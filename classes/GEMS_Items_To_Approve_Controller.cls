/**************************************************************************************
Apex Class Name     : GEMS_Items_To_Approve_Controller
Version             : 1.0
Function            : This is a controller for GEMS Custom Item To Approve
Modification Log    : 
Developer             Date                                Description
------------------------------------------------------------------------------------- 
Gokul Bharati         9/28/2017                           SFDC-4242
**************************************************************************************/
public class GEMS_Items_To_Approve_Controller {
    
    public List<ApprovalRecords> approvalRecords{get;set;}
    
    public GEMS_Items_To_Approve_Controller (){
        approvalRecords = new List<ApprovalRecords>(); 
        processProcessInstanceRecords(); 
    }    
    
    public class ApprovalRecords{  
        public string workItemId{get;set;}  
        public string relatedToName{get;set;}
        public string relatedToId{get;set;}
        public string opportunityName{get;set;}
        public string opportunityId{get;set;}
        public string accountName{get;set;}
        public string accountId{get;set;}
        public string parentCaseName{get;set;}
        public string parentCaseId{get;set;}
        public string childCaseName{get;set;}
        public string childCaseId{get;set;}
        public string type{get;set;}
        public string actor{get;set;}
        public string actorId{get;set;}
        public string originalactor{get;set;}
        public string originalactorId{get;set;}
        public string dateSubmitted{get;set;}
        public string mostRecentApproverName{get;set;}
        public string mostRecentApproverId{get;set;}
        public ApprovalRecords(){    
        }
    }
    
