public class GEMS_FSUClaimsReturnStatusPageController
{
    public List<GEMS_Return_Reason__c> returnReasonList{get;set;}
    public List<SelectOption> statusPickList{get;set;}
    public GEMS_Return_Reason__c returnreasonRec {set;get;}
    public String caseId{get;set;}
    public Boolean displayReturnReason{get;set;}
    public String selectedCaseIds;
    public String selectedStatus{get;set;}
    
    public GEMS_FSUClaimsReturnStatusPageController(ApexPages.StandardController controller)
    {
        //displayReturnReason = true;
        returnreasonRec = new GEMS_Return_Reason__c();
        caseId = ApexPages.currentPage().getParameters().get('Id');
        statusPickList = getMyOptions();
        System.debug('statusPickList ===>'+statusPickList );
        returnReasonList = [SELECT ID, Name, GEMS_Case__c, Process_Name__c, GEMS_Type__c, GEMS_Sub_Type__c, Return_Reason__c, GEMS_Comments__c FROM GEMS_Return_Reason__c where GEMS_Case__c =: caseID];
    }
    
    public List<SelectOption> getMyOptions()
    {    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        options.add(new SelectOption('Return', 'Return'));      
        return options;
    }
    
    public void addRow()
    {
        //reasonList.add(new GEMS_Return_Reason__c(GEMS_case__c= cases.ID));
        returnReasonList.add(returnreasonRec);
        system.debug('ret list : '+returnReasonList);
        returnreasonRec = new GEMS_Return_Reason__c(GEMS_case__c= caseID);
    }
    
    public void showReturnReasonBlock()
    {
        if(selectedStatus == 'Return')
        {
            displayReturnReason = true;        
        }
        else if(selectedStatus == 'Routed In Error') 
        {
            displayReturnReason = false;
        }
        else
        {
            displayReturnReason = false;
        }
        
        System.debug('-----called---');
        //return null;
    }
    
    public pagereference saveStatus() 
    {
        List<GEMS_Return_Reason__c> returnReajonsToBeInserted = new List<GEMS_Return_Reason__c>();
        try 
        {
            if(caseId != null )
            {
                for(GEMS_Return_Reason__c rejectReason : returnReasonList)
                {
                    if(rejectReason.id == null) 
                    {
                        GEMS_Return_Reason__c rrr = new GEMS_Return_Reason__c(GEMS_Sub_Type__c = rejectReason.GEMS_Sub_Type__c,Process_Name__c = rejectReason.Process_Name__c,GEMS_Type__c = rejectReason.GEMS_Type__c,Return_Reason__c = rejectReason.Return_Reason__c, GEMS_Case__c=caseId);    
                        returnReajonsToBeInserted.add(rrr);
                    }
                }
                
                if(returnReajonsToBeInserted.isEmpty())
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add Return Reasons when Return is selected'));
                }
                
                else if(!returnReajonsToBeInserted.isEmpty()) 
                {
                    insert returnReajonsToBeInserted;
                    
                    Case caseRec = [select id,parentid,status,GEMS_Account_Submission_Info__r.ownerId,GEMS_Account_Submission_Info__r.Id, GEMS_Returned_user_id__c,OwnerId from Case where id =:caseId];
                    if(selectedStatus =='Return') 
                    {
                        ID accountSubmissionCaseOwnerId = caseRec.GEMS_Account_Submission_Info__r.ownerId;
                        
                        caseRec.Status='Return';
                        caseRec.GEMS_Returned_user_id__c = caseRec.OwnerId;
                        caseRec.OwnerId=accountSubmissionCaseOwnerId;
                        update caseRec;
                    }
                }           
            }
        }
        
        Catch(Exception ex) 
        {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_FSUClaimsReturnStatusPageController.saveStatus()','High');  
        }
        System.debug('----End saveStatusMethod-----');
        if(returnReajonsToBeInserted.isEmpty())
        {
            return null;
        }
        else if(!returnReajonsToBeInserted.isEmpty())
        {
            return new Pagereference('/'+caseId);
        }
        return null;
    }
    
    public void setSelectedStatus() 
    {
        
    }
    
    public pagereference cancel()
    {
        return new Pagereference('/'+caseId);
    }
}