/**************************************************************************************
  Apex Class Name     : BatchWeeklyMissedOpportunityCheckTest
  Version             : 1.0
  Function            : This is a test class for BatchWeeklyMissedOpportunityCheck.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				6/7/2016
*************************************************************************************/
@isTest(SeeAllData=False)
public class BatchWeeklyMissedOpportunityCheckTest{
	public static String CRON_EXP = '0 0 0 1 1 ? 2022';
	
	@testSetup static void setupRecords(){
		Account testAcc = TestClassUtiltity.CreateAccountRecord('Test Account');	
	}

	@isTest static void createOpportunityCheckBatchTest(){
		Account accRecord = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
		Opportunity testOpp = TestClassUtiltity.CreateOpportunities(accRecord.Id)[0];
		testOpp.StageName = 'Expected In';
		testOpp.Expected_RFP_Release_Date__c = System.Today();
        testOpp.Non_Admin_Last_Modified_Date__c = System.today();
		testOpp.Missed_Last_Week__c = True;
		insert testOpp;
		testOpp = [SELECT Id, LastModifiedDate FROM Opportunity WHERE Id =: testOpp.Id];
		
		Test.startTest();
		Database.executeBatch(new BatchWeeklyMissedOpportunityCheck(), 100);
		Test.stopTest();

		Opportunity updatedTrueOpp = [SELECT Id, Missed_Last_Week__c FROM Opportunity WHERE Id =: testOpp.Id];
		System.assert(updatedTrueOpp.Missed_Last_Week__c == False);
	}


	static testmethod void testScheduledBatchWeeklyMissedOpps() {
		Test.startTest();

		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP,
		                               new BatchWeeklyMissedOpportunityCheck());

		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
		                  NextFireTime
		                  FROM CronTrigger WHERE id = :jobId];

		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		System.assertEquals('2022-01-01 00:00:00', String.valueOf(ct.NextFireTime));

		Test.stopTest();
	}
}