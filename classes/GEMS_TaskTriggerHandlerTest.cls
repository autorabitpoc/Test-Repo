/*
 * 10/8/2017    Luke Chen   SFDC-6659 Pharmacy Scope Code Task: Update BlueSTAR & AS400 - is not opening
*/
@isTEST
public class GEMS_TaskTriggerHandlerTest {
    
    private static testmethod void GEMS_TaskTriggerHandler_Test1(){
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
         Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
                
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com');
        
       Map<String, Schema.RecordTypeInfo> TaskRecordTypeInfo = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
       String GEMSTaskRecordType = TaskRecordTypeInfo.get('GEMS Pharmacy Scope Code').getRecordTypeId();
            
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = strCaseRec.Id;
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
        gemsPhRec.Status__c='In Progress';
        gemsPhRec.ownerId = testUser.Id;
        insert gemsPhRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'Completed';
        taskObj.subject = 'Pharmacy Scope Code';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = gemsPhRec.Id;
        taskObj.ownerId = testUser.Id; 
        taskObj.recordTypeId = GEMSTaskRecordType;
        taskObj.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
                
        task taskObj1 = new task();
        taskObj1.status = 'Completed';
        taskObj1.subject = 'BET Creation';
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testUser.Id; 
        taskObj1.recordTypeId = GEMSTaskRecordType;
        taskObj1.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        
        task taskObj2 = new task();
        taskObj2.status = 'Completed';
        taskObj2.subject = 'Peer Review';
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testUser.Id; 
        taskObj2.recordTypeId = GEMSTaskRecordType;
        taskObj2.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj2.Priority = 'Normal';
        taskList.add(taskObj2);
        
        task taskObj3 = new task();
        taskObj3.status = 'Completed';
        taskObj3.subject = 'Prime Build';
        taskObj3.whatId = gemsPhRec.Id;
        taskObj3.ownerId = testUser.Id; 
        taskObj3.recordTypeId = GEMSTaskRecordType;
        taskObj3.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj3.Priority = 'Normal';
        taskList.add(taskObj3);
        
        
        task taskObj4 = new task();
        taskObj4.status = 'Not Started';
        taskObj4.subject = 'Update BlueSTAR & AS400';
        //taskObj4.GEMS_start_date__c = System.now();
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testUser.Id; 
        taskObj4.recordTypeId = GEMSTaskRecordType;
        taskObj4.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj4.Priority = 'Normal';
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'In Progress';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.recordTypeId = GEMSTaskRecordType;
        taskObj5.GEMS_Type__C = 'Pharmacy Scope Code Account Specialist';
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testUser.Id; 
        taskObj5.Priority = 'Normal';
        taskList.add(taskObj5);
        
        insert taskList;
        
        List<Task> AccSpecTaskList = new List<Task>();
        AccSpecTaskList.add(taskObj5);
        
        test.startTest();      
         // ApexPages.currentpage().getParameters().put('id',gemsRec.id);
          //ApexPages.StandardController std = new ApexPages.standardController(gemsPhRec);
          //GEMS_TaskTriggerHandler.StartScopeCodeTask(AccSpecTaskList);
            taskObj5.status='Completed';
            update taskObj5;
          /*
          GEMS_ViewScopeCodeDetailController scopectrl= new GEMS_ViewScopeCodeDetailController(std);
          scopectrl.CurrentUserId = testuser.id;
          scopectrl.ScopeCodeRecord=gemsPhRec;
          scopectrl.PermScopeCodeRecord=gemsPhRec;
         list<case> a = scopeCtrl.ListofBACases;
          Scopectrl.ListOfBACases = [SELECT Id FROM Case WHERE Parent.Id =: ScopeCtrl.PermScopeCodeRecord.Case__c AND Status != 'Routed In Error' AND (GEMS_Temp_Scope_Code__c =: ScopeCtrl.PermScopeCodeRecord.Name OR GEMS_Pharmacy_Scope_Code__c =: ScopeCtrl.PermScopeCodeRecord.Name)];
          scopectrl.UpdateTasks();
          scopectrl.SaveScopeCode();
          scopectrl.updateStatus();  
        */
      test.stopTest();  
   
    }
    
