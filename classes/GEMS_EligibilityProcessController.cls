/**************************************************************************************
Apex Class Name     : GEMS_EligibilityProcessController 
Version             : 1.0
Function            : This class is to capture eligibility required field Info
Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            11/16/2016             Original Version
*************************************************************************************/
public class GEMS_EligibilityProcessController {
    public ID caserecId {set;get;}
    public Case caseRec{get;set;}
    public Boolean isCDHPGroupMember{get;set;}
    public GEMS_EligibilityProcessController(ApexPages.StandardController controller) {
        try {
            caserecId = apexpages.currentpage().getparameters().get('caseId');
            caseRec = [select HCSC_Division__c,GEMS_Is_Eligibility_Required__c,gems_account_submission_info__r.GEMS_Is_Eligibility_Required__c,Account.name,Account.External_ID__c,GEMS_Case_Effective_Date__c,GEMS_Submission_Type__c,GEMS_Submission_Sub_Type__c,status,Market_Segment__c,gems_account_submission_info__c,GEMS_Line_of_Business__c from case where id=:caserecId ];
            if(caseRec.gems_account_submission_info__r.GEMS_Is_Eligibility_Required__c == null) {
                caseRec.GEMS_Is_Eligibility_Required__c = (String)Case.GEMS_Is_Eligibility_Required__c.getDescribe().getDefaultValue();
            }
            else 
                caseRec.GEMS_Is_Eligibility_Required__c = caseRec.gems_account_submission_info__r.GEMS_Is_Eligibility_Required__c;
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_EligibilityProcessController', 'Case', null, 'GEMS_EligibilityProcessController(ApexPages.StandardController controller)','High'); 
        }
    }
    /******************************************************************** 
*    Method Name : Save
Action
*   @description :   This method to update eligibity required field on account submission case
*   @parameters  :   None
*   @return type :   Void
***************************************************************/
    public void save() {
        try {
            case accSubCase = new case(id=caseRec.gems_account_submission_info__c,GEMS_Is_Eligibility_Required__c = caseRec.GEMS_Is_Eligibility_Required__c);
            update accSubCase;          
            system.debug('@@ in save'+caseRec.GEMS_Is_Eligibility_Required__c);
            case currentCase = new case(id=caserecId,GEMS_Is_Eligibility_Required__c=caseRec.GEMS_Is_Eligibility_Required__c);
            update currentCase;
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_EligibilityProcessController', 'Case', null, 'save()','High'); 
        }
    }
    
/******************************************************************** 
*    Method Name : checkCurrentUserisACDHPQueMember
Action
*   @description :   This method to check whether the current member is a CDHP Que member or not
*   @return type :   Void
***************************************************************/
    public void checkCurrentUserisACDHPQueMember() {
        try {
            Set<Id> userOrGroupIds = new Set<Id>();
            //User userWithRole = [select userRole.name,Id, userroleId from user where id =: userinfo.getuserid()];
            List<String> roleRelatedGroupIds = new List<String>();
            for (Group g : [SELECT id, RelatedId, Type FROM Group where RelatedId= :UserInfo.getUserRoleId()]){
               roleRelatedGroupIds.add(g.id);
            }
            
            List<String> allGroupIDs = new List<String>();
            for (GroupMember gm : [SELECT Id, group.id, group.name, group.type FROM GroupMember where group.name = 'GEMS EEE Queue' 
                AND  ((UserOrGroupId =: UserInfo.getuserid()) OR (UserOrGroupId IN :roleRelatedGroupIds ))]){
                isCDHPGroupMember = true;
            }
            
            /*if(userWithRole != null) {
              List<Group> roleGroups = [Select Id, Name from Group Where Type = 'Queue' and name =:userWithRole.userRole.name ];
              if(roleGroups != null && !roleGroups.isEmpty()) {
                  userOrGroupIds.add(roleGroups[0].Id);
              }
            }
            userOrGroupIds.add(userinfo.getuserid());
            List<Group> cdhpGroupWithMembers = [Select Id, Name,(select UserOrGroupId from GroupMembers where UserOrGroupId In : userOrGroupIds ) From Group Where Type = 'Queue' and name ='GEMS EEE Queue'];
            for(Group cdhpGroup : cdhpGroupWithMembers) {
                if(cdhpGroup.GroupMembers != null && !cdhpGroup.GroupMembers.isEmpty()) {
                    isCDHPGroupMember = true;
                }
            }*/
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_EligibilityProcessController', 'Case', null, 'checkCurrentUserisACDHPQueMember()','High');  
        }
    }
}