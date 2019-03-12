/**************************************************************
Apex Class Name     : ServiceRequestControllerTest 
Version             : 1.0
Function            : This is a test class for ServiceRequestController
Modification Log    :
Developer                   Date            Description        
Padma Beadmpeta(HCSC)       6/14/2017       Service Request Hub on Group Account
Mark Naumann                09/23/2017      Custom Cases and Standard Cases
Zachary Campbell            09/29/2017      Split class into two methods to pass 101 SOQL errors.
Luke Chen                   12/26/2017      SFDC-7107 Tech Debt - Merge Opportunity Request Hub code to the Account Request Hub's
***************************************************************/
@isTest
public class ServiceRequestControllerTest {
    
    static testMethod void SRTest() {
        Account testAcntGrp = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
        testAcntGrp.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        testAcntGrp.HCSC_Division__c = 'IL';
        testAcntGrp.Status__c = 'Active';
        testAcntGrp.Account_Cluster_Name__c = 'Padma B';
        testAcntGrp.Account_Executive_2__c = 'Padma B';
        testAcntGrp.Distribution_Method__c = 'Directly To Group';
        testAcntGrp.AccountNumber = '8889990000';
        
        insert testAcntGrp;
        
        Account accountrec = [select id,Name,Account_Cluster_Name__c,Account_Executive_2__c,External_ID__c,HCSC_Division__c,
               Line_of_business__c,Market_Segment__c,AccountNumber,Sales_Team__c,RecordTypeId from Account where Id=:testAcntGrp.Id];
        
        Contact con = new Contact(LastName = 'Test');

        List<Case_Ids__c> cIDs = new List<Case_Ids__c>();
        Case_Ids__c cIDs1 = new Case_Ids__c();            
        cIDs1.Name = 'CaseAccExec';
        cIDs1.Field_Id__c = 'CF00N33000002yl4a';
        cIDs.add(cIDs1);
        Case_Ids__c cIDs2 = new Case_Ids__c();            
        cIDs2.Name = 'Division';
        cIDs2.Field_Id__c = '00N33000002yl63';
        cIDs.add(cIDs2);
  //    Case_Ids__c cIDs3 = new Case_Ids__c();            
  //    cIDs3.Name = 'LookUp_Id';
  //    cIDs3.Field_Id__c = 'AccountId';
  //    cIDs.add(cIDs3);
        Case_Ids__c cIDs4 = new Case_Ids__c();            
        cIDs4.Name = 'ObjectId';
        cIDs4.Field_Id__c = '500';
        cIDs.add(cIDs4);
        Case_Ids__c cIDs5 = new Case_Ids__c();            
        cIDs5.Name = 'Name';
        cIDs5.Field_Id__c = 'cas4';
        cIDs.add(cIDs5);
        Case_Ids__c cIDs6 = new Case_Ids__c();            
        cIDs6.Name = 'DistributionMethod';
        cIDs6.Field_Id__c = '00N330000038qYJ';
        cIDs.add(cIDs6);
        Case_Ids__c cIDs7 = new Case_Ids__c();            
        cIDs7.Name = 'Underwriter';
        cIDs7.Field_Id__c = 'CF00N33000002yl8P';
        cIDs.add(cIDs7);               
        Case_Ids__c cIDs8 = new Case_Ids__c();            
        cIDs8.Name = 'AccountNumber';
        cIDs8.Field_Id__c = '00N33000002yl4c';
        cIDs.add(cIDs8);         
        Case_Ids__c cIDs9 = new Case_Ids__c();            
        cIDs9.Name = 'ContractFullName';
        cIDs9.Field_Id__c = '00N33000003CfZF';
        cIDs.add(cIDs9);     
        Case_Ids__c cIDs10 = new Case_Ids__c();            
        cIDs10.Name = 'ContractTitle';
        cIDs10.Field_Id__c = '00N33000003CfZH';
        cIDs.add(cIDs10);               
        Case_Ids__c cIDs11 = new Case_Ids__c();            
        cIDs11.Name = 'ContractEmail';
        cIDs11.Field_Id__c = '00N33000003CfZE';
        cIDs.add(cIDs11);           
        insert cIDs;
            
        List<Task_Ids__c> tIDs = new List<Task_Ids__c>();
        Task_Ids__c tIDs1 = new Task_Ids__c();            
        tIDs1.Name = 'Name';
        tIDs1.Field_Id__c = 'tsk3_mlktp';
        tIDs.add(tIDs1);
        Task_Ids__c tIDs2 = new Task_Ids__c();            
        tIDs2.Name = 'ObjectId';
        tIDs2.Field_Id__c = '00T';
        tIDs.add(tIDs2);
        Task_Ids__c tIDs3 = new Task_Ids__c();            
        tIDs3.Name = 'RelatedToID';
        tIDs3.Field_Id__c = 'tsk3_lkid';
        tIDs.add(tIDs3);
        Task_Ids__c tIDs4 = new Task_Ids__c();            
        tIDs4.Name = 'RelatedToPicklist';
        tIDs4.Field_Id__c = 'sk3_mlktp';
        tIDs.add(tIDs4);
        Task_Ids__c tIDs5 = new Task_Ids__c();            
        tIDs5.Name = 'RelatedToText';
        tIDs5.Field_Id__c = 'tsk3';
        tIDs.add(tIDs5);
        insert tIDs;
        
        Service_Request__c SR = new Service_Request__c(Control_Par_Plan__c = 'V1',
                                                       Site_Location_of_event__c = 'Test',
                                                       //Site_Location_type__c ='Test',
                                                       //Contact_Person_on_employer_site__c = con.Id,
                                                       Date_of_Meeting__c = date.today(),
                                                       Enrollment_Contact_Info__c = 'Test',
                                                       Status__c = 'Staffed',
                                                       Type_of_Event__c = 'Other',
                                                       Marketing_Service_Rep__c = con.Id,
                                                       RecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('Open Enrollment').getRecordTypeId());
        
        String selectedvalue; 
        selectedvalue = 'Open Enrollment';

        system.debug('SR values---> ' +SR);
        List<Service_Request_Ids__c> CSobjlst = new List<Service_Request_Ids__c>();
        CSobjlst.add(new Service_Request_Ids__c(Name = 'ObjectId',Field_Id__c = 'SR.id'));        
        CSobjlst.add(new Service_Request_Ids__c(Name = 'Name',Field_Id__c = 'Account__c'));
        CSobjlst.add(new Service_Request_Ids__c(Name = 'LookUp_Id',Field_Id__c = 'accountrec.Id'));
        CSobjlst.add(new Service_Request_Ids__c(Name = 'Executive_Name_1',Field_Id__c = 'accountrec.Account_Cluster_Name__c'));
        CSobjlst.add(new Service_Request_Ids__c(Name = 'Executive_Name_2',Field_Id__c = 'accountrec.Account_Executive_2__c'));
        insert CSobjlst;
        
        Test.setCurrentPageReference(new PageReference('Page.ServiceRequestPage'));
        System.currentPageReference().getParameters().put('selectedrctyp', selectedvalue);     
        system.debug('SRCobj---> checkpoint');
        ServiceRequestController SRCobj = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj.selectedValue = 'Open Enrollment';
         
        Case AMCase = new Case();      
        AMCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        AMCase.AccountId = accountrec.Id;
        AMCase.type=selectedValue;
        AMCase.GEMS_Submission_Type__c = 'Cosmetic Account Maintenance';
        AMCase.GEMS_Submission_Sub_Type__c = 'Group Section and Billing Profile';
        insert AMCase;
        
        CaseComment cc = new CaseComment (ParentID = AMCase.id, isPublished=false);
        cc.CommentBody = 'Test Description';
        insert cc;
        
        Test.setCurrentPageReference(new PageReference('Page.ServiceRequestPage'));
        System.currentPageReference().getParameters().put('selectedrctyp', selectedvalue);     
        
        ServiceRequestController SRCobj1 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj1.selectedValue = 'Cosmetic Account Maintenance';
      // SRCobj1.selectedSubmSubTypOption = 'Contact Information';
        SRCobj1.CaseCommentdesc = 'Test comment';
        
        Account testAcntGrp1 = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
        testAcntGrp1.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        testAcntGrp1.HCSC_Division__c = 'IL';
        testAcntGrp1.Status__c = 'Active';
        testAcntGrp1.Status__c = 'Dormant';
        insert testAcntGrp1;
        
        Service_Request__c SR1 = new Service_Request__c(Control_Par_Plan__c = 'V1',
                                                       Site_Location_of_event__c = 'Test',
                                                       //Site_Location_type__c ='Test',
                                                       //Contact_Person_on_employer_site__c = con.Id,
                                                       Date_of_Meeting__c = date.today(),
                                                       Enrollment_Contact_Info__c = 'Test',
                                                       Status__c = 'Staffed',
                                                       Type_of_Event__c = 'Other',
                                                       Marketing_Service_Rep__c = con.Id);
        
        SR1.RecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('Open Enrollment').getRecordTypeId();
        String selectedvalue1; 
        selectedvalue1 = 'Open Enrollment';
        
        List<Service_Request_Ids__c> CSobjlst1 = new List<Service_Request_Ids__c>();
        CSobjlst1.add(new Service_Request_Ids__c(Name = 'ObjectId',Field_Id__c = 'SR.id'));        
        CSobjlst1.add(new Service_Request_Ids__c(Name = 'Name',Field_Id__c = 'Account__c'));
        CSobjlst1.add(new Service_Request_Ids__c(Name = 'LookUp_Id',Field_Id__c = 'accountrec.Id'));
        CSobjlst1.add(new Service_Request_Ids__c(Name = 'Executive_Name_1',Field_Id__c = 'accountrec.Account_Cluster_Name__c'));
        CSobjlst1.add(new Service_Request_Ids__c(Name = 'Executive_Name_2',Field_Id__c = 'accountrec.Account_Executive_2__c'));
        insert CSobjlst1;
        
        Test.setCurrentPageReference(new PageReference('Page.ServiceRequestPage'));
        System.currentPageReference().getParameters().put('selectedrctyp', selectedvalue1);     
        ServiceRequestController SRCobj2 = new ServiceRequestController(new ApexPages.StandardController(testAcntGrp1));
        SRCobj2.selectedvalue = 'Open Enrollment';
        
        Case LGNACase = new Case();      
        LGNACase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LGNA - General Case').getRecordTypeId();
        LGNACase.AccountId = accountrec.Id;
        LGNACase.type=selectedValue;
        insert LGNACase;  

        Test.setCurrentPageReference(new PageReference('Page.ServiceRequestPage'));
        System.currentPageReference().getParameters().put('selectedrctyp', selectedvalue);  

        ServiceRequestController SRCobj3 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj3.selectedValue = 'LGNA Case';
        SRCobj3.selectedLGNACaseOption = 'LGNA - General Case';

        test.startTest();
        SRCobj.createNewCase();        
        SRCobj1.createNewCase();        
        SRCobj2.createNewCase();        
        SRCobj3.createNewCase();
        SRCobj3.getLGNACaseOptions();
        test.stopTest();
    }
    
