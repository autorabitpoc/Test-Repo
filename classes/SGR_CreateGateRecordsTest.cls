@isTest
public class SGR_CreateGateRecordsTest {
    
    @testSetup 
    public static void setup() {
        insert new Division__c(Name = 'TX');
    }
    @isTest
    public static void testGateCreation() {
        Test.StartTest();
        SGR_CreateGateRecords cg = new SGR_CreateGateRecords(null, 'PREM', 'SG');
        cg.execute(null);
        Test.stopTest(); 
        
		List<Actuary_Gate__c> gates = [Select Id, Effective_Date__c from Actuary_Gate__c];
        System.assertNotEquals(0, gates.size()); 
        System.assertEquals(System.today().year()+1, gates[0].Effective_Date__c.year()); 
    }
    
	public static void testGateCreationWithYearParam() {
        Test.StartTest();
        SGR_CreateGateRecords cg = new SGR_CreateGateRecords(2019, 'PREM', 'SG');
        cg.execute(null);
        Test.stopTest(); 
        
        List<Actuary_Gate__c> gates = [Select Id, Effective_Date__c from Actuary_Gate__c];
        System.assertNotEquals(0, gates.size()); 
        System.assertEquals(2019, gates[0].Effective_Date__c.year()); 
    }
    
    @isTest
    public static void testDuplicateGateCreation() {
        Test.StartTest();
        SGR_CreateGateRecords cg = new SGR_CreateGateRecords(2019, 'PREM', 'SG');
        cg.execute(null);
        List<Actuary_Gate__c> gates = [Select Id, Effective_Date__c from Actuary_Gate__c];
        System.assertEquals(12, gates.size());
        cg.execute(null);
        List<Actuary_Gate__c> gates1 = [Select Id, Effective_Date__c from Actuary_Gate__c];
        System.assertEquals(12, gates.size()); // no new gates should have been created       
        Test.stopTest();
    }

}