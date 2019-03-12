global with sharing class DTOHeronPerCapitaData {
    global DTOHeronRates soldRates {get;set;}
    global list<DTOHeronRatesByTier> soldRatesByTier{get;set;}
    global DTOHeronRates finalUnderwritingRequestedRates{get;set;}
    global list<DTOHeronRatesByTier> finalUnderwritingRequestedRatesByTier{get;set;}
    global DTOHeronRates initialRequestedRates{get;set;}
    global list<DTOHeronRatesByTier> initialRequestedRatesByTier {get;set;}
    
   global DTOHeronPerCapitaData(){}
    
}