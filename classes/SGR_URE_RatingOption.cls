/*************************************************************************************************
	Class Name: SGR_URE_RatingOption.cls
	Created By: Cesar Murcia
	Description: Constants used in the URE Post processing classes 
				(e.g: SGR_URE_OpptyCompAndAgeRatingUtility.cls)
**************************************************************************************************/
global class SGR_URE_RatingOption {
		public static final String RENEWING_PLAN_TYPE = 'Renewal';
		public static final String ALTERNATE_PLAN_TYPE = 'Alternate';
		public static final String CURRENT_PLAN_TYPE = 'Current';
		public static final STRING OPTION_PLAN_TYPE = 'Option 1 and 2';
		public static final String SUBSCRIBER = 'SUB';
		public static final String TIER_EO = 'EO';
		public static final String TIER_ES = 'ES';
		public static final String TIER_EC = 'EC';
		public static final String TIER_EF = 'EF';
		public static final String COMPOSITE = 'Composite';
		public static final String AGE = 'Age';
		public static final String STN = 'STN';
		public static final String ALTERNATECENSUSKEY = 'AlternateCensus';
		public static final String DENTALCOVERAGECODE = 'D';
		public static final String VISIONCOVERAGECODE = 'V';
		public static final String HEALTHCOVERAGECODE = 'H';

		public SGR_URE_RatingOption() {}
}