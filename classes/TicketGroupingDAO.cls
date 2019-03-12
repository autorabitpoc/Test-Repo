/**********************************************************************************/
/*SFDC-7930 - 2018/02 - Added Charity_Organization__c to SOQL on                  */
/*                        grabTicketGroupings() method.                           */
/**********************************************************************************/
public with sharing class TicketGroupingDAO implements ITicketGroupingDAO {

  public interface ITicketGroupingDAO{
        List<Ticket_Grouping__c> insertTicketGroupings(List<Ticket_Grouping__c> ticketGroupingObjs);
        List<Ticket_Grouping__c> upsertTicketGroupings(List<Ticket_Grouping__c> ticketGroupingObjs);
        List<Ticket_Grouping__c> grabTicketGroupings(Id ticketObj);
        Ticket_Grouping__c deleteTicketGrouping(Ticket_Grouping__c ticketGroupingObj);
    }

    public List<Ticket_Grouping__c> insertTicketGroupings(List<Ticket_Grouping__c> ticketGroupingObjs){
        insert ticketGroupingObjs;
        return ticketGroupingObjs;
    }

    public List<Ticket_Grouping__c> upsertTicketGroupings(List<Ticket_Grouping__c> ticketGroupingObjs){
        upsert ticketGroupingObjs;
        return ticketGroupingObjs;
    }

    public Ticket_Grouping__c deleteTicketGrouping(Ticket_Grouping__c ticketGroupingObj){
      delete ticketGroupingObj;
      return ticketGroupingObj;
    }

    public List<Ticket_Grouping__c> grabTicketGroupings(Id ticketId){
        
        return [SELECT Name, groupingNumber__c, Ticket_Event__c,(SELECT Name, Contact__c, Charity_Organization__c, Ticket_Grouping__c, Ticket_Price__c, assignToClient__c,Guest_Name__c,Unused_Ticket__c,
        assignToEmployee__c, assignToProducer__c, AssignToVendor__c,AssignToProspect__c,assignToEmployeeIncentive__c, assignToHost__c, assignToCharity__c, isSelected__c, Business_Use_of_Ticket__c, 
        Requestor_contact__c, Requestor_contact__r.lastName, Requestor_contact__r.firstName, Requestor__r.FirstName, Requestor__r.LastName, Producer_Contact__c,
        Client__c, Client_Number__c, Contact_for_Event__c, Vendor__c,Prospect__c, Producer_for_Event__c,Specific_Prospect_Contact__c,Specific_Vendor_Contact__c, Producer_Number__c,
        Ticket_Event__c, Ticket_Number__c, Ticket_Type__c,Assigned_To__c FROM Tickets__r ORDER BY Ticket_Number__c) FROM Ticket_Grouping__c 
        WHERE Ticket_Event__c = :ticketId ORDER BY groupingNumber__c];
    }
}