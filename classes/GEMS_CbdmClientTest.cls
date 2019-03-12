/* This Test class is to test both the GEMS_CbdmClient and HcscConnectUtil classes
 * Update History:
 * 08-23-2017    Luke Chen    SFDC-2702 Outgoing request to CBDM
 *
 */
@isTest
private class GEMS_CbdmClientTest{
    
    // Test method to test call out to CBDM for sending a form
    private static testmethod void testCallCBDMSubmitForm(){
        // setup and insert data
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Status__c = 'New';
        req.Hidden_HCSC_Division__c = 'IL';
        // req.Market_Segment__c = 'FEP';
        // req.District__c = '002';
        // req.Cluster__c = '002';
        req.Line_of_Business__c = 'SCP';
        req.Category__c = 'Contract Admin';
        req.comments__c = '06';
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
        goodForm.Reason__c = 'New Account; Renewal; Miscellaneous';
        insert goodForm;
        APP_CONNECT_SETTING__c cbdmConnSetting = new APP_CONNECT_SETTING__c();
        cbdmConnSetting.name ='CBDM';
        cbdmConnSetting.APP_ENV__c = 'GEM1';
        cbdmConnSetting.Username__c = 'abc';
        cbdmConnSetting.Password__c = 'abc';
        cbdmConnSetting.ClientID__c = 'abc';
        cbdmConnSetting.ClientSecret__c = 'abc';
        cbdmConnSetting.TOKEN_URL__c = 'https://test.com';
        cbdmConnSetting.CertificateUniqueName__c = null;
        insert cbdmConnSetting;
        APP_API_URL__c reqService = new APP_API_URL__c();
        reqService.name = 'CBDM_ContractRequestService';
        reqService.URL__c = 'https://test.com';
        APP_API_URL__c feedbackService = new APP_API_URL__c();
        feedbackService.name = 'CBDM_ContractFeedbackService';           
        feedbackService.URL__c = 'https://test.com';
        insert reqService; insert feedbackService;
        
        // query to make sure data are inserted
        GEMS_SBC_BB_Form__c form = [select id, Form_Id__c, Form_Request_Type__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(form.Form_Request_Type__c == 'Custom SBC', 'goodForm insert failed !!');
        // set up mock http response for callout testing
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCBDM());
        Test.startTest();
        String returnMsg = GEMS_CbdmClient.CallCBDMSubmitForm(form.Form_Id__c);
        form = [select id, Form_Id__c, Cbdm_Request_Trans_Id__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(returnMsg == null, 'Submit request to CBDM failed!' );
        Test.stopTest();
    }

    // Test method to test Mockup call out to CBDM
    // The difference is that the Cbdm_Request_Trans_Id__c field is prefix with 'MOCKUP-'
    private static testmethod void testCallCBDMSubmitFormMockup(){
        // setup and insert data
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Status__c = 'New';
        req .Hidden_HCSC_Division__c = 'IL';
        // req.Market_Segment__c = 'FEP';
        // req.District__c = '002';
        // req.Cluster__c = '002';
        req.Line_of_Business__c = 'SCP';
        req.Category__c = 'Contract Admin';
        req.comments__c = '06';
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
        goodForm.Reason__c = 'New Account; Renewal; Miscellaneous';
        // this is the difference that the Cbdm_Request_Trans_Id__c field is prefix with 'MOCKUP-'
        goodForm.Cbdm_Request_Trans_Id__c = 'MOCKUP-SBC00101';
        insert goodForm;
        APP_CONNECT_SETTING__c cbdmConnSetting = new APP_CONNECT_SETTING__c();
        cbdmConnSetting.name ='CBDM';
        cbdmConnSetting.APP_ENV__c = 'GEM1';
        cbdmConnSetting.Username__c = 'abc';
        cbdmConnSetting.Password__c = 'abc';
        cbdmConnSetting.ClientID__c = 'abc';
        cbdmConnSetting.ClientSecret__c = 'abc';
        cbdmConnSetting.TOKEN_URL__c = 'https://test.com';
        cbdmConnSetting.CertificateUniqueName__c = null;
        insert cbdmConnSetting;
        APP_API_URL__c reqService = new APP_API_URL__c();
        reqService.name = 'CBDM_ContractRequestService';
        reqService.URL__c = 'https://test.com';
        APP_API_URL__c feedbackService = new APP_API_URL__c();
        feedbackService.name = 'CBDM_ContractFeedbackService';           
        feedbackService.URL__c = 'https://test.com';
        insert reqService; insert feedbackService;
        
        // query to make sure data are inserted
        GEMS_SBC_BB_Form__c form = [select id, Form_Id__c, Form_Request_Type__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(form.Form_Request_Type__c == 'Custom SBC', 'goodForm insert failed !!');
        // set up mock http response for callout testing
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCBDM());
        Test.startTest();
        String returnMsg = GEMS_CbdmClient.CallCBDMSubmitForm(form.Form_Id__c);
        form = [select id, Form_Id__c, Cbdm_Request_Trans_Id__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(returnMsg == null, 'Submit request to CBDM failed!' );
        Test.stopTest();
    }    
    
    // Test method to test call out to CBDM for feedback service
    private static testmethod void testCallCBDMFeedback(){
        // setup and insert data
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Status__c = 'New';
        req.Hidden_HCSC_Division__c = 'IL';
        // req.Market_Segment__c = 'FEP';
        // req.District__c = '002';
        // req.Cluster__c = '002';
        req.Line_of_Business__c = 'SCP';
        req.Category__c = 'Contract Admin';
        req.comments__c = '06';
        insert req;
        GEMS_SBC_BB_Form__c goodForm = new GEMS_SBC_BB_Form__c();
        goodForm.GEMS_SBC_Request__c = req.id;
        goodForm.Form_Request_Type__c = 'Custom SBC';
        goodForm.Form_Id__c = 'SBC-0801';
        goodForm.Form_Status__c = 'Return';
        goodForm.CBDM_Status__c = 'SUCCESS';
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
        goodForm.Reason__c = 'New Account; Renewal; Miscellaneous';
        goodForm.Cbdm_Request_Trans_Id__c = 'SBC00101';
        insert goodForm;
        APP_CONNECT_SETTING__c cbdmConnSetting = new APP_CONNECT_SETTING__c();
        cbdmConnSetting.name ='CBDM';
        cbdmConnSetting.APP_ENV__c = 'GEM1';
        cbdmConnSetting.Username__c = 'abc';
        cbdmConnSetting.Password__c = 'abc';
        cbdmConnSetting.ClientID__c = 'abc';
        cbdmConnSetting.ClientSecret__c = 'abc';
        cbdmConnSetting.TOKEN_URL__c = 'https://test.com';
        cbdmConnSetting.CertificateUniqueName__c = null;
        insert cbdmConnSetting;
        APP_API_URL__c reqService = new APP_API_URL__c();
        reqService.name = 'CBDM_ContractRequestService';
        reqService.URL__c = 'https://test.com';
        APP_API_URL__c feedbackService = new APP_API_URL__c();
        feedbackService.name = 'CBDM_ContractFeedbackService';           
        feedbackService.URL__c = 'https://test.com';
        insert reqService; insert feedbackService;
        
        // query to make sure data are inserted
        GEMS_SBC_BB_Form__c form = [select id, Form_Id__c, Form_Request_Type__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(form.Form_Request_Type__c == 'Custom SBC', 'goodForm insert failed !!');
        // set up mock http response for callout testing
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCBDM());
        Test.startTest();
        String returnMsg = GEMS_CbdmClient.CallCBDMFeedback(form.Form_Id__c);
        form = [select id, Form_Id__c, Cbdm_Request_Trans_Id__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(returnMsg == null, 'Submit request to CBDM failed!' );
        Test.stopTest();
    }

    // Test method to test Mockup call out to CBDM
    // The difference is that the Cbdm_Request_Trans_Id__c field is prefix with 'MOCKUP-'
    private static testmethod void testCallCBDMFeedbackMockup(){
        // setup and insert data
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Status__c = 'New';
        req .Hidden_HCSC_Division__c = 'IL';
        // req.Market_Segment__c = 'FEP';
        // req.District__c = '002';
        // req.Cluster__c = '002';
        req.Line_of_Business__c = 'SCP';
        req.Category__c = 'Contract Admin';
        req.comments__c = '06';
        insert req;
        GEMS_SBC_BB_Form__c goodForm = new GEMS_SBC_BB_Form__c();
        goodForm.GEMS_SBC_Request__c = req.id;
        goodForm.Form_Request_Type__c = 'Custom SBC';
        goodForm.Form_Id__c = 'SBC-0801';
        goodForm.Form_Status__c = 'Return';
        goodForm.CBDM_Status__c = 'SUCCESS';
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
        goodForm.Reason__c = 'New Account; Renewal; Miscellaneous';
        // this is the difference that the Cbdm_Request_Trans_Id__c field is prefix with 'MOCKUP-'
        goodForm.Cbdm_Request_Trans_Id__c = 'MOCKUP-SBC00101';
        insert goodForm;
        APP_CONNECT_SETTING__c cbdmConnSetting = new APP_CONNECT_SETTING__c();
        cbdmConnSetting.name ='CBDM';
        cbdmConnSetting.APP_ENV__c = 'GEM1';
        cbdmConnSetting.Username__c = 'abc';
        cbdmConnSetting.Password__c = 'abc';
        cbdmConnSetting.ClientID__c = 'abc';
        cbdmConnSetting.ClientSecret__c = 'abc';
        cbdmConnSetting.TOKEN_URL__c = 'https://test.com';
        cbdmConnSetting.CertificateUniqueName__c = null;
        insert cbdmConnSetting;
        APP_API_URL__c reqService = new APP_API_URL__c();
        reqService.name = 'CBDM_ContractRequestService';
        reqService.URL__c = 'https://test.com';
        APP_API_URL__c feedbackService = new APP_API_URL__c();
        feedbackService.name = 'CBDM_ContractFeedbackService';           
        feedbackService.URL__c = 'https://test.com';
        insert reqService; insert feedbackService;
        
        // query to make sure data are inserted
        GEMS_SBC_BB_Form__c form = [select id, Form_Id__c, Form_Request_Type__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(form.Form_Request_Type__c == 'Custom SBC', 'goodForm insert failed !!');
        // set up mock http response for callout testing
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCBDM());
        Test.startTest();
        String returnMsg = GEMS_CbdmClient.CallCBDMFeedback(form.Form_Id__c);
        form = [select id, Form_Id__c, Cbdm_Request_Trans_Id__c from GEMS_SBC_BB_Form__c limit 1];
        System.assert(returnMsg == null, 'Submit request to CBDM failed!' );
        Test.stopTest();
    }    

    // this method is to test respectively the 2 methods in HcscConnectUtil class
    private static testmethod void testHcscConnectUtil(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCBDM());
        String token = HcscConnectUtil.fetchOAuth2JwtToken('123','123','123','123','https://test.com',null);
        System.assert(token == '123456789', 'failed! token = ' + token);
        Map<String, Object> results = HcscConnectUtil.consumeRestApiPost('{"abc","123"}','123','https://test.com',null);
        String status = (String) results.get('status');
        System.assert(status == 'success', 'failed! status = ' + status);        
    }

}