/**************************************************************************************
  Apex Class Name     : RateGroupDAO
  Version             : 1.0
  Function            : This is a DAO class for the Rate_Group__c Object
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/6/2016
*************************************************************************************/

public with sharing class RateGroupDAO implements IRateGroupDAO { 

  public interface IRateGroupDAO{
        List<Rate_Group__c> insertRateGroup(List<Rate_Group__c> rateGroupObj);
        List<Rate_Group__c> upsertRateGroup(List<Rate_Group__c> rateGroupObj);
        List<Rate_Group__c> grabRateGroups(Id rateId);
  }

  public List<Rate_Group__c> insertRateGroup(List<Rate_Group__c> rateGroupObj){
        insert rateGroupObj;
        return rateGroupObj;
  }

  public List<Rate_Group__c> upsertRateGroup(List<Rate_Group__c> rateGroupObj){
        upsert rateGroupObj;
        return rateGroupObj;
  }

  public List<Rate_Group__c> grabRateGroups(Id rateId){
        
        return [SELECT Miscellaneous__c, Service_Category__c, List_Service__c, Name, groupNumber__c, Group_1_Amount__c, Group_2_Amount__c, 
        Group_3_Amount__c, Group_4_Amount__c FROM Rate_Group__c WHERE Rate__c = :rateId];
  }

}