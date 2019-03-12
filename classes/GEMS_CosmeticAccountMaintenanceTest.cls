/********************************************************************************************************
Name        : GEMS_CosmeticAccountMaintenanceTest.cls
Description : Test Class: Release action by Account Maintenance Case to create Account Setup Process Case and its task
Version History:
Date        Developer               Description
06/24/2017  Luke Chen               Initial version. SFDC-4719 GEMS - Cosmetic Account Maintenance workflow
08/19/2017  Malathi.K               SFDC-5411 - GEMS Account Eligibility Maintenance.
08/31/2017  Lakshmi                 SFDC-5832 - GEMS AEP File Maintenance Case Functionality
05/18/2017  Malathi.K               SFDC-8197 - GEMS ID Card/Account Setup Maintenance.
**********************************************************************************************************/
@isTest
private class GEMS_CosmeticAccountMaintenanceTest{
   private static testMethod void testRelease1(){
        // Id accMaintCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Cosmetic Account Maintenance').getRecordTypeId();
        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
               
        Boolean IsEligflag=false; 
        Account account = GEMS_AccountSubmissionTestUtility.CreateAccountRecord('Cosmetic Account Maintenance Account');
        account.External_ID__c = 'Test ID';
        insert account;
        Entitlement en = new Entitlement();
        en.name='GEMS Process Entitlement';
        en.accountid = account.id;
        en.startdate = system.today();
        en.enddate = system.today();
        insert en;  
        
        test.startTest();       
       Case maintCase= GEMS_UtilityClassTest.insertionCase('Account Maintenance');
       maintCase.Accountid = account.id;
       maintCase.status = 'In Progress';
       maintCase.Funding_Type_Multiselect__c = 'ACAP';
       // maintCase.RecordTypeId = accMaintCaseRecordTypeId;
       maintCase.GEMS_Products__c = null;
       maintCase.type = 'GEMS Cosmetic Account Maintenance';
       maintCase.GEMS_Submission_Type__c = 'Cosmetic Account Maintenance';       
       insert maintCase;

        // test the release method
        String stringResult = GEMS_CosmeticAccountMaintenance.release(maintCase.id,IsEligflag);
        
        // verify there is no error message
        System.assert(stringResult == null, '!!! Fail to release, cause = ' + stringResult + ' !!!');
        // verify Account Setup Process Case
        Case setupCase = [select id, type from case where RecordTypeId = :accSetupRecordTypeId and parentid = :maintCase.id ];
        System.assert(setupCase != null && setupCase.type == 'Account Setup Maintenance', '!!! Fail to create Account Setup Maintenance Case for Cosmetic Account Maintenance !!!');
        // verify Task
        Task acctSetupCaseTask= [select id, Subject from task where WhatId = :setupCase.id ];
        System.assert(acctSetupCaseTask != null && acctSetupCaseTask.Subject == 'BlueSTAR Entry Complete', '!!! Fail to create Task in Maintenance Account Setup Case for Cosmetic Account Maintenance!!!');
        
        List<Case> caseList = [select id, type from case where parentid = :maintCase.id];
        System.debug('Total # of Child Cases = ' + caseList.size());
        System.assert(caseList.size() == 1, '!!! Total # of Child Cases = ' + caseList.size() + ' !!!');
        // verify GEMS_Ready_to_release_to_screening__c = 'Released'
        // System.assert(maintCase.GEMS_Ready_to_release_to_screening__c == 'Released', '!!! Fail to set GEMS_Ready_to_release_to_screening__c = Released !!!');
        test.stopTest();

    }
    
