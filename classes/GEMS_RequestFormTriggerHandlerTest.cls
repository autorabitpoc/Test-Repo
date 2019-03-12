@isTest
private class GEMS_RequestFormTriggerHandlerTest{

static testmethod void SBCParentToChildInProgressStatusUpdation(){
        
        Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
        Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();        
        User usr=[Select id from User where UserRole.Name like 'GEMS SBC Analyst%' AND isActive=true LIMIT 1];
        system.runAs(usr){        
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Hidden_HCSC_Division__c = 'IL';
        req.Status__c = 'New';
        req.Line_of_Business__c = 'SCP';
        req.Category__c  = 'Contract Admin';
        req.comments__c = '06';
        insert req;
    
        GEMS_SBC_BB_Form__c SBCForm= new GEMS_SBC_BB_Form__c();
        SBCForm.GEMS_SBC_Request__c = req.id;
        SBCForm.Form_Request_Type__c = 'Custom SBC';
        SBCForm.Form_Id__c = 'SBC-0000001';
        SBCForm.CBDM_Status__c = 'New';
        SBCForm.Grandfathered_Benefit_s__c = 'No';
        SBCForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        SBCForm.Associated_Benefit_Agreements__c = 'BA001';
        SBCForm.Minimum_Essential_Coverage_MEC__c = 'No';
        SBCForm.Minimum_Value_Standard_MV__c = 'No';
        SBCForm.Number_of_documents_being_requested__c = 2;
        SBCForm.Current_No_of_Members__c = 5;
        SBCForm.Distribution_Method__c = 'Portal';
        SBCForm.Mental_Health__c = false;
        SBCForm.Other__c = false;
        SBCForm.Resubmission__c = false;
        SBCForm.Rush__c = 'No';
        SBCForm.Rx__c = false;
        SBCForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        SBCForm.Translation__c = 'No';
        SBCForm.recordTypeId=SBCrecordTypeId;
        insert SBCForm;
        
        GEMS_SBC_BB_Form__c BBForm= new GEMS_SBC_BB_Form__c();
        BBForm.GEMS_SBC_Request__c = req.id;
        BBForm.Form_Request_Type__c = 'Custom Benefit Booklet';
        BBForm.Form_Id__c = 'SBC-0000001';
        BBForm.CBDM_Status__c = 'New';
        BBForm.Grandfathered_Benefit_s__c = 'No';
        BBForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        BBForm.Associated_Benefit_Agreements__c = 'BA001';
        BBForm.Minimum_Essential_Coverage_MEC__c = 'No';
        BBForm.Minimum_Value_Standard_MV__c = 'No';
        BBForm.Number_of_documents_being_requested__c = 2;
        BBForm.Current_No_of_Members__c = 5;
        BBForm.Distribution_Method__c = 'Portal';
        BBForm.Mental_Health__c = false;
        BBForm.Other__c = false;
        BBForm.Resubmission__c = false;
        BBForm.Rush__c = 'No';
        BBForm.Rx__c = false;
        BBForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        BBForm.Translation__c = 'No';
        BBForm.RecordTypeId=BBrecordTypeId;
        insert BBForm;
        }
   }
   
