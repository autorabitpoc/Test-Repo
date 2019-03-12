public class SGR_Trigger_Settings_Utility {
    
    //Returns a Map of the Active SGR_Trigger_Settings Custom Setting Methods matching the name passed into the function
    public static Map<String,SGR_Trigger_Settings__c> activeSGRTriggerSettings(String theTriggerName){
        //Custom Setting to control Trigger Methods for activation
        List<SGR_Trigger_Settings__c> listTriggerControls = SGR_Trigger_Settings__c.getall().values();
        Map<String,SGR_Trigger_Settings__c> mapActiveTriggerControls = new Map<String,SGR_Trigger_Settings__c>();
        for(Integer i = (listTriggerControls.size() - 1) ; i >= 0; i-- ){
            if(listTriggerControls[i].Trigger_Name__c == theTriggerName){
                if(listTriggerControls[i].Trigger_Is_Active__c == true){
                    mapActiveTriggerControls.put(listTriggerControls[i].Trigger_SubMethod__c, listTriggerControls[i]);                
                }
            }
        }        
        return mapActiveTriggerControls;        
    }
    
    //Returns a Map of the All SGR_Trigger_Settings Custom Setting Methods matching the name passed into the function
    public static Map<String,SGR_Trigger_Settings__c> allSGRTriggerSettings(String theTriggerName){
        //Custom Setting to control Trigger Methods for activation
        List<SGR_Trigger_Settings__c> listTriggerControls = SGR_Trigger_Settings__c.getall().values();
        Map<String,SGR_Trigger_Settings__c> mapAllTriggerControls = new Map<String,SGR_Trigger_Settings__c>();
        for(Integer i = (listTriggerControls.size() - 1) ; i >= 0; i-- ){
            if(listTriggerControls[i].Trigger_Name__c == theTriggerName){                
                mapAllTriggerControls.put(listTriggerControls[i].Trigger_SubMethod__c, listTriggerControls[i]);                                
            }
        }        
        return mapAllTriggerControls;        
    }
    
}