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
public class SGR_URE_InsertAgeRateDetailsBatchTest {
    
    static testmethod void insertAgeRateDetailsTestMethod(){
       List<SGR_Plan_Age_Rate_Detail__c> ageRateList = new List<SGR_Plan_Age_Rate_Detail__c>();
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='2' , Is_Tobacco__c = true) );
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='3' , Is_Tobacco__c = false) );
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='4' , Is_Tobacco__c = true) );
       ageRateList.add( new SGR_Plan_Age_Rate_Detail__c( Area_Number__c='5' , Is_Tobacco__c = false) );
       Test.startTest();        
       SGR_URE_InsertAgeRateDetailsBatch  obj = new SGR_URE_InsertAgeRateDetailsBatch(ageRateList);
       DataBase.executeBatch(obj);
       Test.stoptest();
       List<SGR_Plan_Age_Rate_Detail__c> arList = new List<SGR_Plan_Age_Rate_Detail__c>();
       arList =[SELECT id from SGR_Plan_Age_Rate_Detail__c];
       System.debug('size'+arList.size());
       //System.assertEquals(arList.size(),4);
    }

}