/* This class is a REST api service for CBDM to update the CBDM_Status__c field in SBC/BB form record
 * Update History:
 * 08-19-2017   Luke Chen   SFDC-4718 Incoming call from CBDM
 * 
 */

/* The URL is mapped to https://<Salesforce instance base URL>/services/apexrest/gemscbdmservice/
 * Only a POST method is implemented in this initial release
 */
@RestResource(urlMapping='/gemscbdmservice/*')
global without sharing class GEMS_CbdmService{
    /*
     * Method: GEMS_CbdmServiceResponse
     * A POST method for CBDM to update fields in GEMS_SBC_BB_Form__c records
     */
    @HttpPost
    global static GEMS_CbdmServiceResponse doPost(String formRecordId, String cbdmStatus, String cbdmComments) {
        try{
            String env = GEMS_Utility.getEnvName(); 
            GEMS_CbdmServiceResponse response = new GEMS_CbdmServiceResponse();
            if(String.isBlank(formRecordId)){
                response.status = 'fail';
                response.errorMsg = 'formrecordID is empty';
                return response;            
            }
            // If not PROD env, check if appended with '-UA', '-SI', etc. due to testing with CBDM TEST env
            // remove it if present and proceed to soql query
            String origFormId = formRecordId;
            if(env != GEMS_Constants.PROD){
                String s = formRecordId.right(3);
                if(s.contains('-')) origFormId = formRecordId.left(formRecordId.length() - 3);
            }
            List<GEMS_SBC_BB_Form__c> formList = [SELECT Id, CBDM_Status__c FROM GEMS_SBC_BB_Form__c WHERE Form_Id__c = :origFormId];
            if(formList.isEmpty()) {
                response.status = 'fail';
                response.errorMsg = 'formrecordID does not exist';
                return response;        
            }
            GEMS_SBC_BB_Form__c thisForm = formList[0];
            thisForm.CBDM_Status__c = cbdmStatus;
            thisForm.CBDM_Status_Message__c = (cbdmComments == null ? '' : cbdmComments.left(200));
            System.debug('cbdmStatus = ' + cbdmStatus + '; cbdmComments = ' + cbdmComments);
            update thisForm;
    
            response.status = 'success';
            response.errorMsg = '';
            return response;
        }catch(Exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'GEMS_SBC_BB_Form__c', null, 'GEMS_CbdmService.doPost(...)','High');
            System.debug('GEMS_CbdmService.doPost Message >>> ' + e.getMessage());
            throw e;
        }
    }
  
    // a data holder class to return response back to CBDM
    global class GEMS_CbdmServiceResponse{
      public String status;
      public String errorMsg;
    }
  
}