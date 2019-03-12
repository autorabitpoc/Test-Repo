/**************************************************************************************
  Apex Class Name     : TicketEventDAOTest
  Version             : 1.0
  Function            : This is a test class for the TicketEventDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             10/26/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class TicketEventDAOTest { 

	@isTest
	static void ticketEventDAOTest(){

		TicketEventDAO.ITicketEventDAO ticketEventDAOInstance = new TicketEventDAO();

		Ticket_Event__c testEvent = new Ticket_Event__c();
        testEvent.Event_Date__c = date.today();
        testEvent.Event_State__c = 'Texas';
        testEvent.Event_Venue_Name__c = 'Other';
        testEvent.Event_Street_Address__c = '121 Test Street';
        testEvent.Event_City__c = 'Plano';
        testEvent.Event_Zip_Postal_Code__c = '75024';
		testEvent.Name = 'Game';

		ticketEventDAOInstance.insertTicketEvent(testEvent);
		ticketEventDAOInstance.updateTicketEvent(testEvent);
		ticketEventDAOInstance.grabTicketEventObj(testEvent.Id);

		List<Ticket_Event__c> ticketEventObj = [SELECT Id FROM Ticket_Event__c];
		System.assertEquals(1, ticketEventObj.size());

	}
}