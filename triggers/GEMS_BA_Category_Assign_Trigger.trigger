trigger GEMS_BA_Category_Assign_Trigger on GEMS_BA_Category_Assignment__c (after delete) {
    
    if(System.Label.GEMSBaCatLabel ==  'N')    
        return;
    
    if(trigger.isAfter && trigger.isDelete && !System.isFuture()){
      
        list<GEMS_BA_Category_Assignment__c> baCatAssigns = Trigger.Old;
        set<id> baIds = new set<id>();
        set<id> catIds = new set<id>();
        set<string> bacats = new set<string>();
        map<id, set<id>> baCatSet = new map<id, set<id>>();
        
        Date effDate;
        
        list<case> cases = [SELECT Id, GEMS_Case_Effective_Date__c FROM Case Where id = : baCatAssigns[0].Case__c];
            
        if(!cases.IsEmpty())
            effDate = cases[0].GEMS_Case_Effective_Date__c;
      
        system.debug('baCatAssigns : ' + baCatAssigns);
        
        if(!baCatAssigns.isEmpty()){
            for(GEMS_BA_Category_Assignment__c baCatAssign : baCatAssigns){
                baIds.add(baCatAssign.Benefit_Agreement__c);
                catIds.add(baCatAssign.Category__c);
                bacats.add(baCatAssign.Benefit_Agreement__c + '-' + baCatAssign.Category__c);
                if(baCatSet.containsKey(baCatAssign.Benefit_Agreement__c)){
                   set<id> tempCatSet = baCatSet.get(baCatAssign.Benefit_Agreement__c);
                   tempCatSet.add(baCatAssign.Category__c);
                   baCatSet.put(baCatAssign.Benefit_Agreement__c, tempCatSet);
                }
                else
                {
                    set<id> tempCatSet = new set<id>();
                    tempCatSet.add(baCatAssign.Category__c);
                    baCatSet.put(baCatAssign.Benefit_Agreement__c, tempCatSet);
                }
            }
            
            list<GEMS_BA_Assignment__c> baGSAssigns = [SELECT Id, Benefit_Agreement__c, Group_Section__c, Group_Section__r.Id
                                                            FROM GEMS_BA_Assignment__c
                                                                WHERE Benefit_Agreement__c IN : baIds];
            
            list<GEMS_Category_Assignment__c> catGSAssigns = [SELECT Id, Category__c, Group_Section__c, Group_Section__r.Id
                                                            FROM GEMS_Category_Assignment__c
                                                                WHERE Category__c IN : catIds];
            
            set<id> gsIds = new set<id>();
            
            for(GEMS_BA_Assignment__c baGSAssign : baGSAssigns)
                gsIds.add(baGSAssign.Group_Section__c);
            
            for(GEMS_Category_Assignment__c catGSAssign : catGSAssigns)
                gsIds.add(catGSAssign.Group_Section__c);
            
            list<GEMS_Group_Section__c> groupSections = new list<GEMS_Group_Section__c>();
            if(!gsIds.IsEmpty()){
                groupSections = [SELECT Id, IsUpdated__c, Section_Eff_Date__c, 
                                        (SELECT Id, Benefit_Agreement__c, Benefit_Agreement__r.IsCancelled__c FROM GS_Assignments__r),
                                        (SELECT Id, Category__c, Category__r.IsCancelled__c FROM Category_Assignments__r) 
                                            FROM GEMS_Group_Section__c WHERE Id IN : gsIds];
            }
            
            set<GEMS_BA_Assignment__c> baGSAssignsToDeleteSet = new set<GEMS_BA_Assignment__c>();
            set<GEMS_Category_Assignment__c> catGSAssignsToDeleteSet = new set<GEMS_Category_Assignment__c>();
            
            list<GEMS_Group_Section__c> groupSectionsToUpdate = new list<GEMS_Group_Section__c>();
            list<GEMS_Group_Section__c> groupSectionsToDelete = new list<GEMS_Group_Section__c>();
            
            for(GEMS_Group_Section__c gs : groupSections){                
                boolean hasNoBAs = true;
                boolean hasNoCats = true;
                set<id> gsBAs = new set<id>();
                set<id> gsCats = new set<id>();
                
                if(gs.GS_Assignments__r != null){
                    for(GEMS_BA_Assignment__c baGS : gs.GS_Assignments__r){
                        gsBAs.add(baGS.Benefit_Agreement__c);
                        if(baIds.contains(baGS.Benefit_Agreement__c))
                            hasNoBAs = false;
                    }
                }
                else
                    continue;

                if(gs.Category_Assignments__r != null){
                    for(GEMS_Category_Assignment__c baGS : gs.Category_Assignments__r){
                        gsCats.add(baGS.Category__c);
                        if(catIds.contains(baGS.Category__c))
                            hasNoCats = false;
                    }
                }
                else
                    continue;
                
                if(hasNoBAs) continue;
                if(hasNoCats) continue;
                
                system.debug('bpBAs : ' + gsBAs);
                system.debug('baIds : ' + baIds);
                
                boolean hasAllBAs = false;
                boolean hasAllCats = false;
                
                if(baIds.containsAll(gsBAs))
                    hasAllBAs = true;
                
                system.debug('bpCats : ' + gsCats);
                system.debug('catIds : ' + catIds);
                
                if(catIds.containsAll(gsCats))
                    hasAllCats = true;
                
                boolean delGS = false;
                
                if(hasAllBAs){         
                    if(hasAllCats){
                        baGSAssignsToDeleteSet.addAll(gs.GS_Assignments__r);                        
                        catGSAssignsToDeleteSet.addAll(gs.Category_Assignments__r);
                        delGS = true;
                    }
                    else{
                        for(GEMS_Category_Assignment__c catGS : gs.Category_Assignments__r){
                            if(catIds.contains(catGS.Category__c))
                                catGSAssignsToDeleteSet.add(catGS);
                        }                                               
                    }
                }
                else{
                    if(hasAllCats){                              
                        for(GEMS_BA_Assignment__c baGS : gs.GS_Assignments__r){                            
                            if(baIds.contains(baGS.Benefit_Agreement__c))
                                baGSAssignsToDeleteSet.add(baGS); 
                        }
                    }
                }
                
                if(!delGS){
                    gs.IsUpdated__c = true;
                    // gs.Section_Eff_Date__c = effDate;
                    groupSectionsToUpdate.add(gs);
                }
                else
                    groupSectionsToDelete.add(gs);
            }
            
            list<GEMS_BA_Assignment__c> baGSAssignsToDelete = new list<GEMS_BA_Assignment__c>(baGSAssignsToDeleteSet);
            list<GEMS_Category_Assignment__c> catGSAssignsToDelete = new list<GEMS_Category_Assignment__c>(catGSAssignsToDeleteSet);            
            
            if(!baGSAssignsToDelete.IsEmpty())
                delete baGSAssignsToDelete;
                
            if(!catGSAssignsToDelete.IsEmpty())
                delete catGSAssignsToDelete;
            
            if(!groupSectionsToUpdate.isEmpty())
                update groupSectionsToUpdate;
            /* Commenting out as per new change during UAT. GS should not be deleted during BA cancellation
             * even if no other assignments exist
            if(!groupSectionsToDelete.isEmpty())
                delete groupSectionsToDelete;
            */
            //Billing Profiles-------------------------------------------------------------------------------------------------------
                            
            list<GEMS_BP_BA_Association__c> baBPAssigns = [SELECT Id, Benefit_Agreement__c, Billing_Profile__c, Billing_Profile__r.Id
                                                            FROM GEMS_BP_BA_Association__c
                                                                WHERE Benefit_Agreement__c IN : baIds];
            
            list<GEMS_BP_Category_Association__c> catBPAssigns = [SELECT Id, Category__c, Billing_Profile__c, Billing_Profile__r.Id
                                                            FROM GEMS_BP_Category_Association__c
                                                                WHERE Category__c IN : catIds];
                        
            set<id> bpIds = new set<id>();
            
            for(GEMS_BP_BA_Association__c baBPAssign : baBPAssigns)
                bpIds.add(baBPAssign.Billing_Profile__c);
            
            for(GEMS_BP_Category_Association__c catBPAssign : catBPAssigns)
                bpIds.add(catBPAssign.Billing_Profile__c);
            
            list<GEMS_Billing_Profile__c> billingProfiles = new list<GEMS_Billing_Profile__c>();
            if(!bpIds.IsEmpty()){
                billingProfiles = [SELECT Id, IsUpdated__c, Effective_Date__c, 
                                        (SELECT Id, Benefit_Agreement__c, Benefit_Agreement__r.IsNew__c, Benefit_Agreement__r.IsCancelled__c FROM BP_Associations__r),
                                        (SELECT Id, Category__c, Category__r.IsNew__c, Category__r.IsCancelled__c FROM BA_BP_Associations__r) 
                                            FROM GEMS_Billing_Profile__c WHERE Id IN : bpIds];
            }
            
            set<GEMS_BP_BA_Association__c> baBPAssignsToDeleteSet = new set<GEMS_BP_BA_Association__c>();
            set<GEMS_BP_Category_Association__c> catBPAssignsToDeleteSet = new set<GEMS_BP_Category_Association__c>();
            
            list<GEMS_Billing_Profile__c> billingProfilesToUpdate = new list<GEMS_Billing_Profile__c>();
            
            for(GEMS_Billing_Profile__c bp : billingProfiles){                
                boolean hasNoBAs = true;
                boolean hasNoCats = true;
                set<id> bpBAs = new set<id>();
                set<id> bpCats = new set<id>();
                
                if(bp.BP_Associations__r != null){
                    for(GEMS_BP_BA_Association__c baBP : bp.BP_Associations__r){
                        bpBAs.add(baBP.Benefit_Agreement__c);
                        if(baIds.contains(baBP.Benefit_Agreement__c))
                            hasNoBAs = false;
                    }
                }
                else
                    continue;

                if(bp.BA_BP_Associations__r != null){
                    for(GEMS_BP_Category_Association__c baBP : bp.BA_BP_Associations__r){
                        bpCats.add(baBP.Category__c);
                        if(catIds.contains(baBP.Category__c))
                            hasNoCats = false;
                    }
                }
                else
                    continue;
                
                if(hasNoBAs) continue;
                if(hasNoCats) continue;
                
                system.debug('bpBAs : ' + bpBAs);
                system.debug('baIds : ' + baIds);
                
                boolean hasAllBAs = false;
                boolean hasAllCats = false;
                
                if(baIds.containsAll(bpBAs))
                    hasAllBAs = true;
                
                system.debug('bpCats : ' + bpCats);
                system.debug('catIds : ' + catIds);
                
                if(catIds.containsAll(bpCats))
                    hasAllCats = true;
                
                if(hasAllBAs){         
                    if(hasAllCats){
                        //baBPAssignsToDeleteSet.addAll(bp.BP_Associations__r);       
                        for(GEMS_BP_BA_Association__c baBP : bp.BP_Associations__r){                            
                            if(baBP.Benefit_Agreement__r.IsNew__c)
                                baBPAssignsToDeleteSet.add(baBP); 
                        }
                        //catBPAssignsToDeleteSet.addAll(bp.BA_BP_Associations__r);
                        for(GEMS_BP_Category_Association__c catBP : bp.BA_BP_Associations__r){
                            if(catBP.Category__r.IsNew__c)
                                catBPAssignsToDeleteSet.add(catBP);
                        }
                    }
                    else{
                        for(GEMS_BP_Category_Association__c catBP : bp.BA_BP_Associations__r){
                            if(catIds.contains(catBP.Category__c) && catBP.Category__r.IsNew__c)
                                catBPAssignsToDeleteSet.add(catBP);
                        }                                               
                    }
                }
                else{
                    if(hasAllCats){                              
                        for(GEMS_BP_BA_Association__c baBP : bp.BP_Associations__r){                            
                            if(baIds.contains(baBP.Benefit_Agreement__c) && baBP.Benefit_Agreement__r.IsNew__c)
                                baBPAssignsToDeleteSet.add(baBP); 
                        }
                    }
                }
                
               /*if(!bp.IsUpdated__c){
                    bp.IsUpdated__c = true;
                    bp.Effective_Date__c = effDate;
                    billingProfilesToUpdate.add(bp);
                }*/
            }
            
            list<GEMS_BP_BA_Association__c> baBPAssignsToDelete = new list<GEMS_BP_BA_Association__c>(baBPAssignsToDeleteSet);
            list<GEMS_BP_Category_Association__c> catBPAssignsToDelete = new list<GEMS_BP_Category_Association__c>(catBPAssignsToDeleteSet);            
            
            if(baBPAssignsToDelete != null && !baBPAssignsToDelete.IsEmpty())
                delete baBPAssignsToDelete;
                
            if(catBPAssignsToDelete != null && !catBPAssignsToDelete.IsEmpty())
                delete catBPAssignsToDelete;
            
            //if(!billingProfilesToUpdate.isEmpty())
                //update billingProfilesToUpdate;
        }
    }

}