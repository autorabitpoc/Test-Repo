@isTest(seeAllData=false)
private class SGR_BRValidationManager_Test {
	@testSetup
    private static void createTestData(){
        Datetime myDateTime = system.now();
        Date today = system.today().adddays(30);
        String renDate = string.valueof(today);
        List<Opportunity> optys = new List<Opportunity>();
        //Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Account acc = Sgr_TestDataUtility.createAcc('NewAcc');
        Opportunity optyIL = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Qualify');
        optyIL.Account_Market_Segment__c = 'SG';
        optyIL.Funding_Type__c = 'PREM';
        optyIL.HCSC_Division__c = 'IL';
        optyIL.RecordTypeId = Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//sgrProdOpp;
        optys.add(optyIL);
        Opportunity optyIL1 = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Qualify');
        optyIL1.Account_Market_Segment__c = 'SG';
        optyIL1.Funding_Type__c = 'PREM';
        optyIL1.HCSC_Division__c = 'IL';
        optyIL1.RecordTypeId = Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//sgrProdOpp;
        optys.add(optyIL1);
        system.debug('++++optyIL.Assigned_UW__c--'+optyIL.Assigned_UW__c);
        //TX Passed Optys
        Opportunity optyTX = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Qualify');
        optyTX.Account_Market_Segment__c = 'SG';
        optyTX.Funding_Type__c = 'PREM';
        optyTX.HCSC_Division__c = 'TX';
        optyTX.RecordTypeId = Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//sgrProdOpp;
        optys.add(optyTX);
        Opportunity optyTX2 = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Qualify');
        optyTX2.Account_Market_Segment__c = 'SG';
        optyTX2.Funding_Type__c = 'PREM';
        optyTX2.HCSC_Division__c = 'TX';
        optyTX2.RecordTypeId = Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//sgrProdOpp;
        optys.add(optyTX2);
        Opportunity optyNM = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Qualify');
        optyNM.Account_Market_Segment__c = 'SG';
        optyNM.Funding_Type__c = 'PREM';
        optyNM.HCSC_Division__c = 'NM';
        optyNM.RecordTypeId = Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//sgrProdOpp;
        optys.add(optyNM);
        Opportunity optyNM1 = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Qualify');
        optyNM1.Account_Market_Segment__c = 'SG';
        optyNM1.Funding_Type__c = 'PREM';
        optyNM1.HCSC_Division__c = 'NM';
        optyNM1.RecordTypeId = Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//sgrProdOpp;
        optys.add(optyNM1);
        insert optys;
        system.debug('++++optyIL.Assigned_UW__c--'+optyIL.Assigned_UW__c);
        List<Plan__c> plans = new List<Plan__c>();
        Plan__c plwithoutMappedPPO = new Plan__c(name='Plan1',Network__c='PPO');
        plans.add(plwithoutMappedPPO);
        Plan__c plwithMappedPPO = new Plan__c(name='Plan2',Network__c='PPO', MappedPlan__c = plwithoutMappedPPO.Id);
        plans.add(plwithMappedPPO);
        Plan__c withoutMappedPlHMO = new Plan__c(name='Plan1',Network__c='HMO');
        plans.add(withoutMappedPlHMO);
        Plan__c withMappedPlHMO = new Plan__c(name='Plan2',Network__c='HMO', MappedPlan__c = plwithoutMappedPPO.Id);
        plans.add(withMappedPlHMO);
        insert plans;
        //SGR_Opportunity_Plan_Rate__c planRate = new SGR_Opportunity_Plan_Rate__c(Opportunity__c = optyIL.id, Name = 'Plan Rate1', Plan__c = plwithoutMappedPl.Id,Plan_Status__c = 'Renewing');
        List<SGR_Opportunity_Plan_Rate__c> planRateRecs = new List<SGR_Opportunity_Plan_Rate__c>();                                                                       
        SGR_Opportunity_Plan_Rate__c planRateIL = Sgr_TestDataUtility.optyPlanRate('Plan RateIL', optyIL.id, 'Renewing', plwithoutMappedPPO.Id);                                                                         
        planRateRecs.add(planRateIL);
        SGR_Opportunity_Plan_Rate__c planRateIL1 = Sgr_TestDataUtility.optyPlanRate('Plan RateIL', optyIL1.id, 'Renewing', plwithoutMappedPPO.Id);                                                                         
        planRateRecs.add(planRateIL1);
        SGR_Opportunity_Plan_Rate__c planRateTX1 = Sgr_TestDataUtility.optyPlanRate('Plan RateTX1', optyTX.id, 'Renewing', plwithoutMappedPPO.Id);                                                                         
        planRateRecs.add(planRateTX1);
        SGR_Opportunity_Plan_Rate__c planRateTX2 = Sgr_TestDataUtility.optyPlanRate('Plan RateTX2', optyTX.id, 'Renewing', plwithoutMappedPPO.Id);                                                                         
        planRateRecs.add(planRateTX2);
        SGR_Opportunity_Plan_Rate__c planRateTX3 = Sgr_TestDataUtility.optyPlanRate('Plan RateTX3', optyTX2.id, 'Renewing', withoutMappedPlHMO.Id);                                                                         
        planRateRecs.add(planRateTX3);
        SGR_Opportunity_Plan_Rate__c planRateTX4 = Sgr_TestDataUtility.optyPlanRate('Plan RateTX1', optyTX2.id, 'Renewing', withoutMappedPlHMO.Id);                                                                         
        planRateRecs.add(planRateTX4);
        SGR_Opportunity_Plan_Rate__c planRateNM1 = Sgr_TestDataUtility.optyPlanRate('Plan RateNM1', optyNM.id, 'Mapped', plwithoutMappedPPO.Id);                                                                         
        planRateRecs.add(planRateNM1);
        SGR_Opportunity_Plan_Rate__c planRateNM2 = Sgr_TestDataUtility.optyPlanRate('Plan RateNM2', optyNM.id, 'Mapped', plwithMappedPPO.Id);                                                                         
        planRateRecs.add(planRateNM2);
        SGR_Opportunity_Plan_Rate__c planRateNM3 = Sgr_TestDataUtility.optyPlanRate('Plan RateNM2', optyNM1.id, 'Renewing', plwithMappedPPO.Id);                                                                         
        planRateRecs.add(planRateNM3);
        insert planRateRecs;
        system.debug('++++planRateRecs.size()--'+planRateRecs.size());
        List<SGR_Renewal_Batch_Oppty__c> optyrenBatch = new List<SGR_Renewal_Batch_Oppty__c>();
        SGR_Renewal_Batch_Oppty__c optyrenBatchIL = new SGR_Renewal_Batch_Oppty__c(Name='Ren BatchIL',
                                                                                   Processing_Status__c='Bluestar transfer initiated',Opportunity__c=optyIL.Id);
        optyrenBatch.add(optyrenBatchIL);
        SGR_Renewal_Batch_Oppty__c optyrenBatchTX1 = new SGR_Renewal_Batch_Oppty__c(Name='Ren BatchTX1',
                                                                                   Processing_Status__c='Bluestar transfer initiated',Opportunity__c=optyTX.Id);
        optyrenBatch.add(optyrenBatchTX1);
        SGR_Renewal_Batch_Oppty__c optyrenBatchTX2 = new SGR_Renewal_Batch_Oppty__c(Name='Ren BatchTX2',
                                                                                   Processing_Status__c='Bluestar transfer initiated',Opportunity__c=optyTX2.Id);
        optyrenBatch.add(optyrenBatchTX2);
       
        SGR_Renewal_Batch_Oppty__c optyrenBatchNM = new SGR_Renewal_Batch_Oppty__c(Name='Ren Batch1',
                                                                                   Processing_Status__c='Bluestar transfer initiated',Opportunity__c=optyNM.Id);
        optyrenBatch.add(optyrenBatchNM);
        insert optyrenBatch; 
        
        List<SGR_Business_Rule__c> brRules = new List<SGR_Business_Rule__c>();
        SGR_Business_Rule__c brRule1 = new SGR_Business_Rule__c(name = 'Rule1',
                                                               Proposed_wording_fail__c = 'Pass', 
                                                               Proposed_wording_pass__c = 'Fail', 
                                                               Rule_Code__c = 'PR.DP.09.c');
        brRules.add(brRule1);
        SGR_Business_Rule__c brrule2 = new SGR_Business_Rule__c(name = 'Rule2',
                                                               Proposed_wording_fail__c = 'Pass', 
                                                               Proposed_wording_pass__c = 'Fail', 
                                                               Rule_Code__c = 'PR.DP.09.h');
        brRules.add(brRule2);
        SGR_Business_Rule__c brrule3 = new SGR_Business_Rule__c(name = 'Rule2',
                                                               Proposed_wording_fail__c = 'Pass', 
                                                               Proposed_wording_pass__c = 'Fail', 
                                                               Rule_Code__c = 'PR.DP.09.j');
        brRules.add(brRule3);
        Insert brRules;
    }
    
