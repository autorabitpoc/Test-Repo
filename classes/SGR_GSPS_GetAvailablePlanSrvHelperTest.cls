@isTest
public with sharing class SGR_GSPS_GetAvailablePlanSrvHelperTest {

    @testSetup
    public static void setupData() {
        SGR_Product_Group__c sPG = new SGR_Product_Group__c();
        sPG.Name = 'Test PG';
        sPG.SGR_Product_Group_Code__c = 'PG12345';
        sPG.SGR_Market_Segment__c = 'SG';
        sPG.SGR_Division__c = 'IL';
        sPG.SGR_Effective_Date__c = System.today();
        sPG.SGR_Expiry_Date__c = System.today().addYears(2);
        insert sPG;
    }

    @isTest
    public static void testProcessPlanGroups() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        SGR_Product_Group__c sPG = [SELECT Id FROM SGR_Product_Group__c LIMIT 1];
        mock.setStaticResource('GetAvailablePlanResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        SGR_GSPS_GetAvailablePlanServiceRequest req = new SGR_GSPS_GetAvailablePlanServiceRequest();
        req.productGroupCd = 'PG12345';
        req.effectiveDate = System.today();
        req.division = 'IL';
        req.marketSegment = 'SG';
        req.fundingType = 'PREM';
        req.clientId = 'QUOTING';
        req.version = 1;

        Date rateEffDate = Date.newInstance(2019, 01, 01);
        //SGR_GSPS_GetAvailablePlanServiceResponse response = util.invokeGetAllAvailablePlanService(req);
        String jsonStr = '{"name": "Health", "productGroupCode": "BASO_IL","productGroupType": ["Health"],"division": "IL","effectiveDate": "2016-01-01","endDate": "9999-12-31","marketSegment": "SG","fundingType": "BASO","lineOfBusiness": "H","planGroups": [{"name": "BluePrint PPO","code": "PPOA3","planGroupId": 973,"startDate": "2019-01-01","endDate": "9999-12-31","lineOfBusiness": "H","sortOrder": "1","subPlanGroups": [   { "name": "PPO Benefit Design Options", "code": "PPO", "planGroupId": 1614, "startDate": "2019-01-01", "endDate": "9999-12-31", "lineOfBusiness": "H", "sortOrder": "459", "productType": { "code": "PPO", "abbreviationCode": "PPO", "description": "Participating Provider Option" }, "plans": [ { "planName": "AILPPOX01", "planSalesId": "AILPPOX01", "description": "BluePrint PPO 203", "longDescription": "BluePrint PPO 203", "shortDescription": "BluePrint PPO 203", "effectiveDate": "2019-01-01T05:00:00.000Z", "retiredDate": "9999-12-31T05:00:00.000Z", "division": "IL", "network": "PPO", "channel": "Off-Exchange", "isHsa": false, "hsaContribution": "NA", "isAllCopay": false, "sortOrder": "10.000", "benefitHeaderDetails": [    {  "id": 30,  "name": "Coins In/Out",  "value": "80%/60%"    } ], "endDate": "9999-12-31T05:00:00.000Z" } ]   }],"noteDetails": [   { "id": 120, "type": "plan_group_info", "text": "Virtual Visits are available from a participating provider for certain non-emergency services."   }],"benefitHeaders": [   { "id": 32, "sortOrder": 1, "name": "Ded In/Out"   }]}],"noteDetails": [{"id": 71,"type": "plan_info","text": "RX Section: Coinsurance after Deductible is Plan pays percentage.","symbol": "*2"}]}';
        SGR_GSPS_GetAvailablePlanServiceResponse response = (SGR_GSPS_GetAvailablePlanServiceResponse) JSON.deserialize(jsonStr, SGR_GSPS_GetAvailablePlanServiceResponse.class);
        System.debug('Response:::: ' + response);
        System.assertNotEquals(null, response, 'The callout returned a null response.');
        // SGR_GSPS_GetAvailablePlanServiceHelper.processAllPlanResponseData( response, sPG.Id,'17003','IL', 'SG', 'PREM',  rateEffDate);//processResponseData(response,sPG.Id);
        SGR_GSPS_GetAvailablePlanServiceHelper.callGetAvailablePlansService ('17003', rateEffDate, 'IL', 'SG', 'PREM', 'RENEWALS', 1);

        System.assertNotEquals(null, response.planGroups, 'Call out did not return any plangroups');
        List<Product2> pgs = [SELECT Id FROM Product2];
        List<Plan__c> plans = [SELECT Id FROM Plan__c];
        List<Benefit_Header__c> bhs = [SELECT Id FROM Benefit_Header__c];
        List<SGR_Note_Detail__c> nds = [SELECT Id FROM SGR_Note_Detail__c];

        List<Benefit_Header_Detail__c> bhd = [SELECT Id FROM Benefit_Header_Detail__c];

    }

}