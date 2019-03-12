/******************************************************************************************************************************
Name        : GEMS_MBCTestingCreate
Description : Common class to create Medical Benefit Testing records. Being called from custom buttons in GEMS_MBC_Testing__c.
Test Class  : GEMS_MBCTestingCreateTest
Version History:
Date        Developer               Description
09/08/2017  Bharath                 Initial version. SFDC-4235, SFDC-3369, SFDC-4305
09/26/2017  Bharath                 6593 - DTU sign-off date to be picked only from the first DTU record created. 
10/04/2017	Bharath					6742 - Populate the MBC parent level case details in the new testing records.
******************************************************************************************************************************/
global class GEMS_MBCTestingCreate {
    public GEMS_MBCTestingCreate(){}
    webservice static Id NewMBCTest(Id MBCId, String TestType){
        GEMS_MBC_Testing__c NewMBCTestRec;
        list<Group> assignQueue;
        map<string, Id> TestRecType = new map<string, Id>();
        TestRecType.put('DTU', Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('DTU Testing').getRecordTypeId());
        TestRecType.put('CDHP', Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('CDHP Testing').getRecordTypeId());
        TestRecType.put('FEAK', Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Analysis').getRecordTypeId());
        TestRecType.put('SAT', Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('Shared Accums Testing').getRecordTypeId());
        Case MBCCase = [select Id,Opportunity_Name__c, AccountId, GEMS_Benefit_Agreement__c, ownerid, GEMS_Owner_Email__c, GEMS_Coding_Complete_Date__c, ParentId from Case where Id = :MBCId limit 1];
        list<GEMS_MBC_Testing__c> DTUTest = [select Id, DTU_Sign_Off_Date__c from GEMS_MBC_tESTING__C where MBC_BA_Level_Case_DTU__c = :MBCId order by name limit 1];
        if(MBCCase != NULL){
            NewMBCTestRec = new GEMS_MBC_Testing__c();
            // Update different lookup fields based on the testing type passed from the javascript. 
            if (TestType == 'DTU'){
                assignQueue = [select Id from Group where Name = 'GEMS DTU Queue' and Type = 'Queue' limit 1];
                NewMBCTestRec.MBC_BA_Level_Case_DTU__c = MBCCase.Id;                
            }
            else if(TestType == 'CDHP'){
                assignQueue = [select Id from Group where Name = 'GEMS CDHP Operations Queue' and Type = 'Queue' limit 1];
                NewMBCTestRec.MBC_BA_Level_Case_CDHP__c = MBCCase.Id;                
            }
            else if(TestType == 'FEAK'){
                assignQueue = [select Id from Group where Name = 'GEMS FEAK Analysis Queue' and Type = 'Queue' limit 1];
                NewMBCTestRec.MBC_BA_Level_Case_FEAK__c = MBCCase.Id;                
            }
            else if(TestType == 'SAT'){
                assignQueue = [select Id from Group where Name = 'GEMS DTU Queue' and Type = 'Queue' limit 1];
                NewMBCTestRec.MBC_BA_Level_Case_Shared_Accums__c = MBCCase.Id;                
            }
            NewMBCTestRec.OwnerId = assignQueue[0].Id;
            NewMBCTestRec.recordtypeId = TestRecType.get(TestType);
            NewMBCTestRec.BA_No__c = MBCCase.GEMS_Benefit_Agreement__c;
            //6742 - Populate the MBC parent level case details in the MBC testing records. 
            NewMBCTestRec.MBC_Parent_Case__c = MBCCase.ParentId;
            //Use the email id for failure notifications to case owner. If the case is assigned to a queue, notifications should be sent to dummy email address. 
            if(MBCCase.GEMS_Owner_Email__c != NULL){
                NewMBCTestRec.Case_Owner_Email__c= MBCCase.GEMS_Owner_Email__c;
            }
            else {
                //Notification should be sent to a dummy id (ex. noreply@hcsc.com) when the case is assigned to a group and the testing fails. This dummy email is controlled in label GEMS_Noreply.
                NewMBCTestRec.Case_Owner_Email__c = system.label.GEMS_Noreply;
            }
            if (TestType != 'DTU'){
                for(GEMS_MBC_Testing__c DTUDate : DTUTest){
                    NewMBCTestRec.DTU_Sign_Off_Date__c = DTUDate.DTU_Sign_Off_Date__c;
                    NewMBCTestRec.DTU_Record_Id_Invisible__c = DTUDate.Id;
                }
            }
            insert NewMBCTestRec;
        }
        return(NewMBCTestRec.id);
    }

}