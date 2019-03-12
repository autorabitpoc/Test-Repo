/*
*	11/21/2018	Luke Chen		SFDC-14848 SGR-BEngaged: Create request to call B-Engaged
*/
public class SGR_Beng_XML_TemplateDAO {
	// input to helper class
	public Id oppId;
	public String docVer,docType,source,correspondenceId,printType;//Print type : Producer, Account, GA
	// below are for helper class internal use
	public Opportunity opportunity;  // include account.id, account.name, accoun.account_number__c
	public Contact primaryContact;
	public Contact adminContact;
	public String rep,agent;
	public Set<Id> planIds;
	public Map<Id,Plan__c> plans;
	public Map<Id,SGR_Opportunity_Plan_Rate__c> planRates;
	public Map<Id,SGR_Opportunity_Plan_Composite_Rate__c> planCompRates; // SGR_Opportunity_Plan_Rate__r.Prototype_Plan_Level__c, Tier_Code__c(EO,ES,EC,EF)
	public Map<Id,Benefit_Header_Detail_Association__c> benefitHDAs;
	public Map<Id,SGR_Opportunity_Census__c> oppCensuses;
	public Map<Id,SGR_Opportunity_Member_Benefits__c> memberBenefits;
	public Map<Id,Plan_Note_Association__c> noteAs;
	public Map<Id,Product_Note_Detail_Association__c> noteDetailAs;
	public Map<Id,SGR_Plan_Age_Rate_Header__c> ageRateHeaders;
	public Map<Id,SGR_Plan_Age_Rate_Detail__c> ageRateDetails;
	public Map<Id,Account> producers;
	public String recipient;
	public SGR_Beng_Address mailingAddr = new SGR_Beng_Address();
	public String npnProducer = '';
	public String npnSubProd = '';
	public String npnGenAgent = '';
	public String pnProducer = '';
	public String pnSubProd = '';
	public String pnGenAgent = '';	
	public Plan__c opt2=null;
	public Plan__c opt3=null;
	
	// public SGR_Lowest_Cost_Plan_Option__c opt2_3=null;

    // create Base64Encoded XML payload string
	public String createXmlDoc(){
		if(oppId==null) return '';
		SGR_Beng_RequestHelper helper = new SGR_Beng_RequestHelper(this);
		String xmlData = helper.generateXML();
		Blob xmlValue = Blob.valueOf(xmlData);
		return EncodingUtil.base64Encode(xmlValue);
	}

	public class SGR_Beng_Address{
		public String street='';
		public String zip='';
		public String state='';
		public String city='';
	}

}