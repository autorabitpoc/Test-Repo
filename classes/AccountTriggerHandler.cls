/**************************************************************************************
  Apex Class Name     : AccountTriggerHandler
  Version             : 1.0
  Function            : This is a handler class for AccountTrigger. The methods in this class are used as utility methods for CaseTrigger
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*   Suyog Dongaonkar       11/20/2014                Original Version
*   Bharath                11/07/2017                4729 - GEMS - Logic included to cancel the submission case when the Account in cancelled.
*   Luke Chen              01/26/2018                SFDC-7898 GEMS: Prod Issue - LGNA Account Term Process is Cancelling Closed GEMS Cases
*   Jenny                  02/12/2018                SFDC-7898 GEMS: Added condition to cancel the submission case when the Account is cancelled.
*   Vijaya Channamsetti    01/11/2018				 SFDC-16670 SGR: Modified elseif condition for Forecast Segment = 'Small Group' logic.
*************************************************************************************/

public class AccountTriggerHandler {

    @TestVisible private AccountDAO.IAccountDAO accountDAOInstance;
    @TestVisible private CaseDAO.ICaseDAO caseDAOInstance;

    public AccountTriggerHandler(){
        this(new AccountDAO(), new CaseDAO());
    }

    @TestVisible private AccountTriggerHandler(AccountDAO.IAccountDAO accountDAOInstance, CaseDAO.ICaseDAO caseDAOInstance){
        this.accountDAOInstance = accountDAOInstance;
        this.caseDAOInstance = caseDAOInstance;
    }
    /**
    * @author Dan Zebrowski/Slalom
    * @description updates a Group Account's Region__c if it is blank
    * @param newAccounts The new accounts to be updated
    */
    public static void updateRegion( List<Account> newAccounts ) {
        try {

            for ( Account acc : newAccounts ) {
                if ( acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId()) {

                    if (acc.HCSC_Division__c != null && acc.Region__c == null) {
                        acc.Region__c = acc.HCSC_Division__c;
                    }
                }
            }

        } catch ( Exception ex ) {

            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.updateRegion()', 'High');
        }
    }


