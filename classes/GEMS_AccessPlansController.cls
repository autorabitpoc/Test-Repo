public class GEMS_AccessPlansController {
    public list<Plan__c> Plans;

    Public list<Plan__c> getPlans(){
            list<Plan__c> Plans = new list<Plan__c>();
            Plans = [SELECT Id, Name FROM Plan__c ORDER BY Product__r.Name LIMIT 1000];
            return Plans;
    }
}