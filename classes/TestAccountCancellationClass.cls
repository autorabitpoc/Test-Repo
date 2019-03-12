/************************************************************************************
*  Apex Class Name     : TestAccountCancellationClass
*  Version             : 1.0
*  Function            : This is a test class for AccountCancellationClass .
*  Modification Log    :
*  Developer				Date			Description
* -----------------------------------------------------------------------------------                 
*  Sruthy Dileep            6/1/2015
*  Zachary Campbell			09/23/2017		SFDC-5767	
*  Padma Bedampeta          10/20/2017      SFDC-5792
*  Zachary Campbell			12/08/2017		SFDC-7455
*  Nathan Shuyler			12/08/2017		SFDC-7485
*  Nathan Shuyler           01/19/2018      Added Methods - testRetroGroupSectionCancellation
                                                          - testGroupSectionCancellation
                                                          - testRetroCategoryCancellation
                                                          - testCategoryCancellation
*************************************************************************************/
@isTest
public class TestAccountCancellationClass {
    
    static testMethod void AccountCompleteCancelTest() {
        try{
            Profile p = [SELECT Id FROM Profile LIMIT 1];
            User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
            
			set<id> LGNATestGpId = new set<id>();
            
            List<Account> testAccount1 = new List<Account>();
            List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
            CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
            insert CSobjlst1;
            Account testAcc = TestClassUtiltity.CreateAccountRecord('Test Account');
            testAcc.Small_Group_Cancellation__c = false; 
            testAcc.Market_Segment__c = 'LG';            
            testAcc.Underwriter__c = uwUser.id;
            testAcc.Requested_Cancellation_Date__c = system.Today().adddays(-70); 
            testAcc.Underwriter_Name__c = 'testttt'+uwUser.Name;
            testAcc.Renewal_Date__c = system.Today();
            testAcc.AR_Cancellation_Flag__c = 'ARCAN';
            system.debug('UW Name = '+uwUser.Name);            
            testAccount1.add(testAcc);
            update testAccount1;            
            list<Product2> LstProduct =  TestClassUtiltity.createProducts();
            insert LstProduct;
            
			Case CaseObj = new Case();
        	CaseObj.Subject = 'Test';
        	CaseObj.Type = 'Account Structure';
        	CaseObj.Sub_Category__c = 'Group Section Cancellation';
        	CaseObj.Status = 'New';
        	CaseObj.AccountId = testAcc.Id;
        	insert CaseObj;
            
            Benefit_Agreement__c TestBnftAgrmt1 = new Benefit_Agreement__c ();
            TestBnftAgrmt1.Group_Account__c= testAccount1[0].id;
            TestBnftAgrmt1.Effective_Date__c =  system.today()-1;
            TestBnftAgrmt1.Product__c = LstProduct[0].id;
            TestBnftAgrmt1.status__c = 'Active';
            TestBnftAgrmt1.Cancellation_Status__c = 'Cancellation Rejected';
            insert TestBnftAgrmt1;            
            Benefit_Agreement__c TestBnftAgrmt2 = new Benefit_Agreement__c ();
            TestBnftAgrmt2.Group_Account__c= testAccount1[0].id;
            TestBnftAgrmt2.Effective_Date__c =  system.today()-1;
            TestBnftAgrmt2.Product__c = LstProduct[0].id;
            TestBnftAgrmt2.status__c = 'Active';
            TestBnftAgrmt2.Cancellation_Status__c = 'Cancellation Rejected';
            insert TestBnftAgrmt2;            
            
			/*GEMS_Group_Section__c TestGroupSection = new GEMS_Group_Section__c();
            TestGroupSection.Account__c = testAccount1[0].id;
			TestGroupSection.Case__c = CaseObj.id;
            TestGroupSection.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection.Section_No__c = '0000';
            TestGroupSection.Group_No__c = 'GS0000';
            insert TestGroupSection;
            set<id> TestGpId = new set<id>();
            TestGpId.add(TestGroupSection.id);*/
            
            Group_Section__c TestGroupSection1 = new Group_Section__c();
            TestGroupSection1.Group_Account__c = testAccount1[0].id;
            TestGroupSection1.status__c = 'Active';
            TestGroupSection1.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection1.Funding_Type__c = 'ASO';            
            insert TestGroupSection1;
            LGNATestGpId.add(TestGroupSection1.id);
            
			/*GEMS_Group_Section__c TestGroupSection1 = new GEMS_Group_Section__c();
            TestGroupSection1.Account__c = testAccount1[0].id;
            TestGroupSection1.Case__c = CaseObj.id;
            TestGroupSection1.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection1.Section_No__c = '0001';
            TestGroupSection1.Group_No__c = 'GS0001';
            insert TestGroupSection1;
            GEMSTestGpId.add(TestGroupSection1.id);*/
            
            Group_Section__c TestGroupSection2 = new Group_Section__c();
            TestGroupSection2.Group_Account__c = testAccount1[0].id;
            TestGroupSection2.status__c = 'Active';
            TestGroupSection2.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection2.Funding_Type__c = 'ASO';            
            insert TestGroupSection2;
            LGNATestGpId.add(TestGroupSection2.id);
            
            BA_GS_Assignment__c TestBAGSAsgnt = new BA_GS_Assignment__c();
            //TestBAGSAsgnt.Benefit_Agreement__c = TestBenefitAgreementLst[0].id;
            TestBAGSAsgnt.Benefit_Agreement__c = TestBnftAgrmt1.id;
            TestBAGSAsgnt.Group_Section__c = TestGroupSection1.id;
            TestBAGSAsgnt.External_ID__c = '101010';
            insert TestBAGSAsgnt;
            
            /*GEMS_Billing_Profile__c TestBilling = new GEMS_Billing_Profile__c();
            TestBilling.Account__c = testAccount1[0].id;
            TestBilling.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling.Case__c = CaseObj.id;
            insert TestBilling;*/
            
            Billing__c TestBilling = new Billing__c();
            TestBilling.Group_Account__c = testAccount1[0].id;
            TestBilling.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling.status__c = 'Active';
            insert TestBilling;
            
            test.StartTest();
            
            PageReference myVfPage2 = new PageReference('/apex/AccountCompleteCancellation');
            myVfPage2.getParameters().put('id',testAccount1[0].id);
            Test.setCurrentPage(myVfPage2);
            
            ApexPAges.StandardController sc2 = new ApexPages.StandardController(testAccount1[0]);
            AccountCancellationClass testController2 = new AccountCancellationClass(sc2);        
            testController2.accountid = testAccount1[0].id;
            //testController2.getBenefitAgreementWrapper();
            testController2.getRelatedBenefitAgreementWrapper();
            testController2.setRelatedBenefitAgreementWrapper(testController2.BAWrapperList);        
            
            //testController2.BAWrapperList[0].entrySelected  = true;
            //testController2.BAWrapperList[1].entrySelected  = true;
            if(testController2.grpSectionWrapperList.size() > 0) {
            	testController2.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController2.BillingWrapperList.size() > 0) {
				testController2.BillingWrapperList[0].entrySelected  = true;
            }
            
            testController2.grpSecIds = LGNATestGpId;
            testController2.selectedValue = 'Group';
            testController2.populatePicklistValues('Group');
            testController2.populatePicklistValues('Complete');
            testController2.populatePicklistValues('Benefit');
            testController2.populatePicklistValues('Billing');
            testController2.NavigateToSelectedPage();
            testController2.AccountRecord = testAccount1;
            testController2.getItems();
            //testController2.getCancellationReasonValues();
            testController2.confirmcancellationAccount();
            testController2.cancel();
            testController2.backToAccountHome();
            
            Id recTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC BlueStar Product').getRecordTypeId();
            LstProduct[0].recordtypeid = recTypeId;
            update LstProduct;            
            TestBilling.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBilling;
            TestBnftAgrmt1.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBnftAgrmt1;            
            TestBnftAgrmt2.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBnftAgrmt2;            
            TestGroupSection1.Cancellation_Status__c = 'Cancellation Rejected';
            update TestGroupSection1;
            TestGroupSection2.Cancellation_Status__c = 'Requested Cancellation';
            update TestGroupSection2;
            
            testController2.moveToAccountCompCancelReviewPg();
            testController2.moveToAccountCompCancel();
            testController2.click();            
            testController2.getGroupSectionList();
            testController2.getGroupSectionWrapperList();
            testController2.getSelectedGroupSectionWrapperList();
            testController2.getRelatedBenefitAgreement();
            
            // 		testController2.MassUpdate();            
            //		testController2.FinishGroupSection();
            //		testController2.backToGroupSection();
            //		testController2.MoveTonextPage();
            
            testController2.getRelatedGroupSectionWrapper();
            testController2.setRelatedGroupSectionWrapper(testController2.grpSectionWrapperList);
            
            if(testController2.grpSectionWrapperList.size() > 0) {
            	testController2.grpSectionWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().adddays(-70);
            	testController2.grpSectionWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            	testController2.grpSectionWrapperList[0].entry.Cancellation_Reason__c = 'test';
            	testController2.grpSectionWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController2.MassUpdate();            
            testController2.FinishGroupSection();
            testController2.backToGroupSection();            
            testController2.MoveTonextPage();
            //testController2.HideMessagePanel();
            testController2.getBAList();
            
            testController2.getBAWrapperList();
            testController2.getSelectedBAWrapperList();
            testController2.getRelatedGroupSection();
            testController2.MassUpdateBenefitAgree();
            testController2.FinishBenefitAgreeCancel();
            testController2.backToBenefitAgreementCan();
            testController2.MoveTonextBenefitAgreePage();
            
            
            //testController2.BAWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
            //testController2.BAWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            //testController2.BAWrapperList[0].entry.Cancellation_Reason__c = 'test';
            //testController2.BAWrapperList[0].entry.Cancellation_Code__c = 'test';
            testController2.MoveTonextBenefitAgreePage();
            
            testController2.HideMessagePanelBA();
            testController2.getBillingList();
            testController2.getBillingProfileWrapperList();
            testController2.getSeelectedBillingWrapperList();
            testController2.CancelExplanation = 'test';
            testController2.CancelReason = 'test';
            testController2.CancelCode = '12';
            testController2.CancelDate = system.today();       
            
            //testController2.MassUpdateBilling();
            //testController2.showselectedBillingProf();
            
            if(testController2.BillingWrapperList.size() > 0) {
            	testController2.BillingWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
            	testController2.BillingWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            	testController2.BillingWrapperList[0].entry.Cancellation_Reason__c = 'test';
            	testController2.BillingWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController2.showselectedBillingProf();
            testController2.backTobillingsection();
            testController2.FinishBillingProfileCancel();
            testController2.HideMessagePanelBP();
            testController2.backcancellationAccount();
            testController2.DiplaycancellationAccountMessage();
            
            testController2.selectedValue = 'Complete';
            testController2.NavigateToSelectedPage();
            
            testController2.selectedValue = 'Benefit';
            testController2.NavigateToSelectedPage();
            
            testController2.selectedValue = 'Billing';
            pageReference pg = testController2.NavigateToSelectedPage();
            
            //testController2.BAWrapperList[0].entrySelected  = false;
            //testController2.BAWrapperList[1].entrySelected  = false;
            
            if(testController2.grpSectionWrapperList.size() > 0) {
            	testController2.grpSectionWrapperList[0].entrySelected  = true;
            }
			if(testController2.BillingWrapperList.size() > 0) {
            	testController2.BillingWrapperList[0].entrySelected  = true;
            }
            testController2.MoveTonextPage();
            testController2.MoveTonextBenefitAgreePage();
            testController2.showselectedBillingProf();
            
            testController2.CancelExplanation = 'test';
            testController2.CancelReason = 'test';
            testController2.CancelDate = system.today();
            testController2.CancelCode = '12';
            testController2.StringCancelDate = '12/27/2017';   
            testController2.MassUpdate();
            testController2.MassUpdateBilling();
            testController2.MassUpdateBenefitAgree();
            
            //system.assertEquals(pg.getURL(),'/apex/billingProfileCancellation?Id=' + testAccount2[0].Id);
            test.StopTest();
            
        }catch(Exception e){
            throw e;
        }
    }
    
    static testMethod void GEMSCancelTest() {
        try{
            Profile p = [SELECT Id FROM Profile LIMIT 1];
            User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
            
            set<id> GEMSTestGpId = new set<id>();            
            
            List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
            CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
            insert CSobjlst1;
            List<Account> testAccount1 = new List<Account>();
            Account testAcc = TestClassUtiltity.CreateAccountRecord('Test Account');
            testAcc.Small_Group_Cancellation__c = false; 
            testAcc.Market_Segment__c = 'LG';            
            testAcc.Underwriter__c = uwUser.id;
            testAcc.Requested_Cancellation_Date__c = system.Today().adddays(-70); 
            testAcc.Underwriter_Name__c = 'testttt'+uwUser.Name;
            testAcc.Renewal_Date__c = system.Today();
            system.debug('UW Name = '+uwUser.Name);            
            testAccount1.add(testAcc);
            update testAccount1;            
            list<Product2> LstProduct =  TestClassUtiltity.createProducts();
            insert LstProduct;
            system.debug('Zac Test Account ID = '+ testAccount1[0].Id);
            
			Case CaseObj = new Case();
        	CaseObj.Subject = 'Test';
        	CaseObj.Type = 'Account Structure';
        	CaseObj.Sub_Category__c = 'Group Section Cancellation';
        	CaseObj.Status = 'New';
        	CaseObj.AccountId = testAcc.Id;
        	insert CaseObj;
            system.debug('Zac Test Case ID = '+ CaseObj.Id);
            
            Benefit_Agreement__c TestBnftAgrmt1 = new Benefit_Agreement__c ();
            TestBnftAgrmt1.Group_Account__c= testAccount1[0].id;
            TestBnftAgrmt1.Effective_Date__c =  system.today()-1;
            TestBnftAgrmt1.Product__c = LstProduct[0].id;
            TestBnftAgrmt1.status__c = 'Active';
            TestBnftAgrmt1.Cancellation_Status__c = 'Cancellation Rejected';
            insert TestBnftAgrmt1;            
            Benefit_Agreement__c TestBnftAgrmt2 = new Benefit_Agreement__c ();
            TestBnftAgrmt2.Group_Account__c= testAccount1[0].id;
            TestBnftAgrmt2.Effective_Date__c =  system.today()-1;
            TestBnftAgrmt2.Product__c = LstProduct[0].id;
            TestBnftAgrmt2.status__c = 'Active';
            TestBnftAgrmt2.Cancellation_Status__c = 'Cancellation Rejected';
            insert TestBnftAgrmt2;            
            
			/*GEMS_Group_Section__c TestGroupSection = new GEMS_Group_Section__c();
            TestGroupSection.Account__c = testAccount1[0].id;
			TestGroupSection.Case__c = CaseObj.id;
            TestGroupSection.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection.Section_No__c = '0000';
            TestGroupSection.Group_No__c = 'GS0000';
            insert TestGroupSection;
            set<id> TestGpId = new set<id>();
            TestGpId.add(TestGroupSection.id);*/
            
            /*Group_Section__c TestGroupSection = new Group_Section__c();
            TestGroupSection.Group_Account__c = testAccount1[0].id;
            TestGroupSection.status__c = 'Active';
            TestGroupSection.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection.Funding_Type__c = 'ASO';            
            insert TestGroupSection;
            LGNATestGpId.add(TestGroupSection.id);*/
            
			GEMS_Group_Section__c TestGroupSection1 = new GEMS_Group_Section__c();
            TestGroupSection1.Account__c = testAccount1[0].id;
            TestGroupSection1.Case__c = CaseObj.id;
            TestGroupSection1.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection1.Section_No__c = '0001';
            TestGroupSection1.Group_No__c = 'GS0001';
            insert TestGroupSection1;
            GEMSTestGpId.add(TestGroupSection1.id);
            
            /*Group_Section__c TestGroupSection5 = new Group_Section__c();
            TestGroupSection5.Group_Account__c = testAccount1[0].id;
            TestGroupSection5.status__c = 'Active';
            TestGroupSection5.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection5.Funding_Type__c = 'ASO';            
            insert TestGroupSection5;
            LGNATestGpId.add(TestGroupSection5.id);*/
            
            /*BA_GS_Assignment__c TestBAGSAsgnt = new BA_GS_Assignment__c();
            //TestBAGSAsgnt.Benefit_Agreement__c = TestBenefitAgreementLst[0].id;
            TestBAGSAsgnt.Benefit_Agreement__c = TestBnftAgrmt1.id;
            TestBAGSAsgnt.Group_Section__c = TestGroupSection1.id;
            TestBAGSAsgnt.External_ID__c = '101010';
            insert TestBAGSAsgnt;*/
            
            GEMS_Billing_Profile__c TestBilling = new GEMS_Billing_Profile__c();
            TestBilling.Account__c = testAccount1[0].id;
            TestBilling.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling.Case__c = CaseObj.id;
            insert TestBilling;
            
            /*Billing__c TestBilling2 = new Billing__c();
            TestBilling2.Group_Account__c = testAccount1[0].id;
            TestBilling2.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling2.status__c = 'Active';
            insert TestBilling2;*/
            
            test.StartTest();
            
            PageReference myVfPage2 = new PageReference('/apex/AccountCancellationGroupSection');
            test.setCurrentPageReference(myVfPage2);
            myVfPage2.getParameters().put('id',testAccount1[0].id);
            //myVfPage2.getParameters().put('Case',CaseObj.Id);
            //myVfPage2.getParameters().put('selectedValue','Group');            
            Test.setCurrentPage(myVfPage2);
            
            ApexPAges.StandardController sc2 = new ApexPages.StandardController(testAccount1[0]);
            AccountCancellationClass testController2 = new AccountCancellationClass(sc2);        
            testController2.accountid = testAccount1[0].id;
			testController2.caseid = CaseObj.id;

            testController2.getGroupSectionList();
            testController2.getGroupSectionWrapperList();
            testController2.gsInitialLoad();
            //testController2.getBenefitAgreementWrapper();
            testController2.getRelatedBenefitAgreementWrapper();
            testController2.setRelatedBenefitAgreementWrapper(testController2.BAWrapperList);        
            
            //testController2.BAWrapperList[0].entrySelected  = true;
            //testController2.BAWrapperList[1].entrySelected  = true;
            if(testController2.grpSectionWrapperList.size() > 0) {
            	testController2.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController2.BillingWrapperList.size() > 0) {
				testController2.BillingWrapperList[0].entrySelected  = true;
            }
            
            testController2.grpSecIds = GEMSTestGpId;
            testController2.selectedValue = 'Group';
            testController2.populatePicklistValues('Group');
            testController2.populatePicklistValues('Complete');
            testController2.populatePicklistValues('Benefit');
            testController2.populatePicklistValues('Billing');
            testController2.NavigateToSelectedPage();
            testController2.AccountRecord = testAccount1;
            testController2.getItems();
            //testController2.getCancellationReasonValues();
            testController2.confirmcancellationAccount();
            testController2.cancel();
            testController2.backToAccountHome();
            
            Id recTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC BlueStar Product').getRecordTypeId();
            LstProduct[0].recordtypeid = recTypeId;
            update LstProduct;            
            TestBilling.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBilling;
            TestBnftAgrmt1.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBnftAgrmt1;            
            TestBnftAgrmt2.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBnftAgrmt2;            
            TestGroupSection1.Cancellation_Status__c = 'Cancellation Rejected';
            update TestGroupSection1;
            TestGroupSection1.Cancellation_Status__c = 'Requested Cancellation';
            update TestGroupSection1;
            
            testController2.moveToAccountCompCancelReviewPg();
            testController2.moveToAccountCompCancel();
            testController2.click();            

            testController2.getSelectedGroupSectionWrapperList();
            testController2.getRelatedBenefitAgreement();
            
            // 		testController2.MassUpdate();            
            //		testController2.FinishGroupSection();
            //		testController2.backToGroupSection();
            //		testController2.MoveTonextPage();
            
            testController2.getRelatedGroupSectionWrapper();
            testController2.setRelatedGroupSectionWrapper(testController2.grpSectionWrapperList);
            
            if(testController2.grpSectionWrapperList.size() > 0) {
            	testController2.grpSectionWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().adddays(-70);
            	testController2.grpSectionWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            	testController2.grpSectionWrapperList[0].entry.Cancellation_Reason__c = 'test';
            	testController2.grpSectionWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController2.MassUpdate();       
            system.debug('Zac AccountID = '+ testcontroller2.accountid);
            system.debug('Zac CaseID = '+ testcontroller2.caseid);
            testController2.FinishGroupSection();
            testController2.backToGroupSection();            
            testController2.MoveTonextPage();
            testController2.HideMessagePanelBA();
            testController2.getBAList();
            
            testController2.getBAWrapperList();
            testController2.getSelectedBAWrapperList();
            testController2.getRelatedGroupSection();
            testController2.MassUpdateBenefitAgree();
            testController2.FinishBenefitAgreeCancel();
            testController2.backToBenefitAgreementCan();
            testController2.MoveTonextBenefitAgreePage();
            
            
            //testController2.BAWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
            //testController2.BAWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            //testController2.BAWrapperList[0].entry.Cancellation_Reason__c = 'test';
            //testController2.BAWrapperList[0].entry.Cancellation_Code__c = 'test';
            testController2.MoveTonextBenefitAgreePage();
            
            testController2.HideMessagePanelBA();
            testController2.getBillingList();
            testController2.getBillingProfileWrapperList();
            testController2.getSeelectedBillingWrapperList();
            testController2.CancelExplanation = 'test';
            testController2.CancelReason = 'test';
            testController2.CancelCode = '12';
            testController2.CancelDate = system.today();       
            
            //testController2.MassUpdateBilling();
            //testController2.showselectedBillingProf();
            
            if(testController2.BillingWrapperList.size() > 0) {
            	testController2.BillingWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
            	testController2.BillingWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            	testController2.BillingWrapperList[0].entry.Cancellation_Reason__c = 'test';
            	testController2.BillingWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController2.showselectedBillingProf();
            testController2.backTobillingsection();
            testController2.FinishBillingProfileCancel();
            testController2.HideMessagePanelBP();
            testController2.backcancellationAccount();
            testController2.DiplaycancellationAccountMessage();
            
            testController2.selectedValue = 'Complete';
            testController2.NavigateToSelectedPage();
            
            testController2.selectedValue = 'Benefit';
            testController2.NavigateToSelectedPage();
            
            testController2.selectedValue = 'Billing';
            pageReference pg = testController2.NavigateToSelectedPage();
            
            //testController2.BAWrapperList[0].entrySelected  = false;
            //testController2.BAWrapperList[1].entrySelected  = false;
            testController2.bpInitialLoad();
            if(testController2.grpSectionWrapperList.size() > 0) {
            	testController2.grpSectionWrapperList[0].entrySelected  = true;
            }
			if(testController2.BillingWrapperList.size() > 0) {
            	testController2.BillingWrapperList[0].entrySelected  = true;
            }
            testController2.MoveTonextPage();
            testController2.MoveTonextBenefitAgreePage();
            testController2.showselectedBillingProf();
            
            testController2.CancelExplanation = 'test';
            testController2.CancelReason = 'test';
            testController2.CancelDate = system.today();
            testController2.CancelCode = '12';
            testController2.StringCancelDate = '12/27/2017';   
            testController2.MassUpdate();
            testController2.MassUpdateBilling();
            testController2.MassUpdateBenefitAgree();
            
            //system.assertEquals(pg.getURL(),'/apex/billingProfileCancellation?Id=' + testAccount2[0].Id);
            test.StopTest();
            
            
        }catch(Exception e){
            throw e;
        }
    }    
    Static testMethod void myUnitTest3(){
        try{
            Profile p = [SELECT Id FROM Profile LIMIT 1];
            User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
            
         //system.assertEquals(pg.getURL(),'/apex/billingProfileCancellation?Id=' + testAccount1[0].Id);
            //Start of SG Account Test Data
            list<Market_Segment__c> sgsmList = new list<Market_Segment__c>();
            sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='1'));
            insert sgsmList;
            List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
            CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
            insert CSobjlst1;
           // sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='2')); 
            List<Account> testAccount2 = new List<Account>();
            Account testAcc1 = TestClassUtiltity.CreateAccountRecord('Test Account1');
            testAcc1.Small_Group_Cancellation__c = True; 
            testAcc1.Market_Segment__c = 'HMSG';            
            testAcc1.Underwriter__c = uwUser.id;
            testAcc1.Requested_Cancellation_Date__c = system.Today().adddays(-50); 
            testAcc1.Underwriter_Name__c = 'testttt'+uwUser.Name;
            testAcc1.Renewal_Date__c = system.Today();
            system.debug('UW Name = '+uwUser.Name);            
            testAccount2.add(testAcc1);
            update testAccount2;            
            list<Product2> LstProduct1 =  TestClassUtiltity.createProducts();
            insert LstProduct1;
            
			Case CaseObj1 = new Case();
        	CaseObj1.Subject = 'Test';
        	CaseObj1.Type = 'Account Structure';
        	CaseObj1.Sub_Category__c = 'Group Section Cancellation';
        	CaseObj1.Status = 'New';
        	CaseObj1.AccountId = testAcc1.Id;
        	insert CaseObj1;
/*            
            Benefit_Agreement__c TestBnftAgrmt3 = new Benefit_Agreement__c ();
            TestBnftAgrmt3.Group_Account__c= testAccount2[0].id;
            TestBnftAgrmt3.Effective_Date__c =  system.today()-1;
            TestBnftAgrmt3.Product__c = LstProduct1[0].id;
            TestBnftAgrmt3.status__c = 'Active';
            TestBnftAgrmt3.Cancellation_Status__c = 'Cancellation Rejected';
            insert TestBnftAgrmt3;            
            Benefit_Agreement__c TestBnftAgrmt4 = new Benefit_Agreement__c ();
            TestBnftAgrmt4.Group_Account__c= testAccount2[0].id;
            TestBnftAgrmt4.Effective_Date__c =  system.today()-1;
            TestBnftAgrmt4.Product__c = LstProduct1[0].id;
            TestBnftAgrmt4.status__c = 'Active';
            TestBnftAgrmt4.Cancellation_Status__c = 'Cancellation Rejected';
            insert TestBnftAgrmt4;            
*/            
            GEMS_Group_Section__c TestGroupSection3 = new GEMS_Group_Section__c();
            TestGroupSection3.Account__c = testAccount2[0].id;
            TestGroupSection3.Case__c = CaseObj1.id;
            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection3.Section_No__c = '0003';
            TestGroupSection3.Group_No__c = 'GS0003';
            insert TestGroupSection3;
            set<id> TestGpId1 = new set<id>();
            TestGpId1.add(TestGroupSection3.id);

            /*Group_Section__c TestGroupSection3 = new Group_Section__c();
            TestGroupSection3.Group_Account__c = testAccount2[0].id;
            TestGroupSection3.status__c = 'Active';
            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection3.Funding_Type__c = 'ASO';            
            insert TestGroupSection3;
            set<id> TestGpId1 = new set<id>();
            TestGpId1.add(TestGroupSection3.id);*/
            
            GEMS_Group_Section__c TestGroupSection4 = new GEMS_Group_Section__c();
            TestGroupSection4.Account__c = testAccount2[0].id;
            TestGroupSection4.Case__c = CaseObj1.id;
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
			TestGroupSection4.Section_No__c = '0004';
            TestGroupSection4.Group_No__c = 'GS0004';            
            insert TestGroupSection4;
            TestGpId1.add(TestGroupSection4.id);

            /*Group_Section__c TestGroupSection4 = new Group_Section__c();
            TestGroupSection4.Group_Account__c = testAccount2[0].id;
            TestGroupSection4.status__c = 'Active';
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection4.Funding_Type__c = 'ASO';            
            insert TestGroupSection4;
            TestGpId1.add(TestGroupSection4.id);*/ 
/*            
            BA_GS_Assignment__c TestBAGSAsgnt1 = new BA_GS_Assignment__c();
            //TestBAGSAsgnt.Benefit_Agreement__c = TestBenefitAgreementLst[0].id;
            TestBAGSAsgnt1.Benefit_Agreement__c = TestBnftAgrmt3.id;
            TestBAGSAsgnt1.Group_Section__c = TestGroupSection4.id;
            TestBAGSAsgnt1.External_ID__c = '1010101';
            insert TestBAGSAsgnt1;
*/            
            GEMS_Billing_Profile__c TestBilling1 = new GEMS_Billing_Profile__c();
            TestBilling1.Account__c = testAccount2[0].id;
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling1.Case__c = CaseObj1.id;
            insert TestBilling1;
            
			/*Billing__c TestBilling1 = new Billing__c();
            TestBilling1.Group_Account__c = testAccount2[0].id;
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling1.status__c = 'Active';
            insert TestBilling1;*/
            
            
             test.StartTest();
            
            PageReference myVfPage3 = new PageReference('/apex/AccountCancellationHome');
            myVfPage3.getParameters().put('id',testAccount2[0].id);
            Test.setCurrentPage(myVfPage3);
            
            ApexPAges.StandardController sc3 = new ApexPages.StandardController(testAccount2[0]);
            AccountCancellationClass testController3 = new AccountCancellationClass(sc3);        
            testController3.accountid = testAccount2[0].id;
            testController3.marketSegment = testAccount2[0].Market_Segment__c; 
           
            //testController3.getBenefitAgreementWrapper();
            testController3.getRelatedBenefitAgreementWrapper();
            testController3.setRelatedBenefitAgreementWrapper(testController3.BAWrapperList);        
            
            //testController3.BAWrapperList[0].entrySelected  = true;
            //testController3.BAWrapperList[1].entrySelected  = true;
            if(testController3.grpSectionWrapperList.size() > 0) {            
            	testController3.grpSectionWrapperList[0].entrySelected  = true;
            }
			if(testController3.BillingWrapperList.size() > 0) {
            	testController3.BillingWrapperList[0].entrySelected  = true;
            }
            
            testController3.grpSecIds = TestGpId1;
            testController3.selectedValue = 'Group';
            testController3.populatePicklistValues('Group');
            testController3.populatePicklistValues('Complete');
            testController3.populatePicklistValues('Benefit');
            testController3.populatePicklistValues('Billing');
            testController3.NavigateToSelectedPage();
            testController3.AccountRecord = testAccount2;
            testController3.getItems();
            //testController3.getCancellationReasonValues();
            testController3.confirmcancellationAccount();
            testController3.cancel();
            testController3.backToAccountHome();
            
            Id recTypeId1=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC BlueStar Product').getRecordTypeId();
            LstProduct1[0].recordtypeid = recTypeId1;
            update LstProduct1;            
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBilling1;
/*            TestBnftAgrmt3.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBnftAgrmt3;            
            TestBnftAgrmt4.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBnftAgrmt4;            
*/            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            update TestGroupSection3;
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
            update TestGroupSection4;
            
            testController3.moveToAccountCompCancelReviewPg();
            testController3.moveToAccountCompCancel();
            testController3.click();            
            testController3.getGroupSectionList();
            testController3.getGroupSectionWrapperList();
            testController3.getSelectedGroupSectionWrapperList();
            testController3.getRelatedBenefitAgreement();
            
            // 		testController3.MassUpdate();            
            //		testController3.FinishGroupSection();
            //		testController3.backToGroupSection();
            //		testController3.MoveTonextPage();
            
            testController3.getRelatedGroupSectionWrapper();
            testController3.setRelatedGroupSectionWrapper(testController3.grpSectionWrapperList);
            
            if(testController3.grpSectionWrapperList.size() > 0) {
            	testController3.grpSectionWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().adddays(-70);
            	testController3.grpSectionWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            	testController3.grpSectionWrapperList[0].entry.Cancellation_Reason__c = 'test';
            	testController3.grpSectionWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController3.MassUpdate();            
            testController3.FinishGroupSection();
            testController3.backToGroupSection();            
            testController3.MoveTonextPage();
            //testController3.HideMessagePanel();
            testController3.getBAList();
            
            testController3.getBAWrapperList();
            testController3.getSelectedBAWrapperList();
            testController3.getRelatedGroupSection();
            testController3.MassUpdateBenefitAgree();
            testController3.FinishBenefitAgreeCancel();
            testController3.backToBenefitAgreementCan();
            testController3.MoveTonextBenefitAgreePage();
            
            
            //testController3.BAWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
            //testController3.BAWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            //testController3.BAWrapperList[0].entry.Cancellation_Reason__c = 'test';
            //testController3.BAWrapperList[0].entry.Cancellation_Code__c = 'test';
            testController3.MoveTonextBenefitAgreePage();
            
            testController3.HideMessagePanelBA();
            testController3.getBillingList();
            testController3.getBillingProfileWrapperList();
            testController3.getSeelectedBillingWrapperList();
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelCode = '12';
            testController3.CancelDate = system.today();       
            
            //testController3.MassUpdateBilling();
            //testController3.showselectedBillingProf();
            
            if(testController3.BillingWrapperList.size() > 0) {
            	testController3.BillingWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
            	testController3.BillingWrapperList[0].entry.Cancellation_Explanation__c = 'test';
            	testController3.BillingWrapperList[0].entry.Cancellation_Reason__c = 'test';
            	testController3.BillingWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
                
            testController3.showselectedBillingProf();
            testController3.backTobillingsection();
            testController3.FinishBillingProfileCancel();
            testController3.HideMessagePanelBP();
            testController3.backcancellationAccount();
            testController3.DiplaycancellationAccountMessage();
            
            testController3.selectedValue = 'Complete';
            testController3.NavigateToSelectedPage();
            
            testController3.selectedValue = 'Benefit';
            testController3.NavigateToSelectedPage();
            
            testController3.selectedValue = 'Billing';
            pageReference pg1 = testController3.NavigateToSelectedPage();
            
            //testController3.BAWrapperList[0].entrySelected  = false;
            //testController3.BAWrapperList[1].entrySelected  = false;
            if(testController3.grpSectionWrapperList.size() > 0) {
            	testController3.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController3.BillingWrapperList.size() > 0) {
            	testController3.BillingWrapperList[0].entrySelected  = true;
            }
            testController3.MoveTonextPage();
            testController3.MoveTonextBenefitAgreePage();
            testController3.showselectedBillingProf();
            
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelDate = system.today();
            testController3.CancelCode = '12';
            testController3.StringCancelDate = '12/27/2017';   
            testController3.MassUpdate();
            testController3.MassUpdateBilling();
            testController3.MassUpdateBenefitAgree();
            //END of SG Account Test Data
            }catch(Exception e){
            throw e;
        }
            
    }
    
    static testMethod void testMailConstruction(){
        Test.startTest();
        List<String> recipients = new List<String>{'test@email.com'};
            List<String> ccRecipients = new List<String>{'testcc@email.com'};
                String sender = 'nomail@email.com';
        String displayName = 'display name';
        String subject = 'subject';
        String messageBody = 'body';
        String htmlBody = '<b>body</b>';
        Messaging.SingleEmailMessage testMessage = AccountCancellationClass.sendEmail(recipients, ccRecipients, sender, displayName, subject, messageBody, htmlBody);
        System.assertEquals('body', testMessage.getPlainTextBody());
        System.assertEquals('<b>body</b>', testMessage.getHtmlBody());
        Test.stopTest();
    }
    
    static testMethod void testRetroactiveMessageGeneration(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile LIMIT 1];
        //generateRetroactiveCancellationMessage
        Id accId = fflib_IDGenerator.generate(Account.sObjectType);
        Id gsId1 = fflib_IDGenerator.generate(GEMS_Group_Section__c.sObjectType);
        Id gsId2 = fflib_IDGenerator.generate(GEMS_Group_Section__c.sObjectType);
        User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
        User ownerUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername2@email.com', 'lastName2', 'testOwnerEmail@email.com');
        System.runAs(ownerUser){    
            Account testAcc = new Account(Name='TestAcc', Effective_Date__c=System.Today()-1, Requested_Cancellation_Date__c=System.Today().adddays(-61),HCSC_Division__c ='IL', External_Id__c='1920841', OwnerId=ownerUser.Id, Underwriter__c=uwUser.Id);
            insert testAcc;
            GEMS_Group_Section__c testGrpSec1 = new GEMS_Group_Section__c(Id=gsId1,Requested_Cancellation_Date__c=System.Today().adddays(-1));
            GEMS_Group_Section__c testGrpSec2 = new GEMS_Group_Section__c(Id=gsId2,Requested_Cancellation_Date__c=System.Today().adddays(-61));
            List<GEMS_Group_Section__c> grpSecs = new List<GEMS_Group_Section__c>{testGrpSec1, testGrpSec2};
                List<String> messages = AccountCancellationClass.generateRetroactiveCancellationMessage(testAcc, grpSecs, false);
            System.debug(messages);
            testGrpSec2.Requested_Cancellation_Date__c = System.Today().adddays(61);
            messages = AccountCancellationClass.generateRetroactiveCancellationMessage(testAcc, grpSecs, true);
        }
        Test.stopTest();
    }
    
    Static testMethod void test0004(){
        try{
            Profile p = [SELECT Id FROM Profile LIMIT 1];
            User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
            
            //Start of SG Account Test Data
            list<Market_Segment__c> sgsmList = new list<Market_Segment__c>();
            sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='1'));
            insert sgsmList;
            List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
            CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
            insert CSobjlst1;
            /* SFDC-7452 - Start */
            /* add LGNA Feature Flag Custom Settings */
            LGNAFeatureFlags__c TheFeatureFlags = new LGNAFeatureFlags__c();
            TheFeatureFlags.LGNA_Billing_Profile_Retro_Cancellation__c = True;
            TheFeatureFlags.LGNA_Category_Retro_Cancellation__c = True;
            TheFeatureFlags.LGNA_Grp_Section_Retro_Cancellation__c = True;
            insert TheFeatureFlags;
            /* SFDC-7452 - Start */
            
            List<Account> testAccount2 = new List<Account>();
            Account testAcc1 = TestClassUtiltity.CreateAccountRecord('Test Account1');
            testAcc1.Small_Group_Cancellation__c = True; 
            testAcc1.Market_Segment__c = 'HMSG';            
            testAcc1.Underwriter__c = uwUser.id;
            testAcc1.Requested_Cancellation_Date__c = system.Today().adddays(-50); 
            testAcc1.Underwriter_Name__c = 'testttt'+uwUser.Name;
            testAcc1.Renewal_Date__c = system.Today();
            system.debug('UW Name = '+uwUser.Name);            
            testAccount2.add(testAcc1);
            update testAccount2;            
            list<Product2> LstProduct1 =  TestClassUtiltity.createProducts();
            insert LstProduct1;
            
            Case CaseObj1 = new Case();
            CaseObj1.Subject = 'Test';
            CaseObj1.Type = 'Account Structure';
            CaseObj1.Sub_Category__c = 'Group Section Cancellation';
            CaseObj1.Status = 'New';
            CaseObj1.AccountId = testAcc1.Id;
            CaseObj1.Underwriter_Lookup__c = uwUser.Id;
            insert CaseObj1;
            
            GEMS_Group_Section__c TestGroupSection3 = new GEMS_Group_Section__c();
            TestGroupSection3.Account__c = testAccount2[0].id;
            TestGroupSection3.Case__c = CaseObj1.id;
            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection3.Section_No__c = '0003';
            TestGroupSection3.Group_No__c = 'GS0003';
            insert TestGroupSection3;
            set<id> TestGpId1 = new set<id>();
            TestGpId1.add(TestGroupSection3.id);
            
            GEMS_Group_Section__c TestGroupSection4 = new GEMS_Group_Section__c();
            TestGroupSection4.Account__c = testAccount2[0].id;
            TestGroupSection4.Case__c = CaseObj1.id;
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection4.Section_No__c = '0004';
            TestGroupSection4.Group_No__c = 'GS0004';            
            insert TestGroupSection4;
            TestGpId1.add(TestGroupSection4.id);
            
            GEMS_Billing_Profile__c TestBilling1 = new GEMS_Billing_Profile__c();
            TestBilling1.Account__c = testAccount2[0].id;
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling1.Case__c = CaseObj1.id;
            insert TestBilling1;
            
            /* SFDC-7801 - BEGIN */
            GEMS_Category__c TestCategory1 = new GEMS_Category__c();
            TestCategory1.Account__c = testAccount2[0].id;
            TestCategory1.Case__c = CaseObj1.id;            
            insert TestCategory1;
            set<id> TestCatId1 = new set<id>();
            TestCatId1.add(TestCategory1.id);
            /*SFDC-7801 - END */
            
            test.StartTest();
            
            PageReference myVfPage3 = new PageReference('/apex/AccountCancellationHome');
            myVfPage3.getParameters().put('id',testAccount2[0].id);
            Test.setCurrentPage(myVfPage3);
            
            ApexPAges.StandardController sc3 = new ApexPages.StandardController(testAccount2[0]);
            AccountCancellationClass testController3 = new AccountCancellationClass(sc3);        
            testController3.accountid = testAccount2[0].id;
            testController3.marketSegment = testAccount2[0].Market_Segment__c; 
            
            testController3.getRelatedBenefitAgreementWrapper();
            testController3.setRelatedBenefitAgreementWrapper(testController3.BAWrapperList);        
            
            if(testController3.grpSectionWrapperList.size() > 0) {            
                testController3.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController3.BillingWrapperList.size() > 0) {
                testController3.BillingWrapperList[0].entrySelected  = true;
            }
            
            testController3.catIds = TestCatId1;
            testController3.grpSecIds = TestGpId1;
            testController3.selectedValue = 'Group';
            testController3.populatePicklistValues('Group');
            testController3.populatePicklistValues('Complete');
            testController3.populatePicklistValues('Benefit');
            testController3.populatePicklistValues('Billing');
            testController3.populatePicklistValues('Category'); /* SFDC-7801 */
            testController3.NavigateToSelectedPage();
            testController3.AccountRecord = testAccount2;
            testController3.getItems();
            
            testController3.confirmcancellationAccount();
            testController3.cancel();
            testController3.backToAccountHome();
            
            Id recTypeId1=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC BlueStar Product').getRecordTypeId();
            LstProduct1[0].recordtypeid = recTypeId1;
            update LstProduct1;            
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            update TestBilling1;
            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            update TestGroupSection3;
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
            update TestGroupSection4;
            
            testController3.moveToAccountCompCancelReviewPg();
            testController3.moveToAccountCompCancel();
            testController3.click();            
            testController3.getGroupSectionList();
            testController3.getGroupSectionWrapperList();
            testController3.getSelectedGroupSectionWrapperList();
            testController3.getRelatedBenefitAgreement();            
            
            testController3.getRelatedGroupSectionWrapper();
            testController3.setRelatedGroupSectionWrapper(testController3.grpSectionWrapperList);
            
            if(testController3.grpSectionWrapperList.size() > 0) {
                testController3.grpSectionWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().adddays(-70);
                testController3.grpSectionWrapperList[0].entry.Cancellation_Explanation__c = 'test';
                testController3.grpSectionWrapperList[0].entry.Cancellation_Reason__c = 'test';
                testController3.grpSectionWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController3.MassUpdate(); 
            testController3.caseId = CaseObj1.id;            
            testcontroller3.RetroConfirmation();
            testcontroller3.CancelMessagePanel();
            testController3.FinishGroupSection();
            testController3.backToGroupSection();            
            testController3.MoveTonextPage();
            //testController3.HideMessagePanel();
            testController3.getBAList();
            
            testController3.getBAWrapperList();
            testController3.getSelectedBAWrapperList();
            testController3.getRelatedGroupSection();
            testController3.MassUpdateBenefitAgree();
            testController3.FinishBenefitAgreeCancel();
            testController3.backToBenefitAgreementCan();
            testController3.MoveTonextBenefitAgreePage();
            
            testController3.MoveTonextBenefitAgreePage();
            
            testController3.HideMessagePanelBA();
            testController3.getBillingList();
            testController3.getBillingProfileWrapperList();
            testController3.getSeelectedBillingWrapperList();
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelCode = '12';
            testController3.CancelDate = system.today();                   
            
            if(testController3.BillingWrapperList.size() > 0) {
                testController3.BillingWrapperList[0].entry.Requested_Cancellation_Date__c = system.Today().addyears(-1);
                testController3.BillingWrapperList[0].entry.Cancellation_Explanation__c = 'test';
                testController3.BillingWrapperList[0].entry.Cancellation_Reason__c = 'test';
                testController3.BillingWrapperList[0].entry.Cancellation_Code__c = 'test';
            }
            
            testController3.showselectedBillingProf();
            testController3.backTobillingsection();
            testController3.FinishBillingProfileCancel();
            testController3.HideMessagePanelBP();
            testController3.backcancellationAccount();
            testController3.DiplaycancellationAccountMessage();
            
            testController3.selectedValue = 'Complete';
            testController3.NavigateToSelectedPage();
            
            testController3.selectedValue = 'Benefit';
            testController3.NavigateToSelectedPage();
            
            testController3.selectedValue = 'Billing';
            pageReference pg1 = testController3.NavigateToSelectedPage();
            
            if(testController3.grpSectionWrapperList.size() > 0) {
                testController3.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController3.BillingWrapperList.size() > 0) {
                testController3.BillingWrapperList[0].entrySelected  = true;
            }
            testController3.MoveTonextPage();
            testController3.MoveTonextBenefitAgreePage();
            testController3.showselectedBillingProf();
            
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelDate = system.today();
            testController3.CancelCode = '12';
            testController3.StringCancelDate = '12/27/2017';   
            testController3.MassUpdate();
            testController3.MassUpdateBilling();
            testController3.MassUpdateBenefitAgree();
            //END of SG Account Test Data
            
            /* SFDC-7801 - Category Cancellation - Start */
            /* go to Page */
            testController3.selectedValue = 'Category';
            pg1 = testController3.NavigateToSelectedPage();
            
            /* fill in the Info Boxes on the Page */
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelDate = system.today();
            testController3.CancelCode = '12';
            
            /* Select the Row to Apply the Info Box items too */
            testController3.getCategoryWrapperList();            
            if(testController3.categoryWrapperList.size() > 0) {
                testController3.categoryWrapperList[0].entrySelected  = true;
            }
            /* Apply the Info Box things */
            testController3.CategoryMassUpdate();
            /* Go to Confirmation Page */
            testController3.MoveCategoryNextPage();
            /* Finish button */
            testController3.finishCategory();                       
            /* SFDC-7801 - Category Cancellation - End */
            
            
            
        }catch(Exception e){
            throw e;
        }            
    }   
    
    Static testMethod void testRetroCategoryCancellation(){
        try{
            Profile p = [SELECT Id FROM Profile LIMIT 1];
            User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
            
            //Start of SG Account Test Data
            list<Market_Segment__c> sgsmList = new list<Market_Segment__c>();
            sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='1'));
            insert sgsmList;
             List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
            CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
            insert CSobjlst1;           
            /* add LGNA Feature Flag Custom Settings */
            LGNAFeatureFlags__c TheFeatureFlags = new LGNAFeatureFlags__c();
            TheFeatureFlags.LGNA_Billing_Profile_Retro_Cancellation__c = True;
            TheFeatureFlags.LGNA_Category_Retro_Cancellation__c = True;
            TheFeatureFlags.LGNA_Grp_Section_Retro_Cancellation__c = True;
            insert TheFeatureFlags;
                        
            List<Account> testAccount2 = new List<Account>();
            Account testAcc1 = TestClassUtiltity.CreateAccountRecord('Test Account1');
            testAcc1.Small_Group_Cancellation__c = False; 
            testAcc1.Market_Segment__c = 'HMSG';            
            testAcc1.Underwriter__c = uwUser.id;
            testAcc1.Requested_Cancellation_Date__c = system.Today().adddays(-50); 
            testAcc1.Underwriter_Name__c = 'testttt'+uwUser.Name;
            testAcc1.Renewal_Date__c = system.Today();
            system.debug('UW Name = '+uwUser.Name);            
            testAccount2.add(testAcc1);
            update testAccount2;            
            list<Product2> LstProduct1 =  TestClassUtiltity.createProducts();
            insert LstProduct1;
            
            Case CaseObj1 = new Case();
            CaseObj1.Subject = 'Test';
            CaseObj1.Type = 'Account Structure';
            CaseObj1.Sub_Category__c = 'Group Section Cancellation';
            CaseObj1.Status = 'New';
            CaseObj1.AccountId = testAcc1.Id;
            CaseObj1.Underwriter_Lookup__c = uwUser.Id;
            insert CaseObj1;
            
            GEMS_Group_Section__c TestGroupSection3 = new GEMS_Group_Section__c();
            TestGroupSection3.Account__c = testAccount2[0].id;
            TestGroupSection3.Case__c = CaseObj1.id;
            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection3.Section_No__c = '0003';
            TestGroupSection3.Group_No__c = 'GS0003';
            insert TestGroupSection3;
            set<id> TestGpId1 = new set<id>();
            TestGpId1.add(TestGroupSection3.id);
            
            GEMS_Group_Section__c TestGroupSection4 = new GEMS_Group_Section__c();
            TestGroupSection4.Account__c = testAccount2[0].id;
            TestGroupSection4.Case__c = CaseObj1.id;
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection4.Section_No__c = '0004';
            TestGroupSection4.Group_No__c = 'GS0004';            
            insert TestGroupSection4;
            TestGpId1.add(TestGroupSection4.id);
            
            GEMS_Billing_Profile__c TestBilling1 = new GEMS_Billing_Profile__c();
            TestBilling1.Account__c = testAccount2[0].id;
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling1.Case__c = CaseObj1.id;
            insert TestBilling1;
            
            GEMS_Category__c TestCategory1 = new GEMS_Category__c();
            TestCategory1.Account__c = testAccount2[0].id;
            TestCategory1.Case__c = CaseObj1.id;            
            insert TestCategory1;
            set<id> TestCatId1 = new set<id>();
            TestCatId1.add(TestCategory1.id);            
            
            test.StartTest();
            
            PageReference myVfPage3 = new PageReference('/apex/AccountCancellationHome');
            myVfPage3.getParameters().put('id',testAccount2[0].id);
            Test.setCurrentPage(myVfPage3);
            
            ApexPAges.StandardController sc3 = new ApexPages.StandardController(testAccount2[0]);
            AccountCancellationClass testController3 = new AccountCancellationClass(sc3);        
            testController3.accountid = testAccount2[0].id;
            testController3.marketSegment = testAccount2[0].Market_Segment__c; 
            
            testController3.getRelatedBenefitAgreementWrapper();
            testController3.setRelatedBenefitAgreementWrapper(testController3.BAWrapperList);        
            
            if(testController3.grpSectionWrapperList.size() > 0) {            
                testController3.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController3.BillingWrapperList.size() > 0) {
                testController3.BillingWrapperList[0].entrySelected  = true;
            }
            
            testController3.caseId = CaseObj1.id;
            testController3.catIds = TestCatId1;
            testController3.grpSecIds = TestGpId1;
            testController3.selectedValue = 'Category';
            testController3.populatePicklistValues('Group');
            testController3.populatePicklistValues('Complete');
            testController3.populatePicklistValues('Benefit');
            testController3.populatePicklistValues('Billing');
            testController3.populatePicklistValues('Category'); 
            testController3.NavigateToSelectedPage();
            testController3.AccountRecord = testAccount2;
            testController3.getItems();            
                        
            /* go to Page */
            testController3.selectedValue = 'Category';
            Pagereference pg1 = testController3.NavigateToSelectedPage();
            
            /* fill in the Info Boxes on the Page */
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelDate = system.today().adddays(-70);  /* RETRO DATE !! */
            testController3.CancelCode = '12';
            
            /* Select the Row to Apply the Info Box items too */
            testController3.getCategoryWrapperList();            
            if(testController3.categoryWrapperList.size() > 0) {
                testController3.categoryWrapperList[0].entrySelected  = true;
            }

            /* Apply the Info Box things */
            testController3.CategoryMassUpdate();

            /* Go to Confirmation Page */
            testController3.MoveCategoryNextPage();

            /* Apply the Retro Confirm button */
            testController3.RetroConfirmation_Cat();

            /* Finish button */
            testController3.finishCategory();                       
            
            /* Including these Methods for Coverage purposes */
            testController3.backToCategorySection();
            pg1 = testController3.CancelMessagePanel_Cat();            
            
        }catch(Exception e){
            throw e;
        }            
    }
    
