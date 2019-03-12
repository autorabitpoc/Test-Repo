@isTest 
private class SGR_OppPlanRateSummary_Controller_test {
    
    @testSetup static void setup() {   
        
        Account anAccount1 = Sgr_TestDataUtility.createAcc('TestAccount1');
        Account anAccount2 = Sgr_TestDataUtility.createAcc('TestAccount2');
        
        Opportunity anOpportunity = Sgr_TestDataUtility.createOpty2(String.valueOf(anAccount1.Id),'Initiated');
        Opportunity anOppWithoutRates = Sgr_TestDataUtility.createOpty2(String.valueOf(anAccount2.Id),'Initiated');
        
        SGR_Opportunity_Benefit_Agreement__c anOppBeneAgreement = Sgr_TestDataUtility.createOptyBenAgr(anOpportunity.Id);
        anOppBeneAgreement.Include_BA__c = true;
        insert anOppBeneAgreement;        
        
        List<Plan__c> listPlans = new List<Plan__c>();
        
        for (Integer i = 0 ; i < 5; i++) {
            Plan__c aPlan = new Plan__c();
            aPlan.Name = 'Test Health Plan' + String.valueOf(i);
            aPlan.Line_Of_Business__c = 'H';        
            listPlans.add(aPlan);        
        }        
        
        for (Integer i = 0 ; i < 5; i++) {
            Plan__c aPlan = new Plan__c();
            aPlan.Name = 'Test Vision Plan' + String.valueOf(i);
            aPlan.Line_Of_Business__c = 'V';        
            listPlans.add(aPlan);        
        }        
        
        for (Integer i = 0 ; i < 5; i++) {
            Plan__c aPlan = new Plan__c();
            aPlan.Name = 'Test Dental Plan' + String.valueOf(i);
            aPlan.Line_Of_Business__c = 'D';        
            listPlans.add(aPlan);        
        }       
        
        insert listPlans;   
        
        List<Plan__c> listHealthPlans = new List<Plan__c>();
        List<Plan__c> listVisionPlans = new List<Plan__c>();
        List<Plan__c> listDentalPlans = new List<Plan__c>();
        
        listHealthPlans = [SELECT Id, Name, Line_Of_Business__c FROM Plan__c WHERE Line_Of_Business__c = 'H']; 
        System.debug('listHealthPlans: ' + listHealthPlans.size());
        listVisionPlans = [SELECT Id, Name, Line_Of_Business__c FROM Plan__c WHERE Line_Of_Business__c = 'V']; 
        System.debug('listVisionPlans: ' + listVisionPlans.size());
        listDentalPlans = [SELECT Id, Name, Line_Of_Business__c FROM Plan__c WHERE Line_Of_Business__c = 'D']; 
        System.debug('listDentalPlans: ' + listDentalPlans.size());
                
        List<SGR_Opportunity_Plan_Rate__c> listOpportunityPlanRates = new List<SGR_Opportunity_Plan_Rate__c>();
        
        for (Integer i = 0 ; i < 5; i++) {
            SGR_Opportunity_Plan_Rate__c aRate = new SGR_Opportunity_Plan_Rate__c();
            aRate.Name = 'TestHealthRate' + String.valueOf(i);
            aRate.Plan_Name__c = 'Health' + String.valueOf(i);  //Health1, Health2, etc.
            aRate.Type__c = 'Renewal';
            aRate.Opportunity__c = anOpportunity.Id;
            //aRate.Coverage_Type__c = 'H';
            if(i == 1){
                aRate.Rate_Type_Code__c = 'STN';                
            }else{
                aRate.Rate_Type_Code__c = 'AGE';                
            }            
            aRate.Opportunity_Benefit_Agreement__c = anOppBeneAgreement.Id;
            aRate.Enrolled_Subscriber_Count__c = 1;
            aRate.Enrolled_Member_Count__c = 2;
            aRate.Current_Comp_Total_Monthly_Premium__c = 1.00;
            aRate.Renw_Comp_Total_Monthly_Premium__c = 2.00;
            aRate.Current_Comp_Total_Est_Tax_and_Fees__c = 3.00;
            aRate.Renw_Comp_Total_Est_Tax_and_Fees__c = 4.00;
            aRate.Current_Age_Total_Monthly_Premium__c = 5.00;
            aRate.Renw_Age_Total_Monthly_Premium__c = 6.00;
            aRate.Current_Age_Total_Est_Tax_and_Fees__c = 7.00;
            aRate.Renw_Age_Total_Est_Tax_and_Fees__c = 8.00;
            if(listHealthPlans.size() == 5){
                aRate.Plan__c = listHealthPlans[i].Id;                
            }            
            listOpportunityPlanRates.add(aRate);            
        }       
        
        for (Integer i = 0 ; i < 5; i++) {
            SGR_Opportunity_Plan_Rate__c aRate = new SGR_Opportunity_Plan_Rate__c();
            aRate.Name = 'TestDentalRate' + String.valueOf(i);
            aRate.Plan_Name__c = 'Dental' + String.valueOf(i); //Dental1, Dental2, etc.
            aRate.Type__c = 'Renewal';
            aRate.Opportunity__c = anOpportunity.Id;
            //aRate.Coverage_Type__c = 'D';
            aRate.Rate_Type_Code__c = 'AGE';    
            aRate.Opportunity_Benefit_Agreement__c = anOppBeneAgreement.Id;
            aRate.Enrolled_Subscriber_Count__c = 1;
            aRate.Enrolled_Member_Count__c = 2;
            aRate.Current_Comp_Total_Monthly_Premium__c = 1.00;
            aRate.Renw_Comp_Total_Monthly_Premium__c = 2.00;
            aRate.Current_Comp_Total_Est_Tax_and_Fees__c = 3.00;
            aRate.Renw_Comp_Total_Est_Tax_and_Fees__c = 4.00;
            aRate.Current_Age_Total_Monthly_Premium__c = 5.00;
            aRate.Renw_Age_Total_Monthly_Premium__c = 6.00;
            aRate.Current_Age_Total_Est_Tax_and_Fees__c = 7.00;
            aRate.Renw_Age_Total_Est_Tax_and_Fees__c = 8.00;
            if(listDentalPlans.size() == 5){
                aRate.Plan__c = listDentalPlans[i].Id;                
            }            
            listOpportunityPlanRates.add(aRate);            
        }       
        
        for (Integer i = 0 ; i < 5; i++) {
            SGR_Opportunity_Plan_Rate__c aRate = new SGR_Opportunity_Plan_Rate__c();
            aRate.Name = 'TestVisionRate' + String.valueOf(i);
            aRate.Plan_Name__c = 'Vision' + String.valueOf(i); //Vision1, Vision2, etc.
            aRate.Type__c = 'Renewal';
            aRate.Opportunity__c = anOpportunity.Id;
           // aRate.Coverage_Type__c = 'V';
            aRate.Rate_Type_Code__c = 'AGE';
            aRate.Opportunity_Benefit_Agreement__c = anOppBeneAgreement.Id;
            aRate.Enrolled_Subscriber_Count__c = 1;
            aRate.Enrolled_Member_Count__c = 2;
            aRate.Current_Comp_Total_Monthly_Premium__c = 1.00;
            aRate.Renw_Comp_Total_Monthly_Premium__c = 2.00;
            aRate.Current_Comp_Total_Est_Tax_and_Fees__c = 3.00;
            aRate.Renw_Comp_Total_Est_Tax_and_Fees__c = 4.00;
            aRate.Current_Age_Total_Monthly_Premium__c = 5.00;
            aRate.Renw_Age_Total_Monthly_Premium__c = 6.00;
            aRate.Current_Age_Total_Est_Tax_and_Fees__c = 7.00;
            aRate.Renw_Age_Total_Est_Tax_and_Fees__c = 8.00;
            if(listVisionPlans.size() == 5){
                aRate.Plan__c = listVisionPlans[i].Id;                
            }
            listOpportunityPlanRates.add(aRate);            
        }       
        
        insert listOpportunityPlanRates;
        
    }
    
