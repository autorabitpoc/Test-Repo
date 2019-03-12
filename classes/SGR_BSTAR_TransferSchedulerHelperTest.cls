/**************************************************************************************
  Apex Class Name     : SGR_BSTAR_TransferSchedulerHelperTest     
  Version             			: 1.0
  Function            		: Test class for SGR_BSTAR_TransferSchedulerHelper
  Modification Log    	:
* Developer: Shankar  Date:  01/01/2019                    Initial version
* ----------------------------------------------------------------------------               
* Shankar                  01/01/2019                Original Version
*************************************************************************************/
@isTest (seeAllData = false)
public class SGR_BSTAR_TransferSchedulerHelperTest {
	
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
	}
	
	@isTest
	public static void testScheduler() {
        Date renDate = System.today().addDays(4);
		SGR_BSTAR_TransferSchedulerHelper h = new SGR_BSTAR_TransferSchedulerHelper();
		SGRRenewalBatch__c batchRec = [Select Id, Scheduled_Date__c, Division__c, MarketSegment__c, FundingType__c from SGRRenewalBatch__c LIMIT 1][0];
		System.assert(null != batchRec);
		//h.scheduleJobs(batchRec.Id,  batchRec.Division__c, batchRec.FundingType__c, batchRec.MarketSegment__c, System.today().month(), System.today().year(), batchRec.Scheduled_Date__c);
		h.scheduleJobs(batchRec.Id,  batchRec.Division__c, batchRec.FundingType__c, batchRec.MarketSegment__c, renDate, batchRec.Scheduled_Date__c);
		List<SGR_Renewal_Batch_Oppty__c> batchOpptys = [Select Id from SGR_Renewal_Batch_Oppty__c];
		//System.assertEquals(1, batchOpptys.size());
	}
    
}