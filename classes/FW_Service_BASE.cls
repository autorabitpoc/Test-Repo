public without sharing abstract class FW_Service_BASE implements FW_Service_Interface {
    
      public FW_Service_Settings__mdt serviceSettings; 
      public string guid;
      
      public string serviceEndpoint;
      public map<string, string> requestHeader;
      public string certificate;
      public Object requestBody;
      
      public Map<string, string> responseHeader;
      public Object responseBody;
      public Object logResponseBody;
      
      public FW_Service_Status serviceStatus = new FW_Service_Status();
      
      private Object serviceOutput;
      public FW_ServiceIO serviceIO;
      
      private datetime executionStartTime;
      private long serviceInputProcessingTime;
      private long serviceCalloutTime;
      private long serviceOutputProcessingTime;
      private datetime executionEndTime;      
        
      private abstract void prepareServiceRequest();
       
        private abstract void execute();
        
        private abstract void processServiceResponse();
        
        private void getServiceEndPoint(){
          serviceEndpoint = serviceSettings.EndPoint__c;          
        }
        
        private void getRequestHeader(){
          requestHeader = FW_Service_Helper.getServiceHeaders(serviceSettings.HeaderName__c);    
        }
        
        private void getCertificate(){          
          if(serviceSettings.Certificate__c != null) certificate =   serviceSettings.Certificate__c;
        }
        
        private void getRequestBody(Object serviceInput){
          if(serviceIO != null){ 
              requestBody = serviceIO.convertInputToRequest(serviceInput, serviceEndpoint, requestHeader, guid);                                  
              System.debug('Service Input : ' + serviceInput);
              System.debug('Service Endpoint : ' + serviceEndpoint);
              System.debug('Service Request Header : ' + requestHeader);
          }
        }
        
        private void prepareOutput(){
          if(serviceIO != null && serviceSettings.OutputClass__c != null){
              //system.debug('@@responseBody' +responseBody);             
              serviceOutput = serviceIO.convertResponseToOutput(responseBody, responseHeader, serviceStatus);
              System.Debug('prepareOutput : ' + serviceOutput);   
          }  
        }    
      
      public Object performServiceCallout(FW_Service_Settings__mdt serviceSettings, Object serviceInput){
          System.Debug('Start performServiceCallout');
          System.Debug('serviceInput : ' + serviceInput);
        executionStartTime = system.now();
        
        try{
          this.serviceSettings = serviceSettings;
          if(serviceSettings.ProcessingClass__c != null)
            this.serviceIO = new FW_ServiceIO(serviceSettings.ProcessingClass__c);
          this.serviceStatus.status = 'S';
          this.guid = FW_GUID_Generator.generateGUID();
          system.debug('GUID : ' + guid);
              
          getServiceEndPoint();
          getRequestHeader();    
          getCertificate();
          getRequestBody(serviceInput);
              
          prepareServiceRequest();
        }
        catch(Exception ex){
            serviceStatus.status = 'E';
            serviceStatus.errorCode = 'Input';
            serviceStatus.errorDescription = ' Processing Error : ' + ex.getMessage();
            system.debug('@@Error Base Service :' + ex.getMessage() + ex.getstacktracestring());      
        }
        serviceInputProcessingTime = system.now().getTime() - executionStartTime.getTime();
        
        DateTime startTime = system.now();
            try{                
                if(serviceStatus.status == 'S') execute();              
            } catch(Exception ex) {
                serviceStatus.status = 'I';
            serviceStatus.errorCode = 'Interface';
            serviceStatus.errorDescription = ex.getMessage();
            }  
            serviceCalloutTime = system.now().getTime() - startTime.getTime();
            
            startTime = system.now(); 
            try{  
              processServiceResponse();        
              prepareOutput();
            }
            catch(Exception ex){
              serviceStatus.status = 'E';
              serviceStatus.errorCode = 'Output';
              serviceStatus.errorDescription = ' Processing Error : ' + ex.getMessage();
              system.debug('@@Error Base Service :' + ex.getMessage() + ex.getstacktracestring());      
            }
            executionEndTime = system.now();
            serviceOutputProcessingTime = executionEndTime.getTime() - startTime.getTime();        
            
            logServiceStatus();
            System.Debug('End performServiceCallout');
            
            System.Debug('serviceOutput:' +string.valueof(serviceOutput));
            return serviceOutput;
            
        }    
        
        private void logServiceStatus(){
            System.Debug('Log Service Status START');
          try {
          if(serviceSettings.LogStatus__c){
              FW_Service_Status_Log__c statusLog = new FW_Service_Status_Log__c();
              statusLog.Name = serviceSettings.QualifiedApiName;
              statusLog.UID__c = guid;
              statusLog.Status__c = serviceStatus.status;          
              statusLog.ErrorCode__c = serviceStatus.errorCode;
              statusLog.ErrorDescription__c = serviceStatus.errorDescription;
              statusLog.StartTime__c = executionStartTime;
              statusLog.InputProcessingTime__c = serviceInputProcessingTime;
              statusLog.CalloutTime__c = serviceCalloutTime;
              statusLog.OutputProcessingTime__c = serviceOutputProcessingTime;  
              statusLog.EndTime__c = executionEndTime;
              //statusLog.Log_Type__c = ServiceHelper.SERVICE_LOG;
              if(serviceSettings.LogRequest__c && requestBody != null){
                string request;
                if(requestBody instanceof string)
                  request = (String) requestBody;
                else
                  request = string.valueof(requestBody);
                if(request.length() > 131000)  
                    request = request.substring(0,131000);      
                statusLog.RequestBody__c = request;
              }
              if(serviceSettings.LogResponse__c && logResponseBody != null){
                string response;
                if(logResponseBody instanceof string)
                  response = (String) logResponseBody;
                else
                  response = string.valueof(logResponseBody);
                if(response.length() > 131000)
                    response = response.substring(0,131000);
                statusLog.ResponseBody__c = response;
              }
              
              System.Debug('Log Service Status BEFORE INSERT' + statusLog);
              
              insert statusLog;
              
              System.Debug('Log Service Status END'); 
           }           
          } catch(Exception ex) {
              GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'FW_Service_BASE.logServiceStatus','High');             
          }
        }
    
}