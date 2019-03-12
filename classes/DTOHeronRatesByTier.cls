global with sharing class DTOHeronRatesByTier {
	global decimal administrativeFee {get;set;}
	global decimal drugAdministrativeFee{get;set;}
	global decimal drugRebateCredit{get;set;}
	global decimal islFee{get;set;}
	global decimal aslFee{get;set;}
	global decimal nonStdSvcFee{get;set;}
	global decimal averageClaimValue{get;set;}
    global decimal runOffClaimLiability{get;set;}
    global decimal runOffAdministration{get;set;}
    global string tierClass{get;set;}
    
    public DTOHeronRatesByTier (){}
}