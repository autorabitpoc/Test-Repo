/**************************************************************************************
  Apex Class Name     : CompetitorRelationshipTriggerHandler
  Version             : 1.0
  Function            : This is a handler Class for the CompetitorRelationshipTrigger 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Nitin Paliwal           09/15/2015                Original Version
*************************************************************************************/
public with sharing class CompetitorRelationshipTriggerHandler{
    /*************************************************
     * Method name  : updateSlicedAccountDetails
     * Description  : Static method to update the sliced field of the Account while inserting/updating carrier relationship
     * Return Type  : Void
   *************************************************/
    public static void updateSlicedAccountDetails(list<Competitor_Relationship__c> newList, map<Id,Competitor_Relationship__c > oldMap,list<Competitor_Relationship__c > oldList){
        list<Account> updateAccounts = new list<Account>();
        set<String> accountIds = new set<String>();
        string carrierRecordTypeId;
        //query the record type of carrier 
        for(RecordType rt : [select Id from RecordType where SobjectType = 'Competitor_Relationship__c' and DeveloperName ='Carrier'])
        {
            carrierRecordTypeId = rt.Id;
        }
        //get the account records ids to be update
        if(newList != null){
            for(Competitor_Relationship__c cr : newList){
                if(cr.RecordTypeId == carrierRecordTypeId ){
                    if(oldMap != null && oldMap.containsKey(cr.Id) ){
                        accountIds.add(cr.Group_Account__c);
                        accountIds.add(oldMap.get(cr.Id).Group_Account__c);
                    }
                    else if(oldMap == null || !(oldMap.containsKey(cr.Id))){
                        accountIds.add(cr.Group_Account__c);
                    }
                }
            }
        }
        if(oldList != null){
            for(Competitor_Relationship__c cr : oldList){
                if(cr.RecordTypeId == carrierRecordTypeId && cr.Sliced__c == true && cr.Status__c == 'Active'){
                    accountIds.add(cr.Group_Account__c);
                }
            }
        }
        //query on the account records and in the inner query find out if there is any carrier which is active and sliced set as true
        for(Account acc : [select Sliced__c,Carve_Out__c,Id,(select Id,Sliced_with__c,Carve_Out__c from Competitor_Relationships1__r where (Sliced_with__c = true or Carve_Out__c = true) and Status__c = 'Active' and RecordtypeId =:carrierRecordTypeId) from account where Id In :accountIds]){
            boolean sliced = false;
            boolean carved = false;
            boolean ischanged = false;
            for(Competitor_Relationship__c cr : acc.Competitor_Relationships1__r){
                if(cr.Carve_Out__c)
                    carved = true;
                if(cr.Sliced_with__c)
                    sliced = true;
            }
            
            if(sliced && !acc.Sliced__c){
                acc.Sliced__c = true;
               ischanged = true;
            }
            else if(!sliced && acc.Sliced__c){
                acc.Sliced__c = false;
                ischanged = true;
            }
            
            if(carved && !acc.Carve_Out__c){
                acc.Carve_Out__c = true;
                 ischanged = true;
            }
            else if(!carved && acc.Carve_Out__c){
                acc.Carve_Out__c = false;
                ischanged = true;
            }
            if(ischanged)
                updateAccounts.add(acc);
        }
        //update the account records
        if(updateAccounts.size() >0)
            update updateAccounts;
    }

    /**
    * @author       Sana Fatima/Slalom
    * @description  Computes the Account Complexity Score for the Competitor Relationship object
    */
    public static void updateAccountComplexityScoreForCompetitorRelationship(List<Competitor_Relationship__c> competitorsToUpdate) {
        Id groupAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();

        Set<Id> parentAccountIds = new Set<Id>();
        Map<Id, Account> groupAccounts = new Map<Id, Account>();

        for ( Competitor_Relationship__c currCompetitor : competitorsToUpdate ) {
            if( currCompetitor.Group_Account__c != null)
                parentAccountIds.add(currCompetitor.Group_Account__c);
        }
        if( !parentAccountIds.isEmpty() ) {
            groupAccounts = new Map<Id, Account>( accountDAOInstance.getCompetitorRelationshipComplexityGroupAccounts(parentAccountIds, groupAccountRecordType) );
        }
        if( !groupAccounts.isEmpty() )
            calculateCompetitorComplexityScore(groupAccounts);
    }

    /**
    * @author       Sana Fatima/Slalom
    * @description  Computes the Account Complexity Score for the Competitor Relationship object
    */
    public static void calculateCompetitorComplexityScore(Map<Id, Account> groupAccounts) {
        try {
            List<Competitor_Relationship__c> childCompetitors = new List<Competitor_Relationship__c>();
            Map<Id, Integer> numCompetitorsByAccIds = new Map<Id, Integer>();
            List<Account> accountsToUpdate = new List<Account>();
            AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();
            CompetitorRelationshipDAO.ICompetitorRelationshipDAO competitorRelationshipDAOInstance = new CompetitorRelationshipDAO();
            Decimal oldValue;

            childCompetitors = competitorRelationshipDAOInstance.getActiveCompetitorRelationships( groupAccounts );
            for( Competitor_Relationship__c currCompetitor :childCompetitors ) {    
                if( !numCompetitorsByAccIds.containsKey(currCompetitor.Group_Account__c)) {
                    numCompetitorsByAccIds.put(currCompetitor.Group_Account__c, 1);
                } else {
                    numCompetitorsByAccIds.put(currCompetitor.Group_Account__c, numCompetitorsByAccIds.get(currCompetitor.Group_Account__c)+ 1 );
                }
            }
            for( Account currAccount: groupAccounts.values() ) {
                oldValue = currAccount.ComplexityScoreCompetitorRelationship__c;
                if (numCompetitorsByAccIds.containsKey(currAccount.Id) && numCompetitorsByAccIds.get(currAccount.Id) >= 1  && numCompetitorsByAccIds.get(currAccount.Id) <= 3) {
                    currAccount.ComplexityScoreCompetitorRelationship__c = 5; 
                } else if (numCompetitorsByAccIds.containsKey(currAccount.Id) && numCompetitorsByAccIds.get(currAccount.Id) >= 4 ) {
                    currAccount.ComplexityScoreCompetitorRelationship__c = 10; 
                } else if ( !numCompetitorsByAccIds.containsKey(currAccount.Id) ){
                    currAccount.ComplexityScoreCompetitorRelationship__c = 0;  
                }
                if( currAccount.ComplexityScoreCompetitorRelationship__c != oldValue) {
                    accountsToUpdate.add(currAccount);
                } 
            }
            if( !accountsToUpdate.isEmpty() ) {
                accountDAOInstance.updateAccounts( accountsToUpdate );
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'CompetitorRelationship', 'CompetitorRelationshipTrigger', 'CompetitorRelationshiprHandler.calculateCompetitorComplexityScore', 'High');
        }
    }
    
    /****************************************************************
* Method name  : strategicPlanUpdate
* Description  : Static method to update the Active Strategic Plan for associated Account on insert
* Return Type  : Void
//------Start of Jira # 4115 ---------------------------   
* *************************************************************/
    
    public void onInsertorUpdate(List<Competitor_Relationship__c> affectedCompetitorRecords){
        Id SPId ;
        Id CompAccountId;
        if(!affectedCompetitorRecords.isEmpty()){
            CompAccountId = affectedCompetitorRecords[0].Group_Account__c;
            SPId = getStrategicPlanIdForAccount(CompAccountId);            
        }//if
        System.debug('**SPID ' + SPID);
        for(Competitor_Relationship__c affectedCompRec :  affectedCompetitorRecords ){
            affectedCompRec.Strategic_Plan__c = SPId;
        }//for
    }//onUpdate 
    //-----------------------------------------------------------
    public Id getStrategicPlanIdForAccount(Id vAccountId){
        Id strategicPlanId;
        List<Strategic_Plan__c> StrategicPlanRecs =
            [SELECT Id FROM Strategic_Plan__c 
             where Account_Name__c =: vAccountId
             AND Active__c = true order by CreatedDate desc limit 1];
        System.debug('*** StrategicPlanRecs : '+StrategicPlanRecs);
        if(!StrategicPlanRecs.isEmpty()){strategicPlanId = StrategicPlanRecs[0].Id;}
        return strategicPlanId;
    }//getStrategicPlanIdForAccount
//------End of Jira # 4115 ---------------------------       
}