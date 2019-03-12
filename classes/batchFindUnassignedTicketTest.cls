/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class batchFindUnassignedTicketTest {

     static testMethod void testBatchFindUnassignedTicketExecute(){
        Ticket_Event__c ticketEvent= new Ticket_Event__c();
        
        ticketEvent.Event_Date__c=system.today().addDays(2);//Date.newInstance(2017,4,18);
        ticketEvent.name='testEvent';
        ticketEvent.Event_State__c='Illinois';
        ticketEvent.Event_Venue__c='Other';
        ticketEvent.Event_Venue_Name__c='Other';
        ticketEvent.Event_Street_Address__c='1234 W. Washington St. Chicago,IL';
         ticketEvent.Event_City__c='Chicago';
        ticketEvent.Event_Description__c='this is test event, donnot go.';
        ticketEvent.Event_Zip_Postal_Code__c='60601';
        
        insert ticketEvent;
        
        Ticket_Grouping__c grouping1=new Ticket_Grouping__c();
        grouping1.name='grouping1';
        grouping1.groupingNumber__c=2;
        grouping1.Ticket_event__c=ticketEvent.id;
        
        insert grouping1;
        
        Contact req=new Contact();
        Id reId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
        req.RecordTypeId=reId;
        req.lastName='TicketEvent';
        req.firstName='testReq';
        req.email='test1@nomail.com';
        req.cost_center__c='test1234';
        insert req;
  
        Ticket__c ticket=new Ticket__c();
        ticket.Ticket_Event__c=ticketEvent.id;
        ticket.Ticket_Grouping__c=grouping1.id;
        ticket.Requestor_contact__c=req.id;
        insert ticket;
        
        test.startTest();
        
        BatchFindUnassignedTicket b = new BatchFindUnassignedTicket();
        Database.executeBatch( b );
        test.stopTest();
        
        
    }
    static testMethod void testbatchFindUnassignedTicketSchedule() {
       User user4 = TestUtils.createTestUser('RunAsUser4', 'System Administrator');
        System.runAs(user4) {
        
            // Start the test
            Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2022';

            // Schedule the test job     
            String jobId = System.schedule('BatchFindUnassignedTicket', CRON_EXP, new BatchFindUnassignedTicketSchedule());
          
            // Stop the test
            Test.stopTest();
        }
        
    }
}