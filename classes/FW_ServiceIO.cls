public without sharing class FW_ServiceIO {
    
    public class NameException extends Exception{}
    
    public static final map<String, FW_ServiceIO_Interface> strategies;
    
    private FW_ServiceIO_Interface strategy;    
    
    static{
        
        system.debug('ServiceIO - Static variables');
        
        List<FW_Service_Settings__mdt> serviceSettings = [Select 
                                                        Timeout__c, Strategy__c, QualifiedApiName, ProcessingClass__c, OutputClass__c, Operation__c,  
                                                        MasterLabel, LogWithCallout__c, LogStatus__c, LogResponse__c, LogRequest__c, Label, InputClass__c, 
                                                        Id, HeaderName__c, EndPoint__c, EndPointParameters__c, DeveloperName, Compressed__c, Certificate__c, 
                                                        CertificatePassword__c, CertificateName__c 
                                                            From FW_Service_Settings__mdt];   
                                       
        List<String> strategyNames = new List<String>();
        
        for(FW_Service_Settings__mdt ss : serviceSettings){          
            strategyNames.add(ss.ProcessingClass__c);
        }
            
        strategies = new Map<String, FW_ServiceIO_Interface>();
        
        for(String name : strategyNames){
            system.debug('@@ProcessingClass' + name);
            try{

                strategies.put(name, (FW_ServiceIO_Interface)Type.forName(name).newInstance());                    
            }
            catch(Exception e){
              system.debug('Strategy Exception : ' + e.getMessage() + e.getStackTraceString());              
                continue;
            }
        }          
    } 
    
    public FW_ServiceIO(String ioClass){
        
        system.debug('ServiceIO - Constructor');
        if(!strategies.containsKey(ioClass))
            throw new NameException(ioClass);
        strategy = strategies.get(ioClass);
        
    }
    
    public Object convertInputToRequest(Object serviceInput, string serviceEndpoint, map<string, string> requestHeader, string messageReference){        
        system.debug('ServiceIO - convertInputToRequest');
        return strategy.convertInputToRequest(serviceInput, serviceEndpoint, requestHeader, messageReference);
    }
    
    /*public Object invokeWebserviceCallout(SoapRequest soapRequest){        
        system.debug('ServiceIO - invokeWebserviceCallout');
        return strategy.invokeWebserviceCallout(soapRequest);        
    }*/
    
    public Object convertResponseToOutput(Object response, map<string, string> responseHeader, FW_Service_Status serviceStatus){        
        system.debug('ServiceIO - convertResponseToOutput');
        return strategy.convertResponseToOutput(response, responseHeader, serviceStatus);
    }
    
}