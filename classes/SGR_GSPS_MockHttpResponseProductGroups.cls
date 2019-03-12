@isTest
global class SGR_GSPS_MockHttpResponseProductGroups implements HttpCalloutMock {

    

	Integer jwtTokenStatusCd = 200;
	string jwtTokenBody='{"username": "test","access_token": "test","token_type": "Bearer","expires_in": 3650, "refresh_token": "test", "scope": "oob", "jwt_token": "test"}';
	Integer planStatusCd;
	String planBody;
	
	public SGR_GSPS_MockHttpResponseProductGroups(Integer planStatusCd, String planBody){
		this.planStatusCd = planStatusCd;
		this.planBody = planBody;
	}
	
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
    	String reqBody = req.getBody();
    	HttpResponse res = new HttpResponse();
    	res.setHeader('Content-Type', 'application/json');
    	if(reqBody != null && reqBody.contains('effectiveDate')){
    		// mapped plan respose
			res.setBody(planBody);
	        res.setStatusCode(planStatusCd);
    	}else{
    		// jwtToken response
			res.setBody(jwtTokenBody);
	        res.setStatusCode(jwtTokenStatusCd);
    	}
        return res;
    }
}