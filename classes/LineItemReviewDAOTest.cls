/**************************************************************************************
  Apex Class Name     : LineItemReviewDAOTest
  Version             : 1.0
  Function            : This is a test class for LineItemReviewDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				6/21/2016
*************************************************************************************/
@isTest(SeeAllData=false)
public class LineItemReviewDAOTest{
	public static LineItemReviewDAO.ILineItemReviewDAO lineItemReviewDAOInstance = new LineItemReviewDAO();
	public static Id pgSMERecordTypeId = Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get(Label.LineItemReviewRecordTypePGSME).getRecordTypeId();

	@testSetup static void setupLineItemPrereqs(){
		Test.startTest();
		Account testAcc = TestClassUtiltity.CreateAccountRecord('Test Account');
		Case testCase = new Case(accountId = testAcc.Id);
		insert testCase;
		Test.stopTest();
	}

	@isTest static void insertLineItemReviewsTest(){
		Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
		Case testCase = [SELECT Id FROM Case WHERE AccountId =: testAcc.Id LIMIT 1];
		Line_Item_Review__c testLIR = new Line_Item_Review__c();
		testLIR.Related_Case__c = testCase.Id;
		testLIR.RecordTypeId = pgSMERecordTypeId;
		System.assertEquals([SELECT Id FROM Line_Item_Review__c WHERE Related_Case__c =: testCase.Id].size(), 0);
		lineItemReviewDAOInstance.insertLineItemReviews(new List<Line_Item_Review__c>{testLIR});
		System.assertEquals([SELECT Id FROM Line_Item_Review__c WHERE Related_Case__c =: testCase.Id].size(), 1);
	}

	@isTest static void deleteLineItemReviewsTest(){
		Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
		Case testCase = [SELECT Id FROM Case WHERE AccountId =: testAcc.Id LIMIT 1];
		Line_Item_Review__c testLIR = new Line_Item_Review__c();
		testLIR.Related_Case__c = testCase.Id;
		testLIR.RecordTypeId = pgSMERecordTypeId;
		insert testLIR;
		System.assertEquals([SELECT Id FROM Line_Item_Review__c WHERE Related_Case__c =: testCase.Id].size(), 1);
		lineItemReviewDAOInstance.deleteLineItemReviews(new List<Line_Item_Review__c>{testLIR});
		System.assertEquals([SELECT Id FROM Line_Item_Review__c WHERE Related_Case__c =: testCase.Id].size(), 0);
	}

	@isTest static void getLineItemReviewsUsingCasesTest(){
		Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
		Case testCase = [SELECT Id FROM Case WHERE AccountId =: testAcc.Id LIMIT 1];
		Line_Item_Review__c testLIR = new Line_Item_Review__c();
		testLIR.Related_Case__c = testCase.Id;
		testLIR.RecordTypeId = pgSMERecordTypeId;
		insert testLIR;
		List<Line_Item_Review__c> lineItemReviews = lineItemReviewDAOInstance.getLineItemReviewsUsingCases(new Set<Id>{testCase.Id});
		System.assertEquals(lineItemReviews.size(), 1);
		System.assertEquals(lineItemReviews[0].Id, testLIR.Id);
	}
}