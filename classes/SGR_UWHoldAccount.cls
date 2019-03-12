/**************************************************************************************
  Apex Schedule Class    : SGR_UWHoldAccount
  Version               : 1.0
  Function              : This class is clearing the value of account hold end date and hold reason if hold end date equals current date.(SFDC-15999)
  Modification Log      :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*   saurav Gupta       26/12/2018                Original Version
*/
public class SGR_UWHoldAccount implements schedulable{
    public void execute(SchedulableContext SC) 
    {
        try{
            
        List<Account>  accLst=new List<Account>();
		List<Account> accountList= [select Id,hold_end_date__c,SGR_Hold_Reason__c from Account where hold_end_date__c <=:SYSTEM.TODAY() AND Market_Segment__c='SG' AND Status__c='Active'];
        if(accountList.size()>0 && accountList.size()!=NULL)
        {
           for(Account acc:accountList)
           {
               	   acc.hold_end_date__c=Null;
               	   acc.SGR_Hold_Reason__c='';
                   accLst.add(acc);

           }
            update accLst;
		}
    }
    
    catch(Exception e)
    {
        System.debug('Error'+e.getStackTraceString());
    }
        
    }
}