/**************************************************************************************
  Apex Class Name     : GEMS_BenefitAgreementController_test
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_BenefitAgreementController.
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Binod Shaw             4/15/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_BenefitAgreementController_test {

    public static testmethod void GEMSBenefitAgreeController1() 
    {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com'); 
               
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty.Date_Closed__c = system.today();
        oppty.Primary_Closed_Reason__c='Other';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
       
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        System.assertEquals('In Progress',oppProd1.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj .GEMS_Submission_Type__c = 'Renewal';
        caseObj.accountid= acc.id;
        insert caseobj;
       
        system.runAs(testUser){ 
        ApexPages.currentpage().getParameters().put('id',caseobj.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseobj );
        GEMS_BenefitAgreementController contr= new GEMS_BenefitAgreementController(std); 
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();          
        contr.Save1();
        }
    }
    public static testmethod void GEMSBenefitAgreeController2() 
    { 
       
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
        User testUser1= TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test@user12.com', 'testUser1', 'test@user1.com');
        
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
        
        product2 productRec6=GEMS_UtilityClassTest.insertionProduct6();
        insert productRec6;
        System.assertEquals('Shared Accums',productRec6.Product_Category__c);
        
        Opportunity_Product__c oppProd6=GEMS_UtilityClassTest.insertionOppProd6(productRec6.Id,oppty.Id);
        System.assertEquals('In Progress',oppProd6.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase1('GEMS Account Structure');
        insert caseobj;
        
        system.runAs(testUser1){
        ApexPages.currentpage().getParameters().put('id',caseobj.id); 
        ApexPages.StandardController std = new ApexPages.standardController(caseobj );
        GEMS_BenefitAgreementController contr= new GEMS_BenefitAgreementController(std); 
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        contr.Save1();
        }   
    }
    public static testmethod void GEMSBenefitAgreeController3() 
    { 
       
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
        User testUser2= TestClassUtiltity.CreateUserRecord(profileRec2.Id, 'test@user13.com', 'testUser2', 'test@user2.com');
        
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
        
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        System.assertEquals('In Progress',oppProd1.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase2('GEMS Account Structure');
        insert caseobj;
   
        system.runAs(testUser2){       
        ApexPages.currentpage().getParameters().put('id',caseobj.id); 
        ApexPages.StandardController std = new ApexPages.standardController(caseobj );
        GEMS_BenefitAgreementController contr= new GEMS_BenefitAgreementController(std); 
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        contr.Save1();
        }   
    }     

}