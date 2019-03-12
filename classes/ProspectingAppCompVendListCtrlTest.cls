@isTest
private class ProspectingAppCompVendListCtrlTest {
	@testSetup
    static void setupData() {
        Account groupAcc = new Account();
        groupAcc.Name = 'Group Account';
        groupAcc.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='Group_Account' LIMIT 1].Id;
        insert groupAcc;
        
        List<Competitor_Relationship__c> compRels = new List<Competitor_Relationship__c>();
        Competitor_Relationship__c compRelOne = new Competitor_Relationship__c();
        compRelOne.Group_Account__c = groupAcc.Id;
        compRelOne.Status__c = 'Active';
        compRels.add(compRelOne);
        Competitor_Relationship__c compRelTwo = new Competitor_Relationship__c();
        compRelTwo.Group_Account__c = groupAcc.Id;
        compRelTwo.Status__c = 'Active';
        compRels.add(compRelTwo);
        insert compRels;
    }
    
    static testMethod void validateQueryAccountCompetitorsAndVendorsList() {
        Account groupAcc = [SELECT Id FROM Account WHERE Name='Group Account'];
        
        List<Competitor_Relationship__c>  compRels = ProspectingAppCompVendListController.queryAccountCompetitorsAndVendorsList(groupAcc);
        System.assertEquals(2, compRels.size());
    }
    
    static testMethod void validateQueryCompetitorInfo() {
        Account groupAcc = [SELECT Id FROM Account WHERE Name='Group Account'];
        
        List<Competitor_Relationship__c> compRels = new List<Competitor_Relationship__c>();
        
        compRels = [SELECT Id, Group_Account__c FROM Competitor_Relationship__c WHERE Group_Account__r.Id = :groupAcc.Id];
        
        for (Competitor_Relationship__c aCompetitor : compRels){
                    Competitor_Relationship__c FunctionReturned = ProspectingAppCompVendListController.getExistingCompetitorDetails(aCompetitor.id);
                    System.assertEquals(aCompetitor.Group_Account__c, groupAcc.Id);
           
        }

        
    }
    
    
}