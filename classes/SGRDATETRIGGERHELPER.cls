public class SGRDATETRIGGERHELPER {
    
     public static void validate(List<SGR_Renewal_Date_Configuration__c> batchList,map<Id,SGR_Renewal_Date_Configuration__c> batchMap){
         
          Map<String,String> divisionMap = new Map<String,String>();
         
for(SGR_Renewal_Date_Configuration__c batch : batchList){

    List<SGR_Renewal_Date_Configuration__c> counting =[Select Id  from SGR_Renewal_Date_Configuration__c where Division__c=:batch.Division__c and Funding_Type__c=:batch.Funding_Type__c];

if(counting.size()!=0)

          Trigger.new[0].adderror('Duplicate record');
}


}
}