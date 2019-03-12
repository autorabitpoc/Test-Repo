/*
* This trigger will populate the Milestone and Milestone Date fields from GEMS_ReportingMilestone_Tracking__c to Case object
*
* 10/11/2017   Luke Chen       SFDC-6129,6871,6872 GEMS Reporting Milestone
* 01/31/2018   Gokul Bharati   SFDC-6946 Auto Close Account Submission Case
* 03/13/2018   Gokul Bharati   SFDC-8034 GEMS: Complete Off-Cycle submission cases as "Completed" instead of "Completed - Without Signed BPA"
*/
trigger GEMSReportingMilestoneTrackingTrigger on GEMS_ReportingMilestone_Tracking__c (after update) {
    
    Map<Id,GEMS_ReportingMilestone_Tracking__c> recToUpdate = new Map<Id,GEMS_ReportingMilestone_Tracking__c>(); // Map<submission case ID, tracking record>
    // this if block is to pick up the tracking records that have milestone field updated
    if(trigger.isAfter && Trigger.isUpdate){
        for(GEMS_ReportingMilestone_Tracking__c t : Trigger.New){
            GEMS_ReportingMilestone_Tracking__c oldTracking = (trigger.oldMap != null ? (GEMS_ReportingMilestone_Tracking__c) trigger.oldMap.get(t.id) : null);
            // pick up the record to populate the milestone field if this field is updated
            if(oldTracking == null || t.Milestone__c != oldTracking.Milestone__c)  recToUpdate.put(t.Submission_Case__c, t);
        }
    }
    
    // retrieve the corresponding submission cases and populate the 2 milestone fields
    if(!recToUpdate.isEmpty()){
        try{
            set<string> docTypes = GEMS_Constants.docTypes;
            string milestoneTocheck = GEMS_Constants.ServiceReady;        
            Map<Id,Boolean> caseBPAFound = new Map<Id,Boolean>();
            Map<Id,Boolean> dwnCaseFound = new Map<Id,Boolean>();
            set<string> recordTypeIdSet = new set<string>{'GEMS_Eligibility_Process','GEMS_GET','GEMS_Request_Resource'};
            List<Case> caseList = [select id,GEMS_Submission_Type__c,Milestone__c, Milestone_Date__c,(select id,Type__c,Case__c from GEMS_Attachments__r where Type__c in:docTypes) from Case where id in :recToUpdate.keySet()];                    
            
            for(Case c : caseList){
            if(recToUpdate.get(c.id).Milestone__c != null && recToUpdate.get(c.id).Milestone__c == milestoneTocheck){
                if(!c.GEMS_Attachments__r.isEmpty()){   
                    caseBPAFound.put(c.Id,true);  
                }
                else{
                    caseBPAFound.put(c.Id,false);
                }
              }  
            }
            if(!caseBPAFound.isEmpty()){
                for(Case cse:[select Id,recordType.DeveloperName,Status,isClosed,GEMS_Account_Submission_Info__c  from Case where recordType.DeveloperName in :recordTypeIdSet and GEMS_Account_Submission_Info__c in:caseBPAFound.keySet()]){              
                          if(!dwnCaseFound.containsKey(cse.GEMS_Account_Submission_Info__c)){
                             if(cse.status == GEMS_Constants.StatusCompleted || cse.status == GEMS_Constants.StatusCancelled)  
                             dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,true); 
                             else
                             dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,false);
                          }
                          else{
                             Boolean bool = dwnCaseFound.get(cse.GEMS_Account_Submission_Info__c);
                             if(cse.status == GEMS_Constants.StatusCompleted || cse.status == GEMS_Constants.StatusCancelled)  
                             dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,(bool && true)); 
                             else
                             dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,(bool && false));                       
                          }       
                 }
            } 
            for(Case c : caseList){ 
                c.Milestone__c = recToUpdate.get(c.id).Milestone__c;
                c.Milestone_Date__c = recToUpdate.get(c.id).Milestone_Date__c;
                //SFDC-8034  
                Boolean NonOffCycle = (recToUpdate.get(c.id).Milestone__c != null && recToUpdate.get(c.id).Milestone__c == milestoneTocheck && !caseBPAFound.isEmpty() && caseBPAFound.get(c.id) != null && caseBPAFound.get(c.id) == true && (dwnCaseFound.get(c.Id) == null || dwnCaseFound.isEmpty() || dwnCaseFound.get(c.Id) == true) && c.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeOffCycle);  
                Boolean OffCycle = (recToUpdate.get(c.id).Milestone__c != null && recToUpdate.get(c.id).Milestone__c == milestoneTocheck && (dwnCaseFound.get(c.Id) == null || dwnCaseFound.isEmpty() || dwnCaseFound.get(c.Id) == true) && c.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeOffCycle);
                if(NonOffCycle || OffCycle){
                    c.Status = GEMS_Constants.StatusCompleted;
                }
                else{
                    c.Status = GEMS_Constants.StatusInProgress;
                }
                //SFDC-8034
            }
            
            if(!caseList.isEmpty()){
                update caseList;
            }
        }
        catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Trigger', 'GEMS_ReportingMilestone_Tracking__c', null, 'GEMSReportingMilestoneTrackingTrigger','High');                
            System.debug('%%%Exception Message%%%'+ex.getMessage()+'%%%Line Number%%%'+ex.getLineNumber());
        } 
    }
    
}