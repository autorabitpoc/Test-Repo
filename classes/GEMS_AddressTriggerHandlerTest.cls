/**************************************************************************************
  Apex Class Name     : GEMS_AddressTriggerHandlerTest
  Version             : 1.0
  Function            : This class serves as Unit Test Class for GEMS_AddressTriggerHandler
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Lakshmi Arigela       06/28/2017                Original Version
*************************************************************************************/
@isTest(SeeAllData=false) 
private class GEMS_AddressTriggerHandlerTest
{

private static testmethod void GEMS_AddressTriggerHandlerTest(){
Account accRec =  new Account();
id rec =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId(); 
accRec.RecordTypeId = rec;
accRec.Name = 'TestAccountForCaseTriggerHandler';
accRec.Group_Number__c= 'B06093';
accRec.external_id__c= 'B06093';
accRec.BillingStreet ='Testing';
accRec.BillingCity='TX';
accRec.BillingState='CT';
accRec.BillingPostalCode='534323';
accRec.status__c = 'Active';
accRec.AccountNumber = '012456';
insert accRec;

GEMS_Address__c gAdd = new GEMS_Address__c();
gAdd.Account__c = accRec.id;
gAdd.Street2__c = 'test';
gAdd.City__c = 'Bangalore';
gAdd.State__c ='Test';
gAdd.Zip_Code__c ='1234556';
gAdd.Country__c = 'US';
gAdd.Usage__c = 'Primary';
gAdd.Contact_Name__c= 'test123';
gAdd.Contact_Phone__c= '334442211';
gAdd.Contact_Email__c= 'test@test.com';
insert gAdd;

Test.startTest();
GEMS_Address__c gAdd1 = new GEMS_Address__c();
gAdd1.Account__c = accRec.id;
gAdd1.Street2__c = 'test123';
gAdd1.City__c = 'Bang';
gAdd1.State__c ='Test';
gAdd1.Zip_Code__c ='123456';
gAdd1.Country__c = 'US';
gAdd1.Usage__c = 'Billing';
gAdd1.Contact_Name__c= 'test123';
gAdd1.Contact_Phone__c= '334442211';
gAdd1.Contact_Email__c= 'test@test.com';
insert gAdd1;

Test.stopTest();

}

private static testmethod void GEMS_AddressTriggerHandlerTest2(){
Account accRec =  new Account();
id rec =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId(); 
accRec.RecordTypeId = rec;
accRec.Name = 'TestAccountForCaseTriggerHandler';
accRec.Group_Number__c= 'B06093';
accRec.external_id__c= 'B06093';
accRec.BillingStreet ='Testing';
accRec.BillingCity='TX';
accRec.BillingState='CT';
accRec.BillingPostalCode='534323';
accRec.status__c = 'Active';
accRec.AccountNumber = '012456';
insert accRec;

GEMS_Address__c gAdd = new GEMS_Address__c();
gAdd.Account__c = accRec.id;
gAdd.Street2__c = 'test';
gAdd.City__c = 'Bangalore';
gAdd.State__c ='Test';
gAdd.Zip_Code__c ='1234556';
gAdd.Country__c = 'US';
gAdd.Usage__c = 'Primary';
gAdd.Contact_Name__c= 'test123';
gAdd.Contact_Phone__c= '334442211';
gAdd.Contact_Email__c= 'test@test.com';
insert gAdd;

try{
Test.startTest();
GEMS_Address__c gAdd1 = new GEMS_Address__c();
gAdd1.Account__c = accRec.id;
gAdd1.Street2__c = 'test123';
gAdd1.City__c = 'Bang';
gAdd1.State__c ='Test';
gAdd1.Zip_Code__c ='123456';
gAdd1.Country__c = 'US';
gAdd1.Usage__c = 'Primary';
gAdd1.Contact_Name__c= 'test123';
gAdd1.Contact_Phone__c= '334442211';
gAdd1.Contact_Email__c= 'test@test.com';
insert gAdd1;

Test.stopTest();
}catch(Exception e){
Boolean expectedExceptionThrown =  e.getMessage().contains('Primary address already exists for this account') ? true : false;
System.assertEquals(expectedExceptionThrown, true);

}

}



}