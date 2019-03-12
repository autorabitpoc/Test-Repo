/**************************************************************************************
  Apex Class Name     : TicketDistributionControllerTest
  Version             : 1.0
  Function            : This is a test class for the TicketDistributionController class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             10/25/2016
*************************************************************************************/
@isTest(SeeAllData=false)
private class TicketDistributionControllerTest {

    @isTest static void ticketDistributionTest() {

        Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Id producerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();

        List<Account> groupAccounts = new List<Account>();
        Set<Id> groupAccountIds = new Set<Id>();
        Account testGroupAccount = new Account();
        testGroupAccount.RecordTypeId = groupAccountRecordTypeId;
        testGroupAccount.External_ID__c = '1232';
        testGroupAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        groupAccountIds.add(testGroupAccount.Id);
        groupAccounts.add(testGroupAccount);

        List<Account> producerAccounts = new List<Account>();
        Set<Id> producerAccountIds = new Set<Id>();
        Account testProducerAccount = new Account();
        testProducerAccount.RecordTypeId = producerAccountRecordTypeId;
        testProducerAccount.Tax_ID__c = '1234';
        testProducerAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        producerAccountIds.add(testProducerAccount.Id);
        producerAccounts.add(testProducerAccount);
        
        Ticket_Event_Venue_Address__c EventVenueName = new Ticket_Event_Venue_Address__c();
        EventVenueName.Name = 'Toyota Center';  
        EventVenueName.Venue_Street__c = '1510 Polk Street';
        EventVenueName.Venue_City__c = 'Houston';
        EventVenueName.Venue_ZipCode__c = '77002';
        insert EventVenueName;
        
        Ticket_Event_Venue_Address__c EventVenueNameother = new Ticket_Event_Venue_Address__c();
        EventVenueNameother.Name = 'Other';  
        EventVenueNameother.Venue_Street__c = 'Test Street';
        EventVenueNameother.Venue_City__c = 'Test City';
        EventVenueNameother.Venue_ZipCode__c = '23234';
        insert EventVenueNameother;
        
    
        Ticket_Event__c testEvent = new Ticket_Event__c();       
        testEvent.Id = fflib_IDGenerator.generate( Ticket_Event__c.SObjectType );
        testEvent.Name = 'Hockey Game';
        testEvent.Event_Venue_Name__c = 'Toyota Center';
       
        List<Ticket_Grouping__c> ticketGroupings = new List<Ticket_Grouping__c>();
        Ticket_Grouping__c ticketGrouping = new Ticket_Grouping__c();
        ticketGrouping.Id = fflib_IDGenerator.generate( Ticket_Grouping__c.SObjectType );
        ticketGrouping.Ticket_Event__c = testEvent.Id;
        ticketGroupings.add(ticketGrouping);

        List<Ticket__c> tickets = new List<Ticket__c>();
        Ticket__c ticket = new Ticket__c();
        ticket.Ticket_Event__c = testEvent.Id;
        ticket.Ticket_Grouping__c = ticketGrouping.Id;
        ticket.Id = fflib_IDGenerator.generate( Ticket__c.SObjectType );
        tickets.add(ticket);

        //List<User> users = new List<User>();
        List<Contact>users =new List<Contact>();
        Set<Id> userIds = new Set<Id>();
        //User testUser = new User();
        Contact testUser=new Contact();
        testUser.FirstName ='Nick';
        testUser.LastName ='Serafin';
        testUser.Email = 'testing@example.com';
        testUser.Cost_Center__c = '1231252';
        testUser.Id = fflib_IDGenerator.generate( Contact.SObjectType );
        userIds.add(testUser.Id);
        users.add(testUser);

        PageReference pageRef = new PageReference('/apex/TicketDistribution');
        Test.setCurrentPage(pageRef);

        fflib_ApexMocks userMocks = new fflib_ApexMocks(); 

        UserDAO.IUserDAO userDAOInstance;
        userDAOInstance = new MockDAOs.UserDAOMock(userMocks);  

        userMocks.startStubbing();
        userMocks.when(userDAOInstance.getRequesterForTicketDistro(testUser.Id))
                    .thenReturn(testUser);
        userMocks.stopStubbing();

        userMocks.startStubbing();
        userMocks.when(userDAOInstance.getContactCostCenterForTicketDistro(userIds))
                    .thenReturn(users);
        userMocks.stopStubbing();

        fflib_ApexMocks accountMocks = new fflib_ApexMocks(); 

        AccountDAO.IAccountDAO accountDAOInstance;
        accountDAOInstance = new MockDAOs.AccountDAOMock(accountMocks);  

        accountMocks.startStubbing();
        accountMocks.when(accountDAOInstance.getProducerAccountsForTicketDistro(producerAccountIds, producerAccountRecordTypeId))
                    .thenReturn(producerAccounts);
        accountMocks.stopStubbing();

        accountMocks.startStubbing();
        accountMocks.when(accountDAOInstance.getGroupAccountsForTicketDistro(groupAccountIds, groupAccountRecordTypeId))
                    .thenReturn(groupAccounts);
        accountMocks.stopStubbing();

        fflib_ApexMocks ticketEventMocks = new fflib_ApexMocks(); 

        TicketEventDAO.ITicketEventDAO ticketEventDAOInstance;
        ticketEventDAOInstance = new MockDAOs.TicketEventDAOMock(ticketEventMocks);  

        ticketEventMocks.startStubbing();
        ticketEventMocks.when(ticketEventDAOInstance.insertTicketEvent(testEvent))
                    .thenReturn(testEvent);
        ticketEventMocks.stopStubbing();

        fflib_ApexMocks ticketGroupingMocks = new fflib_ApexMocks(); 

        TicketGroupingDAO.ITicketGroupingDAO ticketGroupingDAOInstance;
        ticketGroupingDAOInstance = new MockDAOs.TicketGroupingDAOMock(ticketGroupingMocks);  

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.insertTicketGroupings(ticketGroupings))
                    .thenReturn(ticketGroupings);
        ticketGroupingMocks.stopStubbing();

