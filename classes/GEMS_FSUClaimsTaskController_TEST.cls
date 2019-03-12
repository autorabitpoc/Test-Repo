/**************************************************************************************
  Apex Class Name     : GEMS_FSUClaimsTaskController_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_FSUClaimsTaskController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_FSUClaimsTaskController_TEST {
    private static testmethod void GEMS_FSUClaimsTaskController_TEST1(){
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_Accums_file_received_date__c=null;
    
       
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        /*Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        subStrRec.accountId = acc.Id;
        subStrRec.Status = 'Medical Benefits Production Ready'; 
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
        System.assertEquals(subCaseRec.Id,strCaseRec.GEMS_Account_Submission_Info__c);*/

       
        Case fsuCaseRec = GEMS_UtilityClassTest.insertionCase('GEMS FSUClaims');
        fsuCaseRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        fsuCaseRec.accountId = acc.Id;
        fsuCaseRec.Status = 'Medical Benefits Production Ready';
            
        insert fsuCaseRec;
        
        
        Id fsuRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Case fsuCaseRec1=[SELECT Id, GEMS_Account_Submission_Info__c, RecordTypeId from Case 
                        where RecordTypeId=:fsuRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,fsuCaseRec1.GEMS_Account_Submission_Info__c);
        
         
 List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Load and Test Benefit Accums';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subCaseRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
       /* task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Confirm Accums Tested';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subCaseRec.Id;
        taskElig.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Release Claims Hold';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);*/
        
        insert taskList;
        
       // List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec1.Id];
        //System.assertEquals(3,taskquery.size());
        
        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_FSUClaimsTaskController sbcSec = new GEMS_FSUClaimsTaskController (std);
        PageReference pageRef = Page.GEMSFSUClaimsTasks;
        Test.setCurrentPage(pageRef);
        /*List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec.Id];
        system.debug(taskquery.size());
        integer i;
        for(i=0;i<=taskquery.size();i++){
            sbcSec.currentTask=i;
            sbcSec.changeTaskStatus();
        }*/
        sbcSec.assignSelectedVal();
        sbcSec.selectedVal = -2;
         sbcSec.changeTaskStatus();

        test.stopTest();
    }
    
    
    private static testmethod void GEMS_FSUClaimsTaskController_TEST2(){
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        /*Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        subStrRec.accountId = acc.Id;
        subStrRec.Status = 'Medical Benefits Production Ready'; 
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
        System.assertEquals(subCaseRec.Id,strCaseRec.GEMS_Account_Submission_Info__c);*/

       
        Case fsuCaseRec = GEMS_UtilityClassTest.insertionCase('GEMS FSUClaims');
        fsuCaseRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        fsuCaseRec.accountId = acc.Id;
        fsuCaseRec.Status = 'Medical Benefits Production Ready';
        insert fsuCaseRec;
        
        
        Id fsuRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Case fsuCaseRec1=[SELECT Id, GEMS_Account_Submission_Info__c, RecordTypeId from Case 
                        where RecordTypeId=:fsuRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,fsuCaseRec1.GEMS_Account_Submission_Info__c);
        
         
 List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Load and Test Benefit Accums';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subCaseRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
        task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Confirm Accums Tested';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subCaseRec.Id;
        taskElig.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Release Claims Hold';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        insert taskList;
        
       // List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec1.Id];
        //System.assertEquals(3,taskquery.size());
        
        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_FSUClaimsTaskController sbcSec = new GEMS_FSUClaimsTaskController (std);
        PageReference pageRef = Page.GEMSFSUClaimsTasks;
        Test.setCurrentPage(pageRef);
        /*List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec.Id];
        system.debug(taskquery.size());
        integer i;
        for(i=0;i<=taskquery.size();i++){
            sbcSec.currentTask=i;
            sbcSec.changeTaskStatus();
        }*/
        sbcSec.assignSelectedVal();
        sbcSec.selectedVal = -1;
         sbcSec.changeTaskStatus();

        test.stopTest();
    }
    
    
      private static testmethod void GEMS_FSUClaimsTaskController_TEST3(){
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_Accums_file_received_date__c=null;
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        /*Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        subStrRec.accountId = acc.Id;
        subStrRec.Status = 'Medical Benefits Production Ready'; 
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
        System.assertEquals(subCaseRec.Id,strCaseRec.GEMS_Account_Submission_Info__c);*/

       
        Case fsuCaseRec = GEMS_UtilityClassTest.insertionCase('GEMS FSUClaims');
        fsuCaseRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        fsuCaseRec.accountId = acc.Id;
        fsuCaseRec.Status = 'Medical Benefits Production Ready';
        insert fsuCaseRec;
        
        
        Id fsuRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Case fsuCaseRec1=[SELECT Id, GEMS_Account_Submission_Info__c, RecordTypeId from Case 
                        where RecordTypeId=:fsuRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,fsuCaseRec1.GEMS_Account_Submission_Info__c);
         List<Task> taskList = new List<Task>();
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Review Proposal';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        //taskObj.status = 'Completed';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        insert taskList;
        
       // List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec1.Id];
        //System.assertEquals(3,taskquery.size());
        
        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_FSUClaimsTaskController sbcSec = new GEMS_FSUClaimsTaskController (std);
        PageReference pageRef = Page.GEMSFSUClaimsTasks;
        Test.setCurrentPage(pageRef);
        /*List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec.Id];
        system.debug(taskquery.size());
        integer i;
        for(i=0;i<=taskquery.size();i++){
            sbcSec.currentTask=i;
            sbcSec.changeTaskStatus();
        }*/
        sbcSec.assignSelectedVal();
        sbcSec.selectedVal = -2;
         sbcSec.changeTaskStatus();

        test.stopTest();
    }
    
    private static testmethod void GEMS_FSUClaimsTaskController_TEST4(){
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_Accums_file_received_date__c=null;
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        /*Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        subStrRec.accountId = acc.Id;
        subStrRec.Status = 'Medical Benefits Production Ready'; 
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
        System.assertEquals(subCaseRec.Id,strCaseRec.GEMS_Account_Submission_Info__c);*/

       
        Case fsuCaseRec = GEMS_UtilityClassTest.insertionCase('GEMS FSUClaims');
        fsuCaseRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        
        fsuCaseRec.accountId = acc.Id;
        fsuCaseRec.Status = 'Medical Benefits Production Ready';
        insert fsuCaseRec;
        
        
        Id fsuRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Case fsuCaseRec1=[SELECT Id, GEMS_Account_Submission_Info__c, RecordTypeId from Case 
                        where RecordTypeId=:fsuRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,fsuCaseRec1.GEMS_Account_Submission_Info__c);
        
         
 List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Release Claims Hold';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subCaseRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
       /* task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Confirm Accums Tested';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subCaseRec.Id;
        taskElig.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);*/
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Load and Test Benefit Accums';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        insert taskList;
        
       // List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec1.Id];
        //System.assertEquals(3,taskquery.size());
        
        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_FSUClaimsTaskController sbcSec = new GEMS_FSUClaimsTaskController (std);
        PageReference pageRef = Page.GEMSFSUClaimsTasks;
        Test.setCurrentPage(pageRef);
        /*List<task> taskquery =[select id,status from task where whatId = :fsuCaseRec.Id];
        system.debug(taskquery.size());
        integer i;
        for(i=0;i<=taskquery.size();i++){
            sbcSec.currentTask=i;
            sbcSec.changeTaskStatus();
        }*/
        sbcSec.assignSelectedVal();
        sbcSec.selectedVal = -2;
         sbcSec.changeTaskStatus();
          sbcSec.accumsFileReceivedDateError=true;
        test.stopTest();
    }
}