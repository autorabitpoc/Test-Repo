/**************************************************************************************
  Apex Class Name     : GEMS_ReturnReasonUnderwritingControllerTest
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for  GEMS_ReturnReasonUnderwritingController 
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        06/01/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_ReturnReasonUnderwritingTest{
   /* private static testmethod void GEMS_CaptureCategoryController1()
    {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
         
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        subRec.status = 'Return';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        
        subRec.GEMS_Return_Reason__c ='ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)';
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Underwriter');
        insert caseTeamAccSpecMem;
        //System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
         List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Approve Setup in BlueSTAR';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subCaseRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
        task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Approve Account Paperwork';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subCaseRec.Id;
        taskElig.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Approve ASO Billing';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        insert taskList;
        
        Test.setCurrentPageReference(new PageReference('Page.GEMSReturnReasonsForUnderwriting'));
        ApexPages.currentPage().getParameters().put('Id',subRec.id);
        ApexPages.currentPage().getParameters().put('firstRecParam1','true');
        ApexPages.currentPage().getParameters().put('firstRecParam2','true');
        ApexPages.currentPage().getParameters().put('secondParam','true');
        ApexPages.currentPage().getParameters().put('thirdRecParam1','true');
        ApexPages.currentPage().getParameters().put('thirdRecParam2','true');
        ApexPages.StandardController sc1 = new ApexPages.StandardController(subRec);
        GEMS_ReturnReasonUnderwritingController  g1 = new GEMS_ReturnReasonUnderwritingController (sc1);
        g1.returnCase();
        g1.approveDummy();
        
       
        System.currentPageReference().getParameters().put('id', subRec.id);
        g1.updateTasksToApprove();
        g1.allSelected=true;
        g1.selectedIds='ABS';
        g1.unSelectedIds='ABS';
        
        }*/
        
           private static testmethod void GEMS_CaptureCategoryController2()
    {   
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
         
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        subRec.status = 'Return';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        
        subRec.GEMS_Return_Reason__c ='';
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
         List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Approve Setup in BlueSTAR';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subCaseRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
        task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Approve Account Paperwork';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subCaseRec.Id;
        taskElig.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Approve ASO Billing';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        insert taskList;
        
        Test.setCurrentPageReference(new PageReference('Page.GEMSReturnReasonsForUnderwriting'));
        ApexPages.currentPage().getParameters().put('Id',subRec.id);
        ApexPages.currentPage().getParameters().put('firstRecParam1','true');
        ApexPages.currentPage().getParameters().put('firstRecParam2','true');
        ApexPages.currentPage().getParameters().put('secondParam','true');
        ApexPages.currentPage().getParameters().put('thirdRecParam1','true');
        ApexPages.currentPage().getParameters().put('thirdRecParam2','true');
        ApexPages.StandardController sc1 = new ApexPages.StandardController(subRec);
        GEMS_ReturnReasonUnderwritingController  g1 = new GEMS_ReturnReasonUnderwritingController (sc1);
        g1.returnCase();
        g1.approveDummy();
        
       
        System.currentPageReference().getParameters().put('id', subRec.id);
        g1.updateTasksToApprove();
        g1.allSelected=true;
        g1.selectedIds='ABS';
        g1.unSelectedIds='ABS';
        }
        
               private static testmethod void GEMS_CaptureCategoryController3()
    {   
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        Case accsub= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        accsub.status = 'In Progress';
        accsub.Funding_Type_Multiselect__c = 'ACAP';
        accsub.GEMS_Accums_file_received_date__c=null;
        accsub.GEMS_AEP_Account__c= true;
        insert accsub;
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(accsub.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
        subRec.status = 'Return';
        subRec.GEMS_Account_Submission_Info__c= accsub.id;
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_Return_Reason__c ='ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)';
        insert subRec;
        
         
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
       
       
         List<Task> taskList = new List<Task>();
        
        task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Approve Setup in BlueSTAR';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subCaseRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
        task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Approve Account Paperwork';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subCaseRec.Id;
        taskElig.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Approve ASO Billing';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subCaseRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'In Progress';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        insert taskList;
        
        Test.setCurrentPageReference(new PageReference('Page.GEMSReturnReasonsForUnderwriting'));
        ApexPages.currentPage().getParameters().put('Id',subRec.id);
        ApexPages.currentPage().getParameters().put('firstRecParam1','true');
        ApexPages.currentPage().getParameters().put('firstRecParam2','true');
        ApexPages.currentPage().getParameters().put('secondParam','true');
        ApexPages.currentPage().getParameters().put('thirdRecParam1','true');
        ApexPages.currentPage().getParameters().put('thirdRecParam2','true');
        ApexPages.StandardController sc1 = new ApexPages.StandardController(subRec);
        GEMS_ReturnReasonUnderwritingController  g1 = new GEMS_ReturnReasonUnderwritingController (sc1);
        g1.returnCase();
        g1.approveDummy();
        
       
        System.currentPageReference().getParameters().put('id', subRec.id);
        g1.updateTasksToApprove();
        g1.allSelected=true;
        g1.selectedIds='ABS';
        g1.unSelectedIds='ABS';
        }
   
        }