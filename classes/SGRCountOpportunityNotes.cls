/*US-13467
Author:Padmini*/
public class SGRCountOpportunityNotes {
   
    public static void CountEnhanceNotes(List<ContentDocumentLink> noteList){
        
        List<Id> opportunityIds = new List<Id>();
        for(ContentDocumentLink n : noteList){
            String entityId = n.LinkedEntityId;
            if(entityId.startsWith('006')){
                //System.debug('checking for existing notes');
                opportunityIds.add(n.LinkedEntityId);                
            }
        }
        List<Opportunity> opportunityToUpdate = new List<Opportunity>();
        
        for(Opportunity oppty : [select Id, Total_Number_of_Notes__c, (select Id from AttachedContentNotes) from Opportunity where Id IN :opportunityIds]){
            oppty.Total_Number_of_Notes__c = oppty.AttachedContentNotes.size();
            opportunityToUpdate.add(oppty);
           /* if(oppty.AttachedContentNotes.size()==0){
                oppty.Total_Number_of_Notes__c=0;
                opportunityToUpdate.add(oppty);
                System.debug('++++'+oppty.Total_Number_of_Notes__c);
            }*/
        }
        try{
            if(!opportunityToUpdate.IsEmpty()){
                update opportunityToUpdate;
            }
            
        }catch(Exception e){
            system.debug('Thrown exception for SGRCountOpportunityNotes:: CountEnhanceNotes ::'+e.getMessage());
        }
    }

    public static void CountEnhanceNotesOnBeforeDelete(List<ContentDocument> noteList){
        
        List<Id> opportunityIds = new List<Id>();
        List<Id> contentDocIds = new List<Id>();        
        for(ContentDocument cd : noteList){
            contentDocIds.add(cd.Id);                
        }
        
        for(ContentDocumentLink n : [SELECT LinkedEntityId From ContentDocumentLink WHERE ContentDocumentId IN :contentDocIds]){
            String entityId = n.LinkedEntityId;
            if(entityId.startsWith('006')){
                opportunityIds.add(n.LinkedEntityId);                
            }
        }
        List<Opportunity> opportunityToUpdate = new List<Opportunity>();
        Integer notesCount = 0;
        for(Opportunity oppty : [select Id, Total_Number_of_Notes__c, (select Id from AttachedContentNotes) from Opportunity where Id IN :opportunityIds]){
            notesCount = oppty.AttachedContentNotes.size();
            oppty.Total_Number_of_Notes__c = notesCount > 0 ? notesCount - 1 : 0;
            //system.debug('+++++'+oppty.Total_Number_of_Notes__c);
            opportunityToUpdate.add(oppty);
        }
        try{
            if(!opportunityToUpdate.IsEmpty()){
                update opportunityToUpdate;
            }
          }catch(Exception e){
            system.debug('Thrown exception for SGRCountOpportunityNotes:: CountEnhanceNotesOnBeforeDelete :: '+e.getMessage());
        }
    }

}