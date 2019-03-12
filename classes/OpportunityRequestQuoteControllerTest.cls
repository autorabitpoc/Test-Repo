/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

/*****************************************************************************************/
/* SFDC-4784: Added Custom Setting to cover the QuoteRequestTrigger as part of the       */
/*            SharePoint effort                                                          */
/*****************************************************************************************/

@isTest
private class OpportunityRequestQuoteControllerTest {

    @testSetup
    static void setupTests(){
        
        /* SFDC-4784 - 12/2017 - BEGIN */
        /* Create a Custom Setting */ 
        LGNAFeatureFlags__c AFeatureFlag = new LGNAFeatureFlags__c();
        AFeatureFlag.LGNA_Quote_Request_SharePoint__c = true;
        Insert AFeatureFlag;  
        /* SFDC-4784 - 12/2017 - END  */
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'standt12', Email = 'john.testing@testorg2.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg2.com', isActive = TRUE);
        insert testUser;
        
        Profile uw = [SELECT Id FROM Profile WHERE Name = 'Underwriting'];
        User uwUser = new User(Alias = 'standt12', Email = 'smit.testing@testorg24.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Smith', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'smith.testing@testorg24.com', isActive = TRUE);
        insert uwUser;
        
        
      //  Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account123');
        Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account groupAccount = TestClassUtiltity.createAccountWithRecType('Test Account234', groudActRecId);
        groupAccount.Underwriter_Name__c='Smith Testing';
        groupAccount.Account_Executive_2__c='Smith Testing';
        groupAccount.Account_Cluster_Name__c='Smith Testing';
        update groupAccount;
        
       //Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account groupAccount2 = TestClassUtiltity.createAccountWithRecType('Test Account2', groudActRecId);
        groupAccount2.Underwriter_Name__c='Smith Testing';
        groupAccount2.Account_Executive_2__c='Smith Testing';
        groupAccount2.Account_Cluster_Name__c='Smith Testing';
        update groupAccount2;
        
       
        list<Competitor_Relationship__c> carriers=TestClassUtiltity.createCarrierHistory(groupAccount.id);
        
         insert carriers;
         
        List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(groupAccount.Id);
        testOpp[0].Requested_Effective_Date__c = System.now().date();//oppName 1
        testOpp[0].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        testOpp[1].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        testOpp[2].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        
        insert testOpp;

        List<Product2> testProducts = TestClassUtiltity.createProducts();
        testProducts[0].Non_Medical_Compensation__c = True;
        testProducts[0].Family='Network';
        testProducts[0].Product_Type__c='Medical';
        testProducts[0].HCSC_State__c='IL';
        testProducts[0].Product_Category__c='HMO';
        testProducts[1].Non_Medical_Compensation__c = True;
        testProducts[1].Family='Network';
        testProducts[1].Product_Type__c='Medical';
        testProducts[1].HCSC_State__c='IL';
        testProducts[1].Product_Category__c='HMO';
        testProducts[1].HCSC_State__c='IL';
        testProducts[2].Non_Medical_Compensation__c = True;
        testProducts[2].Family='Network';
        testProducts[2].Product_Type__c='Dental';
       testProducts[2].Product_Category__c='PPO';
         testProducts[2].HCSC_State__c='IL';

        insert testProducts;

        list<Product2> products = new list<Product2> ();
        products.add(new Product2(Name = 'prod1', IsActive = true, Family = 'Ancillary and other'));
        products.add(new Product2(Name = 'prod2',IsActive = true));
        products.add(new Product2(Name = 'prod3',IsActive = true));
        
        insert products;
        
                     Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        List<Opportunity_Product__c> testOpProduct1 = TestClassUtiltity.createOppProducts(testOpp[0].Id, testProducts[0].Id);
        List<Opportunity_Product__c> testOpProduct2 = TestClassUtiltity.createOppProducts(testOpp[0].Id, products[0].Id);
        List<Opportunity_Product__c> testOpProduct3 = TestClassUtiltity.createOppProducts(testOpp[0].Id, products[1].Id);
        
        
        testOpProduct1[0].Product_Type__c = 'New Sale';
    //  testOpProduct1[0].Category__c = 'Medical';
        testOpProduct1[0].Status__c = 'In Progress';
         testOpProduct1[0].Incumbent__c = testCompetitorAccount.Id;
        testOpProduct2[0].State__c='TX';
        //testOpProduct1[0].Account__c = groupAccount.Id;
        testOpProduct2[0].Incumbent__c = testCompetitorAccount.Id;
        insert testOpProduct1;
        
        //testOpProduct2[0].Category__c = 'Dental';
        testOpProduct2[0].Product_Type__c = 'Renewal';
         testOpProduct2[0].Status__c = 'In Progress';
         testOpProduct2[0].State__c='IL';
        //testOpProduct2.Account__c = groupAccount.Id;
         
         insert testOpProduct2;
         testOpProduct3[0].Product_Type__c = 'New Sale';
         testOpProduct3[0].Status__c = 'In Progress';
         testOpProduct3[0].State__c='IL';
          testOpProduct3[0].Incumbent__c = testCompetitorAccount.Id;
        insert testOpProduct3;
        
      Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');
      
