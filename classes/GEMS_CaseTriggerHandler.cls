/**************************************************************************************
  Apex Class Name     : GEMS_CaseTriggerHandler 
  Version             : 1.0
  Function            : This is a handler class for CaseTrigger(For GEMS Project).
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            03/29/2016             Original Version
* Ranjit Gandhi       6/1/2017               SFDC-3096:GEMS Account Submission - When the opportunity is marked as 'Won' and the product information is coming over from CRM to GEMS, it is pulling both sold and lost products. System should only pull sold products into GEMS.
* Malathi.K           04/21/2017             SFDC-2627. Manual Eligibility Case creation criteria added.
* Phani.K             05/01/2017             SFDC-4582. Fix SLA Counter for all cases when they are closed.
* Malathi.K           04/21/2017             SFDC-4449. Missing All Screenings Completed Date/Time or flag.
* Luke Chen           06/09/2017             SFDC-3376 Dental Benefit Coding case change
* Malathi.K           06/16/2017             SFDC-216 Add GEMS_Is_Eligibility_Required field to Membership case.
* Lakshmi             06/20/2017             SFDC-3820 Automatically Cancel all downstream cases when an account submission case is cancelled
* Rajeesha            07/03/2017             SFDC-3432 GEMS - Screening Cases - Lock the Status Field on the parent case
* Luke Chen           06/28/2017             SFDC-4719 GEMS - Cosmetic Account Set Up Maintenance case owner should be in-sync with GEMS Cosmetic Account Maintenance Set Up case submitter.
* Rajeesha            07/11/2017             SFDC-5095 GEMS- Cosmetic Account Maintenance: Cancellation
* Bharath             07/11/2017             SFDC-5097 GEMS - Auto-assign Account members for Cosmetic Account Maintenance record type.
* Bharath             07/13/2017             SFDC-4995 Add default assignees for Account Setup cases.
* Gokul               07/17/2017             SFDC-5099 GEMS - Cosmetic Account Maintenance workflow: Account Setup Process: Return and assign back to business
* Malathi.K           07/21/2017             SFDC-5208 GEMS - Account Structure Maintenance: Create Account Structure case.
* Rajeesha            07/24/2017             SFDC-5140 GEMS - Automatically cancel tasks when associated case is cancelled
* Rajeesha            07/27/2017             SFDC-4285 Medical Coding Case - Add Key Dates section and date field
* Bharath             07/27/2017             SFDC-5102 Populate BA level details to Case.
* Luke Chen           07/29/2017             SFDC-5335 Account Structure Maintenance - Account Setup Process case
* Sree Harsha         07/30/2017             SFDC-5248 AND SFDC-5249 Account Structure Maintenance - Medical and Dental Underwriting Case
* Malathi.K           07/30/2017             SFDC-5247 Create Eligibility Process case for Account Structure Maintenance.
* Phani               08/01/2017             Optimized SFDC-5248 AND SFDC-5249 Account Structure Maintenance - Medical and Dental Underwriting Case
* Luke Chen           08/03/2017             SFDC-5246 Account Structure Maintenance - Account Structure case: Page Layout & Functionality
* Lakshmi             08/16/2017             SFDC-5589 Account Eligibility Maintenance - Membership Case
* Sree Harsha         08/16/2017             SFDC-2898 GEMS - When owner is changed on parent case then all BA-level child cases should systematically change to same owner
* Lakshmi             08/29/2017             SFDC-5762 GEMS - Rate Change Maintenance - Medical Underwriting:Page layout and functionality
* Phani               08/30/2017             SFDC-5760 Rate Change Maintenance - Account Setup Process: page layout and functionality
* Sree Harsha         08/31/2017             SFDC-5842 GEMS AEP File Maintenance Eligibility Process Page Layout and Functionality
* Phani K             09/04/2017             SFDC-5927 and SFDC-5333 Notifications for commissions and porbob fields
* Shankar             09/08/2017             SFDC-5815 Create Dental screening cases for BA's without Product but with Dental product category in Plan
* Rajeesha            09/14/2017             SFDC-5928 GEMS-MBC Update BA Level Status Field - based on MBC Testing Object Statuses
* Bharath             09/14/2017             SFDC-5930 Method introduced to update case owner email address of testing records whenever the owner of BA level medical benefit coding changes.
* Hari                09/25/2017             SFDC-4627 GEMS: if the effective date is changed on submission case, it will change on all downstream cases.
* Bharath             09/22/2017             SFDC-6121 Population of Case Team members from Account team update to include active users only. The roles to be copied are updated. 
* Rajeesha            10/11/2017             SFDC-5725 GEMS Dental Benefit Coding Cases should NOT be created without screening (Non-Standard Products)
* Hari                10/11/2017             SFDC-6116 GEMS: CIC on an the Account Team is Recognized as the Submitter
* Phani K             10/16/2017             SFDC-6381 GEMS: Upon cancellation of Case, notifications are sent to Case Owners and Case Team
* Gokul               10/26/2017             SFDC-3817 GEMS - Underwriting case - Update Task Layout
* Shankar             10/26/2017             SFDC-6830. Fix an existing bug: Assign active entitlement id during DBC creation
* Shankar             11/07/2017             SFDC-7098. Removed functionality to change MBC status to 'Medical Benefit Production Ready' when all test records pass
* Vijay               11/14/2017             SFDC-6960 GEMS: DB Coding - Route DB Coding Cases to the DB Coding Screener, not the Queue
* Bharath             11/17/2017             SFDC-4729 Refactored childCaseStatusTOCancelled method to avoid recursive SOQL runs. 
* Bharath             11/21/2017             SFDC-7246 Update the BA level medical benefit coding as Testing Passed when all the testing records are marked as Passed.
* Phani K             11/27/2017             SFDC-6370 GEMS - ID Card Maintenance: Account Setup Maintenance Page Layout & Functionality
* Sree Harsha         11/27/2017             SFDC-7526 GEMS - Display Membership Case Fields on ID Card Case
* Gokul Bharati       02/12/2018             SFDC-6946 GEMS - GEMS: Acct Sub - Automatically mark Account Submission Case as "Completed" when Downstream cases complete
* Gokul Bharati       02/20/2018             SFDC-4244 GEMS - Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
* Jenny Dalsania      03/06/2018             SFDC-7917 GEMS - Rename FSU through out GEMS Emails and Roles
* Gokul Bharati       03/12/2018             SFDC-8034 Complete Off-Cycle submission cases as "Completed" instead of "Completed - Without Signed BPA"
* Luke Chen           03/21/2018             SFDC-7742 GEMS - Account Maintenance workflow - Complete Maintenance Case when Underlying Cases are Closed w/ Workflow and Notification
* Gokul Bharati       03/21/2018             SFDC-7735 GEMs Account Maintenance - Apex Error upon Save
* Gokul Bharati       03/26/2018             SFDC-7734 GEMs Account Maintenance - Incorrect Case Subject
* Jenny Dalsania      04/16/2018             SFDC-7263 GEMS: MBC - "No GCPS action required" should stop the SLA Counter
* Malathi.K           05/18/2018             SFDC-8279 Create DBC cases when MUW or DUW are Routed In Error.  
* Malathi.K           05/18/2018             SFDC-7850 Update parent MBC status to In Progress when new child level BA MBC case is added.
* Malathi.K           05/14/2018             SFDC-8197 GEMS - ID Card Maintenance: Trigger Account Setup Maintenance Case at the same time as ID Card Maintenance Case
* Phani Kommareddy    05/15/2018             SFDC-9463 GEMS - GEMS: BlueSTAR - Member Counts at BA Level (GEMS UI Updates)
* Gokul Bharati       05/17/2018             SFDC-9232 GEMS - Moved  all Trigger After Update Email Notification methods to GEMS_EmailNotification class for future callout 
* Malathi.K           05/29/2018             SFDC- 9360 gems - Update UW Approve Flag field on all cases.
* Gokul Bharati       05/30/2018             SFDC-4112 GEMS: Dental Only Cases should not Create Medical Underwriting Cases
*************************************************************************************/

public  class GEMS_CaseTriggerHandler {
  
    public static Boolean recursiveCheck = true;
    public static Boolean recursiveCheck2 = true;
    public static Boolean updateParentStatus = false;
    public static Boolean restrictExecution = false;
    public static Boolean returnUnderWriterNotification = false;
    public static Boolean updBAChldCaseOwnRecurChk = true;
    public static Boolean upBArecurchk = true;
    public static Boolean reccheck = false;
    public static Boolean autoSubclose = true;
    
