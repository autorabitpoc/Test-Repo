@isTest
global class MockBlueSTARContUpdRespGen implements HttpCalloutMock {

	global HTTPRequest request;

    global HTTPResponse respond(HTTPRequest request) {
    	this.request = request;
        System.assertEquals('POST', request.getMethod());
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"status":"200"}');
        response.setStatusCode(200);
        response.setStatus('Success');
        return response;
    }
}