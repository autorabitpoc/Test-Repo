public with sharing class DTOQuoteRateRTResponse {
    public String statusCode {get;set;}
    public String statusMessage{get;set;}
    public String accessToken{get;set;}
    public String error{get;set;}
    
    public DTOQuoteRateRTResponse(){
       this.error=null;
       this.accessToken=null;
       this.statusMessage=null;
       this.statusCode=null;
    }
}