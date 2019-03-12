global class BatchAddressCacheSchedule implements Schedulable {     
    
    public BatchAddressCacheSchedule(){}
    
    global void execute(SchedulableContext sc) {    
        Database.executeBatch(new BatchAddressCache('IL', 2));
    }
}