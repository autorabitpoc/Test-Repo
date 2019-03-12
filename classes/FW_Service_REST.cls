public without sharing class FW_Service_REST extends FW_Service_Base {
    
    HttpRequest request = new HttpRequest();
    HttpResponse response = new HttpResponse();
    Http http = new Http();
    
    private void prepareServiceRequest(){
        system.debug('SOAPService - prepareServiceRequest');
        system.debug('### Timeout: '+ serviceSettings.Timeout__c);
      if(serviceSettings.Timeout__c != null) request.setTimeout(integer.ValueOf(serviceSettings.Timeout__c));
      
      //Srikanth added this, remove it later 
      request.setTimeout(30000);
      
      if(serviceSettings.Operation__c != null) request.setMethod(serviceSettings.Operation__c);
      if(serviceSettings.Compressed__c) request.setCompressed(serviceSettings.Compressed__c);
      if(serviceSettings.CertificateName__c != null) request.setClientCertificateName(serviceSettings.CertificateName__c);  
          
      if(certificate != null) request.setClientCertificate(certificate, serviceSettings.CertificatePassword__c);
        
        if(requestHeader != null && !requestHeader.isEmpty()){
          Set<string> keys = requestHeader.keySet();
          for(string key : keys){
            request.setHeader(key, requestHeader.get(key));
          }          
        }
        
        string jsonString;
        if(requestBody != null){
            if(requestBody instanceof string){
                jsonString = (string)requestBody;}
            else {
                jsonString = JSON.serializePretty(requestBody);}            
        }        
        
        if(!serviceSettings.EndPointParameters__c){
            request.setEndpoint(serviceEndpoint);
            request.setBody(jsonString);
        }
        else
            request.setEndpoint(serviceEndpoint + jsonString);
        
        requestBody = jsonString;        
        System.debug('Request Body :\n' + requestBody);
    }
   
    private void execute(){
        try{
          system.debug('Request : ' + request);
          system.debug('Request get Body: ' + request.getEndpoint());
            response = http.send(request); 
            system.debug('Response : ' + response);
        }
        catch(Exception ex) {
            system.debug('Interface Error : '+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Frame Work', 'FW_Service_REST', null, 'FW_Service_REST.execute()','High'); 
            throw ex;
        }
    } 
    
    public void processServiceResponse(){
        if(response != null)
            logResponseBody = response.getBody();
        responseBody = response;
        System.Debug('Response Body : ' + responseBody);
        
    }
    
}