/***********************************************************************************************************
*  Apex Class Name     : OpportunityQuoteRequestController
*  Version             : 1.0
*  Function            : This is the controller apex class for the OpportunityQuoteRequest VF page.
*  Modification Log    :
*  Developer                Date            Description
* ----------------------------------------------------------------------------
*  Mei Chen                 06/23/2017      Initial version
*  Zachary Campbell         11/17/2017      SFDC-6953 Remove auto-population of the Sales Executive 1 & 2 fields.
*  Zachary Campbell         12/15/2017      SFDC-7677 Makes changes from SFDC-6953 conditional for only New Sale.
*  Mei Chen                 01/09/2017      SFDC-2102 Prepoulate Opportunity Team Member as Quote Request Sharing member
***********************************************************************************************************/

public class OpportunityQuoteRequestController {
    
    public OpportunityQuoteRequestHelper helper {get;set;}
    public OppQuoteRequestDAO quoteDAO=new OppQuoteRequestDAO();
    public list<OppQuoteRequestDAO> markToDeleteOppProdList{get;set;}
    public list<OppQuoteRequestDAO> futureOppProdList{get;set;}
    public list<OppQuoteRequestDAO> waterTestingOppProdList{get;set;}
    public boolean IsNewSale{get;set;}
    public Id oppId {get;set;}
    public Id acctId=null;
    public String oppName=null;
    public transient String prodRecordType{get;set;}
    public String prodNameInput{get;set;}
    public string selectedProdFamily {get;set;}
    public string selectedProdType{get;set;}
    // public string requestDesc{get;set;}
    public string selectedPricingOption{get;set;}
    public string selectedProdCategory{get;set;}
    // public string dentalUnderwriter{get;set;}
    // public boolean isUWQueue{get;set;}
    public string quoteId{get;set;}
    // public boolean showPremType{get;set;}
    public string commentBox{get;set;}
    public Integer rowIndex{get;set;}
    public string quoteRequestId{get;set;}
    public Id currentQuoteId{get;set;}
    public Id existingQuoteId{get;set;}
    public integer size{get;set;}
    public boolean showSummary{get;set;}
    public boolean isError{get;set;}
    public boolean isEffective11{get;set;}
    
    private list<OppQuoteRequestDAO> oppProdlist;
    //private final Account oppAccount;
    private final Opportunity controlOpp;
    private final Quote_Request_Summary__c quoteReqSummary;
    private final String pricebookName='Underwriting Price Book';
    private final static UserDAO userInstance=new UserDAO();
    public set<id> oppProdId=new set<id>();
    private map<Id,Opportunity_Product__c> currentOppProdMap=new Map<Id,Opportunity_Product__c>();
    private boolean isOptionUpdate=false;
    public string hcscState=null;
    // public String propFundingType {get;set;}
    public list<CarrierHistoryWrapper> carrierHistoryList{get;set;}
    public list<Competitor_Relationship__c> carrierHistories{get;set;}
    private integer recordCount=0;
    public integer rowToRemove{get;set;}
    //public boolean showPage{get;set;}
    public boolean notInsuredValue{get;set;}
    private RecordType rt;
    private list<QuoteRequestShareWrapper> sharmbmList=null;//new list<QuoteRequreShareWrapper>();
    
    public list<SelectOption> getProdCategoryOptions(){
        return OpportunityQuoteRequestHelper.getProdCategories();
    }
    
    public list <SelectOption> getProdTypeOptions(){
        return OpportunityQuoteRequestHelper.getProdTypes();
    }
    
    public List<SelectOption> getProdFamilyOptions(){
        return OpportunityQuoteRequestHelper.getProdFamilies();
    }
    
    public List<SelectOption>getFundingTypeOptions(){
        return OpportunityQuoteRequestHelper.getFundingType();
    }
    
    /*private List<SelectOption> BillingOptions(){
        return OpportunityQuoteRequestHelper.getBillings();
    }*/
    
    public OpportunityQuoteRequestController (){}
    
    public OpportunityQuoteRequestController (ApexPages.StandardController con){
        //  controller=con;
        
        SObject conObj= con.getRecord();
        if(conObj instanceof Opportunity){
            this.controlOpp=(Opportunity)con.getRecord();
            oppId=this.controlOpp.id;
            
        } else if(conObj instanceof Quote_Request_Summary__c){
            this.quoteReqSummary=(Quote_Request_Summary__c)con.getRecord();
            
            Id qrId=this.QuoteReqSummary.id;
            list<Quote_Request_Summary__c> reqQ=[select id, name, Opportunity_Id__c, Account_Id__c from Quote_Request_Summary__c where id=:qrId limit 1];
            
            if(reqQ!=null && reqQ.size()>0){
                oppId=Id.valueOf(reqQ[0].Opportunity_Id__c);
            }
            
        }
        list<Quote> existingQuote=[select id,OpportunityId from Quote where opportunityId=:oppId order by createdDate DESC limit 1];
        
        if(existingQuote!=null && !existingQuote.isEmpty()){
            existingQuoteId=existingQuote[0].id;
        }
        
        acctId=getAccountId();
        helper=new OpportunityQuoteRequestHelper();
        helper.oppQuoteRequestlist=new list<OppQuoteRequestDAO>();
        size=0;
        isError=false;
        
        showSummary=false;
    }
    
    //this method is call from QuoteRequestCarrierHistory Page
    public pageReference initialLoadForCarrier(){
        createCarrierData(false);
        return null;
    }
    
    public pageReference initialLoad(){
    	
    	if(! Schema.sObjectType.Quote.isCreateable()){
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.No_Access_to_create_a_quote_request);//'You do not have Access to the Operation You Requested. Please Contact System Administrator.');
            ApexPages.addMessage(myMsg);
            isError=true;
            return null;
    	}
    	
