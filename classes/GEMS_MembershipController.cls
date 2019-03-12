public class GEMS_MembershipController{
    public Case membershipCase{set;get;}
    public Case membershipCaseRec{set;get;}
    public List<Task> membershipTaskList{set;get;}
    public Boolean disableCompleteButton{get;set;}
    public Integer selectedVal{get;set;}
    public Integer currentTask{get;set;}
    
    public GEMS_MembershipController(ApexPages.standardController con){
    try {
        currentTask = 0;
        Integer completedTasks=0;
        membershipCase = (case)con.getRecord();
        membershipCaseRec = [Select ID, GEMS_Return_Check__c,GEMS_Submission_Type__c, GEMS_ReviewDocuments__c,HCSC_Division__c,GEMS_Products__c,Funding_Type__c, GEMS_Approve__c,GEMS_Return__c,GEMS_Routed_In_Error__c, Status, GEMS_Account_Submission_Info__c,RecordType.name,GEMS_Test_File_Receipt_Date__c,
                          GEMS_Test_Files_Sent_to_Client_Vendor__c, GEMS_Request_for_Reports_Sent_to_ITG__c, GEMS_AEP_Reports_Received_from_ITG__c,GEMS_Release_to_Compare_date__c,
                          GEMS_Authorization_to_valid_date__c,GEMS_Actual_Date_for_Production_File_1__c,GEMS_Actual_Date_for_Production_File_2__c, GEMS_Target_Date_for_Production_File_1__c,
                          GEMS_Target_Date_for_Production_File_2__c,GEMS_Quality_Reviewer__c,GEMS_Is_BlueSTAR_Walkthrough_Needed__c,GEMS_Date_BlueSTAR_Walkthrough_Held__c,GEMS_Account_Submission_Info__r.ownerId  from Case where ID =: membershipCase.ID];
        membershipTaskList = [SELECT id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId FROM Task WHERE whatid =: membershipCase.Id ORDER BY ID ASC];
        Integer noOfTasks= membershipTaskList.Size();
        if(membershipCaseRec.status == 'Completed' || membershipCaseRec.status == 'Cancelled') {
            currentTask = noOfTasks;
            disableCompleteButton=true;
        }
        for(Task taskk : membershipTaskList) {
            if(taskk.status == 'Completed') {
                currentTask++;
                completedTasks=completedTasks+1;
            }
            if(noOfTasks == completedTasks){
                disableCompleteButton=true;
            }
        }
    }
    
    catch(Exception ex) {
        System.debug('=exception=='+ex.getMessage());
    }
    }
    public PageReference changeTaskStatus(){
        if(!membershipTaskList.isEmpty() && currentTask <= membershipTaskList.size() ) {
            if(selectedVal == -1) {
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select below task');
                ApexPages.addMessage(myMsg);                    
                return null;
            }
            Task taskkk = membershipTaskList.get(currentTask);
            taskkk.status = 'Completed';
            taskkk.GEMS_End_Date__c = System.now();
            update taskkk;
            membershipCaseRec.Status='Completed';
            update membershipCaseRec;
        }
        return null;
    }
}