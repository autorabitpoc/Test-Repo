/*************************************************************************************************
	Class Name: SGR_URE_OppRatingOpt2And3CmptBatch.cls
	Created By: Cesar Murcia
	Description: Batch Process to compute rating for Option 2 and Option 3 plans. Runs ater
			     The alternate plans are rated.
**************************************************************************************************/
global class SGR_URE_OppRatingOpt2And3CmptBatch implements Database.Batchable<sObject> {
	
	String query = 'SELECT Id, Renewal_Date__c, HCSC_Division__c, Account_Market_Segment__c FROM Opportunity WHERE Id IN :opportunityIds';
	List<Id> opportunityIds;
	Set<String> planIds;
	String planType;
	List<SGR_URE_GetRatingsResponse> ureResponse;
	String invalidParamName = '';
	
	global SGR_URE_OppRatingOpt2And3CmptBatch(List<SGR_URE_GetRatingsResponse> ureResponse, List<Id> opportunityIds, Set<String> planIds, String planType) {
			if(ureResponse == null)
				invalidParamName = 'ureResponse';
			
			if(opportunityIds == null)
				invalidParamName = String.IsEmpty(invalidParamName) ? 'opportunityIds' : invalidParamName + ', opportunityIds' ;

			if(planIds == null)
				invalidParamName = 'planIds';

			if(planType == null)
				invalidParamName = 'planType';
			
			if(!String.IsEmpty(invalidParamName)) {
				NUllPointerException invalidParamEx = new NUllPointerException();
				invalidParamEx.setMessage(String.format('Parameters cannot be null : {0}', new String[] {invalidParamName}));
				throw invalidParamEx;
			}

			this.opportunityIds = opportunityIds;
			this.planIds = planIds; 
			this.planType = planType;
			this.ureResponse = ureResponse;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
		   Set<String> MarketSegments = new Set<String>(); 
		   Set<String> Divisions = new Set<String>();
		   Map<Id, Id> Plan_Option2 = new Map<Id, Id>();
		   Map<Id, Id> Plan_Option3 = new Map<Id, Id>();
		   Map<String, List<SGR_Lowest_Cost_Plan_Option__c>> lowesCostListMap = new Map<String, List<SGR_Lowest_Cost_Plan_Option__c>>();
		   List<SGR_Lowest_Cost_Plan_Option__c> lowCostList;

		   for(Opportunity oppty : scope){
			   MarketSegments.add(oppty.Account_Market_Segment__c);
			   Divisions.add(oppty.HCSC_Division__c);
		   }

		   	List<SGR_Opportunity_Plan_Rate__c> opptyPlanRates  = [	SELECT 	 Id, Plan__c, Plan__r.Marketing_Plan_Number__c, Opportunity__c, 
			   																Opportunity__r.HCSC_Division__c, Opportunity__r.Renewal_Date__c,  Opportunity__r.Account_Market_Segment__c
																	FROM 	SGR_Opportunity_Plan_Rate__c 
																	WHERE 	Opportunity__c IN :this.opportunityIds AND 
																	Plan__r.Marketing_Plan_Number__c IN : this.planIds AND 
																	Type__c = :this.planType ];

		   List<SGR_Lowest_Cost_Plan_Option__c> lowesCostList = [ 
			   			SELECT Id, LowestCostOption2__c, LowestCostOption3__c, MarketSegment__c, Division__c, RenewalEffectiveDate__c
					    FROM SGR_Lowest_Cost_Plan_Option__c
						WHERE MarketSegment__c IN :MarketSegments AND Division__c IN :Divisions 
						ORDER By RenewalEffectiveDate__c DESC
		   	];
			String key = '';
			for(SGR_Lowest_Cost_Plan_Option__c opt : lowesCostList){
				key = opt.MarketSegment__c + '_' +  opt.Division__c; 
				if(lowesCostListMap.containsKey(key)) {
					lowesCostListMap.get(key).add(opt);
				}
				else {
					lowCostList = new List<SGR_Lowest_Cost_Plan_Option__c>();
					lowCostList.add(opt);
					lowesCostListMap.put(key, lowCostList);
				}
			}

			for(SGR_Opportunity_Plan_Rate__c pr: opptyPlanRates) {
				key = pr.Opportunity__r.Account_Market_Segment__c + '_' +  pr.Opportunity__r.HCSC_Division__c; 
				if(lowesCostListMap.containsKey(key)){
					List<SGR_Lowest_Cost_Plan_Option__c> lowesCostTempList = lowesCostListMap.get(key);
					for(SGR_Lowest_Cost_Plan_Option__c opt : lowesCostTempList){
						if(pr.Opportunity__r.Renewal_Date__c >= opt.RenewalEffectiveDate__c){
							if(!Plan_Option2.containsKey(pr.Id))
								Plan_Option2.put(pr.Id, opt.LowestCostOption2__c);

							if(!Plan_Option3.containsKey(pr.Id))
								Plan_Option3.put(pr.Id, opt.LowestCostOption3__c);
						}
					}
				}
			}

			SGR_URE_OpptyCompAndAgeRatingUtility.OpportunityCompositeRateModel opptyRateModel = SGR_URE_OpptyCompAndAgeRatingUtility.ComputeOptionPlansForRenewingPlans(Plan_Option2, Plan_Option3, opptyPlanRates);

			upsert opptyRateModel.opptyPlanRates;
			upsert opptyRateModel.memberRates;
			
	}
	
	global void finish(Database.BatchableContext BC) {
		/* do nothing */
	}
	
}