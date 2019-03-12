/**************************************************************************************
  Apex Trigger Name     : CompetitorRelationshipTrigger 
  Version               : 1.0
  Function              : This trigger on Competitor_Relationship__c object is used to perform various operations on trigger events on Competitor_Relationship__c . 
  Modification Log      :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  Nitin Paliwal       15/09/2015                Original Version
*/
trigger CompetitorRelationshipTrigger on Competitor_Relationship__c (before insert,before update,after insert,after update,after delete) {
    //------Start of Jira # 4115 ---------------------------        
 if(trigger.isBefore && trigger.isUpdate){   
        if(trigger.new[0].Group_Account__c !=trigger.old[0].Group_Account__c ){	//Account Id is changed
            System.debug('** Before update trigger fired ');
            CompetitorRelationshipTriggerHandler CRT = new CompetitorRelationshipTriggerHandler();
            CRT.onInsertorUpdate(trigger.new);            
        }//if(trigger.new[0].Group_Account__c !=trigger.old[0].Group_Account__c )     
    }//if(trigger.isBefore && trigger.isUpdate)
    //-----------------------------------------------------------
    if(trigger.isBefore && trigger.isInsert){   
        System.debug('** Before Insert trigger fired ');  
        CompetitorRelationshipTriggerHandler CRT = new CompetitorRelationshipTriggerHandler();
        CRT.onInsertorUpdate(trigger.new);
    }//if(trigger.isBefore && trigger.isUpdate) 
//------End of Jira # 4115 ---------------------------    
    if(Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.CompetitorRelationshipTriggerFIeld))){      
        if(trigger.isAfter){
            if(trigger.isinsert || trigger.isUpdate){
                CompetitorRelationshipTriggerHandler.updateSlicedAccountDetails(trigger.new,trigger.oldmap,trigger.old);
                CompetitorRelationshipTriggerHandler.updateAccountComplexityScoreForCompetitorRelationship(trigger.new);
            }
            if(trigger.isDelete) {
                CompetitorRelationshipTriggerHandler.updateSlicedAccountDetails(trigger.new,trigger.oldmap,trigger.old);
                CompetitorRelationshipTriggerHandler.updateAccountComplexityScoreForCompetitorRelationship(trigger.old);
            }
        }
    }
}