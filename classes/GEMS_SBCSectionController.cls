/**************************************************************************************
Apex Class Name       : GEMS_SBCSectionController
Version               : 1.0
Function              : For fetching Account details and updating the SBC Case record.
Modification Log      : Modified to add SBC Header details to populate in SBC Case for Sept 2016 release
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            05/30/2016             Original Version
*************************************************************************************/
public with sharing class GEMS_SBCSectionController
{
    public ID caserecId {set;get;}
    public String ssspage {get;set;}
    public Case caserec{set;get;}
    public GEMS_SBC_Request_Form__c sbcRequestForm{get;set;}
    public Boolean sbcCase{get;set;}
    
    public GEMS_SBCSectionController(ApexPages.StandardController controller) 
    {
        try 
        {
            String caseRecordInput = null;
            ssspage = null;
            Case caserecInline = (Case)controller.getRecord();
            System.debug('caserecInline====>' +caserecInline);
            //Id SBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
            caserecId = apexpages.currentpage().getparameters().get('id');
            ssspage = apexpages.currentpage().getparameters().get('ssspage');
            System.debug('caserecId===>'+caserecId);
            System.debug('caserecId===>'+caserecInline);
            sbcCase = false;
            caseRecordInput = caserecId;
            System.debug('=====>caseRecordInput'+caseRecordInput);
            sbcRequestForm = new GEMS_SBC_Request_Form__c();
            
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            Id sbcId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
            System.debug('=====>caserecInline.Id' +caserecInline.Id);
            if(caserecInline.RecordTypeId == caseAccountSubmissionId && caserecInline.Id!=null && ssspage=='AccSub') 
            {
                System.debug('=====Enter 1===>');
                caserec =[select id, HCSC_Division__c,createdby.name,createdDate,GEMS_Open_Enrollment_Start__c,
                          GEMS_Grandfathered_benefits__c,Account.District__c,                                                                
                          Account.name,Account.External_ID__c,GEMS_Case_Effective_Date__c,District__c,GEMS_Cluster__c ,Account.Region__c,Account.HCSC_Division__c,
                          GEMS_Submission_Type__c,GEMS_Submission_Sub_Type__c,FSU_Location__c,Market_Segment__c,Funding_Type_Multiselect__c,
                          GEMS_Medical_Underwriter__c,Account_Executive__c,Sales_Executive__c,CaseNumber,GEMS_View_Product__c,owner.name,Subject,Account.Cluster__c,
                          RecordType.Name,
                          (SELECT Id, Name FROM GEMS_SBC_Request_Forms__r),
                          GEMS_Account_Submission_Info__c,GEMS_Type__c,Status From case where Id=:caserecInline.Id];
                        System.debug('=====caserec ===>'+caserec );
                
            }
            else if(ssspage=='AccSub')
            {
                System.debug('=====Enter 2===>');
                sbcCase = true;
                Case record_db = [select id, GEMS_Account_Submission_Info__c from case where id =: caserecInline.Id limit 1 ];
                caseRecordInput = record_db.GEMS_Account_Submission_Info__c;
                caserec =[select id,HCSC_Division__c,createdby.name,createdDate,GEMS_Open_Enrollment_Start__c,District__c,
                          GEMS_Grandfathered_benefits__c,
                          Account.District__c,GEMS_Cluster__c,Account.Region__c,                
                          Account.name,Account.External_ID__c,GEMS_Case_Effective_Date__c,
                          GEMS_Submission_Type__c,GEMS_Submission_Sub_Type__c,FSU_Location__c,Market_Segment__c,Funding_Type_Multiselect__c,
                          GEMS_Medical_Underwriter__c,Account_Executive__c,Sales_Executive__c,CaseNumber,GEMS_View_Product__c,owner.name,Subject,Account.Cluster__c,RecordType.Name,
                          GEMS_Account_Submission_Info__c,GEMS_Type__c,Status From case where Id=:caseRecordInput];
            }
            else if(ssspage=='' || ssspage==null)
            {
                Case CurrentCase = [SELECT Id, GEMS_Account_Submission_Info__c FROM Case WHERE Id=:caserecInline.Id];
                
                caserec =[select id, HCSC_Division__c,createdby.name,createdDate,GEMS_Open_Enrollment_Start__c,
                          GEMS_Grandfathered_benefits__c,Account.District__c,                                                                
                          Account.name,Account.External_ID__c,GEMS_Case_Effective_Date__c,District__c,GEMS_Cluster__c ,Account.Region__c,Account.HCSC_Division__c,
                          GEMS_Submission_Type__c,GEMS_Submission_Sub_Type__c,FSU_Location__c,Market_Segment__c,Funding_Type_Multiselect__c,
                          GEMS_Medical_Underwriter__c,Account_Executive__c,Sales_Executive__c,CaseNumber,GEMS_View_Product__c,owner.name,Subject,Account.Cluster__c,
                          RecordType.Name,
                          (SELECT Id, Name FROM GEMS_SBC_Request_Forms__r),
                          GEMS_Account_Submission_Info__c,GEMS_Type__c,Status From case where Id=:CurrentCase.GEMS_Account_Submission_Info__c];
                
                sbcRequestForm = [select id,GEMS_Request_ID__c,GEMS_Translations__c,GEMS_Tagalog_specify_BAs__c,GEMS_Other_Checkbox__c,Other_Reason__c,GEMS_Chinese_specify_BAs__c,Rx__c,GEMS_Revision_Request__c,GEMS_Print_Mail__c,
                              GEMS_Spanish_specify_BAs__c,GEMS_Rush__c,GEMS_Navajo_specify_BAs__c,GEMS_Reason_for_Rush__c,GEMS_Carved_Out_Benefits_From_Vendors__c,GEMS_Number_of_SBCs_Being_Requested__c,
                              GEMS_Number_of_BAs__c,GEMS_Other__c,GEMS_Additional_Notifications__c,GEMS_Mental_Health__c,GEMS_Minimum_Essential_Coverage_MEC__c,GEMS_Current_No_of_Subscribers__c,
                              GEMS_Minimum_Value_Standard_MV__c,GEMS_Current_No_of_Members__c,GEMS_Cluster__c,GEMS_Affected_Funding_Types__c,GEMS_Affected_Benefit_Agreements__c,GEMS_SBC_Request_Type__c,
                              GEMS_Additional_Comments__c,GEMS_Did_HCSC_Create_the_SBC_Last_Year__c,GEMS_Reason__c,GEMS_Sbc_District__c,GEMS_Grandfathered_benefit_s__c 
                              from GEMS_SBC_Request_Form__c where case__c =: CurrentCase.GEMS_Account_Submission_Info__c]; 
            }
            
            if(caserec.GEMS_SBC_Request_Forms__r.Size()>0)
            {
                sbcRequestForm = [select id,GEMS_Request_ID__c,GEMS_Translations__c,GEMS_Tagalog_specify_BAs__c,GEMS_Other_Checkbox__c,Other_Reason__c,GEMS_Chinese_specify_BAs__c,Rx__c,GEMS_Revision_Request__c,GEMS_Print_Mail__c,
                              GEMS_Spanish_specify_BAs__c,GEMS_Rush__c,GEMS_Navajo_specify_BAs__c,GEMS_Reason_for_Rush__c,GEMS_Carved_Out_Benefits_From_Vendors__c,GEMS_Number_of_SBCs_Being_Requested__c,
                              GEMS_Number_of_BAs__c,GEMS_Other__c,GEMS_Additional_Notifications__c,GEMS_Mental_Health__c,GEMS_Minimum_Essential_Coverage_MEC__c,GEMS_Current_No_of_Subscribers__c,
                              GEMS_Minimum_Value_Standard_MV__c,GEMS_Current_No_of_Members__c,GEMS_Cluster__c,GEMS_Affected_Funding_Types__c,GEMS_Affected_Benefit_Agreements__c,GEMS_SBC_Request_Type__c,
                              GEMS_Additional_Comments__c,GEMS_Did_HCSC_Create_the_SBC_Last_Year__c,GEMS_Reason__c,GEMS_Sbc_District__c,GEMS_Grandfathered_benefit_s__c 
                              from GEMS_SBC_Request_Form__c where case__c =: caseRecordInput ];                       
            }
            
            if(sbcRequestForm.GEMS_Sbc_District__c== null || sbcRequestForm.GEMS_Sbc_District__c== '')
            {
                sbcRequestForm.GEMS_Sbc_District__c =caserec.Account.District__c;
                System.debug('=========>sbcRequestForm.GEMS_Sbc_District__c'+sbcRequestForm.GEMS_Sbc_District__c);
            }
            if(sbcRequestForm.GEMS_Cluster__c== null || sbcRequestForm.GEMS_Cluster__c == '')
            {
                sbcRequestForm.GEMS_Cluster__c= caserec.Account.Cluster__c;
                System.debug('=========>sbcRequestForm.GEMS_Sbc_District__c'+sbcRequestForm.GEMS_Sbc_District__c);
            }
            if(caserec.GEMS_Grandfathered_benefits__c == True)
            {
                sbcRequestForm.GEMS_Grandfathered_benefit_s__c = 'Yes';
            }
            if(caserec.GEMS_Grandfathered_benefits__c == false)
            {
                sbcRequestForm.GEMS_Grandfathered_benefit_s__c = 'No';
            }
        }
        catch(Exception ex) 
        {
            System.debug('===Exception==='+ex.getMessage());
        }        
    }
    
    Public PageReference back()
    {
        return new PageReference ('/'+caserec.Id);  
        
    }
    
    public PageReference saveSBCCaseDetails()
    {
        
        boolean isError = false;
        integer count =0;
        
        
        if (sbcRequestForm.GEMS_Rush__c == 'Yes')
        {
            if (sbcRequestForm.GEMS_Reason_for_Rush__c != null)
            {
                count++;
            }
            else
            {   
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Rush is selected as Yes, please add Reason for Rush.');
                ApexPages.addMessage(myMsg);
                isError = true;               
            }
        } 
        
        if (sbcRequestForm.GEMS_Number_of_SBCs_Being_Requested__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Number of SBCs Being Requested.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Minimum_Essential_Coverage_MEC__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Minimum Essential Coverage/MEC.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Current_No_of_Subscribers__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Current # of Subscribers.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Minimum_Value_Standard_MV__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Minimum Value Standard/MV.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Current_No_of_Members__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Current # of Members.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Affected_Benefit_Agreements__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Affected Benefit Agreements.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Number_of_BAs__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Number of BAs.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        if (sbcRequestForm.GEMS_Carved_Out_Benefits_From_Vendors__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Carved Out Benefits From Other Vendors.');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (sbcRequestForm.GEMS_Did_HCSC_Create_the_SBC_Last_Year__c != null)
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Did HCSC Create the SBC Last Year?');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (caserec.GEMS_Grandfathered_benefits__c || sbcRequestForm.GEMS_Grandfathered_benefit_s__c!= null )
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Grandfathered benefit(s)?');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (caserec.Account.District__c != null || sbcRequestForm.GEMS_Sbc_District__c != null )
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Grandfathered benefit(s)?');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        if (caserec.Account.Cluster__c != null || sbcRequestForm.GEMS_Cluster__c != null )
        {
            count++;
        }
        else
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Cluster(s)?');
            ApexPages.addMessage(myMsg);
            isError = true;               
        }
        
        
        if(!isError ) 
        {       
            sbcRequestForm.Case__c = caserec.Id;
            
            upsert sbcRequestForm;
            
            if(sbcRequestForm.GEMS_Print_Mail__c == 'Yes') 
            {
                caserec.GEMS_Print_Mail__c = true;
            }
            else 
            {
                caserec.GEMS_Print_Mail__c = false;
            }
            update caserec;
            PageReference pr = new PageReference('/'+caserec.Id);
            pr.setRedirect(true);
            return pr;
        }
        else
        {
            return null;
        }
    }
}