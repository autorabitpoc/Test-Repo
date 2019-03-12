/**************************************************************************************
  Apex Class Name     : RateDAO
  Version             : 1.0
  Function            : This is a DAO class for the Rate__c Object
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/3/2016
*************************************************************************************/

public with sharing class RateDAO implements IRateDAO { 

  public interface IRateDAO{
        Rate__c insertRate(Rate__c rateObj);
        Rate__c updateRate(Rate__c rateObj);
        Rate__c grabRateObj(Id rateId);
        Rate__c grabASORateObj(Id rateId);
        Rate__c grabHCARateObj(Id rateId);
  }

  public Rate__c insertRate(Rate__c rateObj){
        insert rateObj;
        return rateObj;
  }

  public Rate__c updateRate(Rate__c rateObj){
        update rateObj;
        return rateObj;
  }

  public Rate__c grabRateObj(Id rateId){
        
        return [SELECT Number_of_Years__c, HCSC_Division__c, Rate_Structure_Fully__c, Other_Rate__c FROM Rate__c WHERE Id = :rateId LIMIT 1];
  }

   public Rate__c grabASORateObj(Id rateId){
        
        return [SELECT Total_One_Time__c, Secure_Information__c, Total_Monthly__c, Total_Yearly__c, Total_Other__c, Additional_Comments_Term_Charge__c, Additional_Comments_Admin_Charge__c, Total_Group_1_Year_1__c, 
                Total_Group_2_Year_1__c, Total_Group_3_Year_1__c, Total_Group_4_Year_1__c, Group_Name_1__c, 
                Group_Name_2__c, Group_Name_3__c, Group_Name_4__c, HCSC_Division__c, No_Changes_Claim_Admin_Provider_Access__c, 
                Additional_provisions_Claim_Admin_Pro__c, Group_Number_s__c, of_ADP_savings__c, per_covered_employee_per_month__c, Group_Numbers_With_Multiple__c, 
                of_ADP_savings_2__c, per_covered_employee_per_month_2__c, BlueCard_Program_Network_access_fees__c,
                Group_Name_1_Term__c, Group_Name_2_Term__c, Group_Name_3_Term__c, Group_Name_4_Term__c, Total_Group_1_Term__c,
                Total_Group_2_Term__c, Total_Group_3_Term__c, Total_Group_4_Term__c FROM Rate__c WHERE Id = :rateId LIMIT 1];
  }

  public Rate__c grabHCARateObj(Id rateId){
        
        return [SELECT HCA_Account_Structure__c, HCA_Account_Structure_ASO__c, HCSC_Division__c, Applicable_Group_Number_s__c FROM Rate__c WHERE Id = :rateId LIMIT 1];
  }

}