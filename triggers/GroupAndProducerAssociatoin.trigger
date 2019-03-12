trigger GroupAndProducerAssociatoin on Producer_Group_Association__c (after insert, after update) {    
 if(checkRecursive.runOnce()){
        if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
        {
            system.debug('Entered');
            GrpAndProdAssociationTriggerHandler.CreateProducerAssociationForOpportunity(Trigger.New);
            GrpAndProdAssociationTriggerHandler.populatePrimaryProducerAccountAndRestrict1Primary(Trigger.New); //SFDC-8528-SFDC-8830
        	SGR_GPA_Helper.updateGPAOnOpportunity(Trigger.New);
        }
        if(trigger.isAfter && (trigger.isUpdate)){
         GrpAndProdAssociationTriggerHandler.accountContactRelUpdateForProducerAssociation(Trigger.New);
     }
    }
}