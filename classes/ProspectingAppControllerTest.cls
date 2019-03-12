/*****************************************************************************************
* Apex Class Name     : ProspectingAppControllerTest
* Version             : 1.0
* Function            : This is a test class for ProspectingAppController
* Modification Log    :
* Developer				Date		Description
* -----------------------------------------------------------------------------------
* Zachary Campbell		6/09/2017	Unit Testing for ProspectingAppController Class
******************************************************************************************/
@isTest
private class ProspectingAppControllerTest {
    
    static testMethod void validateQueryRecord() {
        
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.Total_Num_of_Potential_Subscribers__c = 100;
        testAcc.Status__c = 'Active';
        testAcc.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='Group_Account' AND SobjectType='Account'].Id;
        insert testAcc;
        
		Test.startTest();
        Account queriedAcc = (Account)ProspectingAppController.queryRecord('Account', testAcc.Id);
        System.assertEquals(testAcc.Id, queriedAcc.Id);
        queriedAcc = (Account)ProspectingAppController.queryRecord('Case', testAcc.Id);
        System.assertEquals(null, queriedAcc);
        test.StopTest();
    }
   
    static testMethod void validateIsLightningProspectingPilots() {
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'User', 'test@user.com');
        system.runAs(testUser) {

        	List<Lightning_Prospecting_Profiles__c> pProfiles = new List<Lightning_Prospecting_Profiles__c>();
			Lightning_Prospecting_Profiles__c pProfiles1 = new Lightning_Prospecting_Profiles__c();            
			pProfiles1.Name = 'System Administrator';       
			pProfiles.add(pProfiles1);
			insert pProfiles;
            
			List<Lightning_Prospecting_Pilot_Names__c> pNames = new List<Lightning_Prospecting_Pilot_Names__c>();
			Lightning_Prospecting_Pilot_Names__c pNames1 = new Lightning_Prospecting_Pilot_Names__c();            
			pNames1.Name = 'testUser';       
			pNames.add(pNames1);
			insert pNames;
            
            Test.startTest();
			boolean found;
            found = ProspectingAppController.isLightningProspecting(found);
            test.StopTest();
            system.assertEquals(true, found);
		}
    }
    
	static testMethod void validateIsLightningProspectingNoPilots() {
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        system.runAs(testUser) {

        	List<Lightning_Prospecting_Profiles__c> pProfiles = new List<Lightning_Prospecting_Profiles__c>();
			Lightning_Prospecting_Profiles__c pProfiles1 = new Lightning_Prospecting_Profiles__c();            
			pProfiles1.Name = 'System Administrator';       
			pProfiles.add(pProfiles1);
			insert pProfiles;
            
            List<Lightning_Prospecting_Pilot_Names__c> pNames = new List<Lightning_Prospecting_Pilot_Names__c>();

            Test.startTest();
			boolean found;
            found = ProspectingAppController.isLightningProspecting(found);
            test.StopTest();
            system.assertEquals(true, found);
		}
    }
}