    /******************************************************************** 
    *    Method Name : OnBeforeInsert
    *   @description :   This method is to update submission case data after opportunity Won.
    *   @parameters  :   List<case> newCaseList
    *   @return type :   void
    *   @Author : Siva
    ***************************************************************/
    public static void OnBeforeInsert(List<case> newCaseList) {
        List<Id> optyids = new List<Id>();
        List<Id> accountIds = new List<Id>();
        map<id,case> idCaseMap = new map<id,case>();
        Map<Id, AccountTeamMember> accountIdTeamMeberMap = new Map<Id, AccountTeamMember>();
        Map<Id, Map<String,String>> accountIdTeamMebersMap = new Map<Id, Map<String,String>>();
        Map<Id,Account> accountsMap = new Map<Id,Account>(); 
        list<Case> accSubCaseIdList = new List<Case>();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
       try {
        //Group groupId =[select Id from Group where Name = 'GEMS_ACCOUNT IMPLEMENTATION TEAM' and Type = 'Queue' limit 1];
        for(case caseRecord : newCaseList){
        if(caseAccountSubmissionId == caseRecord.recordTypeId )
            idCaseMap.put(caseRecord.Opportunity_Name__c,caseRecord);
            accSubCaseIdList.add(caseRecord);

        }
        if(!accSubCaseIdList.isEmpty()) {
        for(case caseRecord : newCaseList){
            if(caseRecord.AccountId != null) {
                accountIds.add(caseRecord.AccountId);
            }
        }
        if(accountIds != null && Trigger.isInsert ) {
            accountsMap = new Map<Id,Account>([select id,name,ownerId from Account where id in : accountIds]);
            List<AccountTeamMember> accountTeamMembers = [Select UserId, TeamMemberRole, Id, AccountId,account.Open_Enrollment_Date__c,account.Open_Enrollment_End_Date__c From AccountTeamMember where accountid in : accountIds];        
            
            if(accountTeamMembers != null && !accountTeamMembers.isEmpty()) {
                for(AccountTeamMember account_team_Member: accountTeamMembers) {
                    if(accountIdTeamMebersMap.containsKey(account_team_Member.AccountId)) {
                        accountIdTeamMebersMap.get(account_team_Member.AccountId).put(account_team_Member.TeamMemberRole,account_team_Member.UserId);
                    }else {
                        Map<String,String> teamMembersMap = new Map<String,String>();
                        teamMembersMap.put(account_team_Member.TeamMemberRole,account_team_Member.UserId);
                        accountIdTeamMebersMap.put(account_team_Member.AccountId,teamMembersMap);
                    }
                    
                    accountIdTeamMeberMap.put(account_team_Member.AccountId,account_team_Member);                  
                }
            }
        }

        
        Map<id,String> optyMap = new Map<id,String>();
        List<Opportunity_Product__c> oli =[select id,Opportunity_Name__c,Product_Category__c from Opportunity_Product__c where Opportunity_Name__c =:idCaseMap.keySet() and status__c='won'];
        System.debug('++oli+++'+oli);
        Map<Id,Set<String>> dupCheckMap = new Map<Id,Set<String>>();
        for(Opportunity_Product__c oliRecord : oli) {
            String productname = oliRecord.Product_Category__c;            
            System.debug('+++productname ++'+productname);
            if(productname == 'Pharmacy' || productname == 'EPO') {
                productname = 'RX';
            }
            if (!optyMap.containsKey(oliRecord.Opportunity_Name__c)) {
                System.debug('+++++++productname ++++++++'+productname );                
                optyMap.put(oliRecord.Opportunity_Name__c, productname );
                dupCheckMap.put(oliRecord.Opportunity_Name__c, new Set<String>{productname});                
            }
            if (optymap.containsKey(oliRecord.Opportunity_Name__c)) { 
                Set<String> dupCheckSet = dupCheckMap.get(oliRecord.Opportunity_Name__c);
                if (!dupCheckSet.contains(productname)) {
                    String str =optymap.get(oliRecord.Opportunity_Name__c) +';'+productname ;
                    System.debug('+++str++'+str);
                    optyMap.put(oliRecord.Opportunity_Name__c,str);
                    dupCheckMap.get(oliRecord.Opportunity_Name__c).add(productname);          
                }               
            }
        }
            String splitproduct;
            for(case updateCase : newCaseList){
                if (Trigger.isInsert && updateCase.GEMS_Products__c != null ) {                                 
                    if(optymap.get(updateCase.Opportunity_Name__c) != null)
                    splitproduct = optymap.get(updateCase.Opportunity_Name__c)+';'+updateCase.GEMS_Products__c;
                    else 
                    splitproduct = updateCase.GEMS_Products__c;
                    String[] productarray = splitproduct.split(';');
                    Set<String> stringset = new Set<String>();
                    for(String str:productarray ) {
                    stringset.add(str);
                    }
                    String productstr;
                    for(String str : stringset ){
                       if(productstr == null) productstr = str;
                       else productstr = productstr +';'+str;
                    }
                    updateCase.GEMS_Products__c =productstr ;// optymap.get(updateCase.Opportunity_Name__c)+';'+updateCase.GEMS_Products__c;

                }
                else if(Trigger.isInsert){
                    updateCase.GEMS_Products__c = optymap.get(updateCase.Opportunity_Name__c);
                    if(updateCase.AccountId != null && accountIdTeamMebersMap.get(updateCase.AccountId) != null ) {

                         if(accountIdTeamMebersMap.get(updateCase.AccountId).get('Underwriter')!= null) {
                                updateCase.Underwriter_Lookup__c = accountIdTeamMebersMap.get(updateCase.AccountId).get('Underwriter');
                         }
                        
                    }
                    if(updateCase.AccountId != null && accountIdTeamMeberMap.get(updateCase.AccountId) != null) {                        
                        updateCase.GEMS_Open_Enrollment_Start__c = accountIdTeamMeberMap.get(updateCase.AccountId).Account.Open_Enrollment_Date__c;                        
                        updateCase.GEMS_Open_Enrollment_End__c = accountIdTeamMeberMap.get(updateCase.AccountId).Account.Open_Enrollment_End_Date__c;                        
                    }
                }
            }
            }
         }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.OnBeforeInsert(List<case> newCaseList)','High');              
        }
        //update newCaseList;
    }
    
    
    /**
    *This method is to create copy account team members to case team members of given below roles
    *Account Specialist
    *Benefit Coder
    *Accounts Receivable
    *Electronic Eligibility Specialist
    *Implementation Manager
    *Membership Specialist
    *Medical Director
    *
    **/
    public static void createCaseTeamMembers(List<Case> newCaseList) {
        //Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        //Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        set<Id> autoAssignRecordType = new set<Id>();
        // Please add any Case record type to set autoAssignRecordType when the Account members are required to be assigned to Case members
        autoAssignRecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId());
        autoAssignRecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId());
        List<Id> accountIds = new List<Id>();
        List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
        Map<String,List<AccountTeamMember>> accountTeamsWithAccountIds = new Map<String,List<AccountTeamMember>>();
        list<Case> accSubCaseIdList = new List<Case>();
        try {
        for(case caseRecord : newCaseList){
            /*if(caseAccountSubmissionId == caseRecord.recordTypeId && caseRecord.AccountId != null && caseRecord.recordTypeId != caseAccountStructureRecordTypeId 
            && caseRecord.recordTypeId != caseBAScreeningCaseRecordTypeId ) { */
            if(caseRecord.AccountId != null && autoAssignRecordType.contains(caseRecord.recordTypeId)) {  
                accountIds.add(caseRecord.AccountId);
                accSubCaseIdList.add(caseRecord);
                
            }
        }
        if(!accSubCaseIdList.isEmpty()) {
        if(accountIds != null) {
             accountTeamMembers = [Select UserId, User.IsActive, TeamMemberRole, Id, AccountId,Account.ownerId,account.Open_Enrollment_Date__c,account.Open_Enrollment_End_Date__c From AccountTeamMember where accountid in : accountIds];        
        }
        if(!accountTeamMembers.isEmpty()) {
            for(AccountTeamMember accTeamMember : accountTeamMembers) {
                if(accountTeamsWithAccountIds.containskey(accTeamMember.AccountId)) {
                    accountTeamsWithAccountIds.get(accTeamMember.AccountId).add(accTeamMember);
                }else {
                    List<AccountTeamMember> accountTeamMembersList = new List<AccountTeamMember>();
                    accountTeamMembersList.add(accTeamMember);
                    accountTeamsWithAccountIds.put(accTeamMember.AccountId,accountTeamMembersList);
                }
            }
            
            List<CaseTeamRole> caseTeamRoles = [select id,name from caseteamrole];
            Map<String,String> caseTeamRoleMap = new Map<String,String>();
            if(caseTeamRoles != null && !caseTeamRoles.isEmpty()) {
                for(CaseTeamRole caseTeamRole_exist : caseTeamRoles ) {
                    caseTeamRoleMap.put(caseTeamRole_exist.name,caseTeamRole_exist.id);
                }
            }
            List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
            for(case caseRecord : newCaseList) {
                if(caseRecord.AccountId != null) {
                   List<AccountTeamMember> accountTeamMembersList = accountTeamsWithAccountIds.get(caseRecord.AccountId);
                   for(AccountTeamMember accTeamMember : accountTeamMembersList) {
                       //6121 - Proceed with processing only when the account team member is active. 
                       if(accTeamMember.User.IsActive){
                       if(accTeamMember.TeamMemberRole == 'Account Specialist') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Account Specialist');
                           teamMember_new.parentId = caseRecord.Id;                           
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Benefit Coder') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Benefit Coder');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Accounts Receivable') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Accounts Receivable');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Electronic Eligibility Specialist') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Electronic Eligibility Specialist');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       
                       
                       if(accTeamMember.TeamMemberRole == 'Strategic Account Executive') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Strategic Account Executive');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                        if(accTeamMember.TeamMemberRole == 'Account Executive') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Account Executive');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Client Service Specialist') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Client Service Specialist');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Client Service Specialist.') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Client Service Specialist');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Client Implementation Consultant') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Client Implementation Consultant');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Marketing Service Rep') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Marketing Service Rep');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Implementation Manager') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Implementation Manager');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Membership Specialist') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Membership Specialist');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'AEP Processor') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('AEP Processor');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }                           
                       /*6121 - Removing the usage of Sales Executive, Director Account Management and VP Account Management. 
                       if(accTeamMember.TeamMemberRole == 'Sales Executive') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Sales Executive');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'Director Account Management') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Director Account Management');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       if(accTeamMember.TeamMemberRole == 'VP Account Management') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('VP Account Management');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }*/
                       if(accTeamMember.TeamMemberRole == 'Underwriter') {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.userId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Underwriter');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }
                       /*if(accTeamMember.Account.ownerId != null) {
                           CaseTeamMember teamMember_new = new CaseTeamMember();
                           teamMember_new.memberId = accTeamMember.Account.ownerId;
                           teamMember_new.teamRoleId = caseTeamRoleMap.get('Account Executive');
                           teamMember_new.parentId = caseRecord.Id;
                           caseTeamMembers.add(teamMember_new);
                       }*/
                       }
                   }
                }
            }
            
            if(!caseTeamMembers.isEmpty()) {
                Database.insert(caseTeamMembers,false);
            }
         
        }
        }
      } catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createCaseTeamMembers(List<Case> newCaseList)','High');              
        }        
    }
    
    /******************************************************************** 
    *    Method Name : createAccountStructureCase
    *   @description :   This method is to create account structure case after submitting submission case.
    *   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Balaram
    ***************************************************************/
    public static void createAccountStructureCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        Id caseAccountStructeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        /* SFDC-5208 Malathi.K Create Account structure for Account Maintenance*/
        Id caseAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        List<String> caseIds = new List<String>();
        List<String> accountIds = new List<String>();
        List<Case> new_cases_list = new List<Case>();
        try {
           for(Case case_new : newCaseList) {
                if((case_new.recordTypeId == caseAccountSubmissionId || case_new.recordTypeId == caseAccountMaintenanceId)  && case_new.GEMS_Create_Account_Structure__c ) {
                    caseIds.add(case_new.Id);
                    if(case_new.accountId != null) {
                        accountIds.add(case_new.accountId);
                    }
                }
            }
            List<case> structureCaseList =[select id from case where gems_account_submission_info__c=:caseIds and recordtypeid=:caseAccountStructeId];
            if(structureCaseList.isEmpty()) {
                Map<Id,Account> accountsMap = new Map<Id,Account>([select id, name, Reserved_Group_Number__c from Account where Id in : accountIds ]);
                List<caseteammember> caseTeamMembers = [select id,parentId,memberid from caseteammember where TeamRoleId in (select id from caseteamrole where name='Account Specialist') and parentId in : caseIds ];
                Map<Id,CaseTeamMember> caseIdSpecialistTeamMember = new Map<Id,CaseTeamMember>();
                for(caseteammember teamMember: caseTeamMembers) {
                    caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember);
                }
                /* SFDC-5208 Malathi.K Create Account structure for Account Maintenance*/  
                for(Case case_new : newCaseList) {
                   if(case_new.GEMS_Create_Account_Structure__c && case_new.status != oldCaseMap.get(case_new.Id).status && (case_new.recordTypeId == caseAccountSubmissionId || case_new.recordTypeId == caseAccountMaintenanceId) && case_new.status == 'In Progress' && (case_new.GEMS_Submission_Type__c == 'Account Structure Maintenance' || case_new.GEMS_Submission_Type__c == 'New Account' || 
                   ((case_new.GEMS_Submission_Type__c == 'Renewal' || case_new.GEMS_Submission_Type__c == 'Off Cycle')
                    && (case_new.GEMS_Submission_Sub_Type__c.contains('Account Structure Change') || case_new.GEMS_Submission_Sub_Type__c.contains( 'No Changes') || case_new.GEMS_Submission_Sub_Type__c.contains( 'Funding Change') || 
                    case_new.GEMS_Submission_Sub_Type__c.contains('Benefit Change') || case_new.GEMS_Submission_Sub_Type__c.contains( 'Eligibility Change')) ) )) {
                    case newCase = new case();
                        if(caseIdSpecialistTeamMember.containsKey(case_new.Id)) {                
                            newCase.GEMS_Account_Submission_Info__c= case_new.id;
                            newCase.parentid = case_new.id;
                            newCase.Accountid = case_new.Accountid;
                            /* SFDC-5208 Malathi.K*/
                            if (case_new.recordTypeId == caseAccountMaintenanceId) {
                              newCase.GEMS_Effective_Date__c = case_new.GEMS_Case_Effective_Date__c;
                              }
                            else { 
                             newCase.GEMS_Effective_Date__c = case_new.GEMS_Effective_Date__c;
                             }
                            newcase.GEMS_Submission_Type__c = case_new.GEMS_Submission_Type__c;
                            newCase.GEMS_Submission_Sub_Type__c = case_new.GEMS_Submission_Sub_Type__c;
                            newCase.GEMS_All_required_documents_attached__c = case_new.GEMS_All_required_documents_attached__c;
                            if(caseIdSpecialistTeamMember.containsKey(case_new.Id) ) {
                               newCase.ownerId = caseIdSpecialistTeamMember.get(case_new.Id).memberid;
                            }
                            //SFDC-5208 Malathi.K Populate Eff. Dt with Case Eff. Dt. for Acct. Maint. since Eff. Dt is not
                            // required or populated for Acct. maint.
                            DateTime effectiveDate;
                            if (case_new.recordTypeId == caseAccountMaintenanceId) {
                               effectiveDate = case_new.GEMS_Case_Effective_Date__c; 
                              }
                            else {   
                              effectiveDate = case_new.GEMS_Effective_Date__c;
                              }
                            //DateTime effectiveDate = case_new.GEMS_Effective_Date__c;                 
                            //newCase.Subject = case_new.Account_Name__c+' '+ case_new.Account_Number__c +' - Account Structure - '+effectiveDate.format('M/d/yyyy');
                            newCase.Subject = case_new.Account_Name__c+' '+ case_new.Account_Number__c +' '+effectiveDate.format('M/d/yyyy')+' Account Structure';
                            newCase.status = 'Design In Progress';
                            newCase.parentid = case_new.id;
                            newCase.type = 'Account Structure';
                            newCase.GEMS_Products__c = case_new.GEMS_Products__c;
                            newCase.HCSC_Division__c = case_new.HCSC_Division__c;
                            newCase.GEMS_Line_of_Business__c = case_new.GEMS_Line_of_Business__c;
                            newCase.FSU_Location__c = case_new.FSU_Location__c;
                            newCase.Opportunity_Name__c = case_new.Opportunity_Name__c ;
                            if(accountsMap != null && case_new.accountId != null && accountsMap.get(case_new.accountId) != null) {
                                newCase.GEMS_Reserved_Group_Numbers__c = accountsMap.get(case_new.accountId).Reserved_Group_Number__c;
                            }
                            newCase.Underwriter_Lookup__c = case_new.Underwriter_Lookup__c;
                            newCase.GEMS_AEP_Account__c = case_new.GEMS_AEP_Account__c;
                            newCase.recordTypeId = caseAccountStructeId;
                            newCase.Productid=case_new.Productid;
                            newCase.GEMS_Case_Effective_Date__c = case_new.GEMS_Case_Effective_Date__c; 
                            //This line added for October release to populate submitter field on account structure.
                            newcase.GEMS_Submitter__c = case_new.ownerId;    
                            newCase.Funding_Type_Multiselect__c = case_new.Funding_Type_Multiselect__c;                
                            newCase.GEMS_StdCust_Product__c = case_new.GEMS_StdCust_Product__c; 
                            newCase.GEMS_Rx_Vendor__c = case_new.GEMS_Rx_Vendor__c;   
                                           
                            new_cases_list.add(newCase);  
                        }                        
                    }
                }
                if(!new_cases_list.isEmpty()) {
                    insert new_cases_list;
                }         
            }
        } catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createAccountStructureCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        } 
    }
    


    /******************************************************************** 
    *   Method Name : createAccountSetupProcessOnBaScreeningComplete
    *   @description :   This method to Create Process cases when all cases approved unser a BA.
    *   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Siva/Balaram
    ***************************************************************/
    public static void createAccountSetupProcessOnBaScreeningComplete(List<Case> approvedScreeningList, Map<Id,Case> caseOldMap)
    {
        Set<Id> baIdSet = new Set<Id>();
        Set<Id> structureCaseIdSet = new Set<Id>();
        List<GEMS_Benefit_Agreement__c> completedBAList = new List<GEMS_Benefit_Agreement__c>();
        List<Case> structureCaseList = new List<Case>();
        Map<String,Case> baLevelParentCaseMap = new Map<String,Case>();
        Set<ID> processBAlevelRecordTypes = new Set<ID>();
        Set<ID> submissionIds = new Set<ID>(); 
        Id opportunityId = null;
        try {
            Id gemsScreeningRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
            Id accSubRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
            Id baAccLevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
            Id dentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
            Id dentalBALevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId();
            Id MedicalBALevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
            Id MedicalBALevelSubChildRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
            Id EPORecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
            Id EPOChildRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
            Id SBCVBALevelRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();            
            Id SBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();          
            //List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSScreeningEntitlementName];
            List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
            processBAlevelRecordTypes.add(baAccLevelSubRecordType);
            processBAlevelRecordTypes.add(dentalBALevelSubRecordType);
            processBAlevelRecordTypes.add(MedicalBALevelSubChildRecordType);
            processBAlevelRecordTypes.add(EPOChildRecordType);
            //processBAlevelRecordTypes.add(SBCVBALevelRecordTypeId);
            processBAlevelRecordTypes.add(gemsScreeningRecordTypeId);
            
            for(Case screeningCaseRec: approvedScreeningList)
            {
                if(gemsScreeningRecordTypeId == screeningCaseRec.recordTypeId  && (screeningCaseRec.status == 'Routed In Error' || screeningCaseRec.status == 'Approved') ) {
                    baIdSet.add(screeningCaseRec.GEMS_Benefit_Agreement__c);
                    //structureCaseIdSet.add(befAggrement.AccountStructureCase__C);
                }
            }
            System.debug('baIdSet====>'+baIdSet);
            if(!baIdSet.isEmpty()) {
              List<GEMS_Benefit_Agreement__c> benefitAggList =  [select Id, Name,Product__r.Product_Category__c,AccountStructureCase__r.Id,AccountStructureCase__r.GEMS_Account_Submission_Info__c from GEMS_Benefit_Agreement__c where ID IN : baIdSet and GEMS_BAs_SpHandling__c = true];
              for(GEMS_Benefit_Agreement__c befAggrement : benefitAggList) {
                  structureCaseIdSet.add(befAggrement.AccountStructureCase__r.Id);
                  submissionIds.add(befAggrement.AccountStructureCase__r.GEMS_Account_Submission_Info__c);
              } 
            }
            
            
            List<GEMS_Benefit_Agreement__c> benefitAggAndCaseList = new List<GEMS_Benefit_Agreement__c>();
            List<GEMS_Benefit_Agreement__c> allBenefitAggAndCaseList = new List<GEMS_Benefit_Agreement__c>();
            Map<String,BALevelParentIdWrapper> structureCaseAndBALevelParents = new Map<String,BALevelParentIdWrapper>();
            List<Case> accSubProcessChildInsertList = new List<Case>();
            // SFDC-4244 Added new field filter for selected BA
            if(!structureCaseIdSet.isEmpty()) {
                allBenefitAggAndCaseList = [SELECT Id, Name, Account__c, AccountStructureCase__r.GEMS_Effective_Date__c, AccountStructureCase__r.GEMS_Case_Effective_Date__c,
                                            AccountStructureCase__r.GEMS_Submission_Type__c, AccountStructureCase__r.FSU_Location__c,
                                            AccountStructureCase__r.HCSC_Division__c, AccountStructureCase__r.GEMS_Submission_Sub_Type__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c,
                                            Account__r.name, Account__r.External_ID__c,AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Print_Mail__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Performance_Guarantees_Type__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Performance_Guarantees__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Implementation_Audit_Required__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Additional_Comments__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.Other__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Rx_Vendor__c,
                                              AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_SBC_Required__c, 
                                              AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Additional_FSU_Location__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Products__c,Product__r.Product_Category__c,                                       
                                            (SELECT ID, GEMS_Benefit_Agreement__c, Status, RecordtypeId, parentId, Sub_Category__c,GEMS_Effective_Date__c,
                                            FSU_Location__c,GEMS_Case_Effective_Date__c,Opportunity_Name__c,GEMS_Submission_Sub_Type__c,HCSC_Division__c ,GEMS_Submission_Type__c,
                                            GEMS_Account_Submission_Info__c,GEMS_Products__c,AccountId,Funding_Type_Multiselect__c,GEMS_StdCust_Product__c,GEMS_Line_of_Business__c,GEMS_Rx_Vendor__c,GEMS_Submitter__c FROM Cases__r )
                                            FROM GEMS_Benefit_Agreement__c WHERE AccountStructureCase__C IN: structureCaseIdSet and GEMS_BAs_SpHandling__c = true];
            }
            // SFDC-4244 Added new field filter for selected BA
            if(!baIdSet.isEmpty()) {  
                
                benefitAggAndCaseList = [SELECT Id, Name, Account__c,Active_Member_Count__c,AccountStructureCase__r.GEMS_Effective_Date__c, AccountStructureCase__r.GEMS_Case_Effective_Date__c,AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_SBC_Required__c,
                                                                           
                                            AccountStructureCase__r.GEMS_Submission_Type__c, AccountStructureCase__r.FSU_Location__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Performance_Guarantees_Type__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Performance_Guarantees__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Additional_FSU_Location__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c,AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Rx_Vendor__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Implementation_Audit_Required__c, AccountStructureCase__r.HCSC_Division__c, AccountStructureCase__r.GEMS_Submission_Sub_Type__c,
                                             AccountStructureCase__r.GEMS_Account_Submission_Info__c,AccountStructureCase__r.Underwriter_Lookup__c,AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Print_Mail__c,
                                            Account__r.name, Account__r.External_ID__c,AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Private_Exchange_Values__c,AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Private_Exchange__c,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId,
                                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Products__c,Product__r.Product_Category__c,
                                            (SELECT ID, GEMS_Benefit_Agreement__c, Status, RecordtypeId, parentId, Sub_Category__c,GEMS_Effective_Date__c,ownerId,
                                            FSU_Location__c,GEMS_Case_Effective_Date__c,GEMS_Submission_Sub_Type__c,Opportunity_Name__c,
                                            HCSC_Division__c ,Funding_Type_Multiselect__c,GEMS_Products__c,GEMS_Submission_Type__c,GEMS_Account_Submission_Info__c,AccountId,GEMS_StdCust_Product__c,GEMS_Line_of_Business__c,GEMS_Rx_Vendor__c,GEMS_Submitter__c  FROM Cases__r WHERE RecordTypeId IN :processBAlevelRecordTypes)                                        
                                            FROM GEMS_Benefit_Agreement__c WHERE ID IN: baIdSet and GEMS_BAs_SpHandling__c = true];
            }
            Map<String,caseteammember > executiveTeamMembers = new Map<String,caseteammember>();
            System.debug('submissionIds===>'+submissionIds);
            if(!submissionIds.isEmpty()) {
                List<caseteammember> caseTeamMembers = [SELECT id, parentId, memberid FROM caseteammember WHERE TeamRole.name='Account Executive' AND parentId in : submissionIds];
                for(CaseTeamMember teammemb : caseTeamMembers ) {
                    executiveTeamMembers.put(teammemb.parentId,teammemb);
                }
            } 
                if(!allBenefitAggAndCaseList.isEmpty()) {
                    BALevelParentIdWrapper baLevelParentIdWrapper = new BALevelParentIdWrapper ();
                    for(GEMS_Benefit_Agreement__c baRec : allBenefitAggAndCaseList) {
                        if(baLevelParentIdWrapper.structureCaseId != baRec.AccountStructureCase__C ) {
                            baLevelParentIdWrapper = new BALevelParentIdWrapper ();
                        }
                        List<Case> baUnderScreeingOnly = new List<Case>();
                        for(Case screeningCaseRec: baRec.Cases__r){
                            opportunityId = screeningCaseRec.Opportunity_Name__c;
                            if(screeningCaseRec.RecordtypeId == baAccLevelSubRecordType) {
                                baLevelParentIdWrapper.structureCaseId = baRec.AccountStructureCase__C;
                                baLevelParentIdWrapper.accountSetupParentId = screeningCaseRec;
                            }
                            if(screeningCaseRec.RecordtypeId == dentalBALevelSubRecordType ) {
                                baLevelParentIdWrapper.structureCaseId = baRec.AccountStructureCase__C;
                                baLevelParentIdWrapper.dentalBenefitCodingParentId = screeningCaseRec;
                            }
                            if(screeningCaseRec.RecordtypeId == MedicalBALevelSubChildRecordType) {
                                baLevelParentIdWrapper.structureCaseId = baRec.AccountStructureCase__C;
                                baLevelParentIdWrapper.medicalBenefitCodingParentId = screeningCaseRec;
                            }
                            if(screeningCaseRec.RecordtypeId == EPOChildRecordType) {
                                baLevelParentIdWrapper.structureCaseId = baRec.AccountStructureCase__C;
                                baLevelParentIdWrapper.pharmacyCodingParentId = screeningCaseRec;
                            }
                            if(screeningCaseRec.RecordtypeId == SBCVBALevelRecordTypeId ) {
                                baLevelParentIdWrapper.structureCaseId = baRec.AccountStructureCase__C;
                                baLevelParentIdWrapper.sbcParentId = screeningCaseRec;
                            }
                            if(screeningCaseRec.RecordtypeId == gemsScreeningRecordTypeId) {
                                baUnderScreeingOnly.add(screeningCaseRec);
                            }
                        }                    
                        structureCaseAndBALevelParents.put(baRec.AccountStructureCase__C ,baLevelParentIdWrapper);                    
                    }
                }
                
                List<Case> accSubProcessParentInsertList= new List<Case>();
                
                Map<Id,Boolean> baRecordTypeNameMap = new Map<Id,Boolean>();
                Map<Id,Boolean> medicalUnderWritBaIdAndisMedicalUnderWritScrMap = new Map<Id,Boolean>();
                Map<Id,Set<String>> idScreenMap = new Map<Id,Set<String>>();
                Map<Id,Map<String,Case>> baScreeninCaseWithRecordIdMap = new Map<Id,Map<String,Case>>();
            if(!benefitAggAndCaseList.isEmpty())
            {
                for(GEMS_Benefit_Agreement__c baRec: benefitAggAndCaseList)
                {
                    Boolean approvedCheck = true;
                    Boolean isDental = false;
                    Boolean isMedicalUnderWritScr = false;
                    Boolean isEPOScreen = false;
                    Boolean isSetup = false;
                    Integer approvedCasesCount = 0;
                    Integer totalCaseRecordsforBa = baRec.Cases__r.size();
                    Set<String> screenSet = new Set<String>();
                    Integer routedErrorCasesCount = 0;
                    Map<String,Case> recordTypeIdCase = new Map<String,Case>();
                    for(Case screeningCaseRec: baRec.Cases__r)
                    {
                        if(screeningCaseRec.RecordtypeId == baAccLevelSubRecordType || screeningCaseRec.RecordtypeId == dentalBALevelSubRecordType
                        || screeningCaseRec.RecordtypeId == MedicalBALevelSubChildRecordType || screeningCaseRec.RecordtypeId == EPOChildRecordType 
                        ) {
                            break;
                        }
                        if((screeningCaseRec.Status == 'Approved' || screeningCaseRec.Status == 'Routed In Error' )
                        && (screeningCaseRec.RecordtypeId !=accSubRecordTypeId && 
                        screeningCaseRec.RecordtypeId!=baAccLevelSubRecordType && 
                        screeningCaseRec.RecordtypeId!=EPORecordType && 
                        screeningCaseRec.RecordtypeId!=EPOChildRecordType && 
                        screeningCaseRec.RecordtypeId !=MedicalBALevelSubRecordType && 
                        screeningCaseRec.RecordtypeId !=MedicalBALevelSubChildRecordType &&                 
                        screeningCaseRec.RecordtypeId !=dentalRecordTypeId &&                   
                        screeningCaseRec.RecordtypeId !=dentalBALevelSubRecordType))
                        {
                            if(screeningCaseRec.Status == 'Approved') {
                                approvedCasesCount=approvedCasesCount+1;
                            }
                            if(screeningCaseRec.Status == 'Routed In Error') {
                                routedErrorCasesCount = routedErrorCasesCount+1;
                            }
                            if(screeningCaseRec.Status != 'Routed In Error' && screeningCaseRec.Sub_Category__c != '' && screeningCaseRec.Sub_Category__c != null && screeningCaseRec.Sub_Category__c.contains('Account Setup Screening'))
                            {
                                isSetup= true;
                            }
                            if(screeningCaseRec.Status != 'Routed In Error' && screeningCaseRec.Sub_Category__c != '' && screeningCaseRec.Sub_Category__c != null && screeningCaseRec.Sub_Category__c.contains('Dental Benefit Coding Screening'))
                            {
                                isDental= true;
                            }
                            if(screeningCaseRec.Status != 'Routed In Error' && screeningCaseRec.Sub_Category__c != '' && screeningCaseRec.Sub_Category__c != null && screeningCaseRec.Sub_Category__c == 'Benefit Coding Screening')
                            {
                                isMedicalUnderWritScr = true;
                            }
                            if(screeningCaseRec.Status != 'Routed In Error' && screeningCaseRec.Sub_Category__c != '' && screeningCaseRec.Sub_Category__c != null && screeningCaseRec.Sub_Category__c.contains('Pharmacy Coding Screening'))
                            {
                                isEPOScreen = true;
                            }
                            
                            recordTypeIdCase.put(screeningCaseRec.Sub_Category__c,screeningCaseRec);                        
                        }
                        baScreeninCaseWithRecordIdMap.put(baRec.Id,recordTypeIdCase);
                    }

                    if((approvedCasesCount+routedErrorCasesCount) == totalCaseRecordsforBa && approvedCasesCount > =1 )
                    {
                        completedBAList.add(baRec);
                        if(isDental) {
                        screenSet.add('Dental');
                            baRecordTypeNameMap.put(baRec.id,isDental);
                        }
                        if(isMedicalUnderWritScr)
                        {
                            screenSet.add('Medical');
                            medicalUnderWritBaIdAndisMedicalUnderWritScrMap.put(baRec.id,isMedicalUnderWritScr);
                        }
                        if(isEPOScreen) {
                            screenSet.add('EPO');
                        }
                        if(isSetup) {
                            screenSet.add('AccountSetup');
                        }
                        idScreenMap.put(baRec.id,screenSet);
                    }
                }
            }
            
            List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
            if(!completedBAList.isEmpty() && completedBAList != null )
            {
                Boolean setupCreated = false;
                Boolean sbcCreated = false;
                // Boolean dentalCreated = false;
                Boolean medicalCreated = false;
                Boolean pharmacyCreated = false;
                System.debug('======completedBAList====>'+completedBAList.size());
                for(GEMS_Benefit_Agreement__c baRec : completedBAList)
                {
                    DateTime effectiveDate = baRec.AccountStructureCase__r.GEMS_Effective_Date__c;
                    /*if(!setupCreated && idScreenMap.containsKey(baRec.Id) && idScreenMap.get(baRec.Id).contains('AccountSetup') && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c) != null && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c).accountSetupParentId == null ) {                    
                        Case accSubProcessNewParentCase = new Case();
                        accSubProcessNewParentCase.Type = 'Account Setup Process';
                        accSubProcessNewParentCase.recordtypeid=accSubRecordTypeId;
                        //*
                        if(!activeEntitlement.isEmpty())
                        {
                            System.debug('activeEntitlement===enter into if====>');
                            accSubProcessNewParentCase.EntitlementId = activeEntitlement[0].id;
                        }
                        //* -- Reverse it
                        accSubProcessNewParentCase.GEMS_Line_of_Business__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c;
                        accSubProcessNewParentCase.GEMS_Rx_Vendor__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Rx_Vendor__c;
                        accSubProcessNewParentCase.Accountid=baRec.Account__c;
                        accSubProcessNewParentCase.GEMS_Effective_Date__c=baRec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        accSubProcessNewParentCase.GEMS_Case_Effective_Date__c = baRec.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        accSubProcessNewParentCase.GEMS_Submission_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Type__c;
                        accSubProcessNewParentCase.FSU_Location__c=baRec.AccountStructureCase__r.FSU_Location__c;
                        accSubProcessNewParentCase.Status='In Progress';
                        accSubProcessNewParentCase.parentid = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        accSubProcessNewParentCase.HCSC_Division__c=baRec.AccountStructureCase__r.HCSC_Division__c;
                        //accSubProcessNewParentCase.GEMS_Private_Exchange__c=baRec.AccountStructureCase__r.GEMS_Private_Exchange__c;
                        accSubProcessNewParentCase.GEMS_Submission_Sub_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Sub_Type__c;
                        accSubProcessNewParentCase.GEMS_Account_Submission_Info__c=baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        //accSubProcessNewParentCase.Subject=baRec.Account__r.name+' '+baRec.Account__r.External_ID__c+' - Account Setup Process - '+effectiveDate.format('M/d/yyyy');
                        accSubProcessNewParentCase.Subject=baRec.Account__r.name+' '+baRec.Account__r.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' Account Setup Process';
                        //accSubProcessNewParentCase.GEMS_Benefit_Agreement__c=baRec.Id;
                        accSubProcessNewParentCase.GEMS_Private_Exchange__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Private_Exchange__c;     
                        accSubProcessNewParentCase.GEMS_Private_Exchange_Values__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Private_Exchange_Values__c;
                        if(opportunityId != null) 
                            accSubProcessNewParentCase.Opportunity_Name__c = opportunityId;
                        if(baScreeninCaseWithRecordIdMap.get(baRec.Id) != null && baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Account Setup Screening') != null )
                            accSubProcessNewParentCase.ownerId = baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Account Setup Screening').ownerId;
                        
                        accSubProcessNewParentCase.Underwriter_Lookup__c = baRec.AccountStructureCase__r.Underwriter_Lookup__c;
                        
                        accSubProcessParentInsertList.add(accSubProcessNewParentCase);
                        
                        baList.add(baRec);
                        setupCreated = true;
                    }
                    */

                    /* #LUKE SFDC-3376 Move dental coding cases outside of here to createDentalBenefitCodingCase() method triggered by UW cases approved
                    if(!dentalCreated && idScreenMap.containsKey(baRec.Id) && idScreenMap.get(baRec.Id).contains('Dental') && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c) != null && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c).dentalBenefitCodingParentId == null )
                    {
                        System.debug('==Dental Record==');
                        //DateTime effectiveDate = baRec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        Case parentDentalCase = new Case();
                        parentDentalCase.recordtypeid = dentalRecordTypeId;
                        
                     //   if(!activeEntitlement.isEmpty())
                     //   {
                     //       System.debug('activeEntitlement===enter into if====>');
                     //       parentDentalCase.EntitlementId = activeEntitlement[0].id;
                     //   }
                        
                        if(!executiveTeamMembers.isEmpty())
                        parentDentalCase.Account_Executive__c = executiveTeamMembers.get(baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c).memberId;
                        parentDentalCase.GEMS_Line_of_Business__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c;
                        parentDentalCase.GEMS_Rx_Vendor__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Rx_Vendor__c;                        
                        parentDentalCase.Type = 'Dental Benefit Coding';
                        parentDentalCase.parentid = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        parentDentalCase.Accountid=baRec.Account__c;
                        parentDentalCase.GEMS_Effective_Date__c=barec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        parentDentalCase.GEMS_Case_Effective_Date__c = baRec.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        parentDentalCase.GEMS_Submission_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Type__c;
                        parentDentalCase.FSU_Location__c=baRec.AccountStructureCase__r.FSU_Location__c;
                        parentDentalCase.Status='New';
                        parentDentalCase.HCSC_Division__c=baRec.AccountStructureCase__r.HCSC_Division__c;
                        parentDentalCase.GEMS_Submission_Sub_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Sub_Type__c;
                        parentDentalCase.GEMS_Account_Submission_Info__c=baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        //parentDentalCase.Subject=baRec.Account__r.name +' '+baRec.Account__r.External_ID__c+' - Dental Benefit Coding - '+effectiveDate.format('M/d/yyyy');
                        parentDentalCase.Subject=baRec.Account__r.name +' '+baRec.Account__r.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' Dental Benefit Coding';
                        //accSubProcessNewParentCase.GEMS_Benefit_Agreement__c=baRec.Id;
                        parentDentalCase.GEMS_Submitter__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId;
                        parentDentalCase.GEMS_StdCust_Product__c  = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c;
                        parentDentalCase.Funding_Type_Multiselect__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c; 
                        parentDentalCase.GEMS_Products__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Products__c;
                        if(baScreeninCaseWithRecordIdMap.get(baRec.Id) != null && baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Dental Benefit Coding Screening') != null )
                            parentDentalCase.ownerId = baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Dental Benefit Coding Screening').ownerId;
                        if(opportunityId != null) 
                            parentDentalCase.Opportunity_Name__c = opportunityId;
                            
                       accSubProcessParentInsertList.add(parentDentalCase);
                        
                        baList.add(baRec);
                        dentalCreated = true;
                    }
                */
                
                    if(!medicalCreated && idScreenMap.containsKey(baRec.Id) && idScreenMap.get(baRec.Id).contains('Medical') && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c) != null && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c).medicalBenefitCodingParentId == null )
                    {
                        System.debug('==Medical Under Writing Record==');
                        //DateTime effectiveDate = baRec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        Case parentMedicalUnderCase = new Case();
                        parentMedicalUnderCase.GEMS_Case_Effective_Date__c = baRec.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        parentMedicalUnderCase.recordtypeid = MedicalBALevelSubRecordType;
                        
                        if(!activeEntitlement.isEmpty())
                        {
                            System.debug('activeEntitlement===enter into if====>');
                            parentMedicalUnderCase.EntitlementId = activeEntitlement[0].id;
                        }
                        
                        parentMedicalUnderCase.GEMS_Submitter__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId;
                        parentMedicalUnderCase.GEMS_Line_of_Business__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c;
                        parentMedicalUnderCase.GEMS_Rx_Vendor__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Rx_Vendor__c;
                        parentMedicalUnderCase.Type = 'Medical Benefit Coding';
                        parentMedicalUnderCase.Accountid=baRec.Account__c;
                        parentMedicalUnderCase.parentId = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        parentMedicalUnderCase.GEMS_Effective_Date__c=barec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        parentMedicalUnderCase.GEMS_Submission_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Type__c;
                        parentMedicalUnderCase.FSU_Location__c=baRec.AccountStructureCase__r.FSU_Location__c;
                        parentMedicalUnderCase.Status='In Progress';
                        parentMedicalUnderCase.HCSC_Division__c=baRec.AccountStructureCase__r.HCSC_Division__c;
                        parentMedicalUnderCase.GEMS_Submission_Sub_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Sub_Type__c;
                        parentMedicalUnderCase.GEMS_Account_Submission_Info__c=baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        //parentMedicalUnderCase.Subject=baRec.Account__r.name +' '+baRec.Account__r.External_ID__c+' - Medical Underwriting Screening - '+effectiveDate.format('M/d/yyyy');
                        parentMedicalUnderCase.Subject=baRec.Account__r.name +' '+baRec.Account__r.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' Medical Benefit Coding';
                        //parentMedicalUnderCase.GEMS_Benefit_Agreement__c=baRec.Id;
                        parentMedicalUnderCase.GEMS_Submitter__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId;
                        parentMedicalUnderCase.GEMS_StdCust_Product__c  = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c;
                        parentMedicalUnderCase.Funding_Type_Multiselect__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c; 
                        parentMedicalUnderCase.GEMS_Products__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Products__c;
                        if(baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Additional_FSU_Location__c != null) 
                            parentMedicalUnderCase.GEMS_Additional_FSU_Location__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Additional_FSU_Location__c;
                        
                        if(baScreeninCaseWithRecordIdMap.get(baRec.Id) != null && baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Benefit Coding Screening') != null )
                            parentMedicalUnderCase.ownerId = baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Benefit Coding Screening').ownerId;
                        if(opportunityId != null) 
                            parentMedicalUnderCase.Opportunity_Name__c = opportunityId;
                            
                        accSubProcessParentInsertList.add(parentMedicalUnderCase);
                        
                        baList.add(baRec);
                        medicalCreated = true;
                    }
                    
                    if(!pharmacyCreated && idScreenMap.containsKey(baRec.Id) && idScreenMap.get(baRec.Id).contains('EPO') && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c) != null && structureCaseAndBALevelParents.get(baRec.AccountStructureCase__c).pharmacyCodingParentId == null )
                    {
                        System.debug('==Medical Under Writing Record==');
                        //DateTime effectiveDate = baRec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        Case parentMedicalUnderCase = new Case();
                        parentMedicalUnderCase.GEMS_Case_Effective_Date__c = baRec.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        parentMedicalUnderCase.recordtypeid = EPORecordType;
                        
                        if(!activeEntitlement.isEmpty())
                        {
                            System.debug('activeEntitlement===enter into if====>');
                            parentMedicalUnderCase.EntitlementId = activeEntitlement[0].id;
                        }
                        
                        parentMedicalUnderCase.GEMS_Submitter__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId;
                        parentMedicalUnderCase.ParentId = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        parentMedicalUnderCase.GEMS_Line_of_Business__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c;
                        parentMedicalUnderCase.GEMS_Rx_Vendor__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Rx_Vendor__c;
                        parentMedicalUnderCase.Type = 'Pharmacy Coding';
                        parentMedicalUnderCase.Accountid=baRec.Account__c;
                        parentMedicalUnderCase.GEMS_Effective_Date__c=barec.AccountStructureCase__r.GEMS_Effective_Date__c;
                        parentMedicalUnderCase.GEMS_Submission_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Type__c;
                        parentMedicalUnderCase.FSU_Location__c=baRec.AccountStructureCase__r.FSU_Location__c;
                        parentMedicalUnderCase.GEMS_Line_of_Business__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Line_of_Business__c;
                        parentMedicalUnderCase.GEMS_Implementation_Audit_Required__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Implementation_Audit_Required__c;
                        parentMedicalUnderCase.GEMS_Performance_Guarantees_Type__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Performance_Guarantees_Type__c;
                        parentMedicalUnderCase.GEMS_Performance_Guarantees__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Performance_Guarantees__c;
                        parentMedicalUnderCase.Status='In Progress';
                        parentMedicalUnderCase.HCSC_Division__c=baRec.AccountStructureCase__r.HCSC_Division__c;
                        parentMedicalUnderCase.GEMS_Submission_Sub_Type__c=baRec.AccountStructureCase__r.GEMS_Submission_Sub_Type__c;
                        parentMedicalUnderCase.GEMS_Account_Submission_Info__c=baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c;
                        //parentMedicalUnderCase.Subject=baRec.Account__r.name +' '+baRec.Account__r.External_ID__c+' - Pharmacy Coding - '+effectiveDate.format('M/d/yyyy');
                        parentMedicalUnderCase.Subject=baRec.Account__r.name +' '+baRec.Account__r.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' Pharmacy Coding';
                        //parentMedicalUnderCase.GEMS_Benefit_Agreement__c=baRec.Id;
                        parentMedicalUnderCase.GEMS_Submitter__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId;
                        parentMedicalUnderCase.GEMS_StdCust_Product__c  = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c;
                        parentMedicalUnderCase.Funding_Type_Multiselect__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c; 
                        parentMedicalUnderCase.GEMS_Products__c = baRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_Products__c;
                        if(baScreeninCaseWithRecordIdMap.get(baRec.Id) != null && baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Pharmacy Coding Screening') != null )
                                parentMedicalUnderCase.ownerId = baScreeninCaseWithRecordIdMap.get(baRec.Id).get('Pharmacy Coding Screening').ownerId;
                        if(opportunityId != null) 
                            parentMedicalUnderCase.Opportunity_Name__c = opportunityId;
                            
                        accSubProcessParentInsertList.add(parentMedicalUnderCase);
                        
                        baList.add(baRec);
                        pharmacyCreated = true;
                    }
                }
                Database.Saveresult[] caseSaveResult;
                if(accSubProcessParentInsertList!=null && !accSubProcessParentInsertList.isEmpty() && recursiveCheck )
                {
                    recursiveCheck = false;
                    caseSaveResult = Database.insert(accSubProcessParentInsertList);                
                    System.debug('===caseSaveResult======'+caseSaveResult);
                    for(Case caseParents : accSubProcessParentInsertList) {
                        baLevelParentCaseMap.put(caseParents.recordTypeId,caseParents);
                    }
                    
                }
                if(completedBAList != null && !completedBAList.isEmpty()) {
                    GEMS_CaseTriggerHandler.ProcessChildCases processChildFuture = new GEMS_CaseTriggerHandler.ProcessChildCases();
                    processChildFuture.completedBAList = completedBAList;
                    processChildFuture.baLevelParentCaseMap = baLevelParentCaseMap;
                    processChildFuture.structureCaseAndBALevelParents = structureCaseAndBALevelParents;
                    processChildFuture.opportunityId = opportunityId;
                    processChildFuture.executiveTeamMembers = executiveTeamMembers;
                    processChildFuture.baScreeninCaseWithRecordIdMap = baScreeninCaseWithRecordIdMap;
                    processChildFuture.idScreenMap = idScreenMap;

                    createProcessChildCasesFuture(JSON.serializePretty(processChildFuture));
                }                
                
                
                
                
            }
            

            /*
            Database.SaveResult[] childSaveResult;     
            System.debug('accSubProcessChildInsertList====>'+accSubProcessChildInsertList); 
            if(!accSubProcessChildInsertList.isEmpty() )
            {
                childSaveResult = Database.insert(accSubProcessChildInsertList);
                System.debug('======childSaveResult====>'+childSaveResult);
            }
            */
        }
         catch(Exception ex) {
            System.debug('==exception='+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_caseTriggerHandler.createAccountSetupProcessOnBaScreeningComplete(List<Case> approvedScreeningList, Map<Id,Case> caseOldMap)','High');  
                
        }
    }
    
    public class ProcessChildCases {
        public List<GEMS_Benefit_Agreement__c> completedBAList;
        public Map<String,Case> baLevelParentCaseMap;
        public Map<String,BALevelParentIdWrapper> structureCaseAndBALevelParents;
        public Id opportunityId;
        public Map<String,caseteammember> executiveTeamMembers;
        public Map<Id,Map<String,Case>> baScreeninCaseWithRecordIdMap;
        public Map<Id,Set<String>> idScreenMap;
    }
    
    @future
    public static void createProcessChildCasesFuture(string scclass) {
        
        GEMS_CaseTriggerHandler.ProcessChildCases hl = (GEMS_CaseTriggerHandler.ProcessChildCases) JSON.deserialize(scclass, GEMS_CaseTriggerHandler.ProcessChildCases.class);
        
        try {
           createProcessChildCases(hl.completedBAList,hl.baLevelParentCaseMap, hl.structureCaseAndBALevelParents,hl.opportunityId, hl.executiveTeamMembers, hl.baScreeninCaseWithRecordIdMap, hl.idScreenMap);
                
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createProcessChildCasesFuture(string scclass)','High');
        }
        
    }
    
    /******************************************************************** 
    *    Method Name : createProcessChildCases
    *   @description :   This method to create BA Level process child cases 
    *   @parameters  :   List<GEMS_Benefit_Agreement__c> completedBAList,Map<String,Case> baLevelParentCaseMap
    *   @return type :   void
    *   @Author : Balaram
    ***************************************************************/
    public static void createProcessChildCases(List<GEMS_Benefit_Agreement__c> completedBAList, Map<String,Case> baLevelParentCaseMap, Map<String,BALevelParentIdWrapper> structureCaseAndBALevelParents, Id opportunityId, Map<String,caseteammember> executiveTeamMembers, Map<Id,Map<String,Case>> baScreeninCaseWithRecordIdMap, Map<Id,Set<String>> idScreenMap)  {
        
        Id gemsScreeningRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        Id accSubRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Id baAccLevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        Id dentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Id dentalBALevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId();
        Id MedicalBALevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Id MedicalBALevelSubChildRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        Id EPORecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Id EPOChildRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        Id SBCVBALevelRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        Id SBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        //SFDC-7850 Malathi.K
         Set<Id> accSubMBCParentstatusupdateSet = new Set<Id>();                 
        try {
            Integer i=0;
            List<Case> accSubProcessChildInsertList = new List<Case>();             
            for(GEMS_Benefit_Agreement__c baRecord : completedBAList) {
                    Case accSubParentCaseRec = null;
                    //Code Commented for October release not to create BA Level Account setup cases
                    Case accSubProcessNewChildCase = new Case();
                    
                    String parentId = '';
                    if(baLevelParentCaseMap.get(dentalRecordTypeId) != null ) {
                        accSubParentCaseRec = baLevelParentCaseMap.get(dentalRecordTypeId);
                        parentId = accSubParentCaseRec.Id;
                    }else {
                        accSubParentCaseRec = structureCaseAndBALevelParents.get(baRecord.AccountStructureCase__C).dentalBenefitCodingParentId;
                        if(accSubParentCaseRec != null)
                        parentId = accSubParentCaseRec.parentId;
                    }

                    /* #LUKE SFDC-3376 Move dental coding cases outside of here to createDentalBenefitCodingCase() method triggered by UW cases approved
                    if(idScreenMap.containsKey(baRecord.Id) && idScreenMap.get(baRecord.Id).contains('Dental') &&  accSubParentCaseRec != null && (accSubParentCaseRec.recordtypeid == dentalBALevelSubRecordType || accSubParentCaseRec.recordtypeid == dentalRecordTypeId) ) {
                        System.debug('====Dental Record Child Creation====');
                        Case accSubProcessNewChildCase1 = new Case();
                        DateTime effectiveDate1 = accSubParentCaseRec.GEMS_Effective_Date__c;
                        
                        //accSubParentCaseRec1 = structureCaseAndBALevelParents.get(baRecord.AccountStructureCase__C).accountSetupParentId;
                        accSubProcessNewChildCase1.recordtypeid=dentalBALevelSubRecordType;
                        accSubProcessNewChildCase1.Type = 'Dental Benefit Coding';
                        //accSubProcessNewChildCase1.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' - BA Level Dental Benefit Coding - '+effectiveDate1.format('M/d/yyyy');
                        accSubProcessNewChildCase1.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' '+effectiveDate1.format('M/d/yyyy')+' BA Level Dental Benefit Coding';
                        accSubProcessNewChildCase1.Accountid=accSubParentCaseRec.AccountId;
                        accSubProcessNewChildCase1.GEMS_Benefit_Agreement__c = baRecord.id;
                        if(!executiveTeamMembers.isEmpty())
                        accSubProcessNewChildCase1.Account_Executive__c = executiveTeamMembers.get(baRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c).memberId;
                        accSubProcessNewChildCase1.GEMS_Effective_Date__c = baRecord.AccountStructureCase__r.GEMS_Effective_Date__c;
                        accSubProcessNewChildCase1.GEMS_Case_Effective_Date__c = baRecord.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        //accSubProcessNewChildCase.Subject = accSubProcessNewChildCase.Subject+effectiveDate.format('M/d/yyyy');
                        accSubProcessNewChildCase1.ParentId=parentId;
                        //accSubProcessNewChildCase.GEMS_Effective_Date__c=accSubParentCaseRec.GEMS_Effective_Date__c;
                        accSubProcessNewChildCase1.GEMS_Submission_Type__c=accSubParentCaseRec.GEMS_Submission_Type__c;
                        accSubProcessNewChildCase1.FSU_Location__c=accSubParentCaseRec.FSU_Location__c;
                        accSubProcessNewChildCase1.Status='In Progress';
                        accSubProcessNewChildCase1.HCSC_Division__c=accSubParentCaseRec.HCSC_Division__c;
                        accSubProcessNewChildCase1.GEMS_Submission_Sub_Type__c=accSubParentCaseRec.GEMS_Submission_Sub_Type__c;
                        accSubProcessNewChildCase1.GEMS_Account_Submission_Info__c=accSubParentCaseRec.GEMS_Account_Submission_Info__c;
                        // This population is for October Hotfix 2016
                        accSubProcessNewChildCase1.Funding_Type_Multiselect__c = accSubParentCaseRec.Funding_Type_Multiselect__c;                
                        accSubProcessNewChildCase1.GEMS_StdCust_Product__c = accSubParentCaseRec.GEMS_StdCust_Product__c;
                        accSubProcessNewChildCase1.GEMS_Rx_Vendor__c = accSubParentCaseRec.GEMS_Rx_Vendor__c;
                        accSubProcessNewChildCase1.GEMS_Line_of_Business__c=accSubParentCaseRec.GEMS_Line_of_Business__c;
                        accSubProcessNewChildCase1.GEMS_Submitter__c = accSubParentCaseRec.GEMS_Submitter__c;
                        accSubProcessNewChildCase1.GEMS_Products__c = accSubParentCaseRec.GEMS_Products__c;
                        if(baScreeninCaseWithRecordIdMap.get(baRecord.Id) != null && baScreeninCaseWithRecordIdMap.get(baRecord.Id).get('Dental Benefit Coding Screening') != null )
                            accSubProcessNewChildCase1.ownerId = baScreeninCaseWithRecordIdMap.get(baRecord.Id).get('Dental Benefit Coding Screening').ownerId;
                        if(opportunityId != null) 
                            accSubProcessNewChildCase1.Opportunity_Name__c = opportunityId;
                        
                       accSubProcessChildInsertList.add(accSubProcessNewChildCase1);
                    }  */

                    parentId = '';
                    if(baLevelParentCaseMap.get(MedicalBALevelSubRecordType) != null ) {
                        accSubParentCaseRec = baLevelParentCaseMap.get(MedicalBALevelSubRecordType);
                         parentId = accSubParentCaseRec.Id;                        
                    }else {
                        accSubParentCaseRec = structureCaseAndBALevelParents.get(baRecord.AccountStructureCase__C).medicalBenefitCodingParentId;
                        if(accSubParentCaseRec != null)
                        parentId = accSubParentCaseRec.parentId;                                               
                    }                                        

                    if(idScreenMap.containsKey(baRecord.Id) && idScreenMap.get(baRecord.Id).contains('Medical') &&  accSubParentCaseRec != null && (accSubParentCaseRec.recordtypeid == MedicalBALevelSubChildRecordType || accSubParentCaseRec.recordtypeid == MedicalBALevelSubRecordType ) ) {
                        System.debug('====Medical Record Child Creation====');
                        accSubProcessNewChildCase = new Case();
                        DateTime effectiveDate3 = accSubParentCaseRec.GEMS_Effective_Date__c;
                        
                        //accSubParentCaseRec = structureCaseAndBALevelParents.get(baRecord.AccountStructureCase__C).medicalBenefitCodingParentId;
                        accSubProcessNewChildCase.recordtypeid=MedicalBALevelSubChildRecordType;
                        accSubProcessNewChildCase.Type = 'Medical Benefit Coding';
                        //accSubProcessNewChildCase.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' - Medical Benefit Coding - '+effectiveDate3.format('M/d/yyyy');
                        accSubProcessNewChildCase.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' '+effectiveDate3.format('M/d/yyyy')+' Medical Benefit Coding';
                        
                        accSubProcessNewChildCase.Accountid=accSubParentCaseRec.AccountId;
                        accSubProcessNewChildCase.GEMS_Benefit_Agreement__c = baRecord.id;
                        
                        accSubProcessNewChildCase.Active_Member_Count__c = baRecord.Active_Member_Count__c; //SFDC-9463
                        
                        accSubProcessNewChildCase.GEMS_Effective_Date__c = baRecord.AccountStructureCase__r.GEMS_Effective_Date__c;
                        accSubProcessNewChildCase.GEMS_Case_Effective_Date__c = baRecord.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        //accSubProcessNewChildCase.Subject = accSubProcessNewChildCase.Subject+effectiveDate.format('M/d/yyyy');
                        accSubProcessNewChildCase.ParentId=parentId;
                        //accSubProcessNewChildCase.GEMS_Effective_Date__c=accSubParentCaseRec.GEMS_Effective_Date__c;
                        accSubProcessNewChildCase.GEMS_Submission_Type__c=accSubParentCaseRec.GEMS_Submission_Type__c;
                        accSubProcessNewChildCase.FSU_Location__c=accSubParentCaseRec.FSU_Location__c;
                        accSubProcessNewChildCase.Status='In Progress';
                        accSubProcessNewChildCase.HCSC_Division__c=accSubParentCaseRec.HCSC_Division__c;
                        accSubProcessNewChildCase.GEMS_Submission_Sub_Type__c=accSubParentCaseRec.GEMS_Submission_Sub_Type__c;
                        accSubProcessNewChildCase.GEMS_Account_Submission_Info__c=accSubParentCaseRec.GEMS_Account_Submission_Info__c;
                        // This population is for October Hotfix 2016
                        accSubProcessNewChildCase.Funding_Type_Multiselect__c = accSubParentCaseRec.Funding_Type_Multiselect__c;                
                        accSubProcessNewChildCase.GEMS_StdCust_Product__c = accSubParentCaseRec.GEMS_StdCust_Product__c;
                        accSubProcessNewChildCase.GEMS_Rx_Vendor__c = accSubParentCaseRec.GEMS_Rx_Vendor__c;
                        accSubProcessNewChildCase.GEMS_Line_of_Business__c=accSubParentCaseRec.GEMS_Line_of_Business__c;
                        accSubProcessNewChildCase.GEMS_Submitter__c = accSubParentCaseRec.GEMS_Submitter__c;
                        accSubProcessNewChildCase.GEMS_Products__c = accSubParentCaseRec.GEMS_Products__c;
                        if(accSubParentCaseRec.GEMS_Additional_FSU_Location__c != null)
                            accSubProcessNewChildCase.GEMS_Additional_FSU_Location__c = accSubParentCaseRec.GEMS_Additional_FSU_Location__c;
                        
                        if(baScreeninCaseWithRecordIdMap.get(baRecord.Id) != null && baScreeninCaseWithRecordIdMap.get(baRecord.Id).get('Benefit Coding Screening') != null )
                          accSubProcessNewChildCase.ownerId = baScreeninCaseWithRecordIdMap.get(baRecord.Id).get('Benefit Coding Screening').ownerId;
                        if(opportunityId != null) 
                            accSubProcessNewChildCase.Opportunity_Name__c = opportunityId;
                            
                        accSubProcessChildInsertList.add(accSubProcessNewChildCase);
                        //SFDC-7850 Malathi.K                        
                             accSubMBCParentstatusupdateSet.add(parentId);                             
                    }
                    parentId = '';
                    if(baLevelParentCaseMap.get(EPORecordType) != null ) {
                        accSubParentCaseRec = baLevelParentCaseMap.get(EPORecordType);
                        parentId = accSubParentCaseRec.Id;
                    }else {
                        accSubParentCaseRec = structureCaseAndBALevelParents.get(baRecord.AccountStructureCase__C).pharmacyCodingParentId;
                        if(accSubParentCaseRec != null)
                        parentId = accSubParentCaseRec.parentId;
                    }

                    if(idScreenMap.containsKey(baRecord.Id) && idScreenMap.get(baRecord.Id).contains('EPO') && accSubParentCaseRec != null && (accSubParentCaseRec.recordtypeid == EPORecordType || accSubParentCaseRec.recordtypeid == EPOChildRecordType )) {
                        System.debug('====EPO Record Child Creation====');
                        accSubProcessNewChildCase = new Case();
                        DateTime effectiveDate3 = accSubParentCaseRec.GEMS_Effective_Date__c;
                        
                        //accSubParentCaseRec = structureCaseAndBALevelParents.get(baRecord.AccountStructureCase__C).pharmacyCodingParentId;
                        accSubProcessNewChildCase.recordtypeid=EPOChildRecordType ;
                        accSubProcessNewChildCase.Type = 'Pharmacy Coding';
                        //accSubProcessNewChildCase.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' - BA Level Pharmacy Coding - '+effectiveDate3.format('M/d/yyyy');
                        accSubProcessNewChildCase.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' '+effectiveDate3.format('M/d/yyyy')+' BA Level Pharmacy Coding';
                        
                        accSubProcessNewChildCase.Accountid=accSubParentCaseRec.AccountId;
                        accSubProcessNewChildCase.GEMS_Benefit_Agreement__c = baRecord.id;
                        
                        
                        accSubProcessNewChildCase.GEMS_Effective_Date__c = baRecord.AccountStructureCase__r.GEMS_Effective_Date__c;
                        accSubProcessNewChildCase.GEMS_Case_Effective_Date__c = baRecord.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                        //accSubProcessNewChildCase.Subject = accSubProcessNewChildCase.Subject+effectiveDate.format('M/d/yyyy');
                        accSubProcessNewChildCase.ParentId=parentId;
                        //accSubProcessNewChildCase.GEMS_Effective_Date__c=accSubParentCaseRec.GEMS_Effective_Date__c;
                        accSubProcessNewChildCase.GEMS_Submission_Type__c=accSubParentCaseRec.GEMS_Submission_Type__c;
                        accSubProcessNewChildCase.FSU_Location__c=accSubParentCaseRec.FSU_Location__c;
                        accSubProcessNewChildCase.Status='In Progress';
                        accSubProcessNewChildCase.HCSC_Division__c=accSubParentCaseRec.HCSC_Division__c;
                        accSubProcessNewChildCase.GEMS_Submission_Sub_Type__c=accSubParentCaseRec.GEMS_Submission_Sub_Type__c;
                        accSubProcessNewChildCase.GEMS_Account_Submission_Info__c=accSubParentCaseRec.GEMS_Account_Submission_Info__c;
                        // This population is for October Hotfix 2016
                        accSubProcessNewChildCase.Funding_Type_Multiselect__c = accSubParentCaseRec.Funding_Type_Multiselect__c;                
                        accSubProcessNewChildCase.GEMS_StdCust_Product__c = accSubParentCaseRec.GEMS_StdCust_Product__c;
                        accSubProcessNewChildCase.GEMS_Rx_Vendor__c = accSubParentCaseRec.GEMS_Rx_Vendor__c;
                        accSubProcessNewChildCase.GEMS_Line_of_Business__c=accSubParentCaseRec.GEMS_Line_of_Business__c;
                        accSubProcessNewChildCase.GEMS_Submitter__c = accSubParentCaseRec.GEMS_Submitter__c;
                        accSubProcessNewChildCase.GEMS_Products__c = accSubParentCaseRec.GEMS_Products__c;
                        if(baScreeninCaseWithRecordIdMap.get(baRecord.Id) != null && baScreeninCaseWithRecordIdMap.get(baRecord.Id).get('Pharmacy Coding Screening') != null )
                            accSubProcessNewChildCase.ownerId = baScreeninCaseWithRecordIdMap.get(baRecord.Id).get('Pharmacy Coding Screening').ownerId;
                        if(opportunityId != null) 
                            accSubProcessNewChildCase.Opportunity_Name__c = opportunityId;
                        
                        accSubProcessChildInsertList.add(accSubProcessNewChildCase);
                    }
                   
                    
                                       
            }
            Database.SaveResult[] childSaveResult;     
            System.debug('accSubProcessChildInsertList====>'+accSubProcessChildInsertList); 
            if(!accSubProcessChildInsertList.isEmpty() )
            {
                childSaveResult = Database.insert(accSubProcessChildInsertList);
                System.debug('======childSaveResult====>'+childSaveResult);
            }
            //SFDC-7850 Malathi.K            
            Database.SaveResult[] parentStatusUpdResult; 
            if(!accSubMBCParentstatusupdateSet.isEmpty() )
            {                
                List<Case> MBCParentstatusupdateList = new List<Case>();
                for(Id parentcaseMBCRecordId : accSubMBCParentstatusupdateSet) {
                     Case parentcaseMBCRecord = New case();                
                     parentcaseMBCRecord.id = parentcaseMBCRecordId;                   
                     parentcaseMBCRecord.status = 'In Progress';                   
                     MBCParentstatusupdateList.add(parentcaseMBCRecord );
                  }                                
                parentStatusUpdResult = Database.update(MBCParentstatusupdateList);
                System.debug('======parentStatusUpdResult ====>'+parentStatusUpdResult );
            }
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createProcessChildCases()','High');              
        }
        
    }
    /******************************************************************** 
    *    Method Name : parentStatusChangeAllBAScreeningChange
    *   @description :   This method to update BA Level parent cases when all child BA level cases approved
    *   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Balaram
    ***************************************************************/
    public static void parentStatusChangeAllBAScreeningChange(List<Case> casesList,Map<Id,Case> oldCaseMap) {
        Id additionalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        Set<String> completedParentCaseIds = new Set<String>();
        Set<String> ReturnedParentCaseIds = new Set<String>();
        List<Case> parentStatusUpdationList = new List<Case>();
        for(case caserec : casesList) {
            
            
            if((caserec.status == 'Approved' || caserec.status == 'Return' || caserec.status == 'In Progress'|| 
                caserec.status == 'Routed In Error' ) && (caserec.status != oldCaseMap.get(caserec.Id).status) && 
               (caserec.recordTypeId == additionalUnderwritingRecordTypeId))
            {
                System.debug('*************status=Approved/Return/In Progress/Routed In Error/Screening RT');
                completedParentCaseIds.add(caserec.parentId);
            }            
         }
         if(!completedParentCaseIds.isEmpty()) {
             System.debug('*************completedParentCaseIds- not empty');
             List<Case> parentChildCasesList = [select id,casenumber,recordtypeId,GEMS_All_Screening_Routed_In_Error__c, status, parentId,GEMS_Effective_Date__c,Accountid,GEMS_Case_Effective_Date__c,GEMS_Submission_Type__c,
                FSU_Location__c,HCSC_Division__c,GEMS_Submission_Sub_Type__c,GEMS_Account_Submission_Info__c,
                                                Account.name,Account.External_ID__c,(select id, casenumber,status from Cases) 
                                                from case where id in : completedParentCaseIds ];
             System.debug('*************parentChildCasesList-'+parentChildCasesList);
             Boolean allChildSameStatus = true;
             Boolean allChildRoutedInError = true;
             Boolean inProgressStatus = false;//added for checking inProgress status
             //Code changed for October release to update GEMS_All_Screening_Routed_In_Error__c = true for parent case 
             //if all child screening status 'routed in error'
            for(Case caseParent : parentChildCasesList) {
                allChildSameStatus = true;
                allChildRoutedInError = true;
                List<Case> childCases = caseParent.cases;
                String firstCaseStatus = null;
                String firstRoutedInError = null;
                for(Case casss : childCases) {
                    //added by shiva to check In Progress Status
                    if(casss.status == 'In Progress') {
                        inProgressStatus = true;
                        break;
                    }
                    if(firstCaseStatus == null && casss.status != 'Routed In Error' ) {
                       firstCaseStatus =  casss.status;
                    }else if(firstCaseStatus == null && casss.status == 'Routed In Error') {
                        firstRoutedInError = casss.status;
                    }
                    if(casss.status != 'Routed In Error' && casss.status != firstCaseStatus) {
                        allChildSameStatus = false;
                        break;
                    }
                    if(casss.status == 'Routed In Error' && casss.status != firstRoutedInError) {
                        allChildRoutedInError = false;                      
                    }
                }
                //added by shiva to change parent case status to In Progress
                if(inProgressStatus) {
                    caseParent.status = 'In Progress';
                    parentStatusUpdationList.add(caseParent); 
                    continue;
                }
                if(allChildSameStatus && firstCaseStatus != null) {
                    if(caseParent.status != firstCaseStatus ) {
                        caseParent.status = firstCaseStatus;
                        /*if(caseParent.GEMS_All_Screening_Routed_In_Error__c ) {
                            caseParent.GEMS_All_Screening_Routed_In_Error__c = false;
                        }*/
                        parentStatusUpdationList.add(caseParent);                    
                    }
                }
                if(allChildRoutedInError && firstCaseStatus == null) {
                    caseParent.status = 'Routed In Error';
                    parentStatusUpdationList.add(caseParent);
                    /*if(!caseParent.GEMS_All_Screening_Routed_In_Error__c ) {
                        caseParent.GEMS_All_Screening_Routed_In_Error__c = true;
                        parentStatusUpdationList.add(caseParent); 
                    }*/
                }//End Here             
            }
            if(!parentStatusUpdationList.isEmpty()) {
                updateParentStatus = true;
                update parentStatusUpdationList;
            }   
         }
         
    }
    
