/* This Test class is to generate mockup response from CBDM
 * Update History:
 * 08-23-2017    Luke Chen    SFDC-2702 outgoing request to CBDM
 *
 */
@isTest
global class MockHttpResponseCBDM implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"jwt_token":"123456789","status":"success","cbdmContractRequestTransId":"abcdefg"}');
        res.setStatusCode(200);
        return res;
    }
}