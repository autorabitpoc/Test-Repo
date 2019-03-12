/*************************************************************************************
  Apex Class Name     : BatchCreateCededRenewalCaseTest
  Version             : 1.0
  Function            : Test class for the BatchCreateCededRenewalCase class 
  Modification Log    :
  Developer               Date                     Description
  -----------------------------------------------------------------------------------
  Zachary Campbell    :   November 8 2016          Original Version
*************************************************************************************/
@IsTest(SeeAllData=true)
private class BatchCreateCededRenewalCaseTest{

	public static @IsTest(SeeAllData=true) void batchCreateCededRenewalCaseTest(){
        
        Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType 
                                                             WHERE (SobjectType = 'Account')
                                                             OR    (SobjectType = 'Case')]);
		RecordType groupAccountRecordType;
        RecordType cedeCaseRecordType;
		for (RecordType rt : rtMap.values()){
			if (rt.Name == 'Group Account')
                groupAccountRecordType = rt;
            else if (rt.Name == 'Cede')
				cedeCaseRecordType = rt;
		}

    	List<Account> testAccounts = new List<Account>();
		Account testCedeAccount1 = new Account(Name = 'TestCedeAccount1', RecordTypeId = groupAccountRecordType.Id, 
                                               HCSC_Division__C = 'IL', Status__c = 'Active', External_ID__c = '456789',
                                               Renewal_Date__c = System.today() + 30, Ceded__c = true);

		Account testCedeAccount2 = new Account(Name = 'TestCedeAccount2', RecordTypeId = groupAccountRecordType.Id, 
                                               HCSC_Division__C = 'IL', Status__c = 'Active', External_ID__c = '987654',
                                               Renewal_Date__c = System.today() + 30, Ceded__c = true);
		testAccounts.add(testCedeAccount1);
		testAccounts.add(testCedeAccount2);
		insert testAccounts;
        
        List<Case> testCedeCases = new List<Case>();
        
        Case testCedeCase1 = new Case(AccountId = testCedeAccount1.Id, Subject = 'Cede Test1', 
                                      Status = 'Denied', RecordTypeId = cedeCaseRecordType.Id,
                                      Account_Type__c = 'Renewal', Cede_Effective_Date__c = System.today().addDays(10), 
                                      Cede_End_Date__c = System.today().addDays(365), Ceded_From_ICL__c = 'MA', 
                                      Ceded_To_ACL__c = 'IL');
        
        Case testCedeCase2 = new Case(AccountId = testCedeAccount2.Id, Subject = 'Cede Test2.1', 
                                      Status = 'Approved', RecordTypeId = cedeCaseRecordType.Id, 
                                      Account_Type__c = 'Renewal', Cede_Effective_Date__c = System.today().addDays(10), 
                                      Cede_End_Date__c = System.today().addDays(180), Ceded_From_ICL__c = 'AZ', 
                                      Ceded_To_ACL__c = 'IL', CreatedDate = System.today().addDays(-1));
        
        //This testCedeCase3 should be only one cloned.
		Case testCedeCase3 = new Case(AccountId = testCedeAccount2.Id, Subject = 'Cede Test2.2', 
                                      Status = 'Approved', RecordTypeId = cedeCaseRecordType.Id, 
                                      Account_Type__c = 'Renewal', Cede_Effective_Date__c = System.today().addDays(10), 
                                      Cede_End_Date__c = System.today().addDays(180), Ceded_From_ICL__c = 'IL', 
                                      Ceded_To_ACL__c = 'IL');
        
        testCedeCases.add(testCedeCase1);
        testCedeCases.add(testCedeCase2);
        testCedeCases.add(testCedeCase3);
        Insert testCedeCases;

		Test.StartTest();
        
        BatchCreateCededRenewalCase CreateCededRenewalCase = new BatchCreateCededRenewalCase();
		CreateCededRenewalCase.query = 'SELECT Id FROM Account WHERE Status__c = \'Active\' AND External_id__c != null AND Ceded__c = true';
		ID batchprocessid = Database.executeBatch(CreateCededRenewalCase);
        
		Test.StopTest();
        
		System.assertEquals([SELECT Id FROM Case WHERE AccountId = : testCedeAccount1.Id].size(),1);
		System.assertEquals([SELECT Id FROM Case WHERE AccountId = : testCedeAccount2.Id].size(),3);
        System.assertEquals([SELECT Id FROM Case WHERE Ceded_From_ICL__c = : 'IL'].size(),2);
	}
}