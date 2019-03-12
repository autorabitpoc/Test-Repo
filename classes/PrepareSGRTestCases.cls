/*****************************************************************************************************************/
// Used only for Identifying Test Accounts for Small Group Renewals Testing
/*****************************************************************************************************************/


public class PrepareSGRTestCases {


  public PrepareSGRTestCases(){


    Map<Id, Account> acntMap = new Map<Id, Account>([Select Id from Account Limit 1000]);
    Map<Id, SGR_Account_Census__c> acntCenMap = new Map<Id, SGR_Account_Census__c>([Select Id from SGR_Account_Census__c where Account__c in :acntMap.keyset() Limit 1000]);
    Map<Id, SGR_Account_Member_Benefit__c> acntMemMap = new Map<Id, SGR_Account_Member_Benefit__c>([Select Id, Account__c,Account_Census__c from SGR_Account_Member_Benefit__c where Account__c in :acntMap.keyset() and Account_Census__c in :acntCenMap.keyset() Limit 1000]);
    Map<Id, Benefit_Agreement__c> baMap = new Map<Id, Benefit_Agreement__c>([Select Id, Account_data_load__c,Account_Census__c from Benefit_Agreement__c where Status__c = 'Active' and Account_data_load__c in :acntMap.keyset() and Account_Census__c in :acntCenMap.keyset() Limit 1000 ]);

    }


}