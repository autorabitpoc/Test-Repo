/**************************************************************************************
  Apex Class Name     : CustomContractsCurrProdsController
  Version             : 1.0
  Function            : This Class grabs the current products from the related Account to the Case and displays them in
  						a visualforce page
  Modification Log    :
 * Developer									 Date                   
 * ----------------------------------------------------------------------------
 * Author: Nick Serafin/slalom				8/10/2016            
 *************************************************************************************/
public with sharing class CustomContractsCurrProdsController {

	@testVisible private AccountDAO.IAccountDAO accountDAOInstance;
	@testVisible private BenefitAgreementDAO.IBenefitAgreementDAO benefitAgreementDAOInstance;
	@TestVisible private OpportunityDAO.IOpportunityDAO opportunityDAOInstance;
	public Case customContractCase {get;set;}
	public String acctName {get;set;}
	public Id acctId;
	public List<CurrentProductsBean> currentProductsList {get;set;}
	public Boolean hasAccess { get; set; }
	public Boolean currentProds {get;set;}
	public Boolean activeProds {get;set;}

	public CustomContractsCurrProdsController(ApexPages.StandardController stdController){
		this(stdController, new AccountDAO(), new BenefitAgreementDAO(), new OpportunityDAO());
	}

	@testVisible
	private CustomContractsCurrProdsController(ApexPages.StandardController stdController, AccountDAO.IAccountDAO accountDAOInstance, 
												BenefitAgreementDAO.IBenefitAgreementDAO benefitAgreementDAOInstance, 
												OpportunityDAO.IOpportunityDAO opportunityDAOInstance) {

	try {
			hasAccess = true;
			currentProds = false;
			activeProds = false;

			this.accountDAOInstance = accountDAOInstance;
			this.benefitAgreementDAOInstance = benefitAgreementDAOInstance;
			this.opportunityDAOInstance = opportunityDAOInstance;
			this.customContractCase = (Case)stdController.getRecord();

			acctId = customContractCase.AccountId;
			acctName = customContractCase.Account.Name;

			Id groupAccountRecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();

			Account acc = accountDAOInstance.getAccountForCustomContractsProdsPage(acctId);

			currentProductsList = new List<CurrentProductsBean> ();

			if(acc.RecordTypeId == groupAccountRecordTypeId && acc.Status__c == Label.Active){

				currentProds = true;

				List<Benefit_Agreement__c> benefitAgreements = new List<Benefit_Agreement__c> ();
				CurrentProductsBean currentProd;
				List<CurrentProductsBean> fullProductList = new List<CurrentProductsBean>();

				benefitAgreements = benefitAgreementDAOInstance.getBenefitAgreementsForCurrentProds(acctId);

				Map<Id, List<Benefit_Agreement__c>> benefitAgreementMap = new Map<Id, List<Benefit_Agreement__c>> ();
				for (Benefit_Agreement__c benAgr : benefitAgreements) {

					List<Benefit_Agreement__c> benAgrList = new List<Benefit_Agreement__c> ();

					if (benefitAgreementMap.containsKey(benAgr.Product__c)) {
						benAgrList = benefitAgreementMap.get(benAgr.Product__c);
					}

					benAgrList.add(benAgr);
					benefitAgreementMap.put(benAgr.Product__c, benAgrList);
				}

				Map<Id, Set<String>> fundMap = new Map<Id, Set<String>> ();
				for (Benefit_Agreement__c benAgr : benefitAgreements) {

					Set<String> ba = new Set<String> ();

					if (fundMap.containsKey(benAgr.Product__c)) {
						ba = fundMap.get(benAgr.Product__c);
					}

					ba.add(benAgr.Funding_Type__c);
					fundMap.put(benAgr.Product__c, ba);
				}

				Decimal memberCountACAP;
				Decimal memberCountPREM;
				Decimal memberCountASO;
				Decimal memberCountCOST;
				Decimal memberCountMPP;
				Decimal memberCountPAR;
				Decimal memberCountSERV;


				for (String ben : benefitAgreementMap.keySet()) {

					List<Benefit_Agreement__c> benAgrList = new List<Benefit_Agreement__c> ();
					benAgrList = benefitAgreementMap.get(ben);

					memberCountACAP = 0;
					memberCountPREM = 0;
					memberCountASO = 0;
					memberCountCOST = 0;
					memberCountMPP = 0;
					memberCountPAR = 0;
					memberCountSERV = 0;

					for (Benefit_Agreement__c benAgr : benAgrList) {

						if (benAgr.Funding_Type__c == Label.ACAP) {

							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountACAP += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountACAP += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}

						} else if (benAgr.Funding_Type__c == Label.PREM) {

							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountPREM += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountPREM += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}

						} else if (benAgr.Funding_Type__c == Label.ASO) {
							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountASO += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountASo += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}

						} else if (benAgr.Funding_Type__c == Label.COST) {
							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountCOST += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountCOST += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}

						} else if (benAgr.Funding_Type__c == Label.MPP) {
							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountMPP += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountMPP += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}

						} else if (benAgr.Funding_Type__c == Label.PAR) {
							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountPAR += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountPAR += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}

						} else {
							for (BA_GS_Assignment__c bagsAgrrement : benAgr.BA_GS_Assignments__r) {

								if (benAgr.Product__r.Product_Type__c == Label.ProductTypeM) {
									if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null) {
										memberCountSERV += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
									}
								} else if (benAgr.Product__r.Product_Type__c == Label.ProductTypeD) {
									if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null) {
										memberCountSERV += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
									}
								}
							}
						}
					}

					for (String fund : fundMap.get(ben)) {
						if (benefitAgreementMap.get(ben) != null) {
							currentProd = new CurrentProductsBean();
							currentProd.productId = benefitAgreementMap.get(ben)[0].Product__c;
							currentProd.productName = benefitAgreementMap.get(ben)[0].Product__r.Simplified_Product__c;
							currentProd.funding = fund;

							if (fund == Label.ACAP) {
								currentProd.numberOfProjectedMembers = memberCountACAP;
							} else if (fund == Label.PREM) {
								currentProd.numberOfProjectedMembers = memberCountPREM;
							}  else if (fund == Label.ASO) {
								currentProd.numberOfProjectedMembers = memberCountASO;
							}  else if (fund == Label.COST) {
								currentProd.numberOfProjectedMembers = memberCountCOST;
							}  else if (fund == Label.MPP) {
								currentProd.numberOfProjectedMembers = memberCountMPP;
							}  else if (fund == Label.PAR) {
								currentProd.numberOfProjectedMembers = memberCountPAR;
							}  else {
								currentProd.numberOfProjectedMembers = memberCountSERV;
							}

							fullProductList.add(currentProd);
						}
					}
				}

				currentProductsList = fullProductList;

				List<Opportunity> opps = new List<Opportunity>();
				List<Opportunity_Product__c> oppProdList = new List<Opportunity_Product__c>();
				List<CurrentProductsBean> currentProducts = new List<CurrentProductsBean>();
				Map<Id, Opportunity_Product__c> nonBlueStarProds = new Map<Id, Opportunity_Product__c>();

				CurrentProductsBean currProd;
				Id hcscNonBlueSTARRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(Label.Product2_RecordType_HCSC_Non_BlueStar_Product).getRecordTypeId();

				opps = opportunityDAOInstance.getOpportunitiesForCustomContractsCurrProds(acctId, hcscNonBlueSTARRecordTypeId);

				for (Opportunity opp : opps) {
					//Iterate through all the opportunity products for each opportunity
					for (Opportunity_Product__c oppProd : opp.Opportunity_Products__r) {
						//Check for duplicate product in map and if the current opp product has a more recent Effective Date
						if (nonBlueStarProds.containsKey( oppProd.Product__c ) && oppProd.Effective_Date__c > nonBlueStarProds.get(oppProd.Product__c).Effective_Date__c ) {
							nonBlueStarProds.remove(oppProd.Product__c); //remove duplicate from map
							if (oppProd.Status__c == Label.WonP) {
								//insert current opp product in map if the status is won
								nonBlueStarProds.put(oppProd.Product__c, oppProd);
							}
						} //Check if opp product is not in map and status is won
						else if (!nonBlueStarProds.containsKey(oppProd.Product__c) && oppProd.Status__c == Label.WonP) {
							nonBlueStarProds.put(oppProd.Product__c, oppProd);
						}
					}
				}

				oppProdList.addAll(nonBlueStarProds.values());

				for (Opportunity_Product__c oppProd : oppProdList) {
					currProd = new CurrentProductsBean();
					currProd.productId = oppProd.Product__c;
					currProd.productName = oppProd.Product__r.Simplified_Product__c;
					currProd.funding = oppProd.Funding_Type__c;
					if (oppProd.Projected_Members__c != null) {
						currProd.numberOfProjectedMembers = Integer.valueOf(oppProd.Projected_Members__c);
					} else {
						currProd.numberOfProjectedMembers = 0;
					}

					currentProducts.add(currProd);
				}
				currentProductsList.addAll(currentProducts);

			} else {

				activeProds = true;

				List<Opportunity> activeOpp = opportunityDAOInstance.getOpportunitiesForCustomContractsActiveProds(acctId);

				for (Opportunity opp : activeOpp) {

					for (Opportunity_Product__c oppProd : opp.Opportunity_Products__r) {

						CurrentProductsBean activelyPurchasingProd = new CurrentProductsBean();
						activelyPurchasingProd.productId = oppProd.Product__c;
						activelyPurchasingProd.productName = oppProd.Product__r.Simplified_Product__c;
						activelyPurchasingProd.funding = oppProd.Funding_Type__c;
						activelyPurchasingProd.numberOfProjectedMembers = Integer.valueOf(oppProd.Projected_Members__c);

						currentProductsList.add(activelyPurchasingProd);

					}
				}
			}
		} catch (Exception ex) {
			hasAccess = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.InsufficientError));
		}
	}

	public class CurrentProductsBean {
		public String productId { get; set; }
		public String productName { get; set; }
		public String funding { get; set; }
		public Decimal numberOfProjectedMembers { get; set; }
	}
}