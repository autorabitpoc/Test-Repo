/**************************************************************************************
Apex Class Name     : GEMSCaptureBAsController_TEST 
Version             : 1.0
Function            : This class serves as Unit Test Class for GEMSCaptureBAsController. 
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        07/19/2016                Original Version
* Shankar                   07/17/2017                SFDC-5071 - Changes to validate if associated BA Product 
                                                      (plan) has a product code
*************************************************************************************/
@isTest
public class GEMSCaptureBAsController_TEST {
    public static testMethod void GEMSCaptureBAsController_TEST1()
    {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        Profile pNoAccess = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserNoAccess = GEMS_UtilityClassTest.CreateUserRecord(pNoAccess.Id, 'test1@user12.com', 'testUser2', 'test2@user.com');
        insert testUserNoAccess ;
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        //oppty.StageName='Won';
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty.Date_Closed__c = system.today();
        oppty.Primary_Closed_Reason__c='Other';
        insert oppty;
        
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        
        Opportunity_Product__c insertionOppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        System.assertEquals('In Progress',insertionOppProd1.Status__c);
        
        Case caseobj2 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        caseobj2.accountId = acc.Id;
        caseobj2.Funding_Type_Multiselect__c = 'ASO;Premium';
        insert caseobj2;
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseobj.accountId = acc.Id;
        caseobj.GEMS_Account_Submission_Info__C = caseobj2.Id;
        insert caseobj; 
        
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id);  
        GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id); 
        GEMS_Benefit_Agreement__c benefit4=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id);     
        baList.add(benefit);
        baList.add(benefit1);
        baList.add(benefit4);
        insert baList;
        benefit.BA_Description__c='Changed';
        benefit.IsNew__c= False;
        update benefit;
        
        List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);        
        insert Groupsec;
        groupSectionList.add(Groupsec);
        System.assertEquals('TeSt02',Groupsec.Group_No__c);
        
        system.runAs(testUser){
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            balist = [select id,name from GEMS_Benefit_Agreement__c ];
            GEMSCaptureBAsController.BAWrapper bawrap = new GEMSCaptureBAsController.BAWrapper(true, baList[0]);
            GEMSCaptureBAsController.BAWrapper bawrap1 = new GEMSCaptureBAsController.BAWrapper(true, baList[1]);
            
            List<GEMSCaptureBAsController.BAWrapper> wraplst = new List<GEMSCaptureBAsController.BAWrapper>();
            wraplst.add(bawrap);
            wraplst.add(bawrap1);
            gm.hasEditAccess =true;
            Test.startTest();
            gm.saveBAs();  
            
            gm.recordToDelete = baList[0].id;          
            gm.addBA();
            
            Case ccc = gm.ParCase;
            Integer ii = gm.renderMe;
            gm.listOfBAs=wraplst;
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=baList[0].id;  
            gm.getTheUpdatedMembersCount();             
            gm.numberOfRowToRemove = 1; 
            gm.removeBA();                         
            gm.assignBAs();
            gm.cancelRecord();
            gm.removeRow();
            
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
        system.runAs(testUserNoAccess){
            //Test.setCurrentPage(Page.GEMSCaptureBenefitAgreements);
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            GEMSCaptureBAsController.BAWrapper bawrap = new GEMSCaptureBAsController.BAWrapper(true,benefit); 
            
            gm.hasEditAccess =true;
            gm.saveBAs();  
            Test.stopTest();
            gm.recordToDelete = baList[0].id;          
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=baList[0].id;  
            gm.getTheUpdatedMembersCount(); 
            gm.numberOfRowToRemove = 1;
            gm.removeBA();                         
            gm.removeRow();
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
    }
    
    
    public static testMethod void GEMSCaptureBAsController_TEST2()
    {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        Profile pNoAccess = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserNoAccess = GEMS_UtilityClassTest.CreateUserRecord(pNoAccess.Id, 'test1@user12.com', 'testUser2', 'test2@user.com');
        insert testUserNoAccess ;
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        //  oppty.StageName='Won';
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty.Date_Closed__c = system.today();
        oppty.Primary_Closed_Reason__c='Other';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        
        Opportunity_Product__c insertionOppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        System.assertEquals('In Progress',insertionOppProd1.Status__c);
        
        Case caseobj2 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        caseobj2.accountId = acc.Id;
        caseobj2.Funding_Type_Multiselect__c = 'ASO;Premium';
        insert caseobj2;
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseobj.accountId = acc.Id;
        caseobj.GEMS_Account_Submission_Info__C = caseobj2.Id;
        insert caseobj;     
        
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id);  
        insert benefit;
        
        
        List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);        
        insert Groupsec;
        groupSectionList.add(Groupsec);
        System.assertEquals('TeSt02',Groupsec.Group_No__c);
        
        system.runAs(testUser){
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            GEMSCaptureBAsController.BAWrapper bawrap = new GEMSCaptureBAsController.BAWrapper(true, benefit); 
            gm.hasEditAccess =true;
            Test.startTest();
            gm.saveBAs(); 
            gm.recordToDelete = benefit.id;          
            gm.addBA();
            
            Case ccc = gm.ParCase;
            Integer ii = gm.renderMe;
            
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=benefit.id;  
            gm.getTheUpdatedMembersCount();             
            gm.numberOfRowToRemove = 1; 
            gm.removeBA();                         
            gm.assignBAs();
            gm.cancelRecord();
            gm.removeRow();
            
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
        system.runAs(testUserNoAccess){
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            GEMSCaptureBAsController.BAWrapper bawrap = new GEMSCaptureBAsController.BAWrapper(true,benefit); 
            
            gm.hasEditAccess =true;
            gm.saveBAs();  
            Test.stopTest();
            gm.recordToDelete =benefit.id;          
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=benefit.id;  
            gm.getTheUpdatedMembersCount(); 
            gm.numberOfRowToRemove = 1;
            gm.removeBA();                         
            gm.removeRow();
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
            Map < Id, GEMS_Benefit_Agreement__c> idcatmap = new Map < Id, GEMS_Benefit_Agreement__c>();
            idcatmap.put(benefit.id,benefit);
            
            gm.mapOfIdAndBA= idcatmap;
            ApexPages.currentPage().getParameters().put('RecordCan',benefit.id);
            gm.cancelRecord();
        }
    }
    
    public static testMethod void GEMSCaptureBAsController_TEST3()
    {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        Profile pNoAccess = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserNoAccess = GEMS_UtilityClassTest.CreateUserRecord(pNoAccess.Id, 'test1@user12.com', 'testUser2', 'test2@user.com');
        insert testUserNoAccess ;
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        // oppty.StageName='Won';
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty.Date_Closed__c = system.today();
        oppty.Primary_Closed_Reason__c='Other';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        
        Opportunity_Product__c insertionOppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        System.assertEquals('In Progress',insertionOppProd1.Status__c);
        
        Case caseobj2 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        caseobj2.accountId = acc.Id;
        caseobj2.Funding_Type_Multiselect__c = 'ASO;Premium';
        insert caseobj2;
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseobj.accountId = acc.Id;
        caseobj.GEMS_Account_Submission_Info__C = caseobj2.Id;
        insert caseobj;     
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id);  
        GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id); 
        GEMS_Benefit_Agreement__c benefit4=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id);     
        baList.add(benefit);
        baList.add(benefit1);
        baList.add(benefit4);
        insert baList;
        
        
        List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);        
        insert Groupsec;
        groupSectionList.add(Groupsec);
        System.assertEquals('TeSt02',Groupsec.Group_No__c);
        
        system.runAs(testUser){
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            GEMSCaptureBAsController.BAWrapper bawrap = new GEMSCaptureBAsController.BAWrapper(true,benefit);
            
            List<GEMSCaptureBAsController.BAWrapper> wraplst = new List<GEMSCaptureBAsController.BAWrapper>();
            wraplst.add(bawrap);
            
            gm.hasEditAccess =true;
            Test.startTest();
            gm.saveBAs();  
            gm.recordToDelete = baList[0].id;          
            gm.addBA();
            
            Case ccc = gm.ParCase;
            Integer ii = gm.renderMe;
            gm.listOfBAs=wraplst;
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=baList[0].id;  
            gm.getTheUpdatedMembersCount();             
            gm.numberOfRowToRemove = 1; 
            gm.removeBA();                         
            gm.assignBAs();
            gm.cancelRecord();
            gm.removeRow();
            
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
        system.runAs(testUserNoAccess){
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            GEMSCaptureBAsController.BAWrapper bawrap = new GEMSCaptureBAsController.BAWrapper(true,benefit); 
            
            gm.hasEditAccess =true;
            
            gm.saveBAs();  
            Test.stopTest();
            gm.recordToDelete = baList[0].id;          
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=baList[0].id;  
            gm.getTheUpdatedMembersCount(); 
            gm.numberOfRowToRemove = 1;
            gm.removeBA();                         
            gm.removeRow();
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
    }
    
    
    public static testMethod void testBAInsertWithoutProductCode()
    {
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        system.runAs(testUser){
            Account acc = GEMS_UtilityClassTest.insertionAccount();
            insert acc;
            System.assertEquals('BenefitAgreementControllerTest',acc.Name);
            
            Product2 productRec1 = new Product2();
            productRec1.Name='With ProductCode';
            productRec1.Product_Category__c='PPO';
            productRec1.ProductCode='PPO';
            productRec1.Family='Ancillary and other';
            productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
            productRec1.IsActive=true;
            productRec1.HCSC_State__c='IL';
            productRec1.External_ID__c='IL-Accident Insurance (Shared Accums)';
            
            Product2 productRec2 = new Product2();
            productRec2.Product_Category__c='PPO';
            productRec2.Name='Without ProductCode';      
            productRec2.Family='Ancillary';
            productRec2.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
            productRec2.IsActive=true;
            productRec2.HCSC_State__c='IL';
            productRec2.External_ID__c='IL-Accident Insurance (Shared Accumss)';
            List<Product2> products = new List<Product2>();
            
            products.add(productRec1);
            products.add(productRec2);
            insert products;
            
            Case caseobj2 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
            caseobj2.accountId = acc.Id;
            caseobj2.Funding_Type_Multiselect__c = 'ASO;Premium';
            insert caseobj2;
            
            Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
            caseobj.accountId = acc.Id;
            caseobj.GEMS_Account_Submission_Info__C = caseobj2.Id;
            insert caseobj;     
            
            // Add 3 BA's out of which one without plan
            List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
            GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefitWithoutPlan(acc.Id,caseobj.Id);  
            GEMS_Benefit_Agreement__c benefit3=GEMS_UtilityClassTest.insertionBenefitWithoutProduct(acc.Id,caseobj.Id); 
            GEMS_Benefit_Agreement__c benefit2=GEMS_UtilityClassTest.insertionBenefitWithoutPlanAndProduct(acc.Id,caseobj.Id); 
            GEMS_Benefit_Agreement__c benefit4=GEMS_UtilityClassTest.insertionBenefitWithoutProductCode(acc.Id,caseobj.Id); 
            GEMS_Benefit_Agreement__c benefit5=GEMS_UtilityClassTest.insertionBenefitWithProductCode(acc.Id,caseobj.Id); 
            benefit5.IsNew__c = true;
            baList.add(benefit1);
            baList.add(benefit2);
            baList.add(benefit3);
            baList.add(benefit4);
            baList.add(benefit5);
            
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(baList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            
            GEMSCaptureBAsController.BAWrapper bawrap2 = new GEMSCaptureBAsController.BAWrapper(false,benefit2);
            GEMSCaptureBAsController.BAWrapper bawrap3 = new GEMSCaptureBAsController.BAWrapper(false,benefit3);
            GEMSCaptureBAsController.BAWrapper bawrap4 = new GEMSCaptureBAsController.BAWrapper(false,benefit4);
            GEMSCaptureBAsController.BAWrapper bawrap5 = new GEMSCaptureBAsController.BAWrapper(true,benefit5);
            GEMSCaptureBAsController.BAWrapper bawrap1 = new GEMSCaptureBAsController.BAWrapper(false,benefit1);
            bawrap5.isSelected=true;
            
            List<GEMSCaptureBAsController.BAWrapper> wraplst = new List<GEMSCaptureBAsController.BAWrapper>();
            wraplst.add(bawrap1);
            wraplst.add(bawrap2);
            wraplst.add(bawrap3);
            wraplst.add(bawrap4);
            wraplst.add(bawrap5);
            
            gm.hasEditAccess =true;
            gm.listOfBAs=wraplst;
            Test.startTest();
                gm.saveBAs();      
                gm.assignBAs();
            Test.stopTest();
            
            System.assertEquals(5, gm.listOfBAs.size());
            System.assertNotEquals(5, gm.selectedBAs.size());
            Boolean hasErr = false;
            for (GEMSCaptureBAsController.BAWrapper ba: gm.listOfBAs) {
                if (ba.prodTypeErr != null) {
                    hasErr = true;
                }
            }
            
            System.assert(hasErr);
            
            
        }            
    }
    
        public static testMethod void testBAInsertWithProductCode()
    {
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        system.runAs(testUser){
            Account acc = GEMS_UtilityClassTest.insertionAccount();
            insert acc;
            System.assertEquals('BenefitAgreementControllerTest',acc.Name);
            
            Product2 productRec1 = new Product2();
            productRec1.Name='With ProductCode';
            productRec1.Product_Category__c='PPO';
            productRec1.ProductCode='PPO';
            productRec1.Family='Ancillary and other';
            productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
            productRec1.IsActive=true;
            productRec1.HCSC_State__c='IL';
            productRec1.External_ID__c='IL-Accident Insurance (Shared Accums)';
            
            Product2 productRec2 = new Product2();
            productRec2.Product_Category__c='PPO';
            productRec2.Name='Without ProductCode';      
            productRec2.Family='Ancillary';
            productRec2.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
            productRec2.IsActive=true;
            productRec2.HCSC_State__c='IL';
            productRec2.External_ID__c='IL-Accident Insurance (Shared Accumss)';
            List<Product2> products = new List<Product2>();
            
            products.add(productRec1);
            products.add(productRec2);
            insert products;
            
            Case caseobj2 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
            caseobj2.accountId = acc.Id;
            caseobj2.Funding_Type_Multiselect__c = 'ASO;Premium';
            insert caseobj2;
            
            Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
            caseobj.accountId = acc.Id;
            caseobj.GEMS_Account_Submission_Info__C = caseobj2.Id;
            insert caseobj;     
            
            // Add 3 BA's out of which one without plan
            List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
            GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefitWithProductCode(acc.Id,caseobj.Id);  
            GEMS_Benefit_Agreement__c benefit2=GEMS_UtilityClassTest.insertionBenefitWithProductCode2(acc.Id,caseobj.Id); 

      benefit2.IsNew__c = true;
            baList.add(benefit1);
            baList.add(benefit2);

            
            PageReference pageRef = Page.GEMSCaptureBAs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            ApexPages.currentPage().getParameters().put('RN','1234');
            ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
            ApexPages.currentPage().getParameters().put('dDate','07/05/16');
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(baList);           
            GEMSCaptureBAsController gm = new GEMSCaptureBAsController(stdControllerr);
            
            

            GEMSCaptureBAsController.BAWrapper bawrap1 = new GEMSCaptureBAsController.BAWrapper(false,benefit1);
        GEMSCaptureBAsController.BAWrapper bawrap2 = new GEMSCaptureBAsController.BAWrapper(true,benefit2);
            
            List<GEMSCaptureBAsController.BAWrapper> wraplst = new List<GEMSCaptureBAsController.BAWrapper>();
            wraplst.add(bawrap1);
            wraplst.add(bawrap2);
            
            gm.hasEditAccess =true;
            gm.listOfBAs=wraplst;
            Test.startTest();
              gm.saveBAs();      
            Test.stopTest();
             gm.assignBAs();

            System.assertEquals(2, gm.listOfBAs.size());
            System.assertNotEquals(2, gm.selectedBAs.size());
            Boolean hasErr = false;
            for (GEMSCaptureBAsController.BAWrapper ba: gm.listOfBAs) {
                if (ba.prodTypeErr != null) {
                    hasErr = true;
                }
            }
            
            System.assert(!hasErr);
            
            
        }            
    }
}