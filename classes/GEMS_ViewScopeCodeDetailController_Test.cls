/*
* 5/13/2018		Luke Chen				SFDC-6944 GEMS: Account Setup - Allow AS to re-assign their task on Scope Code page
*/
@isTest
    private class GEMS_ViewScopeCodeDetailController_Test{  
    
    static public List<Case> accSubCase;
    static public Account accRec;
    static public List<User> testuser;
    static public product2 prd;
    static public case cs2;
    static public List<case> accStructureCase;
    @testSetup
    static void dataSetup() {

        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;

        accRec = new Account();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.RecordTypeId = recTypeId;
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        
        Account accRec1 = new Account();
        accRec1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec1.Name = 'TestAccountForCaseTriggerHandler1';
        accRec1.Group_Number__c= 'B060931';
        accRec1.external_id__c= 'B0609';
        accRec1.BillingStreet ='Testing';
        accRec1.BillingCity='TX';
        accRec1.BillingState='CT';
        accRec1.BillingPostalCode='534323';
        accRec1.status__c = 'Active';
        
                                
        List<Account> acclist = new List<Account>();
        acclist.add(accRec);
        acclist.add(accRec1);
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
        oppRec.StageName=GEMS_UtilityClassTest.opportunityStatus();//'In Progress';
        oppRec.Date_Closed__c = system.today();
        oppRec.Exchange_Offering_Type__c='No Private Exchange';
        oppRec.CloseDate=Date.Today().addDays(8);
        oppRec.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppRec.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppRec.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppRec.Expected_Health_Members__c=2;
        oppRec.Account_Market_Segment__c='LG';
        oppRec.HCSC_Division__c='TX';
        oppRec.Region__c='N/A - IL';
        oppRec.District__c='290';
        oppRec.Clusters__c='020';
        oppRec.Primary_Closed_Reason__c='Other';
                                
        optyList.add(oppRec);
        insert optyList;
                                
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
       
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<case> caseList = new List<case>();
        case cs = new case();
        cs.accountid = accRecQuery[0].Id;
        cs.Opportunity_Name__c= oppRec.id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        
        case cs1 = new case();
        cs1.accountid = accRecQuery[1].Id;
        cs1.Opportunity_Name__c= oppRec.id;
        cs1.recordtypeid = caseAccountSubmissionId;
        cs1.status = 'New';
                case cs3 = new case();
        cs3.accountid = accRecQuery[1].Id;
        cs3.Opportunity_Name__c= oppRec.id;
        cs3.recordtypeid = caseAccountSubmissionId;
        cs3.status = 'New';
        
        
        caseList.add(cs);
        caseList.add(cs1);
        caseList.add(cs3);
        insert caseList;
        
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
        System.assertEquals('GEMS Account Submission',accSubCase[1].RecordType.Name); 
        integer i=0;
        for(case accSubCase1:accSubCase ){
        accSubCase1.Status ='In Progress';
        accSubCase1.GEMS_Create_Account_Structure__c =true;
        accSubCase1.GEMS_Submission_Type__c = 'Renewal';
        accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        accSubCase1.GEMS_Products__c ='Dental;PPO;RX';
        accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
        accSubCase1.GEMS_Line_of_Business__c='ENA';
        accSubCase1.GEMS_Effective_Date__c = system.today();
        accSubCase1.GEMS_Case_Effective_Date__c= system.today();
        accSubCase1.GEMS_SBC_Required__c = 'Yes';
        
       }
       accSubCase[0].GEMS_Submission_Type__c = 'Renewal';
       accSubCase[0].HCSC_Division__c = 'TX';
       accSubCase[1].HCSC_Division__c = 'TX';
       accSubCase[2].HCSC_Division__c = 'TX';
       update accSubCase;
       accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];

    } 
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test2()
    {
        test.startTest(); 
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='No Scope Code Changes';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Pharmacy Scope Code';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.GEMS_end_date__c = System.now();
        taskObj.whatId = gemsPhRec.Id;
        taskObj.ownerId = testuser[0].Id; 
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
                        
        insert taskList; 
              
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testuser[0]12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode();    
        test.stopTest();  

    }
     private static testmethod void GEMS_ViewScopeCodeDetailController_Test21()
    {
         
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Status__c='Prime Build Started';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Prime Build';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        insert taskList; 
        test.startTest();    
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        taskObj1.subject = 'Prime Build';

        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.taskList = taskList;
        scopectrl.UpdateTasks();
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode();
        scopectrl.approvalProcess();
        scopectrl.updateStatus();
        test.stopTest();  

    }
     private static testmethod void GEMS_ViewScopeCodeDetailController_Test22(){
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = null;
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Prime Build Started';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Status__c='Prime Build Started';
        gemsRec.Prime_Certify_Date__c =null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Prime Build';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
                        
        insert taskList; 
        test.startTest();       
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.tasklist = tasklist;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        test.stopTest();  
    }
     private static testmethod void GEMS_ViewScopeCodeDetailController_Test23()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Prime Build Started';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='Prime Build Started';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Prime Build';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
       
        insert taskList; 
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.tasklist = tasklist;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        test.stopTest();  
 
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test25()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Update BlueSTAR & AS400 Started';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='Update BlueSTAR & AS400 Started';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Update BlueSTAR & AS400';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
       
        insert taskList; 
        test.startTest();      
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.tasklist = tasklist;
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 1;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        test.stopTest();  
 
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test25_1()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Update BlueSTAR & AS400 Started12';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='Update BlueSTAR & AS400 Started';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started12';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Update BlueSTAR & AS400';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        insert taskList; 
        test.startTest();       
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.tasklist = tasklist;
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 1;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.selectParamVal ='Yes';
        scopectrl.UpdateTasks();
        }
        test.stopTest();  
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test26()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX']; 
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='In Progress';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='In Progress';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Update BlueSTAR & AS400';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        
        task taskObj2 = new task();
        taskObj2.status = 'Not Started';
        taskObj2.subject = 'Peer Review';
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';
        taskList.add(taskObj2);
       
        task taskObj3 = new task();
        taskObj3.status = 'Completed';
        taskObj3.subject = 'Prime Build';
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'Completed';
        taskObj4.subject = 'AS400 & BlueStar Verification';
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'Not Started';
        taskObj5.subject = 'BlueStar Update';
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';
        taskList.add(taskObj5);
 
        insert taskList; 
        test.startTest();       
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.tasklist = tasklist;
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 2;
        scopectrl.selectparamVal = 'NA';
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        test.stopTest();  
 
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test27()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Update BlueSTAR & AS400 Started';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Update_AS400__c = false;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='Update BlueSTAR & AS400 Started';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started';
        gemsRec.Update_AS400__c = false;
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Update BlueSTAR & AS400';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        
         task taskObj2 = new task();
        taskObj2.status = 'Not Started';
        taskObj2.subject = 'Peer Review';
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';
        taskList.add(taskObj2);
 
        insert taskList; 
        test.startTest();      
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        //insert usr;
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.tasklist = tasklist;
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 2;
        scopectrl.selectparamVal = 'No';
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        scopectrl.SaveScopeCode();
        }
        test.stopTest();  
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test28()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX']; 
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(accSubCase[0].Id,'Account Specialist');
        caseTeamAccSpecMem.memberId = userInfo.getuserId();
        insert caseTeamAccSpecMem;
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Temp';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='In Progress';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='In Progress';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Started12';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Account Specialist BlueStar Update';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        
        task taskObj2 = new task();
        taskObj2.status = 'In Progress';
        taskObj2.subject = 'Peer Review';
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';
        taskList.add(taskObj2);
 
        insert taskList; 
        Pagereference pf = page.GEMSViewScopeDetail;
        Test.setCurrentPage(pf);
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        scopectrl.CurrentUserId = userinfo.getuserid();
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 2;
        scopectrl.selectparamVal = 'Yes';
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateAccountSpecialistTasks();
        scopectrl.SaveScopeCode();

        test.stopTest();  
 
    }
     private static testmethod void GEMS_ViewScopeCodeDetailController_Test29()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];

        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(accSubCase[0].Id,'Account Specialist');
        caseTeamAccSpecMem.memberId = userInfo.getuserId();
        insert caseTeamAccSpecMem;
        
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Temp';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Prime Build Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;

        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='In Progress';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Completed';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Update BlueSTAR & AS4001';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        
        task taskObj2 = new task();
        taskObj2.status = 'Not Started';
        taskObj2.subject = 'Peer Review';
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';
        taskList.add(taskObj2);
        
        task taskObj3 = new task();
        taskObj3.status = 'In Progress';
        taskObj3.subject = 'Account Specialist Review';
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Prime Build';
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';
        taskList.add(taskObj4);

        insert taskList; 
        Pagereference pf = page.GEMSViewScopeDetail;
        Test.setCurrentPage(pf);
        test.startTest();       
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        List<GEMS_Pharmacy_Scope_Code__c> scopeCodeList = new List<GEMS_Pharmacy_Scope_Code__c>{gemsRec};
        scopectrl.AllScopeCodes=scopeCodeList ;
        Scopectrl.listOfAccountSpecialistTasks = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        scopectrl.CurrentUserId = caseTeamAccSpecMem.memberid;
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 2;
        scopectrl.selectparamVal = 'Yes';
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.CreateAccountSpecialistTask();
        scopectrl.StartAccountSpecialistTasks();
        scopectrl.taskList = taskList;
        scopectrl.StartPrimeBuild();
        scopectrl.CancelScopeCode();
        scopectrl.selectedVal =0;
        test.stopTest();    
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test30()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX']; 
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(accSubCase[0].Id,'Account Specialist');
        caseTeamAccSpecMem.memberId = userInfo.getuserId();
        insert caseTeamAccSpecMem;
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Temp';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c = system.today();
        gemsPhRec.Prime_Plan_ID__c=null;
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Prime Build Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        insert gemsPhRec;

        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Status__c='In Progress';
        gemsRec.Prime_Plan_ID__c=null;
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Status__c='Prime Build Completed';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'Not Started';
        taskObj1.subject = 'Update BlueSTAR & AS4001';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
 
        insert taskList; 
        Pagereference pf = page.GEMSViewScopeDetail;
        Test.setCurrentPage(pf);
        test.startTest();       
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        List<GEMS_Pharmacy_Scope_Code__c> scopeCodeList = new List<GEMS_Pharmacy_Scope_Code__c>{gemsRec};
        scopectrl.AllScopeCodes=scopeCodeList ;
        Scopectrl.listOfAccountSpecialistTasks = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        scopectrl.CurrentUserId = caseTeamAccSpecMem.memberid;
        scopectrl.listOfAccountSpecialistTasks = tasklist;
        scopectrl.NumberOfAccSpecTasks = 1;
        scopectrl.selectparamVal = 'Yes';
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.CreateAccountSpecialistTask();

        test.stopTest();    
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test31()
    {
        test.startTest(); 
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'Peer Review Pending';
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'Complete';
        taskObj.subject = 'Pharmacy Scope Code';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.GEMS_end_date__c = System.now();
        taskObj.whatId = gemsPhRec.Id;
        taskObj.ownerId = testuser[0].Id; 
        taskObj.Priority = 'Normal';                        
        taskList.add(taskObj);
                      
        task taskObj2 = new task();
        taskObj2.status = 'In Progress';
        taskObj2.subject = 'BET Creation';
        taskObj2.GEMS_start_date__c = System.now();
        taskObj2.GEMS_end_date__c = System.now();
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';                       
        taskList.add(taskObj2);
        
        
        
        task taskObj3 = new task();
        taskObj3.status = 'In Progress';
        taskObj3.subject = 'Prime Build';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);
        
        
        insert taskList; 
        
        
              
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        scopectrl.listOfAccountSpecialistTasks = taskList;
        //scopectrl.taskList = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testuser[0]12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        gemsRec.Peer_Reviewer__c = usr.id;
        gemsPhRec.Peer_Reviewer__c = usr.id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        //scopectrl.Peer_Reviewer__c  = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        scopectrl.approvalProcess();
        //scopectrl.options=new list<SelectOption>();
        //scopectrl.peerReviewer= testuser[0].id;
        list<selectOption> testOptions = scopectrl.Options;
        scopectrl.UpdateAccountSpecialistTaskOwner();  // SFDC-6944
        scopectrl.UpdateAccountSpecialistTasks();       
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode(); 
        scopectrl.ListOfBACases=null;
        scopectrl.StartPrimeBuild();        
        test.stopTest();  
    }

    private static testmethod void GEMS_ViewScopeCodeDetailController_Test32()
    {
        test.startTest(); 
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='BET Creation Started';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'BET Creation Started';
        insert gemsRec;

        GEMS_Pharmacy_Scope_Code__c gemsNoScope = new GEMS_Pharmacy_Scope_Code__c();
        gemsNoScope.Case__c = accStructureCase[0].id;
        gemsNoScope.Name='1000';
        gemsNoScope.Temp__c=true;
        gemsNoScope.Type__c='Permanent';
        gemsNoScope.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsNoScope.Retail__c='No Retail Benefits';
        gemsNoScope.Copay_Type__c='Flat';
        gemsNoScope.Rider_Code__c='00';
        gemsNoScope.Scope_Status__c='No Scope Code Changes';
        gemsNoScope.Peer_Review_Reject_Counter__c=0;
        gemsNoScope.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsNoScope.Formulary_Type__c='Basic';
        gemsNoScope.Prime_Certify_Date__c=system.today();
        gemsNoScope.Prime_Plan_ID__c='123456';
        gemsNoScope.Report_Format_Code__c='P';
        gemsNoScope.Comments__c='Comments';
        gemsNoScope.Group_Pay_Code__c = '1000';
        gemsNoScope.Status__c='In Progress';
        gemsNoScope.ownerId = testuser[0].Id;
        gemsNoScope.Peer_Reviewer__c = testuser[0].id;
        insert gemsNoScope;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Pharmacy Scope Code';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.GEMS_end_date__c = System.now();
        taskObj.whatId = gemsNoScope.Id;
        taskObj.ownerId = testuser[0].Id; 
        taskObj.Priority = 'Normal';                        
        taskList.add(taskObj);
                      
        task taskObj2 = new task();
        taskObj2.status = 'In Progress';
        taskObj2.subject = 'BET Creation';
        taskObj2.GEMS_start_date__c = System.now();
        taskObj2.GEMS_end_date__c = System.now();
        taskObj2.whatId = gemsRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';                       
        taskList.add(taskObj2);
        
        
        
        task taskObj3 = new task();
        taskObj3.status = 'In Progress';
        taskObj3.subject = 'Prime Build';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);

        task taskObj6 = new task();
        taskObj6.status = 'In Progress';
        taskObj6.subject = 'Peer Review';
        taskObj6.GEMS_start_date__c = System.now();
        taskObj6.GEMS_end_date__c = System.now();
        taskObj6.whatId = gemsPhRec.Id;
        taskObj6.ownerId = testuser[0].Id; 
        taskObj6.Priority = 'Normal';
        taskList.add(taskObj6);
        
        insert taskList; 
        
        
              
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsNoScope;
        scopectrl.PermScopeCodeRecord=gemsNoScope;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        scopectrl.listOfAccountSpecialistTasks = taskList;
        //scopectrl.taskList = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testuser[0]12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        gemsRec.Peer_Reviewer__c = usr.id;
        gemsPhRec.Peer_Reviewer__c = usr.id;
        scopectrl.PermScopeCodeRecord = gemsNoScope;
        scopectrl.CurrentUserId = testuser[0].id;
        //scopectrl.Peer_Reviewer__c  = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        scopectrl.approvalProcess();
        //scopectrl.options=new list<SelectOption>();
        //scopectrl.peerReviewer= testuser[0].id;
        list<selectOption> testOptions = scopectrl.Options;
        scopectrl.UpdateAccountSpecialistTasks();       
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode(); 
        scopectrl.ListOfBACases=null;
        scopectrl.StartPrimeBuild();        
        test.stopTest();  
    }

    private static testmethod void GEMS_ViewScopeCodeDetailController_Test33()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='BET Creation Started';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'BET Creation Started';
        insert gemsRec;

        List<Task> taskList = new List<Task>();
                      
        task taskObj2 = new task();
        taskObj2.status = 'Completed';
        taskObj2.subject = 'BET Creation';
        taskObj2.GEMS_start_date__c = System.now();
        taskObj2.GEMS_end_date__c = System.now();
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';                       
        taskList.add(taskObj2);
        
        
        
        task taskObj3 = new task();
        taskObj3.status = 'Completed';
        taskObj3.subject = 'Prime Build';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'Completed';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'Completed';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);

        task taskObj6 = new task();
        taskObj6.status = 'Completed';
        taskObj6.subject = 'Peer Review';
        taskObj6.GEMS_start_date__c = System.now();
        taskObj6.GEMS_end_date__c = System.now();
        taskObj6.whatId = gemsPhRec.Id;
        taskObj6.ownerId = testuser[0].Id; 
        taskObj6.Priority = 'Normal';
        taskList.add(taskObj6);
        
        insert taskList; 
        
        test.startTest(); 
              
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        scopectrl.listOfAccountSpecialistTasks = taskList;
        //scopectrl.taskList = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testuser[0]12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        gemsRec.Peer_Reviewer__c = usr.id;
        gemsPhRec.Peer_Reviewer__c = usr.id;
        scopectrl.PermScopeCodeRecord = gemsPhRec;
        scopectrl.CurrentUserId = testuser[0].id;
        //scopectrl.Peer_Reviewer__c  = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        scopectrl.approvalProcess();
        //scopectrl.options=new list<SelectOption>();
        //scopectrl.peerReviewer= testuser[0].id;
        list<selectOption> testOptions = scopectrl.Options;
        scopectrl.UpdateAccountSpecialistTasks();       
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode(); 
        scopectrl.ListOfBACases=null;
        scopectrl.StartPrimeBuild();        
        test.stopTest();  
    }
    
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test34()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'Peer Review Pending';
        insert gemsRec;
    
        List<Task> taskList = new List<Task>();
                      
        task taskObj2 = new task();
        taskObj2.status = 'In Progress';
        taskObj2.subject = 'BET Creation';
        taskObj2.GEMS_start_date__c = System.now();
        taskObj2.GEMS_end_date__c = System.now();
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';                       
        taskList.add(taskObj2);
        
        task taskObj3 = new task();
        taskObj3.status = 'In Progress';
        taskObj3.subject = 'Prime Build';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);

        task taskObj6 = new task();
        taskObj6.status = 'In Progress';
        taskObj6.subject = 'Peer Review';
        taskObj6.GEMS_start_date__c = System.now();
        taskObj6.GEMS_end_date__c = System.now();
        taskObj6.whatId = gemsPhRec.Id;
        taskObj6.ownerId = testuser[0].Id; 
        taskObj6.Priority = 'Normal';
        taskList.add(taskObj6);
        
        insert taskList; 
        
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        taskObj2.subject = 'BET Creation';

        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.taskList = taskList;
        scopectrl.UpdateTasks();
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode();
        scopectrl.approvalProcess();
        scopectrl.updateStatus();        
        test.stopTest();  
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test35()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'Peer Review Pending';
        insert gemsRec;
    
        List<Task> taskList = new List<Task>();
        
        task taskObj3 = new task();
        taskObj3.status = 'In Progress';
        taskObj3.subject = 'Prime Build';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);
        insert taskList; 
        
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        taskObj3.subject = 'Prime Build';

        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.taskList = taskList;
        scopectrl.UpdateTasks();
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode();
        scopectrl.approvalProcess();
        scopectrl.updateStatus();        
        test.stopTest();  
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test36()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'Peer Review Pending';
        insert gemsRec;
    
        List<Task> taskList = new List<Task>();
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);

        task taskObj6 = new task();
        taskObj6.status = 'In Progress';
        taskObj6.subject = 'Peer Review';
        taskObj6.GEMS_start_date__c = System.now();
        taskObj6.GEMS_end_date__c = System.now();
        taskObj6.whatId = gemsPhRec.Id;
        taskObj6.ownerId = testuser[0].Id; 
        taskObj6.Priority = 'Normal';
        taskList.add(taskObj6);
        
        insert taskList; 
        
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        taskObj6.subject = 'Peer Review';

        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.taskList = taskList;
        scopectrl.UpdateTasks();
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode();
        scopectrl.approvalProcess();
        scopectrl.updateStatus();        
        test.stopTest();  
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test37()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'Peer Review Pending';
        insert gemsRec;
    
        List<Task> taskList = new List<Task>();
                      
        task taskObj2 = new task();
        taskObj2.status = 'In Progress';
        taskObj2.subject = 'BET Creation';
        taskObj2.GEMS_start_date__c = System.now();
        taskObj2.GEMS_end_date__c = System.now();
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testuser[0].Id; 
        taskObj2.Priority = 'Normal';                       
        taskList.add(taskObj2);
        
        insert taskList; 
        
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        scopectrl.listOfAccountSpecialistTasks = taskList;
        //scopectrl.taskList = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testuser[0]12', 'test12@user.com');
        system.runas(usr) {
        try{
        gemsRec.ownerid = testuser[0].id;
        gemsRec.Peer_Reviewer__c = usr.id;
        gemsPhRec.Peer_Reviewer__c = usr.id;
        scopectrl.PermScopeCodeRecord = gemsPhRec;
        scopectrl.CurrentUserId = usr.id;
        scopectrl.PermScopeCodeRecord.Peer_Reviewer__c  = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();}
        catch(exception qe)// exception handling
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.error, qe.getMessage());
            ApexPages.addMessage(msg);
        }
        }        
        test.stopTest();  
    }
    private static testmethod void GEMS_ViewScopeCodeDetailController_Test38()
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        system.assertequals('Pharmacy Scope Coding Completed',gemsPhRec.Status__c);
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'Peer Review Pending';
        insert gemsRec;
    
        List<Task> taskList = new List<Task>();
        
        task taskObj3 = new task();
        taskObj3.status = 'In Progress';
        taskObj3.subject = 'Prime Build';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);
        
        task taskObj4 = new task();
        taskObj4.status = 'In Progress';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';    
        taskObj4.GEMS_Type__C='Pharmacy Scope Code Account Specialist';                   
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);
        insert taskList; 
        
        test.startTest(); 
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.listOfAccountSpecialistTasks.add(taskObj4);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        gemsRec.ownerid = testuser[0].id;
        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.CurrentUserId = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        taskObj3.subject = 'Prime Build';
        taskObj4.status = 'In Progress';

        scopectrl.PermScopeCodeRecord = gemsRec;
        scopectrl.taskList = taskList;
        scopectrl.UpdateTasks();
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode();       
        test.stopTest();       
    }

    private static testmethod void GEMS_ViewScopeCodeDetailController_Test39()
    {
        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        testUser =[Select Id,UserName From User where ProfileId= :profileRec2.id];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        
       
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = accStructureCase[0].id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='BET Creation Started';
        gemsPhRec.ownerId = testuser[0].Id;
        gemsPhRec.Peer_Reviewer__c = testuser[0].id;
        insert gemsPhRec;
        
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = accStructureCase[0].id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser[0].Id;
        gemsRec.Peer_Reviewer__c = testuser[0].id;
        gemsRec.status__c = 'BET Creation Started';
        insert gemsRec;

        List<Task> taskList = new List<Task>();
        
        task taskObj4 = new task();
        taskObj4.status = 'Completed';
        taskObj4.subject = 'Account Specialist Review';
        taskObj4.GEMS_start_date__c = System.now();
        taskObj4.GEMS_end_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testuser[0].Id; 
        taskObj4.Priority = 'Normal';                       
        taskList.add(taskObj4);
        
        task taskObj6 = new task();
        taskObj6.Status = 'Not Started';
        taskObj6.Subject = 'Update BlueSTAR & AS400';
        taskObj6.GEMS_start_date__c = System.now();
        taskObj6.GEMS_end_date__c = System.now();
        taskObj6.WhatId = gemsPhRec.Id;
        taskObj6.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj6.OwnerId = testuser[0].Id; 
        taskObj6.Priority = 'Normal';
        taskList.add(taskObj6);
        
        task taskObj1 = new task();
        taskObj1.Status = 'In Progress';
        taskObj1.Subject = 'Prime Build';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.WhatId = gemsPhRec.Id;
        taskObj1.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj1.OwnerId = testuser[0].Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        
        task taskObj5 = new task();
        taskObj5.Status = 'Completed';
        taskObj5.Subject = 'BlueSTAR Update Request';
        taskObj5.GEMS_start_date__c = System.now();
        taskObj5.GEMS_end_date__c = System.now();
        taskObj5.GEMS_Type__C = 'Pharmacy Scope Code Account Specialist';
        taskObj5.WhatId = gemsPhRec.Id;
        taskObj5.OwnerId = testuser[0].Id; 
        taskObj5.Priority = 'Normal';                       
        taskList.add(taskObj5);

        task taskObj3 = new task();
        taskObj3.status = 'Completed';
        taskObj3.subject = 'Account Specialist BlueStar Update';
        taskObj3.GEMS_start_date__c = System.now();
        taskObj3.GEMS_end_date__c = System.now();
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testuser[0].Id; 
        taskObj3.Priority = 'Normal';                       
        taskList.add(taskObj3);

        
        
        insert taskList; 
        
        test.startTest(); 
              
        ApexPages.currentpage().getParameters().put('id',gemsRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
        GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
        scopectrl.CurrentUserId = testuser[0].id;
        scopectrl.ScopeCodeRecord=gemsPhRec;
        scopectrl.PermScopeCodeRecord=gemsPhRec;
        scopectrl.RelatedScopeCodeRecords.add(gemsRec);
        scopectrl.AllScopeCodes.add(gemsRec);
        scopectrl.listOfAccountSpecialistTasks = taskList;
        //scopectrl.taskList = taskList;
        Profile profileRec1 = [select id from profile where name ='System Administrator'];
        User usr = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test12@user11.com', 'testuser[0]12', 'test12@user.com');
        system.runas(usr) {
        gemsRec.ownerid = testuser[0].id;
        gemsRec.Peer_Reviewer__c = usr.id;
        gemsPhRec.Peer_Reviewer__c = usr.id;
        scopectrl.PermScopeCodeRecord = gemsPhRec;
        scopectrl.CurrentUserId = testuser[0].id;
        //scopectrl.Peer_Reviewer__c  = testuser[0].id;
        System.debug('==scopectrl='+gemsRec.ownerid);
        System.debug('==scopectrl.CurrentUserId =='+scopectrl.CurrentUserId );
        scopectrl.UpdateTasks();
        }
        scopectrl.approvalProcess();
        //scopectrl.options=new list<SelectOption>();
        //scopectrl.peerReviewer= testuser[0].id;
        list<selectOption> testOptions = scopectrl.Options;
        scopectrl.UpdateAccountSpecialistTasks();       
        scopectrl.UpdateScopeCodeBeforePeerReview();  
        scopectrl.redirectToPerm();  
        scopectrl.SaveScopeCode(); 
        scopectrl.ListOfBACases=null;
        scopectrl.StartPrimeBuild();        
        test.stopTest();  
    }
}