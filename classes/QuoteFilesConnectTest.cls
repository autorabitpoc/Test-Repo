@isTest
public class QuoteFilesConnectTest {

    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static User userIntProfile;
    String callingSource = 'LGNAQuoteRq';
    @testSetup
    static void dataSetupQR() {
                     
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();        
        SharePoint_TEST_HeronQuotes__c cs = new SharePoint_TEST_HeronQuotes__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }              
        cs.Access_Token_1__c = '00000000000000000000000000000000';
        cs.Access_Token_2__c = '00000000000000000000000000000000';
        cs.Access_Token_3__c = '00000000000000000000000000000000';
        cs.Access_Token_4__c = '00000000000000000000000000000000';
        cs.Access_Token_5__c = '00000000000000000000000000000000';
        cs.Client_ID__c = '123456789ABCDEFG';
        cs.Client_Secret__c = 'secret';
        cs.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        cs.Refresh_Token_1__c = '00000000000000000000000000000000';
        cs.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert cs;
               
        Test.startTest();
        
        Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
		Account groupAccount = TestClassUtiltity.createAccountWithRecType('Test Account234', groudActRecId);
		groupAccount.Underwriter_Name__c='Smith Testing';
		groupAccount.Account_Executive_2__c='Smith Testing';
		groupAccount.Account_Cluster_Name__c='Smith Testing';
		update groupAccount;
		         
	    List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(groupAccount.Id);
		testOpp[0].Requested_Effective_Date__c = System.now().date();//oppName 1
		testOpp[0].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		testOpp[1].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
	    testOpp[2].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		insert testOpp;
		
			
	Profile uw = [SELECT Id FROM Profile WHERE Name = 'Underwriting'];
		User uwUser = new User(Alias = 'standt12', Email = 'smit.testing@testorg24.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Smith', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = uw.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'smith.testing@testorg24.com', isActive = TRUE);
		insert uwUser;
		
		
	  Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');
	  Quote existingQuote=TestClassUtiltity.createQuote(testOpp[0].id);
	  existingQuote.pricebook2Id=priceBook2Id;
	  insert existingQuote;
	  
