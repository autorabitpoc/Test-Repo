public class URE_GenericResponseWrapper {

	public class RetentionBreakdown {
		public String ACAFees;
		public String Net_of_ACA;
		public String nonACAFees;
	}

	public class Rates {
		public String fromAge;
		public String grossPremium;
		public String relationshipCode;
		public RetentionBreakdown retentionBreakdown;
		public String toAge;
	}

	public class MultplvFactors {
		public String ACAFees;
		public String commission;
		public String expense;
		public String m5;
		public String margin;
		public String premtax;
	}

	public RffResult rffResult;

	public class ProductResults_Z {
		public List<PlanResults_Z> planResults;
		public String value;
	}

	public class OptionDetails {
		public String areaFactorClass;
		public String benefitName;
		public String benefitType;
	}

	public class PlanResults {
		public List<AreaResults> areaResults;
		public String coverageCode;
		public String demographicFactorClass;
		public List<OptionResults> optionResults;
		public String planId;
	}

	public class PlanResults_Z {
		public List<AreaResults> areaResults;
		public String coverageCode;
		public String demographicFactorClass;
		public List<OptionResults> optionResults;
		public String planId;
		public String rateSize;
	}

	public class MarketingRatesGenericTaskResult {
		public List<RatingPackageResults> ratingPackageResults;
	}

	public class AreaResults {
		public String areaNumber;
		public String isTefra;
		public String isTobacco;
		public List<Rates> rates;
	}

	public class RetentionTaskResult {
		public String coverageCode;
		public MultplvFactors multplvFactors;
	}

	public class OptionResults {
		public List<OptionDetails> optionDetails;
	}

	public class RatingPackageResults {
		public List<ProductResults> productResults;
	}

	public class MarketingDentalRatesGenericTaskResult {
		public List<RatingPackageResults_Z> ratingPackageResults;
	}

	public class RatingPackageResults_Z {
		public List<ProductResults_Z> productResults;
	}

	public class RffResult {
		public MarketingRatesGenericTaskResult marketingRatesGenericTaskResult;
		public MarketingDentalRatesGenericTaskResult marketingDentalRatesGenericTaskResult;
		public String referenceId;
		public List<RetentionTaskResult> retentionTaskResult;
	}

	public class ProductResults {
		public List<PlanResults> planResults;
		public String value;
	}
}