    @isTest
    private static void blueSTARValidationTestTX(){
        List<Opportunity> optys = [select Id,(select id from Opportunity_Plan_Rates__r) from Opportunity where HCSC_Division__c = 'TX'];
        System.assert(optys.size() > 0);
        //System.assert(optys.size() > 0);
        system.debug('+++optys.size() TX---'+optys.size());
        Set<Id> optyIds = new Set<Id>();
        
        for(Opportunity op : optys){
            optyIds.add(op.Id);
        }
        system.debug('+++optyIds.size() TX---'+optyIds.size());
        test.startTest();
            SGR_BRValidationManager br = new SGR_BRValidationManager('SGR_BlueSTAREligibilityRules');
            br.validate(optyIds);
        	List<Business_Rule_Validation_Log__c> brRules = new List<Business_Rule_Validation_Log__c>();
        	brRules = [select Id from Business_Rule_Validation_Log__c];
        	system.debug('+++brRules.size()--'+brRules.size());
        	System.assert(brRules.size() > 0);
        test.stopTest(); 
    }
    @isTest
    private static void blueSTARValidationTestNM(){
        List<Opportunity> optys = [select Id from Opportunity where HCSC_Division__c = 'NM'];
        system.debug('+++optys.size()  NM---'+optys.size());
        Set<Id> optyIds = new Set<Id>();
        
        for(Opportunity op : optys){
            optyIds.add(op.Id);
        }
        system.debug('+++optyIds.size()  NM---'+optyIds.size());
        test.startTest();	
        	SGR_BRValidationManager brNM = new SGR_BRValidationManager('SGR_BlueSTAREligibilityRules');
            brNM.validate(optyIds);
        test.stopTest();
    }
    @isTest
    private static void blueSTARValidationTestIL(){
        List<Opportunity> optys = [select Id from Opportunity where HCSC_Division__c = 'IL'];
        system.debug('+++optys.size() IL---'+optys.size());
        Set<Id> optyIds = new Set<Id>();
        
        for(Opportunity op : optys){
            optyIds.add(op.Id);
        }
        system.debug('+++optyIds.size() IL---'+optys.size());
        test.startTest();	
            SGR_BRValidationManager brTX = new SGR_BRValidationManager('SGR_BlueSTAREligibilityRules');
            brTX.validate(optyIds);
        test.stopTest();
    }
}