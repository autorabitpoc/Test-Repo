/*
* @Developer - Padma Bedampeta
* Apex Class Method runOnce to check Run Trigger only once
* Used : For Trigger
             GroupAndProducerAssociatoin Trigger
* SFDC-6461 - Auto populate Producer Information from Account to Opportunity only when New/Update Association after Opportunity has been created
* Version Date - 10/20/2017
*/

public class checkRecursive {
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}