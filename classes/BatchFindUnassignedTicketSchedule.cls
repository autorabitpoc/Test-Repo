global class BatchFindUnassignedTicketSchedule implements Schedulable{
  global void execute(SchedulableContext sct){
      BatchFindUnassignedTicket b = new BatchFindUnassignedTicket();
        Database.executeBatch( b );
    }
}