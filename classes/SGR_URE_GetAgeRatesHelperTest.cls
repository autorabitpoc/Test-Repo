@isTest
public class SGR_URE_GetAgeRatesHelperTest {
    
    @isTest 
    public static void testAgeRatesSuccess(){
      /*  Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
        Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData'); */
        
        //String mockResBody='{"rffResult":{"marketingRatesGenericTaskResult":{"ratingPackageResults":[{"productResults":[{"planResults":[{"areaResults":[{"areaNumber":"2","isTefra":"false","isTobacco":"true","rates":[{"fromAge":"0","grossPremium":"283.68","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.43","Net_of_ACA":"283.25","nonACAFees":"37.43"},"toAge":"14"},{"fromAge":"15","grossPremium":"308.89","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.46","Net_of_ACA":"308.43","nonACAFees":"40.76"},"toAge":"15"},{"fromAge":"63","grossPremium":"1094.67","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.64","Net_of_ACA":"1093.03","nonACAFees":"144.45"},"toAge":"63"},{"fromAge":"64","grossPremium":"1112.46","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.68","Net_of_ACA":"1110.78","nonACAFees":"146.79"},"toAge":"120"}]}],"coverageCode":"M","demographicFactorClass":"1 ","optionResults":[{"optionDetails":[{"areaFactorClass":"1","benefitName":"36096IL0770045","benefitType":"MEDICAL"}]}],"planId":"SPSG10PPOSILO"}],"value":"PPO MED"},{"planResults":[{"areaResults":[{"areaNumber":"2","isTefra":"false","isTobacco":"true","rates":[{"fromAge":"0","grossPremium":"223.84","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.34","Net_of_ACA":"223.50","nonACAFees":"29.54"},"toAge":"14"},{"fromAge":"64","grossPremium":"877.80","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.32","Net_of_ACA":"876.48","nonACAFees":"115.83"},"toAge":"120"}]},{"areaNumber":"2","isTefra":"false","isTobacco":"true","rates":[{"fromAge":"0","grossPremium":"223.84","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.34","Net_of_ACA":"223.50","nonACAFees":"29.54"},"toAge":"14"},{"fromAge":"15","grossPremium":"243.73","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.37","Net_of_ACA":"243.36","nonACAFees":"32.16"},"toAge":"15"},{"fromAge":"16","grossPremium":"251.34","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.38","Net_of_ACA":"250.96","nonACAFees":"33.17"},"toAge":"16"},{"fromAge":"64","grossPremium":"877.80","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.32","Net_of_ACA":"876.48","nonACAFees":"115.83"},"toAge":"120"}]}],"coverageCode":"M","demographicFactorClass":"1 ","optionResults":[{"optionDetails":[{"areaFactorClass":"62","benefitName":"36096IL0900038","benefitType":"MEDICAL"}]}],"planId":"SPSG10BCOSILO"}],"value":"BOPT MED"}]}]},"marketingDentalRatesGenericTaskResult":{"ratingPackageResults":[{"productResults":[{"planResults":[{"areaResults":[{"areaNumber":"100","isTefra":"false","isTobacco":"true","rates":[{"fromAge":"0","grossPremium":"38.73","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.00","Net_of_ACA":"38.73","nonACAFees":"12.46"},"toAge":"14"},{"fromAge":"15","grossPremium":"38.73","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.00","Net_of_ACA":"38.73","nonACAFees":"12.46"},"toAge":"15"},{"fromAge":"64","grossPremium":"43.66","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"0.00","Net_of_ACA":"43.66","nonACAFees":"14.04"},"toAge":"120"}]}],"coverageCode":"D","demographicFactorClass":"D7","optionResults":[{"optionDetails":[{"areaFactorClass":"1","benefitName":"DILLR07","benefitType":"Dental"}]}],"planId":"DILLR07","rateSize":"A"}],"value":"PPO"}]}]},"referenceId":"13127874","retentionTaskResult":[{"coverageCode":"M","multplvFactors":{"ACAFees":"0.001500000000000","commission":"0.000000000000000","expense":"0.131960000000000","m5":"0.000000000000000","margin":"0.000000000000000","premtax":"0.000000000000000"}},{"coverageCode":"D","multplvFactors":{"ACAFees":"0.000000000000000","commission":"0.000000000000000","expense":"0.321600000000000","m5":"0.000000000000000","margin":"0.000000000000000","premtax":"0.000000000000000"}}]}}';
       String mockResBody='{"rffResult":{"marketingRatesGenericTaskResult":{"ratingPackageResults":[{"productResults":[{"planResults":[{"areaResults":[{"areaNumber":"2","isTefra":"false","isTobacco":"false","rates":[{"fromAge":"0","grossPremium":"283.68","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.43","Net_of_ACA":"283.25","nonACAFees":"37.43"},"toAge":"14"},{"fromAge":"15","grossPremium":"308.89","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.46","Net_of_ACA":"308.43","nonACAFees":"40.76"},"toAge":"15"},{"fromAge":"63","grossPremium":"1094.67","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.64","Net_of_ACA":"1093.03","nonACAFees":"144.45"},"toAge":"63"},{"fromAge":"64","grossPremium":"1112.46","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.68","Net_of_ACA":"1110.78","nonACAFees":"146.79"},"toAge":"120"}]}],"coverageCode":"M","demographicFactorClass":"1 ","optionResults":[{"optionDetails":[{"areaFactorClass":"1","benefitName":"36096IL0770045","benefitType":"MEDICAL"}]}],"planId":"SPSG10PPOSILO"}],"value":"PPO MED"},{"planResults":[{"areaResults":[{"areaNumber":"2","isTefra":"false","isTobacco":"false","rates":[{"fromAge":"0","grossPremium":"223.84","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.34","Net_of_ACA":"223.50","nonACAFees":"29.54"},"toAge":"14"},{"fromAge":"64","grossPremium":"877.80","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.32","Net_of_ACA":"876.48","nonACAFees":"115.83"},"toAge":"120"}]},{"areaNumber":"2","isTefra":"false","isTobacco":"false","rates":[{"fromAge":"0","grossPremium":"223.84","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.34","Net_of_ACA":"223.50","nonACAFees":"29.54"},"toAge":"14"},{"fromAge":"15","grossPremium":"243.73","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.37","Net_of_ACA":"243.36","nonACAFees":"32.16"},"toAge":"15"},{"fromAge":"16","grossPremium":"251.34","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.38","Net_of_ACA":"250.96","nonACAFees":"33.17"},"toAge":"16"},{"fromAge":"64","grossPremium":"877.80","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"1.32","Net_of_ACA":"876.48","nonACAFees":"115.83"},"toAge":"120"}]}],"coverageCode":"M","demographicFactorClass":"1 ","optionResults":[{"optionDetails":[{"areaFactorClass":"62","benefitName":"36096IL0900038","benefitType":"MEDICAL"}]}],"planId":"SPSG10BCOSILO"}],"value":"BOPT MED"}]}]},"marketingDentalRatesGenericTaskResult":{"ratingPackageResults":[{"productResults":[{"planResults":[{"areaResults":[{"areaNumber":"100","isTefra":"false","isTobacco":"false","rates":[{"fromAge":"0","grossPremium":"38.73","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.00","Net_of_ACA":"38.73","nonACAFees":"12.46"},"toAge":"14"},{"fromAge":"15","grossPremium":"38.73","relationshipCode":"OD","retentionBreakdown":{"ACAFees":"0.00","Net_of_ACA":"38.73","nonACAFees":"12.46"},"toAge":"15"},{"fromAge":"64","grossPremium":"43.66","relationshipCode":"SP","retentionBreakdown":{"ACAFees":"0.00","Net_of_ACA":"43.66","nonACAFees":"14.04"},"toAge":"120"}]}],"coverageCode":"D","demographicFactorClass":"D7","optionResults":[{"optionDetails":[{"areaFactorClass":"1","benefitName":"DILLR07","benefitType":"Dental"}]}],"planId":"DILLR07","rateSize":"A"}],"value":"PPO"}]}]},"referenceId":"13127874","retentionTaskResult":[{"coverageCode":"M","multplvFactors":{"ACAFees":"0.001500000000000","commission":"0.000000000000000","expense":"0.131960000000000","m5":"0.000000000000000","margin":"0.000000000000000","premtax":"0.000000000000000"}},{"coverageCode":"D","multplvFactors":{"ACAFees":"0.000000000000000","commission":"0.000000000000000","expense":"0.321600000000000","m5":"0.000000000000000","margin":"0.000000000000000","premtax":"0.000000000000000"}}]}}';
        //Test.setMock(HttpCalloutMock.class,new MockHttpResponseProductGroup(200, '{"username": "test","access_token": "test","token_type": "Bearer","expires_in": 3650, "refresh_token": "test", "scope": "oob", "jwt_token": "test"}'));
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseProductGroup(200,mockResBody));
      
