@isTest
private class ProspectingAppContactListCtrlTest {
    @testSetup
    static void setupData() {
        Account testAccount = new Account(Name='Test Account 1');
        Account testAccount2 = new Account(Name='Test Account 2');        
        List<Account> accountList = new List<Account>();
        accountList.add(testAccount);
        accountList.add(testAccount2);
        insert accountList;
        
        Contact testContact = new Contact(LastName='TestOne', AccountId=testAccount.Id);
        Contact testContact2 = new Contact(LastName='TestTwo', AccountId=testAccount2.Id);
        Contact testContact3 = new Contact(LastName='TestThree', AccountId=testAccount2.Id);
        List<Contact> contactList = new List<Contact>();
        contactList.add(testContact);
        contactList.add(testContact2);
        contactList.add(testContact3);
        insert contactList;
        
        List<AccountContactRelation> relationList = new List<AccountContactRelation>();
        
        AccountContactRelation relation = new AccountContactRelation();
        relation.AccountId = testAccount2.Id;
        relation.ContactId = testContact.Id;
        relationList.add(relation);
        insert relationList;
    }
    
    static testMethod void validateQueryContactAccountsInfo() {
        Contact con = [SELECT Id FROM Contact WHERE LastName='TestOne'];
        
        Contact conWithAccountList = ProspectingAppContactListController.queryContactAccountsInfo(con.Id);
        System.assert(conWithAccountList.AccountContactRelations.size() == 2);
    }
    
    static testMethod void validateGetAccountContacts() {
        Account acc = [SELECT Id FROM Account WHERE Name='Test Account 2'];
        
        List<Contact> accountContactList = ProspectingAppContactListController.getAccountContacts(acc);
        System.assert(accountContactList.size() == 2);
    }
    
    static testMethod void validateQueryContactDetailsInfo(){
        
        Account acc = [SELECT Id FROM Account WHERE Name='Test Account 2'];
        
        List<Contact> accountContactList = ProspectingAppContactListController.getAccountContacts(acc);
        
        for (Contact aContact : accountContactList){
            Contact verificationContact = ProspectingAppContactListController.queryContactDetailsInfo(aContact.Id);
            System.assertEquals(aContact.Id, verificationContact.Id);
        }        
    }
}