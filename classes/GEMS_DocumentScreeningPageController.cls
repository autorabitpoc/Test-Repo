public class GEMS_DocumentScreeningPageController
{
    public Case cases{get;set;}
    public Case caseRecord{get;set;}
    String screeningStatus = null;
    public Integer totalCount {get;set;}
    public Boolean displayReturnReason {set;get;}
    public GEMS_Return_Reason__c returnreasonRec {set;get;}
    public List<GEMS_Return_Reason__c> delReasonList {get;set;}
    public Integer rowIndex {get;set;}
    public GEMS_Return_Reason__c del;
    
    public Boolean displayErrorForNoreturnReason{set;get;}
    public List<GEMS_Return_Reason__c> returnReasonList{get;set;}
    public Boolean canUpdateCaseRecord{set;get;}
    
    public GEMS_DocumentScreeningPageController(ApexPages.StandardController controller) 
    {
        try {
            cases = (case)controller.getRecord();
            caseRecord = [Select ID, GEMS_Return_Check__c, GEMS_ReviewDocuments__c, Sub_Category__c, GEMS_Approve__c,GEMS_Return__c,GEMS_Routed_In_Error__c, Status, GEMS_Account_Submission_Info__c,RecordType.name, GEMS_Returned_user_id__c, OwnerId from Case where ID =: cases.ID];
            
            returnreasonRec = new GEMS_Return_Reason__c(GEMS_case__c= cases.ID);
            
            returnReasonList = [SELECT ID, Name, GEMS_Case__c, Process_Name__c, GEMS_Type__c, GEMS_Sub_Type__c, Return_Reason__c, GEMS_Comments__c FROM GEMS_Return_Reason__c where GEMS_Case__c =: cases.ID];
            totalCount = returnReasonList.size();
            displayReturnReason = false;
            displayErrorForNoreturnReason=false;
            canUpdateCaseRecord=false;
            //delReasonList = new List<GEMS_Return_Reason__c>();
            
            if(caseRecord.GEMS_Approve__c)
            {
                screeningStatus='Approve';
                displayReturnReason=false;
            }
            else if(caseRecord.GEMS_Return__c || caseRecord.GEMS_Return_Check__c)
            {
                screeningStatus='Return';
                displayReturnReason=true;
            }
            else if(caseRecord.GEMS_Routed_In_Error__c)
            {
                screeningStatus='Routed In Error';
                displayReturnReason=false;
            }
        }
        
        catch(Exception ex)
        {
            System.debug('Exception occured===>'+ex.getMessage());
        }
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Approve','Approve')); 
        options.add(new SelectOption('Return','Return')); 
        if(caseRecord.Sub_Category__c != null && caseRecord.Sub_Category__c != 'Account Setup Screening' ) {
            options.add(new SelectOption('Routed In Error','Routed In Error')); 
        }
        return options; 
    }
    
    public String getScreeningStatus ()
    {
        return screeningStatus;
    }
    
    public void setScreeningStatus (String screeningStatus)
    {
        this.screeningStatus = screeningStatus;
    }
    
    public void displayReturnReasonCheck()
    {
        displayReturnReason=false;
        if(screeningStatus=='Return')
        {
            displayReturnReason=true;
        }
        if(screeningStatus=='Routed In Error')
        {
            displayReturnReason=false;
        }
        if(screeningStatus=='Approve')
        {
            displayReturnReason=false;
        }
        System.debug('-----called---');

    }
    
    public void addRow()
    {
        returnReasonList.add(returnreasonRec);
        system.debug('ret list : '+returnReasonList);
        returnreasonRec = new GEMS_Return_Reason__c(GEMS_case__c= cases.ID);
    }
    /*
    public void deleteRow()
    {
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        del = returnReasonList.remove(rowIndex);
        delReasonList.add(del);
    }
    */
    
    public pageReference saveScreeningDetailsAndReturnReason()
    {
        if(screeningStatus=='Approve')
        {
            caseRecord.GEMS_Approve__c=true;
            caseRecord.GEMS_Return__c=false;
            caseRecord.GEMS_Return_Check__c=false;
            caseRecord.GEMS_Routed_In_Error__c=false;
            caseRecord.Status='Approved';
            canUpdateCaseRecord=true;
        }
        if(screeningStatus=='Return' && returnReasonList.isEmpty())
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add Return Reasons when Return is selected for Disposition'));
        }
        if(!returnReasonList.isEmpty() && screeningStatus=='Return')
        {
            for(GEMS_Return_Reason__c retReasonRec: returnReasonList)
            {
                if(retReasonRec.GEMS_Type__c==null && retReasonRec.Return_Reason__c==null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Returned Document Type and Return Reason'));
                }
                if(retReasonRec.GEMS_Type__c!=null && retReasonRec.Return_Reason__c==null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Return Reason'));
                }
                if(retReasonRec.GEMS_Type__c==null && retReasonRec.Return_Reason__c!=null)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Returned Document Type'));
                }
                if(retReasonRec.GEMS_Type__c!=null){
                    if(retReasonRec.GEMS_Type__c.contains('ABS') && retReasonRec.GEMS_Sub_Type__c==null)
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select ABS/Matirx Sub Document Type'));
                    }
                    if(retReasonRec.Return_Reason__c==null)
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Return Reason'));
                    }
                }
            }
        }
        ApexPages.Message[] messages = ApexPages.getMessages();
        if(screeningStatus=='Return' && !returnReasonList.isEmpty() && messages.size()<1)
        {
            ID accountSubmissionCaseOwnerId = [SELECT ID, OwnerId from Case where ID =: caseRecord.GEMS_Account_Submission_Info__c].ownerId;
            caseRecord.GEMS_ReviewDocuments__c=false;
            caseRecord.GEMS_Approve__c=false;
            caseRecord.GEMS_Return__c=true;
            caseRecord.GEMS_Return_Check__c = true;
            caseRecord.GEMS_Routed_In_Error__c=false;
            caseRecord.Status='Return';
            caseRecord.GEMS_Returned_user_id__c = caseRecord.OwnerId;
            caseRecord.OwnerId=accountSubmissionCaseOwnerId;
            canUpdateCaseRecord=true;
            upsert returnReasonList;
        }
        if(screeningStatus=='Routed In Error')
        {
            caseRecord.GEMS_Approve__c=false;
            caseRecord.GEMS_Return__c=false;
            caseRecord.GEMS_Return_Check__c = false;
            caseRecord.GEMS_Routed_In_Error__c=true;
            caseRecord.Status='Routed In Error';
            canUpdateCaseRecord=true;
        }
        if(canUpdateCaseRecord)
        {
            update caseRecord;
        }
        else
        {
            return null;
        }
        return null;
    }
}