global with sharing class DTOHeronAssociationData {
	global String associationName{get;set;}
	global String associationProduct {get;set;}
	global String runType {get;set;}
	global Date effectiveDate {get;set;}
	global Date endDate {get;set;}
	global integer projectedEnrollment {get;set;}
	global integer projectedEnrollmentSingle {get;set;}
	global integer projectedEnrollmentFamily{get;set;}
	global String accessFeeType {get;set;}
	global String aslFeeType{get;set;}
	global decimal aslAttachment{get;set;} //Aggregate Stop Loss Level
	global decimal islAttachment {get;set;} //Individual Stop Loss Level
	global String proposedRxFormulary {get;set;}
	global String proposedRxNetwork {get;set;}
	global String proposedRxPricing {get;set;}
	global DTOHeronPerCapitaData HeronPerCapitaData {get;set;}
	global DTOHeronPremiumData HeronPremiumData {get;set;}

	public DTOHeronAssociationData (){}
    
}