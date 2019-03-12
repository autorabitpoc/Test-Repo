/**************************************************************************************
  Apex Class Name     : TestAddOpportunityProductsController
  Version             : 1.0
  Function            : This is a test class for AddOpportunityProductsController .
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sruthy Dileep            6/2/2015
*   Updated by Alec Klein/Slalom
*   Updated by Nathan Shuyler - 07/2017
*************************************************************************************/
@isTest
public class TestAddOpportunityProductsController {

    @testSetup static void setupOppProdData(){
        Test.StartTest();
        Id renewalOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id offCycleOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Off-Cycle Change').getRecordTypeId();
        Id hcscNonBluestarProductRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        
        Account testAccount = new Account(Name = 'Test Account', Fax = '1234567', Effective_Date__c = system.today().addyears(2));
        testAccount.ShippingStreet = 'TestStreet';
        testAccount.ShippingCity = 'TestCity';
        testAccount.ShippingState = 'IL';
        testAccount.ShippingPostalCode = '62401-2940';
        insert testAccount;
        
        //KK Added code for SFDC-9391 US
        Id CompRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account CompAcc = new Account(Name = 'Test Comp Account', Fax = '1234567', Effective_Date__c = system.today().addyears(2));
        CompAcc.RecordTypeId = CompRecordTypeId;
        CompAcc.ShippingStreet = 'TestStreet';
        CompAcc.ShippingCity = 'TestCity';
        CompAcc.ShippingState = 'IL';
        CompAcc.ShippingPostalCode = '62401-2940';
        insert CompAcc; 
        
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account aWinner = new Account(Name = 'The Winner', Fax = '1234567', Effective_Date__c = system.today().addyears(2));
        aWinner.RecordTypeId = vendorRecordTypeId;
        aWinner.ShippingStreet = 'TestStreet';
        aWinner.ShippingCity = 'TestCity';
        aWinner.ShippingState = 'IL';
        aWinner.ShippingPostalCode = '62401-2940';
        insert aWinner; 

        Opportunity testOpp = new Opportunity(AccountId = testAccount.Id, Name = 'Test Renewal Opp', StageName = 'Qualification', CloseDate = system.Today().addYears(2));
        testOpp.Expected_Decision_Date__c = system.Today().addYears(1);
        testOpp.RFI_RFP_Received_Date__c = system.Today().addYears(1);
        testOpp.RecordTypeId = renewalOpportunityRecordTypeId;
        testOpp.HCSC_Division__c = 'IL';

        Opportunity testOpp2 = new Opportunity(AccountId = testAccount.Id, Name = 'Test OffCycle Opp 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2));
        testOpp2.Expected_Decision_Date__c = system.Today().addYears(1);
        testOpp2.RFI_RFP_Received_Date__c = system.Today().addYears(1);
        testOpp2.RecordTypeId = offCycleOpportunityRecordTypeId;
        testOpp2.HCSC_Division__c = 'IL';

        Opportunity testOpp3 = new Opportunity(AccountId = testAccount.Id, Name = 'Test OffCycle Opp 2', StageName = 'Qualification', CloseDate = system.Today().addYears(2));
        testOpp3.Expected_Decision_Date__c = system.Today().addYears(1);
        testOpp3.RFI_RFP_Received_Date__c = system.Today().addYears(1);
        testOpp3.RecordTypeId = offCycleOpportunityRecordTypeId;
        testOpp3.HCSC_Division__c = 'IL';
        insert (new List<Opportunity>{testOpp, testOpp2, testOpp3});

        Product2 testProduct0 = new Product2(Name = 'test0', IsActive = true, Family = 'Ancillary and other');
        testProduct0.RecordTypeId = hcscNonBluestarProductRecordTypeId;
        testProduct0.HCSC_State__c = 'IL';
        testProduct0.Simplified_Product__c = 'PPO';
        testProduct0.Product_Type__c = 'Medical';
        testProduct0.Name = 'PPOCompetitorLoss';        
        testProduct0.NotSimple__c = false;
        testProduct0.Non_Medical_Compensation__c = True;        
        
        Product2 testProduct1 = new Product2(Name = 'test', IsActive = true, Family = 'Ancillary and other');
        testProduct1.RecordTypeId = hcscNonBluestarProductRecordTypeId;
        testProduct1.HCSC_State__c = 'IL';
        testProduct1.Simplified_Product__c = 'PPO';
        testProduct1.Product_Type__c = 'Medical';
        testProduct1.Name = 'PPO';
        testProduct1.NotSimple__c = false;

        Product2 testProduct2 = new Product2(Name = 'test1', IsActive = true);
        testProduct2.RecordTypeId = hcscNonBluestarProductRecordTypeId;
        testProduct2.HCSC_State__c = 'IL';
        testProduct2.Simplified_Product__c = 'Dental';
        testProduct2.Product_Type__c = 'Medical';
        testProduct2.Name = 'Dental';
        testProduct2.NotSimple__c = false;

        Product2 testProduct3 = new Product2(Name = 'test', IsActive = true, Family = 'Ancillary and other');
        testProduct3.RecordTypeId = hcscNonBluestarProductRecordTypeId;
        testProduct3.HCSC_State__c = 'IL';
        testProduct3.Simplified_Product__c = 'PPO';
        testProduct3.Product_Type__c = 'Medical';
        testProduct3.Name = 'PPO';
        testProduct3.NotSimple__c = true;

        Product2 testProduct4 = new Product2(Name = 'test1', IsActive = true);
        testProduct4.HCSC_State__c = 'IL';
        testProduct4.Name = 'Dental';
        testProduct4.Product_Type__c = 'Dental';
        testProduct4.Simplified_Product__c = 'Dental';
        testProduct4.NotSimple__c = true;
        insert (new List<Product2>{testProduct1, testProduct2, testProduct3, testProduct4, testProduct0});

        Group_Section__c testGS1 = new Group_Section__c();
        testGS1.Group_Account__c = testAccount.Id;
        testGS1.Status__c = 'Active';
        testGS1.Cancellation_Status__c = 'Cancellation Rejected';
        testGS1.Total_Dental_Active_Members__c = 10;        
        testGS1.Total_Healthcare_Active_Members__c = 10;

        Group_Section__c testGS2 = new Group_Section__c();
        testGS2.Group_Account__c = testAccount.Id;
        testGS2.Status__c = 'Active';
        testGS2.Cancellation_Status__c = 'Cancellation Rejected';
        testGS2.Total_Dental_Active_Members__c = 10;
        testGS2.Total_Healthcare_Active_Members__c = 10;
        insert (new List<Group_Section__c>{testGS1, testGS2});

        Benefit_Agreement__c testBAGR1 = new Benefit_Agreement__c ();
        testBAGR1.Group_Account__c = testAccount.Id;
        testBAGR1.Effective_Date__c =  System.Today() - 1;
        testBAGR1.Product__c = testProduct3.Id;
        testBAGR1.Renewal_Date__c = System.Today();
        testBAGR1.Status__c = 'Active';
        testBAGR1.Funding_Type__c = 'PREM';

        Benefit_Agreement__c testBAGR2 = new Benefit_Agreement__c ();
        testBAGR2.Group_Account__c = testAccount.Id;
        testBAGR2.Effective_Date__c =  System.Today() - 1;
        testBAGR2.Product__c = testProduct3.Id;
        testBAGR2.Status__c = 'Active';
        testBAGR2.Funding_Type__c = 'ACAP';
        testBAGR2.Renewal_Date__c = System.Today();

        Benefit_Agreement__c testBAGR3 = new Benefit_Agreement__c ();
        testBAGR3.Group_Account__c = testAccount.Id;
        testBAGR3.Effective_Date__c =  System.Today() - 1;
        testBAGR3.Product__c = testProduct4.Id;
        testBAGR3.Status__c = 'Active';
        testBAGR3.Funding_Type__c = 'ASO';
        testBAGR3.Renewal_Date__c = System.Today();

        Benefit_Agreement__c testBAGR4 = new Benefit_Agreement__c ();
        testBAGR4.Group_Account__c = testAccount.Id;
        testBAGR4.Effective_Date__c =  System.Today() - 1;
        testBAGR4.Product__c = testProduct4.Id;
        testBAGR4.Status__c = 'Active';
        testBAGR4.Funding_Type__c = 'SERV';
        testBAGR4.Renewal_Date__c = System.Today();

        Benefit_Agreement__c testBAGR5 = new Benefit_Agreement__c ();
        testBAGR5.Group_Account__c = testAccount.Id;
        testBAGR5.Effective_Date__c =  System.Today() - 1;
        testBAGR5.Product__c = testProduct4.Id;
        testBAGR5.Status__c = 'Active';
        testBAGR5.Funding_Type__c = 'COST';
        testBAGR5.Renewal_Date__c = System.Today();

        Benefit_Agreement__c testBAGR6 = new Benefit_Agreement__c ();
        testBAGR6.Group_Account__c = testAccount.Id;
        testBAGR6.Effective_Date__c =  System.Today() - 1;
        testBAGR6.Product__c = testProduct3.Id;
        testBAGR6.Status__c = 'Active';
        testBAGR6.Funding_Type__c = 'MPP';
        testBAGR6.Renewal_Date__c = System.Today();

        Benefit_Agreement__c testBAGR7 = new Benefit_Agreement__c ();
        testBAGR7.Group_Account__c = testAccount.Id;
        testBAGR7.Status__c = 'Active';
        testBAGR7.Funding_Type__c = 'TEST';
        insert (new List<Benefit_Agreement__c>{testBAGR1, testBAGR2, testBAGR3, 
                                                testBAGR4, testBAGR5, testBAGR6, testBAGR7});

        BA_GS_Assignment__c testBAGS1 = new BA_GS_Assignment__c();
        testBAGS1.Benefit_Agreement__c = testBAGR4.Id;
        testBAGS1.Group_Section__c = testGS1.Id;
        testBAGS1.External_Id__c = '1010123';

        //9
        BA_GS_Assignment__c testBAGS2 = new BA_GS_Assignment__c();
        testBAGS2.Benefit_Agreement__c = testBAGR5.Id;
        testBAGS2.Group_Section__c = testGS1.Id;
        testBAGS2.External_Id__c = '1010123454546463';
        //6
        BA_GS_Assignment__c testBAGS3 = new BA_GS_Assignment__c();
        testBAGS3.Benefit_Agreement__c = testBAGR6.Id;
        testBAGS3.Group_Section__c = testGS2.Id;
        testBAGS3.External_Id__c = '1010123231';
        insert (new List<BA_GS_Assignment__c>{testBAGS1, testBAGS2, testBAGS3});
        Test.StopTest();
    }

    static testMethod void myUnitTest1() {
        try {
            Account testAccount = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'Test Account' LIMIT 1];

            List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(testAccount.id);
            testOpp[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            insert testOpp;

            Benefit_Agreement__c TestBenefitAgreement = new Benefit_Agreement__c();
            TestBenefitAgreement.Group_Account__c = testAccount.id;
            TestBenefitAgreement.Status__c = 'Active';
            insert TestBenefitAgreement;

            list<Product2> products = TestClassUtiltity.createProducts();
            insert products;

            list<Opportunity_Product__c> OppProducts = TestClassUtiltity.createOppProducts(testOpp[0].id, products[0].Id);
            OppProducts[0].Benefit_Agreement__c = TestBenefitAgreement.Id;
            OppProducts[0].Product_Type__c = 'Renewal';
            insert OppProducts;

            PageReference myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpp[0].id);
            Test.setCurrentPage(myVfPage2);

            test.StartTest();

            ApexPAges.StandardSetController sc2 = new ApexPages.StandardSetController(testOpp);
            AddOpportunityProductsController myCntrl = new AddOpportunityProductsController(sc2);
            myCntrl.opportunityObj = testOpp[0];
            myCntrl.numberOfRowToRemove = 1;
            myCntrl.recordToDelete = OppProducts[0].Id;
            myCntrl.removeRow();

            myCntrl.AddNewOpportunityProduct();
            myCntrl.saveOpportunityProducts();
            myCntrl.gotoOpportunity();
            System.assertEquals(7, myCntrl.listOfOpportunityProducts.size());

            test.StopTest();

        } catch (Exception e) {
            throw e;
        }
    }

