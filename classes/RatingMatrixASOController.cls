/**************************************************************************************
  Apex Class Name     : RatingMatrixASOController
  Version             : 1.0
  Function            : This class handles the logic for the Rating Matrix ASO vf page which dynamically creates tables with rates
					     based off of selections in fields.
  Modification Log    :
 * Developer		Date  		Description
 * Mark Naumann		3/1/2018	SFDC-8323 Requirment do not display Oklahoma Termination Fees 				                 
 * ----------------------------------------------------------------------------
 * Author: Nick Serafin/slalom				6/6/2016            
 *************************************************************************************/

public class RatingMatrixASOController {

	@TestVisible private RateDAO.IRateDAO rateDAOInstance;
	@TestVisible private RateGroupDAO.IRateGroupDAO rateGroupDAOInstance;
	@TestVisible private RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeDAOInstance;
	@TestVisible private RateTermDAO.IRateTermDAO rateTermDAOInstance;
	private Id secureId;
	private Id asoRecordTypeId;
	private Id rateId;
	public Rate__c rate { get; set; }
	private Integer groupNumber;
	private Integer chargeNumber;
	private Integer termNumber;
	public String hcscDivision { get; set; }
	public Boolean renderRateChart { get; set; }
	public Boolean hasAccess { get; set; }
	public Boolean disabled {get;set;}
	public List<Rate_Group__c> rateGroups { get; set; }
	public List<Rate_Admin_Charge__c> rateAdminCharges { get; set; }
	public List<Rate_Term__c> rateTermCharges{get;set;}

	public RatingMatrixASOController(ApexPages.StandardController stdController){
		this(stdController, new RateDAO(), new RateGroupDAO(), new RateAdminChargeDAO(), new RateTermDAO());
	}

