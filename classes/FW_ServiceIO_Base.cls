public without sharing abstract class FW_ServiceIO_Base implements FW_ServiceIO_Interface {
	
	public abstract object convertInputToRequest(object serviceInput, string serviceEndpoint, map<string, string> requestHeader, object additionalDetails);
    
    //public abstract object invokeWebserviceCallout(SoapRequest soapRequest);
    
    public abstract object convertResponseToOutput(object response, map<string, string> responseHeader, FW_Service_Status serviceStatus);
    
}