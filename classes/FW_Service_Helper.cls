public without sharing class FW_Service_Helper {
    
    public final static string serviceStrategies = 'Service_Strategies';
    
    public final static string statusLogService = 'FW_Service_StatusLogService';
    
    public static map<String, String> getServiceHeaders(string headerType){
        
        system.debug('ServiceHelper - getServiceHeaders');
        
        map<string, string> headers = new map<string, string>();
        try {
        if(headerType != null){
            
          FW_Service_Headers__mdt serviceHeaders = [Select 
                                                    Username__c, QualifiedApiName, Password__c, MasterLabel, Label, Id, DeveloperName, ContentType__c, ContentLength__c, ContentEncoding__c, Authorization__c, AcceptEncoding__c 
                                                        From FW_Service_Headers__mdt
                                                            WHERE QualifiedApiName = : headerType
                                                            limit 1];
          if(serviceHeaders.ContentType__c != null) headers.put('Content-Type',serviceHeaders.ContentType__c);
          
          if(serviceHeaders.Authorization__c != null) headers.put('Authorization',serviceHeaders.Authorization__c);
          
          if(serviceHeaders.ContentEncoding__c != null) headers.put('Content-Encoding',serviceHeaders.ContentEncoding__c);
          
          if(serviceHeaders.AcceptEncoding__c != null) headers.put('Accept-Encoding',serviceHeaders.AcceptEncoding__c);
          
          if(serviceHeaders.ContentType__c != null) headers.put('Content-Type',serviceHeaders.ContentType__c);
          
          if(serviceHeaders.Username__c != null) headers.put('Username',serviceHeaders.Username__c);
          
          if(serviceHeaders.Password__c != null) headers.put('Password',serviceHeaders.Password__c);
          
          /*if(serviceHeaders.Username__c != null && serviceHeaders.Password__c != null){
              Blob headerValue = Blob.valueOf(serviceHeaders.Username__c + ':' + serviceHeaders.Password__c);
              string authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
              headers.put('Authorization',authorizationHeader); 
          }*/
          
        }
        }catch(Exception ex) {
              GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'FW_Service_Helper', 'Case', null, 'FW_Service_Helper.getServiceHeaders(string headerType)','High');             
        }
        return headers;
    }
    
}