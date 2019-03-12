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
@isTest
private class LGNA_NewRequestHubItemControllerTest { 
    static testMethod void AccountMaintanance() {
        try {
            Profile sysProfile=[select id, name from profile where name='System Administrator'];
            
            User newUser = new User(Alias = 'test', Email ='testuserTest@noemail.com', EmailEncodingKey = 'UTF-8', LastName = 'testUserLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = sysProfile.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testUser101@nosfemail.com');
            insert newUser;
            
            //create test account record
            Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            Account testAccount=TestClassUtiltity.createAccountWithRecType('testAccount', grpActRecId);
            Account testAccount1=TestClassUtiltity.createAccountWithRecType('testAccount1', grpActRecId);
            
            List<Opportunity> opp = TestClassUtiltity.CreateOpportunities(testAccount1.Id);
			insert opp;
            
            
            Id AMRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
            
            List<Case> testcase=TestClassUtiltity.createCaseRecords(testAccount.Id);
            
            Case__c aem = new Case__c();
            aem.Name = 'Account Eligibility Maintenance';
            aem.Maintenance_Type__c= 'Updates to New Employee Period';
            insert aem;
            
            Case__c cam = new Case__c();
            cam.Name = 'Cosmetic Account Maintenance';
            cam.Maintenance_Type__c= 'Address';
            insert cam;
            
            Case__c icm = new Case__c();
            icm.Name = 'ID Card Maintenance';
            icm.Maintenance_Type__c= 'ID Card Changes, No Benefit Changes';
            insert icm;
            
            Case__c aep = new Case__c();
            aep.Name = 'AEP File Maintenance';
            aep.Maintenance_Type__c= 'Layout Change';
            insert aep;
            
            Case__c asm = new Case__c();
            asm.Name = 'Account Structure Maintenance';
            asm.Maintenance_Type__c= 'Add Characteristics';
            insert asm;
            
            Case__c rcm = new Case__c();
            rcm.Name = 'Rate Change/Stop Loss Maintenance';
            rcm.Maintenance_Type__c= 'Stop Loss Changes Only with Dental, No Benefit Changes';
            insert rcm;
            
            list<string> myStrings = new list<string>{'Address','Add Characteristics','Stop Loss Changes Only with Dental, No Benefit Changes',
                'ID Card Changes, No Benefit Changes','Updates to New Employee Period','Layout Change'};  
             string aemstring ='Account Eligibility Maintenance';
             string casecomments='case comments value';
                    
            test.startTest();
            LGNA_NewRequestHubItemController.getaccDetails(testAccount.Id);
            LGNA_NewRequestHubItemController.getaccDetails(testAccount1.Id);
             LGNA_NewRequestHubItemController.getaccDetails(null);
            LGNA_NewRequestHubItemController.getSubmissionTypePiklistValues();
            LGNA_NewRequestHubItemController.getselectOptionsCAM();
            LGNA_NewRequestHubItemController.getselectOptionsAEM();
            LGNA_NewRequestHubItemController.getselectOptionsASM(); 
            LGNA_NewRequestHubItemController.getselectOptionsRCM();
            LGNA_NewRequestHubItemController.getselectOptionsICM();
            LGNA_NewRequestHubItemController.getselectOptionsAEPFM();
            LGNA_NewRequestHubItemController.getSSubTypePiklistValues();
            LGNA_NewRequestHubItemController.insertAMCaseRec(testAccount,opp[0],testcase[0],aemstring,myStrings,casecomments);            
            test.stopTest();
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
    static testMethod void getRequestHubAndFavoriteTest() {
        // TO DO: implement unit test
        
        
        Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account testAccount=TestClassUtiltity.createAccountWithRecType('testAccount', grpActRecId);
        
        Id nsOppOppRecId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity nsOpp=new Opportunity(AccountId = testAccount.id, RecordTypeId = nsOppOppRecId, Name = 'oppName 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));
        
        Request_Hub_Items__c item1=new Request_Hub_Items__c ();
        
        item1.Active__c=true;
        item1.name='Cancellation';
        item1.Label__c='this is test requst hub item';
        
        item1.LG_Group_Account__c=true;
        item1.New_Sale_Opp__c=true;
        item1.Renewal_Opp__c=true;
        
        insert item1;
        
        
        
        Profile sysProfile=[select id, name from profile where name='System Administrator'];
        
        User newUser = new User(Alias = 'test', Email ='testuserTest@noemail.com', EmailEncodingKey = 'UTF-8', LastName = 'testUserLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = sysProfile.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testUser101@nosfemail.com');
        insert newUser;
        
        Request_Hub_Favorite__c newfav= new Request_Hub_Favorite__c();
        newFav.Favorite_On__c=true;
        newFav.Request_Hub_Items__c=item1.id;
        newFav.User__c=newUser.id;
        
        insert newFav;
        
        test.startTest();
        LGNA_NewRequestHubItemController.getRequestHubItems(testAccount.id, 'Account');
        LGNA_NewRequestHubItemController.getRequestHubItems(nsOpp.id, 'Opportunity');
        
        LGNA_NewRequestHubItemController.getFavoriteItemsList(testAccount.id, 'Account');
        LGNA_NewRequestHubItemController.getFavoriteItemsList(nsOpp.id, 'Opportunity');
        test.stopTest();
    }
    
    static testMethod void testfetchProfileName(){
        String stringReturned = LGNA_NewRequestHubItemController.fetchProfileName();
        System.debug('stringReturned: ' + stringReturned);
        System.assertEquals(true, String.isNotBlank(stringReturned), 'No Profile was returned.');
    }
    
    static testMethod void testcheckCSSTaskTypeAccess(){
        Boolean booleanReturned = LGNA_NewRequestHubItemController.checkCSSTaskTypeAccess();
        System.debug('booleanReturned: ' + booleanReturned);
        System.assertEquals(true, booleanReturned, 'User did not have access to CSS Task Record Type.');
    }
    static testMethod void contractAdminAccess(){
        Boolean booleanReturned = LGNA_NewRequestHubItemController.contractAdminAccess();
        System.debug('booleanReturned: ' + booleanReturned);
        System.assertEquals(true, booleanReturned, 'You do not have access to create Contract Admin Request, kindly contact your administrator.');
    }
    static testMethod void fetchCustomCaseRecordTypeId(){
        String recordTypeReturned = LGNA_NewRequestHubItemController.fetchCaseRecordTypeId('custom');
        System.debug('recordTypeReturned: ' + recordTypeReturned);
    }
    static testMethod void fetchStadardCaseRecordTypeId(){
        String recordTypeReturned = LGNA_NewRequestHubItemController.fetchCaseRecordTypeId('standard');
        System.debug('recordTypeReturned: ' + recordTypeReturned);
    }
   static testMethod void fetchCurrentAccountInfo(){
        Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account testAccount=TestClassUtiltity.createAccountWithRecType('testAccount', grpActRecId);
        Account accountReturned = LGNA_NewRequestHubItemController.fetchCurrentAccountInfo(testAccount.Id);
        System.debug('accountReturned =: ' + accountReturned);
    }
       static testMethod void checkAccountMaintenanceTypeAccess(){
         Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser=new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE);
        system.runAs(testUser){
        Boolean hasAccess= LGNA_NewRequestHubItemController.checkAccountMaintenanceTypeAccess();
        //Boolean booleanReturned = LGNA_NewRequestHubItemController.checkAccountMaintenanceTypeAccess();
        System.debug('booleanReturned: ' + hasAccess);
       // System.assertEquals(true, hasAccess, 'You do not have access to create Account Maintenance Request, kindly contact your administrator.');
    }
    }
    
    static testMethod void testfetchTaskRecordId(){
        String stringReturned = LGNA_NewRequestHubItemController.fetchTaskRecordId('CSS Task Record Type');
        System.debug('stringReturned: ' + stringReturned);
        System.assertEquals(true, String.isNotBlank(stringReturned), 'No Record Id was returned.');        
    }
    static testMethod void testgetRecordTypeId(){
         Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Account testAccount=TestClassUtiltity.createAccountWithRecType('testAccount', grpActRecId);
        test.startTest();
        String recordId=LGNA_NewRequestHubItemController.getRecordTypeId('Group_Prospect_Account','Account');
        
          Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser=new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE);
       
        system.runAs(testUser){
             Boolean hasAccess= LGNA_NewRequestHubItemController.getProspectAccountAccess(recordId);
        }
        test.stopTest();
        
    }
       
   static testMethod void createCaseTest(){
        try {
            
            //  Profile sysProfile=[select id, name from profile where name='System Administrator'];
            //   User newUser = new User(Alias = 'test', Email ='testuserTest@noemail.com', EmailEncodingKey = 'UTF-8', LastName = 'testUserLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = sysProfile.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testUser101@nosfemail.com');
            //   insert newUser;
            //create test account record
            List<Market_Segment__c> sgmsg = new List<Market_Segment__c>();
            sgmsg.add(new Market_Segment__c(Name='1',Type__c='SG',	Value__c='SG'));
            sgmsg.add(new Market_Segment__c(Name='2',Type__c='SG',	Value__c='HMSG'));
            insert sgmsg;
            
            Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            Id  prosActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            
            Account testAccount=TestClassUtiltity.createAccountWithRecType('grpAccount', grpActRecId);
            Account testSGAccount=TestClassUtiltity.createAccountWithRecType('grpSGAccount', grpActRecId);
            Account testAccount1=TestClassUtiltity.createAccountWithRecType('grpAccount1', grpActRecId);
            List<Account> updateAccs = new List<Account>();
            
            testAccount.External_ID__c = '898989';
            testAccount.FSU_Location__c = 'Chicago';
            testAccount.HCSC_Division__c = 'TX';
            testAccount.Funding_Type__c = 'ASO;Prem';
            testAccount.Premium_Type__c = 'PP';
            testAccount.Funding_Type__c = 'LG';
            updateAccs.add(testAccount);
            
            testSGAccount.External_ID__c = '798989';
            testSGAccount.FSU_Location__c = 'SCP';
            testSGAccount.HCSC_Division__c = 'NM';
            testSGAccount.Funding_Type__c = 'ASO';
            testSGAccount.Market_Segment__c = 'HMSG';
            updateAccs.add(testSGAccount);
            
            testAccount1.FSU_Location__c = 'Other (Specify)';
            testAccount1.External_ID__c = '898988';
            testAccount1.HCSC_Division__c = 'TX';
            updateAccs.add(testAccount1);
            
            update updateAccs;

            String accId= testAccount.Id;
            String sgAccId= testSGAccount.Id;
            String accId1= testAccount1.Id;
           
            String cedeRecordtypeLabel = 'Cede';
            String proposalRecordTypeLabel = 'Proposal';
            String networkInformationRecordTypeLabel = 'Network Information';
            String performanceGuaranteeRecordTypeLabel = 'Performance Guarantee';
            String accountCancellation = 'Account Cancellation';
            //String cbsrRecordTypeLabel = 'CBSR Issue';
         
            test.startTest();
            LGNA_NewRequestHubItemController.checkSRAccess('Open Enrolment');//SFDC#9041
            LGNA_NewRequestHubItemController.checkCaseRecordTypeAccess(cedeRecordtypeLabel);
           // LGNA_NewRequestHubItemController.isSGAccount(accId);
            LGNA_NewRequestHubItemController.isSGAccount(sgAccId);
            LGNA_NewRequestHubItemController.createCase(networkInformationRecordTypeLabel,accId);
            LGNA_NewRequestHubItemController.createCase(cedeRecordtypeLabel,accId);
            LGNA_NewRequestHubItemController.createCase(proposalRecordTypeLabel,accId);
            // LGNA_NewRequestHubItemController.createCase(performanceGuaranteeRecordTypeLabel,accId);
            LGNA_NewRequestHubItemController.createCase(accountCancellation,accId);
            //LGNA_NewRequestHubItemController.createCase(cbsrRecordTypeLabel,accId);
            LGNA_NewRequestHubItemController.createCase(performanceGuaranteeRecordTypeLabel,accId1);
            LGNA_NewRequestHubItemController.createCase(cedeRecordtypeLabel,accId1);          
            test.stopTest();
             } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
   static testMethod void oppCreateCaseTest(){
        try {
            
            Id  grpActRec1Id= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            Id  prosActRec1Id= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            
            Account testGrpAccount=TestClassUtiltity.createAccountWithRecType('grpAccountTest', grpActRec1Id);
            Account testProsAccount1=TestClassUtiltity.createAccountWithRecType('prosAccountTest1', prosActRec1Id);
            List<Account> updateAccs = new List<Account>();
            
            testGrpAccount.External_ID__c = '898989';
            testGrpAccount.FSU_Location__c = 'Chicago';
            testGrpAccount.HCSC_Division__c = 'TX';
            testGrpAccount.Funding_Type__c = 'ASO;Prem';
            testGrpAccount.Premium_Type__c = 'PP';
            updateAccs.add(testGrpAccount);
            
            testProsAccount1.FSU_Location__c = 'Other (Specify)';
            testProsAccount1.External_ID__c = '898988';
            testProsAccount1.HCSC_Division__c = 'TX';
            updateAccs.add(testProsAccount1);
            
            update updateAccs;
            
            List<Opportunity> oppList = new List<Opportunity>();
            Id nsOppOppRecId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            Opportunity newSaleOpp=new Opportunity(AccountId = testGrpAccount.id, 
                                                   RecordTypeId = nsOppOppRecId,
                                                   Requested_Effective_Date__c = system.Today(),
                                                   Name = 'oppName 1', 
                                                   StageName = 'Qualification', 
                                                   CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), 
                                                   RFI_RFP_Received_Date__c = system.Today().addYears(1));
            oppList.add(newSaleOpp);
            Opportunity newSaleOpp1=new Opportunity(AccountId = testProsAccount1.id, 
                                                   RecordTypeId = nsOppOppRecId,
                                                   Requested_Effective_Date__c = system.Today(),
                                                   Name = 'oppName 2', 
                                                   StageName = 'Qualification', 
                                                   CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), 
                                                   RFI_RFP_Received_Date__c = system.Today().addYears(1));
             oppList.add(newSaleOpp1);
            insert oppList;
            
            String grpaccId= testGrpAccount.Id;
            String prosaccId1= testProsAccount1.Id;
            String oppId = newSaleOpp.Id;
            String oppId1 = newSaleOpp1.Id;
            String cedeRecordtypeLabel = 'Cede';
            String proposalRecordTypeLabel = 'Proposal';
            String networkInformationRecordTypeLabel = 'Network Information';
            String performanceGuaranteeRecordTypeLabel = 'Performance Guarantee';
            String privateExchangeExternal = 'Private Exchange - External';
            //String cbsrRecordTypeLabel = 'CBSR Issue'; //Custom Benefit/Service
            
            test.startTest(); 
            LGNA_NewRequestHubItemController.createCase(cedeRecordtypeLabel,oppId);
            LGNA_NewRequestHubItemController.createCase(proposalRecordTypeLabel,oppId);
            //  LGNA_NewRequestHubItemController.createCase(networkInformationRecordTypeLabel,oppId);
            LGNA_NewRequestHubItemController.createCase(performanceGuaranteeRecordTypeLabel,oppId);
            LGNA_NewRequestHubItemController.createCase(privateExchangeExternal,oppId1);
            // LGNA_NewRequestHubItemController.createCase(cbsrRecordTypeLabel,oppId);
            
            

           
            test.stopTest();
            
        }catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
   static testMethod void saveFavoriteItemsListTest() {
      Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account testAccount=TestClassUtiltity.createAccountWithRecType('testAccount', grpActRecId);
        
        Id nsOppOppRecId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity nsOpp=new Opportunity(AccountId = testAccount.id, RecordTypeId = nsOppOppRecId, Name = 'oppName 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));
        
        
        Request_Hub_Items__c item1=new Request_Hub_Items__c ();
        Request_Hub_Items__c item2=new Request_Hub_Items__c ();
        list<Request_Hub_Items__c> favItemsList = new list<Request_Hub_Items__c>();
         list<Request_Hub_Items__c> requestItems = new list<Request_Hub_Items__c>();
        
        item1.Active__c=true;
        item1.name='Cancellation';
        item1.Label__c='this is test requst hub item';
        item1.FavoriteColor__c = 'OrangeColor';
        
        item1.LG_Group_Account__c=true;
        item1.New_Sale_Opp__c=true;
        item1.Renewal_Opp__c=true;
        
        favItemsList.add(item1);
        
        insert favItemsList;
        
        item2.Active__c=true;
        item2.name='Cede';
        item2.Label__c='this is test requst hub item';
        item1.FavoriteColor__c = 'GreyColor';
        
        item2.LG_Group_Account__c=true;
        item2.New_Sale_Opp__c=true;
        item2.Renewal_Opp__c=true;
        
        requestItems.add(item2);
        insert requestItems;         
        test.startTest();
         LGNA_NewRequestHubItemController.saveFavoriteItemsList(favItemsList, requestItems);
        test.stopTest();
    } 
    static testMethod void createSIRecordTest() {
        
        String selectedItem = 'Secure Information';
        String objectName = 'Opportunity';
        SI_Record_Types__c SIRec = new SI_Record_Types__c();
        SIRec.Name = '1';
        SIRec.SI_Record_Type_API_Name__c = 'ASO_BPA_IL';
        SIRec.HCSC_Division__c = 'TX';
        SIRec.SI_Request_Hub_UI_Label__c = 'ASO - BPA - IL';
        insert SIRec;
        
        Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
         Account SItestAccount=TestClassUtiltity.createAccountWithRecType('SItestAccount', grpActRecId);
        SItestAccount.External_ID__c = '898989';
            SItestAccount.FSU_Location__c = 'Chicago';
            SItestAccount.HCSC_Division__c = 'TX';
        update SItestAccount;
        
        Id SInsOppOppRecId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            Opportunity SInewSaleOpp=new Opportunity(AccountId = SItestAccount.id, 
                                                   RecordTypeId = SInsOppOppRecId, 
                                                   Name = 'oppName 1', 
                                                   StageName = 'Qualification', 
                                                   CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), 
                                                   RFI_RFP_Received_Date__c = system.Today().addYears(1));
        
         insert  SInewSaleOpp;
        LGNA_NewRequestHubItemController.fetchSIRecordTypeId(SIRec.SI_Request_Hub_UI_Label__c);
        LGNA_NewRequestHubItemController.getOpportunityDetails(SInewSaleOpp.Id);
        LGNA_NewRequestHubItemController.getSIRecordTypesList(selectedItem, SInewSaleOpp.Id, objectName);
    } 
}