/* This class is a REST client to connect to CBDM and call its api service
 * Update History:
 * 08-19-2017   Luke Chen   SFDC-2702 Outgoing call to CBDM api service
 * 11-22-2017   Luke Chen   SFDC-7429 CBDM and SBC request form integration additions
 * 03-16-2018   Luke Chen   SFDC-8465 GEMS: SBC - Do encoding of text fields for transfer to CBDM
 * 06-18-2018   Luke Chen   SFDC-10276 GEMS: Add CBDM functionality (for SBC forms) in Cosmetic and Account Eligibility Maintenance
 */

global class GEMS_CbdmClient{
    private static Integer SUBMIT_FORM = 1;
    private static Integer FEEDBACK = 2;
    private static Integer ONE_STRING = 1;
    private static Integer MULTI_SELECT = 2;
    private static Integer ONE_STRING_255 = 3;
    private static Integer ONE_STRING_R6 = 4;
    private static String MOCKUP = 'MOCKUP-';
    
    /* CallCBDMSubmitForm method
     * 1. retrieve form data using the passed in formId
     * 2. append env abbrev such as '-SI' or '-UA' in Test env for testing purpose
     * 3. compose Rest body
     * 4. Call out to CBDM REST service api
     */
    webservice Static string CallCBDMSubmitForm(string formId){
        GEMS_SBC_BB_Form__c form = [select id, Account_Name_Text__c, Account_Number__c, HCSC_Division__c, Market_Segment__c, District__c, Cluster__c, Open_Enrollment_Start_Date__c,
                                    Category__c, Submission_Sub_Type__c, Submission_Type__c, Effective_Date__c, Form_Request_Type__c, CreatedBy.name, Opportunity_SharePoint_Link__c, Case_SharePoint_Link__c,
                                    createddate, Form_Status__c, Associated_Benefit_Agreements__c, Grandfathered_Benefit_s__c, Carved_Out_Benefits_From_Other_Vendors__c,
                                    Mental_Health__c, Rx__c, Other__c, Minimum_Essential_Coverage_MEC__c, Minimum_Value_Standard_MV__c, Current_No_of_Members__c,
                                    Number_of_documents_being_requested__c, Rush__c, Reason_for_Rush__c, Special_Handling__c, Translation__c, Chinese_specify_BAs__c,
                                    Navajo_specify_BAs__c, Polish_specify_BAs__c, Spanish_specify_BAs__c, Tagalog_specify_BAs__c, Distribution_Method__c,
                                    Cost_Center__c, Ship_To_Address__c, Did_HCSC_Create_the_SBC_or_BB_Last_Year__c, Reason__c, Standard_fully_insured_or_Blue_Direction__c,
                                    Resubmission__c, Cbdm_Request_Trans_Id__c, (select title, body from Notes order by lastmodifieddate desc) 
                                    from GEMS_SBC_BB_Form__c where Form_Id__c = :formId limit 1];
        String env = GEMS_Utility.getEnvName();
        String envAbbr = GEMS_Utility.getEnvAbbrName();
        
        // if not PROD, check if we do Mockup response for mockup testing
        if(env != GEMS_Constants.PROD){
            MOCKUP_RESPONSE__c useMockupResp = MOCKUP_RESPONSE__c.getValues('CBDM');
            boolean isMockup = (useMockupResp != null && useMockupResp.USE_MOCKUP__c ? true : false );
            // if the record is already used for Mockup respose, keep using Mockup response so we do not mess up the CBDM
            if(form.Cbdm_Request_Trans_Id__c != null && form.Cbdm_Request_Trans_Id__c.contains(MOCKUP)) isMockup = true;
            
            // use Mockup response
            if(isMockup){
                doMockupResponse(formId, form);
                return null;
            }
        }
    
        // append envAbbr such as '-UA', '-SI', etc. if it's not PROD env
        // This is for testing env because GEMS has multiple testing envs but CBDM has only one
        // form ID is a unique key so we append envAbbr and send to CBDM to avoid duplicate with other GEMS envs
        String newFormId = (env == GEMS_Constants.PROD ? formId : formId + '-' + envAbbr);
        // operation parameter to CBDM
        String operation = (form.Cbdm_Request_Trans_Id__c == null ? 'create' : 'update');
        boolean resubmission = (form.Cbdm_Request_Trans_Id__c == null ? false : true);
        // sharepoint path
        // SFDC-10276 if it's maintenance case, use case's sharepoint link; otherwise, use opportunity's
        String sp = (form.Submission_Type__c == 'Cosmetic Account Maintenance' || form.Submission_Type__c == 'Account Eligibility Maintenance' ? form.Case_SharePoint_Link__c : form.Opportunity_SharePoint_Link__c);
        String noteString = '';
        // only get the latest note to send to CBDM
        if(form.notes != null && ! form.notes.isEmpty()) noteString = form.notes[0].title + ' - ' + form.notes[0].body;
        // produce the queue name to assign as form owner after sending form to CBDM
        String queueName = null;
        if(form.Form_Request_Type__c == GEMS_Constants.SbcTypeReq) queueName = 'SBC_Analyst_'+ form.HCSC_Division__c +'_Queue'; 
        else if(form.Form_Request_Type__c == GEMS_Constants.BbTypeReq) queueName = 'Benefit_Booklet_Analyst_'+ form.HCSC_Division__c +'_Queue';
        
        // SFDC-8465 produce REST body content using JSONGenerator to convert special chars
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeStringField('accountName', processString(form.Account_Name_Text__c, ONE_STRING_255));
        gen.writeStringField('accountNumber', processString(form.Account_Number__c, ONE_STRING_R6));
        gen.writeStringField('hCSCDivision', processString(form.HCSC_Division__c, ONE_STRING));
        gen.writeStringField('marketSegment', processString(form.Market_Segment__c, ONE_STRING));
        gen.writeStringField('district', processString(form.District__c, ONE_STRING));
        gen.writeStringField('cluster', processString(form.Cluster__c, ONE_STRING));
        gen.writeStringField('openEnrollmentDate',  processString(form.Open_Enrollment_Start_Date__c, ONE_STRING));
        gen.writeStringField('category', processString(form.Category__c, ONE_STRING) );
        gen.writeStringField('submissionType', processString(form.Submission_Type__c, ONE_STRING));
        gen.writeObjectField('submissionSubType', processList(form.Submission_Sub_Type__c));
        gen.writeStringField('effectiveDate', processString(form.Effective_Date__c, ONE_STRING));
        gen.writeStringField('comments', processString(noteString, ONE_STRING));
        gen.writeStringField('linkToSharepointFolder', processString(sp, ONE_STRING));
        gen.writeStringField('operation', operation);
        gen.writeStringField('cbdmContractRequestTransId', processString(form.Cbdm_Request_Trans_Id__c, ONE_STRING));
        gen.writeStringField('cbdmClient', 'Salesforce');
        gen.writeStringField('formrecordID', processString(newFormId, ONE_STRING));
        gen.writeStringField('name', processString(form.Form_Request_Type__c, ONE_STRING));
        gen.writeStringField('formCreatedBy', processString(form.CreatedBy.name, ONE_STRING));
        gen.writeStringField('formCreatedDateTime', processString(form.createddate.format('MM/dd/yyyy'), ONE_STRING));
        gen.writeStringField('formRequestType', processString(form.Form_Request_Type__c, ONE_STRING));
        // status will always be "In Progress" when sending to CBDM
        gen.writeStringField('formStatus', 'In Progress');
        gen.writeStringField('associatedBenefitAgreements', processString(form.Associated_Benefit_Agreements__c, ONE_STRING));
        gen.writeStringField('grandfatheredBenefit', processString(form.Grandfathered_Benefit_s__c, ONE_STRING));
        gen.writeStringField('carvedOutBenefitsFromOtherVendors', processString(form.Carved_Out_Benefits_From_Other_Vendors__c, ONE_STRING));
        gen.writeStringField('mentalHealth', processBoolean(form.Mental_Health__c));
        gen.writeStringField('rx', processBoolean(form.Rx__c));
        gen.writeStringField('other', processBoolean(form.Other__c));
        gen.writeStringField('minimumEssentialCoverageMEC', processString(form.Minimum_Essential_Coverage_MEC__c, ONE_STRING));
        gen.writeStringField('minimumValueStandardMV', processString(form.Minimum_Value_Standard_MV__c, ONE_STRING));
        gen.writeStringField('currentOfMembers', processDecimal(form.Current_No_of_Members__c));
        gen.writeStringField('numberofDocsBeingrequested', processDecimal(form.Number_of_documents_being_requested__c));
        gen.writeStringField('rush', processString(form.Rush__c, ONE_STRING));
        gen.writeStringField('reasonForRush', processString(form.Reason_for_Rush__c, ONE_STRING));
        gen.writeObjectField('specialHandling', processList(form.Special_Handling__c));
        gen.writeStringField('translation', processString(form.Translation__c, ONE_STRING));
        gen.writeStringField('chineseSpecifyBAs', processString(form.Chinese_specify_BAs__c, ONE_STRING));
        gen.writeStringField('navajoSpecifyBAs', processString(form.Navajo_specify_BAs__c, ONE_STRING));
        gen.writeStringField('polishSpecifyBAs', processString(form.Polish_specify_BAs__c, ONE_STRING));
        gen.writeStringField('spanishSpecifyBAs', processString(form.Spanish_specify_BAs__c, ONE_STRING));
        gen.writeStringField('tagalogSpecifyBAs', processString(form.Tagalog_specify_BAs__c, ONE_STRING));
        gen.writeStringField('distributionMethod', processString(form.Distribution_Method__c, ONE_STRING));
        gen.writeStringField('costCenter', processString(form.Cost_Center__c, ONE_STRING));
        gen.writeStringField('shipToAddress', processString(form.Ship_To_Address__c, ONE_STRING));
        gen.writeStringField('didHCSCCreatetheSBCorBBLastYear', processString(form.Did_HCSC_Create_the_SBC_or_BB_Last_Year__c, ONE_STRING));
        gen.writeObjectField('reason', processList(form.Reason__c));
        gen.writeStringField('standardFullyInsuredorBlueDirectionsProductsIncluded', processString(form.Standard_fully_insured_or_Blue_Direction__c, ONE_STRING));
        gen.writeStringField('resubmission', processBoolean(resubmission));
        gen.writeEndObject();
        // Call out to CBDM
        calloutCBDM(form.id, form.Cbdm_Request_Trans_Id__c, gen.getAsString(), SUBMIT_FORM, queueName);
        return null;
    }
    
    webservice Static string CallCBDMFeedback(string formId){
        GEMS_SBC_BB_Form__c form = [select id, Form_Status__c, Cbdm_Request_Trans_Id__c, Approval_Status__c from GEMS_SBC_BB_Form__c where Form_Id__c = :formId limit 1];
        /* no return status is needed
        GEMS_SBC_BB_Form__c form = [select id, Form_Status__c, Cbdm_Request_Trans_Id__c, Approval_Status__c, 
                                    (SELECT GEMS_Type__c, Return_Reason__c FROM GEMS_Return_Reasons__r order by CreatedDate desc) 
                                    from GEMS_SBC_BB_Form__c where Form_Id__c = :formId limit 1]; */
        List<ProcessInstanceStep> stepList = [SELECT Id, Comments FROM ProcessInstanceStep where stepstatus = :form.Approval_Status__c and ProcessInstance.targetobjectid = :form.id order by createddate desc];
        String comments = (stepList.isEmpty() ? '' : stepList[0].comments);
        String env = GEMS_Utility.getEnvName();
        String envAbbr = GEMS_Utility.getEnvAbbrName();
        
        // if not PROD, check if we do Mockup response for mockup testing
        if(env != GEMS_Constants.PROD){
            MOCKUP_RESPONSE__c useMockupResp = MOCKUP_RESPONSE__c.getValues('CBDM');
            boolean isMockup = (useMockupResp != null && useMockupResp.USE_MOCKUP__c ? true : false );
            // if the record is already used for Mockup respose, keep using Mockup response so we do not mess up the CBDM
            if(form.Cbdm_Request_Trans_Id__c != null && form.Cbdm_Request_Trans_Id__c.contains(MOCKUP)) isMockup = true;
            
            // use Mockup response
            if(isMockup){
                doMockupResponse(formId, form);
                return null;
            }
        }
    
        // append envAbbr such as '-UA', '-SI', etc. if it's not PROD env
        // This is for testing env because GEMS has multiple testing envs but CBDM has only one
        // form ID is a unique key so we append envAbbr and send to CBDM to avoid duplicate with other GEMS envs
        String newFormId = (env == GEMS_Constants.PROD ? formId : formId + '-' + envAbbr);
        
        /* comments is 'Update' for all approval status
        // for 'Return To Submitter', comments is the doc type + return reason from the GEMS_Return_Reason object
        String comments = 'Update';
        if(form.Approval_Status__c == 'Return' && form.GEMS_Return_Reasons__r != null && ! form.GEMS_Return_Reasons__r.isEmpty()) comments = form.GEMS_Return_Reasons__r[0].GEMS_Type__c + '; ' + form.GEMS_Return_Reasons__r[0].Return_Reason__c;
        */
        // produce REST body content
        // SFDC-8465 produce REST body content using JSONGenerator to convert special chars
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeStringField('cbdmContractRequestTransId', processString(form.Cbdm_Request_Trans_Id__c, ONE_STRING));
        gen.writeStringField('feedbackStatus', processString(form.Approval_Status__c, ONE_STRING));
        gen.writeStringField('feedbackComment', processString(comments, ONE_STRING));
        gen.writeEndObject();   
        // Call out to CBDM
        calloutCBDM(form.id, form.Cbdm_Request_Trans_Id__c, gen.getAsString(), FEEDBACK, null);
        return null;
    }    

    /* calloutCBDM method
     * 1. 1st call to data power to get JWT token
     * 2. 2nd call to CBDM REST service api
     */
    @future(callout=true)
    private static void calloutCBDM(String recordId, String CbdmRequestTransId, String jsonBody, Integer apiServiceType, String queueName){
        APP_API_URL__c formUrl = APP_API_URL__c.getVAlues('CBDM_ContractRequestService');
        APP_API_URL__c feedbackUrl = APP_API_URL__c.getVAlues('CBDM_ContractFeedbackService');   
        APP_CONNECT_SETTING__c cbdmConnSetting = APP_CONNECT_SETTING__c.getValues('CBDM');
        String certificateUniqueName = cbdmConnSetting.CertificateUniqueName__c;
        
        GEMS_SBC_BB_Form__c formRecord = new GEMS_SBC_BB_Form__c();
        formRecord.id = recordId;
        // This is 1st call to get JWT token
        String jwtToken = null;
        String errMsg = null;
        try{        
            jwtToken = fetchJwtToken();
        }catch(CalloutException e){
            System.debug('CalloutException Message >>> ' + e.getMessage());
            System.debug('CalloutException stack trace >>> ' + e.getStackTraceString());
            errMsg = e.getMessage();
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'GEMS_SBC_BB_Form__c', null, 'GEMS_CbdmClient.calloutCBDM(...)','High');  
        }
        if(jwtToken == null){
            updateRecordFailed(apiServiceType, formRecord, errMsg);
            return;
        }
        
        Map<String, Object> results = null;
        errMsg = null;
        try{
            if(apiServiceType == SUBMIT_FORM){
                // This is 2nd call to CBDM REST service api
                results = HcscConnectUtil.consumeRestApiPost(jsonBody, jwtToken, formUrl.URL__c, certificateUniqueName);
            }else if(apiServiceType == FEEDBACK){
                results = HcscConnectUtil.consumeRestApiPost(jsonBody, jwtToken, feedbackUrl.URL__c, certificateUniqueName);
            }else{
                System.debug('Error >>> apiServiceType = ' + apiServiceType); 
                errMsg = 'Not Submit Form or Send Feedback. apiServiceType = ' + apiServiceType;
            }
        }catch(Exception e){
            System.debug('CalloutException Message >>> ' + e.getMessage());
            System.debug('CalloutException stack trace >>> ' + e.getStackTraceString());
            errMsg = e.getMessage();
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'GEMS_SBC_BB_Form__c', null, 'GEMS_CbdmClient.calloutCBDM(...)','High');
        }           
        
        if(results == null) {
            updateRecordFailed(apiServiceType, formRecord, errMsg);
            return;         
        }
        // below logic is to update the form record with response
        if(apiServiceType == SUBMIT_FORM) {
            String cbdbStatus = (String) results.get('status');
            formRecord.CBDM_Status__c = 'Request Sent - ' + cbdbStatus;
            String s = (String) results.get('description');
            formRecord.CBDM_Status_Message__c = (s == null ? '' : s.left(200));
            if(String.isEmpty(CbdmRequestTransId)) 
                formRecord.Cbdm_Request_Trans_Id__c = (String) results.get('cbdmContractRequestTransId');
            // set resubmission to true if obtained transaction ID, resubmission field is just an indicator
            if( ! String.isEmpty(formRecord.Cbdm_Request_Trans_Id__c))
                formRecord.Resubmission__c = true;
            formRecord.Last_Resubmitted_Date__c = system.today();
            // assign queue to owner ID if successful
            QueueSobject q = null;
            if(cbdbStatus == GEMS_Constants.CbdmSuccess){ 
                if(queueName != null) q = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.DeveloperName = :queueName and SobjectType = 'GEMS_SBC_BB_Form__c' limit 1];
                formRecord.Form_Status__c = GEMS_Constants.StatusInProgress;
            }
            if(q != null) formRecord.ownerId = q.QueueId;
        }
        else if(apiServiceType == FEEDBACK) {
            formRecord.CBDM_Status__c = 'Feedback Sent - ' + results.get('status');
            String s = (String) results.get('description');
            formRecord.CBDM_Status_Message__c = (s == null ? '' : s.left(200));            
        }
        else formRecord.CBDM_Status__c = 'success';
        update formRecord;      
    }
    
    // method for reuse to update form record with failed response
    private static void updateRecordFailed(Integer apiServiceType, GEMS_SBC_BB_Form__c formRecord, String errMsg){
        if(apiServiceType == SUBMIT_FORM) formRecord.CBDM_Status__c = 'Request Sent Failed';
        else if(apiServiceType == FEEDBACK) formRecord.CBDM_Status__c = 'Feedback Sent Failed';
        else formRecord.CBDM_Status__c = 'Sent Failed';
        if(errMsg != null) formRecord.CBDM_Status_Message__c = errMsg;
        update formRecord;
    }
    
    // get the JWT token with credentials configured in custom setting APP_CONNECT_SETTING__c
    private static String fetchJwtToken(){
        APP_CONNECT_SETTING__c cbdmConnSetting = APP_CONNECT_SETTING__c.getValues('CBDM');
        String userName = cbdmConnSetting.Username__c;
        String password = cbdmConnSetting.Password__c;
        String clientId = cbdmConnSetting.ClientID__c;
        String clientSecret = cbdmConnSetting.ClientSecret__c;
        String tokenUrl = cbdmConnSetting.TOKEN_URL__c;
        String certificateUniqueName = cbdmConnSetting.CertificateUniqueName__c;
        return HcscConnectUtil.fetchOAuth2JwtToken(username, password, clientId, clientSecret, tokenUrl, certificateUniqueName);
    }
    
    
    // method for reuse to process a string to append to REST body
    private static String processString(String s, Integer stringType){
        if( String.isEmpty(s)) return '';
        if(stringType == ONE_STRING){ 
            return s;
        }else if(stringType == ONE_STRING_255){
            return s.left(255);
        }else if(stringType == ONE_STRING_R6){
            return s.right(6);
        } else return '';
    }
    
    // produce Json list/array
    private static List<String> processList(String s){
        List<String> retList = new List<String>();
        if( ! String.isEmpty(s)) {
            for(String st : s.split(';'))
                retList.add(st.trim());
        }
        return retList;
    }

    // method for reuse to process a boolean to append to REST body
    private static String processBoolean(boolean b){
        return ( b ? 'yes' : 'no');
    }
    
    // method for reuse to process a decimal to append to REST body
    private static String processDecimal(Decimal d){
        if(d == null) return '0';
        else return String.valueOf(d);
    }
    
    // This method is to return a mockup respose when configured so in custom setting (MOCKUP_RESPONSE__c)
    // for the purpose of testing without integration with CBDM
    private static void doMockupResponse(String formId, GEMS_SBC_BB_Form__c form){
        GEMS_SBC_BB_Form__c form2Update = new GEMS_SBC_BB_Form__c(Id = form.id);
        if(form.Cbdm_Request_Trans_Id__c == null)
            // prefix 'MOCKUP-' to the formId and assign to Cbdm_Request_Trans_Id__c and update the record
            form2Update.Cbdm_Request_Trans_Id__c = 'MOCKUP-' + formId;
        form2Update.CBDM_Status__c = 'Sent - Mockup';
        form2Update.CBDM_Status_Message__c = 'SUCCESS at ' + system.now();
        update form2Update;
    }
    
    // this method is a wrapper to be called from process builder during approval process triggered by status change
    @InvocableMethod public static void pbCallCBDMFeedback(List<String> formIdList){ for(String formId : formIdList) CallCBDMFeedback(formId); }

}