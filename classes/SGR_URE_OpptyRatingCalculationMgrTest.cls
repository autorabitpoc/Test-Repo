@isTest
private class SGR_URE_OpptyRatingCalculationMgrTest {
	
	@isTest static void CanInstatiateManagerForSGR_URE_OpptyCompAndAgeRatingCalc_Impl() {
		// Implement test code
		try { 
			SGR_URE_OpptyRatingCalculationManager manager = new SGR_URE_OpptyRatingCalculationManager('OpptyCompAndAgeRatingCalc');
			System.assert(true);
		}
		catch(SGR_URE_OpptyRatingCalculationManager.NameException ex) {
			System.assert(false);
		}
	}

	@isTest static void CanInvokeSGR_URE_OpptyCompAndAgeRatingCalc_Impl_calculateRates() {
		Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opptyCalloutInfoMap = new Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo>();
		List<Id> opptyIds = new List<Id>();
		Set<String> plans = new Set<String>();

		try { 
			
			SGR_URE_OpptyRatingCalculationManager manager = new SGR_URE_OpptyRatingCalculationManager('OpptyCompAndAgeRatingCalc');
			manager.calculateRates(opptyIds, plans, opptyCalloutInfoMap);
			System.assert(true);
		}
		catch(SGR_URE_OpptyRatingCalculationManager.NameException ex) {
			System.assert(false);
		}
	}

	@isTest static void CanNotInvokeSGR_URE_OpptyCompAndAgeRatingCalc_Impl_calculateRatesNullParams() {
		List<SGR_URE_GetRatingsResponse> response = new List<SGR_URE_GetRatingsResponse>();
		List<Id> opptyIds = new List<Id>();
		Set<String> plans = new Set<String>();

		try { 
			
			SGR_URE_OpptyRatingCalculationManager manager = new SGR_URE_OpptyRatingCalculationManager('OpptyCompAndAgeRatingCalc');
			manager.calculateRates(opptyIds, plans, null);
			System.assert(true);
		}
		catch(SGR_URE_OpptyRatingCalculationManager.NameException ex) {
			System.assert(false);
		}
		catch(NUllPointerException ex) {
			System.assert(true);
		}
	}
	
	@isTest static void CanInstatiateManagerForSGR_URE_NonExisting_Impl() {
		// Implement test code
		try { 
			SGR_URE_OpptyRatingCalculationManager manager = new SGR_URE_OpptyRatingCalculationManager('NonExisting');
			System.assert(false);
		}
		catch(SGR_URE_OpptyRatingCalculationManager.NameException ex) {
			System.assert(true);
		}
	}
	
}