        List<SGR_URE_Age_Rate_Driver__c> lstAgeRateDrivers= new List<SGR_URE_Age_Rate_Driver__c>();
		List<Plan__c> pList = new List<Plan__c>();
        for(Integer i=0 ;i <100;i++)
        {
            SGR_URE_Age_Rate_Driver__c driver = new SGR_URE_Age_Rate_Driver__c();
            driver.Name ='Name'+i;
			driver.SGR_Plan_Id__c ='Plan00'+i;
			driver.FIPS_Code__c ='CC'+i;
			driver.Corporate_Entity_Code__c ='CEC'+i;
			driver.Rate_Effective_Date__c =System.today();
			driver.Market_Segment__c ='SG';
            lstAgeRateDrivers.add(driver);
        }
        		
        insert lstAgeRateDrivers;
		
		for(Integer i=0 ;i <100;i++){
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
        
        Date renewDate = system.today();
        
        Integration_Log_Switcher__c allPlanLog= new Integration_Log_Switcher__c();
        allPlanLog.Name='URE Generic Service';
        allPlanLog.Integration_Log__c=true;
        insert allPlanLog;
              
        List<Plan__c> planList = new List<Plan__c>();
        Plan__c pL = new Plan__c();
        pL.Channel__c = 'Test';
        pL.Description__c = 'TESTETS';
        pL.Endorsement_Indicator__c = TRUE;
        pL.HCR_Compliance_Code__c = 'TEST';
        pL.Level_1_Product_Name__c = 'TESTETTS';
        pL.Mapped_Plan_Name__c = 'TEST';
        pL.Product_Name__c = 'TESTT';
        pL.Marketing_Plan_Number__c = 'SPSG10PPOSILO';
        planList.add(pL);
        
        Plan__c pL1 = new Plan__c();
        pL1.Channel__c = 'Test';
        pL1.Description__c = 'TESTETS';
        pL1.Endorsement_Indicator__c = TRUE;
        pL1.HCR_Compliance_Code__c = 'TEST';
        pL1.Level_1_Product_Name__c = 'TESTETTS';
        pL1.Mapped_Plan_Name__c = 'TEST';
        pL1.Product_Name__c = 'TESTT';
        pL1.Marketing_Plan_Number__c = 'SPSG10BCOSILO';
        planList.add(pL1);
        
        Plan__c pL2 = new Plan__c();
        pL2.Channel__c = 'Test';
        pL2.Description__c = 'TESTETS';
        pL2.Endorsement_Indicator__c = TRUE;
        pL2.HCR_Compliance_Code__c = 'TEST';
        pL2.Level_1_Product_Name__c = 'TESTETTS';
        pL2.Mapped_Plan_Name__c = 'TEST';
        pL2.Product_Name__c = 'TESTT';
        PL2.Marketing_Plan_Number__c = 'DILLR07';
        planList.add(pL2);
        
        insert planList;
        
        list<SGR_Plan_Age_Rate_Header__c> hdrList = new list<SGR_Plan_Age_Rate_Header__c>();
        
        SGR_Plan_Age_Rate_Header__c hdr = new SGR_Plan_Age_Rate_Header__c();
        hdr.Corporate_Entity_Code__c = '12344';
        hdr.Division__c = 'NM';
        hdr.FIPS_Code__c = 'FIPS';
        hdr.Is_Tobacco__c = false;
        hdr.Rate_Size__c = 'A';
        hdr.Plan__c = planList[0].id;
        hdr.Plan_Header_External_ID__c = 'externalID';
        hdr.SGR_Plan_Id__c = 'TESTETS';
      	hdrlist.add(hdr);
        insert hdrlist;
        
        
        List<SGR_Plan_Age_Rate_Header__c> finalAreaHdrLst = new List<SGR_Plan_Age_Rate_Header__c>();
       // finalAreaHdrLst.addAll(hdrlist);
        Map<String,List<SGR_URE_GetRatingsResponse>> resMap = new Map<String,List<SGR_URE_GetRatingsResponse>>();
        Map<String,List<SGR_Plan_Age_Rate_Header__c>> strMap = new Map<String,List<SGR_Plan_Age_Rate_Header__c>>();
        strMap.put('TESTETS',hdrlist);
        
		SGR_URE_GetRatingsResponse.URE_RetentionBreakDown  sam = new SGR_URE_GetRatingsResponse.URE_RetentionBreakDown();
        sam.ACAFees = 12;
        sam.Net_of_ACA = 13;
        sam.nonACAFees = 14;
        
        list<SGR_URE_GetRatingsResponse.URE_Rate> rateList = new List<SGR_URE_GetRatingsResponse.URE_Rate>();
        SGR_URE_GetRatingsResponse.URE_Rate sam1 = new SGR_URE_GetRatingsResponse.URE_Rate();
        sam1.fromAge = '23';
        sam1.toAge = '56';
        sam1.relationshipCode = '12345';
        sam1.grossPremium = 34;
        sam1.retentionBreakdown = sam;
        sam1.censusDetailId = '12345';
        sam1.subscriberId = '56789';
        rateList.add(sam1);
        
        List<SGR_URE_GetRatingsResponse.URE_AreaRateResult> arRatList = new List<SGR_URE_GetRatingsResponse.URE_AreaRateResult>();
        SGR_URE_GetRatingsResponse.URE_AreaRateResult  sam2 = new SGR_URE_GetRatingsResponse.URE_AreaRateResult();
        sam2.areaNumber = '12343';
        sam2.isTefra = 'TRUE';
        sam2.isTobacco = 'false';
        sam2.rates = rateList;
        arRatList.add(sam2);
        
        List<SGR_URE_GetRatingsResponse.URE_TierRate> tirList = new List<SGR_URE_GetRatingsResponse.URE_TierRate>();
        SGR_URE_GetRatingsResponse.URE_TierRate sam3 = new SGR_URE_GetRatingsResponse.URE_TierRate();
        sam3.ACAFees = 12;
        sam3.grossPremium = 13;
        sam3.tier = '123';
        tirList.add(sam3);
        
        
        List<SGR_URE_GetRatingsResponse.URE_TierResult> tiResList = new List<SGR_URE_GetRatingsResponse.URE_TierResult>();
        SGR_URE_GetRatingsResponse.URE_TierResult sam4 = new SGR_URE_GetRatingsResponse.URE_TierResult();
        sam4.tierRate = tirList;
        sam4.type = 1;
        tiResList.add(sam4);
        
        
        List<SGR_URE_GetRatingsResponse.URE_CompositeRate> comList = new List<SGR_URE_GetRatingsResponse.URE_CompositeRate>();
        SGR_URE_GetRatingsResponse.URE_CompositeRate sam5 = new SGR_URE_GetRatingsResponse.URE_CompositeRate();
        sam5.tierResult = tiResList;
        comList.add(sam5);
        
        List<SGR_URE_GetRatingsResponse.URE_OptionResult> optionResultList = new List<SGR_URE_GetRatingsResponse.URE_OptionResult>();
        SGR_URE_GetRatingsResponse.URE_OptionResult optionResult = new SGR_URE_GetRatingsResponse.URE_OptionResult();
        List<SGR_URE_GetRatingsResponse.URE_OptionDetail> oplist = new List<SGR_URE_GetRatingsResponse.URE_OptionDetail>();
        SGR_URE_GetRatingsResponse.URE_OptionDetail sam6 = new SGR_URE_GetRatingsResponse.URE_OptionDetail();
        sam6.areaFactorClass = '1234';
        sam6.benefitName = '456';
        sam6.benefitType = '789';
        oplist.add(sam6);
        optionResult.optionDetails = oplist;
        optionResultList.add(optionResult);
        
        List<SGR_URE_GetRatingsResponse.URE_PlanRateResult> plRatRest = new List<SGR_URE_GetRatingsResponse.URE_PlanRateResult>();
        SGR_URE_GetRatingsResponse.URE_PlanRateResult sam7 = new SGR_URE_GetRatingsResponse.URE_PlanRateResult();
        sam7.areaResults = arRatList;
        sam7.compositeRateResults = comList;
        sam7.coverageCode = '12334';
        sam7.demographicFactorClass = '12345';
        sam7.optionResults = optionResultList;
        sam7.planId = 'TESTETS';
        sam7.rateSize = 'A';
        plRatRest.add(sam7);
        
        SGR_URE_GetRatingsResponse response = (SGR_URE_GetRatingsResponse)JSON.deserialize(mockResBody, SGR_URE_GetRatingsResponse.class);
        list<SGR_URE_GetRatingsResponse> responseList = new list<SGR_URE_GetRatingsResponse>();
        responseList.add(response); 
         resMap.put('17511',responseList);
        //SGR_URE_GetAgeRateshelper.getUREGenericResponse(soc,'01/01/2019','A','2864736er46347rr',1,'RenewalsSalesForce','IL1','SG',false,'17511',null,null,null,'384784',system.now());
       finalAreaHdrLst = SGR_URE_GetAgeRateshelper.processRatingResponse(responseList,'17511',System.today(),'SG','IL1');
        SGR_URE_GetAgeRateshelper.generateAgeRateTables(lstAgeRateDrivers,renewDate,'Dental',1,'RenewalsSalesForce','SG',false);
        SGR_URE_GetAgeRateshelper.createAgeRateDetailRecords(strMap, plRatRest,'NonDental','17511');
    }
    
