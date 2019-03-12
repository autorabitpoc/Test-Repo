/**************************************************************************************
  Apex Class Name     : GEMS_ReturnStatusComponentControllerTest
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for  GEMS_ReturnStatusComponentController 
  Modification Log    :
* Developer           : Date                   Description
* ----------------------------------------------------------------------------                 
* Gokul Bharati         08/21/2017             Original Version
* Shankar               08/25/2017             US-3044. Set value for HCSC_Division field
*************************************************************************************/

@isTest
private class GEMS_ReturnStatusComponentControllerTest{

   @testSetUp
   private static void testData(){
        Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
        Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();        
                
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
        SBCForm.Form_Status__c = 'New';
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
        BBForm.Form_Status__c = 'New';
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
  
   private static testmethod void SBCreturnStatusMethod(){
        User usr=[Select id from User where UserRole.Name like 'GEMS SBC Analyst%' AND isActive=true LIMIT 1];
        system.runAs(usr){
            GEMS_SBC_BB_Form__c reqform=[select id,recordTypeId from GEMS_SBC_BB_Form__c where Form_Request_Type__c = 'Custom SBC' LIMIT 1];
            Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();
            System.assertEquals(SBCrecordTypeId,reqform.recordTypeId);
            ApexPages.currentPage().getParameters().put('Id',reqform.id);
            PageReference pageRef = Page.GEMSReturnStatusRequestForm;
            GEMS_ReturnStatusComponentController retStatus = new GEMS_ReturnStatusComponentController();
            retStatus.selectedStatus ='Return';
            retStatus.addRow();
            retStatus.showReturnReasonBlock();
            retStatus.saveStatus();
            retStatus.setSelectedStatus();
            retStatus.cancel();
            retStatus.getMyOptions();            
            Test.setCurrentPage(pageRef);
        }
    }
    
    private static testmethod void SBCRoutedInErrorStatusMethod(){
        
            User usr=[Select id from User where UserRole.Name like 'GEMS SBC Analyst%' AND isActive=true LIMIT 1];
            system.runAs(usr){
            GEMS_SBC_BB_Form__c reqform=[select id,recordTypeId from GEMS_SBC_BB_Form__c where Form_Request_Type__c = 'Custom SBC' LIMIT 1];
            Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();
            System.assertEquals(SBCrecordTypeId,reqform.recordTypeId);
            ApexPages.currentPage().getParameters().put('Id',reqform.id);
            PageReference pageRef = Page.GEMSReturnStatusRequestForm;
            GEMS_ReturnStatusComponentController retStatus = new GEMS_ReturnStatusComponentController();
            retStatus.selectedStatus ='Routed In Error';
            retStatus.addRow();
            retStatus.showReturnReasonBlock();
            retStatus.saveStatus();
            retStatus.setSelectedStatus();
            retStatus.cancel();
            retStatus.getMyOptions();
            Test.setCurrentPage(pageRef);
        }
    }
    
    private static testmethod void BenefitBookletreturnStatusMethod(){
    
        User usr=[Select id from User where UserRole.Name like 'GEMS Contract Specialist%' AND isActive=true LIMIT 1];
        system.runAs(usr){
            GEMS_SBC_BB_Form__c reqform=[select id,recordTypeId from GEMS_SBC_BB_Form__c where Form_Request_Type__c = 'Custom Benefit Booklet' LIMIT 1];        
            Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
            System.assertEquals(BBrecordTypeId,reqform.recordTypeId);        
            ApexPages.currentPage().getParameters().put('Id',reqform.id);
            PageReference pageRef = Page.GEMSReturnStatusRequestForm;
            GEMS_ReturnStatusComponentController retStatus = new GEMS_ReturnStatusComponentController();
            retStatus.selectedStatus ='Return';
            retStatus.addRow();
            retStatus.showReturnReasonBlock();
            retStatus.saveStatus();
            retStatus.setSelectedStatus();
            retStatus.cancel();
            retStatus.getMyOptions();            
            Test.setCurrentPage(pageRef);
        }
    }
    
    private static testmethod void BenefitBookletRoutedInErrorStatusMethod(){
        User usr=[Select id from User where UserRole.Name like 'GEMS Contract Specialist%' AND isActive=true LIMIT 1];
        system.runAs(usr){
            GEMS_SBC_BB_Form__c reqform=[select id,recordTypeId from GEMS_SBC_BB_Form__c where Form_Request_Type__c = 'Custom Benefit Booklet' LIMIT 1];        
            Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
            System.assertEquals(BBrecordTypeId,reqform.recordTypeId);        
            ApexPages.currentPage().getParameters().put('Id',reqform.id);
            PageReference pageRef = Page.GEMSReturnStatusRequestForm;
            GEMS_ReturnStatusComponentController retStatus = new GEMS_ReturnStatusComponentController();
            retStatus.selectedStatus ='Routed In Error';
            retStatus.addRow();
            retStatus.showReturnReasonBlock();
            retStatus.saveStatus();
            retStatus.setSelectedStatus();
            retStatus.cancel();
            retStatus.getMyOptions();
            Test.setCurrentPage(pageRef);
        }
    }
    
    private static testmethod void OtherreturnStatusMethod(){
        User usr=[Select id from User where UserRole.Name like 'GEMS SBC Analyst%' AND isActive=true LIMIT 1];
        system.runAs(usr){
            GEMS_SBC_BB_Form__c reqform=[select id,recordTypeId from GEMS_SBC_BB_Form__c where Form_Request_Type__c = 'Custom SBC' LIMIT 1];
            Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();
            System.assertEquals(SBCrecordTypeId,reqform.recordTypeId);
            ApexPages.currentPage().getParameters().put('Id',reqform.id);
            PageReference pageRef = Page.GEMSReturnStatusRequestForm;
            GEMS_ReturnStatusComponentController retStatus = new GEMS_ReturnStatusComponentController();
            retStatus.selectedStatus ='Other';
            retStatus.addRow();
            retStatus.showReturnReasonBlock();
            retStatus.saveStatus();
            retStatus.setSelectedStatus();
            retStatus.cancel();
            retStatus.getMyOptions();            
            Test.setCurrentPage(pageRef);
        }
    }
    
}