/**************************************************************************************
  Apex Class Name     : RateTermDAO
  Version             : 1.0
  Function            : This is a DAO class for the Rate_Term__c Object
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             8/31/2016
*************************************************************************************/

public with sharing class RateTermDAO implements IRateTermDAO {

	public interface IRateTermDAO{
		List<Rate_Term__c> insertRateTerm(List<Rate_Term__c> rateTermObj);
        List<Rate_Term__c> upsertRateTerm(List<Rate_Term__c> rateTermObj);
        List<Rate_Term__c> grabRateTerms(Id rateId);
	}

	public List<Rate_Term__c> insertRateTerm(List<Rate_Term__c> rateTermObj){
        insert rateTermObj;
        return rateTermObj;
  	}

  	public List<Rate_Term__c> upsertRateTerm(List<Rate_Term__c> rateTermObj){
        upsert rateTermObj;
        return rateTermObj;
  	}

 	public List<Rate_Term__c> grabRateTerms(Id rateId){
        	return [SELECT termNumber__c, Miscellaneous__c, Name, Group_1_Amount__c, Group_2_Amount__c, Group_3_Amount__c, Group_4_Amount__c 
        	FROM Rate_Term__c WHERE Rate__c = :rateId];
  	}
}