    Static testMethod void testCategoryCancellation(){
        try{
            Profile p = [SELECT Id FROM Profile LIMIT 1];
            User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
            
            //Start of SG Account Test Data
            list<Market_Segment__c> sgsmList = new list<Market_Segment__c>();
            sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='1'));
            insert sgsmList;
            List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
            CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
            insert CSobjlst1;            
            /* add LGNA Feature Flag Custom Settings */
            LGNAFeatureFlags__c TheFeatureFlags = new LGNAFeatureFlags__c();
            TheFeatureFlags.LGNA_Billing_Profile_Retro_Cancellation__c = True;
            TheFeatureFlags.LGNA_Category_Retro_Cancellation__c = True;
            TheFeatureFlags.LGNA_Grp_Section_Retro_Cancellation__c = True;
            insert TheFeatureFlags;
                        
            List<Account> testAccount2 = new List<Account>();
            Account testAcc1 = TestClassUtiltity.CreateAccountRecord('Test Account1');
            testAcc1.Small_Group_Cancellation__c = False; 
            testAcc1.Market_Segment__c = 'HMSG';            
            testAcc1.Underwriter__c = uwUser.id;
            testAcc1.Requested_Cancellation_Date__c = system.Today().adddays(-50); 
            testAcc1.Underwriter_Name__c = 'testttt'+uwUser.Name;
            testAcc1.Renewal_Date__c = system.Today();
            system.debug('UW Name = '+uwUser.Name);            
            testAccount2.add(testAcc1);
            update testAccount2;            
            list<Product2> LstProduct1 =  TestClassUtiltity.createProducts();
            insert LstProduct1;
            
