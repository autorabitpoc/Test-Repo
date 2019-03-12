/**************************************************************************************
  Apex Class Name     : CustomContractsCurrProdsControllerTest
  Version             : 1.0
  Function            : This is a test class for CustomContractsCurrProdsController and leverages a mocking framework
  						to test the functionality.
  Modification Log    :
 * Developer									 Date                   
 * ----------------------------------------------------------------------------
 * Author: Nick Serafin/slalom				8/10/2016            
 *************************************************************************************/
@isTest
public class CustomContractsCurrProdsControllerTest {

	@isTest static void CustomContractsCurrProdsControllerTestGroup() {

		Account testAcntGrp = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
		testAcntGrp.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
		testAcntGrp.HCSC_Division__c = 'IL';
		testAcntGrp.Status__c = 'Active';
		testAcntGrp.Id = MockRelationshipHelper.Id.generate( Account.SObjectType );

		Case testCase = new Case(AccountId = testAcntGrp.Id, Number_of_Lives__c = 10, Negotiation_Type__c = 'Negotiation Type', Agreement_Submitted__c = 'Agreement Submitted',
		State__c = 'State', Status = 'Request from Sales & Marketing, Draft', Account_Type_Custom_Contract__c = 'Account Type', Type__c = 'Value 1',
		Type = 'Value 2');
		testCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
		testCase.Id = MockRelationshipHelper.Id.generate( Case.SObjectType );

		List<Product2> lstProduct =  TestClassUtiltity.createProducts();
		Id hcscNonBlueSTARRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(Label.Product2_RecordType_HCSC_Non_BlueStar_Product).getRecordTypeId();

		lstProduct[0].RecordTypeId = hcscNonBlueSTARRecordTypeId;
		lstProduct[0].Name = 'PPO';
		lstProduct[0].Simplified_Product__c = 'PPO';
		lstProduct[0].NotSimple__c = false;
		lstProduct[0].HCSC_State__c = 'IL';
		lstProduct[0].Product_Type__c = 'Medical';
		lstProduct[0].Id = MockRelationshipHelper.Id.generate( Product2.SObjectType );

		lstProduct[1].RecordTypeId = hcscNonBlueSTARRecordTypeId;
		lstProduct[1].Name = 'PPO';
		lstProduct[1].Simplified_Product__c = 'PPO';
		lstProduct[1].NotSimple__c = false;
		lstProduct[1].HCSC_State__c = 'IL';
		lstProduct[1].Product_Type__c = 'Dental';
		lstProduct[1].Id = MockRelationshipHelper.Id.generate( Product2.SObjectType );

		Test.StartTest();

		List<Group_Section__c> testGroupSection = new List<Group_Section__c>();

		Group_Section__c temp = new Group_Section__c();
		temp.Group_Account__c = testAcntGrp.id;
		temp.Status__c = 'Active';
		temp.Cancellation_Status__c = 'Cancellation Rejected';
		temp.Total_Healthcare_Active_Members__c = 10;
		temp.Total_Dental_Active_Members__c = 10;
		temp.Id = MockRelationshipHelper.Id.generate( Group_Section__c.SObjectType );
		TestGroupSection.add(temp);

		Group_Section__c temp1 = new Group_Section__c();
		temp1.Group_Account__c = testAcntGrp.id;
		temp1.Status__c = 'Active';
		temp1.Total_Dental_Active_Members__c = 10;
		temp1.Total_Healthcare_Active_Members__c = 10;
		temp1.Cancellation_Status__c = 'Cancellation Rejected';
		temp1.Id = MockRelationshipHelper.Id.generate( Group_Section__c.SObjectType );
		TestGroupSection.add(temp1);

		List<Benefit_Agreement__c> testBenefitAgreementLst = new List<Benefit_Agreement__c>();

		Benefit_Agreement__c testBnftAgrmt1 = new Benefit_Agreement__c ();
		testBnftAgrmt1.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt1.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt1.Product__c = lstProduct[0].id;
		testBnftAgrmt1.Renewal_Date__c = System.today();
		testBnftAgrmt1.Funding_Type__c = 'ACAP';
		testBnftAgrmt1.Status__c = 'Active';
		testBnftAgrmt1.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(testBnftAgrmt1);

		Benefit_Agreement__c testBnftAgrmt2 = new Benefit_Agreement__c ();
		testBnftAgrmt2.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt2.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt2.Product__c = lstProduct[0].id;
		testBnftAgrmt2.Status__c = 'Active';
		testBnftAgrmt2.Funding_Type__c = 'ASO';
		testBnftAgrmt2.Renewal_Date__c = System.today();
		testBnftAgrmt2.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(testBnftAgrmt2);

		Benefit_Agreement__c testBnftAgrmt3 = new Benefit_Agreement__c ();
		testBnftAgrmt3.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt3.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt3.Product__c = lstProduct[1].id;
		testBnftAgrmt3.Status__c = 'Active';
		testBnftAgrmt3.Funding_Type__c = 'PREM';
		testBnftAgrmt3.Renewal_Date__c = System.today();
		testBnftAgrmt3.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(TestBnftAgrmt3);

		Benefit_Agreement__c testBnftAgrmt6 = new Benefit_Agreement__c ();
		testBnftAgrmt6.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt6.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt6.Product__c = lstProduct[1].id;
		testBnftAgrmt6.Status__c = 'Active';
		testBnftAgrmt6.Funding_Type__c = 'MPP';
		testBnftAgrmt6.Renewal_Date__c = System.today();
		testBnftAgrmt6.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(TestBnftAgrmt6);

		Benefit_Agreement__c testBnftAgrmt7 = new Benefit_Agreement__c ();
		testBnftAgrmt7.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt7.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt7.Product__c = lstProduct[1].id;
		testBnftAgrmt7.Status__c = 'Active';
		testBnftAgrmt7.Funding_Type__c = 'COST';
		testBnftAgrmt7.Renewal_Date__c = System.today();
		testBnftAgrmt7.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(TestBnftAgrmt7);

		Benefit_Agreement__c testBnftAgrmt8 = new Benefit_Agreement__c ();
		testBnftAgrmt8.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt8.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt8.Product__c = lstProduct[1].id;
		testBnftAgrmt8.Status__c = 'Active';
		testBnftAgrmt8.Funding_Type__c = 'PAR';
		testBnftAgrmt8.Renewal_Date__c = System.today();
		testBnftAgrmt8.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(TestBnftAgrmt8);

		Benefit_Agreement__c testBnftAgrmt9 = new Benefit_Agreement__c ();
		testBnftAgrmt9.Group_Account__c = testAcntGrp.id;
		testBnftAgrmt9.Effective_Date__c =  System.today() - 1;
		testBnftAgrmt9.Product__c = lstProduct[1].id;
		testBnftAgrmt9.Status__c = 'Active';
		testBnftAgrmt9.Funding_Type__c = 'SERV';
		testBnftAgrmt9.Renewal_Date__c = System.today();
		testBnftAgrmt9.Id = MockRelationshipHelper.Id.generate( Benefit_Agreement__c.SObjectType );
		testBenefitAgreementLst.add(TestBnftAgrmt9);

		List<BA_GS_Assignment__c> testBAGSAsgnt = new List<BA_GS_Assignment__c>();
		
		BA_GS_Assignment__c temp8BAGS = new BA_GS_Assignment__c();
		temp8BAGS.Benefit_Agreement__c = testBnftAgrmt9.id;
		temp8BAGS.Group_Section__c = testGroupSection[1].id;
		temp8BAGS.External_ID__c = '101023344344345';
		temp8BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp8BAGS);

