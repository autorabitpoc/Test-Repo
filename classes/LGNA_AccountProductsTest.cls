/**************************************************************************************
  Apex Class Name     : LGNA_AccountProductsTest
  Version             : 1.0
  Function            : This is a test class for LGNA_AccountProducts.
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  Ranjit Gandhi 		5/4/2018				Initial Version
*************************************************************************************/
@isTest
public class LGNA_AccountProductsTest {

    static testMethod void myUnitTest1() {
       
            test.StartTest();
                         Id CompetitorAccountRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount1 = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId1);

                
        Account GroupAcnt = TestClassUtiltity.CreateAccountRecord('Group Account');
                GroupAcnt.BillingStreet = '123 Main St';
                GroupAcnt.BillingCity= 'AnyCity';
                GroupAcnt.BillingState= 'IL';
                GroupAcnt.BillingPostalCode= '60053-0000';
                GroupAcnt.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                update GroupAcnt;  		
        		
        
        		list<Product2> LstProduct =  TestClassUtiltity.createProducts();
            	insert LstProduct;
        
        		list<Opportunity> OppList =  TestClassUtiltity.CreateOpportunities(GroupAcnt.id);
        		insert OppList;
        		list<Account_Products__c> AccProduct =  TestClassUtiltity.createAccProducts(GroupAcnt.id, LstProduct[0].id);
       			insert AccProduct;
        		list<Opportunity_Product__c> OppProduct =  TestClassUtiltity.createOppProducts(OppList[0].id, LstProduct[0].id);
        		OppProduct[0].Incumbent__c = testCompetitorAccount1.Id;
        		insert OppProduct;
        		
        		Map<String, list<Object>> loadActive=LGNA_AccountProducts.loadInitialAccountProducts(GroupAcnt.id);
        		Map<String, list<Object>> loadHistorical=LGNA_AccountProducts.loadHistoricalAccountProducts(GroupAcnt.id);
        		
        		
        		Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        		 Account testCompetitorAccount = new Account(Name = 'Competitor', RecordTypeId = '01233000000QMOk', 
                                                  Type='Competitor Account',
                                                  Active_Health_Subscribers__c = 15000, Effective_Date__c = system.today().addyears(2));
        		
        		insert testCompetitorAccount;
        		OppProduct[0].Status__c='lost';OppProduct[0].Account__c=testCompetitorAccount.id;OppProduct[0].Incumbent__c = testCompetitorAccount1.Id;
        
        		upsert OppProduct[0];
        		Map<String, list<Object>> loadHistoricalOpp=LGNA_AccountProducts.loadHistoricalOpportunityProducts(GroupAcnt.id);
        
            	
       
    }
}