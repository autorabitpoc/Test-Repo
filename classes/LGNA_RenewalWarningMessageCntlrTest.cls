/**************************************************************************************
  Apex Class Name     : LGNA_RenewalWarningMessageCntlr 
  Version             : 1.0
  Function            : This is Test Class for LGNA_RenewalWarningMessageCntlr
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       09/21/2017                Original Version
*************************************************************************************/
@isTest   
public class LGNA_RenewalWarningMessageCntlrTest {
 static  Account testAccount,testAccount1 ;
     static  Opportunity testOpp,testopp1 ;
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
        
        testOpp = new Opportunity();
        testOpp.Type = 'RFP';
        testOpp.AccountId = testAccount.Id;
        testOpp.RecordTypeId = '01233000000QMPDAA4';
        testOpp.Exchange_Offering_Type__c = 'All On Private Exchange';
        testOpp.Probability = 60;
        testOpp.StageName = 'Prospecting';
        testOpp.Finalist__c = 'No';
        testOpp.Due_Date_Notification_in_Days__c = 45;
        //testOpp.recordtypeid='Group Account';
        testOpp.Expected_Health_Members__c = 23;
        testOpp.Expected_Health_Contracts__c = 56;
        testOpp.Projected_Membership_Gain_Loss__c = 78;
        testOpp.Expected_Dental_Members__c = 43;
        testOpp.Expected_Dental_Contracts__c = 78;
        testOpp.Description = 'tests today description';
        testOpp.Primary_Closed_Reason__c = 'Change of Ownership';
        testOpp.Weekly_Activity_Report__c = false;
        testOpp.Name='test Opportuntiy';
        testOpp.Requested_Effective_Date__c=Date.today();
        testOpp.CloseDate=Date.today();
         testOpp.RFI_RFP_Received_Date__c=Date.today();
        insert testOpp;
 
     }
    public static testMethod void testDetailPage(){
        Test.startTest();
        //LGNA_OpenEnrollCntlr oe= new LGNA_OpenEnrollCntlr();
        LGNA_RenewalWarningMessageCntlr.getOpportunityRenewalList(testAccount.id,testOpp.RecordTypeId);
        Test.stopTest();
    }
    
    
}