      Quote existingQuote=TestClassUtiltity.createQuote(testOpp[0].id);
      existingQuote.pricebook2Id=priceBook2Id;
      insert existingQuote;
      
      Quote_Request_Summary__c testReq=TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser.id);
      testReq.Opportunity_Name__c=testOpp[0].name;
      testReq.Opportunity_Id__c=String.valueOf(testOpp[0].id);
     
      insert TestReq;
       
      list<QuoteLineItem> lines= new list<QuoteLineItem>();
       lines.add(TestClassUtiltity.createQuoteLineItem(existingQuote.id, testReq.id, null, null,testProducts[0].id, priceBook2Id));
       lines.add(TestClassUtiltity.createQuoteLineItem(existingQuote.id,null, testReq.id,null, testProducts[1].id, priceBook2Id));
       lines.add(TestClassUtiltity.createQuoteLineItem(existingQuote.id,null,null,testReq.id, testProducts[2].id, priceBook2Id));
       insert lines;
      

    }
    static testMethod void TestOpportunityRequestQuoteController1() {
        
        // TO DO: implement unit test
        Test.startTest();
      
        list<OppQuoteRequestDAO> markToDeleteOppProdList=new list<OppQuoteRequestDAO>();
        list<OppQuoteRequestDAO> futureOppProdList=new list<OppQuoteRequestDAO>();
        list<OppQuoteRequestDAO> waterTestingOppProdList=new list<oppQuoteRequestDAO>();
    //   list<CarrierHistoryWrapper> carrierHistoryList = new list<CarrierHistoryWrapper>();
        
      //  Id recId1=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
      //  Id recId2=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        OppQuoteRequestDAO quoteDAO=new OppQuoteRequestDAO();
        OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();
        helper.oppQuoteRequestlist=new list<OppQuoteRequestDAO>();  
        //OpportunityQuoteRequestHelper.getProdCategories();
  
        
        Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
        ApexPages.CurrentPage().getParameters().put('id', o.Id);
       
        ApexPages.StandardController std = new ApexPages.StandardController(o);
        OpportunityQuoteRequestController con = new OpportunityQuoteRequestController(std);
        con.getProdCategoryOptions();
        con.getProdTypeOptions();
        con.getProdFamilyOptions();
        con.getFundingTypeOptions();
       // con.BillingOptions();
        
        con.initialLoad();
        con.initialLoadForCarrier();
     
       // OpportunityQuoteRequestController oppCtrl=new OpportunityQuoteRequestController();
         con.findProducts();
        
        
        
        Test.stopTest();
        
           
    }
    
    static testMethod void TestOpportunityRequestQuoteController2() {
      
        // TO DO: implement unit test
        Test.startTest();
      
        list<OppQuoteRequestDAO> markToDeleteOppProdList=new list<OppQuoteRequestDAO>();
        list<OppQuoteRequestDAO> futureOppProdList=new list<OppQuoteRequestDAO>();
        list<OppQuoteRequestDAO> waterTestingOppProdList=new list<oppQuoteRequestDAO>();
   
        OppQuoteRequestDAO quoteDAO=new OppQuoteRequestDAO();
        OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();
        helper.oppQuoteRequestlist=new list<OppQuoteRequestDAO>();  
        //OpportunityQuoteRequestHelper.getProdCategories();
         Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
        Quote_Request_Summary__c currQuoteReq=[Select Id, ownerId,owner.name, Opportunity_Id__c,AFA__c, ASO_Commissions_Annual__c, ASO_Commissions_PCPM__c, Account_Executive1__c, Account_Executive2__c, Active_Health_Contracts__c, Active_Health_Members__c, Are_commissions_included__c, Bull_s_Eye__c, COBRA__c, Claim_Exceeded_Amt_Future__c, Claim_Exceeded_Amt_Past__c, Claims_Target_Guarantee__c, Comment__c, Commissions_Billed_Separately__c, Competitor_3rd_PartyVendor__c, Consultant__c, Contact__c, Contract_End_Date__c, Contract_Start_Date__c, Contract_Term_Aggregate__c, Contract_Term_Individual__c, Covered_ElseWhere__c, Current_Agent__c, DHMO_Current_Participation__c, Dental_Current_Participation__c, Dental__c,Description__c, Dental_days__c, Department_for_Underwriting__c, ERISA_Plan_Year__c, Expected_Dental_Contracts__c, Expected_Health_Contracts__c, GA_Override__c, General_Agent__c, HCSC_Division__c, HMO_Current_Participation__c, Health_Commissions__c, Health_days__c, How_many_HMO_plans_are_there__c, How_many_current_health_plans__c, How_many_non_HMO_health_plans_are_there__c, In_Network_Utilization_Guarantee__c, Is_this_a_Duplicate_Quote__c, Is_this_a_Formal_Bid__c, Life_Current_Participation__c, Life_days__c, Medicare_Retirees_Eligible__c, Network_Discount_Guarantees__c, Non_HMO_Current_Participation__c, Not_Insured__c, Other_Commisions__c, Other_Service__c, PUG__c, Part_Time__c, Participants_Diagonsed_Risk_Condition_Hi__c, Participants_Disabled__c, Percent_Enrolled__c, Performance_Guarantee__c, Premium_Type__c, Prior_HCSC_Account_Number__c, Prior_HCSC_Coverage__c, Priority__c, Producer__c, Proposed_Due_Date__c, Proposed_Funding_Type_multi__c, Quote_Name__c, Quote_Request_Name__c, Rate_Structure__c, Rates_Effective_for_Months__c, Received_From_Marketing__c, Reinsurer__c, Release_To_Marketing__c, Request_Effective_Date__c, Retirees__c, Risk_Data_Comment__c, STD_Current_Participation__c, STD_days__c, Sales_Type__c, Stoploss_Attachment_Points_Aggregate__c, Stoploss_Attachment_Points_Individual__c, Subject_to_ERISA__c, Total_Covered__c, Total_Eligible__c, Total_Eligible_for_Dental__c, Total_Eligible_for_Health__c, Total_on_Payroll__c, Trend_Guarantee__c, Underwriting_Due_Date__c, Waiting_For_Information_Type__c, Waiting_Period__c, Waive_on_Initial_Enrollment__c, Waiving_Not_Covered_ElseWhere__c,Current_Account_Funding_Type__c FROM Quote_Request_Summary__c where Opportunity_name__c='oppName 1' limit 1];
        
         //apex/OpportunityQuoteRequest?quoteRequestId=a2wc0000002fhfv%20&id=006c000000FtEVAAA3
        PageReference initialPage = new PageReference('/apex/OpportunityQuoteRequest');//?quoteRequestId=a2wc0000002fhfv%20&id=006c000000FtEVAAA3');
        Test.setCurrentPage(initialPage);
        ApexPages.CurrentPage().getParameters().put('id', o.Id);
        ApexPages.CurrentPage().getParameters().put('quoteRequestId', currQuoteReq.Id);
        ApexPages.StandardController std = new ApexPages.StandardController(currQuoteReq);
        OpportunityQuoteRequestController con = new OpportunityQuoteRequestController(std);
        con.getProdCategoryOptions();
        con.getProdTypeOptions();
        con.getProdFamilyOptions();
        con.getFundingTypeOptions();
       // con.BillingOptions();
        
        con.initialLoad();
        con.initialLoadForCarrier();
         con.findProducts();
        Test.stopTest();
        
           
    }
     static testMethod void testInitialLoad1(){
      test.startTest();
        Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
        Quote_Request_Summary__c currQuoteReq=[Select Id, ownerId,owner.name, AFA__c, ASO_Commissions_Annual__c, ASO_Commissions_PCPM__c, Account_Executive1__c, Account_Executive2__c, Active_Health_Contracts__c, Active_Health_Members__c, Are_commissions_included__c, Bull_s_Eye__c, COBRA__c, Claim_Exceeded_Amt_Future__c, Claim_Exceeded_Amt_Past__c, Claims_Target_Guarantee__c, Comment__c, Commissions_Billed_Separately__c, Competitor_3rd_PartyVendor__c, Consultant__c, Contact__c, Contract_End_Date__c, Contract_Start_Date__c, Contract_Term_Aggregate__c, Contract_Term_Individual__c, Covered_ElseWhere__c, Current_Agent__c, DHMO_Current_Participation__c, Dental_Current_Participation__c, Dental__c,Description__c, Dental_days__c, Department_for_Underwriting__c, ERISA_Plan_Year__c, Expected_Dental_Contracts__c, Expected_Health_Contracts__c, GA_Override__c, General_Agent__c, HCSC_Division__c, HMO_Current_Participation__c, Health_Commissions__c, Health_days__c, How_many_HMO_plans_are_there__c, How_many_current_health_plans__c, How_many_non_HMO_health_plans_are_there__c, In_Network_Utilization_Guarantee__c, Is_this_a_Duplicate_Quote__c, Is_this_a_Formal_Bid__c, Life_Current_Participation__c, Life_days__c, Medicare_Retirees_Eligible__c, Network_Discount_Guarantees__c, Non_HMO_Current_Participation__c, Not_Insured__c, Other_Commisions__c, Other_Service__c, PUG__c, Part_Time__c, Participants_Diagonsed_Risk_Condition_Hi__c, Participants_Disabled__c, Percent_Enrolled__c, Performance_Guarantee__c, Premium_Type__c, Prior_HCSC_Account_Number__c, Prior_HCSC_Coverage__c, Priority__c, Producer__c, Proposed_Due_Date__c, Proposed_Funding_Type_multi__c, Quote_Name__c, Quote_Request_Name__c, Rate_Structure__c, Rates_Effective_for_Months__c, Received_From_Marketing__c, Reinsurer__c, Release_To_Marketing__c, Request_Effective_Date__c, Retirees__c, Risk_Data_Comment__c, STD_Current_Participation__c, STD_days__c, Sales_Type__c, Stoploss_Attachment_Points_Aggregate__c, Stoploss_Attachment_Points_Individual__c, Subject_to_ERISA__c, Total_Covered__c, Total_Eligible__c, Total_Eligible_for_Dental__c, Total_Eligible_for_Health__c, Total_on_Payroll__c, Trend_Guarantee__c, Underwriting_Due_Date__c, Waiting_For_Information_Type__c, Waiting_Period__c, Waive_on_Initial_Enrollment__c, Waiving_Not_Covered_ElseWhere__c,Current_Account_Funding_Type__c FROM Quote_Request_Summary__c where Opportunity_name__c='oppName 1' limit 1];
        
        PageReference initialPage = new PageReference('/apex/OpportunityQuoteRequest');
        Test.setCurrentPage(initialPage);
        ApexPages.CurrentPage().getParameters().put('id', o.Id);
       // ApexPages.CurrentPage().getParameters().put('quoteRequestId', currQuoteReq.Id);
        
        ApexPages.StandardController std = new ApexPages.StandardController(o);
        OpportunityQuoteRequestController con = new OpportunityQuoteRequestController(std);
        con.initialLoad();
        con.CreateCarrierData(true);
    
        test.stopTest();
       
    }
    static testMethod void testInitialLoad(){
    
        Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
        Quote_Request_Summary__c currQuoteReq=[Select Id, ownerId,owner.name, AFA__c, ASO_Commissions_Annual__c, ASO_Commissions_PCPM__c, Account_Executive1__c, Account_Executive2__c, Active_Health_Contracts__c, Active_Health_Members__c, Are_commissions_included__c, Bull_s_Eye__c, COBRA__c, Claim_Exceeded_Amt_Future__c, Claim_Exceeded_Amt_Past__c, Claims_Target_Guarantee__c, Comment__c, Commissions_Billed_Separately__c, Competitor_3rd_PartyVendor__c, Consultant__c, Contact__c, Contract_End_Date__c, Contract_Start_Date__c, Contract_Term_Aggregate__c, Contract_Term_Individual__c, Covered_ElseWhere__c, Current_Agent__c, DHMO_Current_Participation__c, Dental_Current_Participation__c, Dental__c,Description__c, Dental_days__c, Department_for_Underwriting__c, ERISA_Plan_Year__c, Expected_Dental_Contracts__c, Expected_Health_Contracts__c, GA_Override__c, General_Agent__c, HCSC_Division__c, HMO_Current_Participation__c, Health_Commissions__c, Health_days__c, How_many_HMO_plans_are_there__c, How_many_current_health_plans__c, How_many_non_HMO_health_plans_are_there__c, In_Network_Utilization_Guarantee__c, Is_this_a_Duplicate_Quote__c, Is_this_a_Formal_Bid__c, Life_Current_Participation__c, Life_days__c, Medicare_Retirees_Eligible__c, Network_Discount_Guarantees__c, Non_HMO_Current_Participation__c, Not_Insured__c, Other_Commisions__c, Other_Service__c, PUG__c, Part_Time__c, Participants_Diagonsed_Risk_Condition_Hi__c, Participants_Disabled__c, Percent_Enrolled__c, Performance_Guarantee__c, Premium_Type__c, Prior_HCSC_Account_Number__c, Prior_HCSC_Coverage__c, Priority__c, Producer__c, Proposed_Due_Date__c, Proposed_Funding_Type_multi__c, Quote_Name__c, Quote_Request_Name__c, Rate_Structure__c, Rates_Effective_for_Months__c, Received_From_Marketing__c, Reinsurer__c, Release_To_Marketing__c, Request_Effective_Date__c, Retirees__c, Risk_Data_Comment__c, STD_Current_Participation__c, STD_days__c, Sales_Type__c, Stoploss_Attachment_Points_Aggregate__c, Stoploss_Attachment_Points_Individual__c, Subject_to_ERISA__c, Total_Covered__c, Total_Eligible__c, Total_Eligible_for_Dental__c, Total_Eligible_for_Health__c, Total_on_Payroll__c, Trend_Guarantee__c, Underwriting_Due_Date__c, Waiting_For_Information_Type__c, Waiting_Period__c, Waive_on_Initial_Enrollment__c, Waiving_Not_Covered_ElseWhere__c,Current_Account_Funding_Type__c FROM Quote_Request_Summary__c where Opportunity_name__c='oppName 1' limit 1];
        
        PageReference initialPage = new PageReference('/apex/OpportunityQuoteRequest');
        
         initialPage.getParameters().put('id', o.Id);
         initialPage.getParameters().put('quoteRequestId', currQuoteReq.Id);

      
        Test.setCurrentPage(initialPage);

        ApexPages.StandardController std = new ApexPages.StandardController(currQuoteReq);
        OpportunityQuoteRequestController con = new OpportunityQuoteRequestController(std);
       // con.pricebookName='test price book';
        String quoteRequestId=ApexPages.currentPage().getParameters().get('quoteRequestId'); 
        if(quoteRequestId!=null){
           quoteRequestId=quoteRequestId.trim();
        }

        set<Id> reqIds=new set<Id>();
        list<quoteLineItem> reqProdItems=[select id, product2Id,product2.id,product2.name,product2.recordType.name,isMarketCheck__c,product2.ProductCode,product2.HCSC_State__c,product2.Product_Type__c,Pricing_Option__c,Marked_For_Delete__c,Future__c,Pricing__c,Pricing_Note__c,Billing__c,Product_Type__c from quotelineitem where Request_For_Product_Marked_For_Future__c=:quoteRequestId OR RequestForProductMarkedMarketCheck__c=:quoteRequestId OR RequestForProductMarkedForDelete__c=:quoteRequestId];
        
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
          //  req.billingOptions=BillingOptions();//helper.parseForOption(pb.More_Billing_Info__c);
           // req.selectedBillingOption=i.billing__c;
            
            if(i.Marked_For_Delete__c==true){
              req.isCurrent=i.Marked_For_Delete__c;
            }else {
              req.isCurrent=true;
            //  if(helper.quoteRequest.Sales_Type__c!=null && helper.quoteRequest.Sales_Type__c.equalsIgnoreCase('New Sale')){
              //    req.isCurrent=false; //there is no current for New Sale)
                //}
            }
            req.isFuture=i.Future__c;
            req.isMarketCheck=i.isMarketCheck__c;//;
           // req.quoteId=currentQuoteId;
                         // req.pricingOptions=helper.parseForOption(i.Pricing_Option__c);
          ///  req.pricing=i.pricing__c;
                       //  system.debug('from current Request ==> prodname: '+req.prodName+' isCurrent:'+req.isCurrent+' isFuture: '+req.isFuture);
            currentProdMap.put(i.Product2Id, req);
          }
        }

        test.startTest();
        con.initialLoad();

        con.CreateCarrierData(true);
        OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();
        helper.oppQuoteRequestlist=getQuoteReqDAOList();
        con.removeUnwantedProductFromList();
        con.updateQuoteRequestProdList(reqIds,false,false,currentProdMap); 
      //  con.SyncOppProduct();
        con.backFromSummary();
       // con.updatePricingNote('0');
     //   con.validateForSelection();
        test.stopTest();
       
    }
    
    static testMethod void testFindProducts(){

         // Test.startTest();
        
        PageReference pageRef = new PageReference('/apex/OpportunityQuoteRequest');
       
        //System.assertNotEquals(null, InitialPage);
        
        User testUser = [Select Id, Email from User where Email = 'john.testing@testorg2.com' limit 1];
       
        System.runAs(testUser){ 
        
          Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];

           pageRef.getParameters().put('id', o.Id);
        //   pageRef.getParameters().put('prodNameInput', 'test');
          Test.setCurrentPage(pageRef);

          ApexPages.StandardController sc = new ApexPages.standardController(o);
          OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController(sc);
          contr.prodNameInput='test';
          contr.selectedProdFamily='Network';
          contr.hcscState='IL';
          contr.selectedProdType='Medical';
          contr.selectedProdCategory='HMO';

          Test.startTest();
          contr.findProducts();
          contr.clearSearch();
          contr.cancelSearch();

          contr.hcscState=null;
          contr.findProducts();

          //test insertNewProductoPBE
          set<Id> prodIds=new set<Id>();
          list<Product2> prodlist=[select id from product2 where name like '%test%'];
          
         if(prodlist!=null && prodlist.size()>0){
          for(product2 p: prodlist){
            prodIds.add(p.id);

          }
        }
         // prodIds.add(testProducts[0].id);
          //prodIds.add(testProducts[1].id);
          contr.InsertNewProdtoStandardPB(prodIds);
          contr.InsertNewProdtoPBE(prodIds);
         
          Test.stopTest();
            }

        
    }
   
    

    static testMethod void getPricingValueTest(){
      String preFix='1';
      list<SelectOption> options =new list<SelectOption>();
      options.add(new SelectOption('1-option1','1-option1'));
      options.add(new SelectOption('2-option2','2-option2'));
      OpportunityQuoteRequestController con=new OpportunityQuoteRequestController();

      Test.startTest();
      con.getPricingValue(preFix,options);
      Test.stopTest();

    }

    static testMethod void createQuoteReqSummaryTest(){
     OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();
     list<Quote_Request_Summary__c>qtlist=[Select Id, Quote_Name__c,ownerId,owner.name,Account_Number__c,Sales_Type__c,Comment__c,Opportunity_Name__c,Opportunity_Id__c,HCSC_Division__c,Current_Account_Funding_Type__c,Account_Executive1__c,Account_Executive2__c,Active_Health_Members__c,Active_Health_Contracts__c,Quote_Request_Name__c,Account_Name_tx__c,Account_Id__c FROM Quote_Request_Summary__c where Opportunity_name__c='oppName 1' limit 1];
     helper.oppAcct=[select id, name,External_ID__c,Account_Executive_2__c,HCSC_Division__c,Funding_Type__c,Account_Cluster_Name__c,Active_Health_Subscribers__c,Active_Health_Members__c from Account where name='Test Account234' limit 1];
     helper.opp=[SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
   
     Id qId=null;

     if(qtlist!=null && qtlist.size()>0){
      helper.quoteRequest=qtlist[0];
      qId=helper.quoteRequest.Quote_Name__c;
     }
     OpportunityQuoteRequestController con=new OpportunityQuoteRequestController();

     Test.startTest();
     con.createQuoteReqSummary(qId);
     Test.stopTest();
    
     //new Quote_Request_Summary__c();
    }
    static list<OppQuoteRequestDAO> getQuoteReqDAOList(){
       
       list<OppQuoteRequestDAO> testlist=new list<OppQuoteRequestDAO>();
      list<Product2> prodlist=[select id from product2 where name like '%test%'];

       OppQuoteRequestDAO dao=new OppQuoteRequestDAO();
   
      // dao.pricing1Note='this is note for price1';
     //  dao.pricing2Note='this is note for price2';
        dao.productDetailOption='0';
       dao.pricingReferenceOption='0';
        dao.productDetailOptions=getOption();
       dao.pricingReferenceOptions=getOption();
       dao.effectiveDate=system.today();
      // dao.priceBookEntryId='';
       dao.priceBookId=null;
       dao.quoteId=null;
       dao.productId=prodList[0].id;
       dao.prodId=null;
       dao.prodName='testDental';
       dao.prodFamily='';
       dao.prodCode='';
       dao.prodType='';
       dao.prodrecordType='Service';
       dao.isFuture=true;
       dao.isCurrent=true;
       dao.isMarketCheck=false;
       dao.rowIndex=0;
    //   dao.pricing='1';
     //  dao.pricingNote='testpricingNote';
       dao.extraFundingtype='ASO';
       dao.oppotunityType='New Sale';

       dao.billingOptions=null;//helper.getBillings();
    //   dao.selectedBillingOption='testBillingOption';
       dao.hcscState='IL';
      // dao.pricingOptions=null;
      // dao.selectedPrice='price1';
     //  dao.acct=new account();
     //  dao.opp=new Opportunity();
       dao.comment='teststesateatate';
       

  
       OppQuoteRequestDAO dao2=new OppQuoteRequestDAO();
       dao2.productId=prodList[1].id;
  
     //  dao2.pricing1Note='this is note for price1';
       //dao2.pricing2Note='this is note for price2';
      // dao2.pricing3Note=null;
       dao2.effectiveDate=system.today();
       dao2.productDetailOption='1';
       dao2.pricingReferenceOption='1';
        dao2.productDetailOptions=getOption();
       dao2.pricingReferenceOptions=getOption();
     
       dao2.prodName='testDental';
       dao2.prodFamily='';
       dao2.prodCode='';
       dao2.prodType='';
       dao2.prodrecordType='Service';
       dao2.isFuture=true;
       dao2.isCurrent=false;
       dao2.isMarketCheck=false;
       dao2.rowIndex=1;
      // dao2.pricing='2';
      // dao2.pricingNote='testpricingNote';

       dao2.billingOptions=null;//helper.getBillings();
     //  dao2.selectedBillingOption='testBillingOption';
       dao2.hcscState='IL';
      // dao2.pricingOptions=null;
    //   dao2.selectedPrice='price1';
       dao2.comment='teststesateatate';

       OppQuoteRequestDAO dao3=new OppQuoteRequestDAO();
       dao3.productId=prodList[2].id;
  
       //dao3.pricing1Note='this is note for price1';
      // dao3.pricing2Note='this is note for price2';
       //dao3.pricing3Note=null;
       dao3.effectiveDate=system.today();
       dao3.productDetailOption='1';
       dao3.pricingReferenceOption='1';
        dao3.productDetailOptions=getOption();
       dao3.pricingReferenceOptions=getOption();
       dao3.prodName='testDental';
       dao3.prodFamily='';
       dao3.prodCode='';
       dao3.prodType='';
       dao3.prodrecordType='Service';
       dao3.isFuture=false;
       dao3.isCurrent=true;
       dao3.isMarketCheck=false;
       dao3.rowIndex=1;
     //  dao3.pricing='3';
    //   dao3.pricingNote='testpricingNote';

       dao3.billingOptions=null;//helper.getBillings();
     //  dao3.selectedBillingOption='testBillingOption';
       dao3.hcscState='IL';
     //  dao3.pricingOptions=null;
      // dao3.selectedPrice='price1';
      // dao3.acct=new account();
      // dao3.opp=new Opportunity();
       dao3.comment='teststesateatate';

      
      testlist.add(dao);
      testlist.add(dao2);
      testlist.add(dao3);
      return testlist;
    }

    //test helper classes

    static testMethod void testHelperParseString(){
        
        String testStr='test1;test2;test3';
        OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();
       List<SelectOption> testOption=helper.parseStrTxtIntoOptions(testStr);//parseForOption(testStr);
        
    }
    static testMethod void testHelpGetRecordTypeId(){
      OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();
      helper.getRecordTypeId('Price_Matrix_Quote', 'Quote');
    }

    static list<SelectOption> getOption(){
        list<SelectOption> options=new list<SelectOption>();
        options.add(new selectOption('0', 'option1'));
        options.add(new selectOption('1', 'option1'));
        options.add(new selectOption('2', 'option2'));
        options.add(new selectOption('3', 'option13'));   
            return options;
    }

    static testMethod void testHelpGetPriceNote(){

      OpportunityQuoteRequestHelper helper=new OpportunityQuoteRequestHelper();

       helper.getOpp();
     //  Map<Id,OppQuoteRequestDAO> currnetMap=new Map<Id,OppQuoteRequestDAO>();
    //   list<Product2> prodlist=[select id from product2 where name like '%test%'];

       OppQuoteRequestDAO dao=new OppQuoteRequestDAO();
 
      // dao.pricing1Note='this is note for price1';
       //dao.pricing2Note='this is note for price2';
       //dao.pricing3Note=null;
       dao.productDetailOption='0';
       dao.pricingReferenceOption='0';
       dao.effectiveDate=system.today();
       dao.productDetailOptions=getOption();
       dao.pricingReferenceOptions=getOption();
      // dao.priceBookEntryId='';
       //dao.priceBookId='';
      // dao.quoteId='';
    //   dao.productId=prodList[0].id;
       //dao.prodId='';
       dao.prodName='testDental';
       dao.prodFamily='';
       dao.prodCode='';
       dao.prodType='';
       dao.prodrecordType='Service';
       dao.isFuture=true;
       dao.isCurrent=true;
       dao.isMarketCheck=false;
       dao.rowIndex=0;
     //  dao.pricing='1';
      // dao.pricingNote='testpricingNote';
       dao.productDetailOption='2';
       dao.pricingReferenceOption='2';
       dao.billingOptions=null;//helper.getBillings();
      // dao.selectedBillingOption='testBillingOption';
       dao.hcscState='IL';
     //  dao.pricingOptions=null;
      // dao.selectedPrice='price1';
   
       dao.comment='teststesateatate';
       
       OppQuoteRequestDAO dao2=new OppQuoteRequestDAO();
      // dao2.productId=prodList[1].id;
 
     //  dao2.pricing1Note='this is note for price1';
      // dao2.pricing2Note='this is note for price2';
      // dao2.pricing3Note=null;
        dao2.productDetailOptions=getOption();
       dao2.pricingReferenceOptions=getOption();
       dao2.productDetailOption='1';
       dao2.pricingReferenceOption='1';
       dao2.effectiveDate=system.today();
     
       dao2.prodName='testDental';
       dao2.prodFamily='';
       dao2.prodCode='';
       dao2.prodType='';
       dao2.prodrecordType='Service';
       dao2.isFuture=true;
       dao2.isCurrent=true;
       dao2.isMarketCheck=false;
       dao2.rowIndex=1;
      // dao2.pricing='2';
      // dao2.pricingNote='testpricingNote';

       dao2.billingOptions=null;//helper.getBillings();
      // dao2.selectedBillingOption='testBillingOption';
       dao2.hcscState='IL';
     //  dao2.pricingOptions=null;
    //
       dao2.comment='teststesateatate';

       OppQuoteRequestDAO dao3=new OppQuoteRequestDAO();
      // dao3.productId=prodList[2].id;
 
    //   dao3.pricing1Note='this is note for price1';
     //  dao3.pricing2Note='this is note for price2';
     //  dao3.pricing3Note=null;
       dao3.productDetailOptions=getOption();
       dao3.pricingReferenceOptions=getOption();
       dao3.productDetailOption='0';
       dao3.pricingReferenceOption='0';
       dao3.effectiveDate=system.today();
     
       dao3.prodName='testDental';
       dao3.prodFamily='';
       dao3.prodCode='';
       dao3.prodType='';
       dao3.prodrecordType='Service';
       dao3.isFuture=true;
       dao3.isCurrent=true;
       dao3.isMarketCheck=false;
       dao3.rowIndex=1;
     //  dao3.pricing='3';
    //   dao3.pricingNote='testpricingNote';

       dao3.billingOptions=null;//helper.getBillings();
      // dao3.selectedBillingOption='testBillingOption';
       dao3.hcscState='IL';
      // dao3.pricingOptions=null;
    //   dao3.selectedPrice='price1';
  
       dao3.comment='teststesateatate';

       Test.startTest();
       helper.getPricingReference(dao);
       helper.getPricingReference(dao2);
       helper.getPricingReference(dao3);


       Test.stopTest();


    }

 /*  static testMethod void TestValidateForSelection(){
     OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();  
       contr.helper=new OpportunityQuoteRequestHelper();
       contr.helper.oppRecordTypeName='New Sale';
   }*/
   static testMethod void TestSyncProduct(){
    
      test.startTest();
    
      OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();  
       contr.helper=new OpportunityQuoteRequestHelper();
       contr.helper.oppRecordTypeName='New Sale';
       contr.oppName='oppName 1';
       
       
       Opportunity opp=[select id from Opportunity where name='oppName 1' limit 1];
       
       contr.helper.oppQuoteRequestlist=getQuoteReqDAOList();
       
       set<Id> prodId=new set<Id>();
       
       list<Opportunity_Product__c> oppProd=[select id,Opportunity_Name__c, Product__c, State__c from Opportunity_Product__c where State__c='IL'];
       
       if(oppProd!=null){
         for(Opportunity_Product__c op: oppProd){
            prodId.add(op.Product__c);
         }
         contr.oppProdId=prodId;
       }
       
      
       contr.SyncOppProduct();
       contr.ValidateForSelection();
       test.stopTest();
   }
   
   static testMethod void TestCreateQuoteReqSummary(){
        
       Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
       Quote testQuote=new Quote();
        testQuote.name='new quote';
        testQuote.opportunityId=o.id;
        insert testQuote;
      
       Quote_Request_Summary__c req1=new Quote_Request_Summary__c();
       req1.quote_name__c=testQuote.id;
       insert req1; 
      
       Id recId2=Schema.SObjectType.Quote_Request_Summary__c.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
       OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();  
       contr.helper=new OpportunityQuoteRequestHelper();
       contr.helper.oppRecordTypeName='New Sale';
       contr.oppName='oppName 1';
       
       contr.helper.quoteRequest=[select id,name from Quote_Request_Summary__c where id=:req1.id limit 1];
       contr.helper.oppAcct=[select id,External_ID__c,Account_Executive_2__c,Account_Cluster_Name__c,Funding_Type__c,HCSC_Division__c,Active_Health_Subscribers__c,Active_Health_Members__c, name from Account where name='Test Account234' limit 1];
       
       test.startTest();
       contr.CreateQuoteReqSummary(testQuote.id);
       test.stopTest();
  }
    static testMethod void TestSaveQuoteSummary() {
        Test.startTest();
        Id recId2=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        
        Opportunity newOpp=new Opportunity();
        
        Opportunity o = [SELECT Id FROM Opportunity where name='oppName 1' LIMIT 1];
        String oppIdstr=  ApexPages.CurrentPage().getParameters().put('id', o.Id);
       
       // PageReference mypage=new PageReference();
        
        ApexPages.StandardController std = new ApexPages.StandardController(o);
        OpportunityQuoteRequestController con = new OpportunityQuoteRequestController(std);
        con.getSummary();
        con.updateListwithPricingNote();
        con.SaveQuoteSummary();
        Test.stopTest();
    }
     
     static testMethod void testUpdateList(){
        //updateQuoteRequestProdList
        set<id> prodId =new set<id>();
        list<Product2> testProds=[select id, name from product2 where name in ('test','test1','test3')];
        if(testProds!=null && !testProds.isEmpty()){
            for(Product2 p: testProds){
                prodId.add(p.id);
            }
            
         OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();  
         
         Map<Id,OppQuoteRequestDAO> updateReqProd=new Map<Id, OppQuoteRequestDAO>();   
         test.startTest();
         contr.updateQuoteRequestProdList(ProdId, false, true,null);
         test.stopTest();
         
        }
        
        
     }
   
    static testMethod void testCreateQuote(){
        OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController(); 
        list<OppQuoteRequestDAO> quoteList=getQuoteReqDAOList();
        //contr.helper=new OpportunityQuoteRequestHelper();
        Test.startTest();
        //contr.helper.oppQuoteRequestlist=quoteList;
        contr.createQuote(quoteList);
        
        Test.stopTest();
        
    }
    
    static testMethod void testcreatedProductLineItem(){
        
       User testUser = [Select Id, Email from User where Email = 'john.testing@testorg2.com' limit 1];
       
      System.runAs(testUser){ 
        Opportunity opp=[select id, name from Opportunity where name='randome'];
        
       OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();
       Quote qt=new Quote();
       qt.name='test quote';
       qt.OpportunityId=opp.id;
       insert qt;
       
       Quote_Request_Summary__c req=new Quote_Request_Summary__c();
       req.Quote_Name__c=qt.id;
       
       insert req;
       
       list<OppQuoteRequestDAO> quoteList=getQuoteReqDAOList();
       test.startTest();
       
       contr.CreatedProductLineItem(quoteList,qt.id, req.id,'delete');
       contr.CreatedProductLineItem(quoteList,qt.id, req.id,'future');
       contr.CreatedProductLineItem(quoteList,qt.id, req.id,'marketcheck');
       
      
      }
      
      test.stopTest();
    }
     static testMethod void testAddRow(){
        
        Test.startTest();
        
        PageReference initialPage = new PageReference('/apex/OpportunityQuoteRequest');
        Test.setCurrentPage(initialPage);
        System.assertNotEquals(null, InitialPage);
        User testUser = [Select Id, Email from User where Email = 'john.testing@testorg2.com' limit 1];
        System.runAs(testUser){ 

         OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();             
            //List<Opportunity> testOpp = [select Id, Name from Opportunity];
          list<Account> testAcct=[select Id, name from Account where name='Test Account234'];
          contr.acctId=testAcct[0].id;
          contr.addRow();
            Contr.SaveCarrierRecords();
            contr.DummyMethod();
         contr.removeRow();
        }
        Test.stopTest();
    }
    
    static testMethod void testRemoveRow(){
        
        Test.startTest();
        
        PageReference initialPage = new PageReference('/apex/OpportunityQuoteRequest');
        Test.setCurrentPage(initialPage);
        System.assertNotEquals(null, InitialPage);
        User testUser = [Select Id, Email from User where Email = 'john.testing@testorg2.com' limit 1];
        System.runAs(testUser){ 
         OpportunityQuoteRequestController contr = new OpportunityQuoteRequestController();             
            //List<Opportunity> testOpp = [select Id, Name from Opportunity];
          list<Account> testAcct=[select Id, name from Account where name='Test Account234'];
          contr.acctId=testAcct[0].id;
            contr.removeRow();
            //System.assertEquals(1, sc.accountWrappers[0].opps[0].opportunityProducts.size()); 
            contr.SaveCarrierRecords();
        }
        Test.stopTest();
    }
}