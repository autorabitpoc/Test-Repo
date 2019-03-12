@RestResource(urlMapping='/UCRKafkaUpdateTEST/*')
global with sharing class SF_UCRKafkaUpdateWebServiceHelper {
    String testing='hello';
    
     @HttpPost
    global static void updateOpportunity(){
        system.debug('test ing');
    }
}