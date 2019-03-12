public class RequestTypeNIBtnController {
    private List<Request_Type__c> rtObj,rtobj1;
    public Case caseObj;
    public string errorMessage {get;set;}
    public Id sCaseId {get;set;}
    
    public RequestTypeNIBtnController(ApexPages.StandardSetController stdController) {
        sCaseId = ApexPages.currentPage().getParameters().get('Id');
        this.caseObj=[select Status,RecordTypeId,Owner_Name__c from case where Id=:sCaseId];
    }
    public void CaseSubmitFunctionAddNI(){
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.RecordTypeId).getName();
        if(recordTypeName == 'Network Information'){
            caseSubmitAddorEditNItype();
        }
    }
    public PageReference caseSubmitAddorEditNItype(){
        set<Id> sId = new set<Id>();
        Group membersId= new Group();
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.RecordTypeId).getName();
        Id loggedinuser = UserInfo.getUserId();
        membersId=[SELECT (SELECT UserOrGroupId,GroupId,Id FROM GroupMembers) FROM Group where DeveloperName = 'Network_Information'];        
        for(GroupMember gm:membersId.GroupMembers){
            sId.add(gm.UserOrGroupId);
        }
        if(recordTypeName == 'Network Information' && caseObj.Status == 'Assigned' &&
           caseObj.Owner_Name__c == 'Network Information' && sId.contains(loggedinuser) == false){
               errorMessage ='Only team members can make updates to a case assigned to the team.';
           } else 
               if(recordTypeName == 'Network Information' && caseObj.Status == 'Assigned' &&
                  caseObj.Owner_Name__c != 'Network Information' && sId.contains(loggedinuser) == false){
                      errorMessage ='Only team members can make updates to an assigned case.';
                  } else
                  {
                      system.debug('Add or edit else');
                  }
        return null;
    }
}