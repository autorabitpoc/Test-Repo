trigger GEMS_Category_Trigger on GEMS_Category__c (after update,Before Update) {
    String test = Label.GEMSCatLabel;
    if( test == 'N'){
    return  ;
    }

  //SFDC-3641 : IsDescUpdate__c flag set to true on existing categories when description changes for a account structure case of type renewal or off cycle
  if(Trigger.isBefore && Trigger.isUpdate && !System.isFuture()){
       List<GEMS_Category__c> newCat = Trigger.new;
        for(GEMS_Category__c cat : newCat){
            GEMS_Category__c oldCat = Trigger.oldMap.get(cat.Id);
         
            if(cat.Category_Description__c !=oldCat.Category_Description__c  && cat.IsNew__c== false){
                                cat.IsDescUpdate__c= True;
             
            }
            
        }
        
    }
    if(trigger.isAfter && trigger.isUpdate && !System.isFuture()){    
        list<GEMS_Category__c> newCats = trigger.New;        
        list<GEMS_Category__c> cancelledCats = new list<GEMS_Category__c>();
        for(GEMS_Category__c newCat : newCats){
            if(!newCat.IsNew__c && newCat.IsCancelled__c){            
                cancelledCats.add(newCat);            
            }
            
        } 
        
        Date effDate;
        if(!cancelledCats.IsEmpty()){
        
            list<case> cases = [SELECT Id, GEMS_Case_Effective_Date__c FROM Case Where id = : cancelledCats[0].Case__c];
            
            if(!cases.IsEmpty())
                effDate = cases[0].GEMS_Case_Effective_Date__c;
            
            list<GEMS_BA_Category_Assignment__c> baAssigns = [SELECT Id FROM GEMS_BA_Category_Assignment__c WHERE Category__c in : cancelledCats];
            if(!baAssigns.IsEmpty())
                delete baAssigns;
            
            /*
            //Group Section
            list<GEMS_Category_Assignment__c> catAssigns = [SELECT Id, Group_Section__c FROM GEMS_Category_Assignment__c WHERE Category__c in : cancelledCats];
            set<id> gsIds = new set<id>();
            for(GEMS_Category_Assignment__c catAssign : catAssigns){
                gsIds.add(catAssign.Group_Section__c);
            }
            
            list<GEMS_Group_Section__c> groupSections = new list<GEMS_Group_Section__c>();
            if(!gsIds.IsEmpty()){
                groupSections = [SELECT Id, IsUpdated__c, IsCancelled__c, Section_Eff_Date__c, (SELECT Id FROM Category_Assignments__r) FROM GEMS_Group_Section__c WHERE Id IN : gsIds];
            }
            
            list<GEMS_Group_Section__c> gsToDelete = new list<GEMS_Group_Section__c>();
            list<GEMS_Group_Section__c> gsToUpdate = new list<GEMS_Group_Section__c>();
            
            for(GEMS_Group_Section__c groupSection : groupSections){
                if(groupSection.Category_Assignments__r != null && groupSection.Category_Assignments__r.size() > 1){
                    groupSection.IsUpdated__c = true;
                    groupSection.Section_Eff_Date__c = effDate;
                    gsToUpdate.add(groupSection);
                }
                else
                    gsToDelete.add(groupSection);
            }
            
            if(!catAssigns.IsEmpty())
                delete catAssigns;
            
            if(!gsToDelete.IsEmpty())
                delete gsToDelete;
                
            if(!gsToUpdate.IsEmpty())
                update gsToUpdate;*/  
                
            //Billing Profiles
            /*list<GEMS_BP_Category_Association__c> bpCatAssigns = [SELECT Id, Billing_Profile__c FROM GEMS_BP_Category_Association__c WHERE Category__c in : cancelledCats];
            set<id> bpIds = new set<id>();
            for(GEMS_BP_Category_Association__c bpCatAssign : bpCatAssigns){
                bpIds.add(bpCatAssign.Billing_Profile__c);
            }
            
            list<GEMS_Billing_Profile__c> billingProfiles = new list<GEMS_Billing_Profile__c>();
            if(!bpIds.IsEmpty()){
                billingProfiles = [SELECT Id, IsUpdated__c, Effective_Date__c, (SELECT Id FROM BA_BP_Associations__r) FROM GEMS_Billing_Profile__c WHERE Id IN : bpIds];
            }
            
            //list<GEMS_Billing_Profile__c> bpToDelete = new list<GEMS_Billing_Profile__c>();
            list<GEMS_Billing_Profile__c> bpToUpdate = new list<GEMS_Billing_Profile__c>();
            
            for(GEMS_Billing_Profile__c billingProfile : billingProfiles){
                //if(billingProfile.BA_BP_Associations__r != null && billingProfile.BA_BP_Associations__r.size() > 1){
                    billingProfile.IsUpdated__c = true;
                    billingProfile.Effective_Date__c = effDate;
                    bpToUpdate.add(billingProfile);
                //}
                //else
                    //bpToDelete.add(billingProfile);
            }  
            
            if(!bpCatAssigns.IsEmpty())
                delete bpCatAssigns;
            
            //if(!bpToDelete.IsEmpty())
                //delete bpToDelete;
                
            if(!bpToUpdate.IsEmpty())
                update bpToUpdate;*/  
           
        }
    }
   

}