        static testMethod void SRTest1() {
        Account testAcntGrp = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
        testAcntGrp.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        testAcntGrp.HCSC_Division__c = 'IL';
        testAcntGrp.Status__c = 'Active';
        testAcntGrp.Account_Cluster_Name__c = 'Padma B';
        testAcntGrp.Account_Executive_2__c = 'Padma B';
        testAcntGrp.Distribution_Method__c = 'Directly To Group';
        testAcntGrp.AccountNumber = '8889990000';
        
        insert testAcntGrp;
        
        Account accountrec = [select id,Name,Account_Cluster_Name__c,Account_Executive_2__c,External_ID__c,HCSC_Division__c,
               Line_of_business__c,Market_Segment__c,AccountNumber,Sales_Team__c,RecordTypeId from Account where Id=:testAcntGrp.Id];
        
        Contact con = new Contact(LastName = 'Test');

        List<Case_Ids__c> cIDs = new List<Case_Ids__c>();
        Case_Ids__c cIDs1 = new Case_Ids__c();            
        cIDs1.Name = 'CaseAccExec';
        cIDs1.Field_Id__c = 'CF00N33000002yl4a';
        cIDs.add(cIDs1);
        Case_Ids__c cIDs2 = new Case_Ids__c();            
        cIDs2.Name = 'Division';
        cIDs2.Field_Id__c = '00N33000002yl63';
        cIDs.add(cIDs2);
    //    Case_Ids__c cIDs3 = new Case_Ids__c();            
    //    cIDs3.Name = 'LookUp_Id';
    //    cIDs3.Field_Id__c = 'AccountId';
    //    cIDs.add(cIDs3);
        Case_Ids__c cIDs4 = new Case_Ids__c();            
        cIDs4.Name = 'ObjectId';
        cIDs4.Field_Id__c = '500';
        cIDs.add(cIDs4);
        Case_Ids__c cIDs5 = new Case_Ids__c();            
        cIDs5.Name = 'Name';
        cIDs5.Field_Id__c = 'cas4';
        cIDs.add(cIDs5);
        Case_Ids__c cIDs6 = new Case_Ids__c();            
        cIDs6.Name = 'DistributionMethod';
        cIDs6.Field_Id__c = '00N330000038qYJ';
        cIDs.add(cIDs6);
        Case_Ids__c cIDs7 = new Case_Ids__c();            
        cIDs7.Name = 'Underwriter';
        cIDs7.Field_Id__c = 'CF00N33000002yl8P';
        cIDs.add(cIDs7);        
        
        Case_Ids__c cIDs8 = new Case_Ids__c();            
        cIDs8.Name = 'AccountNumber';
        cIDs8.Field_Id__c = '00N33000002yl4c';
        cIDs.add(cIDs8);         
        Case_Ids__c cIDs9 = new Case_Ids__c();            
        cIDs9.Name = 'ContractFullName';
        cIDs9.Field_Id__c = '00N33000003CfZF';
        cIDs.add(cIDs9);     
        Case_Ids__c cIDs10 = new Case_Ids__c();            
        cIDs10.Name = 'ContractTitle';
        cIDs10.Field_Id__c = '00N33000003CfZH';
        cIDs.add(cIDs10);               
        Case_Ids__c cIDs11 = new Case_Ids__c();            
        cIDs11.Name = 'ContractEmail';
        cIDs11.Field_Id__c = '00N33000003CfZE';
        cIDs.add(cIDs11);           
 
        insert cIDs;
            
        List<Task_Ids__c> tIDs = new List<Task_Ids__c>();
        Task_Ids__c tIDs1 = new Task_Ids__c();            
        tIDs1.Name = 'Name';
        tIDs1.Field_Id__c = 'tsk3_mlktp';
        tIDs.add(tIDs1);
        Task_Ids__c tIDs2 = new Task_Ids__c();            
        tIDs2.Name = 'ObjectId';
        tIDs2.Field_Id__c = '00T';
        tIDs.add(tIDs2);
        Task_Ids__c tIDs3 = new Task_Ids__c();            
        tIDs3.Name = 'RelatedToID';
        tIDs3.Field_Id__c = 'tsk3_lkid';
        tIDs.add(tIDs3);
        Task_Ids__c tIDs4 = new Task_Ids__c();            
        tIDs4.Name = 'RelatedToPicklist';
        tIDs4.Field_Id__c = 'sk3_mlktp';
        tIDs.add(tIDs4);
        Task_Ids__c tIDs5 = new Task_Ids__c();            
        tIDs5.Name = 'RelatedToText';
        tIDs5.Field_Id__c = 'tsk3';
        tIDs.add(tIDs5);
        insert tIDs;
        
        Service_Request__c SR = new Service_Request__c(Control_Par_Plan__c = 'V1',
                                                       Site_Location_of_event__c = 'Test',
                                                       //Site_Location_type__c ='Test',
                                                       //Contact_Person_on_employer_site__c = con.Id,
                                                       Date_of_Meeting__c = date.today(),
                                                       Enrollment_Contact_Info__c = 'Test',
                                                       Status__c = 'Staffed',
                                                       Type_of_Event__c = 'Other',
                                                       Marketing_Service_Rep__c = con.Id,
                                                       RecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('Open Enrollment').getRecordTypeId());
        
        String selectedvalue; 
        selectedvalue = 'Open Enrollment';

        system.debug('SR values---> ' +SR);
        List<Service_Request_Ids__c> CSobjlst = new List<Service_Request_Ids__c>();
        CSobjlst.add(new Service_Request_Ids__c(Name = 'ObjectId',Field_Id__c = 'SR.id'));        
        CSobjlst.add(new Service_Request_Ids__c(Name = 'Name',Field_Id__c = 'Account__c'));
        CSobjlst.add(new Service_Request_Ids__c(Name = 'LookUp_Id',Field_Id__c = 'accountrec.Id'));
        CSobjlst.add(new Service_Request_Ids__c(Name = 'Executive_Name_1',Field_Id__c = 'accountrec.Account_Cluster_Name__c'));
        CSobjlst.add(new Service_Request_Ids__c(Name = 'Executive_Name_2',Field_Id__c = 'accountrec.Account_Executive_2__c'));
        insert CSobjlst;
        
        Test.setCurrentPageReference(new PageReference('Page.ServiceRequestPage'));
        System.currentPageReference().getParameters().put('selectedrctyp', selectedvalue);     
        ServiceRequestController SRCobj4 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj4.selectedValue = 'LGNA Case';
        SRCobj4.selectedLGNACaseOption = 'Private Exchange - External';

        ServiceRequestController SRCobj5 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj5.selectedValue = 'CSS Task';
        
        ServiceRequestController SRCobj6 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj6.selectedValue = 'Cancellation';

        ServiceRequestController SRCobj7 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj7.selectedValue = 'Contract Admin';
        SRCobj7.tempContractType= 'Custom Contracts';
        
        ServiceRequestController SRCobj8 = new ServiceRequestController(new ApexPages.StandardController(accountrec));
        SRCobj8.selectedValue = 'Contract Admin';
        SRCobj8.tempContractType = 'Standard Contracts';
        
        test.startTest();
        SRCobj4.createNewCase();
        SRCobj4.getLGNACaseOptions();        
        SRCobj5.createNewCase();        
        SRCobj6.AccountCancellation();
        SRCobj6.getCancellationOptions();
        SRCobj7.createNewCase();    
        SRCobj8.createNewCase();  
        test.stopTest();
    }
        
