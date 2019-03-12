public without sharing class GEMS_PharmacyScopeCodingHelper {
    
    public list<GEMS_Pharmacy_Scope_Code__c> getPharmacyScopeCodingDetails(id caseId){
        
        list<GEMS_Pharmacy_Scope_Code__c> pharmacyScopeCodes = [SELECT Id, Name, Case__c, Temp__c, Type__c, 
                                                                   Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c        
                                                                        FROM GEMS_Pharmacy_Scope_Code__c
                                                                            WHERE Case__c = : caseId];
        
        return pharmacyScopeCodes ;
    }
    
    public string savePharmacyScopeCodingDetails(){
        return null;
    }
    
}