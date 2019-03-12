/**************************************************************************************
Apex Class Name     : GEMS_AccountRetrieveServiceHelperTest
Version             : 1.0
Function            : This class serves as Unit Test Class for GEMS_AccountRetrieveServiceHelper. 
Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        07/19/2016                Original Version
* Shankar                   08/05/2017                Test class changes for 3-retrieve calls   
*************************************************************************************/
@isTest
private class GEMS_AccountRetrieveServiceHelperTest{  
    
    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static public List<case> accStructureCase;
    
    
    @testSetup
    static void dataSetup() {
        String result;
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        
        accRec = new Account();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.RecordTypeId = recTypeId;
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B0609';
        accRec.AccountNumber = 'A1234';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        
        Account accRec1 = new Account();
        accRec1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec1.Name = 'TestAccountForCaseTriggerHandler1';
        accRec1.AccountNumber = 'A123';
        accRec.External_ID__c = 'A123';
        accRec1.Group_Number__c= 'B0609';
        accRec1.external_id__c= 'B060977';
        accRec1.BillingStreet ='Testing';
        accRec1.BillingCity='TX';
        accRec1.BillingState='CT';
        accRec1.BillingPostalCode='534323';
        accRec1.status__c = 'Active';
        
        Account accRec2 = new Account();
        accRec2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec2.Name = 'TestAccountForCaseTriggerHandler1';
        accRec2.Group_Number__c= 'B0609';
        accRec2.AccountNumber = 'A456';
        accRec.External_ID__c = 'A456';
        accRec2.external_id__c= null;
        accRec2.BillingStreet ='Testing';
        accRec2.BillingCity='TX';
        accRec2.BillingState='CT';
        accRec2.BillingPostalCode='534323';
        accRec2.status__c = 'Active';
        
        List<Account> acclist = new List<Account>();
        acclist.add(accRec);
        acclist.add(accRec1);
        acclist.add(accRec2);
        insert acclist;
        
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        System.assertEquals('TestAccountForCaseTriggerHandler',accRecQuery[0].Name);
        
        List<String> accountTeamRoleList = new  List<String>();
        
        accountTeamRoleList.add('Account Specialist');
        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
        accTeamMemberAccSpecialist.UserId =userList[0].id;
        accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist.AccountId =acclist[0].id;
        accTeamMemberList.add(accTeamMemberAccSpecialist);
        
        AccountTeamMember accTeamMemberAccSpecialist1 = new AccountTeamMember ();
        accTeamMemberAccSpecialist1.UserId =userList[0].id;
        accTeamMemberAccSpecialist1.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist1.AccountId =acclist[1].id;
        accTeamMemberList.add(accTeamMemberAccSpecialist1);
        
        insert accTeamMemberList;
        
        List<Opportunity> optyList = new List<Opportunity>();
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec.Name='CaseTriggerHandler';
        oppRec.accountId=acclist[0].Id;
        oppRec.Type='Other';
        oppRec.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppRec.Date_Closed__c = system.today();
        oppRec.Exchange_Offering_Type__c='No Private Exchange';
        oppRec.CloseDate=Date.Today().addDays(8);
        oppRec.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppRec.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppRec.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppRec.Expected_Health_Members__c=2;
        oppRec.Account_Market_Segment__c='LG';
        oppRec.HCSC_Division__c='IL';
        oppRec.Region__c='N/A - IL';
        oppRec.District__c='290';
        oppRec.Clusters__c='020';
        oppRec.Primary_Closed_Reason__c='Other';
        
        optyList.add(oppRec);
        insert optyList;
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStrId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        List<case> caseList = new List<case>();
        case cs = new case();
        cs.accountid = accRecQuery[0].Id;
        cs.Opportunity_Name__c= oppRec.id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.GEMS_Submission_Type__c = 'New Account';
        cs.status = 'New';
        
        case cs1 = new case();
        cs1.accountid = accRecQuery[1].Id;
        cs.GEMS_Submission_Type__c = 'Renewal';
        cs1.Opportunity_Name__c= oppRec.id;
        cs1.recordtypeid = caseAccountSubmissionId;
        cs1.status = 'New';
        
        caseList.add(cs);
        caseList.add(cs1);
        insert caseList;
        
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
        System.assertEquals('GEMS Account Submission',accSubCase[1].RecordType.Name); 
        integer i=0;
        for(case accSubCase1:accSubCase ){
            accSubCase1.Status ='In Progress';
            accSubCase1.AccountId = accRecQuery[0].Id;
            accSubCase1.GEMS_Create_Account_Structure__c =true;
            accSubCase1.GEMS_Submission_Type__c = 'Renewal';
            accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
            accSubCase1.GEMS_Products__c ='';
            accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
            accSubCase1.GEMS_Line_of_Business__c='ENA';
            accSubCase1.GEMS_Effective_Date__c = system.today();
            accSubCase1.GEMS_Case_Effective_Date__c= system.today();
        }
        //accSubCase[0].GEMS_Submission_Type__c = 'New Account';
        update accSubCase;
        
        Case accStrCase = new Case();
        accStrCase.AccountId = accRec1.id;
        accStrCase.GEMS_Submission_Type__c = 'Renewal';
        accStrCase.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        accStrCase.GEMS_Account_Submission_Info__c = accSubCase[0].id;
        accStrCase.RecordTypeId = caseAccountStrId;
        accStrCase.Additional_Comments__c='test1';
        accStrCase.Status = 'Design In Progress';
        insert accStrCase;
        
        GEMS_Account_Structure_Response__c resp = new GEMS_Account_Structure_Response__c();
        resp.AccStructCaseId__c = accStrCase.Id;
        insert resp;
        
    } 
    