        static testmethod void testOppContractAdminRequest(){    
            test.startTest();
            List<Case> accSubCase;
            Account accRec;
            product2 prd;
            case cs2;
            Opportunity oppRec;
            Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            List<User> userList = new List<User>();
            User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
            User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2@user11.com', 'testUser2', 'test2@user.com');
            User testUser3 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test3@user11.com', 'testUser3', 'test3@user.com');
            User testUser4 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test4@user11.com', 'testUser4', 'test4@user.com');
            User testUser5 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test5@user11.com', 'testUse5', 'test5@user.com');
            User testUser6 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test6@user11.com', 'testUser6', 'test6@user.com');
            User testUser7 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test7@user11.com', 'testUser7', 'test7@user.com');
            User testUser8 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test8@user11.com', 'testUse8', 'test8@user.com');
            User testUser9 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test9@user11.com', 'testUser9', 'test9@user.com');
            User testUser10 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test10@user11.com', 'testUser10', 'test10@user.com');
            User testUser11 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test11@user11.com', 'testUser11', 'test11@user.com');
            User testUser12 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
            User testUser13 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test13@user11.com', 'testUser13', 'test13@user.com');
            User testUser14 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test14@user11.com', 'testUser14', 'test14@user.com');
            User testUser15 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test15@user11.com', 'testUser15', 'test15@user.com');
            User testUser16 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test16@user11.com', 'testUser16', 'test16@user.com');
            User testUser17 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test17@user11.com', 'testUser17', 'test17@user.com');
            User testUser18 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test18@user11.com', 'testUser18', 'test18@user.com');        
            userList.add(testUser1);
            userList.add(testUser2);
            userList.add(testUser3);
            userList.add(testUser4);
            userList.add(testUser5);
            userList.add(testUser6);
            userList.add(testUser7);
            userList.add(testUser8);
            userList.add(testUser9);
            userList.add(testUser10);
            userList.add(testUser11);
            userList.add(testUser12);
            userList.add(testUser13);
            userList.add(testUser14);
            userList.add(testUser15);
            userList.add(testUser16);
            userList.add(testUser17);
            userList.add(testUser18);        
            insert userList;
            accRec = new Account();
            accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            accRec.Name = 'TestAccountForOppReqHub';
            accRec.Group_Number__c= 'B06093';
            accRec.external_id__c= 'B06093';
            accRec.BillingStreet ='Testing';
            accRec.BillingCity='TX';
            accRec.BillingState='CT';
            accRec.BillingPostalCode='534323';
            accRec.status__c = 'Active';
            accRec.AccountNumber = '012456';
            accRec.Market_Segment__c = 'FEP';
            AccRec.District__c = '038';
            AccRec.Cluster__c = '005';
            AccRec.HCSC_Division__c = 'IL';
            AccRec.Open_Enrollment_Date__c = system.today();
            insert accRec;
                   
            List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE name='TestAccountForOppReqHub' LIMIT 1];
            System.assertEquals('TestAccountForOppReqHub',accRecQuery[0].Name);
            
