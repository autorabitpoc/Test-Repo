/**************************************************************************************
  Apex Class Name     : ConfirmProgressOnLostProductsController
  Version             : 1.0
  Function            : This class handles the logic for setting the farthest stage a lost product went to and setting the expected member/Contract 
  						fields on the Opportunity based on the products selected
  Modification Log    :
 * Developer									 Date                   
 * ----------------------------------------------------------------------------
 *   Author: Dan Zebrowski/slalom				4/29/2016
 *	 Updated By: Nick Serafin/slalom			5/23/2016            
 *************************************************************************************/

public class ConfirmProgressOnLostProductsController {

	@TestVisible private OpportunityDAO.IOpportunityDAO opportunityDAOInstance;
	@TestVisible private OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAOInstance;
	public Id opportunityId;
	public List<String> productIds;
	public List<String> selectedProductIds;
	public List<Opportunity_Product__c> opProducts { get; set; }
	public List<Opportunity_Product__c> selectedProducts;
	public Opportunity opportunityObj;
	public String oppRecType {get;set;}
	public Decimal projectedHealthMembers { get; set; }
	public Decimal projectedHealthContracts { get; set; }
	public Decimal projectedDentalMembers { get; set; }
	public Decimal projectedDentalContracts { get; set; }
	public Decimal projectedHealthMembersRollup { get; set; }
	public Decimal projectedHealthContractsRollup { get; set; }
	public Decimal projectedDentalMembersRollup { get; set; }
	public Decimal projectedDentalContractsRollup { get; set; }

	public ConfirmProgressOnLostProductsController(){
		this(new OpportunityDAO(), new OpportunityProductDAO());
	}

