@isTest
public class GEMS_TaskEligControllerExtendedTest
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
    
    private static testmethod void eligiblitytask1() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
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
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='AEP Testing' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }

        

        
        test.stopTest();
    }
    
        private static testmethod void eligiblitytask2() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'AEP Production Ready';
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
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='AEP Production Ready' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }

        

        
        test.stopTest();
    }
    
    
        private static testmethod void eligiblitytask3() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Quality Review';
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
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Quality Review' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }

        

        
        test.stopTest();
    }
    
     private static testmethod void eligiblitytask4() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Walkthrough';
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
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Walkthrough' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }

        

        
        test.stopTest();
    }
    
     private static testmethod void eligiblitytask5() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Walkthrough Meeting Setup Complete';
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
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Walkthrough Meeting Setup Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<6;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();
            //gemsTaskElgty.updateTaskStartDate();
            gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }

        

        
        test.stopTest();
    }
    
    private static testmethod void eligiblitytask6() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Paperwork Review Requested by Account Specialist';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Paperwork Review Requested by Account Specialist' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
    }
    private static testmethod void eligiblitytask7() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        //eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.Status = 'BW Approval Received';
        update eligibityCase;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Walkthrough Meeting Setup Complete';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Walkthrough Meeting Setup Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
    }
    
     private static testmethod void eligiblitytask8() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        //eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.Status = 'BW Approval Rejected';
        update eligibityCase;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Walkthrough Meeting Setup Complete';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Walkthrough Meeting Setup Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        }
        
         private static testmethod void eligiblitytask9() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        //eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.Status = 'BW Approval Rejected';
        update eligibityCase;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Update Complete';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Update Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        }

 private static testmethod void eligiblitytask10() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        //eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.Status = 'BW Approval Received';
        eligibityCase.GEMS_Date_BlueSTAR_Walkthrough_Held__c= system.today();
        update eligibityCase;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Walkthrough';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Walkthrough' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        }
        
         private static testmethod void eligiblitytask11() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id,ownerid from case where recordtypeid =:eligRecordTypeId];
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'Yes';
        eligibityCase.Status = 'Quality Review Completed';
        eligibityCase.GEMS_Quality_Reviewer__c = eligibityCase.ownerid;
        eligibityCase.GEMS_Date_BlueSTAR_Walkthrough_Held__c= system.today();
        update eligibityCase;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Quality Review';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Quality Review' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        }
        
         private static testmethod void eligiblitytask12() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id,ownerid from case where recordtypeid =:eligRecordTypeId];
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.Status = 'Quality Review Completed';
        eligibityCase.GEMS_Quality_Reviewer__c = eligibityCase.ownerid;
        eligibityCase.GEMS_Date_BlueSTAR_Walkthrough_Held__c= system.today();
        update eligibityCase;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Quality Review';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Quality Review' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        }
        
        private static testmethod void eligiblitytask13() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
       
        case eligibityCase = [select id,ownerid from case where recordtypeid =:eligRecordTypeId];
