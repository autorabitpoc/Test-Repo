global with sharing class DTOHeronRates {
   global decimal ilAccessFee {get;set;}
   global decimal hcscAccessFeesPct {get;set;}
   global decimal nonHcscAccessFeesPct {get;set;}
   global decimal nonStdSvcOneTimeCharge {get;set;}
   global decimal commission{get;set;}
   global decimal allocatedTaxesAndFeePcpm {get;set;}
   global decimal physicianServiceFeeSingle{get;set;}
   global decimal physicianServiceFeeFamily{get;set;}
   global decimal hMOManagedCareFee{get;set;}
  // global decimal ilAverageDiscountPercent{get;set;}
   global decimal aHPFee {get;set;}
   global decimal sharedSavingsPct{get;set;}
   global decimal sharedSavingsPctInNetwork{get;set;}
   global decimal sharedSavingsPctOutNetwork{get;set;}
   global decimal annualAggregateCap{get;set;}
   global decimal claimLevelCap{get;set;}
   global decimal guaranteeDiscountPercent{get;set;}
   global decimal totalFixedCost{get;set;}
   global decimal blueCareConnection {get;set;}
   
   public DTOHeronRates(){}
}