    private static testmethod void testRelease2()
    {
          
        Id accSetupProcessRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Boolean IsEligflag=true; 
        Account account = GEMS_AccountSubmissionTestUtility.CreateAccountRecord('Account Maintenance Eligibility Account');
        account.External_ID__c = 'Test ID';
        insert account;
        Entitlement en = new Entitlement();
        en.name='GEMS Process Entitlement';
        en.accountid = account.id;
        en.startdate = system.today();
        en.enddate = system.today();
        insert en;  
        
       test.startTest();      
       Case maintCase= GEMS_UtilityClassTest.insertionCase('Account Maintenance');
       maintCase.Accountid = account.id;
       maintCase.status = 'In Progress';
       maintCase.Funding_Type_Multiselect__c = 'ACAP';
       // maintCase.RecordTypeId = accMaintCaseRecordTypeId;
       maintCase.GEMS_Products__c = null;
       maintCase.type = 'Account Maintenance';
       maintCase.GEMS_Submission_Type__c = 'Account Eligibility Maintenance';       
       insert maintCase;

        // test the release method
        String stringResult = GEMS_CosmeticAccountMaintenance.release(maintCase.id,IsEligflag);
        
        // verify there is no error message
        System.assert(stringResult == null, '!!! Fail to release, cause = ' + stringResult + ' !!!');
        // verify Account Setup Process Case
        Case setupCase = [select id, type from case where RecordTypeId = :accSetupProcessRecTypeId and parentid = :maintCase.id ];
        System.assert(setupCase != null && setupCase.type == 'Account Setup Process', '!!! Fail to create Account Setup Process Case for Account Eligibility Maintenance !!!');
        // verify Task
        Task acctSetupCaseTask= [select id, Subject from task where WhatId = :setupCase.id ];
        System.assert(acctSetupCaseTask != null && acctSetupCaseTask.Subject == 'BlueSTAR Entry Complete', '!!! Fail to create Task in Account Setup Process Case for Account Eligibility Maintenance!!!');
        
        List<Case> caseList = [select id, type from case where parentid = :maintCase.id];
        System.debug('Total # of Child Cases = ' + caseList.size());
        System.assert(caseList.size() == 1, '!!! Total # of Child Cases = ' + caseList.size() + ' !!!');
        // verify GEMS_Ready_to_release_to_screening__c = 'Released'
        // System.assert(maintCase.GEMS_Ready_to_release_to_screening__c == 'Released', '!!! Fail to set GEMS_Ready_to_release_to_screening__c = Released !!!');

                
        test.stopTest();
    }
    private static testMethod void testRelease3(){
    //Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
     Id accSetupProcessRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
     Boolean IsEligflag=true; 
        Account account = GEMS_AccountSubmissionTestUtility.CreateAccountRecord('Account Maintenance Eligibility Account');
        account.External_ID__c = 'Test ID';
        insert account;
        Entitlement en = new Entitlement();
        en.name='GEMS Screening Entitlement';
        en.accountid = account.id;
        en.startdate = system.today();
        en.enddate = system.today();
        insert en; 
             
        
        test.startTest();      
       Case maintCase= GEMS_UtilityClassTest.insertionCase('Account Maintenance');
       maintCase.Accountid = account.id;
       maintCase.status = 'In Progress';
       maintCase.Funding_Type_Multiselect__c = 'ACAP';
       maintCase.GEMS_Products__c = null;
       maintCase.type = 'Account Maintenance';
       maintCase.GEMS_Submission_Type__c = 'AEP File Maintenance';       
       insert maintCase;
              
       //test the elgibilityrelease method
        String stringResult = GEMS_CosmeticAccountMaintenance.elgibilityrelease(maintCase.id,IsEligflag);
         // verify there is no error message
        System.assert(stringResult == null, '!!! Fail to release, cause = ' + stringResult + ' !!!');   
        
        test.stopTest();
} 
        private static testMethod void testRelease4(){
    //Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        
        Account account = GEMS_AccountSubmissionTestUtility.CreateAccountRecord('Account Maintenance ID Card Account');
        
        Id idCardRecordTypeId =           
            Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        Id maintenanceTaskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Setup Maintenance Task').getRecordTypeId();  
        
        
        account.External_ID__c = 'Test ID';
        insert account;
        Entitlement en = new Entitlement();
        en.name='GEMS Process Entitlement';        
        en.accountid = account.id;
        en.startdate = system.today();
        en.enddate = system.today();
        
        insert en; 
                             
        
        test.startTest();      
              
        
       Case maintCase1= GEMS_UtilityClassTest.insertionCase('Account Maintenance');
       maintCase1.Accountid = account.id;
       maintCase1.status = 'In Progress';
       maintCase1.Funding_Type_Multiselect__c = 'ACAP';
       maintCase1.GEMS_Products__c = null;
       maintCase1.type = 'Account Maintenance';
       maintCase1.GEMS_Submission_Type__c = 'ID Card Maintenance';
       maintCase1.GEMS_Case_Effective_Date__c = system.today();
       maintCase1.GEMS_Effective_Date__c = system.today();
       insert maintCase1;
       String idCardReleaseResult = GEMS_CosmeticAccountMaintenance.idCardRelease(maintCase1.id);
       System.assert(idCardReleaseResult == null, '!!! Fail to release, cause = ' + idCardReleaseResult + ' !!!');        
        
       test.stopTest();
}    
}