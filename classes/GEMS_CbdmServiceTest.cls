/* This Test method is to test the GEMS_CbdmService class
 * Update History:
 * 08-23-2017    Luke Chen    SFDC-4718 incoming request from CBDM
 * 08-25-2017    Shankar      SFDC-3044 Set value for HCSC_Division field
 *
 */
@isTest
private class GEMS_CbdmServiceTest{

    @testSetup
    static void dataSetup() {
        
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Status__c = 'New';
        req.Hidden_HCSC_Division__c = 'IL';
        // req.Market_Segment__c = 'NAC';
        // req.District__c = '038';
        // req.Cluster__c = '018';
        req.Line_of_Business__c = 'SCP';
        req.Category__c = 'Contract Admin';
        req.comments__c = '07';
        insert req;

        GEMS_SBC_BB_Form__c goodForm = new GEMS_SBC_BB_Form__c();
        goodForm.GEMS_SBC_Request__c = req.id;
        goodForm.Form_Request_Type__c = 'Custom SBC';
        goodForm.Form_Id__c = 'SBC-0801';
        goodForm.CBDM_Status__c = 'New';
        goodForm.Grandfathered_Benefit_s__c = 'No';
        goodForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        goodForm.Associated_Benefit_Agreements__c = 'BA001';
        goodForm.Minimum_Essential_Coverage_MEC__c = 'No';
        goodForm.Minimum_Value_Standard_MV__c = 'No';
        goodForm.Number_of_documents_being_requested__c = 2;
        goodForm.Current_No_of_Members__c = 5;
        goodForm.Distribution_Method__c = 'Portal';
        goodForm.Mental_Health__c = false;
        goodForm.Other__c = false;
        goodForm.Resubmission__c = false;
        goodForm.Rush__c = 'No';
        goodForm.Rx__c = false;
        goodForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        goodForm.Translation__c = 'No';
        insert goodForm;
    }

    // test Post method for not finding SBC form
    private static testmethod void testDoPostFail(){
        GEMS_CbdmService.GEMS_CbdmServiceResponse resp = GEMS_CbdmService.doPost('SBC-0005','In Progress','success');
        System.assertEquals(resp.status, 'fail');
    }

    // test Post method for empty form ID
    private static testmethod void testDoPostFailEmptyId(){
        GEMS_CbdmService.GEMS_CbdmServiceResponse resp = GEMS_CbdmService.doPost('','In Progress','success');
        System.assertEquals(resp.status, 'fail');
    }
    
    // test Post method for success
    private static testmethod void testDoPostSuccess(){
        GEMS_SBC_BB_Form__c form = [select id, Form_Id__c from GEMS_SBC_BB_Form__c limit 1];
        GEMS_CbdmService.GEMS_CbdmServiceResponse resp = GEMS_CbdmService.doPost(form.Form_Id__c ,'In Progress','success');
        System.assert(resp.status == 'success', 'update cbdm status failed!');
    }

    // test Post method for success on Mockup form_Id__c with appended '-SI' for testing in SIT env
    private static testmethod void testDoPostMockup(){
        GEMS_SBC_BB_Form__c form = [select id, Form_Id__c from GEMS_SBC_BB_Form__c limit 1];
        form.Form_Id__c = form.Form_Id__c + '-SI';
        GEMS_CbdmService.GEMS_CbdmServiceResponse resp = GEMS_CbdmService.doPost(form.Form_Id__c,'In Progress','success');
       // System.assert(resp.status == 'success', 'update cbdm status failed!');
    }
}