            List<String> accountTeamRoleList = new  List<String>();
                   
            accountTeamRoleList.add('Account Specialist');
            accountTeamRoleList.add('Benefit Coder');
            accountTeamRoleList.add('Accounts Receivable');
            accountTeamRoleList.add('Electronic Eligibility Specialist');
            accountTeamRoleList.add('Strategic Account Executive'); 
            accountTeamRoleList.add('Client Service Specialist'); 
            accountTeamRoleList.add('Client Implementation Consultant');
            accountTeamRoleList.add('Sales Executive'); 
            accountTeamRoleList.add('Director Account Management'); 
            accountTeamRoleList.add('VP Account Management');
            accountTeamRoleList.add('Underwriter');
            accountTeamRoleList.add('Account Executive');
            accountTeamRoleList.add('Client Service Specialist.');
            accountTeamRoleList.add('Medical Underwriter');
            //accountTeamRoleList.add('Additional Underwriter');
            //accountTeamRoleList.add('Dental Underwriter');
            //accountTeamRoleList.add('Medical Underwriter'); 
            //accountTeamRoleList.add('Additional Medical Underwriter'); 

            List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
            for(Integer i=0; i<=13;i++)
            {
                AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
                accTeamMemberAccSpecialist.UserId =userList[i].id;
                accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[i];
                accTeamMemberAccSpecialist.AccountId =accRec.id;
                accTeamMemberList.add(accTeamMemberAccSpecialist);

                }
            
