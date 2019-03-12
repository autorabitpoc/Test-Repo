trigger ProductTracking on Product_Tracking__c (before insert, before update, after update) {
    
    /* BEFORE and INSERT/UPDATE Section */
    if (Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate){
            
            /* Populate the Consultant Field */
            for(Product_Tracking__c aProductTrackingRecord : Trigger.New){
                /* get the related Opportunity Product Record */
                List<Opportunity_Product__c> OpportunityProduct = new List<Opportunity_Product__c>([SELECT Id, Opportunity_Name__c 
                                                                                                    FROM Opportunity_Product__c 
                                                                                                    WHERE Id = :aProductTrackingRecord.Opportunity_Product__c LIMIT 1]);
                for(Opportunity_Product__c aOpportunityProductRecord : OpportunityProduct ){
                    /* get the Opportunity Record */
                    List<Opportunity> aOpportunityRecord = new List<Opportunity>([SELECT Id, Account.id 
                                                                                  FROM Opportunity WHERE Id = :aOpportunityProductRecord.Opportunity_Name__c LIMIT 1]);
                    /* only want to use Primary/Producer combination */
                    String aRole = 'Producer';
                    Boolean PrimaryTrue = true;
                    for(Opportunity aOpportunity : aOpportunityRecord){
                        List<AccountContactRole> aAccountContactRoleRecord = new List<AccountContactRole>([SELECT AccountId, ContactId, IsPrimary, Role 
                                                                                                           FROM AccountContactRole 
                                                                                                           WHERE Role = :aRole AND 
                                                                                                           IsPrimary = :PrimaryTrue AND 
                                                                                                           AccountId = :aOpportunity.AccountId LIMIT 1]);
                        if(!aAccountContactRoleRecord.isEmpty()){
                            AccountContactRole theRecord = aAccountContactRoleRecord.get(0);
                            /* set the Product Tracking Consultant Field to the Account Contact Role value retrieved above */
                            aProductTrackingRecord.Consultant__c = theRecord.ContactId;
                        } 
                    }
                }
            }
            
        }        
    }
    
    /* AFTER UPDATE Section*/
     if (Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            
            /* Update the related Opportunity Product record with PBM selected on the Product Tracking record */
            
            for(Product_Tracking__c aProductTrackingRecord : Trigger.New){
                if (aProductTrackingRecord.PBMCarrier__c != null){
                    /* get the related Opportunity Product Record */
                    List<Opportunity_Product__c> OpportunityProduct = new List<Opportunity_Product__c>([SELECT Id, Opportunity_Name__c 
                                                                                                        FROM Opportunity_Product__c 
                                                                                                        WHERE Id = :aProductTrackingRecord.Opportunity_Product__c LIMIT 1]);
                    for (Opportunity_Product__c ToBeUpdated : OpportunityProduct){
                        ToBeUpdated.Account__c = aProductTrackingRecord.PBMCarrier__c;
                        update ToBeUpdated;
                    }
                }                
            } 
            
        }
    }
    
}