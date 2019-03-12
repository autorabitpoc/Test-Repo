/**************************************************************************************
  Apex Class Name     : GEMS_CaseTeamPageController
  Version             : 1.0
  Function            : This method is to create request resources cases from GET case
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            06/23/2016             Original Version
* Phani Kommareddy	  09/21/2017		     SFDC-6371 GEMS: Prod Issue - Request Resource Case giving error message(From GET Case)
* Shankar			  09/27/2017			 SFDC-4278 Limit users from requesting the same resource role multiple times within a GET case
*************************************************************************************/
public with sharing class GEMS_CaseTeamPageController {
    public case caserec {set;get;}
    public Id caseID;
    Id requestResourceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Request Resource').getRecordTypeId();
    public GEMS_CaseTeamPageController(ApexPages.StandardController controller) {
        try {
            requestResourceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Request Resource').getRecordTypeId();
            caseID = apexpages.currentpage().getparameters().get('id');           
            //SFDC-6371 GEMS: Prod Issue - Request Resource Case giving error message - Due to GEMS_Submitter__c info missing
            caserec = [select id,subject,OwnerId,GEMS_Request_Resource__c,account.name,HCSC_Division__c,GEMS_Account_Submission_Info__c, GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c,GEMS_Account_Submission_Info__r.GEMS_Submission_Type__c,GEMS_Account_Submission_Info__r.GEMS_Submission_Sub_Type__c,GEMS_Case_Effective_Date__c,GEMS_AEP_Account__c,FSU_Location__c,GEMS_Line_of_Business__c,GEMS_Products__c,Opportunity_Name__c,Accountid,GEMS_Effective_Date__c,Account.External_ID__c from case where id =:caseID];
        }
        catch(Exception ex){
            System.debug('=====exception==='+ex.getMessage());
        }
    }
    
    
        
/******************************************************************** 
*    Method Name : Save
*   @description :   This method to update Parent case when all child process cases of all BA's approved
*   @parameters  :   
*   @return type :   pagereference
***************************************************************/
public pagereference Save(){
	try {
        Set<String> catSet = new Set<String>();
        List<String> queNames = new List<String>();
        Map<String,String> requestResourceCorrespondingQueueMap = new Map<String,String>();
        Map<String,Id> queueNameIdMap = new Map<String,Id>();
                
        List<GEMS_Request_Resource__mdt> requestResourceList = [select Business_Area__c,Queue_Name__c from GEMS_Request_Resource__mdt];
        for(GEMS_Request_Resource__mdt resourceMetaData : requestResourceList){
            if(resourceMetaData.Queue_Name__c != null && resourceMetaData.Queue_Name__c.length() > 1) {
                queNames.add(resourceMetaData.Queue_Name__c);
                requestResourceCorrespondingQueueMap.put(resourceMetaData.Business_Area__c, resourceMetaData.Queue_Name__c);
            }
        }

        List<Group> resourceQues =[select Id,Name from Group where Type = 'Queue' and name in : requestResourceCorrespondingQueueMap.values() ];

        for(Group resourceQue : resourceQues) {
            queueNameIdMap.put(resourceQue.Name,resourceQue.Id);
        }        

        // SFDC-4278. Modified query to check for Request Resource from both Account Submission & GET cases
        List<case> requestResourceCase = [select id,sub_category__c from case where (parentid = :caseID or GEMS_Account_Submission_Info__c = :caserec.GEMS_Account_Submission_Info__c) and recordtypeid = :requestResourceRecordTypeId];
        for(case caserec:requestResourceCase){
            catSet.add(caserec.sub_category__c);
        }
        

        String[] baList = caserec.GEMS_Request_Resource__c.split(';');
        
        if(caserec.GEMS_Request_Resource__c  != null ){
            List<case> caseList = new List<case>();
            for(String requestResource : baList) {
                if(catSet.contains(requestResource)) continue;
                Case baCase = new Case();
                DateTime effectiveDate = caserec.GEMS_Effective_Date__c;
                baCase.recordtypeid = requestResourceRecordTypeId;
                baCase.status = 'In Progress';
                baCase.subject = caserec.account.name + ' ' +caserec.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+requestResource;
                baCase.parentid = caseID;
                if( requestResourceCorrespondingQueueMap.get(requestResource) != null && queueNameIdMap.get(requestResourceCorrespondingQueueMap.get(requestResource)) != null) {
                    baCase.ownerId = queueNameIdMap.get(requestResourceCorrespondingQueueMap.get(requestResource)) ;
                }
                baCase.type = 'Request Resource';
                baCase.Sub_Category__c = requestResource;
                baCase.GEMS_Account_Submission_Info__c = caserec.GEMS_Account_Submission_Info__c ;
                baCase.Accountid = caserec.Accountid;
                baCase.GEMS_Effective_Date__c = caserec.GEMS_Effective_Date__c;
                baCase.Opportunity_Name__c = caserec.Opportunity_Name__c;
                
                baCase.GEMS_Products__c = caserec.GEMS_Products__c;
                baCase.HCSC_Division__c = caserec.HCSC_Division__c;
                baCase.GEMS_Line_of_Business__c = caserec.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c;
                baCase.GEMS_Submission_Type__c = caserec.GEMS_Account_Submission_Info__r.GEMS_Submission_Type__c;
                baCase.GEMS_Submission_Sub_Type__c = caserec.GEMS_Account_Submission_Info__r.GEMS_Submission_Sub_Type__c;
                baCase.FSU_Location__c = caserec.FSU_Location__c;                   
                baCase.GEMS_AEP_Account__c = caserec.GEMS_AEP_Account__c;
                baCase.GEMS_Case_Effective_Date__c = caserec.GEMS_Case_Effective_Date__c; 
                //SFDC-6371 GEMS: Prod Issue - Request Resource Case giving error message,Due to GEMS_Submitter__c info missing
               	baCase.GEMS_Submitter__c = caserec.ownerid;
                caseList.add(baCase);
            }
            if(!caseList.isEmpty()){
                insert caseList;
            }
            update caserec;
         }
	} catch(Exception ex){
            System.debug('==exception=='+ex.getMessage());
	}
	return null;
}
    
    
}