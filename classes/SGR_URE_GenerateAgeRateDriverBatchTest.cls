@isTest
public class SGR_URE_GenerateAgeRateDriverBatchTest {
    
 	@testSetup 
    public static void dataSetup() {
    	
    	List<SGR_Plan_FIPS_Map__c> planFipsList = new List<SGR_Plan_FIPS_Map__c>();
    	planFipsList.add(new SGR_Plan_FIPS_Map__c (
				Name = '17001-GPSG12BCESILO',
				SGR_Plan_Id__c = 'GPSG12BCESILO' ,
				FIPS_Code__c = '17001',
				Division__c = 'IL',
				Corporate_Entity_Code__c = 'IL1',
				Effective_Date__c = System.today().addYears(-3),
				Market_Segment__c = 'SG',
				Funding_Type__c = 'PREM'    	
    					));
    	planFipsList.add(new SGR_Plan_FIPS_Map__c (
				Name = '17002-GPSG12BCESOKO',
				SGR_Plan_Id__c = 'GPSG12BCESOKO' ,
				FIPS_Code__c = '17002',
				Division__c = 'OK',
				Corporate_Entity_Code__c = 'OK1',
				Effective_Date__c = System.today().addYears(-4),
				Market_Segment__c = 'SG',
				Funding_Type__c = 'PREM'    	
		));
		planFipsList.add(new SGR_Plan_FIPS_Map__c (
				Name = '17002-GPSG12BCESNMO',
				SGR_Plan_Id__c = 'GPSG12BCESNMO' ,
				FIPS_Code__c = '17002',
				Division__c = 'NM',
				Corporate_Entity_Code__c = 'NM1',
				Effective_Date__c = System.today(),
				Market_Segment__c = 'SG',
				Funding_Type__c = 'PREM'    	
		));
		
		insert planFipsList; 
        
        
        List<Division__c> divs = new List<Division__c>();
        divs.add(new Division__c(Name='IL'));
        divs.add(new Division__c(Name='OK'));
        divs.add(new Division__c(Name='NM'));
        divs.add(new Division__c(Name='TX'));
        insert divs; 
    	
    } 
    
    @isTest
    public static void testPlanFipsCreation() {
    	List<Division__c> divs = [Select Id from Division__c]; 
    	List<SGR_Plan_FIPS_Map__c> planFipsList = [Select Id from SGR_Plan_FIPS_Map__c];       
        System.assert(null != divs);
        System.assertEquals(4, divs.size());
    	System.assert(null != planFipsList);
    	System.assertEquals(3, planFipsList.size());
    	
        Test.startTest();
    		SGR_URE_GenerateAgeRateDriverBatch b = new SGR_URE_GenerateAgeRateDriverBatch(Date.today());
    		Database.executeBatch(b);        	
    	Test.stopTest(); 
        
        List<SGR_URE_Age_Rate_Driver__c> ardList = [Select Id,Processing_Status__c from SGR_URE_Age_Rate_Driver__c];
        System.assert(null != ardList);
        //PCM - 01/31/19 - Commenting Out because failing test classes 
		System.assertEquals(1, ardList.size());
		System.assertEquals('Ready', ardList[0].Processing_Status__c);
    }   
}