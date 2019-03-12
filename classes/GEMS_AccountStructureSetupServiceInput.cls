public without sharing class GEMS_AccountStructureSetupServiceInput {
		
	public AccountDetails accountDetails;
	public list<Address> addresses;
	public list<BenefitAggrement> benefitAggrements;
	public list<Category> categories;
	public list<GroupSection> groupSections;
		
	public class AccountDetails{
		public string accountName;
		public string accountNumber;				
		public string effectiveDate;		
		public string marketSegment;
		public string accountStructureCaseID;
		public string corpCode;
		public string cobraAutoCancel;
		public string cobraCode;
	}
	
	public class Address{
		public integer addressSequence;		
		public string addressName;
		public string street;
		public string state;
		public string cityName;
		public string zipCode;
		public string countyCode;
		public string countryCode;
		
		public string isPrimaryAddress;
		public string isMailingAddress;
		public string isSubsidaryAddress;
		public string isBillingAddress;
		public string isInvoiceAddress;
		public string isBaeAddress;
		public string isStlmAddress;
		public string isThirdPartyAddress;
		
		public string contactName;
		public string contactPhoneNumber;
		public string contactEmailAddress;
	}	
	
	public class BenefitAggrement{	
		public string baNumber;		
		public string baDescription;
		public string prodTypeCode;
		public string corporateProdNumber;
		public string corporateProdName;		
		public string baFundType;	
		public string scheduleCode;
	}
	
	public class Category{
		public string categoryNumber;
		public string categoryDescription;	
		public string categoryCobraCode;
				
		public string productIndicator;
		public string billingIndicator;
		public string reportingIndicator;
		public string mailIndicator;
	}
	
	public class GroupSection{
		public string groupNumber;
		
		public string sectionNumber;
		public string sectionDescription;
		
		public list<string> assignedBANumbers;
		public list<string> assignedCategoryNumbers;				
	}
	
}