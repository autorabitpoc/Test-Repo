public class GEMS_RequestImplementerController
{
    public case caserec {set;get;}
    public Id caseID;
    public String caseStatus {set;get;}
    //String approveOrRejectStatus = null;
    String approveOrRejectStatus = 'Approve';
    public Boolean displayImplementer{set;get;}
    public Boolean resourceCheck {get;set;}
    
    public GEMS_RequestImplementerController(ApexPages.StandardController controller) 
    {
        try
        {
            caseID = apexpages.currentpage().getparameters().get('id');
            caserec = [select id,GEMS_Additional_Comments__c,GEMS_Assign_Resource__c,subject,status,GEMS_account_submission_info__c from case where id =:caseID ];
            displayImplementer = true;
            resourceCheck = false;
            if(caseRec.status == 'Completed')
            {
                approveOrRejectStatus='Approve';
                displayImplementer=true;
            }
            else if(caseRec.status == 'Declined')
            {
                approveOrRejectStatus='Declined';
                displayImplementer=false;
            }
        }
        catch(Exception ex){
            System.debug('=====exception==='+ex.getMessage());
        }
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Approve','Approve')); 
        options.add(new SelectOption('Declined','Declined')); 
        return options; 
    }
                   
    public String getApproveOrRejectStatus() 
    {
        return approveOrRejectStatus;
    }
                    
    public void setApproveOrRejectStatus(String approveOrRejectStatus) 
    {
        this.approveOrRejectStatus= approveOrRejectStatus; 
    }
    
    public void enableSelectImplementer()
    {
        displayImplementer=false;
        caserec.GEMS_Additional_Comments__c = '';
        if(approveOrRejectStatus=='Approve')
        {
            displayImplementer=true;
            List<caseteammember> caseTeamMembers = [select id,parentId,memberid,TeamRoleId from caseteammember where  parentId = :caserec.GEMS_Account_Submission_Info__c and memberid =:caseRec.GEMS_Assign_Resource__c];
            if(!caseTeamMembers.isEmpty()) resourceCheck = true;
        }
        else if(approveOrRejectStatus=='Declined')
        {
            displayImplementer=false;
        }
    }
    
    public pagereference Save()
    {
        try{
            Id caseGEMSGetRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();        

            if(caseRec.GEMS_Assign_Resource__c!=null)
            {
                caseteamrole reqResourceRole =[select id from caseteamrole where name = 'Implementer'];
                caseteammember insertCaseTeamMember = new caseteammember(teamroleid = reqResourceRole.id,parentid = caseRec.gems_account_submission_info__c,memberid = caseRec.GEMS_Assign_Resource__c);
                insert insertCaseTeamMember;
                System.debug('insertCaseTeamMember===============>' +insertCaseTeamMember);
                System.debug('Out approveOrRejectStatus=============>'+approveOrRejectStatus);
            }
            
            if(approveOrRejectStatus=='Approve')
            {
                
                caseRec.status = 'Completed';
                System.debug('in If approveOrRejectStatus===============>'+approveOrRejectStatus);
            }
            else if(approveOrRejectStatus=='Declined')
            {
                caseRec.status = 'Declined';
                System.debug('in else approveOrRejectStatus========>'+approveOrRejectStatus);
            }
            update caseRec;
            System.debug('final updated case Rec====>'+caseRec);
                        List<caseteamrole> caseTeamRoleList = [select id,name from caseteamrole where name in ('Client Implementation Consultant','Implementer')];
            Map<Id,String> roleIdRoleNameMap = new Map<Id,String>();
            for(caseteamrole ctr:caseTeamRoleList) {
                roleIdRoleNameMap.put(ctr.id,ctr.name);
            }
                    Boolean implementer = false;
        List<caseteammember> caseTeamMembers = [select id,parentId,memberid,TeamRoleId from caseteammember where TeamRoleId =:roleIdRoleNameMap.keySet() and parentId = :caserec.GEMS_Account_Submission_Info__c];
        Map<Id,caseteammember > caseIdSpecialistTeamMember = new Map<Id,caseteammember >();
        for(caseteammember teamMember: caseTeamMembers) {
            if(roleIdRoleNameMap.containsKey(teamMember.TeamRoleId) && roleIdRoleNameMap.get(teamMember.TeamRoleId) == 'Implementer') {
                caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember);
                implementer = true;
                break;
            }
            else {
                caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember); 
                implementer = true;
            }
        }
        List<Case> new_cases_list = new List<Case>();
        if(implementer) {
        case case_new = [select id,accountid,GEMS_Submission_Sub_Type__c,GEMS_Effective_Date__c,GEMS_Case_Effective_Date__c,GEMS_AEP_Account__c,Opportunity_Name__c,FSU_Location__c,GEMS_Line_of_Business__c,GEMS_Products__c,HCSC_Division__c,Account_Number__c,Account_Name__c,GEMS_Submission_Type__c from case where recordtypeid = :caseAccountSubmissionId and id =:caserec.GEMS_Account_Submission_Info__c];
        List<case> subCaseList = [select id from case where recordtypeid =:caseGEMSGetRecordTypeId and GEMS_Account_Submission_Info__c =:case_new.id];
            System.debug('==subCaseList ===='+subCaseList );
            if(subCaseList.isEmpty() ) {
                case newCase = new case();               
                    newCase.GEMS_Account_Submission_Info__c= case_new.id;
                    newCase.parentid = case_new .id;
                    newCase.Accountid = case_new.Accountid;
                    newCase.GEMS_Effective_Date__c = case_new.GEMS_Effective_Date__c;
                    newcase.GEMS_Submission_Type__c = case_new.GEMS_Submission_Type__c;
                    newCase.GEMS_Submission_Sub_Type__c = case_new.GEMS_Submission_Sub_Type__c;
                    newCase.Opportunity_Name__c = case_new.Opportunity_Name__c;
                    if(caseIdSpecialistTeamMember.containsKey(case_new.Id) ) {
                       newCase.ownerId = caseIdSpecialistTeamMember.get(case_new.Id).memberid;
                    }
                    DateTime effectiveDate = case_new.GEMS_Effective_Date__c;                
                    newCase.Subject = case_new.Account_Name__c+' '+ case_new.Account_Number__c +' '+effectiveDate.format('M/d/yyyy')+' GEMS Get';
                    newCase.status = 'In Progress';
                    newCase.parentid = case_new.id;
                    newCase.type = 'GET';
                    newCase.GEMS_Products__c = case_new.GEMS_Products__c;
                    newCase.HCSC_Division__c = case_new.HCSC_Division__c;
                    newCase.GEMS_Line_of_Business__c = case_new.GEMS_Line_of_Business__c;
                    newCase.FSU_Location__c = case_new.FSU_Location__c;
                    newCase.Opportunity_Name__c = case_new.Opportunity_Name__c ;                    
                    newCase.GEMS_AEP_Account__c = case_new.GEMS_AEP_Account__c;
                    newCase.recordTypeId = caseGEMSGetRecordTypeId;
                    newCase.GEMS_Case_Effective_Date__c = case_new.GEMS_Case_Effective_Date__c;                 
                    new_cases_list.add(newCase);  
                }                           
               }
               
            if(!new_cases_list.isEmpty()) {
            insert new_cases_list;
        }
        
        }
        catch(Exception ex){
        ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'The Requestd Implementer already exist in CaseTeam');
        ApexPages.addMessage(myMsg); 
            System.debug('=======exception====='+ex.getMessage());
            return null;
        }
        return null;
    }
}