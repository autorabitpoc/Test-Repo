/* This Test class is to test SGR_GSPS_GetMappedPlansServiceHandler class
* Update History:
* 11-11-2018    Luke Chen    SFDC-14006 SGR - GSPS : Get Mapped Plans - Build Response Post processing code
*
*/
@isTest
private class SGR_GSPS_GetMappedPlansTest {

    @isTest static void testGetMappedPlans_Success() {
        Date newBenEff = Date.newInstance(2019, 01, 01);
        SGR_Opportunity_Plan_Rate__c plan1 = new SGR_Opportunity_Plan_Rate__c();
        SGR_Opportunity_Plan_Rate__c plan2 = new SGR_Opportunity_Plan_Rate__c();
        List<SGR_Opportunity_Plan_Rate__c> plans = new List<SGR_Opportunity_Plan_Rate__c>();
        plan1.Benefit_Agreement_Effective_Date__c = plan2.Benefit_Agreement_Effective_Date__c = newBenEff;
        plan1.Plan_Name__c = 'AILPPOX01'; plan2.Plan_Name__c = 'AILPPOX02';
        plans.add(plan1); plans.add(plan2);
        Test.loadData(Username_Password__c.SObjectType, 'UserNamePasswordTestData');
        Test.loadData(OAuth_Jwt_Token2__c.SObjectType, 'JwtOauth2TestData');

        HttpCalloutMock httpResponse = new MockHttpResponseMappedPlans(200,
                '[{"name":"Blue Choice PPO Network","code":"BCA","planGroupId":848,"startDate":"2018-01-01","endDate":"2018-12-31","lineOfBusiness":"H","sortOrder":"1","subPlanGroups":[{"name":"PPO Plans","code":"PPO","planGroupId":1279,"startDate":"2018-01-01","endDate":"2018-12-31","lineOfBusiness":"H","sortOrder":"305","productType":{"code":"PPO","abbreviationCode":"PPO","description":"Participating Provider Option"},"subPlanGroups":[{"name":"Blue Platinum Plans","code":"Platinum","planGroupId":1282,"startDate":"2018-01-01","endDate":"2018-12-31","lineOfBusiness":"H","sortOrder":"1","plans":[{"planName":"PPSG11BCASTXO","planSalesId":"P620CHC","description":"Blue Choice Platinum PPO 810","longDescription":"Blue Choice Platinum PPO 810","shortDescription":"Blue Choice Platinum PPO 810","effectiveDate":"2018-01-01T05:00:00.000Z","retiredDate":"2018-12-31T06:00:00.000Z","division":"TX","planLevel":"Platinum","network":"BCA","channel":"Off-Exchange","isHsa":false,"hsaContribution":"NA","isAllCopay":false,"sortOrder":"100.000","benefitHeaderDetails":[{"id":1806,"name":"Non-Preferred Rx","value":"$10/$20/$55/$95/$150/$250"},{"id":1758,"name":"Preferred Rx","value":"$0/$10/$35/$75/$150/$250"},{"id":30,"name":"Coins In/Out","value":"80%/60%"},{"id":32,"name":"Ded In/Out","value":"$250/$500"},{"id":36,"name":"IP In/Out","value":"$150/$250"},{"id":37,"name":"Office Visit/ Specialist","value":"$25/$45"},{"id":39,"name":"OP Surg In/Out","value":"$100/$200"},{"id":41,"name":"OPX In/Out","value":"$1250/$2500"},{"id":126,"name":"ER Copay<sup>*3</sup>/ER Coins","value":"$300/80%"},{"id":128,"name":"Ped Dental In/Out","value":"70%/70%"}],"endDate":"9999-12-31T06:00:00.000Z"}]}]}],"noteDetails":[{"id":100,"type":"plan_group_info","text":"All health plans are embedded with pediatric eye exams (and select pediatric hardware) and vision discounts."},{"id":35,"type":"benefit_header_info","text":"ER copays are per-occurrence deductibles, member is responsible for the listed copay amount and the rest of the billable charge is subject to deductible and coinsurance.","symbol":"*3"}],"benefitHeaders":[{"id":32,"sortOrder":1,"name":"Ded In/Out"},{"id":37,"sortOrder":2,"name":"Office Visit/ Specialist"},{"id":30,"sortOrder":3,"name":"Coins In/Out"},{"id":41,"sortOrder":4,"name":"OPX In/Out"},{"id":126,"notes":[{"id":35,"symbol":"*3"}],"sortOrder":5,"name":"ER Copay<sup>*3</sup>/ER Coins"},{"id":36,"sortOrder":6,"name":"IP In/Out"},{"id":39,"sortOrder":7,"name":"OP Surg In/Out"},{"id":128,"sortOrder":8,"name":"Ped Dental In/Out"},{"id":1806,"sortOrder":9,"name":"Non-Preferred Rx"},{"id":1758,"sortOrder":9,"name":"Preferred Rx"}]}]');
        Test.setMock(HttpCalloutMock.class, httpResponse);
        Test.startTest();
        SGR_GSPS_GetMappedPlansServiceHandler.getMappedPlans('17031', 'RENEWALS', newBenEff, 'IL', 'PREM', 'SG', plans);
        List<Plan__c> pList = [SELECT Id FROM Plan__c];
        Integer size = pList.size();
        system.debug('# of plans = ' + size);
        //system.assert(size > 0);
        Test.stopTest();
    }

