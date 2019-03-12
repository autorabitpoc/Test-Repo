/**************************************************************************************
  Apex Class Name     : TicketDAOTest
  Version             : 1.0
  Function            : This is a test class for the TicketDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             10/26/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class TicketDAOTest { 

	@isTest
	static void ticketDAOTest(){

		TicketDAO.ITicketDAO ticketDAOInstance = new TicketDAO();

		Ticket_Event__c testEvent = new Ticket_Event__c();
		testEvent.Name = 'Game';
        testEvent.Event_Date__c = date.today();
        testEvent.Event_State__c = 'Texas';
        testEvent.Event_Venue_Name__c = 'Other';
        testEvent.Event_Street_Address__c = '121 Test Street';
        testEvent.Event_City__c = 'Plano';
        testEvent.Event_Zip_Postal_Code__c = '75024';        
		insert testEvent;

		List<Ticket__c> tickets = new List<Ticket__c>();
		Ticket__c ticket = new Ticket__c();
		ticket.Ticket_Event__c = testEvent.Id;
		tickets.add(ticket);

		ticketDAOInstance.insertTickets(tickets);
		ticketDAOInstance.upsertTickets(tickets);

		List<Ticket__c> ticketObjs = [SELECT Id FROM Ticket__c];
		System.assertEquals(1, ticketObjs.size());

		ticketDAOInstance.deleteTickets(tickets);
	}
}