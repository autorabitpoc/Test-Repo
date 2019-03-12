public without sharing class FW_Service {
    
    private FW_Service_Settings__mdt serviceSettings;
    
    public class StrategyNameException extends Exception{}
    
    public class ServiceSettingException extends Exception{}
    
    private FW_Service_Interface strategy;    
    
    public static final Map<String, FW_Service_Interface> strategies;    
    
    static{
        
        system.debug('SERVICE - static variables');
        try {
            FW_Global_Settings__mdt serviceStrategies = [Select 
                                                         Value__c, QualifiedApiName, MasterLabel, Label, Id, DeveloperName 
                                                         From FW_Global_Settings__mdt 
                                                         where QualifiedApiName = : FW_Service_Helper.serviceStrategies 
                                                         limit 1];
            List<String> strategyNames = new List<String>();
            
            if(serviceStrategies != null && serviceStrategies.Value__c != null)
                strategyNames = serviceStrategies.Value__c.split(',');
            
            strategies = new Map<String, FW_Service_Interface>();
            
            for(String name : strategyNames){
                try{
                    strategies.put(name, (FW_Service_Interface)Type.forName(name).newInstance());                    
                }
                catch(Exception e){
                    system.debug('Strategy Exception : ' + e.getMessage());
                    continue;
                }
            }
        } catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'FW_Service', 'Case', null, 'FW_Service.staticBlock','High');             
        }
    }   
    
    public FW_Service(String serviceName){
        
        system.debug('SERVICE - Constructor');
        
        serviceSettings = [Select 
                           Timeout__c, Strategy__c, QualifiedApiName, ProcessingClass__c, OutputClass__c, Operation__c,  
                           MasterLabel, LogWithCallout__c, LogStatus__c, LogResponse__c, LogRequest__c, Label, InputClass__c, 
                           Id, HeaderName__c, EndPoint__c, EndPointParameters__c, DeveloperName, Compressed__c, Certificate__c, 
                           CertificatePassword__c, CertificateName__c 
                           From FW_Service_Settings__mdt
                           WHERE QualifiedApiName =: serviceName
                           limit 1];
        
        if(serviceSettings != null){
            
            if(!strategies.containsKey(serviceSettings.Strategy__c))
                throw new StrategyNameException(serviceSettings.Strategy__c);
            
            strategy = strategies.get(serviceSettings.Strategy__c);
            
        }
        else
            throw new ServiceSettingException('Error : Service Configuration Setup is Missing for : ' + serviceName);
        
    }   
    
    public Object callout(Object serviceInput){  
        
        //System.Debug('Service : serviceInput : ' + serviceInput);      
        //system.debug('SERVICE - Callout');
        
        return strategy.performServiceCallout(serviceSettings, serviceInput);
        
    }
    
}