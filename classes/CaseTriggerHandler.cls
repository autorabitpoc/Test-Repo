/**************************************************************************************
*  Apex Class Name     : CaseTriggerHandler
*  Version             : 1.0
*  Function            : This is a handler class for CaseTrigger. The methods in this class are used as utility methods for CaseTrigger
*  Modification Log    :
*  Developer                Date            Description
* ----------------------------------------------------------------------------
*  Suyog Dongaonkar         03/10/2014      Original Version
*  Malathi.K                08/05/2017      SFDC-5096 GEMS - Create Sharepoint folder for Account Maintenance
*  Zachary Campbell         08/18/2017      SFDC-4552 added conditional null checks and BlueDirectionsRecordType* label references
*  Zachary Campbell			10/20/2017		SFDC-6677 Commented out checkIfModifiedBlueDirectionsProductRecords to remove unneeded
*											LOB product update verification for submission.
**************************************************************************************/
public with sharing class CaseTriggerHandler {
  @TestVisible private ProfileDAO.IProfileDAO profileDAOInstance;
  @TestVisible private AccountDAO.IAccountDAO accountDAOInstance;
  @TestVisible private CaseDAO.ICaseDAO caseDAOInstance;

  public CaseTriggerHandler() {
    this( new ProfileDAO(), new AccountDAO(), new CaseDAO() );
  }

  @TestVisible private CaseTriggerHandler(ProfileDAO.IProfileDAO profileDAOInstance, AccountDAO.IAccountDAO accountDAOInstance, CaseDAO.ICaseDao caseDAOInstance) {
    this.profileDAOInstance = profileDAOInstance;
    this.accountDAOInstance = accountDAOInstance;
    this.caseDAOInstance = caseDAOInstance;
  }

  public static Boolean isUpdateFromCode = false;

  /*  isSuperUser
   *   @description:   This method checks if the current user is a super user.
   *   @parameters     N/A
   *   @return type    Boolean
   */


  /*  validateCarrierHistoryValidation
   *   @description:   This method checks if the carrier history is covering the 24 months duration.
   *   @parameters     N/A
   *   @return type    none
   */

  public static void validateCarrierHistoryValidation(list<Case> newCases, map<Id, Case> oldCasesMap, map<Id, Case> newCasesMap) { }



  public static Boolean isSuperUser() {
    try {
      return ConstantsController.LoggedInUserInfo.Is_Super_User__c;
      /*return [    select  Id, Is_Super_User__c
        from    User
        where   Id = :UserInfo.getUserId()
        limit   1].Is_Super_User__c;*/
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
      return false;
    }
  }

  /*  checkCaseEditability
   *   @description:   This method checks if the case is editableby current user.
    This method is used for the before insert scenario.
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void checkCaseEditability(List<Case> newCases) {
    try {
      Case newCase;
      for (Integer index = 0; index < newCases.size(); index++) {
        newCase = newCases[index];
        //If the fields are being updated via code, do not add an error
        if (CaseTriggerHandler.isUpdateFromCode == false) {
          if (newCase.Assigned_To__c != null && !CaseTriggerHandler.isSuperUser()) {
            newCase.addError(Label.Assigned_To_Edit_Not_Allowed);
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  checkCaseEditability
   *   @description:   This method checks if the case is editableby current user.
    This method is used for the before update scenario.
   *   @parameters     List<Case> newCases : Cases under current context.
    List<Case> oldCases : Old values of the cases under context.
   *   @return type    void
   */
  public static void checkCaseEditability(List<Case> newCases, List<Case> oldCases) {
    try {
      Case newCase;
      Case oldCase;
      Set<id> userIds = new Set<id> ();
      Map<id, id> UserManagerMAp = new Map<id, id> ();
      //User loggedinUser = [select id ,profile.name from User where id = :UserInfo.getUserId()] ;
      User loggedinUser = ConstantsController.LoggedInUserInfo;
      Map<String, Restricted_SG_Profiles__c> Restricted_SG_Profiles = Restricted_SG_Profiles__c.getAll();
      for (Integer index = 0; index < newCases.size(); index++) {
        newCase = newCases[index];
        userIds.add(newCase.OwnerId);
      }
      if (newCases.size() > 0) {
        List<User> userList = [Select Id, Name, managerid from User where Id = :newCase.OwnerId];
        for (user userrec : userList) {
          UserManagerMAp.put(userrec.id, userrec.managerid);
        }
        for (Integer index = 0; index < newCases.size(); index++) {
          newCase = newCases[index];
          oldCase = oldCases[index];
          if (CaseTriggerHandler.isUpdateFromCode == false) {
            if (!CaseTriggerHandler.isSuperUser()) {
              //Added owner and owner's manger in condition as a part of requiremnt no :REQ-1444
              if (newCase.OwnerId != oldCase.OwnerId) {

                if (Restricted_SG_Profiles.containskey(loggedinUser.profile.name) || (!Restricted_SG_Profiles.containskey(loggedinUser.profile.name) && newCase.OwnerId != UserInfo.getUserId() && UserManagerMAp.get(newCase.OwnerId) != UserInfo.getUserId()) && newCase.recordtype.DeveloperName == Label.Small_Group_Case_Recordtype) {
                  newCase.addError(Label.Owner_Edit_Not_Allowed);
                }
              } else if (newCase.Assigned_To__c != oldCase.Assigned_To__c && !CaseTriggerHandler.isSuperUser()) {
                newCase.addError(Label.Assigned_To_Edit_Not_Allowed);
              }
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  updateCaseOwnerByQueue
   *   @description:   This method updates the assigned to and owner id of a record when a case is being assigned to partner queues.
    This method is used for the before insert scenario.
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void updateCaseOwnerByQueue(List<Case> newCases) {
    try {
      Set<Id> smallGroupCaseRecordTypeIds = ConstantsController.populateSmallGroupCaseRecordTypeIds();
      Map<String, Id> QueueNameAndIdMap = new Map<String, Id> ();
      Map<String, String> AssignedPartnerAndQueueNameMap = new Map<String, String> ();
      List<Case_Partner_Queues__c> listPartnerQueues = Case_Partner_Queues__c.getAll().values();
      //Get all the queues
      /*for(Group GroupObj : [SELECT Id, Name FROM Group where Type = 'Queue' limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ]){
        QueueNameAndIdMap.put(GroupObj.Name, GroupObj.Id);
        }*/
      for (Group GroupObj : ConstantsController.groups) {
        QueueNameAndIdMap.put(GroupObj.Name, GroupObj.Id);
      }
      //Get all the applicable queues from custom setting
      for (Case_Partner_Queues__c casePartnerQueueObj : listPartnerQueues) {
        AssignedPartnerAndQueueNameMap.put(casePartnerQueueObj.Assigned_Partner__c, casePartnerQueueObj.Queue__c);
      }
      if (!AssignedPartnerAndQueueNameMap.isEmpty() && !QueueNameAndIdMap.isEmpty()) {
        for (Case caseObj : newCases) {
          //if the case is assigned to a partner at the time of case creation
          if (smallGroupCaseRecordTypeIds.contains(caseObj.RecordTypeId)
              && caseObj.Assigned_Partner__c != null &&
              AssignedPartnerAndQueueNameMap.containsKey(caseObj.Assigned_Partner__c) &&
              AssignedPartnerAndQueueNameMap.get(caseObj.Assigned_Partner__c) != null) {

            String queueName = AssignedPartnerAndQueueNameMap.get(caseObj.Assigned_Partner__c);
            if (QueueNameAndIdMap.containsKey(queueName)) {

              caseObj.OwnerId = QueueNameAndIdMap.get(queueName);
              isUpdateFromCode = true;
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage() + e.getLineNumber());
    }
  }

  /*  updateCaseOwnerByQueue
   *   @description:   This method updates the assigned to and owner id of a record when a case is being assigned to partner queues.
    This method is used for the before update scenario.
   *   @parameters     List<Case> oldCases : Old values of the cases under context.
   *   @parameters     List<Case> newCases : Cases under current context.
    List<Case> oldCases : Old values of the cases under context.
   *   @return type    void
   */
  public static void updateCaseOwnerByQueue(List<Case> newCases, List<Case> oldCases) {
    try {
      Set<Id> smallGroupCaseRecordTypeIds = ConstantsController.populateSmallGroupCaseRecordTypeIds();

      Map<String, Id> QueueNameAndIdMap = new Map<String, Id> ();
      Map<String, String> AssignedPartnerAndQueueNameMap = new Map<String, String> ();
      List<Case_Partner_Queues__c> listPartnerQueues = Case_Partner_Queues__c.getAll().values();
      //Get all the queues
      /*for(Group GroupObj : [SELECT Id, Name FROM Group where Type = 'Queue' limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ]){
        QueueNameAndIdMap.put(GroupObj.Name, GroupObj.Id);
        }*/
      for (Group GroupObj : ConstantsController.groups) {
        QueueNameAndIdMap.put(GroupObj.Name, GroupObj.Id);
      }
      //Get all the applicable queues from custom setting
      for (Case_Partner_Queues__c casePartnerQueueObj : listPartnerQueues) {
        AssignedPartnerAndQueueNameMap.put(casePartnerQueueObj.Assigned_Partner__c, casePartnerQueueObj.Queue__c);
      }
      if (!AssignedPartnerAndQueueNameMap.isEmpty() && !QueueNameAndIdMap.isEmpty()) {
        Case newCase;
        Case oldCase;
        for (Integer index = 0; index < newCases.size(); index++) {
          newCase = newCases[index];
          oldCase = oldCases[index];
          System.debug(' smallGroupCaseRecordTypeIds==' + smallGroupCaseRecordTypeIds.contains(newCase.RecordTypeId));
          if (smallGroupCaseRecordTypeIds.contains(newCase.RecordTypeId)) {
            //if the case is assigned to a partner or a partner is changed
            if (newCase.Assigned_Partner__c != null &&
                newCase.Assigned_Partner__c != oldCase.Assigned_Partner__c &&
                AssignedPartnerAndQueueNameMap.containsKey(newCase.Assigned_Partner__c) &&
                AssignedPartnerAndQueueNameMap.get(newCase.Assigned_Partner__c) != null) {

              String queueName = AssignedPartnerAndQueueNameMap.get(newCase.Assigned_Partner__c);
              if (QueueNameAndIdMap.containsKey(queueName)) {
                /*//if the original owner is a queue, update the "Assigned To" to the current user
                  if(  newCase.Assigned_To__c == null && Schema.Group.SObjectType == newCase.OwnerId.getSobjectType() ) {
                  newCase.Assigned_To__c = UserInfo.getUserId();
                  }
                  //if the original owner is a user, update the "Assigned To" to that user
                  else if(  newCase.Assigned_To__c == null && Schema.User.SObjectType == newCase.OwnerId.getSobjectType() ) {
                  newCase.Assigned_To__c = newCase.OwnerId;
                  }*/
                newCase.OwnerId = QueueNameAndIdMap.get(queueName);
                isUpdateFromCode = true;
              }
            }
            //If the case is taken back from the partner, change owner to the Assigned To user.
            else if (newCase.Assigned_Partner__c != oldCase.Assigned_Partner__c &&
                     newCase.Assigned_Partner__c == null) {
              if (newCase.Assigned_To__c != null) {
                newCase.OwnerId = newCase.Assigned_To__c;
                isUpdateFromCode = true;
              } else if (newCase.Assigned_To__c == null) {
                newCase.OwnerId = UserInfo.getUserId();
                isUpdateFromCode = true;
              }
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  manageCaseAccountLookups
   *   @description:   This method updates the account lookups on case object based on the various conditions.
    Account Name and Producer Account lookups are filled in based on the contact type.
   *   @parameters     List<Case> oldCases : Old values of the cases under context.
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void manageCaseAccountLookups(List<Case> newCases) {
    try {
      Set<Id> contactIds = new Set<Id> ();
      Set<Id> accountIds = new Set<Id> ();

      for (Case caseRec : newCases) {
        contactIds.add(caseRec.ContactId);
        accountIds.add(caseRec.AccountId);
        accountIds.add(caseRec.Producer_Account__c);
      }

      Map<Id, Contact> contacts = new Map<Id, Contact> (
        [select Id, AccountId
         from Contact
         where Id IN : contactIds
         limit : Limits.getLimitQueryRows() - Limits.getQueryRows()]
      );

      for (Contact contactRec : contacts.values()) {
        accountIds.add(contactRec.AccountId);
      }

      Map<Id, Account> accounts = new Map<Id, Account> (
        [select Id, RecordType.Name
         from Account
         where Id IN : accountIds
         limit : Limits.getLimitQueryRows() - Limits.getQueryRows()]
      );

      Account accountRec;
      Account contactsAccount;
      for (Case caseRec : newCases) {

        //If both account lookups are blank
        if (String.isBlank(caseRec.AccountId) && String.isBlank(caseRec.Producer_Account__c)) {
          if (String.isNotBlank(caseRec.ContactId)
              && contacts.containsKey(caseRec.ContactId)
              && accounts.containsKey(contacts.get(caseRec.ContactId).AccountId)) {

            accountRec = accounts.get(contacts.get(caseRec.ContactId).AccountId);

            if (accountRec.RecordType.Name == Label.Producer_Account) {
              caseRec.AccountId = Id.valueOf(System.Label.Default_Account);
              caseRec.Producer_Account__c = accountRec.Id;
            } else if (accountRec.RecordType.Name == Label.Group_Account) {
              caseRec.AccountId = accountRec.Id;
              caseRec.Producer_Account__c = null;
            }
          }
        }

        //if account name on case is filled in and producer acc is blank
        if (String.isNotBlank(caseRec.AccountId) && String.isBlank(caseRec.Producer_Account__c)) {
          if (accounts.containsKey(caseRec.AccountId)) {

            accountRec = accounts.get(caseRec.AccountId);

            if (accountRec.RecordType.Name == Label.Producer_Account) {
              caseRec.AccountId = Id.valueOf(System.Label.Default_Account);
              caseRec.Producer_Account__c = accountRec.Id;
            } else if (accountRec.RecordType.Name == Label.Group_Account) {
              caseRec.AccountId = accountRec.Id;

              if (String.isNotBlank(caseRec.ContactId)
                  && contacts.containsKey(caseRec.ContactId)
                  && accounts.containsKey(contacts.get(caseRec.ContactId).AccountId)) {

                contactsAccount = accounts.get(contacts.get(caseRec.ContactId).AccountId);

                if (contactsAccount.Id != accountRec.Id && contactsAccount.RecordType.Name == Label.Producer_Account) {
                  caseRec.Producer_Account__c = contactsAccount.Id;
                }
              }
            }
          }
        }

        //if account name is blank and producer name is filled
        if (String.isBlank(caseRec.AccountId) && String.isNotBlank(caseRec.Producer_Account__c)) {
          if (accounts.containsKey(caseRec.Producer_Account__c)) {

            accountRec = accounts.get(caseRec.Producer_Account__c);

            if (accountRec.RecordType.Name == Label.Producer_Account) {
              if (String.isNotBlank(caseRec.ContactId)
                  && contacts.containsKey(caseRec.ContactId)
                  && accounts.containsKey(contacts.get(caseRec.ContactId).AccountId)) {

                contactsAccount = accounts.get(contacts.get(caseRec.ContactId).AccountId);

                if (contactsAccount.Id != accountRec.Id && contactsAccount.RecordType.Name == Label.Group_Account) {
                  caseRec.AccountId = contactsAccount.Id;
                } else {
                  caseRec.AccountId = Id.valueOf(System.Label.Default_Account);
                }
              }

            } else if (accountRec.RecordType.Name == Label.Group_Account) {
              caseRec.AccountId = accountRec.Id;
              caseRec.Producer_Account__c = null;
            }
          }
        }

        //If both account lookups are not blank
        if (String.isNotBlank(caseRec.AccountId) && String.isNotBlank(caseRec.Producer_Account__c)) {
          if (String.isNotBlank(caseRec.ContactId)
              && contacts.containsKey(caseRec.ContactId)
              && accounts.containsKey(contacts.get(caseRec.ContactId).AccountId)) {

            contactsAccount = accounts.get(contacts.get(caseRec.ContactId).AccountId);

            if (contactsAccount.RecordType.Name == Label.Producer_Account) {
              caseRec.Producer_Account__c = contactsAccount.Id;
            } else if (contactsAccount.RecordType.Name == Label.Group_Account) {
              caseRec.AccountId = contactsAccount.Id;
            }
          }

          //Validate record types
          if (accounts.containsKey(caseRec.Producer_Account__c)) {
            accountRec = accounts.get(caseRec.Producer_Account__c);
            if (accountRec.RecordType.Name == Label.Group_Account) {
              caseRec.Producer_Account__c = null;
            }
          }

          if (accounts.containsKey(caseRec.AccountId)) {
            accountRec = accounts.get(caseRec.AccountId);
            if (accountRec.RecordType.Name == Label.Producer_Account) {
              caseRec.AccountId = Id.valueOf(System.Label.Default_Account);
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }



  /*  updateCaseOwnerByEmail
   *   @description:   This method changes the Case Owner by Queue based on Initial Email Address
    This method is used for the before insert scenario.
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void updateCaseOwnerByEmail(List<Case> newCases, map<Id, Case> oldCaseMap) {
    try {
      Map<String, String> emailAndQueueMap = new Map<String, String> ();
      Map<String, Id> groupNameAndId = new Map<String, Id> ();
      Map<String, String> emailAndStateMap = new Map<String, String> ();

      Map<String, Email_To_Case_Queues__c> emailToCaseQueuesMap = Email_To_Case_Queues__c.getAll();

      for (Email_To_Case_Queues__c emailToCaseQueueObj : emailToCaseQueuesMap.values()) {
        emailAndQueueMap.put(emailToCaseQueueObj.Email__c, emailToCaseQueueObj.Queue_Name__c);
        emailAndStateMap.put(emailToCaseQueueObj.Email__c, emailToCaseQueueObj.State__c);
      }
      List<Group> groupList = [SELECT Id, Name FROM Group WHERE Name IN :emailAndQueueMap.values() limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
      for (Group groupObj : groupList) {
        groupNameAndId.put(groupObj.Name, groupObj.Id);
      }
      for (Case caseObj : newCases) {
        if (caseObj.Initial_Email_To_Address__c != null && caseObj.Initial_Email_To_Address__c != '') {
          if (oldCaseMap.containsKey(caseObj.Id) && caseObj.Initial_Email_To_Address__c != oldCaseMap.get(caseObj.Id).Initial_Email_To_Address__c) {

            if (!emailAndQueueMap.isEmpty() && !groupNameAndId.isEmpty()) {
              for (String emailAddress : emailAndQueueMap.keySet()) {
                if (caseObj.Initial_Email_To_Address__c.contains(emailAddress)) {
                  String queueName = emailAndQueueMap.get(emailAddress);
                  if (groupNameAndId.containsKey(queueName) && groupNameAndId.get(queueName) != null) {
                    caseObj.OwnerId = groupNameAndId.get(queueName);
                    caseObj.Plan_State__c = emailAndStateMap.get(emailAddress);
                    isUpdateFromCode = true;
                  }
                }
              }
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  createCaseOwnershipTrackingRecord
   *   @description:   This method creates case ownership tracking records for Case object. This method is used in after insert trigger.
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void createCaseOwnershipTrackingRecord(List<Case> newCases) {
    try {
      Map<Id, String> queueIdAndNameMap = new Map<Id, String> ();

      for (Group GroupObj : ConstantsController.groups) {
        queueIdAndNameMap.put(GroupObj.Id, GroupObj.Name);
      }

      List<Case_Ownership_Tracking__c> ownershipTrackings = new List<Case_Ownership_Tracking__c> ();
      set<String> allowedRecordTypeNames = new set<String> ();
      for (CaseOwnerShip_Record_Creation_Settings__c crc : CaseOwnerShip_Record_Creation_Settings__c.getAll().values()) {
        if (crc.Create_CaseOwnership_Record__c)
          allowedRecordTypeNames.add(crc.Name);
      }
      List<Case> caseList = [select Id, status, OwnerId, Owner.UserRole.Name, RecordType.DeveloperName, Owner.Profile.Name from Case where Id In :newCases];
      for (Case caseRec : caseList) {
        Case_Ownership_Tracking__c cot = new Case_Ownership_Tracking__c();
        cot.Case__c = caseRec.Id;
        cot.Start__c = System.now();
        if (allowedRecordTypeNames.contains(caseRec.RecordType.DeveloperName))
          cot.Case_Status__c = caseRec.Status;
        //if the original owner is a queue, update the "Queue" field
        if (Schema.Group.SObjectType == caseRec.OwnerId.getSobjectType()) {
          cot.Queue__c = queueIdAndNameMap.get(caseRec.OwnerId);
        }
        //if the original owner is a user, update the "User" field
        else if (Schema.User.SObjectType == caseRec.OwnerId.getSobjectType()) {
          cot.User__c = caseRec.OwnerId;
          if (allowedRecordTypeNames.contains(caseRec.RecordType.DeveloperName)) {
            cot.User_Role__c = caseRec.Owner.UserRole.Name;
            cot.User_Profile__c = caseRec.Owner.Profile.Name;
          }
        }
        ownershipTrackings.add(cot);
      }
      if (ownershipTrackings.size() > 0) {
        insert ownershipTrackings;
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  createCaseOwnershipTrackingRecord
   *   @description:   This method creates case ownership tracking records for Case object. This method also updates end time in previous case ownership record.
   *                   This method is used in after update trigger.
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void createCaseOwnershipTrackingRecord(List<Case> newCases, List<Case> oldCases) {
    try {
      Map<Id, String> queueIdAndNameMap = new Map<Id, String> ();
      //Get all the queues
      /*for(Group GroupObj : [  SELECT  Id, Name
        FROM    Group
        where   Type = 'Queue'
        limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ]){
        queueIdAndNameMap.put( GroupObj.Id, GroupObj.Name );
        }*/
      for (Group GroupObj : ConstantsController.groups) {
        queueIdAndNameMap.put(GroupObj.Id, GroupObj.Name);
      }
      Integer workingHours;
      /*BusinessHours defaultBusinessHours = [    SELECT  IsActive, Id
        FROM    BusinessHours
        where   IsActive= true
        and IsDefault = true
        limit   1 ];    */
      BusinessHours defaultBusinessHours = ConstantsController.defaultBusinessHours;
      /*List<LGNA_Constants__c> lgnaConstants = [ select  Total_Working_Hours_per_Day__c
        from    LGNA_Constants__c
        limit   1 ];
        if( lgnaConstants.size() > 0 ) {
        workingHours = ( Integer )lgnaConstants[0].Total_Working_Hours_per_Day__c;
        }
        else {
        workingHours = 9;
        }*/
      for (LGNA_Constants__c temp : LGNA_Constants__c.getAll().values()) {
        if (temp.name == 'Default') {
          workingHours = (Integer) temp.Total_Working_Hours_per_Day__c;
        }
      }
      if (workingHours == null)
        workingHours = 9;
      List<Case_Ownership_Tracking__c> ownershipTrackings = new List<Case_Ownership_Tracking__c> ();
      Case newCase;
      Case oldCase;
      Set<Id> caseIdsUnderContext = new Set<Id> ();
      set<String> allowedRecordTypeNames = new set<String> ();
      set<String> allowedRecordTypeIds = new set<String> ();
      for (CaseOwnerShip_Record_Creation_Settings__c crc : CaseOwnerShip_Record_Creation_Settings__c.getAll().values()) {
        if (crc.Create_CaseOwnership_Record__c)
          allowedRecordTypeNames.add(crc.Name);
      }
      List<RecordType> recordTypeLists = [select Id from RecordType where DeveloperName In :allowedRecordTypeNames and SobjectType = :String.valueOf(sObjectType.Case)];
      for (RecordType rt : recordTypeLists) {
        allowedRecordTypeIds.add(rt.Id);
      }
      for (Integer index = 0; index < newCases.size(); index++) {
        if ((newCases[index].OwnerId != oldCases[index].OwnerId)
            || (newCases[index].IsClosed != oldCases[index].IsClosed)) {

          caseIdsUnderContext.add(newCases[index].Id);
        } else if (allowedRecordTypeIds.contains(newCases[index].RecordTypeId) && newCases[index].Status != oldCases[index].Status) {
          caseIdsUnderContext.add(newCases[index].Id);
        }
      }

      List<Case> casesUnderContext = [select Id, Subject, Status, RecordTypeId, IsClosed, OwnerId, Owner.UserRole.Name, Owner.Profile.Name,
                                      (select Id, Start__c, End__c, Case__r.Id from Case_Ownership_Tracking__r where End__c = null order by CreatedDate DESC)
                                      from Case
                                      where Id IN :caseIdsUnderContext
                                      limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];

      /* Map<Id, List<Case_Ownership_Tracking__c>> caseToOwnershipTrackingRecords = new Map<Id, List<Case_Ownership_Tracking__c>>();

        for( Case_Ownership_Tracking__c ownershipTracking :[    select  Id, End__c, Case__r.Id
        from    Case_Ownership_Tracking__c
        where   End__c = null
        order by CreatedDate DESC
        limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ])
        {
        if( !caseToOwnershipTrackingRecords.containsKey( ownershipTracking.Case__r.Id ) ) {
        caseToOwnershipTrackingRecords.put( ownershipTracking.Case__r.Id, new List<Case_Ownership_Tracking__c>() );
        }
        caseToOwnershipTrackingRecords.get( ownershipTracking.Case__r.Id ).add( ownershipTracking );
        }*/

      List<Case_Ownership_Tracking__c> caseOwnershipTrackings = new List<Case_Ownership_Tracking__c> ();

      for (Case caseRec : casesUnderContext) {
        /* if( caseToOwnershipTrackingRecords.containsKey( caseRec.Id )  ) {

          caseOwnershipTrackings =  caseToOwnershipTrackingRecords.get( caseRec.Id ) ;

          if( caseOwnershipTrackings != null && caseOwnershipTrackings.size() > 0 ) {
          for( Case_Ownership_Tracking__c cot : caseOwnershipTrackings ) {
          cot.End__c = System.now();
          ownershipTrackings.add( cot );
          }
          }
          }*/
        for (Case_Ownership_Tracking__c cot : caseRec.Case_Ownership_Tracking__r) {
          cot.End__c = System.now();

          ownershipTrackings.add(cot);
        }

        if (!caseRec.IsClosed) {
          Case_Ownership_Tracking__c cot = new Case_Ownership_Tracking__c();
          cot.Case__c = caseRec.Id;
          cot.Start__c = System.now();
          if (allowedRecordTypeIds.contains(caseRec.RecordTypeId))
            cot.Case_Status__c = caseRec.Status;
          //if the original owner is a queue, update the "Queue" field
          if (Schema.Group.SObjectType == caseRec.OwnerId.getSobjectType()) {
            cot.Queue__c = queueIdAndNameMap.get(caseRec.OwnerId);
          }
          //if the original owner is a user, update the "User" field
          else if (Schema.User.SObjectType == caseRec.OwnerId.getSobjectType()) {
            cot.User__c = caseRec.OwnerId;
            if (allowedRecordTypeIds.contains(caseRec.RecordTypeId)) {
              cot.User_Role__c = caseRec.Owner.UserRole.Name;
              cot.User_Profile__c = caseRec.Owner.Profile.Name;
            }
          }
          ownershipTrackings.add(cot);
        }
      }

      if (ownershipTrackings.size() > 0 && ConstantsController.shouldContinueWithOwnerCreation) {
        ConstantsController.shouldContinueWithOwnerCreation = false;
        upsert ownershipTrackings;
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  updateAssignedToOnCase
   *   @description:   This method updates the assigned to of a record when a case is being taken from Case Queues Page.
   *                    This method is used for the before update scenario.
   *   @parameters     List<Case> newCases : Cases under current context.
   *                    List<Case> oldCases : Old values of the cases under context.
   *   @return type    void
   */
  public static void updateAssignedToOnCase(List<Case> newCases, List<Case> oldCases) {
    try {
      Case newCase;
      Case oldCase;
      Map<String, Boolean> QueueNameAndUpdateMap = new Map<String, Boolean> ();
      Set<String> QueueNames = new Set<String> ();
      Map<Id, String> QueueNameAndIdMap = new Map<Id, String> ();

      List<Queue_Names__c> listOfQueueNames = Queue_Names__c.getAll().values();
      for (Queue_Names__c queueNameObj : listOfQueueNames) {
        QueueNameAndUpdateMap.put(queueNameObj.Name, queueNameObj.Update__c);
        QueueNames.add(queueNameObj.Name);
      }
      List<Group> groupList2 = [SELECT Id, Name FROM Group WHERE Name IN :QueueNames limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
      for (Group groupObj : groupList2) {
        QueueNameAndIdMap.put(groupObj.Id, groupObj.Name);
      }

      for (Integer index = 0; index < newCases.size(); index++) {
        newCase = newCases[index];
        oldCase = oldCases[index];
        //if the case is assigned to a partner or a partner is changed
        if (newCase.OwnerId != oldCase.OwnerId) {

          //if the Old owner is a queue and the new Owner is a user then update the "Assigned To" to the new owner
          if (Schema.Group.SObjectType == oldCase.OwnerId.getSobjectType() && Schema.User.SObjectType == newCase.OwnerId.getSobjectType()) {
            if (QueueNameAndIdMap.containsKey(oldCase.OwnerId)) {
              if (QueueNameAndUpdateMap.containsKey(QueueNameAndIdMap.get(oldCase.OwnerId)) && QueueNameAndUpdateMap.get(QueueNameAndIdMap.get(oldCase.OwnerId)))
                newCase.Assigned_To__c = newCase.OwnerId;
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }
  /*  updateAssignedToOnCase
   *   @description:   This method updates the assigned to of a record when a case is being manually created.
    This method is used for the before insert scenario.
   *   @parameters     List<Case> newCases : Cases under current context.

   *   @return type    void
   */
  public static void updateAssignedToOnCase(List<Case> newCases) {
    try {
      Case newCase;
      for (Integer index = 0; index < newCases.size(); index++) {
        newCase = newCases[index];
        //in email to case scenario, do not update the assigned to
        if (newCase.SuppliedEmail == null && newCase.Origin != 'Email') {
          //if new case owner is a user
          if (Schema.User.SObjectType == newCase.OwnerId.getSobjectType()) {
            newCase.Assigned_To__c = newCase.OwnerId;
          }

        }
      }
    } catch (Exception e) {
      System.debug('Exception : ' + e.getMessage());
    }
  }

  /*  updateAssignedToOnCase
   *   @description:   This method carry overs Account Number Esales from Case to its associated Account
    This method is used for the after insert/update scenario.
   *   @parameters     Map<Id,Case> CaseNewMap : Cases new Map Map<Id,Case> CaseOldMap : Cases old map

   *   @return type    void
   */
  public static void updateAccountNumberEsales(Map<Id, Case> CaseNewMap, Map<Id, Case> CaseOldMap) {
    try {
      Id CaseRecordTypeMidMarket = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mid-Market Underwriting').getRecordTypeId();
      Set<Id> AccountIdSet = new Set<Id> ();
      List<Case> CaseList = new List<Case> ();
      List<Account> AccountUpdateList = new List<Account> ();
      for (Case cs : CaseNewMap.values()) {
        if (cs.RecordTypeId == CaseRecordTypeMidMarket && cs.Account_Number_eSales__c != null && cs.Account_Number_eSales__c != CaseOldMap.get(cs.Id).Account_Number_eSales__c) {
          AccountIdSet.add(cs.AccountId);
          CaseList.add(cs);
        }
      }
      if (!AccountIdSet.isEmpty()) {
        Map<Id, Account> AccountMap = new Map<Id, Account> ([SELECT Id, External_ID__c FROM Account where Id IN :AccountIdSet limit :Limits.getLimitQueryRows() - Limits.getQueryRows()]);
        for (Case cs : CaseList) {
          if (AccountMap.get(cs.AccountId).External_ID__c == null) {
            AccountMap.get(cs.AccountId).External_ID__c = cs.Account_Number_eSales__c;
            AccountUpdateList.add(AccountMap.get(cs.AccountId));
          }
        }
        if (AccountUpdateList.size() > 0) {
          update AccountUpdateList;
        }
      }
    } catch (Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.updateAccountNumberEsales()', 'High');
    }
  }

  /*  updateCustomContractFields
   *   @description:   Fill in the Account Executive, Account Executive Phone, Requestor, Requestor Number,
    and State fields based on the Parent Account and Case creator information

   *   @parameters     List<Case> newCases : Cases under current context.

   *   @return type    void
   */
  public static void updateCustomContractFields(List<Case> newCases) {
    try {
      List<Case> customContracts = new List<Case> ();
      Set<Id> customContractsAccIds = new Set<Id> ();
      for (Case curCase : newCases) {
        if (curCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId()) {
          customContracts.add(curCase);
          if (curCase.AccountId != NULL) {
            customContractsAccIds.add(curCase.AccountId);
          }
        }
      }
      if (!customContracts.isEmpty()) {
        List<Account> customContractAccs = [SELECT Id, Name, OwnerId, HCSC_Division__c FROM Account WHERE Id IN :customContractsAccIds];
        Map<Id, Account> customContractAccsMap = new Map<Id, Account> ();
        for (Account acc : customContractAccs) {
          customContractAccsMap.put(acc.Id, acc);
        }

        Set<Id> accOwnerIds = new Set<Id> ();
        for (Account acc : customContractAccs) {
          accOwnerIds.add(acc.OwnerId);
        }

        User curUser;
        List<User> customContractAccExec = [SELECT Id, Phone FROM User WHERE Id IN :accOwnerIds OR Id = :UserInfo.getUserId()];
        Map<Id, User> accExec = new Map<Id, User> ();
        for (User person : customContractAccExec) {
          if (person.Id == UserInfo.getUserId()) {
            curUser = person;
            continue;
          }
          accExec.put(person.Id, person);
        }

        //User curUser = [SELECT Id, Phone FROM User WHERE Id = :UserInfo.getUserId()];

        for (Case curCase : newCases) {
          if (curCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId()) {
            curCase.Requestor_Name__c = UserInfo.getUserId();
            curCase.Requestor_Phone__c = curUser.Phone;
            if (curCase.AccountId != NULL) {
              Id curOwnerId = (customContractAccsMap.get(curCase.AccountId)).OwnerId;
              curCase.Account_Executive__c = curOwnerId;
              curCase.Account_Executive_Phone__c = (accExec.get(curOwnerId)).Phone;
              curCase.State__c = (customContractAccsMap.get(curCase.AccountId)).HCSC_Division__c;
            }
          }
        }
      }
    } catch (Exception e) {
      CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.updateCustomContractFields()', 'High');
    }
  }

  /*   createBlueDirectionsProductRecords()
   *   @description:   Creates Blue Directions Product Records based on the Exchange Lines of Business and Dearborn Benefit Type field's values chosen
   *           in a Parent Private Exchange - Blue Directions Case.  Method is run when there are no Blue Directions Product Records associated
   *           with the case.  The CountLOBRecords__c roll up summary field controlls this and this was added to handle cases created from the Opportunity Playbook.

   *   @parameters     List<Case> newCases : Cases that were inserted.

   *   @return type    void

   *  @author     Nick Serafin/Slalom LLC
   */

  public static void createBlueDirectionsProductRecords(List<Case> newCases) {

    try {
      List<Blue_Directions_LOB__c> blueDirectionsLOBtoInsert = new List<Blue_Directions_LOB__c> ();
      Id privateExchangeBlueDirectionRTId = Schema.SobjectType.Case.getRecordTypeInfosByName().get(Label.Case_Private_Exchange_Blue_Directions).getRecordTypeId();
      Id privateExchangeExternalRTId = Schema.SobjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypePrivateExchangeExternal).getRecordTypeId();
      Id LOBMedicalExternalRTId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.External_medical_recordtype).getRecordTypeId();

      Set<Id> caseId = new Set<Id> ();
      List<List<Case>> blueDirectionsCases = new List<List<Case>> ();
      List<List<Case>> blueDirectionsDearbornCases = new List<List<Case>> ();
      Schema.DescribeFieldResult exchangeLinesofBusiness = Case.Exchange_Lines_of_Business__c.getDescribe();
      List<Schema.PicklistEntry> exchangeLinesofBusinessChoices = exchangeLinesofBusiness.getPicklistValues();

      List<Schema.PicklistEntry> newexchangeLinesofBusinessChoices = new List<Schema.PicklistEntry> ();

      for (Schema.PicklistEntry f : exchangeLinesofBusinessChoices) {
        if (f != null && f.getLabel() != Label.Dearborn) {
          newexchangeLinesofBusinessChoices.add(f);
        }
      }

      Schema.DescribeFieldResult dearbornBenefitType = Case.LGNA_Dearborn_Benefit_Type__c.getDescribe();
      List<Schema.PicklistEntry> dearbornBenefitTypeChoices = dearbornBenefitType.getPicklistValues();

      Map<String, Id> lobRecordTypeMap = new Map<String, Id> ();

      for (Schema.PicklistEntry f : newexchangeLinesofBusinessChoices) {
          if(f != null){
            lobRecordTypeMap.put(f.getLabel(), Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(f.getLabel()).getRecordTypeId());
          }
      }

      Map<String, Id> lobRecordTypeMapDearborn = new Map<String, Id> ();

      for (Schema.PicklistEntry f : dearbornBenefitTypeChoices) {
          if(f != null){          
            lobRecordTypeMapDearborn.put(f.getLabel(), Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(f.getLabel()).getRecordTypeId());
          }
      }

      for (Schema.PicklistEntry f : newexchangeLinesofBusinessChoices) {
          if(f != null){          
            blueDirectionsCases.add(new List<Case> ());
          }
      }

      for (Schema.PicklistEntry f : dearbornBenefitTypeChoices) {
          if(f != null){          
            blueDirectionsDearbornCases.add(new List<Case> ());
          }
      }

      for (Case curCase : newCases) {
        if (curCase.recordTypeID == privateExchangeBlueDirectionRTId || curCase.recordTypeID == privateExchangeExternalRTId) {
          if (curCase.Exchange_Sub_Case__c == false) {
            if (curCase.CountLOBRecords__c == 0) {
              for (Integer i = 0; i < newexchangeLinesofBusinessChoices.size(); i++) {
                if (curCase.Exchange_Lines_of_Business__c != null && curCase.Exchange_Lines_of_Business__c.contains(newexchangeLinesofBusinessChoices[i].getValue())) {
                  blueDirectionsCases[i].add(curCase);
                }
              }
              for (Integer i = 0; i < dearbornBenefitTypeChoices.size(); i++) {
                if (curCase.LGNA_Dearborn_Benefit_Type__c != null && curCase.LGNA_Dearborn_Benefit_Type__c.contains(dearbornBenefitTypeChoices[i].getValue())) {
                  blueDirectionsDearbornCases[i].add(curCase);
                }
              }
            }
          }
        }
      }

      for (Integer i = 0; i < blueDirectionsCases.size(); i++) {
        if (blueDirectionsCases[i].size() > 0) {
          List<Blue_Directions_LOB__c> blueDirectionsLOB = new List<Blue_Directions_LOB__c> ();
          for (Case curCase : blueDirectionsCases[i]) {
            Blue_Directions_LOB__c lob = new Blue_Directions_LOB__c();
            lob.Case_Number__c = curCase.Id;
            if (curCase.recordTypeID == privateExchangeExternalRTId) {
              lob.RecordTypeId = LOBMedicalExternalRTId;
            } else {
              lob.RecordTypeId = lobRecordTypeMap.get(exchangeLinesofBusinessChoices[i].getValue());
            }
            if (exchangeLinesofBusinessChoices[i].getValue() == Label.Medical || exchangeLinesofBusinessChoices[i].getValue() == Label.Dental) {
              Integer year = curCase.Effective_Date__c.year();
              String planYear = String.valueof(year);
              lob.Blue_Directions_Plan_Year__c = planYear;
              if (planYear == Label.PrivateExchangeYear) {
                lob.Medical_HCSC_Division__c = curCase.HCSC_Division__c + Label.PrivateExchangeYearStateAddition;
              } else {
                lob.Medical_HCSC_Division__c = curCase.HCSC_Division__c;
              }
            }
            blueDirectionsLOB.add(lob);
          }
          blueDirectionsLOBtoInsert.addAll(blueDirectionsLOB);
        }
      }

      for (Integer i = 0; i < blueDirectionsDearbornCases.size(); i++) {
        if (blueDirectionsDearbornCases[i].size() > 0) {
          List<Blue_Directions_LOB__c> blueDirectionsLOBDearborn = new List<Blue_Directions_LOB__c> ();
          for (Case curCase : blueDirectionsDearbornCases[i]) {
            Blue_Directions_LOB__c dearbornLOB = new Blue_Directions_LOB__c();
            dearbornLOB.Case_Number__c = curCase.Id;
            dearbornLOB.RecordTypeId = lobRecordTypeMapDearborn.get(dearbornBenefitTypeChoices[i].getValue());
            blueDirectionsLOBDearborn.add(dearbornLOB);
          }
          blueDirectionsLOBtoInsert.addAll(blueDirectionsLOBDearborn);
        }
      }

      if (blueDirectionsLOBtoInsert.size() > 0) {
        insert blueDirectionsLOBtoInsert;
      }

    } catch (Exception e) {
      System.debug(Label.Exception + e.getMessage());
    }

  }
 
   /****************************************************************************************************** 
   *  checkIfModifiedBlueDirectionsProductRecords()
   *   @description:   Checks Blue Directions Products that are related to a given case to see if they have data entered in them.
   *           If they are not modified and the case status is changed to submitted or Assigned then an error is thrown telling
   *           the user to fill out the remaining records before moving the status of the case forward.
   *   @parameters     List<Case> newCases : Cases that were updated.
   *   @return type    void
   *   @author     Nick Serafin/Slalom LLC
   *******************************************************************************************************/
  /*** start SFDC-6677 ***/
  /*public static void checkIfModifiedBlueDirectionsProductRecords(List<Case> newCases) {

    try {
      Id privateExchangeBlueDirectionRTId = Schema.SobjectType.Case.getRecordTypeInfosByName().get(Label.Case_Private_Exchange_Blue_Directions).getRecordTypeId();
      Id privateExchangeExternalRTId = Schema.SobjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypePrivateExchangeExternal).getRecordTypeId();

      List<Case> casesToCheck = new List<Case>();
      Set<Id> caseId = new Set<Id> ();
      String recordNotModified;

      for (Case curCase : newCases) {
        if (curCase.RecordTypeId == privateExchangeBlueDirectionRTId || curCase.RecordTypeId == privateExchangeExternalRTId ) {
          if (curCase.CountLOBRecords__c != 0) {
            if (curCase.Exchange_Sub_Case__c == false) {
              caseId.add(curCase.Id);
              casesToCheck.add(curCase);
            }
          }
        }
      }

      Id BlueDirectionLOBMedicalId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.BlueDirectionsRecordTypeMedical).getRecordTypeId();
      Id BlueDirectionLOBDentalId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.BlueDirectionsRecordTypeDental).getRecordTypeId();
	  //Id BlueDirectionLOBMedicalId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Medical).getRecordTypeId();
	  //Id BlueDirectionLOBDentalId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dental).getRecordTypeId();
      Id BlueDirectionLOBDTLId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dearborn_Term_Life).getRecordTypeId();
      Id BlueDirectionLOBDDId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dearborn_Disability).getRecordTypeId();
      Id BlueDirectionLOBDCIId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dearborn_Critical_Illness).getRecordTypeId();

      List<Blue_Directions_LOB__c> lobRecordsToBeUpdated = new List<Blue_Directions_LOB__c> ();

      if (casesToCheck.size() > 0) {

        List<Blue_Directions_LOB__c> lobExistingRecords = new List<Blue_Directions_LOB__c> ();
        lobExistingRecords = [SELECT Id, Case_Number__c, CreatedDate, LastModifiedDate, RecordTypeId FROM Blue_Directions_LOB__c WHERE Case_Number__c IN :caseId];

        Map<Id, List<Blue_Directions_LOB__c>> lobRecordsToCheck = new Map<Id, List<Blue_Directions_LOB__c>>();

        for (Blue_Directions_LOB__c lobRecords : lobExistingRecords) {

          List<Blue_Directions_LOB__c> lobList = new List<Blue_Directions_LOB__c> ();

          if (lobRecordsToCheck.containsKey(lobRecords.Case_Number__c)) {
            lobList = lobRecordsToCheck.get(lobRecords.Case_Number__c);
          }

          lobList.add(lobRecords);
          lobRecordsToCheck.put(lobRecords.Case_Number__c, lobList);
        }

        for (Case curCase : casesToCheck) {

          recordNotModified = '';

          for (Blue_Directions_LOB__c lobRecords : lobRecordsToCheck.get(curCase.Id)) {
            if (lobRecords.RecordTypeId == BlueDirectionLOBMedicalId) {
              if (lobRecords.LastModifiedDate == lobRecords.CreatedDate) {
                recordNotModified += Label.Medical + ', ';
              }
            } else if (lobRecords.RecordTypeId == BlueDirectionLOBDentalId) {
              if (lobRecords.LastModifiedDate == lobRecords.CreatedDate) {
                recordNotModified += Label.Dental + ', ';
              }
            } else if (lobRecords.RecordTypeId == BlueDirectionLOBDTLId) {
              if (lobRecords.LastModifiedDate == lobRecords.CreatedDate) {
                recordNotModified += Label.Dearborn_Term_Life + ', ';
              }
            } else if (lobRecords.RecordTypeId == BlueDirectionLOBDDId) {
              if (lobRecords.LastModifiedDate == lobRecords.CreatedDate) {
                recordNotModified += Label.Dearborn_Disability + ', ';
              }
            } else if (lobRecords.RecordTypeId == BlueDirectionLOBDCIId) {
              if (lobRecords.LastModifiedDate == lobRecords.CreatedDate) {
                recordNotModified += Label.Dearborn_Critical_Illness + ', ';
              }
            }
          }

          if ((curCase.Status == Label.CaseStatusSubmitted || curCase.Status == Label.CaseStatusAssigned) && curCase.Bypass_Validation__c == False) {
            if (String.isNotBlank(recordNotModified)) {
              recordNotModified = recordNotModified.removeEnd(' ');
              recordNotModified = recordNotModified.removeEnd(',');
              curCase.addError(Label.PEBD_Records_Not_FIlled_Out_Error + ' ' + recordNotModified);
            }
          }
        }
      }
    } catch (Exception e) {
      System.debug(Label.Exception + e.getMessage());
    }
  }*/
  /*** end SFDC-6677 ***/    

  /*   updateBlueDirectionsProductRecords()
   *   @description:  Updates Blue Directions Product Records Child_Case__c field with the case Id from the child cases created in the method
   *          clonePrivateExchangeRecords().

   *   @parameters     List<Case> newCases : Cases that were inserted.

   *   @return type    void

   *  @author     Nick Serafin/Slalom LLC
   */

  public static void updateBlueDirectionsProductRecords(List<Case> newCases) {

    try {
      Id privateExchangeBlueDirectionRTId = Schema.SobjectType.Case.getRecordTypeInfosByName().get(Label.Case_Private_Exchange_Blue_Directions).getRecordTypeId();
      Id privateExchangeExternalRTId = Schema.SobjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypePrivateExchangeExternal).getRecordTypeId();

      Set<Id> parentCaseIds = new Set<Id> ();
      List<Case> casesToCheck = new List<Case>();

      for (Case curCase : newCases) {
        if (curCase.RecordTypeId == privateExchangeBlueDirectionRTId || curCase.RecordTypeId == privateExchangeExternalRTId) {
          if (curCase.Exchange_Sub_Case__c == true) {
            if (curCase.ParentId != null) {
              parentCaseIds.add(curCase.ParentId);
              casesToCheck.add(curCase);
            }
          }
        }
      }

      Id BlueDirectionLOBMedicalId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Medical).getRecordTypeId();
      Id BlueDirectionLOBDentalId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dental).getRecordTypeId();
      Id BlueDirectionLOBDTLId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dearborn_Term_Life).getRecordTypeId();
      Id BlueDirectionLOBDDId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dearborn_Disability).getRecordTypeId();
      Id BlueDirectionLOBDCIId = Schema.SobjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get(Label.Dearborn_Critical_Illness).getRecordTypeId();

      List<Blue_Directions_LOB__c> lobRecordsToBeUpdated = new List<Blue_Directions_LOB__c> ();

      if (casesToCheck.size() > 0) {

        List<Blue_Directions_LOB__c> lobExistingRecords = new List<Blue_Directions_LOB__c> ();
        lobExistingRecords = [SELECT Id, Case_Number__c, RecordTypeId, Child_Case__c FROM Blue_Directions_LOB__c WHERE Case_Number__c IN :parentCaseIds];

        Map<Id, List<Blue_Directions_LOB__c>> lobRecordsToCheck = new Map<Id, List<Blue_Directions_LOB__c>>();

        for (Blue_Directions_LOB__c lobRecords : lobExistingRecords) {

          List<Blue_Directions_LOB__c> lobList = new List<Blue_Directions_LOB__c> ();

          if (lobRecordsToCheck.containsKey(lobRecords.Case_Number__c)) {
            lobList = lobRecordsToCheck.get(lobRecords.Case_Number__c);
          }

          lobList.add(lobRecords);
          lobRecordsToCheck.put(lobRecords.Case_Number__c, lobList);
        }

        for (Case curCase : casesToCheck) {
          for (Blue_Directions_LOB__c lobRecords : lobRecordsToCheck.get(curCase.ParentId)) {
            if (lobRecords.Child_Case__c == null) {
              if (curCase.Exchange_Lines_of_Business__c.contains(Label.Medical) && lobRecords.RecordTypeId == BlueDirectionLOBMedicalId) {
                lobRecords.Child_Case__c = curCase.Id;
                lobRecordsToBeUpdated.add(lobRecords);
              } else if (curCase.Exchange_Lines_of_Business__c.contains(Label.Dental) && lobRecords.RecordTypeId == BlueDirectionLOBDentalId) {
                lobRecords.Child_Case__c = curCase.Id;
                lobRecordsToBeUpdated.add(lobRecords);
              } else if (curCase.Exchange_Lines_of_Business__c.contains(Label.Dearborn)) {
                if (lobRecords.RecordTypeId == BlueDirectionLOBDTLId) {
                  lobRecords.Child_Case__c = curCase.Id;
                  lobRecords.Bypass_Validation__c = True;
                  lobRecordsToBeUpdated.add(lobRecords);
                }
                if (lobRecords.RecordTypeId == BlueDirectionLOBDDId) {
                  lobRecords.Child_Case__c = curCase.Id;
                  lobRecordsToBeUpdated.add(lobRecords);
                }
                if (lobRecords.RecordTypeId == BlueDirectionLOBDCIId) {
                  lobRecords.Child_Case__c = curCase.Id;
                  lobRecordsToBeUpdated.add(lobRecords);
                }
              }
            }
          }
        }

        if (lobRecordsToBeUpdated.size() > 0) {
          update lobRecordsToBeUpdated;
        }
      }
    } catch (Exception e) {
      System.debug(Label.Exception + e.getMessage());
    }
  }

  /*  clonePrivateExchangeRecords
   *   @description:   Creates Private Exchange Sub Cases

   *   @parameters     List<Case> updatedCases : Cases that were updated.
    map<Id, Case> oldCaseMap : Contains the state of the Cases before updated

   *   @return type    void

   *  @author     Ralph Tariga/Slalom LLC
   *  @updated by   Alec Klein/Slalom LLc
   *  @updated by   Nick Serafin/Slalom LLc
   */
  public static void clonePrivateExchangeRecords(List<Case> updatedCases, map<Id, Case> oldCaseMap) {

    Map<Id, Schema.RecordTypeInfo> recTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosById();

    List<List<Case>> blueDirectionsCases = new List<List<Case>> ();
    Schema.DescribeFieldResult exchangeLinesofBusiness = Case.Exchange_Lines_of_Business__c.getDescribe();
    List<Schema.PicklistEntry> exchangeLinesofBusinessChoices = exchangeLinesofBusiness.getPicklistValues();
    for (Integer i = 0; i < exchangeLinesofBusinessChoices.size(); i++) {
      blueDirectionsCases.add(new List<Case> ());
    }

    List<List<Case>> externalCases = new List<List<Case>> ();
    Schema.DescribeFieldResult exchangePlatform = Case.Group_Exchange_Platform__c.getDescribe();
    List<Schema.PicklistEntry> exchangePlatformChoices = exchangePlatform.getPicklistValues();
    for (Integer i = 0; i < exchangePlatformChoices.size(); i++) {
      externalCases.add(new List<Case> ());
    }

    for (Case curCase : updatedCases) {
      if (curCase.Status == Label.CaseStatusAssigned && oldCaseMap.get(curCase.Id).Status == Label.CaseStatusSubmitted && curCase.Exchange_Sub_Case__c != true) {
        String recTypeName = recTypeMap.get(curCase.recordTypeID).getName();
        if (recTypeMap.get(curCase.recordTypeID).getName().containsIgnoreCase(Label.CaseRecordTypePrivateExchangeBlueDirections)) {
          for (Integer i = 0; i < exchangeLinesofBusinessChoices.size(); i++) {
            if (curCase.Exchange_Lines_of_Business__c.contains(exchangeLinesofBusinessChoices[i].getValue())) {
              blueDirectionsCases[i].add(curCase);
            }
          }
        } else if (recTypeMap.get(curCase.recordTypeID).getName().containsIgnoreCase(Label.CaseRecordTypePrivateExchangeExternal)) {
          for (Integer i = 0; i < exchangePlatformChoices.size(); i++) {
            if (curCase.Group_Exchange_Platform__c.contains(exchangePlatformChoices[i].getValue())) {
              externalCases[i].add(curCase);
            }
          }
        }
      }
    }

    List<Case> masterList = new List<Case> ();

    for (Integer i = 0; i < blueDirectionsCases.size(); i++) {
      if (blueDirectionsCases[i].size() > 0) {
        List<Case> blueDirectionsClones = new List<Case> ();
        for (Case curCase : blueDirectionsCases[i]) {
          Case cloneCase = curCase.clone(false, true);
          cloneCase.ParentId = curCase.Id;
          blueDirectionsClones.add(cloneCase);
        }

        for (Case curCase : blueDirectionsClones) {
          curCase.Exchange_Lines_of_Business__c = exchangeLinesofBusinessChoices[i].getValue();
          curCase.Exchange_Sub_Case__c = true;
          curCase.Assigned_To__c = null;
          if (!curCase.Exchange_Lines_of_Business__c.contains(Label.Dearborn)) {
            curCase.LGNA_Dearborn_Benefit_Type__c = '';
          }
        }
        masterList.addAll(blueDirectionsClones);
      }
    }

    for (Integer i = 0; i < externalCases.size(); i++) {
      if (externalCases[i].size() > 0) {
        List<Case> externalClones = new List<Case> ();
        for (Case curCase : externalCases[i]) {
          Case cloneCase = curCase.clone(false, true);
          cloneCase.ParentId = curCase.Id;
          externalClones.add(cloneCase);
        }
        for (Case curCase : externalClones) {
          curCase.Group_Exchange_Platform__c = exchangePlatformChoices[i].getValue();
          curCase.Exchange_Sub_Case__c = true;
          curCase.Assigned_To__c = null;
        }
        masterList.addAll(externalClones);
      }
    }

    if (masterList.size() > 0) {
      insert masterList;
    }

  }

  /*  privateExchangeCheckSubCasesIfClosed
   *   @description:   Check if all the Sub Cases of a Parent Case are closed

   *   @parameters     List<Case> casesToUpdate      : Cases to be updated still containing original values.
    map<Id, Case> updatedCasesMap : Contains the updated Case values

   *   @return type    void

   *  @author     Ralph Tariga/Slalom LLC
   *  @updated by   Alec Klein/Slalom LLc
   *  @updated by   Nick Serafin/Slalom LLc
   */
  public static void privateExchangeCheckSubCasesIfClosed(List<Case> casesToUpdate, map<Id, Case> newMap, map<Id, Case> oldMap) {
    List<Case> casesToCheck = new List<Case> ();
    for (Case parent : casesToUpdate) {
      if (parent.Status == Label.CaseStatusClosed && oldMap.get(parent.Id).Status == Label.CaseStatusAssigned) {
        casesToCheck.add(parent);
      }
    }

    if (casesToCheck.size() > 0) {
      List<Case> curCases = [SELECT Id, Status, (SELECT Status FROM Cases) FROM Case WHERE Id IN :casesToCheck];
      for (Case curCase : curCases) {
        for (Case sub : curCase.Cases) {
          if (sub.Status != Label.CaseStatusClosed) {
            newMap.get(curCase.Id).addError(Label.CaseSubcaseErrorMsg1);
            break;
          }
        }
      }
    }
  }

  /*  updateTypeFieldOnCustomContract
   *  @developer:   Alec Klein/Slalom, LLC
   *  @date:      4/1/2016
   *   @description:   Fill the Type (Category) picklist with the selected value from the Type__c picklist
   *   @parameters     List<Case> newCases : Cases under current context.
   *   @return type    void
   */
  public static void updateTypeFieldOnCustomContract(List<Case> newCases) {
    try {
      for (Case curCase : newCases) {
        if (curCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId())
          curCase.Type = curCase.Type__c;
      }
    } catch (Exception e) {
      CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.updateTypeFieldOnCustomContract()', 'High');
    }
  }

  /*  updatePerformanceGuaranteeCaseOwner
   *  @developer: Ralph Tariga/Slalom, LLC
   *  @date: 6/20/2016
   *  @description: Sets PG Case Owner to Case Creator when Status is changed to Send Back for More Info
   *  @parameters: List<Case> casesToUpdate : Cases to be updated in the current context
   *               map<Id, Case> newMap : Cases' new values
   *               map<Id, Case> oldMap : Cases' old values
   *  @return type: void                                    
   */
  public static void updatePerformanceGuaranteeCaseOwner(List<Case> casesToUpdate, map<Id, Case> newMap, map<Id, Case> oldMap) {
    try {
      for (Case curCase : casesToUpdate) {
        if (curCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId()
            && newMap.get(curCase.Id).Status == ConstantsController.pgCaseStatusSentBackforMoreInfo
            && oldMap.get(curCase.Id).Status != newMap.get(curCase.Id).Status)
          curCase.OwnerId = curCase.CreatedById;
      }
    } catch (Exception e) {
      CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.updatePerformanceGuaranteeCaseOwner()', 'High');
    }
  }

   /*
  *  @developer: Alec Klein/Slalom, LLC
  *  @date: 6/21/2016
  *  @description: Before update trigger that creates children 'Line Item Review' records
            based on SME_Groups and Underwriter selections
  *  @parameters: Map<Id, Case> oldMap : original values
          Map<Id, Case> newMap : newly updated values
  *  @return type: void
  *  Developer      Modified Date   Description
  * Mark Naumann    7/14/2017       Modified code to prevent duplicate Line Items being created for: SME Groups & UW 
  */
  public static void updateLineItemReviews(Map<Id, Case> oldMap, Map<Id, Case> newMap) {
    try {
      LineItemReviewDAO.ILineItemReviewDAO lineItemReviewDAOInstance = new LineItemReviewDAO();
      GroupDAO.IGroupDAO groupDAOInstance = new GroupDAO();
      Id pgRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId();
      Id pgSMERecordTypeId = Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get(Label.LineItemReviewRecordTypePGSME).getRecordTypeId();
      Id pgUWRecordTypeId = Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get(Label.LineItemReviewRecordTypePGUW).getRecordTypeId();
      List<Line_Item_Review__c> newLineItemReviews = new List<Line_Item_Review__c>();
      List<Line_Item_Review__c> removedLineItemReviews = new List<Line_Item_Review__c>();
      Map<Id, Map<Id, Line_Item_Review__c> > existingLineItemReviewMap = new Map<Id, Map<Id, Line_Item_Review__c> >();
      Set<Id> pgCaseIds = new Set<Id>();
      Set<String> pgQueueNames = new Set<String>();
      Map<String, Group> smeQueueMap = new Map<String, Group>();

       
        
      for (Case c : newMap.values()) {
        if (c.RecordTypeId == pgRecordTypeId && (c.Ready_for_SME_Review__c || c.Ready_for_Underwriter__c)) {
          pgCaseIds.add(c.Id);
        }
      }

        
      List<Line_Item_Review__c> CurrentLineItemGroups = [Select OwnerId  from Line_Item_Review__c where Related_Case__c = :pgCaseIds];
        if (CurrentLineItemGroups != null || !CurrentLineItemGroups.isEmpty()){          
        
     
                      
      List<Schema.PicklistEntry> smeGroupsPicklistValues = Case.getSObjectType().getDescribe().fields.getMap().get('SME_Groups__c').getDescribe().getPickListValues();
      for (Schema.PicklistEntry picklistValue : smeGroupsPicklistValues) {
        pgQueueNames.add(picklistValue.getLabel());
      }
      List<Group> smeQueues = groupDAOInstance.getQueuesUsingNames(pgQueueNames);
      for (Group queue : smeQueues) {
        smeQueueMap.put(queue.Name, queue);
      }

      if (pgCaseIds.size() > 0) {
        List<Line_Item_Review__c> existingLineItemReviews = lineItemReviewDAOInstance.getLineItemReviewsUsingCases(pgCaseIds);
        for (Line_Item_Review__c currLIR : existingLineItemReviews) {
          if (!existingLineItemReviewMap.containsKey(currLIR.Related_Case__c)) {
            existingLineItemReviewMap.put(currLIR.Related_Case__c, new Map<Id, Line_Item_Review__c>());
            existingLineItemReviewMap.get(currLIR.Related_Case__c).put(currLIR.OwnerId, currLIR);
          } else {
            existingLineItemReviewMap.get(currLIR.Related_Case__c).put(currLIR.OwnerId, currLIR);
          }
        }
      }

// SME_InList    
      for (Id caseId : pgCaseIds) {
        Case oldCase = oldMap.get(caseId);
        Case currCase = newMap.get(caseId);
        if (oldCase.Ready_for_Underwriter__c && oldCase.SME_Groups__c != currCase.SME_Groups__c) {
          currCase.addError(Label.CasePGErrorSMESelections);
        } else if (!oldCase.Ready_for_SME_Review__c && currCase.Ready_for_SME_Review__c) {
          if (currCase.SME_Groups__c != null) {
            for (String queueName : currCase.SME_Groups__c.split(';')) {
              boolean SME_InList = Boolean.valueOf('false');               
              Line_Item_Review__c currLIR = new Line_Item_Review__c();
              currLIR.Disposition_Status__c = ConstantsController.dispositionStatusSubmitted;
              currLIR.Related_Case__c = currCase.Id;
              currLIR.OwnerId = smeQueueMap.get(queueName).Id;
              currLIR.RecordTypeId = pgSMERecordTypeId;
                
              for (Line_item_review__c SME_LIR : CurrentLineItemGroups){ 
                    if (SME_LIR.ownerid == currLIR.ownerid){
                        SME_InList = true;
                    } 
                }              
                                             
                if (!SME_InList){
                    newLineItemReviews.add(currLIR);    
                }      
            }
  // UW_InList          
            boolean UW_InList = Boolean.valueOf('false');             
            if (!oldCase.Ready_for_Underwriter__c &&
                currCase.Ready_for_Underwriter__c) {
              if (currCase.Underwriter_Lookup__c != null) {
                Line_Item_Review__c currLIR = new Line_Item_Review__c();
                currLIR.Disposition_Status__c = ConstantsController.dispositionStatusSubmitted;
                currLIR.Related_Case__c = currCase.Id;
                currLIR.OwnerId = currCase.Underwriter_Lookup__c;
                currLIR.RecordTypeId = pgUWRecordTypeId;

                for (Line_item_review__c UW_LIR : CurrentLineItemGroups){ 
                    if (UW_LIR.ownerid == currLIR.ownerid){
                        UW_InList = true;
                    } 
                }              
                                             
                if (!UW_InList){
                    newLineItemReviews.add(currLIR);    
                }                  
                
 
              }
            }
          }
        } else if (oldCase.SME_Groups__c != currCase.SME_Groups__c && oldCase.Ready_for_SME_Review__c &&
                   currCase.Ready_for_SME_Review__c && !currCase.Ready_for_Underwriter__c) {
          Set<String> oldGroups = new Set<String>();
          Set<String> newGroups = new Set<String>();
          Set<String> deletedGroups = new Set<String>();
          Set<String> addedGroups = new Set<String>();
          if (oldCase.SME_Groups__c != null) {
            for (String oldGroup : oldCase.SME_Groups__c.split(';')) {
              oldGroups.add(oldGroup);
            }
          }
          if (currCase.SME_Groups__c != null) {
            for (String newGroup : currCase.SME_Groups__c.split(';')) {
              newGroups.add(newGroup);
            }
          }
          for (String oldGroup : oldGroups) {
            if (!newGroups.contains(oldGroup)) {
              removedLineItemReviews.add(existingLineItemReviewMap.get(currCase.Id).get(smeQueueMap.get(oldGroup).Id));
            }
          }
          for (String newGroup : newGroups) {
            if (!oldGroups.contains(newGroup)) {
              Line_Item_Review__c currLIR = new Line_Item_Review__c();
              currLIR.Disposition_Status__c = ConstantsController.dispositionStatusSubmitted;
              currLIR.Related_Case__c = currCase.Id;
              currLIR.OwnerId = smeQueueMap.get(newGroup).Id;
              currLIR.RecordTypeId = pgSMERecordTypeId;
              newLineItemReviews.add(currLIR);
            }
          }
        } else if (oldCase.Ready_for_SME_Review__c && !oldCase.Ready_for_Underwriter__c &&
                   currCase.Ready_for_Underwriter__c) {
          if (currCase.Underwriter_Lookup__c != null) {
            Line_Item_Review__c currLIR = new Line_Item_Review__c();
            currLIR.Disposition_Status__c = ConstantsController.dispositionStatusSubmitted;
            currLIR.Related_Case__c = currCase.Id;
            currLIR.OwnerId = currCase.Underwriter_Lookup__c;
            currLIR.RecordTypeId = pgUWRecordTypeId;
            newLineItemReviews.add(currLIR);
          }
        } else if (oldCase.Ready_for_SME_Review__c && oldCase.Ready_for_Underwriter__c &&
                   currCase.Ready_for_Underwriter__c && oldCase.Underwriter_Lookup__c != currCase.Underwriter_Lookup__c) {
          for (Line_Item_Review__c currLIR : existingLineItemReviewMap.get(currCase.Id).values()) {
            if (currLIR.OwnerId == oldCase.Underwriter_Lookup__c) {
              removedLineItemReviews.add(currLIR);
              break;
            }
          }
          Line_Item_Review__c currLIR = new Line_Item_Review__c();
          currLIR.Disposition_Status__c = ConstantsController.dispositionStatusSubmitted;
          currLIR.Related_Case__c = currCase.Id;
          currLIR.OwnerId = currCase.Underwriter_Lookup__c;
          currLIR.RecordTypeId = pgUWRecordTypeId;
          newLineItemReviews.add(currLIR);
        }
      }
      if (newLineItemReviews.size() > 0) {
        lineItemReviewDAOInstance.insertLineItemReviews(newLineItemReviews);
      }
      if (removedLineItemReviews.size() > 0) {
        lineItemReviewDAOInstance.deleteLineItemReviews(removedLineItemReviews);
      }
     } // notes CurrentLineItemGroups         
    } catch (Exception e) {
      CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.updateLineItemReviews()', 'High');
    }
  }

    
  /*  lockPerformanceGuaranteeForAcctExecs
   *  @developer: Ralph Tariga/Slalom, LLC
   *  @date: 6/20/2016
   *  @description: Checks the Case Record Type, Case Status, and User Profile
   *                and prevents updates if certain conditions are met
   *  @parameters: List<Case> casesToUpdate : Cases to be updated in the current context
                   map<Id, Case> newMap : Contains the proposed new values for the case
                   map<Id, Case> oldMap : Contains the original Case Status before user tries to update the value.
                                          This is what needs to be checked and not the newer one.
   *  @return type: void
   */
  public void lockPerformanceGuaranteeForAcctExecs(List<Case> casesToUpdate, map<Id, Case> newMap, map<Id, Case> oldMap) {
    try {
      Id profileId = userinfo.getProfileId();
      String profileName = profileDAOInstance.getProfileById(profileId).Name;

      for (Case curCase : casesToUpdate) {
        if (oldMap.get(curCase.Id).RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId()
            && (oldMap.get(curCase.Id).Status != ConstantsController.pgCaseStatusNew && oldMap.get(curCase.Id).Status != ConstantsController.pgCaseStatusInProgress && oldMap.get(curCase.Id).Status != ConstantsController.pgCaseStatusSentBackforMoreInfo)
            && (profileName == ConstantsController.profileLGNAAcctMgmt || profileName == ConstantsController.profileLGNASales))
          newMap.get(curCase.Id).addError(Label.Performance_Guarantee_Case_Locked);
      }
    } catch (Exception e) {

    }
  }

  /*
   *  @developer: Ralph Tariga/Slalom, LLC
   *  @date: 6/21/2016
   *  @description: Before update trigger method that updates PG Cases' Status
   *                if certain checkboxes are checked
   *  @parameters: List<case> casesToUpdate : PG Cases to be checked
   *               Map<Id, Case> oldMap : Contains old values of PG Cases
   *  @return type: void
   */
public static void updatePerformanceGuaranteeStatus(List<case> casesToUpdate, map<Id, Case> oldMap) {
    try {
      for (Case curCase : casesToUpdate) {
        if (curCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId()) {
          if (curCase.Ready_for_Underwriter__c == true && oldMap.get(curCase.Id).Ready_for_Underwriter__c == false) {
            curCase.Status = ConstantsController.pgCaseStatusInternalHCSCUWReview;
          } else if (curCase.Ready_for_SME_Review__c == true && oldMap.get(curCase.Id).Ready_for_SME_Review__c == false) {
            curCase.Status = ConstantsController.pgCaseStatusInternalHCSCSMEReview;
          }
        }
      }
    } catch (Exception e) {

    }
  }

  /**
   * @author       Sana Fatima/Slalom
   * @description  Computes the Account Complexity Score for the Case object
   */
  public void updateAccountComplexityScoreForCase(List<Case> casesToUpdate, Map<Id, Case> oldMap) {
    Id performanceGuaranteeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.Performance_Guarantee ).getRecordTypeId();
    Id gemsAccountStructRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Structure ).getRecordTypeId();
    Id gemsAccountSubmissionRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Submission ).getRecordTypeId();
    Id groupAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();

    Set<Id> parentAccountIds = new Set<Id>();
    Map<Id, Account> groupAccounts = new Map<Id, Account>();

    for ( Case currCase : casesToUpdate ) {
      if ( !oldMap.isEmpty() && currCase.AccountId != null ) {
        if ( currCase.RecordTypeId == performanceGuaranteeRecordType ) {
          parentAccountIds.add(currCase.AccountId);
        } else if ( currCase.RecordTypeId == gemsAccountStructRecordType &&
                    (currCase.GEMS_Is_Account_Derivated__c != oldMap.get(currCase.Id).GEMS_Is_Account_Derivated__c
                     || currCase.GEMS_AEP_Account__c != oldMap.get(currCase.Id).GEMS_AEP_Account__c) ) {
          parentAccountIds.add(currCase.AccountId);
        } else if ( currCase.RecordTypeId == gemsAccountSubmissionRecordType &&
                    (currCase.GEMS_Is_Account_Derivated__c != oldMap.get(currCase.Id).GEMS_Is_Account_Derivated__c
                     || currCase.GEMS_AEP_Account__c != oldMap.get(currCase.Id).GEMS_AEP_Account__c) ) {
          parentAccountIds.add(currCase.AccountId);
        }
      } else if ( oldMap.isEmpty() && currCase.AccountId != null ) {
        if ( currCase.AccountId != null && (currCase.RecordTypeId == performanceGuaranteeRecordType || currCase.RecordTypeId == gemsAccountStructRecordType
                                            || currCase.RecordTypeId == gemsAccountSubmissionRecordType) ) {
          parentAccountIds.add(currCase.AccountId);
        }
      }
    }

    if ( !parentAccountIds.isEmpty() ) {
      groupAccounts = new Map<Id, Account>( accountDAOInstance.getCaseComplexityGroupAccounts(parentAccountIds, groupAccountRecordType) );
    }
    if ( !groupAccounts.isEmpty() ) {
      calculateCaseComplexityScore(groupAccounts);
    }
  }

  /**
  * @author       Sana Fatima/Slalom
  * @description  Computes the Account Complexity Score for the Case object
  */
  public void calculateCaseComplexityScore(Map<Id, Account> groupAccounts) {
    try {
      Id performanceGuaranteeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.Performance_Guarantee ).getRecordTypeId();
      Id gemsAccountStructRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Structure ).getRecordTypeId();
      Id gemsAccountSubmissionRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Submission ).getRecordTypeId();

      List<Case> childCases = new List<Case>();
      List<Account> accountsToUpdate = new List<Account>();
      Map<Id, List<Case>> caseToAccountMap = new Map<Id, List<Case>>();

      Decimal oldValue;

      Decimal hasPGCase;
      Decimal gemsAEPAccount;
      Decimal gemsIsAccountDerivated;

      childCases = caseDAOInstance.getPGAndGemsCases( groupAccounts, performanceGuaranteeRecordType, gemsAccountStructRecordType, gemsAccountSubmissionRecordType );

      //map cases to account id
      for ( Case currCase : childCases) {
        if ( caseToAccountMap.containsKey(currCase.AccountId) ) {
          caseToAccountMap.get(currCase.AccountId).add( currCase );
        } else {
          caseToAccountMap.put( currCase.AccountId, new List<Case> {currCase} );
        }
      }

      //iterate through accounts and their respective cases, calculating case complexity score
      for ( Account currAccount : groupAccounts.values() ) {
        oldValue = currAccount.ComplexityScoreCase__c;
        hasPGCase = 0;
        gemsAEPAccount = 0;
        gemsIsAccountDerivated = 0;

        childCases = new List<Case>();

        if ( caseToAccountMap.containsKey( currAccount.id ) ) {
          childCases = caseToAccountMap.get( currAccount.id );
        }

        for (Case currCase : childCases) {
          if ( currCase.RecordTypeId == performanceGuaranteeRecordType && ConstantsController.statuses.contains(currCase.Status) ) {
            hasPGCase = 5;
          }
          if ( currCase.RecordTypeId == gemsAccountStructRecordType || currCase.RecordTypeId == gemsAccountSubmissionRecordType ) {
            if ( currCase.GEMS_AEP_Account__c == true ) {
              gemsAEPAccount = 2;
            }
            if ( currCase.GEMS_Is_Account_Derivated__c == true ) {
              gemsIsAccountDerivated  = 1;
            }
          }
        }
        currAccount.ComplexityScoreCase__c = hasPGCase + gemsAEPAccount + gemsIsAccountDerivated;
        if ( currAccount.ComplexityScoreCase__c != oldValue) {
          accountsToUpdate.add(currAccount);
        }
      }
      if ( !accountsToUpdate.isEmpty() ) {
        accountDAOInstance.updateAccounts( accountsToUpdate );
      }
    } catch (Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.calculateCaseComplexityScore', 'High');
    }
  }

  public static void updateOpportunityIfPECase(List<Case> newCases) {

    try {
      Map<Id, List<Case>> opToCaseMap = new Map<Id, List<Case>>();
      final String PEBD_AND_PEE = 'Private Exchange - Blue Directions and External';
      final String PEE = 'Private Exchange - External';
      final String PEBD = 'Private Exchange - Blue Directions';

      Id pebdRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.Case_Private_Exchange_Blue_Directions ).getRecordTypeId();
      Id peeRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.Case_Private_Exchange_External ).getRecordTypeId();

      for (Case c : newCases) {
        if (c.Opportunity_Name__c != null && (c.RecordTypeId == pebdRecordTypeId || c.RecordTypeId == peeRecordTypeId)) {
          List<Case> cases = opToCaseMap.get(c.Opportunity_Name__c);
          if (cases == null) {
            cases = new List<Case>();
          }
          cases.add(c);
          opToCaseMap.put(c.Opportunity_Name__c, cases);
        }
      }

      if (!opToCaseMap.isEmpty()) {
        List<Opportunity> relatedOpps = [SELECT Id, Name, Exchange_Offering_Type__c FROM Opportunity WHERE Id In :opToCaseMap.keySet()];

        for (Opportunity o : relatedOpps) {

          List<Case> cases = opToCaseMap.get(o.Id);
          if (cases.size() > 1) {
            o.Exchange_Offering_Type__c = PEBD_AND_PEE;
          } else {
            if (cases[0].RecordTypeId == pebdRecordTypeId) {
              if (o.Exchange_Offering_Type__c == PEE)
                o.Exchange_Offering_Type__c = PEBD_AND_PEE;
              else
                o.Exchange_Offering_Type__c = PEBD;
            } else if (cases[0].RecordTypeId == peeRecordTypeId) {
              if (o.Exchange_Offering_Type__c == PEBD)
                o.Exchange_Offering_Type__c = PEBD_AND_PEE;
              else
                o.Exchange_Offering_Type__c = PEE;
            }
          }

        }

        update relatedOpps;
      }
    } catch (Exception e) {
      CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.updateOpportunityIfPECase()', 'High');
    }
  }

  public void populateContractSignerFields(List<Case> newCases) {

    try {

      Set<Id> caseAccountIds = new Set<Id>();
      Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Account_Group_Account_Record_Type).getRecordTypeId();
      Id prospectAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Prospect).getRecordTypeId();
      Id customContractsCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypeCustomContracts).getRecordTypeId();

      for (Case curCase : newCases) {

        if (curCase.RecordTypeId == customContractsCaseRecordTypeId) {
          caseAccountIds.add(curCase.AccountId);
        }
      }

      if (caseAccountIds.size() > 0) {

        Map<Id, Account> accountMap = new Map<Id, Account>();

        List<Account> acctsToCheck = accountDAOInstance.getAccountsForContractSignerCase(caseAccountIds, groupAccountRecordTypeId, prospectAccountRecordTypeId);

        for (Account curAcct : acctsToCheck) {

          Account newAcct = new Account();
          if (accountMap.containsKey(curAcct.Id)) {
            newAcct = accountMap.get(curAcct.Id);
          }
          newAcct = curAcct;
          accountMap.put(curAcct.Id, newAcct);
        }

        for (Case curCase : newCases) {

          if (curCase.RecordTypeId == customContractsCaseRecordTypeId) {

            Account acctRecord = accountMap.get(curCase.AccountId);
            curCase.Bypass_Validation__c = true;

            if (acctRecord.Contract_Signer__c != null) {
              curCase.Full_Name__c = acctRecord.Contract_Signer__r.FirstName + ' ' + acctRecord.Contract_Signer__r.LastName;
            } else {
              curCase.Full_Name__c = '';
            }

            curCase.Email__c = acctRecord.Contract_Signer__r.Email;
            curCase.Phone__c = acctRecord.Contract_Signer__r.Phone;
            curCase.Title__c = acctRecord.Contract_Signer__r.Title;

            if (acctRecord.RecordTypeId == groupAccountRecordTypeId) {
              curCase.Account_Type__c = Label.ProductTypeR;
              curCase.Underwriter_From_Account__c = acctRecord.Underwriter_Name__c;

            } else {
              curCase.Account_Type__c = Label.Prospect;
              if (acctRecord.Underwriter__c != null) {
                curCase.Underwriter_From_Account__c = acctRecord.Underwriter__r.FirstName + ' ' + acctRecord.Underwriter__r.LastName;
              } else {
                curCase.Underwriter_From_Account__c = '';
              }
            }
          }
        }
      }

    } catch (Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.populateContractSignerFields()', 'High');
    }
  }

  /**
    * @author               Sana Fatima/Slalom
    * @description          Creates SharePoint Folders for Cases
    * @param newCases   newCases from Trigger.new
    */
  public static void createSharePointFolder(List<Case> newCases) {
    try {
      Id sGGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SG - General Case').getRecordTypeId();
      //SFDC-5096 GEMS - Create Sharepoint folder for Account Maintenance
      Id caseCosmeticAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        
      List<Case> casesForCreate = new List<Case>();

      for (Case currCase : newCases) {
        if (( currCase.RecordTypeId != SGGeneralCase && currCase.Opportunity_Name__c != null) || (currCase.RecordTypeId == caseCosmeticAccountMaintenanceId)) {
         //if (currCase.RecordTypeId != SGGeneralCase && currCase.Opportunity_Name__c != null) { SDFC-5096
          casesForCreate.add( currCase );
        }
      }

      if ( !casesForCreate.isEmpty() ) {
        System.enqueueJob(new SharePointCaseManager( casesForCreate, new Map<Id, Case>() ));
      }
    } catch (Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CasetTriggerHelper.createSharePointFolder()', 'High');
    }
  }

  /**
    * @author               Sana Fatima/Slalom
    * @description          Updates SharePoint Folders for Cases
    * @param newCases   newCases from Trigger.new, oldCases from oldMap
    */
  public static void updateSharePointFolder(List<Case> newCases, Map<Id, Case> oldCases) {
    try {
      //method is commented out in Trigger since update does not need to run for case
      Id sGGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SG - General Case').getRecordTypeId();
      List<Case> casesToUpdate = new List<Case>();

      for (Case currCase : newCases) {
        if ( currCase.RecordTypeId != SGGeneralCase && currCase.Opportunity_Name__c != null) {
          casesToUpdate.add( currCase );
        }
      }
      if ( !casesToUpdate.isEmpty() ) {
        System.enqueueJob(new SharePointCaseManager( casesToUpdate, oldCases ));
      }
    } catch (Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHelper.updateSharePointFolder()', 'High');
    }
  }

  /*   populateAccountLineofBusiness()
  *   @description:   Populates the Line of Business field on the case account when case field line of business is populated.
  *   @parameters     List<Case> newCases : Cases that were updated.
  *   @return type    void
  *  @author     Al-Que Quiachon/Slalom LLC
  */
  public static void populateAccountLineofBusiness(List<Case> newCases, Map<Id, Case> oldMap) {
    Id gemsAccountSubmissionRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ConstantsController.GEMSAccountSubmissionRT).getRecordTypeId();

    List<Account> accountList = new List<Account>();
    for (Case currCase : newCases) {
      if (currCase.RecordTypeID == gemsAccountSubmissionRecordType && currCase.GEMS_Line_of_Business__c != null && currCase.AccountId != null) {

        if (oldMap == null) {

          Account accnt = new Account();
          accnt.Id = currCase.AccountId;
          accnt.Line_of_business__c = currCase.GEMS_Line_of_Business__c;
          accountList.add(accnt);
        }



        else if (currCase.GEMS_Line_of_Business__c != oldMap.get(currCase.Id).GEMS_Line_of_Business__c) {
          Account accnt = new Account();
          accnt.Id = currCase.AccountId;
          accnt.Line_of_business__c = currCase.GEMS_Line_of_Business__c;
          accountList.add(accnt);
        }
      }

    }
    try {
      if (accountList.size() != 0) {
        update accountList;
      }
    } catch (Exception ex) {
      System.debug('Could not update Account: ' + ex.getCause());
    }
  }

  /**
  * @author               Sana Fatima/Slalom
  * @description          Populates the Sales_Executive_Name text field from the lookup field.
  * @param newCases       newCases from Trigger.new, oldCases from oldMap
  */
  public static void populateSalesExecutiveNameField( List<Case> newCases, Map<Id, Case> oldCases ) {
    try {
      Id cbsrRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Benefit/Service').getRecordTypeId();

      List<Case> updatedCases = new List<Case>();
      Map<Id, User> salesExecs = new Map<Id, User>();
      Set<Id> salesExecIds = new Set<Id>();

      if ( oldCases.isEmpty() ) {
        for ( Case c : newCases ) {
          if ( c.RecordTypeId == cbsrRecTypeId ) {
            updatedCases.add(c);
          }
        }
        updatedCases = newCases;
      } else if ( !oldCases.isEmpty() ) {
        for ( Case c : newCases ) {
          if ( c.Sales_Executive__c != oldCases.get(c.Id).Sales_Executive__c && c.RecordTypeId == cbsrRecTypeId ) {
            updatedCases.add(c);
          }
        }
      }

      for ( Case c : updatedCases ) {
        if ( c.Sales_Executive__c != null) {
          salesExecIds.add( c.Sales_Executive__c );
        }
      }

      if ( !updatedCases.isEmpty() && !salesExecIds.isEmpty() ) {
        salesExecs = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN :salesExecIds]);
      }

      for ( Case c : updatedCases) {
        if ( salesExecs.get(c.Sales_Executive__c) != null ) {
          c.Sales_Executive_Name__c = salesExecs.get(c.Sales_Executive__c).Name;
        } else {
          c.Sales_Executive_Name__c = null;
        }
      }
    } catch (Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'CaseTriggerHandler.populateSalesExecutiveNameField()', 'High');
    }
  }

  /**
  * @author               Sana Fatima/Slalom
  * @description          Populates the Case Description to Account Description for Cede Cases
  * @param newCases       newCases from Trigger.new
  */
  public static void populateCaseDescriptionForCedeCases( List<Case> newCases ) {
    Id cedeRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Cede').getRecordTypeId();
    List<Case> casesToUpdate = new List<Case>();
    Set<Id> caseAccIds = new Set<Id>();
    Map<Id, Account> accMap;


    for ( Case c : newCases ) {
      if ( c.RecordTypeId == cedeRecTypeId && c.AccountId != null ) {
        caseAccIds.add(c.AccountId);
        casesToUpdate.add(c);
      }
    }

    if ( !caseAccIds.isEmpty() ) {
      accMap = new Map<Id, Account>([SELECT Id, Description FROM Account WHERE Id IN :caseAccIds]);
    }

    for ( Case c : casesToUpdate ) {
      if ( accMap.get(c.AccountId).Description != null ) {
        c.Description = accMap.get(c.AccountId).Description;
      }
    }
  }

}