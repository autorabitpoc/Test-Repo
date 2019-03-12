global with sharing class DTOGFRA_AdjustmentRequest {
	
	global String adjustmentRequestID {get;set;}
	global String accountNumber{get;set;}
	global String barsCustomerNumber{get;set;}
	global String adjustmentType{get;set;}
    global Double adjustmentAmount {get;set;}
    global Date adjustmentProcessedDate {get;set;}
    global Date adjustmentEntryDate {get;set;}
    global String submitterName {get;set;}
    global String submitterEmail {get;set;}
    global String adjustmentRequestTypeIndicator {get;set;}
    global String adjustmentRequestLink {get;set;}
    
    global DTOGFRA_AdjustmentRequest(){}
}