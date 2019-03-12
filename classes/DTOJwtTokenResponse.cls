public with sharing class DTOJwtTokenResponse {
	
    public String username {get;set;}
    public String access_token {get;set;}
    public String token_type {get;set;}
    public Integer expires_in {get;set;}
    public String refresh_token{get;set;}
    public String  scope {get;set;}
    public String jwt_token{get;set;}
    public String error{get;set;}
    
    public DTOJwtTokenResponse (){}
}