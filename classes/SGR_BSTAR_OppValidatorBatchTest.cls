/**************************************************************************************
  Apex Class Name     : SGR_BSTAR_OppValidatorBatchTest  
  Version             			: 1.0
  Function            		: Test class for SGR_BSTAR_OppValidatorBatch
  Modification Log    	:
* Developer: Shankar  Date: 12/20/2018                   Initial version
* ----------------------------------------------------------------------------               
* Shankar                  09/05/2018                Original Version
*************************************************************************************/
@isTest (seeAllData = false)
public class  SGR_BSTAR_OppValidatorBatchTest {
	@testSetup 
	public static void setupData() {
		Account a = new Account(Name = 'Test Account', hold_end_date__c = date.today().addMonths(-3), HCSC_Division__c='IL', Market_Segment__c='SG', Funding_Type__c='PREM', Renewal_Date__c = date.Today(), Product_Type__c='H', AccountNumber = '12345');
		insert a;
		
		Id sgrProdOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = a.id;
        opp.Name = 'Sample Opp';
        opp.HCSC_Division__c = 'IL';
        opp.Funding_Type__c = 'PREM';
        opp.Account_Market_Segment__c ='SG';
        opp.StageName = 'Triggered';
        opp.Renewal_Date__c = System.today().addDays(4);
        opp.CloseDate = System.today().addMonths(1);
        opp.RecordTypeId = sgrProdOppRecTypeId;
        opp.Rating_Status__c = 'Sold';
        oplist.add(opp);        
        insert oplist;
        
        
        SGRRenewalBatch__c b = new SGRRenewalBatch__c(Division__c='IL', MarketSegment__c='SG', FundingType__c='PREM', Account_Number__c = a.AccountNumber, Scheduled_Date__c = System.now().addMinutes(2));
		insert b;
		
		SGR_Business_Rule__c rule1 = new SGR_Business_Rule__c();
		rule1.Proposed_wording_fail__c = 'Validation failed';
		rule1.Proposed_wording_pass__c ='Validation passed';
		rule1.Rule_Code__c ='PR.DP.09.c' ;
		insert rule1;
        
	}
	
	@isTest
	public static void testValidatorBatch() {
		Opportunity opp = [Select Id from Opportunity LIMIT 1][0];
		SGRRenewalBatch__c bRec = [Select Id from SGRRenewalBatch__c LIMIT 1][0];
		Set<Id> oppIds = new Set<Id>();
		oppIds.add(opp.Id);
		SGR_BSTAR_OppValidatorBatch b = new SGR_BSTAR_OppValidatorBatch(oppIds, bRec.Id);
		Test.startTest();
			Database.executeBatch(b);
		Test.stopTest();
	}
    
}