/******************************************************************** 
    *    Method Name : parentReleaseToUnderwriterUpdation
    Action
    *   @description :   This method to create Underwriting Cases once all account setup cases release to underwriter
    *   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
 ***************************************************************/
 public static void parentReleaseToUnderwriterUpdation(List<Case> casesList,Map<Id,Case> oldCaseMap) {
    Id accountSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
    Id accountSetupParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
    Id medicalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
    Id dentalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
    Id additionalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
    Id accountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
    Id UWTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('GEMS UW Task Record Type').getRecordTypeId();
    Set<String> setUpRecordTypes = new Set<String>{medicalUnderwritingRecordTypeId,dentalUnderwritingRecordTypeId,additionalUnderwritingRecordTypeId};
        
    List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSScreeningEntitlementName];

    Set<String> completedParentCaseIds = new Set<String>();
    List<Case> parentStatusCompleteUpdationList = new List<Case>();
    Set<String> caseSubmissionIdsSet = new Set<String>();
    Map<Id,Case> casesMap = new Map<Id,Case>();
    Set<Id> maintenanceSubmissionIdSet = new Set<Id>();
    
    Map<Id,List<GEMS_Benefit_Agreement__c>> submissionBaMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
    Map<String,Boolean> underwritingCasesCheckMap = new Map<String,Boolean>();
    Map<String,GEMS_CaseOwnership_MetaData__mdt> screeningAreaMetaDataMap = new Map<String,GEMS_CaseOwnership_MetaData__mdt>();
    Set<String> queueNames = new Set<String>();
    Map<String,Id> groupNameIdMap = new Map<String,Id>();
    //SFDC-4112
    Map<Id,boolean> maintenanceHasDentalBaMap = new Map<Id,boolean>();  // Id: maintenance Submission Case Id; boolean: has dental BA or not
    Map<Id,boolean> submissionHasDentalBaMap = new Map<Id,boolean>();  // Id:Submission Case Id; boolean: has dental BA or not       
    Map<Id,Boolean> submissionAndDentalCheck = new Map<Id,Boolean>(); //Submission Case has Dental Case 
    Map<Id,boolean> submissionHasMedicalBaMap = new Map<Id,boolean>();  // Id:Submission Case Id; boolean: has medical BA or not
    Map<Id,Boolean> submissionAndMedicalCheck = new Map<Id,Boolean>();//Submission Case has Medical Case
    //SFDC-4112    
    try {
        for(case caserec : casesList) {
            if( caserec.status == 'Release Underwriting Complete' && caserec.status != oldCaseMap.get(caserec.Id).status && (caserec.recordTypeId == accountSetupParentRecordTypeId)) {
                System.debug('%%%%% Enter Release Underwriting Complete');
                caseSubmissionIdsSet.add(caserec.GEMS_Account_Submission_Info__c); 
                parentStatusCompleteUpdationList.add(caserec);
                // SFDC-5335 Account Structure Maintenance - Account Setup Process case - This maintenanceSubmissionIdSet below will be used to get the Structure cases and their BA's
                // SFDC-5760 Rate Change Maintenance - Account Setup Process: page layout and functionality
                if(caserec.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeASM){
                    maintenanceSubmissionIdSet.add(caserec.GEMS_Account_Submission_Info__c);
                }                   
                    //US 6702 Checking Submission sub type before creating Dental Underwriting
                else if(caserec.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeRCM && (caserec.GEMS_Submission_Sub_Type__c == GEMS_Constants.SubmissionTypeRCMSubType)||(caserec.GEMS_Submission_Sub_Type__c == GEMS_Constants.SubmissionTypeRCMSubTypeStopLoss)){
                    maintenanceHasDentalBaMap.put(caserec.GEMS_Account_Submission_Info__c, true);
                }    
            }
        }
        // SFDC-5335, add below if-block to obtain dental BAs for structure maintenance Setup case because they don't have values in GEMS_Products__c field
        if(!maintenanceSubmissionIdSet.isEmpty()){
            // There are maintenance cases, get their BA's to see if there are any dental BAs
            // SFDC-5815 Modified query to get product category from associated plan
            // SFDC-4244 Added new field filter for selected BA
            List<case> structureCaseList = [select id,GEMS_Account_Submission_Info__c, (select id, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true)  from case where GEMS_Account_Submission_Info__c in :maintenanceSubmissionIdSet and type = 'Account Structure'];
            if( ! structureCaseList.isEmpty()){
                for(Case structureCase : structureCaseList){
                    boolean hasDentalBa = false;
                    for(GEMS_Benefit_Agreement__c ba : structureCase.GEMS_Benefit_Agreements__r)
                        // SFDC-5815 Check for dental product category in both product & plan in BA
                        if(ba.Product__r.Product_Category__c == 'Dental' || ba.Plan__r.Product__r.Product_Category__c == 'Dental'){
                           hasDentalBa = true;
                           maintenanceHasDentalBaMap.put(structureCase.GEMS_Account_Submission_Info__c, hasDentalBa);
                           System.debug('maintenanceHasDentalBaMap: submissionID=' + structureCase.GEMS_Account_Submission_Info__c + ', hasDentalBa=' + hasDentalBa);
                        }
                }
            }
        }
        if(!caseSubmissionIdsSet.isEmpty()) {
            //SFDC-4112
            //Create a map submission has dental BA
            List<case> structureCaseList = [select id,GEMS_Account_Submission_Info__c, (select id, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true)  from case where GEMS_Account_Submission_Info__c in :caseSubmissionIdsSet and type = 'Account Structure'];
            if(!structureCaseList.isEmpty()){
                for(Case structureCase : structureCaseList){
                    boolean hasDentalBa = false;
                    boolean hasMedicalBa = false;
                    for(GEMS_Benefit_Agreement__c ba : structureCase.GEMS_Benefit_Agreements__r){
                        if(ba.Product__r.Product_Category__c == 'Dental' || ba.Plan__r.Product__r.Product_Category__c == 'Dental'){
                           hasDentalBa = true;
                           submissionHasDentalBaMap.put(structureCase.GEMS_Account_Submission_Info__c, hasDentalBa);
                        }
                        else if((ba.Product__r.Product_Category__c != 'Dental' || ba.Plan__r.Product__r.Product_Category__c != 'Dental')){  
                           hasMedicalBa = true;                         
                           submissionHasMedicalBaMap.put(structureCase.GEMS_Account_Submission_Info__c,hasMedicalBa);
                        }  
                    }
               }
            }
            //SFDC-4112
            List<Case> underwriterCasesInsertList = new List<Case>();
            Map<String,Case> submissionIdAndCase = new Map<String,Case>();
            List<Case> submissionCasesList = [select GEMS_Submission_Type__c,id,ownerId,GEMS_Submission_Sub_Type__c,Funding_Type_Multiselect__c,GEMS_StdCust_Product__c, GEMS_Rx_Vendor__c,GEMS_Line_of_Business__c,GEMS_Are_commissions_changing__c, GEMS_Are_commissions_paid_for_account__c,GEMS_POR_BOB__c,
            casenumber,GEMS_Products__c,Account.name,Account.External_ID__c, (select id,casenumber from cases1__r where recordTypeId in :setUpRecordTypes ) from case where id In : caseSubmissionIdsSet  ];
            Set<String> underwritingCases = new Set<String>{'Medical Underwriting','Dental Underwriting'};
            List<GEMS_CaseOwnership_MetaData__mdt> ownerShipMetaDataList = [select Type_Of_Case__c, Case_Team_Member__c, Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c IN : underwritingCases];
            
            //Owner Info to Assign Case
            for(GEMS_CaseOwnership_MetaData__mdt ownershipMetaData : ownerShipMetaDataList) {
                if(ownershipMetaData.Que_Name__c != null) {
                    queueNames.add(ownershipMetaData.Que_Name__c);
                }
                screeningAreaMetaDataMap.put(ownershipMetaData.Type_Of_Case__c,ownershipMetaData);
            }
            
            List<Group> groupppList = [select Id,name from Group where Name in : queueNames and Type = 'Queue'];
            for(Group group_rec : groupppList) {
                groupNameIdMap.put(group_rec.name,group_rec.Id);
            }
            
            for(Case submissionCase : submissionCasesList) {
                submissionIdAndCase.put(submissionCase.Id,submissionCase);
                //Addition UW Check
                if(submissionCase.cases1__r != null && !(submissionCase.cases1__r).isEmpty()) {
                    underwritingCasesCheckMap.put(submissionCase.Id,true);
                }else {
                    underwritingCasesCheckMap.put(submissionCase.Id,false);
                }
                //Submission Medical Check
                if(submissionCase.GEMS_Products__c != null && submissionCase.GEMS_Products__c != 'Dental'){
                    submissionAndMedicalCheck.put(submissionCase.Id,true);
                }
                else{
                    submissionAndMedicalCheck.put(submissionCase.Id,false);
                }
                //Maintenance Medical Check with no GEMS Products
                if(submissionCase.GEMS_Submission_Type__c!=null && submissionCase.GEMS_Submission_Type__c.containsIgnoreCase('Maintenance')){
                    //SFDC-4112 MUW Creation For Maitenance Case Scenario
                    submissionAndMedicalCheck.put(submissionCase.Id,true);
                    //SFDC-4112 
                }
                //Dental Check
                if(submissionCase.GEMS_Products__c != null && !submissionHasDentalBaMap.isEmpty() && submissionHasDentalBaMap.get(submissionCase.id) && submissionCase.GEMS_Products__c.contains('Dental')) {//Checking both GEMS Product and Dental BA
                    submissionAndDentalCheck.put(submissionCase.Id,true);
                } 
                // SFDC-5335, below else-if is to pick up Structure Maintenance case if it has dental BA because they don't have values in GEMS_Products__c field
                else if(maintenanceHasDentalBaMap.get(submissionCase.id) != null && maintenanceHasDentalBaMap.get(submissionCase.id)){
                    submissionAndDentalCheck.put(submissionCase.Id,true);
                }else {
                    submissionAndDentalCheck.put(submissionCase.Id,false);
                }
            }
            
            Map<Id,Map<String,CaseTeamMember>> caseTeamMemberMap = new Map<Id,Map<String,CaseTeamMember>>();
            Map<Id,CaseTeamMember> caseWithAdditionalUnderwriterMap = new Map<Id,CaseTeamMember>();
            
            List<CaseTeamMember> caseTeamList = [select parentId,memberid,TeamRole.name from caseteammember where parentId In : caseSubmissionIdsSet and TeamRole.name In ('Medical Underwriter','Underwriter','Dental Underwriter','Additional Underwriter')];
            if(caseTeamList != null && !caseTeamList.isEmpty()) {
                for(CaseTeamMember teamMember : caseTeamList) {
                    // SFDC-5335, add "! maintenanceSubmissionIdSet.contains(teamMember.parentId)" because Account Structure Maintenance cases do not create any downstream Additional Underwriting cases
                    if(teamMember.TeamRole.name == 'Additional Underwriter' && ! maintenanceSubmissionIdSet.contains(teamMember.parentId)) {
                        caseWithAdditionalUnderwriterMap.put(teamMember.parentId,teamMember );
                    }
                    if(caseTeamMemberMap.get(teamMember.parentId) != null) {
                        caseTeamMemberMap.get(teamMember.parentId).put(teamMember.TeamRole.name,teamMember);
                    }else {
                        Map<String,CaseTeamMember> caseTeamMapp = new Map<String,CaseTeamMember>();
                        caseTeamMapp.put(teamMember.TeamRole.name,teamMember);
                        caseTeamMemberMap.put(teamMember.parentId,caseTeamMapp);
                    }
                }
            }
            
            List<case> caseList =[Select id, ownerId,GEMS_Account_Submission_Info__c, Sub_Category__c from Case where GEMS_Account_Submission_Info__c = :caseSubmissionIdsSet 
                                  and recordtype.name = 'GEMS Screening' and Sub_Category__c In ('Medical Underwriting Screening','Dental Underwriting Screening')];
            Map<String,String> idUnderwriterScreemingCaseMap = new Map<String,String>();
            Map<String,String> idDentalUnderwriterScreemingCaseMap = new Map<String,String>();
            for(case cs:caseList) {
                if(cs.Sub_Category__c == 'Medical Underwriting Screening') {
                    idUnderwriterScreemingCaseMap.put(cs.GEMS_Account_Submission_Info__c,cs.ownerId);
                }
                if(cs.Sub_Category__c == 'Dental Underwriting Screening') {
                    idDentalUnderwriterScreemingCaseMap.put(cs.GEMS_Account_Submission_Info__c,cs.ownerId);
                }
            }
           
            for(Case case_update : parentStatusCompleteUpdationList) {
                if(underwritingCasesCheckMap.get(case_update.GEMS_Account_Submission_Info__c) == null || (underwritingCasesCheckMap.get(case_update.GEMS_Account_Submission_Info__c) != null && !underwritingCasesCheckMap.get(case_update.GEMS_Account_Submission_Info__c))) {
                   for(String recordTypeId : setUpRecordTypes) {
                    Date effectiveDate = (case_update.GEMS_Case_Effective_Date__c == null ? Date.today() : case_update.GEMS_Case_Effective_Date__c);

                    if(recordTypeId == additionalUnderwritingRecordTypeId  && caseWithAdditionalUnderwriterMap.get(case_update.GEMS_Account_Submission_Info__c) == null ) {
                        continue;
                    }
                    if(!submissionAndDentalCheck.get(case_update.GEMS_Account_Submission_Info__c) && recordTypeId == dentalUnderwritingRecordTypeId) {
                        continue;
                    }
                    //SFDC-4112
                    if(!submissionAndMedicalCheck.get(case_update.GEMS_Account_Submission_Info__c) && recordTypeId == medicalUnderwritingRecordTypeId) {
                        continue;
                    }
                    //SFDC-4112
                    //Create Medical,Dental and Addition UW Cases 
                    Case underwriterCase = new Case();
                    if(recordTypeId == medicalUnderwritingRecordTypeId) {
                        underwriterCase.Type = 'Medical Underwriting';
                        underwriterCase.recordtypeid=medicalUnderwritingRecordTypeId;
                        //SFDC-5927 and SFDC-5333 Notifications for commissions and porbob fields
                        underwriterCase.GEMS_Are_commissions_changing__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).GEMS_Are_commissions_changing__c;
                        underwriterCase.GEMS_Are_commissions_paid_for_account__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).GEMS_Are_commissions_paid_for_account__c;
                        underwriterCase.GEMS_POR_BOB__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).GEMS_POR_BOB__c;
                        if(caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c) != null &&
                            caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Underwriter') != null ) {
                            underwriterCase.ownerId = caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Underwriter').memberid;
                        }else if(caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c) != null &&
                        caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Medical Underwriter') != null ) {
                            underwriterCase.ownerId = caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Medical Underwriter').memberid;
                        }
                        else if (idUnderwriterScreemingCaseMap.containsKey(case_update.GEMS_Account_Submission_Info__c)) {
                             underwriterCase.ownerId = idUnderwriterScreemingCaseMap.get(case_update.GEMS_Account_Submission_Info__c);
                            //underwriterCase.ownerId = casesMap.get(case_update.Id).ownerId;
                        }else if(screeningAreaMetaDataMap.get('Medical Underwriting') != null && screeningAreaMetaDataMap.get('Medical Underwriting').Que_Name__c != null && groupNameIdMap.get(screeningAreaMetaDataMap.get('Medical Underwriting').Que_Name__c) != null) {
                            underwriterCase.ownerId = groupNameIdMap.get(screeningAreaMetaDataMap.get('Medical Underwriting').Que_Name__c);
                        }
                        else underwriterCase.ownerId = userinfo.getuserid(); // ****** REMOVE THIS STATEMENT AFTER CONFIRMING WITH VENU ******//
                        underwriterCase.Subject=submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Account.name+' '+submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Account.External_ID__c+' '+effectiveDate.format()+' Medical Underwriting Process';
                    }
                    if(recordTypeId == dentalUnderwritingRecordTypeId) {
                        underwriterCase.Type = 'Dental Underwriting';
                        underwriterCase.recordtypeid=dentalUnderwritingRecordTypeId;
                        
                        if(caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c) != null &&
                        caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Dental Underwriter') != null ) {
                            underwriterCase.ownerId = caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Dental Underwriter').memberid;
                        }else if(idDentalUnderwriterScreemingCaseMap.containsKey(case_update.GEMS_Account_Submission_Info__c)) {
                            underwriterCase.ownerId = idDentalUnderwriterScreemingCaseMap.get(case_update.GEMS_Account_Submission_Info__c);
                        }else if(screeningAreaMetaDataMap.get('Dental Underwriting') != null && screeningAreaMetaDataMap.get('Dental Underwriting').Que_Name__c != null && groupNameIdMap.get(screeningAreaMetaDataMap.get('Dental Underwriting').Que_Name__c) != null) {
                            underwriterCase.ownerId = groupNameIdMap.get(screeningAreaMetaDataMap.get('Dental Underwriting').Que_Name__c);
                        }
                        underwriterCase.Subject=submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Account.name+' '+submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Account.External_ID__c+' '+effectiveDate.format()+' Dental Underwriting Process';
                    }
                    if(recordTypeId == additionalUnderwritingRecordTypeId) {
                        underwriterCase.Type = 'Additional Underwriting';
                        underwriterCase.recordtypeid=additionalUnderwritingRecordTypeId;
                        if(caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c) != null &&
                        caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Additional Underwriter') != null ) {
                            underwriterCase.ownerId = caseTeamMemberMap.get(case_update.GEMS_Account_Submission_Info__c).get('Additional Underwriter').memberid;
                        }else if(casesMap.get(case_update.Id) != null && casesMap.get(case_update.Id).ownerId != null) {
                            underwriterCase.ownerId = casesMap.get(case_update.Id).ownerId;
                        }
                        underwriterCase.Subject=submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Account.name+' '+submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Account.External_ID__c+' '+effectiveDate.format()+' Additional Underwriting Process';
                    }
                    underwriterCase.Accountid=case_update.AccountId;
                    underwriterCase.GEMS_Submitter__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).ownerId;
                    underwriterCase.parentid = case_update.GEMS_Account_Submission_Info__c;
                    underwriterCase.GEMS_Effective_Date__c=case_update.GEMS_Effective_Date__c;
                    underwriterCase.GEMS_Case_Effective_Date__c = case_update.GEMS_Case_Effective_Date__c;
                    underwriterCase.GEMS_Submission_Type__c= case_update.GEMS_Submission_Type__c;
                    underwriterCase.FSU_Location__c= case_update.FSU_Location__c;
                    underwriterCase.Status='In Progress';
                    underwriterCase.HCSC_Division__c= case_update.HCSC_Division__c;
                    underwriterCase.GEMS_Submission_Sub_Type__c= case_update.GEMS_Submission_Sub_Type__c;
                    underwriterCase.GEMS_Account_Submission_Info__c= case_update.GEMS_Account_Submission_Info__c;
                    underwriterCase.Opportunity_Name__c = case_update.Opportunity_Name__c;
                    // This population is for October Hotfix 2016
                    underwriterCase.Funding_Type_Multiselect__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).Funding_Type_Multiselect__c;                
                    underwriterCase.GEMS_StdCust_Product__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).GEMS_StdCust_Product__c;
                    underwriterCase.GEMS_Rx_Vendor__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).GEMS_Rx_Vendor__c;
                    underwriterCase.GEMS_Line_of_Business__c=submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).GEMS_Line_of_Business__c;
                    underwriterCase.GEMS_Submitter__c = submissionIdAndCase.get(case_update.GEMS_Account_Submission_Info__c).ownerId;
                    if(!activeEntitlement.isEmpty())
                    {
                        System.debug('activeEntitlement===enter into if====>');
                        underwriterCase.EntitlementId = activeEntitlement[0].id;
                    }
                    underwriterCasesInsertList.add(underwriterCase);
                   }
                                                
                }
            }
            
            List<Task> insertTaskList = new List<Task>();
            if(!underwriterCasesInsertList.isEmpty()) {
                insert underwriterCasesInsertList;
                
                System.debug('underwriterCasesInsertList====>'+underwriterCasesInsertList);
                for(Case created_cases : underwriterCasesInsertList) {
                    System.debug('created_cases.OwnerId====>'+created_cases.OwnerId);
                    Task newTask = new Task();
                    newTask.subject = 'Approve Setup in BlueSTAR';
                    newTask.whatId = created_cases.Id;
                    newTask.Priority = 'Normal';
                    newTask.GEMS_Start_Date__c = System.now();                                             
                    //SFDC-3817
                    newTask.recordTypeId = UWTaskRecordTypeId; 
                    newTask.GEMS_Account_Submission_Info__c = created_cases.GEMS_Account_Submission_Info__c;
                    newTask.GEMS_Submission_Sub_Type__c = string.valueOf(created_cases.GEMS_Submission_Sub_Type__c) ;
                    newTask.GEMS_Submission_Type__c = string.valueOf(created_cases.GEMS_Submission_Type__c) ;
                    //SFDC-3817
                    insertTaskList.add(newTask);
                    
                    Task newTask1 = new Task();
                    newTask1.subject = 'Approve Account Paperwork';
                    newTask1.whatId = created_cases.Id;
                    newTask1.Priority = 'Normal';
                    newTask1.GEMS_Start_Date__c = System.now();
                    //SFDC-3817
                    newTask1.recordTypeId = UWTaskRecordTypeId; 
                    newTask1.GEMS_Account_Submission_Info__c = created_cases.GEMS_Account_Submission_Info__c;
                    newTask1.GEMS_Submission_Sub_Type__c =  string.valueOf(created_cases.GEMS_Submission_Sub_Type__c) ;
                    newTask1.GEMS_Submission_Type__c = string.valueOf(created_cases.GEMS_Submission_Type__c) ;
                    //SFDC-3817
                    insertTaskList.add(newTask1);
                    
                    Task newTask2 = new Task();
                    newTask2.subject = 'Approve ASO Billing';
                    newTask2.whatId = created_cases.Id;
                    newTask2.Priority = 'Normal';
                    newTask2.GEMS_Start_Date__c = System.now();                        
                    //SFDC-3817
                    newTask2.recordTypeId = UWTaskRecordTypeId; 
                    newTask2.GEMS_Account_Submission_Info__c = created_cases.GEMS_Account_Submission_Info__c;
                    newTask2.GEMS_Submission_Sub_Type__c = string.valueOf(created_cases.GEMS_Submission_Sub_Type__c) ;
                    newTask2.GEMS_Submission_Type__c = string.valueOf(created_cases.GEMS_Submission_Type__c) ;
                    //SFDC-3817
                    insertTaskList.add(newTask2);
                    if(created_cases.OwnerID != null && !(string.valueOf(created_cases.OwnerID).startsWith('00G'))) 
                    {
                        newTask.ownerId = newTask1.ownerId = newTask2.ownerId = created_cases.OwnerId;
                    }
                }
                if(!insertTaskList.isEmpty()) {
                    insert insertTaskList;
                }
            }
        }
    }catch(Exception ex){
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.parentReleaseToUnderwriterUpdation(List<Case> newCaseList,Map<Id,Case> oldCaseMap)','High');              
    } 
} 
        
/******************************************************************** 
*    Method Name : incrementCaseNumber
Action
*   @description :   This method to increment case number for GEMS_Lead_Number__c for SBC cases round robin methodology
*   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
*   @return type :   void
***************************************************************/
public static void incrementCaseNumber(List<Case> casesList) {
    Id sbcRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();  
    List<Case> sbcCases = new List<Case>();
    Set<String> submissionCaseIds = new Set<String>();
    Boolean sbcFound = false;
    Map<Id,CaseTeamMember> sbcAnalystMap = new Map<Id,CaseTeamMember>();
    Set<String> sbcQueNames = new Set<String>();
    Map<String,String> divisionQueueMap = new Map<String,String>();
    Map<String,List<GroupMember>> gqueAndMemberMap = new Map<String,List<GroupMember>>();
    for(Case case_new : casesList) {        
        if(sbcRecordTypeId == case_new.recordTypeId ) {
            sbcCases.add(case_new);
            sbcFound = true;
            submissionCaseIds.add(case_new.GEMS_Account_Submission_Info__c);
        }
    }
    if(sbcFound) {
        Long latestSBCCaseNumber = -1;
        //Code changed for Deffect num: #345 to assign sbc case to case team member if SBC analyst 
        //exists in caseteam.                 
        if(!submissionCaseIds.isEmpty()) {
            List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c,HCSC_Division__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='SBC' ];
            if(caseOwnerMetadata != null && !caseOwnerMetadata.isEmpty()) {
                List<caseteammember> sbcAnalystList = [select id,parentId,memberid from caseteammember where TeamRoleId in (select id from caseteamrole where name =: caseOwnerMetadata[0].Case_Team_Member__c) and parentId in : submissionCaseIds];
                for(CaseTeamMember teamMember  : sbcAnalystList) {
                    sbcAnalystMap.put(teamMember.parentId,teamMember);
                }
                for(GEMS_CaseOwnership_MetaData__mdt ownerMetaData : caseOwnerMetadata) {
                    sbcQueNames.add(ownerMetaData.Que_Name__c);
                    divisionQueueMap.put(ownerMetaData.HCSC_Division__c,ownerMetaData.Que_Name__c);
                }
            }
            
        }       
        List<Group> divisionGroupsList = [Select Id, Name,(select UserOrGroupId from GroupMembers) From Group Where Type = 'Queue' and name in :sbcQueNames];
        Map<String,Long> divisionMaxLeadNumber = new Map<String,Long>();
        try {
            AggregateResult[] sbcGroupedResults = [SELECT MAX(GEMS_Lead_Number__c) maxLeadNum, HCSC_Division__c FROM case WHERE (recordtypeId =: sbcRecordTypeId AND GEMS_Lead_Number__c != NULL) GROUP BY HCSC_Division__c ];
            for (AggregateResult ar : sbcGroupedResults)  {
                Decimal maxNum = (Decimal)ar.get('maxLeadNum');
                divisionMaxLeadNumber.put((String)ar.get('HCSC_Division__c'),maxNum.longValue());
            }
            for(Group sbcGroup : divisionGroupsList ) {
                gqueAndMemberMap.put(sbcGroup.name,sbcGroup.GroupMembers);
            }
        }catch(Exception e) {
            latestSBCCaseNumber = -1;
        }          
        for(Case case_sbc : casesList) {
            //if(case_sbc.GEMS_Lead_Number__c != null) 
            if(sbcRecordTypeId == case_sbc.recordTypeId ) {
            try {
            if(sbcAnalystMap.get(case_sbc.GEMS_Account_Submission_Info__c) == null) { 
                if(divisionMaxLeadNumber.get(case_sbc.HCSC_Division__c) != null && divisionMaxLeadNumber.get(case_sbc.HCSC_Division__c) > -1) {
                    latestSBCCaseNumber = divisionMaxLeadNumber.get(case_sbc.HCSC_Division__c);
                }else {
                    latestSBCCaseNumber = -1;
                }
                ++latestSBCCaseNumber;
                //latestSBCCaseNumber = latestSBCCaseNumber+1;
                case_sbc.GEMS_Lead_Number__c = latestSBCCaseNumber;
                List<GroupMember> users_sbc_analysts = gqueAndMemberMap.get(divisionQueueMap.get(case_sbc.HCSC_Division__c));
                if(users_sbc_analysts != null) {
                    Integer roundRobinId = math.MOD(Integer.valueOf(case_sbc.GEMS_Lead_Number__c) ,users_sbc_analysts.size());
                    if(roundRobinId < users_sbc_analysts.size() ) {
                        case_sbc.ownerId = users_sbc_analysts.get(roundRobinId).UserOrGroupId;
                    }
                }
            }else {
                case_sbc.ownerId = sbcAnalystMap.get(case_sbc.GEMS_Account_Submission_Info__c).memberId;
            }
            }catch(Exception e) {
                System.debug('========='+e);
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.incrementCaseNumber(List<Case> casesList)','High');
            }
           }
        }
      
    }
}

/******************************************************************** 
    *   Method Name : createGetCase
    *   @description :   This method to Create Get case when case team contains role 'Client Implementation Consultant'/'Implementer'
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Siva
    ***************************************************************/
