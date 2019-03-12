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
private class APICallOutRestWSUtilityTest {

    static testMethod void testSendAdjustmentWSCallOut() {
        // TO DO: implement unit test
        
        
        DTOGFRA_AdjustmentResponse reqDTO =new DTOGFRA_AdjustmentResponse();
        reqDTO.adjustmentRequestID='12345';
        reqDTO.finalApproverName='test tester';
        reqDTO.status='Approved';
        reqDTO.rejectionReason=null;
       
        Test.startTest();
        //List<OAuth_Jwt_Token__c> bList=
       // Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
        test.setMock(HttpCalloutMock.class, new MockAPIJwtTokenCall());
        List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        
        new APICallOutRestWSUtility('GFRA_Callout').SendAdjustmentWSCallOut(reqDTO);
        Test.stopTest();
    }
    
    static testMethod void testCreateGetRageHeronCallout(){
        DTOQuoteRateRequest reqDTO =new DTOQuoteRateRequest();
        reqDTO.hcscDivision='IL';
        reqDTO.accountNumber='IL005599';
        reqDTO.accountName='testAcct';
        reqDTO.opportunityName='testOpp';
        reqDTO.quoteReqId='testQR001';
        reqDTO.quoteReqDesc='this is test quote request';
        reqDTO.salesRep='tester resp';
        reqDTO.rateEffectiveDate=system.today();
        reqDTO.lastModifiedDate=system.now();
        
        Test.startTest();
        List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        
       // Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
        
        test.setMock(HttpCalloutMock.class, new MockAPIJwtTokenCall());
        new APICallOutRestWSUtility('HeronCallOut').CreateGetRageHeronCallout(reqDTO);
        Test.stopTest();
    }
    
     static testMethod void testsetupMuleSoftHttpRequest(){
        DTOQuoteRateRequest reqDTO =new DTOQuoteRateRequest();
        reqDTO.hcscDivision='IL';
        reqDTO.accountNumber='IL005599';
        reqDTO.accountName='testAcct';
        reqDTO.opportunityName='testOpp';
        reqDTO.quoteReqId='testQR001';
        reqDTO.quoteReqDesc='this is test quote request';
        reqDTO.salesRep='tester resp';
        reqDTO.rateEffectiveDate=system.today();
        reqDTO.lastModifiedDate=system.now();
        
         List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        
      //  Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
        
        
        String jwttoken='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogIkVTQi5CVVNBQ1EuSEVST05TVkMiLA0KICAiYXpwIjogIk5TWmtOZHhZQVhpb0FJRldUdXAzQWl4RjZyekdGRFlzIiwNCiAgImlzcyI6ICJodHRwczovL3QtZWFhc3RzLXRzdC50ZXN0Lmhjc2NpbnQubmV0L2Nvbm5lY3QiLA0KICAiaWF0IjogMTUwNzc4NzA4MSwNCiAgImV4cCI6IDE1MDc3OTA3MzEsDQogICJoY3NjX3ByaXZhdGVfY2xhaW1zIjogDQogIHsNCiAgICAgICJwZXJtaXNzaW9ucyI6ICJjbj1IRVJPTl9TRVJWSUNFX0FDQ0VTUyxvdT1CdXNpbmVzcyBBY3F1aXNpdGlvbn5BTUEtMSxvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQIg0KICB9DQp9.YCC8Yn4ySxP5yZeXsOV-4yQX8fcNM_mlbtnQIoJqRKsz9lQLO_gYqfZerdwD_wAp0ZytcujE-E94tBA4aYHGKXBhy4OBlqFMkqLCoEV-vnXwZjRnO0SWR6m-RyPkgSVm3iE60b3CmbcARbg9euVui9PCwND7_feirIXPMD3DaBww5au8p0Ahz0d3mOWOg5IBUo_j_BaeejZmG6rW2kzdJrKOZoHisyRPTKiHuf0wtKVMVJJFEdzP34N4C8qs0-ReG921Y1tqe_AtHxHFEllY5aT5JAshh2O8tkCJ5BABCXmq6wlDSBVrCAolqtHNgvGTbqmJnwOVEhfrU6oC6DnjCg';
        String reqBody = JSON.serialize(reqDTO);
        test.startTest();
        //new APICallOutRestWSUtility('HeronCallout').setupMuleSoftHttpRequest(jwttoken,reqBody);
        test.stopTest();
     
     }
     
