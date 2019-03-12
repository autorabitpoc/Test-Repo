/**************************************************************************************
//Apex Class Name     : GEMS_CharacteristicValueTriggerHandler
//Version             : 1.0
//Modification Log    :
//Developer                   Date                   Description
//----------------------------------------------------------------------------------                 
//5/10/2018   Gokul Bharati   SFDC-4912 GEMS: BlueSTAR - Transfer Updated Characteristic Value Descriptions from GEMS to B* 
*************************************************************************************/ 
public class GEMS_CharValTriggerHandler{

public static Boolean recursiveCheck = true;

/**************************************************************************************
Method Name : AfterInsert
Description : Set the Char isUpdated flag to true after Creation of New Char Value for Renewal and Off Cycle Cases.
Parameters  : AfterInsert(Map<Id,sObject> TriggernewMap,Map<Id,sObject> TriggerOldMap)
ReturnType  : Void
**************************************************************************************/
    public static void AfterInsert(Map<Id,sObject> TriggernewMap,Map<Id,sObject> TriggerOldMap){
    
    List<GEMS_Characteristic_Value__c> charValues = (List<GEMS_Characteristic_Value__c>)TriggernewMap.values();
    set<Id> chaValueIds = new set<Id>();
    for(GEMS_Characteristic_Value__c charValue : charValues){
            chaValueIds.add(charValue.Characteristic__c);
    }
        
    List<GEMS_Characteristic__c> charsToUpdate = new list<GEMS_Characteristic__c>();        
    charsToUpdate = [SELECT Id, Case__c, IsUpdated__c FROM GEMS_Characteristic__c WHERE Id IN : chaValueIds AND IsUpdated__c = false];
    
    for(GEMS_Characteristic__c charToUpdate : charsToUpdate){
        charToUpdate.IsUpdated__c = true;
    }
    
    if(charsToUpdate != null)
       update charsToUpdate;
    
    }
    
/**************************************************************************************
Method Name : BeforeUpdate
Description : Set the Char isUpdated flag to true after updating Char Value Description for Renewal and Off Cycle Cases.
Parameters  : BeforeUpdate(List<sObject> TriggerNew,List<sObject> TriggerOld,Map<Id,sObject> TriggernewMap,Map<Id,sObject> TriggerOldMap){
ReturnType  : Void
**************************************************************************************/    
    public static void BeforeUpdate(List<sObject> TriggerNew,List<sObject> TriggerOld,Map<Id,sObject> TriggernewMap,Map<Id,sObject> TriggerOldMap){
        
    set<Id> chaValueIds = new set<Id>();
        
        for(GEMS_Characteristic_Value__c cha:(List<GEMS_Characteristic_Value__c>)TriggernewMap.values()){
        
            GEMS_Characteristic_Value__c oldRec = (GEMS_Characteristic_Value__c)TriggerOldMap.get(cha.Id);
            GEMS_Characteristic_Value__c newRec = (GEMS_Characteristic_Value__c)TriggernewMap.get(cha.Id);
            
            if(!String.isBlank(cha.Name) && oldRec.Name != newRec.Name && newRec.isNew__c == false && oldRec.IsUpdated__c == false){  
              cha.IsUpdated__c = true;
              chaValueIds.add(cha.Characteristic__c);
            }
        }
                        
        List<GEMS_Characteristic__c> charsToUpdate = new list<GEMS_Characteristic__c>();                      
        charsToUpdate = [SELECT Id, Case__c, IsUpdated__c FROM GEMS_Characteristic__c WHERE Id IN : chaValueIds AND IsUpdated__c = false AND isNew__c = false];       
        for(GEMS_Characteristic__c charToUpdate : charsToUpdate){
            charToUpdate.IsUpdated__c = true;
        }
        
        if(charsToUpdate != null)
           update charsToUpdate;
    
    }
}