public static void createGetCase(List<Case> newCaseList) {
        Id caseGEMSGetRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<String> caseIds = new List<String>();
        List<Case> new_cases_list = new List<Case>();
        try {
        for(Case case_new : newCaseList) {
            if(case_new.recordTypeId == caseAccountSubmissionId && case_new.status == 'New') {
                caseIds.add(case_new.Id);
            }
        }
        if(!caseIds.isEmpty()) {
        List<caseteamrole> caseTeamRoleList = [select id,name from caseteamrole where name in ('Client Implementation Consultant','Implementer')];
        Map<Id,String> roleIdRoleNameMap = new Map<Id,String>();
        for(caseteamrole ctr:caseTeamRoleList) {
            roleIdRoleNameMap.put(ctr.id,ctr.name);
        }
        Boolean implementer = false;
        List<caseteammember> caseTeamMembers = [select id,parentId,memberid,TeamRoleId from caseteammember where TeamRoleId =:roleIdRoleNameMap.keySet() and parentId in : caseIds ];
        Map<Id,caseteammember > caseIdSpecialistTeamMember = new Map<Id,caseteammember >();
        for(caseteammember teamMember: caseTeamMembers) {
            if(roleIdRoleNameMap.containsKey(teamMember.TeamRoleId) && roleIdRoleNameMap.get(teamMember.TeamRoleId) == 'Implementer') {
                caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember);
                implementer = true;
                break;
            }
            else {
                caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember); 
                implementer = true;
            }
        }
        

        if(implementer) {
        List<case> subCaseList = [select id from case where recordtypeid =:caseGEMSGetRecordTypeId and GEMS_Account_Submission_Info__c in :caseIds];
            if(subCaseList.isEmpty() ) {
            for(Case case_new : newCaseList) {
                case newCase = new case();               
                    newCase.GEMS_Account_Submission_Info__c= case_new.id;
                    newCase.parentid = case_new.id;
                    newCase.Accountid = case_new.Accountid;
                    newCase.GEMS_Effective_Date__c = case_new.GEMS_Effective_Date__c;
                    newcase.GEMS_Submission_Type__c = case_new.GEMS_Submission_Type__c;
                    newCase.GEMS_Submission_Sub_Type__c = case_new.GEMS_Submission_Sub_Type__c;
                    newCase.Opportunity_Name__c = case_new.Opportunity_Name__c;
                    if(caseIdSpecialistTeamMember.containsKey(case_new.Id) ) {
                       newCase.ownerId = caseIdSpecialistTeamMember.get(case_new.Id).memberid;
                    }
                    DateTime effectiveDate = case_new.GEMS_Effective_Date__c;                
                    newCase.Subject = case_new.Account_Name__c+' '+ case_new.Account_Number__c +' '+effectiveDate.format('M/d/yyyy')+' GEMS Get';
                    newCase.status = 'In Progress';
                    newCase.parentid = case_new.id;
                    newCase.type = 'GET';
                    newCase.GEMS_Products__c = case_new.GEMS_Products__c;
                    newCase.HCSC_Division__c = case_new.HCSC_Division__c;
                    newCase.GEMS_Line_of_Business__c = case_new.GEMS_Line_of_Business__c;
                    newCase.FSU_Location__c = case_new.FSU_Location__c;
                    newCase.Opportunity_Name__c = case_new.Opportunity_Name__c ;                    
                    newCase.GEMS_AEP_Account__c = case_new.GEMS_AEP_Account__c;
                    newCase.recordTypeId = caseGEMSGetRecordTypeId;
                    newCase.GEMS_Case_Effective_Date__c = case_new.GEMS_Case_Effective_Date__c;   
                    // This population is for October Hotfix 2016
                    newCase.Funding_Type_Multiselect__c = case_new.Funding_Type_Multiselect__c;                
                    newCase.GEMS_StdCust_Product__c = case_new.GEMS_StdCust_Product__c;
                    newCase.GEMS_Rx_Vendor__c = case_new.GEMS_Rx_Vendor__c;
                    newCase.GEMS_Line_of_Business__c=case_new.GEMS_Line_of_Business__c;
                    newCase.GEMS_Submitter__c = case_new.ownerId;
                    
                    new_cases_list.add(newCase);  
                }                           
               }
            }
        if(!new_cases_list.isEmpty()) {
            insert new_cases_list;
        }
        }
      } catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createAccountStructureCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        } 
    }

     /******************************************************************** 
    *   Method Name : createMembershipCase
        Action
    *   @description :   This method to create membership case once all underwriting cases got approved
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
     public static void createMembershipCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        Id caseGEMSMedicalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id caseGEMSAdditionalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
        Id caseGEMSMembershipRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Membership').getRecordTypeId();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<String> caseIds = new List<String>();
        List<Case> new_cases_list = new List<Case>();
        try {
            for(Case case_new : newCaseList) {
                //if((case_new.recordTypeId == caseGEMSMedicalRecordTypeId || case_new.recordTypeId == caseGEMSDentalRecordTypeId || case_new.recordTypeId == caseGEMSAdditionalRecordTypeId )&& case_new.status !=  oldCaseMap.get(case_new.id).status && case_new.isClosed) {
                if((case_new.recordTypeId == caseGEMSMedicalRecordTypeId || case_new.recordTypeId == caseGEMSDentalRecordTypeId || case_new.recordTypeId == caseGEMSAdditionalRecordTypeId )&& case_new.status !=  oldCaseMap.get(case_new.id).status && case_new.status == 'Approved') {
                    caseIds.add(case_new.GEMS_Account_Submission_Info__c);
                }
            }
            if(!caseIds.isEmpty()) {
                List<caseteamrole> caseTeamRoleList = [select id,name from caseteamrole where name in ('Membership Analyst') limit 1];
                Map<Id,String> roleIdRoleNameMap = new Map<Id,String>();
                for(caseteamrole ctr:caseTeamRoleList) {
                    roleIdRoleNameMap.put(ctr.id,ctr.name);
                }
                List<caseteammember> caseTeamMembers = [select id,parentId,memberid,TeamRoleId from caseteammember where TeamRoleId in : roleIdRoleNameMap.keySet() and parentId in : caseIds ];
                Map<Id,caseteammember> caseIdSpecialistTeamMember = new Map<Id,caseteammember >();
                for(caseteammember teamMember: caseTeamMembers) {
                    if(roleIdRoleNameMap.containsKey(teamMember.TeamRoleId) ) {
                        caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember);
                    }
                }
                Group groupId;
                if(caseIdSpecialistTeamMember.isEmpty()) {
                    groupId =[select Id from Group where Name = 'GEMS membership' and Type = 'Queue' limit 1];
                    System.debug('===groupId ='+groupId );
                }
                Set<String> strSet = new Set<String>{caseGEMSMembershipRecordTypeId,caseGEMSMedicalRecordTypeId,caseGEMSAdditionalRecordTypeId,caseGEMSDentalRecordTypeId};
                List<case> subCaseList = [select id,ownerId, recordtypeid, GEMS_StdCust_Product__c ,Funding_Type_Multiselect__c, GEMS_Underwriter_Flag__c, 
                GEMS_Case_Effective_Date__c,Account_Number__c,FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,GEMS_Line_of_Business__c,GEMS_Is_Eligibility_Required__c,
                HCSC_Division__c,Account_Name__c,GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c,GEMS_Rx_Vendor__c ,(select id,RecordTypeId,status,isClosed from Cases1__r where recordtypeid  =:strSet) from case where id = :caseIds];
                Set<String> submissionTypes = new Set<String>();
                Set<String> submissionSubTypes = new Set<String>();
                List<GEMS_Process_Metadata__mdt> processMetaData = null;
               
                for(case subCase : subCaseList) {
                    if(subCase.GEMS_StdCust_Product__c != GEMS_Constants.standardProducts)         //6753 Added 2nd condition in the IF Statement as membership case is created for standard products with all Submission types
                    {
                    if(subCase.GEMS_Submission_Type__c != null) {
                        submissionTypes.add(subCase.GEMS_Submission_Type__c);      
                    }
                    submissionSubTypes.add(subCase.GEMS_Submission_Sub_Type__c);
                    }
                }
                if(!submissionSubTypes.isEmpty() && !submissionTypes.isEmpty()) {
                    processMetaData = GEMS_Utility.retriveCustomMetaDataByProductType(submissionTypes, Label.GEMS_Custom_Products);
                }
                
                    Boolean membershipRec = true;
                    Boolean statusCheck = false;
                    List<Case> caseToCreate = new List<Case>();
                    if(!subCaseList.isEmpty() && subCaseList != null) {
                        
                        for(case mem_case : subCaseList) {
                            if(mem_case.GEMS_Submission_Sub_Type__c != null && (mem_case.GEMS_StdCust_Product__c != GEMS_Constants.standardProducts)) {     //6753 - Added 2nd condition in the IF Statement as membership case is created for standard products with all Submission types
                                String[] submissionSubTypeArray = mem_case.GEMS_Submission_Sub_Type__c.split(';');
                                Set<String> subTypesSet = new Set<String>();
                                for(String subType : submissionSubTypeArray) {
                                    subTypesSet.add(subType);
                                }
                                
                                if(!GEMS_Utility.buildSubmissinCaseBusinessAreaToCreate(processMetaData,subTypesSet,'Membership')){
                                    continue;
                                }
                            }
                            for(case childCase : mem_case.Cases1__r) {
                                if(childCase.recordtypeid == caseGEMSMembershipRecordTypeId) {membershipRec = false;break; }
                                    if(childCase.isClosed && (childCase.recordTypeId == caseGEMSMedicalRecordTypeId || childCase.recordTypeId == caseGEMSDentalRecordTypeId || childCase.recordTypeId == caseGEMSAdditionalRecordTypeId ))
                                        statusCheck = true;
                                    else {statusCheck = false;break;}
                            }
                            //Below Code Updating submission case underwriting flag for october release 2016
                            //6753 - removed an condition subCase.GEMS_StdCust_Product__c != 'Standard Products only' 
                            if(statusCheck && membershipRec) { 
                                caseToCreate.add(mem_case);
                            } /*else if(statusCheck && membershipRec && mem_case.GEMS_Underwriter_Flag__c == false) {
                                mem_case.GEMS_Underwriter_Flag__c = true;
                                new_cases_list.add(mem_case);
                            }*///End Here
                            
                        }
                        
                    }
                    //if(!caseToCreate.isEmpty() || !new_cases_list.isEmpty() ) {
                    if(!caseToCreate.isEmpty() ) {
                        for(Case case_new : caseToCreate) {
                            case newCase = new case();               
                                newCase.GEMS_Account_Submission_Info__c= case_new.id;
                                newCase.parentid = case_new.id;
                                newCase.Accountid = case_new.Accountid;
                                newCase.GEMS_Case_Effective_Date__c = case_new.GEMS_Case_Effective_Date__c;
                                newcase.GEMS_Submission_Type__c = case_new.GEMS_Submission_Type__c;
                                newCase.GEMS_Submission_Sub_Type__c = case_new.GEMS_Submission_Sub_Type__c;
                                if(caseIdSpecialistTeamMember.containsKey(case_new.Id) ) {
                                   newCase.ownerId = caseIdSpecialistTeamMember.get(case_new.Id).memberid;
                                }
                                else { if (groupId != null)newCase.ownerId = groupId.id;}
                                DateTime effectiveDate = case_new.GEMS_Case_Effective_Date__c;                
                                newCase.Subject = case_new.Account_Name__c+' '+ case_new.Account_Number__c +' '+effectiveDate.format('M/d/yyyy')+' GEMS Membership';
                                newCase.status = 'In Progress';
                                newCase.parentid = case_new.id;
                                newCase.type = 'Membership';
                                newCase.GEMS_Products__c = case_new.GEMS_Products__c;
                                newCase.HCSC_Division__c = case_new.HCSC_Division__c;
                                newCase.GEMS_Line_of_Business__c = case_new.GEMS_Line_of_Business__c;
                                newCase.FSU_Location__c = case_new.FSU_Location__c;
                                newCase.Opportunity_Name__c = case_new.Opportunity_Name__c ;                    
                                newCase.GEMS_AEP_Account__c = case_new.GEMS_AEP_Account__c;
                                newCase.recordTypeId = caseGEMSMembershipRecordTypeId;
                                //This update is made to fix US4627
                                newCase.GEMS_Effective_Date__c = case_new.GEMS_Effective_Date__c;
                                // This population is for October Hotfix 2016
                                newCase.Funding_Type_Multiselect__c = case_new.Funding_Type_Multiselect__c;                
                                newCase.GEMS_StdCust_Product__c = case_new.GEMS_StdCust_Product__c;
                                newCase.GEMS_Rx_Vendor__c = case_new.GEMS_Rx_Vendor__c;
                                newCase.GEMS_Line_of_Business__c=case_new.GEMS_Line_of_Business__c;
                                newCase.GEMS_Submitter__c = case_new.ownerId;
                                newCase.GEMS_Is_Eligibility_Required__c = case_new.GEMS_Is_Eligibility_Required__c;
                                
                                new_cases_list.add(newCase);
                                //Below Code Updating submission case underwriting flag for october release 2016
                                /*case_new.GEMS_Underwriter_Flag__c = true;
                                new_cases_list.add(case_new);*/
                                //End Here  
                            }                           

                    List<Task> taskInsertList = new List<Task>();
                    Database.UpsertResult[] childSaveResult;   
                    if(!new_cases_list.isEmpty()) {
                    childSaveResult = Database.upsert(new_cases_list);
                }
                integer i = 0;
                if(childSaveResult != null) {
                System.debug('======creating task for membership======');
                    for(Database.UpsertResult sr:childSaveResult) {
                        if(sr.isSuccess())
                        {
                            Case childRecord = new_cases_list.get(i);
                            //Below Code change for october release 2016
                            /*if(childRecord.recordTypeId == caseAccountSubmissionId) {
                                i++;
                                continue;
                            }*/
                            //End Here
                            Task memTask= new Task();                        
                            memTask.WhatId=childRecord.Id;
                            memTask.Subject='Membership Entry Complete';
                            memTask.Status='In Progress';
                            memTask.Priority='Normal';
                            memTask.GEMS_Start_Date__c = System.now();
                            System.debug('childRecord.GEMS_Account_Submission_Info__c===>'+childRecord.GEMS_Account_Submission_Info__c);
                            if(childRecord.ownerId == null && caseIdSpecialistTeamMember.get(childRecord.GEMS_Account_Submission_Info__c) != null) {
                                memTask.ownerId = caseIdSpecialistTeamMember.get(childRecord.GEMS_Account_Submission_Info__c).memberid;
                            }else if(childRecord.ownerId != null && !(string.valueOf(childRecord.OwnerID).startsWith('00G')) ) {
                                memTask.ownerId = childRecord.ownerId;
                            }
                            taskInsertList.add(memTask);
                        }
                        i++;
                    }
                    }
                if(!taskInsertList.isEmpty())
                Database.insert(taskInsertList);
            } 
        }
    }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createMembershipCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
    } 
}

 
    /******************************************************************** 
    *   Method Name : createDentalBenefitCodingCase
    *   Action
    *   @description :   This method to create Dental Benefit Coding case once dental & medical (if present) underwriting cases got approved
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   Luke Chen             06/09/2017             SFDC-3376 Dental Benefit Coding case change
    ***************************************************************/
   public static void createDentalBenefitCodingCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        Id caseGEMSMedicalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id dentalCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
       // Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseGEMSScreeningId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        Set<Id> strSet = new Set<Id>{caseGEMSMedicalRecordTypeId,caseGEMSDentalRecordTypeId,dentalCodingRecordTypeId};
        Set<Id> caseIds = new Set<Id>();
        List<Case> new_cases_list = new List<Case>();

        for(Case case_new : newCaseList) {
            if((case_new.recordTypeId == caseGEMSMedicalRecordTypeId || case_new.recordTypeId == caseGEMSDentalRecordTypeId ) && 
                 (case_new.status == GEMS_Constants.StatusApproved || case_new.status == GEMS_Constants.StatusRouteErr) &&  oldCaseMap.get(case_new.id).status != 'Approved') {
                if( !caseIds.contains(case_new.GEMS_Account_Submission_Info__c)) caseIds.add(case_new.GEMS_Account_Submission_Info__c);
            }
        }
        if(caseIds.isEmpty()) return; // no cases to process, return

        try{
            // get the submission cases and their child cases of Medical UW, Dental UW & Dental Coding
            List<case> subCaseList = [select id,ownerId, Account.name, Account.External_ID__c, GEMS_Line_of_Business__c,GEMS_Rx_Vendor__c,parentid,Accountid,GEMS_Effective_Date__c,GEMS_Case_Effective_Date__c,
                       GEMS_Submission_Type__c,FSU_Location__c,HCSC_Division__c,GEMS_Submission_Sub_Type__c,GEMS_StdCust_Product__c,Funding_Type_Multiselect__c,GEMS_Products__c,Opportunity_Name__c ,
                       (select id,RecordTypeId,status,ownerid,owner.type,GEMS_Account_Submission_Info__c, GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c from Cases1__r where recordtypeid in :strSet or (recordtypeid =: caseGEMSScreeningId and Sub_Category__c = 'Dental Benefit Coding Screening')),
                        (select id,parentid, memberid, teamroleid from TeamMembers WHERE TeamRole.name='Dental Benefit Coder') from case where id in :caseIds];                       
             Map<Id,Id> screeningCasesMapToCheckOwner = new Map<Id,Id>();
             List<case> screeningNotApprovedCases = new List<Case>();
            List<Case> subCaseToCreateDental = new List<Case>();
            for(case oneSubCase : subCaseList){
                // SFDC-4262 Create Dental Benefit Coding cases for some scenarios when standard products only is selected
                if( !isSubmissionOKToHaveDentalCodingCases(oneSubCase)) continue;
                
                boolean dentalOk = false, medicalOk = true;
                for(case childCase : oneSubCase.Cases1__r) {
                    if(childCase.recordtypeid == dentalCodingRecordTypeId){
                        // Dental Benefit Coding exists, no need for this submission case to create
                        dentalOk = false;
                        break;
                      // SFDC-8279 Check for Routed In Error status.  
                    } else if(childCase.recordtypeid == caseGEMSMedicalRecordTypeId){
                        if(childCase.status == GEMS_Constants.StatusApproved || childCase.status == GEMS_Constants.StatusRouteErr) medicalOk = true;
                        else medicalOk = false;
                    }else if (childCase.recordtypeid == caseGEMSDentalRecordTypeId){
                        if(childCase.status == GEMS_Constants.StatusApproved || childCase.status == GEMS_Constants.StatusRouteErr) dentalOk = true;
                        else dentalOk = false;                      
                    }else if (childCase.recordtypeid == caseGEMSScreeningId){  //US-6960 - GEMS: DB Coding - Route DB Coding Cases to the DB Coding Screener, not the Queue
                        if(childCase.Status == GEMS_Constants.StatusRouteErr && childCase.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c != 'Standard Products only')
                            screeningNotApprovedCases.add(childCase);
                        else{
                            if(childCase.owner.type==GEMS_Constants.ownerTypeUser && childCase.GEMS_Account_Submission_Info__r.GEMS_StdCust_Product__c != 'Standard Products only')
                            screeningCasesMapToCheckOwner.put(childCase.GEMS_Account_Submission_Info__c,childCase.OwnerId);
                        }
                    }   //End of US-6960
                 }
                if(dentalOk && medicalOk) subCaseToCreateDental.add(oneSubCase);
            }
            if(subCaseToCreateDental.isEmpty()) return; // no cases to process, return
            //SFDC-5725 Do not create Dental Benefit Coding Case without screening
            
            if(!screeningNotApprovedCases.isEmpty()) return; 
            //End of SFDC-5725
            
            List<Case> parentDentalCodingCasesToCreate = new List<Case>();
            
            Group DentalCodingQueueGroup = [select Id from Group where Name = 'GEMS Dental Coder Queue' and Type = 'Queue' limit 1];
            // create and add parent dental case
            // US- 6960 Edited the 3rd parameter in the below method invocation
            for(case oneSubCase : subCaseToCreateDental)
                parentDentalCodingCasesToCreate.add(createDentalBenefitCodingCase(oneSubCase, false, (screeningCasesMapToCheckOwner.containsKey(oneSubCase.Id))?screeningCasesMapToCheckOwner.get(oneSubCase.Id):DentalCodingQueueGroup.id, null, oneSubCase.id));
            
            // insert parent cases
            if( !parentDentalCodingCasesToCreate.isEmpty() ) insert parentDentalCodingCasesToCreate;
            else return; // if no parent case, there is not child case
            
            // need BAs from structure cases for Standard Products only
            // SFDC-4244 Added new field filter for selected BA
            List<case> structureCaseList = [select id,GEMS_Account_Submission_Info__c, (select id, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true)  from case where GEMS_Account_Submission_Info__c in :caseIds and type = 'Account Structure'];
            // need screening cases for both standard/custom & custom products
            List<case> SubmissionWithSreeningCaseList = [select id,
                       (select id,status,GEMS_Benefit_Agreement__c from Cases1__r where Sub_Category__c = 'Dental Benefit Coding Screening' and GEMS_Benefit_Agreement__c != null) from case where id in :caseIds];
            // Below Map instances are for look up purpose to create BA level dental coding cases
            // submissionToStructureMap to be used to get BAs
            // submissionToSubmissionWithScreeningMap to be used to check the corresponding BA screening approved or not
            // submissionToDentalParentMap to be used to check if parent case is created, if not, no BA level to create
            Map<Id,Case> submissionToStructureMap = new Map<Id,Case>();
            Map<Id,Case> submissionToSubmissionWithScreeningMap = new Map<Id,Case>();
            Map<Id,Case> submissionToDentalParentMap = new Map<Id, Case>();
            if(structureCaseList != null && !structureCaseList.isEmpty())
                for(Case oneStructureCase : structureCaseList)
                    submissionToStructureMap.put(oneStructureCase.GEMS_Account_Submission_Info__c, oneStructureCase);
            if(SubmissionWithSreeningCaseList != null && !SubmissionWithSreeningCaseList.isEmpty())
                for(Case oneSubScreenCase : SubmissionWithSreeningCaseList)
                    submissionToSubmissionWithScreeningMap.put(oneSubScreenCase.id, oneSubScreenCase);
            for(Case oneDentalParent : parentDentalCodingCasesToCreate)
                submissionToDentalParentMap.put(oneDentalParent.GEMS_Account_Submission_Info__c, oneDentalParent);
            
            List<Case> childDentalCodingCasesToCreate = new List<Case>();
            
            for(case oneSubCase : subCaseList){
                if(submissionToDentalParentMap.get(oneSubCase.id) == null) continue; // no parent dental coding case, no child to create
                // #Luke
                // If Standard Products only, use GEMS_Benefit_Agreement__c.Product__r.Product_Category__c == 'Dental' to create BA level dental benefit coding case
                // else use BA's 'Dental Benefit Coding Screening' case to create BA level dental benefit coding case               
                if(oneSubCase.GEMS_StdCust_Product__c == 'Standard Products only'){
                    // Standard Products only, use BAs
                    Case structureCase = submissionToStructureMap.get(oneSubCase.id);
                    for(GEMS_Benefit_Agreement__c ba : structureCase.GEMS_Benefit_Agreements__r) {
                        
                        // SFDC-5815 To look for dental product category in both plan and product of BA's
                        if(ba.Product__r.Product_Category__c == 'Dental' || ba.Plan__r.Product__r.Product_Category__c == 'Dental') {
                            childDentalCodingCasesToCreate.add(createDentalBenefitCodingCase(oneSubCase, true, DentalCodingQueueGroup.id, ba.id, submissionToDentalParentMap.get(oneSubCase.id).id));
                            System.debug('Added dental coding');
                        }
                    }
                }else{
                    // standard/custom & custom products, use Screenig cases
                    // US- 6960 Edited the 3rd parameter in the below method invocation
                    for(Case screeningCase : submissionToSubmissionWithScreeningMap.get(oneSubCase.id).Cases1__r){
                        if(screeningCase.Status == 'Approved')
                            childDentalCodingCasesToCreate.add(createDentalBenefitCodingCase(oneSubCase, true, (screeningCasesMapToCheckOwner.containsKey(oneSubCase.Id))?screeningCasesMapToCheckOwner.get(oneSubCase.Id):DentalCodingQueueGroup.id, screeningCase.GEMS_Benefit_Agreement__c, submissionToDentalParentMap.get(oneSubCase.id).id));
                    }
                }
            }
            // create child Dental Benefit coding cases
            if( !childDentalCodingCasesToCreate.isEmpty() ) insert childDentalCodingCasesToCreate;
            
        }catch(Exception ex){
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createDentalBenefitCodingCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        }       
    }
    
    // This method is to check for Standard Product if OK to have dental benefit coding case
    private static boolean isSubmissionOKToHaveDentalCodingCases(Case oneSubCase){
        if( oneSubCase.GEMS_StdCust_Product__c != 'Standard Products only') return true;
        if( oneSubCase.GEMS_Submission_Type__c == null ) return false;
        if( oneSubCase.GEMS_Submission_Type__c.contains('New Account')) return true;
        if( oneSubCase.GEMS_Submission_Sub_Type__c == null ) return false;
        if( (oneSubCase.GEMS_Submission_Type__c.contains('Renewal') || oneSubCase.GEMS_Submission_Type__c.contains('Off Cycle')) &&
                (oneSubCase.GEMS_Submission_Sub_Type__c.contains('Account Structure Change') ||
                 oneSubCase.GEMS_Submission_Sub_Type__c.contains('Funding Change') ||
                 oneSubCase.GEMS_Submission_Sub_Type__c.contains('Benefit Change') ||
                 oneSubCase.GEMS_Submission_Sub_Type__c.contains('Eligibility Change'))) return true;
        return false;
    }
    
    // This method is to create a parent or child dental benefit coding case
    private static Case createDentalBenefitCodingCase(Case submissionCase, boolean isBaLevel, Id dentalCodingQueueId, id BaId, id parentId){
        Id dentalCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Id dentalBALevelCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId();       
        Case dentalCodingCase = new Case();
        if( isBaLevel ){
            dentalCodingCase.GEMS_Benefit_Agreement__c = BaId;
            dentalCodingCase.Subject = submissionCase.Account.name +' '+ submissionCase.Account.External_ID__c+' '+ ((DateTime) submissionCase.GEMS_Effective_Date__c).format('M/d/yyyy')+ ' BA Level Dental Benefit Coding';   
            dentalCodingCase.recordtypeid = dentalBALevelCodingRecordTypeId;
        }else{
            dentalCodingCase.Subject = submissionCase.Account.name +' '+ submissionCase.Account.External_ID__c+' '+ ((DateTime) submissionCase.GEMS_Effective_Date__c).format('M/d/yyyy')+' Dental Benefit Coding';
            dentalCodingCase.recordtypeid = dentalCodingRecordTypeId;
        }

        // SFDC-6830 Set active entitlement Id to DBC during creation
        List <Entitlement> activeEntitlements = GEMS_Utility.entitlements;
        Id entId = null;
        if (null != activeEntitlements && !activeEntitlements.isEmpty()) {
            entId = activeEntitlements[0].Id;
        }
        // SFDC-6830 end
        
        dentalCodingCase.Status='In Progress';
        dentalCodingCase.parentid = parentId;
        dentalCodingCase.Type = 'Dental Benefit Coding';
        dentalCodingCase.GEMS_Line_of_Business__c = submissionCase.GEMS_Line_of_Business__c;
        dentalCodingCase.GEMS_Rx_Vendor__c = submissionCase.GEMS_Rx_Vendor__c;                        
        dentalCodingCase.Accountid=submissionCase.Accountid;
        dentalCodingCase.GEMS_Effective_Date__c=submissionCase.GEMS_Effective_Date__c;
        dentalCodingCase.GEMS_Case_Effective_Date__c = submissionCase.GEMS_Case_Effective_Date__c;
        dentalCodingCase.GEMS_Submission_Type__c=submissionCase.GEMS_Submission_Type__c;
        dentalCodingCase.FSU_Location__c=submissionCase.FSU_Location__c;
        dentalCodingCase.HCSC_Division__c=submissionCase.HCSC_Division__c;
        dentalCodingCase.GEMS_Account_Submission_Info__c=submissionCase.id;
        dentalCodingCase.GEMS_Submitter__c = submissionCase.ownerId;
        dentalCodingCase.GEMS_StdCust_Product__c  = submissionCase.GEMS_StdCust_Product__c;
        dentalCodingCase.Funding_Type_Multiselect__c = submissionCase.Funding_Type_Multiselect__c; 
        dentalCodingCase.GEMS_Products__c = submissionCase.GEMS_Products__c;
        dentalCodingCase.Opportunity_Name__c = submissionCase.Opportunity_Name__c;
        // SFDC-6830 Set active entitlement Id to DBC during creation
        dentalCodingCase.EntitlementId = entId;
        // SFDC-6830 end
        // assign owner
        if(submissionCase.TeamMembers != null && !submissionCase.TeamMembers.isEmpty())
            dentalCodingCase.ownerId = submissionCase.TeamMembers[0].memberid;  // assign to a person
        else
            dentalCodingCase.ownerId = dentalCodingQueueId;  // assign to a queue       
        
        return dentalCodingCase;
    }

   
