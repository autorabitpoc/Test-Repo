/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class APIQuoteRateUtilityTest {
/*
    static testMethod void myUnitTest() {
    
       List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
       List<Heron_OAuth__c> bList=Test.loadData(Heron_OAuth__c.sObjectType, 'HeronOauthTestData');
      test.startTest();
      boolean isExp= APIQuoteRateUtility.isTokenExpired();
      if(isExp){
        APIQuoteRateUtility.heronOauth=bList[0];
      	APIQuoteRateUtility.callOutSetting=alist[0];
      	
      	APIQuoteRateUtility.password=APIQuoteRateUtility.heronOauth.Password__c;
      	APIQuoteRateUtility.userName=APIQuoteRateUtility.heronOauth.UserName__c;
      	APIQuoteRateUtility.certificate=APIQuoteRateUtility.heronOauth.Certificate__c;
      	APIQuoteRateUtility.clientId=APIQuoteRateUtility.heronOauth.Client_Id__c;
      	APIQuoteRateUtility.clientSecret=APIQuoteRateUtility.heronOauth.Client_Secret__c;
      	APIQuoteRateUtility.tokenEndpoint=APIQuoteRateUtility.heronOauth.End_Point__c;
        APIQuoteRateUtility.endPoint=APIQuoteRateUtility.callOutSetting.EndPoinUrl__c;
      	 
        test.setMock(HttpCalloutMock.class, new APIQuoteRateTokenCall());
      	DTOQuoteRateRTResponse  tokenRes= APIQuoteRateUtility.InvokeTokenService();
      	
      	
      	DTOQuoteRateRequest reqDTO=new DTOQuoteRateRequest();
        
              //  updateReq=quoteReq[0];

          reqDTO.HCSCDivision='IL';
          reqDTO.quoteReqId='a2wc0000002cvhG';
          reqDTO.opportunityName='testOpp';
          reqDTO.accountName='testAcct';
                // reqDTO.accountNumber=quoteReq[0].Account_Number__c;
            
        
         reqDTO.accountNumber= '123455';
                  //reqDTO.accountNumber=accountNumber;
         reqDTO.salesRep='AE test';//Account_Sales_Executive1__c;
         reqDTO.salesRep='test Rep';//Account_Sales_Executive2__c;   
         reqDTO.quoteReqDesc='this is test quote';
         reqDTO.rateEffectiveDate=system.today();
         reqDTO.lastModifiedDate=null;
         reqDTO.requestType='Renewal';
      	 String  accesstoken=blist[0].JWT_Token__c+blist[0].JWT_Token2__c+blist[0].JWT_Token3__c+blist[0].JWT_Token4__c+blist[0].JWT_Token5__c;
      
      	 HttpRequest req=APIQuoteRateUtility.setupHttpRequest(accesstoken,reqDTO);//new HttpRequest();
         
         test.setMock(HttpCalloutMock.class, new APIOAuthUtilityMockExpiredToken());
         HttpResponse res = APIQuoteRateUtility.InvokeService(req);
         APIQuoteRateUtility.isTokenRespondedExpired(res);
         String resbody='{"access_token":"00Dc0000003vofd!ARIAQLIKI_qsmMvfw4TLA_R9A2.8ntLLgYdFGpfTl3efFCxzvGZVIpXpeaI6TAT3PMbIRVq6ujruG7ESPWB4KIfOIZMz3E_8", "instance_url": "https://hcscgroup--MeiDevelop.cs14.my.salesforce.com","id": "https://test.salesforce.com/id/00Dc0000003vofdEAA/005c0000003S51gAAC", "token_type": "Bearer", "issued_at": "1507782505351", "signature": "5dn/UiqpnVqI0be/N+gqm9p/VAe7RULk4aNJmZG8wMo="';
         
         APIQuoteRateUtility.jsonResult(resbody,'access_token');
         
          test.setMock(HttpCalloutMock.class, new APIQuoteReqServiceCall());
          HttpResponse res1 = APIQuoteRateUtility.InvokeService(req);
          
          test.setMock(HttpCalloutMock.class, new APIQuoteReqServiceCall());
          DTOQuoteRateRTResponse status= APIQuoteRateUtility.CreateGetRateCallout (reqDTO);
      }
      test.stopTest(); 
      
    }
     
     	
     
     public class APIQuoteRateTokenCall implements HttpCallOutMock{
    	
    	public HTTPResponse respond(HTTPRequest req) {
        
        //Create a fake response
        Date effDt=system.today();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
       
        string body='{"username": "ESB.BUSACQ.HERONSVC","access_token": "1fb4ed5a-643e-4aca-a77c-7bf158d0d308","token_type": "Bearer","expires_in": 3650, "refresh_token": "2074667d-c0e4-4346-8dd6-54a50d500d88", "scope": "oob", "jwt_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogIkVTQi5CVVNBQ1EuSEVST05TVkMiLA0KICAiYXpwIjogIk5TWmtOZHhZQVhpb0FJRldUdXAzQWl4RjZyekdGRFlzIiwNCiAgImlzcyI6ICJodHRwczovL3QtZWFhc3RzLXRzdC50ZXN0Lmhjc2NpbnQubmV0L2Nvbm5lY3QiLA0KICAiaWF0IjogMTUwNzc4NzA4MSwNCiAgImV4cCI6IDE1MDc3OTA3MzEsDQogICJoY3NjX3ByaXZhdGVfY2xhaW1zIjogDQogIHsNCiAgICAgICJwZXJtaXNzaW9ucyI6ICJjbj1IRVJPTl9TRVJWSUNFX0FDQ0VTUyxvdT1CdXNpbmVzcyBBY3F1aXNpdGlvbn5BTUEtMSxvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQIg0KICB9DQp9.YCC8Yn4ySxP5yZeXsOV-4yQX8fcNM_mlbtnQIoJqRKsz9lQLO_gYqfZerdwD_wAp0ZytcujE-E94tBA4aYHGKXBhy4OBlqFMkqLCoEV-vnXwZjRnO0SWR6m-RyPkgSVm3iE60b3CmbcARbg9euVui9PCwND7_feirIXPMD3DaBww5au8p0Ahz0d3mOWOg5IBUo_j_BaeejZmG6rW2kzdJrKOZoHisyRPTKiHuf0wtKVMVJJFEdzP34N4C8qs0-ReG921Y1tqe_AtHxHFEllY5aT5JAshh2O8tkCJ5BABCXmq6wlDSBVrCAolqtHNgvGTbqmJnwOVEhfrU6oC6DnjCg"}';
        res.setBody(body); 
      //  res.setBody('{"access_token":"00Dc0000003vofd!ARIAQLIKI_qsmMvfw4TLA_R9A2.8ntLLgYdFGpfTl3efFCxzvGZVIpXpeaI6TAT3PMbIRVq6ujruG7ESPWB4KIfOIZMz3E_8", "instance_url": "https://hcscgroup--MeiDevelop.cs14.my.salesforce.com","id": "https://test.salesforce.com/id/00Dc0000003vofdEAA/005c0000003S51gAAC", "token_type": "Bearer", "issued_at": "1507782505351", "signature": "5dn/UiqpnVqI0be/N+gqm9p/VAe7RULk4aNJmZG8wMo="}');
        res.setStatusCode(201);
       
        return res;
     }
   }
        
      public class APIQuoteRateTokenCallWithError implements HttpCallOutMock{
    	
    	public HTTPResponse respond(HTTPRequest req) {
        
        //Create a fake response
        Date effDt=system.today();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
       
       /// string body='{"username": "ESB.BUSACQ.HERONSVC","access_token": "1fb4ed5a-643e-4aca-a77c-7bf158d0d308","token_type": "Bearer","expires_in": 3650, "refresh_token": "2074667d-c0e4-4346-8dd6-54a50d500d88", "scope": "oob", "jwt_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogIkVTQi5CVVNBQ1EuSEVST05TVkMiLA0KICAiYXpwIjogIk5TWmtOZHhZQVhpb0FJRldUdXAzQWl4RjZyekdGRFlzIiwNCiAgImlzcyI6ICJodHRwczovL3QtZWFhc3RzLXRzdC50ZXN0Lmhjc2NpbnQubmV0L2Nvbm5lY3QiLA0KICAiaWF0IjogMTUwNzc4NzA4MSwNCiAgImV4cCI6IDE1MDc3OTA3MzEsDQogICJoY3NjX3ByaXZhdGVfY2xhaW1zIjogDQogIHsNCiAgICAgICJwZXJtaXNzaW9ucyI6ICJjbj1IRVJPTl9TRVJWSUNFX0FDQ0VTUyxvdT1CdXNpbmVzcyBBY3F1aXNpdGlvbn5BTUEtMSxvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQIg0KICB9DQp9.YCC8Yn4ySxP5yZeXsOV-4yQX8fcNM_mlbtnQIoJqRKsz9lQLO_gYqfZerdwD_wAp0ZytcujE-E94tBA4aYHGKXBhy4OBlqFMkqLCoEV-vnXwZjRnO0SWR6m-RyPkgSVm3iE60b3CmbcARbg9euVui9PCwND7_feirIXPMD3DaBww5au8p0Ahz0d3mOWOg5IBUo_j_BaeejZmG6rW2kzdJrKOZoHisyRPTKiHuf0wtKVMVJJFEdzP34N4C8qs0-ReG921Y1tqe_AtHxHFEllY5aT5JAshh2O8tkCJ5BABCXmq6wlDSBVrCAolqtHNgvGTbqmJnwOVEhfrU6oC6DnjCg"}';
       // res.setBody(body); 
        res.setBody('{"access_token":"00Dc0000003vofd!ARIAQLIKI_qsmMvfw4TLA_R9A2.8ntLLgYdFGpfTl3efFCxzvGZVIpXpeaI6TAT3PMbIRVq6ujruG7ESPWB4KIfOIZMz3E_8", "instance_url": "https://hcscgroup--MeiDevelop.cs14.my.salesforce.com","id": "https://test.salesforce.com/id/00Dc0000003vofdEAA/005c0000003S51gAAC", "token_type": "Bearer", "issued_at": "1507782505351", "signature": "5dn/UiqpnVqI0be/N+gqm9p/VAe7RULk4aNJmZG8wMo="}');
        res.setStatusCode(201);
       
        return res;
     }   
    }
     public class APIOAuthUtilityMockExpiredToken implements HttpCallOutMock{
    	
    	public HTTPResponse respond(HTTPRequest req) {
        
        //Create a fake response
        Date effDt=system.today();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token_expired":"this token is expired"}');
       // res.setBody('{"message":"Quote Rate Request Recieved for QuoteReqId:a2z19000000oliSAAQ"}');
        res.setStatusCode(401);
       
        return res;
     }
    }
    
     public class APIQuoteReqServiceCall implements HttpCallOutMock{
    	
    	public HTTPResponse respond(HTTPRequest req) {
        
        //Create a fake response
        Date effDt=system.today();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token_expired":"this token is expired"}');
       // res.setBody('{"message":"Quote Rate Request Recieved for QuoteReqId:a2z19000000oliSAAQ"}');
        res.setStatusCode(401);
       
        return res;
     }
    }
    */
}