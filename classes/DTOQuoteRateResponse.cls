/**
*** this first response capture the 2nd callout response from Heon in jSon format
**/

global with sharing class DTOQuoteRateResponse {
	
	//HeronCustomerData
   global String customerName {get;set;}
   global String blueStarAccountNumber{get;set;}
   global String corpEntCd{get;set;}
   global String salesforceQuoteRequestId {get;set;}
   global DTOHeronOpportunityData heronOpportunityData {get;set;}
   
   global DTOQuoteRateResponse(){}
  
}