    	If(!HasAccess(oppId)){
    	   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.label.No_Access_to_create_a_quote_request);//'You do not have Access to the Operation You Requested. Please Contact System Administrator.');
            ApexPages.addMessage(myMsg);
            isError=true;
            return null;
    	}
        //this request will come from 'Create New Quote' button on existing Quote Request page 
        quoteRequestId=ApexPages.currentPage().getParameters().get('quoteRequestId'); 
        if(quoteRequestId!=null){
            quoteRequestId=quoteRequestId.trim();
        }
        system.debug('initial load...'+ 'quoteRequestId: -->'+quoteRequestId+'<--');
        
        set<Id> reqIds=new set<Id>();
        IsNewSale=false;
        
        if(quoteRequestId!=null){ // if Quote Request is from the exiting Quot Request Summary 
            //find the products that is related to the quote request summary record from quotelineItem
            
            list<Quote_Request_Summary__c> currQuoteReq=[Select Id, Name,  owner.name,ownerId,CreatedDate,  LastModifiedDate,Underwriter__c,Dental_Underwriter__c,Request_Description__c,Dental_Underwriter_Queue__c,Health_Commissions_PCPM__c, ASL_Fee_Type__c, Access_Fee_Type__c,Administrative_Fee_Type__c,Sales_Type__c, Account_Sales_Executive1__c, Account_Number__c, Account_Executive1__c, Account_Executive2__c, Active_Health_Members__c, Active_Health_Contracts__c, HCSC_Division__c, Account_Sales_Executive2__c, Comment__c, Quote_Name__c, Opportunity_Name__c, Opportunity_Id__c, Account_Id__c, Account_Name_tx__c, Quote_Request_Name__c, Current_Contribution_Type__c, Department_for_Underwriting__c, Request_Effective_Date__c, Underwriting_Due_Date__c, Proposed_Due_Date__c, Bull_s_Eye__c, Medicare_Retirees_Eligible__c, Is_this_a_Duplicate_Quote__c,ASO_Commissions_Annual__c, Is_this_a_Formal_Bid__c, PUG__c,Other_Commisions__c, Release_To_Marketing__c, Received_From_Marketing__c, Waiting_For_Information_Type__c, Prior_HCSC_Coverage__c, Prior_HCSC_Account_Number__c, How_many_current_health_plans__c, How_many_HMO_plans_are_there__c, How_many_non_HMO_health_plans_are_there__c, Subject_to_ERISA__c, ERISA_Plan_Year__c, Premium_Type__c, Stoploss_Attachment_Points_Individual__c, Contract_Term_Individual__c, Contract_Term_Aggregate__c, Stoploss_Attachment_Points_Aggregate__c, Rate_Structure__c, Producer__c, Current_Agent__c, Health_Commissions__c, Consultant__c, General_Agent__c, GA_Override__c, ASO_Commissions_PCPM__c, Performance_Guarantee__c, Network_Discount_Guarantees__c, In_Network_Utilization_Guarantee__c, Claims_Target_Guarantee__c, Trend_Guarantee__c, Other_Service__c, Priority__c, Description__c, Contact_Name__c, Rates_Effective_for_Months__c, Expected_Health_Contracts__c, Expected_Dental_Contracts__c, Commissions_Billed_Separately__c, Are_commissions_included__c, Total_on_Payroll__c, COBRA__c, Retirees__c, Part_Time__c, Waiting_Period__c, Total_Eligible_for_Health__c, Total_Eligible_for_Dental__c, Covered_ElseWhere__c, Total_Eligible__c, Waiving_Not_Covered_ElseWhere__c, Total_Covered__c, Percent_Enrolled__c, Waive_on_Initial_Enrollment__c, Current_Employee_Contribution__c, Life_days__c, STD_days__c, Dental_days__c, Non_HMO_Current_Participation__c, HMO_Current_Participation__c, Life_Current_Participation__c, STD_Current_Participation__c, Dental_Current_Participation__c, DHMO_Current_Participation__c, Current_Dependent_Contribution__c, Proposed_Contribution_Type__c, Proposed_Employee_Contribution__c, Participants_Diagonsed_Risk_Condition_Hi__c, Participants_Disabled__c, Claim_Exceeded_Amt_Future__c, Claim_Exceeded_Amt_Past__c, Health_days__c, Risk_Data_Comment__c,Funding_Type__c, Not_Insured__c, Dental__c, Competitor_3rd_PartyVendor__c, Contract_Start_Date__c, Contract_End_Date__c, AFA__c, Reinsurer__c, Proposed_Dependent_Contribution__c, Opportunity_Owner_tx__c, Underwriter_Name_frm_owner__c, Expected_Health_Members__c, Current_Account_Funding_Type__c, Contact__c, List_contributions_that_vary_by_product__c, Proposed_contribution_same_as_current__c, Propose_Contribution_No_Explain_Box__c, Account_Executive1_Name__c, Account_Executive2_Name__c,Proposed_Rx_Formulary__c,Proposed_Rx_Network__c,Proposed_Rx_Pricing__c FROM Quote_Request_Summary__c where id=:quoteRequestId limit 1];
            
            if(!currQuoteReq.isEmpty()){
                system.debug('quote req::::::'+currQuoteReq);      
                helper.quoteRequest=currQuoteReq[0]; //clone from what previous request has
            }
            system.debug('current quote id:'+currentQuoteId);
            
            //get the list of the lineitem related from the current Quote Request summary
            list<quoteLineItem> reqProdItems=[select id, product2Id,product2.id,product2.name,product2.recordType.name,isMarketCheck__c,product2.ProductCode,product2.HCSC_State__c,product2.Product_Type__c,Marked_For_Delete__c,Future__c,Billing__c,Pricing_Reference_Only__c,Product_Service_Detail__c,Product_Type__c from quotelineitem where Request_For_Product_Marked_For_Future__c=:quoteRequestId OR RequestForProductMarkedMarketCheck__c=:quoteRequestId OR RequestForProductMarkedForDelete__c=:quoteRequestId];
            
            integer ct=helper.oppQuoteRequestlist.size();
            
            map<Id,OppQuoteRequestDAO> currentProdMap=new Map<Id,OppQuoteRequestDAO>();
            
            if(reqProdItems!=null && reqProdItems.size()>0){//pull the current prod info from the line item for new request
                for(quoteLineItem i:reqProdItems){
                    reqIds.add(i.product2Id);// product id currently from the the Quote Request summary
                    
                    OppQuoteRequestDAO req=new OppQuoteRequestDAO();
                    // req.rowIndex=ct;
                    req.productid=i.product2Id;// id in str
                    req.prodName=i.product2.name;
                    req.prodCode=i.product2.ProductCode;
                    req.prodType=i.product_type__c;
                    req.prodrecordType=i.product2.recordType.name;
                    //  req.pricingNote=i.Pricing_Note__c;
                    req.hcscState=i.product2.HCSC_State__c;
                    //req.billingOptions=BillingOptions();//helper.parseForOption(pb.More_Billing_Info__c);
                    //req.selectedBillingOption=i.billing__c;
                    req.billingOption=i.billing__c;
                    req.productDetailOption=i.Product_Service_Detail__c;
                    req.pricingReferenceOption=i.Pricing_Reference_Only__c;
                    
                    if(i.Marked_For_Delete__c==true){
                        req.isCurrent=i.Marked_For_Delete__c;
                    }else {
                        req.isCurrent=true;
                        if(helper.quoteRequest.Sales_Type__c!=null && helper.quoteRequest.Sales_Type__c.equalsIgnoreCase('New Sale')){
                            req.isCurrent=false; //there is no current for New Sale)
                        }
                    }
                    req.isFuture=i.Future__c;
                    req.isMarketCheck=i.isMarketCheck__c;//;
                    currentProdMap.put(i.Product2Id, req);
                    
                }
            }   
            updateQuoteRequestProdList(reqIds,false,false,currentProdMap);   //add to list for display     
        }     
        
        if(helper.quoteRequest==null){
            helper.quoteRequest=new Quote_Request_Summary__c();
        }
        helper.quoteRequest.Contact__c=UserInfo.getUserId();
        
        //Prepopulate the current opp prod related to the opp
        Opportunity oppo=[select id,Requested_Effective_Date__c, name, recordtypeId,Expected_Health_Contracts__c,Expected_Dental_Contracts__c,Expected_Health_Members__c, recordtype.name,HCSC_Division__c, accountId from Opportunity where id=: oppId];
        
        if(helper==null){
            helper=new OpportunityQuoteRequestHelper();
        }
        
        if(oppo!=null){
        	
            helper.opp=oppo;
            //  if(helper.quoteRequest==null){
            //    helper.quoteRequest=new Quote_Request_Summary__c();
            //}
              
           Date novDate=Date.newInstance(2018,11,01);
              
                if(oppo.Requested_Effective_Date__c>=novDate){
                	isEffective11=true;
                }else{
                	isEffective11=false;
                }
                
         
                helper.oppRecordTypeName=oppo.recordtype.name;
                if(oppo.recordtype.name.equalsIgnoreCase('New Sale')){
                    IsNewSale=true;
                }
                //hcscState=oppo.HCSC_Division__c;
               oppName=oppo.name;
               helper.quoteRequest.Expected_Health_Contracts__c=oppo.Expected_Health_Contracts__c;
               helper.quoteRequest.Expected_Dental_Contracts__c=oppo.Expected_Dental_Contracts__c;
               helper.quoteRequest.Expected_Health_Members__c=oppo.Expected_Health_Members__c;
               helper.quoteRequest.Request_Effective_Date__c=oppo.Requested_Effective_Date__c;
       
            
            helper.oppAcct=[select id,Name, AccountNumber,owner.name,Underwriter_Name__c, Premium_Type__c,External_ID__c, HCSC_Division__c, Active_Dental_Subscribers__c,Active_Health_Members__c, Active_Health_Subscribers__c, Account_Cluster_Name__c, Account_Executive_2__c,Underwriter__c,Funding_Type__c,Effective_Date__c from Account where id=:oppo.accountId];
            if(helper.oppAcct!=null){
                // helper.quoteRequest.Funding_Type_multi__c=helper.oppAcct.Funding_type__c;
               // helper.quoteRequest.Proposed_Funding_Type_multi__c=helper.oppAcct.Funding_type__c;
                helper.quoteRequest.Funding_Type__c=helper.oppAcct.Funding_type__c;
                helper.quoteRequest.Opportunity_Owner_tx__c=helper.oppAcct.Owner.name;
                hcscState=helper.oppAcct.HCSC_Division__c;
                helper.quoteRequest.HCSC_Division__c=helper.oppAcct.HCSC_Division__c;
             
                
                system.debug(' quoteRequestId........'+quoteRequestId);
                
                //set the Underwriter showing on UI
                if(quoteRequestId!=null){//if request from Create New Request
                   system.debug('Underwriter:::'+helper.quoteRequest.Underwriter__c);
                        
                   helper.quoteRequest.ownerId=helper.quoteRequest.Underwriter__c; //the existing UW
                }else{
              
                  if(helper.oppAcct.Underwriter_Name__c!=null && helper.oppAcct.Underwriter_Name__c!=''){
                    User uw=userInstance.getUserByName(helper.oppAcct.Underwriter_Name__c);
                   
                    if(quoteRequestId==null && uw!=null){
                        //   helper.quoteRequest.underwriter_user__c=uw.id;//if underwriter is available from Account, prepoulated
                        helper.quoteRequest.ownerId=uw.id;// Underwriter will be prepoulated from account[use ownerId feature temporarly to show on UI]
                        
                    }
                   
                  }
                }
                /*** start SFDC-6953 ***/
                /*** start SFDC-7677 ***/
                if(!IsNewSale){                
                    if(helper.oppAcct.Account_Executive_2__c!=null && helper.oppAcct.Account_Executive_2__c!=''){
                        User ae2=userInstance.getUserByName(helper.oppAcct.Account_Executive_2__c);
                        if(ae2!=null){
                            helper.quoteRequest.Account_Sales_Executive2__c=ae2.id;
                        }
                    }
                    
                    if(helper.oppAcct.Account_Cluster_Name__c!=null && helper.oppAcct.Account_Cluster_Name__c!=''){
                        User ae1=userInstance.getUserByName(helper.oppAcct.Account_Cluster_Name__c);
                        if(ae1!=null){
                            helper.quoteRequest.Account_Sales_Executive1__c=ae1.id;
                        }
                    }
                }
                /*** end SFDC-7677 ***/
                /*** end SFDC-6953 ***/
            }
        }
        //check if there is any current opp product existing
        list<Opportunity_Product__c>  currentOpp=[select Opportunity_Name__c,Status__c, Product__r.recordType.name,recordtype.name,Product__c, Product__r.ProductCode, product__r.Product_Type__c, Product__r.name, product__r.id, Product_Family__c from Opportunity_Product__c where Opportunity_Name__c=:oppId and Status__c!='Declined' and Status__c!='Lost'];
        
        oppProdlist=new list<OppQuoteRequestDAO>();
        
        boolean isDentalProd=false;
        if(!currentOpp.isEmpty()){
            
            for(Opportunity_Product__c opp:currentOpp ){
                system.debug(' opp Product__c: '+opp.Product__c+' opp Product__r.id: '+ opp.product__r.id);
                if(opp.Product__c!=null){
                    oppProdId.add(opp.Product__c);
                    currentOppProdMap.put(opp.Product__c,opp);
                } 
                if(opp.product__r.Product_Type__c!=null && (opp.product__r.Product_Type__c.equalsIgnoreCase('Dental'))){
                    isDentalProd=true;
                }
            }
            
            if(isDentalProd && helper.quoteRequest!=null && helper.quoteRequest.Department_for_Underwriting__c!=null 
               && helper.quoteRequest.Department_for_Underwriting__c.containsIgnoreCase('Large Group') ){
                   helper.quoteRequest.Dental_Underwriter_Queue__c=label.Dental_Underwriting_Queue_Name;//'Dental Underwriting';
               }
            //check if the Opp Prod in Price book, if not insert them to price book
            if(!oppProdId.isEmpty()){
                system.debug('current opp prod::: '+oppProdId.size());
                FindandInsertProdtoPBE(oppProdId);
                boolean isCurrent=true;
                boolean isFuture=true;
                if(helper.oppRecordTypeName.equalsIgnoreCase('New Sale')){
                    isCurrent=false; //there is no current for New Sale
                    isFuture=true;
                    // isFuture=true;
                }
                updateQuoteRequestProdList(oppProdId, isCurrent, isFuture, null);
                system.debug('helper.oppQuoteRequestlist: '+helper.oppQuoteRequestlist);
            }
            
            createCarrierData(true);//create carrier and from related account
        }     
        return null;    
    }
    
    @TestVisible private boolean hasAccess(id oppId){
    	UserRecordAccess userAccess=[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =:oppId limit 1];
    	if(userAccess!=null && userAccess.HasEditAccess){
    		return true;
    	}else{
    		return false;
    	}
    }
    
    /***********************************************************************************************
    *  this methond is to seach the product base on the input criteria provided from search UI
    ***********************************************************************************************/
    @TestVisible private RecordType getCarrierRecordType(){
        RecordType  crt = [select Id from RecordType where DeveloperName = 'Carrier' and SobjectType='Competitor_Relationship__c' limit 1][0];
        return crt;
        
    }
    @TestVisible  private void CreateCarrierData(boolean isAddCarrier){//prepopulate the existing carrier history 
        
        try{
            recordCount = 0;
            carrierHistoryList = new list<CarrierHistoryWrapper>();
            rt = [select Id from RecordType where DeveloperName = 'Carrier' and SobjectType='Competitor_Relationship__c' limit 1][0];
            if(acctId!=null){
                for(Competitor_Relationship__c cr : [select AFA__c,Dental__c,Group_Account__c,Competitor_Account__r.name, Rate_Effective_Date__c,Contract_End_Date__c,Not_Insured__c,Competitor_Account__c,Reinsurer__c from 
                                                     Competitor_Relationship__c where Group_Account__c = :acctId and RecordTypeId =:rt.Id]){
                                                         carrierHistoryList.add(new CarrierHistoryWrapper(cr,true,recordCount));
                                                         ++recordCount;                              
                                                     }
            }
            
            if(isAddCarrier && carrierHistoryList.isEmpty()){//creat empty one to add
                carrierHistoryList.add(new CarrierHistoryWrapper(new Competitor_Relationship__c(RecordTypeId = rt.Id,Group_Account__c =acctId,status__c='Active'),false,recordCount));
                ++recordCount;
            }
        }catch(Exception e){
            system.debug('excpetion: '+e);
        }
    }
    
    /***********************************************************************************************
    * this method is to save Carrier information invoked by the button 'Save/Send Notfiication'.
    ***********************************************************************************************/
    @TestVisible  private void SaveCarrierRecords(){
        try{
            carrierHistories = new list<Competitor_Relationship__c>();
            
            if(carrierHistoryList!=null && carrierHistoryList.size()>0){
                for(CarrierHistoryWrapper chw : carrierHistoryList){
                    carrierHistories.add(chw.carrierHistory);
                }
                upsert carrierHistories;
            }
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Insert Carrier error! Please contact System Administrator.');
            ApexPages.addMessage(myMsg);
            
            system.debug('save carrier exception: '+e);
        }
    }
    
    /***********************************************************************************************
    * for carrier update from UI,  trigger to hit server.
    ***********************************************************************************************/
    public void  DummyMethod(){
        try{
            for(CarrierHistoryWrapper chw : carrierHistoryList){
                if(chw.recordNumber == rowToRemove){
                    chw.carrierHistory.Not_Insured__c = notInsuredValue;
                }
                
            }
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void AddRow(){
        if(carrierHistoryList==null){
            carrierHistoryList = new list<CarrierHistoryWrapper>();
        }
        if(rt==null){
            rt=getCarrierRecordType();
        }
        carrierHistoryList.add(new CarrierHistoryWrapper(new Competitor_Relationship__c(RecordTypeId = rt.Id,Group_Account__c = acctId,status__c='Active'),false,recordCount));
        ++recordCount;
    }
    
    public void RemoveRow(){
        try{
            list<CarrierHistoryWrapper> tempList = new list<CarrierHistoryWrapper>();
            Competitor_Relationship__c deleteRecord;
            for(CarrierHistoryWrapper chw : carrierHistoryList){
                if(chw.recordNumber != rowToRemove){
                    tempList.add(chw);
                }
                else if(chw.carrierHistory.Id != null)
                    deleteRecord = chw.carrierHistory;
            }
            carrierHistoryList = new list<CarrierHistoryWrapper>();
            carrierHistoryList.addAll(tempList);
            if(deleteRecord != null)
                delete deleteRecord;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    /***********************************************************************************************
    * this method is invoked by the button 'Find Product'from UI. It search the Product from the Product table and price book entry.
    * Input: Product name is mandary with at least three characters except 'Rx'. Input State is default to HCSC state from Account. 
    ***********************************************************************************************/
    public PageReference findProducts(){
        showSummary=false;
        //  isSearch=true;
        system.debug('getAllheroproduc====>');
        
        removeUnwantedProductFromList();//only keep the those selected product if search perform again
        
        set<Id> existingProd=new set<Id>();
        
        if(helper!=null && helper.oppQuoteRequestlist!=null && !helper.oppQuoteRequestlist.isEmpty()){
            for(OppQuoteRequestDAO prod: helper.oppQuoteRequestlist){
                existingProd.add(prod.productId);  // if product is already exiting in the display list, no need to search
            }
        }
        system.debug('existing Prod::::;'+existingProd);
        
        list<Product2> prodList=new list<Product2>();
        String findProdQuery='select name, id, family, productCode,Product_Type__c, HCSC_State__c, recordType.name from Product2 where id NOT IN:existingProd AND isActive=TRUE ';
        
        if(prodNameInput==null || prodNameInput=='' || (!prodNameInput.equalsIgnoreCase('Rx') && prodNameInput.length()<3)){
            
            ApexPages.Message error=new ApexPages.Message(ApexPages.Severity.ERROR, system.label.Require_3_characters_to_search_product);//'Please check at lease one product for Future or Current to get Summary!');
            ApexPages.addMessage(error);
            return null;
            
        }else{
            findProdQuery=findProdQuery+' AND name like \'%'+prodNameInput+'%\'';
        }
        
        if(selectedProdFamily!=null && selectedProdFamily!=''){
            findProdQuery=findProdQuery+' AND family=\''+selectedProdFamily+'\'';
        }
        
        if(selectedProdType!=null && selectedProdType!=''){
            findProdQuery=findProdQuery+' AND Product_Type__c=\''+selectedProdType+'\'';
        }
        
        system.debug('hcsc division::::::::'+hcscState);
        if(hcscState!=null && hcscState!=''){
            findProdQuery=findProdQuery+' AND HCSC_State__c=\''+hcscState+'\'';
        }else if(helper.quoteRequest.HCSC_Division__c!=null && helper.quoteRequest.HCSC_Division__c!=''){
            hcscState=helper.quoteRequest.HCSC_Division__c;
            findProdQuery=findProdQuery+' AND HCSC_State__c=\''+hcscState+'\'';
        }else{
            ApexPages.Message error=new ApexPages.Message(ApexPages.Severity.ERROR, system.label.Validation_Error_HCSC_Division_is_missing_from_Account);//'Validation Error, HCSC Division is missing from Account.' );//'Please check at lease one product for Future or Current to get Summary!');
            ApexPages.addMessage(error);
            return null;
        }
        
        if(selectedProdCategory!=null && selectedProdCategory!=''){
            findProdQuery=findProdQuery+' AND  recordType.name=\''+selectedProdCategory+'\'';
        }
        //   findProdQuery=findProdQuery+' limit 500';
        
        system.debug('findprodQuery:;;;;'+findProdQuery);
        prodList=Database.query(findProdQuery);
        
        // system.debug('prodList::::: '+prodList.size());
        
        if(prodList!=null && prodList.size()>100){
            ApexPages.Message error=new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Search_return_too_large_data);// 'Search result is too big, please add criteria to narrow the search.' );//'Please check at lease one product for Future or Current to get Summary!');
            ApexPages.addMessage(error);
            return null;
            
        }else if(prodList==null || prodList.size()==0){
            String message=system.label.Search_returns_no_result_base_on_your_criteria+': '+ 'Account HCSC Division="'+hcscState+'" and Product Name includes "'+ProdNameInput+'"';
            ApexPages.Message error=new ApexPages.Message(ApexPages.Severity.ERROR, message );//'Please check at lease one product for Future or Current to get Summary!');
            ApexPages.addMessage(error);
            return null;
        }
        set<Id> prodId=new set<Id>();
        
        if(!prodList.isEmpty()){
            
            for(Product2 p:prodList){
                system.debug('new prod from search: '+p.name);
                prodId.add(p.id); 
            }
            FindandInsertProdtoPBE(prodId);//add the product price book as can search from UI
            updateQuoteRequestProdList(prodId, false,false, null); //from FindProduct
            size=helper.oppQuoteRequestlist.size();
            
        }
        prodList.clear();//clear the prod list before new search
        return null;
    }
    
    @TestVisible private void removeUnwantedProductFromList(){
        
        if(helper!=null && helper.oppQuoteRequestlist!=null && !helper.oppQuoteRequestlist.isEmpty()){
            
            system.debug('size before removed: '+helper.oppQuoteRequestlist.size());
            for(integer i=helper.oppQuoteRequestlist.size()-1;i>=0;i--){
                OppQuoteRequestDAO prod=helper.oppQuoteRequestlist[i];
                if(!prod.isFuture && !prod.isMarketCheck && !prod.isCurrent){
                    helper.oppQuoteRequestlist.remove(i);    
                    system.debug('remove prod : '+prod.prodName);
                }
            }
            system.debug('size after removed: '+helper.oppQuoteRequestlist.size());
        }
    }
    
    @TestVisible private void FindandInsertProdtoPBE(set<id> prodId){
        set<id> newPBEProd=new set<id>();
        
        list<PriceBookEntry> pbelist=new list<PriceBookEntry>();
        list<PriceBookEntry> stdPbeList=new list<PriceBookEntry>();
        
        pbeList=[select name, id, product2Id  from PricebookEntry where product2Id in:prodId and priceBook2.IsStandard=false and priceBook2.name=:pricebookName];//'Underwriting Price Book'];
        stdPbeList=[select name, id, product2Id  from PricebookEntry where product2Id in:prodId and priceBook2.IsStandard=true];//'Underwriting Price Book'];
        
        set<id> newProdId =prodId.clone();
        set<id> newStdProdId=prodId.clone();
        set<id> tempId=new set<id>();
        set<id> tempStdId=new set<id>();
        
        if(!stdPbeList.isEmpty()){
            for(PriceBookEntry sp:stdPbeList){
                tempStdId.add(sp.product2Id);
            }
            newStdProdId.removeAll(tempStdId);//prod need to insert to standard price book
        }
        
        if(!pbeList.isEmpty()){
            for(PriceBookEntry p:pbeList){
                //if prod id in pbe
                tempId.add(p.product2Id);
            }  
            newProdId.removeAll(tempId);//only keep the one not existing in PBE   
            system.debug(' after removed prod id set: '+newProdId);
        }
        
        if(newProdId.size()>0){
            if(InsertNewProdtoStandardPB(newStdProdId)){
                InsertNewProdtoPBE(newProdId);
            }
        }
    }
    
    /***********************************************************************************************
    * This method is to check if to check if the new opp produ have been added to standard price book, if not add them to standard price book
    ***********************************************************************************************/
    @TestVisible private boolean InsertNewProdtoStandardPB(set <id> prodIds){
        
        boolean result=true;
        set<Id> newIds=prodIds.clone();
        
        if(newIds !=null && !newIds.isEmpty()){ //found there is prod not existing in standard price book
            
            list<PriceBookEntry> stdpbe =new list<PriceBookEntry>();
            
            Id stdPb2Id=getStandardPriceBooKId();
            
            for(Id  p2Id: newIds){
                PriceBookEntry se=new PriceBookEntry();
                se.product2Id=p2Id;
                se.IsActive=true;
                se.priceBook2Id=stdPb2Id;
                se.UnitPrice=1.0;
                stdpbe.add(se);
            }
            
            try{
                if(!stdpbe.isEmpty()){ 
                    insert stdpbe;// insert product to standard price book
                }
                
            }catch (Exception dmlex){
                system.debug(' insert standard price book: '+dmlex);
                result=false;
            }
        }
        return result;
    }
    
    /***********************************************************************************************
    * This method is to insert product into pricebook entry
    ***********************************************************************************************/
    @TestVisible private void InsertNewProdtoPBE(set<Id> newprodId){
        
        Id pb2Id=getUWPriceBookId();
        
        try{
            
            list<PriceBookEntry> newpbe=new list<PriceBookEntry>();
            list<PriceBookEntry>stdpbe=new list<PriceBookEntry>();
            
            for(Id p2Id: newprodId){
                PriceBookEntry pbe=new PriceBookEntry();
                pbe.product2Id=p2Id;
                pbe.IsActive=true;
                pbe.priceBook2Id=pb2Id;
                pbe.UnitPrice=1.0;
                pbe.UseStandardPrice=false;
                newpbe.add(pbe);
            }
            
            //   boolean isSuccess=true;
            
            system.debug(' insert new prod to price book: '+newpbe);
            if(!newpbe.isEmpty()){
                //database.insert(newpbe, false);
                insert newpbe;
            }
        }catch(exception e){
            system.debug(' insert price book exception: '+e);
        }
    }
    
    private Id getStandardPriceBookId(){
        list<Pricebook2> standardPB = [select id from Pricebook2 where isStandard=true limit 1];
        
        if(standardPB!=null && standardPB.size()>0){
            return standardPB[0].id;
        }else{
            return null;
        }
    }
    
    private Id getUWPriceBookId(){
        list<PriceBook2> pb=[select id,name from Pricebook2 where name=:priceBookName and IsStandard=false limit 1];
        if(pb!=null && pb.size()>0){
            return pb[0].id;
        }else return null;
    }
    
    //get the update list
    @TestVisible private void updateQuoteRequestProdList(Set<Id> ProdId, boolean isCurrent, boolean isFuture, Map<Id, OppQuoteRequestDAO> updateReqProd){
        
        //check if the new  coming Product already in the list
        set<Id> existingProdId =new set<Id>();
        
        if(helper!=null && helper.oppQuoteRequestlist!=null && !helper.oppQuoteRequestlist.isEmpty()){
            
            for(OppQuoteRequestDAO d: helper.oppQuoteRequestlist){
                //existingProdId.add(d.productId);
                if(ProdId.contains(d.productId)){
                    ProdId.remove(d.productId);
                }
            }
        }
        
        if(helper==null){
            helper=new OpportunityQuoteRequestHelper();
        }
        
        if(helper.oppQuoteRequestlist==null){
            helper.oppQuoteRequestlist=new list<OppQuoteRequestDAO>();
        }
        
        list<PriceBookEntry> pbeList=new list<PriceBookEntry>();
        pbeList=[select name, id, product2Id,product2.name,product2.family,product2.product_type__c,product2.productCode,HCSC_State__c,Pricing_reference_only__c,Product_Service_Detail__c,New_Billing__c, product2.recordType.name, Network__c, priceBook2.IsStandard from PricebookEntry where product2Id in:ProdId and priceBook2.IsStandard=false and priceBook2.name=:pricebookName];//'Underwriting Price Book'];
        
        system.debug('pbe list;:::'+pbelist);
        
        if(pbeList!=null && !pbeList.isEmpty()){
            
            integer ct=0;
            
            if(helper!=null && helper.oppQuoteRequestlist!=null){
                ct=helper.oppQuoteRequestlist.size();
            }
            
            for(PriceBookEntry pb: pbeList){
                // PriceMatrixWrapper pm=new PriceMatrixWrapper();
                OppQuoteRequestDAO pm=null;
                
                if(updateReqProd!=null){
                    pm=updateReqProd.get(pb.product2Id); // get the information from the previous request if request is from Quote Request Summary
                }
                if(pm==null){//these information will be pulled from the pricebook too if this is new Quote Request
                    pm=new OppQuoteRequestDAO();
                    pm.productid=pb.product2Id;
                    pm.prodName=pb.product2.name;
                    pm.prodCode=pb.product2.productCode;
                    pm.prodType=pb.product2.product_type__c;
                    // pm.pricingnote='Not Available';//initially//helper.getPriceNote(pm);
                    pm.pricingReferenceOption='Not Available';
                    pm.isCurrent=isCurrent;//initially
                    pm.isFuture=isFuture; //initially
                    if(isCurrent){
                        pm.isFuture=true;//automaticall set IsFuture to be true when Is Current is true initially
                    }
                }
                // get these information from price book entry
                pm.rowIndex=ct;
                pm.prodrecordType=pb.product2.recordType.name;
                // pm.pricing1Note=pb.pricing1_Note__c;
                //pm.pricing2Note=pb.pricing2_Note__c;
                // pm.pricing3Note=pb.pricing3_Note__c;
                system.debug('product name:'+pm.prodName+'   pm.productDetailOptions'+pb.Product_Service_Detail__c);
                pm.productDetailOptions=helper.parseStrTxtIntoOptions(pb.Product_Service_Detail__c);//get list of options
                pm.pricingReferenceOptions=helper.parseStrTxtIntoOptions(pb.Pricing_reference_only__c);//get list of options
                //if there is only one true value like '-None-', 'option1', default to display option1
                system.debug('pm.productDetailOptions:::'+pm.productDetailOptions.size()+' options: '+pm.productDetailOptions);
                system.debug('pm.pricingReferenceOptions::'+pm.pricingReferenceOptions.size()+' options: '+pm.pricingReferenceOptions);
                
                if(pm.productDetailOptions!=null && pm.productDetailOptions.size()==1){
                	system.debug('pm.productDetailOptions[0].getLabel() ::::'+pm.productDetailOptions[0].getLabel());
                    pm.productDetailOption=pm.productDetailOptions[0].getLabel();
                    //if there is only one from Product Detail option, there should non or only option from teh pricing reference option. display the only one pricing reference option if there is one
                    if(pm.pricingReferenceOptions!=null && pm.pricingReferenceOptions.size()==1){
                        pm.pricingReferenceOption=pm.pricingReferenceOptions[0].getLabel();//initial
                    }else if(pm.pricingReferenceOptions!=null && pm.pricingReferenceOptions.size()>1){
                    	 pm.pricingReferenceOption=pm.pricingReferenceOptions[1].getLabel();//initial
                    }
                }/*else if(pm.productDetailOptions!=null && pm.productDetailOptions.size()==2){
                    pm.productDetailOption=pm.productDetailOptions[1].getLabel();
                    //if there is only one from Product Detail option, there should non or only option from teh pricing reference option. display the only one pricing reference option if there is one
                    if(pm.pricingReferenceOptions!=null && pm.pricingReferenceOptions.size()>1){
                        pm.pricingReferenceOption=pm.pricingReferenceOptions[1].getLabel();//initial
                    }
                }*/
                pm.hcscState=pb.HCSC_State__c;
                pm.billingOptions=helper.parseStrTxtIntoOptions(pb.New_Billing__c);//helper.parseStrTxtIntoOptions(pb.New_Billing__c);//BillingOptions();//helper.parseForOption(pb.More_Billing_Info__c);
                // pm.pricingOptions=helper.parseForOption(pb.Pricing_Option__c);
                pm.priceBookEntryId=pb.id;//need for create line item
                pm.priceBookId=pb.priceBook2Id;
                helper.oppQuoteRequestlist.add(pm);
                ct++;
            }
        }
    }
    
    /*public PageReference updateRequestDesc(){
        String requestDescParam=ApexPages.currentPage().getParameters().get('requestDesc');

        system.debug(' requestDesc param from assignment:'+requestDescParam);

        if(requestDesc==null && requestDescParam !=null){
            requestDesc=requestDescParam;
        }
        return null;
    }*/
    
    public PageReference updateListwithPricingNote(){
        showSummary=false;
        //  system.debug('quote list items: '+helper.oppQuoteRequestlist);
        String index=ApexPages.currentPage().getParameters().get('index');
        Integer i=0;
        if(index!=null){
            i=Integer.valueOf(index);
        }
        //  system.debug('record['+i+']:::'+helper.oppQuoteRequestlist[i]); 
        updatePricingReference(index);
        isOptionUpdate=true;
        return null;
    }
    
    public void updatePricingReference(String index){
        Integer size1=helper.oppQuoteRequestlist.size();
        Integer myindex=rowIndex;
        
        if(index!=null && index!=''){
            myIndex=Integer.valueOf(index);
        }
        
        system.debug('row index::::'+myIndex);  
        
        if(size1>myIndex){
            OppQuoteRequestDAO  thisRow=helper.oppQuoteRequestlist[myIndex];
            //   thisRow.pricing=thisRow.selectedPrice;//selectedPricingOption;//thisRow.selectedPrice;//thisRow.selectedPrice;//issueL: selectedprice is always null. dosn't captured the one from selection
            // thisRow.pricingNote=helper.getPriceNote(thisRow);
            thisRow.PricingReferenceOption=helper.getPricingReference(thisRow);
            helper.oppQuoteRequestlist[myIndex]=thisRow;        
            system.debug('ok::::+'+helper.oppQuoteRequestlist[myIndex]);
        }
        system.debug('updated pricing Reference..');
    }
    
    /*public void updatePricingNote(String index){
        Integer size1=helper.oppQuoteRequestlist.size();
        Integer myindex=rowIndex;

        if(index!=null && index!=''){
            myIndex=Integer.valueOf(index);
        }

        system.debug('row index::::'+myIndex);  

        if(size1>myIndex){
            OppQuoteRequestDAO  thisRow=helper.oppQuoteRequestlist[myIndex];
            thisRow.pricing=thisRow.selectedPrice;//selectedPricingOption;//thisRow.selectedPrice;//thisRow.selectedPrice;//issueL: selectedprice is always null. dosn't captured the one from selection
            thisRow.pricingNote=helper.getPriceNote(thisRow);
            helper.oppQuoteRequestlist[myIndex]=thisRow;        
            system.debug('ok::::+'+helper.oppQuoteRequestlist[myIndex]);
        }

        system.debug('updated pricing note...');
        }*/
    
    /***********************************************************************************************
    * Method invoked by button 'Next/Get Summary'
    ***********************************************************************************************/
    public PageReference getSummary(){
        String errorMsg=validateForSelection();
        if(errorMsg==null){
            showSummary=true;
            
        }else{
            ApexPages.Message error=new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg );//'Please check at lease one product for Future or Current to get Summary!');
            ApexPages.addMessage(error);
        }
        return null;
    }
    
    @TestVisible private String validateForSelection(){
        String result=null;
        boolean isChecked=false;
        boolean isLGR=false;
        boolean isDental=false;
        
        futureOppProdList=new list<OppQuoteRequestDAO>();
        markToDeleteOppProdList=new list<OppQuoteRequestDAO>();
        waterTestingOppProdList=new list<OppQuoteRequestDAO>();
        if(helper==null){
            helper=new OpportunityQuoteRequestHelper();
        }
        
        /*if(requestDesc!=null && requestDesc.length()<16){
            result='Please provide Request Descriptoin 16 to 60 characters.';
            return result;
        }*/
        
        system.debug('quote request field:::'+helper.quoteRequest.Request_Description__c);
        
        if(helper.quoteRequest!=null){
            if (helper.quoteRequest.Request_Description__c!=null){
                ///helper.quoteRequest.Request_Description__c=requestDesc;
                if(helper.quoteRequest.Request_Description__c.length()<16){
                    result='Please provide Request Description 16 to 53 characters.';
                    return result;
                }
                
                if(helper.quoteRequest.Department_for_Underwriting__c!=null && helper.quoteRequest.Department_for_Underwriting__c.containsIgnoreCase('Large Group')){
                    isLGR=true;
                }
            }
        }
        
        if(helper.oppQuoteRequestlist.size()>0){
            //  String newPricing='No Pricing Info';
            
            for(OppQuoteRequestDAO reqData:helper.oppQuoteRequestlist ){
                system.debug('reqData:'+reqData.isFuture);
                
                if((reqData.isFuture || reqData.isMarketCheck ) && reqData.prodType!=null && reqData.prodType.equalsIgnoreCase('Dental')){
                    isDental=true;
                }
                
                if(reqData.isFuture || reqData.isMarketCheck){
                    //   system.debug('add future with pricing: '+reqData.pricing);
                    system.debug('reqData isFuture:::'+reqData.isFuture+ ' market: '+reqData.isMarketCheck);
                    if((reqData.productDetailOptions!=null && reqData.productDetailOptions.size()>1) && (reqData.productDetailOption==null || reqData.productDetailOption.equals('0') || reqData.productDetailOption.equals('') ||reqData.productDetailOption.equalsIgnoreCase('None'))){
                        //  system.debug('reqData.Pricing;;;;;'+reqData.pricing);
                        system.debug('reqData.Product /Service Detail:'+reqData.ProductDetailOption);
                        result='Please select Product/Service Detail Option for (future)Product  "'+reqData.prodName+'".';
                        return result;
                    }
                    if((reqData.billingOptions!=null && reqData.billingOptions.size()>1) && (reqData.billingOption==null || reqData.billingOption.equals('0') || reqData.billingOption.equals('') ||reqData.billingOption.equalsIgnoreCase('None'))){
                        //  system.debug('reqData.Pricing;;;;;'+reqData.pricing);
                        system.debug('reqData.billingOption:'+reqData.billingOption);
                        result='Please select Billing Option for (future)Product  "'+reqData.prodName+'".';
                        return result;
                    }
                    
                    system.debug('productDetailOption=>'+reqData.productDetailOption+'<----');
                    system.debug('Product Details Options:::::'+reqData.productDetailOptions);
                    reqData.productDetailOption=getPricingValue(reqData.productDetailOption,reqData.productDetailOptions);//getPricingValue(reqData.pricing,reqData.pricingOptions);
                    reqData.billingOption=getPricingValue(reqData.billingOption,reqData.billingOptions);
                    //  reqData.pricing=newPricing;
                    // reqData.productDetailOption=newPricing;
                    system.debug('productDetailOption:: '+reqData.productDetailOption);
                    if(reqData.isFuture){
                        futureOppProdList.add(reqData);
                    } else if (reqData.isMarketCheck) {
                        waterTestingOppProdList.add(reqData);//marketcheck
                    }
                    isChecked=true;//check if there is at lease one checked.
                }
                
                if(reqData.isCurrent && !reqData.isFuture && !reqData.isMarketCheck){//else is current but not checked for future, add to MarktoDelete
                    //  reqData.pricing=null;
                    //  reqData.pricingNote=null;
                    //  reqData.selectedBillingOption=null;
                    reqData.pricingReferenceOption=null;
                    reqData.productDetailOption=null;
                    reqData.billingOption=null;
                    markToDeleteOppProdList.add(reqData);
                    isChecked=true;
                }
                
            }
            if(!isChecked){//if no product is checked, return error
                result=system.label.Please_check_at_lease_one_product_for_Future_or_Market_Check;//'Please check at lease one product for Future or Market Check!';
            }else{//if there is any dental product checked
                if(isDental && isLGR){
                    helper.quoteRequest.Dental_Underwriter_Queue__c=label.Dental_Underwriting_Queue_Name;//Dental Underwriting';
                }else{
                    helper.quoteRequest.Dental_Underwriter_Queue__c=null;
                }
            }
            system.debug('future size:'+futureOppProdList.size()+' delete prod size:'+markToDeleteOppProdList.size());
        }
        return result; 
    }
    
    /***********************************************************************************************
    * this method is get the pricing from the option label when save the req record
    * as the value of options is too long which caused the problem from memery.
    ***********************************************************************************************/
    @TestVisible private String getPricingValue(String preFix, list<SelectOption> options){
        String price='None';
        
        if(options!=null){
            
            system.debug('prefix:::'+prefix);//
            
            if(options.size()==1){
                price=options[0].getlabel();
                
            }else if(options.size()>1){
                
                if(prefix!=null && prefix.length()>0){
                    try{
                        integer num=Integer.valueOf(prefix);//.remove('-'));
                        if(options.size()>num){
                            system.debug('num: '+num+' pricing: '+options[num].getlabel());
                            price=options[num].getlabel();
                        }
                    }catch (Exception e){
                        system.debug('Exception: '+e);
                        price='Error!';
                    }
                }
            }
            
        }else{
            return 'No Info';
        }
        return price;
    }
    
    //back button
    public PageReference backFromSummary(){
        showSummary=false;
        return null;
    }
    
   /* public PageReference cancelAndBack(){
    	PageReference pg=new PageReference('/'+oppId);
    	return pg;
    }
    */
    /***********************************************************************************************
    * this method is to 1) add the selected product as Future to Opp Product;
    * 2) Update the Opp product that is not selected as Future to status ='lost' and type ='Product Term'  (SFDC5212)
    ***********************************************************************************************/
    @TestVisible private void SyncOppProduct(){
        
        set <id> addOppProd=new set<id>();
        
        try{
            if(!helper.oppQuoteRequestlist.isEmpty()){
                
                list<Opportunity_Product__c> newOppProdlist=new list<Opportunity_Product__c>();
                list<Opportunity_Product__c> updateOppProdlist=new list<Opportunity_Product__c>();
                
                Opportunity_Product__c newOppProd=new Opportunity_Product__c();
                
                system.debug('oppProdId:::: '+oppProdId);
                
                for(OppQuoteRequestDAO row: helper.oppQuoteRequestlist){
                    newOppProd=new Opportunity_Product__c();
                    
                    //is marked for Future and is not current
                    if( row.prodrecordType!='Service'){
                        system.debug('add new opp prod name::::: '+row.prodName+'prod id: '+row.prodId+ 'row.productid::::'+row.Productid);
                        
                        if(oppProdId!=null && !oppProdId.contains(row.Productid)){// if not existing in current product table
                            
                            newOppProd.Opportunity_Name__c=oppId;
                            newOppProd.Product__c=row.productid;
                            
                            if((row.isFuture || row.isMarketCheck) && !row.isCurrent){
                                
                                if(helper.oppRecordTypeName.contains('Renewal')){//renewal Upsell or renewal
                                    system.debug('adding opp produ: is future?:::'+row.isFuture+' markedcheck?:::'+row.isMarketCheck);
                                    if(row.isFuture){
                                        newOppProd.Product_Type__c='Upsell';
                                        newOppProd.Upsell__c='Yes';
                                        // newOppProd.RecordTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();//helper.getRecordTypeId('Renewal', 'Opportunity_Product__c');
                                    }else if(row.isMarketCheck){
                                        newOppProd.Product_Type__c='Market Check';
                                        system.debug('yay market check');
                                    }
                                    newOppProd.RecordTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();//helper.getRecordTypeId('Renewal', 'Opportunity_Product__c');
                                    
                                }else if(helper.oppRecordTypeName.contains('New Sale')){
                                    if(row.isFuture){
                                        newOppProd.Product_Type__c='New Sale';//helper.oppRecordTypeName;
                                        //newOppProd.RecordTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                                    }else if(row.isMarketCheck){
                                        newOppProd.Product_Type__c='Market Check';
                                    }
                                    newOppProd.RecordTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                                    
                                }else if (row.isFuture && helper.oppRecordTypeName.contains('Off Cycle Change')){
                                    newOppProd.Product_Type__c='Upsell';
                                    newOppProd.RecordTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get('Off Cycle Change').getRecordTypeId();
                                }
                                newOppProdlist.add(newOppProd);
                            }
                            
                        }else{ //if they are exiting //update the opp prod type to Renewal for select Current prod
                            system.debug('isCurrent: '+row.isCurrent+' isFuture: '+row.isFuture+' is MarkedCheck: '+row.isMarketCheck+' product Id:'+row.ProductId);
                            if(row.isFuture && row.isCurrent && helper.oppRecordTypeName.equalsIgnoreCase('Renewal')){
                                Opportunity_Product__c currProd=currentOppProdMap.get(row.Productid);
                                system.debug('update current opp pro to Renewal');
                                currProd.Product_Type__c='Renewal';
                                currProd.RecordTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                                updateOppProdlist.add(currProd);
                            } else if(row.isCurrent && !row.isFuture && !row.isMarketCheck){//those existing product is not marked for future
                                Opportunity_Product__c lostProd=currentOppProdMap.get(row.Productid);
                                system.debug('lost product: '+row.Productid);
                                lostProd.Product_Type__c='Product Term';
                                lostProd.Status__c='Declined';
                                
                                updateOppProdlist.add(lostProd);//hold off from 5212
                            }
                        }
                    }
                }
                
                if(!newOppProdlist.isEmpty()){
                    system.debug('upsert Opp prod: '+newOppProdlist);
                    insert newOppProdlist;
                    
                }
                if(!updateOppProdlist.isEmpty()){
                    system.debug('update opp prod: '+updateOppProdlist);
                    update updateOppProdlist;
                }
            }
        }catch(Exception e){
            system.debug('exception '+e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Something wrong! Please contact System Administrator.');
        } 
    }
    
    /***********************************************************************************************
    * this method is called when button 'Save/Send Notification' is clicked
    ***********************************************************************************************/
    public pageReference SaveQuoteSummary(){
    	
        sharmbmList=new list<QuoteRequestShareWrapper>();//share member list
        
        Id qrId=null;
        try{
            if(existingQuoteId!=null){// if it isn't first quote request from the quote
                system.debug('quote req Id: '+quoteRequestId+ ' current quote id: '+currentQuoteId);
                qrId=createQuoteReqSummary(existingQuoteId);
            }else{
                Id qId=createQuote(futureOppProdList);
                if(qId!=null){//only when quote is creted
                  qrId= createQuoteReqSummary(qId);
                }else{
                	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Quote_can_not_be_created);//'Quote can not be created. Please contact System Administrator.');
                    ApexPages.addMessage(myMsg);
                    isError=true;
                    return null;
                }
            }
            
            list<Opportunity> currOpp=[select id, StageName from Opportunity where id=:oppId limit 1];
            
            if(currOpp!=null &&  !currOpp.isEmpty()){
                if(!currOpp[0].StageName.equalsIgnoreCase(system.label.In_Underwriting)){
                    currOpp[0].StageName=system.label.In_Underwriting;
                    update currOpp[0];
                }
            }
            
            //SFDC 2102 add opp team member to quote request sharing member
      /*     list<OpportunityTeamMember> oppMembers=[ select OpportunityAccessLevel, OpportunityId,TeamMemberRole, userId from OpportunityTeamMember where opportunityId=:OppId];
          
           system.debug('Opp team members:>>>>>> '+oppMembers);
           if(qrId!=null && oppMembers!=null && !oppMembers.isEmpty()){
          //	list<QuoteRequreShareWrapper> sharmbmList=new list<QuoteRequreShareWrapper>();
           	 for(OpportunityTeamMember om:oppMembers){
           	 	QuoteRequestShareWrapper shrWrapper=new QuoteRequestShareWrapper(om.userId,om.OpportunityAccessLevel, qrId, null);
           	    sharmbmList.add(shrWrapper);
           	 }
           	 
           	 if(sharmbmList!=null){
           	 	addQuoteRequestShare(sharmbmList);
           	 }
           }
           */
           
        }catch (Exception e){
            system.debug(' update opp exception: '+e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System Exception! Please contact System Administrator.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        SyncOppProduct();//add the futured selected prod to Opp Product and update the not selected future product(renew) to lost
        SaveCarrierRecords();
        
        return new Pagereference('/'+oppId);
    }
    
    @TestVisible private Id createQuoteReqSummary(Id qId){
        Id reqId=null;
        Id underwriterId=null;
        
        Quote_Request_Summary__c req=new Quote_Request_Summary__c();
        
        if(helper!=null && helper.quoteRequest!=null){
            req=helper.quoteRequest.clone();
        }
        
        //if(req==null){
            //req=new Quote_Request_Summary__c();
        //}
        req.Quote_Name__c=qId;
        req.Status__c='New';
        
        system.debug('req.ownerId::'+req.ownerId);
        
    
        // system.debug('opp recordtype name: ;;;'+helper.oppRecordTypeName);
        if(helper!=null && helper.oppRecordTypeName.contains('New Sale')){
            req.recordTypeId=Schema.SObjectType.Quote_Request_Summary__c.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            //helper.getRecordTypeId('New_Sale', 'Quote_Request_Summary__c');
            system.debug('assigned record typeId new sale: '+req.recordTypeId);
        }else {
            req.recordTypeId=Schema.SObjectType.Quote_Request_Summary__c.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            system.debug('assigned record typeId renewal: '+req.recordTypeId);
            //helper.getRecordTypeId('Renewal', 'Quote_Request_Summary__c');
        }
        
        Datetime todayDate=system.today();
        Datetime newdate=Date.newInstance(todayDate.Year(), todayDate.month(), todayDate.day());
        
        if(helper!=null && helper.oppAcct!=null){
            req.Quote_Request_Name__c=helper.oppRecordTypeName+' '+' '+newDate;
            req.Account_Id__c=string.valueOf(helper.oppAcct.id);
            req.Account_Name_tx__c=helper.oppAcct.name;
            req.Account_Number__c=helper.oppAcct.External_ID__c;
            req.Active_Health_Contracts__c=helper.oppAcct.Active_Health_Subscribers__c;
            req.Active_Health_Members__c=helper.oppAcct.Active_Health_Members__c;
            req.Account_Executive2__c=helper.oppAcct.Account_Executive_2__c;
            req.Account_Executive1__c=helper.oppAcct.Account_Cluster_Name__c;
            req.Current_Account_Funding_Type__c=helper.oppAcct.Funding_Type__c;
            req.HCSC_Division__c=helper.oppAcct.HCSC_Division__c;
            req.Opportunity_Id__c=string.valueOf(oppId);
            req.Opportunity_Name__c=oppName;
            req.Sales_Type__c=helper.oppRecordTypeName;
            req.Comment__c=commentBox;
          
            if(req.Funding_Type__c!=null && req.Funding_Type__c.toUpperCase().contains('PREM')){
            	  system.debug('proposed funding type: '+req.Funding_Type__c);
            	  req.Stoploss_Attachment_Points_Aggregate__c=null;
            	  req.Stoploss_Attachment_Points_Individual__c=null;
            
            }else{
            	req.Premium_Type__c=null;
            }
        }
        
        try{
        	Id uwId=req.ownerId;//stor the temp owner Id
        	
        	 if(String.Valueof(uwId).startsWith('00G')){//queue
                 Group q=[select id, type, name from Group where id=:uwId];
                 
                  if(q!=null){
                  	req.Underwriter_Queue__c=q.name;//get the quene name
                  }
              } else{
                	req.Underwriter__c=uwId;
              }
            system.debug('before insert req:'+req+'temp uw: '+req.owner+' id instr: '+String.valueOf(uwId));
            req.ownerId=UserInfo.getUserId();//reassinge curren user as owner
          
            
            insert req;
            reqId=req.id;
            
            list<Quote_Request_Summary__c> uq=[select id, name,Dental_Underwriter_Queue__c, Underwriter__c,Underwriter__r.id,Underwriter_Queue__c, Request_Description__c from Quote_Request_Summary__c where id=:req.id limit 1];
            system.debug('uq:::'+uq);
            if(uq!=null && !uq.isEmpty()){
                uq[0].Request_Description__c=uq[0].name+'-'+uq[0].Request_Description__c;
                
                if(uq[0].Underwriter_Queue__c!=null && uq[0].Underwriter_Queue__c!=''){
                	Id grpId=getGroupId(uq[0].Underwriter_Queue__c);//underwriting queue name
                	if(grpId!=null){//add underwriting queue to sharing list
                		  sharmbmList.add(new QuoteRequestShareWrapper(grpId, 'Edit', uq[0].id, 'Underwriting'));//add the selected underwriter or queue to share member
                	 }
                
                }
                
                 if(uq[0].Dental_Underwriter_Queue__c!=null && uq[0].Dental_Underwriter_Queue__c!=''){
                	Id grpId=getGroupId(uq[0].Dental_Underwriter_Queue__c);//underwriting queue name
                	if(grpId!=null){//add underwriting queue to sharing list
                		  sharmbmList.add(new QuoteRequestShareWrapper(grpId, 'Edit', uq[0].id, 'Dental'));//add the selected underwriter or queue to share member
                	 }
                
                }
               
                if(uq[0].Underwriter__c!=null){//add underwriter to sharing list
                  sharmbmList.add(new QuoteRequestShareWrapper(uq[0].Underwriter__c, 'Edit',uq[0].id,'Underwriting'));//add the selected underwriter or queue to share member
                }
               system.debug('sharemblist:::::'+sharmbmList);
               
               try{
                update uq[0];
                system.debug('after update::'+uq[0]);
               }catch (system.dmlException o ){
               	system.debug('update quote req'+o);
               }
            }
            
            shareOppTeamToQuoteRequest(reqId);//SFDC 2102 add opp team member to quote request sharing member: give access to the opp team 
            createdProductLineItem(futureOppProdList,qId, reqId, 'future');
            createdProductLineItem(markToDeleteOppProdList, qId, reqId, 'delete');
            createdProductLineItem(waterTestingOppProdList,qId,reqId, 'marketcheck');
            
            //send notification to UW queue
         }catch (Exception e){
            system.debug(' insert Quote Req summary exception: '+e+' line '+e.getLineNumber());
            return null;
         }
        return  reqId;
    }
    
    /***********************************************************************************************
    * This method is used to create Quote Line Item to the Quote Request 
    ***********************************************************************************************/
    @TestVisible  private void createdProductLineItem(list<OppQuoteRequestDAO> quoteList, Id quoteId, Id reqId, String bucketType){
        
        system.debug('quoteList:::::'+quoteList.size()+'   '+quoteList);
        
        if(quoteList!=null && quoteList.size()>0){
            
            list<QuoteLineItem> lineItemList= new list<QuoteLineItem>();
            QuoteLineItem ql=new QuoteLineItem(); 
            
            for(OppQuoteRequestDAO quoteItem: quoteList){
                
                if(quoteItem!=null){
                    system.debug('quote prod name: '+quoteItem.prodName);
                    ql=new QuoteLineItem();             
                    ql.QuoteId=quoteId;
                    // ql.Pricing__c=quoteItem.pricing;
                    ql.Pricing_Reference_Only__c=quoteItem.PricingReferenceOption;
                    ql.Product_Service_Detail__c=quoteItem.ProductDetailOption;
                    // ql.Pricing_Note__c=quoteItem.pricingNote;
                    ql.Billing__c=quoteItem.BillingOption;//selectedBillingOption;
                    ql.Product_type__c=quoteItem.prodType;
                    ql.Product2Id=quoteItem.productid;
                    ql.Quantity=1;//required
                    ql.UnitPrice=1.0;//required
                    
                    if(bucketType.equals('delete')){
                        ql.RequestForProductMarkedForDelete__c=reqId;
                        ql.Request_For_Product_Marked_For_Future__c=null;
                        ql.RequestForProductMarkedMarketCheck__c=null;
                        ql.Marked_For_Delete__c=true;
                        ql.Future__c=false;
                        ql.isMarketCheck__c=false;
                    }else if(bucketType.equals('marketcheck')){
                        ql.RequestForProductMarkedForDelete__c=null;
                        ql.RequestForProductMarkedMarketCheck__c=reqId;
                        ql.Request_For_Product_Marked_For_Future__c=null;
                        ql.Future__c=false;
                        ql.Marked_For_Delete__c=false;
                        ql.isMarketCheck__c=true;
                    }else if(bucketType.equals('future')) {
                        ql.RequestForProductMarkedForDelete__c=null;
                        ql.RequestForProductMarkedMarketCheck__c=null;
                        ql.Request_For_Product_Marked_For_Future__c=reqId;
                        ql.Future__c=true;
                        ql.Marked_For_Delete__c=false;
                        ql.isMarketCheck__c=false;
                    }
                    //system.debug('sales price: '+quoteItem.price);
                    ql.PricebookEntryId=quoteItem.priceBookEntryId;
                    system.debug('pricebook entry id: '+quoteItem.priceBookEntryId);

                    lineItemList.add(ql);
                }
            }
            
            if(lineItemList!=null && !lineItemList.isEmpty()){
                system.debug('lineItemList::::');
                try{
                    insert lineItemList;
                }catch (Exception e){
                    system.debug('insert line Item list exception: '+e);
                }
            }
        }
    }
    
    @TestVisible private Id createQuote(list<OppQuoteRequestDAO> quoteList){
        Id newQuoteId=null;
        
        try{
            String user=UserInfo.getName();
            Datetime todayDate=system.today();
            Date newdate=Date.newInstance(todayDate.Year(), todayDate.month(), todayDate.day());
            Quote newQuote=new Quote();
            newQuote.OpportunityId=oppId;
            newQuote.name=oppName+system.now();//user+newDate;
            newQuote.Status='New';
            
            // Recordtype priceMatrixType=[select Id, name from RecordType where developerName = 'Price_Matrix_Quote' and SobjectType = 'Quote'];
            
            list<Pricebook2> books = [select Id, name From Pricebook2 where name =:pricebookName and IsActive=true limit 1];
            if (books != null && books.size() > 0) {
                newQuote.Pricebook2Id = books[0].id;
                //  if(priceMatrixType!=null){
                newQuote.recordTypeId=helper.getRecordTypeId('Price_Matrix_Quote', 'Quote');
                //Schema.SObjectType.Quote_Request_Summary__c.getRecordTypeInfosByName().get('Price Matrix Quote').getRecordTypeId();//helper.getRecordTypeId('Price_Matrix_Quote', 'Quote');//priceMatrixType.Id;
                //}
            }
            try{
                insert newQuote;
                newQuoteId=newQuote.id;
            }catch(Exception e){
                system.debug('insert new Quote: '+e);
                return null;
            }
        }catch(Exception e){
            system.debug('new createQuote exception: '+e);
            return null;
        }
        return newQuoteId;
    }
    
    public PageReference clearSearch(){
        helper.oppQuoteRequestlist.clear();
        initialLoad();
        //PageReference pageRef=new Pagereference('/apex?OpportunityQuoteRequest.page');
        return null;
    }
    
    public PageReference CancelSearch (){
        string baseURL=URL.getSalesforceBaseUrl().toExternalForm();//getHost();
        system.debug('base URL: '+baseURL);
        PageReference pageRef=new Pagereference(baseURL+'/'+oppId);
        return pageRef;
    }
    
    @TestVisible private Id getAccountId(){
        list<Opportunity> opp=[select id, name, Account.id, Account.name from Opportunity where id=:oppId];
        Id accountId=null;
        if(!opp.isEmpty()){
            accountId=opp[0].Account.id;
        }
        return accountId;
    }
    private Id getGroupId(String grpName){
    	list<Group> grp=[select id,name, type from Group where type='Regular' and name=:grpName limit 1];
    	Id grpId=null;
    	if(grp!=null && !grp.isEmpty()){
    		grpId=grp[0].id;
    	}
    	return grpId;
    }
    
    public void shareOppTeamToQuoteRequest(Id qrId){
    	  
    	     //SFDC 2102 add opp team member to quote request sharing member
          try{
           list<OpportunityTeamMember> oppMembers=[ select OpportunityAccessLevel, OpportunityId,TeamMemberRole, userId from OpportunityTeamMember where opportunityId=:OppId];
          
           system.debug('Opp team members:>>>>>> '+oppMembers);
           if(qrId!=null && oppMembers!=null && !oppMembers.isEmpty()){
          //	list<QuoteRequreShareWrapper> sharmbmList=new list<QuoteRequreShareWrapper>();
           	 for(OpportunityTeamMember om:oppMembers){
           	 	QuoteRequestShareWrapper shrWrapper=new QuoteRequestShareWrapper(om.userId,om.OpportunityAccessLevel, qrId, null);
           	    sharmbmList.add(shrWrapper);
           	 }
           	 
        //   	 User admin=[select id,name, profileId, profile.name from user where Profile.name='System Administrator' limit 1];
          
            // system.runAs(admin){
           	if(sharmbmList!=null){
           	 	addQuoteRequestShare(sharmbmList);
           	 }
           	//}
           }
           
          }catch (Exception e){
          	system.debug(' insert sharelist excepiton:'+e);
          }
           
    }
    /**
    ** this method is add the users to the Quote Request Sharing list base on the Opp team members
    **/
    public void addQuoteRequestShare(list<QuoteRequestShareWrapper> shareMembers){
    	system.debug('share members: '+shareMembers);
     try{
    	if(shareMembers!=null && !shareMembers.isEmpty()){
    		
    		list<Quote_Request_Summary__share> qrShrList=new list<Quote_Request_Summary__Share>();
    		
    		for(QuoteRequestShareWrapper shr:shareMembers){
    			Quote_Request_Summary__share qrShr=new Quote_Request_Summary__Share();
    			qrShr.UserOrGroupId=shr.userId;
    			qrShr.AccessLevel=shr.AccessLevel;
    			qrShr.ParentId=shr.recordId;
    			
    		  if(shr.causeType!=null && shr.causeType=='Dental'){
    		  	  qrShr.RowCause=Schema.Quote_Request_Summary__Share.RowCause.Dental_Underwriting_Member__c;
    		  	 
    		  } else if(shr.causeType!=null && shr.causeType=='Underwriting'){
    		  	  system.debug('share with underwriting::'+Schema.Quote_Request_Summary__Share.RowCause.Underwriting_Member__c);
    			  qrShr.RowCause=Schema.Quote_Request_Summary__Share.RowCause.Underwriting_Member__c;
    			}else{
    			 system.debug(' row casue::::'+Schema.Quote_Request_Summary__Share.RowCause.Team_Member__c);
    			   //qrShr.RowCause='Opportunity Team Member';
    			    qrShr.RowCause=Schema.Quote_Request_Summary__Share.RowCause.Team_Member__c;
    			}
    		
    			qrShrList.add(qrShr);
    		}
    		
    		if(qrShrList!=null && !qrShrList.isEmpty()){
    			system.debug('share list:::'+qrShrList);
    			
    			Database.SaveResult[] lsr = Database.insert(qrShrList,false);
    			if(lsr!=null){
    				system.debug('share add result error::::'+lsr[0].getErrors());
    				system.debug(' is adding Quote Request Share Member Success ? '+lsr[0].isSuccess());
    				
    			}
    		}
    	}
    	}catch(Exception e){
    		system.debug(' addQuoteRequestShare exception: '+e);
    	}
    }
    public Class CarrierHistoryWrapper{
        public Competitor_Relationship__c carrierHistory{get;set;}
        public boolean isSelected{get;set;}
        public integer recordNumber{get;set;}
        public CarrierHistoryWrapper(Competitor_Relationship__c ch , boolean selected,Integer recNo){
            carrierHistory = ch;
            isSelected = selected;
            recordNumber = recNo;
        }
    }
    
    public Class QuoteRequestShareWrapper{
    	public Id userId=null;
    	public String accessLevel=null;
    	public Id recordId=null;
    	public String causeType=null;
    	
    	public QuoteRequestShareWrapper(Id user, String access, Id recId, String causeType){
    		this.userId=user;
    		this.accessLevel=access;
    		this.recordId=recId;
    		this.causeType=causeType;
    	}
    }
}