    static testMethod void testFetchRates(){
        
        system.debug('SGR_OppPlanRateSummary_Controller_test.testFetchRates()');

        Opportunity anOpportunity = [SELECT 
                                     Id,
                                     Name
                                     FROM Opportunity
                                     WHERE Account.Name = 'TestAccount1'
                                     LIMIT 1];
         
        List <SGR_Opportunity_Plan_Rate__c > listOpportunityPlanRates = new List<SGR_Opportunity_Plan_Rate__c >();
        
        SGR_OppPlanRateSummary_Controller.wrapperOppPlanRateSummary aWrapper = new SGR_OppPlanRateSummary_Controller.wrapperOppPlanRateSummary(); 

        //cover Health logic
        aWrapper = SGR_OppPlanRateSummary_Controller.fetchRates(anOpportunity.Id, 'Health');
        system.debug('Health: ' + aWrapper);
        
        //cover Dental logic
        aWrapper = SGR_OppPlanRateSummary_Controller.fetchRates(anOpportunity.Id, 'Dental');
        system.debug('Dental: ' + aWrapper);
        
        //cover Vision logic
        aWrapper = SGR_OppPlanRateSummary_Controller.fetchRates(anOpportunity.Id, 'Vision');
        system.debug('Vision: ' + aWrapper);
        
        anOpportunity = [SELECT 
                         Id,
                         Name
                         FROM Opportunity
                         WHERE Account.Name = 'TestAccount2'
                         LIMIT 1];
        
        //cover Health logic where no related record exists
        aWrapper = SGR_OppPlanRateSummary_Controller.fetchRates(anOpportunity.Id, 'Health');
        system.debug('Health no related record: ' + aWrapper);
        
    }
    
}