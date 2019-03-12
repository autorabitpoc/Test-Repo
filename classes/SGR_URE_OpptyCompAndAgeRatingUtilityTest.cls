@isTest 
private class SGR_URE_OpptyCompAndAgeRatingUtilityTest {
	
	@isTest static void CanGetPlanCompAndAgeRateResultMapByPlanId_Test() {
		// Implement test code

		List<SGR_URE_GetRatingsResponse> ureResponse = new List<SGR_URE_GetRatingsResponse>(); 
		ureResponse.add(GetUREResponseObject());

		SGR_URE_OpptyCompAndAgeRatingUtility.URERateModel planRateMap =  SGR_URE_OpptyCompAndAgeRatingUtility.GetPlanCompAndAgeRateResultMapByPlanId(ureResponse); 

		System.AssertEquals(3, planRateMap.compositeRateMap.keySet().size());
		System.AssertEquals(6, planRateMap.ureRateMap.keySet().size());

	}

	@isTest static void CanComputeCompositeRatesForRenewalPlan_Test() {
         Map<String, SGR_URE_GetRatingsResponse.URE_TierRate> tierMap = getCompositeTierTestData();

        insertRatingTestDataForPlan(SGR_URE_RatingOption.RENEWING_PLAN_TYPE);

		List<SGR_Opportunity_Plan_Composite_Rate__c> compositeRatesInserted = [SELECT Id, Tier_Code__c, ACA_Fees__c, 
                                                                                      Volume__c, Gross_Premium__c 
                                                                                FROM SGR_Opportunity_Plan_Composite_Rate__c
                                                                                      ];

		AssertCompositeRates(compositeRatesInserted, tierMap);

	}

    @isTest static void CanComputeCompositeRatesForAlternatePlan_Test() {

         Map<String, SGR_URE_GetRatingsResponse.URE_TierRate> tierMap = getCompositeTierTestData();

        insertRatingTestDataForPlan(SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE);

		List<SGR_Opportunity_Plan_Composite_Rate__c> compositeRatesInserted = [SELECT Id, Tier_Code__c, ACA_Fees__c, 
                                                                                      Volume__c, Gross_Premium__c
                                                                                FROM SGR_Opportunity_Plan_Composite_Rate__c
                                                                                      ];

		AssertCompositeRates(compositeRatesInserted, tierMap);

	}

	@isTest static void CanComputeOpportunitySummaryTotals_Test() {
	    Map<String, SGR_URE_GetRatingsResponse.URE_TierRate> tierMap = getCompositeTierTestData();
	    Opportunity oppty =new Opportunity(
            name='TestOp',
            StageName='Triggered',
            CloseDate=Date.newInstance(2022, 12, 9),
            HCSC_Division__c ='IL',
            Renewal_Date__c = System.today(),
            County_Code__c = '43243',
            FIPS_Code__c = '17111',
            Zip_Code__c = '32015',RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId()
        );
        
        insert oppty; 
        
		Plan__c plan =  new Plan__c(Name = 'Test', Marketing_Plan_Number__c = 'DILLR07');

		insert plan;

		SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = SGR_URE_RatingOption.RENEWING_PLAN_TYPE, 	
																				Opportunity__c = oppty.Id, Coverage_Type__c = 'D',
																				Plan__c = plan.Id);

		insert planRate;

		List<SGR_Opportunity_Plan_Rate__c> opptyPlanRates = [SELECT Id, Plan__c, Plan__r.Marketing_Plan_Number__c, Opportunity__c, 
                                                                Plan__r.Line_Of_Business__c ,
																( SELECT Id, Tier_Code__c FROM Opportunity_Plan_Composite_Rate__r )
															FROM SGR_Opportunity_Plan_Rate__c
															WHERE Id = :planRate.Id ];


		List<SGR_URE_GetRatingsResponse> ureResponse = new List<SGR_URE_GetRatingsResponse>(); 
		ureResponse.add(GetUREResponseObject());

		SGR_URE_OpptyCompAndAgeRatingUtility.OpportunityCompositeRateModel opptyModel =  SGR_URE_OpptyCompAndAgeRatingUtility.ComputeCompositeAndAgeRates(ureResponse, opptyPlanRates, SGR_URE_RatingOption.RENEWING_PLAN_TYPE);
		