    static testMethod void myUnitTest2() {
        try {
            Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
            TestAcnt.ShippingStreet = 'TestStreet';
            TestAcnt.ShippingCity = 'TestCity';
            TestAcnt.ShippingState = 'IL';
            TestAcnt.ShippingPostalCode = '62401-2940';
            //TestAcnt.ShippingCountry = 'United States';
            update TestAcnt;
            
            //KK Added code for SFDC-9391 US
            Account TestCompAcnt = TestClassUtiltity.CreateCompAccountRecord('TestCompAccount');
            TestAcnt.ShippingStreet = 'TestStreet';
            TestAcnt.ShippingCity = 'TestCity';
            TestAcnt.ShippingState = 'IL';
            TestAcnt.ShippingPostalCode = '62401-2940';
            //TestAcnt.ShippingCountry = 'United States';
            update TestAcnt;

            List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(TestAcnt.id);
            testOpp[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            testOpp[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            insert testOpp;

            Benefit_Agreement__c TestBenefitAgreement = new Benefit_Agreement__c();
            TestBenefitAgreement.Group_Account__c = TestAcnt.id;
            TestBenefitAgreement.Status__c = 'Active';
            insert TestBenefitAgreement;

            list<Product2> products = TestClassUtiltity.createProducts();
            insert products;

            list<Opportunity_Product__c> OppProducts = TestClassUtiltity.createOppProducts(testOpp[0].id, products[0].Id);
            OppProducts[0].Product_Type__c = 'New Sale';
            OppProducts[0].Benefit_Agreement__c = TestBenefitAgreement.Id;
            OppProducts[0].Incumbent__c = TestCompAcnt.id;
            insert OppProducts;
            
            PageReference myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpp[0].id);
            Test.setCurrentPage(myVfPage2);

            test.StartTest();
            ApexPAges.StandardSetController sc2 = new ApexPages.StandardSetController(testOpp);
            AddOpportunityProductsController myCntrl = new AddOpportunityProductsController(sc2);
            myCntrl.opportunityObj = testOpp[0];
            myCntrl.numberOfRowToRemove = 1;
            myCntrl.recordToDelete = OppProducts[0].Id;
            myCntrl.removeRow();
            myCntrl.AddNewOpportunityProduct();
            myCntrl.saveOpportunityProducts();
            myCntrl.gotoOpportunity();
            myCntrl.getTheUpdatedMembersCount();
            System.assertEquals(1, myCntrl.listOfOpportunityProducts.size());

            myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpp[1].id);
            Test.setCurrentPage(myVfPage2);

            sc2 = new ApexPages.StandardSetController(testOpp);
            myCntrl = new AddOpportunityProductsController(sc2);
            test.StopTest();

        } catch (Exception e) {
            throw e;
        }
    }

