/**************************************************************************************
  Apex Class Name     : ContactDAO
  Version             : 1.0
  Function            : This is a Contact DAO class for accessing the Contact object.
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------
* Alec Klein                6/8/2016
*************************************************************************************/
public with sharing class ContactDAO implements IContactDAO {

    public interface IContactDAO {
        List<Contact> updateContacts(List<Contact> contacts);
        List<Contact> getContactsWithAssociatedUsers(Set<String> associatedUserIds, Map<String, User> userEmploymentNumbers, String recordTypeId);
        List<Contact> getContactsById(List<Id> ids);
        List<Contact> getContactsByAccountAddressSeqNumAndAccountId(String accountAddressSeqNum, String accountId);
        List<Contact> getPrimaryGroupContacts(Map<Id, Account> groupAccounts, Id groupContactRecordType);
        Map<String, List<Contact>> getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(List<Contact> contacts, List<String> types);
    }

    public List<Contact> updateContacts(List<Contact> contacts) {
        update contacts;
        return contacts;
    }

    public List<Contact> getContactsWithAssociatedUsers(Set<String> associatedUserIds,
            Map<String, User> userEmploymentNumbers,
            String recordTypeId) {
        return [SELECT Associated_User__c, Active_user__c, External_ID__c FROM Contact
                WHERE (Associated_User__c = : associatedUserIds
                                            OR External_ID__c = : userEmploymentNumbers.keySet())
                AND RecordTypeId = : recordTypeId];
    }

    public List<Contact> getContactsById(List<Id> ids) {

        String soql = 'SELECT ';

        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }

        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Id IN :ids';
        return Database.query(soql);
    }

    public List<Contact> getContactsByAccountAddressSeqNumAndAccountId(String accountAddressSeqNum, String accountId) {
        return [SELECT Id FROM Contact WHERE AccountId =: accountId AND Account_Address_Sequence_Number__c =: accountAddressSeqNum];
    }

    public List<Contact> getPrimaryGroupContacts(Map<Id, Account> groupAccounts, Id groupContactRecordType) {
        return [SELECT Type__c, AccountId, RecordTypeId FROM Contact WHERE AccountId IN :groupAccounts.keySet() 
                            AND Type__c = :Label.Contact_Type_Primary AND RecordTypeId = :groupContactRecordType];
    }

    public Map<String, List<Contact>> getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(List<Contact> contacts, List<String> types){ 
        return GroupBy.strings( 'Account_Address_Sequence_Number__c', 
                                    [SELECT Id, Account_Address_Sequence_Number__c, Type__c FROM Contact 
                                        WHERE AccountId IN :Pluck.ids('AccountId' , contacts) AND
                                             Account_Address_Sequence_Number__c IN : 
                                                    Pluck.strings('Account_Address_Sequence_Number__c' , contacts)
                                                        AND Type__c IN :types] );
    }
}