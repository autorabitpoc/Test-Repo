public with sharing class APIQuoteRateUtility {
/*
     public static String password;
     public static String userName;
     public static String certificate;
   //  private static String baseUrl;
     public static String clientId;
     public static String clientSecret;
     public static Id heronIntId;
     public static String tokenEndpoint;
     public static String endPoint;
     public final static String heronIntName='Integration Heron';
     public final static String heronCallOut='HeronCallOut';
     public static Heron_OAuth__c heronOauth=new Heron_OAuth__c();
     public static Username_Password__c callOutSetting=new Username_Password__c();

     private static CustomSettingDAO.ICustomSettingDAO customSettingInstance=new CustomSettingDAO();
     private static boolean updateTokenSetting=false;

     public static DTOQuoteRateRTResponse  CreateGetRateCallout(DTOQuoteRateRequest reqDTO){
        
     // String reqResult =null;
      DTOQuoteRateRTResponse  serviceResult=new DTOQuoteRateRTResponse ();

     // baseUrl=System.URL.getSalesforceBaseUrl().toExternalForm();
      User heronInt = [SELECT Id FROM User WHERE Name =:heronIntName];
       
      if(heronInt!=null){
          heronIntId=heronInt.id;
          heronOauth=customSettingInstance.getHeronOAuthSetting(heronIntId);
          callOutSetting=customSettingInstance.getUsernamePasswordCSByName(heronCallOut);
           
          endPoint=callOutSetting.EndPoinUrl__c;
          password=heronOauth.Password__c;
          userName=heronOauth.UserName__c;
          certificate=heronOauth.Certificate__c;
          clientId=heronOauth.Client_Id__c;
          clientSecret=heronOauth.Client_Secret__c;
          tokenEndpoint=heronOauth.End_Point__c;
          system.debug('heronInt User id: '+heronIntId);
          
          system.debug('endPoint: '+endPoint+' userName: '+userName+ ' tokenEndpoint: '+tokenEndpoint+' clientId:::'+clientId+'  clientSecret:'+clientSecret);

      }else{
         system.debug('missing heron Integration Profile. Please check profile Name in systme: '+heronIntName);
          serviceResult.statusCode='500';
          serviceResult.statusMessage=' User: '+heronIntName+' is not existing!';
          serviceResult.error='Internal Service Error';
          return serviceResult;

      }
        
     try {
        String accesstoken=null;// InvokeTokenService();
        DTOQuoteRateRTResponse  tokenRes=null;

        if( isTokenExpired()){
            tokenRes=InvokeTokenService();

            if(tokenRes!=null){
              if(tokenRes.statusCode!='201'){
                    system.debug('token error: '+tokenRes.statusMessage);
                    serviceResult.error='Token Exception: '+tokenRes.statusMessage;
                    serviceResult.statusCode=tokenRes.statusCode;
                    serviceResult.statusMessage=tokenRes.statusMessage;
                    return serviceResult;
                    //return tokenRes.statusMessage;
               }else {
                  accesstoken=tokenRes.accessToken;
                  system.debug('accessToken:::: '+accessToken);
               }
            }
        }else{

            accesstoken='';//heronOauth.JWT_Token__c+heronOauth.JWT_Token2__c+heronOauth.JWT_Token3__c+heronOauth.JWT_Token4__c+heronOauth.JWT_Token5__c;
            if(heronOauth.JWT_Token__c!=null){
              accesstoken=accesstoken+heronOauth.JWT_Token__c;
            }
            if(heronOauth.JWT_Token2__c!=null){
              accesstoken=accesstoken+heronOauth.JWT_Token2__c;
            }
            if(heronOauth.JWT_Token3__c!=null){
              accesstoken=accesstoken+heronOauth.JWT_Token3__c;
            }
            if(heronOauth.JWT_Token4__c!=null){
              accesstoken=accesstoken+heronOauth.JWT_Token4__c;
            }
            if(heronOauth.JWT_Token5__c!=null){
              accesstoken=accesstoken+heronOauth.JWT_Token5__c;
            }

            system.debug('get token from custom setting: '+accesstoken);
        }

        HttpRequest req=setupHttpRequest(accesstoken,reqDTO);//new HttpRequest(); 
       
        if (req == null || String.isBlank(req.getBody())) {
                    system.debug('The HttpRequest was invalid. Contact administrator.');
                    serviceResult.statusCode='401';//bad request
                    serviceResult.statusMessage='Error! Invalid Request data, please contact system administrator.';
                    serviceResult.error='bad request data:'+req;
                    return serviceResult;
         }
         system.debug('HERON IB callout request::'+req.getBody());
            //Call API
         HttpResponse res = InvokeService(req);

         if(isTokenRespondedExpired(res)){

                tokenRes=InvokeTokenService();
               
                if(tokenRes!=null && tokenRes.statusCode=='201'){
                   req=setupHttpRequest(tokenRes.accessToken, reqDTO);
                   res = InvokeService(req);
                }else{
                    system.debug('token error: '+tokenRes.statusMessage);
                    serviceResult.error='Token Exception: '+tokenRes.statusMessage;
                    serviceResult.statusCode=tokenRes.statusCode;
                    serviceResult.statusMessage=tokenRes.statusMessage;
                    return serviceResult;
                }
           }
                  
            String jsonStr ='';
            if(res !=null){
              jsonStr=res.getBody();

            }else{
                serviceResult.statusCode='401';
                serviceResult.statusMessage='Error! Failed to send Quote Request to Heron. Please contact System Administrator.';
                serviceResult.error='Received Empty Response data from HERON service. ';
                return serviceResult;
            }
           
            system.debug(LoggingLevel.INFO,'Quote Response: '+jsonStr);
             

             if(res!=null && String.valueOf(res.getStatusCode())=='201'){
                //reqResult=jsonResult(jsonStr, 'message');
                serviceResult.statusCode='201';
                serviceResult.statusMessage='Quote Request:'+reqDTO.quoteReqId+' is Successfully received by Heron.';
                serviceResult.error=null;
             }else{
                //reqResult=jsonResult(jsonStr,'errorMessage');
                serviceResult.statusCode='401';
                serviceResult.statusMessage='Error! Failed to send Quote Request to Heron. Please contact System Administrator.';
                serviceResult.error=jsonResult(jsonStr,'errorMessage');//res.getStatus();//'Error! Failed to send Quote Request to Heron. Please contact System Administrator.';
                system.debug('json error: '+serviceResult.error);
             }
        
           //update the HeroOauth after the service call. order is matter to avoid dml before the  WS call
           
          if (updateTokenSetting){
            try{
              Heron_Oauth__c updateOauth=[select id, name, JWT_Token__c,Refresh_Token__c, Last_Updated_Date_Time__c from Heron_Oauth__c where end_point__c=:tokenEndpoint]; 
              
             if(updateOauth!=null && accessToken !=null){
                Integer accessLen=accessToken.length();//848= 212,,212,212,212

              system.debug('new accesstoken length: '+accessLen+'  accesstoken::::==>'+accesstoken+'<----');
                
               updateOauth.JWT_Token__c=accessToken.substring(0,accessLen/5);
               updateOauth.JWT_Token2__c=accessToken.substring(accessLen/5,2*(accessLen/5));
               updateOauth.JWT_Token3__c=accessToken.substring(2*(accessLen/5), 3*(accessLen/5));
               updateOauth.JWT_Token4__c=accessToken.substring(3*(accessLen/5),4*(accessLen/5));
               updateOauth.JWT_Token5__c=accessToken.substring(4*(accessLen/5));
              // updateOauth.JWT_Token__c=accessToken;
               updateOauth.Last_Updated_Date_Time__c=system.now();
                
               update updateOauth;

               system.debug('jwt_token__c -->'+updateOauth.JWT_Token__c+'<---');
               system.debug('jwt_token2__c -->'+updateOauth.JWT_Token2__c+'<----');
               system.debug('jwt_token3__c -->'+updateOauth.JWT_Token3__c+'<----');
               system.debug('jwt_token4__c -->'+updateOauth.JWT_Token4__c+'<----');
              system.debug('jwt_token4__c -->'+updateOauth.JWT_Token5__c+'<----');


             }
            }catch (System.DmlException dmle){
                system.debug('update JWT Token to custom setting exception:  '+dmle);
            }
           }

        } catch (Exception e) {
            system.debug(e);
            serviceResult.statusCode='401';
            serviceResult.statusMessage='Error! Failed to send Quote Request to Heron. Please contact System Administrator.';
            serviceResult.error='Exceptoin: '+e;
        }   

        system.debug('service call result: '+serviceResult);  
        return serviceResult;
    }
    
    @TestVisible
    private static HttpRequest setupHttpRequest(String accesstoken, DTOQuoteRateRequest reqDTO){

        HttpRequest request=new HttpRequest(); 
          
        // Blob headerValue = Blob.valueOf(userName + ':' + password);        
        // String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
          //  system.debug(LoggingLevel.DEBUG, '64Encoded Basic from service: ' + authorizationHeader);
            
    //    if(baseUrl!=null && (baseUrl.contains('SAMSIT') || baseUrl.contains('samsit'))){ //samsit is current set up with datapower connection
       //     endPoint='https://gateway.wtc.hcsc.net/services/heron/rest/quoteRateRequest';
        //   request.setHeader('Authorization', authorizationHeader+','+'Bearer '+accesstoken);  // in samsit as 9/19/2017
          // system.debug('calling from Samsit:::::'+baseUrl);
         //}else{
         system.debug('set authorization with accesstoken--->'+accesstoken+'<-----');
         request.setHeader('Authorization', 'Bearer ' + accesstoken); // muselsoft in samTEST
        //  }
         system.debug('header setting::'+request.getHeader('Authorization'));
         request.setEndpoint(endPoint);
         request.setMethod('POST');
         request.setCompressed(false);
         request.setHeader('Accept','application/json');
         request.setheader('Content-Type','application/json');
         request.setClientCertificateName(certificate);
            
         system.debug('jwtToken: '+accesstoken);
            
         String reqBody = JSON.serialize(reqDTO);
         system.debug('request body: '+reqBody);
           
         request.setBody(reqBody);
           
         system.debug(LoggingLevel.INFO,'Quote Request: '+reqBody);

         return request;

    }

    
   @TestVisible 
   private  static boolean isTokenRespondedExpired(HttpResponse resp){
      if (resp == null) {
            return false;
      }
    
      String body = '' + resp.getBody();
      if (resp.getStatusCode() != 201 && body.contains('access_token_expired')) {
            system.debug('401 Token Expiration Response occurred');
         return true;
     }
        return false;

   }
    

   @TestVisible    
    private static boolean isTokenExpired(){
        if (heronOauth== null || heronOauth.Last_Updated_Date_Time__c== null ||  heronOauth.duration__c == null) {
           system.debug(' token expired');
            return true;
        }
        Datetime nowTime = DateTime.now();
        decimal minDuration = ((nowTime.getTime()/1000/60) - (heronOauth.Last_Updated_Date_Time__c).getTime()/1000/60);   
        return (minDuration >= heronOauth.duration__c);// if great than the during in custom setting
    }

    public static DTOQuoteRateRTResponse InvokeTokenService(){
        
        //String tokenAccess=null;
        DTOQuoteRateRTResponse tokenRes=new DTOQuoteRateRTResponse();

        Http http = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req=new HttpRequest(); 
        
        try{
     
            //String endpoint=heronOauth.end_Point__c;//'https://gateway.wtc.hcsc.net/services/sts/ssl/b2b/getjwtoken';
            //String certificate=heronOauth.Certificate__c;//'eamsg_salesforce_hcscexttest_net';//custom setting
            //String username=heronOauth.UserName__c;//'ESB.BUSACQ.HERONSVC';
            //String password=heronOauth.Password__c;//'mU8AfRaj';//'p7atrUTH';
          
            system.debug('client Id: -->'+clientId+'<---  clientSecret:::-->'+clientSecret+'<---- certificate:::'+certificate);
           
            req.setEndpoint(tokenEndpoint);
            req.setMethod('POST');
        
            req.setCompressed(false);
            req.setHeader('Accept','application/json');
            req.setheader('Content-Type','application/json');
            req.setHeader('ClientSecret',clientSecret);//'7681dBc2867e4b9aBf3621a72F9967E2');
            req.setHeader('ClientId',clientId);//'5c22ab6f60d8474abd0bae13cbdb1c38');// 'a947eb37f9664ff4acf6af4945a9f3eb');
            req.setClientCertificateName(certificate);//certificate);
       
            String  body = res.getBody();
            system.debug('clientId:'+req.getHeader('ClientId')+' clientSecret: '+req.getHeader('ClientSecret') );
            String tokenRequest='{"username":"'+userName+'", "password":"'+password+'"}';//'{"username":"ESB.BUSACQ.HERONSVC", "password":"mU8AfRaj"}';
            req.setbody(tokenRequest);
        
            system.debug(' token servcie request body: '+req.getBody());
            res = InvokeService(req);
            tokenRes.statusCode=res.getStatus();
            
            system.debug('token service response:'+res);

            String jsonStr = res.getBody();
        
            system.debug(LoggingLevel.INFO,'Token Response: '+jsonStr);
            
            if(jsonStr!=null && jsonStr!=''){
        
                DTOJwtTokenResponse token=(DTOJwtTokenResponse) System.JSON.deserialize(jsonStr,DTOJwtTokenResponse.class);
        
                if(token==null || String.isBlank(token.access_token)){
                    tokenRes.statusCode='401';
                    tokenRes.statusMessage='Error! Can not retrieve Access Token from JWT token API.';
                    tokenRes.error='Error! Can not retrieve Access Token from JWT token API.';
                    //throw new OAuthCustomSettingsException('Can not retrieve Access Token from JWT token API.');
                }else{
                    tokenRes.accessToken=token.jwt_token;//token.access_token;
                    tokenRes.statusMessage='Retrieved Token Successfully';
                    tokenRes.statusCode='201';
                    heronOauth.JWT_Token__c=token.jwt_token;
                    heronOauth.Last_Updated_Date_Time__c=system.now();
                    updateTokenSetting=true;


                }
            }else{
                tokenRes.statusCode='500';
                tokenRes.statusMessage='Token Retrival Error! Please contact System Administrator.';
            }
            
        }catch(Exception e){
            system.debug('token service  exception: '+e);
            tokenRes.statusCode='500';
            tokenRes.statusMessage='Integration Token error. Please contact System Administrator. ';
            tokenRes.accesstoken=null;
            tokenRes.error=e.getMessage();
            return tokenRes;
        }
         
        return tokenRes;//tokenAccess;
    }
   
   @TestVisible
    private static HttpResponse InvokeService(HttpRequest req){
        
        HttpResponse response=new HttpResponse();
        Http http = new Http();
        
        try{
        
         //Try to call the service.        
          response = http.send(req);
          
          system.debug('Heron service response: '+response);
        }catch (Exception e){
            system.debug('invokeService exception: '+e);
        }
        
        return response;
    }
    
    @TestVisible
    private static String jsonResult (String jsonBody, String fieldName){
    
        
          JSONParser parser = JSON.createParser(jsonBody);
      
          String token = null;
      
       try {
        
        while (parser.nextToken() != null) {
             if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == fieldName)) {  
                    parser.nextToken();
                    token = parser.getText();
                    system.debug(' message:'+token);
               }
         }
         
        } catch (JSONException e) {
            system.debug('json exception: '+e);
            token=' Json Exception: '+e;
        }
        return token;
    }
    
    public class OAuthCustomSettingsException extends Exception {}
    
    */
}