    static testMethod void myUnitTest3() {
        Id renewalOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        try {
            test.StartTest();
            //Get account
            Account testAccount = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'Test Account' LIMIT 1];

            //Get Opp
            Opportunity testOpp = [SELECT Id, AccountId, Name, StageName, CloseDate, Expected_Decision_Date__c, RFI_RFP_Received_Date__c, RecordTypeId, HCSC_Division__c FROM Opportunity 
                                    WHERE AccountId =: testAccount.Id AND RecordTypeId =: renewalOpportunityRecordTypeId LIMIT 1];

            //Map : (NotSimple, Map(Name, Product))
            Map<Boolean, Map<String, Product2> > testProdMap = new Map<Boolean, Map<String, Product2> >();
            List<Product2> testProds = [SELECT Id, Name, RecordTypeId, IsActive, Family, HCSC_State__c, Product_Type__c, Simplified_Product__c, NotSimple__c FROM Product2 LIMIT 4];
            for(Product2 prod: testProds){
                if(!testProdMap.containsKey(prod.NotSimple__c)){
                    testProdMap.put(prod.NotSimple__c, new Map<String, Product2>());
                }
                testProdMap.get(prod.NotSimple__c).put(prod.Name, prod);
            }
            Product2 notSimplePPO = testProdMap.get(true).get('PPO');
            Product2 notSimpleDental = testProdMap.get(true).get('Dental');
            Product2 simplePPO = testProdMap.get(false).get('PPO');
            Product2 simpleDental = testProdMap.get(true).get('Dental');


            List<Group_Section__c> testGrpSecs = [SELECT Id, Group_Account__c, Status__c, Cancellation_Status__c,
            Total_Dental_Active_Members__c, Total_Healthcare_Active_Members__c FROM Group_Section__c LIMIT 2];


            PageReference myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpp.id);
            Test.setCurrentPage(myVfPage2);