    // SFDC-6659 Pharmacy Scope Code Task: Update BlueSTAR & AS400 - is not opening
    private static testmethod void GEMS_TaskTriggerHandler_startBluestar(){
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
         Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
                
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Case rxRec= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        rxRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        rxRec.accountId = acc.Id;
        insert rxRec;        

        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com');
        
       Map<String, Schema.RecordTypeInfo> TaskRecordTypeInfo = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
       String GEMSTaskRecordType = TaskRecordTypeInfo.get('GEMS Pharmacy Scope Code').getRecordTypeId();
            
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = rxRec.Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c=GEMS_Constants.RxScopeNoChanges;
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='In Progress';
        gemsPhRec.ownerId = testUser.Id;
        insert gemsPhRec;
        
        Case rxBaRec= GEMS_UtilityClassTest.insertionCase('GEMS BA Level Pharmacy Coding');
        rxBaRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        rxBaRec.accountId = acc.Id;
        rxBaRec.GEMS_Pharmacy_Scope_Code_Info__c = gemsPhRec.id;
        rxBaRec.parentid = rxRec.id;
        insert rxBaRec;        

        List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'Completed';
        taskObj.subject = 'Pharmacy Scope Code';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = gemsPhRec.Id;
        taskObj.ownerId = testUser.Id; 
        taskObj.recordTypeId = GEMSTaskRecordType;
        taskObj.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);

        task taskObj2 = new task();
        taskObj2.status = 'In Progress';
        taskObj2.subject = 'Peer Review';
        taskObj2.whatId = gemsPhRec.Id;
        taskObj2.ownerId = testUser.Id; 
        taskObj2.recordTypeId = GEMSTaskRecordType;
        taskObj2.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj2.Priority = 'Normal';
        taskList.add(taskObj2);

        task taskObj4 = new task();
        taskObj4.status = 'Not Started';
        taskObj4.subject = 'Update BlueSTAR & AS400';
        taskObj4.whatId = gemsPhRec.Id;
        taskObj4.ownerId = testUser.Id; 
        taskObj4.recordTypeId = GEMSTaskRecordType;
        taskObj4.GEMS_Type__C = 'Pharmacy Scope Code Owner';
        taskObj4.Priority = 'Normal';
        taskList.add(taskObj4);
        
        task taskObj5 = new task();
        taskObj5.status = 'Completed';
        taskObj5.subject = 'BlueSTAR Update Request';
        taskObj5.recordTypeId = GEMSTaskRecordType;
        taskObj5.GEMS_Type__C = 'Pharmacy Scope Code Account Specialist';
        taskObj5.whatId = gemsPhRec.Id;
        taskObj5.ownerId = testUser.Id; 
        taskObj5.Priority = 'Normal';
        taskList.add(taskObj5);
        
        insert taskList;
        
        List<Task> AccSpecTaskList = new List<Task>();
        AccSpecTaskList.add(taskObj5);
        
        test.startTest();      
        taskObj2.status='Completed';
        update taskObj2;
        test.stopTest();  
   
    }
    private static testmethod void updateTaskEmail(){
       Id medicalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId(); 
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<Case> accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId]; 
        User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
        
        Case cas1 = new case();
        cas1.recordtypeid = caseAccountSubmissionId;
        cas1.status ='In progress';
        cas1.OwnerId = u1.Id;
        insert cas1;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = cas1.id;
        cas2.recordtypeid = medicalUWRecordTypeid;
        cas2.status ='In progress';
        cas2.OwnerId = u1.Id;
        insert cas2;
        
        task taskObj = new task();
        taskObj.status = 'Not Started';
        taskObj.subject = 'Approve Account Paperwork';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = cas2.id;
        taskObj.Priority = 'Normal';
        insert taskobj;
        
        taskObj.status = 'Return';
        try{
        update taskObj;
        }
        catch(Exception e){
        
        }
        task taskObj1 = new task();
        taskObj1.status = 'Not Started';
        taskObj1.subject = 'Approve Account Paperwork';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.whatId = cas2.id;
        taskObj1.Priority = 'Normal';
        insert taskobj1;
        
        taskObj1.status = 'Re-Review';
        update taskObj1;
        
       
    }

}