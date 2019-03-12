public with sharing class OpportunityTriggerHelper {
    /** final variables ***/
    static final String ENTRY_SEPARATOR = ',';
    static final String KEY_SEPARATOR = '__';
    static final String OPP_PROD_OPPORTUNITY_FIELD = 'opportunity__c';
    static final String OPP_PROD_PRODFAMILY_FIELD = 'family';
    static final String OPP_PROD_RECORD_TYPE_FIELD = 'recType';
    
    
    
    public static void updateUserOpporuntityActivity(List<Opportunity> newOpps) {
        
        Id currUserId = UserInfo.getUserId();
        User currUser = [Select Id, Last_Opp_Activity_Date__c from User Where Id = :currUserId limit 1];
        currUser.Last_Opp_Activity_Date__c = System.now();
        //update currUser;
    }
    
    /**
* @developer: Abhinav Gadepalli/Deloitte Consulting
* @description: Method to filter the opportunities for which the playbook records(stage mapping, sub stage mapping and task mapping)
*               records have to be created. This method is overloaded as there is another method takes an extra param(old trigger map)
*                to filter the opp records to return records where playbook has been added.
* @usage: OpportunityTriggerHelper
*
*/
    public static void filterForCreatePlaybookRecords(List<Opportunity> newOpportunitiesList) {
        List<Opportunity> oppList = new List<Opportunity> ();
        if (!recursiveHelper.hascreatedPlaybookRecs()) {
            for (Opportunity opp : newOpportunitiesList) {
                if (opp.Playbook__c != null) {
                    oppList.add(opp);
                }
            }
        }
        if (oppList.size() <> 0) {
            createRecordsForPlaybook(oppList);
            RecursiveHelper.setCreatedPlaybookRecs();
        }
    }
    
    /**
* @developer: Abhinav Gadepalli/Deloitte Consulting
* @description: Method to filter the opportunities for which the playbook records(stage mapping, sub stage mapping and task mapping)
*                records have to be created. This method is overloaded as the method takes an extra param(old trigger map)
*                to filter the opp records to return records where playbook has been added.
* @usage: OpportunityTriggerHelper
*
*/
    public static void filterForCreatePlaybookRecords(Map<Id, Opportunity> newOpportunititesMap, Map<Id, Opportunity> oldOpportunitiesMap) {
        List<Opportunity> oppList = new List<Opportunity> ();
        if (!recursiveHelper.hascreatedPlaybookRecs()) {
            for (Id oppId : newOpportunititesMap.keySet()) {
                if (newOpportunititesMap.get(oppId).Playbook__c<> oldOpportunitiesMap.get(oppId).Playbook__c) {
                    oppList.add(newOpportunititesMap.get(oppId));
                }
            }
        }
        if (oppList.size() <> 0) {
            createRecordsForPlaybook(oppList);
            RecursiveHelper.setCreatedPlaybookRecs();
        }
    }
    
    /**
* @description: Method to create the playbook stage, substage and task mapping records when a playbook is added to an opportunity.
* @usage:       OpportunityTriggerHelper
*
*/
    public static void createRecordsForPlaybook(List<Opportunity> listOppsForPlaybook) {
        
        Map<Id, List<Opportunity>> mapOppsByPbId = new Map<Id, List<Opportunity>> ();
        Set<Id> setStageIds = new Set<Id> ();
        Map<String, Stage_Mapping__c> mapSMByKey = new Map<String, Stage_Mapping__c> ();
        Set<Id> setSubstageIds = new Set<Id> ();
        Map<String, Substage_Mapping1__c> mapSSMByKey = new Map<String, Substage_Mapping1__c> ();
        List<Task_Mapping__c> listTM = new List<Task_Mapping__c> ();
        
        List<Opportunity> listOpps;
        try {
            for (Opportunity opp : listOppsForPlaybook) {
                if (!mapOppsByPbId.containsKey(opp.Playbook__c)) {
                    listOpps = new List<Opportunity> ();
                    listOpps.add(opp);
                    mapOppsByPbId.put(opp.Playbook__c, listOpps);
                } else mapOppsByPbId.get(opp.Playbook__c).add(opp);
            }
            Stage_Mapping__c sm;
            for (Playbook__c pb :[SELECT Id, (SELECT Id FROM Stages__r ORDER BY Stage_Sort_Order__c)
                                  FROM Playbook__c WHERE Id IN :mapOppsByPbId.keySet()]) {
                                      for (Stage__c s : pb.Stages__r)
                                          setStageIds.add(s.Id);
                                      if (mapOppsByPbId.containsKey(pb.Id)) {
                                          for (Opportunity opp : mapOppsByPbId.get(pb.Id)) {
                                              for (Stage__c s : pb.Stages__r) {
                                                  sm = new Stage_Mapping__c();
                                                  sm.Opportunity__c = opp.Id;
                                                  sm.Playbook__c = pb.Id;
                                                  sm.Stage__c = s.Id;
                                                  String key1 = sm.Opportunity__c + '-' + sm.Playbook__c + '-' + sm.Stage__c;
                                                  mapSMByKey.put(key1, sm);
                                              }
                                          }
                                      }
                                  }
            
            if (!mapSMByKey.values().isEmpty()) {
                insert mapSMByKey.values();
            }
            
            Substage_Mapping1__c ssm;
            for (Stage__c s :[SELECT Id, Playbook__c, (SELECT Id, Stage__r.Stage_Sort_Order__c, Substage_Sort_Order__c FROM Substages__r ORDER BY Substage_Sort_Order__c)
                              FROM Stage__c WHERE Id IN :setStageIds]) {
                                  for (Substage__c ss : s.Substages__r) {
                                      setSubstageIds.add(ss.Id);
                                      if (mapOppsByPbId.containsKey(s.Playbook__c)) {
                                          for (Opportunity o : mapOppsByPbId.get(s.Playbook__c)) {
                                              String key2 = o.Id + '-' + s.Playbook__c + '-' + s.Id;
                                              if (mapSMByKey.containsKey(key2)) {
                                                  ssm = new Substage_Mapping1__c();
                                                  ssm.Substage__c = ss.Id;
                                                  ssm.Stage_Mapping__c = mapSMByKey.get(key2).Id;
                                                  if (ss.Stage__r.Stage_Sort_Order__c == 1 && ss.Substage_Sort_Order__c == 1) {
                                                      ssm.Started__c = true;
                                                      ssm.Start_DateTime__c = DateTime.now();
                                                  }
                                                  String key3 = key2 + '-' + ssm.Substage__c;
                                                  mapSSMByKey.put(key3, ssm);
                                              }
                                          }
                                      }
                                  }
                              }
            
            if (!mapSSMByKey.values().isEmpty()) {
                insert mapSSMByKey.values();
            }
            Task_Mapping__c tm;
            for (Substage__c ss :[SELECT Id, Stage__r.Playbook__c, Stage__c, (SELECT Id FROM Tasks__r ORDER BY Task_Sort_Order__c)
                                  FROM Substage__c WHERE Id IN :setSubstageIds]) {
                                      for (Task__c t : ss.Tasks__r) {
                                          if (mapOppsByPbId.containsKey(ss.Stage__r.Playbook__c)) {
                                              for (Opportunity o : mapOppsByPbId.get(ss.Stage__r.Playbook__c)) {
                                                  String key4 = o.Id + '-' + ss.Stage__r.Playbook__c + '-' + ss.Stage__c + '-' + ss.Id;
                                                  if (mapSSMByKey.containsKey(key4)) {
                                                      tm = new Task_Mapping__c();
                                                      tm.Task__c = t.Id;
                                                      tm.Substage_Mapping__c = mapSSMByKey.get(key4).Id;
                                                      listTM.add(tm);
                                                  }
                                              }
                                          }
                                      }
                                  }
            
            if (!listTM.isEmpty()) {
                insert listTM;
            }
        } catch(Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunty', null, 'OpportunityTriggerHelper', 'High');
            System.debug('Exception : ' + e.getMessage());
        }
    }
    
    
    public static void selectDefaultPlaybook(List<Opportunity> newOpportunities) {
        Playbook_Settings__c playbookSettings = Playbook_Settings__c.getOrgDefaults();
        
        Map<String, Id> playbookNameIdMap = new Map<String, Id> ();
        
        for (Playbook__c plbk : [select Id, Name
                                 from Playbook__c
                                 where(Name = :playbookSettings.New_Sale_Default_Playbook__c
                                       or Name = :playbookSettings.Renewal_Default_Playbook__c or Name = :playbookSettings.RFP_Renewal_Default_Playbook__c)
                                 And Active__c = true
                                 limit 3]) {
                                     playbookNameIdMap.put(plbk.Name, plbk.Id);
                                 }
        
        Id newSaleRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get( 'New Sale' ).getRecordTypeId();
        Id renewalRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get( 'Renewal' ).getRecordTypeId();
        Id offcycleRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get( 'Off-Cycle Change' ).getRecordTypeId();
        
        try {
            for (Opportunity opp : newOpportunities) {
                
                if (opp.RecordTypeId != null && opp.Playbook__c == null) {
                    if (opp.RecordTypeId == newSaleRecType ) {
                        opp.Playbook__c = playbookNameIdMap.get(playbookSettings.New_Sale_Default_Playbook__c);
                    } else if (opp.RecordTypeId == renewalRecType) {
                        if (opp.Type == Label.RFP)
                            opp.Playbook__c = playbookNameIdMap.get(playbookSettings.RFP_Renewal_Default_Playbook__c);
                        else
                            opp.Playbook__c = playbookNameIdMap.get(playbookSettings.Renewal_Default_Playbook__c);
                    } else if (opp.RecordTypeId == offcycleRecType) {
                        opp.Playbook__c = playbookNameIdMap.get(playbookSettings.New_Sale_Default_Playbook__c);
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunty', null, 'OpportunityTriggerHelper', 'High');
        }
        
    }
    /**************************************************************************************
Apex Methos Name    : CreateBAForNonBlueStarProducts
Version             : 2.0
Function            : This method creates a benefit agreement from won opportunities that are related to a given account.  These
benefit agreements are only created for HCSC Non BlueStar Products that are won for the account

*************************************************************************************/
    public static void CreateBAForNonBlueStarProducts(Map<Id, Opportunity> OpportunityMap) {
        Set<Id> OpportunityIdSet = new Set<Id> ();
        Set<Id> ProductIdSet = new Set<Id> ();
        Id BANonBluStarRecordTypeId;
        BANonBluStarRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(Label.HCSCNonBlueStar).getRecordTypeId();
        List<Benefit_Agreement__c> BAList = new List<Benefit_Agreement__c> ();
        Benefit_Agreement__c BARecord;
        try {
            for (Opportunity oppty : OpportunityMap.values()) {
                if (oppty.IsWon == true) {
                    OpportunityIdSet.add(oppty.Id);
                }
            }
            
            List<Opportunity_Product__c> opptyLineItemList = new List<Opportunity_Product__c>();
            if(!OpportunityIdSet.isEmpty()) {
                opptyLineItemList = [SELECT Id, Product__c, Opportunity_Name__r.AccountId, Product__r.RecordtypeId FROM Opportunity_Product__c WHERE Opportunity_Name__c IN :OpportunityIdSet AND Product__r.RecordtypeId = :BANonBluStarRecordTypeId];
            }
            for (Opportunity_Product__c opptyLit : OpptyLineItemList) {
                BARecord = new Benefit_Agreement__c();
                BARecord.Product__c = opptyLit.Product__c;
                BARecord.Group_Account__c = opptyLit.Opportunity_Name__r.AccountId;
                BAList.add(BARecord);
            }
            insert BAList;
        } catch(Exception ex) {
            System.debug('#####' + Label.Error + ex.getMessage() + ex.getStackTraceString());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunty', null, 'OpportunityTriggerHelper', 'High');
        }
    }
    /********************************************************************
*    Method Name :   SendChatterNotifications
*   @description :   This method  will post chatter on case owner when the Opportunity is won/lost/Declined
*   @parameters  :   map<Id,Case> newCasesMap,map<Id,Case> oldCasesMap
*   @return type :   none
***************************************************************/
    public static void SendChatterNotifications(map<Id, Opportunity> newOpportunitiesMap, map<Id, Opportunity> oldOpportunitiesMap) {
        try {
            
            set<String> changedOppIds = new set<String> ();
            set<String> CedeuserIds = new set<String> ();
            set<String> userIds = new set<String> ();
            set<String> userChatterPosted = new set<String> ();
            list<FeedItem> feedItems = new list<FeedItem> ();
            boolean isCededChatterPosted = false;
            set<String> accIds = new set<String> ();
            for (Opportunity opp : newOpportunitiesMap.values()) {
                if (((oldOpportunitiesMap != null && oldOpportunitiesMap.containsKey(opp.Id) && oldOpportunitiesMap.get(opp.Id).stageName != opp.stagename)
                     || (oldOpportunitiesMap == null || !oldOpportunitiesMap.containsKey(opp.Id)))
                    && (constantsController.OpportunityStagesConsideredForChatterPost.contains(opp.stagename))) {
                        changedOppIds.add(opp.Id);
                        if (opp.stagename == 'Won')
                            accIds.add(opp.AccountId);
                    }
            }
            for (GroupMember gm :[select UserOrGroupId from GroupMember where Group.developerName = 'Cede_Team' and Group.type = 'Queue']) {
                CedeuserIds.add(gm.UserOrGroupId);
            }
            for (Account acc :[select Id, RecordType.DeveloperName, Ceded__c, Name from Account where Id In :accIds and Ceded__c = true]) {
                system.debug('====' + acc.RecordType.DeveloperName);
                if (acc.RecordType.DeveloperName == 'Group_Prospect_Account' || acc.RecordType.DeveloperName == 'Prospect_Non_BlueSTAR') {
                    string chatterMessage = Label.OpporuntiyUpdatePostToChatterMessageCedeCase.replace('<<AccountName>>', acc.name).replace('<<UpdatedOpportunityStage>>', 'Won');
                    //feedItems.addAll(ConstantsController.sendChattertoTeams(CedeuserIds,chatterMessage,'',''));
                    for (String userId : CedeuserIds) {
                        system.debug('=========' + userId);
                        FeedItem post = new FeedItem();
                        post.ParentId = userId;
                        post.Body = chatterMessage;
                        feedItems.add(post);
                    }
                    isCededChatterPosted = true;
                }
            }
            for (Case caseRec :[select Account.name, Account.Ceded__c, OwnerId, RecordType.Developername, CaseNumber, Opportunity_Name__c, Opportunity_Name__r.Name, Opportunity_Name__r.StageName
                                from Case where Opportunity_Name__c In :changedOppIds and
                                (RecordType.Developername In :ConstantsController.caseRecordTypePermissibleWhenOppUpdatedChatter)]) {
                                    string caseLinkId = URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseRec.Opportunity_Name__c;
                                    string caseTitle = caseRec.Opportunity_Name__r.Name;
                                    string chatterMessage = Label.OpporuntiyUpdatePostToChatterMessage.replace('<<AccountName>>', caseRec.Account.name).replace('<<UpdatedOpportunityStage>>', caseRec.Opportunity_Name__r.StageName);
                                    if (caseRec.RecordType.Developername != 'Cede') {
                                        userIds = new set<String> ();
                                        userIds.add(caseRec.OwnerId);
                                        if (!userChatterPosted.contains(caseRec.OwnerId)) {
                                            feedItems.addAll(ConstantsController.sendChattertoTeams(userIds, chatterMessage, caseLinkId, caseTitle));
                                            userChatterPosted.add(caseRec.OwnerId);
                                        }
                                    } else {
                                        if (!isCededChatterPosted && caseRec.Account.Ceded__c) {
                                            chatterMessage = Label.OpporuntiyUpdatePostToChatterMessageCedeCase.replace('<<AccountName>>', caseRec.Account.name).replace('<<UpdatedOpportunityStage>>', caseRec.Opportunity_Name__r.StageName);
                                            feedItems.addAll(ConstantsController.sendChattertoTeams(CedeuserIds, chatterMessage, caseLinkId, caseTitle));
                                            isCededChatterPosted = true;
                                        }
                                    }
                                }
            if (feedItems.size() > 0)
                insert feedItems;
            
        } catch(Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'SendChatterNotifications', 'Opportunity', 'OpportunityTrigger', 'OpportunityTriggerHelper.SendChatterNotifications', 'High');
            
        }
    }
    
    /**
* @developer: Alec Klein, Sana Fatima, Dan Zebrowski/Slalom LLC
* @description: Method to populate certain fields on the Opportunity object based on the values of the Account
*               record in the lookup.
* @usage: OpportunityTriggerHelper
*
*/
    public static void PopulateFieldsFromAccount(List<Opportunity> newOpportunities) {
        try {
            Set<Id> oppAccountIds = new Set<Id> ();
            for (Opportunity opp : newOpportunities) {
                if (opp.AccountId != null)
                    oppAccountIds.add(opp.AccountId);
            }
            Map<ID, Account> oppAccountMap = new Map<ID, Account> ([SELECT Id, Active_Dental_Members__c, Active_Dental_Subscribers__c,
                                                                    Active_Health_Members__c, Active_Health_Subscribers__c, HCSC_Division__c,FSU_Location__c, Market_Segment__c, Cluster__c, Region__c, District__c FROM Account WHERE Id IN :oppAccountIds]);
            
            for (Opportunity opp : newOpportunities) {
                if (opp.AccountId != null) {
                    Account acc = oppAccountMap.get(opp.AccountId);
                    Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
                    String recordTypeName = rtMap.get(opp.RecordTypeId).getName();
                    
                    if (acc.HCSC_Division__c != null) {
                        opp.HCSC_Division__c = acc.HCSC_Division__c;
                        if(acc.FSU_Location__c!=null){
                            opp.FSU_Location__c=acc.FSU_Location__c;
                        }
                    }
                    if (acc.Market_Segment__c != null) {
                        opp.Account_Market_Segment__c = acc.Market_Segment__c;
                    }
                    if (acc.Cluster__c != null) {
                        opp.Clusters__c = acc.Cluster__c;
                    }
                    if (acc.Region__c != null) {
                        opp.Region__c = acc.Region__c;
                    }
                    if (acc.District__c != null) {
                        opp.District__c = acc.District__c;
                    }
                    
                    
                    if (recordTypeName.equalsIgnoreCase('Renewal')) {
                        if (acc.Active_Dental_Members__c != null)
                            opp.Expected_Dental_Members__c = acc.Active_Dental_Members__c;
                        if (acc.Active_Dental_Subscribers__c != null)
                            opp.Expected_Dental_Contracts__c = acc.Active_Dental_Subscribers__c;
                        if (acc.Active_Health_Members__c != null)
                            opp.Expected_Health_Members__c = acc.Active_Health_Members__c;
                        if (acc.Active_Health_Subscribers__c != null)
                            opp.Expected_Health_Contracts__c = acc.Active_Health_Subscribers__c;
                        
                    }else if(recordTypeName.equalsIgnoreCase('New Sale')) {
                        if (acc.Projected_Dental_Members__c != null)
                            opp.Expected_Dental_Members__c = acc.Projected_Dental_Members__c;
                        if (acc.Projected_Dental_Contracts__c != null)
                            opp.Expected_Dental_Contracts__c = acc.Projected_Dental_Contracts__c;
                        if (acc.Projected_Health_Members__c != null)
                            opp.Expected_Health_Members__c = acc.Projected_Health_Members__c;
                        if (acc.Projected_Health_Contracts__c != null)
                            opp.Expected_Health_Contracts__c = acc.Projected_Health_Contracts__c;
                    }
                }
            }
        } catch(Exception e) {
            System.debug('Exception : ' + e.getMessage());
        }
    }
    /**
* @developer: Nick Serafin/Slalom LLC
* @description: Method to pre-populate products on Renewal Opportunities from active BenefitAgreements
*               on the related account
* @usage: OpportunityTriggerHelper
*
*/
    
    public static void PopulateRenewalProducts(List<Opportunity> newOpportunities) {
        
        try {
            String cancelled = Label.Cancelled;
            String active = Label.Active;
            List<Benefit_Agreement__c> benagr = new List<Benefit_Agreement__c> ();
            Set<Id> oppAccountIds = new Set<Id> ();
            Id renewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Label.ProductTypeR).getRecordTypeId();
            List<Opportunity> opportunitiesToCheck = new List<Opportunity>();
            Set<String> statesToCheck = new Set<String>();
            
            for (Opportunity op : newOpportunities) {
                if (op.RecordTypeId == renewalRecordTypeId) {
                    if (op.AccountId != null) {
                        oppAccountIds.add(op.AccountId);
                        opportunitiesToCheck.add(op);
                        statesToCheck.add(op.HCSC_Division__c);
                    }
                }
            }
            
            Id renewalOppProdRecordTypeId = Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get(Label.ProductTypeR).getRecordTypeId();
            
            if (opportunitiesToCheck.size() > 0) {
                
                benagr = [SELECT Group_Account__c, Product__c, Product__r.Product_Type__c, Product__r.HCSC_State__c, Product__r.Simplified_Product__c, Funding_type__c, (select Group_Section__r.Total_Dental_Active_Members__c,
                                                                                                                                                                         Group_Section__r.Total_Healthcare_Active_Members__c, Group_Section__r.Total_Active_Subscribers__c
                                                                                                                                                                         from BA_GS_Assignments__r where Group_Section__r.Status__c = :active),
                          Premium_Type__c FROM Benefit_Agreement__c WHERE Status__c = :active AND Group_Account__c IN :oppAccountIds AND Effective_Date__c < :System.today()
                          and (Cancellation_Status__c != :cancelled and Status__c != :cancelled)
                          ORDER BY Product__r.Product_Type__c ASC limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
                
                Map<Id, Set<String>> accountBenMap = new Map<Id, Set<String>> ();
                
                for (Benefit_Agreement__c b : benagr) {
                    
                    Set<String> simpleProduct = new Set<String> ();
                    
                    if (accountBenMap.containsKey(b.Group_Account__c)) {
                        simpleProduct = accountBenMap.get(b.Group_Account__c);
                    }
                    
                    simpleProduct.add(b.Product__r.Simplified_Product__c);
                    accountBenMap.put(b.Group_Account__c, simpleProduct);
                }
                
                Map<String, List<Benefit_Agreement__c>> bagrMap = new Map<String, List<Benefit_Agreement__c>> ();
                
                for (Benefit_Agreement__c ben : benagr) {
                    
                    List<Benefit_Agreement__c> be = new List<Benefit_Agreement__c> ();
                    
                    if (bagrMap.containsKey(ben.Product__r.Simplified_Product__c)) {
                        be = bagrMap.get(ben.Product__r.Simplified_Product__c);
                    }
                    
                    be.add(ben);
                    bagrMap.put(ben.Product__r.Simplified_Product__c, be);
                }
                
                List<String> prods = new List<String> ();
                
                for (String b : bagrMap.keySet()) {
                    String product = bagrMap.get(b) [0].Product__r.Simplified_Product__c;
                    prods.add(product);
                }
                
                Map<String, List<Product2>> prodMap = new Map<String, List<Product2>> ();
                
                List<Product2> prod = new List<Product2> ();
                
                prod = [SELECT Id, Name FROM Product2 WHERE NotSimple__c = false AND Name IN :prods AND HCSC_State__c IN :statesToCheck];
                
                for (Product2 p : prod) {
                    List<Product2> Nprod = new List<Product2> ();
                    Nprod.add(p);
                    prodMap.put(p.Name, Nprod);
                }
                
                List<Opportunity_Product__c> newProductList = new List<Opportunity_Product__c> ();
                
                decimal memberCountACAP;
                decimal memberCountPREM;
                decimal memberCountASO;
                decimal memberCountCOST;
                decimal memberCountMPP;
                decimal memberCountPAR;
                decimal memberCountSERV;
                
                decimal memberCountACAPContracts;
                decimal memberCountPREMContracts;
                decimal memberCountASOContracts;
                decimal memberCountCOSTContracts;
                decimal memberCountMPPContracts;
                decimal memberCountPARContracts;
                decimal memberCountSERVContracts;
                
                for (Opportunity opps : opportunitiesToCheck) {
                    
                    for (String simpleProd : accountBenMap.get(opps.AccountId)) {
                        
                        Map<String, Set<String>> fundMap = new Map<String, Set<String>> ();
                        
                        List<Benefit_Agreement__c> ba = new List<Benefit_Agreement__c> ();
                        ba = bagrMap.get(simpleProd);
                        
                        memberCountACAP = 0;
                        memberCountPREM = 0;
                        memberCountASO = 0;
                        memberCountCOST = 0;
                        memberCountMPP = 0;
                        memberCountPAR = 0;
                        memberCountSERV = 0;
                        
                        memberCountACAPContracts = 0;
                        memberCountPREMContracts = 0;
                        memberCountASOContracts = 0;
                        memberCountCOSTContracts = 0;
                        memberCountMPPContracts = 0;
                        memberCountPARContracts = 0;
                        memberCountSERVContracts = 0;
                        
                        for (Benefit_Agreement__c ab : ba) {
                            
                            if (ab.Group_Account__c == opps.AccountId) {
                                
                                Set<String> fundType = new Set<String> ();
                                
                                if (fundMap.containsKey(ab.Product__r.Simplified_Product__c)) {
                                    fundType = fundMap.get(ab.Product__r.Simplified_Product__c);
                                }
                                
                                fundType.add(ab.Funding_Type__c);
                                fundMap.put(ab.Product__r.Simplified_Product__c, fundType);
                                
                                if (ab.Funding_Type__c == Label.ACAP) {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountACAP += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountACAPContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountACAP += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountACAPContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                } else if (ab.Funding_Type__c == Label.PREM) {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountPREM += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountPREMContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountPREM += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountPREMContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                } else if (ab.Funding_Type__c == Label.ASO) {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountASO += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountASOContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountASo += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountASOContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                } else if (ab.Funding_Type__c == Label.COST) {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountCOST += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountCOSTContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountCOST += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountCOSTContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                } else if (ab.Funding_Type__c == Label.MPP) {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountMPP += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountMPPContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountMPP += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountMPPContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                } else if (ab.Funding_Type__c == Label.PAR) {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountPAR += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountPARContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountPAR += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountPARContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                } else {
                                    for (BA_GS_Assignment__c bagsAgrrement : ab.BA_GS_Assignments__r) {
                                        
                                        if (ab.Product__r.Product_Type__c == Label.ProductTypeM) {
                                            if (bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c != null)
                                                memberCountSERV += bagsAgrrement.Group_Section__r.Total_Healthcare_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountSERVContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        } else if (ab.Product__r.Product_Type__c == Label.ProductTypeD) {
                                            if (bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c != null)
                                                memberCountSERV += bagsAgrrement.Group_Section__r.Total_Dental_Active_Members__c;
                                            if (bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c != null)
                                                memberCountSERVContracts += bagsAgrrement.Group_Section__r.Total_Active_Subscribers__c;
                                        }
                                    }
                                }
                            }
                        }
                        for (String f : fundMap.get(simpleProd)) {
                            
                            Opportunity_Product__c o = new Opportunity_Product__c();
                            o.State__c = opps.HCSC_Division__c;
                            o.Opportunity_Name__c = opps.Id;
                            o.RecordTypeId = renewalOppProdRecordTypeId; 
                            if (prodMap.get(simpleProd) == null) {
                                o.Product__c = bagrMap.get(simpleProd) [0].Product__c;
                            } else {
                                o.Product__c = prodMap.get(simpleProd) [0].Id;
                            }
                            if (f == Label.ACAP) {
                                o.Projected_Members__c = memberCountACAP;
                            } else if (f == Label.PREM) {
                                o.Projected_Members__c = memberCountPREM;
                            } else if (f == Label.ASO) {
                                o.Projected_Members__c = memberCountASO;
                            } else if (f == Label.COST) {
                                o.Projected_Members__c = memberCountCOST;
                            } else if (f == Label.MPP) {
                                o.Projected_Members__c = memberCountMPP;
                            } else if (f == Label.PAR) {
                                o.Projected_Members__c = memberCountPAR;
                            } else {
                                o.Projected_Members__c = memberCountSERV;
                            }
                            
                            if (f == Label.ACAP) {
                                o.Projected_Contracts__c = memberCountACAPContracts;
                            } else if (f == Label.PREM) {
                                o.Projected_Contracts__c = memberCountPREMContracts;
                            } else if (f == Label.ASO) {
                                o.Projected_Contracts__c = memberCountASOContracts;
                            } else if (f == Label.COST) {
                                o.Projected_Contracts__c = memberCountCOSTContracts;
                            } else if (f == Label.MPP) {
                                o.Projected_Contracts__c = memberCountMPPContracts;
                            } else if (f == Label.PAR) {
                                o.Projected_Contracts__c = memberCountPARContracts;
                            } else {
                                o.Projected_Contracts__c = memberCountSERVContracts;
                            }
                            
                            o.Status__c = Label.Progress;
                            o.Product_Type__c = Label.ProductTypeR;
                            o.Win_Probability__c = opps.Probability;
                            o.Funding_Type__c = f;
                            o.Premium_Type__c = bagrMap.get(simpleProd) [0].Premium_Type__c;
                            o.Upsell__c = Label.NoneP;
                            o.Category__c = bagrMap.get(simpleProd) [0].Product__r.Product_Type__c;
                            newProductList.add(o);
                            
                        }
                    }
                }
                
                if (newProductList.size() > 0) {
                    insert newProductList;
                }
            }
            
        } catch (Exception e) {
            System.debug(Label.Exception + e.getMessage());
        }
    }
    
    
    /**
* @developer: Ralph Tariga/Slalom LLC
* @description: Method to check if Opportunity's parent account has an Underwriter in Account Team
*               if not, an error is thrown
* @usage: Used in a before update trigger
*
*/
    public static void CheckAccountTeamForUnderwriter(List<Opportunity> opps, map<Id, Opportunity> newMap, map<Id, Opportunity> oldMap) {
        try {
            Set<Id> accIds = new Set<Id> ();
            List<RenewalOpportunityStages__c> stages = RenewalOpportunityStages__c.getAll().values();
            Set<String> stagesIncluded = new Set<String> ();
            for (RenewalOpportunityStages__c stage : stages) {
                stagesIncluded.add(stage.Stage_to_Check__c);
            }
            
            for (Opportunity opp : opps) {
                if (stagesIncluded.contains(opp.StageName) && oldMap.get(opp.Id).StageName != opp.StageName) {
                    accIds.add(opp.AccountId);
                }
            }
            
            if (accIds.size() > 0) {
                Set<Id> accUnderWriterExists = new Set<Id> ();
                Map<Id, Decimal> accMemberMap = new Map<Id, Decimal>();
                
                List<Account> accountsToCheck = [SELECT Active_Health_Subscribers__c FROM Account WHERE Id IN :accIds];
                
                for(Account accts : accountsToCheck){
                    accMemberMap.put(accts.Id, accts.Active_Health_Subscribers__c);
                }
                
                List<AccountTeamMember> accTMs = [SELECT TeamMemberRole, AccountId FROM AccountTeamMember WHERE AccountId IN :accIds AND TeamMemberRole = :Label.AccountUnderwriterRole];
                
                for (AccountTeamMember accTM : accTMs) {
                    accUnderWriterExists.add(accTM.AccountId);
                }
                
                for (Opportunity opp : opps) {
                    if (accUnderWriterExists.contains(opp.AccountId) == false && accMemberMap.get(opp.AccountId) > 150) {
                        newMap.get(opp.Id).addError(Label.OppNoAccountUnderwriterErrorMessage);
                        break;
                    }
                }
            }
        } catch(Exception e) {
            System.debug('Exception : ' + e.getMessage());
        }
    }
    
    /**
* @developer:   Alec Klein/Slalom LLC
* @description: Method to create "Producer Association for Opportunity" objects based on the "Producer Group Associations"
*                   that the Account has
* @usage:       Used in an after insert trigger
* @date:        4/25/2016
*/
    public static void CreateProducerAssociationForOpportunity(List<Opportunity> opps){
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
            if(producerGroupAssociations.size() > 1){
                for(Producer_Group_Association__c pga: producerGroupAssociations){
                    //SFDC-6461 added primary and End Date check :Padma Bedampeta - 10/20/2017  
                    if(pga.Group_Account__c != null && pga.Producer_Account__c != null && pga.Producer_Account__r.Status__c == 'Active' && pga.Primary__c == true && pga.End_Date__c == NULL){
                        paoList.add(new Producer_Association_For_Opportunity__c(Opportunity__c = opportunityAccountMap.get(pga.Group_Account__c), Producer_Consultant__c = pga.Producer_Account__c));
                    }
                }
            }
            //Else, add the Producer Account
            else{
                for(Producer_Group_Association__c pga: producerGroupAssociations){
                    //SFDC-6461 added primary check :Padma Bedampeta - 10/20/2017
                    if(pga.Group_Account__c != null && pga.Producer_Account__c != null && pga.Producer_Account__r.Status__c == 'Active' && pga.Primary__c == true){
                        paoList.add(new Producer_Association_For_Opportunity__c(Opportunity__c = opportunityAccountMap.get(pga.Group_Account__c), Producer_Consultant__c = pga.Producer_Account__c));
                    }
                }
            }
            //Only need to insert if there are PAOs to insert
            if(paoList.size() > 0){
                try{
                    insert paoList;
                } catch(DMLException e){
                    System.debug(e.getMessage());
                }
            }
        }
    }
    
    /**
* @author Alec Klein/Slalom
* @description: Assigns Forecast Segment based on criteria 
* @param oppNewMap The new opportunities to be updated
*/
    public static void populateForecastSegment(List<Opportunity> newOpps){
        try{
            if(newOpps != null){
                Set<String> forecastDistricts = new Set<String>();
                for(Forecast_Segment_District__c fsd: Forecast_Segment_District__c.getAll().values()){
                    forecastDistricts.add(fsd.District__c);
                }
                for(Opportunity currOpp: newOpps){
                    if(currOpp != null){
                        if(forecastDistricts.contains(currOpp.District__c)){
                            currOpp.Forecast_Segment__c = ConstantsController.opportunityForecastSegmentENA;
                        }
                        else if(currOpp.Account_Market_Segment__c == ConstantsController.opportunityMarketSegmentSG){
                            currOpp.Forecast_Segment__c = ConstantsController.opportunityForecastSegmentSmallGroup;
                        }
                        else if(currOpp.Account_Market_Segment__c == ConstantsController.opportunityMarketSegmentNAL || currOpp.Account_Market_Segment__c == ConstantsController.opportunityMarketSegmentHWB){
                            currOpp.Forecast_Segment__c = ConstantsController.opportunityForecastSegmentLabor;
                        }
                        else{
                            currOpp.Forecast_Segment__c = ConstantsController.opportunityForecastSegmentLargeGroup;
                        }
                    }
                }
            }
        } catch(Exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', 'OpportunityTrigger', 'OpportunityTriggerHelper.populateForecastSegment()', 'High');
        }
    }
    
    /**
* Updates Non_Admin_Last_Modified_Date__c to today's date when a User 
* that is not and Admin or Integration User updates the Opportunity
* 
* @param newOpps trigger.new list of new Opportunities coming in
*/
    public static void updateLastModifiedDate(List<Opportunity> newOpps){
        
        Id currUserProfileId = UserInfo.getProfileId();
        Profile currProfile = [SELECT Id, Name FROM Profile WHERE Id = :currUserProfileId];
        if (currProfile.Name != ConstantsController.systemAdministrator && currProfile.Name != ConstantsController.integrationProfile){
            for (Opportunity o : newOpps){
                o.Non_Admin_Last_Modified_Date__c = System.today();
            }
        }
    }
    
    /**
* @author               Sana Fatima/Slalom
* @description          Creates SharePoint Folders for Opportunities
* @param newOpps        newOpps from Trigger.new
*/
    public static void createSharePointFolder(List<Opportunity> newOpps) {
        try{ 
            if( !newOpps.isEmpty() ) {
                System.enqueueJob(new SharePointOpportunityManager( newOpps, new Map<Id, Opportunity>() ));
            }
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', 'OpportunityTrigger', 'OpportunitytTriggerHelper.createSharePointFolder()', 'High');
        }        
    }
    
    /**
* @author               Sana Fatima/Slalom
* @description          Updates SharePoint Folders for Opportunities
* @param newOpps        newOpps from Trigger.new, oldOpps from oldMap
*/
    public static void updateSharePointFolder(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps){
        try{
            List<Opportunity> modifiedOpps = new List<Opportunity>();
            for (Opportunity opp: newOpps) {
                if ( opp.Name != oldOpps.get(opp.Id).Name ) {
                    modifiedOpps.add( opp );
                }
            }
            if( !modifiedOpps.isEmpty() ) { 
                System.enqueueJob(new SharePointOpportunityManager( modifiedOpps, oldOpps ));
            }
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', 'OpportunityTrigger', 'OpportunityTriggerHelper.updateSharePointFolder()', 'High');
        }  
    }
    
    /**
* @author               Zachary Campbell/HCSC
* @description          Update Opportunity Products to Lost
* @param newOpps        newOpps from Trigger.new, oldOpps from oldMap
*/
    public static void updateLostOppProducts(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps){
        
        Set<Id> lostOpps = new Set<Id>();
        List<Opportunity_Product__c> lostOppProds = new List<Opportunity_Product__c>();
        
        for (Opportunity opp: newOpps) {
            
            if ((opp.StageName == 'Lost') && (oldOpps.get(opp.Id).StageName != 'Lost')) {
                lostOpps.add(opp.Id);
            }
        }
        
        if( !lostOpps.isEmpty() ) { 
            lostOppProds = [SELECT Id, Name, Opportunity_Name__c, Status__c, Account__c, Product__c, 
                            Winning_Carrier_Vendor__c
                            FROM    Opportunity_Product__c 
                            WHERE   Opportunity_Name__c = :lostOpps
                            AND     Status__c <> 'Lost'];
        }
        
        for (Opportunity_Product__c prods: lostOppProds) {
            prods.status__c = 'Lost';
        }
        update lostOppProds;
    }
    /**************************************************************************************

* @author               Rakesh Nunna
* @version              1.0
* @description          To create Opportunity Contact roles and add conact to account
* @param newOpps        newOpps from Trigger.new, oldOpps from oldMap
* created Date          4/1/2018

**************************************************************************************/
    // COMMENTED OUT PER MEETING ON 2018.05.15 TEST CLASS ERRORS FOR LIGHTNING PROJECT BEGIN
    public static void addOpportunityContactRoles(List<Opportunity> newOpp,Map<Id, Opportunity> olm){
        Boolean runCode = false;
        System.debug('==newOpp=='+newOpp);
        System.debug('==olm=='+olm);
        if(olm<>null){
            Set<Id> pcSet = new Set<Id>();
            for(Opportunity opp : olm.values()){
                pcSet.add(opp.Producer_Contact__c);    
            }
            
            for(Opportunity opt : newOpp){
                if(olm.containsKey(opt.Id)){
                    if(opt.Producer_Contact__c!=olm.get(opt.Id).Producer_Contact__c){
                        runCode = true; 
                    }
                    break;
                }
                else if(!pcSet.contains(opt.Producer_Contact__c)){
                    runCode = true;
                    break;
                }
                
            }
        }
        else{
            runCode = true;
        }
        if(runCode == true){
            System.debug('==Inside==');
            List<String> contactIds = new List<String>();
            set<String> selectedOpportunityRecordsSet = new set<string>();
            
            String recId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Producer Contact').getRecordTypeId();
            List<RecordType> opportunityRecordTypeList = [select Id,Name,DeveloperName from RecordType where SObjectType='Opportunity' and DeveloperName!='Renewal_Upsell'];
            for(RecordType recType:opportunityRecordTypeList){
                selectedOpportunityRecordsSet.add(recType.Id);
                
            }
            System.debug('==selectedOpportunityRecordsSet=='+selectedOpportunityRecordsSet);
            System.debug('=recId='+recId);
            Map<String,String> ContactOppMap = new Map<String,String>();
            Map<String,OpportunityContactRole> existingContactRolesMap = new Map<String,OpportunityContactRole>();
            Map<String,String> contactAccountMap = new Map<String,String>();
            
            //Get existing Opportunity Contact roles
            List<OpportunityContactRole> existingOppContactRoleList =[select Id,ContactId from OpportunityContactRole where OpportunityId IN:newOpp];
            if(existingOppContactRoleList!=null && existingOppContactRoleList.size()>0){
                for(OpportunityContactRole roles:existingOppContactRoleList){
                    existingContactRolesMap.put(roles.ContactId,roles);
                    
                }
            }
            System.debug('=existingContactRolesMap='+existingContactRolesMap);
            
            //Prepare Map With Current List of records
            for(Opportunity o:newOpp){
                //if(o.Producer_Contact__c!=oldOpps.get(o.Id).Producer_Contact__c){
                if(o.Producer_Contact__c!=null && selectedOpportunityRecordsSet.contains(o.RecordTypeId)){
                    System.debug('=Not null=');
                    // if (o.Producer_Contact__c != oldOpps.get(o.Id).Producer_Contact__c){
                    contactIds.add(o.Producer_Contact__c);
                    System.debug('==contactIds=='+contactIds);
                    ContactOppMap.put(o.Producer_Contact__c,o.Id);
                    contactAccountMap.put(o.Producer_Contact__c,o.AccountId);
                    // }
                    
                }
                // }
                
            }
            System.debug('==contactAccountMap=='+contactAccountMap);
            
            //List of contact for the record type Business solutions
            List<Contact> conList = [select Id,Buyer_Role__c,AccountId,RecordTypeId from Contact where Id IN:contactIds AND RecordTypeId =:recId];
            
            
            System.debug('==conList=='+conList);
            List<OpportunityContactRole> contactRole = new List<OpportunityContactRole>();
            if(conList!=null && conList.size()>0){
                for(Contact c:conList){
                    if(!existingContactRolesMap.keySet().Contains(c.Id)){
                        OpportunityContactRole ocr = new OpportunityContactRole();
                        ocr.OpportunityId = ContactOppMap.get(c.Id);
                        ocr.ContactId = c.Id;
                        ocr.IsPrimary = true;
                        ocr.Role='Producer';
                        contactRole.add(ocr);
                    }
                    else{
                        OpportunityContactRole conRole = existingContactRolesMap.get(c.Id); 
                        conRole.IsPrimary = true;
                        conRole.Role='Producer';
                        contactRole.add(conRole);   
                        
                    }
                }
            }
            if(contactRole.size()>0){
                upsert contactRole;
                
            }
            
            //Code to Add Contact to Account
            List<Contact> addContactToAccountList = new List<Contact>();
            System.debug('=contactAccountMap='+contactAccountMap);
            
            
            for(Contact c:conList){
                System.debug('=AccountId='+c.AccountId);
                
                
                if(c.AccountId!=null && c.AccountId!=contactAccountMap.get(c.Id)){
                    System.debug('=Inside existing=');
                    c.AccountId = contactAccountMap.get(c.Id);
                    addContactToAccountList.add(c);
                    
                    
                }
                else{
                    System.debug('=finally we are in else=');
                    c.AccountId = contactAccountMap.get(c.Id);
                    addContactToAccountList.add(c);
                    
                    
                }
                
            }
            System.debug('==addContactToAccountList=='+addContactToAccountList);
            if(addContactToAccountList.size()>0){
                update addContactToAccountList;
                
            }
            //Code to update the Account Contact relationship
            List<AccountContactRelation> acrListToUpdate = new List<AccountContactRelation>();
            Map<String,AccountContactRelation> ContactRelationMap = new Map<String,AccountContactRelation>();
            
            List<AccountContactRelation> acrList = [select Id,AccountId,ContactId,StartDate,Roles,IsActive from AccountContactRelation where ContactId IN:addContactToAccountList];
            System.debug('=acrList='+acrList);
            
            
            if(acrList != null && acrList.size()>0){
                for(AccountContactRelation acr:acrList){
                    
                    ContactRelationMap.put(acr.ContactId,acr);
                }
            }
            System.debug('=ContactRelationMap='+ContactRelationMap);
            if(addContactToAccountList.size()>0){
                for(Contact c:addContactToAccountList){
                    
                    AccountContactRelation acr = ContactRelationMap.get(c.Id);
                    acr.Roles = 'Producer Consultant';
                    acr.IsActive = true;
                    acr.StartDate = System.today();
                    acrListToUpdate.add(acr);
                    
                }
            }
            
            System.debug('=acrListToUpdate='+acrListToUpdate);
            if(acrListToUpdate.size()>0){
                update acrListToUpdate;
                
            }
        }
        
        //COMMENTED OUT PER MEETING ON 2018.05.15 TEST CLASS ERRORS FOR LIGHTNING PROJECT END
    }
}