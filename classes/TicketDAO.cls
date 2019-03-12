public with sharing class TicketDAO implements ITicketDAO {

	public interface ITicketDAO{
        List<Ticket__c> insertTickets(List<Ticket__c> ticketObjs);
        List<Ticket__c> upsertTickets(List<Ticket__c> ticketObjs);
        List<Ticket__c> deleteTickets(List<Ticket__c> ticketObjs);
  	}

  	public List<Ticket__c> insertTickets(List<Ticket__c> ticketObjs){
        insert ticketObjs;
        return ticketObjs;
  	}

  	public List<Ticket__c> upsertTickets(List<Ticket__c> ticketObjs){
        upsert ticketObjs;
        return ticketObjs;
  	}

  	public List<Ticket__c> deleteTickets(List<Ticket__c> ticketObjs){
        delete ticketObjs;
        return ticketObjs;
  	}
}