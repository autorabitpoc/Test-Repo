global with sharing class DTOHeronPremiumData {
  //  global decimal projectedConventionalEquivalentPremium {get;set;}
  //  global decimal projectedConventionalEquivalentPremiumAtCurrentRates {get;set;}
    global decimal soldPremium {get;set;}
    global decimal initialRequestedPremium{get;set;}
    global decimal finalRequestedPremium{get;set;}
    global string rateTier {get;set;}
    global list<DTOHeronPremiumRates> heronSoldPremiumRates {get;set;}
    global list<DTOHeronPremiumRates> initialRequestedPremiumRates{get;set;}
    global list<DTOHeronPremiumRates> finalRequestedPremiumRates {get;set;}
    
    global DTOHeronPremiumData(){}
}