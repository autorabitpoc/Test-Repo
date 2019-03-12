/* This util class collects methods to connect to HCSC apps and consume their api service
 * NOTE: The Test methods for this class is in GEMS_CbdmClientTest class.
 * Update History:
 * 08/20/2017   Luke Chen   SFDC-2702 Outgoing call to CBDM api service
 * 
 */

public class HcscConnectUtil{

    // This method is to obtain the OAuth2 JWT token. 
    // The JWT token is part of information to pass in for the 2nd call to consume the actual api service
    public static String fetchOAuth2JwtToken(String username, String password, String clientId, String clientSecret, String tokenUrl, String certificateUniqueName){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(tokenUrl);
        request.setMethod('POST');
        request.setHeader('content-type', 'application/json');
        request.setHeader('Content-Length','10240');
        request.setHeader('ClientID', clientId);
        request.setHeader('ClientSecret', clientSecret);
        // certificate is used for mutual authentication required by data power
        if(certificateUniqueName!=null)
            request.setClientCertificateName(certificateUniqueName);
        request.setTimeout(60000); // time out to 60 sec, can change to max 120 sec
        // Set the body as a JSON object
        request.setBody('{"username":"' + userName + '", "password":"' + password + '"}');
        System.debug('toString >>> ' + request.toString());
        System.debug('getBody >>> ' + request.getBody());
        System.debug('getHeader(ClientID) >>> ' + request.getHeader('ClientID'));
        System.debug('getHeader(ClientSecret) >>> ' + request.getHeader('ClientSecret'));
        System.debug('getHeader(content-type) >>> ' + request.getHeader('content-type'));
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return (String) results.get('jwt_token');
        }
        // error, put in debug and return null
        System.debug('Error >>> ' + response.getBody());    
        return null;
    }
    
    // This method is the 2nd call to consume the REST api service and return back the response in Map object to easily access response fields
    // This method performs the POST action. 
    public static Map<String, Object> consumeRestApiPost(String jsonBody, String jwtToken, String url, String certificateUniqueName){
        System.debug('jsonBody = ' + jsonBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('content-type', 'application/json');
        request.setHeader('Content-Length','10240');
        request.setHeader('Authorization', 'Bearer ' + jwtToken);
        // certificate is used for mutual authentication required by data power
        if(certificateUniqueName!=null)
            request.setClientCertificateName(certificateUniqueName);
        request.setTimeout(60000); // time out to 60 sec, can change to max 120 sec
        
        // Set the body as a JSON object
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);
        System.debug('consumeRestApiPost >>> response = ' + response.getBody());
        if(response.getBody() == null) return null; // something wrong with error
        // Deserializes the JSON string into collections of primitive data types.
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return results;
    
    }
}