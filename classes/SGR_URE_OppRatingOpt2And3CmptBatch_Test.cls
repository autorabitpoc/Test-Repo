@isTest
private class SGR_URE_OppRatingOpt2And3CmptBatch_Test {
	
	@isTest private static void CanNotExecuteOppRatingOpt2And3CmptBatchWithNullParameters_Test() {
		try{
			SGR_URE_OppRatingOpt2And3CmptBatch opptyBatch = 
					new SGR_URE_OppRatingOpt2And3CmptBatch(null, null, null, null); 
			System.Assert(false);
		}
		catch(NUllPointerException ex){
			System.Assert(true); /* Passed - exception was thrown */
		}

	}

	@isTest private static void CanExecuteOppRatingOpt2And3CmptBatch_Test() {
		List<Id> opptyIdList = new List<Id>();
		Set<String> planSetIds = new Set<String>();

		Plan__c plan =  new Plan__c(Name = 'Test', Marketing_Plan_Number__c = 'DILLR07');

		insert plan;
		
		planSetIds.add(plan.Marketing_Plan_Number__c);

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
        	
		   opptyIdList.add(op.Id);
        
		SGR_Opportunity_Plan_Rate__c planRate =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test', 
																				Type__c = SGR_URE_RatingOption.RENEWING_PLAN_TYPE, 	
																				Opportunity__c = op.id,
																				Plan__c = plan.Id);

		insert planRate;

		List<SGR_Opportunity_Plan_Rate__c> opptyPlanRates = [SELECT Id, Plan__c, Plan__r.Marketing_Plan_Number__c, Opportunity__c,
																( SELECT Id, Tier_Code__c FROM Opportunity_Plan_Composite_Rate__r )
															FROM SGR_Opportunity_Plan_Rate__c
															WHERE Id = :planRate.Id ];

		List<SGR_URE_GetRatingsResponse> ureResponse = new List<SGR_URE_GetRatingsResponse>(); 
		ureResponse.add(GetUREResponseObject());

		Test.startTest();
		SGR_URE_OppRatingOpt2And3CmptBatch opptyBatch = 
						new SGR_URE_OppRatingOpt2And3CmptBatch(ureResponse, opptyIdList, planSetIds, SGR_URE_RatingOption.RENEWING_PLAN_TYPE); 
			
