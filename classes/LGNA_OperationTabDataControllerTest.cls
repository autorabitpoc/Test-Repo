/**************************************************************************************
  Apex Class Name     : LGNA_OperationTabDataController 
  Version             : 1.0
  Function            : This is Test Class for LGNA_OperationTabDataController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       09/12/2017                Original Version
*************************************************************************************/
@isTest
public class LGNA_OperationTabDataControllerTest {
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
      //  testAccount.recordtypeid='Group Account';
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
        LGNA_OperationTabDataController.getaccDetails(testAccount.Id);
         LGNA_OperationTabDataController.getaccDetails(testAccount1.Id);
        LGNA_OperationTabDataController.fetchAccdmList();
        LGNA_OperationTabDataController.fetchRiskTypeList();
        LGNA_OperationTabDataController.fetchRiskLevelList();
        LGNA_OperationTabDataController.fetchGroupMTList();
        LGNA_OperationTabDataController.fetchGroupMPList();
        LGNA_OperationTabDataController.getaccRecordTypename(testAccount.Id);
        LGNA_OperationTabDataController.updateAcc(testAccount);
         LGNA_OperationTabDataController.updateAcc(testAccount1);
        Test.stopTest();
    }
}