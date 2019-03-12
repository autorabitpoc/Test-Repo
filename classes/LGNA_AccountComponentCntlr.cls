/**************************************************************************************
  Apex Class Name     : LGNA_AccountComponentCntlr 
  Version             : 1.0
  Function            : This is for Strategic Plan Details
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       08/30/2017                Original Version
*************************************************************************************/


public class LGNA_AccountComponentCntlr {
  public static String selectStr= 'Select';
  public static String exceptionStr= 'An exception occurred: ';
   
  /*************************************************************************************************************************************
    *  getsplanDetails
    *   @description:  Method is used to Update the Account Record
    *   @parameters : Account Id
    *   @return type : List<Strategic_Plan__c> 
    *******************************************************************************************************************************************/ 
    @AuraEnabled
    public static List<Strategic_Plan__c> getsplanDetails(Id accountId){
        List<Strategic_Plan__c> strategicPlanList = new List<Strategic_Plan__c>();
     
        try{
             system.debug('**** accountId--> ' + accountId);
             strategicPlanList = [SELECT Id,name,Strategic_Plan_Name_URL__c,Account_Name__c ,Account_name__r.name, 
                                  Account_Name__r.recordType.name,recordType.name, lastModifiedBy.name, lastModifiedDate, 
                                  CreatedBy.name, CreatedDate, Active__c, Effective_Date__c FROM Strategic_Plan__c
                                  WHERE Account_Name__c =:accountId and Active__c=true ORDER BY Effective_Date__c ASC Limit 1];
            
                     system.debug('* strategicPlanList--> ' + strategicPlanList.size());  
        return strategicPlanList;
        }catch(Exception e){
            system.debug('*** Exception ex --> ' + e);
        }
        return null;
    }
}