GEMS_Return_Reason__c reason = new GEMS_Return_Reason__c();  
      reason.GEMS_Sub_Type__c='ABS';
      reason.GEMS_Case__c=eligibityCase.id;
      reason.GEMS_Comments__c='ABC';
      reason.Process_Name__c='Account Setup Screening';
      reason.GEMS_Type__c='ABS/Matrix';
      reason.Return_Reason__c='Missing doc';
      insert reason;
                List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Paperwork Review Requested by Account Specialist';
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Paperwork Review Requested by Account Specialist' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='Yes';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        }
    //Rajeesha - else part.
        private static testmethod void blueStarEntryCompleteTask() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = Null;
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = Null;
        eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = Null;
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
        
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
        
        

        
        test.startTest();
        {
          Test.setCurrentPage(Page.GEMSScreeningTasks);
        taskElig.status = 'Complete';
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
           // gemsTaskElgty.updateTaskStartDate();
           // gemsTaskElgty.addRow();
            gemsTaskElgty.showReturnReasonBlock();
            gemsTaskElgty.showYesOrNoPage();
            gemsTaskElgty.assignSelectedVal();
        }
        
    
    ApexPages.CurrentPage().getParameters().put('hasError','true');     
    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = true;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('QR Needed') == true)
    
    system.assert(b);//Assert the Page Message was Properly Displayed

   
  }


      
        test.stopTest();
    }
    }
    //Rajeesha for if part.
            private static testmethod void blueStarEntryCompleteTask1() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'No';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = Null;
        eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = Null;
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
        
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
        
        

        
        test.startTest();
        {
          Test.setCurrentPage(Page.GEMSScreeningTasks);
        taskElig.status = 'Complete';
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
        
    
    ApexPages.CurrentPage().getParameters().put('hasError','true');     
    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = true;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('QR Needed') == true)
    
    system.assert(b);//Assert the Page Message was Properly Displayed

   
  }


      
        test.stopTest();
    }
    }
    
    //Bharath
             private static testmethod void blueStarEntryCompleteTask4() 
    {

                    Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];

            User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
            insert u2;
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'Yes';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        //eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = 'No';
        eligibityCase.GEMS_Quality_Reviewer__c = U2.Id;
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
        
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
        
        

        
        test.startTest();
        {

          Test.setCurrentPage(Page.GEMSScreeningTasks);
        taskElig.status = 'Complete';
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
        
    
    ApexPages.CurrentPage().getParameters().put('hasError','true');     
    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = true;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('QR Needed') == true)
    
    system.assert(b);//Assert the Page Message was Properly Displayed

   
  }


      
        test.stopTest();
    }
    }

    
             private static testmethod void blueStarEntryCompleteTask5() 
    {

                    Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];

            User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
            insert u2;
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'Yes';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'Yes';
        //eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = 'Yes';
        eligibityCase.GEMS_Account_Setup_QR_Approval_Received__c = TRUE;
        eligibityCase.GEMS_Quality_Reviewer__c = U2.Id;
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
        
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
        
        

        
        test.startTest();
        {

          Test.setCurrentPage(Page.GEMSScreeningTasks);
        taskElig.status = 'Complete';
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
        
    
    ApexPages.CurrentPage().getParameters().put('hasError','true');     
    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = true;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('QR Needed') == true)
    
    system.assert(b);//Assert the Page Message was Properly Displayed

   
  }


      
        test.stopTest();
    }
    }

             private static testmethod void blueStarEntryCompleteTask7() 
    {

                    Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];

            User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
            insert u2;
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'Yes';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'Yes';
        //eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = 'Yes';
        eligibityCase.GEMS_Account_Setup_QR_Approval_Received__c = TRUE;
        eligibityCase.GEMS_Quality_Reviewer__c = U2.Id;
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
        
        List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Quality Review';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = eligibityCase.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
       insert taskList;
        
        

        
        test.startTest();
        {

          Test.setCurrentPage(Page.GEMSScreeningTasks);
        taskElig.status = 'Complete';
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Quality Review' and whatId=:eligibityCase.id];
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
        
    
    ApexPages.CurrentPage().getParameters().put('hasError','true');     
    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = true;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('QR Needed') == true)
    
    system.assert(b);//Assert the Page Message was Properly Displayed

   
  }


      
        test.stopTest();
    }
    }

             private static testmethod void blueStarEntryCompleteTask11() 
    {

                    Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];

            User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
            insert u2;
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'Yes';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        //eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = 'Yes';
        eligibityCase.GEMS_Account_Setup_QR_Approval_Received__c = TRUE;
        eligibityCase.GEMS_Quality_Reviewer__c = U2.Id;
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
        
        List<Task> taskList = new List<Task>();
        

        
        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'Quality Review';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = eligibityCase.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
       insert taskList;
        
        

        
        test.startTest();
        {

          Test.setCurrentPage(Page.GEMSScreeningTasks);
        taskElig.status = 'Complete';
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='Quality Review' and whatId=:eligibityCase.id];
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
        
    
    ApexPages.CurrentPage().getParameters().put('hasError','true');     
    List<Apexpages.Message> msgs = ApexPages.getMessages();
    boolean b = true;
    for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('QR Needed') == true)
    
    system.assert(b);//Assert the Page Message was Properly Displayed

   
  }


      
        test.stopTest();
    }
    }

    
    //Bharath
    
                private static testmethod void blueStarEntryCompleteTask2() 
    {
        
        Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'No';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = 'No';
        
        //case eligibityCase = [select id from case where recordtypeid =:eligRecordTypeId];
        insert eligibityCase;
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
        

        test.startTest();
        {
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(eligibityCase);
        GEMS_TaskEligibilityController gemsTaskElgty = new GEMS_TaskEligibilityController (stdController);
        List<Task> tskList = [select id, status,subject,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Entry Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;
        tskList[0].status = 'Complete';

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
    
         private static testmethod void BlueSTARcompletion1() 
    {
        
       
                Id eligRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Case eligibityCase = new Case();
        eligibityCase.recordtypeid = eligRecordTypeId;
        eligibityCase.status = 'In Progress';
        eligibityCase.Is_QR_Needed__c = 'No';
        eligibityCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c = 'No';
        eligibityCase.GEM_Is_group_loading_eligty_via_LGDE__c = 'No';
        insert eligibityCase;
        
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
        List<Task> tskList = [select id, status,subject,WhatId,OwnerId,GEMS_Start_Date__c,GEMS_End_Date__c from task where subject='BlueSTAR Entry Complete' and whatId=:eligibityCase.id];
        gemsTaskElgty.taskList = tsklist;

        Integer i,selectedVal;
        for(i=0;i<1;i++)
        {
            gemsTaskElgty.selectedVal =i;
            gemsTaskElgty.selectParamVal='No';
            gemsTaskElgty.currentTask= i;      
            gemsTaskElgty.changeTaskStatus();

        }

        

        
        test.stopTest();
        
        } 
        }