/**************************************************************************************
  Apex Class Name     : GEMS_CaseTriggerHandler 
  Version             : 1.0
  Function            : This is a handler class for GEMS_CaseFieldvalidationHandler (For GEMS Project).
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            06/25/2016             Original Version
*************************************************************************************/
public class GEMS_CaseFieldvalidationHandler {
    /******************************************************************** 
    *    Method Name : beforeCaseUpdate
        Action
    *   @description :   This method to check get Case field validation before changing the case status to Complete
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/  
    public static void beforeGetCaseUpdate(List<Case> caseList,Map<Id,Case> newMap) {
                List<String> csList = new List<String>();
                Id caseGETCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();   
                Id requestResourceCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Request Resource').getRecordTypeId();                           
                for(case cs:caseList) {
                    if(cs.recordTypeID == caseGETCaseRecordTypeId && cs.status == 'Completed')
                    csList.add(cs.id);
                }
                if(!csList.isEmpty()) {
                List<case> getwithResourceCaseList = [select id,(select id,status from Cases where recordTypeId =:requestResourceCaseRecordTypeId) from case where recordTypeID =:caseGETCaseRecordTypeId and id=:csList];
                 for(case parentCase:getwithResourceCaseList){
                     Case getCase = newMap.get(parentCase.id);
                    for(case childCase:parentCase.Cases){
                        if(childCase.status!= 'Completed')
                        getCase.addError('Please complete all the Request resource case before making the get case to Complete');
                    }
                 }
    }
}
        /******************************************************************** 
    *    Method Name : beforeGetCaseUpdate
        Action
    *   @description :   This method to check  atleast one Group section record exist before changing the case status to 'Client Approval Received'
    *   @parameters  :   List<Case> caseList,Map<Id,Case> newMap,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/  
    public static void beforeStructureCaseUpdate(List<Case> caseList,Map<Id,Case> newMap,Map<Id,Case> oldCaseMap) {
        List<String> csList = new List<String>();
        Map<Id,case> idcasemap = oldCaseMap;
        Id caseCaseStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        for(case cs:caseList) {
            if(cs.recordTypeID == caseCaseStructureRecordTypeId && cs.status == 'Client Approval Received' && oldCaseMap.get(cs.id).status != cs.status)
                csList.add(cs.id);
        }
        if(!csList.isEmpty()) {
            List<case> caseStructwithGSList = [select id,(select id  from Group_Sections__r) from case where recordTypeID =:caseCaseStructureRecordTypeId and id=:csList];
            for(case parentCase:caseStructwithGSList){
                Case structCase = newMap.get(parentCase.id);
                List<GEMS_Group_Section__c> gsList = parentCase.Group_Sections__r;
                    if(gsList.isEmpty())
                    structCase.addError('Please create atleast one Group Section record');
                }
            }
    }
}