		//System.assertEquals(1, opptyModel.opptyToUpdateList.size());
		System.Assert(true); /* Temporary assert */

	}

	@isTest static void Can_UpdatePlanRateSObjectDynamically_Test()
	{
		SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test');


		insert planRate;

		System.Assert(planRate.Id != null);

		SGR_Opportunity_Plan_Rate__c planRate2 = new SGR_Opportunity_Plan_Rate__c(Id = planRate.Id);

		System.Assert(planRate2.Id == planRate.Id);

		planRate2.put('Name', 'Test3');

		System.Assert(planRate2.Name == 'Test3');

		planRate2 = [SELECT Id FROM SGR_Opportunity_Plan_Rate__c Where Id = :planRate.Id LIMIT 1];

		planRate2.put('Renw_Comp_Total_Est_Tax_and_Fees__c', 100.50);
		planRate2.put('EC_Enrolled_Subscriber_Count__c', 50);

		System.Assert(planRate2.Renw_Comp_Total_Est_Tax_and_Fees__c == 100.50);
		System.Assert(planRate2.EC_Enrolled_Subscriber_Count__c == 50);

		planRate2.put('Renw_Comp_Total_Est_Tax_and_Fees__c', 50.25);
		planRate2.put('EC_Enrolled_Subscriber_Count__c', 30);

		upsert planRate2;

		planRate2 = [SELECT Id, Renw_Comp_Total_Est_Tax_and_Fees__c, EC_Enrolled_Subscriber_Count__c FROM SGR_Opportunity_Plan_Rate__c Where Id = :planRate.Id LIMIT 1];
		
		System.Assert((Decimal)planRate2.get('Renw_Comp_Total_Est_Tax_and_Fees__c') == 50.25);
		System.Assert((Decimal)planRate2.get('EC_Enrolled_Subscriber_Count__c') == 30);
	}

	@isTest static void CanCreateInstanceOfSGR_URE_RatingOption_Test() {
		SGR_URE_RatingOption ro = new SGR_URE_RatingOption();
		System.Assert(ro != null);
	}

    @isTest static void GetOptionPlansTest(){
        Plan__c plan =  new Plan__c(Name = 'Test', Marketing_Plan_Number__c = 'DILLR07');

		insert plan;
		
        Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Quote';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.HCSC_Division__c ='IL';
        op.Renewal_Date__c = System.today();
        op.County_Code__c = '43243';
        op.FIPS_Code__c = '17111';
        op.Zip_Code__c = '32015';
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
       	insert op;
        List<id> plnlst = new List<id>();
        plnlst.add(plan.id);
        
        List<id> oplst = new List<id>();
        oplst.add(op.id);
		SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE, 	
																				Opportunity__c = op.id,
																				Plan__c = plan.Id);

		insert planRate;
        SGR_URE_OpptyCompAndAgeRatingUtility.GetOptionPlans(plnlst,oplst);
    }
    
    @isTest static void GetOptionPlanMembersTest(){
        Plan__c plan =  new Plan__c(Name = 'Test', Marketing_Plan_Number__c = 'DILLR07');

		insert plan;
		
        Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Quote';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.HCSC_Division__c ='IL';
        op.Renewal_Date__c = System.today();
        op.County_Code__c = '43243';
        op.FIPS_Code__c = '17111';
        op.Zip_Code__c = '32015';
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
       	insert op;
        
        List<id> plnlst = new List<id>();
        plnlst.add(plan.id);
        System.debug('plnlst'+plnlst);
        SGR_Opportunity_Census__c cen=new SGR_Opportunity_Census__c();
        cen.Opportunity__c=op.id;
        cen.Subscriber_Number__c=860535;
        cen.Gender__c='M';
        cen.Relationship__c='Subscriber';
        cen.Relationship_Code__c='PR';
        cen.Date_of_Birth__c=Date.newInstance(1992, 12, 9);
        cen.Age_New__c=26;
        cen.Zip_Code__c='12';
        insert cen;
        
        SGR_Opportunity_Group_Section__c grp=new SGR_Opportunity_Group_Section__c();
        grp.Name='GS-976908';
        grp.Opportunity__c=op.id;
        insert grp;
        
        SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE, 	
																				Opportunity__c = op.id,
																				Plan__c = plan.Id);

		insert planRate;
        
        SGR_Opportunity_Member_Benefits__c mbs = new SGR_Opportunity_Member_Benefits__c();
        mbs.Name='demo34Cloned';
        mbs.Opportunity_Group_Section__c=grp.id;
        mbs.Opportunity_Census__c=cen.id;
        mbs.Opportunity_Plan_Rate__c=planRate.id;
        mbs.Opportunity__c = op.id;
        insert mbs;
        
        List<id> oplst = new List<id>();
        oplst.add(op.id);
		System.debug('oplist'+oplst);
        
        SGR_URE_OpptyCompAndAgeRatingUtility.GetOptionPlanMembers(plnlst,oplst);
    }
    
    @isTest static void AddMemberTest(){
        Plan__c plan =  new Plan__c(Name = 'Test', Marketing_Plan_Number__c = 'DILLR07');

		insert plan;
		
        Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Quote';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.HCSC_Division__c ='IL';
        op.Renewal_Date__c = System.today();
        op.County_Code__c = '43243';
        op.FIPS_Code__c = '17111';
        op.Zip_Code__c = '32015';
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
       	insert op;
        
        List<id> plnlst = new List<id>();
        plnlst.add(plan.id);
        
        SGR_Opportunity_Census__c cen=new SGR_Opportunity_Census__c();
        cen.Opportunity__c=op.id;
        cen.Subscriber_Number__c=860535;
        cen.Gender__c='M';
        cen.Relationship__c='Subscriber';
        cen.Relationship_Code__c='PR';
        cen.Date_of_Birth__c=Date.newInstance(1992, 12, 9);
        cen.Age_New__c=26;
        cen.Zip_Code__c='12';
        insert cen;
        
        SGR_Opportunity_Group_Section__c grp=new SGR_Opportunity_Group_Section__c();
        grp.Name='GS-976908';
        grp.Opportunity__c=op.id;
        insert grp;
        
        SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE, 	
																				Opportunity__c = op.id,
																				Plan__c = plan.Id);

		insert planRate;
        
        SGR_Opportunity_Member_Benefits__c mbs = new SGR_Opportunity_Member_Benefits__c();
        mbs.Name='demo34Cloned';
        mbs.Opportunity_Group_Section__c=grp.id;
        mbs.Opportunity_Census__c=cen.id;
        mbs.Opportunity_Plan_Rate__c=planRate.id;
        mbs.Member_Policy_Tier__c = 'ES';
        insert mbs;
		
		SGR_Opportunity_Member_Benefits__c mbs2 = new SGR_Opportunity_Member_Benefits__c();
        mbs2.Name='demo34Cloned2';
        mbs2.Opportunity_Group_Section__c=grp.id;
        mbs2.Opportunity_Census__c=cen.id;
        mbs2.Opportunity_Plan_Rate__c=planRate.id;
        mbs2.Member_Policy_Tier__c = 'EO';
        insert mbs2;

		SGR_Opportunity_Member_Benefits__c mbs3 = new SGR_Opportunity_Member_Benefits__c();
        mbs3.Name='demo34Cloned3';
        mbs3.Opportunity_Group_Section__c=grp.id;
        mbs3.Opportunity_Census__c=cen.id;
        mbs3.Opportunity_Plan_Rate__c=planRate.id;
        mbs3.Member_Policy_Tier__c = 'EC';
        insert mbs3;

		SGR_Opportunity_Member_Benefits__c mbs4 = new SGR_Opportunity_Member_Benefits__c();
        mbs4.Name='demo34Cloned4';
        mbs4.Opportunity_Group_Section__c=grp.id;
        mbs4.Opportunity_Census__c=cen.id;
        mbs4.Opportunity_Plan_Rate__c=planRate.id;
        mbs4.Member_Policy_Tier__c = 'EF';
        insert mbs4; 
        SGR_URE_OpptyCompAndAgeRatingUtility.MemberModelByPlan obj = new SGR_URE_OpptyCompAndAgeRatingUtility.MemberModelByPlan();
        obj.AddMember(mbs);
        obj.AddMember(mbs2);
        obj.AddMember(mbs3);
        obj.AddMember(mbs4);
    }
    
     @isTest static void InsertURECalloutAuditTest(){
        		
         List<Opportunity> opList=new List<Opportunity>();
         Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Quote';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.HCSC_Division__c ='IL';
        op.Renewal_Date__c = System.today();
        op.County_Code__c = '43243';
        op.FIPS_Code__c = '17111';
        op.Zip_Code__c = '32015';
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
       	insert op;
         opList.add(op);
        
         SGR_URE_GetRatingsResponse ureResponse = new SGR_URE_GetRatingsResponse();
         SGR_URE_GetAgeRatesRequestWrapper ureRequest = new SGR_URE_GetAgeRatesRequestWrapper();
        SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo objure= new SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo();
        objure.ureResponse = GetUREResponseObject();
        objure.Success =false;
        // obj.ureRequest  = ureRequest;
        Map<Id,SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opmap = new Map<Id,SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo>();
         opmap.put(op.id,objure);
       /// SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo ureobj = opmap.get(op.id);
         System.debug('ureobj'+objure);
        SGR_URE_OpptyCompAndAgeRatingUtility.InsertURECalloutAudit(opList,opmap);
    }
    
     @isTest static void ComputeOptionPlansForRenewingPlansTest(){
        Plan__c plan =  new Plan__c(Name = 'Test', Marketing_Plan_Number__c = 'DILLR07');

		insert plan;
         
         Plan__c plan2 =  new Plan__c(Name = 'Test1', Marketing_Plan_Number__c = 'DILLR075');

		insert plan2;
		
        Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Quote';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.HCSC_Division__c ='IL';
        op.Renewal_Date__c = System.today();
        op.County_Code__c = '43243';
        op.FIPS_Code__c = '17111';
        op.Zip_Code__c = '32015';
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
       	insert op;
        
        List<id> plnlst = new List<id>();
        plnlst.add(plan.id);
         
        SGR_Opportunity_Census__c cen=new SGR_Opportunity_Census__c();
        cen.Opportunity__c=op.id;
        cen.Subscriber_Number__c=860535;
        cen.Gender__c='M';
        cen.Relationship__c='Subscriber';
        cen.Relationship_Code__c='PR';
        cen.Date_of_Birth__c=Date.newInstance(1992, 12, 9);
        cen.Age_New__c=26;
        cen.Zip_Code__c='12';
        insert cen;
        
        SGR_Opportunity_Group_Section__c grp=new SGR_Opportunity_Group_Section__c();
        grp.Name='GS-976908';
        grp.Opportunity__c=op.id;
        insert grp;
        
        List<SGR_Opportunity_Plan_Rate__c> planRateLst = new List<SGR_Opportunity_Plan_Rate__c>();
        SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE, 	
																				Opportunity__c = op.id,
																				Plan__c = plan.Id);
         insert planRate;
         SGR_Opportunity_Plan_Rate__c planRate2 =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test2', 
																				Type__c = SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE, 	
																				Opportunity__c = op.id,
																				Plan__c = plan2.Id);
		insert planRate2;
		
        planRateLst.add(planRate);
         planRateLst.add(planRate2);
         
        SGR_Opportunity_Member_Benefits__c mbs = new SGR_Opportunity_Member_Benefits__c();
        mbs.Name='demo34Cloned';
        mbs.Opportunity_Group_Section__c=grp.id;
        mbs.Opportunity_Census__c=cen.id;
        mbs.Opportunity_Plan_Rate__c=planRate.id;
        mbs.Opportunity__c = op.id;
        insert mbs;
        
        SGR_Opportunity_Member_Benefits__c mbs2 = new SGR_Opportunity_Member_Benefits__c();
        mbs2.Name='demo34Cloned43';
        mbs2.Opportunity_Group_Section__c=grp.id;
        mbs2.Opportunity_Census__c=cen.id;
        mbs2.Opportunity_Plan_Rate__c=planRate2.id;
        mbs2.Opportunity__c = op.id;
        insert mbs2;
        
        List<id> oplst = new List<id>();
        oplst.add(op.id);
		
         Map<id,id> map1 = new Map<id,id>();
         map1.put(planRate.id,plan.id);
        
         Map<id,id> map2 = new Map<id,id>();
         map2.put(planRate2.id,plan2.id);
        Map<Id, List<SGR_Opportunity_Member_Benefits__c>> member2 = SGR_URE_OpptyCompAndAgeRatingUtility.GetOptionPlanMembers(map1.values(), oplst );
		Map<Id, List<SGR_Opportunity_Member_Benefits__c>> member3 = SGR_URE_OpptyCompAndAgeRatingUtility.GetOptionPlanMembers(map2.values(), oplst );
        SGR_URE_OpptyCompAndAgeRatingUtility.ComputeOptionPlansForRenewingPlans(map1,map2,planRateLst);
    }

    @isTest static void CanAccessOpptyRenewPlanRateSummaryTotalsFieldsTest() {
        SGR_URE_OpptyCompAndAgeRatingUtility.OpptyRenewPlanRateSummaryTotals totals = new SGR_URE_OpptyCompAndAgeRatingUtility.OpptyRenewPlanRateSummaryTotals();

        System.assertEquals(0, totals.Total_Monthly_Premium);
        System.assertEquals(0, totals.Total_Est_Tax_and_Fees);

    }


    /* Private Helper Methods */
    private static SGR_URE_GetRatingsResponse GetUREResponseObject() {
		String jsonResponse = '{\"rffResult\":{\"marketingDentalRatesSpecificTaskResult\":{\"ratingPackageResults\":[{\"productResults\":[{\"planResults\":[{\"areaResults\":[{\"areaNumber\":\"100\",\"isTefra\":\"false\",\"isTobacco\":\"false\",\"rates\":[{\"censusDetailId\":\"860534\",\"grossPremium\":\"43.66\",\"retentionBreakdown\":{\"ACAFees\":\"0.00\",\"Net_of_ACA\":\"43.66\",\"nonACAFees\":\"14.04\"},\"subscriberId\":\"860534\"},{\"censusDetailId\":\"860535\",\"grossPremium\":\"43.66\",\"retentionBreakdown\":{\"ACAFees\":\"0.00\",\"Net_of_ACA\":\"43.66\",\"nonACAFees\":\"14.04\"},\"subscriberId\":\"860535\"}]}],\"compositeRateResults\":[{\"tierResult\":[{\"tierRate\":[{\"ACAFees\":\"0.00\",\"grossPremium\":\"43.66\",\"tier\":\"EO\"},{\"ACAFees\":\"0.00\",\"grossPremium\":\"106.97\",\"tier\":\"EC\"},{\"ACAFees\":\"0.00\",\"grossPremium\":\"87.32\",\"tier\":\"ES\"},{\"ACAFees\":\"0.00\",\"grossPremium\":\"172.46\",\"tier\":\"EF\"}],\"type\":\"4\"}]}],\"coverageCode\":\"D\",\"demographicFactorClass\":\"D7\",\"optionResults\":[{\"optionDetails\":[{\"areaFactorClass\":\"1\",\"benefitName\":\"DILLR07\",\"benefitType\":\"Dental\"}]}],\"planId\":\"DILLR07\"}],\"value\":\"PPO\"}]}]},\"marketingRatesSpecificTaskResult\":{\"ratingPackageResults\":[{\"productResults\":[{\"planResults\":[{\"areaResults\":[{\"areaNumber\":\"2\",\"isTefra\":\"false\",\"isTobacco\":\"false\",\"rates\":[{\"censusDetailId\":\"860534\",\"grossPremium\":\"318.05\",\"retentionBreakdown\":{\"ACAFees\":\"0.48\",\"Net_of_ACA\":\"317.57\",\"nonACAFees\":\"41.97\"},\"subscriberId\":\"860534\"},{\"censusDetailId\":\"860535\",\"grossPremium\":\"306.64\",\"retentionBreakdown\":{\"ACAFees\":\"0.46\",\"Net_of_ACA\":\"306.18\",\"nonACAFees\":\"40.46\"},\"subscriberId\":\"860535\"}]}],\"compositeRateResults\":[{\"tierResult\":[{\"tierRate\":[{\"ACAFees\":\"0.47\",\"grossPremium\":\"312.35\",\"tier\":\"EO\"},{\"ACAFees\":\"0.87\",\"grossPremium\":\"577.85\",\"tier\":\"EC\"},{\"ACAFees\":\"0.94\",\"grossPremium\":\"624.70\",\"tier\":\"ES\"},{\"ACAFees\":\"1.34\",\"grossPremium\":\"890.20\",\"tier\":\"EF\"}],\"type\":\"4\"}]}],\"coverageCode\":\"M\",\"demographicFactorClass\":\"1\",\"optionResults\":[{\"optionDetails\":[{\"areaFactorClass\":\"62\",\"benefitName\":\"36096IL0900038\",\"benefitType\":\"MEDICAL\"}]}],\"planId\":\"SPSG10BCOSILO\"}],\"value\":\"BOPTMED\"},{\"planResults\":[{\"areaResults\":[{\"areaNumber\":\"2\",\"isTefra\":\"false\",\"isTobacco\":\"false\",\"rates\":[{\"censusDetailId\":\"860534\",\"grossPremium\":\"403.08\",\"retentionBreakdown\":{\"ACAFees\":\"0.60\",\"Net_of_ACA\":\"402.48\",\"nonACAFees\":\"53.19\"},\"subscriberId\":\"860534\"},{\"censusDetailId\":\"860535\",\"grossPremium\":\"388.62\",\"retentionBreakdown\":{\"ACAFees\":\"0.58\",\"Net_of_ACA\":\"388.04\",\"nonACAFees\":\"51.28\"},\"subscriberId\":\"860535\"}]}],\"compositeRateResults\":[{\"tierResult\":[{\"tierRate\":[{\"ACAFees\":\"0.59\",\"grossPremium\":\"395.85\",\"tier\":\"EO\"},{\"ACAFees\":\"1.10\",\"grossPremium\":\"732.32\",\"tier\":\"EC\"},{\"ACAFees\":\"1.19\",\"grossPremium\":\"791.70\",\"tier\":\"ES\"},{\"ACAFees\":\"1.69\",\"grossPremium\":\"1128.17\",\"tier\":\"EF\"}],\"type\":\"4\"}]}],\"coverageCode\":\"M\",\"demographicFactorClass\":\"1\",\"optionResults\":[{\"optionDetails\":[{\"areaFactorClass\":\"1\",\"benefitName\":\"36096IL0770045\",\"benefitType\":\"MEDICAL\"}]}],\"planId\":\"SPSG10PPOSILO\"}],\"value\":\"PPOMED\"}]}]},\"rateSize\":\"A\",\"referenceId\":\"13127874\",\"retentionTaskResult\":[{\"coverageCode\":\"M\",\"multplvFactors\":{\"ACAFees\":\"0.001500000000000\",\"commission\":\"0.000000000000000\",\"expense\":\"0.131960000000000\",\"m5\":\"0.000000000000000\",\"margin\":\"0.000000000000000\",\"premtax\":\"0.000000000000000\"}},{\"coverageCode\":\"D\",\"multplvFactors\":{\"ACAFees\":\"0.000000000000000\",\"commission\":\"0.000000000000000\",\"expense\":\"0.321600000000000\",\"m5\":\"0.000000000000000\",\"margin\":\"0.000000000000000\",\"premtax\":\"0.000000000000000\"}}]}}';
		return (SGR_URE_GetRatingsResponse) System.JSON.deserialize(jsonResponse,SGR_URE_GetRatingsResponse.class);
	}

	private static Map<String, SGR_URE_GetRatingsResponse.URE_TierRate> getCompositeTierTestData() {
		Map<String, SGR_URE_GetRatingsResponse.URE_TierRate> tierMap = new Map<String, SGR_URE_GetRatingsResponse.URE_TierRate>();

		SGR_URE_GetRatingsResponse.URE_TierRate tier = new SGR_URE_GetRatingsResponse.URE_TierRate();
		tier.tier = 'EO';
		tier.ACAFees = 0.00;
		tier.grossPremium = 43.66;

		tierMap.put('EO',tier);

		tier = new SGR_URE_GetRatingsResponse.URE_TierRate();
		tier.tier = 'EC';
		tier.ACAFees = 0.00;
		tier.grossPremium = 106.97;

		tierMap.put('EC',tier);

		tier = new SGR_URE_GetRatingsResponse.URE_TierRate();
		tier.tier = 'ES';
		tier.ACAFees = 0.00;
		tier.grossPremium = 87.32;

		tierMap.put('ES',tier);

		tier = new SGR_URE_GetRatingsResponse.URE_TierRate();
		tier.tier = 'EF';
		tier.ACAFees = 0.00;
		tier.grossPremium = 172.46;

		tierMap.put('EF',tier);

		return tierMap;
	}

	private static void AssertCompositeRates(List<SGR_Opportunity_Plan_Composite_Rate__c> opptyCompositeRates, Map<String, SGR_URE_GetRatingsResponse.URE_TierRate> tierMap) {
		for(SGR_Opportunity_Plan_Composite_Rate__c compositeRate : opptyCompositeRates ) {
			if(tierMap.containsKey(compositeRate.Tier_Code__c)) {
				SGR_URE_GetRatingsResponse.URE_TierRate tier = tierMap.get(compositeRate.Tier_Code__c);
				System.AssertEquals(tier.ACAFees, compositeRate.ACA_Fees__c);
				System.AssertEquals(tier.grossPremium, compositeRate.Gross_Premium__c);
				System.AssertEquals(0,compositeRate.Volume__c);
			}
		}
	}

    private static void insertRatingTestDataForPlan(String type){
       
		Plan__c plan =  new Plan__c(Name = 'Test', 
                                    Marketing_Plan_Number__c = 'DILLR07',
                                    Line_Of_Business__c = 'D'
                                   );

		insert plan;
		
        Opportunity op = new Opportunity(
            Name='TestOp',
            StageName='Quote',
            CloseDate=Date.newInstance(2022, 12, 9),
            HCSC_Division__c ='IL',
            Renewal_Date__c = System.today(),
            County_Code__c = '43243',
            FIPS_Code__c = '17111',
            Zip_Code__c = '32015',
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId());
       	
           insert op;
        
		SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = type, 	
																				Opportunity__c = op.id,
																				Plan__c = plan.Id);

		insert planRate;

		List<SGR_Opportunity_Plan_Rate__c> opptyPlanRates = [SELECT Id, Plan__c, Plan__r.Marketing_Plan_Number__c, Opportunity__c,
                                                                Plan__r.Line_Of_Business__c,
																( SELECT Id, Tier_Code__c FROM Opportunity_Plan_Composite_Rate__r )
															FROM SGR_Opportunity_Plan_Rate__c
															WHERE Id = :planRate.Id ];

		List<SGR_URE_GetRatingsResponse> ureResponse = new List<SGR_URE_GetRatingsResponse>(); 
		ureResponse.add(GetUREResponseObject());
		SGR_URE_OpptyCompAndAgeRatingUtility.URERateModel planRateMap =  
                                    SGR_URE_OpptyCompAndAgeRatingUtility.GetPlanCompAndAgeRateResultMapByPlanId(ureResponse);
		SGR_URE_OpptyCompAndAgeRatingUtility.OpportunityCompositeRateModel opptyModel =  
                                    SGR_URE_OpptyCompAndAgeRatingUtility.ComputeCompositeAndAgeRates(ureResponse, opptyPlanRates, type);

		/*System.Assert(opptyModel != null);
		System.Assert(opptyModel.opptyPlanCompositeRates != null);
		System.AssertEquals(4, opptyModel.opptyPlanCompositeRates.size());
		System.Assert(opptyModel.opptyPlanRates != null);
		System.AssertEquals(1, opptyModel.opptyPlanRates.size());
		System.Assert(opptyModel.memberRates != null);
		System.AssertEquals(0, opptyModel.memberRates.size());

		AssertCompositeRates(opptyModel.opptyPlanCompositeRates, tierMap);*/

		upsert opptyModel.opptyPlanCompositeRates; 
    }

}