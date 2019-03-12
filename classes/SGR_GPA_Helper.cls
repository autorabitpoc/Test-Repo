public class SGR_GPA_Helper {
    public static void updateGPAOnOpportunity(List<Producer_Group_Association__c> sgrProducerGroupAssociations){
        // Set of Id's to hold Group Accounts, Producer Accounts, Opportunities
        Set<Id> grpAccIds = new Set<Id>();
        Set<Id> prodAccIds = new Set<Id>();
        List<Opportunity> opplist = new List<Opportunity>();
        Set<Opportunity> oppIds = new Set<Opportunity>();
        // Producer_Association_For_Opportunity__c lists to verify existing records and list to insert new records
            List<Producer_Association_For_Opportunity__c> paoList = new List<Producer_Association_For_Opportunity__c>();
            List<Producer_Association_For_Opportunity__c> updatepaoList = new List<Producer_Association_For_Opportunity__c>();
        if(sgrProducerGroupAssociations != NULL && sgrProducerGroupAssociations.size()>0){
           List<Producer_Group_Association__c> sgrProducerGroupAssociationsList = [select id,Group_Account__c,Producer_Account__c,
                                                                               End_Date__c,Producer_Account__r.Status__c 
                                                                               FROM Producer_Group_Association__c
                                                                               WHERE Id IN:sgrProducerGroupAssociations];
           // Filter producerGroupAssociations with criteria needed and add lists with respective Ids
            if(sgrProducerGroupAssociationsList.size() > 0){
                for(Producer_Group_Association__c pga :sgrProducerGroupAssociationsList){
                    if(pga.Group_Account__c != null && pga.Producer_Account__c != null 
                       && pga.End_Date__c == null && pga.Producer_Account__r.Status__c == 'Active'){
                           grpAccIds.add(pga.Group_Account__c);
                           prodAccIds.add(pga.Producer_Account__c);                             
                       } 
                }
            }
        //Get recent opportunity on Group Account to update Producer Association For Opportunity
            opplist = [Select id,AccountId,Requested_Effective_Date__c from Opportunity where AccountId IN: grpAccIds];
            if(opplist.size() > 0){
                for(Opportunity oppty: opplist){
                    if(oppty.Requested_Effective_Date__c.year() >= System.now().year()){
                        oppIds.add(oppty);
                    }
                }  
            }
        // Query all Producer Association For Opportunity records to avoid duplicate record insert
            paoList = [Select Opportunity__c,Producer_Consultant__c from Producer_Association_For_Opportunity__c 
                       where Opportunity__c IN: oppIds AND Producer_Consultant__c IN: prodAccIds];
            if(paoList.size() == 0){
                for(Opportunity oppId:oppIds){
                    for(Producer_Group_Association__c pga: sgrProducerGroupAssociationsList){
                        if(pga.Group_Account__c != null && pga.Producer_Account__c != null
                           && pga.End_Date__c == null && pga.Producer_Account__r.Status__c == 'Active'){
                               if(oppId.Accountid==pga.Group_Account__c)
                               updatepaoList.add(new Producer_Association_For_Opportunity__c(Opportunity__c = oppId.id, Producer_Consultant__c = pga.Producer_Account__c));
                           }
                    }
                    
                }
            }
            
            if(updatepaoList.size()>0){
                try{
                    insert updatepaoList;
                }
                Catch(Exception e){
                	e.getMessage();
                }
            } 
        }
        
    }

}