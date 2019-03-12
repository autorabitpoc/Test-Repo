@isTest
public class GEMS_AccountStructureHelper_test {

 private static testmethod void GEMS_AccountStructurfoundHelper() {

        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com'); 
               
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        product2 productRec5=GEMS_UtilityClassTest.insertionProduct5();
        insert productRec5;
        System.assertEquals('EPO',productRec5.Product_Category__c);
    
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseobj.accountid = acc.id;
        caseobj .GEMS_Submission_Type__c='Renewal';
        insert caseobj;
        
        GEMS_Group_Section__c  groupSection = GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);
        insert groupSection;
        System.assertEquals('TeSt02',groupSection.Group_No__c);
        
        
        Plan__c  plan = GEMS_UtilityClassTest.insertionPlan(productRec5.Id);
        insert plan;
        
        GEMS_Benefit_Agreement__c  benfitAgrmt = GEMS_UtilityClassTest.insertionbenfitAgrmt(acc.Id,caseobj.Id,productRec5.Id,plan.Id);
        insert benfitAgrmt;
        
        GEMS_BA_Assignment__c  BAassign = GEMS_UtilityClassTest.insertionBaAssign(acc.Id,caseobj.Id,benfitAgrmt.Id,groupSection.Id);
        insert BAassign;
        
        GEMS_Category__c  gemscat1  = GEMS_UtilityClassTest.insertiongemscat1(acc.Id,caseobj.Id);
        gemscat1.Usage_Billing__c = true;
        insert gemscat1 ;
        
        GEMS_BA_Category_Assignment__c bacateg  = GEMS_UtilityClassTest.insertionBACategory(acc.Id,caseobj.Id,benfitAgrmt.Id,gemscat1.Id);
        insert bacateg ;
        
        
        GEMS_Category_Assignment__c catAssign   = GEMS_UtilityClassTest.insertionCategoryAssign(acc.Id,caseobj.Id,gemscat1.Id,groupSection.Id);
        insert catAssign;
        
        
        
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id); 
                   
       //ApexPages.StandardController stdController   = new ApexPages.StandardController(caseObj);
      GEMS_AccountStructureHelper gemsAcctStruct = new GEMS_AccountStructureHelper();
     
      GEMS_AccountStructure  accStruct = gemsAcctStruct.getAccountStructure(caseObj.id);
       gemsAcctStruct.saveAccountStructure(accStruct);
       GEMS_AccountStructureHelper.getCategoryGroupSections(caseObj.id);
       GEMS_AccountStructureHelper.getBACategoriesAndGroupSections(caseObj.id);
       Test.stopTest();              
   
   }

private static testmethod void GEMS_AccountStructureHelper() {

        Test.startTest();
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
       
        product2 productRec5=GEMS_UtilityClassTest.insertionProduct5();
        insert productRec5;
        System.assertEquals('EPO',productRec5.Product_Category__c);
    
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
         caseobj.accountid = acc.id;
        caseobj .GEMS_Submission_Type__c='Renewal';
        insert caseobj;
        
        
        GEMS_Group_Section__c  groupSection = GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);
        insert groupSection;
        System.assertEquals('TeSt02',groupSection.Group_No__c);
        
        
        Plan__c  plan = GEMS_UtilityClassTest.insertionPlan(productRec5.Id);
        insert plan;
        
        
        GEMS_Benefit_Agreement__c  benfitAgrmt = GEMS_UtilityClassTest.insertionbenfitAgrmt(acc.Id,caseobj.Id,productRec5.Id,plan.Id);
        insert benfitAgrmt;
        
        
        GEMS_Category__c  gemscat1  = GEMS_UtilityClassTest.insertiongemscat1(acc.Id,caseobj.Id);
        gemscat1.Usage_Billing__c = true;
        insert gemscat1 ;
        
        GEMS_BA_Category_Assignment__c bacateg  = GEMS_UtilityClassTest.insertionBACategory(acc.Id,caseobj.Id,benfitAgrmt.Id,gemscat1.Id);
        insert bacateg ;
        update bacateg ;
        
        GEMS_BA_Assignment__c  BAassign = GEMS_UtilityClassTest.insertionBaAssign(acc.Id,caseobj.Id,benfitAgrmt.Id,groupSection.Id);
        insert BAassign;
         
        
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id); 
                   
       //ApexPages.StandardController stdController   = new ApexPages.StandardController(caseObj);
      GEMS_AccountStructureHelper gemsAcctStruct = new GEMS_AccountStructureHelper();
     
      GEMS_AccountStructure  accStruct = gemsAcctStruct.getAccountStructure(caseObj.id);
       gemsAcctStruct.saveAccountStructure(accStruct);
       GEMS_AccountStructureHelper.getCategoryGroupSections(caseObj.id);
       GEMS_AccountStructureHelper.getBACategoriesAndGroupSections(caseObj.id);
       Test.stopTest();              
   
   }
   
   private static testmethod void GEMS_AccountSectionDetails() {

        Test.startTest();
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        
        product2 productRec5=GEMS_UtilityClassTest.insertionProduct5();
        insert productRec5;
        System.assertEquals('EPO',productRec5.Product_Category__c);
    
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseobj.accountid = acc.id;
        caseobj .GEMS_Submission_Type__c='Renewal';
        insert caseobj;
        
        
        GEMS_Group_Section__c  groupSection = GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);
        insert groupSection;
        System.assertEquals('TeSt02',groupSection.Group_No__c);
        
        
        Plan__c  plan = GEMS_UtilityClassTest.insertionPlan(productRec5.Id);
        insert plan;
        
        GEMS_Benefit_Agreement__c  benfitAgrmt = GEMS_UtilityClassTest.insertionbenfitAgrmt(acc.Id,caseobj.Id,productRec5.Id,plan.Id);
        insert benfitAgrmt;
        
        GEMS_BA_Assignment__c  BAassign = GEMS_UtilityClassTest.insertionBaAssign(acc.Id,caseobj.Id,benfitAgrmt.Id,groupSection.Id);
        insert BAassign;
        
        GEMS_Category__c  gemscat1  = GEMS_UtilityClassTest.insertiongemscat1(acc.Id,caseobj.Id);
        //Usage Insert
        gemscat1.Usage_Billing__c = true;
        insert gemscat1 ;
        
        GEMS_BA_Category_Assignment__c bacateg  = GEMS_UtilityClassTest.insertionBACategory(acc.Id,caseobj.Id,benfitAgrmt.Id,gemscat1.Id);
        insert bacateg ;
        
        GEMS_Category_Assignment__c catAssign   = GEMS_UtilityClassTest.insertionCategoryAssign(acc.Id,caseobj.Id,gemscat1.Id,groupSection.Id);
        insert catAssign;
          
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id); 
                   
       //ApexPages.StandardController stdController   = new ApexPages.StandardController(caseObj);
      GEMS_AccountStructureHelper gemsAcctStruct = new GEMS_AccountStructureHelper();
     
      GEMS_AccountStructure  accStruct = gemsAcctStruct.getAccountStructure(caseObj.id);
      
       gemsAcctStruct.saveAccountStructure(accStruct);
       GEMS_AccountStructureHelper.getCategoryGroupSections(caseObj.id);
       GEMS_AccountStructureHelper.getBACategoriesAndGroupSections(caseObj.id);
       Test.stopTest();              
   
   }
   
  
  }