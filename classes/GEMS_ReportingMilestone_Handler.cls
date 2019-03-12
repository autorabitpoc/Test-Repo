/* This class processes the reporting milestone.
 * It's driven by the Case status change in the Case trigger
 * To avoid the performance impact to the Case trigger, it only checks if the case's status is changed and
 * then sends everything to a future method to contiue processing.
 * 
 * Update History:
 * 09-28-2017   Luke Chen   SFDC-6129,6871,6872 GEMS Reporting Milestone
 * 
*/
public class GEMS_ReportingMilestone_Handler{
    // This is the entry method to start the Reporting Milestone process
    public static void processReportingMilestone(Map<Id,Case> newMap, Map<Id,Case> oldCaseMap){
        
        Disable_Function__c milestoneFun = Disable_Function__c.getValues('Reporting_Milestone');
        if(milestoneFun != null && milestoneFun.Disable__c) return; // disable reporting milestone funtion
        // quickly exit without going into future if they are not cases to be recorded in tracking record
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case oneCase : newMap.values())
            if(GEMS_ReportingMilestoneUtil.getCaseRecTypeName(oneCase.recordTypeId) != null) // provisioned to update in tracking object
                newCaseMap.put(oneCase.id, oneCase);
        if(newCaseMap.isEmpty()) return; // nothing to process
        
        // pick up status changed only
        Set<Id> statusChgCases = new Set<Id>();
        for(Id caseId : newCaseMap.keySet())
            if(oldCaseMap == null || oldCaseMap.get(caseId) == null || newCaseMap.get(caseId).status != oldCaseMap.get(caseId).status || newCaseMap.get(caseId).GEMS_ID_card_mailed_date__c != oldCaseMap.get(caseId).GEMS_ID_card_mailed_date__c)
                statusChgCases.add(caseId);
        if(statusChgCases.isEmpty()) return;  // nothing to process, return
        
        if(System.isBatch() || System.isFuture() ){
            try{
            // already in batch or future
               processReportingMilestoneWork(statusChgCases);  
            }
            catch(Exception e){
              CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'called after case creation batch method GEMS_ReportingMilestone_Handler.processReportingMilestoneWork(Set<Id>)','High');              
            }
        }   
        else{
            // throw into future method to avoid long process inside case trigger
              processReportingMilestoneFuture(statusChgCases);
        }   

    }
    
    // synchronous call method to use in batch or future context
    private static void processReportingMilestoneWork(Set<Id> casesStatusChanged){
        Id subRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<Case> casesChgd = GEMS_ReportingMilestoneUtil.getCases(casesStatusChanged);
        List<Case> cases2Process = new List<Case>();
        for(Case oneCase : casesChgd){
            // if not submission case or its submission info field is not a submission case, skip the case
            if( oneCase.GEMS_Account_Submission_Info__c == null && oneCase.recordtypeid != subRecTypeId) continue;
            if( oneCase.GEMS_Account_Submission_Info__c != null && oneCase.GEMS_Account_Submission_Info__r.recordtypeid != subRecTypeId) continue;
            cases2Process.add(oneCase);
        }
        if(cases2Process.isEmpty()) return; // nothing to process, return

        // get all their Submission case IDs
        Set<Id> subCaseIds = new Set<Id>();
        for(Case aCase : cases2Process){
            if(aCase.GEMS_Account_Submission_Info__c != null)
                subCaseIds.add(aCase.GEMS_Account_Submission_Info__c);
            else
                subCaseIds.add(aCase.id);   
        }
        Map<Id, GEMS_ReportingMilestone_Tracking__c> trackingObjMap = GEMS_ReportingMilestoneUtil.getTrackingRecords(subCaseIds);
        // populate case status to tracking subject
        for(Case aCase : cases2Process){
            if(aCase.GEMS_Account_Submission_Info__c != null)
                GEMS_ReportingMilestoneUtil.populateStatus(GEMS_ReportingMilestoneUtil.getCaseRecTypeName(aCase.recordTypeId), 
                    aCase, trackingObjMap.get(aCase.GEMS_Account_Submission_Info__c), null);
            else
                GEMS_ReportingMilestoneUtil.populateStatus(GEMS_ReportingMilestoneUtil.getCaseRecTypeName(aCase.recordTypeId), 
                    aCase, trackingObjMap.get(aCase.id), null);
        }
    
        // run the matrix logic to update the milestone field
        List<GEMS_ReportingMilestone_Tracking__c> trackingObjs = trackingObjMap.values();
        GEMS_ReportingMilestoneUtil.updateReportingMilestoneMatrixLogic(trackingObjs);
    }    
    
    // future method to use in the context of synchronous call   
    @future(callout=false)
    private static void processReportingMilestoneFuture(Set<Id> casesStatusChanged){
       try{
        processReportingMilestoneWork(casesStatusChanged);
       }
       catch(Exception e){
        CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'called from future method GEMS_ReportingMilestone_Handler.processReportingMilestoneWork(Set<Id>)','High');              
       }    
    }
}