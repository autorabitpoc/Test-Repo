@isTest
public class SharePointQuoteRequestManagerTest {
    
    @testSetup
    /* setupTests() copied directly from OpportunityRequestQuoteControllerTest Class */
    static void setupTests(){
        
        Test.startTest();
        
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
        
        //Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account123');
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
        
        testOpProduct1[0].Incumbent__c = testCompetitorAccount.Id;
        testOpProduct2[0].Incumbent__c = testCompetitorAccount.Id;
        testOpProduct3[0].Incumbent__c = testCompetitorAccount.Id;
        
        testOpProduct1[0].Product_Type__c = 'New Sale';
    	//testOpProduct1[0].Category__c = 'Medical';
        testOpProduct1[0].Status__c = 'In Progress';
        testOpProduct2[0].State__c='TX';
        //testOpProduct1[0].Account__c = groupAccount.Id;
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
         
        insert testOpProduct3;
        
      	Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');
      
      	Quote existingQuote=TestClassUtiltity.createQuote(testOpp[0].id);
      	existingQuote.pricebook2Id=priceBook2Id;
      	insert existingQuote;
      
      	Quote_Request_Summary__c testReq=TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser.id);
      	testReq.Opportunity_Name__c=testOpp[0].name;
      	testReq.Opportunity_Id__c=String.valueOf(testOpp[0].id);
      	testReq.Account_Id__c = String.valueOf(groupAccount.Id);
     
      	insert TestReq;
       
      	list<QuoteLineItem> lines= new list<QuoteLineItem>();
       	lines.add(TestClassUtiltity.createQuoteLineItem(existingQuote.id, testReq.id, null, null,testProducts[0].id, priceBook2Id));
       	lines.add(TestClassUtiltity.createQuoteLineItem(existingQuote.id,null, testReq.id,null, testProducts[1].id, priceBook2Id));
       	lines.add(TestClassUtiltity.createQuoteLineItem(existingQuote.id,null,null,testReq.id, testProducts[2].id, priceBook2Id));
       	insert lines;  
        
        /* Below copied from GEMS_SharePointUtilityController_Test and modified to use the correct Custom Settings */
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePoint_TEST_HeronQuotes__c ACustomSetting01 = new SharePoint_TEST_HeronQuotes__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            ACustomSetting01.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            ACustomSetting01.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        ACustomSetting01.Access_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting01.Access_Token_2__c = '00000000000000000000000000000000';
        ACustomSetting01.Access_Token_3__c = '00000000000000000000000000000000';
        ACustomSetting01.Access_Token_4__c = '00000000000000000000000000000000';
        ACustomSetting01.Access_Token_5__c = '00000000000000000000000000000000';
        ACustomSetting01.Client_ID__c = '123456789ABCDEFG';
        ACustomSetting01.Client_Secret__c = 'secret';
        ACustomSetting01.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        ACustomSetting01.Refresh_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting01.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert ACustomSetting01;
        
        SPOAuthTestReqHub__c ACustomSetting02 = new SPOAuthTestReqHub__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            ACustomSetting02.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            ACustomSetting02.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        ACustomSetting02.Access_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting02.Access_Token_2__c = '00000000000000000000000000000000';
        ACustomSetting02.Access_Token_3__c = '00000000000000000000000000000000';
        ACustomSetting02.Access_Token_4__c = '00000000000000000000000000000000';
        ACustomSetting02.Access_Token_5__c = '00000000000000000000000000000000';
        ACustomSetting02.Client_ID__c = '123456789ABCDEFG';
        ACustomSetting02.Client_Secret__c = 'secret';
        ACustomSetting02.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        ACustomSetting02.Refresh_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting02.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert ACustomSetting02;
        
        SharePointOAuthReqHub__c ACustomSetting03 = new SharePointOAuthReqHub__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            ACustomSetting03.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            ACustomSetting03.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        ACustomSetting03.Access_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting03.Access_Token_2__c = '00000000000000000000000000000000';
        ACustomSetting03.Access_Token_3__c = '00000000000000000000000000000000';
        ACustomSetting03.Access_Token_4__c = '00000000000000000000000000000000';
        ACustomSetting03.Access_Token_5__c = '00000000000000000000000000000000';
        ACustomSetting03.Client_ID__c = '123456789ABCDEFG';
        ACustomSetting03.Client_Secret__c = 'secret';
        ACustomSetting03.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        ACustomSetting03.Refresh_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting03.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert ACustomSetting03;
        
        SharePointOAuth__c ACustomSetting04 = new SharePointOAuth__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            ACustomSetting04.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            ACustomSetting04.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        ACustomSetting04.Access_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting04.Access_Token_2__c = '00000000000000000000000000000000';
        ACustomSetting04.Access_Token_3__c = '00000000000000000000000000000000';
        ACustomSetting04.Access_Token_4__c = '00000000000000000000000000000000';
        ACustomSetting04.Access_Token_5__c = '00000000000000000000000000000000';
        ACustomSetting04.Client_ID__c = '123456789ABCDEFG';
        ACustomSetting04.Client_Secret__c = 'secret';
        ACustomSetting04.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        ACustomSetting04.Refresh_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting04.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert ACustomSetting04;
        
