@isTest
public class SGR_BengOppFinalTest {
    @testSetup 
    static void setup(){
        Account anAccount1 = Sgr_TestDataUtility.createAcc('TestAccount471');
        Account anAccount2 = Sgr_TestDataUtility.createAcc('TestAccount472');
        
        Opportunity anOpportunity = Sgr_TestDataUtility.createOpty2(String.valueOf(anAccount1.Id),'Initiated');
        Opportunity anOppWithoutRates = Sgr_TestDataUtility.createOpty2(String.valueOf(anAccount2.Id),'Initiated');
    }
    
    @isTest
    static void test1(){
        Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');       
        List<Opportunity> oppList = [select name, id from opportunity where account.name = 'TestAccount471' or account.name = 'TestAccount472'];
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSgr_bng()); 
        SGR_BengOppFinal OppFinalJob = new SGR_BengOppFinal(oppList);
        ID jobId = System.enqueueJob(OppFinalJob);        
        test.stopTest();
    }
    
    
}