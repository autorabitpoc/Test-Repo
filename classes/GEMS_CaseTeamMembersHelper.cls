/***************************************************************************************************************************
Class: GEMS_CaseTeamMembersHelper
Purpose: Helper class for making database operations

*  Ver     Date(MM/DD/YYYY)  Name            	  Description
*  ---     ----------------  ---------------   	  ----------------------
*  1.1     05/22/2017        Phani Kommareddy  	  SFDC-1503 Prevent implementer change
*  1.2 	   06/02/2017		 Phani Kommareddy	  SFDC-3879 Updates on AS should update Pharmacy scode AS tasks uncompleted
*  1.3 	   11/16/2017		 Shankar			  SFDC-4225 Do not allow for more than 1 medical or dental UW on the case team		

******************************************************************************************************************************/

public  class GEMS_CaseTeamMembersHelper {
    
    public static List<GEMS_IndexedCTM> removeRowFromCaseTeamList(Integer index, List<GEMS_IndexedCTM> indexedCTMList) {
        indexedCTMList.remove(index);
        return indexedCTMList;
    }
 
    //Adding row 
    public static List<GEMS_IndexedCTM> addNewRowToCaseTeamList(List<GEMS_IndexedCTM> indexedCTMList,Id parentId) {
        GEMS_IndexedCTM newiCTM = new GEMS_IndexedCTM();
        newiCTM.index = indexedCTMList.size();
        CaseTeamMember ctm = new CaseTeamMember(ParentId=parentId);
        newiCTM.record = ctm;
        newiCTM.isChanged = true;
        indexedCTMList.add(newiCTM);        
        return indexedCTMList;
    }
    
    
    //Save functionality to persist data to objects
    public static String saveCaseTeamList(List<GEMS_IndexedCTM> indexedCTMList,List<CaseTeamMember> toDeleteList, Id parentid, Id uwRoleId, Id dentalUWRoleId) {
        System.debug('toDeleteList '+toDeleteList);
        String returnString = '';
        Set<Id> teamMemberSet = new Set<Id>();
        List<sobject> result = new List<sobject>();
        Integer recordsToUpsert = 0;
        System.debug('indexedCTMList '+indexedCTMList);
        // SFDC-4225. Flags for UW and dental UW CTMs' existence 
        Boolean medUWFlag = false;
        Boolean dentUWFlag = false;
        // SFDC-4225. End

        for(GEMS_IndexedCTM iCTM : indexedCTMList) {
            System.debug('iCTM '+iCTM);
            if(iCTM.isChanged) {
                recordsToUpsert++;
            }
            CaseTeamMember ctm = iCTM.record;

            if(ctm.MemberId == null || ctm.TeamRoleId == null) {
                returnString = 'Select Team Member and appropriate Member Role';       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, returnString));
                return returnString;
            }
            if (!teamMemberSet.add(ctm.MemberId)) {
                returnString = 'Team member cannot be assigned multiple roles';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, returnString));
                return returnString;
            }
            // SFDC-4225. Check if UW or Dental UW are already present in the save list. If so, error out before proceeding with another UW or Dental UW            
            if (medUWFlag && ctm.TeamRoleId == uwRoleId) {
            	returnString = System.Label.GEMS_Duplicate_UW_Error_Message;       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, returnString));
                return returnString;
            } else if (dentUWFlag && ctm.TeamRoleId == dentalUWRoleId) {
            	returnString = System.Label.GEMS_Duplicate_UW_Error_Message;       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, returnString));
                return returnString;
            }
            
            // SFDC-4225. Set UWFlag or dentUWFlag if an UW CTM record is encountered 
            if (iCTM.teamMemberRole == 'Underwriter') {
            	medUWFlag = true;
            } else if (iCTM.teamMemberRole == 'Dental Underwriter') {
            	dentUWFlag = true;
            }
            // SFDC-4225 End.
        }
        
        if(recordsToUpsert == 0 && toDeleteList.isEmpty()){
            returnString = 'Case Team updated successfully';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, returnString));
            return returnString;
        }
            
        

              
        //persist the remaining inserts and updates
        System.debug('Before update/insert, indexedCTMList::'+indexedCTMList);
        List<CaseTeamMember> ctmList = [SELECT Id, ParentId,MemberId,TeamRoleId,Member.Name,TeamRole.Name from CaseTeamMember where parentId = '5002F000001HCFTQA4' order by LastModifiedDate desc];
        System.debug('Before update/insert, caseTeamMember::'+ ctmList);
        for(GEMS_IndexedCTM iCTM : indexedCTMList){
            CaseTeamMember ctm  = iCTM.record;
            if(iCTM.isChanged) {
                if(ctm.Id != null) {
                	//team role changes come here 
                    update ctm;                    
                } else {
                    //any update or insert on the caseteammember name is an insert, a CaseTeamMember Object restriction
                	insert ctm;
                    //Change Pharmacy Scope code Account Specialist tasks owner to the new changed one
                    if(ictm.teamMemberRole == 'Account Specialist') {
                        List<Task> allTasksToChange = [Select id, ownerId from task where whatid in (select id FROM GEMS_Pharmacy_Scope_Code__c where case__r.GEMS_Account_Submission_Info__c = :parentId) AND GEMS_Type__C = 'Pharmacy Scope Code Account Specialist' and status != 'Completed'];
						List<Task> tasksToUpdate = new List<Task>();
                        for(Task taskToChange : allTasksToChange) {
                            if(taskToChange.ownerId != ctm.MemberId) { 
                                taskToChange.ownerId = ctm.MemberId;
                            	tasksToUpdate.add(taskToChange);
                            }
                        }
                        try {
                        	update tasksToUpdate;
                        } catch(Exception e) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getStackTraceString()));
                        }
                        
                    }
                }
            }
        }
        
        
        //delete the removes
        if(!toDeleteList.isEmpty()) {
			delete toDeleteList;           
        }
                
        System.debug('<<<< SAVING COMPLETE....saveCaseTeamList >>>>');
        returnString = 'Case Team updated successfully';
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, returnString));
        toDeleteList.clear();
        clearChangeStatus(indexedCTMList);
        return returnString;
    }    
    
    public static void clearChangeStatus(List<GEMS_IndexedCTM> indexedCTMList) {
  		for(GEMS_IndexedCTM iCTM : indexedCTMList) {
            iCTM.isChanged = false;
        }
    }
}