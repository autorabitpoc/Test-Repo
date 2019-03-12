/**************************************************************************************
Apex Class Name     : SGR_RenewalProcessor  
Version             : 1.0
Function            : This class is used to Count the Number of Accounts Per division which are about to be renewed.
Modification Log    :
* Developer:  TarunKumar Gajula                  Date  : 9/7/2018                Description
* Developer:  SantoshKumar Nalli                 Date  : 8/07/2018               Description
* Developer:  Nidhi Reddy                        Date  : 10/3/2018               Description
* Developer:  Saritha Boyapati           Date  : 11/22/2018              Description
* ----------------------------------------------------------------------------               
* INFOSYS                  05/09/2018                Original Version
*************************************************************************************/
public class SGR_RenewalProcessor {
    
    
    
    public static  Integer count;
    
    public static  String returnMsg;
    public static  map<String,String> divAccCounter =new map<String,String>();
    
    public static  list<Account> accs=new list<Account>();
    
    
    
    @AuraEnabled
    public static map<String,String> initiateRenewalForBatch(List<string> divisions,String marketSegment,String fundingType,String renewEffDateStr,String renType){
        try{
            list<ID> batchLst=new list<ID>(); 
            list<SGRRenewalBatch__c> insertedBatchRecs = new list<SGRRenewalBatch__c>();
            list<SGR_Renewal_Batch_Oppty__c> renBatOppLstUpdate=new list<SGR_Renewal_Batch_Oppty__c>();
            Date renewEffDate = Date.valueOf(renewEffDateStr);
            Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId(); 
            Id sgrAnalytOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
            
            /**Query that will generate all the account records based on our requirement**/
            //Nidhi: replaced accountnumber with external_ID__c
            accs=[select id,ACA_Indicator__c,ShippingPostalCode,HCSC_Division__c,Renewal_Date__c,external_ID__c,County_Code__c,Domestic_Partner__c, Region__c, Forecast_Segment__c  from Account where Forecast_Segment__c='Small Group' AND Funding_Type__c=:fundingType AND (Renewal_Date__c >=:renewEffDate )AND (Renewal_Date__c <:renewEffDate.addMonths(1)) AND HCSC_Division__c IN:divisions AND Status__c='Active' AND recordTypeId=:sgrGroupAccount and ACA_Indicator__c='Y'];
            if(accs.isEmpty()){
                AuraHandledException e = new AuraHandledException('Error! Entered criteria resulted 0 records');
                e.setMessage('Error! Entered criteria resulted 0 records');
            }
            
            count=0;
            
            /**Logic for genearating BatchID per each division**/
            list<SGRRenewalBatch__c> rbList=new list<SGRRenewalBatch__c>();
            for(String indDiv: divisions) {
                for(Account acc:accs){
                    if(indDiv==acc.HCSC_Division__c){
                        count++;                    
                    }
                 }
                Boolean result = false;
                // No account retreived for this division
                if (count == 0) {
                    returnMsg ='No accounts found for <strong>' + indDiv +'</strong> division. <strong>0</strong> opportunities will be created.<br/>';
                    divAccCounter.put(indDiv,returnMsg);
                    divAccCounter.put('title', 'Not all renewals were initiated successfully.');
                    continue;
                } else {
                    String valResult = SGR_AccountRenewalsHelper.validateRenewalEffectiveDate(marketSegment, fundingType, 'Batch', renType, indDiv, renewEffDate); 
                    if (valResult!='') {
                        throw new AuraHandledException(valResult);
                    }                
                }
                ID batchId;
                Integer batchSize = integer.valueOf(System.label.SGRAccountRenewalBatchSize);
                if(!accs.isEmpty()&& accs.size()>0){
                SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
               
                batchId = Database.executeBatch(sbr,batchSize);
                 batchLst.add(batchId);
                }
                /**Logic for Inserting the records into the SGRRenewalBatch Object**/
                if(batchId != null || batchId != ''){               
                    
                    rbList.add(SGR_AccountRenewalsHelper.createRenewalBatchRec(indDiv,'', marketSegment, fundingType, renewEffDate, renType, 'Batch', count, batchId));
                    returnMsg ='Batch ID #<strong>'+batchId+'</strong> created for <strong>'+indDiv+'</strong> division. <strong>'+ count + '</strong> opportunities will be created.' + '<br/>';
                    divAccCounter.put(indDiv,returnMsg);
                    if (divAccCounter.get('title')!='Partial Success') {
                        divAccCounter.put('title','Success! Renewal(s) successfully initiated.');
                    }
                    count=0;
                } else {                
                    throw new AuraHandledException('Batch Processing interrupted.. Kindly try again!'); 
                }            
            }
            
        }
        catch(SGR_Exception e) {
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                String errorStr = e.getMessage().subStringAfter('EXCEPTION,');
                errorStr = errorStr.substringBefore(': ');
                throw new AuraHandledException(errorStr);
            }
            
        }
        