        fflib_ApexMocks ticketMocks = new fflib_ApexMocks(); 

        TicketDAO.ITicketDAO ticketDAOInstance;
        ticketDAOInstance = new MockDAOs.TicketDAOMock(ticketMocks);  

        ticketMocks.startStubbing();
        ticketMocks.when(ticketDAOInstance.insertTickets(tickets))
                    .thenReturn(tickets);
        ticketMocks.stopStubbing();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testEvent);
        TicketDistributionController ticketDistributionController = new TicketDistributionController(stdController, 
                                                                                                        ticketEventDAOInstance, 
                                                                                                            ticketDAOInstance, 
                                                                                                                ticketGroupingDAOInstance,
                                                                                                                    accountDAOInstance,
                                                                                                                        userDAOInstance);
        ticketDistributionController.ticketEventDAOInstance = ticketEventDAOInstance;
        ticketDistributionController.ticketDAOInstance = ticketDAOInstance;
        ticketDistributionController.ticketGroupingDAOInstance = ticketGroupingDAOInstance;
        ticketDistributionController.accountDAOInstance = accountDAOInstance;
        ticketDistributionController.userDAOInstance = userDAOInstance;
        
        ticketDistributionController.renderTickets();
        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 14;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        System.assertEquals(ticketDistributionController.ticketGroupingWrapperList.size(), 1);

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToClient__c = true;
        ticketDistributionController.assignTicket.Client__c = testGroupAccount.Id;
        ticketDistributionController.ticketGroupingId = 1;
        ticketDistributionController.assignTickets();

        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 142;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToProducer__c = true;
        ticketDistributionController.assignTicket.Producer_For_Event__c = testProducerAccount.Id;
        ticketDistributionController.ticketGroupingId = 2;
        ticketDistributionController.assignTickets();

        ticketDistributionController.saveTickets();
        ticketDistributionController.cancel();
		ticketDistributionController.EventVenueAddress();
        ticketDistributionController.EventStateChange();
        
        System.assertEquals(ticketDistributionController.ticketGroupingWrapperList.size(), 2);

    }

    @isTest static void ticketDistributionEditTest() {

        Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Id producerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();

        List<Account> groupAccounts = new List<Account>();
        Set<Id> groupAccountIds = new Set<Id>();
        Account testGroupAccount = new Account();
        testGroupAccount.RecordTypeId = groupAccountRecordTypeId;
        testGroupAccount.External_ID__c = '1232';
        testGroupAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        groupAccountIds.add(testGroupAccount.Id);
        groupAccounts.add(testGroupAccount);

        List<Account> producerAccounts = new List<Account>();
        Set<Id> producerAccountIds = new Set<Id>();
        Account testProducerAccount = new Account();
        testProducerAccount.RecordTypeId = producerAccountRecordTypeId;
        testProducerAccount.Tax_ID__c = '1234';
        testProducerAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        producerAccountIds.add(testProducerAccount.Id);
        producerAccounts.add(testProducerAccount);

        Contact testContact = new Contact();
        testContact.Id = fflib_IDGenerator.generate(Contact.SObjectType);
    
        Ticket_Event__c testEvent = new Ticket_Event__c();
        testEvent.Id = fflib_IDGenerator.generate( Ticket_Event__c.SObjectType );
        testEvent.Name = 'Hockey Game';
       
        List<Ticket_Grouping__c> ticketGroupings = new List<Ticket_Grouping__c>();
        Ticket_Grouping__c ticketGrouping = new Ticket_Grouping__c();
        ticketGrouping.Id = fflib_IDGenerator.generate( Ticket_Grouping__c.SObjectType );
        ticketGrouping.Ticket_Event__c = testEvent.Id;
        ticketGroupings.add(ticketGrouping);

        List<Ticket__c> tickets = new List<Ticket__c>();
        Ticket__c ticket = new Ticket__c();
        ticket.Ticket_Event__c = testEvent.Id;
        ticket.Ticket_Grouping__c = ticketGrouping.Id;
        ticket.Id = fflib_IDGenerator.generate( Ticket__c.SObjectType );
        tickets.add(ticket);

        List<User> users = new List<User>();
        Set<Id> userIds = new Set<Id>();
        User testUser = new User();
        testUser.FirstName ='Nick';
        testUser.LastName ='Serafin';
        testUser.Email = 'testing@example.com';
        testUser.Cost_Center__c = '1231252';
        testUser.Id = fflib_IDGenerator.generate( User.SObjectType );
        userIds.add(testUser.Id);
        users.add(testUser);

        PageReference pageRef = new PageReference('/apex/TicketDistribution');
        pageRef.getParameters().put('ticketId', testEvent.Id);
        Test.setCurrentPage(pageRef);

        List<Ticket_Grouping__c> ticketGroupingRelationship = (List<Ticket_Grouping__c>)
        MockRelationshipHelper.makeRelationship(
            List<Ticket_Grouping__c>.class,
        new List<Ticket_Grouping__c> {ticketGrouping},
        Ticket__c.Ticket_Grouping__c,
        new List<List<Ticket__c>> {tickets});

        fflib_ApexMocks userMocks = new fflib_ApexMocks(); 

        UserDAO.IUserDAO userDAOInstance;
        userDAOInstance = new MockDAOs.UserDAOMock(userMocks);  

        userMocks.startStubbing();
        userMocks.when(userDAOInstance.getRequesterForTicketDistro(testUser.Id))
                    .thenReturn(testUser);
        userMocks.stopStubbing();

        userMocks.startStubbing();
        userMocks.when(userDAOInstance.getContactCostCenterForTicketDistro(userIds))
                    .thenReturn(users);
        userMocks.stopStubbing();

        fflib_ApexMocks accountMocks = new fflib_ApexMocks(); 

        AccountDAO.IAccountDAO accountDAOInstance;
        accountDAOInstance = new MockDAOs.AccountDAOMock(accountMocks);  

        accountMocks.startStubbing();
        accountMocks.when(accountDAOInstance.getProducerAccountsForTicketDistro(producerAccountIds, producerAccountRecordTypeId))
                    .thenReturn(producerAccounts);
        accountMocks.stopStubbing();

        accountMocks.startStubbing();
        accountMocks.when(accountDAOInstance.getGroupAccountsForTicketDistro(groupAccountIds, groupAccountRecordTypeId))
                    .thenReturn(groupAccounts);
        accountMocks.stopStubbing();

        fflib_ApexMocks ticketEventMocks = new fflib_ApexMocks(); 

        TicketEventDAO.ITicketEventDAO ticketEventDAOInstance;
        ticketEventDAOInstance = new MockDAOs.TicketEventDAOMock(ticketEventMocks);  

        ticketEventMocks.startStubbing();
        ticketEventMocks.when(ticketEventDAOInstance.grabTicketEventObj(testEvent.Id))
                    .thenReturn(testEvent);
        ticketEventMocks.stopStubbing();

        ticketEventMocks.startStubbing();
        ticketEventMocks.when(ticketEventDAOInstance.updateTicketEvent(testEvent))
                    .thenReturn(testEvent);
        ticketEventMocks.stopStubbing();

        fflib_ApexMocks ticketGroupingMocks = new fflib_ApexMocks(); 

        TicketGroupingDAO.ITicketGroupingDAO ticketGroupingDAOInstance;
        ticketGroupingDAOInstance = new MockDAOs.TicketGroupingDAOMock(ticketGroupingMocks);  

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.grabTicketGroupings(testEvent.Id))
                    .thenReturn(ticketGroupingRelationship);
        ticketGroupingMocks.stopStubbing();

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.upsertTicketGroupings(ticketGroupings))
                    .thenReturn(ticketGroupings);
        ticketGroupingMocks.stopStubbing();

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.deleteTicketGrouping(ticketGrouping))
                    .thenReturn(ticketGrouping);
        ticketGroupingMocks.stopStubbing();

        fflib_ApexMocks ticketMocks = new fflib_ApexMocks(); 

        TicketDAO.ITicketDAO ticketDAOInstance;
        ticketDAOInstance = new MockDAOs.TicketDAOMock(ticketMocks);  

        ticketMocks.startStubbing();
        ticketMocks.when(ticketDAOInstance.upsertTickets(tickets))
                    .thenReturn(tickets);
        ticketMocks.stopStubbing();

        ticketMocks.startStubbing();
        ticketMocks.when(ticketDAOInstance.deleteTickets(tickets))
                    .thenReturn(tickets);
        ticketMocks.stopStubbing();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testEvent);
        TicketDistributionController ticketDistributionController = new TicketDistributionController(stdController, 
                                                                                                        ticketEventDAOInstance, 
                                                                                                            ticketDAOInstance, 
                                                                                                                ticketGroupingDAOInstance,
                                                                                                                    accountDAOInstance,
                                                                                                                        userDAOInstance);
        ticketDistributionController.ticketEventDAOInstance = ticketEventDAOInstance;
        ticketDistributionController.ticketDAOInstance = ticketDAOInstance;
        ticketDistributionController.ticketGroupingDAOInstance = ticketGroupingDAOInstance;
        ticketDistributionController.accountDAOInstance = accountDAOInstance;
        ticketDistributionController.userDAOInstance = userDAOInstance;
        
        ticketDistributionController.renderTickets();
        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 14;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToClient__c = true;
        ticketDistributionController.assignTicket.Client__c = testGroupAccount.Id;
        ticketDistributionController.ticketGroupingId = 1;
        ticketDistributionController.assignTickets();

        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 142;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToProducer__c = true;
        ticketDistributionController.assignTicket.Producer_For_Event__c = testProducerAccount.Id;
        ticketDistributionController.ticketGroupingId = 2;
        ticketDistributionController.assignTickets();

        ticketDistributionController.saveTickets();
        ticketDistributionController.cancel();

        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 111;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Personal';
        ticketDistributionController.assignTicket.assignToEmployee__c = true;
        ticketDistributionController.assignTicket.Contact__c = testContact.Id;
        ticketDistributionController.ticketGroupingId = 3;
        ticketDistributionController.ticketGroupingObjId = 3;
        ticketDistributionController.assignTickets();
        ticketDistributionController.deleteTickets();

        ticketDistributionController.saveTickets();

        System.assertEquals(ticketDistributionController.ticketGroupingWrapperList.size(), 1);

    }
     @isTest static void ticketDistributionChangeRequesterTest() {

        Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Id producerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();

        List<Account> groupAccounts = new List<Account>();
        Set<Id> groupAccountIds = new Set<Id>();
        Account testGroupAccount = new Account();
        testGroupAccount.RecordTypeId = groupAccountRecordTypeId;
        testGroupAccount.External_ID__c = '1232';
        testGroupAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        groupAccountIds.add(testGroupAccount.Id);
        groupAccounts.add(testGroupAccount);

        List<Account> producerAccounts = new List<Account>();
        Set<Id> producerAccountIds = new Set<Id>();
        Account testProducerAccount = new Account();
        testProducerAccount.RecordTypeId = producerAccountRecordTypeId;
        testProducerAccount.Tax_ID__c = '1234';
        testProducerAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        producerAccountIds.add(testProducerAccount.Id);
        producerAccounts.add(testProducerAccount);

        Contact testContact = new Contact();
        testContact.Id = fflib_IDGenerator.generate(Contact.SObjectType);
    
        Ticket_Event__c testEvent = new Ticket_Event__c();
        testEvent.Id = fflib_IDGenerator.generate( Ticket_Event__c.SObjectType );
        testEvent.Name = 'Hockey Game';       
        testEvent.Event_Venue_Name__c = 'AT & T Center';
        testEvent.Event_Street_Address__c = '14888 palm desrt ln';
        testEvent.Event_City__c = 'Frisco';
        testEvent.Event_State__c = 'TX';        
        testEvent.Event_Zip_Postal_Code__c = '75035';
        
        List<Ticket_Grouping__c> ticketGroupings = new List<Ticket_Grouping__c>();
        Ticket_Grouping__c ticketGrouping = new Ticket_Grouping__c();
        ticketGrouping.Id = fflib_IDGenerator.generate( Ticket_Grouping__c.SObjectType );
        ticketGrouping.Ticket_Event__c = testEvent.Id;
        ticketGroupings.add(ticketGrouping);

        List<Ticket__c> tickets = new List<Ticket__c>();
        Ticket__c ticket = new Ticket__c();
        ticket.Ticket_Event__c = testEvent.Id;
        ticket.Ticket_Grouping__c = ticketGrouping.Id;
        ticket.Id = fflib_IDGenerator.generate( Ticket__c.SObjectType );
        tickets.add(ticket);

        List<User> users = new List<User>();
        Set<Id> userIds = new Set<Id>();
        User testUser = new User();
        testUser.FirstName ='Nick';
        testUser.LastName ='Serafin';
        testUser.Email = 'testing@example.com';
        testUser.Cost_Center__c = '1231252';
        testUser.Id = fflib_IDGenerator.generate( User.SObjectType );
        userIds.add(testUser.Id);
        users.add(testUser);
         
         User testUser1 = new User();
        testUser1.FirstName ='Jonny';
        testUser1.LastName ='Serafin';
        testUser1.Email = 'testing@example.com';
        testUser1.Cost_Center__c = '1231252';
        testUser1.Id = fflib_IDGenerator.generate( User.SObjectType );
        userIds.add(testUser1.Id);
        users.add(testUser1);
         
        Contact testUser2 = new Contact();
        testUser2.Id=fflib_IDGenerator.generate(Contact.SObjectType);
       

        PageReference pageRef = new PageReference('/apex/TicketDistribution');
        pageRef.getParameters().put('ticketId', testEvent.Id);
        Test.setCurrentPage(pageRef);

        List<Ticket_Grouping__c> ticketGroupingRelationship = (List<Ticket_Grouping__c>)
        MockRelationshipHelper.makeRelationship(
            List<Ticket_Grouping__c>.class,
        new List<Ticket_Grouping__c> {ticketGrouping},
        Ticket__c.Ticket_Grouping__c,
        new List<List<Ticket__c>> {tickets});

        fflib_ApexMocks userMocks = new fflib_ApexMocks(); 

        UserDAO.IUserDAO userDAOInstance;
        userDAOInstance = new MockDAOs.UserDAOMock(userMocks);  

        userMocks.startStubbing();
        userMocks.when(userDAOInstance.getRequesterForTicketDistro(testUser.Id))
                    .thenReturn(testUser);
        userMocks.stopStubbing();

        userMocks.startStubbing();
        userMocks.when(userDAOInstance.getContactCostCenterForTicketDistro(userIds))
                    .thenReturn(users);
        userMocks.stopStubbing();

        fflib_ApexMocks accountMocks = new fflib_ApexMocks(); 

        AccountDAO.IAccountDAO accountDAOInstance;
        accountDAOInstance = new MockDAOs.AccountDAOMock(accountMocks);  

        accountMocks.startStubbing();
        accountMocks.when(accountDAOInstance.getProducerAccountsForTicketDistro(producerAccountIds, producerAccountRecordTypeId))
                    .thenReturn(producerAccounts);
        accountMocks.stopStubbing();

        accountMocks.startStubbing();
        accountMocks.when(accountDAOInstance.getGroupAccountsForTicketDistro(groupAccountIds, groupAccountRecordTypeId))
                    .thenReturn(groupAccounts);
        accountMocks.stopStubbing();

        fflib_ApexMocks ticketEventMocks = new fflib_ApexMocks(); 

        TicketEventDAO.ITicketEventDAO ticketEventDAOInstance;
        ticketEventDAOInstance = new MockDAOs.TicketEventDAOMock(ticketEventMocks);  

        ticketEventMocks.startStubbing();
        ticketEventMocks.when(ticketEventDAOInstance.grabTicketEventObj(testEvent.Id))
                    .thenReturn(testEvent);
        ticketEventMocks.stopStubbing();

        ticketEventMocks.startStubbing();
        ticketEventMocks.when(ticketEventDAOInstance.updateTicketEvent(testEvent))
                    .thenReturn(testEvent);
        ticketEventMocks.stopStubbing();

        fflib_ApexMocks ticketGroupingMocks = new fflib_ApexMocks(); 

        TicketGroupingDAO.ITicketGroupingDAO ticketGroupingDAOInstance;
        ticketGroupingDAOInstance = new MockDAOs.TicketGroupingDAOMock(ticketGroupingMocks);  

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.grabTicketGroupings(testEvent.Id))
                    .thenReturn(ticketGroupingRelationship);
        ticketGroupingMocks.stopStubbing();

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.upsertTicketGroupings(ticketGroupings))
                    .thenReturn(ticketGroupings);
        ticketGroupingMocks.stopStubbing();

        ticketGroupingMocks.startStubbing();
        ticketGroupingMocks.when(ticketGroupingDAOInstance.deleteTicketGrouping(ticketGrouping))
                    .thenReturn(ticketGrouping);
        ticketGroupingMocks.stopStubbing();

        fflib_ApexMocks ticketMocks = new fflib_ApexMocks(); 

        TicketDAO.ITicketDAO ticketDAOInstance;
        ticketDAOInstance = new MockDAOs.TicketDAOMock(ticketMocks);  

        ticketMocks.startStubbing();
        ticketMocks.when(ticketDAOInstance.upsertTickets(tickets))
                    .thenReturn(tickets);
        ticketMocks.stopStubbing();

        ticketMocks.startStubbing();
        ticketMocks.when(ticketDAOInstance.deleteTickets(tickets))
                    .thenReturn(tickets);
        ticketMocks.stopStubbing();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testEvent);
        TicketDistributionController ticketDistributionController = new TicketDistributionController(stdController, 
                                                                                                        ticketEventDAOInstance, 
                                                                                                            ticketDAOInstance, 
                                                                                                                ticketGroupingDAOInstance,
                                                                                                                    accountDAOInstance,
                                                                                                                        userDAOInstance);
        ticketDistributionController.ticketEventDAOInstance = ticketEventDAOInstance;
        ticketDistributionController.ticketDAOInstance = ticketDAOInstance;
        ticketDistributionController.ticketGroupingDAOInstance = ticketGroupingDAOInstance;
        ticketDistributionController.accountDAOInstance = accountDAOInstance;
        ticketDistributionController.userDAOInstance = userDAOInstance;
        
        ticketDistributionController.renderTickets();
        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 14;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();
         
       // ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 14;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();
		
        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToClient__c = true;
        ticketDistributionController.assignTicket.Client__c = testGroupAccount.Id;
        ticketDistributionController.ticketGroupingId = 1;
        ticketDistributionController.assignTickets();
		ticketDistributionController.singleTicket.Requestor_contact__c = testUser1.Id;
        ticketDistributionController.changeTicketRequestor();
        //ticketEventDAOInstance.updateTicketEvent tEDAOIUp = new ticketEventDAOInstance.updateTicketEvent();
        ticketEventDAOInstance.updateTicketEvent(testEvent);
         
        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToClient__c = true;
        ticketDistributionController.assignTicket.Client__c = testGroupAccount.Id;
        ticketDistributionController.ticketGroupingId = 1;
        ticketDistributionController.assignTickets();
		ticketDistributionController.singleTicket.Requestor_contact__c = testUser2.Id;
        ticketDistributionController.changeTicketRequestor();
         
        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 142;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Business';
        ticketDistributionController.assignTicket.assignToProducer__c = true;
        ticketDistributionController.assignTicket.Producer_For_Event__c = testProducerAccount.Id;
        ticketDistributionController.ticketGroupingId = 2;
        ticketDistributionController.assignTickets();

        ticketDistributionController.saveTickets();
         //testUser1
        ticketDistributionController.cancel();

        ticketDistributionController.ticketEvent.incrementalNumberOfTickets__c = 2;
        ticketDistributionController.singleTicket.Ticket_Price__c = 111;
        ticketDistributionController.singleTicket.Requestor_contact__c = testUser.Id;
        ticketDistributionController.singleTicket.Ticket_Type__c = 'Box';

        ticketDistributionController.generateTickets();

        ticketDistributionController.assignTicket.Business_Use_of_Ticket__c = 'Personal';
        ticketDistributionController.assignTicket.assignToEmployee__c = true;
        ticketDistributionController.assignTicket.Contact__c = testContact.Id;
        ticketDistributionController.ticketGroupingId = 3;
        ticketDistributionController.ticketGroupingObjId = 3;
        ticketDistributionController.assignTickets();
        ticketDistributionController.deleteTickets();
		
        ticketDistributionController.saveTickets();

        System.assertEquals(ticketDistributionController.ticketGroupingWrapperList.size(), 1);

    }
   
}