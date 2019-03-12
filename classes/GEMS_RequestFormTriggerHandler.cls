/**************************************************************************************
Apex Class Name     : GEMS_RequestFormTriggerHandler
Version             : 1.0
Function            : This is a handler class for Request Form Trigger
Developer         : Date                   Description
----------------------------------------------------------------------------                 
Gokul Bharati       09/07/2017             US-3044
Malathi Kethireddy  06/11/2018             US-9337
*************************************************************************************/
public  class GEMS_RequestFormTriggerHandler{
    
    static Id SBCrecordTypeId = Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId(); 
    static Id BBrecordTypeId = Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId(); 
    
    public static void ChildtoParentStatusUpdate(Map<Id,GEMS_SBC_BB_Form__c> TriggerNewMap,Map<Id,GEMS_SBC_BB_Form__c> TriggerOldMap,List<GEMS_SBC_BB_Form__c> TriggerNew,List<GEMS_SBC_BB_Form__c> TriggerOld){
        Set<Id> parentIdRequest=new Set<Id>();
        Map<Id,List<GEMS_SBC_BB_Form__c>> ParentChild=new Map<Id,List<GEMS_SBC_BB_Form__c >>();
        for(GEMS_SBC_BB_Form__c rec:TriggerNew){
            if(Trigger.isAfter){
                string parentId=string.ValueOf(rec.GEMS_SBC_Request__c != null?rec.GEMS_SBC_Request__c:rec.GEMS_Benefit_Booklet_Request__c);    
                if(Trigger.isUpdate){
                    if(parentId!=null && TriggerOldMap.get(rec.Id).Form_Status__c != TriggerNewMap.get(rec.Id).Form_Status__c && (rec.Form_Status__c == 'Approved' || rec.Form_Status__c == 'Cancelled' || rec.Form_Status__c == 'New' || rec.Form_Status__c == 'In Progress' || rec.Form_Status__c == 'Return' || rec.Form_Status__c == 'Completed') && (rec.recordTypeId == SBCrecordTypeId || rec.recordTypeId == BBrecordTypeId )){
                        parentIdRequest.add(parentId);   
                    }
                }
                if(Trigger.isInsert){
                    if(parentId!=null && (rec.recordTypeId == SBCrecordTypeId || rec.recordTypeId == BBrecordTypeId)){
                        parentIdRequest.add(parentId);   
                    } 
                }
            }
        }
        if(parentIdRequest.isEmpty()){
            return;
        }
        Map<Id,GEMS_Contract_Admin_Request__c> ContractAdminReqEntries = new Map<Id, GEMS_Contract_Admin_Request__c>([select Id, Status__c from GEMS_Contract_Admin_Request__c where id in :parentIdRequest]);
        for(GEMS_SBC_BB_Form__c rec:[select Id,Form_Status__c,GEMS_Benefit_Booklet_Request__c,GEMS_SBC_Request__c from GEMS_SBC_BB_Form__c where (GEMS_SBC_Request__c in: parentIdRequest OR GEMS_Benefit_Booklet_Request__c in: parentIdRequest)]){
            string parentId=string.ValueOf(rec.GEMS_SBC_Request__c != null?rec.GEMS_SBC_Request__c:rec.GEMS_Benefit_Booklet_Request__c);
            if(parentId!=null && !ParentChild.containsKey(parentId))
                ParentChild.put(parentId, new list<GEMS_SBC_BB_Form__c>{rec}); 
            else
                ParentChild.get(parentId).add(rec);  
        }   
        system.debug('ParentChild'+ParentChild);
        if(!ParentChild.isEmpty()){
            List<GEMS_Contract_Admin_Request__c> updParList = new List<GEMS_Contract_Admin_Request__c>();
            for(Id par:ParentChild.keySet()){
                Boolean UpdateParentStaus=null;
                string parentStatus=ContractAdminReqEntries.get(par).Status__c;
                List<GEMS_SBC_BB_Form__c> childs=ParentChild.get(par);
                if(!childs.isEmpty()){
                    for(GEMS_SBC_BB_Form__c rec:childs){
                        //SFDC-7746: checking completed and cancelled status
                        if(rec.Form_Status__c == 'Cancelled' || rec.Form_Status__c == 'Completed'){
                            UpdateParentStaus=true;
                        } 
                        else{
                            UpdateParentStaus=false;
                            break;
                        }
                    }
                } 
                if(UpdateParentStaus){
                    if(parentStatus != 'Completed'){
                        updParList.add(new GEMS_Contract_Admin_Request__c(Id = par,Status__c = 'Completed')); 
                    }
                }
                else if(!UpdateParentStaus){ 
                    if(parentStatus != 'In Progress'){
                        updParList.add(new GEMS_Contract_Admin_Request__c(Id = par,Status__c = 'In Progress')); 
                    }
                } 
            }
            if(!updParList.isEmpty()){
                update updParList;
            }
        } 
    }
    public static void SendEmailandFlagUpdate(Map<Id,GEMS_SBC_BB_Form__c> TriggerNewMap,Map<Id,GEMS_SBC_BB_Form__c> TriggerOldMap,List<GEMS_SBC_BB_Form__c> TriggerNew,List<GEMS_SBC_BB_Form__c> TriggerOld){  
        Set<Id> sbcIdRequests =new Set<Id>();
        Set<Id> bbIdRequests =new Set<Id>();
        User actualApproverDetails ; 
        List<GEMS_SBC_BB_Form__c> UpdateSendMailFlaglist = new List<GEMS_SBC_BB_Form__c>();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<OrgWideEmailAddress> orgEmailAddress =  [select id, Address,displayname from OrgWideEmailAddress where displayname='No Reply GEMS'];  
        Map<Id,List<GEMS_SBC_BB_Form__c>> ParentChild=new Map<Id,List<GEMS_SBC_BB_Form__c >>();
        List<Task> sendEmailTaskList =new List<Task>();
        for(GEMS_SBC_BB_Form__c rec:TriggerNew){
            string parentId=string.ValueOf(rec.GEMS_SBC_Request__c != null?rec.GEMS_SBC_Request__c:rec.GEMS_Benefit_Booklet_Request__c);
            
            if(TriggerOldMap.get(rec.Id).Send_Email_Flag__c != TriggerNewMap.get(rec.Id).Send_Email_Flag__c &&  (rec.Send_Email_Flag__c == True ) && (rec.Form_Request_Type__c == 'Custom SBC' )){
                sbcIdRequests.add(rec.Id);   
            } 
            if(TriggerOldMap.get(rec.Id).Send_Email_Flag__c != TriggerNewMap.get(rec.Id).Send_Email_Flag__c &&  (rec.Send_Email_Flag__c== True ) && (rec.Form_Request_Type__c ==  'Custom Benefit Booklet')){
                bbIdRequests.add(rec.Id);   
            } 
        }                
        if((sbcIdRequests.isEmpty()) && (bbIdRequests.isEmpty())) {
            return;
        }
        if(!sbcIdRequests.isEmpty()) { 
            Set<String> emailIds = new Set<String>(); 
            String[] toAddresses;
            
            for(GEMS_SBC_BB_Form__c rec:[select Id,OwnerId,Owner.email,Owner.Name,Account_Name_Text__c,Account_Number__c,Form_Id__c,Form_Link__c,Effective_Date__c,Case__c,GEMS_SBC_Request__r.Case__r.Owner.email from GEMS_SBC_BB_Form__c where Id in :sbcIdRequests]){                                                                                                                                        
                GEMS_SBC_BB_Form__c sbcRec ;
                sbcRec =  rec;
                Id SubCaseId = (sbcRec.Case__c).substring(10,25);
                
                case subcaseownerId = [Select OwnerId from Case where Id = :SubCaseId];
                actualApproverDetails = [SELECT Name,Email FROM User where Id = :subcaseownerId.OwnerId ];
                emailIds.add(actualApproverDetails.email);
                
                List<ProcessInstance> actualApprover = new List<ProcessInstance>();
                actualApprover =  [SELECT Id, LastActorId FROM ProcessInstance where TargetObjectId= :sbcRec.Id and status = 'Approved' ORDER BY CreatedDate DESC limit 1];
                // CHECK FOR NULL ASSIGMENT TO Malathi.k
                If (!actualApprover.isEmpty()) {
                    actualApproverDetails = [SELECT Name,Email FROM User where Id = :actualApprover[0].LastActorId];        
                    emailIds.add(actualApproverDetails.email);
                }                               
                
                If(emailIds.size() > 0)
                {
                    toAddresses = new String[emailIds.size()];
                    Integer i = 0;
                    for (String to: emailIds) {
                        toAddresses[i++] = to;
                    }
                    
                    String effectiveDate1 = sbcRec.Effective_Date__c;
                    String subjecttt;
                    String body;                        
                    
                    subjecttt = sbcRec.Account_Name_Text__c +' - '+sbcRec.Account_Number__c+' - '+effectiveDate1;
                    body =  'The final version of the SBC has been uploaded to SharePoint. Please distribute or take any necessary action. </br></br> <b>Account Name : </b>'+ sbcRec.Account_Name_Text__c +'</br> <b>Form Number &nbsp : </b>'+ sbcRec.Form_Id__c +'</br> <b>Form Details &nbsp : </b>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ sbcRec.Id+'</br><b>Contract Admin Analyst &nbsp: </b> ' +sbcRec.Owner.Name + '</br> <b>Approver &nbsp : </b>' +actualApproverDetails.Name + '</br></br>Thanks';

                    GEMS_EmailNotification.createMassEmailMessageSBCBB(mailList,toAddresses,subjecttt,body);
                    
                    
                    //Task a = new Task(whoid=UserInfo.getUserId(),ownerid = UserInfo.getUserId(),whatid='sbcRec[0].Id',Subject='Send Final Document Email',Status='Completed');
                    //insert a; 
                    String userID=UserInfo.getUserId();  
                    Task SendMailTask = new Task();
                    SendMailTask.Subject = 'Send Final Document Email';
                    SendMailTask.Priority = 'Normal';
                    SendMailTask.Type = 'Send Final Document Email ';
                    SendMailTask.Status = 'Completed';
                    SendMailTask.ActivityDate = date.today();
                    SendMailTask.Task_Created_Date__c = date.today();        
                    SendMailTask.OwnerId = userId;
                    SendMailTask.WhatId = sbcRec.Id;
                    sendEmailTaskList.add(SendMailTask);
                    
                    // if (!sbcRec.isEmpty()) {
                    sbcRec.Send_Email_Flag__c = false;
                    UpdateSendMailFlaglist.add(sbcRec);                                 
                    //}                         
                }                   
            }
        }          
        
        if(!bbIdRequests.isEmpty()) {
            Set<String> bbemailIds = new Set<String>(); 
            String[] bbtoAddresses;
            GEMS_SBC_BB_Form__c bbRec ; 
            for(GEMS_SBC_BB_Form__c rec:[select Id,OwnerId,Owner.email,Owner.Name,Account_Name_Text__c,Account_Number__c,Form_Id__c,Form_Link__c,Effective_Date__c,Case__c,GEMS_Benefit_Booklet_Request__r.Case__r.Owner.email from GEMS_SBC_BB_Form__c where Id in :bbIdRequests]){
                bbRec=  rec; 
                
                Id SubCaseId = (bbRec.Case__c).substring(10,25);
                
                case subcaseownerId = [Select OwnerId from Case where Id = :SubCaseId];
                actualApproverDetails = [SELECT Name,Email FROM User where Id = :subcaseownerId.OwnerId ];
                bbemailIds.add(actualApproverDetails.email);
                
                List<ProcessInstance> actualApprover = new List<ProcessInstance>();
                actualApprover = [SELECT Id, LastActorId FROM ProcessInstance where TargetObjectId= :bbRec.Id and status = 'Approved' ORDER BY CreatedDate DESC limit 1];
                If (!actualApprover.isEmpty()) {
                    actualApproverDetails = [SELECT Name,Email FROM User where Id = :actualApprover[0].LastActorId ];        
                    bbemailIds.add(actualApproverDetails.email);    
                }
                If(bbemailIds.size() > 0)
                {
                    bbtoAddresses = new String[bbemailIds.size()];
                    Integer i = 0;
                    for (String to: bbemailIds) {
                        bbtoAddresses[i++] = to;
                    }
                    
                    String effectiveDate1 = bbRec.Effective_Date__c;
                    String subjecttt;
                    String body;                        
                    
                    subjecttt = bbRec.Account_Name_Text__c +' - '+bbRec.Account_Number__c+' - '+effectiveDate1;
                    body =  'The final version of the Benefit Booklet has been uploaded to SharePoint. Please distribute or take any necessary action. </br></br> <b>Account Name : </b>'+ bbRec.Account_Name_Text__c +'</br> <b>Form Number &nbsp : </b>'+ bbRec.Form_Id__c +'</br> <b>Form Details &nbsp : </b>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+bbRec.Id+'</br><b>Contract Admin Analyst &nbsp: </b> ' +bbRec.Owner.Name + '</br> <b>Approver &nbsp : </b>' + +actualApproverDetails.Name +'</br></br>Thanks';
                    
                    GEMS_EmailNotification.createMassEmailMessageSBCBB(mailList,bbtoAddresses,subjecttt,body);
                    
                    String userID=UserInfo.getUserId();
                    Task SendMailTask = new Task();
                    SendMailTask.Subject = 'Send Final Document Email';
                    SendMailTask.Priority = 'Normal';
                    SendMailTask.Type = 'Send Final Document Email ';
                    SendMailTask.Status = 'Completed';
                    SendMailTask.ActivityDate = date.today();
                    SendMailTask.Task_Created_Date__c = date.today();        
                    SendMailTask.OwnerId = userId;
                    SendMailTask.WhatId = bbRec.Id;
                    sendEmailTaskList.add(SendMailTask);                 
                    
                    //  if(!bbRec.isEmpty()) {
                    bbRec.Send_Email_Flag__c = false;
                    UpdateSendMailFlaglist.add(bbRec);                              
                    //  }                        
                    
                }      
            }
        }
        
        
        if(!mailList.isEmpty()) {
            if(orgEmailAddress != null && !orgEmailAddress.isEmpty()) {
                for(Messaging.SingleEmailMessage mailMessage : mailList) {
                    mailMessage.setOrgWideEmailAddressId(orgEmailAddress.get(0).Id);
                }
            }         
            Messaging.sendEmail(mailList); 
        }
        
         if(!sendEmailTaskList.isEmpty()){
             insert sendEmailTaskList;
         }               
                        
        if(!UpdateSendMailFlaglist.isEmpty()) {                     
            update UpdateSendMailFlaglist;
        }   
        
    }
}