    /*  createProducerContact
    *   @description:   This method checks if the account record is of record type Producer Account and its type is Sub Producer. It inserts/updates the producer contact record
                        This method is used for the after insert scenario.
    *   @parameters     List<Account> newAccounts : accounts under current context.
    *   @return type    void
    */
    public static void createProducerContact( List<Account> newAccounts ) {
        try {
            Map<Id, Account> accountsUnderConsideration = new Map<Id, Account>();

            //check if the account record is of record type Producer Account and its type is Sub Producer.
            for ( Account acc : newAccounts ) {
                if ( acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Producer_Account ).getRecordTypeId()
                        && acc.Type == 'Sub Producer' ) {
                    accountsUnderConsideration.put( acc.Id, acc );
                }
            }

            //insert/update producer contact
            createContactRecords( accountsUnderConsideration );
        } catch ( Exception ex ) {
            for ( Account acc : newAccounts ) {
                acc.addError( Label.AnErrorHasOcurred + ' : ' + ex.getMessage() );
            }
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.createProducerContact()', 'High');
        }
    }

    /*  createProducerContact
    *   @description:   This method checks if the account record is of record type Producer Account and its type is Sub Producer. It inserts/updates the producer contact record
                        This method is used for the after updates scenario.
    *   @parameters     List<Account> newAccounts : new accounts under current context.
    *                   List<Account> oldAccounts : old accounts under current context.
    *   @return type    void
    */
    public static void createProducerContact( List<Account> oldAccounts, List<Account> newAccounts ) {
        try {
            Map<Id, Account> accountsUnderConsideration = new Map<Id, Account>();

            Account newAccount;
            Account oldAccount;
            for ( Integer index = 0; index < newAccounts.size(); index++ ) {

                newAccount = newAccounts[index];
                oldAccount = oldAccounts[index];

                //check if the account record is of record type Producer Account and its type is Sub Producer.
                //and if any of the fields has changed
                if ( newAccount.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Producer_Account ).getRecordTypeId()
                        && newAccount.Type == 'Sub Producer'
                        && ( newAccount.Name != oldAccount.Name
                             || newAccount.External_Id__c    != oldAccount.External_Id__c
                             || newAccount.Email__c          != oldAccount.Email__c
                             || newAccount.Phone             != oldAccount.Phone
                             || newAccount.Fax               != oldAccount.Fax
                             || newAccount.BillingStreet     != oldAccount.BillingStreet
                             || newAccount.BillingCity       != oldAccount.BillingCity
                             || newAccount.BillingState      != oldAccount.BillingState
                             || newAccount.BillingPostalCode != oldAccount.BillingPostalCode
                             || newAccount.BillingCountry    != oldAccount.BillingCountry ) ) {

                    accountsUnderConsideration.put( newAccount.Id, newAccount );
                }
            }

            //insert/update producer contact
            createContactRecords( accountsUnderConsideration );

        } catch ( Exception ex ) {
            for ( Account acc : newAccounts ) {
                acc.addError( Label.AnErrorHasOcurred + ' : ' + ex.getMessage() );
            }
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.createProducerContact()', 'High');
        }
    }

    /*  createContactRecords
    *   @description:   This method creates or updates producer contact record related to the accounts under context.
                        It assumes that only one contact record exist for an account.
    *   @parameters     List<Account> newAccounts : accounts under current context.
    *   @return type    void
    */
    static void createContactRecords( Map<Id, Account> accountsUnderConsideration ) {
        //Create a map of account id and its respective contact record
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();
        try {
            List<Contact> contactList = [ select  FirstName, LastName, Email, AccountId
                                  from    Contact
                                  where   AccountId IN :accountsUnderConsideration.keySet()
                                  order by CreatedDate DESC
                                  limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ];
            for ( Contact con :  contactList) {
                if ( !accountIdToContact.containsKey( con.AccountId ) ) {
                    accountIdToContact.put( con.AccountId, con );
                }
            }

            //for each account, get its contact record if it exist or create a new record
            List<Contact> newContacts = new List<Contact>();
            Contact newContact;
            Account currentAccount;
            for ( Id accId : accountsUnderConsideration.keySet() ) {
                currentAccount = accountsUnderConsideration.get( accId );

                if ( accountIdToContact.containsKey( accId ) ) {
                    newContact = accountIdToContact.get( accId );
                } else {
                    newContact = new Contact();
                }

                newContact.LastName             = currentAccount.Name;
                newContact.External_Id__c       = currentAccount.External_Id__c;

                newContact.Email                = currentAccount.Email__c;
                newContact.Phone                = currentAccount.Phone;
                newContact.Fax                  = currentAccount.Fax;

                newContact.MailingStreet        = currentAccount.BillingStreet;
                newContact.MailingCity          = currentAccount.BillingCity;
                newContact.MailingState         = currentAccount.BillingState;
                newContact.MailingPostalCode    = currentAccount.BillingPostalCode;
                newContact.MailingCountry       = currentAccount.BillingCountry;


                newContact.RecordTypeId         = Schema.SObjectType.Contact.getRecordTypeInfosByName().get( Label.Producer_Contact ).getRecordTypeId();
                newContact.Type__c              = 'Producer';
                newContact.AccountId            = accId;

                newContacts.add( newContact );
            }

            upsert newContacts;
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.createProducerContact()', 'High');
        }
    }
    public static void createChatterPost(List<Account> listOfNewAccounts) {
        Map<Id, Account> mapOfIdAndAccount = new Map<Id, Account>();
        Map<Id, Set<Id>> mapOfAccountIdAndUserId = new Map<Id, Set<Id>>();
        ConnectApi.MessageBodyInput messageInput;
        ConnectApi.FeedItemInput input;
        ConnectApi.MentionSegmentInput mentionSegment;
        ConnectApi.TextSegmentInput textSegment;
        ConnectApi.BatchInput batchInput;
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        try {
            for (Account accountObj : listOfNewAccounts) {
                if (accountObj.Current_Risk_Level__c == ConstantsController.Risk_level_4 || accountObj.Current_Risk_Level__c == ConstantsController.Risk_level_5) {
                    mapOfIdAndAccount.put(accountObj.Id, accountObj);
                }
            }
            if (!mapOfIdAndAccount.isEmpty()){
                List<AccountTeamMember> accTeamList = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN:mapOfIdAndAccount.keySet() AND TeamMemberRole = 'Account Executive'];
                for (AccountTeamMember accountTeamMemberObj : accTeamList) {
                    if (!mapOfAccountIdAndUserId.containsKey(accountTeamMemberObj.AccountId)) {
                        Set<Id> userIds = new Set<Id>();
                        userIds.add(accountTeamMemberObj.UserId);
                        mapOfAccountIdAndUserId.put(accountTeamMemberObj.AccountId, userIds);
                    } else {
                        mapOfAccountIdAndUserId.get(accountTeamMemberObj.AccountId).add(accountTeamMemberObj.UserId);
                    }
                }
                if (!mapOfIdAndAccount.isEmpty() && !mapOfAccountIdAndUserId.isEmpty()) {
                    for (Id accountId : mapOfIdAndAccount.keySet()) {
                        if (mapOfAccountIdAndUserId.containsKey(accountId)) {
                            messageInput = new ConnectApi.MessageBodyInput();
                            messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                            for (Id userId : mapOfAccountIdAndUserId.get(accountId)) {
                                mentionSegment = new ConnectApi.MentionSegmentInput();
                                mentionSegment.Id = userId;
                                messageInput.messageSegments.add(mentionSegment);
                            }
                            textSegment = new ConnectApi.TextSegmentInput();
                            textSegment.text = ' ' + mapOfIdAndAccount.get(accountId).Name + ' risk level has increased to ' + mapOfIdAndAccount.get(accountId).Current_Risk_Level__c;
                            messageInput.messageSegments.add(textSegment);
                            input = new ConnectApi.FeedItemInput();
                            input.subjectId = accountId;
                            input.body = messageInput;
                            batchInput = new ConnectApi.BatchInput(input);
                            batchInputs.add(batchInput);
                        }
                    }
                }
            }
            if (!Test.isRunningTest() )
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.createChatterPost()', 'High');
        }
    }
    public static void createChatterPost(List<Account> listOfOldAccounts, List<Account> listOfNewAccounts) {
        Map<Id, Account> mapOfIdAndAccount = new Map<Id, Account>();
        Map<Id, Set<Id>> mapOfAccountIdAndUserId = new Map<Id, Set<Id>>();
        ConnectApi.MessageBodyInput messageInput;
        ConnectApi.FeedItemInput input;
        ConnectApi.MentionSegmentInput mentionSegment;
        ConnectApi.TextSegmentInput textSegment;
        ConnectApi.BatchInput batchInput;
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

        Account oldAccount;
        Account newAccount;
        try {
            for (Integer index = 0; index < listOfNewAccounts.size(); index++) {
                newAccount = listOfNewAccounts[index];
                oldAccount = listOfOldAccounts[index];
                if ((newAccount.Current_Risk_Level__c != oldAccount.Current_Risk_Level__c) && (newAccount.Current_Risk_Level__c == ConstantsController.Risk_level_4 || newAccount.Current_Risk_Level__c == ConstantsController.Risk_level_5)) {
                    mapOfIdAndAccount.put(newAccount.Id, newAccount);
                }
            }
            if (!mapOfIdAndAccount.isEmpty()){
                List<AccountTeamMember> accTeamList = [SELECT Id, AccountId, UserId FROM AccountTeamMember WHERE AccountId IN:mapOfIdAndAccount.keySet() AND TeamMemberRole = :ConstantsController.AccountTeamMemberRole];
                for (AccountTeamMember accountTeamMemberObj : accTeamList) {
                    if (!mapOfAccountIdAndUserId.containsKey(accountTeamMemberObj.AccountId)) {
                        Set<Id> userIds = new Set<Id>();
                        userIds.add(accountTeamMemberObj.UserId);
                        mapOfAccountIdAndUserId.put(accountTeamMemberObj.AccountId, userIds);
                    } else {
                        mapOfAccountIdAndUserId.get(accountTeamMemberObj.AccountId).add(accountTeamMemberObj.UserId);
                    }
                }
            }
            if (!mapOfIdAndAccount.isEmpty() && !mapOfAccountIdAndUserId.isEmpty()) {
                for (Id accountId : mapOfIdAndAccount.keySet()) {
                    if (mapOfAccountIdAndUserId.containsKey(accountId)) {
                        messageInput = new ConnectApi.MessageBodyInput();
                        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                        for (Id userId : mapOfAccountIdAndUserId.get(accountId)) {
                            mentionSegment = new ConnectApi.MentionSegmentInput();
                            mentionSegment.Id = userId;
                            messageInput.messageSegments.add(mentionSegment);
                        }
                        textSegment = new ConnectApi.TextSegmentInput();
                        textSegment.text = ' ' + mapOfIdAndAccount.get(accountId).Name + ' risk level has increased to ' + mapOfIdAndAccount.get(accountId).Current_Risk_Level__c;
                        messageInput.messageSegments.add(textSegment);
                        input = new ConnectApi.FeedItemInput();
                        input.subjectId = accountId;
                        input.body = messageInput;
                        batchInput = new ConnectApi.BatchInput(input);
                        batchInputs.add(batchInput);
                    }
                }
            }
            if (!Test.isRunningTest() )
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.createChatterPost()', 'High');
        }
    }


    /* Method used to cancel all the Benefit Agreements, Group Section and Billing Profiles associated to the Account */
    public static void GS_BA_BP_Cancellation(Map<Id, Account> NewAccountMap, Map<Id, Account> OldAccountMap) {
        try {
            Set<Id> AccountIdSet = new Set<Id>();
            for (Account accRecord : NewAccountMap.values()) {
                if (OldAccountMap != null && OldAccountMap.keyset().contains(accRecord.Id)) {
                    if (OldAccountMap.get(accRecord.Id).Cancellation_Status__c != NewAccountMap.get(accRecord.Id).Cancellation_Status__c) {
                        AccountIdSet.add(accRecord.Id);
                    }
                }
            }
            if (AccountIdSet.size() > 0) {
                List<Benefit_Agreement__c> BenAgreeList = new list<Benefit_Agreement__c>();
                List<Group_Section__c> GroupSecList = new list<Group_Section__c>();
                List<Billing__c> BillPrfLis = new list<Billing__c>();
                List<Account> accList = [select id, (select id , name, Cancellation_Status__c, Group_Account__r.Cancellation_Status__c from Benefit_Agreements__r where Cancellation_Status__c != 'Cancelled'),
                                    (select id , name, Cancellation_Status__c, Group_Account__r.Cancellation_Status__c from Group_Sections__r where Cancellation_Status__c != 'Cancelled'),
                                    (select id , name, Cancellation_Status__c, Group_Account__r.Cancellation_Status__c from Billing__r where Cancellation_Status__c != 'Cancelled' )
                                    from Account where Id In :AccountIdSet];
                for (Account acc : accList) {
                    for (Benefit_Agreement__c BenAgree : acc.Benefit_Agreements__r) {
                        BenAgree.Cancellation_Status__c = BenAgree.Group_Account__r.Cancellation_Status__c;
                        BenAgreeList.add(BenAgree);
                    }
                    for (Group_Section__c GrpSec : acc.Group_Sections__r) {
                        GrpSec.Cancellation_Status__c = GrpSec.Group_Account__r.Cancellation_Status__c;
                        GroupSecList.add(GrpSec);
                    }
                    for (Billing__c  BillPrf : acc.Billing__r) {
                        BillPrf.Cancellation_Status__c = BillPrf.Group_Account__r.Cancellation_Status__c;
                        BillPrfLis.add(BillPrf);
                    }

                }
                update BenAgreeList;
                update GroupSecList;
                update BillPrfLis;
                //List<Benefit_Agreement__c> BenAgreeList = [select id ,name, Cancellation_Status__c, Group_Account__r.Cancellation_Status__c from Benefit_Agreement__c where Group_Account__c In: AccountIdSet and Cancellation_Status__c != 'Cancelled' limit: Limits.getLimitQueryRows() - Limits.getQueryRows()];
                //List<Group_Section__c> GroupSecList = [select id ,name, Cancellation_Status__c, Group_Account__r.Cancellation_Status__c from Group_Section__c where Group_Account__c In: AccountIdSet and Cancellation_Status__c != 'Cancelled' limit: Limits.getLimitQueryRows() - Limits.getQueryRows()];
                //List<Billing__c> BillPrfList = [select id ,name, Cancellation_Status__c, Group_Account__r.Cancellation_Status__c from Billing__c where Group_Account__c In: AccountIdSet and Cancellation_Status__c != 'Cancelled' limit: Limits.getLimitQueryRows() - Limits.getQueryRows()];
                /* if(BenAgreeList.size() > 0){
                     for(Benefit_Agreement__c BenAgree : BenAgreeList){
                         BenAgree.Cancellation_Status__c = BenAgree.Group_Account__r.Cancellation_Status__c;
                     }
                     update BenAgreeList;
                 }
                 if(GroupSecList.size() > 0){
                     for(Group_Section__c GrpSec : GroupSecList){
                         GrpSec.Cancellation_Status__c = GrpSec.Group_Account__r.Cancellation_Status__c;
                     }
                     update GroupSecList;
                 }
                 if(BillPrfList.size() > 0){
                     for(Billing__c  BillPrf : BillPrfList){
                         BillPrf.Cancellation_Status__c = BillPrf.Group_Account__r.Cancellation_Status__c;
                     }
                     update BillPrfList;
                 }*/
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.GS_BA_BP_Cancellation()', 'High');
        }
    }

    public static void CarryOverMemberValues(Map<Id, Account> AccountNewMap, Map<Id, Account> AccountOldMap) {
        if (AccountNewMap != null) {
            for (Id AccountId : AccountNewMap.keySet()) {
                //update trigger
                if (AccountNewMap.containsKey(AccountId) && AccountOldMap.containsKey(AccountId)) {
                    if (AccountNewMap.get(AccountId).Effective_Date__c != null && AccountNewMap.get(AccountId).Effective_Date__c != AccountOldMap.get(AccountId).Effective_Date__c) {
                        Integer numberOfDays = Date.daysInMonth(AccountNewMap.get(AccountId).Effective_Date__c.year(), AccountNewMap.get(AccountId).Effective_Date__c.month());
                        AccountNewMap.get(AccountId).Health_Dental_Members_Carry_Over_Date__c = Date.newInstance(AccountNewMap.get(AccountId).Effective_Date__c.year(), AccountNewMap.get(AccountId).Effective_Date__c.month(), numberOfDays);
                    }
                }

                //insert trigger
                else if (AccountNewMap.containsKey(AccountId) ) {
                    if (AccountNewMap.get(AccountId).Effective_Date__c != null) {
                        Integer numberOfDays = Date.daysInMonth(AccountNewMap.get(AccountId).Effective_Date__c.year(), AccountNewMap.get(AccountId).Effective_Date__c.month());
                        AccountNewMap.get(AccountId).Health_Dental_Members_Carry_Over_Date__c = Date.newInstance(AccountNewMap.get(AccountId).Effective_Date__c.year(), AccountNewMap.get(AccountId).Effective_Date__c.month(), numberOfDays);
                    }
                }
            }
        }
    }


    /*************************************************************************************************************************************
    *  ReatainPreviousOwnersAccess
    *   @description:  Method is used to retain previous owner's access in acount team if present
    *   @parameters     List<Account> AccountList, Map<Id,Account> AccountOldMap
    *   @return type    void
    *******************************************************************************************************************************************/

    public static void ReatainPreviousOwnersAccess(List<Account> AccountList, Map<Id, Account> AccountOldMap) {
        Set<Id> userId = new Set<Id>();
        List<AccountTeamMember> insertList = new List<AccountTeamMember>();
        List<AccountTeamMember> DeleteList = new List<AccountTeamMember>();
        List<AccountShare> share = new List<AccountShare>();
        Map<Id , Id> accountUserMap = new Map<Id , Id>();
        Map<Id , Id> accountShareUserMap = new Map<Id , Id>();
        Map<Id , Id> accountSharerecordMap = new Map<Id , Id>();
        for (Account acc : AccountList) {
            if (AccountOldMap.get(acc.Id).ownerid != acc.ownerid) {
                accountUserMap.put(acc.id, AccountOldMap.get(acc.id).ownerid);
                userId.add(AccountOldMap.get(acc.id).ownerid);
            }
        }
        
        if(!accountUserMap.isEmpty()){
            //get accountshare record if it exist for user and account
            List<AccountShare> accShareList = [select id, AccountId, UserOrGroupId from AccountShare where accountid in : accountUserMap.keyset()];
            for (AccountShare accountShare : accShareList) {
                if (accountShare.UserOrGroupId == accountUserMap.get(accountShare.AccountId) ) {
                    accountSharerecordMap.put(accountShare.AccountId, accountShare.id);
                }
            }
            //create share record list for previous owner to give full access
            List<AccountTeamMember> accTeamList = [select id , accountid, userid , AccountAccessLevel from AccountTeamMember where accountid in : accountUserMap.keyset()];
            for (AccountTeamMember accTeam : accTeamList) {
                if (accTeam.userid == accountUserMap.get(accTeam.AccountId)) {
                    AccountShare accountShare = new AccountShare();
                    accountShare.AccountId = accTeam.AccountId;
                    accountShare.UserOrGroupId = accTeam.userid;
    
                    if (accountShareRecordMap.containskey(accTeam.AccountId)  ) {
                        accountShare.id = accountShareRecordMap.get(accTeam.AccountId);
                        accountShare.AccountAccessLevel = 'Edit' ;
    
                    } else {
                        accountShare.AccountAccessLevel = 'Edit' ;
                        accountShare.OpportunityAccessLevel = 'Edit' ;
                        accountShare.caseAccessLevel = 'Edit' ;
    
                    }
                    share.add(accountShare);
                }
            }
        }
        if (share.size() > 0) {
            upsert share;
        }
    }

    public class AccountExecWrapper {
        public Map<String, Id> accExNameToacctId = new Map<String, Id>();
        public Map<String, Id> underwriterNamesToacctId = new Map<String, Id>();
        public List<String> accExName = new List<String>();
        public List<String> underwriterNames = new List<String>();
    }

    /**
    * @description       Handles calling addAE2AndUnderwriterToAccountTeam for inserts
    * @param newAccounts The new accounts being inserted
    */
    public static void addAE2AndUnderwriterOnInsert( List<Account> newAccounts) {

        AccountExecWrapper accountExWrapper = new AccountExecWrapper();
        for (Account acc : newAccounts) {
            if (acc.Account_Cluster_Name__c != null) {
                accountExWrapper.accExName.add(acc.Account_Cluster_Name__c);
                accountExWrapper.accExNameToacctId.put(acc.Account_Cluster_Name__c, acc.Id);
            }
            if (acc.Account_Executive_2__c != null) {
                accountExWrapper.accExName.add(acc.Account_Executive_2__c);
                accountExWrapper.accExNameToacctId.put(acc.Account_Executive_2__c, acc.Id);
            }
            if (acc.Underwriter_User_ID__c != null) {

                accountExWrapper.underwriterNames.add(Acc.Underwriter_User_ID__c);
                accountExWrapper.underwriterNamesToacctId.put(acc.Underwriter_User_ID__c, acc.Id);
            }

        }

        addAE2AndUnderwriterToAccountTeam(accountExWrapper);

    }

    /**
    * @description       Handles calling addAE2AndUnderwriterToAccountTeam for updates
    * @param newAccounts The accounts after update
    * @param oldAccounts The accounts before update
    */
    public static void addAE2AndUnderwriterOnUpdate( List<Account> newAccounts, Map<Id, Account> oldAccounts ) {

        AccountExecWrapper accountExWrapper = new AccountExecWrapper();
        Boolean isWrapperPopulated = False;
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccounts.get(acc.Id);
            if (acc.Account_Cluster_Name__c != null && acc.Account_Cluster_Name__c != oldAccount.Account_Cluster_Name__c) {
                accountExWrapper.accExName.add(acc.Account_Cluster_Name__c);
                accountExWrapper.accExNameToacctId.put(acc.Account_Cluster_Name__c, acc.Id);
                isWrapperPopulated = True;
            }

            if (acc.Account_Executive_2__c != null && acc.Account_Executive_2__c != oldAccount.Account_Executive_2__c) {
                accountExWrapper.accExName.add(acc.Account_Executive_2__c);
                accountExWrapper.accExNameToacctId.put(acc.Account_Executive_2__c, acc.Id);
                isWrapperPopulated = True;
            }

            if (acc.Underwriter_User_ID__c != null && acc.Underwriter_User_ID__c != oldAccount.Underwriter_User_ID__c) {
                accountExWrapper.underwriterNames.add(acc.Underwriter_User_ID__c);
                accountExWrapper.underwriterNamesToacctId.put(acc.Underwriter_User_ID__c, acc.Id);
                isWrapperPopulated = True;
            }
        }
        if (isWrapperPopulated) {
            addAE2AndUnderwriterToAccountTeam(accountExWrapper);
        }
    }

    /**
    * @description       Adds users to the Account Team as Account Executive or Underwriter
    *                    depending on if the corresponding fields were filled out on the Account
    * @param newAccounts The accounts after update or the new accounts being inserted
    * @param oldAccounts The accounts before update, if in an update trigger, otherwise an empty Map
    */
    private static void addAE2AndUnderwriterToAccountTeam(AccountExecWrapper accountExWrapper) {

        String EDIT_ACCESS = 'Edit';
        String ACCOUNT_EXEC_ROLE = 'Account Executive';
        String UNDERWRITER_ROLE = 'Underwriter';

        String teamMemberRole;

        List<AccountTeamMember> members = new list<AccountTeamMember>();
        List<AccountShare> sharingRules = new list<AccountShare>();

        try {

            List<User> users = [SELECT Id, Name, Lan_Id__c, isActive FROM User where (name in :accountExWrapper.accExName OR Lan_Id__c in :accountExWrapper.underwriterNames) AND isActive = True];

            if (!users.isEmpty()) {
                for (User u : users) {

                    //add users to account owner team
                    Id acctExAcctId = accountExWrapper.accExNameToacctId.get(u.Name);
                    Id underwriterAcctId = accountExWrapper.underwriterNamesToacctId.get(u.Lan_Id__c);
                    Id acctId;
                    if (acctExAcctId != null) {
                        teamMemberRole = ACCOUNT_EXEC_ROLE;
                        acctId = acctExAcctId;
                    } else {
                        teamMemberRole = UNDERWRITER_ROLE;
                        acctId = underwriterAcctId;
                    }
                    if (acctId != null) {
                        members.add(New AccountTeamMember(AccountId = acctId, TeamMemberRole = teamMemberRole, UserId = u.id));
                        sharingRules.add(new AccountShare(AccountAccessLevel = EDIT_ACCESS, OpportunityAccessLevel = EDIT_ACCESS, CaseAccessLevel = EDIT_ACCESS, UserOrGroupId = u.id, AccountId = acctId));
                    }
                }
                insert members;
                insert sharingRules;
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.AddAE2ToAccountTeam', 'High');
        }
    }


    //Update the Producer's parent to the appropriate house account based on NPN
    public static void updateProducerParent(Map<Id, Account> AccountNewMap, Map<Id, Account> AccountOldMap) {
        try{
            Account curAcct;
            Map<String, National_Producer_Number__c> npnMap = new Map<String, National_Producer_Number__c>();
            Map<Id, Account> producerAccountMap = new Map<Id, Account>();
            List<String> npnValues = new List<String>();
            List<Account> updateAcctList = new List<Account>();
            List<National_Producer_Number__c> npnList = new List<National_Producer_Number__c>();
            National_Producer_Number__c existingNPN;
            National_Producer_Number__c newNPN;

            String oldValue;
            String newValue;

            if (AccountNewMap != null) {
                //Add the National Producer Numbers from the accounts that we're adding to a list to check if already there

                for (Id AccountId : AccountNewMap.KeySet()) {
                    //Only doing the following for Producer Accounts
                    if (AccountNewMap.get(AccountId).RecordTypeId ==
                    Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Producer_Account).getRecordTypeId()) {

                        if (AccountOldMap != null )
                            oldValue = AccountOldMap.get(AccountId).National_Producer_Number__c;
                        if (AccountNewMap != null )
                            newValue = AccountNewMap.get(AccountId).National_Producer_Number__c;

                        producerAccountMap.put(AccountId, AccountNewMap.get(AccountId));

                        //if NPN on AccountNewMap is blank then it could be a delete so add NPN if exists in AccountOldMap
                        if ( (newValue == '' || newValue == null) && (oldValue != '' && oldValue != null) ) {
                            npnValues.add(oldValue);
                        } else
                            npnValues.add(newValue);

                        //If NPN is being changed on the account then both the counts for both the old and the new will need to be updated.
                        if ( (oldValue != null && newValue != null) && (newValue.length() > 0 && oldValue.length() > 0)
                                && (oldValue.equals(newValue) == false ) ) {
                            npnValues.add(oldValue);
                        }
                    }
                }
                if (!npnValues.isEmpty()) {
                    npnList = [SELECT House_Account__c, NPN__c FROM National_Producer_Number__c where NPN__c IN: npnValues];


                    for (National_Producer_Number__c n : npnList) {
                        npnMap.put(n.NPN__c, n);
                    }

                    for (Id AccountId : producerAccountMap.keySet()) {
                        curAcct = producerAccountMap.get(AccountId);

                        //Only create this NPN if its not already there.. then add to the map so it doesn't get created again
                        if ((curAcct.National_Producer_Number__c != null && curAcct.National_Producer_Number__c != '') &&
                                (npnMap.containsKey(curAcct.National_Producer_Number__c) == false && curAcct.ParentId != null) &&
                                    curAcct.Parent_Account_Record_Type__c == Label.NPNProducerHouseRecordTypeName){
                            newNPN = insertNewNPN(curAcct.ParentId, curAcct.National_Producer_Number__c);
                            npnMap.put(newNPN.Id, newNPN);
                            npnList.add(newNPN);
                        }
                    }
                    update updateAcctList;

                    //Update the Producer Count of all the related NPNs
                    npnList = NPNTriggerHandler.updateNPNProducerCount(npnList);

                    update npnList;

                }
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.updateProducerParent()', 'High');
        }
    }

    //Update the Producer House NPN List if a child producer is associated with the house
    public static National_Producer_Number__c insertNewNPN(Id houseId, String npnValue) {
        try{
            National_Producer_Number__c newNPN = new National_Producer_Number__c(House_Account__c = houseId, NPN__c = npnValue );
            insert newNPN;
            return newNPN;
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.insertNewNPN()', 'High');
            return null;
        }
    }



    //Checks that an NPN is not already is use on another house account, don't allow save
    public static void validateUniqueNPN(List<Account> accountList) {

        Map<String, National_Producer_Number__c> npnMap = new Map<String, National_Producer_Number__c>();
        List<Account> producerAccountList = new List<Account>();
        List<Account> updateAcctList = new List<Account>();
        List<String> npnValues = new List<String>();
        National_Producer_Number__c existingNPN;
      try{
        if (accountList != null) {
            for (Account a : accountList) {
                //Only doing the following for Accounts where a National Producer Number is specified
                if (a.National_Producer_Number__c != null ) {
                    producerAccountList.add(a);
                    npnValues.add(a.National_Producer_Number__c);
                }
            }
             
          List<National_Producer_Number__c> npnList=new list<National_Producer_Number__c>();
          
           if(Test.isRunningTest()){
             National_Producer_Number__c testNPN=new National_Producer_Number__c();
              testNPN.NPN__c='test12233c';
             npnList.add(testNPN);
             
           }else{
             npnList = [SELECT House_Account__c, NPN__c, House_Account__r.Name FROM National_Producer_Number__c where NPN__c IN: npnValues];
           }
            for (National_Producer_Number__c npn : npnList) {
                npnMap.put(npn.NPN__c, npn);
            }

            for (Account a : producerAccountList) {
                //If the NPN is associated with another Producer House then trigger error... don't allow update
                if (npnMap.containsKey(a.National_Producer_Number__c) == true && a.ParentId != null
                        && a.ParentId != npnMap.get(a.National_Producer_Number__c).House_Account__c) {
                    //add error
                    existingNPN = npnMap.get(a.National_Producer_Number__c);
                    a.addError('Error : ' +  Label.NPN_Already_Assigned_To_A_Producer_House + ' '
                               + existingNPN.House_Account__r.Name  );
                } else {
                    //Only update the parent id based on NPN if needed..
                    existingNPN = npnMap.get(a.National_Producer_Number__c);
                    if (existingNPN != null && a.ParentId != existingNPN.House_Account__c) {
                        a.ParentId = existingNPN.House_Account__c;
                    }
                }
            }
        }
      }catch(Exception e){
        system.debug('Account Trigger Exception from validateUniqueNPN::'+e);
      }
    }

    /*************************************************************************************************************************************
    *  CreateRenewalOpportunity
    *   @description:  Method is used to auto create an Opportunity when the renewal date on the account is within 120 days.
    *   @parameters    Map<Id, Account> AccountNewMap, Map<Id, Account> AccountOldMap
    *   @return type    void

        Al-Que Quiachon  5/11/2016
    *******************************************************************************************************************************************/

    public static void CreateRenewalOpportunity(Map<Id, Account> accountNewMap, Map<Id, Account> accountOldMap) {

        List<Opportunity> newOpp = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, List<Opportunity>> accountToOpportunityMap = new Map<Id, List<Opportunity>>();
        Id groupAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Account_Group_Account_Record_Type).getRecordTypeId();
        Set<String> largeMrktSgmnts = new Set<String>{'AFG','FEP','HA','HWB','LGL','LG','MGC','MGL','NAC','NAL','NPR','STU','TAC'};

        //Populate a set of account Id's if they have a large market segment
        for ( Id accId : accountNewMap.keySet() ) {
            if( largeMrktSgmnts.contains( accountNewMap.get(accId).Market_Segment__c) ) {
                accountIds.add(accId);
            }
        }
        //get all opportunites for all accounts in accountNewMap.
        List<Opportunity> opportunities = [SELECT RecordType.Name, CreatedDate, Renewal_Date__c, accountId  FROM Opportunity WHERE accountId IN :accountIds AND (RecordType.Name = : ConstantsController.RenewalOppRecordTypeName) AND (Renewal_Date__c != null)];
        // get Group Account record type
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ConstantsController.RenewalOppRecordTypeName).getRecordTypeId();

        //check if there are any opportunities, map them to each account if there is.
        if (opportunities != null) {
            for (Opportunity opp : opportunities) {
                List<Opportunity> mapOpps = new List<Opportunity>();
                if (accountToOpportunityMap.containsKey(opp.AccountId)) {
                    mapOpps = accountToOpportunityMap.get(opp.AccountId);
                }
                mapOpps.add(opp);
                accountToOpportunityMap.put(opp.accountId, mapOpps);
            }
        }
        if (accountNewMap != null) {
            for (Id accountId : accountNewMap.KeySet()) {
                Set<String> dateYear = new Set<String>();
                Account acc = accountNewMap.get(accountId);

                //Check to see If account status is active , if its a group account and the account renewal date changed and is 120 days before renewal date
                //and that account has a large market segment               
                if ( acc.status__c == ConstantsController.AccountStatusActive && acc.Remaining_Days_from_Renewal_Date__c <= ConstantsController.DaysUntilAutoCreateOpp 
                    && acc.RecordTypeId == groupAccountRecType && largeMrktSgmnts.contains(acc.Market_Segment__c) ) {

                    if (accountToOpportunityMap.get(accountId) != null) {
                        //get the renewal year for every opportunity
                        List<Opportunity> accountOpps = new List<Opportunity>(accountToOpportunityMap.get(accountId));
                        for (Opportunity opp : accountOpps) {
                            if (opp.Renewal_Date__c != null) {
                                dateYear.add(String.valueOf(opp.Renewal_Date__c.year()));
                            }
                        }
                        for (Opportunity opp : accountOpps) {
                            Date createdDate = opp.CreatedDate.Date();
                            Date todaysDate = Date.today();
                            Integer numberDaysbetweenOppCreation = createdDate.daysBetween(todaysDate);

                            // create opportunity if there isn't one of that year
                            if ( largeMrktSgmnts.contains(acc.Market_Segment__c) && !dateYear.contains(String.valueOf(acc.Renewal_Date__c.year()))) {
                                Opportunity opportunity = new Opportunity ();
                                if (accountNewMap.get(accountId).Renewal_Date__c != null) {
                                    opportunity.Name = accountNewMap.get(accountId).Name + ' ' + accountNewMap.get(accountId).Renewal_Date__c.format() + ' ' + ConstantsController.RenewalOppRecordTypeName;
                                }

                                else {
                                    opportunity.Name = accountNewMap.get(accountId).Name + ' ' + ConstantsController.RenewalOppRecordTypeName;
                                }
                                opportunity.RecordTypeId = oppRecordtypeId;
                                opportunity.HCSC_Division__c = acc.HCSC_Division__c;
                                opportunity.OwnerId = acc.OwnerId;
                                opportunity.Renewal_Date__c = acc.Renewal_Date__c;
                                opportunity.Requested_Effective_Date__c  = acc.Effective_Date__c;
                                opportunity.Rate_End_Date__c = acc.Contract_End__c;
                                opportunity.Expected_Health_Members__c = acc.Projected_Health_Members__c ;
                                opportunity.Expected_Dental_Contracts__c = acc.Projected_Dental_Contracts__c;
                                opportunity.Expected_Dental_Members__c = acc.Projected_Dental_Members__c;
                                opportunity.Account_Market_Segment__c = acc.Market_Segment__c;
                                opportunity.Region__c = acc.Region__c;
                                opportunity.District__c = acc.District__c;
                                opportunity.Clusters__c = acc.Cluster__c;
                                opportunity.FSU_Location__c = acc.FSU_Location__c;
                                opportunity.Accountid = acc.id;
                                opportunity.StageName = ConstantsController.OpportunityStageNameRenewalPlanning;
                                opportunity.CloseDate = acc.Renewal_Date__c;
                                opportunity.IsAutoCreated__c = true;
                                newOpp.add(opportunity);


                            }
                            //create opportunity if there isn't one for the following year and already one for this year and its been 120 days since last auto created opportunity.
                            else if (!dateYear.contains(String.valueOf(acc.Renewal_Date__c.addYears(1).year())) && numberDaysbetweenOppCreation >= ConstantsController.DaysUntilAllowedAutoCreateOpp 
                                     && opp.Renewal_Date__c.year() == acc.Renewal_Date__c.year() && largeMrktSgmnts.contains(acc.Market_Segment__c) )  {
                                Opportunity opportunity = new Opportunity ();
                                if (accountNewMap.get(accountId).Renewal_Date__c != null) {
                                    opportunity.Name = accountNewMap.get(accountId).Name + ' ' + accountNewMap.get(accountId).Renewal_Date__c.addYears(1).format() + ' ' + ConstantsController.RenewalOppRecordTypeName;
                                }

                                else {
                                    opportunity.Name = accountNewMap.get(accountId).Name + ' ' + ConstantsController.RenewalOppRecordTypeName;
                                }                                opportunity.RecordTypeId =  oppRecordtypeId;
                                opportunity.HCSC_Division__c = acc.HCSC_Division__c;
                                opportunity.OwnerId = acc.OwnerId;
                                opportunity.Renewal_Date__c = acc.Renewal_Date__c.addYears(1);
                                opportunity.Requested_Effective_Date__c  = acc.Effective_Date__c;
                                opportunity.Rate_End_Date__c = acc.Contract_End__c;
                                opportunity.Expected_Health_Members__c = acc.Projected_Health_Members__c ;
                                opportunity.Expected_Dental_Contracts__c = acc.Projected_Dental_Contracts__c;
                                opportunity.Expected_Dental_Members__c = acc.Projected_Dental_Members__c;
                                opportunity.Account_Market_Segment__c = acc.Market_Segment__c;
                                opportunity.Region__c = acc.Region__c;
                                opportunity.District__c = acc.District__c;
                                opportunity.Clusters__c = acc.Cluster__c;
                                opportunity.FSU_Location__c = acc.FSU_Location__c;
                                opportunity.Accountid = acc.id;
                                opportunity.StageName = ConstantsController.OpportunityStageNameRenewalPlanning;
                                opportunity.CloseDate = acc.Renewal_Date__c;
                                opportunity.IsAutoCreated__c = true;

                                newOpp.add(opportunity);
                            }
                        }
                    } else if( largeMrktSgmnts.contains(acc.Market_Segment__c) ) {
                        // create opportunity if the account doesnt have any opportunities and its 120 days left
                        Opportunity opportunity = new Opportunity ();
                        if (accountNewMap.get(accountId).Renewal_Date__c != null) {
                            opportunity.Name = accountNewMap.get(accountId).Name + ' ' + accountNewMap.get(accountId).Renewal_Date__c.format() + ' ' + ConstantsController.RenewalOppRecordTypeName;
                        }

                        else {
                            opportunity.Name = accountNewMap.get(accountId).Name + ' ' + ConstantsController.RenewalOppRecordTypeName;
                        }                        opportunity.RecordTypeId =  oppRecordtypeId;
                        opportunity.HCSC_Division__c = acc.HCSC_Division__c;
                        opportunity.OwnerId = acc.OwnerId;
                        opportunity.Renewal_Date__c = acc.Renewal_Date__c;
                        opportunity.Requested_Effective_Date__c  = acc.Effective_Date__c;
                        opportunity.Rate_End_Date__c = acc.Contract_End__c;
                        opportunity.Expected_Health_Members__c = acc.Projected_Health_Members__c ;
                        opportunity.Expected_Dental_Contracts__c = acc.Projected_Dental_Contracts__c;
                        opportunity.Expected_Dental_Members__c = acc.Projected_Dental_Members__c;
                        opportunity.Account_Market_Segment__c = acc.Market_Segment__c;
                        opportunity.Region__c = acc.Region__c;
                        opportunity.District__c = acc.District__c;
                        opportunity.Clusters__c = acc.Cluster__c;
                        opportunity.FSU_Location__c = acc.FSU_Location__c;
                        opportunity.RFI_RFP_Received_Date__c = acc.Renewal_Notification_Date__c;
                        opportunity.StageName = ConstantsController.OpportunityStageNameRenewalPlanning;
                        opportunity.CloseDate = acc.Renewal_Date__c;
                        opportunity.Accountid = acc.id;
                        opportunity.IsAutoCreated__c = true;

                        newOpp.add(opportunity);
                    }
                }
            }
        }
        insert newOpp;

    }

    /**
    * @author               Sana Fatima/Slalom
    * @description          Filters which accounts need to be fed into completion rate calculation method
    * @param newAccounts    The new accounts that were inserted or updated
    */
    public static void clientProfileFieldCompletion( List<Account> newAccounts, Map<Id, Account> oldMap, Boolean isInsert ) {
        List<Account> targetAccounts = new List<Account>();

        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeDAOInstance = new CustomMetadataTypeDAO();
        List<CP_Completion_Rate_Fields__mdt> rateFields = customMetadataTypeDAOInstance.getClientProfileCompletionRateFields();

        if (isInsert) {
            for(Account acc : newAccounts) {
                targetAccounts.add(acc);
            }
        } else if (isInsert == false) {
            for ( Account acc : newAccounts ) {
                if( acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId() ) {
                    for ( CP_Completion_Rate_Fields__mdt rateField : rateFields ) {
                        if( acc.get(rateField.Field_Name__c) != oldMap.get(acc.Id).get(rateField.Field_Name__c) ) {
                            targetAccounts.add(acc);
                            continue; 
                        }
                    }
                }
            }
        }
        if ( !targetAccounts.isEmpty() ) {
            calculateFieldCompletionRate( targetAccounts, rateFields );
        }   
    }

    /**
    * @author               Sana Fatima/Slalom
    * @description          Computes the completion rate for the Client Profile fields
    * @param newAccounts    Targeted accounts that have been inserted or the selective fields were modified
    */
    public static void calculateFieldCompletionRate( List<Account> targetAccounts, List<CP_Completion_Rate_Fields__mdt> rateFields ) {
        Decimal totalFieldPoints;
        Decimal actualFieldPoints;

        if( !targetAccounts.isEmpty() ) {
            for (Account acc: targetAccounts) {
                totalFieldPoints = 0;
                actualFieldPoints = 0;
                if( !rateFields.isEmpty() ) {
                    for(CP_Completion_Rate_Fields__mdt rateField : rateFields) {
                        totalFieldPoints += rateField.PointValue__c;
                        if(acc.get(rateField.Field_Name__c) != null) {
                            actualFieldPoints += rateField.PointValue__c;
                        }
                    } 
                }
                if(totalFieldPoints != 0) {
                    acc.CPFieldCompletionRate__c = actualFieldPoints.divide(totalFieldPoints, 4) * 100 ;
                }
            }
        }
    }

    /**
    * @author Alec Klein/Slalom
    * @description: Assigns Forecast Segment based on criteria 
    * @param accountNewMap The new accounts to be updated
    */
    public static void populateForecastSegment(List<Account> newAccounts){
        try{
            if(newAccounts != null){
                Set<String> forecastDistricts = new Set<String>();
                Set<String> marketSegment = new Set<String>();
                Map<String, SGR_Market_Segments__c> mcs = SGR_Market_Segments__c.getAll();
                system.debug(mcs);
                
                for(Forecast_Segment_District__c fsd: Forecast_Segment_District__c.getAll().values()){
                    forecastDistricts.add(fsd.District__c);
                }
                for(Account currAccount: newAccounts){
                    if(currAccount != null){
                        if(forecastDistricts.contains(currAccount.District__c)){
                            currAccount.Forecast_Segment__c = ConstantsController.accountForecastSegmentENA;
                        }
                        /*else if(currAccount.Market_Segment__c == ConstantsController.accountMarketSegmentSG){
                            currAccount.Forecast_Segment__c = ConstantsController.accountForecastSegmentSmallGroup;
                        }*/
                        else if(mcs.containsKey(currAccount.HCSC_Division__c)){
                            List<String> mktSegments = mcs.get(currAccount.HCSC_Division__c).Market_Segment__c.split(',');
                            system.debug('+++mktSegments--'+mktSegments);
                            if(mktSegments.contains(currAccount.Market_Segment__c))
                            	currAccount.Forecast_Segment__c = ConstantsController.accountForecastSegmentSmallGroup;
                        }
                        else if(currAccount.Market_Segment__c == ConstantsController.accountMarketSegmentNAL || currAccount.Market_Segment__c == ConstantsController.accountMarketSegmentHWB){
                            currAccount.Forecast_Segment__c = ConstantsController.accountForecastSegmentLabor;
                        }
                        else{
                            currAccount.Forecast_Segment__c = ConstantsController.accountForecastSegmentLargeGroup;
                        }
                    }
                }
            }
        } catch(Exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.populateForecastSegment()', 'High');
        }
    }

    /**
    * @author               Sana Fatima/Slalom
    * @description          Computes the complexity score for Complexity Score Account fields
    * @param newAccounts    Targeted accounts that have been inserted or the selective fields were modified
    */
    public static void complexityScoreFieldCompletion( List<Account> newAccounts, Map<Id, Account> oldMap, Boolean isInsert ) {
        try {
            List<Account> targetAccounts = new List<Account>();
            Set<String> complexFieldAPIName = new Set<String>();

            CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeDAOInstance = new CustomMetadataTypeDAO();
            List<Complexity_Score_Fields__mdt> complexityScoreFields = customMetadataTypeDAOInstance.getComplexityScoreFields();

            //Removing duplicate complexity score field API names
            for(Complexity_Score_Fields__mdt complexityScoreField : complexityScoreFields) {
                complexFieldAPIName.add(complexityScoreField.Field_API_Name__c);
            }

            if (isInsert) {
                for( Account acc : newAccounts ) {
                    targetAccounts.add(acc);
                }
            } else if (isInsert == false) {
                for ( Account acc : newAccounts ) {
                    if( acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId() ) {
                        for ( String complexFieldName : complexFieldAPIName ) {
                            if( acc.get(complexFieldName) != oldMap.get(acc.Id).get(complexFieldName) ) {
                                targetAccounts.add(acc);
                            }
                        }
                    }
                }
            }
            if ( !targetAccounts.isEmpty() ) {
                calculateFieldComplexityScore( targetAccounts, complexityScoreFields );
            }   
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.complexityScoreFieldCompletion', 'High');
        }
    }

    /**
    * @author               Sana Fatima/Slalom
    * @description          Computes the complexity score for Account fields
    * @param newAccounts    Targeted accounts that have been inserted or the selective fields were modified
    */
    public static void calculateFieldComplexityScore( List<Account> targetAccounts, List<Complexity_Score_Fields__mdt> complexityScoreFields ) {
        try{
            Decimal actualFieldPoints;

            if( !targetAccounts.isEmpty() ) {
                for ( Account acc: targetAccounts ) {
                    actualFieldPoints = 0;
                    if( !complexityScoreFields.isEmpty() ) {
                        for( Complexity_Score_Fields__mdt complexField : complexityScoreFields ) {
                            if(acc.get( complexField.Field_API_Name__c) != null && !(acc.get(complexField.Field_API_Name__c) instanceof Boolean)) {
                                if( complexField.Field_API_Name__c == Label.Account_Active_Health_Subscribers ) { 
                                    if( (Decimal)acc.get(complexField.Field_API_Name__c) >=  complexField.ValueMin__c 
                                            && (Decimal)acc.get(complexField.Field_API_Name__c) <= complexField.ValueMax__c )
                                        actualFieldPoints += complexField.Score__c;
                                } else if ( complexField.Field_API_Name__c == Label.Account_HCM_Program_Model ) {
                                    if( complexField.Value__c.containsIgnoreCase((String)acc.get(complexField.Field_API_Name__c)) ) {
                                        actualFieldPoints += complexField.Score__c;
                                    }
                                } else if ( complexField.Field_API_Name__c == Label.Account_Funding_Type ) { 
                                    if( ((String)acc.get(complexField.Field_API_Name__c)).containsIgnoreCase(complexField.Value__c)) {
                                        actualFieldPoints += complexField.Score__c;
                                    } else {
                                        actualFieldPoints += ConstantsController.PointsForFundingTypeOtherThanASO; 
                                    }
                                } else if ( complexField.Field_API_Name__c == Label.Account_Cobra_Administration_Type ) {
                                    actualFieldPoints += complexField.Score__c;
                                } 
                            } else if ( acc.get( complexField.Field_API_Name__c ) != false ) {
                                if ( complexField.Field_API_Name__c == Label.Account_Ceded ) {
                                    actualFieldPoints += complexField.Score__c;
                                } else if ( complexField.Field_API_Name__c == Label.Account_Exchange_Account ) {
                                    actualFieldPoints += complexField.Score__c;
                                } else if ( complexField.Field_API_Name__c == Label.Account_Sliced ) {
                                    actualFieldPoints += complexField.Score__c;
                                }
                            }       
                        } 
                    }
                    acc.ComplexityScoreAccountFields__c = actualFieldPoints;
                }
            } 
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.calculateFieldComplexityScore', 'High');
        }
    }