            Case CaseObj1 = new Case();
            CaseObj1.Subject = 'Test';
            CaseObj1.Type = 'Account Structure';
            CaseObj1.Sub_Category__c = 'Group Section Cancellation';
            CaseObj1.Status = 'New';
            CaseObj1.AccountId = testAcc1.Id;
            CaseObj1.Underwriter_Lookup__c = uwUser.Id;
            insert CaseObj1;
            
            GEMS_Group_Section__c TestGroupSection3 = new GEMS_Group_Section__c();
            TestGroupSection3.Account__c = testAccount2[0].id;
            TestGroupSection3.Case__c = CaseObj1.id;
            TestGroupSection3.Cancellation_Status__c = 'Cancellation Rejected';
            TestGroupSection3.Section_No__c = '0003';
            TestGroupSection3.Group_No__c = 'GS0003';
            insert TestGroupSection3;
            set<id> TestGpId1 = new set<id>();
            TestGpId1.add(TestGroupSection3.id);
            
            GEMS_Group_Section__c TestGroupSection4 = new GEMS_Group_Section__c();
            TestGroupSection4.Account__c = testAccount2[0].id;
            TestGroupSection4.Case__c = CaseObj1.id;
            TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
            TestGroupSection4.Section_No__c = '0004';
            TestGroupSection4.Group_No__c = 'GS0004';            
            insert TestGroupSection4;
            TestGpId1.add(TestGroupSection4.id);
            