/******************************************************************** 
    *    Method Name : updateUnderiterCaseOwner
    Action
    *   @description :   This method to send notification when underwriter returns the case with reject reason
    *   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/  
public Static boolean staticExecute = true;     
public static void updateUnderiterCaseOwner(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
    Id caseGEMSMedicalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
    Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
    Id caseGEMSAdditionalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
    List<Id> submissionIds = new List<Id>();
    List<Case> underwritingCases = new List<Case>();
    List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
    Map<Id,Case> subCaseIdAndCaseMap = new Map<Id,Case>();
    try {
        for(Case underwritingCase : newCaseList) {
            if((underwritingCase.recordTypeId == caseGEMSMedicalRecordTypeId || underwritingCase.recordTypeId == caseGEMSDentalRecordTypeId 
            || underwritingCase.recordTypeId == caseGEMSAdditionalRecordTypeId) 
            && underwritingCase.status == 'Return' && underwritingCase.status != oldCaseMap.get(underwritingCase.Id).status) {
                 submissionIds.add(underwritingCase.GEMS_Account_Submission_Info__c);           
            }
        }
        
        if(!submissionIds.isEmpty() && staticExecute) {
            Map<String,CaseTeamMember> submissionIdAndTeamSpecialist = new Map<String,CaseTeamMember>();            
            List<CaseTeamMember>  specialists = [select parentId,memberid,TeamRole.name, member.email from caseteammember where parentId In: submissionIds and TeamRole.name = 'Account Specialist'];
            Map<Id,Case>  specialistsSubmissionMap = new Map<Id,Case>([select Id, ownerId, owner.email, Status, Account.Name from case where Id In: submissionIds ]);
            String sendNotification = System.Label.GEMS_Send_notification_to_underwriter;

            for(CaseTeamMember teamSpecialist : specialists) {
                submissionIdAndTeamSpecialist.put(teamSpecialist.parentId,teamSpecialist);
            }
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            for(Case underwritingCase : newCaseList) {
                if((underwritingCase.recordTypeId == caseGEMSMedicalRecordTypeId || underwritingCase.recordTypeId == caseGEMSDentalRecordTypeId 
                || underwritingCase.recordTypeId == caseGEMSAdditionalRecordTypeId) && underwritingCase.status == 'Return' && underwritingCase.status != oldCaseMap.get(underwritingCase.Id).status )
                 
                 if( underwritingCase.GEMS_Return_Reason__c == 'ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)'  ) {
                     //underwritingCase.GEMS_Returned_user_id__c = underwritingCase.ownerId;
                    underwritingCase.ownerId = submissionIdAndTeamSpecialist.get(underwritingCase.GEMS_Account_Submission_Info__c).memberid;                    

                    if(sendNotification == 'Yes' && !returnUnderWriterNotification) {
                        String[] toAddresses = new String[] {submissionIdAndTeamSpecialist.get(underwritingCase.GEMS_Account_Submission_Info__c).member.email };
                        String emailBody = 'Underwriting has returned the case due to an ASO Billing / BlueSTAR issue </br></br><b>Account Name :</b>' + specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ underwritingCase.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+underwritingCase.Id +'" target="_blank">View Case Details</a></br></br></br>Thanks';
                        messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses,underwritingCase.subject,emailBody,underwritingCase);                        
                        returnUnderWriterNotification = true;
                    }
                 }else if(!underwritingCase.GEMS_Return_Reason__c.contains('ASO Billing/BlueSTAR Issue')) {
                     //underwritingCase.GEMS_Returned_user_id__c = underwritingCase.ownerId;
                    underwritingCase.ownerId = specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).ownerId;

                    if(sendNotification == 'Yes') {
                        String[] toAddresses = new String[] {specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).owner.email};
                        String emailBody1 = 'Underwriting has requested paperwork review </br></br><b>Account Name :</b>' + specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ underwritingCase.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+underwritingCase.Id +'" target="_blank">View Case Details</a></br></br></br>Thanks';
                        messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses,underwritingCase.subject,emailBody1,underwritingCase);                        
                    }
                 }else {
                    //underwritingCase.GEMS_Returned_user_id__c = underwritingCase.ownerId;
                    underwritingCase.ownerId = specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).ownerId;                                        
                    underwritingCase.GEMS_UW_Acct_Sub_Spec_flag__c = true;
                    if(sendNotification == 'Yes') {
                        String[] toAddresses2 = new String[] {specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).owner.email};
                        String emailBody2 = 'Underwriting has requested paperwork review </br></br><b>Account Name :</b>' + specialistsSubmissionMap.get(underwritingCase.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ underwritingCase.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+underwritingCase.Id +'" target="_blank">View Case Details</a></br></br></br>Thanks';
                        messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses2,underwritingCase.subject,emailBody2,underwritingCase);                        
                    }
                 }
            }
            if(!messageList.isEmpty() && sendNotification == 'Yes') {
                Messaging.sendEmail(messageList);
            }
            staticExecute = false ;
        }
    }catch(Exception ex){
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateUnderiterCaseOwner(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
    }
}


    
    class BALevelParentIdWrapper {
        String structureCaseId;
        Case accountSetupParentId;
        Case dentalBenefitCodingParentId;
        Case medicalBenefitCodingParentId;
        Case pharmacyCodingParentId;
        Case sbcParentId;
    }
        /******************************************************************** 
    *   Method Name : updateOwnerToBenefitCoderFeekReceived
    *   @description :   This method to Create Fsu Claims case when Medical Benefit coding case status becomes 'Medical Benefits Production Ready'
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Praveen
    ***************************************************************/
        public static void createFSUClaimsCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        Id caseGEMSFSUClaimsRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Id caseGEMSBALevelMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        List<Id> accSubcaseIds = new List<Id>();
        List<Case> new_cases_list = new List<Case>();
        try {
            for(Case case_new : newCaseList) {
                if(case_new.recordTypeId == caseGEMSMedicalBenfCodingRecordTypeId && case_new.status !=  oldCaseMap.get(case_new.id).status && case_new.status =='Medical Benefits Production Ready') {
                    accSubcaseIds.add(case_new.GEMS_Account_Submission_Info__c);
                }
            }
            if(!accSubcaseIds.isEmpty()) {
                Set<String> strSet = new Set<String>{caseGEMSFSUClaimsRecordTypeId,caseGEMSMedicalBenfCodingRecordTypeId,caseGEMSBALevelMedicalBenfCodingRecordTypeId};
                List<case> subCaseList = [select id, Status, recordtypeid, GEMS_Accum_Type__c, GEMS_Account_Submission_Info__c,GEMS_Rx_Vendor__c,ownerId, 
                                            GEMS_Case_Effective_Date__c,Account_Number__c,FSU_Location__c,GEMS_AEP_Account__c,GEMS_StdCust_Product__c,
                                            Opportunity_Name__c,GEMS_Products__c,GEMS_Line_of_Business__c,HCSC_Division__c,Funding_Type_Multiselect__c,
                                            Account_Name__c,GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,
                                            GEMS_Submission_Type__c ,
                                                (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c from Cases1__r 
                                                where recordtypeid  =:strSet),
                                                (select parentId,memberid,TeamRole.name from TeamMembers
                                                where TeamRole.name ='Claims Analyst')
                                            from case where id = :accSubcaseIds];
                Map<Id,Case> subCaseIdSubCaseRecMap = new Map<Id,Case>();
                Map<Id, caseTeamMember> subIdFSUAnalystMemberMap = new Map<Id, caseTeamMember>();
                Group fsuClaimsGroup =[select Id from Group where Name = 'GEMS Claims Queue' and Type = 'Queue' LIMIT 1];
                for(Case subCaseRec: subCaseList)
                {
                    subCaseIdSubCaseRecMap.put(subCaseRec.Id,subCaseRec);
                    if(!subCaseRec.TeamMembers.isEmpty())
                    {
                        subIdFSUAnalystMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers);
                    }
                }
                    System.debug('subIdFSUAnalystMemberMap=====>' +subIdFSUAnalystMemberMap);
                    Boolean FSUClaimsFound = false;
                    List<Case> caseToCreate = new List<Case>();
                    if(!subCaseList.isEmpty() && subCaseList != null) {
                        for(case caseRec : subCaseList) {
                            for(case childCase : caseRec.Cases1__r) {
                                if(childCase.recordtypeid == caseGEMSFSUClaimsRecordTypeId) {
                                    FSUClaimsFound = true;
                                    break; 
                                }
                                if(childCase.recordtypeid == caseGEMSMedicalBenfCodingRecordTypeId && childCase.Status=='Medical Benefits Production Ready' && !FSUClaimsFound)
                                {
                                    caseToCreate.add(caseRec);
                                }
                            }
                        }
                        
                    }
                    if(!caseToCreate.isEmpty() && !FSUClaimsFound ) {
                        for(Case case_new : caseToCreate) {
                            case newCase = new case();               
                                //newCase.GEMS_Account_Submission_Info__c= case_new.GEMS_Account_Submission_Info__c;
                                newCase.GEMS_Account_Submission_Info__c = case_new.id;
                                if(subIdFSUAnalystMemberMap.get(case_new.id)!=null)
                                {
                                    newCase.ownerId=subIdFSUAnalystMemberMap.get(case_new.id).memberid;
                                }
                                else
                                {
                                    newCase.ownerId=fsuClaimsGroup.Id;
                                }
                                newCase.Accountid = case_new.Accountid;
                                newCase.Opportunity_Name__c=case_new.Opportunity_Name__c;
                                newCase.GEMS_Effective_Date__c = case_new.GEMS_Effective_Date__c;
                                newcase.GEMS_Submission_Type__c = case_new.GEMS_Submission_Type__c;
                                newCase.GEMS_Submission_Sub_Type__c = case_new.GEMS_Submission_Sub_Type__c;
                                DateTime effectiveDate = case_new.GEMS_Effective_Date__c;                
                                newCase.Subject = case_new.Account_Name__c+' '+ case_new.Account_Number__c +' '+effectiveDate.format('M/d/yyyy')+' FSU Claims';
                                newCase.status = 'In Progress';
                                newCase.type = 'FSU Claims';
                                newCase.GEMS_Products__c = case_new.GEMS_Products__c;
                                newCase.HCSC_Division__c = case_new.HCSC_Division__c;
                                newCase.FSU_Location__c = case_new.FSU_Location__c;
                                newCase.recordTypeId = caseGEMSFSUClaimsRecordTypeId;
                                newCase.GEMS_Case_Effective_Date__c = case_new.GEMS_Case_Effective_Date__c; 
                                // This population is for October Hotfix 2016
                                newCase.Funding_Type_Multiselect__c = case_new.Funding_Type_Multiselect__c;                
                                newCase.GEMS_StdCust_Product__c = case_new.GEMS_StdCust_Product__c;
                                newCase.GEMS_Rx_Vendor__c = case_new.GEMS_Rx_Vendor__c;
                                newCase.GEMS_Line_of_Business__c=case_new.GEMS_Line_of_Business__c;
                                newCase.GEMS_Submitter__c = case_new.ownerId;
                                
                                new_cases_list.add(newCase);  
                            }                           

                        List<Task> taskInsertList = new List<Task>();
                        Database.SaveResult[] fsuClaimsSaveResult;   
                        if(!new_cases_list.isEmpty()) {
                        fsuClaimsSaveResult = Database.insert(new_cases_list);
                    }
                    integer i = 0;
                    if(fsuClaimsSaveResult != null) {
                        for(Database.SaveResult sr:fsuClaimsSaveResult) {
                            if(sr.isSuccess())
                            {
                                Case childRecord = new_cases_list.get(i);
                                System.debug('childRecord =====>' +childRecord );
                                Case subCaseRec= subCaseIdSubCaseRecMap.get(childRecord.GEMS_Account_Submission_Info__c);
                                System.debug('subcaseReccc =====>' +subCaseRec);
                                if(subCaseRec.GEMS_Accum_Type__c=='Manual and Electronic')
                                {
                                    Task memTask1= new Task();
                                    memTask1.WhatId=childRecord.Id;
                                    memTask1.Subject='Load and Test Benefit Accums';
                                    memTask1.Status='In Progress';
                                    memTask1.Priority='Normal';
                                    memTask1.GEMS_Start_Date__c = System.now();
                                    taskInsertList.add(memTask1);
                                    
                                    Task memTask2= new Task();
                                    memTask2.WhatId=childRecord.Id;
                                    memTask2.Subject='Confirm Accums Tested';
                                    memTask2.Status='Not Started';
                                    memTask2.Priority='Normal';
                                    taskInsertList.add(memTask2);
                                    
                                    Task memTask3= new Task();
                                    memTask3.WhatId=childRecord.Id;
                                    memTask3.Subject='Confirm Production Accums Load';
                                    memTask3.Status='Not Started';
                                    memTask3.Priority='Normal';
                                    taskInsertList.add(memTask3);
                                    
                                    Task memTask4= new Task();
                                    memTask4.WhatId=childRecord.Id;
                                    memTask4.Subject='Release Claims Hold';
                                    memTask4.Status='Not Started';
                                    memTask4.Priority='Normal';
                                    
                                    if(!(string.valueOf(childRecord.OwnerID).startsWith('00G'))) 
                                    {
                                        memTask1.OwnerID = memTask2.OwnerID = memTask3.OwnerID = memTask4.OwnerID = childRecord.OwnerId;
                                    }
                                    /*
                                    else if(childRecord.ownerId != null) 
                                    {
                                        memTask1.OwnerID = memTask2.OwnerID = memTask3.OwnerID = memTask4.OwnerID = childRecord.ownerId;
                                    }
                                    */
                                    taskInsertList.add(memTask4);
                                }
                                if(subCaseRec.GEMS_Accum_Type__c=='Paper/Manual')
                                {
                                    Task memTask1= new Task();
                                    memTask1.WhatId=childRecord.Id;
                                    memTask1.Subject='Load and Test Benefit Accums';
                                    memTask1.Status='In Progress';
                                    memTask1.Priority='Normal';
                                    memTask1.GEMS_Start_Date__c = System.now();
                                    taskInsertList.add(memTask1);
                                    
                                    Task memTask4= new Task();
                                    memTask4.WhatId=childRecord.Id;
                                    memTask4.Subject='Release Claims Hold';
                                    memTask4.Status='Not Started';
                                    memTask4.Priority='Normal';
                                    
                                    if(!(string.valueOf(childRecord.OwnerID).startsWith('00G'))) 
                                    {
                                        memTask1.OwnerID = memTask4.OwnerID = childRecord.ownerid;
                                    }
                                    /*
                                    else if(childRecord.ownerId != null) 
                                    {
                                        memTask1.OwnerID = memTask4.OwnerID = childRecord.ownerId;
                                    }
                                    */
                                    taskInsertList.add(memTask4);
                                }
                                if(subCaseRec.GEMS_Accum_Type__c=='Electronic')
                                {
                                    Task memTask2= new Task();
                                    memTask2.WhatId=childRecord.Id;
                                    memTask2.Subject='Confirm Accums Tested';
                                    memTask2.Status='In Progress';
                                    memTask2.GEMS_Start_Date__c = System.now();
                                    memTask2.Priority='Normal';
                                    taskInsertList.add(memTask2);
                                    
                                    Task memTask3= new Task();
                                    memTask3.WhatId=childRecord.Id;
                                    memTask3.Subject='Confirm Production Accums Load';
                                    memTask3.Status='Not Started';
                                    memTask3.Priority='Normal';
                                    taskInsertList.add(memTask3);
                                    
                                    Task memTask4= new Task();
                                    memTask4.WhatId=childRecord.Id;
                                    memTask4.Subject='Release Claims Hold';
                                    memTask4.Status='Not Started';
                                    memTask4.Priority='Normal';
                                    
                                    if(!(string.valueOf(childRecord.OwnerID).startsWith('00G'))) 
                                    {
                                        memTask2.OwnerID = memTask3.OwnerID = memTask4.OwnerID = childRecord.Ownerid;
                                    }
                                    /*
                                    else if(childRecord.ownerId != null) 
                                    {
                                        memTask2.OwnerID = memTask3.OwnerID = memTask4.OwnerID = childRecord.ownerId;
                                    }
                                    */
                                    taskInsertList.add(memTask4);
                                }
                                if(subCaseRec.GEMS_Accum_Type__c=='' || subCaseRec.GEMS_Accum_Type__c==null)
                                {
                                    Task memTask4= new Task();
                                    memTask4.WhatId=childRecord.Id;
                                    memTask4.Subject='Release Claims Hold';
                                    memTask4.Status='In Progress';
                                    memTask4.GEMS_Start_Date__c = System.now();
                                    memTask4.Priority='Normal';
                                    
                                    if(!(string.valueOf(childRecord.OwnerID).startsWith('00G'))) 
                                    {
                                        memTask4.OwnerID = childRecord.Ownerid;
                                    }
                                    /*
                                    else if(childRecord.ownerId != null) 
                                    {
                                        memTask4.OwnerID = childRecord.ownerId;
                                    }
                                    */
                                    taskInsertList.add(memTask4);
                                }
                            }
                            i++;
                        }
                    }
                    if(!taskInsertList.isEmpty())
                    Database.insert(taskInsertList);
                } 
            }
        }catch(Exception ex){
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createFSUClaimsCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        } 
    }
     /******************************************************************** 
    *   Method Name : updateOwnerToBenefitCoderFeekReceived
    *   @description :   This method to Create Id card Parent Child Cases
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Praveen
    ***************************************************************/
    /*public static void createIdCardParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)
    {
        System.debug('=======> into method');
        List<Case> custIdParentCasesInsertList = new List<Case>();
        List<Case> custIdChildCasesInsertList = new List<Case>();
        
        System.debug('Client Approved Received Rec==>'+clientApprovalReceivedCasesList);
        System.debug('subIdListBenfMap==>'+subIdListBenfMap);
        
        Id customIdCardParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Id customIdCardChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId();
        
        Set<ID> subCaseIdsSet = new Set<ID>();
        subCaseIdsSet=subIdListBenfMap.keySet();
        System.debug('subCaseIdsSet========>'+subCaseIdsSet);
        
        //List<Case> subCaseChildCasesList = [SELECT ID, GEMS_Account_Submission_Info__c,RecordTypeId from Case WHERE GEMS_Account_Submission_Info__c IN: subCaseIdsSet];
        /* --------------- //*
        List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
        List<case> subCaseRecChildIDCardCasesList = [select id, Status, recordtypeid, GEMS_Accum_Type__c, 
                                                        GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                        FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                        GEMS_Line_of_Business__c,HCSC_Division__c,Account_Name__c,
                                                        GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                        (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                        from Cases1__r where recordtypeid  =:customIdCardParentRecordTypeId),
                                                        (select parentId,memberid,TeamRole.name from TeamMembers
                                                        where TeamRole.name =: caseOwnerMetadata[0].Case_Team_Member__c)
                                                        from case where id = :subCaseIdsSet];
                                                        
        Map<Id,Boolean> subCaseIdIDCardRecFoundMap = new Map<Id,Boolean>();
        
        Map<Id, caseTeamMember> subIdAccSpecialistMemberMap = new Map<Id, caseTeamMember>();
        Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
                
        Boolean IDCardRecFound = false;
        
        if(!subCaseRecChildIDCardCasesList.isEmpty() && subCaseRecChildIDCardCasesList != null) 
        {
            for(case subCaseRec : subCaseRecChildIDCardCasesList) 
            {
                List<Case> tempCaseList = new List<Case>();
                tempCaseList=subCaseRec.Cases1__r;
                if(!subCaseRec.TeamMembers.isEmpty())
                {
                    subIdAccSpecialistMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                }
                if(tempCaseList.Size()>0)
                {
                    IDCardRecFound=true;
                    subCaseIdIDCardRecFoundMap.put(subCaseRec.Id,IDCardRecFound);
                    break;
                }
                else
                {
                    IDCardRecFound=false;
                    subCaseIdIDCardRecFoundMap.put(subCaseRec.Id,IDCardRecFound);
                }
            }
            
        }
        System.debug('subCaseIdIDCardRecFoundMap ========>'+subCaseIdIDCardRecFoundMap);
        
        for(Case strCaseRec: clientApprovalReceivedCasesList)
        {
            Boolean IDCardCaseRecFound = subCaseIdIDCardRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
            
            System.debug('strCaseRec.GEMS_Account_Submission_Info__c========>'+strCaseRec.GEMS_Account_Submission_Info__c);
            System.debug('IDCardCaseRecFound ========>'+IDCardCaseRecFound);
            
            if(!IDCardCaseRecFound)
            {
                List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                System.debug('Into for loop====>' +strCaseRec);
                DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                Case parentIdCase = new Case();
                parentIdCase.recordTypeId =customIdCardParentRecordTypeId;
                //*
                if(subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c)!=null)
                {
                    parentIdCase.ownerId=subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                }
                //*
                if(benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId != null)
                {
                    parentIdCase.ownerId=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                }
                else
                {
                    parentIdCase.ownerId=accSpecGroup.Id;
                }
                parentIdCase.Subject=benfAggList[0].AccountStructureCase__r.Account.Name+' '+ benfAggList[0].AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' ID Card';
                parentIdCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                parentIdCase.Accountid = strCaseRec.Accountid;
                parentIdCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                parentIdCase.GEMS_Case_Effective_Date__c=strCaseRec.GEMS_Case_Effective_Date__c;
                parentIdCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                parentIdCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                parentIdCase.FSU_Location__c=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                parentIdCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;
                parentIdCase.GEMS_Line_of_Business__c=strCaseRec.GEMS_Line_of_Business__c;
                parentIdCase.Opportunity_Name__c=strCaseRec.Opportunity_Name__c;
                parentIdCase.Type='ID Card';  //strCaseRec.Type;
                parentIdCase.Funding_Type_Multiselect__c=strCaseRec.Funding_Type_Multiselect__c;
                parentIdCase.status='In Progress';
                parentIdCase.parentid=strCaseRec.GEMS_Account_Submission_Info__c;
                custIdParentCasesInsertList.add(parentIdCase);
            }
        }
        if(!custIdParentCasesInsertList.isEmpty())
        {
            insert custIdParentCasesInsertList;
        }
        System.Debug('parent insert =====>' +custIdParentCasesInsertList);
        for(Case custCaseRec: custIdParentCasesInsertList)
        {
            System.Debug('Into child For custCaseRec =====>' +custCaseRec);
            List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(custCaseRec.GEMS_Account_Submission_Info__c);
            System.Debug('List benfAggList =====>' +benfAggList);
            for(GEMS_Benefit_Agreement__c benfRec: benfAggList)
            {
                System.Debug('Into Child Benf for  =====>' +benfRec);
                DateTime effectiveDate = custCaseRec.GEMS_Effective_Date__c;
                Case childIdCase = new Case();
                childIdCase.recordTypeId=customIdCardChildRecordTypeId;
                childIdCase.parentId=custCaseRec.Id;
                childIdCase.OwnerId=custCaseRec.OwnerId;
                childIdCase.GEMS_Benefit_Agreement__c=benfRec.Id;
                childIdCase.Subject=benfRec.AccountStructureCase__r.account.name+' '+ benfRec.AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' BA ID Card';
                childIdCase.GEMS_Account_Submission_Info__c=custCaseRec.GEMS_Account_Submission_Info__c;
                childIdCase.Accountid = custCaseRec.Accountid;
                childIdCase.GEMS_Effective_Date__c=custCaseRec.GEMS_Effective_Date__c;
                childIdCase.GEMS_Case_Effective_Date__c=custCaseRec.GEMS_Case_Effective_Date__c;
                childIdCase.GEMS_Submission_Type__c=custCaseRec.GEMS_Submission_Type__c;
                childIdCase.GEMS_Submission_Sub_Type__c=custCaseRec.GEMS_Submission_Sub_Type__c;
                childIdCase.FSU_Location__c=benfRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                childIdCase.HCSC_Division__c=custCaseRec.HCSC_Division__c;
                childIdCase.GEMS_Line_of_Business__c=custCaseRec.GEMS_Line_of_Business__c;
                childIdCase.Opportunity_Name__c=custCaseRec.Opportunity_Name__c;
                childIdCase.Type= 'ID Card'; //custCaseRec.Type;
                childIdCase.Funding_Type_Multiselect__c=custCaseRec.Funding_Type_Multiselect__c;
                childIdCase.status='In Progress';
                custIdChildCasesInsertList.add(childIdCase);
            }
        }
        if(!custIdChildCasesInsertList.isEmpty())
        {
            insert custIdChildCasesInsertList;
        }
        System.Debug('Child insert list =====>' +custIdChildCasesInsertList);
    }*/
    /******************************************************************** 
    *   Method Name : createManualEligibilityWhenAllUnderwitingCasesComplete
    *   @description :   This method to Create manual eligibilty case when all underwriting cases status is 'isClosed'
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Balaram
    ***************************************************************/
    public static void createManualEligibilityWhenAllUnderwitingCasesComplete(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        try {
            Id caseGEMSMedicalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
            Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
            Id caseGEMSAdditionalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
            Id caswManualEligibilityId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Manual Eligibility').getRecordTypeId();
            Set<Id> underwritingRecordTypeIdsSet = new Set<Id>{caseGEMSMedicalRecordTypeId,caseGEMSDentalRecordTypeId,caseGEMSAdditionalRecordTypeId, caswManualEligibilityId };
            Set<String> submissionIds = new Set<String>();
            List<Case> new_cases_list = new List<Case>();
            
            for(Case undewritingCase : newCaseList) {
                //String recordTypeId
                if(underwritingRecordTypeIdsSet.contains(undewritingCase.recordTypeId) && undewritingCase.isClosed && oldCaseMap.get(undewritingCase.Id).status != undewritingCase.status) {
                    submissionIds.add(undewritingCase.GEMS_Account_Submission_Info__c);
                }
            }
            if(!submissionIds.isEmpty()) {
               List<Case> submissionAndUnderwritingCases = [select id,OwnerId,Expected_No_of_paper_application__c,GEMS_Additional_Medical_Underwriter__c,GEMS_Products__c,account.name,GEMS_Submission_Type__c,
                                            GEMS_Submission_Sub_Type__c ,GEMS_Line_of_Business__c ,GEMS_Benefit_Booklet_Required__c,GEMS_Effective_Date__c,
                                             Account.External_ID__c,type,FSU_Location__c,Account_Executive__c,HCSC_Division__c,GEMS_Rx_Vendor__c,GEMS_StdCust_Product__c,
                                            GEMS_Medical_Underwriter__c,Sales_Executive__c,Productid,status,GEMS_Case_Effective_Date__c,Opportunity_Name__c,Funding_Type__c,
                                            Funding_Type_Multiselect__c,GEMS_Ready_to_release_to_screening__c,GEMS_AEP_Account__c,isClosed,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,GEMS_Performance_Guarantees__c,GEMS_OE_Eligibility_Method__c,(select Attachment__c,Description__c,Type__c from GEMS_Attachments__r),
                                            (select id, casenumber,status, isClosed, recordTypeId from Cases1__r where recordtypeid In : underwritingRecordTypeIdsSet)
                                            from case where id=:submissionIds];
                
                if(submissionAndUnderwritingCases != null && !submissionAndUnderwritingCases.isEmpty()) {
                    Set<String> submissionTypes = new Set<String>();
                    Set<String> submissionSubTypes = new Set<String>();
                    List<GEMS_Process_Metadata__mdt> processMetaData = null;
                    for(case subCase : submissionAndUnderwritingCases) {
                        submissionTypes.add(subCase.GEMS_Submission_Type__c);
                        submissionSubTypes.add(subCase.GEMS_Submission_Sub_Type__c);                    
                    }
                    if(!submissionSubTypes.isEmpty() && !submissionTypes.isEmpty()) {
                        processMetaData = GEMS_Utility.retriveCustomMetaDataByProductType(submissionTypes, Label.GEMS_Custom_Products);
                    }
                    /*for(case subCase : submissionAndUnderwritingCases) {
                        if(subCase.GEMS_StdCust_Product__c != null && subCase.GEMS_StdCust_Product__c.contains('Custom')
                            && subCase.GEMS_Submission_Type__c == 'Renewal' && subCase.GEMS_Submission_Sub_Type__c == 'No Changes') {
                            processMetaData = GEMS_Utility.retriveCustomMetaDataByProductTypeIndividual(subCase.GEMS_Submission_Type__c,Label.GEMS_Custom_Products,subCase.GEMS_Submission_Sub_Type__c,'Manual Eligibility');                   
                            break;
                        }
                    }*/
                    boolean manualEligibilityFound = false;
                    List<caseteamrole> caseTeamRoleList = [select id,name from caseteamrole where name in ('Membership Analyst') limit 1];
                    Map<Id,String> roleIdRoleNameMap = new Map<Id,String>();
                    for(caseteamrole ctr:caseTeamRoleList) {
                        roleIdRoleNameMap.put(ctr.id,ctr.name);
                    }
                    List<caseteammember> caseTeamMembers = [select id,parentId,memberid,TeamRoleId from caseteammember where TeamRoleId in : roleIdRoleNameMap.keySet() and parentId in : submissionIds ];
                    Map<Id,caseteammember> caseIdSpecialistTeamMember = new Map<Id,caseteammember >();
                    for(caseteammember teamMember: caseTeamMembers) {
                        if(roleIdRoleNameMap.containsKey(teamMember.TeamRoleId) ) {
                            caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember);
                        }
                    }
                    Group groupId;
                    if(caseIdSpecialistTeamMember.isEmpty()) {
                        groupId =[select Id from Group where Name = 'GEMS membership' and Type = 'Queue' limit 1];
                        System.debug('===groupId ='+groupId );
                    }
                        for(Case submissionCase : submissionAndUnderwritingCases) {
                            if(submissionCase.GEMS_StdCust_Product__c !='Standard Products only' && submissionCase.GEMS_Submission_Sub_Type__c != null && processMetaData!= null) {
                                String[] submissionSubTypeArray = submissionCase.GEMS_Submission_Sub_Type__c.split(';');
                                Set<String> subTypesSet = new Set<String>();
                                for(String subType : submissionSubTypeArray) {
                                    subTypesSet.add(subType);
                                }
                                
                                if(!subTypesSet.isEmpty() && !GEMS_Utility.buildSubmissinCaseBusinessAreaToCreate(processMetaData,subTypesSet,'Manual Eligibility')){
                                    continue;
                                }
                            }
                            List<Case> underWrittingCases = submissionCase.Cases1__r;
                            Boolean allCompleted = true;
                            for(Case uwCase : underWrittingCases) {
                                if(uwCase.recordTypeId == caswManualEligibilityId) {
                                    manualEligibilityFound = true;
                                    break;
                                }
                                if(!uwCase.isClosed ) {
                                    allCompleted = false;
                                    break;
                                }
                            }
                              // US 4753 Added Condition to check whether case is released before creating manual eligibility Case                               
                              if(!manualEligibilityFound && allCompleted && submissionCase.GEMS_Ready_to_release_to_screening__c=='Released' && !submissionCase.GEMS_AEP_Account__c && (submissionCase.GEMS_OE_Eligibility_Method__c == 'OTL' || submissionCase.GEMS_OE_Eligibility_Method__c == 'LGDE' || submissionCase.GEMS_OE_Eligibility_Method__c == 'Paper/XLS')) {
                                new_cases_list  = createManualEligibilityCase(new_cases_list,submissionCase,caswManualEligibilityId,caseIdSpecialistTeamMember,groupId);
                            }
                        }
                        
                        if(!new_cases_list.isEmpty()) {
                            //insert new_cases_list;
                           Database.SaveResult[] saveResults = Database.insert(new_cases_list,false);
                           Integer count =0;
                            for(Database.SaveResult saveResult : saveResults ) {
                              if(saveResult.isSuccess()) {
                                Case caseee = new_cases_list.get(count);
                                /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                String[] toAddresses = new String[] {System.Label.FSU_Membership};
                                mail.setToAddresses(toAddresses);
                                
                                mail.setHtmlBody('The account is active in BlueSTAR :<b> Please proceed with the manual eligibility process ' + caseee.caseNumber );
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                              }
                              count++;
                            }
                            Integer count2 = 0;
                            List<Task> insertTaskList = new List<Task>();
                            for(Database.SaveResult saveResult : saveResults) {
                              if(saveResult.isSuccess()) {
                                Case caseManualEligibility = new_cases_list.get(count2);
                                Task newTask = new Task();
                                newTask.subject = 'Manual Eligibility Complete';
                                newTask.whatId = caseManualEligibility.Id;
                                //newTask.ownerId = caseManualEligibility.OwnerId;
                                newTask.status = 'In progress';
                                newTask.Priority = 'Normal';
                                newTask.GEMS_Start_Date__c = System.now();
                                insertTaskList.add(newTask);
                              }
                           }
                           if(!insertTaskList.isEmpty()) {
                               insert insertTaskList;
                           }
                        }    
                }
            }
        }catch(Exception ex){
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createManualEligibilityWhenAllUnderwitingCasesComplete(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        }
    }
    /******************************************************************** 
    *   Method Name : createManualEligibilityCase
    *   @description :   This method is a helper method for 'createManualEligibilityWhenAllUnderwitingCasesComplete' 
    *                    here actual manual eligibility case will be Initiated
    *   @parameters  :   List<Case> new_cases_list ,Case case_screening,Id caswManualEligibilityId,Map<Id,caseteammember> caseIdSpecialistTeamMember,Group groupId
    *   @return type :   void
    *   @Author : Balaram
    ***************************************************************/    
    public static List<Case> createManualEligibilityCase(List<Case> new_cases_list ,Case case_screening,Id caswManualEligibilityId,Map<Id,caseteammember> caseIdSpecialistTeamMember,Group groupId) {
    
               case manualEligibilityProcessCase = new case();
               
                DateTime effectiveDate1 = case_screening.GEMS_Case_Effective_Date__c;
                if(caseIdSpecialistTeamMember.containsKey(case_screening.Id) ) {
                   manualEligibilityProcessCase.ownerId = caseIdSpecialistTeamMember.get(case_screening.Id).memberid;
                }
                else { if (groupId != null)manualEligibilityProcessCase.ownerId = groupId.id;}
                manualEligibilityProcessCase.GEMS_Account_Submission_Info__c= case_screening.id;
                manualEligibilityProcessCase.parentid= case_screening.id;
                manualEligibilityProcessCase.Expected_No_of_paper_application__c = case_screening.Expected_No_of_paper_application__c;
                manualEligibilityProcessCase.Accountid=case_screening.Accountid;
                //eligibilityProcessCase.Subject=case_screening.Account.Name+' '+ case_screening.Account.External_ID__c +' - Eligibility Process - '+effectiveDate1.format('M/d/yyyy');
                manualEligibilityProcessCase.Subject=case_screening.Account.Name+' '+ case_screening.Account.External_ID__c +' '+effectiveDate1.format('M/d/yyyy')+' Manual Eligibility ';
                manualEligibilityProcessCase.GEMS_Submission_Type__c=case_screening.GEMS_Submission_Type__c;
                manualEligibilityProcessCase.FSU_Location__c=case_screening.FSU_Location__c;
                //manualEligibilityProcessCase.GEMS_Strategic_Account_Executive__c=case_screening.GEMS_Strategic_Account_Executive__c;
                manualEligibilityProcessCase.Account_Executive__c=case_screening.Account_Executive__c;
                manualEligibilityProcessCase.HCSC_Division__c=case_screening.HCSC_Division__c;
                manualEligibilityProcessCase.GEMS_Submission_Sub_Type__c=case_screening.GEMS_Submission_Sub_Type__c;
                manualEligibilityProcessCase.GEMS_Medical_Underwriter__c=case_screening.GEMS_Medical_Underwriter__c;
                manualEligibilityProcessCase.Sales_Executive__c=case_screening.Sales_Executive__c;
                manualEligibilityProcessCase.Productid=case_screening.Productid;
                //newCase.status=case_screening.status;
                //newCase.Type = scrnList;
                manualEligibilityProcessCase.GEMS_Case_Effective_Date__c = case_screening.GEMS_Case_Effective_Date__c;
                manualEligibilityProcessCase.GEMS_Effective_Date__c = case_screening.GEMS_Effective_Date__c;
                //newCase.status = case_screening.status;
                manualEligibilityProcessCase.status = 'In Progress';            
                manualEligibilityProcessCase.recordTypeId = caswManualEligibilityId;                        
                manualEligibilityProcessCase.Opportunity_Name__c = case_screening.Opportunity_Name__c ;
                //String[] ba1=businessArea.split(' ');
                manualEligibilityProcessCase.type = 'Manual Eligibility';//ba1[0] + ' ' +ba1[2];
                //newCase.Sub_Category__c = businessArea;
                manualEligibilityProcessCase.GEMS_Products__c=case_screening.GEMS_Products__c;
                // This population is for October Hotfix 2016
                manualEligibilityProcessCase.Funding_Type_Multiselect__c = case_screening.Funding_Type_Multiselect__c;                
                manualEligibilityProcessCase.GEMS_StdCust_Product__c = case_screening.GEMS_StdCust_Product__c;
                manualEligibilityProcessCase.GEMS_Rx_Vendor__c = case_screening.GEMS_Rx_Vendor__c;
                manualEligibilityProcessCase.GEMS_Line_of_Business__c=case_screening.GEMS_Line_of_Business__c;
                manualEligibilityProcessCase.GEMS_Submitter__c = case_screening.ownerId;
                                
                /*if(activeEntitlement != null) {
                    System.debug('activeEntitlement===enter into if====>');
                    manualEligibilityProcessCase.EntitlementId = activeEntitlement.id;
                }*/
                new_cases_list.add(manualEligibilityProcessCase);
                return new_cases_list;
    }   
    /******************************************************************** 
    *   Method Name : updateOwnerToBenefitCoderFeekReceived
    *   @description :   This method to Update medical benefit code case owner as Benifit Coder if case status Feak Approval Received
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Balaram
    ***************************************************************/   
    //Commented this method as part of US 5230 for MBC case status cleanup
    /*public static void updateOwnerToBenefitCoderFeekReceived(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        try {
            Id caseGEMSMedicalBenefitRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
            List<Id> submissionIds = new List<Id>();
            List<Case> approvalReceivedCases = new List<Case>();
            Map<Id,CaseTeamMember> caseTeamMemberMap = new Map<Id,CaseTeamMember>();
            for(Case benefitCodingCase : newCaseList) {
                if(benefitCodingCase.status == 'FEAK Approval Received' && benefitCodingCase.status != oldCaseMap.get(benefitCodingCase.id).status 
                && benefitCodingCase.recordTypeId == caseGEMSMedicalBenefitRecordTypeId  ) {
                    submissionIds.add(benefitCodingCase.GEMS_Account_Submission_Info__c);
                    approvalReceivedCases.add(benefitCodingCase);
                }
            }
            
            if(!approvalReceivedCases.isEmpty()) {
                List<CaseTeamMember > caseTeamMembers = [select id,parentId,memberid from caseteammember where TeamRoleId in (select id from caseteamrole where name='Benefit Coder') and parentId in : submissionIds];
                if(!caseTeamMembers.isEmpty()) {
                    for(CaseTeamMember memb : caseTeamMembers ) {
                        caseTeamMemberMap.put(memb.parentId,memb);
                    }
                }
                
                for(Case caseBenefit : approvalReceivedCases) {
                    if(caseTeamMemberMap.get(caseBenefit.GEMS_Account_Submission_Info__c) != null ) {
                        caseBenefit.ownerId = caseTeamMemberMap.get(caseBenefit.GEMS_Account_Submission_Info__c).memberId;
                    }
                }
            }
            
        }catch(Exception ex){
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createManualEligibilityWhenAllUnderwitingCasesComplete(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        }
    }*/ //US 5230 End
    /******************************************************************** 
    *   Method Name : complete
    
    ForClosedScreeningCases
    *   @description :   This method to complete milestone status for all Screening and process cases
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @Author : Praveen
    ***************************************************************/    
    public static void completeMilestoneForClosedScreeningCases(List<Case> newCaseList, Map<Id,Case> oldCaseMap) 
    {
        try
        {
            DateTime completionDate = System.now();
            List<Id> updateCases = new List<Id>();
            for(Case caseRec: newCaseList)
            {
                Id caseScreeningCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
                Id medBenfCodingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
                Id accSetupCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
                Id pharmacyCodingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
                Id dentalBenfCodCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
                Id sbcCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
                Id medUnderwritingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
                Id dentalunderCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
                Id additionalUnderWritCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
                //SFDC-5099 This recordTypeId is used to filter the Account Set up Maitnenance Case Record and pass it to the GEMS_MilestoneUtils the to set the complete date of milestones.
                Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
                //SFDC-5099
                // SFDC-4582 Fix SLA Counter for all cases when they are closed.
                // Added all the status's that mark the case closed to SLA completion date as well.
                // SFDC-7263 GEMS: MBC - "No GCPS action required" should stop the SLA Counter
                // Added one more closing status to medBenfCodingCasesRecordTypeId   
                if( 
                    (
                         ((caseRec.Status=='Approved' || caseRec.Status=='Routed In Error' ) && caseRec.RecordTypeId==caseScreeningCasesRecordTypeId)
                        || ((caseRec.Status=='Completed' || caseRec.Status== 'Approved' ) && caseRec.RecordTypeId==sbcCasesRecordTypeId)
                        || ((caseRec.Status=='AS400 & BlueStar Update Completed' || caseRec.Status=='Routed in Error' || caseRec.Status== 'Approved' || caseRec.Status=='Completed' ) && caseRec.RecordTypeId==pharmacyCodingCasesRecordTypeId)
                        || ((caseRec.Status=='Medical Benefits Production Ready' || caseRec.Status=='Closed' || caseRec.Status=='Completed' || caseRec.Status=='Approved' || caseRec.Status== 'Routed in Error' || caseRec.Status == 'No GCPS action required')  && caseRec.RecordTypeId==medBenfCodingCasesRecordTypeId)
                        || ((caseRec.Status=='Completed' || caseRec.Status=='Closed') && caseRec.RecordTypeId==dentalBenfCodCasesRecordTypeId)
                        || ((caseRec.Status=='Release Underwriting Complete' || caseRec.Status=='Approved' || caseRec.Status=='Completed' ) && caseRec.RecordTypeId==accSetupCasesRecordTypeId)
                        || ((caseRec.Status=='Approved' || caseRec.Status== 'Closed' || caseRec.Status== 'Completed') && caseRec.RecordTypeId==medUnderwritingCasesRecordTypeId)
                        || ((caseRec.Status=='Approved' || caseRec.Status== 'Closed' || caseRec.Status== 'Completed') && caseRec.RecordTypeId==dentalunderCasesRecordTypeId)
                        || ((caseRec.Status=='Approved' || caseRec.Status== 'Closed' || caseRec.Status== 'Completed') && caseRec.RecordTypeId==additionalUnderWritCasesRecordTypeId)
                        || ((caseRec.Status=='Closed' || caseRec.Status== 'Completed') &&  caseRec.RecordTypeId==accSetupRecordTypeId)
                    )
                    && caseRec.Status!=oldCaseMap.get(caseRec.id).status
                  )
                {
                    updateCases.add(caseRec.id);
                }
            }
            if (updateCases.isEmpty() == false)
            GEMS_MilestoneUtils.completeMilestone(updateCases, completionDate);
        }
        catch(Exception ex)
        {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.completeMilestoneForClosedScreeningCases(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
        }
    }
    
    

  /******************************************************************** 
    *    Method Name : firstAndLastBAApproveStatusNotification
    Action
    *   @description :   This method to send email notification on first account setup prcocess balevel case approval
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    //public Static Integer staticExecute = 0;
   public static void firstAndLastBAApproveStatusNotification(List<Case> newCasesList) {
    
    Set<Case> approvedCases = new Set<Case>();
    Set<Id> submissionIds = new Set<Id>();
    try {
    //Id baAccLevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
    Id baAccLevelDentalRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId();
    Id MedicalBALevelSubChildRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
    Id dbcParentRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
   // Id SBCVBALevelRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
    
    Id accountStructureRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
    
    Set<String> requiredRecordTypes = new Set<String>{baAccLevelDentalRecordType,MedicalBALevelSubChildRecordType};
    String firstBaApproval = System.Label.GEMS_Send_first_BA_approval_notification;
       
    Case approvedBaSetupProcess = null;
    Map<Id,List<GEMS_Benefit_Agreement__c>> submissionBaMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
    List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
    List<Case> parentCaseUpdation = new List<Case>();
    Set<String> divisions = new Set<String>();
    List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
    Map<String,String> dentalDivisionEmails = new Map<String,String>();
    Map<String,String> divisionEmails = new Map<String,String>();
    MAP<Id,Case> parentUpdatedCases = new Map<Id,Case>();
    Set<Id> submissionIdsSet = new Set<Id>();
    Set<Id> recordTypesForApprovedCasesSet = new Set<Id>();
    
    if(firstBaApproval == 'Yes' ) {
        for(Case caseee : newCasesList) {
            if( requiredRecordTypes.contains(caseee.recordTypeId) && caseee.status=='In Progress' ) {
                submissionIds.add(caseee.GEMS_Account_Submission_Info__c);
                if(!recordTypesForApprovedCasesSet.contains(caseee.recordTypeId)) {
                    approvedCases.add(caseee);                    
                    recordTypesForApprovedCasesSet.add(caseee.recordTypeId);
                }
                divisions.add(caseee.HCSC_Division__c);
            }
        }
        
        if(!approvedCases.isEmpty()) {
            System.debug('=====requiredRecordTypes=====>'+requiredRecordTypes);
            List<OrgWideEmailAddress> orgEmailAddress =  [select id, Address,displayname from OrgWideEmailAddress where displayname='No Reply GEMS'];
            List<GEMS_Email_Notification__mdt> divisionNotificationMetadata = [select Division__c, Funding_Type__c, Email__c,Business_Area__c from GEMS_Email_Notification__mdt where Division__c In :divisions and Flag__c =: true ];
            for(GEMS_Email_Notification__mdt emailMdt : divisionNotificationMetadata) {
                if(emailMdt.Business_Area__c != null && emailMdt.Business_Area__c.contains('Dental Benefit Coding') && emailMdt.Funding_Type__c == null) {
                    dentalDivisionEmails.put(emailMdt.Division__c,emailMdt.Email__c);
                }else if(emailMdt.Business_Area__c != null && emailMdt.Business_Area__c.contains('Dental Benefit Coding') && emailMdt.Funding_Type__c != null) {
                    dentalDivisionEmails.put((emailMdt.Division__c+emailMdt.Funding_Type__c),emailMdt.Email__c);
                }
                if(emailMdt.Business_Area__c != null && emailMdt.Business_Area__c.contains('Medical Benefit Coding')) {
                    divisionEmails.put(emailMdt.Division__c,emailMdt.Email__c);
                }
            }
            System.debug('divisionEmails======>'+divisionEmails);
            List<Case> subWithApproveCases = [select id,recordTypeId,GEMS_Effective_Date__c, GEMS_StdCust_Product__c,Funding_Type_Multiselect__c, Account.Name,Account_Number__c, GEMS_Case_Effective_Date__c, caseNumber,status,subject,OwnerId,owner.email,HCSC_Division__c,(select id,caseNumber,HCSC_Division__c,Funding_Type_Multiselect__c, status,subject,owner.email,ownerId,parentId,GEMS_Account_Submission_Info__c,recordTypeId,GEMS_Type__c, parent.recordTypeId from Cases1__r where recordTypeId In : requiredRecordTypes) from case where id in : submissionIds];
            System.debug('subWithApproveCases====>'+subWithApproveCases);
            Map<Id,Map<Id,List<Case>>> submissionIdApprovedCases = new Map<Id,Map<Id,List<Case>>>();
            Map<Id,Case> submissionCaseMap = new Map<Id,Case>();
            if(subWithApproveCases != null && !subWithApproveCases.isEmpty()) {
                for(Case superClass : subWithApproveCases) {
                 if(superClass.GEMS_StdCust_Product__c != 'Standard Products only') {
                  List<Case> childBACases = superClass.Cases1__r;
                  for(Case apppCase : childBACases) {
                    if(submissionIdApprovedCases.get(apppCase.GEMS_Account_Submission_Info__c) != null) {
                    System.debug('=====Enter Here 1======');
                        if(submissionIdApprovedCases.get(apppCase.GEMS_Account_Submission_Info__c).get(apppCase.recordTypeId) != null) {
                            submissionIdApprovedCases.get(apppCase.GEMS_Account_Submission_Info__c).get(apppCase.recordTypeId).add(apppCase);
                        }else {
                            System.debug('=====Enter Here 2======');
                            Map<Id,List<Case>> recordTypeIdRelatedCasesMap = submissionIdApprovedCases.get(apppCase.GEMS_Account_Submission_Info__c);
                            recordTypeIdRelatedCasesMap.put(apppCase.recordTypeId, new List<Case>{apppCase});
                            submissionIdApprovedCases.put(apppCase.GEMS_Account_Submission_Info__c,recordTypeIdRelatedCasesMap);
                        }
                    }else {
                        System.debug('=====Enter Here 3======');
                        Map<Id,List<Case>> recordTypeIdRelatedCasesMap = new Map<Id,List<Case>>();
                        recordTypeIdRelatedCasesMap.put(apppCase.recordTypeId, new List<Case>{apppCase});
                        submissionIdApprovedCases.put(apppCase.GEMS_Account_Submission_Info__c,recordTypeIdRelatedCasesMap);
                    }
                    //submissionIdApprovedCases.put(apppCase.GEMS_Account_Submission_Info__c,apppCase.Cases1__r );
                  }
                    submissionCaseMap.put(superClass.Id,superClass);
                  }
                }
                System.debug('==submissionIdApprovedCases=====>'+submissionIdApprovedCases);
            }
           // SFDC-4449 Malathi.K 06/09/17 Get Child Level BA cases with Routed In Error Status.
            List<Case> CasesWithMedBSRIE = [select id from case where GEMS_Account_Submission_Info__c in : submissionIds and Sub_Category__c = 'Benefit Coding Screening' and GEMS_Benefit_Agreement__c <> '' and status = 'Routed In Error'];
            List<Case> CasesWithDenBSRIE = [select id from case where GEMS_Account_Submission_Info__c in : submissionIds and Sub_Category__c = 'Dental Benefit Coding Screening' and GEMS_Benefit_Agreement__c <> '' and status = 'Routed In Error'];
            
            System.debug('==CasesWithMedBSRIE =====>'+CasesWithMedBSRIE);
            System.debug('==CasesWithMedBSRIE size =====>'+CasesWithMedBSRIE.size());
            
            System.debug('==CasesWithDenBSRIE =====>'+CasesWithDenBSRIE);
            System.debug('==CasesWithDenBSRIE size =====>'+CasesWithDenBSRIE.size());
            // SFDC-4244 Added new field filter for selected BA
            List<Case> structureCsesWithBA = [select id,casenumber,recordtypeId, status, parentId,GEMS_Account_Submission_Info__c,Funding_Type_Multiselect__c,
                (select id, Name from GEMS_Benefit_Agreements__r where HAS_GROUP_SECTIONS__C =true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true) from case where GEMS_Account_Submission_Info__c in : submissionIds and recordTypeId =: accountStructureRecordTypeId  ];
            for(Case structCase : structureCsesWithBA) {
                List<GEMS_Benefit_Agreement__c> baList = structCase.GEMS_Benefit_Agreements__r;
                if(baList != null) {
                    submissionBaMap.put(structCase.GEMS_Account_Submission_Info__c,baList);
                }
            }
            //Code Modified for October release Email-Notifications
            
            /*List<String> templateNames = new List<String>{'GEMS_First_BA_Complete_Template','GEMS_Last_BA_Complete_Template','GEMS_Dental_Benefit_Coding_Template'};
            List<EmailTemplate> emailTemplates = [select Id, Subject, HtmlValue, Body, DeveloperName from EmailTemplate where developername In : templateNames];
            EmailTemplate firstBaEmailTemplate = null;
            EmailTemplate lastBaEmailTemplate = null;
            EmailTemplate dentalBenefitCodingEmailTemplate = null;
            for(EmailTemplate ttt : emailTemplates) {
                if(ttt.developername == 'GEMS_First_BA_Complete_Template') {
                    firstBaEmailTemplate = ttt;                 
                }else if(ttt.developername == 'GEMS_Last_BA_Complete_Template') {
                    lastBaEmailTemplate = ttt;
                }else if(ttt.developername == 'GEMS_Dental_Benefit_Coding_Template') {
                    dentalBenefitCodingEmailTemplate = ttt;
                }
            }
            Contact lll = [select id, name from Contact where name = 'No Reply Test'];*/
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            for(Case approvedCase : approvedCases ) {
                if(submissionIdApprovedCases.get(approvedCase.GEMS_Account_Submission_Info__c) != null ) {
                    List<Case> childCases = null;
                    System.debug('approvedCase.recordTypeId===>'+approvedCase.recordTypeId);
                    if(submissionIdApprovedCases.get(approvedCase.GEMS_Account_Submission_Info__c) != null) {
                        childCases = submissionIdApprovedCases.get(approvedCase.GEMS_Account_Submission_Info__c).get(approvedCase.recordTypeId);
                    }
                    Integer childCasesCount = 0;
                    if(childCases != null && !childCases.isEmpty()) {                       
                        childCasesCount = childCases.size();
                        List<GEMS_Benefit_Agreement__c> benefitList = submissionBaMap.get(approvedCase.GEMS_Account_Submission_Info__c);
                        Case submissionCase_db = submissionCaseMap.get(approvedCase.GEMS_Account_Submission_Info__c);
                        DateTime effectiveDate1 = submissionCase_db.GEMS_Effective_Date__c;
                        if(childCasesCount == 1 ) {
                            approvedBaSetupProcess = childCases[0];
                            if(approvedBaSetupProcess.owner.email != null || (MedicalBALevelSubChildRecordType == approvedBaSetupProcess.recordTypeId && divisionEmails.get(approvedBaSetupProcess.HCSC_Division__c) != null) 
                                ) {
                                String[] toAddressesOwner = new String[] {approvedBaSetupProcess.owner.email};
                                String subjecttt = submissionCase_db.Account.Name+' - '+submissionCase_db.Account_Number__c+' - '+submissionCase_db.GEMS_Case_Effective_Date__c+'- Screening Complete for 1st BA ';
                                if(MedicalBALevelSubChildRecordType == approvedBaSetupProcess.recordTypeId && divisionEmails.get(approvedBaSetupProcess.HCSC_Division__c) != null) {
                                    String toAddressString = divisionEmails.get(approvedBaSetupProcess.HCSC_Division__c);
                                    String[] emailAddressarray = toAddressString.split(';');
                                    toAddressesOwner = emailAddressarray;
                                    System.debug('==effectvidate=====>'+effectiveDate1.format('M/d/yyyy'));
                                    subjecttt = submissionCase_db.Account.Name+' - '+submissionCase_db.Account_Number__c+' - '+effectiveDate1.format('M/d/yyyy')+'- Screening Complete for 1st BA ';
                                }
                                String body = 'The Benefit Agreement has passed Screening and is ready for coding </br></br> <b>Account Name :</b>'+ submissionCase_db.Account.Name +'</br> <b>Case Number &nbsp : </b>'+ submissionCase_db.CaseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+submissionCase_db.Id +'" target="_blank">View Case Details</a></br></br></br><b>Thanks</b>';
                                //mailList = GEMS_EmailNotification.createMassEmailNotificationWithTemplate(mailList,toAddressesOwner, firstBaEmailTemplate, submissionCaseMap.get(approvedCase.GEMS_Account_Submission_Info__c), lll,emailAddress );
                                mailList = GEMS_EmailNotification.createMassEmailMessage(mailList,toAddressesOwner,subjecttt,body,submissionCase_db);
                            }
                        }
                        // SFDC-4449 Malathi.K 06/09/17 Add Routed In Error Count to criteria.
                        // if(benefitList != null && childCasesCount == benefitList.size()) {
                        //    approvedBaSetupProcess = childCases[(benefitList.size()-1)];
                          if(benefitList != null && (((childCasesCount + CasesWithMedBSRIE.size()) == benefitList.size()) || ((childCasesCount + CasesWithDenBSRIE.size()) == benefitList.size()))) {
                               approvedBaSetupProcess = childCases[childCasesCount-1];
                            if(approvedBaSetupProcess.owner.email != null || (MedicalBALevelSubChildRecordType == approvedBaSetupProcess.recordTypeId && divisionEmails.get(approvedBaSetupProcess.HCSC_Division__c) != null) 
                                || (baAccLevelDentalRecordType == approvedBaSetupProcess.recordTypeId && dentalDivisionEmails.get(approvedBaSetupProcess.HCSC_Division__c) != null)) {
                                String[] toAddresses = new String[] {approvedBaSetupProcess.owner.email};
                                String subjecttt = submissionCase_db.Account.Name+' - '+submissionCase_db.Account_Number__c+' - '+submissionCase_db.GEMS_Case_Effective_Date__c+'- Screening Complete for Last BA '; 
                                if(MedicalBALevelSubChildRecordType == approvedBaSetupProcess.recordTypeId && divisionEmails.get(approvedBaSetupProcess.HCSC_Division__c) != null) {
                                    String toAddressString = divisionEmails.get(approvedBaSetupProcess.HCSC_Division__c);
                                    String[] emailAddressarray = toAddressString.Split(';');
                                    toAddresses = emailAddressarray;                                    
                                    subjecttt = submissionCase_db.Account.Name+' - '+submissionCase_db.Account_Number__c+' - '+effectiveDate1.format('M/d/yyyy')+'- Screening Complete for Last BA '; 
                                    String body = 'The Benefit Agreement has passed Screening and is ready for coding </br></br> <b>Account Name :</b>'+ submissionCase_db.Account.Name +'</br> <b>Case Number &nbsp : </b>'+ submissionCase_db.CaseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+submissionCase_db.Id +'" target="_blank">View Case Details</a></br></br></br><b>Thanks</b>';
                                    //mailList = GEMS_EmailNotification.createMassEmailNotificationWithTemplate(mailList,toAddresses, lastBaEmailTemplate, submissionCaseMap.get(approvedCase.GEMS_Account_Submission_Info__c), lll,emailAddress );
                                    mailList = GEMS_EmailNotification.createMassEmailMessage(mailList,toAddresses,subjecttt,body,submissionCase_db);
                                }
                                if(baAccLevelDentalRecordType == approvedBaSetupProcess.recordTypeId && dentalDivisionEmails.get(approvedBaSetupProcess.HCSC_Division__c) != null) {
                                    String toAddressString = '';
                                    if(approvedBaSetupProcess.HCSC_Division__c == 'OK' && approvedBaSetupProcess.Funding_Type_Multiselect__c != null && approvedBaSetupProcess.Funding_Type_Multiselect__c.contains('ASO') ) {
                                        toAddressString = dentalDivisionEmails.get((approvedBaSetupProcess.HCSC_Division__c+'ASO'));
                                    }else {
                                        toAddressString = dentalDivisionEmails.get(approvedBaSetupProcess.HCSC_Division__c);
                                    }
                                    String[] emailAddressarray = toAddressString.Split(';');
                                    toAddresses = emailAddressarray;
                                    subjecttt = submissionCase_db.Account.Name+' - '+submissionCase_db.Account_Number__c+' - '+effectiveDate1.format('M/d/yyyy')+'- Screening Process Complete '; 
                                    String body = 'Screening has been completed by all applicable business for the account. </br></br> <b>Account Name :</b>'+ submissionCase_db.Account.Name +'</br> <b>Case Number &nbsp : </b>'+ submissionCase_db.CaseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+submissionCase_db.Id +'" target="_blank">View Case Details</a></br></br></br><b>Thanks</b>';
                                    //mailList = GEMS_EmailNotification.createMassEmailNotificationWithTemplate(mailList,toAddresses, dentalBenefitCodingEmailTemplate, submissionCaseMap.get(approvedCase.GEMS_Account_Submission_Info__c), lll,emailAddress );
                                    mailList = GEMS_EmailNotification.createMassEmailMessage(mailList,toAddresses,subjecttt,body,submissionCase_db);
                                }
                                
                            }
                            //Code for updating ba completed flag & date for Oct Hot fix                            
                            Case submiCase = submissionCaseMap.get(approvedCase.GEMS_Account_Submission_Info__c);
                            System.debug('approvedCase.GEMS_Account_Submission_Info__c==============>'+approvedCase.GEMS_Account_Submission_Info__c);
                            System.debug('submiCase==============>'+submiCase);
                            
                            if(submiCase != null && !submissionIdsSet.contains(submiCase.Id) ) {                                
                                submiCase.GEMS_All_screenings_completed_date__c = System.now();
                                submiCase.GEMS_All_screenings_completed_flag__c = true;
                                parentCaseUpdation.add(submiCase);
                                submissionIdsSet.add(submiCase.Id);
                            }
                            //Updating parent case last ba completed date when Last BA approval.
                            if(parentUpdatedCases.get(approvedBaSetupProcess.parentId) == null ) {
                                Case parentUpdationCase = new Case();
                                parentUpdationCase.Id = approvedBaSetupProcess.parentId;
                                submiCase.GEMS_Last_BA_Completed_Date__c = System.now();
                                if(!activeEntitlement.isEmpty() && approvedBaSetupProcess.parent.RecordTypeId != dbcParentRecordType) // Condition "parentUpdationCase.RecordType.Name != 'GEMS Dental Benefit Coding'" added as per the Story SFDC-3690
                                {
                                    System.debug('activeEntitlement===enter into if====>');
                                    parentUpdationCase.EntitlementId = activeEntitlement[0].id;
                                }
                                parentCaseUpdation.add(parentUpdationCase);
                                parentUpdatedCases.put(approvedBaSetupProcess.parentId, parentUpdationCase );
                            }
                            //update parentUpdationCase;
                        }
                    }
                }
            }
            try {
                if(!mailList.isEmpty()) {
                    if(orgEmailAddress != null && !orgEmailAddress.isEmpty()) {
                        for(Messaging.SingleEmailMessage mailMessage : mailList) {
                            mailMessage.setOrgWideEmailAddressId(orgEmailAddress.get(0).Id);
                        }
                    }
                    Messaging.sendEmail(mailList);
                }
            }catch(Exception ex){
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.firstAndLastBAApproveStatusNotification(List<Case> newCasesList)','Low');              
            }
            if(!parentCaseUpdation.isEmpty()) {
                update parentCaseUpdation;
            }
        }
        //staticExecute = 1;
     }
    }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.firstAndLastBAApproveStatusNotification(List<Case> newCasesList)','High');              
        }
 }
  
  
  /******************************************************************** 
    *    Method Name : parentStatusChangeAllProcessCaseStatusChange
    Action
    *   @description :   This method to update Parent case when all child process cases of all BA's approved
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void parentStatusChangeAllProcessCaseStatusChange(List<Case> casesList,Map<Id,Case> oldCaseMap) {
        
        // to check if parent case is dental benefit coding
        Id dentalCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        // BA level cases
        Id medBenfCodingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        Id accSetupCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        Id pharmacyCodingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        Id dentalBenfCodCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId();
        Id sbcCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        Set<Id> caseRecordTypeIds = new Set<Id>{pharmacyCodingCasesRecordTypeId,dentalBenfCodCasesRecordTypeId,sbcCasesRecordTypeId,medBenfCodingCasesRecordTypeId,accSetupCasesRecordTypeId};
        
        Id accountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        
        Set<String> completedParentCaseIds = new Set<String>();
        List<Case> parentStatusCompleteUpdationList = new List<Case>();
        List<Id> caseSubmissionIdsList = new List<Id>();
        Map<Id,List<GEMS_Benefit_Agreement__c>> submissionBaMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
        List<Case> parentStatusUpdationList = new List<Case>();
        try {
            for(case caserec : casesList) {
                if(caserec.status != 'Release Underwriting Complete' && (caserec.status != oldCaseMap.get(caserec.Id).status) && caseRecordTypeIds.contains(caserec.recordTypeId)) {
                    completedParentCaseIds.add(caserec.parentId);
                    caseSubmissionIdsList.add(caserec.GEMS_Account_Submission_Info__c);
                }            
             }
             if(!completedParentCaseIds.isEmpty()) {  
                 List<Case> parentChildCasesList = [select id,casenumber,recordtypeId, status, parentId,GEMS_Effective_Date__c,Accountid,GEMS_Account_Submission_Info__c,Account.name,Account.External_ID__c,(select id, casenumber,status from Cases) from case where id in : completedParentCaseIds ];
                 Boolean allChildSameStatus = true;
                 // SFDC-4244 Added new field filter for selected BA
                 List<Case> structureCsesWithBA = [select id,casenumber,recordtypeId, status, parentId,GEMS_Account_Submission_Info__c,
                (select id, Name from GEMS_Benefit_Agreements__r where HAS_GROUP_SECTIONS__C =true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true) from case where 
                                                   GEMS_Account_Submission_Info__c in : caseSubmissionIdsList and recordTypeId =: accountStructureRecordTypeId  ];
                for(Case structCase : structureCsesWithBA) {
                    List<GEMS_Benefit_Agreement__c> baList = structCase.GEMS_Benefit_Agreements__r;
                    if(baList != null) {
                        submissionBaMap.put(structCase.GEMS_Account_Submission_Info__c,baList);
                    }
                }
                for(Case caseParent : parentChildCasesList) {
                    allChildSameStatus = true;
                    List<Case> childCases = caseParent.cases;
                    String firstCaseStatus = null;

                    // if dental parent case, there is no child BA case for non-dental BAs. Therefore, the BA size and child size wont' match
                    if(submissionBaMap.get(caseParent.GEMS_Account_Submission_Info__c) != null && childCases != null && 
                      (caseParent.recordtypeId == dentalCodingRecordTypeId || childCases.size() > 0)) {//submissionBaMap.get(caseParent.GEMS_Account_Submission_Info__c).size() == childCases.size()
                        for(Case casss : childCases) {
                            if(firstCaseStatus == null) {
                               firstCaseStatus =  casss.status;
                            }
                            if(casss.status != firstCaseStatus) {
                                allChildSameStatus = false;
                                break;
                            }
                        }
                        if(allChildSameStatus) {
                            if(caseParent.status != firstCaseStatus ) {
                                caseParent.status = firstCaseStatus;
                                parentStatusUpdationList.add(caseParent);                    
                            }
                        }
                    }
                }
                if(!parentStatusUpdationList.isEmpty()) {
                    update parentStatusUpdationList;
                }   
             }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.parentCompleteUpdation(List<Case> newCaseList)','High');              
        } 
    }
    
    
    /******************************************************************** 
    *    Method Name : benefitAdhocMeetingMinutesCheckForGetCase
    Action
    *   @description :   This method to check adhoc meeting minutes check when adhoc needed yes
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/  
  public static void benefitAdhocMeetingMinutesCheckForGetCase(List<Case> casesList,Map<Id,Case> oldCaseMap) {
    try{
        Id accSubRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
        List<Id> submissionCaseIds = new List<Id>();
        for(Case case_to_update : casesList) {
            if(case_to_update.recordTypeId == accSubRecordTypeId && case_to_update.status ==  'Completed' 
                && case_to_update.status != oldCaseMap.get(case_to_update.id).status && case_to_update.GEMS_Verify_Benefit_Adhoc_Needed__c == 'Yes') {
                submissionCaseIds.add(case_to_update.GEMS_Account_Submission_Info__c);
            }
        }
        if(!submissionCaseIds.isEmpty()) {
            List<Case> casesWithAttachmentList = [select id, casenumber,(select id,type__c from GEMS_Attachments__r where type__c =: System.Label.GEMS_Benefit_Adhoc_Meeting_Minutes_Doc_Name) from case where id in : submissionCaseIds ];
            Map<Id,List<GEMS_Attachment__c>>  adhocAttachmentMap = new Map<Id,List<GEMS_Attachment__c>>();
            if(casesWithAttachmentList != null && !casesWithAttachmentList.isEmpty()) {
                for(Case casewithAttahment : casesWithAttachmentList) {
                    adhocAttachmentMap.put(casewithAttahment.Id,casewithAttahment.GEMS_Attachments__r);
                }
                for(Case case_to_update : casesList) {
                    if(adhocAttachmentMap.get(case_to_update.GEMS_Account_Submission_Info__c) == null) {
                        case_to_update.addError('Benefit Adhoc Meeting Minutes Document Required When Benefit Adhoc Needed? chosen as Yes ');
                    }else if(adhocAttachmentMap.get(case_to_update.GEMS_Account_Submission_Info__c) != null && adhocAttachmentMap.get(case_to_update.GEMS_Account_Submission_Info__c).isEmpty()) {
                        case_to_update.addError('Benefit Adhoc Meeting Minutes Document Required When Benefit Adhoc Needed? chosen as Yes ');
                    }
                }
            }
        }
      }catch(Exception ex) {
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.benefitAdhocMeetingMinutesCheckForGetCase(List<Case> newCaseList,Map<Id,Case> oldCaseMap)','High');              
       }
 }
 
 /******************************************************************** 
    *    Method Name : updateReadyToReleaseScreeningStatusChange
    Action
    *   @description :   This method to check adhoc meeting minutes check when adhoc needed yes
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
 public static void updateReadyToReleaseScreeningStatusChange(List<Case> casesList,Map<Id,Case> oldCaseMap) {
       Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();       
       Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
       try {
            Set<Id> submissionIdsSet = new Set<Id>();
            Set<Id> nonStatusSubmissionIdSet = new Set<Id>();
            for(Case accStructCase : casesList) {
                if( accStructCase.recordTypeId == accStructCaseRecordTypeId && accStructCase.status != oldCaseMap.get(accStructCase.Id).status && (accStructCase.status =='Client Approval Received' || accStructCase.status == 'BlueSTAR Sent' || accStructCase.status == 'BlueSTAR Shell Created' 
                 || accStructCase.status == 'BlueSTAR Failed' || accStructCase.status == 'BlueSTAR Partially Fail')){
                     submissionIdsSet.add(accStructCase.GEMS_Account_Submission_Info__c);
                 }else if(accStructCase.recordTypeId == accStructCaseRecordTypeId && accStructCase.status != oldCaseMap.get(accStructCase.Id).status && 
                   (oldCaseMap.get(accStructCase.Id).status == 'Client Approval Received' || oldCaseMap.get(accStructCase.Id).status == 'BlueSTAR Sent' 
                    || oldCaseMap.get(accStructCase.Id).status == 'BlueSTAR Shell Created' || accStructCase.status == 'BlueSTAR Failed' 
                    || accStructCase.status == 'BlueSTAR Partially Fail' )) {
                     nonStatusSubmissionIdSet.add(accStructCase.GEMS_Account_Submission_Info__c);
                 }
            }
            if(!submissionIdsSet.isEmpty()) {
                List<Case> submissionCases = [select id, status, GEMS_All_required_documents_attached__c, GEMS_Ready_to_release_to_screening__c, GEMS_StdCust_Product__c,(select Attachment__c,Description__c,Type__c from GEMS_Attachments__r) from case where id in :submissionIdsSet ];
                List<Case> submissionCases_toUpdate = new List<Case>();
                // attachment is mandatory regardless of standard or custom products per comments by Hormuz Nariman on 3/27/2017
                // remove "&& submissionCase.GEMS_StdCust_Product__c != 'Standard Products only'" from if-block
                for(Case submissionCase : submissionCases) {
                    if(submissionCase.GEMS_Attachments__r != null && !submissionCase.GEMS_Attachments__r.isEmpty() 
                       && submissionCase.GEMS_Ready_to_release_to_screening__c != 'Ready to Release' 
                       && submissionCase.GEMS_Ready_to_release_to_screening__c != 'Released' ) {
                        submissionCase.GEMS_Ready_to_release_to_screening__c = 'Ready to Release';
                        submissionCases_toUpdate.add(submissionCase);
                    } 
                }
                if(!submissionCases_toUpdate.isEmpty()) {
                    update submissionCases_toUpdate;
                }
            }
            if(!nonStatusSubmissionIdSet.isEmpty()) {
                List<Case> submissionCases = [select id, status, GEMS_All_required_documents_attached__c, GEMS_Ready_to_release_to_screening__c, GEMS_StdCust_Product__c from case where id in :nonStatusSubmissionIdSet];
                List<Case> submissionCases_toUpdate = new List<Case>();
                //else if condetion added for Standard Products only case for October release Defect fix
                for(Case submissionCase : submissionCases) {
                    if(submissionCase.GEMS_Ready_to_release_to_screening__c == 'Ready to Release' ) {
                        submissionCase.GEMS_Ready_to_release_to_screening__c = 'Not Ready for release';
                        submissionCases_toUpdate.add(submissionCase);
                    }else if(submissionCase.GEMS_StdCust_Product__c == 'Standard Products only' && submissionCase.GEMS_Ready_to_release_to_screening__c == 'Ready to Release' ) {
                        submissionCase.GEMS_Ready_to_release_to_screening__c = 'Not Ready for release';
                        submissionCases_toUpdate.add(submissionCase);
                    }
                }
                if(!submissionCases_toUpdate.isEmpty()) {
                    update submissionCases_toUpdate;
                }
            }
       }catch(Exception ex) {
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateReadyToReleaseScreeningStatusChange(List<Case> newCaseList,Map<Id,Case> oldCaseMap)','High');              
       }
 }

//SFDC-5247 Create Eligibility Process case for Acct: Structure Maintenance When Acct. Structure case status is updated to Client Approval Received
 /******************************************************************* 
  *   Method Name :    CreateAcctMaintEligProcessCase  
  *   @description :   This method is to create Eligibility Process for Acct: Structure Maintenance.
  *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
  *   @return type :   void
  ***************************************************************/
