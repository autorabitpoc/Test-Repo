public class SGR_PGA_Opportunity {
	 public static void sgrCreateProducerAssociationForOpportunity(List<Opportunity> opps){         
        //Key: Account Id; Value: Opportunity Id
        Map<Id, Id> opportunityAccountMap = new Map<Id, Id>();
        for(Opportunity opp: opps){
            opportunityAccountMap.put(opp.AccountId, opp.Id);
        }
        //Only need to query/insert if there are Opportunity/Account matches
        if(opportunityAccountMap.size() > 0){
            List<Producer_Group_Association__c> producerGroupAssociations = [SELECT Id, Group_Account__c, Producer_Account__c, Producer_Account__r.Status__c,Primary__c,End_Date__c FROM Producer_Group_Association__c WHERE Group_Account__c in :opportunityAccountMap.keySet()];
            List<Producer_Association_For_Opportunity__c> paoList = new List<Producer_Association_For_Opportunity__c>();
            //If there are more than one Producer Group Association records, add only the Producer Accounts marked "Active"
            if(!producerGroupAssociations.isEmpty() && producerGroupAssociations.size() > 0){
                for(Producer_Group_Association__c pga: producerGroupAssociations){
                    //SFDC-6461 added primary and End Date check :Padma Bedampeta - 10/20/2017  
                    if(pga.Group_Account__c != null && pga.Producer_Account__c != null && pga.Producer_Account__r.Status__c == 'Active' 
                       && pga.End_Date__c == NULL){
                        paoList.add(new Producer_Association_For_Opportunity__c(Opportunity__c = opportunityAccountMap.get(pga.Group_Account__c), Producer_Consultant__c = pga.Producer_Account__c));
                    }
                }
            }
            //Else, add the Producer Account
          /*  else{
                for(Producer_Group_Association__c pga: producerGroupAssociations){
                    //SFDC-6461 added primary check :Padma Bedampeta - 10/20/2017
                    if(pga.Group_Account__c != null && pga.Producer_Account__c != null && pga.Producer_Account__r.Status__c == 'Active' && pga.Primary__c == true){
                        paoList.add(new Producer_Association_For_Opportunity__c(Opportunity__c = opportunityAccountMap.get(pga.Group_Account__c), Producer_Consultant__c = pga.Producer_Account__c));
                    }
                }
            }*/
            //Only need to insert if there are PAOs to insert
            if(!paoList.isEmpty() && paoList.size() > 0){
                try{
                    insert paoList;
                } catch(DMLException e){
                    System.debug(e.getMessage());
                }
            }
        }
    }
}