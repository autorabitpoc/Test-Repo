public class SGR_Date_Trigger {

      public static void validate(List<SGR_Renewal_Date_Configuration__c> batchList,map<Id,SGR_Renewal_Date_Configuration__c> batchMap){
         
         
for(SGR_Renewal_Date_Configuration__c batch : batchList){

    List<SGR_Renewal_Date_Configuration__c> counting =[Select Id  from SGR_Renewal_Date_Configuration__c where Division__c=:batch.Division__c and Funding_Type__c=:batch.Funding_Type__c and Group__c=:batch.Group__c and Market_Segment__c=:batch.Market_Segment__c and Renewal_Type__c=:batch.Renewal_Type__c and Trigger_Type__c=:batch.Trigger_Type__c];

if(counting.size()!=0)

          Trigger.new[0].adderror('Duplicate record only ok');
}


}
      
}