            GEMS_Billing_Profile__c TestBilling1 = new GEMS_Billing_Profile__c();
            TestBilling1.Account__c = testAccount2[0].id;
            TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
            TestBilling1.Case__c = CaseObj1.id;
            insert TestBilling1;
                        
            GEMS_Category__c TestCategory1 = new GEMS_Category__c();
            TestCategory1.Account__c = testAccount2[0].id;
            TestCategory1.Case__c = CaseObj1.id;            
            insert TestCategory1;
            set<id> TestCatId1 = new set<id>();
            TestCatId1.add(TestCategory1.id);           
            
            test.StartTest();
            
            PageReference myVfPage3 = new PageReference('/apex/AccountCancellationHome');
            myVfPage3.getParameters().put('id',testAccount2[0].id);
            Test.setCurrentPage(myVfPage3);
            
            ApexPAges.StandardController sc3 = new ApexPages.StandardController(testAccount2[0]);
            AccountCancellationClass testController3 = new AccountCancellationClass(sc3);        
            testController3.accountid = testAccount2[0].id;
            testController3.marketSegment = testAccount2[0].Market_Segment__c; 
            
            testController3.getRelatedBenefitAgreementWrapper();
            testController3.setRelatedBenefitAgreementWrapper(testController3.BAWrapperList);        
            