/**
** This method is to populate the Contact from the AccountcontactRole where primary is checked to the Primary Contact field on Account.
** It the ultimate purpose of using the Primary Contact field on Account is to auto populated to Stickness Scorinng record related to the Group Account.
*/
   
    public  void populatePrimaryContactField(Map<Id, Account> accountNewMap, Map<Id, Account> accountOldMap){
        
        set<Id> idToUpdate=new set<Id>();
        set<Id> allIds=new set<Id>();
        //check if primary contact is null or different, if yes update the Primary Contact field
        set<Id> idToCheck=new set<Id>();
        Id GroupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();
        
        
        try{
        for(Id acctId: accountNewMap.keySet()){
            system.debug('acctId: '+acctId);
            //no primary contact there
            system.debug('new primary contact_:'+accountNewMap.get(acctId).Primary_Contact__c+ ' Old: '+accountOldMap.get(acctId).Primary_Contact__c);
            
            if(accountNewMap.get(acctId).recordTypeId==GroupAccountRecordTypeId){
                allIds.add(acctId);
               
                if(accountNewMap.get(acctId).Primary_Contact__c==null){
                    idToUpdate.add(acctId);
                    system.debug('accountNewMap.get(acctId).Primary_Contact__c: '+ accountNewMap.get(acctId).Primary_Contact__c);
              
                }else if(accountNewMap.get(acctId).Primary_Contact__c!=null){
                    idToCheck.add(acctId);
                }
                
            }
        }
        
        Map<Id, Account> updateAccountMap=new Map<Id,Account>();
        list<Account> updateForPC=new list<Account>();
    
            list<Account> accountToUpdate=accountDAOInstance.getAccountForPrimaryContactUpdate(allIds);
          //  system.debug('Account To Update: '+accountToUpdate);
            
            if(accountToUpdate!=null && !accountToUpdate.isEmpty()){
                for(account acct:accountToUpdate){
                    updateAccountMap.put(acct.Id, acct);
                }
            }
            
            list<AccountContactRole> crs=[select accountId, id, contactId,Isprimary from AccountContactRole where accountId IN:allIds and Isprimary=true];
      
            system.debug('account contact Roles:::::'+crs);
            
            set<id> crIds=new set<id>();
            Map<Id,Account> acctWithCR =new Map<Id,Account>();
            
            
            if(crs!=null && !crs.isEmpty()){
                for(AccountContactRole cr: crs){
                 
                 crIds.add(cr.AccountId);
                 
                 Account acct=updateAccountMap.get(cr.AccountId);
                 
                    if(acct!=null && cr.isPrimary &&(acct.Primary_Contact__c==null || (acct.Primary_Contact__c!=null && acct.Primary_Contact__c!=cr.contactId))){
                       crIds.add(cr.AccountId);
                       system.debug('update acct.Primary_Contact__c for Account '+acct.id);
                       acct.Primary_Contact__c=cr.contactId;
                       updateForPC.add(acct);   
                         
                    }
                }
            }
            
        //check if the primary contact role has been removed, if true, update the primary contact to null
         
         if(!idToCheck.isEmpty()) { 
            
            if(crIds!=null && !crIds.isEmpty()){          
                for(Id acctId1: idToCheck){
                
                    if(!crIds.contains(acctId1)){
                         Account acct=updateAccountMap.get(acctId1);
                         acct.Primary_Contact__c=null;
                         updateForPC.add(acct);
                         system.debug('primary contact is removed:::'+acctId1);
                    }
                }
             
            }else{
                for(Id acctId2: idToCheck){
                     Account acct=updateAccountMap.get(acctId2);
                     acct.Primary_Contact__c=null;
                     system.debug('primary contact is removed:::'+acctId2);
                     updateForPC.add(acct);
                }
            }
     
       }
 
        if(updateForPC!=null && !updateForPC.isEmpty()){
                
                update updateForPC;
                system.debug('update For Primary Contact:::::'+updateForPC);
       } 
       
       
     }catch (Exception e){
            system.debug('populatePrimaryContactField error:  '+e);
          CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.populatePrimaryContactField()', 'High');
        }
    }
    
   
    public void populateContractSignerFields(Map<Id, Account> accountNewMap, Map<Id, Account> accountOldMap){

        try{

            Set<Id> accountIds = new Set<Id>();
            Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Account_Group_Account_Record_Type).getRecordTypeId();
            Id prospectAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Prospect).getRecordTypeId();
            Id customContractsCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypeCustomContracts).getRecordTypeId();

            for (Id acctId : accountNewMap.KeySet()) {
               
                if (accountNewMap.get(acctId).RecordTypeId == groupAccountRecordTypeId || accountNewMap.get(acctId).RecordTypeId == prospectAccountRecordTypeId) {     
                    if((accountNewMap.get(acctId).Contract_Signer__c != null && accountNewMap.get(acctId).Contract_Signer__c != accountOldMap.get(acctId).Contract_Signer__c) || 
                        (accountNewMap.get(acctId).Underwriter_Name__c != null && accountNewMap.get(acctId).Underwriter_Name__c != accountOldMap.get(acctId).Underwriter_Name__c) || 
                        (accountNewMap.get(acctId).Underwriter__c != null && accountNewMap.get(acctId).Underwriter__c != accountOldMap.get(acctId).Underwriter__c)){     
                            accountIds.add(acctId);
                    }
                }             
            }

            if (accountIds.size() > 0) {
           
                Map<Id, List<Case>> caseMap = new Map<Id, List<Case>>();

                List<Case> cases = caseDAOInstance.getContractSignerCases(accountIds, customContractsCaseRecordTypeId);

                List<Account> acctsToCheck = accountDAOInstance.getAccountsForContractSignerAccount(accountIds);

                for (Case curCase : cases) {

                    List<Case> newCase = new List<Case>();
                    if (caseMap.containsKey(curCase.AccountId)) {
                        newCase = caseMap.get(curCase.AccountId);
                    }
                    newCase.add(curCase);
                    caseMap.put(curCase.AccountId, newCase);
                }

                List<Case> casesToUpdate = new List<Case>();

                for (Account curAccount : acctsToCheck) {
                    
                    if(caseMap.containsKey(curAccount.Id)){
               
                        for (Case caseRecords : caseMap.get(curAccount.Id)) {

                            caseRecords.Bypass_Validation__c = true;

                            if (curAccount.Contract_Signer__c != null) {
                                caseRecords.Full_Name__c = curAccount.Contract_Signer__r.FirstName + ' ' + curAccount.Contract_Signer__r.LastName;
                            } else {
                                caseRecords.Full_Name__c = '';
                            }

                            caseRecords.Email__c = curAccount.Contract_Signer__r.Email;
                            caseRecords.Phone__c = curAccount.Contract_Signer__r.Phone;
                            caseRecords.Title__c = curAccount.Contract_Signer__r.Title;              

                            if(curAccount.RecordTypeId == groupAccountRecordTypeId){
                                caseRecords.Account_Type__c = Label.ProductTypeR;                   
                                caseRecords.Underwriter_From_Account__c = curAccount.Underwriter_Name__c;
                   
                            } else {
                                caseRecords.Account_Type__c = Label.Prospect;
                                if(curAccount.Underwriter__c != null){
                                    caseRecords.Underwriter_From_Account__c = curAccount.Underwriter__r.FirstName + ' ' + curAccount.Underwriter__r.LastName;
                                } else {
                                    caseRecords.Underwriter_From_Account__c = '';
                                }
                            }
                            casesToUpdate.add(caseRecords);
                        }
                    }
                }

                if (!casesToUpdate.isEmpty()) {

                      caseDAOInstance.updateContractSignerCases(casesToUpdate);
                }
            }

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.populateContractSignerFields()', 'High');
        }
    }

    public static void updateOpportunityWeeklyActivityModifiedDate(Map<Id, Account> newMap, Map<Id, Account> oldMap){

        try {
            
            UserDAO userDAOInstance = new UserDAO();
            OpportunityDAO opportunityDAOInstance = new OpportunityDAO();
            User currUser = userDAOInstance.getCurrentUser();
            if (currUser.Lan_Id__c != '456' && currUser.Name != 'BCBS'){
                Set<Id> changedAccounts = new Set<Id>();
                for (Account a : newMap.values()){
                    Account oldAcc = oldMap.get(a.Id);
                    if (a.Current_Risk_Level__c != oldAcc.Current_Risk_Level__c)
                        changedAccounts.add(a.Id);
                    else if (a.Status__c != oldAcc.Status__c)
                        changedAccounts.add(a.Id);
                    else if (a.Critical_Account__c != oldAcc.Critical_Account__c)
                        changedAccounts.add(a.Id);
                }
                
                if (!changedAccounts.isEmpty()){
                    List<Opportunity> oppsToUpdate = opportunityDAOInstance.getOpportunitiesByParentAccount(changedAccounts);
                    
                    if (!oppsToUpdate.isEmpty()){

                        for (Opportunity o : oppsToUpdate){
                            o.Weekly_Activity_Modified_Date__c = System.today();
                        }
                        update oppsToUpdate;
                    }
                }
            }
        } catch (Exception e){

            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.updateOpportunityWeeklyActivityModifiedDate()', 'High');
        }
    }

    /**
    * @author               Sana Fatima/Slalom
    * @description          Creates SharePoint Folders for Group and Prospect Accounts
    * @param newAccounts    newAccounts from Trigger.new
    */
    public static void createSharePointFolder(List<Account> newAccounts) {
        try{ 
            Id groupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
            Id prospectAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Prospect ).getRecordTypeId();
            List<Account> groupAndProspects = new List<Account>();

            for(Account acc : newAccounts) {
                if (acc.recordTypeId == groupAccount || acc.recordTypeId == prospectAccount ) {
                    groupAndProspects.add( acc );
                }
            }
            if( !groupAndProspects.isEmpty() ) {
            System.enqueueJob(new SharePointAccountManager( groupAndProspects, new Map<Id, Account>() ));
            }
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.createSharePointFolder()', 'High');
        }        
    }

    /**
    * @author               Sana Fatima/Slalom
    * @description          Updates SharePoint Folders for Group and Prospect Accounts
    * @param newAccounts    newAccounts from Trigger.new, oldAccounts from oldMap
    */
    public static void updateSharePointFolder(List<Account> newAccounts, Map<Id, Account> oldAccounts){
        try{
            Id groupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
            Id prospectAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Prospect ).getRecordTypeId();
            List<Account> modifiedGroupAndProspects = new List<Account>();

            for(Account acc : newAccounts) {
                if (acc.recordTypeId == groupAccount || acc.recordTypeId == prospectAccount ) {
                    if ( acc.Name != null && !acc.Name.equalsIgnoreCase(oldAccounts.get(acc.Id).Name) ) {
                        modifiedGroupAndProspects.add( acc );
                    } else if ( acc.External_ID__c != null && !acc.External_ID__c.equalsIgnoreCase(oldAccounts.get(acc.Id).External_ID__c) ) {
                        modifiedGroupAndProspects.add( acc );
                    } else if ( acc.HCSC_Division__c != null && !acc.HCSC_Division__c.equalsIgnoreCase(oldAccounts.get(acc.Id).HCSC_Division__c) ) {
                        modifiedGroupAndProspects.add( acc );
                    } else if ( acc.Effective_Date__c != (oldAccounts.get(acc.Id).Effective_Date__c) ) {
                        modifiedGroupAndProspects.add( acc );
                    }
                }
            }
            if( !modifiedGroupAndProspects.isEmpty() ) { 
                System.enqueueJob(new SharePointAccountManager( modifiedGroupAndProspects, oldAccounts ));
            }
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.updateSharePointFolder()', 'High');
        }  
    }


    /**
    * @author               Al-Que Quiachon/Slalom
    * @description          Updates Case Custom Contracts status to cancelled if the related Group Account status changes to canceled.
    * @param newAccounts    newAccounts from Trigger.new, oldAccounts from oldMap
    */

        public static void updateCustomContractCaseStatus(List<Account> newAccounts, Map<Id, Account> oldAccounts){
        try{
        Id groupAccountRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get( ConstantsController.groupAccountRT).getRecordTypeId();
        Id customContractRTCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get( ConstantsController.customContractRTCase).getRecordTypeId();
        Set<Id> grpAccountId = new Set <Id>();
        Integer index = 0; 
        List<Case> casesToUpdate = new List<Case>();

        for(Account acct : newAccounts){
            if(acct.RecordTypeId == groupAccountRTID){
                if(oldAccounts.size() > 0){
                if(acct.Cancellation_Status__c == ConstantsController.cancelledStatus && oldAccounts.get(acct.Id).Cancellation_Status__c != ConstantsController.cancelledStatus){
                    grpAccountId.add(acct.Id);
                }
            }
                else if (acct.Cancellation_Status__c == ConstantsController.cancelledStatus){
                    grpAccountId.add(acct.Id);
                }

            }
        }
        if(grpAccountId.size() > 0){

            
            for(Case c: [SELECT Reason_for_Cancellation__c,Account.Id,Id,Status,RecordType.Id FROM Case where Account.Id In : grpAccountId AND RecordType.Id =: customContractRTCase LIMIT 100]){

                c.Status= ConstantsController.caseCancelledStatus;
                c.Reason_for_Cancellation__c = ConstantsController.reasonForCaseCancel;
                casesToUpdate.add(c);
            }
        }
        if(casesToUpdate.size() > 0){
        update casesToUpdate;
    }   
    }
catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', 'AccountTrigger', 'AccountTriggerHandler.updateCustomContractCaseStatus()', 'High');
        }
}
    
    /******************************************************************** 
     *     Method Name : cancelSubmissionCase
     *    @description :   SFDC-4729 Cancel Submission case when Account in cancelled.
     *    @parameters  :   List<Account> newAccList, Map<id,Account> oldAccMap
     *    @return type :   void
     *    @Author      : Bharath
     * ******************************************************************/
    public static void cancelSubmissionCase(List<Account> newAccList, Map<id,Account> oldAccMap){
        Set<Id> useAccIdList = new Set<Id>();
        List<Case> casesToCancel = new List<Case>();
        for(Account newAcc : newAccList){
            // 7898 - Check for value in cancellation date field and check if status is cancelled. 
            if(newAcc.Cancellation_Date__c != NULL && newAcc.Status__c == 'Cancelled'){
                useAccIdList.add(newAcc.Id);
            }
        }
        //Check if there are accounts which has been cancelled for further processing. 
        if(useAccIdList.size() > 0){
            //Process all the open submission cases related to the cancelled account. 
            futureCancelSubCase(useAccIdList);
        }
    }
    /******************************************************************** 
     *     Method Name : futureCancelSubCase
     *    @description :   SFDC-4729 Cancel Submission case for the Account IDs passed as paramter.
     *    @parameters  :   Set<Id> subCaseIds
     *    @return type :   void
     *    @Author      : Bharath
     * ******************************************************************/
    @future
    public static void futureCancelSubCase(Set<Id> subCaseIds){
        List<Case> casesToCancel = new List<Case>();
        Id caseSubRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseMaintRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        if(!subCaseIds.isEmpty()){
            // SFDC-7898, use isClosed instead of list of closed statuses
            for(Case c : [select id, status, Reason_for_Cancellation__c from Case where isClosed = false and (RecordTypeId = :caseSubRecTypeId or RecordTypeId = :caseMaintRecTypeId) and AccountId in : subCaseIds]){
                              c.Status= ConstantsController.caseCancelledStatus;
                              c.Reason_for_Cancellation__c = ConstantsController.reasonForCaseCancel;
                              casesToCancel.add(c);
                          }
            if(casesToCancel.size() > 0){
                update casesToCancel;
            }
            
        }
    }
     
}