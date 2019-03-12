/**************************************************************************************
Apex Class Name     : RequestTypeDAO
Version             : 1.0
Function            : This class is used to run dml statements for object Request Type.newInstance()
Created By          : Al-Que Quiachon 6/8/2016
*************************************************************************************/


public with sharing class RequestTypeDAO implements IRequestTypeDAO {
    
    public interface IRequestTypeDAO {
        void upsertRequestType(List<Request_Type__c> reqType);
        List<PROPOSAL_NI_TYPE__mdt> getRequestType(ID accountID);
        List<Request_Type__c> getRequestTypes(ID accountID);
        void deleteRequestType(List<Request_Type__c> reqType);
    }
    public void upsertRequestType(List<Request_Type__c> reqType) {
        upsert reqType;        
    }
    public void deleteRequestType(List<Request_Type__c> reqType) {
        delete reqType;
    }
    public List<Request_Type__c> getRequestTypes(ID caseId) {
        
        List<Request_Type__c> requestTypes = [SELECT number_of_requests__c, Proposal_NI_Type__c FROM Request_Type__c WHERE Case__c = : caseId];        
        return requestTypes;
    }
    public List<PROPOSAL_NI_TYPE__mdt> getRequestType(ID caseId) {
        
        List<PROPOSAL_NI_TYPE__mdt> requestTypes = [SELECT Proposal_NI_Type__c,Description__c FROM PROPOSAL_NI_TYPE__mdt];
        return requestTypes;
    }
}