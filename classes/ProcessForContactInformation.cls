public class ProcessForContactInformation {
    @InvocableMethod
    public static void sendCallout(List<Contact> contacts){
        System.enqueueJob(new ApexJobContactUpdate(contacts));
    }
}