    @isTest static void testGetMappedPlans_Failed() {
        Date newBenEff = Date.newInstance(2019, 01, 01);
        SGR_Opportunity_Plan_Rate__c plan1 = new SGR_Opportunity_Plan_Rate__c();
        SGR_Opportunity_Plan_Rate__c plan2 = new SGR_Opportunity_Plan_Rate__c();
        List<SGR_Opportunity_Plan_Rate__c> plans = new List<SGR_Opportunity_Plan_Rate__c>();
        plan1.Benefit_Agreement_Effective_Date__c = plan2.Benefit_Agreement_Effective_Date__c = newBenEff;
        plan1.Plan_Name__c = 'AILPPOX01'; plan2.Plan_Name__c = 'AILPPOX02';
        plans.add(plan1); plans.add(plan2);
        Test.loadData(Username_Password__c.SObjectType, 'UserNamePasswordTestData');
        Test.loadData(OAuth_Jwt_Token2__c.SObjectType, 'JwtOauth2TestData');

        HttpCalloutMock httpResponse = new MockHttpResponseMappedPlans(403,
                '[{"name":"Blue Choice PPO Network","code":"BCA","planGroupId":848,"startDate":"2018-01-01","endDate":"2018-12-31","lineOfBusiness":"H","sortOrder":"1","subPlanGroups":[{"name":"PPO Plans","code":"PPO","planGroupId":1279,"startDate":"2018-01-01","endDate":"2018-12-31","lineOfBusiness":"H","sortOrder":"305","productType":{"code":"PPO","abbreviationCode":"PPO","description":"Participating Provider Option"},"subPlanGroups":[{"name":"Blue Platinum Plans","code":"Platinum","planGroupId":1282,"startDate":"2018-01-01","endDate":"2018-12-31","lineOfBusiness":"H","sortOrder":"1","plans":[{"planName":"PPSG11BCASTXO","planSalesId":"P620CHC","description":"Blue Choice Platinum PPO 810","longDescription":"Blue Choice Platinum PPO 810","shortDescription":"Blue Choice Platinum PPO 810","effectiveDate":"2018-01-01T05:00:00.000Z","retiredDate":"2018-12-31T06:00:00.000Z","division":"TX","planLevel":"Platinum","network":"BCA","channel":"Off-Exchange","isHsa":false,"hsaContribution":"NA","isAllCopay":false,"sortOrder":"100.000","benefitHeaderDetails":[{"id":1806,"name":"Non-Preferred Rx","value":"$10/$20/$55/$95/$150/$250"},{"id":1758,"name":"Preferred Rx","value":"$0/$10/$35/$75/$150/$250"},{"id":30,"name":"Coins In/Out","value":"80%/60%"},{"id":32,"name":"Ded In/Out","value":"$250/$500"},{"id":36,"name":"IP In/Out","value":"$150/$250"},{"id":37,"name":"Office Visit/ Specialist","value":"$25/$45"},{"id":39,"name":"OP Surg In/Out","value":"$100/$200"},{"id":41,"name":"OPX In/Out","value":"$1250/$2500"},{"id":126,"name":"ER Copay<sup>*3</sup>/ER Coins","value":"$300/80%"},{"id":128,"name":"Ped Dental In/Out","value":"70%/70%"}],"endDate":"9999-12-31T06:00:00.000Z"}]}]}],"noteDetails":[{"id":100,"type":"plan_group_info","text":"All health plans are embedded with pediatric eye exams (and select pediatric hardware) and vision discounts."},{"id":35,"type":"benefit_header_info","text":"ER copays are per-occurrence deductibles, member is responsible for the listed copay amount and the rest of the billable charge is subject to deductible and coinsurance.","symbol":"*3"}],"benefitHeaders":[{"id":32,"sortOrder":1,"name":"Ded In/Out"},{"id":37,"sortOrder":2,"name":"Office Visit/ Specialist"},{"id":30,"sortOrder":3,"name":"Coins In/Out"},{"id":41,"sortOrder":4,"name":"OPX In/Out"},{"id":126,"notes":[{"id":35,"symbol":"*3"}],"sortOrder":5,"name":"ER Copay<sup>*3</sup>/ER Coins"},{"id":36,"sortOrder":6,"name":"IP In/Out"},{"id":39,"sortOrder":7,"name":"OP Surg In/Out"},{"id":128,"sortOrder":8,"name":"Ped Dental In/Out"},{"id":1806,"sortOrder":9,"name":"Non-Preferred Rx"},{"id":1758,"sortOrder":9,"name":"Preferred Rx"}]}]');
        Test.setMock(HttpCalloutMock.class, httpResponse);
        Test.startTest();
        SGR_GSPS_GetMappedPlansServiceHandler.getMappedPlans('17031', 'RENEWALS', newBenEff, 'IL', 'PREM', 'SG', plans);
        List<Plan__c> pList = [SELECT Id FROM Plan__c];
        Integer size = pList.size();
        system.debug('# of plans = ' + size);
        system.assert(size == 0);
        Test.stopTest();
    }

