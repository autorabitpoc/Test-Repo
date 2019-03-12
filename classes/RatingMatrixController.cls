/**************************************************************************************
  Apex Class Name     : RatingMatrixController
  Version             : 1.0
  Function            : This class handles the logic for the Rating Matrix vf page which dynamically creates tables with rates
  for products based off of selections in fields.
  Modification Log    :
 * Developer									 Date                   
 * ----------------------------------------------------------------------------
 * Author: Nick Serafin/slalom				5/25/2016            
 *************************************************************************************/

public class RatingMatrixController {

	@TestVisible private OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAOInstance;
	@TestVisible private RateDAO.IRateDAO rateDAOInstance;
	@TestVisible private RateProductDAO.IRateProductDAO rateProductDAOInstance;
	public Id opportunityId;
	public Id secureId;
	public Id rateId;
	public Id fullyInsuredRecordTypeId;
	public String hcscDivision { get; set; }
	public Rate__c rate { get; set; }
	public List<Opportunity_Product__c> opportunityProds { get; set; }
	public List<Rate_Product__c> rateProds { get; set; }
	public String numberOfYears { get; set; }
	public String rateStructure { get; set; }
	public String otherRate { get; set; }
	public Boolean renderRateChart { get; set; }
	public Boolean hasAccess { get; set; }

	public RatingMatrixController(ApexPages.StandardController stdController) {
		this(stdController, new OpportunityProductDAO(), new RateDAO(), new RateProductDAO());
	}

	@TestVisible private RatingMatrixController(ApexPages.StandardController stdController, OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAOInstance, RateDAO.IRateDAO rateDAOInstance, 
													RateProductDAO.IRateProductDAO rateProductDAOInstance) {

		try {

			this.opportunityProductDAOInstance = opportunityProductDAOInstance;
			this.rateDAOInstance = rateDAOInstance;
			this.rateProductDAOInstance = rateProductDAOInstance;

			if(ApexPages.currentPage().getParameters().get('rateId') != null){				

				hasAccess = true;
				renderRateChart = true;

				rateId = ApexPages.currentPage().getParameters().get('rateId');				

				rate = rateDAOInstance.grabRateObj(rateId);

				rateProds = rateProductDAOInstance.grabRateProducts(rateId);

				Opportunity_Product__c oppProd = new Opportunity_Product__c();
				opportunityProds = new List<Opportunity_Product__c>();
				opportunityProds.add(oppProd);

				numberOfYears = rate.Number_of_Years__c;
				otherRate = rate.Other_Rate__c;
				rateStructure = rate.Rate_Structure_Fully__c;	
				hcscDivision = rate.HCSC_Division__c;

			} else {
			
				hasAccess = true;
				renderRateChart = false;

				opportunityId = ApexPages.currentPage().getParameters().get('oid');
				hcscDivision = ApexPages.currentPage().getParameters().get('state');
				secureId = ApexPages.currentPage().getParameters().get('secure');

				this.rate = (Rate__c) stdController.getRecord();
				rate.HCSC_Division__c = hcscDivision;

				fullyInsuredRecordTypeId = Schema.SObjectType.Rate__c.getRecordTypeInfosByName().get(Label.Fully_Insured_BPA).getRecordTypeId();

				opportunityProds = opportunityProductDAOInstance.getRatingProducts(opportunityId);

				rateProds = new List<Rate_Product__c> ();

				for (Opportunity_Product__c oppProd : opportunityProds) {
					Rate_Product__c newRateProd = new Rate_Product__c();
					newRateProd.Name = oppProd.Product__r.Name;
					newRateProd.Product__c = oppProd.Product__r.Name;
					rateProds.add(newRateProd);
				}

			}

		} catch(Exception ex) {
			hasAccess = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.UnexpectedError));
		}
	}

	public PageReference saveRateBackground() {

		try {
			renderRateChart = true;
			numberOfYears = rate.Number_of_Years__c;
			otherRate = rate.Other_Rate__c;
			rateStructure = rate.Rate_Structure_Fully__c;
			hcscDivision = rate.HCSC_Division__c;			

			return null;

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixController.saveRateBackground()', 'High');
			return null;
		}
	}

	public PageReference saveNewRateRecord() {
	
	try{

		if(rateId != null){

			rateDAOInstance.updateRate(rate);
			
			if(!rateProds.isEmpty()){
				rateProductDAOInstance.updateRateProducts(rateProds);
			}
			
			return new PageReference('/' + rate.Id);
			
		} else {

			Rate__c rateFullyInsured = new Rate__c();

			rateFullyInsured.Secure_Information__c = secureId;
			rateFullyInsured.Opp__c = opportunityId;
			rateFullyInsured.RecordTypeId = fullyInsuredRecordTypeId;
			rateFullyInsured.Number_of_Years__c = numberOfYears;
			rateFullyInsured.HCSC_Division__c = hcscDivision;
			rateFullyInsured.Rate_Structure_Fully__c = rateStructure;
			rateFullyInsured.Other_Rate__c = otherRate;

			rateDAOInstance.insertRate(rateFullyInsured);

			List<Rate_Product__c> rateProdsToInsert = new List<Rate_Product__c> ();
			for (Rate_Product__c rateProds : rateProds) {
				rateProds.Rate__c = rateFullyInsured.Id;
				rateProdsToInsert.add(rateProds);
			}

			if(!rateProdsToInsert.isEmpty()){
				rateProductDAOInstance.insertRateProducts(rateProdsToInsert);
			}

			return new PageReference('/' + rateFullyInsured.Id);

		}

		} catch(Exception ex) {
			
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixController.saveNewRateRecord()', 'High');
			return null;
		}
	}

	public PageReference cancel() {

		if(rateId != null){

			return new PageReference('/' + rate.Id);

		} else {

			return new PageReference('/' + secureId);
		}
	}
}