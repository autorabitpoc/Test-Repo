/**************************************************************************************
  Apex Class Name     : GEMS_AssociateCatBAControllerTest 
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_AssociateBACatController 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_AssociateCatBAControllerTest {

private static testmethod void GEMS_AssociateCatBAController()
 {

  Integer SizeOflist=1;
  Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
  User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com'); 
    
    
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        
       /* Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.StageName='Won';
        oppty.Date_Closed__c = system.today();
        oppty.Primary_Closed_Reason__c='Other';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);*/
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseobj.GEMS_Submission_Type__c = 'Renewal';
        caseobj.accountid= acc.id;
        insert caseobj;
        
        GEMS_Benefit_Agreement__c  benefit=GEMS_UtilityClassTest.insertionBenefitAgg(acc.Id,caseobj.Id,productRec1.Id);
        insert benefit;
        System.assertEquals('ACAP',benefit.BA_Fund_Type__c);
        List<GEMS_Benefit_Agreement__c> gemsben = new List<GEMS_Benefit_Agreement__c>();
        gemsben.add(benefit);
        
        GEMS_Category__c   gemscat1=GEMS_UtilityClassTest.insertiongemscat1(acc.Id,caseobj.Id);
        gemscat1.Usage_Billing__c = true;
        insert gemscat1;
        
   
        System.assertEquals('CO',gemscat1.Category_Cobra_Code__c);
        
        List<GEMS_Category__c> gemsCatList = new List<GEMS_Category__c>();
        gemsCatList.add(gemscat1);
       
     
      
        
        
        GEMS_BA_Category_Assignment__c  bacateg=GEMS_UtilityClassTest.insertionBACategory(acc.Id,caseobj.Id,benefit.Id,gemscat1.Id);
      
        insert bacateg;
       
      
        
        GEMS_Characteristic__c gemscha =GEMS_UtilityClassTest.insertionCharacteristic(acc.Id, caseobj.Id);
        insert gemscha;
        
        List<GEMS_Characteristic__c> gemsListChart = new List<GEMS_Characteristic__c>();
        gemsListChart.add(gemscha);
        
        GEMS_Characteristic_Value__c value = new GEMS_Characteristic_Value__c();
            value.Case__c=caseobj.Id;
    value.Characteristic__c=gemscha.Id;
     value.Code__c='ABS';
     value.Effective_Date__c = Date.Today().addDays(8);
        insert value;
        
        GEMS_Cat_Char_Value_Association__c associate =GEMS_UtilityClassTest.insertionAssociate(caseobj.Id,acc.Id,value.Id,gemscat1.Id);
        insert associate ;
        //System.assertEquals('CO',associate.Category_Cobra_Code__c);
        
        
       system.runAs(testUser){ 
     Test.setCurrentPage(Page.GEMSAssignBACat);
      
     List<Case> caseList = new List<case>();
     caseList.add(caseobj);
     ApexPages.currentpage().getParameters().put('recs',benefit.Id);
        ApexPages.StandardSetController std = new ApexPages.StandardSetController(caseList);
       GEMS_AssociateBACatController contr= new GEMS_AssociateBACatController(std); 
       Map<Id, GEMS_Category__c> catIdCat = new Map<Id, GEMS_Category__c>();
       catIdCat.put(gemscat1.Id, gemscat1);
       contr.mapOfIdAndCat=catIdCat;
       List<Integer> intList;
       contr.iter = new List<Integer>();
       List<Integer> intList1 = contr.iter;
       contr.listOfBAs =gemsben;
       contr.listOfChars=gemsListChart;
       contr.sizeOfList=4;
       contr.removeCat();
       contr.assignCat();
       contr.getTheUpdatedMembersCount();
       contr.addCat();
       contr.numberOfRowToRemove=1;
       contr.recordToDelete=gemscat1.id;
       contr.removeRow();
       contr.gotoCreateAccountStructure();
       contr.gotoCase();
        contr.getOptions();
        contr.rowCount='ABS';
           //     contr.recordToDelete='1234';
        contr.numberOfRowToRemove=2;
        
        contr.hasEditAccess=true;
        
        contr.selectedCat=gemsCatList;
        List<List<SelectOption>> sdf = contr.listOfOptions;
    }
    



    }
    }