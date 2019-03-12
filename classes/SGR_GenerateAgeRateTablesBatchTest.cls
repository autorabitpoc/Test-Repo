@isTest 
public class SGR_GenerateAgeRateTablesBatchTest
{
    @testSetUp
	static void testData(){
   	
		List<SGR_URE_Age_Rate_Driver__c> lstAgeRateDrivers= new List<SGR_URE_Age_Rate_Driver__c>();
		List<Plan__c> pList = new List<Plan__c>();
        
        for(Integer i=0 ;i <2;i++){
			Plan__c p = new Plan__c();
			p.Marketing_Plan_Number__c = 'Plan00'+i;
			if(i/2==0){
				p.Line_Of_Business__c = 'D';
			}else{
				p.Line_Of_Business__c = 'H';
			}
			pList.add(p);
		}
         insert pList;
        
        for(Integer i=0 ;i <100;i++)
        {
            SGR_URE_Age_Rate_Driver__c driver = new SGR_URE_Age_Rate_Driver__c();
            driver.Name ='Name'+i;
            Id planId = null;
            if (i/2==0) {
                planId = pList.get(0).Id;
            } else {
                planId = pList.get(1).Id;
            }
			driver.SGR_Plan_Id__c =planId;
			driver.FIPS_Code__c ='CC'+i;
			driver.Corporate_Entity_Code__c ='CEC'+i;
			driver.Rate_Effective_Date__c =System.today();
			driver.Market_Segment__c ='SG';
            lstAgeRateDrivers.add(driver);
        }
        		
        insert lstAgeRateDrivers;
		
		
	}
	static testMethod void testGenerateDentalAgeRateTables() 
    {	 
       
        Test.startTest();
            SGR_GenerateAgeRateTablesBatch obj = new SGR_GenerateAgeRateTablesBatch(System.today(),'Dental',1,'RenewalsSalesForce','SG',false);
            Database.executeBatch(obj,200);
        Test.stopTest();
                List<SGR_Plan_Age_Rate_Detail__c> ards = [Select Id from SGR_Plan_Age_Rate_Detail__c];
        System.assertNotEquals(null, ards);
    }
	static testMethod void testGenerateNonDentalAgeRateTables() 
    {	 
        Test.startTest();
            SGR_GenerateAgeRateTablesBatch obj = new SGR_GenerateAgeRateTablesBatch(System.today(),'NonDental',1,'RenewalsSalesForce','SG',false);
            Database.executeBatch(obj,200);
        Test.stopTest();
                List<SGR_Plan_Age_Rate_Detail__c> ards = [Select Id from SGR_Plan_Age_Rate_Detail__c];
        System.assertNotEquals(null, ards);
    } 
}