public with sharing class Prototype_OpportunityModel {
	public Prototype_OpportunityModel() {
		
	}

	public Opportunity currentOpportunity { get; set; }
    public List<SGR_Opportunity_Benefit_Agreement__c> benefitAggrementList {get; set;}
    public List<SGR_Opportunity_Census__c> censusList {get; set;}
    public List<SGR_Opportunity_Group_Section__c> groupSectionList {get; set;}
    public List<SGR_Opportunity_Member_Benefits__c> memberBenefitList {get; set;}
        
    /* properties to store pre-computed values */
    public Boolean HasActiveBenefitAgreement {get; set;}
    public Boolean IsCountyCodeMissing {get; set; }
    public Boolean IsZipcodeValid {get; set; }
        
    /*
		oppty: Opportunity
		opptyBA: Opportunity BA related List
		opptyCensus: Opportunity Census Related List
        opptyGroupSection: Opportunity Group Section Related List
		opptyMemberBenefit: Opportunity Member Benefit Related List
	*/   
    public Prototype_OpportunityModel(Opportunity oppty, 
                                List<SGR_Opportunity_Benefit_Agreement__c> opptyBA,
                                List<SGR_Opportunity_Census__c> opptyCensus, 
                                List<SGR_Opportunity_Group_Section__c> opptyGroupSection,
                                List<SGR_Opportunity_Member_Benefits__c> opptyMemberBenefit) {
                                    
        this.benefitAggrementList = opptyBA;
        this.censusList = opptyCensus;
        this.groupSectionList = opptyGroupSection;
        this.memberBenefitList = opptyMemberBenefit;
            
        computeHasActiveBenefitAggrement();
		computeIsCountryCodeMissing();
    }
        
    private void computeHasActiveBenefitAggrement() {
            Date currentDate = System.now().date();
            
            for(SGR_Opportunity_Group_Section__c gs : groupSectionList) {
                if(gs.Benefit_Agreement_Cancel_Date__c > currentDate) {
                    this.HasActiveBenefitAgreement = true;
                    break;
                }
 
            }
    }
        
    private void computeIsCountryCodeMissing() {
            this.IsCountyCodeMissing = this.currentOpportunity.County_Code__c == null;
    }
        
    private void computeIsZipcodeValid() {
		String zipCode = String.valueOf(currentOpportunity.Zip_Code__c);
        Pattern zipcodePattern = Pattern.compile('^[0-9]{5}([0-9]{4})?$');
        Matcher zipCodeMatcher = zipcodePattern.matcher(zipCode);
       this.IsZipcodeValid = zipCodeMatcher.matches();
    }
    
    private Boolean IsZipcodeValid() {
		String zipCode = String.valueOf(currentOpportunity.Zip_Code__c);
        Pattern zipcodePattern = Pattern.compile('^[0-9]{5}(-[0-9]{4})?$');
        Matcher zipCodeMatcher = zipcodePattern.matcher(zipCode);
        
        return  zipCodeMatcher.matches();
    }
}