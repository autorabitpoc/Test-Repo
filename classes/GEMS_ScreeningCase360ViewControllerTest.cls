/**************************************************************************************
  Apex Class Name     : GEMS_ScreeningCase360ViewControllerTest
  Version             : 1.0
  Function            : This class serves as Unit Test Class for Generating mockdata for all GEMS related objects.
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Ranjit Gandhi          03/20/2017                Made changes as per SFDC-4036: Open/Closed Indicator on the Account Submission page next to each type of case
* Siva Thimmannagari     06/29/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_ScreeningCase360ViewControllerTest {
private static testmethod void GEMS_ScreeningCase360ViewController1(){
             
    Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user101.com', 'testUser101', 'test@user101.com'); 
        
     Account acc = GEMS_UtilityClassTest.insertionAccount();
     Opportunity  opty = GEMS_UtilityClassTest.insertionOpp1(acc.Id);
     product2 prod = GEMS_UtilityClassTest.insertionProduct();
     Opportunity_Product__c OppProd = GEMS_UtilityClassTest.insertionOppProd(prod.id, opty.Id);
     Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        
      system.runAs(testUser){   
    ApexPages.StandardController stdController   = new ApexPages.StandardController(caseObj);
    GEMS_ScreeningCase360ViewController gems = new GEMS_ScreeningCase360ViewController(stdController);
    String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();  
       GEMS_ScreeningCase360ViewController gems1 = new GEMS_ScreeningCase360ViewController();
          
    
}
}
private static testmethod void GEMS_ScreeningCase360ViewController2() {
    Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS BA Level Screening');   
    //Case caseObj;
    ApexPages.StandardController stdController;//;   = new ApexPages.StandardController(caseObj);
    GEMS_ScreeningCase360ViewController gems = new GEMS_ScreeningCase360ViewController(stdController);
  
}

}