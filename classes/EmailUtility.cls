public class EmailUtility implements IEmailUtility{

    public interface IEmailUtility{
        void circulateEmail (String toAddress, String subject, String emailMessage);
    }

    public static void circulateEmail (String toAddress, String subject, String emailMessage) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        toAddresses.add(toAddress);      

        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
        }
    }
    
	public static void circulateEmail( List<String> toAddresses, String subject, String body) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setHtmlBody(body);
        
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
        }      
    }
}