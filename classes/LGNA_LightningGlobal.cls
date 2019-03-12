/**************************************************************************************
  Apex Class Name     : LGNA_LightningGlobal 
  Version             : 1.0
  Function            : This class is used as a global class for common methods. 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Dileep      09/26/2017                Original Version
*************************************************************************************/
public class LGNA_LightningGlobal {
    
    /*************************************************************************************************************************************
    *  getaccountDetails
    *   @description:  Method is used to get the Account Details based on Opportunity Id
    *   @parameters :  
    *   @return type : Account Object
    *******************************************************************************************************************************************/ 
    @AuraEnabled
    public static String getAccountIdFromOpptyId(String OpptyId){
        try{
            String AccountId =  [SELECT account.id from Opportunity WHERE Id=:OpptyId].account.Id;
            return AccountId;
        }catch(Exception e){
            system.debug('*** Exception ex --> ' + e);
        }
        return null;
    }
    
    /*************************************************************************************************************************************
    *  getaccountDetails
    *   @description:  Method is used to get the Case recordTypeId based on RecordType Name
    *   @parameters :  
    *   @return type : recordTypeId
    *******************************************************************************************************************************************/ 
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        try{
            Id recid = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
            return recid;            
        }catch (exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'LGNA_LightningGlobal', 'LGNA_LightningGlobal', 'getAccountIdFromOpptyId.getRecTypeId()', 'High');
        } return null;
    }  
    
    @AuraEnabled
    public static Id getOpportunityRecTypeId(String recordTypeLabel){
        try{
            Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
            return recid;            
        }catch (exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'LGNA_LightningGlobal', 'LGNA_LightningGlobal', 'getAccountIdFromOpptyId.getRecTypeId()', 'High');
        } return null;
    }  
    
     /*************************************************************************************************************************************
    *  getaccountDetails
    *   @description:  Method is used to get the Service Request recordTypeId based on RecordType Name
    *   @parameters :  
    *   @return type : recordTypeId
    *******************************************************************************************************************************************/ 
    @AuraEnabled
    public static Id getServiceReqRecTypeId(String recordTypeLabel){
        try{
            Id recid = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
            return recid;            
        }catch (exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'LGNA_LightningGlobal', 'LGNA_LightningGlobal', 'getAccountIdFromOpptyId.getRecTypeId()', 'High');
        } return null;
    }   

}