global class SGR_Beng_Schedule_RequestBatch implements Schedulable{
    global void execute(SchedulableContext sc){
        SGR_Beng_RequestBatch btch = new SGR_Beng_RequestBatch ();
        database.executebatch(btch,1);
    }
   
}