public static void CreateAcctMaintEligProcessCase(List<Case> casesList,Map<Id,Case> oldCaseMap) {
       Id caseAccountMaintenanceId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();       
       Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
       try {
            Set<Id> MaintStructIdsSet = new Set<Id>();
            //Set<Id> nonStatusSubmissionIdSet = new Set<Id>();
            for(Case accStructCase : casesList) {
                if( accStructCase.recordTypeId == accStructCaseRecordTypeId && accStructCase.status != oldCaseMap.get(accStructCase.Id).status 
                     && (accStructCase.status =='Client Approval Received')){
                     MaintStructIdsSet.add(accStructCase.GEMS_Account_Submission_Info__c);
                }
            }       
            
             if(!MaintStructIdsSet.isEmpty()) {
                List<Case> MaintCases = [select id, status, GEMS_StdCust_Product__c,GEMS_Submission_Type__c,GEMS_Case_Effective_Date__c,GEMS_Effective_Date__c,GEMS_Submission_Sub_Type__c,GEMS_Is_Eligibility_Required__c,GEMS_AEP_Account__c,Accountid,FSU_Location__c,GEMS_Target_Date_Production_OE_File__c,Account_Executive__c,HCSC_Division__c,GEMS_Medical_Underwriter__c,Sales_Executive__c,Productid,GEMS_Actual_Date_Production_OE_File__c,Opportunity_Name__c,GEMS_Products__c,ownerId,Funding_Type_Multiselect__c,GEMS_Rx_Vendor__c,Account.name,Account.External_ID__c,GEMS_Line_of_Business__c from case where id in :MaintStructIdsSet ]; 
                    
                List<Case> AEPEligibilitycases_tocreate = new List<Case>();
                
                for(Case MaintCase : MaintCases) {
                    if (MaintCases != null && ! MaintCases.isEmpty()){
                         if (MaintCase.GEMS_Is_Eligibility_Required__c == 'Yes' &&  MaintCase.GEMS_AEP_Account__c == True) {
                          AEPEligibilitycases_tocreate.add(MaintCase);
                          }
                         }
                         }              
                         if(!AEPEligibilitycases_tocreate.isEmpty()) {
                             GEMS_AccountScreeningCaseCreation.screeningCasesCreation(AEPEligibilitycases_tocreate,true);                     
                           }
                         }                                 
      
      }catch(Exception ex) {
      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.CreateAcctMaintEligProcessCase(List<Case> newCaseList,Map<Id,Case> oldCaseMap)','High');              
     }
}           

    /******************************************************************** 
    *    Method Name : setSBCBACaseOwner
    Action
    *   @description :   This method to set ba level sbc owner
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void setSBCBACaseOwner(List<Case> casesList) {
           Id sbcRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();       
           Id accBalevelSBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
           try {
                Set<Id> parentIdsSet = new Set<Id>();
                for(Case accStructCase : casesList) {
                    if( accStructCase.recordTypeId == accBalevelSBCRecordTypeId ){
                         parentIdsSet.add(accStructCase.parentId);
                     }
                }
                if(!parentIdsSet.isEmpty()) {
                    Map<Id,Case> parentSbcCasesMap = new Map<Id,Case>([select id, ownerId from case where id in :parentIdsSet and recordTypeId =: sbcRecordTypeId  ]);
                    List<Case> submissionCases_toUpdate = new List<Case>();
                    for(Case accStructCase : casesList) {
                        if(parentSbcCasesMap.get(accStructCase.parentId) != null) {
                            accStructCase.ownerId = parentSbcCasesMap.get(accStructCase.parentId).ownerId;                        
                        }
                    }                
                }
           }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.setSBCBACaseOwner(List<Case> newCaseList)','High');              
           }
     } 
    /******************************************************************** 
    *    Method Name : createAccountSetupOnAllBAsApproved
    Action
    *   @description :   This method to create Account setup case when all ba screenings approved(Method is for October release Hot fix)
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
     public static void createAccountSetupOnAllBAsApproved(List<Case> casesList,Map<Id,Case> oldCaseMap) {
         
         Id screeningParentTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();      
         Id accSubRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
         try {
             Set<Id> submissionIdsSet = new Set<Id>();
             Set<Id> recordTypeIdsSet = new Set<Id>{screeningParentTypeId,accSubRecordTypeId};
             List<Case> setupCasesList = new List<Case>();
             for(Case parentScreeningCase : casesList) {
             System.debug('parentScreeningCase======>'+parentScreeningCase);
             System.debug('status======>'+parentScreeningCase.status);
             System.debug('All_Screening_Routed_In_Error__c======>'+parentScreeningCase.GEMS_All_Screening_Routed_In_Error__c);
                if(parentScreeningCase.recordTypeId == screeningParentTypeId && ( ((parentScreeningCase.status == 'Approved' || parentScreeningCase.status == 'Routed In Error') 
                    && parentScreeningCase.status != oldCaseMap.get(parentScreeningCase.id).status)) ) {
                        submissionIdsSet.add(parentScreeningCase.GEMS_Account_Submission_Info__c);
                }
             }
             
             if(!submissionIdsSet.isEmpty()) {
                List<Case> allSubmisionAndParentScreeningCasesList = [select id,GEMS_Products__c ,ownerId,casenumber,status,GEMS_All_Screening_Routed_In_Error__c,recordTypeId, GEMS_Line_of_Business__c, Funding_Type_Multiselect__c, 
                    accountId, GEMS_Effective_Date__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, FSU_Location__c, HCSC_Division__c, GEMS_Account_Submission_Info__c, GEMS_StdCust_Product__c,
                    GEMS_Submission_Sub_Type__c, Account.name, Account.External_ID__c, GEMS_Rx_Vendor__c, GEMS_Private_Exchange__c, GEMS_Private_Exchange_Values__c, 
                    Underwriter_Lookup__c, Opportunity_Name__c,(select id,casenumber,status,GEMS_Products__c,GEMS_All_Screening_Routed_In_Error__c,recordTypeId, Sub_Category__c,ownerId from Cases1__r where recordTypeId In : recordTypeIdsSet ) from case where Id in :submissionIdsSet ];
                List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
                Case structureCase = null;
                 //Retreiving account specialist details assigned to Submission case to be assigned as Quality Reviewer. #4995
                map<Id, Id> AccountSpecialists = new map<Id, Id>();
                list<caseteammember> listteammembers = [select parentid, teamrole.name, memberid, member.name from caseteammember where teamrole.name = 'Account Specialist' and parentid in : submissionIdsSet];
                for(caseteammember ctm: listteammembers)
                {
                    AccountSpecialists.put(ctm.parentid, ctm.memberid);
                }
                for(Case submissionCase : allSubmisionAndParentScreeningCasesList) {
                    Boolean allParentCasesApproved = true;
                    Case setupScreeningCase = null;
                    Boolean setupAlreadyExist = false;
                    for(Case parentCase : submissionCase.Cases1__r) {
                        if(parentCase.recordTypeId == accSubRecordTypeId) {
                            setupAlreadyExist = true;
                            break;
                        }
                        if(parentCase.Sub_Category__c == 'Account Setup Screening') {
                            setupScreeningCase = parentCase;
                        }
                        if(parentCase.status != 'Approved' && parentCase.status != 'Routed In Error') {
                            allParentCasesApproved = false;
                            break;
                        }
                    }
                    if(!setupAlreadyExist && allParentCasesApproved) {
                        Case accSubProcessNewParentCase = new Case();
                        DateTime effectiveDate = submissionCase.GEMS_Effective_Date__c;
                        accSubProcessNewParentCase.Type = 'Account Setup Process';
                        accSubProcessNewParentCase.recordtypeid=accSubRecordTypeId;
                        accSubProcessNewParentCase.GEMS_Line_of_Business__c = submissionCase.GEMS_Line_of_Business__c;
                        accSubProcessNewParentCase.GEMS_Rx_Vendor__c = submissionCase.GEMS_Rx_Vendor__c;
                        accSubProcessNewParentCase.Accountid=submissionCase.accountId;
                        accSubProcessNewParentCase.GEMS_Effective_Date__c=submissionCase.GEMS_Effective_Date__c;
                        accSubProcessNewParentCase.GEMS_Case_Effective_Date__c = submissionCase.GEMS_Case_Effective_Date__c;
                        accSubProcessNewParentCase.GEMS_Submission_Type__c=submissionCase.GEMS_Submission_Type__c;
                        accSubProcessNewParentCase.FSU_Location__c=submissionCase.FSU_Location__c;
                        accSubProcessNewParentCase.Status='In Progress';
                        accSubProcessNewParentCase.parentid = submissionCase.Id;
                        accSubProcessNewParentCase.HCSC_Division__c=submissionCase.HCSC_Division__c;                        
                        accSubProcessNewParentCase.GEMS_Submission_Sub_Type__c=submissionCase.GEMS_Submission_Sub_Type__c;
                        accSubProcessNewParentCase.GEMS_Account_Submission_Info__c=submissionCase.Id;
                        accSubProcessNewParentCase.Subject=submissionCase.Account.name+' '+submissionCase.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' Account Setup Process';
                        accSubProcessNewParentCase.GEMS_Private_Exchange__c = submissionCase.GEMS_Private_Exchange__c;     
                        accSubProcessNewParentCase.GEMS_Private_Exchange_Values__c = submissionCase.GEMS_Private_Exchange_Values__c;
                        accSubProcessNewParentCase.Opportunity_Name__c = submissionCase.Opportunity_Name__c;
                        accSubProcessNewParentCase.Underwriter_Lookup__c = submissionCase.Underwriter_Lookup__c;
                        accSubProcessNewParentCase.GEMS_Submitter__c = submissionCase.ownerId;
                        // This population is for October Hotfix 2016
                        accSubProcessNewParentCase.Funding_Type_Multiselect__c = submissionCase.Funding_Type_Multiselect__c;                
                        accSubProcessNewParentCase.GEMS_StdCust_Product__c = submissionCase.GEMS_StdCust_Product__c;                                                                        
                        accSubProcessNewParentCase.GEMS_Products__c = submissionCase.GEMS_Products__c;
                        accSubProcessNewParentCase.GEMS_Quality_Reviewer__c = AccountSpecialists.get(submissionCase.id);
                        accSubProcessNewParentCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = submissionCase.ownerId;
                        
                        if(setupScreeningCase != null) {
                            accSubProcessNewParentCase.ownerId = setupScreeningCase.ownerId;
                        }
                        if(!activeEntitlement.isEmpty()) {
                            System.debug('activeEntitlement===enter into if====>');
                            accSubProcessNewParentCase.EntitlementId = activeEntitlement[0].id;
                        }
                        setupCasesList.add(accSubProcessNewParentCase);
                    } else {
                        System.debug('Already account setup exists===>'+submissionCase.Id);
                    }
                }
                Map<Id,Case> accountSetupCaseMap = new Map<Id,Case>();
                List<Task> taskInsertList = new List<Task>();
                Database.SaveResult[] childSaveResult;
                if(!setupCasesList.isEmpty()) {
                    childSaveResult = Database.insert(setupCasesList);
                }               
                if(childSaveResult != null) {
                    for(Case casesss : setupCasesList) {
                        accountSetupCaseMap.put(casesss.Id,casesss);                        
                    }
                    for(Database.SaveResult sr:childSaveResult) {
                         if(sr.isSuccess()) {
                            Case childRecord = accountSetupCaseMap.get(sr.getId());
                            Task baLevelAccSetUpTask= new Task();
                            baLevelAccSetUpTask.WhatId=childRecord.Id;
                            baLevelAccSetUpTask.Subject='BlueSTAR Entry Complete';
                            baLevelAccSetUpTask.Status='In Progress';
                            baLevelAccSetUpTask.Priority='Normal';
                            baLevelAccSetUpTask.GEMS_Start_Date__c = System.now();
                            baLevelAccSetUpTask.ownerId = childRecord.ownerId;
                            taskInsertList.add(baLevelAccSetUpTask);
                         }
                    }
                     if(!taskInsertList.isEmpty()) {
                        Database.insert(taskInsertList);
                    }
                }
             }
         }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createAccountSetupOnAllBAsApproved(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
         }
     }
     
  /******************************************************************** 
    *    Method Name : updateUnderwriterFlagOnMedicalBenefitCodingCase
    Action
    *   @description :   This method to update Underwriter Flg to true if medical underwriting case approved on Medical benefit Coding case (Method is for October release Hot fix)
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void updateUnderwriterFlagOnMedicalBenefitCodingCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        try {
            GEMS_CaseTriggerHandler.SubmitterFutureClass submissionFuture = new GEMS_CaseTriggerHandler.SubmitterFutureClass();
            submissionFuture.submissionCaseList = newCaseList;
            submissionFuture.oldCaseMap = oldCaseMap;
            updateUnderwriterFlagOnMedicalBenefitCodingCasesFuture(JSON.serializePretty(submissionFuture));
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateUnderwriterFlagOnMedicalBenefitCodingCase(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
         }
    }
    
    @future
    public static void updateUnderwriterFlagOnMedicalBenefitCodingCasesFuture(string scclass) {
        
        GEMS_CaseTriggerHandler.SubmitterFutureClass hl = (GEMS_CaseTriggerHandler.SubmitterFutureClass) JSON.deserialize(scclass, GEMS_CaseTriggerHandler.SubmitterFutureClass.class);
        
        try {
            updateUnderwriterFlagOnMedicalBenefitCoding(hl.submissionCaseList, hl.oldCaseMap);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateUnderwriterFlagOnMedicalBenefitCodingCasesFuture(string scclass)','High');
        }
        
    }
    
    /******************************************************************** 
    *    Method Name : updateUnderwriterFlagOnMedicalBenefitCoding
    Action
    *   @description :   This method to update Underwriter Flg to true if medical underwriting case approved on Medical benefit Coding case (Method is for October release Hot fix)
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void updateUnderwriterFlagOnMedicalBenefitCoding(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        try {

            Id caseGEMSMedicalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
            Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
            Id caseGEMSDentalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
            Id caseGEMSAccountSubmissionRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            Id caseGEMSAccountMaintRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
            Set<Id> caseIds = new Set<Id>();                        
            Set<Id> recordTypeIdsSet = new Set<Id>{caseGEMSMedicalBenfCodingRecordTypeId,caseGEMSDentalBenfCodingRecordTypeId,caseGEMSAccountSubmissionRecordTypeId};
            List<Case> medicalBenefitCodingCasesToUpdateList = new List<Case>();
            Map<Id,Case> approvedCasesMap = new Map<Id,Case>();
            for(Case case_new : newCaseList) {
                if((case_new.recordTypeId == caseGEMSMedicalRecordTypeId )&& case_new.status !=  oldCaseMap.get(case_new.id).status && case_new.isClosed) {
                    caseIds.add(case_new.GEMS_Account_Submission_Info__c);
                    approvedCasesMap.put(case_new.GEMS_Account_Submission_Info__c,case_new);
                }                 
            }
            if(!caseIds.isEmpty()) {
               // SFDC-9360
               // List<Case> medicalBenefitCaseList = [select id, recordTypeId, casenumber, GEMS_XAccountHas_signed_2017BPA_attached__c, GEMS_Underwriter_Flag__c from case where GEMS_Account_Submission_Info__c in :caseIds and recordTypeId In : recordTypeIdsSet ];
                List<Case> medicalBenefitCaseList = [select id, recordTypeId, casenumber, GEMS_XAccountHas_signed_2017BPA_attached__c, GEMS_Underwriter_Flag__c from case where GEMS_Account_Submission_Info__c in :caseIds];
                List<Case> submissionCaseList = [select id, casenumber, recordTypeId, GEMS_XAccountHas_signed_2017BPA_attached__c, GEMS_Underwriter_Flag__c from case where Id in :caseIds and recordTypeId =: caseGEMSAccountSubmissionRecordTypeId];
                List<Case> maintenanceCaseList = [select id, casenumber, recordTypeId, GEMS_XAccountHas_signed_2017BPA_attached__c, GEMS_Underwriter_Flag__c from case where Id in :caseIds and recordTypeId =: caseGEMSAccountMaintRecordTypeId];
                if(!medicalBenefitCaseList.isEmpty()) {
                    if(submissionCaseList != null && !submissionCaseList.isEmpty()) {
                        medicalBenefitCaseList.addAll(submissionCaseList);                       
                    }
                    if(maintenanceCaseList != null && !maintenanceCaseList.isEmpty()) {                        
                        medicalBenefitCaseList.addAll(maintenanceCaseList);
                    }
                    for(Case medicalBenefitCoding : medicalBenefitCaseList) {
                        Boolean needToUpdate = false;
                        if(medicalBenefitCoding.recordTypeId == caseGEMSAccountSubmissionRecordTypeId && approvedCasesMap.get(medicalBenefitCoding.Id) != null 
                            && approvedCasesMap.get(medicalBenefitCoding.Id).GEMS_XAccountHas_signed_2017BPA_attached__c != null) {
                            medicalBenefitCoding.GEMS_XAccountHas_signed_2017BPA_attached__c = approvedCasesMap.get(medicalBenefitCoding.Id).GEMS_XAccountHas_signed_2017BPA_attached__c;
                            needToUpdate = true;
                        }
                        if(!medicalBenefitCoding.GEMS_Underwriter_Flag__c) {
                            medicalBenefitCoding.GEMS_Underwriter_Flag__c = true;
                            needToUpdate = true;                            
                        }
                        if(needToUpdate)
                            medicalBenefitCodingCasesToUpdateList.add(medicalBenefitCoding);                                                    
                         
                    }
                    if(!medicalBenefitCodingCasesToUpdateList.isEmpty()) {
                        update medicalBenefitCodingCasesToUpdateList;
                    }              
                }
             }
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateUnderwriterFlagOnMedicalBenefitCodingCase(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
         }
    }
    
    /******************************************************************** 
    *    Method Name : updateSubmitterInStructureCase
    Action                October Release
    *   @description :   This method to call future class which update Submitter field in Account Structure if owner changed in Account Submission
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void updateSubmitterFieldFutureCall(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        try {
            GEMS_CaseTriggerHandler.SubmitterFutureClass submissionFuture = new GEMS_CaseTriggerHandler.SubmitterFutureClass();
            submissionFuture.submissionCaseList = newCaseList;
            submissionFuture.oldCaseMap = oldCaseMap;
            updateSubmissionCasesFuture(JSON.serializePretty(submissionFuture));
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateSubmitterFieldOnSubmissionCase(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
         }
    }
    
    @future
    public static void updateSubmissionCasesFuture(string scclass) {
        
        GEMS_CaseTriggerHandler.SubmitterFutureClass hl = (GEMS_CaseTriggerHandler.SubmitterFutureClass) JSON.deserialize(scclass, GEMS_CaseTriggerHandler.SubmitterFutureClass.class);
        
        try {
            updateSubmitterInStructureCase(hl.submissionCaseList, hl.oldCaseMap);
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateSubmissionCasesFuture(string scclass)','High');
        }
        
    }
    
    /******************************************************************** 
    *    Method Name : updateSubmitterInStructureCase
    Action
    *   @description :   This method to update Submitter field in Account Structure if owner changed in Account Submission(October Release)
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void updateSubmitterInStructureCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        Id caseGEMSAccountSubmissionRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseGEMSAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseGEMSScreeningRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        Id caseGEMSMedicalBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Id caseGEMSAccountSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Id caseGEMSPharmacyCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Id caseGEMSDentalBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Id caseGEMSSBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();       
        Id caseGEMSBALevelSBCRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        Id caseGEMSMedicalUWRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id caseGEMSDentalUWRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id caseGEMSAdditionalUWRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
        Id caseGEMSEligibilityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        Id caseGEMSAccountSpecialistRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Request Resource').getRecordTypeId();
        //#SFDC-4719
        Id caseGEMSAccountSetUpMaintenanceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        Id caseGEMSCosmeticAccountMaintenanceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        //#SFDC-4719
        Set<Id> caseIds = new Set<Id>();
        List<Case> structureCasesList = new List<Case>();
        Set<Id> recordTypeIdsSet = new Set<Id>{caseGEMSAccountStructureRecordTypeId,caseGEMSScreeningRecordTypeId,caseGEMSMedicalBCRecordTypeId
        ,caseGEMSAccountSetupRecordTypeId,caseGEMSPharmacyCodingRecordTypeId,caseGEMSDentalBCRecordTypeId,caseGEMSSBCRecordTypeId,caseGEMSBALevelSBCRecordTypeId
        ,caseGEMSMedicalUWRecordTypeId,caseGEMSDentalUWRecordTypeId,caseGEMSAdditionalUWRecordTypeId,caseGEMSEligibilityRecordTypeId,caseGEMSAccountSpecialistRecordTypeId,caseGEMSAccountSetUpMaintenanceRecordTypeId};
        try {
            for(Case case_new : newCaseList) {
                if((case_new.recordTypeId == caseGEMSAccountSubmissionRecordTypeId || case_new.recordTypeId == caseGEMSCosmeticAccountMaintenanceRecordTypeId )&& case_new.ownerId !=  oldCaseMap.get(case_new.id).ownerId) {
                    caseIds.add(case_new.Id);
                }                 
            }
            if(!caseIds.isEmpty()) {
                List<Case> structureCaseList = [select id, casenumber, GEMS_Submitter__c,GEMS_Account_Submission_Info__r.ownerId from case where GEMS_Account_Submission_Info__c in :caseIds and recordTypeId In : recordTypeIdsSet ];
                if(!structureCaseList.isEmpty()) {
                    for(Case structureCase : structureCaseList) {
                        if(structureCase.GEMS_Submitter__c != structureCase.GEMS_Account_Submission_Info__r.ownerId) {
                            structureCase.GEMS_Submitter__c = structureCase.GEMS_Account_Submission_Info__r.ownerId;
                            structureCasesList.add(structureCase);                                
                        }
                    }
                    if(!structureCasesList.isEmpty()) {
                        update structureCasesList;
                    }
                }
            }
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateSubmitterInStructureCase(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
         }
    }
    
    public class SubmitterFutureClass{
        public List<Case> submissionCaseList = new list<case>();
        public Map<Id,Case> oldCaseMap = new Map<Id,Case>();        
    }
       /******************************************************************** 
    *    Method Name : parentStatusChangeOnChildPharmacyCaseChange
    Action
    *   @description :   This method to update Parent case when all child process cases of all BA's approved
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void parentStatusChangeOnChildPharmacyCaseChange(List<Case> casesList,Map<Id,Case> oldCaseMap) {
        
        Id pharmacyCodingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        Id accountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();        
        Set<String> completedParentCaseIds = new Set<String>();
        List<Case> parentStatusCompleteUpdationList = new List<Case>();
        List<Id> caseSubmissionIdsList = new List<Id>();
        Map<Id,List<GEMS_Benefit_Agreement__c>> submissionBaMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
        List<Case> parentStatusUpdationList = new List<Case>();
        try {
            for(case caserec : casesList) {
                if((caserec.status == 'Completed' || caserec.status == 'AS400 & BlueStar Update Completed') && (caserec.status != oldCaseMap.get(caserec.Id).status) && caserec.recordTypeId == pharmacyCodingCasesRecordTypeId) {
                    completedParentCaseIds.add(caserec.parentId);
                    caseSubmissionIdsList.add(caserec.GEMS_Account_Submission_Info__c);
                }            
             }
             if(!completedParentCaseIds.isEmpty()) {  
                 List<Case> parentChildCasesList = [select id,casenumber,recordtypeId, isClosed, Status, parentId,GEMS_Effective_Date__c,Accountid,GEMS_Account_Submission_Info__c,Account.name,Account.External_ID__c,(select id, isClosed, casenumber,status from Cases where recordtypeid=:pharmacyCodingCasesRecordTypeId) from case where id in : completedParentCaseIds ];
                 Boolean allChildSameStatus = true;
                 // SFDC-4244 Added new field filter for BA
                 List<Case> structureCsesWithBA = [select id,casenumber,recordtypeId, status, parentId,GEMS_Account_Submission_Info__c,
                (select id, Name from GEMS_Benefit_Agreements__r where HAS_GROUP_SECTIONS__C =true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true ) from case where GEMS_Account_Submission_Info__c in : caseSubmissionIdsList and recordTypeId =: accountStructureRecordTypeId  ];
                for(Case structCase : structureCsesWithBA) {
                    List<GEMS_Benefit_Agreement__c> baList = structCase.GEMS_Benefit_Agreements__r;
                    if(baList != null) {
                        submissionBaMap.put(structCase.GEMS_Account_Submission_Info__c,baList);
                    }
                }
                for(Case caseParent : parentChildCasesList) {
                    allChildSameStatus = true;
                    List<Case> childCases = caseParent.cases;
                    String firstCaseStatus = null;
                    Boolean isCompletedFlag = false;
                    Boolean isAS400Flag = false;              
                    if(submissionBaMap.get(caseParent.GEMS_Account_Submission_Info__c) != null && childCases != null && submissionBaMap.get(caseParent.GEMS_Account_Submission_Info__c).size() == childCases.size()){
                        for(Case casss : childCases) {
                            if(!casss.isClosed) {
                               isCompletedFlag = false;
                               isAS400Flag = false;
                               break;
                            }
                            else if(casss.status == 'Completed'){
                                isCompletedFlag = true;
                            }
                            else if(casss.status == 'AS400 & BlueStar Update Completed'){
                                isAS400Flag = true;
                            }
                        }
                        if(isCompletedFlag && isAS400Flag) {
                            caseParent.status = 'Completed';
                            parentStatusUpdationList.add(caseParent);                    
                        }
                    }
                }
            }
            if(!parentStatusUpdationList.isEmpty()) {
                update parentStatusUpdationList;
            }   
        }
        catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.parentStatusChangeOnChildPharmacyCaseChange(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
        } 
    }
    
    /*public static void duplicateProcessParentCheck(List<Case> casesList) {
        //try {
            Id dentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();            
            Id medicalBALevelSubRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();            
            Id ePORecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
            Set<Id> submissionIdsSet = new Set<Id>();
            Set<Id> recordTypeIdsSet = new Set<Id>{dentalRecordTypeId,medicalBALevelSubRecordType,ePORecordType};
            for(case caserec : casesList) {
                if(caserec.recordTypeId == dentalRecordTypeId || caserec.recordTypeId == medicalBALevelSubRecordType || caserec.recordTypeId == ePORecordType) {
                    submissionIdsSet.add(caserec.GEMS_Account_Submission_Info__c);
                } 
            }
            if(!submissionIdsSet.isEmpty()) {
                Map<Id,Case> processCasesMap = new Map<Id,Case>([select id, caseNumber,(select id,caseNumber,subject from cases1__r where recordTypeId in : recordTypeIdsSet And GEMS_Account_Submission_Info__c in : submissionIdsSet) from case where ID IN : submissionIdsSet ]);
                for(case caserec : casesList) {
                    if(processCasesMap != null && processCasesMap.get(caserec.GEMS_Account_Submission_Info__c) != null 
                        && processCasesMap.get(caserec.GEMS_Account_Submission_Info__c).cases1__r != null 
                        && !processCasesMap.get(caserec.GEMS_Account_Submission_Info__c).cases1__r.isEmpty() ) {
                        caserec.addError('There is some other process is creating cases pleaase aprove after a while');
                    }
                }
            }
        /*}catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.duplicateProcessParentCheck(List<Case> casesList)','High');              
        } 
    }*/
    
    /******************************************************************** 
    *    Method Name : childCaseStatusTOCancelled
    *   @description :   This method is to cancel all downstream cases and related tasks when an account submission case is cancelled
    *   @parameters  :   List<Case> updatedParentCases, List<Case> oldCases
    *   @return type :   void
    *   @Author : Rajeesha/Lakshmi
    ***************************************************************/

    public static void childCaseStatusTOCancelled( List<Case> updatedParentCases, Map<Id,Case> oldCaseStatusMap)
    {
        Id accountSubmissionRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id medicalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id dentalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id additionalUnderwritingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
        //5235 Automatically cancel tasks when UW case is cancelled
        Map<Id,String> rtid = new Map<Id,String>{};
        rtid.put(accountSubmissionRecordTypeId,accountSubmissionRecordTypeId);
        Map<Id,String> uwid = new Map<Id,String>{};
        uwid.put(medicalUnderwritingRecordTypeId ,medicalUnderwritingRecordTypeId );
        uwid.put(dentalUnderwritingRecordTypeId ,dentalUnderwritingRecordTypeId );
        uwid.put(additionalUnderwritingRecordTypeId ,additionalUnderwritingRecordTypeId );
        List<Case> childrentoupdate = new List<Case>();
        Map<id,string> childTask = new Map<id,string>();
        List<Task> relatedTask = new List<Task>();
        Map<Id, Id> parentIds = new Map<Id, Id>();
        Map<Id,String> scopeIds = new Map<Id,String>();
        System_Admin__c sysAdm = System_Admin__c.getInstance();
        String sysAdmin = sysAdm.Profile_Id__c;
        boolean hasNoCancelledCase = true;
        
        // check if there's any case in Cancelled status, if none, exit immediately
        for(Case p:updatedParentCases){
            if(p.status != oldCaseStatusMap.get(p.Id).status && p.status == 'Cancelled' && (p.RecordTypeId == rtid.get(p.RecordTypeId) || p.RecordTypeId == uwid.get(p.RecordTypeId))){
                hasNoCancelledCase = false;
                break;
            }
        }
        if(hasNoCancelledCase) return;
                
        for(Case p:updatedParentCases){
            if((p.status != oldCaseStatusMap.get(p.Id).status && p.status == 'Cancelled' && (p.RecordTypeId == rtid.get(p.RecordTypeId) || p.RecordTypeId == uwid.get(p.RecordTypeId)) && 
                (p.ownerId == UserInfo.getUserId() || GEMS_Utility.perm != Null || UserInfo.getProfileId() == sysAdmin))){
                    scopeIds.put(p.Id,p.ownerid);
                    if(p.RecordTypeId == rtid.get(p.RecordTypeId)){
                        parentIds.put(p.Id,p.ownerid);
                    }
                }   
        }
        if(!parentIds.isEmpty()){     
        List<Case> rs = [Select Id,Status,CaseNumber,isClosed,RecordTypeId  from Case where GEMS_Account_Submission_Info__c IN : parentIds.keyset()];      
        List<GEMS_Pharmacy_Scope_Code__c> sCode = [Select id, Case__c, Status__c,  Case__r.GEMS_Account_Submission_Info__c from GEMS_Pharmacy_Scope_Code__c where  Case__r.GEMS_Account_Submission_Info__c IN : parentIds.keyset()];
        
                   for(Case relatedcases: rs){
                       childTask.put(relatedcases.id,relatedcases.status);
                       if(!relatedcases.isClosed && relatedcases.Status != 'Project Cancelled' && relatedcases.Status != 'BlueSTAR Sent'
                           && relatedcases.Status != 'BlueSTAR Failed' && relatedcases.Status != 'BlueSTAR Shell Created' && relatedcases.Status != 'BlueSTAR Partial Fail'
                           && relatedcases.Status != 'Completed – Without SIGNED BPA'){
                            relatedcases.Status = 'Cancelled';
                            childrentoupdate.add(relatedcases);
                            
                        } }
                   
                    for(GEMS_Pharmacy_Scope_Code__c scopeRelatedCases : sCode){
                           scopeIds.put(scopeRelatedCases.id,scopeRelatedCases.Status__c);
                      
                   }
        }
        
        if(!childTask.isEmpty()){           
              //SFDC-5140 GEMS - Automatically cancel tasks when associated case is cancelled
              List<Task> rt = [Select id, status,Closed_Date__c,WhatId from task where whatid IN : childTask.keyset() and isclosed = false
                               and Status Not IN ('Approved','Cancelled','Project Cancelled')]; 

              for(Task caseTask : rt){
                          caseTask.Status = 'Cancelled';
                          caseTask.Closed_Date__c = System.Now();
                          relatedTask.add(caseTask);          
               }
        }
        
        if(!scopeIds.isEmpty()){
              List<Task> srt = [Select id, status,Closed_Date__c,WhatId from task where whatid IN : scopeIds.keyset() and isclosed = false
                               and Status Not IN ('Approved','Cancelled','Project Cancelled')];        
               for(Task scopeCaseTask : srt){
                          scopeCaseTask.Status = 'Cancelled';
                          scopeCaseTask.Closed_Date__c = System.Now();
                          relatedTask.add(scopeCaseTask);          
               }
        }
             //End of SFDC-5140
        if(!childrentoupdate.isEmpty()){
              updateParentStatus = true;   
              update childrentoupdate; 
        }
        if(!relatedTask.isEmpty()){
              update relatedTask;
        }
     
     }
     
     
    
     
 /******************************************************************** 
    *    Method Name : cancelDownstreamAccountMaintenanceCases
    *   @description :   This method is to cancel all downstream cases when a cosmetic account maintenance case is cancelled
    *   @parameters  :   List<Case> updatedAccountMaintenance, List<Case> oldCaseStatus
    *   @return type :   void
    *   @Author      : Rajeesha
    ***************************************************************/

