/**************************************************************************************
  Apex Class Name     : RatingMatrixHCAController
  Version             : 1.0
  Function            : This class handles the logic for the Rating Matrix HCA vf page which dynamically creates tables with rates
					     based off of selections in fields.
  Modification Log    :
 * Developer									 Date                   
 * ----------------------------------------------------------------------------
 * Author: Nick Serafin/slalom				6/17/2016            
 *************************************************************************************/
public with sharing class RatingMatrixHCAController {

	@TestVisible private RateDAO.IRateDAO rateDAOInstance;
	@TestVisible private RateHCADAO.IRateHCADAO rateHCADAOInstance;
	public Id secureId;
	public Id hcaRecordTypeId;
	public Id rateId;
	public Rate__c rate { get; set; }
	public Integer hcaNumber;
	public String hcscDivision { get; set; }
    public String newAccountStructure{get;set;}
	public String accountStructure { get; set; }
	public String healthCareAccount { get; set; }
	public String groupNumbers { get; set; }
	public Boolean renderRateChart { get; set; }
	public Boolean hasAccess { get; set; }
	public List<Rate_HCA__c> rateHCAs { get; set; }
	public Integer numberOfChoices {get;set;}

	public RatingMatrixHCAController(ApexPages.StandardController stdController) {
		this(stdController, new RateDAO(), new RateHCADAO());
	}

	@TestVisible private RatingMatrixHCAController(ApexPages.StandardController stdController, RateDAO.IRateDAO rateDAOInstance, 
													RateHCADAO.IRateHCADAO rateHCADAOInstance){

		try {

			this.rateDAOInstance = rateDAOInstance;
			this.rateHCADAOInstance = rateHCADAOInstance;

			if(ApexPages.currentPage().getParameters().get('rateId') != null){

				hasAccess = true;
				renderRateChart = true;

				rateId = ApexPages.currentPage().getParameters().get('rateId');				

				rate = rateDAOInstance.grabHCARateObj(rateId);

				rateHCAs = rateHCADAOInstance.grabRateHCAs(rateId);

				hcaNumber = rateHCAs.size();

                newAccountStructure = '';
				accountStructure = rate.HCA_Account_Structure_ASO__c;				
				groupNumbers = rate.Applicable_Group_Number_s__c;
				hcscDivision = rate.HCSC_Division__c;		

			} else {
				
				hasAccess = true;
				renderRateChart = false;

				hcaRecordTypeId = Schema.SObjectType.Rate__c.getRecordTypeInfosByName().get(Label.HCA).getRecordTypeId();

				hcscDivision = ApexPages.currentPage().getParameters().get('state');
				secureId = ApexPages.currentPage().getParameters().get('secure');
				newAccountStructure = '';
				hcaNumber = 1;
		
				this.rate = (Rate__c) stdController.getRecord();
				rate.HCSC_Division__c = hcscDivision;

				rateHCAs = new List<Rate_HCA__c> ();

				Rate_HCA__c newHCA = new Rate_HCA__c();
				newHCA.Name = Label.HCA + ' ' + hcaNumber;

				rateHCAs.add(newHCA);

			}

		} catch(Exception ex) {
			hasAccess = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error));
		}
		
	}

	public PageReference saveRateBackground() {

		try {

			renderRateChart = true;            
			accountStructure = rate.HCA_Account_Structure_ASO__c;
			groupNumbers = rate.Applicable_Group_Number_s__c;
			hcscDivision = rate.HCSC_Division__c;
            
            if(accountStructure != newAccountStructure){         
            	for(Rate_HCA__c rateHCAObj : rateHCAs){              
                    rateHCAObj.Employee_Spouse_HCA__c = null;
                    rateHCAObj.Employee_Child_HCA__c = null;
                    rateHCAObj.Family_HCA__c = null;
                    rateHCAObj.Employee_1_HCA__c = null;
                    rateHCAObj.Employee_2_HCA__c = null;          
                    rateHCAObj.Employee_Spouse_Only__c = null;
                    rateHCAObj.Employee_Child_Only__c = null;
                    rateHCAObj.Family_Only__c = null;
                    rateHCAObj.Employee_1_Only__c = null;
                    rateHCAObj.Employee_2_Only__c = null;            
                    rateHCAObj.Employee_Spouse_Max__c = null;
                    rateHCAObj.Employee_Child_Max__c = null;
                    rateHCAObj.Family_Max__c = null;
                    rateHCAObj.Employee_1_Max__c = null;
                    rateHCAObj.Employee_2_Max__c = null;
                }
            }
		
			return null;

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixHCAController.saveRateBackground()', 'High');
			return null;
		}
	}

	public PageReference addNewHCA() {

		try {

			hcaNumber++;
			Rate_HCA__c newHCA = new Rate_HCA__c();
			newHCA.Name = Label.HCA + ' ' + hcaNumber;

			rateHCAs.add(newHCA);
			return null;

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixHCAController.addNewHCA()', 'High');
			return null;
		}
	}

	public PageReference saveNewRateRecord() {

		try {

			Id rateHCARecordTypeId = Schema.SObjectType.Rate_HCA__c.getRecordTypeInfosByName().get(Label.RatingMatrixHCARateHCART).getRecordTypeId();
			Id rateHCAMTRecordTypeId = Schema.SObjectType.Rate_HCA__c.getRecordTypeInfosByName().get(Label.RatingMatrixHCARateHCARTMT).getRecordTypeId();

			if(rateId != null){

				rateDAOInstance.updateRate(rate);

				List<Rate_HCA__c> rateHCAsToInsert = new List<Rate_HCA__c> ();

				for (Rate_HCA__c rateHCAObj : rateHCAs) {
					rateHCAObj.Rate__c = rate.Id;
					if(hcscDivision == Label.RatingMatrixHCAMTState){						
						rateHCAObj.RecordTypeId = rateHCAMTRecordTypeId;
					} else {
						rateHCAObj.RecordTypeId = rateHCARecordTypeId;
					}
					rateHCAsToInsert.add(rateHCAObj);
				}

				if (!rateHCAsToInsert.isEmpty()) {
					rateHCADAOInstance.upsertRateHCA(rateHCAsToInsert);
				}
				return new PageReference('/' + rate.Id);

			} else {

				Rate__c rateHCA = new Rate__c();

				rateHCA.Secure_Information__c = secureId;
				rateHCA.RecordTypeId = hcaRecordTypeId;
				rateHCA.HCA_Account_Structure_ASO__c = accountStructure;
				rateHCA.HCSC_Division__c = hcscDivision;			
				rateHCA.Applicable_Group_Number_s__c = groupNumbers;
				
				rateDAOInstance.insertRate(rateHCA);			

				List<Rate_HCA__c> rateHCAsToInsert = new List<Rate_HCA__c> ();

				for (Rate_HCA__c rateHCAObj : rateHCAs) {
					rateHCAObj.Rate__c = rateHCA.Id;
					if(hcscDivision == Label.RatingMatrixHCAMTState){						
						rateHCAObj.RecordTypeId = rateHCAMTRecordTypeId;
					} else {
						rateHCAObj.RecordTypeId = rateHCARecordTypeId;
					}
					rateHCAsToInsert.add(rateHCAObj);
				}

				if (!rateHCAsToInsert.isEmpty()) {
					rateHCADAOInstance.insertRateHCA(rateHCAsToInsert);
				}

				return new PageReference('/' + rateHCA.Id);

			}

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixHCAController.saveNewRateRecord()', 'High');
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