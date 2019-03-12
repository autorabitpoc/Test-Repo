//************************************************************************************
// Name             : GEMS_WhereIsMyCaseExt.cls
// Description      : Controller extension for GEMS_Where_Is_My_Case VF page. To build links to reports dynamically without the need to hardcode report IDs.                   
// Created By       : Gowrishankar Subramanian
// Created Date     : 8/29/2017
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 07/10/2017        Shankar             SFDC-4202. Initial version
// 10/21/2017        Phani K             SFDC-6897  Reset Release
// 01/31/2018        Gokul Bharati       SFDC-6946  Auto Close Account Submission Case
// 03/12/2018        Gokul Bharati       SFDC-8034  Complete Off-Cycle submission cases as "Completed" instead of "Completed - Without Signed BPA"
// ************************************************************************************

public class GEMS_WhereIsMyCaseExt {
    public String commentsReportUrl {get;set;}
    public String caseDetailReportUrl {get;set;}
    public Id subCaseId {get;set;}
    public Boolean typeCheck {get;set;}
    public Case c {get;set;}
    public String errorMsg {get;set;}
    
    //SFDC-6897 Reset Release. Refactored
    public GEMS_WhereIsMyCaseExt(ApexPages.StandardController controller) {
        errorMsg = '';  
        subCaseId=  ApexPages.currentPage().getParameters().get('id');
        set<string> docTypes = GEMS_Constants.docTypes; 
        set<string> recordTypeIdSet = new set<string>{'GEMS_Eligibility_Process','GEMS_GET','GEMS_Request_Resource'}; 
        c = [Select type,GEMS_Submission_Type__c,CaseNumber,MileStone__c,Status,(select id,Type__c from GEMS_Attachments__r where Type__c in:docTypes),(select id,recordType.DeveloperName,Status,isClosed from Cases1__r where recordType.DeveloperName in :recordTypeIdSet) from Case where Id=:subCaseId]; 
        if(c.type != null && c.type == 'Account Submission') 
            typeCheck = True;
        else
            typeCheck = False;
    }
    
    public void getReportDet() {
        commentsReportUrl = '/' + Label.CaseCommentsReportId + '?pv0=' + c.CaseNumber + '&pv2=' + c.CaseNumber;
        caseDetailReportUrl = '/' + Label.caseDetailReportId + '?pv0=' +c.CaseNumber;
    }
    
    public void autoUpdAccSubCaseBPA(){ 
    List<string> errormsgs = new List<string>();
    string milestoneTocheck= GEMS_Constants.ServiceReady;
    Boolean caseBPAFound;    
     try{  
           if(c.status == GEMS_Constants.StatusCompleted){
              errorMsg ='Case is already updated to Completed.';           
           }
           else if(c.MileStone__c == null || c.MileStone__c != milestoneTocheck){
              errormsgs.add('\\nCase is not Service Ready.');
           }
           else{
               if(!c.GEMS_Attachments__r.isEmpty()){      
                    caseBPAFound = true;
                }
                else{
                    caseBPAFound = false;
                } 
                if(!caseBPAFound && c.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeOffCycle){
                   errormsgs.add('\\nPlease add a BPA attachment.');   
                } 
                if(!c.Cases1__r.isEmpty()){
                    for(Case cse:c.Cases1__r){
                       if(cse.RecordType.DeveloperName == 'GEMS_Eligibility_Process' && (cse.Status != GEMS_Constants.StatusCancelled && cse.Status != GEMS_Constants.StatusCompleted)){
                            errormsgs.add('\\nEligibility Case is not Closed.'); 
                       }
                       if(cse.RecordType.DeveloperName == 'GEMS_GET' && (cse.Status != GEMS_Constants.StatusCancelled && cse.Status != GEMS_Constants.StatusCompleted)){
                            errormsgs.add('\\nGET Case is not Closed.');
                       }
                       if(cse.RecordType.DeveloperName == 'GEMS_Request_Resource' && (cse.Status != GEMS_Constants.StatusCancelled && cse.Status != GEMS_Constants.StatusCompleted)){
                            errormsgs.add('\\nRequest Resource Case is not Closed.');
                       }
                    } 
                }
                //SFDC-8034 
                Boolean NonOffCycle = (c.MileStone__c != null && c.MileStone__c == milestoneTocheck && caseBPAFound && errormsgs.isEmpty() && c.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeOffCycle);
                Boolean OffCycle = (c.MileStone__c != null && c.MileStone__c == milestoneTocheck && errormsgs.isEmpty() && c.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeOffCycle);
                if(NonOffCycle || OffCycle){
                    c.status = GEMS_Constants.StatusCompleted;
                    update c;  
                }
                //SFDC-8034
           } 
       }
       catch(Exception ex){
            errorMsg ='Update Failed.Please contact GEMS support for assistance'; 
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_WhereIsMyCaseExt.autoUpdAccSubCaseBPA()','High');              
           
       }
       if(!errormsgs.isEmpty()){
          errorMsg = 'Please review below items to Close Submission Case:'+ string.join(errormsgs,'');
       }              
    }
}