@isTest
public class SGR_BRValidationCaseMgrTest {
    
    @isTest static void testCasesManager(){
        List<Opportunity> opp = new List<Opportunity>();
         final Map<String,SGR_BRValidationCaseService> strategies;
         List<String> strategyNames = new List<String>();
		strategyNames.add('SGR_BRValidationFalloutCaseForUW');
        Test.startTest();
        SGR_BRValidationCaseManager sr = new SGR_BRValidationCaseManager('SGR_BRValidationFalloutCaseForUW');
        sr.createCases(opp);
        test.stopTest();
        
    }
    
  /*  @isTest static void testCasesManager2(){
        
         final Map<String,SGR_BRValidationCaseService> strategies;
         List<String> strategyNames = new List<String>();
		strategyNames.add('SGR');
        Test.startTest();
        SGR_BRValidationCaseManager sr = new SGR_BRValidationCaseManager('SGR');
        
        test.stopTest();
        
    }*/
}