@isTest
global class MockHttpResponseGeneratorSgr_bng implements HttpCalloutMock{
	Integer jwtTokenStatusCd = 200;
	string jwtTokenBody='{"username": "test","access_token": "test","token_type": "Bearer","expires_in": 3650, "refresh_token": "test", "scope": "oob", "jwt_token": "test"}';	
	string responseBody='{"message":"Request process successfully", "status":"SUCCESS", "transactionId":"7dc53df5-703e-49b3-8670-b1c468f47f1f", "documentBase64Encoded": "ewqewqewqewqewqewqewqewqewq32322wdwewq","errorMessage": "","errorDesc": ""}';
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
    	String reqBody = req.getBody();
    	HttpResponse res = new HttpResponse();
    	res.setHeader('Content-Type', 'application/json');
    	if(reqBody != null){    		
			res.setBody(responseBody);
            res.setStatusCode(200);	       
    	}else{
    		// jwtToken response
			res.setBody(jwtTokenBody);
	        res.setStatusCode(jwtTokenStatusCd);
    	}
        return res;
    }
}