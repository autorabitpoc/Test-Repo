/*************************************************************************************************
	Class Name: SGR_URE_OpptyCompAndAgeRatingCalc_Impl.cls
	Created By: Cesar Murcia
	Description: Implementation of SGR_URE_OpptyRatingCalculationService. Starts the batch process
				 responsible for opportunity rating (Plan and member benefits rating).
**************************************************************************************************/
global class SGR_URE_OpptyCompAndAgeRatingCalc_Impl implements SGR_URE_OpptyRatingCalculationService {
	Boolean isBatchExecutedSuccessfully = false;
	public void calculateRates(List<Id> opptyIdList, Set<String> PlanIdList, Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opptyCalloutInfoMap) {
		try
		{
			List<SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> ureCalloutInfo = opptyCalloutInfoMap.values();

			List<SGR_URE_GetRatingsResponse> ureResponse = new List<SGR_URE_GetRatingsResponse>();

			for(SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo ci : ureCalloutInfo) {
				if(ci.Success)
					ureResponse.add(ci.ureResponse);
			}

			SGR_URE_OpptyRatingComputationBatch opptyRatingRenewing = new SGR_URE_OpptyRatingComputationBatch(ureResponse, opptyIdList, PlanIdList, SGR_URE_RatingOption.RENEWING_PLAN_TYPE); 


			if(!Test.IsRunningTest()) {
				Id renewingBatchId = Database.executeBatch(opptyRatingRenewing);
			}

			isBatchExecutedSuccessfully = true;
		}
		catch(Exception ex){
			isBatchExecutedSuccessfully = false;
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_OpptyCompAndAgeRatingCalc_Impl', null, 'SGR_URE_OpptyCompAndAgeRatingCalc_Impl.calculateRates', 'High');
			throw ex;
		}
		
	}

	public Boolean isSuccess() {return isBatchExecutedSuccessfully;}
	

}