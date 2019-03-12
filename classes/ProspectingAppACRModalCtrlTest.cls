@isTest
private class ProspectingAppACRModalCtrlTest {
	static testMethod void validateGetPicklistValues() {
        List<String> acrRolesList = ProspectingAppACRModalController.getPicklistValues('AccountContactRelation', 'Roles');
        
        Set<String> acrRolesSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = AccountContactRelation.Roles.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            acrRolesSet.add(f.getValue());
        } 
        
        for(String role : acrRolesList) {
            System.assertEquals(true, acrRolesSet.contains(role));
        }
    }
    
    static testMethod void validateUpsertAccountContactRelation() {
        List<Account> testAccountList = new List<Account>();
        Account testAccount = new Account(Name='Test Account');
        testAccountList.add(testAccount);
        Account testAccount2 = new Account(Name='Test Account 2');
        testAccountList.add(testAccount2);
        Account testAccount3 = new Account(Name='Test Account 3');
        testAccountList.add(testAccount3);
        insert testAccountList;
        
        Contact testContact = new Contact(LastName='Test', AccountId=testAccount.Id);
        insert testContact;
        
        ProspectingAppACRModalController.upsertAccountContactRelation(testContact.Id, testAccount2.Id, 'Business User');
        ProspectingAppACRModalController.upsertAccountContactRelation(testContact.Id, testAccount3.Id, 'Business User');
        
        Contact con = [SELECT Id, (SELECT Id, Account.Name, Account.RecordType.Name FROM AccountContactRelations ORDER BY Account.Name ASC NULLS LAST) 
                       FROM Contact WHERE Id=:testContact.Id];
        System.assert(con.AccountContactRelations.size() == 3);
    }
}