/*************************************************************************************************
	Class Name: SGR_URE_OpptyRatingComputationBatch.cls
	Created By: Cesar Murcia
	Description: Batch Class to process the URE Response to compute plan composite rates and 
				 member composite/age rates
**************************************************************************************************/
public class SGR_URE_OpptyRatingComputationBatch implements Database.Batchable<sObject>, Database.Stateful {

		List<Id> opportunityIds;
	    Set<String> planIds;
	    String planType;
		List<SGR_URE_GetRatingsResponse> ureResponse;
		String invalidParamName = '';

		String query = 'SELECT 	 Id, Plan__c, Plan__r.Marketing_Plan_Number__c, Plan__r.Line_Of_Business__c, Opportunity__c, Opportunity__r.HCSC_Division__c, ' + 
								' Opportunity__r.Renewal_Date__c, ACA_Fee__c, Member_Premium__c, Rate_Type_Code__c ' +
								' ,(SELECT Id, Tier_Code__c ' +
						 		' FROM Opportunity_Plan_Composite_Rate__r ' +
						 		' LIMIT 200) ' +
								' FROM 	SGR_Opportunity_Plan_Rate__c ' +
								' WHERE 	Opportunity__c IN :opportunityIds AND ' +
								' Plan__r.Marketing_Plan_Number__c IN : planIds AND ' +
								' Type__c = :planType ';

		public SGR_URE_OpptyRatingComputationBatch(List<SGR_URE_GetRatingsResponse> ureResponse, List<Id> opportunityIds, Set<String> planIds, String planType) 
		{
			if(ureResponse == null)
				{invalidParamName = 'ureResponse';}
			
			if(opportunityIds == null)
				{invalidParamName = String.IsEmpty(invalidParamName) ? 'opportunityIds' : invalidParamName + ', opportunityIds' ;}

			if(planIds == null)
				{invalidParamName = 'planIds';}

			if(planType == null)
				{invalidParamName = 'planType';}
			
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

		public Database.QueryLocator start( Database.BatchableContext bc) {  			
			return Database.getQueryLocator(this.query);
		}

		public void execute(Database.BatchableContext BC, List<SGR_Opportunity_Plan_Rate__c> scope) { 
			try {
				SGR_URE_OpptyCompAndAgeRatingUtility.OpportunityCompositeRateModel opptyRateModel = SGR_URE_OpptyCompAndAgeRatingUtility.ComputeCompositeAndAgeRates(this.ureResponse, scope, this.planType);
				System.debug('SGR_URE_OpptyRatingComputationBatch :: Inserting rates for Plan Rate Type: ' + this.planType);
				upsert opptyRateModel.opptyPlanCompositeRates;
				upsert opptyRateModel.opptyPlanRates;
				upsert opptyRateModel.memberRates;
				if(this.planType == SGR_URE_RatingOption.RENEWING_PLAN_TYPE)
					update opptyRateModel.opptyToUpdateList;
			}
			catch(Exception ex){
				CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_OpptyRatingComputationBatch', 
							null, 'SGR_URE_OpptyRatingComputationBatch.execute', 'High');
			}

		}

		public void finish(Database.BatchableContext BC) { 
			/* compute Alternate plans */
			if(this.planType == SGR_URE_RatingOption.RENEWING_PLAN_TYPE) {
				SGR_URE_OpptyRatingComputationBatch opptyRatingAlternate = new SGR_URE_OpptyRatingComputationBatch(this.ureResponse, this.opportunityIds, this.planIds, SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE); 
				Database.executeBatch(opptyRatingAlternate); 
			}
			/* compute Option 2, 3 for Renewal */
			if(this.planType == SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE) {
				/* Compute Option Plans for renewing */ 
				SGR_URE_OppRatingOpt2And3CmptBatch opptyRatingRenewing = new SGR_URE_OppRatingOpt2And3CmptBatch(this.ureResponse, this.opportunityIds, this.planIds, SGR_URE_RatingOption.RENEWING_PLAN_TYPE);
				Database.executeBatch(opptyRatingRenewing); 
			}
		}
}