    private static testmethod void testRetrieveServiceForCall1() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        accStructureCase =[select id,RecordType.Name, Account.Id, Account.External_Id__c, Account_Number__c from case where GEMS_Submission_Type__c ='Renewal' and RecordType.Name ='GEMS Account Structure' and Additional_Comments__c = 'test1'];
        Case accCase = accStructureCase[0];     
        System.assertNotEquals(null, Account.External_Id__c);
        
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        
        GEMS_AccountRetrieveServiceOutput outService = new GEMS_AccountRetrieveServiceOutput();
        outService.status='S';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_AccountRetrieveServiceHelper.retrieveAccountStructure(accStructureCase[0].id, 'Call1', '');
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string body= '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
        
        res.setBody(body );
        res.setStatusCode(200);
        res.setStatus('S');
        map<string, string> responseHeader=null;
        FW_Service_Status serviceStatus = new FW_Service_Status();//null;
        serviceStatus.status='S';
        Object obj =res;
        GEMS_AccountRetrieveServiceCallout accountRetrieve = new GEMS_AccountRetrieveServiceCallout ();
        accountRetrieve.convertResponseToOutput(obj,responseHeader,serviceStatus);
        test.stoptest();        
    }
    
    private static testmethod void testRetrieveServiceForCall2() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        accStructureCase =[select id,RecordType.Name,Account.Id, Account_Number__c from case where GEMS_Submission_Type__c ='Renewal' and RecordType.Name ='GEMS Account Structure'];
        Case accCase = accStructureCase[0];
        System.assertNotEquals(null, accCase.Account_Number__c);
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        
        GEMS_AccountRetrieveServiceOutput outService = new GEMS_AccountRetrieveServiceOutput();
        outService.status='S';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_Account_Structure_Response__c resp = [Select Id from GEMS_Account_Structure_Response__c LIMIT 1];
        GEMS_AccountRetrieveServiceHelper.retrieveAccountStructure(accStructureCase[0].id, 'Call2', resp.id);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string body= '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
        
        res.setBody(body );
        res.setStatusCode(200);
        res.setStatus('S');
        map<string, string> responseHeader=null;
        FW_Service_Status serviceStatus = new FW_Service_Status();//null;
        serviceStatus.status='S';
        Object obj =res;
        GEMS_AccountRetrieveServiceCallout accountRetrieve = new GEMS_AccountRetrieveServiceCallout ();
        accountRetrieve.convertResponseToOutput(obj,responseHeader,serviceStatus);
        test.stoptest();        
    }
    
    private static testmethod void testRetrieveServiceForCall3() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        accStructureCase =[select id,RecordType.Name,Account.Id, Account_Number__c from case where GEMS_Submission_Type__c ='Renewal' and RecordType.Name ='GEMS Account Structure'];
        Case accCase = accStructureCase[0];
        System.assertNotEquals(null, accCase.Account_Number__c);
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        
        GEMS_AccountRetrieveServiceOutput outService = new GEMS_AccountRetrieveServiceOutput();
        outService.status='S';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_Account_Structure_Response__c resp = [Select Id from GEMS_Account_Structure_Response__c LIMIT 1];
        GEMS_AccountRetrieveServiceHelper.retrieveAccountStructure(accStructureCase[0].id, 'Call3', resp.id);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string body= '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
        
        res.setBody(body );
        res.setStatusCode(200);
        res.setStatus('S');
        map<string, string> responseHeader=null;
        FW_Service_Status serviceStatus = new FW_Service_Status();//null;
        serviceStatus.status='S';
        Object obj =res;
        GEMS_AccountRetrieveServiceCallout accountRetrieve = new GEMS_AccountRetrieveServiceCallout ();
        accountRetrieve.convertResponseToOutput(obj,responseHeader,serviceStatus);
        test.stoptest();        
    }
    
    private static testmethod void testRetrieveServiceWithoutAccNumber() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accStructureCase = [select id,RecordType.Name,Account.Id, Account.External_Id__c, Account_Number__c from case where GEMS_Submission_Type__c ='Renewal' and RecordType.Name ='GEMS Account Structure'];
        test.startTest();
        List<Account> accRecQuery=[SELECT ID, External_Id__c, name FROM Account WHERE recordtypeid=:recTypeId and External_Id__c = null];
        GEMS_Account_Structure_Response__c resp = [Select Id from GEMS_Account_Structure_Response__c LIMIT 1];
        
        Case accCase = accStructureCase[0];        
        accCase.AccountId = accRecQuery[0].id;
        System.assertEquals(null, accRecQuery[0].External_Id__c);
        update accCase;
        
        GEMS_AccountRetrieveServiceOutput outService = new GEMS_AccountRetrieveServiceOutput();
        outService.status='I';
        // test.startTest();
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_AccountRetrieveServiceHelper.retrieveAccountStructure(accStructureCase[0].id, 'Call2', resp.id);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string body= '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:getAccountStructureResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:getAccountStructureResponse></soap:Body></soap:Envelope>';
        
        res.setBody(body );
        res.setStatusCode(200);
        res.setStatus('I');
        map<string, string> responseHeader=null;
        FW_Service_Status serviceStatus = new FW_Service_Status();//null;
        serviceStatus.status='S';
        Object obj =res;
        GEMS_AccountRetrieveServiceCallout accountRetrieve = new GEMS_AccountRetrieveServiceCallout ();
        accountRetrieve.convertResponseToOutput(obj,responseHeader,serviceStatus);
        test.stoptest();        
    }
    
    private static testmethod void testUpdateCallDetailsInCase() {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Case> accStructureCase = [select id,RecordType.Name,Account.Id, Account.External_Id__c, Account_Number__c from case where GEMS_Submission_Type__c ='Renewal' and RecordType.Name ='GEMS Account Structure'];
        test.startTest();
        GEMS_AccountRetrieveServiceHelper.updateCallDetailsInCase(accStructureCase[0].Id, 'Successfully retrieved', System.now(), System.now().addDays(1), false);
        test.stoptest(); 
    }
}