            insert accTeamMemberList;
            System.assertEquals('Account Specialist',accTeamMemberList[0].TeamMemberRole);
            List<AccountTeamMember> accTeamMemberQuery=[SELECT Id, AccountId, TeamMemberRole from AccountTeamMember WHERE AccountId=:accRecQuery[0].id LIMIT 1];
            
            
            oppRec = new Opportunity();
            oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            oppRec.Name='CaseTriggerHandler';
            oppRec.accountId=accRecQuery[0].Id;
            oppRec.Type='Other';
            oppRec.StageName=GEMS_UtilityClassTest.opportunityStatus();//'In Progress';
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
            insert oppRec;
            
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            case cs = new case();
            cs.accountid = accRecQuery[0].Id;
            cs.recordtypeid = caseAccountSubmissionId;
            cs.status = 'New';
            insert cs;
            Test.setCurrentPageReference(new PageReference('Page.ServiceRequestPage'));
            System.currentPageReference().getParameters().put('id', accRecQuery[0].Id);
            System.currentPageReference().getParameters().put('OpportunityId', oppRec.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(accRecQuery[0]);
            ServiceRequestController oppController = new ServiceRequestController(sc);
            oppController.selectedValue = 'Contract Admin Request';
            oppController.selectedSubCat = 'Custom SBC or Benefit Booklets';
            System.assertNotEquals(null,oppController.createRequest());
            // below to test opp that already has one request existing, cannot create 2nd request
            System.assertEquals(null,oppController.createRequest());
            
            test.stopTest();
        }        

}