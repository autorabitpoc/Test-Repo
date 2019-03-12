/**************************************************************************************
  Apex Class Name     : SGR_URE_InsertAgeRateDetailsBatchTest apex test for SGR_URE_InsertAgeRateDetailsBatch     
  Version             : 1.0
  Function            : This class is used to test the code coverage of the class SGR_URE_InsertAgeRateDetailsBatch
  Modification Log    :
* Developer:Akbar   Date: 12/13/2018         Description
* ----------------------------------------------------------------------------               
* INFOSYS                  12/13/2018                Original Version
*************************************************************************************/
@isTest
public class SGR_URE_AgeRateDetailIteratorTest {
	static testmethod void iterateAgeRateDetailsTestMethod(){
       List<SGR_Plan_Age_Rate_Detail__c> ageRateList = new List<SGR_Plan_Age_Rate_Detail__c>();
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='2' , Is_Tobacco__c = true) );
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='3' , Is_Tobacco__c = false) );
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='4' , Is_Tobacco__c = true) );
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='5' , Is_Tobacco__c = false) );
       Test.startTest();        
       SGR_URE_AgeRateDetailIterator  obj = new SGR_URE_AgeRateDetailIterator(ageRateList);
        obj.hasNext();
        obj.next();
       Test.stoptest();
       System.assertEquals(obj.source.size(),4);
    }
}