    @isTest static void testGetMappedPlans_NoMappedPlans() {
        Date newBenEff = Date.newInstance(2019, 01, 01);
        SGR_Opportunity_Plan_Rate__c plan1 = new SGR_Opportunity_Plan_Rate__c();
        SGR_Opportunity_Plan_Rate__c plan2 = new SGR_Opportunity_Plan_Rate__c();
        List<SGR_Opportunity_Plan_Rate__c> plans = new List<SGR_Opportunity_Plan_Rate__c>();
        plan1.Benefit_Agreement_Effective_Date__c = plan2.Benefit_Agreement_Effective_Date__c = newBenEff;
        plan1.Plan_Name__c = 'AILPPOX01'; plan2.Plan_Name__c = 'AILPPOX02';
        plans.add(plan1); plans.add(plan2);
        Test.loadData(Username_Password__c.SObjectType, 'UserNamePasswordTestData');
        Test.loadData(OAuth_Jwt_Token2__c.SObjectType, 'JwtOauth2TestData');
        HttpCalloutMock httpResponse = new MockHttpResponseMappedPlans(200, '[]');
        Test.setMock(HttpCalloutMock.class, httpResponse);
        Test.startTest();
        SGR_GSPS_GetMappedPlansServiceHandler.getMappedPlans('17031', 'RENEWALS', newBenEff, 'IL', 'PREM', 'SG', plans);
        List<Plan__c> pList = [SELECT Id FROM Plan__c];
        Integer size = pList.size();
        system.debug('# of plans = ' + size);
        system.assert(size == 0);
        Test.stopTest();
    }

    @isTest static void testupdateOpprPlanRateWithMappedPlans() {
        List<SGR_Opportunity_Plan_Rate__c> plans = new List<SGR_Opportunity_Plan_Rate__c>();
        SGR_Opportunity_Plan_Rate__c p1 = new SGR_Opportunity_Plan_Rate__c();
        p1.Plan_Name__c = 'PPSE46BCASTXO';
        p1.Benefit_Agreement_Effective_Date__c = Date.valueOf('2016-01-01');
        p1.Plan_Status__c = 'Renewing';
        plans.add(p1);
        insert plans;

        Plan__c plan1 = new Plan__c();
        plan1.Name = 'PPSG11BCASTXO';
        plan1.Marketing_Plan_Number__c = 'PPSG11BCASTXO';
        plan1.Plan_Sales_ID__c = 'P600CHCaa';
        insert plan1;

        Plan__c plan = new Plan__c();
        plan.Name = 'PPSE46BCASTXO';
        plan.Marketing_Plan_Number__c = 'PPSE46BCASTXO';
        plan.Mapped_Plan_Name__c = 'PPSG11BCASTXO';
        plan.MappedPlan__c = plan1.Id;
        plan.Plan_Sales_ID__c = 'P600CHC';
        insert plan;

        Test.startTest();
        SGR_GSPS_GetMappedPlansServiceHandler.updateOpprPlanRateWithMappedPlans(plans);
        List<SGR_Opportunity_Plan_Rate__c> planList = new List<SGR_Opportunity_Plan_Rate__c>();
        planList = [
                SELECT Id,Marketing_Plan_ID__c,Sales_Plan_ID__c,Plan__c,Mapping_From_Plan_Id__c,Plan_Name__c,Plan_Status__c
                FROM SGR_Opportunity_Plan_Rate__c
                WHERE Plan_Name__c = 'PPSE46BCASTXO'
        ];
        //System.assertEquals(planList[0].Plan_Status__c,'Mapped');
        Test.stopTest();

    }

}