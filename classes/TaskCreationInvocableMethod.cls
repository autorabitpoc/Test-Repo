/*****************************************************************/
/*  Created:  09/2017                                            */
/*                                                               */
/*  Usage: Designed to create a Task from a Process Builder flow */
/*         with very specific criteria defined by Business User. */
/*                                                               */
/*  SFC-7136 - 11/2017 - Update criteria so that Task & email    */
/*                       will not be sent is there is already    */
/*                       an existing Contract Administration (CA)*/
/*                       case (Custom or Standard) associated to */
/*                       that Account.                           */
/*****************************************************************/
global class TaskCreationInvocableMethod     {
    
    @InvocableMethod (label='Create a Specific Task' description='Creates a Task based on a specific Business Requirements.')
    global static void CreateATask(List<TaskCreationRequestWrapper> requests){
        
        for (TaskCreationRequestWrapper TheRequest:requests){
            
            if (TheRequest.TaskCreationProcess == 'OpportunityWonCreateATaskForAccountExecutive'){
                
                Id IdOfAssignee;
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 1');
                
                /* create the Task shell */
                Task TheNewTask = new Task();
                
                /* add the Task details */
                TheNewTask.Subject = TheRequest.TaskSubject;
                TheNewTask.Follow_Up_Date__c = TheRequest.TaskFollowUpDate;
                TheNewTask.Priority = TheRequest.TaskPriority;
                TheNewTask.Status = TheRequest.TaskStatus;
                TheNewTask.Type = 'Create a Contract Admin Case';
                TheNewTask.WhatId = TheRequest.OpportunityID;
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 2');
                
                String TheDescription = 'This is a reminder to submit a Contract Admin case.  Please follow the these instructions:\n' ;
                TheDescription += '1) Open the Account.\n';
                TheDescription += '2) Click the Request Hub button located on the Account 360 View.\n';
                TheDescription += '3) Select Contract Admin under Request Category picklist.\n';
                TheDescription += '4) Complete the questionnaire and click continue.\n';
                TheDescription += 'Once done please mark the task as Completed';
                TheNewTask.Description = TheDescription; 
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 3');
                
                TheNewTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(TheRequest.TaskRecordTypeName).getRecordTypeId();
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 4');
                
                /* Logic to decide who will be assigned the Task */
                
                List<Opportunity> TheOpportunity = new List<Opportunity>(); 
                TheOpportunity = [SELECT
                                  Id,AccountId
                                  FROM Opportunity
                                  WHERE Id = :TheRequest.OpportunityID
                                  LIMIT 1];
                
                system.debug('TheOpportunity: ' + TheOpportunity);
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 5');
                                
                List<Account> TheAccount = new List<Account>();
                TheAccount = [SELECT
                              Id,Account_Cluster_Name__c,OwnerId
                              FROM Account
                              WHERE Id = :TheOpportunity[0].AccountId
                              LIMIT 1];
                
                system.debug('TheAccount: ' + TheAccount);
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 6');
                
                  /* SFDC-7136 - 11/2017 - BEGIN */                
                Boolean ContinueToCreateTaskAndEmail;
                
                /* Get the Record Type ID's for the Standard and Custom Cases */
                Id AStandardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Standard Contracts').getRecordTypeId();
                ID ACustomCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
                	                
                Id TheAccountID = TheAccount[0].Id;

                /* Query to determine if there are already existing Cases for this Account */
                String CountQuery = 'SELECT COUNT() FROM Case WHERE AccountId = :TheAccountId AND ((RecordTypeId = :AStandardCaseRecordTypeId) OR (RecordTypeId = :ACustomCaseRecordTypeId))';               

                Integer ContractAdminCasesForAccount = database.countQuery(CountQuery) ;
                
                /* If Count > 0 Then set Flag */
                If (ContractAdminCasesForAccount > 0) {
                    ContinueToCreateTaskAndEmail = false;
                } else {
                    ContinueToCreateTaskAndEmail = true;
                }
                
                System.debug('ContractAdminCasesForAccount: ' + ContractAdminCasesForAccount);
                System.debug('ContinueToCreateTaskAndEmail Flag: ' + ContinueToCreateTaskAndEmail);              
                
                /* if the Flag = False then Break the FOR Loop so that */
                /* Task is not created and Email is not sent.          */
                If (ContinueToCreateTaskAndEmail == false){
                    Break;
                }
                /* SFDC-7136 - 11/2017 - END   */                
                
                List<User> TheUserToAssign = new List<User>();
                If (String.isBlank(TheAccount[0].Account_Cluster_Name__c)){
                    /* Need to leave the List as empty to fall thru logic below */
                }else{                    
                    TheUserToAssign = [SELECT
                                       Id
                                       FROM User
                                       WHERE Name = :TheAccount[0].Account_Cluster_Name__c
                                       LIMIT 1];                    
                }
                
                system.debug('TheUserToAssign: ' + TheUserToAssign);
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 7');
                
                if (TheUserToAssign.size() == 1){
                    /* if the Account.Account_Cluser_Name__c value matched a User that is the Assignee */
                    TheNewTask.OwnerId = TheUserToAssign[0].Id;
                    IdOfAssignee = TheUserToAssign[0].Id;
                    system.debug('Used TheUserToAssign for Id');
                } else {
                    List<OpportunityTeamMember> TheOpportunityTeamAccountExecutives = new List<OpportunityTeamMember>();
                    TheOpportunityTeamAccountExecutives = [SELECT
                                                           UserId
                                                           FROM OpportunityTeamMember 
                                                           WHERE TeamMemberRole = 'Account Executive'
                                                           AND OpportunityId = :TheRequest.OpportunityID
                                                          ];
                    /* if the Account Executive on the Opportunity Team is present that is the Assignee */
                    if (TheOpportunityTeamAccountExecutives.size() > 0){
                        TheNewTask.OwnerId = TheOpportunityTeamAccountExecutives[0].UserId;
                        IdOfAssignee = TheOpportunityTeamAccountExecutives[0].UserId;
                        system.debug('Used TheOpportunityTeamAccountExecutives for Id');
                    } else {
                        /* as a last resort assign the Task to the Account Owner */
                        TheNewTask.OwnerId = TheAccount[0].OwnerId;
                        IdOfAssignee = TheAccount[0].OwnerId;
                        system.debug('Used TheAccount for Id');
                    }
                }
                
                system.debug('IdOfAssignee: ' + IdOfAssignee);
                
                Try{
                    insert TheNewTask;
                } catch (DMLException e){
                    system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive>DMLException: ' + e.getMessage());
                }
                
                /* get the email address of the person Assigned the Task */
                User TheTaskAssignee = [SELECT Id, Email
                                        FROM User
                                        WHERE
                                        Id = :IdOfAssignee
                                        LIMIT 1];
                List<String> SendToAddresses = new List<String>();
                SendToAddresses.add(TheTaskAssignee.Email);
                
                system.debug('Task Assignee Email Address: ' + TheTaskAssignee.Email);
                
                /* Have to create a Temporary Contact as Messaging Class does not work properly */
                /* with a Template being sent to a User                                         */
                Contact TempContact = new Contact();
                Datetime myDateTime = DateTime.now();
                String myLastName = 'FakeContact' + myDateTime.format();
                TempContact.LastName = myLastName;
                TempContact.Email = TheTaskAssignee.Email;
                TempContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
                
                Try{
                    Upsert TempContact;
                }catch(DMLException ContactExc){
                    System.debug('Upsert Contact Exception: ' +ContactExc.getDmlMessage(0));
                }
                
                Id ContactIdToDelete = TempContact.Id;
                
                /* send the Account Executive an email for notification */                
                EmailTemplate templateId = [SELECT 
                                            id 
                                            FROM EmailTemplate 
                                            WHERE 
                                            Name = 'OppWonNeedContractAdminCase'
                                            LIMIT 1];                
                system.debug('Email Template Id: ' + templateId);
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 8');
                
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                mail.setTargetObjectId(ContactIdToDelete);
                mail.setWhatId(TheOpportunity[0].Id);
                mail.setSaveAsActivity(false);                
                allmsg.add(mail);
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 9');                
                
                try{
                    Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(allmsg,true);
                }catch(System.EmailException Emailex){
                    system.debug('Email Exception: ' + Emailex);
                }                
                
                system.debug('CreateATask>OpportunityWonCreateATaskForAccountExecutive CheckPoint 10');
                
                Delete TempContact;
                
            }
        }
    }
    global class TaskCreationRequestWrapper{
        
        @InvocableVariable(label='Identify the Process' description='Provide this to ensure correct logic in TaskCreationInvocableMethod is followed.' required='true' )
        global String TaskCreationProcess;         
        
        @InvocableVariable(label='Task Record Type Name' description='Provide the Task Record Type Name.' required='true')
        global String TaskRecordTypeName; 
        
        @InvocableVariable(label='Opportunity ID' description='Provide the Opportunity ID if needed.' required='false')
        global ID OpportunityID;
        
        @InvocableVariable(label='Priority' description='Provide the Task Priority.' required='true')
        global String TaskPriority;
        
        @InvocableVariable(label='Status' description='Provide the Task Status.' required='true')
        global String TaskStatus;
        
        @InvocableVariable(label='Subject' description='Provide the Task Subject.' required='true')
        global String TaskSubject;
        
        @InvocableVariable(label='Follow Up Date' description='Provide the Task Follow-Up Date.' required='true')
        global Date TaskFollowUpDate;
        
        @InvocableVariable(label='Task Type' description='Provide the Type value' required='false')
        global String TaskType;
        
    }
}