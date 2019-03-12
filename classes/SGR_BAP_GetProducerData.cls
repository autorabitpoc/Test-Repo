//*************************************************************************************
// Name             : SGR_BAP_GetProducerData.cls
// Description      : Exposed as a Rest Service to provide the Producer Data to BAP
// Created By       : Akbar Hussain Salisabgari 
// Created Date     : 12/28/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 12/28/2018       Akbar             SFDC-15963->BAP Webservice 
// ************************************************************************************
@RestResource(urlMapping='/BAP_GetProducerData/*')
global class  SGR_BAP_GetProducerData {
   
	@HttpPost
    global static void getProducerData(){
        RestRequest request = RestContext.request;
        //RestResponse response = RestContext.response;
        SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
        SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
        try{      
            String jsonRequestBody=request.requestBody.toString().trim();
            req = (SGR_BAP_GetProducerDataRequest)JSON.deserialize(jsonRequestBody,SGR_BAP_GetProducerDataRequest.class);
            res = SGR_BAP_GetProducerDataHelper.generateBAPProducerData(req);
        }catch(Exception e){
            FW_Service_Status_Log__c serLog = new FW_Service_Status_Log__c();
        	serLog.Name = 'BAP Webservice';
        	serLog.StartTime__c = System.now();
            serLog.RequestBody__c = String.valueOf(request.requestBody.toString().trim());
            serLog.Status__c ='Request process failed';
			serLog.ErrorDescription__c = e.getMessage();
			serLog.ErrorCode__c = 'Failed';
			res.status = 'Failed';
			res.message = 'Request process failed';
			res.failureReason = 'System Exception. Please contact System Administrator.';
            insert serLog;
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    
    }
}