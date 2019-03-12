/**************************************************************************************
  Apex Class Name     : GEMS_AccountStructureProductsTest
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_AccountStructureProducts 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/
@isTest 
public class GEMS_AccountStructureProductsTest {
private static testmethod void GEMS_AccountStructureProducts1() {
         
    Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com'); 
    
    Account acc = GEMS_UtilityClassTest.insertionAccount();
    insert acc;
    System.assertEquals('BenefitAgreementControllerTest',acc.Name);
    
         ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity oppty= new Opportunity();
        oppty.RecordTypeId=OppRecTypeId;
        oppty.Name='BenefitAgreementControllerTest';
        oppty.AccountId=acc.id;
        oppty.Type='RFI';
        oppty.StageName='Expected In';
        oppty.Exchange_Offering_Type__c='No Private Exchange';
        oppty.CloseDate=Date.Today().addDays(8);
        oppty.Due_Date_Notification_in_Days__c=2;
        oppty.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppty.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppty.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppty.Expected_Health_Members__c=2;
        oppty.HCSC_Division__c='IL';
        oppty.Region__c='N/A - IL';
        oppty.District__c='290';
        oppty.Clusters__c='020';
        oppty.Account_Market_Segment__c='LG';
        oppty.FSU_Location__c='Chicago';
        insert oppty;
        
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
    
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
       
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        
        oppProd1.Status__c='Won';
        System.assertEquals('Won',oppProd1.Status__c);
        
       //oppty.Primary_Closed_Reason__c='Other';
        //oppty.StageName='Won';
       // update oppty;
        
         Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
    
    /*GEMS_UtilityClassTest.insertionAccount(); 
    GEMS_UtilityClassTest.insertionOpp();
    GEMS_UtilityClassTest.insertionProduct();    
    GEMS_UtilityClassTest.insertionOpportunityProduct();      
    Id GEMSAccstructurerectyid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
    case CaseObj = GEMS_UtilityClassTest.insertionCase(GEMSAccstructurerectyid);*/
   
        system.runAs(testUser){
        //ApexPages.currentpage().getParameters().put('OppProd',OppProd.id);
        ApexPages.currentPage().getParameters().put('caseId',subCaseRec .id);
        ApexPages.StandardController stdController   = new ApexPages.StandardController(subCaseRec );
        GEMS_AccountStructureProducts gems = new GEMS_AccountStructureProducts(stdController);
        
        gems.getOpportunityProduct();
   }    
        
}

 }