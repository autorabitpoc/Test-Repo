@isTest
public class SGR_BAP_GetProducerDataTest {

	@isTest
	static void testGetProducerData(){
        
		SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
		SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
		req.producerNumber= '35435';
		String myJSON = JSON.serialize(req);
		
        RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        res.pageNumber=0;
        res.pageSize=1;
        RestResponse response = new RestResponse();
        response.responseBody = Blob.valueOf(String.valueof(res));
        RestContext.response = response;
		SGR_BAP_GetProducerData.getProducerData();
		System.assertNotEquals(RestContext.response,null);
		
		
	}
    
    @isTest
	static void testGetProducerDataException(){
        
		SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
		SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
		req.producerNumber= '35435,';
        req.pageSize =0;
        String myJSON = JSON.serialize(req);
        
           RestRequest request = new RestRequest();
            request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof('');
            RestContext.request = request;
            RestResponse response = new RestResponse();
            response.responseBody = Blob.valueOf(String.valueof(res));
            RestContext.response = response; 
            SGR_BAP_GetProducerData.getProducerData();
		
		
	}
}