      static testMethod void testsetupDPHttpRequest(){
        DTOGFRA_AdjustmentResponse reqDTO=new DTOGFRA_AdjustmentResponse();
        reqDTO.adjustmentRequestID='12345';
        reqDTO.finalApproverName='test tester';
        reqDTO.status='Approved';
        reqDTO.rejectionReason=null;
        List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        
      //  Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
        
        
        String jwttoken='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogIkVTQi5CVVNBQ1EuSEVST05TVkMiLA0KICAiYXpwIjogIk5TWmtOZHhZQVhpb0FJRldUdXAzQWl4RjZyekdGRFlzIiwNCiAgImlzcyI6ICJodHRwczovL3QtZWFhc3RzLXRzdC50ZXN0Lmhjc2NpbnQubmV0L2Nvbm5lY3QiLA0KICAiaWF0IjogMTUwNzc4NzA4MSwNCiAgImV4cCI6IDE1MDc3OTA3MzEsDQogICJoY3NjX3ByaXZhdGVfY2xhaW1zIjogDQogIHsNCiAgICAgICJwZXJtaXNzaW9ucyI6ICJjbj1IRVJPTl9TRVJWSUNFX0FDQ0VTUyxvdT1CdXNpbmVzcyBBY3F1aXNpdGlvbn5BTUEtMSxvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQIg0KICB9DQp9.YCC8Yn4ySxP5yZeXsOV-4yQX8fcNM_mlbtnQIoJqRKsz9lQLO_gYqfZerdwD_wAp0ZytcujE-E94tBA4aYHGKXBhy4OBlqFMkqLCoEV-vnXwZjRnO0SWR6m-RyPkgSVm3iE60b3CmbcARbg9euVui9PCwND7_feirIXPMD3DaBww5au8p0Ahz0d3mOWOg5IBUo_j_BaeejZmG6rW2kzdJrKOZoHisyRPTKiHuf0wtKVMVJJFEdzP34N4C8qs0-ReG921Y1tqe_AtHxHFEllY5aT5JAshh2O8tkCJ5BABCXmq6wlDSBVrCAolqtHNgvGTbqmJnwOVEhfrU6oC6DnjCg';
        String reqBody = JSON.serialize(reqDTO);
        
        test.startTest();
        new APICallOutRestWSUtility('GFRA_Callout').setupDPHttpRequest(jwttoken,reqBody);
        test.stopTest();
      }
     
     static testMethod void testjsonResult(){
        test.startTest();
        
        String jsonStr='{"username": "ESB.BUSACQ.HERONSVC","access_token": "1fb4ed5a-643e-4aca-a77c-7bf158d0d308","token_type": "Bearer","expires_in": 3650, "refresh_token": "2074667d-c0e4-4346-8dd6-54a50d500d88", "scope": "oob", "jwt_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogIkVTQi5CVVNBQ1EuSEVST05TVkMiLA0KICAiYXpwIjogIk5TWmtOZHhZQVhpb0FJRldUdXAzQWl4RjZyekdGRFlzIiwNCiAgImlzcyI6ICJodHRwczovL3QtZWFhc3RzLXRzdC50ZXN0Lmhjc2NpbnQubmV0L2Nvbm5lY3QiLA0KICAiaWF0IjogMTUwNzc4NzA4MSwNCiAgImV4cCI6IDE1MDc3OTA3MzEsDQogICJoY3NjX3ByaXZhdGVfY2xhaW1zIjogDQogIHsNCiAgICAgICJwZXJtaXNzaW9ucyI6ICJjbj1IRVJPTl9TRVJWSUNFX0FDQ0VTUyxvdT1CdXNpbmVzcyBBY3F1aXNpdGlvbn5BTUEtMSxvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQIg0KICB9DQp9.YCC8Yn4ySxP5yZeXsOV-4yQX8fcNM_mlbtnQIoJqRKsz9lQLO_gYqfZerdwD_wAp0ZytcujE-E94tBA4aYHGKXBhy4OBlqFMkqLCoEV-vnXwZjRnO0SWR6m-RyPkgSVm3iE60b3CmbcARbg9euVui9PCwND7_feirIXPMD3DaBww5au8p0Ahz0d3mOWOg5IBUo_j_BaeejZmG6rW2kzdJrKOZoHisyRPTKiHuf0wtKVMVJJFEdzP34N4C8qs0-ReG921Y1tqe_AtHxHFEllY5aT5JAshh2O8tkCJ5BABCXmq6wlDSBVrCAolqtHNgvGTbqmJnwOVEhfrU6oC6DnjCg"}';
        new APICallOutRestWSUtility('GFRA_Callout').jsonResult(jsonStr,'access_token');
        test.stopTest();
        
     }
     