	@TestVisible private RatingMatrixASOController(ApexPages.StandardController stdController, 
												   		RateDAO.IRateDAO rateDAOInstance, 
												   			RateGroupDAO.IRateGroupDAO rateGroupDAOInstance,
																RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeDAOInstance, 
																	RateTermDAO.IRateTermDAO rateTermDAOInstance) {

		try {

			this.rateDAOInstance = rateDAOInstance;
			this.rateGroupDAOInstance = rateGroupDAOInstance;
			this.rateAdminChargeDAOInstance = rateAdminChargeDAOInstance;
			this.rateTermDAOInstance = rateTermDAOInstance;

			if(ApexPages.currentPage().getParameters().get('rateId') != null){

				hasAccess = true;
				renderRateChart = true;
				disabled = true;

				rateId = ApexPages.currentPage().getParameters().get('rateId');				

				rate = rateDAOInstance.grabASORateObj(rateId);

				rateGroups = rateGroupDAOInstance.grabRateGroups(rateId);

				rateAdminCharges = rateAdminChargeDAOInstance.grabRateAdminCharges(rateId);

				rateTermCharges = rateTermDAOInstance.grabRateTerms(rateId);

				groupNumber = rateGroups.size();
				chargeNumber = rateAdminCharges.size();
				termNumber = rateTermCharges.size();
				
                secureId = rate.Secure_Information__c;
				hcscDivision = rate.HCSC_Division__c;

			} else {
				
				hasAccess = true;
				renderRateChart = false;
				disabled = false;

				asoRecordTypeId = Schema.SObjectType.Rate__c.getRecordTypeInfosByName().get(Label.ASO_Rate).getRecordTypeId();

				hcscDivision = ApexPages.currentPage().getParameters().get('state');
				secureId = ApexPages.currentPage().getParameters().get('secure');

				groupNumber = 0;
				chargeNumber = 0;
				termNumber = 0;

				this.rate = (Rate__c) stdController.getRecord();
				rate.HCSC_Division__c = hcscDivision;

				rateGroups = new List<Rate_Group__c> ();
				rateAdminCharges = new List<Rate_Admin_Charge__c> ();
				rateTermCharges = new List<Rate_Term__c>();

			}

		} catch(Exception ex) {
			hasAccess = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error));
		}
	}

	public PageReference saveRateBackground() {

		try {

			renderRateChart = true;
			hcscDivision = rate.HCSC_Division__c;
	
			if(!disabled){

				if(hcscDivision == Label.RatingMatrixASOStateIL || hcscDivision == Label.RatingMatrixASOStateNM){

					Schema.DescribeFieldResult serviceFee = Rate__c.Service_Fees_2__c.getDescribe();
            		List<Schema.PicklistEntry> serviceFeeChoices = serviceFee.getPicklistValues();

					for(Schema.PicklistEntry fee : serviceFeeChoices){
            			groupNumber++;
            			Rate_Group__c newRateGroup = new Rate_Group__c();
						newRateGroup.Name = fee.Label;
						newRateGroup.groupNumber__c = groupNumber;
						rateGroups.add(newRateGroup);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfOtherRatesPEPM; i++){
            			groupNumber++;
            			Rate_Group__c newRateGroup = new Rate_Group__c();
						newRateGroup.Name = Label.Other;
						newRateGroup.groupNumber__c = groupNumber;
						rateGroups.add(newRateGroup);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfOtherRatesCharge; i++){
            			chargeNumber++;
						Rate_Admin_Charge__c newRateAdminCharge = new Rate_Admin_Charge__c();
						newRateAdminCharge.Name = Label.Other;
						newRateAdminCharge.adminNumber__c = chargeNumber;
						rateAdminCharges.add(newRateAdminCharge);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfMiscellaneous; i++){
            			groupNumber++;
            			Rate_Group__c newRateGroup = new Rate_Group__c();
						newRateGroup.Name = Label.Miscellaneous;
						newRateGroup.groupNumber__c = groupNumber;
						rateGroups.add(newRateGroup);

						chargeNumber++;
						Rate_Admin_Charge__c newRateAdminCharge = new Rate_Admin_Charge__c();
						newRateAdminCharge.Name = Label.Miscellaneous;
						newRateAdminCharge.adminNumber__c = chargeNumber;
						rateAdminCharges.add(newRateAdminCharge);
            		}

            		disabled = true;
            	} else {

            		Schema.DescribeFieldResult serviceFee = Rate__c.Service_Fees__c.getDescribe();
            		List<Schema.PicklistEntry> serviceFeeChoices = serviceFee.getPicklistValues();

            		for(Schema.PicklistEntry fee : serviceFeeChoices){
            			groupNumber++;
            			Rate_Group__c newRateGroup = new Rate_Group__c();
						newRateGroup.Name = fee.Label;
						newRateGroup.groupNumber__c = groupNumber;
						rateGroups.add(newRateGroup);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfOtherRatesPEPM; i++){
            			groupNumber++;
            			Rate_Group__c newRateGroup = new Rate_Group__c();
						newRateGroup.Name = Label.Other;
						newRateGroup.groupNumber__c = groupNumber;
						rateGroups.add(newRateGroup);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfOtherRatesCharge; i++){
            			chargeNumber++;
						Rate_Admin_Charge__c newRateAdminCharge = new Rate_Admin_Charge__c();
						newRateAdminCharge.Name = Label.Other;
						newRateAdminCharge.adminNumber__c = chargeNumber;
						rateAdminCharges.add(newRateAdminCharge);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfMiscellaneous; i++){
            			groupNumber++;
            			Rate_Group__c newRateGroup = new Rate_Group__c();
						newRateGroup.Name = Label.Miscellaneous;
						newRateGroup.groupNumber__c = groupNumber;
						rateGroups.add(newRateGroup);

						chargeNumber++;
						Rate_Admin_Charge__c newRateAdminCharge = new Rate_Admin_Charge__c();
						newRateAdminCharge.Name = Label.Miscellaneous;
						newRateAdminCharge.adminNumber__c = chargeNumber;
						rateAdminCharges.add(newRateAdminCharge);
            		}
            		disabled = true;
            	}

         //   	if(hcscDivision != Label.RatingMatrixASOStateIL){
                if(hcscDivision != Label.RatingMatrixASOStateIL && hcscDivision != Label.RatingMatrixASOStateOK){    

            		Schema.DescribeFieldResult termCharge = Rate__c.Termination_Charges__c.getDescribe();
            		List<Schema.PicklistEntry> termChargeChoices = termCharge.getPicklistValues();

            		for(Schema.PicklistEntry fee : termChargeChoices){
            			termNumber++;
            			Rate_Term__c newTermCharge = new Rate_Term__c();
						newTermCharge.Name = fee.Label;
						newTermCharge.termNumber__c = termNumber;
						rateTermCharges.add(newTermCharge);
            		}

            		for(Integer i = 0; i < ConstantsController.numberOfMiscellaneous; i++){
            			termNumber++;
            			Rate_Term__c newTermCharge = new Rate_Term__c();
						newTermCharge.Name = Label.Miscellaneous;
						newTermCharge.termNumber__c = termNumber;
						rateTermCharges.add(newTermCharge);
            		}

            	}

            } else {

            	return null;
            }

			return null;

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixASOController.saveRateBackground()', 'High');
			return null;
		}
	}

	public PageReference saveNewRateRecord() {

		try {
            
            Secure_Information__c secureInfoObj = [SELECT Id, PBM__c FROM Secure_Information__c WHERE Id =:secureId LIMIT 1];

			if(rateId != null){

				rateDAOInstance.updateRate(rate);

				List<Rate_Group__c> rateGroupsToInsert = new List<Rate_Group__c> ();

				for (Rate_Group__c rateGroupObj : rateGroups) {
					rateGroupObj.Rate__c = rate.Id;
                    if(rateGroupObj.Name == Label.RatingMatrixASOPrescriptionDrugProgramCredit){
						if(rateGroupObj.Group_1_Amount__c != null || rateGroupObj.Group_2_Amount__c != null || 
							rateGroupObj.Group_3_Amount__c != null || rateGroupObj.Group_4_Amount__c != null){
							secureInfoObj.PBM__c = true;
						} else {
							secureInfoObj.PBM__c = false;
						}
					}
					rateGroupsToInsert.add(rateGroupObj);
				}

				if (!rateGroupsToInsert.isEmpty()) {
					rateGroupDAOInstance.upsertRateGroup(rateGroupsToInsert);
				}
			
				List<Rate_Admin_Charge__c> rateAdminChargeToInsert = new List<Rate_Admin_Charge__c> ();

				for (Rate_Admin_Charge__c rateAdminObj : rateAdminCharges) {
					rateAdminObj.Rate__c = rate.Id;
					rateAdminChargeToInsert.add(rateAdminObj);
				}

				if (!rateAdminChargeToInsert.isEmpty()) {
					rateAdminChargeDAOInstance.upsertRateAdminCharge(rateAdminChargeToInsert);
				}

				List<Rate_Term__c> rateTermsToInsert = new List<Rate_Term__c> ();

				for (Rate_Term__c rateTermObj : rateTermCharges) {					
					rateTermObj.Rate__c = rate.Id;
					rateTermsToInsert.add(rateTermObj);
				}

				if (!rateTermsToInsert.isEmpty()) {
					rateTermDAOInstance.upsertRateTerm(rateTermsToInsert);
				}
                
                update secureInfoObj;

				return new PageReference('/' + rate.Id);

			} else {

				Rate__c rateASO = new Rate__c();

				rateASO.Secure_Information__c = secureId;
				rateASO.RecordTypeId = asoRecordTypeId;
				rateASO.HCSC_Division__c = hcscDivision;
				rateASO.No_Changes_Claim_Admin_Provider_Access__c = rate.No_Changes_Claim_Admin_Provider_Access__c;
				rateASO.Additional_provisions_Claim_Admin_Pro__c = rate.Additional_provisions_Claim_Admin_Pro__c;
				rateASO.Group_Number_s__c = rate.Group_Number_s__c;
				rateASO.of_ADP_savings__c = rate.of_ADP_savings__c;
				rateASO.per_covered_employee_per_month__c = rate.per_covered_employee_per_month__c;
				rateASO.Group_Numbers_With_Multiple__c = rate.Group_Numbers_With_Multiple__c;
				rateASO.of_ADP_savings_2__c = rate.of_ADP_savings_2__c;
				rateASO.per_covered_employee_per_month_2__c = rate.per_covered_employee_per_month_2__c;
				rateASO.BlueCard_Program_Network_access_fees__c = rate.BlueCard_Program_Network_access_fees__c;
				rateASO.Group_Name_1__c = rate.Group_Name_1__c;
				rateASO.Group_Name_2__c = rate.Group_Name_2__c;
				rateASO.Group_Name_3__c = rate.Group_Name_3__c;
				rateASO.Group_Name_4__c = rate.Group_Name_4__c;
				rateASO.Total_Group_1_Year_1__c = rate.Total_Group_1_Year_1__c;
				rateASO.Total_Group_2_Year_1__c = rate.Total_Group_2_Year_1__c;
				rateASO.Total_Group_3_Year_1__c = rate.Total_Group_3_Year_1__c;
				rateASO.Total_Group_4_Year_1__c = rate.Total_Group_4_Year_1__c;
				rateASO.Group_Name_1_Term__c = rate.Group_Name_1_Term__c;
				rateASO.Group_Name_2_Term__c = rate.Group_Name_2_Term__c;
				rateASO.Group_Name_3_Term__c = rate.Group_Name_3_Term__c;
				rateASO.Group_Name_4_Term__c = rate.Group_Name_4_Term__c;
				rateASO.Total_Group_1_Term__c = rate.Total_Group_1_Term__c;
    			rateASO.Total_Group_2_Term__c = rate.Total_Group_2_Term__c;
    			rateASO.Total_Group_3_Term__c = rate.Total_Group_3_Term__c;
    			rateASO.Total_Group_4_Term__c = rate.Total_Group_4_Term__c;
  				rateASO.Additional_Comments_Term_Charge__c = rate.Additional_Comments_Term_Charge__c;
  				rateASO.Additional_Comments_Admin_Charge__c = rate.Additional_Comments_Admin_Charge__c;
  				rateASO.Total_One_Time__c = rate.Total_One_Time__c;
  				rateASO.Total_Monthly__c = rate.Total_Monthly__c;
  				rateASO.Total_Yearly__c = rate.Total_Yearly__c;
  				rateASO.Total_Other__c = rate.Total_Other__c;
				
				rateDAOInstance.insertRate(rateASO);			

				List<Rate_Group__c> rateGroupsToInsert = new List<Rate_Group__c> ();

				for (Rate_Group__c rateGroupObj : rateGroups) {					
					rateGroupObj.Rate__c = rateASO.Id;
                    if(rateGroupObj.Name == Label.RatingMatrixASOPrescriptionDrugProgramCredit){
						if(rateGroupObj.Group_1_Amount__c != null || rateGroupObj.Group_2_Amount__c != null || 
							rateGroupObj.Group_3_Amount__c != null || rateGroupObj.Group_4_Amount__c != null){
							secureInfoObj.PBM__c = true;
						} else {
							secureInfoObj.PBM__c = false;
						}
					}
					rateGroupsToInsert.add(rateGroupObj);
				}

				if (!rateGroupsToInsert.isEmpty()) {
					rateGroupDAOInstance.insertRateGroup(rateGroupsToInsert);
				}

				List<Rate_Admin_Charge__c> rateAdminChargeToInsert = new List<Rate_Admin_Charge__c> ();

				for (Rate_Admin_Charge__c rateAdminObj : rateAdminCharges) {
					rateAdminObj.Rate__c = rateASO.Id;
					rateAdminChargeToInsert.add(rateAdminObj);
				}

				if (!rateAdminChargeToInsert.isEmpty()) {
					rateAdminChargeDAOInstance.insertRateAdminCharge(rateAdminChargeToInsert);
				}

				List<Rate_Term__c> rateTermsToInsert = new List<Rate_Term__c> ();

				for (Rate_Term__c rateTermObj : rateTermCharges) {					
					rateTermObj.Rate__c = rateASO.Id;
					rateTermsToInsert.add(rateTermObj);
				}

				if (!rateTermsToInsert.isEmpty()) {
					rateTermDAOInstance.insertRateTerm(rateTermsToInsert);
				}
                
                update secureInfoObj;

				return new PageReference('/' + rateASO.Id);

			}

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Rate__c', null, 'RatingMatrixASOController.saveNewRateRecord()', 'High');
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