    @isTest
    public static void testGenericResposne(){
        List<SGR_Opportunity_Census__c> censusList = new List<SGR_Opportunity_Census__c>();
        SGR_Opportunity_Census__c census = new SGR_Opportunity_Census__c();
        census.Dental_Plan_ID__c = 'Test';
        census.Employee_Status_Code__c = 'TESTTEST';
        census.First_Name__c = 'TESTETS';
        census.Group_Number__c = '123456';
        census.Health_Plan_ID__c = 'ETSTES';
        census.Member_Characteristic_Type__c = 'TETSTE';
        census.Gender__c = 'M';
        census.Relationship__c = 'Subscriber';
        census.Zip_Code__c = 'ZIP';
        census.Date_of_Birth__c = system.today();
        census.Vision_Plan_ID__c = '98574395';
        censusList.add(census);
        insert censusList;
        	
        
         List<String> type = new List<String>();
         type.add('Type1');
         List<String> tasks = new List<String>();
         tasks.add('task1');
         tasks.add('tasks2');
         List<String> planId = new List<String>();
         planId.add('4738264');
        SGR_URE_GetAgeRateshelper.getUREGenericResponse(censusList,'01/01/2019','A','2864736er46347rr',1,'RenewalsSalesForce','IL1','SG',false,'17511',planId,tasks,type,'384784',system.now());
    }
    
}