   static testmethod void SBCParentToChildApprovedStatusUpdation(){
   
        Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
        Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();        
        User usr=[Select id from User where UserRole.Name like 'GEMS SBC Analyst%' AND isActive=true LIMIT 1];
        system.runAs(usr){        
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Hidden_HCSC_Division__c = 'IL';
        req.Status__c = 'In Progress';
        req.Line_of_Business__c = 'SCP';
        req.Category__c  = 'Contract Admin';
        req.comments__c = '06';
        insert req;
    
        GEMS_SBC_BB_Form__c SBCForm= new GEMS_SBC_BB_Form__c();
        SBCForm.GEMS_SBC_Request__c = req.id;
        SBCForm.Form_Request_Type__c = 'Custom SBC';
        SBCForm.Form_Id__c = 'SBC-0000001';
        SBCForm.Form_Status__c = 'In Progress';
        SBCForm.Grandfathered_Benefit_s__c = 'No';
        SBCForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        SBCForm.Associated_Benefit_Agreements__c = 'BA001';
        SBCForm.Minimum_Essential_Coverage_MEC__c = 'No';
        SBCForm.Minimum_Value_Standard_MV__c = 'No';
        SBCForm.Number_of_documents_being_requested__c = 2;
        SBCForm.Current_No_of_Members__c = 5;
        SBCForm.Distribution_Method__c = 'Portal';
        SBCForm.Mental_Health__c = false;
        SBCForm.Other__c = false;
        SBCForm.Resubmission__c = false;
        SBCForm.Rush__c = 'No';
        SBCForm.Rx__c = false;
        SBCForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        SBCForm.Translation__c = 'No';
        SBCForm.recordTypeId=SBCrecordTypeId;
        insert SBCForm;
        SBCForm.Form_Status__c = 'Approved';
        update SBCForm; 
        
        GEMS_SBC_BB_Form__c BBForm= new GEMS_SBC_BB_Form__c();
        BBForm.GEMS_SBC_Request__c = req.id;
        BBForm.Form_Request_Type__c = 'Custom Benefit Booklet';
        BBForm.Form_Id__c = 'SBC-0000001';
        BBForm.Form_Status__c = 'In Progress';
        BBForm.Grandfathered_Benefit_s__c = 'No';
        BBForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        BBForm.Associated_Benefit_Agreements__c = 'BA001';
        BBForm.Minimum_Essential_Coverage_MEC__c = 'No';
        BBForm.Minimum_Value_Standard_MV__c = 'No';
        BBForm.Number_of_documents_being_requested__c = 2;
        BBForm.Current_No_of_Members__c = 5;
        BBForm.Distribution_Method__c = 'Portal';
        BBForm.Mental_Health__c = false;
        BBForm.Other__c = false;
        BBForm.Resubmission__c = false;
        BBForm.Rush__c = 'No';
        BBForm.Rx__c = false;
        BBForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        BBForm.Translation__c = 'No';
        BBForm.RecordTypeId=BBrecordTypeId;
        insert BBForm;
        BBForm.Form_Status__c = 'Approved';
        update BBForm; 
        }
   }
   
   
static testmethod void BBParentToChildInProgressStatusUpdation(){
        
        Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
        Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();        
        User usr=[Select id from User where UserRole.Name like 'GEMS Contract Specialist%' AND isActive=true LIMIT 1];
        system.runAs(usr){        
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Hidden_HCSC_Division__c = 'IL';
        req.Status__c = 'New';
        req.Line_of_Business__c = 'SCP';
        req.Category__c  = 'Contract Admin';
        req.comments__c = '06';
        insert req;
    
        GEMS_SBC_BB_Form__c SBCForm= new GEMS_SBC_BB_Form__c();
        SBCForm.GEMS_SBC_Request__c = req.id;
        SBCForm.Form_Request_Type__c = 'Custom SBC';
        SBCForm.Form_Id__c = 'SBC-0000001';
        SBCForm.CBDM_Status__c = 'New';
        SBCForm.Grandfathered_Benefit_s__c = 'No';
        SBCForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        SBCForm.Associated_Benefit_Agreements__c = 'BA001';
        SBCForm.Minimum_Essential_Coverage_MEC__c = 'No';
        SBCForm.Minimum_Value_Standard_MV__c = 'No';
        SBCForm.Number_of_documents_being_requested__c = 2;
        SBCForm.Current_No_of_Members__c = 5;
        SBCForm.Distribution_Method__c = 'Portal';
        SBCForm.Mental_Health__c = false;
        SBCForm.Other__c = false;
        SBCForm.Resubmission__c = false;
        SBCForm.Rush__c = 'No';
        SBCForm.Rx__c = false;
        SBCForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        SBCForm.Translation__c = 'No';
        SBCForm.recordTypeId=SBCrecordTypeId;
        insert SBCForm;
        
        GEMS_SBC_BB_Form__c BBForm= new GEMS_SBC_BB_Form__c();
        BBForm.GEMS_SBC_Request__c = req.id;
        BBForm.Form_Request_Type__c = 'Custom Benefit Booklet';
        BBForm.Form_Id__c = 'SBC-0000001';
        BBForm.CBDM_Status__c = 'New';
        BBForm.Grandfathered_Benefit_s__c = 'No';
        BBForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        BBForm.Associated_Benefit_Agreements__c = 'BA001';
        BBForm.Minimum_Essential_Coverage_MEC__c = 'No';
        BBForm.Minimum_Value_Standard_MV__c = 'No';
        BBForm.Number_of_documents_being_requested__c = 2;
        BBForm.Current_No_of_Members__c = 5;
        BBForm.Distribution_Method__c = 'Portal';
        BBForm.Mental_Health__c = false;
        BBForm.Other__c = false;
        BBForm.Resubmission__c = false;
        BBForm.Rush__c = 'No';
        BBForm.Rx__c = false;
        BBForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        BBForm.Translation__c = 'No';
        BBForm.RecordTypeId=BBrecordTypeId;
        insert BBForm;
        }
   }
   
