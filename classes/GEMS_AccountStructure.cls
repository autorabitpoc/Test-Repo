public without sharing class GEMS_AccountStructure {
	
	public list<BenefitAgreement> benefitAgreements {get; set;}
	
	public List<GEMS_Characteristic__c> Characts {get; set;}
    public list<GEMS_Characteristic_Value__c> CharVals {get; set;}
	public List<Integer> NumberOfChars {get; set;}
	
	public list<SelectOption> groupNumbers {get; set;}
	public Integer renderMe{get; set;}	
    
	public class BenefitAgreement{
		public GEMS_Benefit_Agreement__c ba {get; set;}		
		public list<Category> categories {get; set;}
		
		public string groupNumber {get; set;}
	}
	
	public class Category{
		public GEMS_Category__c cat {get; set;}	
		 public list<GEMS_Characteristic_Value__c> catCharValues {get; set;}
		 	
		public GEMS_Group_Section__c groupSection {get; set;}
		public GEMS_Category_Assignment__c catGSAssign {get; set;}
		public GEMS_BA_Assignment__c baGSAssign {get; set;}
		
		public string groupNumber {get; set;}
	}
    
}