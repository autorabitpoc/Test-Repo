/**************************************************************************************
  Apex Class Name     : LGNA_ProductTabDataController 
  Version             : 1.0
  Function            : This is Test Class for LGNA_ProductTabDataController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       09/12/2017                Original Version
*************************************************************************************/
@isTest
public class LGNA_ProductTabDataControllerTest {
   static  Account testAccount,testAccount1 ;
    static
    {
       
        testAccount = new Account();
        testAccount.Ceded__c = true;
        testAccount.HCM_Program_Model__c = 'BCC Elite';
        testAccount.Funding_Type__c = 'PREM';
        testAccount.Cobra_Administration_Type__c = 'HCSC';
        testAccount.Exchange_Account__c = true;
        testAccount.Exchange_Name__c = 'Mercer Marketplace';
        testAccount.Sliced__c = true;
        //testAccount.recordtypeid='Group Account';
        testAccount.Current_Risk_Level__c = '3 - Medium';
        testAccount.Status__c = 'Active';
        testAccount.Critical_Account__c = True;
        testAccount.Risk_Reason__c = 'Test';
        testAccount.HCSC_Division__c = 'TX';
        testAccount.Account_Cluster_Name__c = 'John Testing';
        testAccount.Account_Executive_2__c = 'Jane Testing';
        testAccount.Underwriter_User_ID__c = 'UU456';
        testAccount.Name='test Account';
        insert testAccount;
        
        testAccount1 = new Account();
        
        List<User> testUsers = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            testUsers.add(new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE));
            testUsers.add(new User(Alias = 'standt6', Email = 'sana.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Sana', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'sana.testing@testorg.com', isActive = TRUE, Lan_Id__c = 'UU4569'));
        insert testUsers;

     }
    
    public static testMethod void testDetailPage(){
        Test.startTest();
        //LGNA_OpenEnrollCntlr oe= new LGNA_OpenEnrollCntlr();
        LGNA_ProductTabDataController.getaccDetails(testAccount.Id);
        LGNA_ProductTabDataController.getaccDetails(testAccount1.Id);
        LGNA_ProductTabDataController.fetchcatList();
        LGNA_ProductTabDataController.fetchwellnesscList();
        LGNA_ProductTabDataController.fetchpostpeList();
        LGNA_ProductTabDataController.fetchexchangenameList();
        LGNA_ProductTabDataController.fetchprepeList();
        LGNA_ProductTabDataController.fetchhcmprogramList();
        LGNA_ProductTabDataController.fetchbccprogramList();
        LGNA_ProductTabDataController.fetchhcmclientList();
        LGNA_ProductTabDataController.getaccRecordType(testAccount.Id);
        LGNA_ProductTabDataController.updateproductAcc(testAccount1);
        LGNA_ProductTabDataController.updateproductAcc(testAccount);
        Test.stopTest();
    }
}