            if(testController3.grpSectionWrapperList.size() > 0) {            
                testController3.grpSectionWrapperList[0].entrySelected  = true;
            }
            if(testController3.BillingWrapperList.size() > 0) {
                testController3.BillingWrapperList[0].entrySelected  = true;
            }
            
            testController3.caseId = CaseObj1.id;
            testController3.catIds = TestCatId1;
            testController3.grpSecIds = TestGpId1;
            testController3.selectedValue = 'Category';
            testController3.populatePicklistValues('Group');
            testController3.populatePicklistValues('Complete');
            testController3.populatePicklistValues('Benefit');
            testController3.populatePicklistValues('Billing');
            testController3.populatePicklistValues('Category'); 
            testController3.NavigateToSelectedPage();
            testController3.AccountRecord = testAccount2;
            testController3.getItems();            
            
            /* go to Page */
            testController3.selectedValue = 'Category';
            Pagereference pg1 = testController3.NavigateToSelectedPage();
            /*Calling initial load of category list*/
            testController3.catInitialLoad();
            /* fill in the Info Boxes on the Page */
            testController3.CancelExplanation = 'test';
            testController3.CancelReason = 'test';
            testController3.CancelDate = system.today();
            testController3.CancelCode = '12';
            
            /* Select the Row to Apply the Info Box items too */
            testController3.getCategoryWrapperList();            
            if(testController3.categoryWrapperList.size() > 0) {
                testController3.categoryWrapperList[0].entrySelected  = true;
            }