public static void cancelDownstreamAccountMaintenanceCases( List<Case> updatedAccountMaintenance, Map<id,Case> oldCaseStatus)
 {
 Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
 List<Case> downstreamCases = new List<Case>();
 Map<Id, Id> accountMaintenance = new Map<Id, Id>();
 Map<Id,String> scopeIds = new Map<Id,String>();
 Map<id,string> childTask = new Map<id,string>();
 List<Task> relatedTask = new List<Task>();
 System_Admin__c sysAdm = System_Admin__c.getInstance();
 String sysAdmin = sysAdm.Profile_Id__c;     

 for(Case AM:updatedAccountMaintenance){
         if(AM.status != oldCaseStatus.get(AM.id).status && (AM.ownerId == UserInfo.getUserId() || GEMS_Utility.perm != Null || UserInfo.getProfileId() == sysAdmin) && AM.status == 'Cancelled' && AM.RecordTypeId == rtid){
              
             accountMaintenance.put(AM.Id,AM.ownerid);
             scopeIds.put(AM.Id,AM.ownerid);
                 
          }
     }
if(accountMaintenance.size() > 0){
 List<Case> DS = [Select Id,Status,CaseNumber,isClosed from Case where GEMS_Account_Submission_Info__c IN : accountMaintenance.keyset()]; 
  List<GEMS_Pharmacy_Scope_Code__c> sCode = [Select id, Case__c, Status__c,  Case__r.GEMS_Account_Submission_Info__c from GEMS_Pharmacy_Scope_Code__c where  Case__r.GEMS_Account_Submission_Info__c IN : accountMaintenance.keyset()];
     
         for(Case dsCases: DS){
             childTask.put(dsCases.id,dsCases.status);
             if(!dsCases.isClosed && dsCases.Status != 'Project Cancelled' && dsCases.Status != 'BlueSTAR Sent' 
               && dsCases.Status != 'BlueSTAR Failed' && dsCases.Status != 'BlueSTAR Shell Created' 
               && dsCases.Status != 'BlueSTAR Partial Fail' && dsCases.Status != 'Completed – Without SIGNED BPA'){
                 dsCases.Status = 'Cancelled';
                 downstreamCases.add(dsCases);
              
          }
         for(GEMS_Pharmacy_Scope_Code__c scopeRelatedCases : sCode){
               scopeIds.put(scopeRelatedCases.id,scopeRelatedCases.Status__c);
          }
         //SFDC-5411 Automatically cancel tasks when associated case is cancelled 
         List<Task> rt = [Select id, status,Closed_Date__c,WhatId from task where whatid IN : childTask.keyset() and isclosed = false
                               and Status Not IN ('Approved','Cancelled','Project Cancelled')]; 
              List<Task> srt = [Select id, status,Closed_Date__c,WhatId from task where whatid IN : scopeIds.keyset() and isclosed = false
                               and Status Not IN ('Approved','Cancelled','Project Cancelled')];
              for(Task caseTask : rt){
                          caseTask.Status = 'Cancelled';
                          caseTask.Closed_Date__c = System.Now();
                          relatedTask.add(caseTask);          
               }
               
               for(Task scopeCaseTask : srt){
                          scopeCaseTask.Status = 'Cancelled';
                          scopeCaseTask.Closed_Date__c = System.Now();
                          relatedTask.add(scopeCaseTask);          
               }
          //End of SFDC-5411
          updateParentStatus = true;
          update downstreamCases;
          update relatedTask;    
     }
 
 }
 }
 
 
    /******************************************************************** 
    *    Method Name : preventParentScreeningCaseStatusChange
    *   @description :   This method is to prevent users except System Admin and Super User from changing the Parent screening status  
    *   @parameters  :   List<Case> statusChnage, List<Case> oldParentCaseStatus
    *   @return type :   void
    *   @Author      : Rajeesha
    ***************************************************************/
 
 
    public static void preventParentScreeningCaseStatusChange(List<Case> statusChnage, Map<id,Case> oldParentCaseStatus){
    if(updateParentStatus == false){
    Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
    System_Admin__c sysAd = System_Admin__c.getInstance();
    String sysAdmin = sysAd.Profile_Id__c;
    for(Case screeningParent : statusChnage){
             if((GEMS_Utility.perm == Null && UserInfo.getProfileId() != sysAdmin) && (screeningParent.status != oldParentCaseStatus.get(screeningParent.id).status && screeningParent.RecordTypeId == rtid)){
                 updateParentStatus = true;
                 screeningParent.addError('Cannot manually change parent case status. BA case status automatically updates parent.');
             }
      
         }
         updateParentStatus = true;
      }
      }
      
  /******************************************************************** 
    *   Method Name  : parentEffectivedateUpdateOnChildCaseEffectivedate
    *   @description : This method is to update the Case effective date and Effective date in Downstream cases when it is Updated in Submission or maintanence cases.  
    *   @parameters  : List<Case> statusChnage, Map<Id,Case> oldCaseMap
    *   @return type : void
    *   @Author      : Hari - US 4627
    ***************************************************************/    
      
      public static void parentEffectivedateUpdateOnChildCaseEffectivedate(Map<id,Case> newCaseMap,Map<Id,Case> oldCaseMap) {
     Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
     Id caseAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
     set<id> caseId= new set<id>();
   
     list<case> newCaseList = new list<case>();
     Map<id,string> casemap=new  Map<id,string>();   
          newCaselist.addall(newcasemap.values());
          for(Case newCase : newCaseList) {
              
              if((newCase.recordTypeId == caseAccountSubmissionId || newCase.recordTypeId == caseAccountMaintenanceId) && (newCase.GEMS_Effective_Date__c !=null && (((newCase.GEMS_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Effective_Date__c)))) || (newCase.GEMS_Case_Effective_Date__c !=null && (((newCase.GEMS_Case_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c)))))
                     {            
                                 caseId.add(newCase.id);
                               
                       }
                        if((newCase.GEMS_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Effective_Date__c)&& (newCase.GEMS_Case_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c) )
                            {
                                    casemap.put(newcase.id,GEMS_Constants.EffDatesBoth);
                            }
                        else if(newCase.GEMS_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Effective_Date__c)
                            {
                                    casemap.put(newcase.id,GEMS_Constants.EffectiveDate);
                            }
                        else if(newCase.GEMS_Case_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c)
                            {
                                    casemap.put(newcase.id,GEMS_Constants.CaseEffectiveDate);
                            }
            }
            
            GEMS_casetriggerhandler.dateupdate(caseId,casemap);
            reccheck = true;
            }

            
     @future
     public static void dateupdate(set<id> caseids,Map<id,string> checkmap)
     {
     list<Case> updatedCases = new list<Case>();
     List<Case> childCase = [SELECT id,GEMS_Effective_Date__c,GEMS_Case_Effective_Date__c,Type,Case.GEMS_Account_Submission_Info__r.GEMS_Effective_Date__c,
                                    Case.GEMS_Account_Submission_Info__r.Account_Name__c,case.GEMS_Account_Submission_Info__r.Account_Number__c,
                                    case.GEMS_Account_Submission_Info__r.GEMS_Case_Effective_Date__c,case.GEMS_Account_Submission_Info__r.recordTypeId,case.GEMS_Account_Submission_Info__r.id FROM Case where case.GEMS_Account_Submission_Info__c=:caseIds];
                                    
                                
            if(childCase.size()>0){
                for(Case newCase1 : childCase)
                //Id parentid=newCase1.GEMS_Account_Submission_Info__r.id;
                {
                if(checkmap.get(newCase1.GEMS_Account_Submission_Info__r.id)==GEMS_Constants.EffDatesBoth)
                    {    
                        newCase1.GEMS_Effective_Date__c = newCase1.GEMS_Account_Submission_Info__r.GEMS_Effective_Date__c;
                        newCase1.GEMS_Case_Effective_Date__c = newCase1.GEMS_Account_Submission_Info__r.GEMS_Case_Effective_Date__c;
                        newCase1.Subject=newCase1.GEMS_Account_Submission_Info__r.Account_Name__c+' '+newCase1.GEMS_Account_Submission_Info__r.Account_Number__c +' '+newCase1.GEMS_Account_Submission_Info__r.GEMS_Case_Effective_Date__c.format()+' '+newCase1.Type;
                        updatedCases.add(newCase1);
                    }
                else if(checkmap.get(newCase1.GEMS_Account_Submission_Info__r.id)==GEMS_Constants.EffectiveDate)
                    {    
                        newCase1.GEMS_Effective_Date__c = newCase1.GEMS_Account_Submission_Info__r.GEMS_Effective_Date__c;
                        updatedCases.add(newCase1);
                    }
                else if(checkmap.get(newCase1.GEMS_Account_Submission_Info__r.id)==GEMS_Constants.CaseEffectiveDate)                   
                {    
                         newCase1.GEMS_Case_Effective_Date__c = newCase1.GEMS_Account_Submission_Info__r.GEMS_Case_Effective_Date__c;
                         newCase1.Subject=newCase1.GEMS_Account_Submission_Info__r.Account_Name__c+' '+newCase1.GEMS_Account_Submission_Info__r.Account_Number__c +' '+newCase1.GEMS_Account_Submission_Info__r.GEMS_Case_Effective_Date__c.format()+' '+newCase1.Type;
                         updatedCases.add(newCase1);
                    }}
                }

            if(!updatedCases.isempty()){
            
                      update updatedCases;
            } 
     }
     
     /******************************************************************** 
    *   Method Name  : parentSujectUpdate
    *   @description : This method is to update the Suject when the effective date is Updated in Submission/Maintenance cases.  
    *   @parameters  : List<Case> statusChnage, Map<Id,Case> oldCaseMap
    *   @return type : void
    *   @Author      : Hari - US 4627
    ***************************************************************/
     
     public static void parentSujectUpdate(List<Case> newCaseList,Map<Id,Case> oldCaseMap) {
     Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
     Id caseAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
         for(Case newCase : newCaseList) {
              //SFDC-7735
              if(newCase.recordTypeId == caseAccountSubmissionId){ //SFDC-7734 Remove GEMS Account Maintenance Record Type  
              Boolean changedEffDate = (newCase.GEMS_Case_Effective_Date__c !=null && oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c!=null && newCase.GEMS_Case_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c);
              Boolean newEffDate = (newCase.GEMS_Case_Effective_Date__c !=null && oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c==null && newCase.GEMS_Case_Effective_Date__c!=oldCaseMap.get(newCase.Id).GEMS_Case_Effective_Date__c);                                                    
                  if(changedEffDate || newEffDate)
                  { 
                    newCase.Subject=newCase.Account_Name__c+' '+newCase.Account_Number__c +' '+newCase.GEMS_Case_Effective_Date__c.format()+' '+newCase.Type;
                  }              
              }
              //SFDC-7735
         }
      }
     
    /******************************************************************** 
    *   Method Name  : caseOwnerChange
    *   @description : This method is to update the Case Owner with CIC role team member when the Account team contains active CIC role team member.  
    *   @parameters  : List<Case> statchange
    *   @return type : void
    *   @Author      : Hari - US 6116
    ***************************************************************/
      public static void caseOwnerChange(List<case> newCaseList) {
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_SubmissionCase ).getRecordTypeId();
        Map<id,Case> accountIds=new Map<id,Case>();
        List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
        for(case caseRecord : newCaseList){
            if(caseAccountSubmissionId == caseRecord.recordTypeId && caseRecord.AccountId != null && caseRecord.status ==GEMS_Constants.statusnew) { 
               
                accountIds.put(caseRecord.AccountId,caseRecord);     
            }
            }
        if(accountIds!= null) {
           accountTeamMembers = [Select UserId, User.IsActive, TeamMemberRole, Id, AccountId From AccountTeamMember where TeamMemberRole='Client Implementation Consultant' and User.IsActive = true and accountid in : accountIds.keyset() Order by lastmodifiedDate ASC];        
            }
            if(!accountTeamMembers.isEmpty()){
                Case c=accountids.get(accountTeamMembers[0].accountid);
                C.Ownerid=accountTeamMembers[0].userID;
            }
            
            }
      
     /******************************************************************** 
    *    Method Name : preventStatusChange
    *   @description :   This method is to prevent user from changing the BA level Medical Benefit coding case status
    *   @parameters  :   List<Case> statChange
    *   @return type :   void
    *   @Author      : Rajeesha
    *   //6459 - Logic introduced to use the status of testing records when the status of Case changes from Return to In Progress.
    ***************************************************************/
    
    public static void preventStatusChange(List<Case> statChange, Map<id,Case> oldCase){
        Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        Boolean testfail = false;
        Boolean testinpro = false;
        Boolean testnew = false;
        Boolean testpass = false;
    for(Case child : statChange){
       // if(child.status=='Medical Benefits Production Ready' && child.RecordTypeId==rtid && child.Production_Availability_Date__c==Null){
        //    child.addError('Status is "Medical Benefits Production Ready", Production Availability Date should be entered.');
       // }
        //SFDC_5928 : Update BA level Medical Benefit Coding Case Status to 'Medical Coding Complete' when coding complete date is populated 
        if(child.GEMS_Coding_Complete_Date__c != Null && child.RecordTypeId==rtid && child.GEMS_Coding_Complete_Date__c != oldCase.get(child.id).GEMS_Coding_Complete_Date__c){
            child.status = 'Medical Coding Complete';
        }
        //SFDC-6459 : If the status of BA level Medical Benefit Coding changes from 'Return' to 'In Progress', check the status of related testing records and update to new status.
        if(child.RecordTypeId==rtid && child.status == 'In Progress' && oldCase.get(child.id).status == 'Return'){
            List<GEMS_MBC_Testing__c> checktests = [select Status__c from GEMS_MBC_Testing__c where MBC_BA_Level_Case_CDHP__c =: child.Id OR MBC_BA_Level_Case_DTU__c =: child.Id 
                                              OR MBC_BA_Level_Case_FEAK__c =: child.Id OR MBC_BA_Level_Case_FEAK_Testing__c =: child.Id 
                                              OR MBC_BA_Level_Case_Shared_Accums__c =: child.Id]; 
            for(GEMS_MBC_Testing__c checktest : checktests){
                if(checktest.Status__c == 'Failed'){
                    testfail = true;
                }
                else if(checktest.Status__c == 'In Progress'){
                    testinpro = true;
                }
                else if(checktest.Status__c == 'New'){
                    testnew = true;
                }
                else if(checktest.Status__c == 'Passed'){
                    testpass = true;
                }            
            }
            if(testfail){
                child.Status = 'Testing Failed';
            }
            else if(testinpro){
                child.Status = 'Testing In Progress';
            }
            //SFDC-7246 - Set the status of Case to 'Testing Passed' if the status of testing records are Passed.
            else if(testpass){
                child.Status = 'Testing Passed';
            }
            else if(testnew){
                child.Status = 'Medical Coding Complete';
            }
            // SFDC-7098. Commented to avoid changing the status to 'Medical Benefits Production Ready' when 
            // test records are passed
            /*
            else if(testpass){
                System.Debug('Changing case status to Medical Benefits Production Ready');
                child.Status = 'Medical Benefits Production Ready';
            }
            */
            // SFDC-7098 End
        }
    }
    }

         /******************************************************************** 
    *    Method Name : updateMBCTestEmail
    *   @description :   SFDC-5930 This method will update the testing records with case owner's email when the Medical Benefit Coding case owner is changed.
    *   @parameters  :   List<Case> statChange, Map<id,Case> oldCase
    *   @return type :   void
    *   @Author      : Bharath
    ***************************************************************/
    
    public static void updateMBCTestEmail(List<Case> statChange, Map<id,Case> oldCase){
        Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        Boolean udpateTestRec = false;
        map<id, string> caseEmail = new map<id,string>();
        for(Case child : statChange){
            //Check whether the BA level medical benefit coding owner has changed. 
            if((child.ownerId != oldCase.get(child.Id).ownerId && child.RecordTypeId==rtid) || (child.RecordTypeId==rtid && test.isRunningTest())){
                udpateTestRec = true;
                caseEmail.put(child.Id, child.GEMS_Owner_Email__c);
            }
        }
        //Proceed only if the BA level medical benefit coding owner has changed.
        if(udpateTestRec){
            //Retreive all the testing records which are linked to the case whose owner has changed. 
            list<GEMS_MBC_Testing__c> mbcTestRecs = [select id, Case_Owner_Email__c,MBC_BA_Level_Case_CDHP__c, MBC_BA_Level_Case_DTU__c, MBC_BA_Level_Case_FEAK__c, 
                                               MBC_BA_Level_Case_FEAK_Testing__c,MBC_BA_Level_Case_Shared_Accums__c
                                               from GEMS_MBC_Testing__c where (MBC_BA_Level_Case_CDHP__c in :oldCase.keySet()) OR
                                              (MBC_BA_Level_Case_DTU__c in :oldCase.keySet()) OR (MBC_BA_Level_Case_FEAK__c in :oldCase.keySet()) OR
                                              (MBC_BA_Level_Case_FEAK_Testing__c in :oldCase.keySet()) or (MBC_BA_Level_Case_Shared_Accums__c in :oldCase.keySet())];
            list<GEMS_MBC_Testing__c> updateMBCTest = new list<GEMS_MBC_Testing__c>();
            for(GEMS_MBC_Testing__c mbcTest : mbcTestRecs){
                //Check and process each look-up field in the testing record.
                if (mbcTest.MBC_BA_Level_Case_CDHP__c != NULL){
                    mbcTest.Case_Owner_Email__c = caseEmail.get(mbcTest.MBC_BA_Level_Case_CDHP__c);
                }
                else if (mbcTest.MBC_BA_Level_Case_DTU__c != NULL){
                    mbcTest.Case_Owner_Email__c = caseEmail.get(mbcTest.MBC_BA_Level_Case_DTU__c);
                }
                else if (mbcTest.MBC_BA_Level_Case_FEAK__c != NULL){
                    mbcTest.Case_Owner_Email__c = caseEmail.get(mbcTest.MBC_BA_Level_Case_FEAK__c);
                }
                else if (mbcTest.MBC_BA_Level_Case_FEAK_Testing__c != NULL){
                    mbcTest.Case_Owner_Email__c = caseEmail.get(mbcTest.MBC_BA_Level_Case_FEAK_Testing__c);
                }
                else if (mbcTest.MBC_BA_Level_Case_Shared_Accums__c != NULL){
                    mbcTest.Case_Owner_Email__c = caseEmail.get(mbcTest.MBC_BA_Level_Case_Shared_Accums__c);
                }
                    if(mbcTest.Case_Owner_Email__c == NULL){
                        mbcTest.Case_Owner_Email__c = system.label.GEMS_Noreply;
                    }
                    updateMBCTest.add(mbcTest);
            }
            update updateMBCTest;
        }
    }
  
    /******************************************************************** 
    *    Method Name :  updateBAProductIsNew
    *   @description :  This method adds BA details to Case object from Business Agreement object.  
    *   @parameters  :   List<Case> ProcessCases (trigger.new)
    *   @return type :   void
    *   @Author      : Bharath
    ***************************************************************/
    public static void updateBADetails(List<Case> ProcessCases){
        if(GEMS_CaseTriggerHandler.upBArecurchk){
        List<case> toupdateCases = new List<case>();
        List<id> agreementIDs = new List<id>();
        map<id,GEMS_Benefit_Agreement__c> agreementMap = new map<id,GEMS_Benefit_Agreement__c>();
        List<case> updateCases = new List<case>();
        Map<id,Case> caseBA = new Map<id,Case>();
        set<Id> forBARecordType = new set<Id>();
        //5102 Include all the record types where the BA level details are required to be added.
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId());
        forBARecordType.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId());
        for (Case checkCase : ProcessCases){
            if(checkCase.GEMS_Benefit_Agreement__c != NULL && checkCase.BA_Product__c == NULL && forBARecordType.contains(checkCase.recordTypeId)){
                toupdateCases.add(checkCase);
                agreementIDs.add(checkCase.GEMS_Benefit_Agreement__c);
            }
        }
       //For the cases being updated, process only when the cases which have BA assigned, and BA Product is empty.
      // SFDC-4244 Added new field filter for BA
        if(toupdateCases.size()>0){
            list<GEMS_Benefit_Agreement__c> agreements = [select id, product__c, isnew__c from GEMS_Benefit_Agreement__c where 
                                                            ID in : agreementIDs and GEMS_BAs_SpHandling__c = true];
            if(agreements.size()>0){
                for(GEMS_Benefit_Agreement__c am : agreements){
                        agreementMap.put(am.Id, am);
                }
                for (Case changeCase : ProcessCases){
                    try{
                    //Update the Product and IsNew details from the GEMS Benefit Agreement object.
                        changeCase.BA_Product__c = agreementMap.get(changeCase.GEMS_Benefit_Agreement__c).product__c;
                        changeCase.IsNew__c = agreementMap.get(changeCase.GEMS_Benefit_Agreement__c).IsNew__c;
                    }
                    catch (exception ex){
                        GEMS_CaseTriggerHandler.upBArecurchk=false;
                        System.debug('==exception='+ex.getMessage());
                        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 
                                                          'GEMS_caseTriggerHandler.updateBADetails(List<Case> ProcessCases)','High');  
                    }
                }
            }
          }
         GEMS_CaseTriggerHandler.upBArecurchk = false; 
       }         
    }
    
    
 /******************************************************************* 
    *   Method Name  :  parentStatusUpdation
    *   @description :  Method updates Account Structure Maintenance Submission case to Completed, if Medical UW and Dental UW cases exists and are approved. As part of SFDC-5248 AND SFDC-5249
                        Method updates Account Eligibility Maintenance case to completed, if Membership case status is 'Completed'.As part of SFDC-5589
                        Method updates Rate Change Maintenance case to Completed, if Medical UW and Dental UW cases exists and are approved. As part of SFDC-5762
    *   @parameters  :  List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :  void     
    *   @Author      :  Phani,SreeHarsha and Lakshmi 
     ***************************************************************/
    public static void parentStatusUpdation(List<Case> casesList,Map<Id,Case> oldCaseMap) {
        Set<ID> submissionCases = new Set<ID>();
        Set<String> caseTypeSet = new Set<String>{GEMS_Constants.TypeMedicalUnderwriting,GEMS_Constants.TypeDentalUnderwriting,GEMS_Constants.TypeEligibilityProcess,GEMS_Constants.TypeMembership,GEMS_Constants.TypeAccountSetupMaintenance};
        //get all Account Structure Maintenance Submission cases for approved medical underwriting or approved dental underwriting
        //get All Account Eligibility Maintenance cases for Completed Membership Cases
        //Get All Rate Change Maintenance cases for Approved Medical Cases
        for(case childCase : casesList) {
            if((((childCase.status == GEMS_Constants.StatusApproved && caseTypeSet.contains(childCase.Type)) || 
                 (childCase.status == GEMS_Constants.StatusCompleted && caseTypeSet.contains(childCase.Type))) && childCase.status != oldCaseMap.get(childCase.Id).status && childCase.GEMS_Submission_Type__c == 'Account Structure Maintenance') ||  // 7742
                 (childCase.status == GEMS_Constants.StatusCompleted && caseTypeSet.contains(childCase.Type) && childCase.status != oldCaseMap.get(childCase.Id).status && childCase.GEMS_Submission_Type__c == 'Account Eligibility Maintenance') ||
                 (childCase.status == GEMS_Constants.StatusCompleted && caseTypeSet.contains(childCase.Type) && childCase.status != oldCaseMap.get(childCase.Id).status && childCase.GEMS_Submission_Type__c == 'AEP File Maintenance') || //5842 // 7742
                 (childCase.status == GEMS_Constants.StatusApproved && caseTypeSet.contains(childCase.Type) && childCase.status != oldCaseMap.get(childCase.Id).status && childCase.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeRCM) ||//7734
                 (childCase.status == GEMS_Constants.StatusCompleted && caseTypeSet.contains(childCase.Type) && childCase.status != oldCaseMap.get(childCase.Id).status && childCase.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeIDCardMaintenance)) {

                submissionCases.add(childCase.gems_account_submission_info__c);  
            }
        }
      
        //if submissionCases not found exit
        if(!submissionCases.isEmpty()) {
            boolean medicalUWApproved = false;
            boolean dentalUWApproved = false;
            boolean medicalUWExists = false;
            boolean dentalUWExists = false;
            boolean eligProcessExists = false;
            boolean eligProdCompStatus = false;
            boolean membershipcaseComplete = false;
            boolean membershipcaseExists = false;
            boolean idCardAccountSetupMaintenanceExists = false;
            boolean idCardAccountSetupMaintenanceComplete = false;
            // 7742
            boolean setupCaseExists = false;
            boolean setupCaseRelUW = false;
            
            List<Case> submissionCasesMarkCompleted = new List<Case>();
            List<Case> parentChildCasesList = [select Id,Type,GEMS_Type__c,Status,(select id,status,type,GEMS_Submission_Type__c from Cases1__r),GEMS_Submission_Type__c, GEMS_Products__c From Case Where id in : submissionCases];
            if(!parentChildCasesList.isEmpty()){
                for(case caserec : parentChildCasesList){
                    medicalUWExists = false;
                    medicalUWApproved = false;
                    dentalUWExists = false;
                    dentalUWApproved = false;
                    eligProcessExists = false;
                    eligProdCompStatus = false;
                    membershipcaseExists = false;
                    membershipcaseComplete = false;
                    idCardAccountSetupMaintenanceExists = false;
                    idCardAccountSetupMaintenanceComplete = false;
                    // 7742
                    setupCaseExists = false;
                    setupCaseRelUW = false;                    
                    
                    for(Case childrec : caserec.cases1__r) {
                        // start 7742
                        if(childrec.type == 'Account Setup Process'){
                            setupCaseExists = true;
                            if(childrec.status == 'Release Underwriting Complete') setupCaseRelUW = true;
                        } // end 7742
                        else if(childrec.GEMS_Submission_Type__c == 'Account Structure Maintenance' || 
                            childrec.GEMS_Submission_Type__c == 'Account Eligibility Maintenance' || 
                            childrec.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeRCM || //7734
                            childrec.GEMS_Submission_Type__c == 'AEP File Maintenance' ||
                            childrec.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeIDCardMaintenance) {
                            if(childrec.Type == GEMS_Constants.TypeMedicalUnderwriting)  {
                                medicalUWExists = true;
                                if(childrec.status == GEMS_Constants.StatusApproved){
                                    medicalUWApproved = true;
                                } 
                            } else if(childrec.Type == GEMS_Constants.TypeDentalUnderwriting) {
                                dentalUWExists = true;
                                if(childrec.status == GEMS_Constants.StatusApproved){
                                    dentalUWApproved = true;
                                } 
                            } else if(childrec.Type == GEMS_Constants.TypeEligibilityProcess) {
                                eligProcessExists = true;
                                if(childrec.status == GEMS_Constants.StatusCompleted){  // 7742
                                    eligProdCompStatus = true;
                                } 
                            } else if(childrec.Type == GEMS_Constants.TypeMembership) { 
                                membershipcaseExists = true;
                                if(childrec.status == GEMS_Constants.StatusCompleted){
                                    membershipcaseComplete = true;
                                }
                            } else if(childrec.Type == GEMS_Constants.TypeAccountSetupMaintenance && childrec.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeIDCardMaintenance) { 
                                idCardAccountSetupMaintenanceExists = true;
                                if(childrec.status == GEMS_Constants.StatusCompleted){
                                    idCardAccountSetupMaintenanceComplete = true;
                                }
                            }
                        }         
                    }
                    //criteria for submission case status to be marked completed
                    if(caserec.GEMS_Submission_Type__c == 'Account Structure Maintenance' && ! setupCaseRelUW ) continue; // 7742, not yet release to UW
                    if(((medicalUWApproved && dentalUWApproved) || (medicalUWApproved &&  !dentalUWExists) || (!medicalUWExists &&  dentalUWApproved)) && 
                       ((membershipcaseExists && membershipcaseComplete) || (!membershipcaseExists)) && ((eligProcessExists && eligProdCompStatus) || (!eligProcessExists)) || 
                       (eligProcessExists && eligProdCompStatus && !setupCaseExists)) { // 7742
                            caserec.status = GEMS_Constants.StatusCompleted;
                            submissionCasesMarkCompleted.add(caserec);                  
                    } else if(idCardAccountSetupMaintenanceExists && idCardAccountSetupMaintenanceComplete) {
                        caserec.status = GEMS_Constants.StatusCompleted;
                        submissionCasesMarkCompleted.add(caserec);                  
                    }
                }
                update submissionCasesMarkCompleted;
            }           
        }
    }
    
    
    /******************************************************************* 
    *   Method Name  :  updateMUW
    *   @description :  Method updates MUW case with commisions changin, commissions paid and porbob fields as part of SFDC-5927 and SFDC-5333
    *   @parameters  :  List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :  void     
    *   @Author      :  Phani Kommareddy
     ***************************************************************/
    public static void updateMUW(List<Case> casesList,Map<Id,Case> oldCaseMap) {
        Map<ID,Case> subCases = new Map<ID,Case>();
        Set<String> subTypesSet = new Set<String>{GEMS_Constants.SubmissionTypeNewAc,GEMS_Constants.SubmissionTypeRenewal,GEMS_Constants.SubmissionTypeOffCycle,GEMS_Constants.SubmissionTypeRCM};
        boolean porbobChanged = false;
        boolean ccChanged = false;
        boolean cpChanged = false;
        //get all regular submission cases that have changed in commissions and por/bob fields
       for(case newCase : casesList) {
            if(subTypesSet.contains(newCase.GEMS_Submission_Type__c) &&  (newCase.Type == GEMS_Constants.TypeAccountSubmission || newCase.Type == GEMS_Constants.TypeAccountMaintenance )) {
                Case oldCase = oldCaseMap.get(newCase.Id);
                porbobChanged  = newCase.GEMS_POR_BOB__c != oldCase.GEMS_POR_BOB__c ? true:false;
                ccChanged = newCase.GEMS_Are_commissions_changing__c != oldCase.GEMS_Are_commissions_changing__c ? true:false;
                cpChanged = newCase.GEMS_Are_commissions_paid_for_account__c != oldCase.GEMS_Are_commissions_paid_for_account__c ? true:false;
                if(porbobChanged || ccChanged || cpChanged)
                    subCases.put(newCase.Id,newCase);
            }
        }
        
        //if submissionCases not found exit
        if(!subCases.isEmpty()) {
            // retrieve MUW case for submission case and update the submission fields GEMS_Are_commissions_changing__c, GEMS_Are_commissions_paid_for_account__c,GEMS_POR_BOB__c
            List<Case> muwCasesList = [select id,GEMS_Account_Submission_Info__c from case where gems_account_submission_info__c in : subCases.keySet()  and type = 'Medical Underwriting'];
            if(!muwCasesList.isEmpty()){
                for(Case muw : muwCasesList) {
                    Case subCase = subCases.get(muw.GEMS_Account_Submission_Info__c);
                    if(ccChanged)  muw.GEMS_Are_commissions_changing__c = subCase.GEMS_Are_commissions_changing__c;
                    if(cpChanged) muw.GEMS_Are_commissions_paid_for_account__c =  subCase.GEMS_Are_commissions_paid_for_account__c;
                    if(porbobChanged) muw.GEMS_POR_BOB__c = subCase.GEMS_POR_BOB__c;
                }
            }
            update muwCasesList;
        }
    }
     
    /******************************************************************* 
    *    Method Name :   CreateAcctSetUpProcessCase
              Action
    *   @description :   This method is to create Account Set Up Process Case for Account Structure Maintenance.
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void CreateAcctSetUpProcessCase(List<Case> casesList,Map<Id,Case> oldCaseMap) {
           List<string> TypeofDownStCases=new List<string>();  
           Id caseAccStructCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
           Id caseAccMainteRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
           Set<Id> strucMainCaseIds = new Set<Id>();  
           try{
                
               // only pick up the Account Structure cases whose status is 'Client Approval Received' and its GEMS_Submission_Type__c = 'Account Structure Maintenance'
               for(Case acctStruct : casesList) {
                    if(acctStruct.recordTypeId == caseAccStructCaseRecTypeId && !string.IsEmpty(acctStruct.GEMS_Submission_Type__c) && acctStruct.GEMS_Submission_Type__c == 'Account Structure Maintenance' && !string.isEmpty(acctStruct.status) && acctStruct.status == 'Client Approval Received' && !string.isEmpty(oldCaseMap.get(acctStruct.Id).status) && oldCaseMap.get(acctStruct.Id).status != 'Client Approval Received' ) { 
                       strucMainCaseIds.add(acctStruct.ParentId);
                    } 
                } 
                //System.debug('%%%%%% strucMainCaseIds = '+strucMainCaseIds);
                
                // Exit this method immediately if no cases to process
                if( strucMainCaseIds.isEmpty() ) return;
                
                TypeofDownStCases.add('GEMS Account Setup');
                GEMS_AccountScreeningCaseCreation.CreateAccountMaintenanceDownstreamCases(strucMainCaseIds,TypeofDownStCases,'BlueSTAR Entry Complete');
           }
           catch(Exception ex){
                //System.debug('%%%%%%Exception inside CreateAcctSetUpProcessCase! '+ex.getMessage() +', lineNumber='+ex.getLineNumber());
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.CreateAcctSetUpProcessCase(List<Case> newCaseList,Map<Id,Case> oldCaseMap)','High');              
           }
     }
    /******************************************************************** 
    *   @Method Name : Child Owner update on Parent Owner change
    *   @description : This method to update owner of Child BA cases when Parent Case owner is changed.
    *   @parameters  : List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type : void
    *   @Story Number: 2898
    ***************************************************************/
    public static void updateBAChildCasesOwner(List<Case> newCasesList,Map<Id,Case> oldCaseMap) {
        try {
            if(updBAChldCaseOwnRecurChk){
            Id pharmacyCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
            list<GEMS_Pharmacy_Scope_Code__c> pharmacyCodingRecordsList = new list<GEMS_Pharmacy_Scope_Code__c>();
            set<id> caseIdSet = new set<id>();
            set<id> pharmacyCodingCasesIdSet = new set<id>();
            set<string> categorySet = new set<string>();
            set<string> statusSet = new set<string>();      
            //statusSet.add('Return');
            //statusSet.add('Closed');
            List<GEMS_Case_Categories__c> caseCategoryList = GEMS_Case_Categories__c.getall().values();
            if(caseCategoryList.size()>0){
                for(GEMS_Case_Categories__c cc:caseCategoryList){
                    categorySet.add(cc.name);
                }
            }
            List<GEMS_Case_Statuses__c> caseStatusList = GEMS_Case_Statuses__c.getall().values();
            if(caseStatusList.size()>0){
                for(GEMS_Case_Statuses__c cs:caseStatusList){
                    statusSet.add(cs.name);
                }
            }
            map<id,id> parentOwnerMap = new map<id,id>();
            for(case c:newCasesList){
                //system.debug('@@ old owner Id'+oldCaseMap.get(c.id).ownerId);
                //system.debug('@@ new Owner Id'+c.ownerId);
                //system.debug('@@ parent Id'+c.parentId);
                if(categorySet.contains(c.type) && oldCaseMap.get(c.id).ownerId!=c.ownerId){
                //if(c.parentID==null){
                    caseIdSet.add(c.id);
                    parentOwnerMap.put(c.id,c.ownerId);
                    if(c.RecordtypeId == pharmacyCodingRecordTypeId)
                    pharmacyCodingCasesIdSet.add(c.id);
                    
                }
            }
            //system.debug('@@ caseIdSet'+caseIdSet);
            //system.debug('@@parentOwnerMap'+parentOwnerMap);
            list<case> relatedBAChildCases = [select id,caseNumber,parentId from case where parentId in:caseIdSet and GEMS_Benefit_Agreement__c!=null and status NOT in:statusSet];
            system.debug('@@ relatedBAChildCases size'+relatedBAChildCases.size());
            if(relatedBAChildCases.size()>0){
                for(case c: relatedBAChildCases){
                    c.ownerId=parentOwnerMap.get(c.parentId);
                }
                update relatedBAChildCases;
            }
            
            pharmacyCodingRecordsList = [SELECT Id, OwnerId, Case__c FROM GEMS_Pharmacy_Scope_Code__c WHERE Case__c IN: pharmacyCodingCasesIdSet and Status__c!='AS400 & BlueStar Update Completed'];
            if(pharmacyCodingRecordsList.size()>0)
            {
                for(GEMS_Pharmacy_Scope_Code__c pharmacyScopeCodeRec: pharmacyCodingRecordsList)
                {
                    pharmacyScopeCodeRec.OwnerId = parentOwnerMap.get(pharmacyScopeCodeRec.Case__c);
                }
                update pharmacyCodingRecordsList;
            }
            updBAChldCaseOwnRecurChk = false;
         }   
        }
        catch(exception ex){
            system.debug('@@ in exception'+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateBAChildCasesOwner(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');              
        }
    }
    
    /******************************************************************** 
    *   @Method Name : Submitter of eligibility cases update
    *   @description : This method to update submitter of eligibility cases when Eligibility Case is created or updated.
    *   @parameters  : List<Case> newCasesList
    *   @return type : void
    *   @Story Number: 2898
    ***************************************************************/
    public static void updateEligibilityCasesOwner(List<Case> newCasesList,Map<id,Case> oldCaseMap) {
        try{
            system.debug('@@ in updateEligibilityCasesOwner');
            Id submissionCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            Id eligibilityCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
            Id idCardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId(); 
            Id membershipCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Membership').getRecordTypeId();            
            set<id> submissionCaseIdSet = new set<id>();
            list<case> casesToBeUpdated = new list<case>();
            if(recursiveCheck2){
            list<case> caseList = [select id,status,ClosedDate,GEMS_Submitter__c,GEMS_Account_Submission_Info__c,GEMS_Account_Submission_Info__r.ownerId from case where id in:newCasesList and recordTypeId=:membershipCaseRecordTypeId];
            list<case> submissionCaseList = [select id,GEMS_OE_Eligibility_Method__c,GEMS_Target_Date_Production_OE_File__c from case where recordTypeId=:submissionCaseRecordTypeId and id in:newCasesList];
            Map<string,string> submitterOwnerMap = new Map<string,string>();
            for(case c:caseList){
                submitterOwnerMap.put(c.id,c.GEMS_Account_Submission_Info__r.ownerId);
            }
            if(caseList.size()>0){
                for(case c:caseList){   
                    //system.debug('@@ in updateEligibilityCasesOwner before if');                
                    if(c.GEMS_Account_Submission_Info__c!=null){
                        //system.debug('@@ in updateEligibilityCasesOwner in if ownerId' +c.GEMS_Account_Submission_Info__r.ownerId);
                        c.GEMS_Submitter__c =submitterOwnerMap.get(c.id); 
                        submissionCaseIdSet.add(c.GEMS_Account_Submission_Info__c);
                        casesToBeUpdated.add(c);
                    }
                    
                }
               // update caseList;
            }
            //system.debug('@@ submissionCaseIdSet'+submissionCaseIdSet);
            if(submissionCaseList.size()>0){
                for(case subCase: submissionCaseList){
                submissionCaseIdSet.add(subCase.id);
                }
            }
            
            list<case> idCardCaseList = [select id,status,ClosedDate,GEMS_Target_Date_Production_OE_File__c,GEMS_OE_Eligibility_Method__c,GEMS_Account_Submission_Info__c from case where GEMS_Account_Submission_Info__c in:submissionCaseIdSet and recordTypeId=:idCardCaseRecordTypeId];
            //list<case> membershipCaseList = [select id,status,ClosedDate,GEMS_OE_Eligibility_Method__c,GEMS_Account_Submission_Info__c from case where GEMS_Account_Submission_Info__c in:submissionCaseIdSet and recordTypeId=:membershipCaseRecordTypeId];
           
            //system.debug('@@idCardCaseList'+idCardCaseList);
            if(idCardCaseList.size()>0 ){
                for(case idCardCase: idCardCaseList){               
                    for(case membershipCase: caseList){                    
                        if(idCardCase.GEMS_Account_Submission_Info__c ==membershipCase.GEMS_Account_Submission_Info__c){
                            //system.debug('@@ Submission case matches');
                            if(oldCaseMap!=null){
                                //if(idCardCase.Production_OE_File_Target_Date__c!=null){
                            //if(oldCaseMap.get(membershipCase.id).GEMS_Account_Submission_Info__c!=membershipCase.GEMS_Account_Submission_Info__c){
                              //  system.debug('@@ in if membership Id' +membershipCase.id);
                            //idCardCase.Production_OE_File_Target_Date__c  = membershipCase.GEMS_Account_Submission_Info__c;
                            //}
                            //}
                            if(oldCaseMap.get(membershipCase.id).ClosedDate!=membershipCase.ClosedDate){
                            idCardCase.Membership_Case_Date_Time_Closed__c = membershipCase.ClosedDate;
                            }
                            }
                            else{
                            //idCardCase.Production_OE_File_Target_Date__c  = membershipCase.GEMS_Account_Submission_Info__c;
                            idCardCase.Membership_Case_Date_Time_Closed__c = membershipCase.ClosedDate;
                            }
                        }
                    }
                    for(case submissionCase: submissionCaseList){
                        system.debug('@@ submissionCase id'+submissionCase.id);
                        system.debug('@@ idCardCase GEMS_Account_Submission_Info__c'+idCardCase.GEMS_Account_Submission_Info__c);
                        if(submissionCase.id==idCardCase.GEMS_Account_Submission_Info__c){
                            system.debug('@@ submission case submissionCase.GEMS_OE_Eligibility_Method__c'+submissionCase.GEMS_OE_Eligibility_Method__c);
                            idCardCase.GEMS_OE_Eligibility_Method__c = submissionCase.GEMS_OE_Eligibility_Method__c;
                            idCardCase.GEMS_Target_Date_Production_OE_File__c = submissionCase.GEMS_Target_Date_Production_OE_File__c;
                            
                        }
                    }
                    casesToBeUpdated.add(idCardCase);
                }
                
                    system.debug('@@ before update idCardCaseList: '+idCardCaseList);
                   
                
            }
            recursiveCheck2=false;                  
            update casesToBeUpdated;
           
          }  
        }
        catch(exception ex){
            recursiveCheck2=false;
            system.debug('@@ in exception'+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.updateEligibilityCasesOwner(List<Case> casesList)','High');              
        }
    }
    
    // SFDC-8197 Comment the call from here and create the Acct. Setup Maint. from GEMS_CosmeticAccountMaintenance in idCardRelease
    /******************************************************************** 
    *   @Method Name : createIDCardMaintenanceAccountSetup
    *   @description : This method to Creates account setup maintenance case when id card maintenace is completed
    *   @parameters  : List<Case> newCasesList,Map<id,Case> oldCaseMap
    *   @return type : void
    *   @Story Number: 6370
    ***************************************************************/
 /*   public static void createIDCardMaintenanceAccountSetup(List<Case> newCasesList,Map<id,Case> oldCaseMap) {
        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup Maintenance').getRecordTypeId();
        Id maintenanceTaskTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Setup Maintenance Task').getRecordTypeId();
        Id idCardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Set<Id> acctMaintCaseIdsSet = new Set<Id>();
        List<Case> idCardMaintAccSetupCasesList = new List<Case>();
        try {
            //get list of account maintenance cases for submission type =   ID Card Maintenance and submission sub-type = ID Card Changes, No Benefit Changes and category is ID card and new status is Completed
            for(Case newCase : newCasesList) {
                Case oldCase = oldCaseMap.get(newCase.Id);
                if(newCase.RecordTypeId == idCardCaseRecordTypeId && 
                   newCase.GEMS_Submission_Type__c == 'ID Card Maintenance' && 
                   newCase.GEMS_Submission_Sub_Type__c == 'ID Card Changes, No Benefit Changes' && 
                   newCase.Status != oldCase.status &&
                   newCase.Status == 'Completed') {
                        acctMaintCaseIdsSet.add(newCase.GEMS_Account_Submission_Info__c);
                }
            }
            
            
            if(!acctMaintCaseIdsSet.isEmpty()) {
                //retrive submission cases from completedIdCardList
                List<Case> allMaintenanceCasesList = [select id,GEMS_Products__c ,ownerId,casenumber,status,GEMS_All_Screening_Routed_In_Error__c,recordTypeId, GEMS_Line_of_Business__c, Funding_Type_Multiselect__c, 
                        accountId, GEMS_Effective_Date__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, FSU_Location__c, HCSC_Division__c, GEMS_Account_Submission_Info__c, GEMS_StdCust_Product__c,
                        GEMS_Submission_Sub_Type__c, Account.name, Account.External_ID__c, GEMS_Rx_Vendor__c, GEMS_Private_Exchange__c, GEMS_Private_Exchange_Values__c, Underwriter_Lookup__c, Opportunity_Name__c                     
                        from case where Id in :acctMaintCaseIdsSet ];
                
                List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName LIMIT 1];
                map<Id, Id> AccountSpecialists = new map<Id, Id>();
                list<caseteammember> listteammembers = [select parentid, memberid from caseteammember where teamrole.name = 'Account Specialist' and parentid in : acctMaintCaseIdsSet];
                for(caseteammember ctm: listteammembers) {
                    AccountSpecialists.put(ctm.parentid, ctm.memberid);
                }
                for(Case acctMaintCase : allMaintenanceCasesList) {
                    Case setupScreeningCase = null;
                    Case idCardMaintAccSetupCase = new Case();
                    DateTime effectiveDate = acctMaintCase.GEMS_Effective_Date__c;
                    idCardMaintAccSetupCase.Type = 'Account Setup Maintenance';
                    idCardMaintAccSetupCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c+' Account Setup Maintenance';
                    idCardMaintAccSetupCase.recordtypeid=accSetupRecordTypeId;
                    idCardMaintAccSetupCase.GEMS_Line_of_Business__c = acctMaintCase.GEMS_Line_of_Business__c;
                    idCardMaintAccSetupCase.GEMS_Rx_Vendor__c = acctMaintCase.GEMS_Rx_Vendor__c;
                    idCardMaintAccSetupCase.Accountid=acctMaintCase.accountId;
                    idCardMaintAccSetupCase.GEMS_Effective_Date__c=acctMaintCase.GEMS_Effective_Date__c;
                    idCardMaintAccSetupCase.GEMS_Case_Effective_Date__c = acctMaintCase.GEMS_Case_Effective_Date__c;
                    idCardMaintAccSetupCase.GEMS_Submission_Type__c=acctMaintCase.GEMS_Submission_Type__c;
                    idCardMaintAccSetupCase.FSU_Location__c=acctMaintCase.FSU_Location__c;
                    idCardMaintAccSetupCase.Status='In Progress';
                    idCardMaintAccSetupCase.parentid = acctMaintCase.Id;
                    idCardMaintAccSetupCase.HCSC_Division__c=acctMaintCase.HCSC_Division__c;                        
                    idCardMaintAccSetupCase.GEMS_Submission_Sub_Type__c=acctMaintCase.GEMS_Submission_Sub_Type__c;
                    idCardMaintAccSetupCase.GEMS_Account_Submission_Info__c=acctMaintCase.Id;
                    idCardMaintAccSetupCase.GEMS_Private_Exchange__c = acctMaintCase.GEMS_Private_Exchange__c;     
                    idCardMaintAccSetupCase.GEMS_Private_Exchange_Values__c = acctMaintCase.GEMS_Private_Exchange_Values__c;
                    idCardMaintAccSetupCase.Opportunity_Name__c = acctMaintCase.Opportunity_Name__c;
                    idCardMaintAccSetupCase.Underwriter_Lookup__c = acctMaintCase.Underwriter_Lookup__c;
                    idCardMaintAccSetupCase.GEMS_Submitter__c = acctMaintCase.ownerId;
                    idCardMaintAccSetupCase.Funding_Type_Multiselect__c = acctMaintCase.Funding_Type_Multiselect__c;                
                    idCardMaintAccSetupCase.GEMS_StdCust_Product__c = acctMaintCase.GEMS_StdCust_Product__c;                                                                        
                    idCardMaintAccSetupCase.GEMS_Products__c = acctMaintCase.GEMS_Products__c;
                    if(AccountSpecialists.get(acctMaintCase.id) == null){ 
                        idCardMaintAccSetupCase.ownerId = acctMaintCase.ownerId;
                    } else { 
                        idCardMaintAccSetupCase.ownerId = AccountSpecialists.get(acctMaintCase.id);
                        idCardMaintAccSetupCase.GEMS_Quality_Reviewer__c = AccountSpecialists.get(acctMaintCase.id);
                    }
                    idCardMaintAccSetupCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = acctMaintCase.ownerId;
                    
                    if(!activeEntitlement.isEmpty()) {
                        idCardMaintAccSetupCase.EntitlementId = activeEntitlement[0].id;
                    }
                    idCardMaintAccSetupCasesList.add(idCardMaintAccSetupCase);
                }
                
                Map<Id,Case> idCardMaintAccSetupCasesMap = new Map<Id,Case>();
                List<Task> taskInsertList = new List<Task>();
                Database.SaveResult[] childSaveResult;
                if(!idCardMaintAccSetupCasesList.isEmpty()) {
                    childSaveResult = Database.insert(idCardMaintAccSetupCasesList);
                }               
                if(childSaveResult != null) {
                    for(Case idCardMaintAccSetupCase : idCardMaintAccSetupCasesList) {
                        idCardMaintAccSetupCasesMap.put(idCardMaintAccSetupCase.Id,idCardMaintAccSetupCase);                        
                    }
                    for(Database.SaveResult sr:childSaveResult) {
                        //if(sr.isSuccess()) {
                            Case childRecord = idCardMaintAccSetupCasesMap.get(sr.getId());
                            Task baLevelAccSetUpTask= new Task();
                            baLevelAccSetUpTask.WhatId=childRecord.Id;
                            baLevelAccSetUpTask.Subject='BlueSTAR Entry Complete';
                            baLevelAccSetUpTask.Status='In Progress';
                            baLevelAccSetUpTask.Priority='Normal';
                            baLevelAccSetUpTask.GEMS_Start_Date__c = System.now();
                            baLevelAccSetUpTask.ownerId = childRecord.ownerId;
                            taskInsertList.add(baLevelAccSetUpTask);
                        //}
                    }
                    
                    if(!taskInsertList.isEmpty()) {
                        Database.insert(taskInsertList);
                    }
                }
            }
            } catch(Exception ex) {
                
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.createIDCardMaintenanceAccountSetup(List<Case> newCasesList,Map<id,Case> oldCaseMap)','High');              
            }
    }
    */
/******************************************************************** 
*   Method Name  :   autoUpdAccSubCaseBPA
*   @description :   Refer - SFDC - 6946   
*   @parameters  :   Map<Id,Case> TriggerNewMap,Map<Id,Case> TriggerOldMap
*   @return type :   void
*   @Author      :   Gokul Bharati
***************************************************************/    
   public static void autoUpdAccSubCaseBPA(Map<Id,Case> triggerNewMap,Map<Id,Case> triggerOldMap){  
    if(autoSubclose){
    set<string> recordTypeIdSet = new set<string>{'GEMS_Eligibility_Process','GEMS_GET','GEMS_Request_Resource'}; 
    set<string> docTypes = GEMS_Constants.docTypes; 
    string milestoneTocheck= GEMS_Constants.ServiceReady;        
    List<case> caseList = new List<case>();
    Map<Id,Boolean> caseBPAFound = new Map<Id,Boolean>();
    Map<Id,Boolean> dwnCaseFound = new Map<Id,Boolean>();
    set<Id> caseIds = new set<Id>();
    try{
       for(Case cse:[select Id,recordType.DeveloperName,Status,isClosed,GEMS_Account_Submission_Info__c,GEMS_Account_Submission_Info__r.MileStone__c  from Case where recordType.DeveloperName in :recordTypeIdSet and Id in:triggerNewMap.keySet()]){
          if(TriggernewMap.get(cse.Id).Status != TriggeroldMap.get(cse.Id).Status){
             caseIds.add(cse.GEMS_Account_submission_Info__c);
          }       
       }
       for(Case cse:[select Id,recordType.DeveloperName,Status,isClosed,GEMS_Account_Submission_Info__c,GEMS_Account_Submission_Info__r.MileStone__c  from Case where recordType.DeveloperName in :recordTypeIdSet and GEMS_Account_Submission_info__c in:caseIds]){
         if(cse.GEMS_Account_Submission_Info__r.MileStone__c != null && cse.GEMS_Account_Submission_Info__r.MileStone__c == milestoneTocheck){ 
          if(!dwnCaseFound.containsKey(cse.GEMS_Account_Submission_Info__c)){
              if((cse.isClosed))  
                 dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,true); 
                 else 
                 dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,false);           
          }
          else{
             Boolean bool = dwnCaseFound.get(cse.GEMS_Account_Submission_Info__c);
             if(cse.isClosed)  
                 dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,(bool && true)); 
                 else
                 dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,(bool && false));  
             }           
         }     
        }
        if(!dwnCaseFound.isEmpty()){
            for(GEMS_Attachment__c att:[select id,Type__c,Case__c,Case__r.MileStone__c from GEMS_Attachment__c where Case__c in:dwnCaseFound.keySet() and  Type__c in:docTypes]){             
                 caseBPAFound.put(att.Case__c,true);  
            }
            for(Case cse:[select id,MileStone__c,status,GEMS_Submission_Type__c from Case where Id in:dwnCaseFound.keySet()]){
                //SFDC-8034
                
                Boolean NonOffCycle = (case.MileStone__c != null && cse.MileStone__c == milestoneTocheck && caseBPAFound.get(cse.Id) != null && caseBPAFound.get(cse.Id) == true && (dwnCaseFound.get(cse.Id) == null || dwnCaseFound.isEmpty() || dwnCaseFound.get(cse.Id) == true) && cse.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeOffCycle);
                Boolean OffCycle = (case.MileStone__c != null && cse.MileStone__c == milestoneTocheck && (dwnCaseFound.get(cse.Id) == null || dwnCaseFound.isEmpty() || dwnCaseFound.get(cse.Id) == true) && cse.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeOffCycle);
                
                if(NonoffCycle || OffCycle){
                       cse.Status = GEMS_Constants.StatusCompleted;
                       caseList.add(cse);
                }
                else{
                       cse.Status = GEMS_Constants.StatusInProgress;
                       caseList.add(cse);
                }
                //SFDC-8034 
            }                
            if(!caseList.isEmpty()){
                update caseList; 
            }
          } 
          autoSubclose = false; 
       }
       catch(Exception ex){
           CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.autoUpdAccSubCaseBPA(List<GEMS_Attachment__c > attachments)','High');              
           System.debug('$$$$Exception Message'+ex.getMessage()+'$$$$Line Number'+ex.getLineNumber());
       }
      } 
     }
         
}