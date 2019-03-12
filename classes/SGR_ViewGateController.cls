/**************************************************************************************
  Apex Class Name     : SGR_ViewGateController     
  Version             : 1.0
  Function            : Controller class to get opportunities list and get total gate count
  Modification Log    :
* Developer: Shankar                 Date: 03/10/2018                   Description
* ----------------------------------------------------------------------------               
* Shankar                  03/10/2018                Original Version
  Akhil                    10/04/2018                2.0 Version
*************************************************************************************/
public class SGR_ViewGateController {
    @AuraEnabled
    public static List<Opportunity> getRelatedOpportunities(Id gateId, Integer maxRows, String sortField, String sortOrder) {
        Integer rowLimit = Integer.valueOf(maxRows);
        List<Opportunity> oppsList = new List<Opportunity>();
        
        try {
            String oppsListQuery = 'SELECT Name, Account.Name,SGR_Account_Number__c, Account.External_Id__c,Gate__c, RecordType.Name, Renewal_Date__c, Rating_Status__c, Subscribers_Count__c, Health_Count__c, Dental_Count__c, Assigned_UW__r.Name,recordtypeid FROM Opportunity where Rating_Status__c=\'Rated\' AND Gate__c =:gateId ORDER BY Renewal_Date__c ASC LIMIT ' + maxRows;           	
            
        	oppsList = Database.query(oppsListQuery); 
             
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return oppsList;
    }
    
    @AuraEnabled
    public static Integer getRelOppsCount(Id gateId) {
        try {
            AggregateResult[] result = [SELECT Count(Id) FROM Opportunity where Rating_Status__c ='Rated' AND Gate__c = :gateId];
            Integer count = 0;
                count = (Integer) result[0].get('expr0');
                List<Actuary_Gate__c> gate = [Select Id, OppCount__c from Actuary_Gate__c where Id=:gateId];
                if (!gate.isEmpty()) {
                    gate[0].OppCount__c = count;
                }
                return count;          
        } catch(Exception e) {
            throw new AuraHandledException('An error has occured while getting opportunities count. Please contact System Administrator');
        } 
    }
    

    @AuraEnabled
    public static List<Opportunity> getSelectedOpty(List<Id> ids){
        return [select id,Name,Rating_Status__c,Gate__r.Status__c,SGR_Workflow_Status__c,Account.Name,
                Account.Status__c,Account.Renewal_Date__c,Account.hold_end_date__c,
                Account.renewal_duration_is_infinite__c,Workflow_System_Status__c,recordtypeId,Renewal_Date__c,Assigned_UW__c from Opportunity
                where id=:ids];
    }
    
      @AuraEnabled
    public static Boolean getGateStatus(Id gateId){
        
        Actuary_Gate__c gate1=new Actuary_Gate__c();
        gate1=[select Status__c from Actuary_Gate__c where id=:gateId];
        if(gate1.Status__c=='Up')
                {
                    return false;
                }
                else
            	{
                return true;
            	}
    }
    
     @AuraEnabled
    public static boolean gateStatus(Id gateId){
        Actuary_Gate__c gate1=new Actuary_Gate__c();
        gate1=[select Status__c from Actuary_Gate__c where id=:gateId];
                if(gate1.Status__c=='Up')
                {
                    gate1.Status__c='Down';
                    update gate1;
                    return true;
                }
        	return false;
        
    }
    
    
    @AuraEnabled 
    Public static List<Opportunity> processSelectedOptys(List<Opportunity> selOptyRecords){
        list<Opportunity> optyListToUpdate = new list<Opportunity>();
        try{
        if(!selOptyRecords.isEmpty()){
            for(Opportunity  opp : selOptyRecords){
                opp.Rating_Status__c='Actuarial-Released';
                opp.SGR_Workflow_Activity__c = null;
                opp.Workflow_System_Status__c='Gate Processing Completed';
                optyListToUpdate.add(opp);
            }
        }
            
            update optyListToUpdate;
            SGR_ReleaseValidations.initiateValidation(optyListToUpdate);
            return optyListToUpdate;
        }
        catch(Exception e){
            return null;
        }
    } 
   
    
    @AuraEnabled
public static Boolean liftGate(Id selOptyRecords) {
    
    List<Opportunity> optyListToUpdate= new List<Opportunity>();
    List<Opportunity> optyListToUpdate1= new List<Opportunity>();
    optyListToUpdate = [select Id,status__c,HCSC_Division__c,Gate__c,Assigned_UW__c,Account.Renewal_Date__c,Account.hold_end_date__c,Account.renewal_duration_is_infinite__c,Account_Market_Segment__c,Rating_Status__c,Funding_Type__c,Renewal_Date__c,SGR_Workflow_Status__c,RecordType.Name,RecordTypeId,Workflow_System_Status__c from opportunity where Gate__c = :selOptyRecords AND Rating_Status__c='Rated'];

    set<id> sid = new set<id>();
    List<Actuary_Gate__c> gate1= new List<Actuary_Gate__c>();
     gate1=[select Id,status__c,Division__c,Effective_Date__c,Funding_Type__c,Market_Segment__c from Actuary_Gate__c where Id =:selOptyRecords];
    
      if(!optyListToUpdate.isEmpty()){
            for(Opportunity  opp : optyListToUpdate){
                
                if(opp.RecordType.Name=='SGR Production Opportunity' || opp.RecordType.Name=='SGR Analytical Opportunity'){
        
                    opp.Rating_Status__c='Actuarial-Released';
                    opp.SGR_Workflow_Activity__c = null;
                    opp.Workflow_System_Status__c='Gate Processing Completed';
      
                    sid.add(opp.Gate__c); 
            	}
                optyListToUpdate1.add(opp); 
             }
          
         
      }
        try{
             if(gate1.size()>0){
             if(gate1[0].Status__c =='Down'){
                gate1[0].Status__c ='Up';
          }  
          }
            update gate1;
            update optyListToUpdate1;
            SGR_ReleaseValidations.initiateValidation(optyListToUpdate1);
            return false;
        }
        catch(Exception e){
            return true;
        }

}
     /************Saurav End ************/
}