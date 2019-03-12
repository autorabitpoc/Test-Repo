public without sharing abstract class FW_ServiceIO_REST extends FW_ServiceIO_Base {
    
    public object serviceInput;
    public object additionalDetails;      
      
    private virtual void setEndPointParameters(string serviceEndpoint){     
    }
      
    private virtual void setCustomHeaderValues(map<string, string> requestHeader){      
    }
      
    private virtual object convertInputToRequest(){
        return serviceInput;
    }
      
    public override object convertInputToRequest(object serviceInput, string serviceEndpoint, map<string, string> requestHeader, object additionalDetails){
        this.serviceInput = serviceInput;    
        this.additionalDetails = additionalDetails;  
            
        setEndPointParameters(serviceEndpoint);
        setCustomHeaderValues(requestHeader);        
        
        return convertInputToRequest();
    }
        
    /*public override object invokeWebserviceCallout(SoapRequest soapRequest){
        return null;
    }*/
      
    public override virtual object convertResponseToOutput(object response, map<string, string> responseHeader, FW_Service_Status serviceStatus){
        return response;
    }
    
}