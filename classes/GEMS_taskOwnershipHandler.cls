/**************************************************************************************
  Apex Class Name       : GEMS_taskOwnershipHandler
  Version               : 1.0
  Function              : This Class changes the task owner to User(Not Queue) when the owner of the Case is changed to a User
  Modification Log      :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------  
* Ranjit Gandhi               10/20/2017            SFDC-6890 GEMS - Underwriting case - Update Task Owner if Case Owner is Changed               
* Praveen                     06/22/2016             Original Version
*************************************************************************************/
public  class GEMS_taskOwnershipHandler
{
    // Changes the task owner to User(Not Queue) when the owner of the Case is changed
    public static void changeTaskOwnerOnCaseOwnerChange(List<Case> newCaseList, Map<Id,Case> oldCaseMap)
    {
        List<Case> ownerChangedCasesList = new List<Case>();
        Set<ID> ownerChangesCasesIdSet = new Set<ID>();
        Set<ID> ownerOldCaseSet = new Set<ID>();

        try
        {
            for(Case caseRecOld: oldCaseMap.values())
            {
                if(caseRecOld.OwnerId!=oldCaseMap.get(caseRecOld.id).OwnerId && !(string.valueOf(caseRecOld.OwnerID).startsWith('00G')))
                {
                    ownerOldCaseSet.add(caseRecOld.Id);
                }
            }
            
            
            for(Case caseRec: newCaseList)
            {
                if(caseRec.OwnerId!=oldCaseMap.get(caseRec.id).OwnerId && !(string.valueOf(caseRec.OwnerID).startsWith('00G')))
                {
                    ownerChangesCasesIdSet.add(caseRec.Id);
                }
            }
            if(!ownerChangesCasesIdSet.isEmpty())
            {
                //Ranjit Gandhi               10/20/2017            SFDC- GEMS 6890- Retreive recordtypeid,   Last_Assigned_Owner__c       
                ownerChangedCasesList = [SELECT ID, OwnerId,RecordTypeId, (SELECT ID, Subject, OwnerId,status,Last_Assigned_Owner__c,isclosed from Tasks) FROM Case WHERE ID IN: ownerChangesCasesIdSet];
                system.debug('ownerChangedCasesList'+ownerChangedCasesList);
            }
            List<Task> updateTaskList = new List<Task>();
            
            if(!ownerChangedCasesList.isEmpty())
            {
                        //Ranjit Gandhi               10/20/2017            SFDC- GEMS 6890- Get the 3 record types- On return tasks- retain last assigned owner on owner change
                        Id caseMedicalUnderwriting = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
                        Id caseDentalUnderwriting = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
                        Id caseAdditionalUnderwriting = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
                for(case ownerChangedCaseRec: ownerChangedCasesList)
                {
                    if(ownerChangedCaseRec.Tasks!=null && !(ownerChangedCaseRec.Tasks.isEmpty()))
                    {
                        for(Task taskRec: ownerChangedCaseRec.Tasks)
                        {
                            if(!string.valueOf(oldCaseMap.get(ownerChangedCaseRec.id).OwnerId).startsWith('00G'))
                           {    
                            //Ranjit Gandhi               10/20/2017            SFDC- GEMS 6890- Get the 3 record types- On return tasks- retain last assigned owner on owner change
                             if(ownerChangedCaseRec.RecordTypeId==caseMedicalUnderwriting || ownerChangedCaseRec.RecordTypeId==caseDentalUnderwriting || ownerChangedCaseRec.RecordTypeId==caseAdditionalUnderwriting)
                                {                                        
                                            
                                            //All other records- must have owner change
                                         if(taskRec.status != 'Return')
                                         {                                             
                                                 if(taskRec.isclosed==false){
                                                     system.debug('isclosed=d');
                                             taskRec.OwnerId=ownerChangedCaseRec.OwnerId;
                                                 updateTaskList.add(taskRec);}
                                             
                                         } 
                                         else
                                         {                                              
                                            //Ranjit Gandhi               10/20/2017            SFDC- GEMS 6890- On return tasks- retain last assigned owner on owner change
                                            taskRec.OwnerId=taskRec.Last_Assigned_Owner__c;
                                            updateTaskList.add(taskRec);
                                         }  
                                }
                                else
                                {                                       
                                         taskRec.OwnerId=ownerChangedCaseRec.OwnerId;
                                             updateTaskList.add(taskRec);
                                }
                            }
                            else
                            {
                                 taskRec.OwnerId=ownerChangedCaseRec.OwnerId;
                                     updateTaskList.add(taskRec);
                            }
                            
                    }
                }
            }
            System.debug('updateTaskList'+updateTaskList);
            if(!updateTaskList.isEmpty())
            {
                update updateTaskList;
            }
            }}
            Catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_taskOwnershipHandler.changeTaskOwnerOnCaseOwnerChange(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        }
        
    }
}