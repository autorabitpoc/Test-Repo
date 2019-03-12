/**************************************************************************************
Apex Class Name     : LGNA_NewOpportunityProducts
Version             : 1.0
Function            : This is a test class for LGNA_AccountProducts.
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  Ranjit Gandhi 		5/4/2018				Initial Version
*  Sujatha Gondi        5/14/2018               Added some methods
*************************************************************************************/
@isTest
//(SeeAllData=true)

public class LGNA_NewOpportunityProductsTest {
    static testMethod void myUnitTest1() {
        test.StartTest();
        string testtodayrec;
        string keyword ='text';
        string objectname ='account';
        string fliter ='texttoday';
       // Opportunity_Product__c.Opportunity_Name__c testtype;
        Account GroupAcnt = TestClassUtiltity.CreateAccountRecord('Group Account');
        GroupAcnt.BillingStreet = '123 Main St';
        GroupAcnt.BillingCity= 'AnyCity';
        GroupAcnt.BillingState= 'IL';
        GroupAcnt.BillingPostalCode= '60053-0000';
        GroupAcnt.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        update GroupAcnt;  		
        
        Opportunity opp = TestClassUtiltity.createOpportunity(GroupAcnt.id);
        //insert opp;
        
        list<Product2> LstProduct =  TestClassUtiltity.createProducts();
        insert LstProduct;
        
        Ignore_Validations__c settings = Ignore_Validations__c.getOrgDefaults();
        settings.Ignore_Validation__c = true;
        upsert settings Ignore_Validations__c.Id;
        
        list<Opportunity_Product__c> LstOppProduct =  TestClassUtiltity.createOpptyProducts(opp.Id,LstProduct[0].Id);
        insert LstOppProduct;
        
        list<Account_Products__c> AccProduct =  TestClassUtiltity.createAccProducts(GroupAcnt.id, LstProduct[0].id);
        insert AccProduct;
       // Map<String, list<Account_Products__c>> abc=LGNA_NewOpportunityProducts.loadInitialAccountProducts(GroupAcnt.id);
      //  LGNA_NewOpportunityProducts.getPicklistMappedData();
       // LGNA_NewOpportunityProducts.findPicklistValues('Opportunity_Product__c', 'Opportunity_Name__c');
        LGNA_NewOpportunityProducts.saveOpportunityProducts(LstOppProduct,null);
        LGNA_NewOpportunityProducts.fetchAccount(testtodayrec);
      //  LGNA_NewOpportunityProducts.productTypeMapping();
        LGNA_NewOpportunityProducts.getCurrentlySelectedOpportunityProducts(opp.Id);
        LGNA_NewOpportunityProducts.getPreviouslyQuotedOpportunityProducts(opp.Id);
      //  LGNA_NewOpportunityProducts.getopportunitydetails(opp.Id);
 		LGNA_NewOpportunityProducts.getOppProducts('IL');
        //LGNA_NewOpportunityProducts.insertProducts(opp,LstProduct);
        LGNA_NewOpportunityProducts.fetchLookUpValues(fliter,keyword,objectname);
        //KK Added code for Delete Opportunity Product and Won/Lost Update
        LGNA_NewOpportunityProducts.SetOpptyProd(LstOppProduct[0].Id, LstOppProduct[0].Status__c, LstOppProduct[0].Account__c,LstOppProduct[0].Notes__c, LstOppProduct[0].Split__c, LstOppProduct[0].Carve_Out__c);
        //Kishore Added for US#SFDC-9297
        LGNA_NewOpportunityProducts.getOptyId(LstOppProduct[0].Id);
        //KK Added for Opportunity Product View Access 6/25/2018
        LGNA_NewOpportunityProducts.checkOptyAccess(opp.Id);
        LGNA_NewOpportunityProducts.deleteOptyProduct(LstOppProduct[0].Id);
		
        
        test.StopTest();
        
    }
}