		BA_GS_Assignment__c temp7BAGS = new BA_GS_Assignment__c();
		temp7BAGS.Benefit_Agreement__c = testBnftAgrmt8.id;
		temp7BAGS.Group_Section__c = testGroupSection[1].id;
		temp7BAGS.External_ID__c = '1010154344345';
		temp7BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp7BAGS);

		BA_GS_Assignment__c temp6BAGS = new BA_GS_Assignment__c();
		temp6BAGS.Benefit_Agreement__c = testBnftAgrmt7.id;
		temp6BAGS.Group_Section__c = testGroupSection[1].id;
		temp6BAGS.External_ID__c = '1010154344';
		temp6BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp6BAGS);

		BA_GS_Assignment__c temp5BAGS = new BA_GS_Assignment__c();
		temp5BAGS.Benefit_Agreement__c = testBnftAgrmt6.id;
		temp5BAGS.Group_Section__c = testGroupSection[1].id;
		temp5BAGS.External_ID__c = '10101543';
		temp5BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp5BAGS);

		BA_GS_Assignment__c tempBAGS = new BA_GS_Assignment__c();
		tempBAGS.Benefit_Agreement__c = testBenefitAgreementLst[0].id;
		tempBAGS.Group_Section__c = testGroupSection[0].id;
		tempBAGS.External_ID__c = '101011';
		tempBAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(tempBAGS);

		BA_GS_Assignment__c temp1BAGS = new BA_GS_Assignment__c();
		temp1BAGS.Benefit_Agreement__c = testBenefitAgreementLst[0].id;
		temp1BAGS.Group_Section__c = testGroupSection[1].id;
		temp1BAGS.External_ID__c = '101012';
		temp1BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp1BAGS);

		BA_GS_Assignment__c temp2BAGS = new BA_GS_Assignment__c();
		temp2BAGS.Benefit_Agreement__c = testBenefitAgreementLst[1].id;
		temp2BAGS.Group_Section__c = testGroupSection[0].id;
		temp2BAGS.External_ID__c = '101013';
		temp2BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp2BAGS);

		BA_GS_Assignment__c temp3BAGS = new BA_GS_Assignment__c();
		temp3BAGS.Benefit_Agreement__c = testBenefitAgreementLst[1].id;
		temp3BAGS.Group_Section__c = testGroupSection[1].id;
		temp3BAGS.External_ID__c = '101014';
		temp3BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp3BAGS);

		BA_GS_Assignment__c temp4BAGS = new BA_GS_Assignment__c();
		temp4BAGS.Benefit_Agreement__c = testBenefitAgreementLst[2].id;
		temp4BAGS.Group_Section__c = testGroupSection[1].id;
		temp4BAGS.External_ID__c = '101015';
		temp4BAGS.Id = MockRelationshipHelper.Id.generate( BA_GS_Assignment__c.SObjectType );
		testBAGSAsgnt.add(temp4BAGS);

		Opportunity opp = new Opportunity(AccountId = testAcntGrp.Id, HCSC_Division__c = 'IL', Name = 'oppName 2', StageName = 'Won',
		CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1),
		Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1),
		Primary_Closed_Reason__c = 'Savings', Requested_Effective_Date__c = System.Today() - 1);
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
		opp.Id = MockRelationshipHelper.Id.generate( Opportunity.SObjectType );

		List<Opportunity_Product__c> opptyProd = TestClassUtiltity.createOppProducts(opp.Id, lstProduct[0].Id);
		opptyProd[0].Status__c = 'Won';
		opptyProd[0].Product_Type__c = 'New Sale';
		opptyProd[0].Projected_Members__c = 5;
		opptyProd[0].Funding_Type__c = 'ASO';
		opptyProd[0].Id = MockRelationshipHelper.Id.generate( Opportunity_Product__c.SObjectType );

		List<Opportunity> opportunities = (List<Opportunity>)
		MockRelationshipHelper.makeRelationship(
		    List<Opportunity>.class,
		new List<Opportunity> { opp },
		Opportunity_Product__c.Opportunity_Name__c,
		new List<List<Opportunity_Product__c>> { opptyProd });

		PageReference pageRef = new PageReference('/apex/CustomContractsCurrProdsController');
		pageRef.getParameters().put('?id=', testCase.Id);
		Test.setCurrentPage(pageRef);
	
		fflib_ApexMocks accountMocks = new fflib_ApexMocks();

		AccountDAO.IAccountDAO accountDAOInstance;
		accountDAOInstance = new MockDAOs.AccountDAOMock(accountMocks);

		accountMocks.startStubbing();
		accountMocks.when(accountDAOInstance.getAccountForCustomContractsProdsPage(testAcntGrp.Id))
		.thenReturn(testAcntGrp);
		accountMocks.stopStubbing();

		fflib_ApexMocks oppMocks = new fflib_ApexMocks();

		OpportunityDAO.IOpportunityDAO opportunityDAOInstance;
		opportunityDAOInstance = new MockDAOs.OpportunityDAOMock(oppMocks);

		oppMocks.startStubbing();
		oppMocks.when(opportunityDAOInstance.getOpportunitiesForCustomContractsCurrProds(testAcntGrp.Id, hcscNonBlueSTARRecordTypeId))
		.thenReturn(opportunities);
		oppMocks.stopStubbing();

		List<Benefit_Agreement__c> mainBenefitAgreementList = new List<Benefit_Agreement__c>();

		List<Benefit_Agreement__c> benefitAgreements = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt1},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		List<Benefit_Agreement__c> benefitAgreements2 = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt2},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		List<Benefit_Agreement__c> benefitAgreements3 = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt3},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		List<Benefit_Agreement__c> benefitAgreements4 = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt6},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		List<Benefit_Agreement__c> benefitAgreements5 = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt7},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		List<Benefit_Agreement__c> benefitAgreements6 = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt8},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		List<Benefit_Agreement__c> benefitAgreements7 = (List<Benefit_Agreement__c>)
		MockRelationshipHelper.makeRelationship(
		    List<Benefit_Agreement__c>.class,
		new List<Benefit_Agreement__c> {testBnftAgrmt9},
		BA_GS_Assignment__c.Benefit_Agreement__c,
		new List<List<BA_GS_Assignment__c>> { testBAGSAsgnt });

		mainBenefitAgreementList.addALL(benefitAgreements);
		mainBenefitAgreementList.addALL(benefitAgreements2);
		mainBenefitAgreementList.addALL(benefitAgreements3);
		mainBenefitAgreementList.addALL(benefitAgreements4);
		mainBenefitAgreementList.addALL(benefitAgreements5);
		mainBenefitAgreementList.addALL(benefitAgreements6);
		mainBenefitAgreementList.addALL(benefitAgreements7);

		fflib_ApexMocks benefitAgreementMocks = new fflib_ApexMocks();

		BenefitAgreementDAO.IBenefitAgreementDAO benefitAgreementDAOInstance;
		benefitAgreementDAOInstance = new MockDAOs.BenefitAgreementDAOMock(benefitAgreementMocks);

		benefitAgreementMocks.startStubbing();
		benefitAgreementMocks.when(benefitAgreementDAOInstance.getBenefitAgreementsForCurrentProds(testAcntGrp.Id))
		.thenReturn(mainBenefitAgreementList);
		benefitAgreementMocks.stopStubbing();

		ApexPAges.StandardController sc2 = new ApexPages.StandardController(testCase);
		CustomContractsCurrProdsController myCntrl = new CustomContractsCurrProdsController(sc2, accountDAOInstance, benefitAgreementDAOInstance, opportunityDAOInstance);

		myCntrl.accountDAOInstance = accountDAOInstance;
		myCntrl.benefitAgreementDAOInstance = benefitAgreementDAOInstance;
		myCntrl.opportunityDAOInstance = opportunityDAOInstance;

		System.assertEquals(8, myCntrl.currentProductsList.size());

		Test.StopTest();
	}

	@isTest static void CustomContractsCurrProdsControllerTestNonGroup() {

		Account testAcntGrp = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
		testAcntGrp.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		testAcntGrp.HCSC_Division__c = 'IL';
		testAcntGrp.Status__c = 'Active';
		testAcntGrp.Id = MockRelationshipHelper.Id.generate( Account.SObjectType );

		Case testCase = new Case(AccountId = testAcntGrp.Id, Number_of_Lives__c = 10, Negotiation_Type__c = 'Negotiation Type', Agreement_Submitted__c = 'Agreement Submitted',
		State__c = 'State', Status = 'Request from Sales & Marketing, Draft', Account_Type_Custom_Contract__c = 'Account Type', Type__c = 'Value 1',
		Type = 'Value 2');
		testCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
		testCase.Id = MockRelationshipHelper.Id.generate( Case.SObjectType );

		List<Product2> lstProduct =  TestClassUtiltity.createProducts();
		Id hcscNonBlueSTARRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(Label.Product2_RecordType_HCSC_Non_BlueStar_Product).getRecordTypeId();

		lstProduct[0].RecordTypeId = hcscNonBlueSTARRecordTypeId;
		lstProduct[0].Name = 'PPO';
		lstProduct[0].Simplified_Product__c = 'PPO';
		lstProduct[0].NotSimple__c = false;
		lstProduct[0].HCSC_State__c = 'IL';
		lstProduct[0].Product_Type__c = 'Medical';
		lstProduct[0].Id = MockRelationshipHelper.Id.generate( Product2.SObjectType );

		Opportunity opp = new Opportunity(AccountId = testAcntGrp.Id, HCSC_Division__c = 'IL', Name = 'oppName 2', StageName = 'Expected In',
		CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1),
		Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1),
		Primary_Closed_Reason__c = 'Savings', Requested_Effective_Date__c = System.Today() - 1);
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
		opp.Id = MockRelationshipHelper.Id.generate( Opportunity.SObjectType );

		List<Opportunity_Product__c> opptyProd = TestClassUtiltity.createOppProducts(opp.Id, lstProduct[0].Id);
		opptyProd[0].Status__c = 'In Progress';
		opptyProd[0].Product_Type__c = 'New Sale';
		opptyProd[0].Projected_Members__c = 5;
		opptyProd[0].Funding_Type__c = 'ASO';
		opptyProd[0].Id = MockRelationshipHelper.Id.generate( Opportunity_Product__c.SObjectType );

		List<Opportunity> opportunities = (List<Opportunity>)
		MockRelationshipHelper.makeRelationship(
		    List<Opportunity>.class,
		new List<Opportunity> { opp },
		Opportunity_Product__c.Opportunity_Name__c,
		new List<List<Opportunity_Product__c>> { opptyProd });

		PageReference pageRef = new PageReference('/apex/CustomContractsCurrProdsController');
		pageRef.getParameters().put('?id=', testCase.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks accountMocks = new fflib_ApexMocks();

		AccountDAO.IAccountDAO accountDAOInstance;
		accountDAOInstance = new MockDAOs.AccountDAOMock(accountMocks);

		accountMocks.startStubbing();
		accountMocks.when(accountDAOInstance.getAccountForCustomContractsProdsPage(testAcntGrp.Id))
		.thenReturn(testAcntGrp);
		accountMocks.stopStubbing();

		fflib_ApexMocks oppMocks = new fflib_ApexMocks();

		OpportunityDAO.IOpportunityDAO opportunityDAOInstance;
		opportunityDAOInstance = new MockDAOs.OpportunityDAOMock(oppMocks);

		oppMocks.startStubbing();
		oppMocks.when(opportunityDAOInstance.getOpportunitiesForCustomContractsActiveProds(testAcntGrp.Id))
		.thenReturn(opportunities);
		oppMocks.stopStubbing();

		BenefitAgreementDAO.IBenefitAgreementDAO benefitAgreementDAOInstance;

		ApexPAges.StandardController sc2 = new ApexPages.StandardController(testCase);
		CustomContractsCurrProdsController myCntrl = new CustomContractsCurrProdsController(sc2, accountDAOInstance, benefitAgreementDAOInstance, opportunityDAOInstance);

		myCntrl.accountDAOInstance = accountDAOInstance;
		myCntrl.benefitAgreementDAOInstance = benefitAgreementDAOInstance;
		myCntrl.opportunityDAOInstance = opportunityDAOInstance;

		System.assertEquals(1, myCntrl.currentProductsList.size());

	}
}