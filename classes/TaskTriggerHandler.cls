/********************************************************************************************************
*  Apex Class Name     : TaskTriggerHandler
*  Version             : 1.0
*  Function            : This is a handler class for the task trigger
*  Modification Log    :
*  Developer			Date		Description
*  ----------------------------------------------------------------------------
*  Zachary Campbell		08/18/2017	SFDC-4552 added methods insertCaseCSSFields, updateCaseCSSFields,
*									and PopulateCaseCSSFields
*********************************************************************************************************/
public with sharing class TaskTriggerHandler {
	/******************************************************************** 
    * Method Name    : updateCaseStatus
    *   @description : This method updates the UnderWriting Case Status when a new Task of Type "Need Additional Information" is created
    *   @parameters  : list<Task> newTasklist,map<Id,Task> newTaskMap
    *   @return type :void  
    *   Requirement Number : REQ - 02209               
    ***************************************************************/
    public static void updateCaseStatus(list<Task> newlist,map<Id,Task> newMap){
        set<String> caseIds = new set<String>();
        for(Task t : newlist){
            if(t.whatId != null){
                if(string.valueOf(t.whatId).subString(0,3) == Case.sobjecttype.getDescribe().getKeyPrefix() && 
                   t.Type == ConstantsController.TaskTypeForUpdatingCaseStatus ){
                    
                	caseIds.add(t.whatId);
                }
            }
        }
        map<String,Case> caseRecords = new map<String,Case>( [SELECT Id, Status,
        															(SELECT	Id, Status 
        															 FROM 	Tasks 
        															 WHERE 	(Status != 'Completed' and Status != 'Deferred')
        															 AND 	Type = :ConstantsController.TaskTypeForUpdatingCaseStatus) 
        														FROM 	Case 
        														WHERE 	Id =:caseIds 
        														AND 	(RecordType.DeveloperName =: ConstantsController.UnderwritingCaseRecordType 
        																 or	RecordType.DeveloperName =:ConstantsController.DentalUnderwritingCaseRecordTypeDeveloperName ) 
        														LIMIT   :Limits.getLimitQueryRows() - Limits.getQueryRows() ] );
		if(!caseRecords.isEmpty()){
        	list<Case> updatedCaseStatus = new list<Case>();
        	for(Task t : newList){
            	if(t.Type == ConstantsController.TaskTypeForUpdatingCaseStatus){
                	if(t.Status != 'Completed' && t.Status != 'Deferred' && caseRecords.containsKey(t.whatId)){
                    	if(caseRecords.get(t.whatId).Status != ConstantsController.updatedCaseStatus){
                        	caseRecords.get(t.whatId).Status = ConstantsController.updatedCaseStatus;
                        	updatedCaseStatus.add(caseRecords.get(t.whatId));
                    	}
                	}
                	else if((t.Status == 'Completed' || t.Status == 'Deferred')&& caseRecords.containsKey(t.whatId)){
                    	if (caseRecords.get(t.whatId).Tasks.size() == 0 && caseRecords.get(t.whatId).Status != 'Closed' && caseRecords.get(t.whatId).Status != 'In Progress')
                        	caseRecords.get(t.whatId).Status = 'In Progress';
                        	updatedCaseStatus.add(caseRecords.get(t.whatId));
                	}
            	}
        	}
        	Database.SaveResult[] srList;
        	try{
            	if(updatedCaseStatus.size() > 0){
					ConstantsController.shouldCarrierHistoryValidationFire = false;
					srList = database.update(updatedCaseStatus,false);
               		for(Integer i=0;i<srList.size();i++){
                    	Database.SaveResult s = srList[i];
                    	Case origRecord = updatedCaseStatus[i];
                    	if (!s.isSuccess()) {
                        	for(Task t : newlist){
                            	if(t.whatId == origRecord.Id){
                                	t.addError(System.label.AnErrorHasOcurred);
                            	}
                        	}
						}	 
                	}
            	}
        	}catch(Exception e){
            	throw e;
        	}
    	}
    }
	/**
	* @description Updates the field Last_Opp_Activity_Date__c on the current User to the current time.
	*			   Used for tracking the last time a User created/edited Opportunity Tasks.
	* @param newTasks The list of Tasks in Trigger.new
	*/
/****    
	public static void updateUserLastOppActivity(List<Task> newTasks){
		
		try 
		{	        
			// Finds current User
			Id currUserId = UserInfo.getUserId();
			User currUser = [Select Id, Last_Opp_Activity_Date__c from User Where Id = :currUserId limit 1];
			
			// Builds list of Object Ids that newTasks are related to
			Set<Id> whatIds = new Set<Id>();
			for (Task newt : newTasks){
			
				whatIds.add(newt.WhatId);
			}
		
			// Queries for Opportunities that any Task in newTasks is related to
			Map<Id, Opportunity> m = new Map<Id, Opportunity>([Select Id, Name From Opportunity Where Id in :whatIds]); 

			// Looks through newTasks to find any related objects that are Opportunities.
			// If any are found, update the current User's Last_Opp_Activity_Date__c to the current time.
			for (Task t : newTasks){
				Opportunity o = m.get(t.WhatId);
			
				if (o != null){
					currUser.Last_Opp_Activity_Date__c = System.now();
				}
			}
			update currUser;
		}
		catch (Exception e){
			System.debug('Exception ' + e.getMessage());
		}
	}
****/
 /******************************************************************** 
    * Method Name    : sendEmailAlertToTaskOwner
    *   @description : This method updates the will send an email alert to taskowner when the task status is set as completed
    *   @parameters  : list<Task> newTasklist,map<Id,Task> oldTaskMap
    *   @return type :void  
    *   Requirement Number : REQ - 02523               
    ***************************************************************/
    public static void sendEmailAlertToTaskOwner(list<Task> newlist,map<Id,Task> oldMap){
        try{
	        if( !ConstantsController.isTaskCompletionEmailSent ) {
		        set<String> caseIds 		= new set<String>();
		        set<String> closedTaskIds 	= new set<String>();
		        set<String> createdUserIds  = new set<String>();
		        for(Task t :newlist ){
		            if(t.whatId != null) {
		                if(((oldMap != null && oldMap.containsKey(t.Id) && t.status != oldMap.get(t.Id).status) 
							|| (oldMap == null || !oldMap.containsKey(t.Id))) && t.status == 'Completed') {
							
							if(string.valueOf(t.whatId).subString(0, 3) == Case.sobjecttype.getDescribe().getKeyPrefix()){
		                    	caseIds.add(t.whatId);
		                    	closedTaskIds.add(t.Id); // this set will be used to validate the task id
		                		createdUserIds.add(t.CreatedById);
							}
		                }
		            }
		        }
		        set<String> allowedProfileNames = new set<String>();
		        for(Task_Closed_Mail_User_Profiles__c temp : Task_Closed_Mail_User_Profiles__c.getAll().values()){
		        	allowedProfileNames.add(temp.Name);
		        }
		        map<String,Case> caseRecords = new map<String,Case>([SELECT Id, Status, OwnerId
	    															FROM 	Case 
	    															WHERE 	Id =:caseIds 
	    															AND 	(RecordType.DeveloperName = :ConstantsController.UnderwritingCaseRecordType 
	    																	Or 	RecordType.DeveloperName = :ConstantsController.DentalUnderwritingCaseRecordTypeDeveloperName ) 
																	LIMIT	:Limits.getLimitQueryRows() - Limits.getQueryRows()]);
		        
		        map<Id,User> createdUsersMap = new Map<Id,User>([SELECT Profile.Name, Id FROM User WHERE Id In :createdUserIds]);
		        
		        list<Messaging.SingleEmailMessage> sendEmails = new list<Messaging.SingleEmailMessage>();
		        EmailTemplate et = [SELECT 	Id 
		        					FROM 	EmailTemplate 
		        					WHERE 	DeveloperName = 'Case_Task_Complete_VF_Template'
		        					LIMIT	1 ];
		       	Case caseRec;
		        for(Task t : newList){
		            
		            if(closedTaskIds.contains(t.Id)  && t.OwnerId != t.createdbyId && createdUsersMap.containsKey(t.createdbyId) 
		            	&& allowedProfileNames.contains(createdUsersMap.get(t.createdbyId).Profile.name) 
                        /*createdUsersMap.get( t.createdbyId ).Profile.name == 'Underwriting'*/){
                            
		            	system.debug('inside---');
		            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						mail.setTemplateId(et.Id);
						mail.setTargetObjectId(t.CreatedById);
						mail.setWhatId(t.Id); 
						mail.setSaveAsActivity(false); 
						sendEmails.add(mail);
		            }
		            else if(closedTaskIds.contains(t.Id) && caseRecords.containsKey(t.WhatId)){
		            	caseRec = caseRecords.get(t.WhatId);
		            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						mail.setTemplateId(et.Id);
						mail.setTargetObjectId(caseRec.OwnerId);
						mail.setWhatId(t.Id); 
						mail.setSaveAsActivity(false); 
						sendEmails.add(mail);
		            }
		        }

		        if(sendEmails.size() > 0){
		        	Messaging.sendEmail(sendEmails);
		        	ConstantsController.isTaskCompletionEmailSent = true;
		        }
	        }
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
    }
   
    /**********************************************************************************************
  	* @author               Zachary Campbell/HCSC
  	* @description          LGNA: Identifies related Case records for new or deleted tasks.
  	* @param NewTaskList	NewTaskList from Trigger.new
  	**********************************************************************************************/
    public static void insertCaseCSSFields(list<Task> NewTask){

		Id taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(Label.TaskRecordTypeCSSTaskRecordType).getRecordTypeId();
		set<Id> parentCaseId = new set<Id>();

		try{
            //determine if tasks meet needed CSS criteria
   	 		for(Task tsk : newTask){
   	  	 		if((tsk.recordtypeid == taskRecTypeId) && (string.valueof(tsk.WhatId.getSobjectType()) == 'Case') 
                   	&& (tsk.Status <> 'Closed') && (tsk.Status <> 'Completed')){ //open css task
   	  	   	 		//add parent case to setid
   	  	   	 	 	parentCaseId.add(tsk.whatId);
   	  	 		}
   	  		}
   	  		
			if(!parentCaseId.isEmpty()){
				//call method to tally and update CSS fields
            	populateCaseCSSFields(parentCaseId);
			}
        }catch (Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', 'TaskTrigger', 'TaskTriggerHandler.insertParentCaseCSSFields()', 'High');
        }  
    }   

    /**********************************************************************************************
  	* @author               Zachary Campbell/HCSC
  	* @description          LGNA: Identifies related Case records for updated/reassigned tasks.
  	* @param NewTaskList	NewTaskList from Trigger.new, oldTask from Trigger.oldMap
  	**********************************************************************************************/
    public static void updateCaseCSSFields(list<Task> NewTask, map<Id,Task> oldTask){

		Id taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(Label.TaskRecordTypeCSSTaskRecordType).getRecordTypeId();
		set<Id> parentCaseId = new set<Id>();

		try{
			for (Task tsk : NewTask){
				//verify task and parent case meet criteria
                if((tsk.recordtypeid == taskRecTypeId) && (string.valueof(tsk.WhatId.getSobjectType()) == 'Case')){
					//determine if Task status & parent Case ID or only parent Case ID have been updated
                    if((tsk.status != oldTask.get(tsk.Id).status && tsk.whatid != oldTask.get(tsk.Id).whatid) ||
                       tsk.whatid != oldTask.get(tsk.Id).whatid){
                    		parentCaseId.add(tsk.whatid);
	                    	parentCaseId.add(oldTask.get(tsk.Id).whatid);    
                    }
                	//determine if only Task status has been updated
                	else if(tsk.status != oldTask.get(tsk.Id).status){
                    	parentCaseId.add(tsk.whatid);
                	}  
            	}
			}

			if(!parentCaseId.isEmpty()){
				//call method to tally and update CSS fields
            	populateCaseCSSFields(parentCaseId);
			}
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', 'TaskTrigger', 'TaskTriggerHandler.updateParentCaseCSSFields()', 'High');
        }  
    }   

    /**********************************************************************************************
  	* @author               Zachary Campbell/HCSC
  	* @description          LGNA: Updates Open CSS Task fields for related cases.
  	* @param NewTaskList	NewTaskList from Trigger.new, oldTask from Trigger.oldMap
  	**********************************************************************************************/
    public static void populateCaseCSSFields(set<id> parentCaseId){

		Integer ct=0;
        //retreive required recordtype ids
		Id taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(Label.TaskRecordTypeCSSTaskRecordType).getRecordTypeId();
		Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypeLGNAGeneralCase).getRecordTypeId();
        
		try{
			//create and populate case map of parent cases with CSS fields
   	 	 	map<Id,Case> caseMap = new Map<Id,Case>();   	  	
   	  		for(Case cs : [SELECT Id, RecordtypeId, Open_CSS_Task__c, Open_CSS_Task_Count__c FROM Case where Id IN :parentCaseId]){ 
   	  	  		caseMap.put(cs.Id,cs);
   	 		}

            //create and populate case task-count map of parent case IDs and aggregated task counts
   	 	 	map<Id,Integer> caseTaskMap = new Map<Id,Integer>();
			for(AggregateResult result:[SELECT count(Id) ct, whatId FROM Task WHERE recordtype.id = :taskRecTypeId
               	        				AND what.type = 'Case' AND status <> 'Closed' AND status <> 'Completed' 
										AND whatid in :parentCaseId group by whatid]){
   	  	  			
				caseTaskMap.put((Id)result.get('whatId'), (Integer)result.get('ct'));
   	    	}
            
            //add cases that lost all CSS tasks to caseTask map
            for(id cid : parentCaseId){
                if(!caseTaskMap.containsKey(cid)){
                    caseTaskMap.put(cid, 0);
                }
            }
            
            //loop through the case task-count map using the key and count to update the case CSS fields.
   	 		list<Case> updateCase = new list<Case>();
   	  		if(!caseTaskMap.isEmpty()){
   	   	 		for(Id csId: caseTaskMap.keyset()){
   	     	 		Case cse = caseMap.get(csId);
                    if (caseRecTypeId == cse.recordtypeid){                    
                    	if (caseTaskMap.get(csId) > 0){
   	     	 				cse.Open_CSS_Task__c = true; //check box
   	     	 				cse.Open_CSS_Task_Count__c = caseTaskMap.get(csId); //include count
						} else {
							cse.Open_CSS_Task__c = false; //uncheck box
   	     	 				cse.Open_CSS_Task_Count__c = null; //remove count                        
                    	}
   	     		 		updateCase.add(cse);
                    }
   	     		}
   	 	 	}
            
			if(!updateCase.isEmpty()){
				update updateCase;
			}
		}catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', 'TaskTrigger', 'TaskTriggerHandler.populateParentCaseCSSFields()', 'High');
        }  
    }
    
    
}