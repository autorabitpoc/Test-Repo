/**************************************************************************************
  Apex Class Name     : CustomMetadataTypeDAO
  Version             : 1.0
  Function            : This is a DAO for Custom Metadata Types
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------
* Sana Fatima/Slalom        6/3/2016
*************************************************************************************/
public class CustomMetadataTypeDAO implements ICustomMetadataTypeDAO{
    
    public interface ICustomMetadataTypeDAO{
        List<CP_Completion_Rate_Fields__mdt> getClientProfileCompletionRateFields();
        SObject getCustomMetadaTypeDynamically(String soql);
        Callout_Configuration__mdt getCustomMetadaTypeByName(String name);
        List<Complexity_Score_Fields__mdt> getComplexityScoreFields();
        SharePoint_Configuration__mdt getSharePointConfigurationByName(String name);
    }

    public List<CP_Completion_Rate_Fields__mdt> getClientProfileCompletionRateFields() {
        return [SELECT Field_Name__c, PointValue__c FROM CP_Completion_Rate_Fields__mdt];
    }

    public SObject getCustomMetadaTypeDynamically(String soql){
        return Database.query(soql);
    }

    public Callout_Configuration__mdt getCustomMetadaTypeByName(String name){
        return [SELECT Endpoint_URL__c, Username__c, Password__c, Scheduled_Apex_Class__c, SSL_Certificate__c FROM Callout_Configuration__mdt WHERE DeveloperName =:name LIMIT 1];
    }

    public List<Complexity_Score_Fields__mdt> getComplexityScoreFields() {
        return [SELECT Field_API_Name__c, Score__c, ValueMax__c, ValueMin__c, Value__c FROM Complexity_Score_Fields__mdt];
    }   

    public SharePoint_Configuration__mdt getSharePointConfigurationByName(String name) {
        Map<String, Schema.SobjectField> sharePointConfigFieldMap = 
                            SharePoint_Configuration__mdt.getSObjectType().getDescribe().fields.getMap();
        String soql;   
        Set<String> sharePointConfigFieldList = new Set<String>();
        if(!sharePointConfigFieldMap.isEmpty()){
            soql = 'SELECT ';

            for (String field : sharePointConfigFieldMap.keySet()) {
                soql += field + ',';
                sharePointConfigFieldList.add(field);
            }
            soql = soql.removeEnd(',');
            soql += ' FROM SharePoint_Configuration__mdt WHERE DeveloperName =:name LIMIT 1';
        }
        System.debug('SOQL: ' + soql);
        return Database.query(soql);

    }
}