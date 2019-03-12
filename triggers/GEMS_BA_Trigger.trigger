/**************************************************************************************
  Apex Trigger Name     : GEMS_BA_Trigger
  Version               : 1.0
  Function              : This trigger class is on GEMS Benefit Agreement custom object. 
  Modification Log      :
* Developer                 Date            Description
* ----------------------------------------------------------------------------                 
*   Bharath					07/27/2017		SFDC-5102 Call the handler class to update corresponding Cases.
*************************************************************************************/
trigger GEMS_BA_Trigger on GEMS_Benefit_Agreement__c (after update,Before Update) {
     String test = System.Label.GEMSBaLabel;
     if(test == 'N'){
     return ;
     }
    
    //SFDC-3641 : IsDescUpdate__c flag updated when description changes for existing BAs when account structure case is of type renewal or off cycle
    if(Trigger.isBefore && Trigger.isUpdate && !System.isFuture()){
        List<GEMS_Benefit_Agreement__c> newBA = Trigger.new;
        for(GEMS_Benefit_Agreement__c BA : newBA){
            GEMS_Benefit_Agreement__c oldBA = Trigger.oldMap.get(BA.Id);
            
            if(BA.BA_Description__c !=oldBA.BA_Description__c && BA.IsNew__c == false){
                                BA.IsDescUpdate__c= True;
             
            }
            
        }
        
    }
    if(trigger.isAfter && trigger.isUpdate && !System.isFuture()){    
		//5102 - Method call to update case object. 
        GEMS_BATriggerHandler.updateCaseBAProduct(trigger.old, trigger.new);
        list<GEMS_Benefit_Agreement__c> newBAs = trigger.New;
        
        list<GEMS_Benefit_Agreement__c> cancelledBAs = new list<GEMS_Benefit_Agreement__c>();
        for(GEMS_Benefit_Agreement__c newBA : newBAs){
          if(!newBA.IsNew__c && newBA.IsCancelled__c){            
                cancelledBAs.add(newBA);            
            }
           
        } 
        
        Date effDate;
        if(!cancelledBAs.IsEmpty()){
        
            list<case> cases = [SELECT Id, GEMS_Case_Effective_Date__c FROM Case Where id = : cancelledBAs[0].AccountStructureCase__c];

            if(!cases.IsEmpty())
                effDate = cases[0].GEMS_Case_Effective_Date__c;
            
            list<GEMS_BA_Category_Assignment__c> catAssigns = [SELECT Id FROM GEMS_BA_Category_Assignment__c WHERE Benefit_Agreement__c in : cancelledBAs];
            if(!catAssigns.IsEmpty())
                delete catAssigns;
            
            /*            
            //Group Section
            list<GEMS_BA_Assignment__c> baAssigns = [SELECT Id, Group_Section__c FROM GEMS_BA_Assignment__c WHERE Benefit_Agreement__c in : cancelledBAs];
            set<id> gsIds = new set<id>();
            for(GEMS_BA_Assignment__c baAssign : baAssigns){
                gsIds.add(baAssign.Group_Section__c);
            }
                        
            list<GEMS_Group_Section__c> groupSections = new list<GEMS_Group_Section__c>();
            if(!gsIds.IsEmpty()){
                groupSections = [SELECT Id, IsUpdated__c, IsCancelled__c, Section_Eff_Date__c, (SELECT Id FROM GS_Assignments__r) FROM GEMS_Group_Section__c WHERE Id IN : gsIds];
            }
            
            list<GEMS_Group_Section__c> gsToDelete = new list<GEMS_Group_Section__c>();
            list<GEMS_Group_Section__c> gsToUpdate = new list<GEMS_Group_Section__c>();
            
            for(GEMS_Group_Section__c groupSection : groupSections){
                if(groupSection.GS_Assignments__r != null && groupSection.GS_Assignments__r.size() > 1){
                    groupSection.IsUpdated__c = true;
                    groupSection.Section_Eff_Date__c = effDate;
                    gsToUpdate.add(groupSection);
                }
                else
                    gsToDelete.add(groupSection);
            }
            
            if(!baAssigns.IsEmpty())
                delete baAssigns;
            
            if(!gsToDelete.IsEmpty())
                delete gsToDelete;
                
            if(!gsToUpdate.IsEmpty())
                update gsToUpdate;*/
            
            //Billing Profiles
            /*list<GEMS_BP_BA_Association__c> bpBaAssigns = [SELECT Id, Billing_Profile__c FROM GEMS_BP_BA_Association__c WHERE Benefit_Agreement__c in : cancelledBAs];
            set<id> bpIds = new set<id>();
            for(GEMS_BP_BA_Association__c bpBaAssign : bpBaAssigns){
                bpIds.add(bpBaAssign.Billing_Profile__c);
            }
            
            list<GEMS_Billing_Profile__c> billingProfiles = new list<GEMS_Billing_Profile__c>();
            if(!bpIds.IsEmpty()){
                billingProfiles = [SELECT Id, IsUpdated__c, Effective_Date__c, (SELECT Id FROM BP_Associations__r) FROM GEMS_Billing_Profile__c WHERE Id IN : bpIds];
            }
            
            //list<GEMS_Billing_Profile__c> bpToDelete = new list<GEMS_Billing_Profile__c>();
            list<GEMS_Billing_Profile__c> bpToUpdate = new list<GEMS_Billing_Profile__c>();
            
            for(GEMS_Billing_Profile__c billingProfile : billingProfiles){
                //if(billingProfile.BP_Associations__r != null && billingProfile.BP_Associations__r.size() > 1){
                    billingProfile.IsUpdated__c = true;
                    billingProfile.Effective_Date__c = effDate;
                    bpToUpdate.add(billingProfile);
                //}
                //else
                    //bpToDelete.add(billingProfile);
            }  
            
            if(!bpBaAssigns.IsEmpty())
                delete bpBaAssigns;
            
            //if(!bpToDelete.IsEmpty())
                //delete bpToDelete;
                
            if(!bpToUpdate.IsEmpty())
                update bpToUpdate;*/
           
        }
    }

}