/* This Test class is to generate mockup response 
 * Update History:
 * 11-11-2018    Luke Chen    SFDC-14006 SGR - GSPS : Get Mapped Plans - Build Response Post processing code
 *
 */
@isTest
global class MockHttpResponseMappedPlans implements HttpCalloutMock {
    Integer jwtTokenStatusCd = 200;
    String jwtTokenBody = '{"username": "test","access_token": "test","token_type": "Bearer","expires_in": 3650, "refresh_token": "test", "scope": "oob", "jwt_token": "test"}';
    Integer planStatusCd;
    String planBody;

    public MockHttpResponseMappedPlans(Integer planStatusCd, String planBody) {
        this.planStatusCd = planStatusCd;
        this.planBody = planBody;
    }

    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        String reqBody = req.getBody();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (reqBody != null && reqBody.contains('effectiveDate')) {
            // mapped plan respose
            res.setBody(planBody);
            res.setStatusCode(planStatusCd);
        } else {
            // jwtToken response
            res.setBody(jwtTokenBody);
            res.setStatusCode(jwtTokenStatusCd);
        }
        return res;
    }
}