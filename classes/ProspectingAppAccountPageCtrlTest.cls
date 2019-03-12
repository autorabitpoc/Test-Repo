@isTest
private class ProspectingAppAccountPageCtrlTest {
    static testMethod void validateUpsertRecord() {
    	Account newAcc = new Account(Name='New Account 1');
        
        Account existingAcc = new Account(Name='Existing Account');
        insert existingAcc;
        
        ProspectingAppAccountPageController.upsertRecord(newAcc);
        System.assertNotEquals(null, newAcc.Id);
        
        existingAcc.Website = 'www.test.com';
        ProspectingAppAccountPageController.upsertRecord(existingAcc);
        existingAcc = [SELECT Id, Website FROM Account WHERE Id=:existingAcc.Id];
        System.assertEquals('www.test.com', existingAcc.Website);
    }
    
	static testMethod void validateGetPicklistValues() {
        List<String> accountTypeList = ProspectingAppAccountPageController.getPicklistValues('Account', 'Type');
        
        Set<String> accountTypeSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            accountTypeSet.add(f.getValue());
        } 
        
        for(String type : accountTypeList) {
            System.assertEquals(true, accountTypeSet.contains(type));
        }
    }
}