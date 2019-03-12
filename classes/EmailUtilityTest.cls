@isTest
private class EmailUtilityTest { 
    @isTest static void circulateEmailTest(){
        EmailUtility.IEmailUtility emailUtilInstance = new EmailUtility();
        String toAddress = 'testEmail@test.com'; 
        String subject = 'Test Subject';
        String emailMessage = 'This is a test message';
        emailUtilInstance.circulateEmail(toAddress, subject, emailMessage);
    }
}