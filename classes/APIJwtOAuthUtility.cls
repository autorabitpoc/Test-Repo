public with sharing class APIJwtOAuthUtility {
	
  private String password;
  private String userName;
  private String tokenEndpoint;
  public String clientId;
  public String clientSecret;
  private String certificate;
  public  String endpoint;
  public  String accessToken;
  public Datetime lastTokenUpdateDateTime;//temp
//  public  OAuth_Jwt_Token__c oAuthCustomSetting=new OAuth_Jwt_Token__c();//Oauth custom setting 
  public  OAuth_Jwt_Token2__c oAuthCustomSetting2=new OAuth_Jwt_Token2__c();
  private CustomSettingDAO.ICustomSettingDAO customSettingInstance=new CustomSettingDAO();
  public  boolean updateTokenSetting=false;
  private Id integrationUserId; 
  private String integrationName;
  
   
  /* public APIJwtOAuthUtility (Id intUserId){
   //	 setOauthSetting(intUser);
   	// integrationUser= [SELECT Id FROM User WHERE Name =:intUser limit 1];// 'Integration GFRA'
   	     oAuthCustomSetting=customSettingInstance.getJWTOAuthSetting(intUserId);//retrieve the JWTOauthSetting from custom setting
   	   
         if(OAuthCustomSetting!=null){
     	 	password=OAuthCustomSetting.Password__c;
     	 	username=OAuthCustomSetting.UserName__c;
     	 	tokenEndpoint=OAuthCustomSetting.End_Point__c;
     	 	certificate=OAuthCustomSetting.Certificate__c;
     	 	clientId=OAuthCustomSetting.Client_Id__c;
     	 	clientSecret=OAuthCustomSetting.Client_Secret__c;
         }else{
            system.debug('Missing Integration data from Jwt Oauth custom setting.');
            throw new CustomException(null,'error! Missing Integration data from Jwt OAuth Custom setting','APIJwtOAuthUtility');
         }
     	 integrationUserId=intUserId;
     	 integrationName=null;
   }*/

   public APIJwtOAuthUtility (String calloutName){
   //	 setOauthSetting(intUser);
   	// integrationUser= [SELECT Id FROM User WHERE Name =:intUser limit 1];// 'Integration GFRA'
   	     system.debug('calloutName:;;'+calloutName);
   	     oAuthCustomSetting2=customSettingInstance.getJWTOAuthSettingCallOut(calloutName);//retrieve the JWTOauthSetting from custom setting
   	    
         system.debug('oauthcustom Setting 2:'+oAuthCustomSetting2);
         if(OAuthCustomSetting2!=null){
     	 	password=OAuthCustomSetting2.Password__c;
     	 	username=OAuthCustomSetting2.UserName__c;
     	 	tokenEndpoint=OAuthCustomSetting2.End_Point__c;
     	 	certificate=OAuthCustomSetting2.Certificate__c;
     	 	clientId=OAuthCustomSetting2.Client_Id__c;
     	 	clientSecret=OAuthCustomSetting2.Client_Secret__c;
         }else{
            system.debug('Missing Integration data from Jwt Oauth custom setting.');
            throw new CustomException(null,'error! Missing Integration data from Jwt OAuth Custom setting','APIJwtOAuthUtility');
         }
     	 integrationUserId=null;
     	 integrationName=calloutName;
   }
  
	public String getAccessToken(){
      DTOJwtTokenResponse token =new DTOJwtTokenResponse();

      try{
        
        if(isTokenExpired()){
        	system.debug('token expired');
      	 //	accessToken=InvokeTokenService();
      	  token=InvokeTokenService();
     	 if(token!=null && (token.error==null || token.error=='')){
      	 	accessToken=token.jwt_token;
      	 	lastTokenUpdateDateTime=DateTime.now();
      	 	updateTokenSetting=true;
      	 }else{
      	 	system.debug('error from retireving JWT token:'+token.error);
      	 //	return null;
      	    throw new CustomException(null,'Error! '+token.error,'APIJwtOAuthUtility');
      	 }
       	}else{
       		accesstoken=getAccessFrCustomSetting();//heronOauth.JWT_Token__c+heronOauth.JWT_Token2__c+heronOauth.JWT_Token3__c+heronOauth.JWT_Token4__c+heronOauth.JWT_Token5__c;
            
         /*   if(OAuthCustomSetting.JWT_Token__c!=null){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token__c;
            }
            if(OAuthCustomSetting.JWT_Token2__c!=null && OAuthCustomSetting.JWT_Token2__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token2__c;
            }
            if(OAuthCustomSetting.JWT_Token3__c!=null && OAuthCustomSetting.JWT_Token3__c!='' ){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token3__c;
            }
            if(OAuthCustomSetting.JWT_Token4__c!=null && OAuthCustomSetting.JWT_Token4__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token4__c;
            }
            if(OAuthCustomSetting.JWT_Token5__c!=null && OAuthCustomSetting.JWT_Token5__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token5__c;
            }
            if(OAuthCustomSetting.JWT_Token6__c!=null && OAuthCustomSetting.JWT_Token6__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token6__c;
            	
            }
             if(OAuthCustomSetting.JWT_Token7__c!=null && oAuthCustomSetting.JWT_Token7__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting.JWT_Token7__c;
            	
            }*/
            system.debug('get token from custom setting: '+accesstoken);
       	}

       } catch (Exception e){
         	system.debug('Get Access Token Exception:'+e);
        // 	throw new CustomException(e, 'Retrieve Token Exception !', 'APIJwtOAuthUtility');
         //	return null;
       }
        return accesstoken;
	}

    // @TestVisible    
    public  boolean isTokenExpired(){
        if (OAuthCustomSetting2== null || OAuthCustomSetting2.Last_Updated_Date_Time__c== null ||  OAuthCustomSetting2.duration__c == null) {
           system.debug(' token expired!!!!');
            return true;
        }
        Datetime nowTime = DateTime.now();
        decimal minDuration = ((nowTime.getTime()/1000/60) - (OAuthCustomSetting2.Last_Updated_Date_Time__c).getTime()/1000/60);   
        system.debug('minDuration:::'+minDuration);
        return (minDuration >= OAuthCustomSetting2.duration__c);// if great than the during in custom setting
    }


    public String getAccessFrCustomSetting(){
    	String accesstoken='';
    	
    	 if(OAuthCustomSetting2.JWT_Token__c!=null){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token__c;
             System.debug('accesstoken1'+accesstoken);
            }
            if(OAuthCustomSetting2.JWT_Token2__c!=null && OAuthCustomSetting2.JWT_Token2__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token2__c;
                System.debug('accesstoken2'+OAuthCustomSetting2.JWT_Token2__c);
            }
            if(OAuthCustomSetting2.JWT_Token3__c!=null && OAuthCustomSetting2.JWT_Token3__c!='' ){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token3__c;
                System.debug('accesstoken3'+OAuthCustomSetting2.JWT_Token3__c);
            }
            if(OAuthCustomSetting2.JWT_Token4__c!=null && OAuthCustomSetting2.JWT_Token4__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token4__c;
                System.debug('accesstoken4'+OAuthCustomSetting2.JWT_Token4__c);
            }
            if(OAuthCustomSetting2.JWT_Token5__c!=null && OAuthCustomSetting2.JWT_Token5__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token5__c;
                System.debug('accesstoken5'+OAuthCustomSetting2.JWT_Token5__c);
            }
            if(OAuthCustomSetting2.JWT_Token6__c!=null && OAuthCustomSetting2.JWT_Token6__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token6__c;
                System.debug('accesstoken6'+OAuthCustomSetting2.JWT_Token6__c);
            	
            }
             if(OAuthCustomSetting2.JWT_Token7__c!=null && oAuthCustomSetting2.JWT_Token7__c!=''){
              accesstoken=accesstoken+OAuthCustomSetting2.JWT_Token7__c;
                 System.debug('accesstoken1234567'+accesstoken);
            	
            }
            return accesstoken;
    }
	
	/**
	**
	*/
	private DTOJwtTokenResponse InvokeTokenService(){

        String jwtToken=null;
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req=new HttpRequest(); 
        DTOJwtTokenResponse token=new DTOJwtTokenResponse();
         try{
            
           // system.debug('client Id: -->'+clientId+'<---  clientSecret:::-->'+clientSecret+'<---- certificate:::'+certificate);
           
            req.setEndpoint(tokenEndpoint);
            req.setMethod('POST');
        
            req.setCompressed(false);
            req.setHeader('Accept','application/json');
            req.setheader('Content-Type','application/json');
            req.setHeader('ClientSecret',clientSecret);//'7681dBc2867e4b9aBf3621a72F9967E2');
            req.setHeader('ClientId',clientId);//'5c22ab6f60d8474abd0bae13cbdb1c38');// 'a947eb37f9664ff4acf6af4945a9f3eb');
            req.setClientCertificateName(certificate);//certificate);
       
            system.debug('clientId:'+req.getHeader('ClientId')+' clientSecret: '+req.getHeader('ClientSecret') );
         //   String tokenRequest='{"username":"'+userName+'", "password":"'+password+'"}';//'{"username":"ESB.BUSACQ.HERONSVC", "password":"mU8AfRaj"}';
        
            String tokenRequest='{"username":"'+username+'", "password":"'+password+'"}';//'{"username":"ESB.BUSACQ.HERONSVC", "password":"mU8AfRaj"}';

            req.setbody(tokenRequest);
        
            system.debug(' token servcie request body: '+req.getBody());

            /**JWT token Example Output In Jason**
            **{
                   "username": "ESB.BUSACQ.HERONSVC",
                   "access_token": "0b38c083-b869-4a37-af4f-4006cf98912b",
                   "token_type": "Bearer",
                   "expires_in": 3600,
                   "refresh_token": "1a5c0c70-f07a-4cef-baf2-88feb9321662",
                   "scope": "oob",
                   "jwt_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.ew0KICAic3ViIjogIkVTQi5CVVNBQ1EuSEVST05TVkMiLA0KICAiYXpwIjogIkVOcVc5R2xURlhpQ1E5OUlRbEh6UXVUclFzYmVDV0xnIiwNCiAgImlzcyI6ICJodHRwczovL2VhYXN0cy5kZXYuZnlpYmx1ZS5jb206ODQ0My9jb25uZWN0IiwNCiAgImlhdCI6IDE1MTA3MjI0MDYsDQogICJleHAiOiAxNTEwODA4ODA2LA0KICAiaGNzY19wcml2YXRlX2NsYWltcyI6IA0KICB7DQogICAgICAicGVybWlzc2lvbnMiOiAiY249SEVST05fU0VSVklDRV9BQ0NFU1Msb3U9QnVzaW5lc3MgQWNxdWlzaXRpb25-QU1BLTEsb3U9QXV0aG9yaXRpZXMsb3U9RnJhbWV3b3JrLG91PVNFUlZJQ0VTLG89RVhUTERBUCINCiAgfQ0KfQ.QgqAWuHU60U5chnjzuaxtH8Rzi0DR7eCxBB-dNMcCDZ2GGHu-jaJMo4KRovrQjgl59-763XK1n2nm9hhqiF79wmJr0lN62GoHZggXOqlNNASmMrwCRElGnplBs5dHDSmopj10PkCpez3CxMnVFAo4uvwE7DLug1n_ARXJEHFRB9UfHjTzSOaM_db1RjOml4ddAhAvPv0FrAg9xFChRy5sHU65eoGexenRxPgpus5jjlb6CZ4X3DhhqJPTt1NciGYa9t1pEKrYNN0-8R7f-Qx7n2UqccvfIAsfSZNMswUk9dfIGLPrbkwVVNj3htU8HwwqaXwLlGzoyix5iLxQ8VGgg"
               }
               
               
            */
           
            res =http.send(req) ;//InvokeService(req);
            system.debug('token service response:'+res);
           
            if(res!=null){
            	
              system.debug('res.getStatusCode():::::'+res.getStatusCode());
              
              String jsonStr = res.getBody();
              system.debug(LoggingLevel.INFO,'Token Response: '+jsonStr);
              token=(DTOJwtTokenResponse) System.JSON.deserialize(jsonStr,DTOJwtTokenResponse.class);
           }

		 }catch(Exception e){
		 	system.debug('Invoke Token service exception: '+e);
			token.error='JWT Token Exception:'+e.getMessage();
         }
		//return jwtToken;
		return token;
	}

 public void updateToken(String newAccessToken){
 	try{
 		system.debug('newAccessToken to update: '+newAccessToken);
 		
 		if(newAccessToken!=null){
              
           if(integrationName!=null){
           	   
           	   list<OAuth_Jwt_Token2__c> updateOauth2=[select id, name, JWT_Token__c, JWT_Token2__c,JWT_Token3__c, JWT_Token4__c, JWT_Token5__c, JWT_Token6__c, JWT_Token7__c, Last_Updated_Date_Time__c from OAuth_Jwt_Token2__c where name=:integrationName]; 
           	  
           	   system.debug('update accessToken to OAuthCustomSetting2.'+updateOauth2);
           	   
           	   if(updateOauth2!=null && !updateOauth2.isEmpty()){
           	  		integer len=newAccessToken.length();
 		  	  		integer size=255;
 		            
 		      
 		       		//clearPreviouToken
 		            system.debug('jwt tokenRecord:: Id'+ updateOauth2[0].id);
 		            updateOauth2[0].JWT_Token__c=null;
 					updateOauth2[0].JWT_Token2__c=null;
 					updateOauth2[0].JWT_Token3__c=null;
 					updateOauth2[0].JWT_Token4__c=null;
 					updateOauth2[0].JWT_Token5__c=null;
 					updateOauth2[0].JWT_Token6__c=null;
 					updateOauth2[0].JWT_Token7__c=null;
 					
      	  		   updateOauth2[0].JWT_Token__c = newAccessToken.left(255);
                   system.debug('updateOauth2[0].JWT_Token__c.'+updateOauth2[0].JWT_Token__c);
 		  	       if(len>size){
      	    				updateOauth2[0].JWT_Token2__c= newAccessToken.remove(updateOauth2[0].JWT_Token__c).left(255);
                             system.debug('updateOauth2[0].JWT_Token2__c.'+updateOauth2[0].JWT_Token2__c);
 		 				 }
 		  				if(len>2*size){
      	    				updateOauth2[0].JWT_Token3__c = newAccessToken.remove(updateOauth2[0].JWT_Token__c + updateOauth2[0].JWT_Token2__c).left(255);
 		  				}
 		  				if(len>3*size){
      	   					updateOauth2[0].JWT_Token4__c = newAccessToken.remove(updateOauth2[0].JWT_Token__c + updateOauth2[0].JWT_Token2__c+ updateOauth2[0].JWT_Token3__c).left(255);
 		  				}
 		  				if(len>4*size){
            				updateOauth2[0].JWT_Token5__c = newAccessToken.remove(updateOauth2[0].JWT_Token__c + updateOauth2[0].JWT_Token2__c+ updateOauth2[0].JWT_Token3__c + updateOauth2[0].JWT_Token4__c ).left(255);
 		  				}
 		  				if(len>5*size){
           					updateOauth2[0].JWT_Token6__c = newAccessToken.remove(updateOauth2[0].JWT_Token__c + updateOauth2[0].JWT_Token2__c+ updateOauth2[0].JWT_Token3__c + updateOauth2[0].JWT_Token4__c + updateOauth2[0].JWT_Token5__c).left(255);
 		  				}
 		  				if(len>6*size &&  len<=7*size){
            			    updateOauth2[0].JWT_Token7__c = newAccessToken.remove(updateOauth2[0].JWT_Token__c + updateOauth2[0].JWT_Token2__c+ updateOauth2[0].JWT_Token3__c + updateOauth2[0].JWT_Token4__c + updateOauth2[0].JWT_Token5__c + updateOauth2[0].JWT_Token6__c).left(255);
 		  				}
         				updateOauth2[0].Last_Updated_Date_Time__c=system.now();
         
         				system.debug('JWT_Token__c 1:'+updateOauth2[0].JWT_Token__c+'JWT_Token__c 4:'+updateOauth2[0].JWT_Token4__c+' JWT_Token7__c: '+updateOauth2[0].JWT_Token7__c);
         
         				update updateOauth2[0];    
           }
           }
 		}                        	
 		
 	}catch (System.DmlException dmle){
         system.debug('update JWT Token to custom setting exception:  '+dmle+' line '+dmle.getLineNumber());
     }catch(Exception e){
         system.debug('exception from update token into custom setting: '+e+' line: '+e.getLineNumber());
      }
	
 }
 

	/*
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
   */
    /*
    private static HttpResponse InvokeService(HttpRequest req){
        
        HttpResponse response=new HttpResponse();
        Http http = new Http();
        
        try{
        
         //Try to call the service.        
          response = http.send(req);
          
          system.debug('service response: '+response);
        }catch (Exception e){
            system.debug('invokeService exception: '+e);
        }
        
        return response;
    }*/
   
}