            List<Benefit_Agreement__c> TestBenefitAgreementLst = [select Id, Name from Benefit_Agreement__c where Group_Account__c =: testAccount.Id];
            ApexPAges.StandardSetController sc2 = new ApexPages.StandardSetController(new List<Opportunity>{testOpp});
            AddOpportunityProductsController myCntrl = new AddOpportunityProductsController(sc2);

            myCntrl.BARecordId = TestBenefitAgreementLst[0].Name;
            myCntrl.getTheUpdatedMembersCount();
            myCntrl.BARecordId = TestBenefitAgreementLst[1].Name;
            myCntrl.getTheUpdatedMembersCount();
            myCntrl.BARecordId = TestBenefitAgreementLst[2].Name;
            myCntrl.rowCount = '1';
            myCntrl.getTheUpdatedMembersCount();
            myCntrl.opportunityObj = testOpp;
            System.assertEquals(6, myCntrl.listOfOpportunityProducts.size());
            test.StopTest();

        } catch (Exception e) {
            throw e;
        }
    }

    static testMethod void myUnitTest4() {
        Id offCycleOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Off-Cycle Change').getRecordTypeId();    
        try {
            Account testAccount = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
            //KK Added code for SFDC-9391 US
            Account TestCompAccount = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'Test Comp Account' LIMIT 1];
            
            
            List<Opportunity> testOpps = [SELECT Id, AccountId, Name, StageName, CloseDate, Expected_Decision_Date__c, Probability, 
                                          RFI_RFP_Received_Date__c, RecordTypeId, HCSC_Division__c FROM Opportunity 
                                          WHERE AccountId =: testAccount.Id AND RecordTypeId =: offCycleOpportunityRecordTypeId LIMIT 2];
            
            
            Benefit_Agreement__c testBAGR = [SELECT Id, Group_Account__c, Status__c FROM Benefit_Agreement__c WHERE Funding_Type__c = 'TEST' LIMIT 1];
            
            Product2 testProd = [SELECT Id, Name, RecordTypeId, IsActive, Family, HCSC_State__c, Product_Type__c, 
                                 Simplified_Product__c, NotSimple__c FROM Product2 LIMIT 1];
            
            list<Opportunity_Product__c> OppProducts = TestClassUtiltity.createOppProducts(testOpps[0].id, testProd.Id);
            OppProducts[0].Product_Type__c = 'New Sale';
            OppProducts[0].Benefit_Agreement__c = testBAGR.Id;
            OppProducts[0].Incumbent__c = TestCompAccount.id;//KK Added code for SFDC-9391 US
            insert OppProducts[0];
            
            PageReference myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpps[0].id);
            Test.setCurrentPage(myVfPage2);
            
            test.StartTest();
            ApexPAges.StandardSetController sc2 = new ApexPages.StandardSetController(testOpps);
            AddOpportunityProductsController myCntrl = new AddOpportunityProductsController(sc2);
            myCntrl.opportunityObj = testOpps[0];
            myCntrl.numberOfRowToRemove = 1;
            myCntrl.recordToDelete = OppProducts[0].Id;
            myCntrl.removeRow();
            myCntrl.AddNewOpportunityProduct();
            myCntrl.saveOpportunityProducts();
            myCntrl.gotoOpportunity();
            myCntrl.getTheUpdatedMembersCount();
            System.assertEquals(1, myCntrl.listOfOpportunityProducts.size());
            
            myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpps[1].id);
            Test.setCurrentPage(myVfPage2);
            
            sc2 = new ApexPages.StandardSetController(testOpps);
            myCntrl = new AddOpportunityProductsController(sc2);
            test.StopTest();
            
        } catch (Exception e) {
            throw e;
        }
    }
    
    static testMethod void myUnitTest5(){        
        Id offCycleOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Off-Cycle Change').getRecordTypeId();       

        try {
            Account testAccount = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
            
            Account aWinner = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'The Winner' LIMIT 1];
            
            //KK Added code for SFDC-9391 US
            Account TestCompAccount = [SELECT Id, Name, Fax, Effective_Date__c FROM Account WHERE Name = 'Test Comp Account' LIMIT 1];
            
            List<Opportunity> testOpps = [SELECT Id, AccountId, Name, StageName, CloseDate, Expected_Decision_Date__c, Probability, 
                                          RFI_RFP_Received_Date__c, RecordTypeId, HCSC_Division__c FROM Opportunity 
                                          WHERE AccountId =: testAccount.Id AND RecordTypeId =: offCycleOpportunityRecordTypeId LIMIT 2];
            
            Benefit_Agreement__c testBAGR = [SELECT Id, Group_Account__c, Status__c FROM Benefit_Agreement__c WHERE Funding_Type__c = 'TEST' LIMIT 1];
            
            Product2 testProd = [SELECT Id, Name, RecordTypeId, IsActive, Family, HCSC_State__c, Product_Type__c, 
                                 Simplified_Product__c, NotSimple__c FROM Product2 WHERE Name = 'PPOCompetitorLoss' LIMIT 1];                       
            
            list<Opportunity_Product__c> OppProducts = TestClassUtiltity.createOppProducts(testOpps[0].id, testProd.Id);
            OppProducts[0].Product_Type__c = 'New Sale';
            OppProducts[0].Benefit_Agreement__c = testBAGR.Id;
            OppProducts[0].Status__c = 'Lost';
            OppProducts[0].Account__c = aWinner.Id; 
            OppProducts[0].Incumbent__c = TestCompAccount.id;//KK Added code for SFDC-9391 US
            insert OppProducts[0];
            
            PageReference myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpps[0].id);
            Test.setCurrentPage(myVfPage2);
            
            test.StartTest();
            ApexPAges.StandardSetController sc2 = new ApexPages.StandardSetController(testOpps);
            AddOpportunityProductsController myCntrl = new AddOpportunityProductsController(sc2);
            myCntrl.saveOpportunityProducts();
            myCntrl.gotoOpportunity();
            myCntrl.getTheUpdatedMembersCount();
            System.assertEquals(1, myCntrl.listOfOpportunityProducts.size());
            
            myVfPage2 = new PageReference('/apex/AddOpportunityProducts');
            myVfPage2.getParameters().put('opportunityId', testOpps[1].id);
            Test.setCurrentPage(myVfPage2);
            
            sc2 = new ApexPages.StandardSetController(testOpps);
            myCntrl = new AddOpportunityProductsController(sc2);
            test.StopTest();
            
        } catch (Exception e) {
            throw e;
        }        
    }
}