    public void processProcessInstanceRecords(){
        Map<Id,Case> IdCaseRec = new Map<Id,Case>();
        Map<Id,string> queueIdName = new Map<Id,string>();
        Set<Id> caseRecordIds = new Set<Id>();
        Set<Id> queueIds = new Set<Id>();
        Set<Id> roleGroupIds =new Set<Id>();
        try{
        //Get User Role Ids
        for(Group grp:[SELECT id, RelatedId, Type FROM Group where RelatedId =:UserInfo.getUserRoleId() and (Type ='RoleAndSubordinates' OR Type ='Role')]){
            roleGroupIds.add(grp.Id);
        }
        //Public Group
        for(GroupMember grp:[Select Group.Id,UserOrGroupId  from GroupMember where (UserOrGroupId = :UserInfo.getUserId() AND Group.Type='Regular')]){
            roleGroupIds.add(grp.Group.Id);
        }
        //Get User and Queue Info Map
        Map<Id,GroupMember> GroupIdMember = new Map<Id,GroupMember>();
        //Queue
        for(GroupMember grp:[Select Group.Id,UserOrGroupId  from GroupMember where (Group.Type = 'Queue' AND (UserOrGroupId = :UserInfo.getUserId() OR UserOrGroupId in:roleGroupIds))]){
            GroupIdMember.put(grp.Group.Id,grp); 
        }
        system.debug('<<<GroupIdMember>>>'+GroupIdMember);
        //Get Process Instance records for the user and for he is part of the queue.
        List<ProcessInstanceWorkItem> processInstanceItems = [SELECT 
                                                              Id, 
                                                              ProcessInstance.TargetObject.Name,
                                                              ProcessInstance.LastActor.LastName,ProcessInstance.LastActor.FirstName,
                                                              ProcessInstance.LastActorId,
                                                              ProcessInstance.TargetObject.Type,
                                                              ProcessInstance.createdDate,
                                                              ProcessInstance.SubmittedById,ProcessInstance.SubmittedBy.LastName,ProcessInstance.SubmittedBy.FirstName,
                                                              Actor.lastName,Actor.FirstName,ActorId,
                                                              OriginalActorId,OriginalActor.LastName,OriginalActor.FirstName
                                                              FROM ProcessInstanceWorkItem 
                                                              WHERE ProcessInstance.Status = 'Pending' and (ActorId =:UserInfo.getUserId() OR ActorId in:GroupIdMember.keySet()) Order By CreatedDate DESC LIMIT 100];
        
        if(!processInstanceItems.isEmpty()){ 
            //get all the caseIds to fetch all its related field
            for(ProcessInstanceWorkItem obj : processInstanceItems){
                if(obj.ProcessInstance.TargetObjectId != null && obj.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName() == 'Case'){
                    caseRecordIds.add(obj.ProcessInstance.TargetObjectId);
                }
                string orginalActorId = obj.OriginalActorId;
                if(obj.OriginalActorId != null && (orginalActorId.containsIgnoreCase('00G'))){
                    queueIds.add(obj.OriginalActorId);
                }
            }
            //fetch all the related fields inside a map
            if(!caseRecordIds.isEmpty()){ 
                for(case recs:[Select Id,Account.Name,AccountId,Opportunity_Name__c,Opportunity_Name__r.Name,Parent.CaseNumber,ParentId,GEMS_Account_Submission_Info__c,GEMS_Account_Submission_Info__r.CaseNumber From Case where Id in: caseRecordIds]){
                    IdCaseRec.put(recs.Id,recs);
                }          
            }
            if(!queueIds.isEmpty()){
                for(QueueSObject obj:[Select Id, SobjectType, QueueId, Queue.Name From QueueSObject where QueueId in:queueIds]){
                  queueIdName.put(obj.QueueId,obj.Queue.Name); 
                }
            }
            for(ProcessInstanceWorkItem obj : processInstanceItems){
            
                ApprovalRecords apprverecs=new ApprovalRecords();
                apprverecs.workItemId = obj.Id;   
                apprverecs.relatedToName = obj.ProcessInstance.TargetObject.Name;
                apprverecs.relatedToId = obj.ProcessInstance.TargetObjectId;
                apprverecs.type = (Id.valueOf(obj.ProcessInstance.TargetObjectId).getSObjectType()).getDescribe().getLabel();
                Datetime subdte= obj.ProcessInstance.createdDate != null?obj.ProcessInstance.createdDate:null;             
                apprverecs.dateSubmitted = subdte!=null?subdte.format('MM/dd/yyyy h:mm a','America/Chicago'):'';
                apprverecs.mostrecentApproverName = obj.ProcessInstance.SubmittedById!= null?obj.ProcessInstance.SubmittedBy.LastName+', '+obj.ProcessInstance.SubmittedBy.FirstName:'';
                apprverecs.mostRecentApproverId = obj.ProcessInstance.SubmittedById!= null?obj.ProcessInstance.SubmittedById:'';
                
                string ActorId = obj.ActorId;
                if(obj.ActorId!=null && ActorId.containsIgnoreCase('005')){
                    apprverecs.actorId = obj.ActorId!= null?obj.ActorId:null;
                    apprverecs.actor = obj.ActorId !=null?obj.Actor.LastName+', '+obj.Actor.FirstName:'';
                }
                else if(obj.ActorId!=null && ActorId.containsIgnoreCase('00G')){
                    apprverecs.actorId = UserInfo.getUserId();
                    apprverecs.actor = UserInfo.getLastName()+', '+UserInfo.getFirstName();
                }
                
                string orginalActorId = obj.OriginalActorId;
                if(obj.OriginalActorId!=null && orginalActorId.containsIgnoreCase('005')){
                    apprverecs.originalactor = (obj.OriginalActor.LastName != null && obj.OriginalActor.FirstName != null)?obj.OriginalActor.LastName+', '+obj.OriginalActor.FirstName:'';        
                    apprverecs.originalactorId = (obj.OriginalActorId!= null)?obj.OriginalActorId:null;   
                }
                else if(obj.OriginalActorId!=null && orginalActorId.containsIgnoreCase('00G')){
                  if(!queueIdName.isEmpty()){
                    apprverecs.originalactor = queueIdName.get(orginalActorId)!=null?queueIdName.get(orginalActorId):'';
                    apprverecs.originalactorId = (obj.OriginalActorId!= null)?obj.OriginalActorId:null;
                  }
                }
                //Populate Fields for Case records only
                if(!IdCaseRec.isEmpty() && obj.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName() == 'Case'){
                    apprverecs.opportunityName = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!=null?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).Opportunity_Name__r.Name:'';
                    apprverecs.opportunityId = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!=null?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).Opportunity_Name__c:'';
                    apprverecs.accountName = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!= null ?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).Account.Name:'';
                    apprverecs.accountId = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!= null ?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).AccountId:'';      
                    apprverecs.parentCaseName = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!= null?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).GEMS_Account_Submission_Info__r.CaseNumber:'';
                    apprverecs.parentCaseId = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!= null?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).GEMS_Account_Submission_Info__c:''; 
                    apprverecs.childCaseName = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!= null?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).Parent.CaseNumber:'';
                    apprverecs.childCaseId = IdCaseRec.get(obj.ProcessInstance.TargetObjectId)!= null?IdCaseRec.get(obj.ProcessInstance.TargetObjectId).Parent.Id:'';
                }
                             
                approvalRecords.add(apprverecs);
                }
            }
          }
          catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', null, null, 'GEMS_Items_To_Approve_Controller.processProcessInstanceRecords()','High');              
          }   
        } 
    
}