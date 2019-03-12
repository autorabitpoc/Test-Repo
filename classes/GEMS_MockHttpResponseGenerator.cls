/**************************************************************************************
Apex Class Name       : GEMS_MockHttpResponseGenerator 
Version               : 1.0
Function              : This test Class is used for setting the mock response for HTTP callouts.
Modification Log      :  
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            07/28/2016             Original Version
*************************************************************************************/
@isTest
global class GEMS_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://gateway.wtc.hcsc.net/services/group/setupAccount/SIT', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
string body= '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
     
        res.setBody(body );
        res.setStatusCode(200);
        res.setStatus('S');
        return res;
     }
}