public with sharing class TicketEventDAO implements ITicketEventDAO {

	public interface ITicketEventDAO{
        Ticket_Event__c insertTicketEvent(Ticket_Event__c ticketEventObj);
        Ticket_Event__c updateTicketEvent(Ticket_Event__c ticketEventObj);
        Ticket_Event__c grabTicketEventObj(Id ticketEventObj);
  	}

  	public Ticket_Event__c insertTicketEvent(Ticket_Event__c ticketEventObj){
        insert ticketEventObj;
        return ticketEventObj;
  	}

  	public Ticket_Event__c updateTicketEvent(Ticket_Event__c ticketEventObj){
        update ticketEventObj;
        return ticketEventObj;
  	}

  	public Ticket_Event__c grabTicketEventObj(Id ticketEventId){
        
        return [SELECT Name, incrementalNumberOfTickets__c, Event_Venue__c, Total_Number_of_Tickets__c, Assigned_Tickets__c, Unassigned_Tickets__c,
				Event_Street_Address__c, Event_City__c, Event_State__c, Event_Zip_Postal_Code__c, Event_Start_Date_Time__c, Event_Date__c, Event_Time__c, Event_Description__c, 
				Event_Venue_Name__c
                FROM Ticket_Event__c WHERE Id = :ticketEventId LIMIT 1];
  	}
}