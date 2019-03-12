/********************************************************************************************************
Name        : GEMS_CosmeticAccountMaintenance.cls
Description : Release action by Account Maintenance Case to create Account Setup Process Case and its task
Version History:
Date        Developer               Description
06/24/2017  Luke Chen               Initial version. SFDC-4719 GEMS - Cosmetic Account Maintenance workflow
07/07/2017  Gokul Bharati           SFDC - 5099 - GEMS-Cosmetic Account Maintenance
08/19/2017  Malathi.K               SFDC-5411- GEMS Account Eligibility Maintenance - Create Account Setup Process case.
08/31/2017  Lakshmi                 SFDC-5832 - GEMS - AEP File Maintenance - Case Functionality
09/11/2017  Gokul Bharati           SFDC-5880-GEMS: Pre-Populate Quality/QAI Reviewer and BlueSTAR Walkthrough Account Mgmt/GET on ASP Case for Account Structure Maintenance
11/21/2017  Phani Kommareddy        SFDC-6368 GEMS - ID Card Maintenance: Case Functionality
05/14/2017  Malathi.K               SFDC-8197 GEMS - ID Card Maintenance: Trigger Account Setup Maintenance Case at the same time as ID Card Maintenance Case
*******************************************************************************************************/
global class GEMS_CosmeticAccountMaintenance{
    
    public GEMS_CosmeticAccountMaintenance(){}
    
    webService static String release(Id acctMaintCaseId,Boolean IsEligMaint){

        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        Id maintenanceTaskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Setup Maintenance Task').getRecordTypeId();
        Id accSetupProcessRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        
       
        // Fetch the GEMS Process Entitlement Id
        List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName LIMIT 1];     
        //Create a List of BlueSTAR Task to be created
        List<Task> BlueStrCompTask =new List<Task>();
        Id rectypetopass ;
        
        If (IsEligMaint) {
          rectypetopass = accSetupProcessRecTypeId ;
          }
        else{
          rectypetopass = accSetupRecordTypeId ;
          }
        
        // obtain the Account Maintenance Case record
        Case acctMaintCase = 
            [select id,GEMS_Products__c ,ownerId,status,GEMS_Line_of_Business__c, Funding_Type_Multiselect__c, accountId, GEMS_Effective_Date__c, 
             GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, FSU_Location__c, HCSC_Division__c, GEMS_Account_Submission_Info__c, GEMS_StdCust_Product__c,
             GEMS_Submission_Sub_Type__c, Account.name, Account.External_ID__c, GEMS_Rx_Vendor__c, GEMS_Private_Exchange__c, GEMS_Private_Exchange_Values__c, 
             Underwriter_Lookup__c, Opportunity_Name__c, GEMS_Ready_to_release_to_screening__c, (select id from Cases1__r where recordTypeId = :rectypetopass ) 
             from case where Id = :acctMaintCaseId ];
        
        if(acctMaintCase == null) {
            System.debug('Cosmetic Account Maintenance Case ID = ' + acctMaintCaseId + '; Case = null; cannot find the record !!');
            return 'Release failed. Caes ID is null. Cannot find Cosmetic Account Maintenance Case';
        }
        if(acctMaintCase.Cases1__r != null && acctMaintCase.Cases1__r.size() > 0) {
          If (IsEligMaint) {
            return 'Release failed. Account Setup Process case already exists';
            }
          else {
             return 'Release failed. Account Maintenance Setup Process case already exists';
            }
           }   
        try{
            // create Account Setup Process Case from its parent
            Case acctSetupCase = new Case();
            Date effectiveDate = acctMaintCase.GEMS_Case_Effective_Date__c;
            If (IsEligMaint) {
              acctSetupCase.Type = 'Account Setup Process';
              acctSetupCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c + ' ' + effectiveDate.format() + ' Account Setup Process';
              
            }
            else{
               acctSetupCase.Type = 'Account Setup Maintenance';
               acctSetupCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c+' Account Setup Maintenance';
            }
           // acctSetupCase.Type = 'Account Setup Maintenance';
            //acctSetupCase.recordtypeid=accSetupRecordTypeId;
            acctSetupCase.recordtypeid=rectypetopass ;
            acctSetupCase.GEMS_Line_of_Business__c = acctMaintCase.GEMS_Line_of_Business__c;
            acctSetupCase.GEMS_Rx_Vendor__c = acctMaintCase.GEMS_Rx_Vendor__c;
            acctSetupCase.Accountid=acctMaintCase.accountId;
            acctSetupCase.GEMS_Effective_Date__c=acctMaintCase.GEMS_Effective_Date__c;
            acctSetupCase.GEMS_Case_Effective_Date__c = acctMaintCase.GEMS_Case_Effective_Date__c;
            acctSetupCase.GEMS_Submission_Type__c=acctMaintCase.GEMS_Submission_Type__c;
            acctSetupCase.FSU_Location__c=acctMaintCase.FSU_Location__c;
            acctSetupCase.Status='In Progress';
            acctSetupCase.parentid = acctMaintCase.Id;
            acctSetupCase.HCSC_Division__c=acctMaintCase.HCSC_Division__c;                        
            acctSetupCase.GEMS_Submission_Sub_Type__c=acctMaintCase.GEMS_Submission_Sub_Type__c;
            acctSetupCase.GEMS_Account_Submission_Info__c=acctMaintCase.Id;
           // acctSetupCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c+' Account Setup Maintenance';
            acctSetupCase.GEMS_Private_Exchange__c = acctMaintCase.GEMS_Private_Exchange__c;     
            acctSetupCase.GEMS_Private_Exchange_Values__c = acctMaintCase.GEMS_Private_Exchange_Values__c;
            acctSetupCase.Opportunity_Name__c = acctMaintCase.Opportunity_Name__c;
            acctSetupCase.Underwriter_Lookup__c = acctMaintCase.Underwriter_Lookup__c;
            acctSetupCase.GEMS_Submitter__c = acctMaintCase.ownerId;
            acctSetupCase.Funding_Type_Multiselect__c = acctMaintCase.Funding_Type_Multiselect__c;                
            acctSetupCase.GEMS_StdCust_Product__c = acctMaintCase.GEMS_StdCust_Product__c;                                                                        
            acctSetupCase.GEMS_Products__c = acctMaintCase.GEMS_Products__c;
            List<CaseTeamMember> specialistIdList = [SELECT Id, memberid FROM CaseTeamMember where TeamRole.Name='Account Specialist' and ParentId = :acctMaintCaseId];
            if(specialistIdList.isEmpty()){ 
                acctSetupCase.ownerId = acctMaintCase.ownerId;
            } else { 
                acctSetupCase.ownerId = specialistIdList[0].memberid;
                acctSetupCase.GEMS_Quality_Reviewer__c = specialistIdList[0].memberid;                   
            }
            acctSetupCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = acctMaintCase.ownerId;
            //Add the As Is GEMS Process Entitlement 
            If (IsEligMaint) {
              acctSetupCase.EntitlementId=activeEntitlement[0].Id!=null?activeEntitlement[0].Id:null;             
            }
            else{
              acctSetupCase.EntitlementId=activeEntitlement[0].Id;
              }
            insert acctSetupCase;
            
            If (IsEligMaint) {
               //create BlueStar Complete Entry Task record
                     BlueStrCompTask.add(GEMS_Utility.createTask('In Progress', acctSetupCase.Id, acctSetupCase.ownerId, 'BlueSTAR Entry Complete', 'Normal', System.now(), null, null));
                        if(!BlueStrCompTask.isEmpty())
                               insert BlueStrCompTask;
                } 
            else {                             
                // create Task record
                Task acctSetupCaseTask= new Task();
                acctSetupCaseTask.recordTypeId = maintenanceTaskTypeId; 
                acctSetupCaseTask.WhatId=acctSetupCase.Id;
                acctSetupCaseTask.Subject='BlueSTAR Entry Complete';
                acctSetupCaseTask.Status='In Progress';
                acctSetupCaseTask.Priority='Normal';
                acctSetupCaseTask.GEMS_Start_Date__c = System.now();
                acctSetupCaseTask.ownerId = acctSetupCase.ownerId;                                
                insert acctSetupCaseTask;
               } 
            //update GEMS_Ready_to_release_to_screening__c field
            acctMaintCase.GEMS_Ready_to_release_to_screening__c = 'Released';
            acctMaintCase.status = 'In Progress';
            update acctMaintCase;
            return null;
        }Catch(Exception ex)
        {
            System.debug('Fail to release GEMS Cosmetic Account Maintenance case. Error = ' + ex.getMessage()+ex.getLineNumber());
            return 'Fail to release Cosmetic Account Maintenance case. Please contact GEMS support for assistance!';
        }
    }
   /******************************************************************** 
    *    Method Name :   elgibilityrelease
    *   @description :   This method is to create Eligibility Process case for AEP File Maintenance
    *   @parameters  :   Id acctMaintCaseId,Boolean IsEligMaint
    *   @return type :   String
    *   @Author      :   Lakshmi
    ***************************************************************/
  webService static String elgibilityrelease(Id acctMaintCaseId,Boolean IsEligMaint){
    List<Case> new_cases_list = new List<Case>();
     Map<String,List<Case>> caseidListOfScreeningCases = new Map<String,List<Case>>();

        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        Id maintenanceTaskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Setup Maintenance Task').getRecordTypeId();
        Id accSetupProcessRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();       
        // Fetch the GEMS Process Entitlement Id
        //List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName LIMIT 1];     
         List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSScreeningEntitlementName];
           // Assigning case owner to EEE Queue
           Group s =    [select Id from Group where Name = 'GEMS EEE Queue' AND Type = 'Queue'];
           list<QueueSobject> q = [select Id, QueueId from QueueSobject WHERE SobjectType = 'Case' AND Queue.Name ='GEMS EEE Queue'];
           
           
        //Create a List of BlueSTAR Task to be created
        List<Task> BlueStrCompTask =new List<Task>();
       
        //List<Task> insertTaskList = new List<Task>();
         List<Case> allScreeningCasesList = new List<Case>();
        
        Id rectypetopass ;
        
        If (IsEligMaint) {
          rectypetopass = accSetupProcessRecTypeId ;
          
          }
        else{
          rectypetopass = accSetupRecordTypeId ;
            
          }
        
        // obtain the Account Maintenance Case record
        Case acctMaintCase = 
            [select id,GEMS_Products__c ,ownerId,status,GEMS_Line_of_Business__c, Funding_Type_Multiselect__c, accountId, GEMS_Effective_Date__c, 
             GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, FSU_Location__c, HCSC_Division__c, GEMS_Account_Submission_Info__c, GEMS_StdCust_Product__c,
             GEMS_Submission_Sub_Type__c, Account.name, Account.External_ID__c, GEMS_Rx_Vendor__c, GEMS_Private_Exchange__c, GEMS_Private_Exchange_Values__c, 
             Underwriter_Lookup__c, Opportunity_Name__c,GEMS_Target_Date_Production_OE_File__c,Account_Executive__c,GEMS_Medical_Underwriter__c,Sales_Executive__c,type,GEMS_Submitter__c,Sub_Category__c,Productid,recordTypeId, GEMS_Ready_to_release_to_screening__c, (select id from Cases1__r where recordTypeId = :rectypetopass ) 
             from case where Id = :acctMaintCaseId ];
             
           
        
        if(acctMaintCase == null) {
            System.debug('Cosmetic Account Maintenance Case ID = ' + acctMaintCaseId + '; Case = null; cannot find the record !!');
            return 'Release failed. Caes ID is null. Cannot find Cosmetic Account Maintenance Case';
        }
        if(acctMaintCase.Cases1__r != null && acctMaintCase.Cases1__r.size() > 0) {
          If (IsEligMaint) {
            return 'Release failed. Eligibility Process case already exists';
            }
          else {
             return 'Release failed. Account Maintenance Setup Process case already exists';
            }
           }   
        try{
            // create Eligibility Process Case from its parent
            Case eligibilityProcessCase = new Case();
            
            Date caseffDate1 = acctMaintCase.GEMS_Case_Effective_Date__c;
            If (IsEligMaint) {
          
             eligibilityProcessCase.Type = 'Eligibility Process';
               
               eligibilityProcessCase.Subject=acctMaintCase.Account.Name+' '+ acctMaintCase.Account.External_ID__c +' '+ caseffDate1.format() +' Eligibility Process';
                         
              
            }
            else{
               eligibilityProcessCase.Type = 'Account Setup Maintenance';
               eligibilityProcessCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c+' Account Setup Maintenance';
            }
           // acctSetupCase.Type = 'Account Setup Maintenance';
            //acctSetupCase.recordtypeid=accSetupRecordTypeId;
            eligibilityProcessCase.GEMS_Submission_Type__c=acctMaintCase.GEMS_Submission_Type__c;
            eligibilityProcessCase.parentid= acctMaintCase.id;
           // eligibilityProcessCase.Account.name = acctMaintCase.Account.name;
                        eligibilityProcessCase.FSU_Location__c=acctMaintCase.FSU_Location__c;
                        eligibilityProcessCase.Accountid=acctMaintCase.accountId;
                        // populate GEMS_Target_Date_Production_OE_File__c field from submission case's
                        eligibilityProcessCase.GEMS_Target_Date_Production_OE_File__c = acctMaintCase.GEMS_Target_Date_Production_OE_File__c;
                        eligibilityProcessCase.GEMS_Account_Submission_Info__c = acctMaintCase.Id;
                        eligibilityProcessCase.Account_Executive__c=acctMaintCase.Account_Executive__c;
                        eligibilityProcessCase.HCSC_Division__c=acctMaintCase.HCSC_Division__c;
                        eligibilityProcessCase.GEMS_Submission_Sub_Type__c=acctMaintCase.GEMS_Submission_Sub_Type__c;
                        eligibilityProcessCase.GEMS_Medical_Underwriter__c=acctMaintCase.GEMS_Medical_Underwriter__c;
                        eligibilityProcessCase.Sales_Executive__c=acctMaintCase.Sales_Executive__c;
                        eligibilityProcessCase.Productid=acctMaintCase.Productid;
                        eligibilityProcessCase.GEMS_Case_Effective_Date__c = acctMaintCase.GEMS_Case_Effective_Date__c;
                        eligibilityProcessCase.GEMS_Effective_Date__c = acctMaintCase.GEMS_Effective_Date__c;
                        eligibilityProcessCase.status = 'In Progress';            
                        eligibilityProcessCase.recordTypeId = accSetupProcessRecTypeId;         
                        eligibilityProcessCase.GEMS_Target_Date_Production_OE_File__c = acctMaintCase.GEMS_Target_Date_Production_OE_File__c;
                        //eligibilityProcessCase.GEMS_Actual_Date_Production_OE_File__c = acctMaintCase.GEMS_Actual_Date_Production_OE_File__c;              
                        eligibilityProcessCase.Opportunity_Name__c = acctMaintCase.Opportunity_Name__c ;
                        eligibilityProcessCase.type = 'Eligibility Process';//ba1[0] + ' ' +ba1[2];
                        eligibilityProcessCase.Sub_Category__c = 'AEP Eligibility';//ba1[0] + ' ' +ba1[2];
                        eligibilityProcessCase.GEMS_Products__c=acctMaintCase.GEMS_Products__c;
                        eligibilityProcessCase.GEMS_Submitter__c = acctMaintCase.ownerId; //Code Added for October Release
                        eligibilityProcessCase.ownerId = q[0].QueueId;
                        // This population is for October Hotfix 2016
                         eligibilityProcessCase.Funding_Type_Multiselect__c = acctMaintCase.Funding_Type_Multiselect__c;                
                         eligibilityProcessCase.GEMS_StdCust_Product__c = acctMaintCase.GEMS_StdCust_Product__c;
                         eligibilityProcessCase.GEMS_Rx_Vendor__c = acctMaintCase.GEMS_Rx_Vendor__c;
                         eligibilityProcessCase.GEMS_Line_of_Business__c=acctMaintCase.GEMS_Line_of_Business__c;
                        
                         new_cases_list.add(eligibilityProcessCase);
          
            
            //Add the As Is GEMS Process Entitlement 
            If (IsEligMaint) {
             // if(acctMaintCase.TeamMembers[0].MemberId !=null){
             // acctSetupCase.ownerId=acctMaintCase.TeamMembers[0].MemberId;}
              eligibilityProcessCase.EntitlementId=activeEntitlement[0].Id!=null?activeEntitlement[0].Id:null; 
                             
             }
            else{
              eligibilityProcessCase.EntitlementId=activeEntitlement[0].Id;
                  
              }
             // new_cases_list.add(eligibilityProcessCase);
              
              if(!new_cases_list.isEmpty()) {
              
                   insert new_cases_list;
                   System.debug('--------------------new_cases_list------------------'+new_cases_list);
                   //allScreeningCasesList.addAll(new_cases_list);
                    
                    }
                
    
        if(!new_cases_list.isEmpty()) {
           
              System.debug('--------------------new_cases_list------------------'+!new_cases_list.isEmpty());
            for(Case caseScreening :new_cases_list ) {                
                if(caseScreening.type == 'Eligibility Process') {
                  /*  String ownerIdString = caseScreening.OwnerId;
                    Task newTask = new Task();
                    newTask.subject = 'AEP Initial Setup';
                    newTask.whatId = caseScreening.Id;
                    //Condetion added for October release to fix the insufficiat access while completing task in Eligibility Process case                    
                    if(caseScreening.OwnerId != null && !(ownerIdString.startsWith('00G'))) 
                        newTask.ownerId = caseScreening.OwnerId;
                                            
                    newTask.status = 'In progress';
                    newTask.Priority = 'Normal';
                    newTask.GEMS_Start_Date__c = System.now();
                    insertTaskList.add(newTask);
                    
                    Task newTask1 = new Task();
                    newTask1.subject = 'AEP Testing';
                    newTask1.whatId = caseScreening.Id;
                    //Condetion added for October release to fix the insufficiat access while completing task in Eligibility Process case
                    if(caseScreening.OwnerId != null && !(ownerIdString.startsWith('00G')))
                        newTask1.ownerId = caseScreening.OwnerId;
                        
                    newTask1.status = 'Not Started';
                    newTask1.Priority = 'Normal';
                    //newTask1.GEMS_Start_Date__c = System.now();
                    insertTaskList.add(newTask1);
                    
                    Task newTask2 = new Task();
                    newTask2.subject = 'AEP Production Ready';
                    newTask2.whatId = caseScreening.Id;
                    //Condetion added for October release to fix the insufficiat access while completing task in Eligibility Process case
                    if(caseScreening.OwnerId != null && !(ownerIdString.startsWith('00G')))
                        newTask2.ownerId = caseScreening.OwnerId;
                        
                    newTask2.status = 'Not Started';
                    newTask2.Priority = 'Normal';
                    //newTask2.GEMS_Start_Date__c = System.now();
                    insertTaskList.add(newTask2);*/
                    
                }else {
                    if(caseidListOfScreeningCases.get(caseScreening.parentId) != null ) {
                        caseidListOfScreeningCases.get(caseScreening.parentId).add(caseScreening);
                    }else {
                        List<Case> screening = new List<Case>();
                        screening.add(caseScreening);
                        caseidListOfScreeningCases.put(caseScreening.parentId,screening);
                    }
                }
            }
        }
      /*  if(!insertTaskList.isEmpty()) {
            insert insertTaskList;
        }*/
         acctMaintCase.GEMS_Ready_to_release_to_screening__c = 'Released';
            acctMaintCase.status = 'In Progress';
            update acctMaintCase;   
            //Fetching the assignment rules on case
AssignmentRule AR = new AssignmentRule();
AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

//Creating the DMLOptions for "Assign using active assignment rules" checkbox
Database.DMLOptions dmlOpts = new Database.DMLOptions();
dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;

Case newCase = new Case(Status = 'New') ;
//Setting the DMLOption on Case instance
newCase.setOptions(dmlOpts);
insert newCase ;           
        }
        
        Catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'GEMS_AccountScreeningCaseCreation.screeningCasesCreation(List<Case> casesList)','High'); 
            return null;
        }
        
        //return caseidListOfScreeningCases;
        return null;   
            
            
}

    /********************************************************************
     *   Method Name  :   idCardRelease
     *   @description :   This method is to create ID Card case for ID Card Maintenance(SFDC-6368)
     *   @parameters  :   Id acctMaintCaseId
     *   @return type :   String
     *   @Author      :   Phani Kommareddy
     ***************************************************************/
    webService static String idCardRelease(Id acctMaintCaseId) {
        Id idCardRecordTypeId =           
            Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        Id maintenanceTaskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Setup Maintenance Task').getRecordTypeId();      
        
        // Fetch the GEMS Process Entitlement Id
        List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName LIMIT 1];     
        //Create a List of BlueSTAR Task to be created
        List<Task> BlueStrCompTask =new List<Task>();
            
        // obtain the Account Maintenance Case record
        Case acctMaintCase =
            [select id, GEMS_Products__c, ownerId, status, GEMS_Line_of_Business__c, Funding_Type_Multiselect__c, accountId, GEMS_Effective_Date__c,
            GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, FSU_Location__c, HCSC_Division__c, GEMS_Account_Submission_Info__c, GEMS_StdCust_Product__c,
            GEMS_Submission_Sub_Type__c, Account.name, Account.External_ID__c, GEMS_Rx_Vendor__c, GEMS_Private_Exchange__c, GEMS_Private_Exchange_Values__c,
            Underwriter_Lookup__c, Opportunity_Name__c, GEMS_Ready_to_release_to_screening__c,GEMS_ID_Cards_Format__c from case where Id = : acctMaintCaseId];
            
        if (acctMaintCase == null) {
                System.debug('ID Card Maintenance Case ID = ' + acctMaintCaseId + '; Case = null; cannot find the record !!');
                return 'Release failed. Case ID is null. Cannot find ID Card Maintenance Case';
        }
        try {
            // create ID Card Case from its parent
            Case idCardCase = new Case();
            Date effectiveDate = acctMaintCase.GEMS_Case_Effective_Date__c;
            idCardCase.Type = 'ID Card';
            idCardCase.Subject = acctMaintCase.Account.name + ' ' + acctMaintCase.Account.External_ID__c + ' ' + effectiveDate.format() + ' ID Card';
            idCardCase.recordtypeid = idCardRecordTypeId;
            idCardCase.GEMS_Line_of_Business__c = acctMaintCase.GEMS_Line_of_Business__c;
            idCardCase.GEMS_Rx_Vendor__c = acctMaintCase.GEMS_Rx_Vendor__c;
            idCardCase.Accountid = acctMaintCase.accountId;
            idCardCase.GEMS_Effective_Date__c = acctMaintCase.GEMS_Effective_Date__c;
            idCardCase.GEMS_Case_Effective_Date__c = acctMaintCase.GEMS_Case_Effective_Date__c;
            idCardCase.GEMS_Submission_Type__c = acctMaintCase.GEMS_Submission_Type__c;
            idCardCase.FSU_Location__c = acctMaintCase.FSU_Location__c;
            idCardCase.Status = 'In Progress';
            idCardCase.parentid = acctMaintCase.Id;
            idCardCase.HCSC_Division__c = acctMaintCase.HCSC_Division__c;
            idCardCase.GEMS_Submission_Sub_Type__c = acctMaintCase.GEMS_Submission_Sub_Type__c;
            idCardCase.GEMS_Account_Submission_Info__c = acctMaintCase.Id;
            idCardCase.GEMS_Private_Exchange__c = acctMaintCase.GEMS_Private_Exchange__c;
            idCardCase.GEMS_Private_Exchange_Values__c = acctMaintCase.GEMS_Private_Exchange_Values__c;
            idCardCase.Opportunity_Name__c = acctMaintCase.Opportunity_Name__c;
            idCardCase.Underwriter_Lookup__c = acctMaintCase.Underwriter_Lookup__c;
            idCardCase.GEMS_Submitter__c = acctMaintCase.ownerId;
            idCardCase.Funding_Type_Multiselect__c = acctMaintCase.Funding_Type_Multiselect__c;
            idCardCase.GEMS_StdCust_Product__c = acctMaintCase.GEMS_StdCust_Product__c;
            idCardCase.GEMS_Products__c = acctMaintCase.GEMS_Products__c;
            idCardCase.ownerId = acctMaintCase.ownerId;
            idCardCase.GEMS_ID_Cards_Format__c = acctMaintCase.GEMS_ID_Cards_Format__c;
            insert idCardCase;

            // SFDC-8197 Create the Account Setup Maint. case on release along with the ID card case creation 
            // create Account Setup Maintenance Case from its parent 
            Case acctSetupCase = new Case();
            effectiveDate = acctMaintCase.GEMS_Case_Effective_Date__c;            
            acctSetupCase.Type = 'Account Setup Maintenance';
            acctSetupCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c+' Account Setup Maintenance';                                   
            acctSetupCase.recordtypeid=accSetupRecordTypeId ;
            acctSetupCase.GEMS_Line_of_Business__c = acctMaintCase.GEMS_Line_of_Business__c;
            acctSetupCase.GEMS_Rx_Vendor__c = acctMaintCase.GEMS_Rx_Vendor__c;
            acctSetupCase.Accountid=acctMaintCase.accountId;
            acctSetupCase.GEMS_Effective_Date__c=acctMaintCase.GEMS_Effective_Date__c;
            acctSetupCase.GEMS_Case_Effective_Date__c = acctMaintCase.GEMS_Case_Effective_Date__c;
            acctSetupCase.GEMS_Submission_Type__c=acctMaintCase.GEMS_Submission_Type__c;
            acctSetupCase.FSU_Location__c=acctMaintCase.FSU_Location__c;
            acctSetupCase.Status='In Progress';
            acctSetupCase.parentid = acctMaintCase.Id;
            acctSetupCase.HCSC_Division__c=acctMaintCase.HCSC_Division__c;                        
            acctSetupCase.GEMS_Submission_Sub_Type__c=acctMaintCase.GEMS_Submission_Sub_Type__c;
            acctSetupCase.GEMS_Account_Submission_Info__c=acctMaintCase.Id;            
            acctSetupCase.GEMS_Private_Exchange__c = acctMaintCase.GEMS_Private_Exchange__c;     
            acctSetupCase.GEMS_Private_Exchange_Values__c = acctMaintCase.GEMS_Private_Exchange_Values__c;
            acctSetupCase.Opportunity_Name__c = acctMaintCase.Opportunity_Name__c;
            acctSetupCase.Underwriter_Lookup__c = acctMaintCase.Underwriter_Lookup__c;
            acctSetupCase.GEMS_Submitter__c = acctMaintCase.ownerId;
            acctSetupCase.Funding_Type_Multiselect__c = acctMaintCase.Funding_Type_Multiselect__c;                
            acctSetupCase.GEMS_StdCust_Product__c = acctMaintCase.GEMS_StdCust_Product__c;                                                                        
            acctSetupCase.GEMS_Products__c = acctMaintCase.GEMS_Products__c;
            List<CaseTeamMember> specialistIdList = [SELECT Id, memberid FROM CaseTeamMember where TeamRole.Name='Account Specialist' and ParentId = :acctMaintCaseId];
            if(specialistIdList.isEmpty()){ 
                acctSetupCase.ownerId = acctMaintCase.ownerId;
            } else { 
                acctSetupCase.ownerId = specialistIdList[0].memberid;
                acctSetupCase.GEMS_Quality_Reviewer__c = specialistIdList[0].memberid;                   
            }
            acctSetupCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = acctMaintCase.ownerId;
            //Add the As Is GEMS Process Entitlement            
              acctSetupCase.EntitlementId=activeEntitlement[0].Id;
            
            insert acctSetupCase;
                                                    
                // create Task record
                Task acctSetupCaseTask= new Task();
                acctSetupCaseTask.recordTypeId = maintenanceTaskTypeId; 
                acctSetupCaseTask.WhatId=acctSetupCase.Id;
                acctSetupCaseTask.Subject='BlueSTAR Entry Complete';
                acctSetupCaseTask.Status='In Progress';
                acctSetupCaseTask.Priority='Normal';
                acctSetupCaseTask.GEMS_Start_Date__c = System.now();
                acctSetupCaseTask.ownerId = acctSetupCase.ownerId;                                
                insert acctSetupCaseTask;
                   
            //update GEMS_Ready_to_release_to_screening__c field
            acctMaintCase.GEMS_Ready_to_release_to_screening__c = 'Released';
            acctMaintCase.status = 'In Progress';
            update acctMaintCase;
            return null;
        }
        Catch(Exception ex) {
            System.debug('Fail to release ID Card Maintenance case. Error = ' + ex.getMessage() + ex.getLineNumber());
            return 'Fail to release ID Card Maintenance case. Please contact GEMS support for assistance!';
        }       
    }


    
   
}