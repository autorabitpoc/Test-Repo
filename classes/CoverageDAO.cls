public class CoverageDAO implements ICoverageDAO { 

	public Interface ICoverageDAO{
		List<Coverage__c> getCoveragesForBAs(Set<Id> blueSTARBAs);
	}

	public List<Coverage__c> getCoveragesForBAs(Set<Id> blueSTARBAs) {
		return [SELECT Type__c, Benefit_Agreement__c FROM Coverage__c WHERE Benefit_Agreement__c IN :blueSTARBAs];
	}
}