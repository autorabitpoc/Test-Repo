public with sharing class GEMS_PharmacyScopeCoding {
  
    public boolean isSelected {get; set;}
    public GEMS_Pharmacy_Scope_Code__c scopeCode {get; set;}
    
    public GEMS_PharmacyScopeCoding(boolean isSelected, GEMS_Pharmacy_Scope_Code__c scopeCode){
        this.isSelected = isSelected;
        this.scopeCode = scopeCode;
    }
    
}