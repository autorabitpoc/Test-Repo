/**************************************************************************************
  Apex Class Name     : GEMS_CaptureBenefitAgreementsCtrl_Test
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for  GEMS_CaptureBenefitAgreementsController
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari     06/29/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_CaptureBenefitAgreementsCtrl_Test {
    public static testMethod void GEMS_CaptureBenefitAgreementsCtrl_Test1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'test@user11.com', 'testUser', 'test@user.com');
        
        Profile pNoAccess = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist']; 
        User testUserNoAccess = TestClassUtiltity.CreateUserRecord(pNoAccess.Id, 'test@userNoAcc.com', 'testUserNoAcc', 'test@userNoAcc.com');
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
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

        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS BA Level Screening');
        caseobj.accountId = acc.Id;
        caseobj.GEMS_Account_Submission_Info__C = caseobj2.Id;
        insert caseobj;     
        
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,caseobj.Id,productRec1.Id);        
        insert benefit;
        System.assertEquals('1234',benefit.Name);
        
        
        List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,caseobj.Id);        
        insert Groupsec;
        groupSectionList.add(Groupsec);
        System.assertEquals('TeSt02',Groupsec.Group_No__c);
      
        system.runAs(testUser){
            Test.setCurrentPage(Page.GEMSCaptureBenefitAgreements);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMS_CaptureBenefitAgreementsController gm = new GEMS_CaptureBenefitAgreementsController(stdControllerr);
            
            GEMS_CaptureBenefitAgreementsController.BAWrapper bawrap = new GEMS_CaptureBenefitAgreementsController.BAWrapper(true, benefit); 
            //gm.getParentCase();
            gm.hasEditAccess =true;
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
            gm.removeRow();
            
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
        system.runAs(testUserNoAccess){
            Test.setCurrentPage(Page.GEMSCaptureBenefitAgreements);
            ApexPages.currentPage().getParameters().put('caseId',CaseObj.id);
            ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);           
            GEMS_CaptureBenefitAgreementsController gm = new GEMS_CaptureBenefitAgreementsController(stdControllerr);
            
            GEMS_CaptureBenefitAgreementsController.BAWrapper bawrap = new GEMS_CaptureBenefitAgreementsController.BAWrapper(true,benefit); 
                          
            
            //gm.getParentCase();
            gm.hasEditAccess =true;
            gm.saveBAs();  
            gm.recordToDelete = benefit.id;          
            gm.gotoCase();                               
            gm.rowCount = 'testetst';
            gm.BARecordId=benefit.id;  
            gm.getTheUpdatedMembersCount(); 
            
            gm.numberOfRowToRemove = 1;
             
            gm.removeBA();                         
            gm.removeRow();
            System.debug('SelectedBA Size=====>' +gm.selectedBAs.size());
        }
    }
}