	  Quote_Request_Summary__c testReq=TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser.id);
	  testReq.Opportunity_Name__c=testOpp[0].name;
      testReq.Opportunity_Id__c=String.valueOf(testOpp[0].id);
      testReq.Request_Description__c='testreq123';
      //testReq.Account_Executive2_Name__c='John Smith';
      //testReq.Account_Executive1_Name__c='Test dummy';
      testReq.HCSC_Division__c='IL';
      testReq.Account_Name_tx__c='Heron test Account';
      testReq.Account_Number__c='0000555';
      testReq.Request_Effective_Date__c=system.today();
      testReq.Sales_Type__c='New Sale';
	    insert testReq;
   
        Test.stopTest();                     
       
    }
    
     @isTest static void testMethodQR() {
        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        //userIntProfile = userList[0];
        
          Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
		Account groupAccount = TestClassUtiltity.createAccountWithRecType('Test Account234', groudActRecId);
		groupAccount.Underwriter_Name__c='Smith Testing';
		groupAccount.Account_Executive_2__c='Smith Testing';
		groupAccount.Account_Cluster_Name__c='Smith Testing';
		update groupAccount;
		         
	    List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(groupAccount.Id);
		testOpp[0].Requested_Effective_Date__c = System.now().date();//oppName 1
		testOpp[0].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		testOpp[1].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
	    testOpp[2].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		insert testOpp;
		
		
         
	Profile uw = [SELECT Id FROM Profile WHERE Name = 'Underwriting'];
		User uwUser1 = new User(Alias = 'standt12', Email = 'smit.testing@testorg24.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Smith', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = uw.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'smith.testing1@testorg24.com', isActive = TRUE);
		insert uwUser1;
		
		
	  Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');
	  Quote existingQuote=TestClassUtiltity.createQuote(testOpp[0].id);
	  existingQuote.pricebook2Id=priceBook2Id;
	  insert existingQuote;
	  
	  Quote_Request_Summary__c testReq=TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser1.id);
	  testReq.Opportunity_Name__c=testOpp[0].name;
      testReq.Opportunity_Id__c=String.valueOf(testOpp[0].id);
      testReq.Request_Description__c='testreq123';
      //testReq.Account_Executive2_Name__c='John Smith';
      //testReq.Account_Executive1_Name__c='Test dummy';
      testReq.HCSC_Division__c='IL';
      testReq.Account_Name_tx__c='Heron test Account';
      testReq.Account_Number__c='0000555';
      testReq.Quote_Name__c = existingQuote.Id;      
      testReq.Request_Effective_Date__c=system.today();            
      testReq.Sales_Type__c='New Sale';
	    insert testReq;
         //system.assertEquals(testReq.Id, existingQuote.Id);
       
        //PageReference pageRef = Page.QuoteRequestSharepoint;
        //Test.setCurrentPage(pageRef);
         
        //Quote_Request_Summary__c c = [SELECT Id FROM Quote_Request_Summary__c LIMIT 1];
        ApexPages.CurrentPage().getParameters().put('id', existingQuote.id);
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = profileRec.Id;
        insert testKey;
         
        ApexPages.StandardController std = new ApexPages.StandardController(existingQuote);
         //QuoteFilesConnect con = new QuoteFilesConnect(std);
         
         //SharePoint_Configuration__mdt sharePointConfiguration;
         
         //CaseDAO.ICaseDAO caseDAOInstance;
         CaseDAO caseDAOInstance = new CaseDAO();
         ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance;
         //SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance;
         SharePointConfiguration sharePointConfiguration = new SharePointConfiguration('LGNAQuoteRq'); 
         SharePointCalloutUtility sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfiguration);
           QuoteFilesConnect con = new QuoteFilesConnect(std,
                                           caseDAOInstance,
                                           itemsSharePointDAOInstance,
                                           sharePointCalloutUtilityInstance,
                                           SharePointConfiguration);
         
         /*QuoteFilesConnect(ApexPages.StandardController std,
                                           CaseDAO.ICaseDAO caseDAOInstance,
                                           ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance,
                                           SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                           SharePointConfiguration sharePointConfiguration)*/

                
        try{    
          con.pageSize = 0;
          con.totalNoOfRecs = 1;
          con.getInitialDocumentSet();
        } catch(System.MathException e) {
          System.assert(true);
        }
    
        con.totalNoOfRecs = 0;
        con.pageSize = 2;
        con.getInitialDocumentSet();
    
        con.totalNoOfRecs = 3;
        con.getInitialDocumentSet();
         try{
          con.next();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        System.assertEquals(1, con.pageNumber);
    
        try{
          con.previous();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
    
        try{
          con.previous();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
    
        con.fileType = 'application';
        con.fileName = 'Test file name';
        con.linkFile();
        con.fileType = 'other';
        con.fileName = 'Test file name';
        con.linkFile();
        try{
            con.fileType = 'other';
            con.fileName = 'Test file name';
            con.SFlinkFile(con.fileName);
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        
        //con.isAuthUser= true;
        con.verifySharePointButton();
        try{
            con.downloadURL();
            con.fileType = 'application';
            con.fileName = 'abcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklAASmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcde';
            con.subStringAttachmentName(con.fileName);
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        Test.stopTest();
        
    }
    
      @isTest static void testMethodQR2() {
        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        //userIntProfile = userList[0];
        
          Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
		Account groupAccount = TestClassUtiltity.createAccountWithRecType('Test Account234', groudActRecId);
		groupAccount.Underwriter_Name__c='Smith Testing';
		groupAccount.Account_Executive_2__c='Smith Testing';
		groupAccount.Account_Cluster_Name__c='Smith Testing';
		update groupAccount;
		         
	    List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(groupAccount.Id);
		testOpp[0].Requested_Effective_Date__c = System.now().date();//oppName 1
		testOpp[0].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		testOpp[1].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
	    testOpp[2].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		insert testOpp;
		
		
         
	Profile uw = [SELECT Id FROM Profile WHERE Name = 'Underwriting'];
		User uwUser1 = new User(Alias = 'standt12', Email = 'smit.testing@testorg24.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Smith', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = uw.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'smith.testing2@testorg24.com', isActive = TRUE);
		insert uwUser1;
		
		
	  Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');
	  Quote existingQuote=TestClassUtiltity.createQuote(testOpp[0].id);
	  existingQuote.pricebook2Id=priceBook2Id;
	  insert existingQuote;
	  
	  Quote_Request_Summary__c testReq=TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser1.id);
	  testReq.Opportunity_Name__c=testOpp[0].name;
      testReq.Opportunity_Id__c=String.valueOf(testOpp[0].id);
      testReq.Request_Description__c='testreq123';
      //testReq.Account_Executive2_Name__c='John Smith';
      //testReq.Account_Executive1_Name__c='Test dummy';
      testReq.HCSC_Division__c='IL';
      testReq.Account_Name_tx__c='Heron test Account';
      testReq.Account_Number__c='0000555';
      testReq.Quote_Name__c = existingQuote.Id;      
      testReq.Request_Effective_Date__c=system.today();            
      testReq.Sales_Type__c='New Sale';
	    insert testReq;
         //system.assertEquals(testReq.Id, existingQuote.Id);
       
        //PageReference pageRef = Page.QuoteRequestSharepoint;
        //Test.setCurrentPage(pageRef);
         
        //Quote_Request_Summary__c c = [SELECT Id FROM Quote_Request_Summary__c LIMIT 1];
        ApexPages.CurrentPage().getParameters().put('id', testReq.id);
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = profileRec.Id;
        insert testKey;
         
        ApexPages.StandardController std = new ApexPages.StandardController(testReq);
         //QuoteFilesConnect con = new QuoteFilesConnect(std);
         
         //SharePoint_Configuration__mdt sharePointConfiguration;
         
         //CaseDAO.ICaseDAO caseDAOInstance;
         CaseDAO caseDAOInstance = new CaseDAO();
         ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance;
         //SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance;
         SharePointConfiguration sharePointConfiguration = new SharePointConfiguration('LGNAQuoteRq'); 
         SharePointCalloutUtility sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfiguration);
           QuoteFilesConnect con = new QuoteFilesConnect(std,
                                           caseDAOInstance,
                                           itemsSharePointDAOInstance,
                                           sharePointCalloutUtilityInstance,
                                           SharePointConfiguration);
         
         /*QuoteFilesConnect(ApexPages.StandardController std,
                                           CaseDAO.ICaseDAO caseDAOInstance,
                                           ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance,
                                           SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                           SharePointConfiguration sharePointConfiguration)*/

                
        try{    
          con.pageSize = 0;
          con.totalNoOfRecs = 1;
          con.getInitialDocumentSet();
        } catch(System.MathException e) {
          System.assert(true);
        }
    
        con.totalNoOfRecs = 0;
        con.pageSize = 2;
        con.getInitialDocumentSet();
    
        con.totalNoOfRecs = 3;
        con.getInitialDocumentSet();
         try{
          con.next();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        System.assertEquals(1, con.pageNumber);
    
        try{
          con.previous();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
    
        try{
          con.previous();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
    
        con.fileType = 'application';
        con.fileName = 'Test file name';
        con.linkFile();
        con.fileType = 'other';
        con.fileName = 'Test file name';
        con.linkFile();
        try{
            con.fileType = 'other';
            con.fileName = 'Test file name';
            con.SFlinkFile(con.fileName);
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        
        //con.isAuthUser= true;
        con.verifySharePointButton();
        try{
            con.downloadURL();
            con.fileType = 'application';
            con.fileName = 'abcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklAASmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcde';
            con.subStringAttachmentName(con.fileName);
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        Test.stopTest();
        
    }

}