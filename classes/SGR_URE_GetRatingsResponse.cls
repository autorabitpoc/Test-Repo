//*************************************************************************************
// Name             : SGR_URE_GetRatingsResponse.cls
// Description      : Output Class for URE Rating service
// Created By       : Shankar
// Created Date     : 11/19/2018
// 
// ************************Version Updates********************************************
// Date         Developer   Description
// -----------------------------------------------------------------------------------
// 11/11/2018   Shankar     SFDC 14017 Initial version
// ************************************************************************************
global class SGR_URE_GetRatingsResponse {
	
	webservice URE_RateResponse rffResult;
	webservice String statusCode; 
	global class URE_RateResponse {
		webservice URE_TaskResult marketingRatesGenericTaskResult;
		webservice URE_TaskResult marketingDentalRatesGenericTaskResult;		
		webservice URE_TaskResult marketingRatesSpecificTaskResult;
		webservice URE_TaskResult marketingDentalRatesSpecificTaskResult;
	
		webservice String referenceId;
		webservice List<URE_RetentionTaskResult> retentionTaskResult;

	}
	
	
    	webservice String statusMessage;
    	webservice String errorMessage;
    	webservice String req;
    	webservice String res;
    	webservice DateTime executeStartDate;
   
    global class URE_TaskResult {
    	webservice List<URE_RatingPackageResult> ratingPackageResults;
    }
    
	
	global class URE_RatingPackageResult {
		webservice List<URE_ProductResult> productResults;
	}
	
	global class URE_ProductResult {
		webservice List<URE_PlanRateResult> planResults;
		webservice String value;
	}
	
    global class URE_PlanRateResult {
        webservice List<URE_AreaRateResult> areaResults;
        webservice List<URE_CompositeRate> compositeRateResults;
        webservice String coverageCode;
        webservice String demographicFactorClass;
        webservice List<URE_OptionResult> optionResults;
        webservice String planId;
        webservice String rateSize;
    }
	
	global class URE_AreaRateResult {
		webservice String areaNumber;
		webservice String isTefra;//Boolean
		webservice String isTobacco;//Boolean
		webservice List<URE_Rate> rates;
	}
	
	global class URE_CompositeRate {
		webservice List<URE_TierResult> tierResult;
		
	}
	
	global class URE_TierResult {
		webservice List<URE_TierRate> tierRate;
		webservice Integer type;
	}
	
	global class URE_TierRate {
		webservice Decimal ACAFees;
		webservice Decimal grossPremium;
		webservice String tier;
	}
	
	global class URE_Rate {
		webservice String fromAge;
		webservice String toAge;
		webservice String relationshipCode;
		webservice Decimal grossPremium;
		webservice URE_RetentionBreakDown retentionBreakdown;
		webservice String censusDetailId;
		webservice String subscriberId;			
	}
	
	global class URE_OptionResult {
		webservice List<URE_OptionDetail> optionDetails;
	}
	
	global class URE_OptionDetail {
		webservice String areaFactorClass;
		webservice String benefitName;
		webservice String benefitType; 
	}
	
	global class URE_RetentionBreakDown {
		webservice Decimal ACAFees;
		webservice Decimal Net_of_ACA;
		webservice Decimal nonACAFees;
	}
	
	global class URE_RetentionTaskResult {
		webservice String coverageCode;
		webservice URE_MultPLVFactor multplvFactors;			
	}
	
	global class URE_MultPLVFactor {
		webservice Decimal ACAFees;
		webservice Decimal commission;
		webservice Decimal expense;
		webservice Decimal m5;
		webservice Decimal margin;
		webservice Decimal premtax;
	}
    
}