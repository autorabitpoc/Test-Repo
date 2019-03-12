public class GEMS_GetPageController {
public String comments{get;set;}
public case caseRec {set;get;}
public Id caserecId;
//public Case caseRec;
public Case casecommentRec;

    public GEMS_GetPageController(ApexPages.StandardController controller) {
    try{
    caserecId = apexpages.currentpage().getparameters().get('id');
    caseRec = [select id,GEMS_Submission_Type__c,GEMS_Submission_Sub_Type__c,opportunity_name__c,Accountid,GEMS_Case_Effective_Date__c,GEMS_AEP_Account__c,GEMS_Products__c,FSU_Location__c,HCSC_Division__c,GEMS_Line_of_Business__c,Account.External_ID__c,GEMS_Effective_Date__c,account.name from case where id =:caserecId ];
   
    //caseteammember caseTmMember = [select id,parentId,member.id from caseteammember where TeamRoleId in (select id from caseteamrole where name='Electronic Eligibility Specialist') and parentId =:caserecId];     
}
catch(Exception ex) {
            System.debug('===Exception==='+ex.getMessage());
        }
        }
public pagereference save( ) {   
  try{  
  System.debug('========comments==='+comments);
  Id requestImpRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Request Implementer').getRecordTypeId();
  List<case> requestImplementerCase = [select id from case where recordtypeid = :requestImpRecordTypeId  and parentid = :caserec.id];
if(requestImplementerCase.isEmpty() ) {
Group gemsImpleQueue = [select Id,name from Group where Name ='GEMS_ACCOUNT IMPLEMENTATION TEAM'and Type = 'Queue' limit 1];
Case gemsGetRecord = new Case();
DateTime effectiveDate = caserec.GEMS_Effective_Date__c;
gemsGetRecord.recordtypeid=requestImpRecordTypeId;
gemsGetRecord.status = 'In Progress';
gemsGetRecord.subject = caserec.account.name + ' ' +caserec.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+'Request Implementer';
gemsGetRecord.parentid = caserec.id;
gemsGetRecord.ownerId = gemsImpleQueue.Id;
gemsGetRecord.type='Request Implementer';
gemsGetRecord.Sub_Category__c = 'Request Implementer';
gemsGetRecord.GEMS_Account_Submission_Info__c = caserec.id ;
gemsGetRecord.Accountid = caserec.Accountid;
//added below two lines for the defect ALM1069
gemsGetRecord.GEMS_Submission_Type__c = caserec.GEMS_Submission_Type__c;
gemsGetRecord.GEMS_Submission_Sub_Type__c = caserec.GEMS_Submission_Sub_Type__c;
gemsGetRecord.GEMS_Effective_Date__c = caserec.GEMS_Effective_Date__c;
gemsGetRecord.Opportunity_Name__c = caserec.Opportunity_Name__c;

gemsGetRecord.GEMS_Products__c = caserec.GEMS_Products__c;
gemsGetRecord.HCSC_Division__c = caserec.HCSC_Division__c;
gemsGetRecord.GEMS_Line_of_Business__c = caserec.GEMS_Line_of_Business__c;
gemsGetRecord.FSU_Location__c = caserec.FSU_Location__c;                   
gemsGetRecord.GEMS_AEP_Account__c = caserec.GEMS_AEP_Account__c;
gemsGetRecord.GEMS_Case_Effective_Date__c = caserec.GEMS_Case_Effective_Date__c; 
    insert gemsGetRecord;
    CaseComment obj = new CaseComment();
    obj.CommentBody=comments;
    obj.ParentId = gemsGetRecord.id;
    insert obj;
    system.debug('======'+comments);
}
    }
    catch(exception ex){
    System.debug('==========exception==='+ex.getMessage());
        return null;
    }
return null;
    }
    
    
}