        return divAccCounter;
    } 
    
    @AuraEnabled
    public static list<String> initiateRenewalForOnDemand(String division,String accNum,String renType,String fundingType,String marketSegment,String renewEffDate){
        List<Opportunity> oss = new List<Opportunity>();  
        List<Opportunity> ossP = new List<Opportunity>();
        List<Opportunity> ossZ = new List<Opportunity>();
        Date renewEffDate1= date.valueOf(renewEffDate);
        list<String> msgsList=new list<String>();
        String valResult = SGR_AccountRenewalsHelper.validateRenewalEffectiveDate(marketSegment, fundingType, 'On-Demand', renType, division, renewEffDate1); 
        
        if (valResult!='') {
            throw new AuraHandledException(valResult);
        }  
        try{      
            List<SGRRenewalBatch__c> rbList= new List<SGRRenewalBatch__c>();
            // santosh made the change of saving  the value into bid variable and passed that variable into Parameter 
            String bid=String.valueOf(System.currentTimeMillis());
            SGRRenewalBatch__c rb = SGR_AccountRenewalsHelper.createRenewalBatchRec(division,accNum, marketSegment, fundingType, renewEffDate1, renType, 'On-Demand', 1, bid);
            
            
            // SFDC-14055 Get matching gate record 
            Actuary_Gate__c gateRec = SGR_AccountRenewalsHelper.fetchGateRecord(division, marketSegment, fundingType, renewEffDate1);
            
            rbList.add(rb);
            //Nidhi: replaced accountnumber with external_ID__c
            // SFDC-14499:Checking for metallic account
             List<Account> accList= new List<Account>();
            if(!test.isRunningTest())
          {

             //accList = [Select Id,Name,HCSC_Division__c,status__c,Domestic_Partner__c,Renewal_Date__c,County_Code__c,Funding_Type__c,ShippingPostalCode__c from Account where external_ID__c=:accNum AND Is_Metallic_Account__c=True];
             accList = [Select Id,ACA_Indicator__c,Name,EIN__c,HCSC_Division__c,status__c,Domestic_Partner__c,Renewal_Date__c,County_Code__c,Funding_Type__c,ShippingPostalCode, Region__c,external_ID__c,Forecast_Segment__c from Account where external_ID__c=:accNum AND ACA_Indicator__c='Y' AND Status__c='Active' AND Forecast_Segment__c='Small Group'];
            }
            else {
              accList = [Select Id,Name,EIN__c,HCSC_Division__c,status__c,Domestic_Partner__c,Renewal_Date__c,County_Code__c,Funding_Type__c,ShippingPostalCode, Region__c,external_ID__c,Forecast_Segment__c  from Account where external_ID__c=:accNum];  
            }
            Id acId;
            set<id> acIdSet=new set<id>();
      set<String> acNoSet = new set<String>();           
            //SFDC-14499:Checking for metallic account
            if(!accList.isEmpty()){
                acId=accList[0].id;
                acNoSet.add(accList[0].External_ID__c);
                acIdSet.add(acId);
            }
            else{
                throw new AuraHandledException('Error!: The selected Account is not an ACA Metallic Account');
                 } 
              
           
            //SFDC:14536:For adding rating statuses
            set<ID> oppRatingstatusOther = new set<ID>();
            
            //Nidhi: replaced accountnumber with external_ID__c
            //SFDC:14536:Adding Rating_Status__c field to the Query
            List<Opportunity> opps =[Select id,name,AccountId,stageName,Forecast_Segment__c,Renewal_Date__c,Opportunity.Account.external_ID__c,Rating_Status__c,SGR_Opportunity_Type__c,Health_Count__c,Dental_Count__c,Subscribers_Count__c from Opportunity where AccountId=:acId AND HCSC_Division__c=:division AND Renewal_Date__c=:renewEffDate1];
            
                if (!rbList.isEmpty() && !accList.isEmpty()) { 
                    if(renType=='Analytical'){
                        SGR_AccountRenewalsHelper.createRenewalBatchOpps(opps, rb.batchId__c);
                        String msg = SGR_AccountRenewalsHelper.createOpportunities(accList,renType,'On-Demand', rb.batchId__c, renewEffDate1, gateRec);
                        msgsList.add(msg);
                        //SFDC-14508 (Landry) - added Funding_Type__c to query
                        //SFDC-14506 (Landry) - added Renewal_Date__c to query
                        //SFDC-14540 (Landry) - added HCSC Dvision and ShippingState (related account) to query
                        //US12536 & US11982 - added Rating_Status__c,SGR_Workflow_Activity__c fields to the below query.
                        oss=[Select id,RecordTypeId,AccountId,County_Code__c,Batch_Id__c,Zip_Code__c, Funding_Type__c, Renewal_Date__c, Product_Type__c,Forecast_Segment__c,
                             HCSC_Division__c, Account.ShippingState__c,Rating_Status__c,SGR_Workflow_Activity__c,Assigned_UW__c,Workflow_System_Status__c,FIPS_Code__c  from opportunity where Batch_Id__c=:rb.batchId__c];
                        if(oss.size()>0){
                            
                            SGR_AccountRenewalsHelper.addBAGSAssignments(acNoSet,rb.batchId__c);
                            //Tarun 01/02/2019 : Added return type as a part of E2E Fixes
                            map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap1=
                                SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(acIdSet,oss,rb.batchId__c);
                            SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(acIdSet,oss,rb.batchId__c);
                            SGR_AccountRenewalsHelper.insertOpportunitiesCencus(acIdSet,oss,rb.batchId__c);
                            //Tarun 01/02/2019 : Added extra parameter as a part of E2E Fixes
                            
                            SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(acIdSet,oss,rb.batchId__c,opBenMap1);
                            SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(acIdSet,oss,rb.batchId__c);
                            //SFDC-14982
                            SGR_AccountRenewalsHelper.insertOppBAGSAssignment(acIdSet,oss,rb.batchId__c);
                            SGR_PGA_Opportunity.sgrCreateProducerAssociationForOpportunity(oss);
                            //SFDC-16508 start
                            SGR_GSPS_CallMappedPlans sgcmp = new SGR_GSPS_CallMappedPlans(rb.batchId__c);
                  ID batchId1 = Database.executeBatch(sgcmp, 5);
                            //code changes done by santosh complete for US14334.
                        } //SFDC-16508 END
                       return msgsList; 
                    }
                    else{
                        // List<Opportunity> oppsActive =[Select id,name,AccountId,stageName,Opportunity.Account.external_ID__c,Rating_Status__c,SGR_Opportunity_Type__c from Opportunity where AccountId=:acId AND HCSC_Division__c=:division AND Renewal_Date__c=:renewEffDate1 and SGR_Opportunity_Type__c='Production'];
                       for(Opportunity tmp1:opps){
                        if(tmp1.Rating_Status__c!='Finalized' && tmp1.Rating_Status__c!='Closed' && tmp1.SGR_Opportunity_Type__c =='Production' ){
                                oppRatingstatusOther.add(tmp1.Id);
                            }
                        }
                        for(Opportunity tmp:opps){
                           //SFDC-14536(Saritha):change in duplicate condition check based on rating status of 'Finalized' or 'Closed' instead of WON/LOST status
                            if(oppRatingstatusOther.size()==0 && oppRatingstatusOther.isEmpty()){
                                String msg =  SGR_AccountRenewalsHelper.createOpportunities(accList,renType,'On-Demand', rb.batchId__c, renewEffDate1, gateRec);
                                msgsList.add(msg);
                                //US12536 & US11982 - added Rating_Status__c,SGR_Workflow_Activity__c fields to the below query.     
                                ossP=[Select id,RecordTypeId,AccountId,County_Code__c,Batch_Id__c,Zip_Code__c, Funding_Type__c, Renewal_Date__c, Product_Type__c,FIPS_Code__c, Forecast_Segment__c,
                                      HCSC_Division__c, Account.ShippingState__c,Rating_Status__c,SGR_Workflow_Activity__c,Assigned_UW__c,Workflow_System_Status__c from opportunity where Batch_Id__c=:rb.batchId__c];
                                
                                if(ossP.size()>0){
                                    SGR_AccountRenewalsHelper.addBAGSAssignments(acNoSet,rb.batchId__c);
                                    //Tarun 01/02/2019 : Added return type as a part of E2E Fixes
                                    map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap2=
                                        SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(acIdSet,ossP,rb.batchId__c);
                                    SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(acIdSet,ossP,rb.batchId__c);
                                    SGR_AccountRenewalsHelper.insertOpportunitiesCencus(acIdSet,ossP,rb.batchId__c);
                                    //Tarun 01/02/2019 : Added extra parameter as a part of E2E Fixes
                                    
                                    SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(acIdSet,ossP,rb.batchId__c,opBenMap2);
                                    SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(acIdSet,ossP,rb.batchId__c);
                                    //SFDC-14982
                                    SGR_AccountRenewalsHelper.insertOppBAGSAssignment(acIdSet,ossP,rb.batchId__c);
                                    SGR_PGA_Opportunity.sgrCreateProducerAssociationForOpportunity(oss);
                                   
                                     //SFDC-16508 Start
                                    SGR_GSPS_CallMappedPlans sgcmp = new SGR_GSPS_CallMappedPlans(rb.batchId__c);
                      ID batchId1 = Database.executeBatch(sgcmp, 5);
                                    //SFDC-16508 END
                                    //code changes done by santosh complete for US14334.
                                } 
                                return msgsList;   
                            }
                            else{
                                SGR_AccountRenewalsHelper.createRenewalBatchOpps(opps, rb.batchId__c);
                                SGR_AccountRenewalsHelper.createErrorLog(accList, rb.batchId__c);
                                list<Opportunity> errprint=[select id,name from Opportunity where Id = :oppRatingstatusOther];
                                throw new AuraHandledException('Error! Multiple production opportunities are not allowed for the same account and renewal date. Production opportunity'+'<a href="/'+errprint[0].id+'">'+'#<strong>'+errprint[0].name+'<strong>'+'</a>'+'already exists.');
                           }
            }
                        
                    } 
                    if(opps.size()==0)   
                    {
                        String msg =  SGR_AccountRenewalsHelper.createOpportunities(accList,renType,'On-Demand', rb.batchId__c, renewEffDate1, gateRec); 
                        msgsList.add(msg);
                        //US12536 & US11982 - added Rating_Status__c,SGR_Workflow_Activity__c fields to the below query.
                        ossZ=[Select id,RecordTypeId,AccountId,County_Code__c,Batch_Id__c,Zip_Code__c, Funding_Type__c, Renewal_Date__c, Product_Type__c, FIPS_Code__c,Forecast_Segment__c,
                              HCSC_Division__c, Account.ShippingState__c,Rating_Status__c,SGR_Workflow_Activity__c,Assigned_UW__c,Workflow_System_Status__c  from opportunity where Batch_Id__c=:rb.batchId__c];
                        SGR_AccountRenewalsHelper.addBAGSAssignments(acNoSet,rb.batchId__c);
                        //Tarun 01/02/2019 : Added return type as a part of E2E Fixes
                        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap3=
                            SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(acIdSet,ossZ,rb.batchId__c);
                        SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(acIdSet,ossZ,rb.batchId__c);
                        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(acIdSet,ossZ,rb.batchId__c);
                        //Tarun 01/02/2019 : Added extra parameter as a part of E2E Fixes
                       
                        SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(acIdSet,ossZ,rb.batchId__c,opBenMap3);
                        SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(acIdSet,ossZ,rb.batchId__c);
                        //SFDC-14982
                        SGR_AccountRenewalsHelper.insertOppBAGSAssignment(acIdSet,ossZ,rb.batchId__c);
                        
                        if(ossZ.size()>0){
                            SGR_GSPS_CallMappedPlans sgcmp = new SGR_GSPS_CallMappedPlans(rb.batchId__c);
                  ID batchId1 = Database.executeBatch(sgcmp, 5);
                            //code changes done by santosh complete for US14334.
                        } 
                        return msgsList; 
                    }
                    
                    
                    //santosh fetched list of opportunities created for on demand based on batch ID here. 
                    // the below 3 lines of code is for on demand functionality of business validation rules  US 14334   
                    
                       }
                else{
                    throw new AuraHandledException('No Opportunities Created: Error!');
                    }
              
            msgsList.add('No Opportunities Created: Error!');
            return msgsList;
         }
        catch(SGR_Exception e){
          throw new AuraHandledException(e.getMessage());
        }
      }
    
    @AuraEnabled
    public static Account searchAccounts(String division,String acctNo) {
        //Nidhi: replaced accountnumber with external_ID__c
         acctNo =acctNo.trim();
        List<Account> accList=[select id,Name,Domestic_Partner__c,External_ID__c,HCSC_Division__c,Renewal_Date__c,status__c,Market_Segment__c,Funding_Type__c, Region__c, Forecast_Segment__c,(select id,stageName,status__c,Renewal_Date__c from opportunities) from Account where External_ID__c=:acctNo and HCSC_Division__c = :division];
        
        if(accList.isEmpty()) {
            throw new AuraHandledException('Error! Division/Account number specified cannot be found');
        } else if(accList.size() > 1) {
            throw new AuraHandledException('Error! Multiple accounts were found for the specified criteria');
        } else if(accList[0].status__c == 'Cancelled'){
            
            throw new AuraHandledException('Error! Cancelled Account cannot be triggered.');
            
        }
        return accList[0];
    }
    
}