     public class MockAPIJwtTokenCall implements HttpCallOutMock{
        
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
    
   public static testMethod void testProductGroupWSCallOut() {
        
        
        Date effectiveDate = Date.newInstance(2019, 01, 01);
        String effectiveDateStr=effectiveDate.Year()+'-'+effectiveDate.month()+'-'+effectiveDate.day();
        //SGR_GSPS_ProductGroupRequestWrapper reqDTO =new SGR_GSPS_ProductGroupRequestWrapper();
        SGR_GSPS_ProductGroupRequestWrapper wrP = new SGR_GSPS_ProductGroupRequestWrapper();
        wrP.clientId = 'RENEWALS' ;
        wrP.version =1 ;
        wrP.marketSegment ='SG';
        //wrP.effectiveDate  = effectiveDate;
       string str='2014-01-01';
       wrP.effectiveDate =Utility.parseDate(str);// SGR_DateUtils.parseDate(str);
        wrP.division = 'NM';
        wrP.fundingType = 'PREM';
       // wrP.planNames='dsfsd';
        wrP.fipsCode='sdfds';
        Test.startTest();
        //List<OAuth_Jwt_Token__c> bList=
      //  Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
        
        test.setMock(HttpCalloutMock.class, new MockAPIJwtTokenCall());
        List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        Integration_Log_Switcher__c  log = new Integration_Log_Switcher__c();
        log.Name='GSPS Product Group Service';
        log.Integration_Log__c=false;
        Utility.insertIntegrationLog('serviceName','anyId', 'status','errorDesc', Date.today(), Date.today(),'input','output');
       //new APICallOutRestWSUtility('GSPS_ProductGroupCallOut').invokeProductGroupService(wrP);
        String myendpoint= 'https://api-sit.hcsctest.net/gsps/productGroup?clientId=RENEWALS&marketSegment=SG&effectiveDate=2019-01-01&division=IL&fundingType=PREM';
        string accesstoken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogImU2NzU5MDE2IiwNCiAgImF6cCI6ICI1YzIyYWI2ZjYwZDg0NzRhYmQwYmFlMTNjYmRiMWMzOCIsDQogICJpc3MiOiAiaHR0cHM6Ly90LWVhYXN0cy10c3QudGVzdC5oY3NjaW50Lm5ldC9jb25uZWN0IiwNCiAgImlhdCI6IDE1NDIzMDc5NzUsDQogICJleHAiOiAxNTQyMzExNjI1LA0KICAiaGNzY19wcml2YXRlX2NsYWltcyI6IA0KICB7DQogICAgICAicGVybWlzc2lvbnMiOiAiY249QXBwbGljYXRpb25fQWNjZXNzLG91PUFTTyBCaWxsaW5nIEFkanVzdGVyLG91PUF1dGhvcml0aWVzLG91PUZyYW1ld29yayxvdT1TZXJ2aWNlcyxvPUVYVExEQVA7Y249Vmlld19EZXRhaWwsb3U9QVNPIEJpbGxpbmcgQWRqdXN0ZXIsb3U9QXV0aG9yaXRpZXMsb3U9RnJhbWV3b3JrLG91PVNlcnZpY2VzLG89RVhUTERBUDtjbj1DcmVhdGVfUmVxdWVzdCxvdT1BU08gQmlsbGluZyBBZGp1c3RlcixvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQO2NuPUF0dGFjaF9Eb2N1bWVudHMsb3U9QVNPIEJpbGxpbmcgQWRqdXN0ZXIsb3U9QXV0aG9yaXRpZXMsb3U9RnJhbWV3b3JrLG91PVNlcnZpY2VzLG89RVhUTERBUDtjbj1VcGRhdGVfUmVxdWVzdCxvdT1BU08gQmlsbGluZyBBZGp1c3RlcixvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQO2NuPU1haW50ZW5hbmNlLG91PUFTTyBCaWxsaW5nIEFkanVzdGVyLG91PUF1dGhvcml0aWVzLG91PUZyYW1ld29yayxvdT1TZXJ2aWNlcyxvPUVYVExEQVAiDQogIH0NCn0.FIP5sPKhgUitcFSbYW004wwldO13iT6dj1zeHWM5XKlzYA-M9nA5oYOlBRnbuR9Oad7wsKqqCy7VJjvHKAftX-U84cS0xSpKL9C3xBOpnHN6rUjceg1R43fdqg_QfYNJNt_dUpsWUc6SZ19l9-KwRLj5e6DMntwMjfL5bSZzS9uqE1mLTz_qOuZRZ21EbOJMTzQD31q4aS2w9hrMcRKuFkqdnQdUGNjnnDkUOwEWi08_flX-aGfA_nYuwHgcl3t97o-9OENaMdOq1IXa1jCZbc6oLX0qrrc-PkVQLErBuH_xbQRoRxfEMRw7_LD27n1e_1KZQ53O8XtkJNlW0T06rw';
        APICallOutRestWSUtility apiCal = new APICallOutRestWSUtility('GSPS_ProductGroupCallOut');
        apiCal.invokeProductGroupService(wrP);
        apiCal.setupMuleSoftHttpRequest(accesstoken, null, 'GET');
       //setupMuleSoftHttpRequest(accesstoken,null,'GET');
        Test.stopTest();
    }
    