	@TestVisible private ConfirmProgressOnLostProductsController(OpportunityDAO.IOpportunityDAO opportunityDAO, OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAO) {

		try {

			this.opportunityDAOInstance = opportunityDAO;
			this.opportunityProductDAOInstance = opportunityProductDAO;

			opportunityId = ApexPages.currentPage().getParameters().get('oid');
			productIds = (ApexPages.currentPage().getParameters().get('ids')).split('-');
			selectedProductIds = (ApexPages.currentPage().getParameters().get('pids')).split('-');

			opProducts = opportunityProductDAOInstance.getLostProducts(productIds);

			selectedProducts = opportunityProductDAOInstance.getSelectedProducts(selectedProductIds);

			opportunityObj = opportunityDAOInstance.getOpportunityById(opportunityId);

			oppRecType = opportunityObj.RecordType.Name;

			Map<Id, List<Opportunity_Product__c>> oppProdMap = new Map<Id, List<Opportunity_Product__c>> ();

			for (Opportunity_Product__c oppProds : selectedProducts) {

				List<Opportunity_Product__c> productList = new List<Opportunity_Product__c> ();

				if (oppProdMap.containsKey(oppProds.Opportunity_Name__c)) {

					productList = oppProdMap.get(oppProds.Opportunity_Name__c);
				}

				productList.add(oppProds);
				oppProdMap.put(oppProds.Opportunity_Name__c, productList);
			}

			projectedHealthMembers = 0;
			projectedHealthContracts = 0;
			projectedDentalMembers = 0;
			projectedDentalContracts = 0;

			projectedHealthMembersRollup = 0;
			projectedHealthContractsRollup = 0;
			projectedDentalMembersRollup = 0;
			projectedDentalContractsRollup = 0;

			Id newSaleRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Label.ProductTypeN).getRecordTypeId();

			if(opportunityObj.RecordTypeId == newSaleRecordTypeId){

				for (Opportunity_Product__c product : oppProdMap.get(opportunityObj.Id)) {

					if (product.Category__c == Label.Medical) {

						if (product.Status__c != Label.Lost && product.Product_Type__c != Label.Upsell) {
						
							projectedHealthContracts += product.Projected_Contracts__c;							
							projectedHealthContractsRollup += product.Projected_Contracts__c;
						}
						
					} else if (product.Category__c == Label.Dental) {

						if (product.Status__c != Label.Lost && product.Product_Type__c != Label.Upsell) {
							
							projectedDentalContracts += product.Projected_Contracts__c;						
							projectedDentalContractsRollup += product.Projected_Contracts__c;
						}
					}
				}

				projectedHealthMembers = projectedHealthContracts * ConstantsController.numberToMultiplyTotalMembersByForContracts;
				projectedDentalMembers = projectedDentalContracts * ConstantsController.numberToMultiplyTotalMembersByForContracts;
				projectedHealthMembersRollup = projectedHealthContractsRollup * ConstantsController.numberToMultiplyTotalMembersByForContracts;
				projectedDentalMembersRollup = projectedDentalContractsRollup * ConstantsController.numberToMultiplyTotalMembersByForContracts;

				if (opportunityObj.Expected_Health_Members__c != null) {

					projectedHealthMembers = opportunityObj.Expected_Health_Members__c;
				}

				if (opportunityObj.Expected_Health_Contracts__c != null) {

					projectedHealthContracts = opportunityObj.Expected_Health_Contracts__c;
				}

				if (opportunityObj.Expected_Dental_Members__c != null) {

					projectedDentalMembers = opportunityObj.Expected_Dental_Members__c;
				}

				if (opportunityObj.Expected_Dental_Contracts__c != null) {

					projectedDentalContracts = opportunityObj.Expected_Dental_Contracts__c;
				}


			} else {

				for (Opportunity_Product__c product : oppProdMap.get(opportunityObj.Id)) {

					if (product.Category__c == Label.Medical) {

						if (product.Status__c != Label.Lost && product.Product_Type__c != Label.Upsell) {

							projectedHealthMembers += product.Projected_Members__c;
							projectedHealthContracts += product.Projected_Contracts__c;
							projectedHealthMembersRollup += product.Projected_Members__c;
							projectedHealthContractsRollup += product.Projected_Contracts__c;
						}
						
					} else if (product.Category__c == Label.Dental) {

						if (product.Status__c != Label.Lost && product.Product_Type__c != Label.Upsell) {

							projectedDentalMembers += product.Projected_Members__c;
							projectedDentalContracts += product.Projected_Contracts__c;
							projectedDentalMembersRollup += product.Projected_Members__c;
							projectedDentalContractsRollup += product.Projected_Contracts__c;
						}
					}
				}

				if (opportunityObj.Expected_Health_Members__c != null) {

					projectedHealthMembers = opportunityObj.Expected_Health_Members__c;
				}

				if (opportunityObj.Expected_Health_Contracts__c != null) {

					projectedHealthContracts = opportunityObj.Expected_Health_Contracts__c;
				}

				if (opportunityObj.Expected_Dental_Members__c != null) {

					projectedDentalMembers = opportunityObj.Expected_Dental_Members__c;
				}

				if (opportunityObj.Expected_Dental_Contracts__c != null) {

					projectedDentalContracts = opportunityObj.Expected_Dental_Contracts__c;
				}
			}

		} catch(Exception ex) {
			System.debug(ex);
		}
	}

	/**
	 * @Method:getFields()
	 * @description: Method to grab the field set for use in the visualforce page
	 */
	public List<Schema.FieldSetMember> getFields() {

		return SObjectType.Opportunity_Product__c.FieldSets.Lost_Products.getFields();
	}

	public PageReference save() {

		try {

			opportunityObj.Expected_Health_Members__c = projectedHealthMembers;
			opportunityObj.Expected_Health_Contracts__c = projectedHealthContracts;
			opportunityObj.Expected_Dental_Members__c = projectedDentalMembers;
			opportunityObj.Expected_Dental_Contracts__c = projectedDentalContracts;

			opportunityDAOInstance.updateOpportunity(opportunityObj);

			if (opProducts.size() > 0) {
				opportunityProductDAOInstance.updateOpportunityProducts(opProducts);
			}
			return new PageReference('/' + opportunityId);

		} catch(Exception ex) {

			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', null, null, 'ConfirmProgressOnLostProductsController.save()', 'High');
			return null;
		}
	}

	public PageReference cancel() {

		return new PageReference('/apex/AddOpportunityProducts?opportunityId=' + opportunityId);

	}
}