@isTest
public without sharing class GEMS_CreateCharValuesServiceTest {
   
   
  static testMethod void testPost() {

        //do request
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/GEMS_CreateCharValuesService/gemsCharValues';
       // RestContext.request.requestBody('email');
       
        req.httpMethod = 'POST';
        String results = GEMS_CreateCharValuesService.doPost();
        req.requestURI = '/services/apexrest/GEMS_CreateCharValuesService/gemsCatCharValues'; 
       // RestContext.request.requestBody('POST');
        req.httpMethod = 'POST';
        String results1 = GEMS_CreateCharValuesService.doPost();
       

    
}
 
 }