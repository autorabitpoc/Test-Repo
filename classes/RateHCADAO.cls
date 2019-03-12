/**************************************************************************************
  Apex Class Name     : RateHCADAO
  Version             : 1.0
  Function            : This is a DAO class for the Rate_HCA__c Object
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/20/2016
*************************************************************************************/
public with sharing class RateHCADAO implements IRateHCADAO {

    public interface IRateHCADAO{
   
        List<Rate_HCA__c> insertRateHCA(List<Rate_HCA__c> rateHCAObj);
        List<Rate_HCA__c> upsertRateHCA(List<Rate_HCA__c> rateHCAObj);
        List<Rate_HCA__c> grabRateHCAs(Id rateId);
        
    }

    public List<Rate_HCA__c> insertRateHCA(List<Rate_HCA__c> rateHCAObj){
        insert rateHCAObj;
        return rateHCAObj;
    }

    public List<Rate_HCA__c> upsertRateHCA(List<Rate_HCA__c> rateHCAObj){
        upsert rateHCAObj;
        return rateHCAObj;
    }

    public List<Rate_HCA__c> grabRateHCAs(Id rateId){
        
        return [SELECT Name, Additional_Provisions_HCA__c, BlueEdge_Direct_HCA__c, BlueEdge_FSAFirst__c, BlueEdge_HCA__c, BlueEdge_Limited_Purpose_HCA__c, 
        BlueEdge_Vitality_HCA__c, BlueEdge_Wellness_Rewards_HCA__c, Employee_HCA__c, Employee_Spouse_HCA__c, Employee_Child_HCA__c, Family_HCA__c, Employee_1_HCA__c, Employee_2_HCA__c,
        Employee_Only__c, Employee_Spouse_Only__c, Employee_Child_Only__c, Family_Only__c, Employee_1_Only__c, Employee_2_Only__c,
        Employee_Max__c, Employee_Spouse_Max__c, Employee_Child_Max__c, Family_Max__c, Employee_1_Max__c, Employee_2_Max__c, 
        HCA_Roll_Over_Amount__c, Other_Roll_over__c, New_Changed_Subscriber_HCA_Proration__c, Funds_will_be_removed_on_Cancelation__c, 
        HCA_Annual_Contribution_Frequency__c, Incentives_applied_to_HCA__c, Add_l_Spend_Account_s_paired_w_product__c, Order__c, Existing_HCA_HRA_needing_ending_credit__c,
        Date_prior_to_carrier_credit__c, HCA_Account_Yearly_Claim_Options__c FROM Rate_HCA__c WHERE Rate__c = :rateId ORDER BY Name];
    }

}