        SharePointOAuthTEST__c ACustomSetting05 = new SharePointOAuthTEST__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            ACustomSetting05.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            ACustomSetting05.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        ACustomSetting05.Access_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting05.Access_Token_2__c = '00000000000000000000000000000000';
        ACustomSetting05.Access_Token_3__c = '00000000000000000000000000000000';
        ACustomSetting05.Access_Token_4__c = '00000000000000000000000000000000';
        ACustomSetting05.Access_Token_5__c = '00000000000000000000000000000000';
        ACustomSetting05.Client_ID__c = '123456789ABCDEFG';
        ACustomSetting05.Client_Secret__c = 'secret';
        ACustomSetting05.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        ACustomSetting05.Refresh_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting05.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert ACustomSetting05;        
        
        //SharePoint_PROD_HeronQuotes__c
                SharePoint_PROD_HeronQuotes__c ACustomSetting06 = new SharePoint_PROD_HeronQuotes__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            ACustomSetting06.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            ACustomSetting06.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        ACustomSetting06.Access_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting06.Access_Token_2__c = '00000000000000000000000000000000';
        ACustomSetting06.Access_Token_3__c = '00000000000000000000000000000000';
        ACustomSetting06.Access_Token_4__c = '00000000000000000000000000000000';
        ACustomSetting06.Access_Token_5__c = '00000000000000000000000000000000';
        ACustomSetting06.Client_ID__c = '123456789ABCDEFG';
        ACustomSetting06.Client_Secret__c = 'secret';
        ACustomSetting06.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        ACustomSetting06.Refresh_Token_1__c = '00000000000000000000000000000000';
        ACustomSetting06.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert ACustomSetting06;        
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];        
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = profileRec.Id;
        insert testKey;
        
    }
    
    static testmethod void Test001(){
        
        Opportunity o = [SELECT Id, Name FROM Opportunity where name='oppName 1' LIMIT 1];
        
        System.debug('Test001 Opportunity Name: ' + o.Name);
        
        List<Quote_Request_Summary__c> currQuoteReq = new List<Quote_Request_Summary__c>();
        currQuoteReq=[Select Id, ownerId,owner.name, Account_Id__c, Name, Opportunity_Id__c,AFA__c, ASO_Commissions_Annual__c, ASO_Commissions_PCPM__c, Account_Executive1__c, Account_Executive2__c, Active_Health_Contracts__c, Active_Health_Members__c, Are_commissions_included__c, Bull_s_Eye__c, COBRA__c, Claim_Exceeded_Amt_Future__c, Claim_Exceeded_Amt_Past__c, Claims_Target_Guarantee__c, Comment__c, Commissions_Billed_Separately__c, Competitor_3rd_PartyVendor__c, Consultant__c, Contact__c, Contract_End_Date__c, Contract_Start_Date__c, Contract_Term_Aggregate__c, Contract_Term_Individual__c, Covered_ElseWhere__c, Current_Agent__c, DHMO_Current_Participation__c, Dental_Current_Participation__c, Dental__c,Description__c, Dental_days__c, Department_for_Underwriting__c, ERISA_Plan_Year__c, Expected_Dental_Contracts__c, Expected_Health_Contracts__c, GA_Override__c, General_Agent__c, HCSC_Division__c, HMO_Current_Participation__c, Health_Commissions__c, Health_days__c, How_many_HMO_plans_are_there__c, How_many_current_health_plans__c, How_many_non_HMO_health_plans_are_there__c, In_Network_Utilization_Guarantee__c, Is_this_a_Duplicate_Quote__c, Is_this_a_Formal_Bid__c, Life_Current_Participation__c, Life_days__c, Medicare_Retirees_Eligible__c, Network_Discount_Guarantees__c, Non_HMO_Current_Participation__c, Not_Insured__c, Other_Commisions__c, Other_Service__c, PUG__c, Part_Time__c, Participants_Diagonsed_Risk_Condition_Hi__c, Participants_Disabled__c, Percent_Enrolled__c, Performance_Guarantee__c, Premium_Type__c, Prior_HCSC_Account_Number__c, Prior_HCSC_Coverage__c, Priority__c, Producer__c, Proposed_Due_Date__c, Proposed_Funding_Type_multi__c, Quote_Name__c, Quote_Request_Name__c, Rate_Structure__c, Rates_Effective_for_Months__c, Received_From_Marketing__c, Reinsurer__c, Release_To_Marketing__c, Request_Effective_Date__c, Retirees__c, Risk_Data_Comment__c, STD_Current_Participation__c, STD_days__c, Sales_Type__c, Stoploss_Attachment_Points_Aggregate__c, Stoploss_Attachment_Points_Individual__c, Subject_to_ERISA__c, Total_Covered__c, Total_Eligible__c, Total_Eligible_for_Dental__c, Total_Eligible_for_Health__c, Total_on_Payroll__c, Trend_Guarantee__c, Underwriting_Due_Date__c, Waiting_For_Information_Type__c, Waiting_Period__c, Waive_on_Initial_Enrollment__c, Waiving_Not_Covered_ElseWhere__c,Current_Account_Funding_Type__c FROM Quote_Request_Summary__c where Opportunity_name__c='oppName 1' limit 1];
        
        System.debug('Test001 currQuoteReq Size: ' + currQuoteReq.size());
        
        Test.startTest();
        
        System.enqueueJob(new SharePointQuoteRequestManager(currQuoteReq));
        
        Test.stopTest();
        
        
    }

}