            /* Apply the Info Box things */
            testController3.CategoryMassUpdate();

            /* Go to Confirmation Page */
            testController3.MoveCategoryNextPage();

            /* Finish button */
            testController3.finishCategory();                       
            
            /* Including these Methods for Coverage purposes */
            testController3.backToCategorySection();
            pg1 = testController3.CancelMessagePanel_Cat();                        
            
        }catch(Exception e){
            throw e;
        }            
    }
    
    Static testMethod void testGroupSectionCancellation(){
        
        Profile p = [SELECT Id FROM Profile LIMIT 1];
        User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
        
        //Start of SG Account Test Data
        list<Market_Segment__c> sgsmList = new list<Market_Segment__c>();
        sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='1'));
        insert sgsmList;
        List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
        insert CSobjlst1;
        /* add LGNA Feature Flag Custom Settings */
        LGNAFeatureFlags__c TheFeatureFlags = new LGNAFeatureFlags__c();
        TheFeatureFlags.LGNA_Billing_Profile_Retro_Cancellation__c = True;
        TheFeatureFlags.LGNA_Category_Retro_Cancellation__c = True;
        TheFeatureFlags.LGNA_Grp_Section_Retro_Cancellation__c = True;
        insert TheFeatureFlags;
        
        List<Account> testAccount2 = new List<Account>();
        Account testAcc1 = TestClassUtiltity.CreateAccountRecord('Test Account1');
        testAcc1.Small_Group_Cancellation__c = False; 
        testAcc1.Market_Segment__c = 'HMSG';            
        testAcc1.Underwriter__c = uwUser.id;
        testAcc1.Requested_Cancellation_Date__c = system.Today().adddays(-50); 
        testAcc1.Underwriter_Name__c = 'testttt'+uwUser.Name;
        testAcc1.Renewal_Date__c = system.Today();
        system.debug('UW Name = '+uwUser.Name);            
        testAccount2.add(testAcc1);
        update testAccount2;            
        list<Product2> LstProduct1 =  TestClassUtiltity.createProducts();
        insert LstProduct1;
        
        Case CaseObj1 = new Case();
        CaseObj1.Subject = 'Test';
        CaseObj1.Type = 'Account Structure';
        CaseObj1.Sub_Category__c = 'Group Section Cancellation';
        CaseObj1.Status = 'New';
        CaseObj1.AccountId = testAcc1.Id;
        CaseObj1.Underwriter_Lookup__c = uwUser.Id;
        insert CaseObj1;
        
        GEMS_Group_Section__c TestGroupSection3 = new GEMS_Group_Section__c();
        TestGroupSection3.Account__c = testAccount2[0].id;
        TestGroupSection3.Case__c = CaseObj1.id; 
        TestGroupSection3.Section_No__c = '0003';
        TestGroupSection3.Group_No__c = 'GS0003';
        insert TestGroupSection3;
        set<id> TestGpId1 = new set<id>();
        TestGpId1.add(TestGroupSection3.id);
        
        GEMS_Group_Section__c TestGroupSection4 = new GEMS_Group_Section__c();
        TestGroupSection4.Account__c = testAccount2[0].id;
        TestGroupSection4.Case__c = CaseObj1.id;
        TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
        TestGroupSection4.Section_No__c = '0004';
        TestGroupSection4.Group_No__c = 'GS0004';            
        insert TestGroupSection4;
        TestGpId1.add(TestGroupSection4.id);
        
        GEMS_Billing_Profile__c TestBilling1 = new GEMS_Billing_Profile__c();
        TestBilling1.Account__c = testAccount2[0].id;
        TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
        TestBilling1.Case__c = CaseObj1.id;
        insert TestBilling1;
        
        GEMS_Category__c TestCategory1 = new GEMS_Category__c();
        TestCategory1.Account__c = testAccount2[0].id;
        TestCategory1.Case__c = CaseObj1.id;            
        insert TestCategory1;
        set<id> TestCatId1 = new set<id>();
        TestCatId1.add(TestCategory1.id);           
        
        test.StartTest();
        
        PageReference myVfPage3 = new PageReference('/apex/AccountCancellationHome');
        myVfPage3.getParameters().put('id',testAccount2[0].id);
        Test.setCurrentPage(myVfPage3);
        
        ApexPAges.StandardController sc3 = new ApexPages.StandardController(testAccount2[0]);
        AccountCancellationClass testController3 = new AccountCancellationClass(sc3);        
        testController3.accountid = testAccount2[0].id;
        testController3.marketSegment = testAccount2[0].Market_Segment__c; 
        
        testController3.getRelatedBenefitAgreementWrapper();
        testController3.setRelatedBenefitAgreementWrapper(testController3.BAWrapperList);        
        
        if(testController3.grpSectionWrapperList.size() > 0) {            
            testController3.grpSectionWrapperList[0].entrySelected  = true;
        }
        if(testController3.BillingWrapperList.size() > 0) {
            testController3.BillingWrapperList[0].entrySelected  = true;
        }
        
        testController3.caseId = CaseObj1.id;
        testController3.catIds = TestCatId1;
        testController3.grpSecIds = TestGpId1;
        testController3.selectedValue = 'Group';
        testController3.populatePicklistValues('Group');
        testController3.populatePicklistValues('Complete');
        testController3.populatePicklistValues('Benefit');
        testController3.populatePicklistValues('Billing');
        testController3.populatePicklistValues('Category'); 
        testController3.NavigateToSelectedPage();
        testController3.AccountRecord = testAccount2;
        testController3.getItems();            
        
        /* go to Page */
        testController3.selectedValue = 'Group';
        Pagereference pg1 = testController3.NavigateToSelectedPage();            
        
        /* fill in the Info Boxes on the Page */
        testController3.CancelExplanation = 'test';
        testController3.CancelReason = 'test';
        testController3.CancelDate = system.today();
        testController3.CancelCode = '12';
        
        /* Select the Row to Apply the Info Box items too */
        testController3.getGroupSectionWrapperList();
        if(testController3.grpSectionWrapperList.size() > 0) {
            testController3.grpSectionWrapperList[0].entrySelected  = true;
        }
        
        /* Apply the Info Box things */
        testController3.MassUpdate();
        
        /* Go to Confirmation Page */
        testController3.MoveTonextPage();
        
        /* Finish button */
        testController3.FinishGroupSection();  
                
        /* adding these for coverage purposes */
        testController3.backToGroupSection();
        pg1 = testController3.CancelMessagePanel();
    }
    
    Static testMethod void testRetroGroupSectionCancellation(){
        
        Profile p = [SELECT Id FROM Profile LIMIT 1];
        User uwUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testUsername1@email.com', 'lastName1', 'testUWEmail@email.com');
        
        //Start of SG Account Test Data
        list<Market_Segment__c> sgsmList = new list<Market_Segment__c>();
        sgsmList.add(new Market_Segment__c(Type__c='SG',Value__c='HMSG',Name='1'));
        insert sgsmList;
        List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'sourceSystemCd',ARCancelRequiredField__c = 'ARCAN'));
        insert CSobjlst1;
        /* add LGNA Feature Flag Custom Settings */
        LGNAFeatureFlags__c TheFeatureFlags = new LGNAFeatureFlags__c();
        TheFeatureFlags.LGNA_Billing_Profile_Retro_Cancellation__c = True;
        TheFeatureFlags.LGNA_Category_Retro_Cancellation__c = True;
        TheFeatureFlags.LGNA_Grp_Section_Retro_Cancellation__c = True;
        insert TheFeatureFlags;
        /* SFDC-7452 - Start */
        
        List<Account> testAccount2 = new List<Account>();
        Account testAcc1 = TestClassUtiltity.CreateAccountRecord('Test Account1');
        testAcc1.Small_Group_Cancellation__c = False; 
        testAcc1.Market_Segment__c = 'HMSG';            
        testAcc1.Underwriter__c = uwUser.id;
        testAcc1.Requested_Cancellation_Date__c = system.Today().addmonths(-3); 
        testAcc1.Underwriter_Name__c = 'testttt'+uwUser.Name;
        testAcc1.Renewal_Date__c = system.Today();
        system.debug('UW Name = '+uwUser.Name);            
        testAccount2.add(testAcc1);
        update testAccount2;            
        list<Product2> LstProduct1 =  TestClassUtiltity.createProducts();
        insert LstProduct1;
        
        Case CaseObj1 = new Case();
        CaseObj1.Subject = 'Test';
        CaseObj1.Type = 'Account Structure';
        CaseObj1.Sub_Category__c = 'Group Section Cancellation';
        CaseObj1.Status = 'New';
        CaseObj1.AccountId = testAcc1.Id;
        CaseObj1.Underwriter_Lookup__c = uwUser.Id;
        insert CaseObj1;
        
        GEMS_Group_Section__c TestGroupSection3 = new GEMS_Group_Section__c();
        TestGroupSection3.Account__c = testAccount2[0].id;
        TestGroupSection3.Case__c = CaseObj1.id;
        TestGroupSection3.Section_No__c = '0003';
        TestGroupSection3.Group_No__c = 'GS0003';
        insert TestGroupSection3;
        set<id> TestGpId1 = new set<id>();
        TestGpId1.add(TestGroupSection3.id);
        
        GEMS_Group_Section__c TestGroupSection4 = new GEMS_Group_Section__c();
        TestGroupSection4.Account__c = testAccount2[0].id;
        TestGroupSection4.Case__c = CaseObj1.id;
        TestGroupSection4.Cancellation_Status__c = 'Requested Cancellation';
        TestGroupSection4.Section_No__c = '0004';
        TestGroupSection4.Group_No__c = 'GS0004';            
        insert TestGroupSection4;
        TestGpId1.add(TestGroupSection4.id);
        
        GEMS_Billing_Profile__c TestBilling1 = new GEMS_Billing_Profile__c();
        TestBilling1.Account__c = testAccount2[0].id;
        TestBilling1.Cancellation_Status__c = 'Cancellation Rejected';
        TestBilling1.Case__c = CaseObj1.id;
        insert TestBilling1;
        
        GEMS_Category__c TestCategory1 = new GEMS_Category__c();
        TestCategory1.Account__c = testAccount2[0].id;
        TestCategory1.Case__c = CaseObj1.id;            
        insert TestCategory1;
        set<id> TestCatId1 = new set<id>();
        TestCatId1.add(TestCategory1.id);           
        
        test.StartTest();
        
        PageReference myVfPage3 = new PageReference('/apex/AccountCancellationHome');
        myVfPage3.getParameters().put('id',testAccount2[0].id);
        Test.setCurrentPage(myVfPage3);
        
        ApexPAges.StandardController sc3 = new ApexPages.StandardController(testAccount2[0]);
        AccountCancellationClass testController3 = new AccountCancellationClass(sc3);        
        testController3.accountid = testAccount2[0].id;
        testController3.marketSegment = testAccount2[0].Market_Segment__c; 
        
        testController3.getRelatedBenefitAgreementWrapper();
        testController3.setRelatedBenefitAgreementWrapper(testController3.BAWrapperList);        
        
        if(testController3.grpSectionWrapperList.size() > 0) {            
            testController3.grpSectionWrapperList[0].entrySelected  = true;
        }
        if(testController3.BillingWrapperList.size() > 0) {
            testController3.BillingWrapperList[0].entrySelected  = true;
        }
        
        testController3.caseId = CaseObj1.id;
        testController3.catIds = TestCatId1;
        testController3.grpSecIds = TestGpId1;
        testController3.selectedValue = 'Group';
        testController3.populatePicklistValues('Group');
        testController3.populatePicklistValues('Complete');
        testController3.populatePicklistValues('Benefit');
        testController3.populatePicklistValues('Billing');
        testController3.populatePicklistValues('Category'); 
        testController3.NavigateToSelectedPage();
        testController3.AccountRecord = testAccount2;
        testController3.getItems();            
        
        /* go to Page */
        testController3.selectedValue = 'Group';
        Pagereference pg1 = testController3.NavigateToSelectedPage();            
        
        /* fill in the Info Boxes on the Page */
        testController3.CancelExplanation = 'test';
        testController3.CancelReason = 'test';
        testController3.CancelDate = system.today().addmonths(-3); /* RETRO DATE */
        testController3.CancelCode = '12';
        
        /* Select the Row to Apply the Info Box items too */
        testController3.getGroupSectionWrapperList();
        if(testController3.grpSectionWrapperList.size() > 0) {
            testController3.grpSectionWrapperList[0].entrySelected  = true;
        }
        
        /* Apply the Info Box things */
        testController3.MassUpdate();
        
        /* Go to Confirmation Page */
        testController3.MoveTonextPage();
        
        /* Apply the Retro Confirm button */
        testController3.RetroConfirmation();
        
        /* Finish button */
        testController3.FinishGroupSection();  
                
        /* adding these for coverage purposes */
        testController3.backToGroupSection();
        pg1 = testController3.CancelMessagePanel();
    }

    
}