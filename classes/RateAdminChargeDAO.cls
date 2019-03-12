/**************************************************************************************
  Apex Class Name     : RateAdminChargeDAO
  Version             : 1.0
  Function            : This is a DAO class for the Rate_Admin_Charge__c Object
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/6/2016
*************************************************************************************/

public with sharing class RateAdminChargeDAO implements IRateAdminChargeDAO { 

  public interface IRateAdminChargeDAO{
        List<Rate_Admin_Charge__c> insertRateAdminCharge(List<Rate_Admin_Charge__c> rateAdminChargeObj);
        List<Rate_Admin_Charge__c> upsertRateAdminCharge(List<Rate_Admin_Charge__c> rateAdminChargeObj);
        List<Rate_Admin_Charge__c> grabRateAdminCharges(Id rateId);
  }

  public List<Rate_Admin_Charge__c> insertRateAdminCharge(List<Rate_Admin_Charge__c> rateAdminChargeObj){
        insert rateAdminChargeObj;
        return rateAdminChargeObj;
  }

  public List<Rate_Admin_Charge__c> upsertRateAdminCharge(List<Rate_Admin_Charge__c> rateAdminChargeObj){
        upsert rateAdminChargeObj;
        return rateAdminChargeObj;
  }

  public List<Rate_Admin_Charge__c> grabRateAdminCharges(Id rateId){
     
        return [SELECT adminNumber__c, List_Service__c, Miscellaneous__c, Service_Charges__c, Name, Frequency__c, Other_Frequency__c,
                  Amount__c FROM Rate_Admin_Charge__c WHERE Rate__c = :rateId];
  }

}