trigger GEMS_Group_Section_trigger on GEMS_Group_Section__c (Before Update) {

      //SFDC-3641 : IsDescUpdate__c flag set to true on existing group section when its description changes for an account structure case of type renewal or off cycle
      if(Trigger.isBefore && Trigger.isUpdate && !System.isFuture()){
       List<GEMS_Group_Section__c> newGS = Trigger.new;
        for(GEMS_Group_Section__c GS : newGS){
            GEMS_Group_Section__c oldGS = Trigger.oldMap.get(GS.Id);
         
            if(GS.Section_Description__c !=oldGS.Section_Description__c && GS.IsNew__c == false){
                
                    GS.IsDescUpdate__c= True;
             
            }
            
        }
        
    }
}