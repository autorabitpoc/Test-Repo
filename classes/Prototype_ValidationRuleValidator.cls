public with sharing class Prototype_ValidationRuleValidator {
	List<Prototype_OpportunityModel> opportunityList { get; set; }
	List<SGR_Business_Rule__c> BRList { get; set;}
	Prototype_SGRValidationRuleError ruleError {get; set;}
	public Prototype_ValidationRuleValidator(List<Prototype_OpportunityModel> opptyList) {
		this.opportunityList = opptyList;
		this.ruleError = new Prototype_SGRValidationRuleError();
		this.BRList = GetRules();
	} 

	public void Validate() {
		List<Business_Rule_Validation_Log__c> errorLogs = new List<Business_Rule_Validation_Log__c>();
		for(SGR_Business_Rule__c rule: BRList) {
			/*for(Prototype_OpportunityModel oppty: opportunityList){

				if(rule.Code__c == '')
					errorLogs.add(this.ruleError.RuleGRDV01(oppty, rule));

			}*/
			/*if(rule.Code__c == ''){
				errorLogs.addRange(this.ruleError.RuleGRDV01(opportunityList, rule));
			}*/
		}

		insert errorLogs;
	}

	private List<SGR_Business_Rule__c> GetRules() {

		return new List<SGR_Business_Rule__c>();
	}

	
}