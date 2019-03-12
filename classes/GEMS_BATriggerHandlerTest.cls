@isTest
public class GEMS_BATriggerHandlerTest {
    public static testMethod void updateCaseBAProduct_Test1(){
        test.startTest();
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
        benefit.IsNew__c = TRUE;
        update benefit;        

        caseobj.GEMS_Benefit_Agreement__c = benefit.Id;
		update caseobj;
        benefit.IsNew__c = FALSE;
		update benefit; 
        test.stopTest();

        
    }
}