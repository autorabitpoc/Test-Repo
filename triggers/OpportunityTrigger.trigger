trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update) {
    
   
    if (Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.OpportunityTriggerField)) ) {
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Id sgrAnalytOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
        Opportunity opp= new Opportunity();
        if(trigger.new !=NULL){
         opp = trigger.new[0];
       
        }
       if(opp.RecordTypeid != sgrProdOpp && opp.RecordTypeid != sgrAnalytOpp)
        {
        try {
            if ( trigger.isBefore ) {
               
                OpportunityTriggerHelper.populateForecastSegment(trigger.new);
                if ( trigger.isInsert) {
                    
                    OpportunityTriggerHelper.updateLastModifiedDate(trigger.new);
                    OpportunityTriggerHelper.selectDefaultPlaybook( trigger.new );
                    //Method to populate fields on new opportunity creation with related account field values
                    OpportunityTriggerHelper.PopulateFieldsFromAccount(trigger.new);
                }

                if (trigger.isUpdate) {
                    OpportunityTriggerHelper.updateLastModifiedDate(trigger.new);
                    // Method to check if parent account has an underwriter, and adds an error if it does not
                    OpportunityTriggerHelper.CheckAccountTeamForUnderwriter(trigger.new, trigger.newMap, trigger.oldMap);
                    //Updating workflow activity based on rating status
                    //Sgr_OpportunityHelper.updatestatus(trigger.new, trigger.oldmap);
                }
            }

            if (Trigger.isAfter) {  
                //OpportunityTriggerHelper.updateOppsTotalsinGate(Trigger.new);
                if (Trigger.isInsert) {  
                    
                    
                    //Method call to filter and create related playbook records - stage,substage and task mapping records associated to the opportunity
                    OpportunityTriggerHelper.filterForCreatePlaybookRecords(trigger.new);
                    //Metehod call to pre populate Renewal Opportunities with Existing Products
                    OpportunityTriggerHelper.PopulateRenewalProducts(trigger.new);
                    //Method call to create Producer Association records from the Account's Group Association records
                    OpportunityTriggerHelper.CreateProducerAssociationForOpportunity(trigger.new);
                    OpportunityTriggerHelper.createSharePointFolder(trigger.new);
                    
                    //SFDC-8872 Rakesh Nunna
                   OpportunityTriggerHelper.addOpportunityContactRoles(trigger.new,trigger.oldMap);
                    
                } else if (Trigger.isUpdate) {
                    //Method call to filter and create related playbook records when playbook is added to opp - stage,substage and task mapping records associated to the opportunity
                    OpportunityTriggerHelper.filterForCreatePlaybookRecords(trigger.newMap, trigger.oldMap);
                    OpportunityTriggerHelper.updateSharePointFolder(trigger.new, trigger.oldMap);
                    //Method call to update the statuses of products to Lost when their Opportunity is updated to Lost
                    OpportunityTriggerHelper.updateLostOppProducts(trigger.new, trigger.oldMap);
                    
                    //SFDC-8872 Rakesh Nunna
                    OpportunityTriggerHelper.addOpportunityContactRoles(trigger.new,trigger.oldMap);
                    
                    
                    
                }
                if (Trigger.isInsert || Trigger.isUpdate) {
                    OpportunityTriggerHelper.CreateBAForNonBlueStarProducts(trigger.newMap);
                    OpportunityTriggerHelper.SendChatterNotifications(trigger.newMap, trigger.oldMap);                    
                }
            }

        } catch (Exception e) {
            for (Opportunity oppIterator : trigger.new) {
                string errMsg = e.getMessage();
                boolean MissingWC = true;
                
                if(MissingWC) {
                    //writes specific validation rule error to page
                    oppIterator.addError(errMsg);
                } else {
                    //writes generic system error to page
                    oppIterator.addError(System.Label.UnexpectedError);     
                }
            }
        }
   
        
            }
        
        else {
              if (trigger.isBefore && trigger.isUpdate) {
                 
                    Sgr_OpportunityHelper.updatestatus(trigger.new, trigger.oldmap);
                     Sgr_OpportunityHelper.CreatingChildtask(trigger.new, trigger.oldmap);
                    
                    Sgr_OpportunityHelper.updateOpportunityEffectiveDate(trigger.new, trigger.oldmap);
                }
        }
    }
    
    }