@RestResource(urlMapping='/GEMS_CreateCharValuesService/*')
global without sharing class GEMS_CreateCharValuesService {
    
    /*  
    HttpPost method is used to capture a HttpPOST request has been sent to our rest apex class.  
    Used to request data on the basis of JSON request sent in the URL  
    */  
    
    @HttpPost
    global static string doPost() {
        try{

            RestRequest  req = RestContext.request;
            
            String RequestString = req.requestBody.toString();
            system.debug('RequestString : '+RequestString);
            
            String recordType = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if(recordType != null && recordType == 'gemsCharValues'){
                list<GEMS_Characteristic_Value__c> gemsCharValues = (list<GEMS_Characteristic_Value__c>)JSON.deserialize(RequestString, list<GEMS_Characteristic_Value__c>.class);
                //system.debug('gemsCharValues : '+ gemsCharValues);
               
                insert gemsCharValues;
            }
            else if(recordType != null && recordType == 'gemsCatCharValues'){
                list<GEMS_Cat_Char_Value_Association__c> gemsCatCharValues = (list<GEMS_Cat_Char_Value_Association__c>)JSON.deserialize(RequestString, list<GEMS_Cat_Char_Value_Association__c>.class);
                //system.debug('gemsCatCharValues : '+ gemsCatCharValues);
               
                insert gemsCatCharValues;
                //insertCatCharValues(RequestString);
            }
            else
                return 'E';
            
            return 'S';
        }catch(exception ex){
            system.debug('Exception:'+ex.getMessage());
            return ex.getMessage();
        }
    }
}