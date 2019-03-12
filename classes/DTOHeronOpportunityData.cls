global with sharing class DTOHeronOpportunityData {
   global long opportunityId{get;set;}
   global String opportunityName{get;set;}
   global String underwriterId{get;set;}
   global String underwriterName{get;set;}
   global String coverageType{get;set;} //either M- medical or D-dental
   global String businessType{get;set;}
   global String ratingMethod{get;set;}
   global String funding{get;set;}
   global String versionStatus{get;set;}
   global String singleFamilyInd{get;set;}
   global String adminFeeType {get;set;}
   global list<DTOHeronAssociationData> HeronAssociationData {get;set;}
   
   public DTOHeronOpportunityData(){}
    
}