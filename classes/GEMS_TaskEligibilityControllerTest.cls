@isTest
public class GEMS_TaskEligibilityControllerTest
{
    @testSetup
    static void dataSetup() 
    {
    Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        //case accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        case caseaccSub = new case();
        caseaccSub.recordtypeid = caseAccountSubmissionId;
        caseaccSub.status = 'New';
        insert caseaccSub;
        case caseSub = [select id from case where recordtypeid = :caseAccountSubmissionId];
        
        case eligibilityCase = new case();
        eligibilityCase.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        eligibilityCase.status = 'In Progress';
        //eligibilityCase.ownerid = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        eligibilityCase.gems_account_submission_info__c = caseSub.id;
        
        case accSetUpCase = new case();
        accSetUpCase.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        accSetUpCase.status = 'In Progress';
        //accSetUpCase.ownerid = [select id,memberid from caseteammember where teamrole.name ='Account Specialist'].memberid;
        accSetUpCase.gems_account_submission_info__c = caseSub.id;
        
        List<case> caseList = new List<Case>();
        caseList.add(eligibilityCase);
        caseList.add(accSetUpCase);
        
        insert caseList;
        
    }
    
    private static testmethod void eligiblitytask() 
    {
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        ApexPages.currentPage().getParameters().put('caseId',eligibityCase.id);                  
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        gemsTaskElgty.changeTaskStatus();
        test.startTest();
        gemsTaskElgty.selectedVal = 1;      
        gemsTaskElgty.changeTaskStatus();
        gemsTaskElgty.cancelProject();
        test.stopTest();
    }
    
    private static testmethod void eligiblitytaskProjectCancel() 
    {
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        ApexPages.currentPage().getParameters().put('caseId',eligibityCase.id);
        eligibityCase.Status='Project Cancelled';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c='Yes';
        update eligibityCase;
         List<Task> taskList = new List<Task>();
         task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'AEP Testing';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = eligibityCase.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
         task taskElig1 = new task();
        taskElig1.status = 'Not Started';
        taskElig1.subject = 'AEP Production Ready';
        taskElig1.GEMS_Start_Date__c = System.now();
        taskElig1.GEMS_End_Date__c = System.now()+2;
        taskElig1.whatId = eligibityCase.Id;
        
        taskElig1.Priority = 'Normal';
        taskList.add(taskElig1);
        
        insert taskList;
        
        test.startTest();
        
        taskList[0].Status='Completed';
        taskList[1].Status='Completed';
        update taskList;
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        gemsTaskElgty.taskList=taskList;
        Integer i;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }
        eligibityCase.Status='BW Approval Received';
        update eligibityCase;
        
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty1 = new GEMS_TaskEligibilityController (stdController1);
        
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;
            gemsTaskElgty.selectedVal = i;     
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }
        
        test.stopTest();
    }
    
    private static testmethod void eligiblitytask1() 
    {
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        ApexPages.currentPage().getParameters().put('caseId',eligibityCase.id);
        test.startTest();
        eligibityCase.Status='BW Approval Received';
        update eligibityCase;
         List<Task> taskList = new List<Task>();
         task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'AEP Testing';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = eligibityCase.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        
        
        
        
        
        
        
        
        taskList.add(taskElig);
        
        insert taskList;
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        gemsTaskElgty.taskList=taskList;
        Integer i;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectParamVal='Yes';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
            //gemsTaskElgty.updateTaskStartDate(taskList[0]);
        }
        test.stopTest();
    }
    
    private static testmethod void manualEligiblitytask1() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId limit 1];
        ApexPages.currentPage().getParameters().put('caseId',eligibityCase.id);
        test.startTest();
        eligibityCase.Status='BW Approval Received';
        update eligibityCase;
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        
        Integer i;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }
        
        eligibityCase.Status='BW Approval Rejected';
        update eligibityCase;
        test.stopTest();
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty1 = new GEMS_TaskEligibilityController (stdController1);
        
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;
            gemsTaskElgty.selectedVal = i;     
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal(); 
            gemsTaskElgty.blueStarTaskCompleteError = false;
            gemsTaskElgty.blueStarTaskCompleteError1 = false;
        }
        
        
    }
    
    
private static testmethod void eligiblitytask3() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Entry Complete';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = eligibityCase.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        insert taskList;
        
        //GEMS_Eligibility_Testing__c test1 = new GEMS_Eligibility_Testing__c();
        //test1.Eligiblity_Case__c = eligibityCase.id;
        //insert test1;
        
        //GEMS_Eligibility_Production__c prod = new GEMS_Eligibility_Production__c();
        //prod.Eligiblity_Case__c = eligibityCase.id;
        //insert prod;
        ApexPages.currentPage().getParameters().put('caseId',eligibityCase.id);

        
        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Entry Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
           // gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }

        

        
        test.stopTest();
    }
}