/**************************************************************************************
  Apex Class Name     : TicketDistributionController
  Version             : 1.0
  Function            : This class handles the logic for the TicketDistribution vf page which dynamically creates tickets and handles the assigning of those tickets for events.
  Modification Log    :
 * Developer                                     Date                   
 * ----------------------------------------------------------------------------
 * Author: Nick Serafin/slalom              10/05/2016            
 *************************************************************************************/
public with sharing class TicketDistributionController {

    @TestVisible private TicketEventDAO.ITicketEventDAO ticketEventDAOInstance;
    @TestVisible private TicketDAO.ITicketDAO ticketDAOInstance;
    @TestVisible private TicketGroupingDAO.ITicketGroupingDAO ticketGroupingDAOInstance;
    @TestVisible private AccountDAO.IAccountDAO accountDAOInstance;
    @TestVisible private UserDAO.IUserDAO userDAOInstance;
    private Id ticketId;
    public Boolean hasAccess {get; set;}
    public Boolean ticketCreation {get; set;}
    public Decimal ticketNumber {get; set;}
    public Decimal groupingNumber {get; set;}
    public Decimal groupsOfTicketsToCreate {get; set;}
    public Decimal ticketGroupingId {get; set;}
    public Integer ticketGroupingObjId {get; set;}
    public Id recordToDelete {get; set;}
    public Ticket_Event__c ticketEvent {get; set;}
    public Ticket__c singleTicket {get; set;}
    public Ticket__c assignTicket {get; set;}
    public List<TicketGroupingWrapper> ticketGroupingWrapperList {get; set;}
    public Map<Id, Ticket_Grouping__c> ticketGroupingIdMap {get; set;}
    public Map<Id, Ticket__c> ticketMap {get; set;}
    public String ContactForEvent{get;set;}
    public boolean isGuest{get;set;}
    public Ticket_Event_Venue_Address__c eventVenueName {get;set;}
	public String selectedEventVenueName {get;set;}

    public TicketDistributionController(ApexPages.StandardController stdController) {
        this(stdController, new TicketEventDAO(), new TicketDAO(), new TicketGroupingDAO(), new AccountDAO(), new UserDAO());
      // isGuest=false;
    }

    @TestVisible private TicketDistributionController(ApexPages.StandardController stdController,
                                                        TicketEventDAO.ITicketEventDAO ticketEventDAOInstance,
                                                            TicketDAO.ITicketDAO ticketDAOInstance,
                                                                TicketGroupingDAO.ITicketGroupingDAO ticketGroupingDAOInstance,
                                                                    AccountDAO.IAccountDAO accountDAOInstance,
                                                                        UserDAO.IUserDAO userDAOInstance) {
        try {

            this.ticketEventDAOInstance = ticketEventDAOInstance;
            this.ticketDAOInstance = ticketDAOInstance;
            this.ticketGroupingDAOInstance = ticketGroupingDAOInstance;
            this.accountDAOInstance = accountDAOInstance;
            this.userDAOInstance = userDAOInstance;

            if (ApexPages.currentPage().getParameters().get('ticketId') != null) {

                hasAccess = true;
                ticketCreation = true;

                singleTicket = new Ticket__c();
                assignTicket = new Ticket__c();

                buildWrapper();

            } else {

                hasAccess = true;
                this.ticketEvent = (Ticket_Event__c)stdController.getRecord();
                ticketNumber = 0;
                groupingNumber = 0;
                ticketGroupingId = 0;
                singleTicket = new Ticket__c();
                assignTicket = new Ticket__c();
                ticketGroupingWrapperList = new List<TicketGroupingWrapper>();
            }

        } catch (Exception ex) {
            hasAccess = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error));
        }
    }

    private void buildWrapper() {
        try{

            ticketId = ApexPages.currentPage().getParameters().get('ticketId');

            ticketEvent = ticketEventDAOInstance.grabTicketEventObj(ticketId);

            String ticketEventId = ticketEvent.Id;
            ticketEvent.reportUrl__c = Label.EventTicketsReportId + '?pv0="' + ticketEventId.substring(0, 15) + '"';

            ticketGroupingIdMap = new Map<Id, Ticket_Grouping__c>();
            ticketMap = new Map<Id, Ticket__c>();

            List<Ticket_Grouping__c> ticketGroupings = ticketGroupingDAOInstance.grabTicketGroupings(ticketId);

            for (Ticket_Grouping__c ticketGroup : ticketGroupings) {
                ticketGroupingIdMap.put(ticketGroup.Id, ticketGroup);
            }

            for (Ticket_Grouping__c ticketGroup : ticketGroupings) {
                for (Ticket__c ticket : ticketGroup.Tickets__r) {
                    ticketMap.put(ticket.Id, ticket);
                }
            }

            ticketNumber = 0;
            groupingNumber = 0;

            ticketGroupingWrapperList = buildTicketGroupingWrapper(ticketGroupings);

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.buildWrapper()', 'High');
        }

    }

    private List<TicketGroupingWrapper> buildTicketGroupingWrapper(List<Ticket_Grouping__c> groupings) {
        try {

            List<TicketGroupingWrapper> ticketGroupingWrapper = new List<TicketGroupingWrapper>();

            for (Ticket_Grouping__c ticketGrouping : groupings) {
                groupingNumber++;
                String ticketRequester = '';
                TicketGroupingWrapper ticketGroupingObject = new TicketGroupingWrapper();
                ticketGroupingObject.ticketGroupingObject = ticketGrouping;
                ticketGroupingObject.ticketGroupingObject.Name = Label.TicketDistributionGroupingString + groupingNumber;
                ticketGroupingObject.ticketGroupingObject.groupingNumber__c = groupingNumber;
                ticketGroupingObject.ticketWrappers = buildTicketWrapper(ticketGrouping.Tickets__r, ticketGroupingObject.ticketGroupingObject.groupingNumber__c);
                if (ticketGroupingObject.ticketWrappers.size() == 0) {
                    continue;
                }
                for (TicketWrapper ticket : ticketGroupingObject.ticketWrappers) {
                    if(ticket.ticketObject.Requestor_contact__r.FirstName!=null){
                        ticketRequester =ticket.ticketObject.Requestor_contact__r.FirstName + ' ' + ticket.ticketObject.Requestor_contact__r.LastName;
                        system.debug('Ticket requeastor'+ticketRequester);
                        // ticket.ticketObject.Requestor__r.FirstName + ' ' + ticket.ticketObject.Requestor__r.LastName;
                    }else{
                        ticketRequester = ticket.ticketObject.Requestor_contact__r.LastName;
                        
                    }
                }

                ticketGroupingObject.ticketRequester = ticketRequester;
                ticketGroupingObject.ticketGroupingId = ticketGrouping.groupingNumber__c;
                ticketGroupingWrapper.add(ticketGroupingObject);
            }

            return ticketGroupingWrapper;

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.buildTicketGroupingWrapper()', 'High');
            return null;
        }
    }

    private List<TicketWrapper> buildTicketWrapper(List<Ticket__c> tickets, Decimal groupingNumber) {
        try {

            List<TicketWrapper> ticketWrapper = new List<TicketWrapper>();

            for (Ticket__c ticket : tickets) {
                ticketNumber++;
                TicketWrapper ticketObject = new TicketWrapper();
                ticketObject.ticketObject = ticket;
                ticketObject.ticketObject.Ticket_Number__c = ticketNumber;
                ticketObject.ticketGroupingId = groupingNumber;
                ticketObject.ticketId = Integer.valueOf(ticketNumber);
                ticketWrapper.add(ticketObject);
            }

            return ticketWrapper;

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.buildTicketWrapper()', 'High');
            return null;
        }
    }

    public void renderTickets() {
        try {

            ticketEvent.incrementalNumberOfTickets__c = 0;
            ticketCreation = true;
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.renderTickets()', 'High');
        }
    }

 
    public void assignTickets() {
        try {

            for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                for (TicketWrapper ticket : ticketGrouper.ticketWrappers) {
                    if (ticket.ticketGroupingId == ticketGroupingId) {
                        ticket.ticketObject.Business_Use_of_Ticket__c = assignTicket.Business_Use_of_Ticket__c;
                        ticket.ticketObject.assignToClient__c = assignTicket.assignToClient__c;
                        ticket.ticketObject.assignToEmployee__c = assignTicket.assignToEmployee__c;
                        ticket.ticketObject.assignToProducer__c = assignTicket.assignToProducer__c;
                        ticket.ticketObject.assignToHost__c = assignTicket.assignToHost__c;
                        ticket.ticketObject.assignToCharity__c = assignTicket.assignToCharity__c;
                        ticket.ticketObject.assignToEmployeeIncentive__c = assignTicket.assignToEmployeeIncentive__c;
                        
                        ticket.ticketObject.AssignToVendor__c=assignTicket.AssignToVendor__c;//check box
                        ticket.ticketObject.AssignToProspect__c=assignTicket.AssignToProspect__c;//check box
                        
                        
                        ticket.ticketObject.Client__c = assignTicket.Client__c;                 
                        ticket.ticketObject.Contact__c = assignTicket.Contact__c;  
                        ticket.ticketObject.Prospect__c=assignTicket.Prospect__c;
                        ticket.ticketObject.Vendor__c=assignTicket.Vendor__c;
                        
                        ticket.ticketObject.Specific_Vendor_Contact__c=assignTicket.Specific_Vendor_Contact__c; //look up field
                        ticket.ticketObject.Specific_Prospect_Contact__c=assignTicket.Specific_Prospect_Contact__c;//look up field 
                     //   ticket.ticketObject.Event_Guest_Name__c=assignTicket.Event_Guest_Name__c;   //3959 Guest Name field
                                          
                        ticket.ticketObject.Producer_for_Event__c = assignTicket.Producer_for_Event__c;
                        ticket.ticketObject.isSelected__c = true;
                    }
                }
            }

            assignTicket = new Ticket__c();

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.assignTickets()', 'High');
        }

    }
    public Pagereference changeTicketRequestor() {
	try {
             system.debug('Entered changeTicketRequestor');            
            for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                for (TicketWrapper ticket : ticketGrouper.ticketWrappers) {
                    if (ticket.ticketGroupingId == ticketGroupingId) {
                         system.debug('requester.Name************'+assignTicket.Requestor_contact__c);
                        ticket.ticketObject.Requestor_contact__c = assignTicket.Requestor_contact__c;                       
                    }
                }
            } 
             saveTickets();
             PageReference pr = new PageReference('/apex/TicketDistribution?ticketId='+ticketEvent.Id);
   			 pr.setRedirect(true);
             return pr;
         }
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.changeTicketRequestor()', 'High');
            return null;
        }
    }
    public void deleteTickets() {
        try {

            if (ticketGroupingObjId != null) {
                List<Ticket__c> ticketsToDelete = new List<Ticket__c>();

                for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                    for (TicketWrapper ticket : ticketGrouper.ticketWrappers) {
                        if (ticket.ticketGroupingId == ticketGroupingObjId) {
                            if (ticketMap != null) {
                                if (ticketMap.containsKey(ticket.ticketObject.Id)) {
                                    ticketsToDelete.add(ticket.ticketObject);
                                }
                            }
                        }
                    }
                }

                for (Integer i = 0; i < ticketGroupingWrapperList.size(); i++) {
                    for (Integer j = (ticketGroupingWrapperList[i].ticketWrappers.size() - 1) ; j >= 0; j--) {
                        TicketWrapper ticket = ticketGroupingWrapperList.get(i).ticketWrappers.get(j);
                        if (ticket.ticketGroupingId == ticketGroupingObjId) {
                            ticketGroupingWrapperList.get(i).ticketWrappers.remove(j);
                        }
                    }
                }

                ticketGroupingWrapperList.remove(ticketGroupingObjId - 1);
                if (ticketGroupingIdMap != null) {
                    if (recordToDelete != null && !ticketGroupingIdMap.isEmpty()) {
                        if (ticketGroupingIdMap.containsKey(recordToDelete)) {
                            ticketGroupingDAOInstance.deleteTicketGrouping(ticketGroupingIdMap.get(recordToDelete));
                        }
                    }
                }

                if (!ticketsToDelete.isEmpty()) {
                    ticketDAOInstance.deleteTickets(ticketsToDelete);
                }
            }

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.deleteTickets()', 'High');
        }
    }

    public void generateTickets() {
        try {

            groupsOfTicketsToCreate = ticketEvent.incrementalNumberOfTickets__c;

           // User requester = userDAOInstance.getRequesterForTicketDistro(singleTicket.Requestor_contact__c);
           Contact requester=userDAOInstance.getRequesterForTicketDistro(singleTicket.Requestor_contact__c);

            TicketGroupingWrapper ticketGroupingWrapper = new TicketGroupingWrapper();
            groupingNumber++;
            ticketGroupingWrapper.ticketGroupingObject.Name = Label.TicketDistributionGroupingString + groupingNumber;
            ticketGroupingWrapper.ticketGroupingObject.groupingNumber__c = groupingNumber;
            ticketGroupingWrapper.ticketRequester = requester.FirstName + ' ' + requester.LastName;
            ticketGroupingWrapper.ticketGroupingId = groupingNumber;

            List<TicketWrapper> ticketWrapperList = new List<TicketWrapper>();

            for (Integer i = 0; i < groupsOfTicketsToCreate; i++) {
                TicketWrapper newTicketWrapper = new TicketWrapper();
                ticketNumber++;
                newTicketWrapper.ticketGroupingId = groupingNumber;
                newTicketWrapper.ticketObject.Ticket_Number__c = ticketNumber;
                newTicketWrapper.ticketObject.Ticket_Price__c = singleTicket.Ticket_Price__c;
                newTicketWrapper.ticketObject.Requestor_contact__c = singleTicket.Requestor_contact__c;
                newTicketWrapper.ticketObject.Ticket_Type__c = singleTicket.Ticket_Type__c;
                newTicketWrapper.ticketId = Integer.valueOf(ticketNumber);

                ticketWrapperList.add(newTicketWrapper);
            }

            ticketGroupingWrapper.ticketWrappers = ticketWrapperList;

            ticketGroupingWrapperList.add(ticketGroupingWrapper);

            ticketEvent.incrementalNumberOfTickets__c = 0;
            singleTicket = new Ticket__c();

        } catch (Exception ex) {
            system.debug('exception: '+ex);
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.generateTickets()', 'High');
        }
    }

    public PageReference saveTickets() {
        try {
		
            Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();
            Id producerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Producer_Account).getRecordTypeId();
            Set<Id> producerIds = new Set<Id>();
            Set<Id> clientIds = new Set<Id>();
            Set<id> userIds = new Set<Id>();
            Set<id> contactIds=new Set<Id>();
            Map<Id, String> producerNumberMap = new Map<Id, String>();
            Map<Id, String> clientNumberMap = new Map<Id, String>();
           // Map<Id, User> userCostCenterMap = new Map<Id, User>();
            Map<Id, Contact> userCostCenterMap = new Map<Id, Contact>();
            
            List<Ticket_Grouping__c> ticketGroupingsToInsert = new List<Ticket_Grouping__c>();
            List<Ticket__c> ticketsToInsert = new List<Ticket__c>();

            for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                for (TicketWrapper ticket : ticketGrouper.ticketWrappers) {
                    if (ticket.ticketObject.Requestor_contact__c != null) {
                       // userIds.add(ticket.ticketObject.Requestor_contact__c);
                       contactIds.add(ticket.ticketObject.Requestor_contact__c);
                    }
                    if (ticket.ticketObject.assignToClient__c) {
                        clientIds.add(ticket.ticketObject.Client__c);
                    } else if (ticket.ticketObject.assignToProducer__c) {
                        producerIds.add(ticket.ticketObject.Producer_for_Event__c);
                    }
                }
            }

            List<Account> producerNumbers = accountDAOInstance.getProducerAccountsForTicketDistro(producerIds, producerAccountRecordTypeId);
            for (Account producer : producerNumbers) {
                producerNumberMap.put(producer.Id, producer.Tax_ID__c);
            }

            List<Account> clientNumbers = accountDAOInstance.getGroupAccountsForTicketDistro(clientIds, groupAccountRecordTypeId);
            for (Account client : clientNumbers) {
                clientNumberMap.put(client.Id, client.External_ID__c);
            }

            //List<User> userCostCenter = userDAOInstance.getCostCenterForTicketDistro(userIds);
            List<Contact> userCostCenter = userDAOInstance.getContactCostCenterForTicketDistro(contactIds);
            
            /*for (User u : userCostCenter) {
                userCostCenterMap.put(u.Id, u);
            }*/
            
            for (Contact u : userCostCenter) {
                userCostCenterMap.put(u.Id, u);
            }
            
            if (ticketId != null) {

                ticketEventDAOInstance.updateTicketEvent(ticketEvent);

                for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                    Ticket_Grouping__c newTicketGrouping = ticketGrouper.ticketGroupingObject;
                    newTicketGrouping.Ticket_Event__c = ticketEvent.Id;
                    ticketGroupingsToInsert.add(newTicketGrouping);
                }

                if (!ticketGroupingsToInsert.isEmpty()) {
                    ticketGroupingDAOInstance.upsertTicketGroupings(ticketGroupingsToInsert);
                }

                for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                    Ticket_Grouping__c newTicketGrouping = ticketGrouper.ticketGroupingObject;
                    for (TicketWrapper ticket : ticketGrouper.ticketWrappers) {
                        Ticket__c newTicket = ticket.ticketObject;
                        newTicket.Ticket_Event__c = ticketEvent.Id;
                        newTicket.Event_Start_Date_Time__c = ticketEvent.Event_Start_Date_Time__c;
                        newTicket.Event_Date__c=ticketEvent.Event_Date__c;
                        newTicket.Event_Time__c=ticketEvent.Event_Time__c;
                        
                        if (newTicket.Requestor_contact__c != null) {
                            if (userCostCenterMap.get(newTicket.Requestor_contact__c) != null) {
                                newTicket.Requester_Call_Center__c = userCostCenterMap.get(newTicket.Requestor_contact__c).Cost_Center__c;
                                newTicket.Requester_Email__c = userCostCenterMap.get(newTicket.Requestor_contact__c).Email;
                            }
                        }                      
                        if (newTicket.Client__c != null) {
                            newTicket.isSelected__c = true;
                            if (clientNumberMap.get(newTicket.Client__c) != null) {
                                newTicket.Client_Number__c = clientNumberMap.get(newTicket.Client__c);
                                newTicket.Producer_Number__c = null;
                            }
                        } else if (newTicket.Producer_for_Event__c != null) {
                            newTicket.isSelected__c = true;
                            if (producerNumberMap.get(newTicket.Producer_for_Event__c) != null) {
                                newTicket.Producer_Number__c = producerNumberMap.get(newTicket.Producer_for_Event__c);
                                newTicket.Client_Number__c = null;
                            }
                        } else if (newTicket.Contact__c != null) {
                            newTicket.isSelected__c = true;
                            newTicket.Client_Number__c = null;
                            newTicket.Producer_Number__c = null;
                        }else if(newticket.Vendor__c!=null){
                            newTicket.isSelected__c = true;
                            newTicket.Client_Number__c = null;
                            newTicket.Producer_Number__c = null;
                            
                        }else if(newticket.Prospect__c!=null){
                            newTicket.isSelected__c = true;
                             newTicket.Client_Number__c = null;
                            newTicket.Producer_Number__c = null;
                        }                        
                        if(newTicket.Contact__c == null && newTicket.Producer_for_Event__c == null && newTicket.Client__c == null && newticket.Prospect__c==null && newticket.Vendor__c==null ){
                            newTicket.isSelected__c = false;
                        }
                        newTicket.Ticket_Grouping__c = newTicketGrouping.Id;
                        ticketsToInsert.add(newTicket);
                    }
                }

                if (!ticketsToInsert.isEmpty()) {
                    ticketDAOInstance.upsertTickets(ticketsToInsert);
                }

            } else {

                ticketEventDAOInstance.insertTicketEvent(ticketEvent);

                for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                    Ticket_Grouping__c newTicketGrouping = ticketGrouper.ticketGroupingObject;
                    newTicketGrouping.Ticket_Event__c = ticketEvent.Id;
                    ticketGroupingsToInsert.add(newTicketGrouping);
                }

                if (!ticketGroupingsToInsert.isEmpty()) {
                    ticketGroupingDAOInstance.insertTicketGroupings(ticketGroupingsToInsert);
                }

                for (TicketGroupingWrapper ticketGrouper : ticketGroupingWrapperList) {
                    Ticket_Grouping__c newTicketGrouping = ticketGrouper.ticketGroupingObject;
                    for (TicketWrapper ticket : ticketGrouper.ticketWrappers) {
                        Ticket__c newTicket = ticket.ticketObject;
                        newTicket.Ticket_Event__c = ticketEvent.Id;
                        newTicket.Event_Start_Date_Time__c = ticketEvent.Event_Start_Date_Time__c;
                        newTicket.Event_Date__c=ticketEvent.Event_Date__c;
                        newTicket.Event_Time__c=ticketEvent.Event_Time__c;
                        if (newTicket.Requestor_contact__c != null) {
                            if (userCostCenterMap.get(newTicket.Requestor_contact__c) != null) {
                                newTicket.Requester_Call_Center__c = userCostCenterMap.get(newTicket.Requestor_contact__c).Cost_Center__c;
                                newTicket.Requester_Email__c = userCostCenterMap.get(newTicket.Requestor_contact__c).Email;
                            }
                        }
                        if (newTicket.Client__c != null) {
                            newTicket.isSelected__c = true;
                            if (clientNumberMap.get(newTicket.Client__c) != null) {
                                newTicket.Client_Number__c = clientNumberMap.get(newTicket.Client__c);
                                newTicket.Producer_Number__c = null;
                            }
                        } else if (newTicket.Producer_for_Event__c != null) {
                            newTicket.isSelected__c = true;
                            if (producerNumberMap.get(newTicket.Producer_for_Event__c) != null) {
                                newTicket.Producer_Number__c = producerNumberMap.get(newTicket.Producer_for_Event__c);
                                newTicket.Client_Number__c = null;
                            }
                        } else if (newTicket.Contact__c != null) {
                            newTicket.isSelected__c = true;
                            newTicket.Client_Number__c = null;
                            newTicket.Producer_Number__c = null;
                        }else if(newticket.Vendor__c!=null){
                            newTicket.isSelected__c = true;
                            newTicket.Client_Number__c = null;
                            newTicket.Producer_Number__c = null;
                            
                        }else if(newticket.Prospect__c!=null){
                            newTicket.isSelected__c = true;
                             newTicket.Client_Number__c = null;
                            newTicket.Producer_Number__c = null;
                        }
                        if(newTicket.Contact__c == null && newTicket.Producer_for_Event__c == null && newTicket.Client__c == null && newticket.Prospect__c==null && newticket.Vendor__c==null){
                            newTicket.isSelected__c = false;
                        }
                        newTicket.Ticket_Grouping__c = newTicketGrouping.Id;
                        ticketsToInsert.add(newTicket);
                    }
                }

               
                if (!ticketsToInsert.isEmpty()) {
                      ticketDAOInstance.insertTickets(ticketsToInsert);
                }

            }
	    		
            return new PageReference('/' + ticketEvent.Id);
		
        } catch (Exception ex) {
            ApexPages.addMessages(ex); 
            system.debug('ex....'+ex.getMessage());
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Valid Event Time! for exmple: 12:30 PM'));
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Ticket_Event__c', null, 'TicketDistributionController.saveTickets()', 'High');
            return null;
        }
    }

    public PageReference cancel() {

        if (ticketId != null) {
            return new PageReference('/' + ticketEvent.Id);
        } else {
            return new PageReference('/apex/TicketEventHomePage');
        }
    }
    public Pagereference EventVenueAddress(){    
        ticketEvent.Event_Street_Address__c = '';
        ticketEvent.Event_City__c = '';
        ticketEvent.Event_Zip_Postal_Code__c = ''; 
        If(ticketEvent.Event_Venue_Name__c == '' || ticketEvent.Event_Venue_Name__c == '--None--' || ticketEvent.Event_Venue_Name__c == 'Other'){
            ticketEvent.Event_Street_Address__c = '';
            ticketEvent.Event_City__c = '';
            ticketEvent.Event_Zip_Postal_Code__c = '';
        }else{         
            selectedEventVenueName = '';
            EventVenueName = Ticket_Event_Venue_Address__c.getValues('Other');
            selectedEventVenueName = ticketEvent.Event_Venue_Name__c;
            system.debug('-------selectedEventVenueName-----'+selectedEventVenueName);
            EventVenueName = Ticket_Event_Venue_Address__c.getValues(selectedEventVenueName);
            ticketEvent.Event_Street_Address__c = eventVenueName.Venue_Street__c;
            ticketEvent.Event_City__c = eventVenueName.Venue_City__c;
            ticketEvent.Event_Zip_Postal_Code__c = eventVenueName.Venue_ZipCode__c;
        }
        
        return null;
    }
    
    public Pagereference EventStateChange(){
        EventVenueName = Ticket_Event_Venue_Address__c.getValues('Other');
            ticketEvent.Event_Street_Address__c = '';
            ticketEvent.Event_City__c = '';
            ticketEvent.Event_Zip_Postal_Code__c = '';
        return null;
    } 

    public class TicketGroupingWrapper {
        public Ticket_Grouping__c ticketGroupingObject {get; set;}
        public String ticketRequester {get; set;}
        public Decimal ticketGroupingId {get; set;}
        public List<TicketWrapper> ticketWrappers {get; set;}

        public TicketGroupingWrapper() {
            ticketGroupingObject = new Ticket_Grouping__c();
            ticketWrappers = new List<TicketWrapper>();
        }
    }

    public class TicketWrapper {
        public Ticket__c ticketObject {get; set;}
        public Integer ticketId {get; set;}
        public Decimal ticketGroupingId {get; set;}

        public TicketWrapper() {
            ticketObject = new Ticket__c();
        }
    }
}