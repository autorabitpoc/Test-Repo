/***************************************************************************************************************************
	Apex Class Name		: GEMS_CaseTeamMembersController
	Function			: Extension controller for caseteam members add/remove/update
	Author				: Phani Kommareddy

*  Ver     Date(MM/DD/YYYY)  Name            	  Description
*  ---     ----------------  ---------------   	  ----------------------
*  1.1     05/22/2017        Phani Kommareddy  	  Original Version created for SFDC-1503 Prevent implementer change
*  1.2 	   06/02/2017		 Phani Kommareddy	  SFDC-3879 Updates on AS should update Pharmacy scode AS tasks uncompleted
*  1.3	   10/20/2017        Bharath			  SFDC-3743 Exclude 'Additional Medical Underwriter' from the list of roles in case team.
*  1.4 	   11/16/2017		 Shankar			  SFDC-4225 Do not allow for more than 1 medical or dental UW on the case team
*  1.5     04/22/2018		 Luke Chen			  SFDC-9342 GEMS: Prod Issue - 360 view showing a different open/closed date than actual cases
******************************************************************************************************************************/
public without sharing class GEMS_CaseTeamMembersController {
    public  String searchString {get; set;}
    public List<User> users {get; set;}
    public  Map<String,CaseTeamRole> caseTeamRoleMap{get; set;}
    private Map<String,Id> caseTeamRoleNameMap{get; set;}
    public ID caseID {set;get;}
    public String caseNumber{set;get;}
    public String roleName{set;get;}
    public String roleId{set;get;}
    public List<GEMS_IndexedCTM> indexedCTMList {get;set;}
    public Integer rowToRemove {get;set;}
    public Integer rowToUpdate {get;set;}
    private  List<CaseTeamMember> toDeleteList{set;get;}
    public String updatedMemberRole{get;set;}    
    public String updatedTeamMemberId{get;set;}
    public String updatedTeamMemberName{get;set;}
	// SFDC-4225. To hold UW role Id and dental UW role id
    public Id uwRoleId{get;set;}
    public Id dentalUWRoleId{get;set;}
    public Boolean saveBtnDisStatus{get;set;}
	// SFDC-4225. End
	public Double offset{get; set;}  // SFDC-9342
    
    public GEMS_CaseTeamMembersController(ApexPages.StandardController stdcontroller) {
        try {
            offset = GEMS_Utility.getLocalTimeZoneOffset(); // SFDC-9342
            getRoleOptions();
            saveBtnDisStatus = false;
            toDeleteList = new List<CaseTeamMember>();
            caseID = apexpages.currentpage().getparameters().get('id');
            List<CaseTeamMember> ctmList = [SELECT Id, ParentId,MemberId,TeamRoleId,Member.Name,TeamRole.Name from CaseTeamMember where parentId = :caseID order by LastModifiedDate desc];
            indexCTM(ctmList);
            Case[] cases = [SELECT caseNumber from Case where id = :caseID];
            caseNumber = cases[0].caseNumber;
        }
        catch(Exception ex) {
            System.debug('=====exception====='+ex);              
        }
    }

    
    //Get all the case team member roles and create a map of caseTeamRoles
    public List<SelectOption> getRoleOptions() {
        caseTeamRoleMap = new Map<String,CaseTeamRole>();
        caseTeamRoleNameMap = new Map<String, Id>();
        //SFDC-3743 Retreive the Inactive roles from the custom metadata 'GEMS Global Settings' with label as InActiveCaseTeamRole. 
        //Exclude these roles from the list displayed on the screen. 
        List<String> inactiveCaseTeamRoleList = new List<String>();
        for(GEMS_Global_Settings__mdt inactiveRole : [Select Value__c from GEMS_Global_Settings__mdt where MasterLabel = 'InActiveCaseTeamRole']){
            inactiveCaseTeamRoleList.add(inactiveRole.value__c);
        }
        List<CaseTeamRole> caseTeamRoleList = [SELECT Id, Name, AccessLevel FROM CaseTeamRole where Name NOT IN :inactiveCaseTeamRoleList];
        List<SelectOption> ctrSelectOptions = new List<SelectOption>();
        ctrSelectOptions.add(new SelectOption('Select One','Select One',true));
        CaseTeamRole ctrNew = new CaseTeamRole();
        ctrNew.Name = 'Select One';
        caseTeamRoleMap.put(null,ctrNew);
        for(CaseTeamRole ctr : caseTeamRoleList) {
            caseTeamRoleMap.put(ctr.id,ctr);
            caseTeamRoleNameMap.put(ctr.Name,ctr.Id);
            if(ctr.Name != 'Implementer')
               	ctrSelectOptions.add(new SelectOption(ctr.Name,ctr.Name,false));
            else
               	ctrSelectOptions.add(new SelectOption(ctr.Name,ctr.Name,true));
        	// SFDC-4225. Set UW role Id and dental UW role id
            if (ctr.Name == 'Underwriter') {
            	uwRoleId = ctr.Id;
            } else if (ctr.Name == 'Dental Underwriter') {
            	dentalUWRoleId = ctr.Id;
            }
           	// SFDC-4225. End
        }
        ctrSelectOptions.sort();
        return ctrSelectOptions;
    }

    //redirects to Update case team members
    public PageReference Redirect() {
        PageReference redirect =  new PageReference('/apex/GEMSUpdateCaseTeamMembers?id='+caseID); 
        redirect.setRedirect(true);
        return redirect;
    }
    
    
    //Cancel on update case team members, redirects to case
    public PageReference RedirectToCase() {
        toDeleteList.clear();
        PageReference redirect =  new PageReference('/'+caseID); 
        redirect.setRedirect(true);
        return redirect;
    }
    
    
    
    //Removes case team member from CaseTeamMember object
    public PageReference RemoveRole() {
        CaseTeamMember ctm = [SELECT Id,TeamRole.Name FROM CaseTeamMember WHERE Id = :roleId];
        Delete ctm;
        System.debug(ctm.TeamRole.Name +' >>>Deleted successsfully');       
        return null;
    }
    

    
    
    //Search for lookup
    public PageReference searchUsers()  {
        users = new List<User>();
        if(String.isNotBlank(searchString) && searchString.trim().length()>1) {
            String soql = 'select id,name from user where isactive = true and name LIKE \'%' + searchString +'%\' LIMIT 20 ';
            List<User> searchResults = database.query(soql); 
            users = searchResults;
            return null;
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter alteast 2 characters');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    
  
    //team member update
    public PageReference updateMemberNameId() {
        GEMS_IndexedCTM indexCTM = indexedCTMList.get(rowToUpdate);
        CaseTeamMember ctm = indexCTM.record;
        Id oldMemberId = ctm.MemberId;
        CaseTeamMember ctmUpdateNew = new CaseTeamMember(MemberId=updatedTeamMemberId,ParentId=ctm.ParentId,TeamRoleId=ctm.TeamRoleId);
        if(ctm.id != null) {
            toDeleteList.add(ctm);
        }
        GEMS_CaseTeamMembersHelper.removeRowFromCaseTeamList(rowToUpdate, indexedCTMList);
        GEMS_IndexedCTM iCTM = new GEMS_IndexedCTM();
        iCTM.index = rowToUpdate;
        iCTM.record = ctmUpdateNew;
        iCTM.teamMemberName = updatedTeamMemberName;
        CaseTeamRole ctrole = caseTeamRoleMap.get(ctm.TeamRoleId);
        iCTM.teamMemberRole = ctrole.Name;
        iCTM.isChanged = true;
        indexedCTMList.add(iCTM);
        indexedCTMList.sort();
        return null;
    }
    
    
    public PageReference updateMemberRole() {
        saveBtnDisStatus = true;
    	GEMS_IndexedCTM indexCTM = indexedCTMList.get(rowToUpdate);
        indexCTM.isChanged = true;
        CaseTeamMember ctm = indexCTM.record;
        Id newId = caseTeamRoleNameMap.get(updatedMemberRole);
        ctm.TeamRoleId = newId;
        indexCTM.teamMemberRole = updatedMemberRole;
        return null;
    }  
    
    //create and index of CaseTeamMembers
    private void indexCTM(List<CaseTeamMember> ctmList) {
        Integer i = 0;
        indexedCTMList = new List<GEMS_IndexedCTM>();
        for(CaseTeamMember caseTeamMember : ctmList) {
            GEMS_IndexedCTM indexCTM = new GEMS_IndexedCTM();
            indexCTM.index = i;
            indexCTM.record = caseTeamMember;
            indexCTM.teamMemberName = caseTeamMember.Member.Name;
            indexCTM.teamMemberRole = caseTeamMember.TeamRole.Name;
           	indexCTM.isChanged = false;
            indexedCTMList.add(indexCTM);            
            i++;
        }
    }
    
    
    //remove row from caseteam
    public void removeRowFromCaseTeamList(){
        GEMS_IndexedCTM indexCTM = indexedCTMList.get(rowToRemove);
        CaseTeamMember ctm = indexCTM.record;
        Id ctmId = ctm.Id;
        if(ctmId != null) { 
            toDeleteList.add(ctm);
        }
        indexedCTMList = GEMS_CaseTeamMembersHelper.removeRowFromCaseTeamList(rowToRemove, indexedCTMList);        
    }
    
    
    public void addNewRowToCaseTeamList(){
        indexedCTMList = GEMS_CaseTeamMembersHelper.addNewRowToCaseTeamList(indexedCTMList ,caseID);
    }
    
    
    public PageReference saveCaseTeamList() {
    	// SFDC-4225. Changed signature to include UW role Id and dental UW role id
        String validationResult = GEMS_CaseTeamMembersHelper.saveCaseTeamList(indexedCTMList ,toDeleteList,caseID, uwRoleId, dentalUWRoleId);
    	// SFDC-4225. End
        return null;
    }
    
    public List<GEMS_IndexedCTM> getIndexedCTM() {
        return indexedCTMList;
    }
    
    public void setIndexedCTM(List<GEMS_IndexedCTM> indCTM) {
    	indexedCTMList = indCTM;
    }
    
}