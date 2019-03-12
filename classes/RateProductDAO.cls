/**************************************************************************************
  Apex Class Name     : RateProductDAO
  Version             : 1.0
  Function            : This is a DAO class for the Rate_Product__c Object
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/3/2016
*************************************************************************************/

public with sharing class RateProductDAO implements IRateProductDAO { 

  public interface IRateProductDAO{
        List<Rate_Product__c> insertRateProducts(List<Rate_Product__c> rateProductObj);
        List<Rate_Product__c> updateRateProducts(List<Rate_Product__c> rateProductObj);
        List<Rate_Product__c> grabRateProducts(Id rateId);
  }

  public List<Rate_Product__c> insertRateProducts(List<Rate_Product__c> rateProductObj){
        insert rateProductObj;
        return rateProductObj;
  }

  public List<Rate_Product__c> updateRateProducts(List<Rate_Product__c> rateProductObj){
        update rateProductObj;
        return rateProductObj;
  }

  public List<Rate_Product__c> grabRateProducts(Id rateId){
      
        return [SELECT Employee_One_Dependent1__c, Employee_One_Dependent2__c, Employee_One_Dependent3__c, Employee_Two_or_More_Dependents1__c,
                Employee_Two_or_More_Dependents2__c, Employee_Two_or_More_Dependents3__c, Product__c, Employee_Only1__c, Employee_Spouse1__c, 
                Employee_Child_ren1__c, Family1__c, Other1__c, Employee_Only2__c, Employee_Spouse2__c, Employee_Child_ren2__c, Family2__c, Other2__c,
                Employee_Only3__c, Employee_Spouse3__c, Employee_Child_ren3__c, Family3__c, 
                Other3__c FROM Rate_Product__c WHERE Rate__c = :rateId];
  }

}