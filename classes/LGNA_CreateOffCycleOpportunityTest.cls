@isTest(SeeAllData=false)
public class LGNA_CreateOffCycleOpportunityTest{
     static Account testAccount;
    static {
       
        testAccount = new Account();
        testAccount.Name='Test Account33';
        testAccount.Ceded__c = true;
        testAccount.HCM_Program_Model__c = 'BCC Elite';
        testAccount.Funding_Type__c = 'PREM';
        testAccount.Cobra_Administration_Type__c = 'HCSC';
        testAccount.Exchange_Account__c = true;
        testAccount.Exchange_Name__c = 'Mercer Marketplace';
        testAccount.Sliced__c = true;
        
        testAccount.Current_Risk_Level__c = '3 - Medium';
        testAccount.Status__c = 'Active';
        testAccount.Critical_Account__c = True;
        testAccount.Risk_Reason__c = 'Test';
        testAccount.HCSC_Division__c = 'TX';
        testAccount.Account_Cluster_Name__c = 'John Testing';
        testAccount.Account_Executive_2__c = 'Jane Testing';
        testAccount.Underwriter_User_ID__c = 'UU456';
        testAccount.Name='test acc';
        insert testAccount;
       
        }
     
      public static testMethod void testDetailPage(){
        Test.startTest();
        LGNA_CreateOffCycleOpportunity.getAccDetails(testAccount.Id);
        LGNA_CreateOffCycleOpportunity.getRecTypeId('asdasd');
        Test.stopTest();
    }

}