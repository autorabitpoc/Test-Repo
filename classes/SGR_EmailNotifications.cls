global class SGR_EmailNotifications {
    public static void sendEmailNotification(String emailMessgaeBody,String recordName)
    {
        List <string> toaddress = new List <string> ();         
        List<SGR__c> intgerationDlList= SGR__c.getAll().Values();
        for(SGR__c  integrationdl:intgerationDlList)
            toaddress.add(integrationdl.Email_Address__c); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                  
        mail.setToAddresses(toaddress) ;                     
        mail.setSubject('Salesforce Error Update in - ' +recordName);                          
        mail.setHtmlBody(emailMessgaeBody);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );       
    }                                 
}