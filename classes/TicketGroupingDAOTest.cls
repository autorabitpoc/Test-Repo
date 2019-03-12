/**************************************************************************************
  Apex Class Name     : TicketGroupingDAOTest
  Version             : 1.0
  Function            : This is a test class for the TicketGroupingDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             10/26/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class TicketGroupingDAOTest { 

	@isTest
	static void ticketGroupingDAOTest(){

		TicketGroupingDAO.ITicketGroupingDAO ticketGroupingDAOInstance = new TicketGroupingDAO();

		Ticket_Event__c testEvent = new Ticket_Event__c();
		testEvent.Name = 'Game';
        testEvent.Event_Date__c = date.today();
        testEvent.Event_State__c = 'Texas';
        testEvent.Event_Venue_Name__c = 'Other';
        testEvent.Event_Street_Address__c = '121 Test Street';
        testEvent.Event_City__c = 'Plano';
        testEvent.Event_Zip_Postal_Code__c = '75024';
		insert testEvent;

		List<Ticket_Grouping__c> ticketGroupings = new List<Ticket_Grouping__c>();
		Ticket_Grouping__c ticketGrouping = new Ticket_Grouping__c();
		ticketGrouping.Ticket_Event__c = testEvent.Id;
		ticketGroupings.add(ticketGrouping);

		ticketGroupingDAOInstance.insertTicketGroupings(ticketGroupings);
		ticketGroupingDAOInstance.upsertTicketGroupings(ticketGroupings);

		List<Ticket_Grouping__c> ticketGroupingObjs = [SELECT Id FROM Ticket_Grouping__c];
		System.assertEquals(1, ticketGroupingObjs.size());

		ticketGroupingDAOInstance.deleteTicketGrouping(ticketGrouping);
		ticketGroupingDAOInstance.grabTicketGroupings(testEvent.Id);
	}
}