/*****************************************************************************************************
*TEEST EDIT 2 Apex Class Name     : AccountCancellationClass
* Version             : 1.0

* Function            : This is the controlling class for page AccountCompleteCancellation.
* Modification Log    :
* Developer             Deploy Target Date          Description
* ----------------------------------------------------------------------------
* Zachary Campbell      09/23/2017      SFDC-5767 - added AccountRecord[0].Small_Group_Cancellation__c
*                                       to isSGAccount() conditional statements and PageReference click()
*                                       method to show/hide text message on vf page.
* Zachary Campbell      09/23/2017      SFDC-5888 - added code so group cancellations of small group account 
*                                       would immediately be updated to cancelled status with no approvals.
*                                       SFDC-5883 - added code to accomodate approval process for group section 
*                                       retro UW approval > 60 days.
* Nathan Shuyler        09/23/2017      SFDC-5889 - added code so user input cancellation fields for group sections
*                                       and billing profiles would be validated and populated before applying to 
*                                       selected lines.
* Zachary Campbell      09/29/2017      SFDC-6076 - add code so the cancellation button can be used with Hub user
*                                       and SG user Account Cancellation.  Also cleared cancellation fields when
*                                       Cancel button function is executed.
* Padma Bedampeta       10/13/2017      SFDC-6091 - Allow SG Accounts Requested for Cancellation, Retro(>=60) 
*                                       Account Cancellation should go through Approval Process else SG Account
*                                       Cancellation bipass the Approval Process.
* Zachary Campbell      12/15/2017      SFDC-7455 - Updated the entire class replacing all object references of Group_Section__c
*                                       with GEMS_Group_Section__c.  The SQLs pulling from Group Section were replaced with SQLs
*                                       that pull a smaller number of fields from GEMS Group Section.
* Nathan Shuyler        12/15/2017      SFDC-7485 - Updated the entire class replacing all object references of Billing__c
*                                       with GEMS_Billing_Profile__c.  The SQLs pulling from Billing were replaced with SQLs
*                                       that pull similar fields from GEMS Billing Profile.
* Padma Bedampeta       12/15/2017      SFDC-7453 - Calling sendLGNAAccountStructureCancellation(List<Id> accountIds, List<Id> CaseIds)
*                                       future method of ARCancellationHelper Class.
* Zachary Campbell      12/15/2017      SFDC-7696 - Prevent retro cancellations and take user back to Case page.
* Mark, Nathan          01/19/2018      SFDC-7452 - AR - GrpSect Retro Cancel:Case Approval
* Mark, Nathan          01/19/2018      SFDC-7666 - AR - Billing Profile Retro Cancel:Case Approval
* Mei Chen              01/19/2018      SFDC-7801 - Added Categroy Cancellation UI
* Mark, Nathan          01/19/2018      SFDC-7791 - Added Retro approval process for canclations older than 60 days
* Nathan Shuyler        02/23/2018      SFDC-7931 - Added checks to ensure Underwriter is Active for Retro Cancellations.
* Padma Bedampeta       02/23/2018      SFDC-7899 - View State error with Large amount of records on VF page, List array size limit exceed on VF page.
                                        Group Section and Billing Profile record display on review page with Account cancellation information.
 * Dacus, Lori           03/19/2018     SFDC-8825 - Added New SG Fields
************************************************************************************************************************/
public with sharing class AccountCancellationClass {
    
    Public Boolean ShowNextButton {get;set;}  //SFDC-5889
    Public Boolean GrpSecRetroFlag {get;set;} // SFDC-7452
    Public Boolean GrpSecRetroFeatureFlag {get;set;} // SFDC-7452
    Public Boolean BPRetroFlag{get;set;}      //SFDC-7666
    Public Boolean BPRetroFeatureFlag {get;set;} //SFDC-7666
    Public Boolean CatRetroFlag{get;set;}      //SFDC-7791 
    Public Boolean CatRetroFeatureFlag {get;set;} //SFDC-7791
    Public Boolean UnderWriterActiveForRetro {get;set;} //SFDC-7931
    public String StringCancelDate {get;set;}
    public String CancelExplanation { get; set; }
    public String CancelReason { get; set; }
    public String CancelCode { get; set; }
    public Date CancelDate {get;set;}
    public List<selectOption> CancellationCodePicklist { get; set; }
    public List<SelectOption> CancellationReasonPicklist { get; set; }
    String previoscancellationstatus;
    public boolean displayBillingsection { get; set; }
    public String selectedValue { get; set; }
    public Id accountId { get; set; }
    public Id caseId { get; set; }
    public List<Account> AccountRecord { get; set; }
    
    /*** start SFDC-7455 ***/
    public List<GEMS_Group_Section__c> GroupSectionList { get; set; }
    //public List<List<Group_Section__c>> LGNA_GroupSectionList { get; set; }
    /*** end SFDC-7455 ***/
    public List<Benefit_Agreement__c> BenefitAgreementList { get; set; }
    public String accountName { get; set; }
    /*** start SFDC-7455 ***/
   // List<Group_Section__c> lgnagrpSecList { get; set; }
   // public List<LGNAGroupSectionWrapper> lgnagrpSectionWrapperList { get; set; }
    public List<GroupSectionWrapper> grpSectionWrapperList { get; set; }
    /*** end SFDC-7455 ***/
    /*** start  SFDC-7453 ***/
    public List<Id> accountIds { get; set; }
    public List<Id> CaseIds { get; set; }
    /*** end  SFDC-7453 ***/
    
    public List<GroupSectionWrapper> selectedgrpSectionWrapperList { get; set; }
    public Set<id> grpSecIds { get; set; }
    public List<BenefitAgreementWrapper> BAWrapperList { get; set; }
    public List<BenefitAgreementWrapper> selectedBAWrapperList { get; set; }   
    public Integer renewalDay { get; set; }
    public Integer reqCancelday { get; set; }
    
    public List<BiilingProfileWrapper> BillingWrapperList { get; set; }
    public List<BiilingProfileWrapper> selectedBillingWrapperList { get; set; }
    public Set<id> BAIds { get; set; }
    
    public GEMS_Group_Section__c Massgrpsec { get; set; }
    public Benefit_Agreement__c MassBArec { get; set; }
    public GEMS_Billing_Profile__c Massbilling { get; set; }
    Map<id, set<id>> ba_gs_map;
    Map<id, set<id>> ba_gs_mapGrpSec;
    Map<id, GEMS_Group_Section__c> GsIdRecMap;
    Map<id, Benefit_Agreement__c> BAIdRecMap;
    public boolean completeCancellationSectionToggle { get; set; }
    public boolean benefitAgreementSectionToggle { get; set; }
    public boolean GroupSectionToggle { get; set; }
    public boolean showMessagepanel { get; set; }
    public String DisplayMessage { get; set; }
    /*** start SFDC-7485 ***/
    public List<GEMS_Billing_Profile__c> BillingProfileList { get; set; }
    //public List<Billing__c> LGNA_BillingProfileList { get; set; }
    /*** end SFDC-7485 ***/
    public boolean hasEditAccess { get; set; }
    public String marketSegment { get; set; } //the market segment value from the current account record
    public String pageWarning { get; set; }
    public List<BenefitAgreementWrapper> RelatedBenefitAgreementWrapper;
    public List<GroupSectionWrapper> RelatedGroupSectionWrapper;
    Id ProdNonBluStarRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(ConstantsController.HCSC_Non_BlueStar_Product).getRecordTypeId();
    public Set<Id> persistentGroupSectionIdSet {get;set;}
    /*** start SFDC-7455 ***/
    //public Boolean hasActiveMembers {get;set;}
    /*** end SFDC-7455 ***/   
    public List<List<LGNAGroupSectionWrapper>> lgnagswlist {get;set;}
    public List<List<GroupSectionWrapper>> gswlist {get;set;}
    
    //**** SFDC-7899 Account Cancellation review page start ****//
    public List<List<Group_Section__c>> LGNA_GroupSectionList { get; set; }
    public List<Group_Section__c> lgnagrpSecList { get; set; }
    public List<List<Benefit_Agreement__c>> LGNA_BAList { get; set; }
   // public List<Benefit_Agreement__c> LGNABAList { get; set; }
    public List<List<Billing__c>> LGNA_BillingProfileList { get; set; }
    public List<Billing__c> LGNABillingProfileList { get; set; }
    //**** SFDC-7899 End ****//
    
    //-----SFDC 7801 Category Cancellation------------
    Map<id, GEMS_Category__c> catRecMap;
    public Set<id> catIds{get;set;}
    public list<list<CategoryWrapper>> categoryList {get;set;}
    public list<CategoryWrapper> categoryWrapperList {get;set;}
    public list<CategoryWrapper> selectedCategoryWrapperList {get;set;}
    public boolean CategoryToggle {get;set;}
    //-----end SFDC 7801--------------
    
    /*** start SFDC-6076 ***/
    public string previousCancellationStatus {get; set;}    
    public date previousCancellationDate {get; set;}
    public string previousCancellationReason {get; set;}
    public string previousCancellationExplanation {get; set;}
    public string previousCancellationCode {get; set;}
    public boolean previousSmallGroupCancellation {get; set;}
    
    /*** start SFDC-8825 ***/
    public list<Account> carrierList {get;set;}
    public list<Account> fundingIncrementList {get;set;}
    public list<Account> newFundingTypeList {get;set;}
    public string OtherCarrier {get; set;}
    public double PercentAmount {get; set;}   
    public double DollarAmount {get; set;}
    
    /*** end SFDC-6076 ***/ 
    Private String arFlag = NULL;
    /*Removed Variables*/
    /*
public String AccountCancellationReason {get; set;}
public Integer AccountCancellationMembers {get; set;}
public String AccountCancellationExplaination {get; set;}
public List<Group_Section__c> RelatedGroupSection {get; set;}
*/
    
    public void setRelatedBenefitAgreementWrapper(List<BenefitAgreementWrapper> tempListBene) {
        RelatedBenefitAgreementWrapper = tempListBene;
    }
    
    public List<BenefitAgreementWrapper> getRelatedBenefitAgreementWrapper() {
        try {
            List<Benefit_Agreement__c> RelatedBenefitAgreement = getRelatedBenefitAgreement();
            RelatedBenefitAgreementWrapper.clear();
            for (Benefit_Agreement__c benAgree : RelatedBenefitAgreement) {
                RelatedBenefitAgreementWrapper.add(new BenefitAgreementWrapper(true, benAgree));
            }
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getRelatedBenefitAgreementWrapper()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
        return RelatedBenefitAgreementWrapper;
    }
    
    public void setRelatedGroupSectionWrapper(List<GroupSectionWrapper> templist) {
        RelatedGroupSectionWrapper = templist;
    }
    
    public List<GroupSectionWrapper> getRelatedGroupSectionWrapper() {
        try {
            List<GEMS_Group_Section__c> RelatedGroupSections = getRelatedGroupSection();
            RelatedGroupSectionWrapper.clear();
            for (GEMS_Group_Section__c grpSec : RelatedGroupSections) {
                RelatedGroupSectionWrapper.add(new GroupSectionWrapper(true, grpSec));
            }
        } Catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionWrapperList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
        return RelatedGroupSectionWrapper;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('Complete', 'Account Cancellation'));
        options.add(new SelectOption('Group', 'Group Sections Cancellation'));
        options.add(new SelectOption('Benefit', 'Benefit Agreements Cancellation'));
        options.add(new SelectOption('Billing', 'Billing Profile Cancellation'));
        return options;
    }
    
    public AccountCancellationClass(ApexPages.StandardController controller) {
        try {
            accountId = ApexPages.currentPage().getParameters().get('id');
            caseId = ApexPages.currentPage().getParameters().get('Case');
            GrpSecRetroFlag = false; //SFDC-7452
            BPRetroFlag = false;     //SFDC-7666
            CatRetroFlag = false;    //SFDC-7791
            GetRetroFeatureFlags();
            system.debug('Account ID = '+ accountId);
            system.debug('Case ID = '+ caseId); 
            accountIds = new List<Id>();
            CaseIds = new List<Id>();
            String selectedValue = ApexPages.currentPage().getParameters().get('selectedValue');
            this.pageWarning = system.label.AccountCancellationHomeWarning;
            UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :accountId limit 1] [0];
            if (userAccess.HasEditAccess) {
                hasEditAccess = true;
                AccountRecord = new List<Account> ();
                AccountRecord = [Select Small_Group_Cancellation__c, Requested_Cancellation_Date__c, New_Carrier_For_Dental_G__c, New_Carrier_For_Medical_G__c, New_Carrier_For_Dental_C__c, New_Carrier_For_Medical_C__c, Market_Segment__c, Cancellation_Code__c, Cancellation_Explanation__c, Cancellation_Reason__c,
                                 name, id, Description, Status__c, Cancellation_Status__c, Carrier__c, OtherCarrier__c, DollarAmount__c, percentAmount__c, NewFundingType__c, FundingIncrement__c, Underwriter__c, Underwriter_Name__c, OwnerId, External_ID__c,Renewal_Date__c
                                 From Account
                                 Where id = :accountId
                                 limit 1];        
                // Mark 08-09-2017 Used Underwriter_Name__c to find Id for lookup on Underwriter__c
                if(AccountRecord[0].Underwriter_Name__c != null){
                    list<user> uw_usr = [Select Id from User Where Name =: AccountRecord[0].Underwriter_Name__c limit 1];                               
                    if(!uw_usr.isEmpty()){
                        accountrecord[0].underwriter__c = uw_usr[0].id;
                    }    
                }
                
                arFlag = ARCancellationConstants__c.getValues('sourceSystemCd').ARCancelRequiredField__c;
                system.debug('arFlag in Constructor::::'+arFlag);
                accountName = AccountRecord[0].name;
                marketSegment = AccountRecord[0].Market_Segment__c;
                previoscancellationstatus = AccountRecord[0].Cancellation_Status__c;
                grpSectionWrapperList = new List<GroupSectionWrapper> ();
                //lgnagrpSectionWrapperList = new List<LGNAGroupSectionWrapper> ();
                selectedgrpSectionWrapperList = new List<GroupSectionWrapper> ();
                grpSecIds = new Set<id> ();
                BAWrapperList = new List<BenefitAgreementWrapper> ();
                selectedBAWrapperList = new List<BenefitAgreementWrapper> ();
                BAIds = new Set<id> ();
                selectedBillingWrapperList = new List<BiilingProfileWrapper> ();
                BillingWrapperList = new List<BiilingProfileWrapper> ();
                Massgrpsec = new GEMS_Group_Section__c();
                MassBArec = new Benefit_Agreement__c();
                ba_gs_map = new Map<id, set<id>> ();
                ba_gs_mapGrpSec = new Map<id, set<id>> ();
                GsIdRecMap = new Map<id, GEMS_Group_Section__c> ();
                BAIdRecMap = new Map<id, Benefit_Agreement__c> ();
                RelatedGroupSectionWrapper = new List<GroupSectionWrapper> ();
                RelatedBenefitAgreementWrapper = new List<BenefitAgreementWrapper> ();
                Massbilling = new GEMS_Billing_Profile__c();
                lgnagswlist = new List<List<LGNAGroupSectionWrapper>>();
                gswlist = new List<List<GroupSectionWrapper>>();
                completeCancellationSectionToggle = true;
                benefitAgreementSectionToggle = true;
                GroupSectionToggle = true;
                displayBillingsection = false;
                showMessagepanel = false;
                // SFDC-7899 start
                List<Group_Section__c> lgnagrpSecList = new List<Group_Section__c>();
                List<List<Group_Section__c>> LGNA_GroupSectionList = new List<List<Group_Section__c>>();
                List<List<Benefit_Agreement__c>> LGNA_BAList = new List<List<Benefit_Agreement__c>>();
                List<Benefit_Agreement__c> BenefitAgreementList = new List<Benefit_Agreement__c>();
                List<List<Billing__c>> LGNA_BillingProfileList = new List<List<Billing__c>>();
                List<Billing__c> LGNABillingProfileList = new List<Billing__c>();
                // SFDC-7899 END
                //----SFDC7801------
                catIds=new Set<id>();
                CatRecMap=new Map<id, GEMS_Category__c>();
                categoryWrapperList=new list<CategoryWrapper>();
                categorylist=new list<list<CategoryWrapper>>();
                selectedCategoryWrapperList=new list<CategoryWrapper>();
                CategoryToggle=true;
                //----end SFDC-7801-------------
                
                /*** start SFDC-6076 ***/
                previousCancellationStatus = AccountRecord[0].Cancellation_Status__c;
                previousCancellationDate = AccountRecord[0].Requested_Cancellation_Date__c;
                previousCancellationReason = AccountRecord[0].Cancellation_Reason__c;
                previousCancellationExplanation = AccountRecord[0].Cancellation_Explanation__c;
                previousCancellationCode = AccountRecord[0].Cancellation_Code__c;
                previousSmallGroupCancellation = AccountRecord[0].Small_Group_Cancellation__c;
                /*** end SFDC-6076 ***/                
                
                //getBAWrapperList();
                
                /*** start SFDC-7455 ***/
                // getLGNAGroupSectionWrapperList();
                /*** end SFDC-7455 ***/
                
                // getGroupSectionWrapperList();
                
                //  getBillingProfileWrapperList();
                //  getCategoryWrapperList(); // SDFC-7801----
                populatePicklistValues(selectedValue);
                
                /*** start SFDC-5889 ***/   
                This.ShowNextButton = False;
                This.CancelDate = AccountRecord[0].Renewal_Date__c;
                /*** end SFDC-5889 ***/
                
            } else {
                hasEditAccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.InsufficientError));
            }
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getRelatedBenefitAgreementWrapper()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
    }
    // ********* SFDC-7899 Reduce View state size start *********//
    public void gsInitialLoad(){
        getGroupSectionWrapperList();
    }
    public void catInitialLoad(){
        getCategoryWrapperList(); // SDFC-7801----
    }
    public void bpInitialLoad(){
        getBillingProfileWrapperList();
    }
    public void baInitialLoad(){
        getBAWrapperList();
    }    
    //SFDC-7899 Reduce View state size End *********//
    public pageReference NavigateToSelectedPage() {
        accountId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg = null;
        if (selectedValue == 'Group') {
            pg = new pageReference('/apex/AccountCancellationGroupSection?Id=' + accountId);
            ResetMassUpdateValues(new GEMS_Group_Section__c());
        } else if (selectedValue == 'Complete') {
            pg = new pageReference('/apex/AccountCompleteCancellation?Id=' + accountId);
            ResetMassUpdateValues(new Account());
        } else if (selectedValue == 'Benefit') {
            pg = new pageReference('/apex/AccountCancellationBenefitAgreement?Id=' + accountId);
            ResetMassUpdateValues(new Benefit_Agreement__c());
        } else if (selectedValue == 'Billing') {
            pg = new pageReference('/apex/billingProfileCancellation?Id=' + accountId);
            ResetMassUpdateValues(new GEMS_Billing_Profile__c());
        }else if (selectedValue == 'Category') {
            pg = new pageReference('/apex/AccountCancellationCategory?Id=' + accountId);
            ResetMassUpdateValues(new GEMS_Category__c());
        }
        if (pg != null) {
            pg.getParameters().put('selectedValue', selectedValue);
            pg.setRedirect(true);   
        }
        return pg;
    }
    
    /**
* @developer: Alec Klein/Slalom LLC
* @description: Populates picklist values based on the current selected page
*/
    public void populatePicklistValues(String currentSelectedValue){
        if (currentSelectedValue == 'Group'){
            ResetMassUpdateValues(new GEMS_Group_Section__c());
        }else if (currentSelectedValue == 'Complete') {
            ResetMassUpdateValues(new Account());
        }else if (currentSelectedValue == 'Benefit') {
            ResetMassUpdateValues(new Benefit_Agreement__c());
        }else if (currentSelectedValue == 'Billing') {
            ResetMassUpdateValues(new GEMS_Billing_Profile__c());
        }else if(currentSelectedValue=='Category'){
            ResetMassUpdateValues(new GEMS_Category__c());
        }
    }
    /****** Account Cancellation Start *******/ 
    public pageReference confirmcancellationAccount() {
        
        if (!checkIfAccountCanBeCancelled()) {
            backcancellationAccount();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Account_Cannot_Be_Cancelled));
            return null;
        }
        
        Savepoint sp = Database.setSavepoint();
        
        try {
            if (AccountRecord.size() > 0 && AccountRecord[0] != null) {
                /*** start SFDC-5767 ***/    /*** start SFDC-SFDC-6091 ***/            
                if (isSGAccount() && (AccountRecord[0].Small_Group_Cancellation__c) && AccountRecord[0].Requested_Cancellation_Date__c.daysBetween(System.Today()) < 60) {
                    /*** end SFDC-5767 ***/    /*** start SFDC-SFDC-6091 ***/                 
                    AccountRecord[0].Cancellation_Status__c = 'Requested Cancellation';
                } else {
                    AccountRecord[0].Cancellation_Status__c = 'Pending Approval';
                } 
                AccountRecord[0].AR_Cancellation_Flag__c = ARCancellationConstants__c.getValues('sourceSystemCd').ARCancelRequiredField__c;
                System.debug('AccountRecord[0].AR_Cancellation_Flag__c::::::::::'+AccountRecord[0].AR_Cancellation_Flag__c);
                update AccountRecord[0];
                
                if (lgnagrpSecList != null && lgnagrpSecList.size() > 0) {
                    update lgnagrpSecList;
                }
                if (BenefitAgreementList != null && BenefitAgreementList.size() > 0) {
                    update BenefitAgreementList;
                }
                if (LGNABillingProfileList != null && LGNABillingProfileList.size() > 0) {
                    update LGNABillingProfileList;
                }
                
                /***start SFDC-5767***/ /*** start SFDC-SFDC-6091 ***/ 
                //Approval process initiation for Small Group Retro OR Large Group cancellation
                if (( (isSGAccount() || (AccountRecord[0].Small_Group_Cancellation__c)) && AccountRecord[0].Requested_Cancellation_Date__c.daysBetween(System.Today()) >= 60) 
                    || (!isSGAccount() && !(AccountRecord[0].Small_Group_Cancellation__c))) { 
                        /***end SFDC-5767***/  /*** start SFDC-SFDC-6091 ***/                   
                        list<Approval.ProcessSubmitRequest> request = new list<Approval.ProcessSubmitRequest> ();
                        Approval.ProcessSubmitRequest temp = new Approval.ProcessSubmitRequest();
                        temp.setComments('Submitting for Approval');
                        temp.setObjectId(AccountRecord[0].id);
                        request.add(temp);
                        list<Approval.ProcessResult> result = Approval.process(request, true);
                    }
            }
            PageReference pg = new pageReference('/' + accountId);
            
            if(!Test.isRunningTest()){
                generateRetroactiveCancellationMessage(AccountRecord[0], GroupSectionList, true);
            }
            
            return pg;
        } catch(DMLException ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.confirmcancellationAccount()','High');
            AccountRecord[0].Cancellation_Status__c = previoscancellationstatus;
            AccountRecord[0].AR_Cancellation_Flag__c = NULL;
            System.debug('DMLException AccountRecord[0].AR_Cancellation_Flag__c::::::::::'+AccountRecord[0].AR_Cancellation_Flag__c);
            Database.rollback(sp);
            backcancellationAccount();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.UsersManagerNotAvailable));
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
        return null;
    }
    
    private Boolean checkIfAccountCanBeCancelled() {
        if ((AccountRecord[0].Cancellation_Status__c == ConstantsController.pendingApprovalStatus && !isSGAccount()) // SG account doesn't need to check approval process
            || AccountRecord[0].Cancellation_Status__c == ConstantsController.cancelledStatus
            || AccountRecord[0].Cancellation_Status__c == ConstantsController.submittedStatus
            || AccountRecord[0].Cancellation_Status__c == ConstantsController.requestedCancellationStatus) {
                
                return false;
            }
        return true;
    }
    
    public pageReference backcancellationAccount() {
        showMessagepanel = false;
        return null;
    }
    
    public pageReference DiplaycancellationAccountMessage() {
        showMessagepanel = true;
        DisplayMessage = 'Are you sure you want to cancel the entire account?';
        return null;
    }
    
    public pageReference cancel() {
        /*** start SFDC-6076 ***/
        AccountRecord[0].Cancellation_Status__c = previousCancellationStatus;
        AccountRecord[0].Cancellation_Reason__c = previousCancellationReason;
        AccountRecord[0].Requested_Cancellation_Date__c = previousCancellationDate;
        AccountRecord[0].Cancellation_Explanation__c = previousCancellationExplanation;
        AccountRecord[0].Cancellation_Code__c = previousCancellationCode;
        AccountRecord[0].Small_Group_Cancellation__c = previousSmallGroupCancellation;
        update AccountRecord;
        
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(profile != null && !profile.isEmpty()){
            if(profile[0].name == 'SG - Service Center User'){
                accountId = ApexPages.currentPage().getParameters().get('id');
                pageReference pg = new pageReference('/' + accountId);
                return pg;                
            } 
        }
        return new PageReference('javascript:window.close()');
        /*** end SFDC-6076 ***/
    }
    
    public pageReference backToAccountHome() {
        accountId = ApexPages.currentPage().getParameters().get('id');
        pageReference pg = new pageReference('/apex/AccountCancellationHome?id=' + accountId);
        pg.setredirect(true);
        return pg;
    }
   /* Account Level Cancellation - Move to Account complete Review Page */ 
    public pageReference moveToAccountCompCancelReviewPg() {
        try {
            update AccountRecord[0];           
            accountId = ApexPages.currentPage().getParameters().get('id');
            Boolean isRetroCancelled = false;
            
            if(!AccountRecord[0].Small_Group_Cancellation__c && AccountRecord[0].Requested_Cancellation_Date__c.daysBetween(System.Today()) >= 60 && AccountRecord[0].Underwriter__c == null){
                isRetroCancelled = true;
            }
            
            /*** start SFDC-7455 ***/
            /*LGNA_GroupSectionList = [SELECT Id, Cancellation_Explanation__c, Members_Cancelling__c, Cancellation_Reason__c, Requested_Cancellation_Date__c, Cancellation_Code__c,
Section_Number__c, Name, Name__c, Group_Account__c, Status__c, Cancellation_Status__c, Total_Active_Members__c, Total_Active_Subscribers__c, Group_Number__c, External_ID__c, Underwriter__c
FROM Group_Section__c
WHERE Group_Account__c = :accountId
and status__c = 'Active'
and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
and Cancellation_Status__c != :ConstantsController.cancelledStatus
and Cancellation_Status__c != :ConstantsController.submittedStatus
and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];*/
            /*** end SFDC-7455 ***/
            
            /*** start SFDC-7485 ***/
            /*   LGNA_BillingProfileList = [select id, name, Cancellation_Code__c, Requested_Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
Cancellation_Submitted_Date__c, Status__c, Group_Account__c, Group_Account__r.name, Cancellation_Status__c from Billing__C
WHERE Group_Account__c = :accountId
and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
and Cancellation_Status__c != :ConstantsController.cancelledStatus
and Cancellation_Status__c != :ConstantsController.submittedStatus
and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus) 
limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];*/
            /*** end SFDC-7485 ***/
            
          /*  BenefitAgreementList = [SELECT id, Status__c, Group_Account__c, Benefit_Agreement_Number__c, Cancellation_Explanation__c, Requested_Cancellation_Date__c, Cancellation_Code__c,
                                    Members_Cancelling__c, Cancellation_Reason__c, Name, Cancellation_Status__c
                                    FROM Benefit_Agreement__c
                                    WHERE Group_Account__c = :accountId
                                    and status__c = 'Active'
                                    and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                                        and Cancellation_Status__c != :ConstantsController.cancelledStatus
                                        and Cancellation_Status__c != :ConstantsController.submittedStatus
                                        and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                                    and Product__r.RecordTypeId != :ProdNonBluStarRecordTypeId 
                                    limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];*/
             /*** start SFDC-7899 ***/
            LGNA_GroupSectionList = getLGNAGroupSectionList();
            LGNA_BAList = getLGNABenefitAgreementList();
            LGNA_BillingProfileList = getLGNABillingList();
             /*** End SFDC-7899 ***/
            for (Group_Section__c GroupSec : lgnagrpSecList) {
                GroupSec.Cancellation_Reason__c = AccountRecord[0].Cancellation_Reason__c;
                GroupSec.Requested_Cancellation_Date__c = AccountRecord[0].Requested_Cancellation_Date__c;
                GroupSec.Cancellation_Explanation__c = AccountRecord[0].Cancellation_Explanation__c;
                GroupSec.Cancellation_Code__c = AccountRecord[0].Cancellation_Code__c;
            }
            for (Benefit_Agreement__c benAgree : BenefitAgreementList) {
                benAgree.Cancellation_Reason__c = AccountRecord[0].Cancellation_Reason__c;
                benAgree.Cancellation_Code__c = AccountRecord[0].Cancellation_Code__c;
                benAgree.Cancellation_Explanation__c = AccountRecord[0].Cancellation_Explanation__c;
                benAgree.Requested_Cancellation_Date__c = AccountRecord[0].Requested_Cancellation_Date__c;
            }
            for (Billing__c billPrf : LGNABillingProfileList) {
                billPrf.Cancellation_Reason__c = AccountRecord[0].Cancellation_Reason__c;
                billPrf.Cancellation_Code__c = AccountRecord[0].Cancellation_Code__c;
                billPrf.Cancellation_Explanation__c = AccountRecord[0].Cancellation_Explanation__c;
                billPrf.Requested_Cancellation_Date__c = AccountRecord[0].Requested_Cancellation_Date__c;
            }
            if(isRetroCancelled){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.AccountCancellationClassError12));
                return null;
            }
            
            date renewalDate = AccountRecord[0].Renewal_Date__c;
            renewalDay = renewalDate.day();
            system.debug('renewalDate::::::::::::'+renewalDay);
            date reqCanDate = AccountRecord[0].Requested_Cancellation_Date__c;
            reqCancelDay = reqCanDate.day();
            system.debug('reqCanDate::::::::::::'+reqCanDate);           
            if(renewalDay != reqCancelDay){
                /*** start SFDC-5889 ***/
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.Account_Requested_Cancel_day_is_same_as_Renewal_Day));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Requested Cancellation Date Day: '+reqCancelDay+ '  must match the Account Renewal Date Day: ' +renewalDay));
                /*** end SFDC-5889 ***/
                return null;
            }
            completeCancellationSectionToggle = false;
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()));
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.moveToAccountCompCancelReviewPg()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
        return null;
    }
    
    public pageReference moveToAccountCompCancel() {
        completeCancellationSectionToggle = true;
        return null;
    }
    // Methods created for LGNA Group Section tabels for cancellation, commented code to reduce view state error SFDC-7899. 
    // Revised design version used GEMS Tabels to cancel Group sections. 
    
    /*** start SFDC-7455 ***/
    //SFDC-7899 2/23/2018 Padma - Method used for limit VF page list size to < 1000 //
    // *******  SFDC-7899 2/23/2018 Group Sections displayed on Review page of Account Level Cancellation Start *******//
    public List<List<Group_Section__c>> getLGNAGroupSectionList() {
        List<List<Group_Section__c>> lgnagswlist = new List<List<Group_Section__c>>();
        List<Group_Section__c> lgnagswTemp = new List<Group_Section__c>();        
        
        try {
            
            lgnagrpSecList = [select id, name, Cancellation_Status__c, Cancellation_Code__c, Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
                              Requested_Cancellation_Date__c, Certs_Cancelling__c, Members_Cancelling__c, Section_Number__c, Status__c, Group_Account__c,
                              Group_Account__r.name, Group_Account__r.Small_Group_Cancellation__c, Name__c, Total_Active_Members__c, Total_Active_Subscribers__c, Group_Number__c, External_Id__c, Underwriter__c
                              from Group_Section__c
                              where Group_Account__c = :accountId
                              and Status__c = 'Active'
                              and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                                  and Cancellation_Status__c != :ConstantsController.cancelledStatus
                                  and Cancellation_Status__c != :ConstantsController.submittedStatus
                                  and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                              limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
            for(Group_Section__c lgnags: lgnagrpSecList){
                lgnagswTemp.add(lgnags);
                if(lgnagswTemp.size() == 1000){//limit of vf repeat components
                    lgnagswlist.add(lgnagswTemp);
                    lgnagswTemp = new List<Group_Section__c>();
                }
            }
            lgnagswList.add(lgnagswTemp);
            
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()));
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
        return lgnagswlist;
    }
    // *******  SFDC-7899 2/23/2018 Group Sections displayed on Review page of Account Level Cancellation END *******//
    // *******  SFDC-7899 2/23/2018 Benefit Agreements displayed on Review page of Account Level Cancellation Start *******//
    public List<List<Benefit_Agreement__c>> getLGNABenefitAgreementList() {
        List<List<Benefit_Agreement__c>> lgnaBAwlist = new List<List<Benefit_Agreement__c>>();
        List<Benefit_Agreement__c> lgnaBAwTemp = new List<Benefit_Agreement__c>();        
     
        try {
            
            BenefitAgreementList = [SELECT id, Status__c, Group_Account__c, Benefit_Agreement_Number__c, Cancellation_Explanation__c, Requested_Cancellation_Date__c, Cancellation_Code__c,
                                    Members_Cancelling__c, Cancellation_Reason__c, Name, Cancellation_Status__c
                                    FROM Benefit_Agreement__c
                                    WHERE Group_Account__c = :accountId
                                    and status__c = 'Active'
                                    and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                                        and Cancellation_Status__c != :ConstantsController.cancelledStatus
                                        and Cancellation_Status__c != :ConstantsController.submittedStatus
                                        and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                                    and Product__r.RecordTypeId != :ProdNonBluStarRecordTypeId 
                                    limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
            for(Benefit_Agreement__c lgnaBA: BenefitAgreementList){
                lgnaBAwTemp.add(lgnaBA);
                if(lgnaBAwTemp.size() == 1000){//limit of vf repeat components
                    lgnaBAwlist.add(lgnaBAwTemp);
                    lgnaBAwTemp = new List<Benefit_Agreement__c>();
                }
            }
            lgnaBAwlist.add(lgnaBAwTemp);
            
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()));
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
        return lgnaBAwlist;
    }
    // *******  SFDC-7899 2/23/2018 Benefit Agreements displayed on Review page of Account Level Cancellation End *******//
    // *******  SFDC-7899 2/23/2018 Billing Profiles displayed on Review page of Account Level Cancellation Start *******//
    public List<List<Billing__C>> getLGNABillingList() {
        List<List<Billing__C>> lgnabillingwlist = new List<List<Billing__C>>();
        List<Billing__C> lgnaBillingwTemp = new List<Billing__C>();        
        
        try {
            
            LGNABillingProfileList = [select id, name, Cancellation_Code__c, Requested_Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
                                      Cancellation_Submitted_Date__c, Status__c, Group_Account__c, Group_Account__r.name, Cancellation_Status__c from Billing__C
                                      WHERE Group_Account__c = :accountId
                                      and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                                          and Cancellation_Status__c != :ConstantsController.cancelledStatus
                                          and Cancellation_Status__c != :ConstantsController.submittedStatus
                                          and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                                      limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
            for(Billing__C lgnab: LGNABillingProfileList){
                lgnaBillingwTemp.add(lgnab);
                if(lgnaBillingwTemp.size() == 1000){//limit of vf repeat components
                    lgnabillingwlist.add(lgnaBillingwTemp);
                    lgnabillingwTemp = new List<Billing__C>();
                }
            }
            lgnabillingwlist.add(lgnabillingwTemp);
            
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()));
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
        return lgnabillingwlist;
    }
    // *******  Billing Profiles displayed on Review page of Account Level Cancellation END *******//
    
    // Methods created for LGNA Group Section tabels for cancellation, commented unused code to reduce view state error SFDC-7899 2/23/2018. 
    // Revised design version used GEMS Tabels to cancel Group sections. 
    //Padma - Code Comment start - SFDC-7899 to reduce view state error on AccountCompleteCancellation VF page start//
    
    /*** end SFDC-7455 ***/
    
    /*  public void getLGNAGroupSectionWrapperList() {
List<Group_Section__c> lgnagrpSecList = getLGNAGroupSectionList();
List<LGNAGroupSectionWrapper> lgnagswTemp = new List<LGNAGroupSectionWrapper>();
try {
if (lgnagrpSecList != null && lgnagrpSecList.size() > 0) {
for (Group_Section__c gs : lgnagrpSecList) {
if (gs.Cancellation_Status__c != ConstantsController.pendingApprovalStatus
&& gs.Cancellation_Status__c != ConstantsController.cancelledStatus
&& gs.Cancellation_Status__c != ConstantsController.submittedStatus
&& gs.Cancellation_Status__c != ConstantsController.requestedCancellationStatus) {

lgnagrpSectionWrapperList.add(new LGNAGroupSectionWrapper(false, gs));
}
}
}

for(LGNAGroupSectionWrapper lgnagswrapper: lgnagrpSectionWrapperList){
lgnagswTemp.add(lgnagswrapper);
if(lgnagswTemp.size() == 1000){//limit of vf repeat components
lgnagswlist.add(lgnagswTemp);
lgnagswTemp = new List<LGNAGroupSectionWrapper>();
}
}
lgnagswList.add(lgnagswTemp);

} catch(Exception ex) {
//CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionWrapperList()','High');
system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
}
}*/
    /*** end SFDC-7455 ***/
    //Padma - Code Comment END - SFDC-7899 - 2/23/2018-to reduce view state error on AccountCompleteCancellation VF page //
    
    
    private boolean isSGAccount() {
        
        list<Market_Segment__c> sgsmList = [select id, name, value__c, type__c from market_segment__c where type__c = 'SG'];
        
        if (sgsmList != null && sgsmList.size() > 0 && marketSegment != null && marketSegment != '') {
            for (Market_Segment__c sm : sgsmList) {
                if (sm != null && sm.value__c.containsIgnoreCase(marketSegment)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /*** start SFDC-5767 ***/    
    public Boolean displayInputputText{get;set;}
    
    public PageReference click(){    
        if(AccountRecord[0].Small_Group_Cancellation__c){
            displayInputputText = true;
        }
        else{
            displayInputputText = false;
        }
        return null;
    }
    /*** end SFDC-5767 ***/
    
    /****** Account Cancellation END *******/ 
    
    /*******************************************************************Group Section**********************************************************************************************/
    
    public List<GEMS_Group_Section__c> getGroupSectionList() {
        List<GEMS_Group_Section__c> grpSecList = new List<GEMS_Group_Section__c>();
        
        try {
            
            /*** start SFDC-7455 ***/
            grpSecList = [select id, name, Cancellation_Status__c, Cancellation_Code__c, Cancellation_Date__c, Cancellation_Explanation__c, 
                          Cancellation_Reason__c, Requested_Cancellation_Date__c, Section_No__c, Account__c,
                          Account__r.name, Account__r.Small_Group_Cancellation__c, Group_No__c, Underwriter__c
                          from GEMS_Group_Section__c
                          where Account__c = :accountId
                          and Case__c = :caseId
                          and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                              and Cancellation_Status__c != :ConstantsController.cancelledStatus
                              and Cancellation_Status__c != :ConstantsController.submittedStatus
                              and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                          limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
            
            /*grpSecList = [select id, name, Cancellation_Status__c, Cancellation_Code__c, Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
Requested_Cancellation_Date__c, Certs_Cancelling__c, Members_Cancelling__c, Section_Number__c, Status__c, Group_Account__c,
Group_Account__r.name, Group_Account__r.Small_Group_Cancellation__c, Name__c, Total_Active_Members__c, Total_Active_Subscribers__c, Group_Number__c, External_Id__c, Underwriter__c
from Group_Section__c
where Group_Account__c = :accountId
and Status__c = 'Active'
and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
and Cancellation_Status__c != :ConstantsController.cancelledStatus
and Cancellation_Status__c != :ConstantsController.submittedStatus
and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];*/
            /*** end SFDC-7455 ***/
            
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
        return grpSecList;
    }
    
    public void getGroupSectionWrapperList() {
        List<GEMS_Group_Section__c> grpSecList = getGroupSectionList();
        List<GroupSectionWrapper> gswTemp = new List<GroupSectionWrapper>();
        try {
            if (grpSecList != null && grpSecList.size() > 0) {
                for (GEMS_Group_Section__c gs : grpSecList) {
                    if (gs.Cancellation_Status__c != ConstantsController.pendingApprovalStatus
                        && gs.Cancellation_Status__c != ConstantsController.cancelledStatus
                        && gs.Cancellation_Status__c != ConstantsController.submittedStatus
                        && gs.Cancellation_Status__c != ConstantsController.requestedCancellationStatus) {
                            
                            grpSectionWrapperList.add(new GroupSectionWrapper(false, gs));
                        }
                }
            }
            
            for(GroupSectionWrapper gswrapper: grpSectionWrapperList){
                gswTemp.add(gswrapper);
                if(gswTemp.size() == 1000){//limit of vf repeat components
                    gswlist.add(gswTemp);
                    gswTemp = new List<GroupSectionWrapper>();
                }
            }
            gswList.add(gswTemp);
            
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getGroupSectionWrapperList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
    }
    
    
    public List<GroupSectionWrapper> getSelectedGroupSectionWrapperList() {
        selectedgrpSectionWrapperList.clear();
        for (GroupSectionWrapper gsw : grpSectionWrapperList) {
            if (gsw.entrySelected) {
                selectedgrpSectionWrapperList.add(gsw);
                grpSecIds.add(gsw.entry.id);
                GsIdRecMap.put(gsw.entry.id, gsw.entry);
            }
        }
        return selectedgrpSectionWrapperList;
    }
    
    public List<Benefit_Agreement__c> getRelatedBenefitAgreement() {
        Set<id> BAisds = new Set<id> ();
        Set<id> TempBAids = new Set<id> ();
        List<Benefit_Agreement__c> benAgreeList = new List<Benefit_Agreement__c> ();
        try {
            
            for (BA_GS_Assignment__c ba_gs :[select id, Benefit_Agreement__c from BA_GS_Assignment__c where Group_Section__c in :grpSecIds and Benefit_Agreement__r.Status__c = 'Active']) {
                TempBAids.add(ba_gs.Benefit_Agreement__c);
            }
            
            if (TempBAids.size() > 0)
                for (BA_GS_Assignment__c ba_gs :[select id, Benefit_Agreement__c, Group_Section__c
                                                 from BA_GS_Assignment__c
                                                 where Benefit_Agreement__r.Status__c = 'Active' and Benefit_Agreement__c in :TempBAids
                                                ]) {
                                                    if (ba_gs_map.get(ba_gs.Benefit_Agreement__c) == null) {
                                                        Set<id> newIds = new Set<id> ();
                                                        newIds.add(ba_gs.Group_Section__c);
                                                        ba_gs_map.put(ba_gs.Benefit_Agreement__c, newIds);
                                                    } else {
                                                        ba_gs_map.get(ba_gs.Benefit_Agreement__c).add(ba_gs.Group_Section__c);
                                                    }
                                                }
            
            if (ba_gs_map.size() > 0)
                for (Id baid : ba_gs_map.keyset()) {
                    if (ba_gs_map.get(baid).size() == 1) {
                        BAisds.add(baid);
                    } else if (ba_gs_map.get(baid).size() > 1) {
                        if (grpSecIds.size() >= ba_gs_map.get(baid).size() && grpSecIds.containsAll(ba_gs_map.get(baid))) {
                            BAisds.add(baid);
                        }
                    }
                }
            if (BAisds.size() > 0)
                benAgreeList = [select id, name, Benefit_Agreement_Number__c, Status__c, Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
                                Members_Cancelling__c, Requested_Cancellation_Date__c, Cancellation_Code__c
                                from Benefit_Agreement__c
                                where id IN :BAisds
                                and Status__c = 'Active'
                                and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                                    and Cancellation_Status__c != :ConstantsController.cancelledStatus
                                    and Cancellation_Status__c != :ConstantsController.submittedStatus
                                    and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                                and Product__r.RecordTypeId != :ProdNonBluStarRecordTypeId limit :
                                Limits.getLimitQueryRows() - Limits.getQueryRows()];
            
            List<id> ids = new List<id> ();
            for (Benefit_Agreement__c benAgr : benAgreeList) {
                ids.addall(ba_gs_map.get(benAgr.id));
                if (ba_gs_map.get(benAgr.id) != null && GsIdRecMap.get(ids[0]) != null) {
                    benAgr.Cancellation_Explanation__c = GsIdRecMap.get(ids[0]).Cancellation_Explanation__c;
                    benAgr.Cancellation_Reason__c = GsIdRecMap.get(ids[0]).Cancellation_Reason__c;
                    benAgr.Requested_Cancellation_Date__c = GsIdRecMap.get(ids[0]).Requested_Cancellation_Date__c;
                    benAgr.Cancellation_Code__c = GsIdRecMap.get(ids[0]).Cancellation_Code__c;
                }
            }
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getRelatedBenefitAgreement()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
        return benAgreeList;
    }
    
    public void MassUpdate() {
        Boolean SelctedFlag = false;
        /*** start SFDC-5889 ***/      
        if(CancelDate != null && !String.isEmpty(CancelCode) && !String.isEmpty(CancelReason) && !String.isEmpty(CancelExplanation)){
            /*** end SFDC-5889 ***/            
            try{
                if(CancelDate == null){
                    CancelDate = Date.parse(StringCancelDate);
                } 
            } catch (TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
            
            if(CancelDate.day() != AccountRecord[0].Renewal_Date__c.day()){
                ShowNextButton = False;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Day value of Requested Cancellation Date entered: '+CancelDate.day()+' must match Account Renewal Date Day value: ' +AccountRecord[0].Renewal_Date__c.day()));
            } else {
                ShowNextButton = True;
                
                /*** start SFDC-5889 ***/
                for (GroupSectionWrapper gsw : grpSectionWrapperList) {
                    if (gsw.entrySelected) {
                        /*** start SFDC-5883 ***/
                        gsw.entry.Underwriter__c = AccountRecord[0].Underwriter__c;
                        /*** end SFDC-5883 ***/
                        if (CancelExplanation != '') {
                            gsw.entry.Cancellation_Explanation__c = CancelExplanation;
                        }
                        if (CancelReason != '') {
                            gsw.entry.Cancellation_Reason__c = CancelReason;
                        }
                        if (CancelDate != null) {
                            gsw.entry.Requested_Cancellation_Date__c = CancelDate;
                        }
                        if (CancelCode != '') {
                            gsw.entry.Cancellation_Code__c = CancelCode;
                        }
                        SelctedFlag = true;
                    }
                }
                if (!SelctedFlag) {
                    ShowNextButton = False;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
                }
            }
            /*** end SFDC-5889 ***/
        } else {
            ShowNextButton = False;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please populate Requested Cancellation Date, Cancellation Code, Cancellation Explanation and Cancellation Reason before proceeding.'));
        }
    }
    
    public pageReference FinishGroupSection() {
        Date TodayDate = system.Today();
        List<GEMS_Group_Section__c> updateGroupSection = new List<GEMS_Group_Section__c> ();
        List<Benefit_Agreement__c> updatebenAgreeList = new List<Benefit_Agreement__c> ();
        Set<id> uniqueset = new Set<id> ();
        //SFDC-10448 added code for AR Cancellation Flag start
        Case caseRecord = new Case();
        system.debug('Finish Group Section caseId::::'+caseId);
        if(caseId!=null){
            caseRecord = [Select Id, AR_Cancellation_Flag__c from Case where Id=:caseId];
            caseRecord.AR_Cancellation_Flag__c = arFlag;
            system.debug('Inside If caseRecord.AR_Cancellation_Flag__c:::'+caseRecord.AR_Cancellation_Flag__c);
        }
        //SFDC-10448 added code for AR Cancellation Flag END
        for (GroupSectionWrapper grpsec : selectedgrpSectionWrapperList) {
            /*** start SFDC-7455 ***/
            /*** start SFDC-5883 ***/
            //if ((!isSGAccount() || !AccountRecord[0].Small_Group_Cancellation__c) &&
            //(grpsec.entry.Requested_Cancellation_Date__c.daysBetween(TodayDate) > 60)){
            //grpsec.entry.Cancellation_Status__c = 'Pending Approval';
            //} else if (!isSGAccount() || !AccountRecord[0].Small_Group_Cancellation__c){
            grpsec.entry.Cancellation_Status__c = 'Requested Cancellation';  
            //}
            /*** end SFDC-5883 ***/
            /*** end SFDC-7455 ***/
            if (uniqueset.size() == 0 || !uniqueset.contains(grpsec.entry.id)) {
                updateGroupSection.add(grpsec.entry);
                uniqueset.add(grpsec.entry.id);
            }
        }
        system.debug('******selectedgrpSectionWrapperList' + selectedgrpSectionWrapperList);
        for (BenefitAgreementWrapper benAgrWrp : RelatedBenefitAgreementWrapper) {
            if (benAgrWrp.entrySelected == true) {
                benAgrWrp.entry.Cancellation_Status__c = 'Requested Cancellation';
                updatebenAgreeList.add(benAgrWrp.entry);
            }
        }
        
        try {
            if (updateGroupSection!= NULL && updateGroupSection.size() > 0){
                update updateGroupSection;
            //SFDC-10448 added code for AR Cancellation Flag start
                update caseRecord;//Padma
            //SFDC-10448 added code for AR Cancellation Flag END
            }
                
            /*** start SFDC-7453  ***/
            /*** SFDC-7452 Added GrpSecRetroFlag to If condition ***/
            if(accountId != null && caseId != null  && GrpSecRetroFlag == false ){
                accountIds.add(accountId);
                caseIds.add(caseId);
                // SFDC-7453 - Calling sendLGNAAccountStructureCancellation(List<Id> accountIds, List<Id> CaseIds)future call Method of ARCancellationHelper.apxc
                // ARCancelllationHelper.sendLGNAAccountStructureCancellation(accountIds,CaseIds);//Below defination changed to pass only case Id's- Padma
                ARCancelllationHelper.sendLGNAAccountStructureCancellation(CaseIds);
            }
            /*** End SFDC-7453  ***/
            /*** start SFDC-7455 ***/
            /*** start SFDC-5883 ***/
            /*for (GEMS_Group_Section__c ugs : updateGroupSection){
if (ugs.Cancellation_Status__c == 'Pending Approval'){
list<Approval.ProcessSubmitRequest> request = new list<Approval.ProcessSubmitRequest> ();
Approval.ProcessSubmitRequest temp = new Approval.ProcessSubmitRequest();
temp = new Approval.ProcessSubmitRequest();
temp.setComments('Submitting for Approval');
temp.setObjectId(ugs.id);
request.add(temp);
list<Approval.ProcessResult> result = Approval.process(request, true);
}
}*/
            /*** end SFDC-5883 ***/
            /*** end SFDC-7455 ***/
            if (updatebenAgreeList.size() > 0)
                update updatebenAgreeList;
            accountId = ApexPages.currentPage().getParameters().get('id');
            //pageReference pg = new pageReference('/' + accountId);
            pageReference pg = new pageReference('/' + caseId);
            
            /*** start SFDC-5883 ***/
            /*if(!Test.isRunningTest()){
generateRetroactiveCancellationMessage(AccountRecord[0], updateGroupSection, false);
}*/
            /*** end SFDC-5883 ***/
            
            /*** Start SFDC-7452 ***/
            if (GrpSecRetroFlag == true){
                
                Boolean MethodResult = RetroMethod(caseId, GrpSecRetroFlag);
                
                If(MethodResult==True){
                    System.Debug('Case was Updated and Approval Process was Created!');
                }else if(MethodResult==False){
                    /* problem in the RetroMethod - Throw Error */
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError15));
                    return null;                        
                }      
            }
            /*** End SFDC-7452 ***/
            
            return pg;
            
        } catch(DMLException ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.FinishGroupSection()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
    }
    
    public pageReference backToGroupSection() {
        accountId = ApexPages.currentPage().getParameters().get('id');
        selectedgrpSectionWrapperList.clear();
        ResetMassUpdateValues(new Group_Section__c());
        GroupSectionToggle = true;
        return null;
        //pageReference pg = new pageReference('/apex/AccountCancellationGroupSection?id='+accountId);
        //return pg;
    }
    
    public PageReference MoveTonextPage() {
        Boolean SelctedFlag = false;
        Boolean AllSelected = true;
        /*** start SFDC-7455 ***/
        //hasActiveMembers = false;
        /*** end SFDC-7455 ***/
        update AccountRecord[0];
        Pagereference p;
        Date TodayDate = system.Today();
        List<GEMS_Group_Section__c> RequestedDateGSList = new List<GEMS_Group_Section__c> ();
        for (GroupSectionWrapper gsw : grpSectionWrapperList) {
            if (gsw.entrySelected) {
                SelctedFlag = true;
                AllSelected = false;
                /***start SFDC-5888***/
                if(AccountRecord[0].Small_Group_Cancellation__c){
                    if(gsw!=null && gsw.entry != null && gsw.entry.Requested_Cancellation_Date__c!=null){
                        gsw.entry.Cancellation_Status__c = 'Requested Cancellation';
                    }
                } 
                /***end SFDC-5888***/
                if(AccountRecord[0].Underwriter__c == null && !AccountRecord[0].Small_Group_Cancellation__c){
                    if(gsw!=null && gsw.entry != null && gsw.entry.Requested_Cancellation_Date__c!=null && gsw.entry.Requested_Cancellation_Date__c.daysBetween(System.Today()) >= 60){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.AccountCancellationClassError11));
                        ba_gs_mapGrpSec.clear();
                        BAIds.clear();
                        return null;                                        
                    }
                } 
                if (gsw.entry.Requested_Cancellation_Date__c != null && gsw.entry.Cancellation_Explanation__c != null && gsw.entry.Cancellation_Reason__c != null && gsw.entry.Cancellation_Code__c != null) {
                    if (gsw.entry.Requested_Cancellation_Date__c != null) {
                        if (gsw.entry.Requested_Cancellation_Date__c.daysBetween(TodayDate) > 60) {
                            RequestedDateGSList.add(gsw.entry);
                        }
                    }
                    
                    /*** start SFDC-7455 ***/
                    //if (gsw.entry.Total_Active_Members__c > 0) {
                    //hasActiveMembers = true;
                    //}
                    /*** end SFDC-7455 ***/
                    
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError2));
                    ba_gs_mapGrpSec.clear();
                    BAIds.clear();
                    return null;
                }
            } else {
                AllSelected = false;
            }
        }
        if (!SelctedFlag) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            return null;
        } else if (AllSelected) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError5));
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            return null;
            // p  = new Pagereference('/apex/CancellationReviewPage');
        } else if (!AccountRecord[0].Small_Group_Cancellation__c && RequestedDateGSList.size() > 0) {
            
            /*** start SFDC-7696 ***/
            //DisplayMessage = system.label.AccountCancellationClassError6;
            if(GrpSecRetroFeatureFlag == true){
                DisplayMessage = System.label.AccountCancellationClassError13;           
            }else{
                DisplayMessage = System.label.AccountCancellationClassError16;           
            }
            /*** end SFDC-7696 ***/            
            
            /*** SFDC-7931 Begin ***/
            if(GrpSecRetroFeatureFlag == true){
                
                User UnderwriterCheck = new User();
                UserDAO UserDAOInstance = new UserDAO();
                
                System.debug('GrpSecRetroFeatureFlag UW Check: ' + AccountRecord[0].Underwriter__c);
                
                UnderwriterCheck = UserDAOInstance.getUserByID(AccountRecord[0].Underwriter__c);
                if(UnderwriterCheck == null){
                    /* Underwriter is Not Active */                    
                    /* set the message */
                    DisplayMessage = System.label.AccountCancellationClassError17;                    
                    /* set the Flag to hide the 'Confirm' button */
                    UnderWriterActiveForRetro = False;                
                }else{
                    /* Underwriter is Active */                    
                    /* set the Flag to show the 'Confirm' button */
                    UnderWriterActiveForRetro = True;
                }                
            }            
            /*** SFDC-7931 End   ***/
            
            showMessagepanel = true;
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            return null;
        } else {
            GroupSectionToggle = false;
            return null;
        }
    }
    
    public pageReference HideMessagePanel_Cat() {
        showMessagepanel = false;
        GroupSectionToggle = false;
        
        /*** start SFDC-7696 ***/
        pageReference pg = new pageReference('/' + caseId);
        return pg;
        //return null;
        /*** end SFDC-7696 ***/   
    }
    
    /*** start SFDC-7452 ***/
    public pageReference RetroConfirmation() {
        showMessagepanel = false;
        GroupSectionToggle = false;
        GrpSecRetroFlag = true; 
        return null;
    }
    /*** end SFDC-7452 ***/
    
    /*** start SFDC-7791 ***/
    public pageReference RetroConfirmation_Cat(){
        getSelectedCategoryWrapperList();            
        showMessagepanel = false;
        CategoryToggle = false;
        CatRetroFlag = true; 
        return null;
    }
    /*** start SFDC-7791 ***/    
    
    /*** start SFDC-7452 ***/
    public pageReference CancelMessagePanel() {
        showMessagepanel = false;
        GroupSectionToggle = false; 
        pageReference pg = new pageReference('/apex/AccountCancellationGroupSection?id=' + accountId + '&Case=' + caseId+'&selectedValue=Group');   
        pg.setRedirect(True);
        return pg;
    }
    /*** end SFDC-7452 ***/ 
    
    /*** start SFDC-7666 ***/
    public pageReference CancelMessagePanel_BP() {
        showMessagepanel = false;
        GroupSectionToggle = false; 
        pageReference pg = new pageReference('/apex/BillingProfileCancellation?id=' + accountId + '&Case=' + caseId+'&selectedValue=Billing');   
        pg.setRedirect(True);
        return pg;
    }
    /*** end SFDC-7666 ***/ 
    
    /*** start SFDC-7791 ***/
    public pageReference CancelMessagePanel_Cat() {
        showMessagepanel = false;
        GroupSectionToggle = false; 
        pageReference pg = new pageReference('/apex/AccountCancellationCategory?id=' + accountId + '&Case=' + caseId+'&selectedValue=Billing');   
        pg.setRedirect(True);
        return pg;
    }
    /*** end SFDC-7791 ***/ 
    
    
    //--------------------------------------SFDC-7801--Category Cancellation----------------------------------
    public list<GEMS_Category__c> getCategoryList(){
        list<GEMS_Category__c> catList=new list<GEMS_Category__c>();
        try{
            
            catlist=[select id, name,IsCancelled__c, Category_Cobra_Code__c,Cancellation_Reason__c ,Requested_Cancellation_Date__c,Cancellation_Explanation__c,Cancellation_Code__c, Category_Description__c,Effective_Date__c,Cancel_Date__c,Account__c,Usage_Billing__c, Usage_Mailing__c,Usage_Product__c,Usage_Reporting__c,Case__c,Account__r.name, Account__r.Small_Group_Cancellation__c from GEMS_Category__c
                     where Account__c = :accountId 
                     and Case__c = :caseId 
                     and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                         and Cancellation_Status__c != :ConstantsController.cancelledStatus
                         and Cancellation_Status__c != :ConstantsController.submittedStatus
                         and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                     limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
        }catch(Exception e){
            system.debug(' exception: '+e);
            return null;
        }
        return catList;
    }
    public void getCategoryWrapperList(){
        list<GEMS_Category__c> catList=getCategoryList();
        list<CategoryWrapper> tempCatlist=new list<CategoryWrapper>();
        try{
            if(catList!=null && !catList.isEmpty()){
                for(GEMS_Category__c cat: catList){
                    categoryWrapperList.add(new CategoryWrapper(false, cat));
                }
            }
            
            for(CategoryWrapper catwrapper: CategoryWrapperList){
                tempCatlist.add(catwrapper);
                if(tempCatlist.size() == 1000){//limit of vf repeat components
                    categorylist.add(tempCatlist);
                    tempCatlist= new List<CategoryWrapper>();
                }
            }
            categoryList.add(tempCatlist);
        }catch(Exception e){
            system.debug('get category WrapperList exception: '+e);
        }
    }
    
    public List<CategoryWrapper> getselectedCategoryWrapperList() {
        
        System.debug('getSelectedCategroyWrapperList Before: ' + selectedCategoryWrapperList );
        
        selectedCategoryWrapperList.clear();
        for (CategoryWrapper cat: categoryWrapperList) {
            system.debug(' selecting category:::;;'+cat);
            if (cat.entrySelected) {
                selectedCategoryWrapperList.add(cat);
                catIds.add(cat.entry.id);
                catRecMap.put(cat.entry.id, cat.entry);
            }
        }
        system.debug('selected category wrapper:'+selectedCategoryWrapperList);
        return selectedCategoryWrapperList;
    }
    
    public void CategoryMassUpdate() {
        Boolean SelctedFlag = false;
        /*** start SFDC-5889 ***/      
        if(CancelDate != null && !String.isEmpty(CancelCode) && !String.isEmpty(CancelReason) && !String.isEmpty(CancelExplanation)){
            /*** end SFDC-5889 ***/            
            try{
                if(CancelDate == null){
                    CancelDate = Date.parse(StringCancelDate);
                } 
            } catch (TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
            
            if(AccountRecord[0].Renewal_Date__c!=null && CancelDate.day() != AccountRecord[0].Renewal_Date__c.day()){
                ShowNextButton = False;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Day value of Requested Cancellation Date entered: '+CancelDate.day()+' must match Account Renewal Date Day value: ' +AccountRecord[0].Renewal_Date__c.day()));
            } else {
                ShowNextButton = True;
                
                system.debug(' category wrapper list::;;'+categoryWrapperList);
                
                if(categoryWrapperList!=null && !categoryWrapperList.isEmpty()){
                    for (CategoryWrapper cat : categoryWrapperList) {
                        if (cat.entrySelected) {
                            
                            cat.entry.Underwriter__c = AccountRecord[0].Underwriter__c;
                            
                            if (CancelExplanation != '') {
                                cat.entry.Cancellation_Explanation__c = CancelExplanation;
                            }
                            if (CancelReason != '') {
                                cat.entry.Cancellation_Reason__c = CancelReason;
                            }
                            if (CancelDate != null) {
                                cat.entry.Requested_Cancellation_Date__c = CancelDate;
                            }
                            if (CancelCode != '') {
                                cat.entry.Cancellation_Code__c = CancelCode;
                            }
                            SelctedFlag = true;
                        }
                    }
                }
                if (!SelctedFlag) {
                    ShowNextButton = False;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
                }
            }
            
        } else {
            ShowNextButton = False;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please populate Requested Cancellation Date, Cancellation Code, Cancellation Explanation and Cancellation Reason before proceeding.'));
        }
    } 
    
    public pageReference backToCategorySection() {
        
        SelectedCategoryWrapperList.clear();
        ResetMassUpdateValues(new GEMS_Category__c());
        CategoryToggle= true;
        return null;
    }
    
    public PageReference MoveCategoryNextPage() {
        Boolean SelctedFlag = false;
        Boolean AllSelected = true;       
        
        update AccountRecord[0];
        Pagereference p;
        Date TodayDate = system.Today();
        List<GEMS_Category__c> RequestedDateCatList = new List<GEMS_Category__c> ();
        for (CategoryWrapper cat : categoryWrapperList) {
            if (cat.entrySelected) {
                SelctedFlag = true;
                AllSelected = false;
                
                if(AccountRecord[0].Small_Group_Cancellation__c){
                    if(cat!=null && cat.entry != null && cat.entry.Requested_Cancellation_Date__c!=null){
                        cat.entry.Cancellation_Status__c = 'Requested Cancellation';
                    }
                } 
                if(AccountRecord[0].Underwriter__c == null && !AccountRecord[0].Small_Group_Cancellation__c){
                    if(cat!=null && cat.entry != null && cat.entry.Requested_Cancellation_Date__c!=null && cat.entry.Requested_Cancellation_Date__c.daysBetween(System.Today()) >= 60){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.AccountCancellationClassError11));
                        catRecMap.clear();
                        catIds.clear();
                        return null;                                        
                    }
                } 
                if (cat.entry.Requested_Cancellation_Date__c != null && cat.entry.Cancellation_Explanation__c != null && cat.entry.Cancellation_Reason__c != null && cat.entry.Cancellation_Code__c != null) {
                    if (cat.entry.Requested_Cancellation_Date__c != null) {
                        if (cat.entry.Requested_Cancellation_Date__c.daysBetween(TodayDate) > 60) {
                            RequestedDateCatList.add(cat.entry);
                        }
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError2));
                    catRecMap.clear();
                    catIds.clear();
                    return null;
                }
            } else {
                AllSelected = false;
            }
        }
        if (!SelctedFlag) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
            catRecMap.clear();
            catIds.clear();
            return null;
        } else if (AllSelected) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError5));
            catRecMap.clear();
            catIds.clear();
            return null;
            
        } else if (!AccountRecord[0].Small_Group_Cancellation__c && RequestedDateCatList.size() > 0) {
            if(CatRetroFeatureFlag == True){
                DisplayMessage = system.label.AccountCancellationClassError13;
                
            }else{
                DisplayMessage = System.label.AccountCancellationClassError16;
            }
            
            /*** SFDC-7931 Begin ***/
            if(CatRetroFeatureFlag == true){
                
                User UnderwriterCheck = new User();
                UserDAO UserDAOInstance = new UserDAO();
                
                System.debug('CatRetroFeatureFlag UW Check: ' + AccountRecord[0].Underwriter__c);
                
                UnderwriterCheck = UserDAOInstance.getUserByID(AccountRecord[0].Underwriter__c);
                if(UnderwriterCheck == null){
                    /* Underwriter is Not Active */                    
                    /* set the message */
                    DisplayMessage = System.label.AccountCancellationClassError17;                    
                    /* set the Flag to hide the 'Confirm' button */
                    UnderWriterActiveForRetro = False;                
                }else{
                    /* Underwriter is Active */                    
                    /* set the Flag to show the 'Confirm' button */
                    UnderWriterActiveForRetro = True;
                }                
            }            
            /*** SFDC-7931 End   ***/
            
            showMessagepanel = true;
            return null;
        } else {
            CategoryToggle = false;
            getSelectedCategoryWrapperList();            
            return null;
        }
    }
    
    public pageReference finishCategory(){
        
        List<GEMS_Category__c> updateCategory= new List<GEMS_Category__c> ();
        Set<id> uniqueset = new Set<id> ();
        //SFDC-10448 added code for AR Cancellation Flag start
        Case caseRecord = new Case();
        if(caseId!=null){
            caseRecord = [Select Id, AR_Cancellation_Flag__c from Case where Id=:caseId];
            caseRecord.AR_Cancellation_Flag__c = arFlag; 
        }
        //SFDC-10448 added code for AR Cancellation Flag END
        system.debug('******finishCategry................' );
        for (CategoryWrapper cat : selectedCategoryWrapperList) {
            cat.entry.Cancellation_Status__c = 'Requested Cancellation';  
            
            if (uniqueset.size() == 0 || !uniqueset.contains(cat.entry.id)) {
                updateCategory.add(cat.entry);
                uniqueset.add(cat.entry.id);
            }
        }
        system.debug('******selected Category WrapperList' + selectedCategoryWrapperList);
        
        try {
            if (updateCategory.size() > 0){
                 update updateCategory;
               //SFDC-10448 added code for AR Cancellation Flag start
                update caseRecord;//Padma
            //SFDC-10448 added code for AR Cancellation Flag END
            }
               
            /* SFDC-7791 - BEGIN */        
            IF(CatRetroFlag == TRUE)
            {
                Boolean MethodResult = RetroMethod(caseId, CatRetroFlag);
                
                If(MethodResult==True){
                    System.Debug('Case was Updated and Approval Process was Created!');
                }else if(MethodResult==False){
                    /* problem in the RetroMethod - Throw Error */
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError15));
                    return null;                        
                }           
            }        
            /* SFDC-7791 - END */
            
            system.debug(' AccountId:'+accountId+' caseId: '+caseId);
            /*** SFDC-7791 - Added CatRetroFlag to If conditions ***/
            if(caseId != null && CatRetroFlag == False ){
                //accountIds.add(accountId);
                caseIds.add(caseId);
                ARCancelllationHelper.sendLGNAAccountStructureCancellation(CaseIds);
            }
            
            //   accountId = ApexPages.currentPage().getParameters().get('id');
            pageReference pg = new pageReference('/' + caseId);
            
            return pg;
            
        } catch(DMLException ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.FinishGroupSection()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        } catch(Exception e){
            system.debug(' exception: '+e);
            return null;
        }
        
        
    }
    //-----end -SFDC-7801-Category Cancellation--------------------------------------------
    
    
    
    /********************************************************************* Benefit Agreement ********************************************************************************************/
    
    public List<Benefit_Agreement__c> getBAList() {
        List<Benefit_Agreement__c> BAList;
        try {
            BAList = [select id, name, Cancellation_Status__c, Cancellation_Date__c, Status__c, Group_Account__c,
                      Group_Account__r.name, Benefit_Agreement_Number__c, Cancellation_Explanation__c,
                      Cancellation_Reason__c, Members_Cancelling__c, Requested_Cancellation_Date__c, Cancellation_Code__c,
                      (select Id, Group_Section__r.Total_Active_Members__c from BA_GS_Assignments__r)
                      from Benefit_Agreement__c
                      where Group_Account__c = :accountId
                      and Status__c = 'Active'
                      and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                          and Cancellation_Status__c != :ConstantsController.cancelledStatus
                          and Cancellation_Status__c != :ConstantsController.submittedStatus
                          and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                      and Product__r.RecordTypeId != :ProdNonBluStarRecordTypeId
                      limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getBAList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
        return BAList;
    }
    
    public void getBAWrapperList() {
        List<Benefit_Agreement__c> BAList = getBAList();
        
        try {
            if (BAList != null && BAList.size() > 0) {
                for (Benefit_Agreement__c ba : BAList) {
                    if (ba.Cancellation_Status__c != ConstantsController.pendingApprovalStatus
                        && ba.Cancellation_Status__c != ConstantsController.cancelledStatus
                        && ba.Cancellation_Status__c != ConstantsController.submittedStatus
                        && ba.Cancellation_Status__c != ConstantsController.requestedCancellationStatus) {
                            
                            BAWrapperList.add(new BenefitAgreementWrapper(false, ba));
                        }
                }
            }
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getBAWrapperList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
    }
    
    public List<BenefitAgreementWrapper> getSelectedBAWrapperList() {
        selectedBAWrapperList.clear();
        for (BenefitAgreementWrapper gsw : BAWrapperList) {
            if (gsw.entrySelected) {
                selectedBAWrapperList.add(gsw);
                BAIds.add(gsw.entry.id);
                BAIdRecMap.put(gsw.entry.id, gsw.entry);
            }
        }
        return selectedBAWrapperList;
    }
    
    public List<GEMS_Group_Section__c> getRelatedGroupSection() {
        return buildRelatedGroupSectionList(false);
    }
    
    public List<GEMS_Group_Section__c> getAllRelatedGroupSection() {
        return buildRelatedGroupSectionList(true);
    }
    
    private List<GEMS_Group_Section__c> buildRelatedGroupSectionList(Boolean ignoreMultipleRelatedBAs){
        Set<id> ba_gs_set = new Set<id>();
        Set<id> TempGSids = new Set<id>();
        List<GEMS_Group_Section__c> GroupSEcList = new List<GEMS_Group_Section__c>();
        try {
            for (BA_GS_Assignment__c ba_gs : [select id, Group_Section__c from BA_GS_Assignment__c where Benefit_Agreement__c in: BAIds and Group_Section__r.Status__c = 'Active' ]) {
                TempGSids.add(ba_gs.Group_Section__c);
            }
            if (TempGSids.size() > 0)
                for (BA_GS_Assignment__c ba_gs : [select id, Benefit_Agreement__c, Group_Section__c from BA_GS_Assignment__c where Group_Section__c in: TempGSids ]) {
                    if (ba_gs_mapGrpSec.get(ba_gs.Group_Section__c) == null) {
                        Set<id> newIds = new Set<id>();
                        newIds.add(ba_gs.Benefit_Agreement__c);
                        ba_gs_mapGrpSec.put(ba_gs.Group_Section__c, newIds);
                    } else {
                        ba_gs_mapGrpSec.get(ba_gs.Group_Section__c).add(ba_gs.Benefit_Agreement__c);
                    }
                }
            if (ba_gs_mapGrpSec.size() > 0)
                for (Id gsid : ba_gs_mapGrpSec.keyset()) {
                    if (ignoreMultipleRelatedBAs){
                        ba_gs_set.add(gsid);
                    } else if (ba_gs_mapGrpSec.get(gsid).size() == 1) {
                        ba_gs_set.add(gsid);
                    } else if (ba_gs_mapGrpSec.get(gsid).size() > 1) {
                        if (BAIds.size() > ba_gs_mapGrpSec.get(gsid).size() &&  BAIds.containsAll(ba_gs_mapGrpSec.get(gsid))) {
                            ba_gs_set.add(gsid);
                        }
                    }
                }
            
            if (ba_gs_set.size() > 0)
                
                /*** start SFDC-7455 ***/                
                GroupSEcList = [select id, name, Cancellation_Code__c, Cancellation_Date__c, Cancellation_Explanation__c, 
                                Cancellation_Reason__c, Cancellation_Status__c, Requested_Cancellation_Date__c, Section_No__c,
                                Account__c, Account__r.name, Group_No__c
                                from GEMS_Group_Section__c
                                where id IN :ba_gs_set
                                and (Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                                     and Cancellation_Status__c != :ConstantsController.cancelledStatus
                                     and Cancellation_Status__c != :ConstantsController.submittedStatus
                                     and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                                limit: Limits.getLimitQueryRows() - Limits.getQueryRows()];
            
            /*GroupSEcList = [    select  id , name , Cancellation_Code__c, Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
Cancellation_Status__c, Requested_Cancellation_Date__c, Certs_Cancelling__c, Members_Cancelling__c , Section_Number__c ,
Status__c, Group_Account__c, Group_Account__r.name, Name__c, Total_Active_Members__c, Total_Active_Subscribers__c, Group_Number__c
from    Group_Section__c
where   id          IN :ba_gs_set
and Status__c   = 'Active'
and (   Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
and Cancellation_Status__c != :ConstantsController.cancelledStatus
and Cancellation_Status__c != :ConstantsController.submittedStatus
and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
limit: Limits.getLimitQueryRows() - Limits.getQueryRows()];*/
            /*** end SFDC-7455 ***/
            
            List<id> ids = new List<id>();
            for (GEMS_Group_Section__c grpSec : GroupSEcList) {
                ids.addall(ba_gs_mapGrpSec.get(grpSec.id));
                if (ba_gs_mapGrpSec.get(grpSec.id) != null && BaIdRecMap.get(ids[0]) != null) {
                    grpSec.Cancellation_Explanation__c = BaIdRecMap.get(ids[0]).Cancellation_Explanation__c;
                    grpSec.Cancellation_Reason__c      = BaIdRecMap.get(ids[0]).Cancellation_Reason__c;
                    grpSec.Requested_Cancellation_Date__c = BaIdRecMap.get(ids[0]).Requested_Cancellation_Date__c;
                    grpSec.Cancellation_Code__c  = BaIdRecMap.get(ids[0]).Cancellation_Code__c;
                }
            }
        } catch (Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getRelatedGroupSection()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
        return GroupSEcList;
    }      
    
    public pageReference MassUpdateBenefitAgree() {
        Boolean SelctedFlag = false;
        
        for (BenefitAgreementWrapper gsw : BAWrapperList) {
            if (gsw.entrySelected) {
                if (CancelExplanation != '') {
                    gsw.entry.Cancellation_Explanation__c = CancelExplanation;
                }
                if (CancelReason != '') {
                    gsw.entry.Cancellation_Reason__c = CancelReason;
                }
                if (Date.parse(StringCancelDate) != null) {
                    gsw.entry.Requested_Cancellation_Date__c = Date.parse(StringCancelDate);
                }
                if (CancelCode != '') {
                    gsw.entry.Cancellation_Code__c = CancelCode;
                }
                
                SelctedFlag = true;
            }
        }
        if (!SelctedFlag) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
        }
        return null;
    }
    
    public pageReference FinishBenefitAgreeCancel() {
        List<Benefit_Agreement__c> benefitAgreementList = new List<Benefit_Agreement__c> ();
        List<GEMS_Group_Section__c> UpdateRelatedGroupSection = new List<GEMS_Group_Section__c> ();
        List<id> ids = new List<id> ();
        if (benefitAgreementList != null)
            for (BenefitAgreementWrapper benAgrWrp : SelectedBAWrapperList) {
                benAgrWrp.entry.Cancellation_Status__c = 'Requested Cancellation';
                benefitAgreementList.add(benAgrWrp.entry);
            }
        for (GroupSectionWrapper grpSec : RelatedGroupSectionWrapper) {
            if (grpSec.entrySelected == true) {
                grpSec.entry.Cancellation_Status__c = 'Requested Cancellation';
                UpdateRelatedGroupSection.add(grpSec.entry);
            }
        }
        
        try {
            if (benefitAgreementList != null && benefitAgreementList.size() > 0)
                update benefitAgreementList;
            if (UpdateRelatedGroupSection != null && UpdateRelatedGroupSection.size() > 0)
                update UpdateRelatedGroupSection;
            pageReference pg = new pageReference('/' + accountId);
            return pg;
        } catch(DMLException ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.FinishBenefitAgreeCancel()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
    }
    
    public pageReference backToBenefitAgreementCan() {
        accountId = ApexPages.currentPage().getParameters().get('id');
        selectedBAWrapperList.clear();
        ResetMassUpdateValues(new Benefit_Agreement__c());
        benefitAgreementSectionToggle = true;
        return null;
        /*
pageReference pg = new pageReference('/apex/AccountCancellationBenefitAgreement?id='+accountId);
return pg;
*/
    }
    
    public PageReference MoveTonextBenefitAgreePage() {
        Pagereference p;
        Boolean SelctedFlag = false;
        Boolean AllSelected = true;
        Date TodayDate = system.Today();
        List<Benefit_Agreement__c> RequestedDateBAList = new List<Benefit_Agreement__c> ();
        getSelectedBAWrapperList();
        List<GEMS_Group_Section__c> relatedGSList = getAllRelatedGroupSection();
        Map<Id, Benefit_Agreement__c> activeBAWithActiveGS;
        Set<Id> currBAs = new Set<Id> ();
        
        // Loops through the Group Sections related to the Benefit Agreements and grabs all the BAs Ids
        // that have Group Sections with active members
        for (Integer i = 0; i < relatedGSList.size(); i++) {
            /*** start SFDC-7455 ***/
            //if (relatedGSList[i].Total_Active_Members__c > 0) {
            currBAs.addAll(ba_gs_mapGrpSec.get(relatedGSList[i].Id));
            //}
            /*** end SFDC-7455 ***/
        }
        
        // Grabs the Benefit Agreements from the Ids gathered above
        if (!currBAs.isEmpty()) {
            activeBAWithActiveGS = new Map<Id, Benefit_Agreement__c> ([Select Id, Name from Benefit_Agreement__c where Id in :currBAs limit :Limits.getLimitQueryRows() - Limits.getQueryRows()]);
        }
        
        String errorBAs = '';
        for (BenefitAgreementWrapper gsw : BAWrapperList) {
            if (gsw.entrySelected) {
                
                Benefit_Agreement__c currBA;
                
                if (activeBAWithActiveGS != null)
                    currBA = activeBAWithActiveGS.get(gsw.entry.Id);
                // Builds the error string with the names of Benefit Agreements that have related Group Sections with Active Members
                if (currBA != null)
                    errorBAs = errorBAs + currBA.Name + '  ';
                
                SelctedFlag = true;
                if (gsw.entry.Requested_Cancellation_Date__c != null && gsw.entry.Cancellation_Explanation__c != null && gsw.entry.Cancellation_Reason__c != null && gsw.entry.Cancellation_Code__c != null) {
                    if (gsw.entry.Requested_Cancellation_Date__c != null) {
                        if (gsw.entry.Requested_Cancellation_Date__c.daysBetween(TodayDate) > 60) {
                            RequestedDateBAList.add(gsw.entry);
                        }
                    }
                } else {
                    ba_gs_mapGrpSec.clear();
                    BAIds.clear();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError2));
                    return null;
                }
            } else {
                AllSelected = false;
            }
        }
        if (!SelctedFlag) {
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
            return null;
        } else if (AllSelected) {
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError4));
            return null;
            // p  = new Pagereference('/apex/CancellationReviewPage');
        } else if (RequestedDateBAList.size() > 0) {
            DisplayMessage = system.label.AccountCancellationClassError7;
            /*for(Benefit_Agreement__c BenAg : RequestedDateBAList){
DisplayMessage += ' ' + BenAg.Name;
}*/
            //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, DisplayMessage));
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            showMessagepanel = true;
            return null;
        } else if (errorBAs != '') {
            ba_gs_mapGrpSec.clear();
            BAIds.clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError9 + errorBAs));
            return null;
        }
        else {
            benefitAgreementSectionToggle = false;
            return null;
        }
        /*
if(p!=null)
p.setRedirect(false);
return p;
*/
    }
    
    public pageReference HideMessagePanelBA() {
        showMessagepanel = false;
        benefitAgreementSectionToggle = false;
        return null;
    }
    
    /*******************************************************************Billing Section**********************************************************************************************/
    
    public List<GEMS_Billing_Profile__c> getBillingList() {
        List<GEMS_Billing_Profile__c> billingList;
        try {
            
            /*** start SFDC-7485 ***/
            billingList = [select id, name, Cancellation_Code__c, Requested_Cancellation_Date__c, Cancellation_Explanation__c, Billing_Profile_Number__c,
                           Cancellation_Reason__c, Cancellation_Submitted_Date__c, Account__c, Account__r.name, Cancellation_Status__c
                           from GEMS_Billing_Profile__c
                           where Account__c = :accountId
                           and Case__c = :caseId  //7450
                           and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
                               and Cancellation_Status__c != :ConstantsController.cancelledStatus
                               and Cancellation_Status__c != :ConstantsController.submittedStatus
                               and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
                           limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
            
            /*billingList = [select id, name, Cancellation_Code__c, Requested_Cancellation_Date__c, Cancellation_Explanation__c, Cancellation_Reason__c,
Cancellation_Submitted_Date__c, Status__c, Group_Account__c, Group_Account__r.name, Cancellation_Status__c, External_ID__c
from Billing__c
where Group_Account__c = :accountId
and(Cancellation_Status__c != :ConstantsController.pendingApprovalStatus
and Cancellation_Status__c != :ConstantsController.cancelledStatus
and Cancellation_Status__c != :ConstantsController.submittedStatus
and Cancellation_Status__c != :ConstantsController.requestedCancellationStatus)
limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];*/
            /*** end SFDC-7485 ***/
            
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getBillingList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
        return billingList;
    }
    
    public void getBillingProfileWrapperList() {
        List<GEMS_Billing_Profile__c> bpList = getBillingList();
        
        try {
            if (bpList != null && bpList.size() > 0) {
                for (GEMS_Billing_Profile__c billing : bpList) {
                    BillingWrapperList.add(new BiilingProfileWrapper(false, billing));
                }
            }
        } catch(Exception ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.getBillingProfileWrapperList()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
        }
    }
    
    public List<BiilingProfileWrapper> getSeelectedBillingWrapperList() {
        SelectedBillingWrapperList.clear();
        for (BiilingProfileWrapper gsw : BillingWrapperList) {
            if (gsw.entrySelected) {
                SelectedBillingWrapperList.add(gsw);
            }
        }
        return SelectedBillingWrapperList;
    }
    
    public pageReference MassUpdateBilling() {
        Boolean SelctedFlag = false;
        
        /*** start SFDC-5889 ***/      
        if(CancelDate != null && !String.isEmpty(CancelCode) && !String.isEmpty(CancelReason) && !String.isEmpty(CancelExplanation)){
            /*** end SFDC-5889 ***/            
            try{
                if(CancelDate == null){
                    CancelDate = Date.parse(StringCancelDate);
                } 
            } catch (TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
            
            if(CancelDate.day() != AccountRecord[0].Renewal_Date__c.day()){
                ShowNextButton = False;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Day value of Requested Cancellation Date entered: '+CancelDate.day()+' must match Account Renewal Date Day value: ' +AccountRecord[0].Renewal_Date__c.day()));
            }else{
                ShowNextButton = True;
                
                /*** start SFDC-5889 ***/ 
                for (BiilingProfileWrapper gsw : BillingWrapperList) {
                    if (gsw.entrySelected) {
                        if (CancelExplanation != '') {
                            gsw.entry.Cancellation_Explanation__c = CancelExplanation;
                        }
                        if (CancelReason != '') {
                            gsw.entry.Cancellation_Reason__c = CancelReason;
                        }
                        /*** start SFDC-5889 - Nathan Shuyler 9/23/2017 ***/
                        //if (Date.parse(StringCancelDate) != null) {
                        //gsw.entry.Requested_Cancellation_Date__c = Date.parse(StringCancelDate);
                        if (CancelDate != null) {
                            gsw.entry.Requested_Cancellation_Date__c = CancelDate;                    
                        }
                        /*** end SFDC-5889 - Nathan Shuyler 9/23/2017 ***/          
                        if (CancelCode != '') {
                            gsw.entry.Cancellation_Code__c = CancelCode;
                        }
                        SelctedFlag = true;
                    }
                }
                if (!SelctedFlag) {
                    ShowNextButton = False;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
                }
            }
            /*** end SFDC-5889 ***/
        } else {
            ShowNextButton = False;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please populate Requested Cancellation Date, Cancellation Code, Cancellation Explanation and Cancellation Reason before proceeding.'));
        }
        return null;
    }
    
    public pageReference showselectedBillingProf() {
        Boolean SelctedFlag = false;
        Boolean AllSelected = true;
        Date TodayDate = system.Today();
        List<GEMS_Billing_Profile__c> billingList = new List<GEMS_Billing_Profile__c> ();
        List<GEMS_Billing_Profile__c> RequestedDateBPList = new List<GEMS_Billing_Profile__c> ();
        getSeelectedBillingWrapperList();
        for (BiilingProfileWrapper gsw : BillingWrapperList) {
            if (gsw.entrySelected) {
                SelctedFlag = true;
                if (gsw.entry.Requested_Cancellation_Date__c != null && gsw.entry.Cancellation_Explanation__c != null && gsw.entry.Cancellation_Reason__c != null && gsw.entry.Cancellation_Code__c != null) {
                    if (gsw.entry.Requested_Cancellation_Date__c != null) {
                        if (gsw.entry.Requested_Cancellation_Date__c.daysBetween(TodayDate) > 60) {
                            RequestedDateBPList.add(gsw.entry);
                        }
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError2));
                    return null;
                }
            } else {
                AllSelected = false;
            }
        }
        
        if (!SelctedFlag) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError1));
            return null;
        } else if (AllSelected) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError3));
            return null;
            // p  = new Pagereference('/apex/CancellationReviewPage');
        } else if (RequestedDateBPList.size() > 0) {
            
            /*** start SFDC-7696 ***/            
            if(BPRetroFeatureFlag == True){
                DisplayMessage = system.label.AccountCancellationClassError13;
            }else{
                DisplayMessage = System.label.AccountCancellationClassError16;
            }                        
            /*** end SFDC-7696 ***/
            
            /*** SFDC-7931 Begin ***/
            if(BPRetroFeatureFlag == true){
                
                User UnderwriterCheck = new User();
                UserDAO UserDAOInstance = new UserDAO();
                
                System.debug('BPRetroFeatureFlag UW Check: ' + AccountRecord[0].Underwriter__c);
                
                UnderwriterCheck = UserDAOInstance.getUserByID(AccountRecord[0].Underwriter__c);
                if(UnderwriterCheck == null){
                    /* Underwriter is Not Active */                    
                    /* set the message */
                    DisplayMessage = System.label.AccountCancellationClassError17;                    
                    /* set the Flag to hide the 'Confirm' button */
                    UnderWriterActiveForRetro = False;                
                }else{
                    /* Underwriter is Active */                    
                    /* set the Flag to show the 'Confirm' button */
                    UnderWriterActiveForRetro = True;
                }                
            }            
            /*** SFDC-7931 End   ***/
            
            showMessagepanel = true;
            return null;
        } else {
            displayBillingsection = true;
            return null;
        }
    }
    public pageReference backTobillingsection() {
        ResetMassUpdateValues(new GEMS_Billing_Profile__c());
        SelectedBillingWrapperList.clear();
        displayBillingsection = false;
        return null;
    }
    
    public pageReference FinishBillingProfileCancel() {
        List<GEMS_Billing_Profile__c> billingList = new List<GEMS_Billing_Profile__c> ();
        List<id> ids = new List<id> ();
        //SFDC-10448 added code for AR Cancellation Flag start
        Case caseRecord = new Case();
        if(caseId!=null){
            caseRecord = [Select Id, AR_Cancellation_Flag__c from Case where Id=:caseId];
            caseRecord.AR_Cancellation_Flag__c = arFlag; 
        }
        //SFDC-10448 added code for AR Cancellation Flag END
        
        if (billingList != null)
            for (BiilingProfileWrapper gsw : selectedBillingWrapperList) {
                gsw.entry.Cancellation_Status__c = 'Requested Cancellation';
                billingList.add(gsw.entry);
            }
        
        try {
            if(billingList != null && billingList.size() > 0){
                update billingList;
            //SFDC-10448 added code for AR Cancellation Flag start
                update caseRecord;//Padma
            //SFDC-10448 added code for AR Cancellation Flag END
            }
                
            /*** start SFDC-7453  ***/
            /* SFDC-7666 - Added BPRetroFlag to IF condition */
            if(accountId != null && caseId != null && BPRetroFlag == false ){
                accountIds.add(accountId);
                caseIds.add(caseId);
                // SFDC-7453 - Calling sendLGNAAccountStructureCancellation(List<Id> accountIds, List<Id> CaseIds)future call Method of ARCancellationHelper.apxc
                // ARCancelllationHelper.sendLGNAAccountStructureCancellation(accountIds,CaseIds);//Below defination changed to pass only case Id's- Padma
                ARCancelllationHelper.sendLGNAAccountStructureCancellation(CaseIds);
            }
            /*** End SFDC-7453  ***/
            
            /* SFDC-7666 - BEGIN */        
            IF(BPRetroFlag == TRUE)
            {
                Boolean MethodResult = RetroMethod(caseId, BPRetroFlag);
                
                If(MethodResult==True){
                    System.Debug('Case was Updated and Approval Process was Created!');
                }else if(MethodResult==False){
                    /* problem in the RetroMethod - Throw Error */
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.AccountCancellationClassError15));
                    return null;                        
                }           
            }        
            /* SFDC-7666 - END */            
            
            pageReference pg = new pageReference('/' + caseId);
            return pg;
        } catch(DMLException ex) {
            //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Account', null, 'AccountCancellationClass.FinishBillingProfileCancel()','High');
            system.debug('ERROR: ' + ex.getMessage() + '  ' + ex.getStackTraceString());
            return null;
        }
    }
    
    public pageReference HideMessagePanelBP() {
        showMessagepanel = false;
        displayBillingsection = true;
        BPRetroFlag = true;  //SFDC-7666
        return null;
        
        /*** start SFDC-7696, SFDC-7666 ***/
        //pageReference pg = new pageReference('/' + caseId);          
        //pageReference pg = new pageReference('/apex/BillingProfileCancellation?id=' + accountId );                            
        //pg.setRedirect(True);            
        //return pg;
        /*** end SFDC-7696, SFDC-7666  ***/
    }
    
    public static list<SelectOption> getPicklistValues(SObject obj, String fld) {
        list<SelectOption> options = new list<SelectOption> ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values) {
            options.add(new SelectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public void ResetMassUpdateValues(SObject objInstance) {
        CancellationCodePicklist = getPicklistValues(objInstance, 'Cancellation_Code__c');
        CancellationReasonPicklist = getPicklistValues(objInstance, 'Cancellation_Reason__c');
        CancelExplanation = '';
        CancelCode = '';
        StringCancelDate = '';
        CancelReason = '';
    }
    
    public static List<String> generateRetroactiveCancellationMessage(Account acc, List<GEMS_Group_Section__c> grpSections, Boolean isAccountCancellation){
        Id accountUWId = acc.Underwriter__c;
        Id accountOwnerId = acc.OwnerId;
        String subjectLine = Label.AccountCancellationSubjectLine.replace('<today>', String.valueOf(System.Today()));
        String messageBody = '';
        String messageHTMLBody = '';
        String accountBody = '';
        String accountHTMLBody = '';
        String groupSectionsBody = '';
        String groupSectionsHTMLBody = '';
        Boolean isRetroCancelledAccount = false;
        Boolean hasUnderwriter = (accountUWId != null);
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id IN (:accountUWId, :accountOwnerId)]);
        String recipientEmail = '';
        String underwriterFullName = '';
        String ccEmail = '';
        String accountOwnerFullName = '';
        if(userMap.get(accountUWId) != null){
            recipientEmail = userMap.get(accountUWId).Email;
            underwriterFullName = userMap.get(accountUWId).Name;
        }
        if(userMap.get(accountOwnerId) != null){
            ccEmail = userMap.get(accountOwnerId).Email;
            accountOwnerFullName = userMap.get(accountOwnerId).Name;
        }
        
        String accountName = acc.Name;
        String accountCancellationDate = String.valueOf(acc.Requested_Cancellation_Date__c);
        String accountId = acc.External_ID__c;
        Date today = System.Today();
        List<GroupSectionSortWrapper> retroCancelledGroupSections = new List<GroupSectionSortWrapper>();
        
        //Flag if the account is being cancelled and the account is being retroactively cancelled
        if(!acc.Small_Group_Cancellation__c && isAccountCancellation && acc.Requested_Cancellation_Date__c != null && acc.Requested_Cancellation_Date__c.daysBetween(today) >= 60){
            isRetroCancelledAccount = true;
        }
        
        //Get all group sections that are retroactively cancelled
        if(grpSections != null && grpSections.size() > 0){
            for(GEMS_Group_Section__c gs: grpSections){
                if(gs.Requested_Cancellation_Date__c != null && gs.Requested_Cancellation_Date__c.daysBetween(today) >= 60 && !acc.Small_Group_Cancellation__c){
                    retroCancelledGroupSections.add(new GroupSectionSortWrapper(gs));
                }
            }
        }
        retroCancelledGroupSections.sort();
        
        /*** start SFDC-7455 ***/
        Map<String, String> gsAPINames = new Map<String, String>{   'Group_No__c' => 'Group Number',
            'Section_No__c' => 'Section Number',
            //'Total_Active_Members__c' => 'Total Active Health Members', 
            //'Total_Active_Subscribers__c' => 'Total Active Health Subscribers', 
            'Requested_Cancellation_Date__c' => 'Requested Cancellation Date'};
                /*** end SFDC-7455 ***/
                
                String fullMessageBody = '';
        String headerLine = underwriterFullName +',<br><br>';
        String recordCancelledMessage = 'An Account or Group Section(s) has been submitted for cancellation 60+ days retroactive to the requested cancellation date for '+accountName+'.<br><br>';
        String forwardMessageLine = '<span style="color:#0070C0"><b>Please review the following cancellation request and forward this email with your approval to <a href="mailto:acctsreceiv@bcbsil.com">acctsreceiv@bcbsil.com</a></b></span><br><br>';
        String accDetailsLine = '<b>Account Details:</b><br>';
        String accGroupLine = 'Group: ' + accountName + '<br>';
        String accOwnerLine = 'Salesforce Account Owner: ' + accountOwnerFullName + '<br>';
        String accCancellationLine = 'Requested Cancellation Date: ' + accountCancellationDate + '<br><br>';
        String accCancellationMessage = '<b>The following Account was retroactively cancelled:</b><br>';
        String accData = accountId + ' - ' + acc.Name + '<br><br>';
        String gsCancellationMessage = '<b>The following Group Section(s) was retroactively cancelled:</b><br>';
        String tableHTML = '<table style="width:100%;border:1px solid black;border-collapse:collapse;"><tr>';
        for(String apiName: gsAPINames.values()){
            tableHTML += '<th style="border:1px solid black;border-collapse:collapse;text-align:left;">' + apiName + '</th>';
        }
        tableHTML += '</tr>';
        for(GroupSectionSortWrapper gsw: retroCancelledGroupSections){
            tableHTML += '<tr>';
            for(String apiName: gsAPINames.keySet()){
                String value = gsw.gs.get(apiName)!=null ? String.valueOf(gsw.gs.get(apiName)) : '-';
                if(apiName.equalsIgnoreCase('requested_cancellation_date__c') && value.contains(' ')){
                    value = value.split(' ')[0];
                }
                tableHTML += '<td style="border:1px solid black;border-collapse:collapse;">'+value+'</td>';
            }
            tableHTML += '</tr>';
        }
        tableHTML += '</table>';
        fullMessageBody += headerLine+recordCancelledMessage+forwardMessageLine+accDetailsLine+accGroupLine+accOwnerLine+accCancellationLine;
        if(isRetroCancelledAccount){
            fullMessageBody += accCancellationMessage+accData;
        }
        
        String plainTextBody = (fullMessageBody+gsCancellationMessage).replace('<br>', '\n').replaceAll('<[^>]+>',' ');
        for(GroupSectionSortWrapper gsw: retroCancelledGroupSections){
            /*** start SFDC-7455 ***/
            //plainTextBody += 'Group Section ID: ' + gsw.gs.External_Id__c + '\n';
            /*** end SFDC-7455 ***/
        }
        
        fullMessageBody += gsCancellationMessage+tableHTML;
        
        if((isAccountCancellation && (isRetroCancelledAccount || retroCancelledGroupSections.size()>0)) || 
           (!isAccountCancellation && retroCancelledGroupSections.size()>0)){
               sendEmail(new List<String>{recipientEmail}, new List<String>{ccEmail}, UserInfo.getUserEmail(), Label.AccountCancellationSenderDisplayName, subjectLine, plainTextBody, fullMessageBody);
           }
        
        return new List<String>{plainTextBody, messageHTMLBody, accountBody, accountHTMLBody, groupSectionsBody, groupSectionsHTMLBody};
            }
    
    public static Messaging.SingleEmailMessage sendEmail(List<String> recipients, List<String> ccRecipients, String sender, String displayName, String subject, String messageBody, String htmlBody){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(recipients);
        mail.setCCAddresses(ccRecipients);
        mail.setReplyTo(sender);
        mail.setSenderDisplayName(displayName);
        mail.setSubject(subject);
        mail.setPlainTextBody(messageBody);
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        return mail;
    }
    
    private boolean RetroMethod(Id CaseID, Boolean RetroFlag){
        /* Common Method to Update the Case and create an Approval for Retro */
        /* Group Section, Billing Profile, and Category Cancellations.       */
        Boolean TheReturn;
        
        If(RetroFlag==False){
            System.Debug('Entered the RetroMethod in Error!');
            TheReturn = False;
            Return TheReturn;
        }
        
        /* need to verify that the Underwriter is assigned on the Case */
        List<Case> OneCase = [Select Id, Status,AR_Cancellation_Flag__c, Underwriter_Lookup__c from Case where Id =:CaseID Limit 1];
        
        if (OneCase!= NULL && OneCase.size() > 0){
           // for(case c: OneCase){
           Case c = OneCase[0];                    
                if(string.isBlank(c.Underwriter_Lookup__c)) {
                    /* no Underwriter is declared on the Case - Error */
                    system.debug('Inside Is blank: ' + c.Underwriter_Lookup__c);                    
                    TheReturn = False;                    
                }else{
                    /* Underwriter is defined on the Case - Continue */                        
                    
                    /* Update the Case Status to 'Pending Approval' which is the Entry Criteria for */
                    /* the LGNA Retro Pending Approval Process on the Case                          */
                    c.Status = 'Pending Approval';
                    //SFDC-10448 added code for AR Cancellation Flag start
                    c.AR_Cancellation_Flag__c = arFlag;
                    //SFDC-10448 added code for AR Cancellation Flag END
                    update c;
                    
                    // Create an Approval Request for the Case
                    Approval.ProcessSubmitRequest ApprovalRequest = new Approval.ProcessSubmitRequest();
                    ApprovalRequest.setComments('Submitting request for Underwriter approval.');
                    ApprovalRequest.setObjectId(c.id);
                    
                    // Submit the record to specific process and skip the criteria evaluation
                    ApprovalRequest.setProcessDefinitionNameOrId('LGNA_Retro_Pending_Approval');
                    
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(ApprovalRequest);
                    
                    // Verify the result
                    System.debug('Approval Result: ' + result.isSuccess() + 'Status ' + result.getInstanceStatus());
                    System.assert(result.isSuccess());
                    
                    TheReturn = True;
                }
           // }                  
        }               
        Return TheReturn;
    }
    
    /* Reads the Custom Setting Feature Flags related to Retro Cancellations and */
    /* Sets the appropriate Flag values.                                         */
    public void GetRetroFeatureFlags(){      
        
        /* get the Custom Setting Feature Flags */
        LGNAFeatureFlags__c AllFeatureFlags = LGNAFeatureFlags__c.getInstance();
        
        /* Group Section Feature Flags set here */
        if (AllFeatureFlags.LGNA_Grp_Section_Retro_Cancellation__c == True){
            GrpSecRetroFeatureFlag = True;
        }else{
            GrpSecRetroFeatureFlag = False;
        }
        
        /* Billing Profile Feature Flags set here */
        if (AllFeatureFlags.LGNA_Billing_Profile_Retro_Cancellation__c == True){
            BPRetroFeatureFlag = True;
        }else{
            BPRetroFeatureFlag = False;
        }
        
        /* Billing Profile Feature Flags set here */
        if (AllFeatureFlags.LGNA_Category_Retro_Cancellation__c == True){
            CatRetroFeatureFlag = True;
        }else{
            CatRetroFeatureFlag = False;
        }
    }
    
    /*********************************************Wrapper class section*****************************************************************************************/
    public class BiilingProfileWrapper {
        public Boolean entrySelected { get; set; }
        public GEMS_Billing_Profile__c entry { get; set; }
        public BiilingProfileWrapper(Boolean b, GEMS_Billing_Profile__c e) {
            entrySelected = b;
            entry = e;
        }
    }
    
    public class GroupSectionSortWrapper implements Comparable {
        public GEMS_Group_Section__c gs;
        
        public GroupSectionSortWrapper(GEMS_Group_Section__c gs){
            this.gs = gs;
        }
        
        public Integer compareTo(Object compareTo){
            
            GroupSectionSortWrapper compareToGs = (GroupSectionSortWrapper)compareTo;
            Integer returnValue = 0;
            if(this.gs.Group_No__c > compareToGs.gs.Group_No__c){
                returnValue = 1;
            }
            else if(this.gs.Group_No__c < compareToGs.gs.Group_No__c){
                returnValue = -1;
            }
            return returnValue;
        }
    }
    
    public class GroupSectionWrapper {
        public Boolean entrySelected { get; set; }
        public GEMS_Group_Section__c entry { get; set; }
        public GroupSectionWrapper(Boolean b, GEMS_Group_Section__c e) {
            entrySelected = b;
            entry = e;
        }
    }
    
    public class LGNAGroupSectionWrapper {
        public Boolean entrySelected { get; set; }
        public Group_Section__c entry { get; set; }
        public LGNAGroupSectionWrapper(Boolean b, Group_Section__c e) {
            entrySelected = b;
            entry = e;
        }
    }
    
    
    public class BenefitAgreementWrapper {
        public Boolean entrySelected { get; set; }
        public Benefit_Agreement__c entry { get; set; }
        public Decimal totalActiveGroupSectionMembers {get;set;}
        public BenefitAgreementWrapper(Boolean b, Benefit_Agreement__c e) {
            /*** start SFDC-7455 ***/
            //totalActiveGroupSectionMembers = 0;
            //for(BA_GS_Assignment__c bags: e.BA_GS_Assignments__r){
            //totalActiveGroupSectionMembers += bags.Group_Section__r.Total_Active_Members__c;
            //}
            /*** end SFDC-7455 ***/
            entrySelected = b;
            entry = e;
        }
    }
    
    public class CategoryWrapper{
        public Boolean entrySelected {get;set;}
        public GEMS_Category__c entry{get;set;}
        
        public CategoryWrapper(Boolean selected, GEMS_Category__c cat){
            entrySelected=selected;
            entry=cat;
        }
    }
    
}