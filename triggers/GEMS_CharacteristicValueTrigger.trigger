//************************************************************************************
// Name             : GEMS_CharacteristicValueTrigger.trgr
// Description      : 
// Created By       : Janakiram Jonnadula
// Created Date     :
// ************************Version Updates***********************************************
// 5/10/2018   Gokul Bharati   SFDC-4912 GEMS: BlueSTAR - Transfer Updated Characteristic Value Descriptions from GEMS to B* 
// **************************************************************************************
trigger GEMS_CharacteristicValueTrigger  on GEMS_Characteristic_Value__c (after insert,before update) {   
    
    String  test =  System.Label.GemsCharValTriggerLabel;
    if(test == 'N'){
     return ;
    }   
            
    if(trigger.isAfter && trigger.isInsert && !System.isFuture()){
      GEMS_CharValTriggerHandler.AfterInsert(Trigger.NewMap,Trigger.OldMap);     
    }    

    if(Trigger.isBefore && Trigger.isUpdate && !System.isFuture()){
      GEMS_CharValTriggerHandler.BeforeUpdate(Trigger.New,Trigger.Old,Trigger.NewMap,Trigger.OldMap); 
    }
    
}