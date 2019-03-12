public class SGR_AccountsHold implements schedulable{

    public void execute(SchedulableContext sc){
        
        

    SGR_AccontsHoldBatch bcn = new SGR_AccontsHoldBatch() ;
 	  ID batchprocessid = Database.executeBatch(bcn);


    }
}