    public static testMethod void testInvokeAgerateWSCallOut() {
        
      
        Date effectiveDate = Date.newInstance(2019, 01, 01);
        String effectiveDateStr=effectiveDate.Year()+'-'+effectiveDate.month()+'-'+effectiveDate.day();
        SGR_URE_GetAgeRatesRequestWrapper.URE_Plan plan = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
        List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan> planList = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>();
        plan.planId = 'SPSG10BCOSILO';
        planList.add(plan);
        SGR_URE_GetAgeRatesRequestWrapper.URE_Plans plans = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plans();
        plans.plan = planList;
        SGR_URE_GetAgeRatesRequestWrapper.RffRequestWrapper rftReq = new SGR_URE_GetAgeRatesRequestWrapper.RffRequestWrapper();
        rftReq.plans = plans;
        rftReq.applicationId = 'RenewalsSalesForce';
        rftReq.countyCode = '17111';
        rftReq.marketSegment = 'SG';
        rftReq.rateEffectiveDate = '01/01/2019';
        rftReq.referenceId = '13127874';
        rftReq.requestType = 1;
        rftReq.isExchange = false;
        rftreq.corporateEntityCode = 'IL1';
        SGR_URE_GetAgeRatesRequestWrapper obj = new SGR_URE_GetAgeRatesRequestWrapper();
        obj.rffRequest =rftReq;
        
        CustomSettingDAO.ICustomSettingDAO customSettingInstance=new CustomSettingDAO();
        Username_Password__c pwd = new Username_Password__c();
        pwd.Name = 'URE_Rate_Callout';
        pwd.Integration_Name__c = 'Integration SGR';
        pwd.EndPoinUrl__c = 'https://test';
        pwd.Password__c = 'Password';
        insert pwd;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User u =new User();
        u.FirstName = 'Integration test';
        u.LastName = 'SGR';
        u.Alias = 'ISGR';
        u.Email = 'xyz@gmail.com';
        u.Username = 'Integrationxyz@gmail.com';
        u.IsActive = true;
        u.ProfileId = profileId.id;
        u.TimeZoneSidKey = 'GMT';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        OAuth_Jwt_Token2__c oAuth = new OAuth_Jwt_Token2__c();
        oAuth.Name = 'Integration test SGR';
        //oAuth.SetupOwnerId=u.Id;
        oAuth.Password__c='xx';
     	oAuth.UserName__c = 'xs123';
     	oAuth.End_Point__c = 'https://test';
        oAuth.Last_Updated_Date_Time__c = System.now();
        oAuth.JWT_Token__c = 'xyz1234';
        oAuth.Client_Id__c = 'sdfsdjkfh7845';
        oAuth.Client_Secret__c = 'ghfhg9067kljgghh';
     	insert oAuth;
        
        APICallOutRestWSUtility objUtility = new APICallOutRestWSUtility('Integration test SGR');
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        User iUser = userDAOInstance.getUserByName(u.name);
        APIJwtOAuthUtility oAuthUtil = new APIJwtOAuthUtility('Integration test SGR');
        
        Test.startTest();
        //List<OAuth_Jwt_Token__c> bList=
        Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        test.setMock(HttpCalloutMock.class, new MockAPIJwtTokenCall());
        List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        Integration_Log_Switcher__c  log = new Integration_Log_Switcher__c();
        log.Name='URE CallOut';
        log.Integration_Log__c=false;
        Utility.insertIntegrationLog('serviceName','anyId', 'status','errorDesc', Date.today(), Date.today(),'input','output');
        String myendpoint= 'https://api-sit.hcsctest.net/gsps/productGroup?clientId=RENEWALS&marketSegment=SG&effectiveDate=2019-01-01&division=IL&fundingType=PREM';
        string accesstoken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogImU2NzU5MDE2IiwNCiAgImF6cCI6ICI1YzIyYWI2ZjYwZDg0NzRhYmQwYmFlMTNjYmRiMWMzOCIsDQogICJpc3MiOiAiaHR0cHM6Ly90LWVhYXN0cy10c3QudGVzdC5oY3NjaW50Lm5ldC9jb25uZWN0IiwNCiAgImlhdCI6IDE1NDIzMDc5NzUsDQogICJleHAiOiAxNTQyMzExNjI1LA0KICAiaGNzY19wcml2YXRlX2NsYWltcyI6IA0KICB7DQogICAgICAicGVybWlzc2lvbnMiOiAiY249QXBwbGljYXRpb25fQWNjZXNzLG91PUFTTyBCaWxsaW5nIEFkanVzdGVyLG91PUF1dGhvcml0aWVzLG91PUZyYW1ld29yayxvdT1TZXJ2aWNlcyxvPUVYVExEQVA7Y249Vmlld19EZXRhaWwsb3U9QVNPIEJpbGxpbmcgQWRqdXN0ZXIsb3U9QXV0aG9yaXRpZXMsb3U9RnJhbWV3b3JrLG91PVNlcnZpY2VzLG89RVhUTERBUDtjbj1DcmVhdGVfUmVxdWVzdCxvdT1BU08gQmlsbGluZyBBZGp1c3RlcixvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQO2NuPUF0dGFjaF9Eb2N1bWVudHMsb3U9QVNPIEJpbGxpbmcgQWRqdXN0ZXIsb3U9QXV0aG9yaXRpZXMsb3U9RnJhbWV3b3JrLG91PVNlcnZpY2VzLG89RVhUTERBUDtjbj1VcGRhdGVfUmVxdWVzdCxvdT1BU08gQmlsbGluZyBBZGp1c3RlcixvdT1BdXRob3JpdGllcyxvdT1GcmFtZXdvcmssb3U9U2VydmljZXMsbz1FWFRMREFQO2NuPU1haW50ZW5hbmNlLG91PUFTTyBCaWxsaW5nIEFkanVzdGVyLG91PUF1dGhvcml0aWVzLG91PUZyYW1ld29yayxvdT1TZXJ2aWNlcyxvPUVYVExEQVAiDQogIH0NCn0.FIP5sPKhgUitcFSbYW004wwldO13iT6dj1zeHWM5XKlzYA-M9nA5oYOlBRnbuR9Oad7wsKqqCy7VJjvHKAftX-U84cS0xSpKL9C3xBOpnHN6rUjceg1R43fdqg_QfYNJNt_dUpsWUc6SZ19l9-KwRLj5e6DMntwMjfL5bSZzS9uqE1mLTz_qOuZRZ21EbOJMTzQD31q4aS2w9hrMcRKuFkqdnQdUGNjnnDkUOwEWi08_flX-aGfA_nYuwHgcl3t97o-9OENaMdOq1IXa1jCZbc6oLX0qrrc-PkVQLErBuH_xbQRoRxfEMRw7_LD27n1e_1KZQ53O8XtkJNlW0T06rw';   
        APICallOutRestWSUtility apiCal = new APICallOutRestWSUtility('URE_Rate_Callout');
        apiCal.invokeUREAgeRates(obj);
        apiCal.invokeUREAgeRates(obj);
        Test.stopTest();
     
    }
}