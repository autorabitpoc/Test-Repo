/**************************************************************************************
* Apex Class Name     : LGNA_EIN_TriggerTest 
* Version             : 1.0
* Function            : This is test class for LGNA_EIN_TriggerHelper class. Successful run of the test class asserts the apex class.
* Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Bharath            04/09/2018             Original Version
*************************************************************************************/
@isTest(SeeAllData=false) 
public class LGNA_EIN_TriggerTest {
    private static testmethod void TestEINTrigger(){
        test.startTest();
        Account accRec = new Account();
        id rec =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId(); 
        accRec.RecordTypeId = rec;
        accRec.Name = 'TestAccountForEIN';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='Houston';
        accRec.BillingState='TX';
        accRec.BillingPostalCode='77077';
        accRec.status__c = 'Active';
        accRec.AccountNumber = '012456';
        insert accRec;
        
        /*GEMS_Address__c addrRec1 = new GEMS_Address__c();
        addrRec1.Account__c = accRec.Id;
        addrRec1.Street2__c = 'Street1';
        addrRec1.City__c = 'City1';
        addrRec1.State__c = 'TX';
        addrRec1.Zip_Code__c = '77077';
        addrRec1.Contact_Name__c = 'Test1 Name';
        addrRec1.Contact_Email__c = 'test1@gmail.com';
        addrRec1.Contact_Phone__c = '1231231234';
        addrRec1.Usage__c = 'Billing';
        insert addrRec1;
        
        GEMS_Address__c addrRec2 = new GEMS_Address__c();
        addrRec2.Account__c = accRec.Id;
        addrRec2.Street2__c = 'Street2';
        addrRec2.City__c = 'City2';
        addrRec2.State__c = 'TX';
        addrRec2.Zip_Code__c = '77077';
        addrRec2.Contact_Name__c = 'Test2 Name';
        addrRec2.Contact_Email__c = 'test2@gmail.com';
        addrRec2.Contact_Phone__c = '1231231235';
        addrRec2.Usage__c = 'Primary';
        insert addrRec2;*/

        EIN__c einRec1 = new EIN__C();
        einRec1.Name = '131313134';
        einRec1.Account__c = accRec.id;
        einRec1.Street11__c = 'Street1';
        einRec1.Street21__c = 'Street1';
        einRec1.City1__c = 'City1';
        einRec1.State1__c = 'TX';
        einRec1.Zip_Code1__c = '77077';
        einRec1.County_Code1__c = 123;
        einRec1.Country1__c = 'US';
        einRec1.Effective_Date__c = system.today();
        einRec1.Location_Name__c = 'Test1';
        insert einRec1;         
        
		EIN__c einRec2 = new EIN__C();
        einRec2.Name = '343434343';
        einRec2.Account__c = accRec.id;
        einRec2.Street11__c = 'Street1';
        einRec2.Street21__c = 'Street1';
        einRec2.City1__c = 'City1';
        einRec2.State1__c = 'TX';
        einRec2.Zip_Code1__c = '77077';
        einRec2.County_Code1__c = 123;
        einRec2.Country1__c = 'US';
        einRec2.Effective_Date__c = system.today();
        einRec2.Location_Name__c = 'Test2';
        einRec2.Primary__c = true;
        insert einRec2;   

        LGNA_EIN_TriggerHelper.recCheck = false;
		einRec2.Primary__c = false;
		upsert einRec2;  
        
        einRec2.Change_Reason__c = '';
        einRec2.Bluestar_Transfer_Status__c = '';
        upsert einRec2;
        
        einRec2.Location_Name__c = 'Test21';
        upsert einRec2;
        
        einRec2.Effective_Date__c = system.today()+1;
        upsert einRec2;
        
        LGNA_EIN_TriggerHelper.recCheck = false;
		einRec1.Primary__c = true;
		upsert einRec1;      
        
		EIN__c einRec3 = new EIN__C();
        einRec3.Name = '121212121';
        einRec3.Account__c = accRec.id;
        einRec3.Street11__c = 'Street1';
        einRec3.Street21__c = 'Street1';
        einRec3.City1__c = 'City1';
        einRec3.State1__c = 'TX';
        einRec3.Zip_Code1__c = '77077';
        einRec3.County_Code1__c = 123;
        einRec3.Country1__c = 'US';
        einRec3.Effective_Date__c = system.today();
        einRec3.Location_Name__c = 'Test3';
        einRec3.Primary__c = true;
        insert einRec3;           

        LGNA_EIN_TriggerHelper.recCheck = false;
		einRec1.Primary__c = true;
		upsert einRec1;      

		EIN__c einRec4 = new EIN__C();
        einRec4.Name = '454545454';
        einRec4.Account__c = accRec.id;
        einRec4.Street11__c = 'Street1';
        einRec4.Street21__c = 'Street1';
        einRec4.City1__c = 'City1';
        einRec4.State1__c = 'TX';
        einRec4.Zip_Code1__c = '77077';
        einRec4.County_Code1__c = 123;
        einRec4.Country1__c = 'US';
        einRec4.Effective_Date__c = system.today();
        einRec4.Location_Name__c = 'Test3';
        //einRec4.Primary__c = true;
        insert einRec4;    

		einRec4.Change_Reason__c = '';
        einRec4.Bluestar_Transfer_Status__c = '';
        upsert einRec4;
        
        einRec4.End_Date__c = system.today();
        upsert einRec4;
        
        test.stopTest();
    }

}