		Id renewingBatchId = Database.executeBatch(opptyBatch);
		Test.stopTest();
	}

	/* Private helper methods */
 	private static SGR_URE_GetRatingsResponse GetUREResponseObject() {
			String jsonResponse = '{\"rffResult\":{\"marketingDentalRatesSpecificTaskResult\":{\"ratingPackageResults\":[{\"productResults\":[{\"planResults\":[{\"areaResults\":[{\"areaNumber\":\"100\",\"isTefra\":\"false\",\"isTobacco\":\"false\",\"rates\":[{\"censusDetailId\":\"860534\",\"grossPremium\":\"43.66\",\"retentionBreakdown\":{\"ACAFees\":\"0.00\",\"Net_of_ACA\":\"43.66\",\"nonACAFees\":\"14.04\"},\"subscriberId\":\"860534\"},{\"censusDetailId\":\"860535\",\"grossPremium\":\"43.66\",\"retentionBreakdown\":{\"ACAFees\":\"0.00\",\"Net_of_ACA\":\"43.66\",\"nonACAFees\":\"14.04\"},\"subscriberId\":\"860535\"}]}],\"compositeRateResults\":[{\"tierResult\":[{\"tierRate\":[{\"ACAFees\":\"0.00\",\"grossPremium\":\"43.66\",\"tier\":\"EO\"},{\"ACAFees\":\"0.00\",\"grossPremium\":\"106.97\",\"tier\":\"EC\"},{\"ACAFees\":\"0.00\",\"grossPremium\":\"87.32\",\"tier\":\"ES\"},{\"ACAFees\":\"0.00\",\"grossPremium\":\"172.46\",\"tier\":\"EF\"}],\"type\":\"4\"}]}],\"coverageCode\":\"D\",\"demographicFactorClass\":\"D7\",\"optionResults\":[{\"optionDetails\":[{\"areaFactorClass\":\"1\",\"benefitName\":\"DILLR07\",\"benefitType\":\"Dental\"}]}],\"planId\":\"DILLR07\"}],\"value\":\"PPO\"}]}]},\"marketingRatesSpecificTaskResult\":{\"ratingPackageResults\":[{\"productResults\":[{\"planResults\":[{\"areaResults\":[{\"areaNumber\":\"2\",\"isTefra\":\"false\",\"isTobacco\":\"false\",\"rates\":[{\"censusDetailId\":\"860534\",\"grossPremium\":\"318.05\",\"retentionBreakdown\":{\"ACAFees\":\"0.48\",\"Net_of_ACA\":\"317.57\",\"nonACAFees\":\"41.97\"},\"subscriberId\":\"860534\"},{\"censusDetailId\":\"860535\",\"grossPremium\":\"306.64\",\"retentionBreakdown\":{\"ACAFees\":\"0.46\",\"Net_of_ACA\":\"306.18\",\"nonACAFees\":\"40.46\"},\"subscriberId\":\"860535\"}]}],\"compositeRateResults\":[{\"tierResult\":[{\"tierRate\":[{\"ACAFees\":\"0.47\",\"grossPremium\":\"312.35\",\"tier\":\"EO\"},{\"ACAFees\":\"0.87\",\"grossPremium\":\"577.85\",\"tier\":\"EC\"},{\"ACAFees\":\"0.94\",\"grossPremium\":\"624.70\",\"tier\":\"ES\"},{\"ACAFees\":\"1.34\",\"grossPremium\":\"890.20\",\"tier\":\"EF\"}],\"type\":\"4\"}]}],\"coverageCode\":\"M\",\"demographicFactorClass\":\"1\",\"optionResults\":[{\"optionDetails\":[{\"areaFactorClass\":\"62\",\"benefitName\":\"36096IL0900038\",\"benefitType\":\"MEDICAL\"}]}],\"planId\":\"SPSG10BCOSILO\"}],\"value\":\"BOPTMED\"},{\"planResults\":[{\"areaResults\":[{\"areaNumber\":\"2\",\"isTefra\":\"false\",\"isTobacco\":\"false\",\"rates\":[{\"censusDetailId\":\"860534\",\"grossPremium\":\"403.08\",\"retentionBreakdown\":{\"ACAFees\":\"0.60\",\"Net_of_ACA\":\"402.48\",\"nonACAFees\":\"53.19\"},\"subscriberId\":\"860534\"},{\"censusDetailId\":\"860535\",\"grossPremium\":\"388.62\",\"retentionBreakdown\":{\"ACAFees\":\"0.58\",\"Net_of_ACA\":\"388.04\",\"nonACAFees\":\"51.28\"},\"subscriberId\":\"860535\"}]}],\"compositeRateResults\":[{\"tierResult\":[{\"tierRate\":[{\"ACAFees\":\"0.59\",\"grossPremium\":\"395.85\",\"tier\":\"EO\"},{\"ACAFees\":\"1.10\",\"grossPremium\":\"732.32\",\"tier\":\"EC\"},{\"ACAFees\":\"1.19\",\"grossPremium\":\"791.70\",\"tier\":\"ES\"},{\"ACAFees\":\"1.69\",\"grossPremium\":\"1128.17\",\"tier\":\"EF\"}],\"type\":\"4\"}]}],\"coverageCode\":\"M\",\"demographicFactorClass\":\"1\",\"optionResults\":[{\"optionDetails\":[{\"areaFactorClass\":\"1\",\"benefitName\":\"36096IL0770045\",\"benefitType\":\"MEDICAL\"}]}],\"planId\":\"SPSG10PPOSILO\"}],\"value\":\"PPOMED\"}]}]},\"rateSize\":\"A\",\"referenceId\":\"13127874\",\"retentionTaskResult\":[{\"coverageCode\":\"M\",\"multplvFactors\":{\"ACAFees\":\"0.001500000000000\",\"commission\":\"0.000000000000000\",\"expense\":\"0.131960000000000\",\"m5\":\"0.000000000000000\",\"margin\":\"0.000000000000000\",\"premtax\":\"0.000000000000000\"}},{\"coverageCode\":\"D\",\"multplvFactors\":{\"ACAFees\":\"0.000000000000000\",\"commission\":\"0.000000000000000\",\"expense\":\"0.321600000000000\",\"m5\":\"0.000000000000000\",\"margin\":\"0.000000000000000\",\"premtax\":\"0.000000000000000\"}}]}}';
			return (SGR_URE_GetRatingsResponse) System.JSON.deserialize(jsonResponse,SGR_URE_GetRatingsResponse.class);
	}
	
}