/**************************************************************************************
* Create By:   Deloitte Consulting LLP.
* CreateDate:  18/02/2014
* Description: Mock Web Service for wwwHcscComCorpItMnssAddressSvcV4.
*              Copied from U65 Retail Org (InternalAddressWebserviceMock)
*              for Test Class Remediation
*  
*  Modification Log :
*  -----------------------------------------------------------------------------
*  * Developer                 Date                    Description
*  * ----------------------------------------------------------------------------                 
*  * Raymundo Rodriguez        18/02/2014              Initial version.
**************************************************************************************/
@isTest
global class BatchAddressCacheMock implements WebServiceMock {
    
    /*
* Method name  :    doInvoke
* Description  :    Mock response of the Web Service.
* Return Type  :    Void.
* Parameter    :    Stub, Request, Response, End point, Soap Action, Request Name, 
*                   Response NS, Response Name and Response Type.
*/
    global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, 
                         String soapAction, String requestName, String responseNS, String responseName, String responseType) {
                             
                             //Initializing nodes.
                             wwwHcscComCorpItMnssAddressSvcV4.getZipCodeToCountiesRelationshipByStateResponse responseRoot = new wwwHcscComCorpItMnssAddressSvcV4.getZipCodeToCountiesRelationshipByStateResponse();
                             wwwHcscComCorpItMnssAddressSvcV4.getZipCodeToCountiesRelationshipResponse responseRoot2 = new wwwHcscComCorpItMnssAddressSvcV4.getZipCodeToCountiesRelationshipResponse();
                             wwwHcscComCorpItMnssAddressSvcV4.getZipCodeToCountiesRelationshipsResponse responseRoot3 = new wwwHcscComCorpItMnssAddressSvcV4.getZipCodeToCountiesRelationshipsResponse();
                             wwwHcscComCorpItMnssAddressSvcV4.validateResponse responseRoot4 = new wwwHcscComCorpItMnssAddressSvcV4.validateResponse();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAllResponse responseRoot5 = new wwwHcscComCorpItMnssAddressSvcV4.validateAllResponse();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressResponseList validateAddressResponseList = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressResponseList();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressResponse responseValidate = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressResponse();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequestList validateAddressRequestList = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequestList();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequests_element validateAddressRequestElementList = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequests_element();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequest validateAddressRequest = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequest();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressMessage responseValidateAddressMessage = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressMessage();
                             wwwHcscComCorpItMnssAddressSvcV4.validateAddressMessages_element responseValidateElement = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressMessages_element();
                             wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList responseParent = new wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList();
                             wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationships_element responseElement = new wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationships_element();
                             wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationship responseItem = new wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationship();
                             wwwHcscComCorpItMnssAddressSvcV4.counties_element counties = new wwwHcscComCorpItMnssAddressSvcV4.counties_element();
                             
                             //Setting data.
                             wwwHcscComCorpItMnssAddressSvcV4.county county = new wwwHcscComCorpItMnssAddressSvcV4.county();
                             county.fipsCountyCode3 = 'Test';
                             county.fipsStateCode2 = 'Te';
                             county.name = 'Test';
                             county.stateCode = 'Te';
                             counties.county = new wwwHcscComCorpItMnssAddressSvcV4.county[]{};
                                 counties.county.add(county);
                             responseValidateAddressMessage.code = 'TE';
                             responseValidateAddressMessage.description = 'Test';
                             responseValidateElement.validateAddressMessage = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressMessage[]{};
                                 responseValidateElement.validateAddressMessage.add(responseValidateAddressMessage);
                             responseValidate.city = 'Test';
                             responseValidate.cityAbbreviation = 'Te';
                             responseValidate.county = county;
                             responseValidate.validateAddressMessages = responseValidateElement;
                             responseValidate.stateCode = 'Te';
                             responseValidate.streetLine1 = 'Test';
                             responseValidate.streetLine2 = 'Test';
                             responseValidate.zipCode = 'Test';
                             validateAddressRequest.city = 'Test';
                             validateAddressRequest.stateCode = 'Te';
                             validateAddressRequest.streetLine1 = 'Test';
                             validateAddressRequest.streetLine2 = 'Test';
                             validateAddressRequest.zipCode = 'Test';
                             validateAddressRequestElementList.validateAddressRequest = new wwwHcscComCorpItMnssAddressSvcV4.validateAddressRequest[]{};
                                 validateAddressRequestElementList.validateAddressRequest.add(validateAddressRequest);
                             validateAddressRequestList.validateAddressRequests = validateAddressRequestElementList;
                             
                             //Top data.
                             responseItem.counties = counties;
                             responseItem.zipCode = 'Test';
                             responseItem.zipCodeClassification = 'Tes';
                             
                             //Setting parent nodes.
                             responseElement.zipCodeToCountiesRelationship = new wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationship[]{};
                                 responseElement.zipCodeToCountiesRelationship.add(responseItem);
                             responseParent.zipCodeToCountiesRelationships = responseElement;
                             responseRoot.zipCodeToCountiesRelationshipList = responseParent;
                             responseRoot2.zipCodeToCountiesRelationship = responseItem;
                             responseRoot3.zipCodeToCountiesRelationshipList = responseParent;
                             responseRoot4.validateAddressResponse = responseValidate;
                             responseRoot5.validateAddressResponseList = validateAddressResponseList;
                             
                             //Selecting response according to request.
                             if(requestName == 'getZipCodeToCountiesRelationshipByState') {
                                 response.put('response_x', responseRoot);
                             } else if(requestName == 'getZipCodeToCountiesRelationship') {
                                 response.put('response_x', responseRoot2);
                             } else if(requestName == 'getZipCodeToCountiesRelationships') {
                                 response.put('response_x', responseRoot3);
                             } else if(requestName == 'validate') {
                                 response.put('response_x', responseRoot4);
                             } else if(requestName == 'validateAll') {
                                 response.put('response_x', responseRoot5);
                             }
                         }
}