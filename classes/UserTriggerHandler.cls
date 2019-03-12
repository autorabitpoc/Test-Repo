/**************************************************************************************
  Apex Class Name     : UserTriggerHandler
  Version             : 1.0
  Function            : This is a handler class for UserTrigger. The methods in this class are used as utility methods for UserTrigger
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Mayuri Bhadane       05/12/2015               Original Version
*************************************************************************************/
public with sharing class UserTriggerHandler {
    @testVisible private PermissionSetDAO.IPermissionSetDAO permissionSetDAOInstance;
    @testVisible private PermissionSetAssignmentDAO.IPermissionSetAssignmentDAO permissionSetAssignmentDAOInstance;
    @testVisible private static ContactDAO.IContactDAO contactDAOInstance = new ContactDAO();
    @testVisible private static UserDAO.IUserDAO userDAOInstance = new UserDAO();

    public UserTriggerHandler() {
        this(new PermissionSetDAO(), new PermissionSetAssignmentDAO());
    }

    @testVisible private UserTriggerHandler(PermissionSetDAO.IPermissionSetDAO permissionSetDAOInstance,
                                            PermissionSetAssignmentDAO.IPermissionSetAssignmentDAO permissionSetAssignmentDAOInstance) {
        this.permissionSetDAOInstance = permissionSetDAOInstance;
        this.permissionSetAssignmentDAOInstance = permissionSetAssignmentDAOInstance;
    }

    /***************************************************************************************************
            Method Name     : updateUserPermissionSets
            @usage          : This method is used for the before update scenario
            @description    : This method adds/removes the Super User/Strategic Plan management permission sets
                                based on the checkboxes on the User detail page
            @parameters     : List<User> newUsers, Map<Id, User> oldMap
            @return type    : void
     ****************************************************************************************************/
    public void updateUserPermissionSets(List<User> newUsers, Map<Id, User> oldMap) {
        List<PermissionSetAssignment> psAssignmentInsert    = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> psAssignmentDelete    = new List<PermissionSetAssignment>();
        Map<String, PermissionSet> permissionSetMap         = new Map<String, PermissionSet>();
        Set<Id> superUserIds                                = new Set<Id>();
        Set<Id> strategicPlanUserIds                        = new Set<Id>();
        String superUserLabel                               = System.Label.Super_User_Permissions;
        String strategicPlanLabel                           = System.Label.PermissionSetCanApproveStrategicPlans;

        try {
            List<PermissionSet> permissionSets = permissionSetDAOInstance.getSUAndSPPermissionSetList();
            for (PermissionSet ps : permissionSets) {
                permissionSetMap.put(ps.Name, ps);
            }
            for (User newUser : newUsers) {
                User oldUser = oldMap.get(newUser.Id);
                if (oldUser.Is_Super_User__c != newUser.Is_Super_User__c) {
                    if (newUser.Is_Super_User__c) {
                        PermissionSetAssignment paRecord = new PermissionSetAssignment();
                        paRecord.AssigneeId = newUser.Id;
                        paRecord.PermissionSetId = permissionSetMap.get(superUserLabel).Id;
                        psAssignmentInsert.add(paRecord);
                    } else {
                        superUserIds.add(newUser.Id);
                    }
                }
                if (oldUser.Can_Approve_Strategic_Plans__c != newUser.Can_Approve_Strategic_Plans__c) {
                    if (newUser.Can_Approve_Strategic_Plans__c) {
                        PermissionSetAssignment paRecord = new PermissionSetAssignment();
                        paRecord.AssigneeId = newUser.Id;
                        paRecord.PermissionSetId = permissionSetMap.get(strategicPlanLabel).Id;
                        psAssignmentInsert.add(paRecord);
                    } else {
                        strategicPlanUserIds.add(newUser.Id);
                    }
                }
            }
            if (superUserIds.size() + strategicPlanUserIds.size() > 0) {
                psAssignmentDelete = permissionSetAssignmentDAOInstance.getSUAndSPPermissionSetAssignmentList(
                                         permissionSetMap.get(superUserLabel).Id, permissionSetMap.get(strategicPlanLabel).Id,
                                         superUserIds, strategicPlanUserIds);
                if (psAssignmentDelete.size() > 0) {
                    permissionSetAssignmentDAOInstance.deletePermissionSetAssignmentList(psAssignmentDelete);
                }
            }
            if (psAssignmentInsert.size() > 0) {
                permissionSetAssignmentDAOInstance.insertPermissionSetAssignmentList(psAssignmentInsert);
            }

        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'User', 'UserTrigger', 'UserTriggerHandler.updateUserPermissionSets()', 'High');
        }
    }

    /***************************************************************************************************
        Method Name     : assignUserPermissionSets
        @usage          : This method is used for the after insert scenario
        @description    : This method adds the Super User/Strategic Plan management permission sets
                            if the respective checkboxes are checked
        @parameters     : List<User> newUsers
        @return type    : void
    ****************************************************************************************************/
    public void assignUserPermissionSets(List<User> newUsers) {
        List<PermissionSetAssignment> psAssignmentInsert    = new List<PermissionSetAssignment>();
        Map<String, PermissionSet> permissionSetMap         = new Map<String, PermissionSet>();
        String superUserLabel                               = System.Label.Super_User_Permissions;
        String strategicPlanLabel                           = System.Label.PermissionSetCanApproveStrategicPlans;
        try {
            List<PermissionSet> permissionSets = permissionSetDAOInstance.getSUAndSPPermissionSetList();
            for (PermissionSet ps : permissionSets) {
                permissionSetMap.put(ps.Name, ps);
            }
            for (User newUser : newUsers) {
                if (newUser.Is_Super_User__c) {
                    PermissionSetAssignment paRecord = new PermissionSetAssignment();
                    paRecord.AssigneeId = newUser.Id;
                    paRecord.PermissionSetId = permissionSetMap.get(superUserLabel).Id;
                    psAssignmentInsert.add(paRecord);
                }
                if (newUser.Can_Approve_Strategic_Plans__c) {
                    PermissionSetAssignment paRecord = new PermissionSetAssignment();
                    paRecord.AssigneeId = newUser.Id;
                    paRecord.PermissionSetId = permissionSetMap.get(strategicPlanLabel).Id;
                    psAssignmentInsert.add(paRecord);
                }
            }
            if (psAssignmentInsert.size() > 0) {
                permissionSetAssignmentDAOInstance.insertPermissionSetAssignmentList(psAssignmentInsert);
            }
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'User', 'UserTrigger', 'UserTriggerHandler.assignUserPermissionSets()', 'High');
        }
    }

    public void updateContactAssociatedFields(List<User> newUserList, Map<Id, User> oldUserMap) {
        try {
            Map<String, User> userEmploymentNumbers = new Map<String, User>();
            Set<String> userWithChangedEmploymentNumberIds = new Set<String>();
            Set<String> userIds = new Set<String>();
            List<Contact> updateContacts = new List<Contact>();
            String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(ConstantsController.contactRecordTypeInternalContact).getRecordTypeId();
            for (User u : newUserList) {
                if (oldUserMap != null && oldUserMap.containsKey(u.Id)) {
                    if (oldUserMap.get(u.Id).EmployeeNumber != u.EmployeeNumber || oldUserMap.get(u.Id).IsActive != u.IsActive) {
                        userWithChangedEmploymentNumberIds.add(u.Id);
                        if (u.EmployeeNumber != null) {
                            userIds.add(u.Id);
                        }
                    }
                } else if (u.EmployeeNumber != null) {
                    userIds.add(u.Id);
                }
            }
            if (ConstantsController.canMakeFutureCalls) {
                updateContactRecords(userWithChangedEmploymentNumberIds, userIds);
            }
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'User', 'UserTrigger', 'UserTriggerHandler.updateContactAssociatedFields()', 'High');
        }
    }

    @future
    public static void updateContactRecords(Set<String> userWithChangedEmploymentNumberIds, Set<String> userIds) {
        List<Contact> updateContacts = new List<Contact>();
        Map<String, User> userEmploymentNumbers = new Map<String, User>();
        for (User u : userDAOInstance.getUsersWithEmployeeNumber(userIds)) {
            userEmploymentNumbers.put(u.EmployeeNumber, u);
        }
        String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(ConstantsController.contactRecordTypeInternalContact).getRecordTypeId();
        for (Contact con : contactDAOInstance.getContactsWithAssociatedUsers(userWithChangedEmploymentNumberIds, userEmploymentNumbers, recordTypeId)) {
            if (userEmploymentNumbers.containsKey(con.External_ID__c)) {
                con.Associated_User__c = userEmploymentNumbers.get(con.External_ID__c).Id;
                updateContacts.add(con);
            } else {
                con.Associated_User__c = null;
                updateContacts.add(con);
            }
        }

        if (updateContacts.size() > 0)
            contactDAOInstance.updateContacts(updateContacts);
    }
}