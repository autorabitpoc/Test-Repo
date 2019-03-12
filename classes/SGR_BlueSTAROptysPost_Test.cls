@isTest
private class SGR_BlueSTAROptysPost_Test {
    @testSetup static void setup() {
        // Create common test Data
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Account acc = Sgr_TestDataUtility.createAcc('NewAcc');
        system.debug('+++Acc.Id--'+acc.Id);
        List<Opportunity> optys = new List<Opportunity>();
        Opportunity optyIL = Sgr_TestDataUtility.createOpportunity(acc.Id, 'Marketing Release', 'Qualify');
        //opty.Account_Market_Segment__c = 'SG';
        optyIL.Funding_Type__c = 'PREM';
        optyIL.HCSC_Division__c = 'IL';
        optyIL.RecordTypeId = sgrProdOpp;
        optyIL.Renewal_Date__c = system.today().adddays(5);
        //opty.Assigned_UW__c ='';//UserInfo.getuserid();
        optyIL.Workflow_System_Status__c = 'Ready for BlueSTAR Initiation';
        optyIL.ForeCast_Segment__c='Small Group';
        optys.add(optyIL);
        Opportunity optyTX = Sgr_TestDataUtility.createOpportunity(acc.Id, 'Marketing Release', 'Qualify');
        //opty.Account_Market_Segment__c = 'SG';
        optyTX.Funding_Type__c = 'PREM';
        optyTX.HCSC_Division__c = 'TX';
        optyTX.RecordTypeId = sgrProdOpp;
        optyTX.Renewal_Date__c = system.today().adddays(30);
        //opty.Assigned_UW__c ='';//UserInfo.getuserid();
        optyTX.Workflow_System_Status__c = 'Ready for BlueSTAR Initiation';
        optyTX.ForeCast_Segment__c='Small Group';
        optys.add(optyTX);
        Insert optys;
        
        
        List<SGR_Opportunity_Plan_Rate__c> planRates = new List<SGR_Opportunity_Plan_Rate__c>();
        SGR_Opportunity_Plan_Rate__c planRateIL = new SGR_Opportunity_Plan_Rate__c(Opportunity__c = optyIL.id, Plan_Status__c = 'Renewing', Type__c='Renewal');
        planRates.add(planRateIL);
        SGR_Opportunity_Plan_Rate__c planRateTX = new SGR_Opportunity_Plan_Rate__c(Opportunity__c = optyTX.id, Plan_Status__c = 'Renewing', Type__c='Renewal');
        planRates.add(planRateTX);
        insert planRates;
    }
    @isTest
    private static void blueStarmethod(){
        Datetime myDateTime = system.now();
        Date today = system.today().adddays(5);
        String renDate = string.valueof(today);
        
        Test.startTest();
        SGR_BlueSTAROptysPost.updateBlueSTAROptys('IL', 'SG', 'PREM', renDate, myDateTime);
        SGR_BlueSTAROptysPost.updateBlueSTAROptys('TX', 'SG', 'PREM', renDate, myDateTime);
        SGR_BlueSTAROptysPost.updateBlueSTAROptys('TX', 'SG', 'PREM', 'Hi', myDateTime);
        SGR_BlueSTAROptysPost.updateBlueSTAROptys('MT', 'SG', 'PREM', renDate, myDateTime);
        Test.stopTest();
    }
    
}