   static testmethod void BBParentToChildApprovedStatusUpdation(){
   
        Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
        Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();        
        User usr=[Select id from User where UserRole.Name like 'GEMS Contract Specialist%' AND isActive=true LIMIT 1];
        system.runAs(usr){        
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Hidden_HCSC_Division__c = 'IL';
        req.Status__c = 'In Progress';
        req.Line_of_Business__c = 'SCP';
        req.Category__c  = 'Contract Admin';
        req.comments__c = '06';
        insert req;
    
        GEMS_SBC_BB_Form__c SBCForm= new GEMS_SBC_BB_Form__c();
        SBCForm.GEMS_SBC_Request__c = req.id;
        SBCForm.Form_Request_Type__c = 'Custom SBC';
        SBCForm.Form_Id__c = 'SBC-0000001';
        SBCForm.Form_Status__c = 'In Progress';
        SBCForm.Grandfathered_Benefit_s__c = 'No';
        SBCForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        SBCForm.Associated_Benefit_Agreements__c = 'BA001';
        SBCForm.Minimum_Essential_Coverage_MEC__c = 'No';
        SBCForm.Minimum_Value_Standard_MV__c = 'No';
        SBCForm.Number_of_documents_being_requested__c = 2;
        SBCForm.Current_No_of_Members__c = 5;
        SBCForm.Distribution_Method__c = 'Portal';
        SBCForm.Mental_Health__c = false;
        SBCForm.Other__c = false;
        SBCForm.Resubmission__c = false;
        SBCForm.Rush__c = 'No';
        SBCForm.Rx__c = false;
        SBCForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        SBCForm.Translation__c = 'No';
        SBCForm.recordTypeId=SBCrecordTypeId;
        insert SBCForm;
        SBCForm.Form_Status__c = 'Approved';
        update SBCForm; 
        
        GEMS_SBC_BB_Form__c BBForm= new GEMS_SBC_BB_Form__c();
        BBForm.GEMS_SBC_Request__c = req.id;
        BBForm.Form_Request_Type__c = 'Custom Benefit Booklet';
        BBForm.Form_Id__c = 'SBC-0000001';
        BBForm.Form_Status__c = 'In Progress';
        BBForm.Grandfathered_Benefit_s__c = 'No';
        BBForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        BBForm.Associated_Benefit_Agreements__c = 'BA001';
        BBForm.Minimum_Essential_Coverage_MEC__c = 'No';
        BBForm.Minimum_Value_Standard_MV__c = 'No';
        BBForm.Number_of_documents_being_requested__c = 2;
        BBForm.Current_No_of_Members__c = 5;
        BBForm.Distribution_Method__c = 'Portal';
        BBForm.Mental_Health__c = false;
        BBForm.Other__c = false;
        BBForm.Resubmission__c = false;
        BBForm.Rush__c = 'No';
        BBForm.Rx__c = false;
        BBForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        BBForm.Translation__c = 'No';
        BBForm.RecordTypeId=BBrecordTypeId;
        insert BBForm;
        BBForm.Form_Status__c = 'Approved';
        update BBForm; 
        }
   }
}