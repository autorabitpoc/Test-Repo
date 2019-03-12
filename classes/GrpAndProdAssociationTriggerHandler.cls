public class GrpAndProdAssociationTriggerHandler {
    
/*
* @Developer - Padma Bedampeta
* Apex Class Method CreateProducerAssociationForOpportunity to update Producer Association of Group Account on Opportunity by 
* creating new record of Producer_Association_For_Opportunity__c
* SFDC-6461 - Auto populate Producer Information from Account to Opportunity only when New/Update Association after Opportunity has been created
* Version Date - 10/20/2017
*/
public static void CreateProducerAssociationForOpportunity(List<Producer_Group_Association__c> newList){
    try{
        // Set of Id's to hold Group Accounts, Producer Accounts, Opportunities
        Set<Id> grpAccIds = new Set<Id>();
        Set<Id> prodAccIds = new Set<Id>();
        Set<Opportunity> oppIds = new Set<Opportunity>();
        Map<Id,Id> mapOppId = new Map<Id,Id>();
        // opplist to hold opportunities of Group Account
        List<Opportunity> opplist = new List<Opportunity>();
        
        system.debug('newList:::::'+newList);
        if(newList.size() > 0){
            
            //Get Producer Association fields from Trigger.new list            
            List<Producer_Group_Association__c> producerGroupAssociations = [SELECT Id, Group_Account__c, Producer_Account__c, Producer_Account__r.Status__c,Primary__c,End_Date__c 
                                                                             FROM Producer_Group_Association__c WHERE Id in :newList AND Group_Account__r.Forecast_Segment__c != 'Small Group'];
            
             List<Producer_Group_Association__c> sgrProducerGroupAssociations = [SELECT Id, Group_Account__r.Forecast_Segment__c,Group_Account__c, Producer_Account__c, Producer_Account__r.Status__c,Primary__c,End_Date__c 
                                                                             FROM Producer_Group_Association__c WHERE Id in :newList AND Group_Account__r.Forecast_Segment__c = 'Small Group'];
            if(!sgrProducerGroupAssociations.isEmpty() && sgrProducerGroupAssociations.size() > 0){
                SGR_GPA_Helper.updateGPAOnOpportunity(sgrProducerGroupAssociations);
            }
	    // Producer_Association_For_Opportunity__c lists to verify existing records and list to insert new records
            List<Producer_Association_For_Opportunity__c> paoList = new List<Producer_Association_For_Opportunity__c>();
            List<Producer_Association_For_Opportunity__c> updatepaoList = new List<Producer_Association_For_Opportunity__c>();
            
            // Filter producerGroupAssociations with criteria needed and add lists with respective Ids
            if(producerGroupAssociations.size() > 0){
                for(Producer_Group_Association__c pga :producerGroupAssociations){                       
                    if(pga.Group_Account__c != null && pga.Producer_Account__c != null 
                       && pga.Primary__c == true && pga.End_Date__c == null && pga.Producer_Account__r.Status__c == 'Active'){
                           grpAccIds.add(pga.Group_Account__c);
                           prodAccIds.add(pga.Producer_Account__c);                             
                       }                        
                    else if(pga.Group_Account__c != null && pga.Producer_Account__c != null 
                            && pga.Producer_Account__r.Status__c == 'Active' && pga.Primary__c == true){
                                grpAccIds.add(pga.Group_Account__c);
                                prodAccIds.add(pga.Producer_Account__c);                                  
                            }
                }
            }
            
            system.debug('grpAccIds:::::'+grpAccIds);
            system.debug('prodAccIds:::::'+prodAccIds);
           
            //Get recent opportunity on Group Account to update Producer Association For Opportunity
            opplist = [Select id,AccountId,Requested_Effective_Date__c from Opportunity where AccountId IN: grpAccIds];
            system.debug('opplist:::::'+opplist);
            if(opplist.size() > 0){
                for(Opportunity oppty: opplist){
                    if(oppty.Requested_Effective_Date__c.year() >= System.now().year()){
                        oppIds.add(oppty);
                    }
                }  
            }
            system.debug('oppIds:::::'+oppIds);
         
            // Query all Producer Association For Opportunity records to avoid duplicate record insert
            paoList = [Select Opportunity__c,Producer_Consultant__c from Producer_Association_For_Opportunity__c 
                       where Opportunity__c IN: oppIds AND Producer_Consultant__c IN: prodAccIds];
            system.debug('paoList:::::'+paoList);
            if(paoList.size() == 0){
                for(Opportunity oppId:oppIds){
                    for(Producer_Group_Association__c pga: producerGroupAssociations){
                        if(pga.Group_Account__c != null && pga.Producer_Account__c != null
                           && pga.Primary__c == true && pga.End_Date__c == null && pga.Producer_Account__r.Status__c == 'Active'){
                               if(oppId.Accountid==pga.Group_Account__c)
                               updatepaoList.add(new Producer_Association_For_Opportunity__c(Opportunity__c = oppId.id, Producer_Consultant__c = pga.Producer_Account__c));
                           }
                    }
                    
                }
            }
            
            if(updatepaoList.size()>0){
                try{
                    system.debug('paoList:::::'+updatepaoList);
                    insert updatepaoList;
                }
                Catch(Exception e){
                    system.debug('Exception::::'+e);
                }
            }
            
        }
        
    }Catch(Exception e){
        System.debug('Exception ::::::'+e);
    }
    
}
/*
* @Developer - Padma Bedampeta
* Apex Class Method to terminate RelatedContact records of Group Account when associated Producer Account terminated and Producer House contacts 
* related to Group Account will also be terminated.
* SFDC-8584 - 
* Version Date - 
*/
public static void accountContactRelUpdateForProducerAssociation(List<Producer_Group_Association__c> newList){
    Set<Id> grpAccIds = new Set<Id>();
    Set<Id> prodAccIds = new Set<Id>();
   // Set<Id> relProdAccIds = new Set<Id>();
    Set<Id> ProdHouseAccIds = new Set<Id>(); 
    Set<Id> relContactIds = new Set<Id>();
    List<Account> prodAcc = new List<Account>();
    List<Account> allChildProdAccs = new List<Account>();
    List<AccountContactRelation> accContRelList = new List<AccountContactRelation>();
    Map<Id,Date> accPGAMAP = new Map<Id,Date>();
    
    List<AccountContactRelation> accContRelListToUpdate = new List<AccountContactRelation>();
    //Get PAG record list from Trigger.New
    List<Producer_Group_Association__c> producerGroupAssociations = [SELECT Id, Group_Account__c, Producer_Account__c, Producer_Account__r.Status__c,Primary__c,End_Date__c 
                                                                     FROM Producer_Group_Association__c WHERE Id in :newList];
    //add Group and Producer Account Id into individual set of Ids
    try{
        if(producerGroupAssociations.size()>0){
            for(Producer_Group_Association__c PGA :producerGroupAssociations){
                if(PGA.Producer_Account__c != NULL && PGA.Group_Account__c != NULL && PGA.End_Date__c != NULL){
                    grpAccIds.add(pga.Group_Account__c);
                    prodAccIds.add(pga.Producer_Account__c);
                    accPGAMAP.put(pga.Group_Account__c, PGA.End_Date__c);
                } 
            } 
            //Get Producer House Account 
            if(prodAccIds.size()>0){
                prodAcc = [SELECT Id,ParentId from Account where Id IN:prodAccIds];
            } 
            //add Producer House Account Ids into Set
            if(prodAccIds.size()>0){
                for(Account pa:prodAcc){
                    ProdHouseAccIds.add(pa.ParentId);
                } 
            }
            //Get Producer House Accounts - Siblings to Associated Producer Account
            if(ProdHouseAccIds.size()>0){
                allChildProdAccs = [SELECT id,Name,ParentId,
                                    (Select Id,EndDate,IsActive,ContactId From AccountContactRelations) 
                                    from Account where ParentId IN:ProdHouseAccIds];
            }
            //Get All Producer House Contacts
            if(allChildProdAccs.size()>0){
                List<Contact> allProducerHouseContacts = [SELECT Id,AccountId from Contact WHERE AccountId IN: allChildProdAccs];
                for(Contact relCon:allProducerHouseContacts){
                    relContactIds.add(relCon.Id);
                }
            }
            
            /* List<Account> grpAccRelatedContacts = [SELECT id,Name,
(Select Id,EndDate,IsActive,ContactId From AccountContactRelations 
where EndDate = NULL AND IsActive=TRUE AND ContactId IN:relContactIds) 
FROM Account WHERE Id IN:grpAccIds];*/
                //Get All related Contact Ids from Group AccountContactRelationship which are related to Producer House Account
                if(relContactIds.size()>0){
                    accContRelList = [SELECT id,AccountId,ContactId,EndDate,IsActive FROM AccountContactRelation 
                                      WHERE AccountId IN:grpAccIds AND 
                                      EndDate = NULL AND 
                                      IsActive=TRUE AND 
                                      ContactId IN:relContactIds];
                }
                //Update AccountConatctRelationship records 
                if(accContRelList.size()>0){
                    for(AccountContactRelation accContRel :accContRelList){
                        if(accPGAMAP.containsKey(accContRel.AccountId)) {
                            accContRel.EndDate=accPGAMAP.get(accContRel.AccountId);
                        }
                       // accContRel.EndDate = System.today();
                        accContRel.IsActive = false;
                        accContRelListToUpdate.add(accContRel);
                    }
                }
                
            }
            //Update final list.
            try{
                if(accContRelListToUpdate.size()>0){
                    Update accContRelListToUpdate;
                }
                
            }Catch(DmlException e){
                System.debug('The following exception has occurred:'+e.getMessage());
            }
            
        }Catch(exception e)
        {
            System.debug('The following exception has occurred:'+e.getMessage());
        }
    } 
    
    
    /**@Author Mei Chen
    ** @Date 4/02/2018 
    ** this method does: SFDC 8528 & SFDC8830
    **   #1. to populate the producer account from PAG to parent Group/Prospect account 
    **          when is Primary and no End Date.
    **   #2. to restrict only one primary Producer Account from the same group account.
    **       such as if the newly inserted/updated PAG is Primary and no end date,
    **       then uncheck primary from previouls PAG that is also related the same grp account. 
    **/
    
    public static void populatePrimaryProducerAccountAndRestrict1Primary(list<Producer_Group_Association__c> pagList){
        
        map<Id, Id> prodMap=new map<Id,Id>();
        map<Id, Id> uncheckPrevPrimary=new map<Id,Id>();
        
        system.debug('populatePrimaryProducerAccount '+pagList);
        
        List<Producer_Group_Association__c> producerGroupAssociations = [SELECT Id, Group_Account__c,Group_Account__r.id, Producer_Account__c, Producer_Account__r.id,Producer_Account__r.Status__c,Primary__c,End_Date__c 
                                                                             FROM Producer_Group_Association__c WHERE Id in :pagList];
        
        system.debug(' new list: '+producerGroupAssociations);
        
        for(Producer_Group_Association__c pag:producerGroupAssociations){
            system.debug('pag: '+pag);
            
          if(pag.Primary__c==true && pag.End_Date__c==null && pag.Producer_Account__c!=null && pag.Producer_Account__r.Status__c=='Active'){
              system.debug('primary producer account: '+pag.Producer_Account__c);
              system.debug('Group_Account__r.id: '+pag.Group_Account__r.id+' :: '+pag.Producer_Account__r.id);
             
             prodMap.put(pag.Group_Account__r.id, pag.Producer_Account__r.id);
             uncheckPrevPrimary.put(pag.Group_Account__r.id, pag.id);//remember the account Id and newly update/inset pag
          } 
        }//get all the group/prospect accounts that need to update producer acccount
        
        if(!prodMap.isEmpty()){
            
            set<Id> acctId=prodMap.keySet();
            list<Account> updateAcct=[select id,Primary_Producer_Account__c from Account where Id in:acctId];
            
            for(Account act:updateAcct){
                system.debug('primary producer account before:'+ act.Primary_Producer_Account__c);
                act.Primary_Producer_Account__c=prodMap.get(act.id);
                system.debug('primary producer account after:'+ act.Primary_Producer_Account__c);
            }
            
            if(updateAcct!=null && !updateAcct.isEmpty()){
                try{
                    update updateAcct;
                }catch (system.dmlException e){
                    system.debug('update account exception: '+e);
                }
            }
        }
        
   
   /** this code is restrict only one primary Producer Account from the same group account.
    ** such as if the newly inserted/updated PAG is Primary and no end date,
    ** then uncheck primary from previouls PAG that is also related the same grp account.
    **/
        
        if(!uncheckPrevPrimary.isEmpty()){
            set<Id> acctId=uncheckPrevPrimary.keySet();
            list<Id> pagId=uncheckPrevPrimary.values(); 
                    
            List<Producer_Group_Association__c> updatePagList=[select id, primary__c, End_Date__c, group_account__c from Producer_Group_Association__c where id not in:pagId and group_account__c in: acctId];
            
            system.debug('updatePagList: '+updatePagList);
            
            if(updatePagList!=null && !updatePagList.isEmpty()){
                
                list<Producer_Group_Association__c> updatePag=new list<Producer_Group_Association__c>();
                
                for(Producer_Group_Association__c pag: updatePagList){
                    if(pag.primary__c){
                        pag.primary__c=false;//uncheck primary
                        updatePag.add(pag);
                    }
                }
                
                if(!updatePag.isEmpty()){
                    
                    try{
                      update updatePag;
                     
                    }catch(system.dmlException e){
                      system.debug(' update pag to remove previous primary check exception:::'+e);
                    }
                }
                    
            }
        
        }
    }
    
   
    
}