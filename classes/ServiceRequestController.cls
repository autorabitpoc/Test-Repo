/************************************************************************************** 
* Apex Class Name     : ServiceRequestController
* Version             : 1.0
* Function            : ServiceRequestController
* Modification Log    :
* Developer         Date            Description
* ----------------------------------------------------------------------------   
* Ranjit Gandhi     07/20/2017      SFDC-5330:GEMS - Cosmetic Account Maintenance: Ready To Release
* Ranjit Gandhi     07/10/2017      SFDC-4250-GEMS - NO GET case should be created for cosmetic account maintenance case (even if account team has a CIC on it) 
* Padma Bedampeta   07/10/2017      Original Version
* Padma Bedampeta   07/15/2017      SFDC-5209 Marketing Request Hub UI Interface : Access on Prospect Account
* Padma Bedampeta   07/15/2017      SFDC-5198, SFDC-5199 -Open Requests for Group and Prospect Account with Report
* Padma Bedampeta   08/02/2017      SFDC-5591 Request Hub - Enhancements - Part 2(Closed Requests with Report for Group and Prospect Account)
* Mark Naumann      08/15/2017      SFDC 5750 & 5751 Add General Case and External Case to Hub
* Zachary Campbell  09/23/2017      SFDC-5752 Add CSS Task to Hub
* Mark Naumann      09/14/2017      SFDC-6093 Add Custome Cases and Standard Cases
* Mark & Nathan     10/13/2017      SFDC-5602, SFDC-5761, SFDC-5897 HUB Metrics  
* Mark Naumann      11/19/2017      SFDC-7450 Retrieve GEMS Account Structure in LGNA - “Account Cancellation Record Type
* Mark Naumann      01/19/2018      SFDC-7452 Underwriter needed for Retro approval
* Luke Chen         01/19/2018      SFDC-7107 Tech Debt - Merge Opportunity Request Hub code to the Account Request Hub'*
* Mark Naumann		01/19/2018      SFDC-7791 Add Category to drop down for GrpSec, Bill Profile, and Category
* Gokul Bharati     03/26/2018      SFDC-7734 GEMs Account Maintenance - Incorrect Case Subject
* Bharath Raj		04/09/2018		SFDC-8691 Added method sendEIN for directing user to EIN transmission confirmation screen when user chooses 'Transmit EIN to BlueStar' option.
*************************************************************************************/
public with sharing class ServiceRequestController {
    //private ApexPages.StandardController controller;
    public Account acc {get; set;} 
    public Case CancelCase {get; set;}   //7450    
    public Case AMCase {get; set;}
    public Case LGNACase {get; set;} 
    public List<String> pcklistvals {get; set;}
    public Id prospectAccountRectypId {get; set;}
    public Id groupAccountRectypId {get; set;}
    public String azId {get; set;}
    public List<recTypeTableRow> tableRows { get; set; }
    //public List<Recordtype> rectypelst {get; set;}
    public Map<Id,Report> rectypeAndReportMap {get; set;}
    public Map<Id,Report> rectypeAndClReqReportMap {get; set;}
    public Map<Id,String> rectypeAndClosedReqsMap {get; set;}
    public Map<Id,String> rectypeAndOpenReqsMap {get; set;}
    public Report report {get; set;}
    public Report clReqReport {get; set;}
    
    //Service Request Fields
    public String retURL {get; set;}
    public String ent {get; set;}
    public String SRRecordTypeId {get; set;} 
    public Account aId {get; set;}
    public pagereference returnURL {get; set;}
    public String SRObjectId {get; set;}
    public String SRAccName {get; set;}
    public String SRAcclookupid {get; set;}
    public String SRExetv1 {get; set;}
    public String SRExetv2 {get; set;}
    public boolean isProspect {get; set;}
    public Id SRecordTypeId {get; set;}
    public Integer openEnrllnmtCount {get; set;}
    public Integer openEnrllnmtClosedCount {get; set;}
    /*SFDC-5602, SFDC-5761, SFDC-5897  - 10/2017 - BEGIN */
    public Id LGNA_GeneralCasesRecordTypeId {get; set;}
    public Id LGNA_PrivateExchangeExternalRecordTypeId {get; set;}  
    public Id CSS_Task_RecordTypeId {get; set;}  
    public Integer CosmeticAccountMaintenanceOpenCount {get; set;}
    public Integer CosmeticAccountMaintenanceClosedCount {get; set;}  
    public Integer StructureAccountMaintenanceOpenCount {get; set;}
    public Integer StructureAccountMaintenanceClosedCount {get; set;} 
    public Integer LGNA_GeneralCasesOpenCount {get; set;}
    public Integer LGNA_GeneralCasesClosedCount {get; set;} 
    public Integer LGNA_PrivateExchangeExternalCasesOpenCount {get; set;}
    public Integer LGNA_PrivateExchangeExternalCasesClosedCount {get; set;} 
    public Integer CSS_TaskOpenCount {get; set;}
    public Integer CSS_TaskClosedCount {get; set;}        
    /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - END   */
    
    //GEMS Case Fields
    public List<SelectOption> recordOptions {get; set;}
    public String selectedValue {get; set;}
    public Id GEMS_CAM_RecordTypeId {get; set;}
    public String CaseCommentdesc {get; set;}
    public  integer i {get; set;} 
    
    public string selectedCancelOption {get;set;}
    public string selectedLGNACaseOption {get;set;}
    public String CaseRecordTypeId {get; set;}
    public String CaseObjectId {get; set;}
    public String CaseAccName {get; set;}
    public String CaseAccNumber {get; set;}       
    public String CaseAccDivision {get; set;}
    public String CaseAccExec {get; set;}
    public String CaseAccDistributionMethod {get; set;}  
    public String CaseAccUnderwriter {get; set;}  
    public String CaseAccContactFullName {get; set;}  
    public String CaseAccContactTitle {get; set;} 
    public String CaseAccContactEmail {get; set;}  
    public String TaskRecordTypeId {get; set;}    
    public String TaskObjectId {get; set;}
    public String TaskAccName {get; set;}    
    public String TaskRelatedToID {get; set;}    
    public String TaskRelatedToPicklist {get; set;}
    public String TaskRelatedToText {get; set;}
    public String Question1 {get; set;}
    public String tempContractType {get; set;}
    /****** SFDC-7107 Tech Debt - Merge Opportunity Request Hub code to the Account Request Hub's **********/ 
    public Id currentUserId {get; set;}
    public string OppId {get; set;}
    public Opportunity OppDet {get; set;}
    public Account AccDet {get; set;}
    public String selectedSubCat {get; set;}
    public Boolean requestExists {get; set;}
    public GEMS_Contract_Admin_Request__c newContractRequest{get; set;}
    public List<SelectOption> RequestCategoryChoices {get; set;}
    public List<SelectOption> RequestSubCatChoices {get; set;}
    public Map<String,List<SelectOption>> RequestSubCategoryChoices {get; set;}   
    /*****************************/
    
    /**
** @author: Mei Chen
** @Story: SFDC 5588 
** @Date:  8/07/2017
**   This method is create dropdown select list in UI as Account Cancellation option.
**   Value is Visualforce page built to process the selected option request
**   Label is the friendly name showing on the UI to Users. 
**   See method "AccountCancellation" about this Options is used.
**/
    
    public list<selectOption> getCancellationOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
  //      options.add(new SelectOption('AccountCompleteCancellation?selectedValue=Complete','Account Cancellation'));
        options.add(new SelectOption('Account','Account'));
        //SFDC-7791 Updated Option -- Start //
        options.add(new SelectOption('Group Section, Billing Profile, & Category','Group Section, Billing Profile, & Category'));  
        //SFDC-7791 Updated Option -- End //    
        return options;
    }
   
    public list<selectOption> getLGNACaseOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('LGNA - General Case','LGNA - General Case'));
        options.add(new selectOption('Private Exchange - External','Private Exchange - External'));
        return options;      
    }   
       
    
    Public void find() 
    {
        if (Question1 =='No' || Question1 =='--None--')    
        {
            tempContractType = 'Standard Contracts';
        }                 
        else  
        {
            tempContractType  = 'Custom Contracts';             
        }
    }  
    
    // Constructor --- it can tell if it's for Account or Opportunity via the URL parameters
    public ServiceRequestController(ApexPages.StandardController controller){
        OppId = ApexPages.currentPage().getParameters().get('OpportunityId')!='' ? ApexPages.currentPage().getParameters().get('OpportunityId') : '';  // SFDC-7107
        if(OppId == '' || OppId == NULL){   
        // This is for Account request hub
        CancelCase = new Case(); //7450         
        AMCase = new Case();
        LGNACase = new Case();
        isProspect = false;
        tableRows = new List<recTypeTableRow>();
        rectypeAndReportMap = new Map<Id,Report>();
        rectypeAndClReqReportMap = new Map<Id,Report>();
        rectypeAndOpenReqsMap = new Map<Id,String>();
        rectypeAndClosedReqsMap = new Map<Id,String>();
        Date CurrentYear = Date.newInstance(Date.today().year(), 1, 1);
        tempContractType  = 'Standard Contracts';
        
        prospectAccountRectypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        groupAccountRectypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        //Get Record type ID's for values of Request Category picklist
        SRecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('Open Enrollment').getRecordTypeId();
        GEMS_CAM_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        
        /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - BEGIN */
        LGNA_GeneralCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LGNA - General Case').getRecordTypeId();       
        LGNA_PrivateExchangeExternalRecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Private Exchange - External').getRecordTypeId();       
        CSS_Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CSS Task Record Type').getRecordTypeId();       
        /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - END */   
        
        aId = (Account)controller.getRecord();
        acc = [select id,Name,Account_Cluster_Name__c,Account_Executive_2__c,External_ID__c,HCSC_Division__c,
               Line_of_business__c,Market_Segment__c,AccountNumber,Sales_Team__c, Distribution_Method__c, 
               Underwriter__c, Underwriter_Name__c, Contract_Signer__c from Account where Id=:aId.Id];
        azId = String.valueOf(aId.Id).substring(0, 15);
        system.debug('azId--------------'+azId);
        system.debug('Account Id---'+aId);       
        
        //Get the count of Open Requests for Open Entrollment recordtype
        openEnrllnmtCount =[SELECT count() 
                            FROM Service_Request__c 
                            WHERE Account__c = :aId.Id                             
                            AND Date_of_Meeting__c >= :Date.today() 
                            AND RecordtypeId = :SRecordTypeId];
        
        system.debug('openEnrllnmtCount---'+openEnrllnmtCount);
        
        rectypeAndOpenReqsMap.put(SRecordTypeId, String.valueOf(openEnrllnmtCount));
        rectypeAndOpenReqsMap.put(GEMS_CAM_RecordTypeId, '--');
        
        /* SFDC-5897  - 10/2017 - BEGIN */
        //Get the count of Closed Requests for Open Enrollment recordtype
        openEnrllnmtClosedCount =[SELECT  count() 
                                  FROM Service_Request__c 
                                  WHERE Account__c=:aId.Id 
                                  AND Enrollment_Specialist__c != null  /* added for SFDC-5897 */  
                                  AND Date_of_Meeting__c < TODAY
                                  AND Date_of_Meeting__c >= THIS_YEAR
                                  AND RecordtypeId=:SRecordTypeId];
        /* SFDC-5897  - 10/2017 - END */
        system.debug('openEnrllnmtClosedCount---'+openEnrllnmtClosedCount);
        
        /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - BEGIN */
        CosmeticAccountMaintenanceOpenCount = [SELECT count()
                                               FROM Case
                                               WHERE AccountId  = :aId.Id
                                               AND GEMS_Submission_Type__c = 'Cosmetic Account Maintenance'
                                               AND IsClosed = false
                                               AND RecordTypeId = :GEMS_CAM_RecordTypeId
                                              ];
        
        CosmeticAccountMaintenanceClosedCount = [SELECT count()
                                                 FROM Case
                                                 WHERE AccountId  = :aId.Id
                                                 AND GEMS_Submission_Type__c = 'Cosmetic Account Maintenance'
                                                 AND IsClosed = true
                                                 AND ClosedDate = This_Year  
                                                 AND RecordTypeId = :GEMS_CAM_RecordTypeId
                                                ];
        
        StructureAccountMaintenanceOpenCount = [SELECT count()
                                                FROM Case
                                                WHERE AccountId  = :aId.Id
                                                AND GEMS_Submission_Type__c = 'Account Structure Maintenance'
                                                AND IsClosed = false
                                                AND RecordTypeId = :GEMS_CAM_RecordTypeId
                                               ];
        
        StructureAccountMaintenanceClosedCount = [SELECT count()
                                                  FROM Case
                                                  WHERE AccountId  = :aId.Id
                                                  AND GEMS_Submission_Type__c = 'Account Structure Maintenance'
                                                  AND IsClosed = true
                                                  AND ClosedDate = This_Year  
                                                  AND RecordTypeId = :GEMS_CAM_RecordTypeId
                                                 ];        
        
        LGNA_GeneralCasesOpenCount = [SELECT count()
                                      FROM Case
                                      WHERE AccountId  = :aId.Id
                                      AND IsClosed = false 
                                      AND Status != 'Withdrawn'
                                      AND RecordTypeId = :LGNA_GeneralCasesRecordTypeId
                                     ];
        
        LGNA_GeneralCasesClosedCount = [SELECT count()
                                        FROM Case
                                        WHERE AccountId  = :aId.Id
                                        AND (IsClosed = true or Status = 'Withdrawn')
                                        AND ClosedDate = This_Year  
                                        AND RecordTypeId = :LGNA_GeneralCasesRecordTypeId
                                       ];  
        
        LGNA_PrivateExchangeExternalCasesOpenCount = [SELECT count()
                                                      FROM Case
                                                      WHERE AccountId  = :aId.Id
                                                      AND IsClosed = false 
                                                      AND Status Not In ('Declined','Withdrawn')
                                                      AND RecordTypeId = :LGNA_PrivateExchangeExternalRecordTypeId
                                                     ];
        
        LGNA_PrivateExchangeExternalCasesClosedCount = [SELECT count()
                                                        FROM Case
                                                        WHERE AccountId  = :aId.Id
                                                        AND (IsClosed = true or Status In('Declined','Withdrawn'))
                                                        AND ClosedDate = This_Year  
                                                        AND RecordTypeId = :LGNA_PrivateExchangeExternalRecordTypeId
                                                       ];  
        
        CSS_TaskOpenCount = [SELECT count()
                             FROM Task
                             WHERE AccountId  = :aId.Id
                             AND IsClosed = false
                             AND Task_Created_Date__c  = This_Year
                             AND Status != 'Withdrawn'
                             AND Status != 'Completed'
                             AND RecordTypeId = :CSS_Task_RecordTypeId
                            ];
        
        CSS_TaskClosedCount = [SELECT count()
                               FROM Task
                               WHERE AccountId  = :aId.Id
                               AND IsClosed = true                                
                               AND Task_Created_Date__c = This_Year                              
                               AND RecordTypeId = :CSS_Task_RecordTypeId                                        
                              ];
        /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - END   */
        
        rectypeAndClosedReqsMap.put(SRecordTypeId, String.valueOf(openEnrllnmtClosedCount));
        rectypeAndClosedReqsMap.put(GEMS_CAM_RecordTypeId, '--');
        
        //Custom setting Values for Request Category on pop page(Request Hub)
        pcklistvals = new List<String>();
        for(Request_Hub__c rh : Request_Hub__c.getAll().values())
            if(rh.Request_Type__c != 'Contract Admin Request') // SFDC-7107
                pcklistvals.add(rh.Request_Type__c);
        system.debug('pcklistvals-------' + pcklistvals);
        recordOptions = new List<SelectOption>();
        recordOptions.add(new SelectOption('--None--', '--None--'));
        
        //------------------------Prospect Account START------------------------------
        IF(aId.RecordTypeId == prospectAccountRectypId){
            isProspect = true;
            recordOptions.add(new SelectOption('Open Enrollment', 'Open Enrollment'));
            system.debug('Is Prospect-------');
            
            //Get name, description of displayed record types
            //rectypelst = [select id,name,Description from recordtype where id=:SRecordTypeId];
            
            list<Report> TheReports = [SELECT Id, DeveloperName 
                                       FROM Report 
                                       WHERE DeveloperName IN
                                       ('Open_Requests_for_OE_to_Group_Acc',
                                        'Closed_Requests_for_OE_for_Account'
                                       )
                                      ];
            
            list<Report> OEOpenReports = new List<Report>();
            list<Report> OEClosedReports = new List<Report>();
            
            for (Report AReport : TheReports){
                If(AReport.DeveloperName=='Open_Requests_for_OE_to_Group_Acc'){
                    OEOpenReports.add(AReport);
                }
                If(AReport.DeveloperName=='Closed_Requests_for_OE_for_Account'){
                    OEClosedReports.add(AReport);
                }
            }
            
            if(OEOpenReports.isEmpty() == false && OEClosedReports.isEmpty() == false){
                tableRows.add(new recTypeTableRow(String.valueOf(openEnrllnmtCount),OEOpenReports[0],String.valueOf(openEnrllnmtClosedCount),OEClosedReports[0],'Open Enrollment','Service Requests'));
            } else {
                tableRows.add(new recTypeTableRow(String.valueOf(openEnrllnmtCount),NULL,String.valueOf(openEnrllnmtClosedCount),NULL,'Open Enrollment','Service Requests'));
            }
            system.debug('Open Enrollment Counts: '+ openEnrllnmtCount + ' ' + openEnrllnmtClosedCount);
        }
        
        //---------------------Prospect Account END--------------------- 
        //---------------------Group Account START----------------------
        else if(aId.RecordTypeId == groupAccountRectypId){
            system.debug('Is Group---------');
            for(string rtype : pcklistvals) {
                if(rtype!=null){               
                    recordOptions.add(new SelectOption(rtype, rtype));
                }
            }
            
            //Get description of displayed record types
            //rectypelst = [select id,name,Description from recordtype where id=:SRecordTypeId OR
            //              id=:GEMS_CAM_RecordTypeId]; 
            
            //----------Report-----------
            
            if(!Test.isRunningTest()){
                //Get report for open requests
                list<Report> reports = [select Id,DeveloperName from Report where DeveloperName = 'Open_Requests_for_OE_to_Group_Acc'];
                system.debug('reports::::::::::::::'+reports);
                
                if(!reports.isEmpty()){
                    rectypeAndReportMap.put(SRecordTypeId, reports[0]);
                }
                rectypeAndReportMap.put(GEMS_CAM_RecordTypeId, NULL);
                
                //Get report for closed requests - Closed_Requests_for_OE_for_Account
                list<Report> clreports = [select Id from Report where DeveloperName = 'Closed_Requests_for_OE_for_Account']; 
                if(!clreports.isEmpty()){
                    rectypeAndClReqReportMap.put(SRecordTypeId, clreports[0]);
                }
            }
            
            /* Get the Reports in 1 SOQL statement*/
            list<Report> AllTheReports = [select Id,DeveloperName from Report where DeveloperName IN
                                          ('Open_Requests_for_OE_to_Group_Acc',
                                           'Closed_Requests_for_OE_for_Account',
                                           'Hub_AM_Cosmetic_Acct_Maint_Open',
                                           'Hub_AM_Cosmetic_Acct_Maint_Closed_YTD',
                                           'Hub_AM_Structure_Acct_Maint_Open',
                                           'Hub_AM_Structure_Acct_Maint_Closed_YTD',
                                           'Hub_LGNA_General_Cases_Open',
                                           'Hub_LGNA_General_Cases_Closed_YTD',
                                           'Hub_Private_Exc_Extn_Cases_Open',
                                           'Hub_Private_Exc_Extn_Closed_YTD',
                                           'Hub_AM_Structure_Acct_Maint_Open',
                                           'Hub_CSS_Task_Open',
                                           'Hub_CSS_Task_Closed_YTD'
                                          )
                                         ];
            list<Report> OEOpenReports = new List<Report>();
            list<Report> OEClosedReports = new List<Report>();
            list<Report> AMCosmeticAcctMaintOpenReport = new List<Report>();
            list<Report> AMCosmeticAcctMaintClosedYTDReport = new List<Report>();
            list<Report> AMStructureAcctMaintOpenReport = new List<Report>();
            list<Report> AMStructureAcctMaintClosedYTDReport = new List<Report>();            
            list<Report> LGNA_GeneralCasesOpenReport = new List<Report>();
            list<Report> LGNA_GeneralCasesYTDReport = new List<Report>();
            list<Report> LGNA_PrivateExchangeExternalCasesOpenReport = new List<Report>();
            list<Report> LGNA_PrivateExchangeExternalCasesYTDReport = new List<Report>();
            list<Report> CSS_TaskOpenReport = new List<Report>();
            list<Report> CSS_TaskClosedYTDReport = new List<Report>();
            
            if (Test.isRunningTest()){
                /* have to dummy a value in the List for this report */
                /* to ensure that Test Class does not fail with Out  */
                /* of Bounds on references in subsequent calls.      */
                Report ATestReport = new Report();
                ATestReport.Id = '00Oc0000000erni';                
                
                OEOpenReports.add(ATestReport);
                OEClosedReports.add(ATestReport);
                AMCosmeticAcctMaintOpenReport.add(ATestReport);
                AMCosmeticAcctMaintClosedYTDReport.add(ATestReport);
                AMStructureAcctMaintOpenReport.add(ATestReport);
                AMStructureAcctMaintClosedYTDReport.add(ATestReport);
                LGNA_GeneralCasesOpenReport.add(ATestReport);
                LGNA_GeneralCasesYTDReport.add(ATestReport);
                LGNA_PrivateExchangeExternalCasesOpenReport.add(ATestReport);
                LGNA_PrivateExchangeExternalCasesYTDReport.add(ATestReport);
                CSS_TaskOpenReport.add(ATestReport);
                CSS_TaskClosedYTDReport.add(ATestReport);                
            }                   
            
            /* loop thru the reports adding them to the correct List */
            for(Report AReport : AllTheReports ){
                If(AReport.DeveloperName=='Open_Requests_for_OE_to_Group_Acc'){                    
                    OEOpenReports.add(AReport);
                }                
                If(AReport.DeveloperName=='Closed_Requests_for_OE_for_Account'){                    
                    OEClosedReports.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_AM_Cosmetic_Acct_Maint_Open'){
                    AMCosmeticAcctMaintOpenReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_AM_Cosmetic_Acct_Maint_Closed_YTD'){
                    AMCosmeticAcctMaintClosedYTDReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_AM_Structure_Acct_Maint_Open'){
                    AMStructureAcctMaintOpenReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_AM_Structure_Acct_Maint_Closed_YTD'){
                    AMStructureAcctMaintClosedYTDReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_LGNA_General_Cases_Open'){
                    LGNA_GeneralCasesOpenReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_LGNA_General_Cases_Closed_YTD'){
                    LGNA_GeneralCasesYTDReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_Private_Exc_Extn_Cases_Open'){
                    LGNA_PrivateExchangeExternalCasesOpenReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_Private_Exc_Extn_Closed_YTD'){
                    LGNA_PrivateExchangeExternalCasesYTDReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_CSS_Task_Open'){
                    CSS_TaskOpenReport.add(AReport);
                }
                If(AReport.DeveloperName=='Hub_CSS_Task_Closed_YTD'){
                    CSS_TaskClosedYTDReport.add(AReport);
                }
            }                    
            
            /* Open Enrollment */
            tableRows.add(new recTypeTableRow(String.valueOf(openEnrllnmtCount),OEOpenReports[0],String.valueOf(openEnrllnmtClosedCount),OEClosedReports[0],'Open Enrollment','Service Requests'));
            
            /* Account Maintenance - HUB Metrics Labels SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - BEGIN */
            tableRows.add(new recTypeTableRow(String.valueOf(CosmeticAccountMaintenanceOpenCount),AMCosmeticAcctMaintOpenReport[0],String.valueOf(CosmeticAccountMaintenanceClosedCount),AMCosmeticAcctMaintClosedYTDReport[0],'Account Maintenance','Cosmetic'));
            tableRows.add(new recTypeTableRow(String.valueOf(StructureAccountMaintenanceOpenCount),AMStructureAcctMaintOpenReport[0],String.valueOf(StructureAccountMaintenanceClosedCount),AMStructureAcctMaintClosedYTDReport[0],'Account Maintenance','Structure')); 
            tableRows.add(new recTypeTableRow(String.valueOf(LGNA_GeneralCasesOpenCount),LGNA_GeneralCasesOpenReport[0],String.valueOf(LGNA_GeneralCasesClosedCount),LGNA_GeneralCasesYTDReport[0],'LGNA - Case','LGNA General Case'));
            tableRows.add(new recTypeTableRow(String.valueOf(LGNA_PrivateExchangeExternalCasesOpenCount),LGNA_PrivateExchangeExternalCasesOpenReport[0],String.valueOf(LGNA_PrivateExchangeExternalCasesClosedCount),LGNA_PrivateExchangeExternalCasesYTDReport[0],'LGNA - Case','Private Exchange - External'));
            tableRows.add(new recTypeTableRow(String.valueOf(CSS_TaskOpenCount),CSS_TaskOpenReport[0],String.valueOf(CSS_TaskClosedCount),CSS_TaskClosedYTDReport[0],'Task','CSS Task'));
            /* Account Maintenance - HUB Metrics Labels SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - END */           
            
            //------------------------Group Account END------------------------------            
        }
        
        //Getting Id's of fileds to populate on Service Request edit page through Custom settings
        If(Service_Request_Ids__c.Field_Id__c!=null){
            SRObjectId = Service_Request_Ids__c.getValues('ObjectId').Field_Id__c;
            system.debug('SRObjectId---'+SRObjectId);
            SRAccName = Service_Request_Ids__c.getValues('Name').Field_Id__c;
            SRAcclookupid = Service_Request_Ids__c.getValues('LookUp_Id').Field_Id__c;
            SRExetv1 = Service_Request_Ids__c.getValues('Executive_Name_1').Field_Id__c;
            SRExetv2 = Service_Request_Ids__c.getValues('Executive_Name_2').Field_Id__c; 
        }
        //Getting Id's of fields to populate on Case edit page through Custom settings
        If(Case_Ids__c.Field_Id__c!=null){
            CaseObjectId = Case_Ids__c.getValues('ObjectId').Field_Id__c;
            system.debug('CaseObjectId--->'+ CaseObjectId);
            CaseAccName = Case_Ids__c.getValues('Name').Field_Id__c;
            system.debug('CaseAccName--->'+CaseAccName);            
            CaseAccNumber = Case_Ids__c.getValues('AccountNumber').Field_Id__c;
            system.debug('CaseAccNumber--->'+CaseAccNumber);                                
            CaseAccDivision = Case_Ids__c.getValues('Division').Field_Id__c;
            system.debug('CaseAccDivision---'+CaseAccDivision); 
            CaseAccExec = Case_Ids__c.getValues('CaseAccExec').Field_Id__c;
            system.debug('CaseAccExec---'+CaseAccExec);
            CaseAccDistributionMethod = Case_Ids__c.getValues('DistributionMethod').Field_Id__c;
            system.debug('Distribution Method---'+CaseAccDistributionMethod);           
            CaseAccUnderwriter = Case_Ids__c.getValues('Underwriter').Field_Id__c;
            system.debug('CaseAccUnderwriter---'+ CaseAccUnderwriter);              
            CaseAccContactFullName = Case_Ids__c.getValues('ContractFullName').Field_Id__c;
            system.debug('CaseAccContactFullName---'+ CaseAccContactFullName);                              
            CaseAccContactTitle = Case_Ids__c.getValues('ContractTitle').Field_Id__c;
            system.debug('CaseAccContactTitle---'+ CaseAccContactTitle);                        
            CaseAccContactEmail = Case_Ids__c.getValues('ContractEmail').Field_Id__c;
            system.debug('CaseAccContactEmail---'+ CaseAccContactEmail);
        }   
        //Getting Id's of fields to populate on Task edit page through Custom settings        
        If(Task_Ids__c.Field_Id__c!=null){
            system.debug('Get custom setting Task Ids');          
            TaskObjectId = Task_Ids__c.getValues('ObjectId').Field_Id__c;
            system.debug('TaskObjectId--->'+ TaskObjectId);
            TaskAccName = Task_Ids__c.getValues('Name').Field_Id__c;
            system.debug('TaskAccName--->'+TaskAccName);
            TaskRelatedToID = Task_Ids__c.getValues('RelatedToID').Field_Id__c;
            system.debug('TaskRelatedToID--->'+TaskRelatedToID);
            TaskRelatedToPicklist = Task_Ids__c.getValues('RelatedToPicklist').Field_Id__c;
            system.debug('TaskRelatedToPicklist--->'+TaskRelatedToPicklist);         
            TaskRelatedToText = Task_Ids__c.getValues('RelatedToText').Field_Id__c;
            system.debug('TaskRelatedToText--->'+TaskRelatedToText);            
        }
        }      
        /************* SFDC-7107 Tech Debt - Merge Opportunity Request Hub code to the Account Request Hub's *************/ 
        else if(OppId != NULL && OppID != ''){
        //Custom setting Values for Request Category on pop page(Request Hub)
        pcklistvals = new List<String>();
        for(Request_Hub__c rh : Request_Hub__c.getAll().values()){
                if(rh.Request_Type__c == 'Contract Admin Request'){                  
                   pcklistvals.add(rh.Request_Type__c); 
                }
            system.debug('pcklistvals-------'+pcklistvals);
        }    
        recordOptions = new List<SelectOption>();
        tableRows = new List<recTypeTableRow>();
        recordOptions.add(new SelectOption('--None--', '--None--'));
        for(string rtype : pcklistvals) {
                if(rtype!=null){               
                    recordOptions.add(new SelectOption(rtype, rtype));
                }
            }
        currentUserId = userInfo.getUserId();
        requestExists = false;      
        RequestCategoryChoices = new List<SelectOption>();
        RequestCategoryChoices.add(new SelectOption('--None--', '--None--'));
        RequestCategoryChoices.add(new SelectOption('Contract Admin Request', 'Contract Admin Request'));
        RequestSubCatChoices = new List<SelectOption>();
        RequestSubCatChoices.add(new SelectOption('--None--', '--None--'));
        RequestSubCatChoices.add(new SelectOption('Custom SBC or Benefit Booklets', 'Custom SBC or Benefit Booklets'));
        RequestSubCategoryChoices = new Map<String,List<SelectOption>>();
        RequestSubCategoryChoices.put('Contract Admin Request', RequestSubCatChoices); 
        tableRows.add(new recTypeTableRow('', new Report(),'',new Report(),'Contract Admin Request','Submit Requests to Contract Administration'));            
        }    
        /*******************************************************/   
    }
    
    public Pagereference AccountCancellation(){
        system.debug('>>>> Continue Button -> AccountCancellation()');
        PageReference newurl;
        //AccountCompleteCancellation?Id=0011900000ROcAUAA1&selectedValue=Complete
        //AccountCancellationGroupSection?Id=0011900000ROcAUAA1&selectedValue=Group
        //AccountCancellationBenefitAgreement?Id=0011900000ROcAUAA1&selectedValue=Benefit
        //billingProfileCancellation?Id=0011900000ROcAUAA1&selectedValue=Billing
        
       if(selectedValue == 'Cancellation' && selectedCancelOption=='Account' ){ 
                  //if(selectedCancelOption=='Account Cancellation'){
            String baseURL=URL.getSalesforceBaseUrl().toExternalForm();
          //newurl=new PageReference('/apex/'+selectedCancelOption+'&id='+acc.id);
           newurl=new PageReference('/apex/AccountCompleteCancellation?selectedValue=Complete+&id='+acc.id);
        }
        system.debug('return URL '+newurl);
        return newurl;
       }
    
    /******************************************************************** 
    *    Method Name : sendEIN
    *   @description : This method is called when user chooses 'Transmit EIN to BlueStar' option in request hub. 
    * 				   This method will open a new tab for the user where the list of EINs which are pending for transmission to BlueStar will be displayed.
    *   @parameters  : Map of New Trigger, Map of Old Trigger
    *   @return type :   void. 
    *   @Author      : Bharath
    ***************************************************************/          
    public Pagereference sendEIN(){
        PageReference newurl;
       if(selectedValue == 'Transmit EIN to BlueStar'){ 
            String baseURL=URL.getSalesforceBaseUrl().toExternalForm();
           newurl=new PageReference('/apex/LGNA_EIN_ConfirmVF?');
        }
        system.debug('return URL '+newurl);
        return newurl;
       }    
    
    public Pagereference createNewCase(){
        system.debug('>>>> Continue Button -> createNewCase()');
        system.debug('Account Id ----'+acc);
        system.debug('selected requested: '+selectedValue+' is cancellation? '+selectedCancelOption);
        
        if(selectedValue == 'Open Enrollment' && isProspect == false)
        {
            SRRecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get(selectedValue).getRecordTypeId();
            returnURL = new PageReference('/'+SRObjectId+'/e'); 
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', SRRecordTypeId);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            if (aId.Id != null){
                returnURL.getParameters().put(SRAccName, acc.Name);
                returnURL.getParameters().put(SRAcclookupid, aId.Id);
                returnURL.getParameters().put(SRExetv1, acc.Account_Cluster_Name__c);
                returnURL.getParameters().put(SRExetv2, acc.Account_Executive_2__c);
            } 
            
        }else if(selectedValue == 'Open Enrollment' && isProspect == true)
        {
            SRRecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get(selectedValue).getRecordTypeId();
            returnURL = new PageReference('/'+SRObjectId+'/e'); 
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', SRRecordTypeId);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            if (aId.Id != null){
                returnURL.getParameters().put(SRAccName, acc.Name);
                returnURL.getParameters().put(SRAcclookupid, aId.Id);
                returnURL.getParameters().put(SRExetv1, acc.Sales_Team__c);
                //returnURL.getParameters().put(SRExetv2, acc.Account_Executive_2__c);
            } 

            // Start SFDC-7450
        }else if(selectedValue == 'Cancellation' && selectedCancelOption=='Group Section, Billing Profile, & Category')    //SFDC-7791 Update option                  
        {                         
            CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
            CancelCase.RecordTypeId = CaseRecordTypeId;
            CancelCase.AccountId = acc.Id;
            CancelCase.type='Account Cancellation';            
            CancelCase.HCSC_Division__c = acc.HCSC_Division__c;
            CancelCase.GEMS_Line_of_Business__c = acc.Line_of_business__c;
            CancelCase.GEMS_Effective_Date__c = system.today();         
            CancelCase.GEMS_Case_Effective_Date__c = system.today();         
            CancelCase.subject = acc.Name+' '+acc.External_ID__c+' '+ CancelCase.GEMS_Submission_Type__c;
            //SFDC START 7452
            CancelCase.Underwriter_Lookup__c = acc.Underwriter__c;
            //SFDC END 7452            
            insert CancelCase;
            
            returnURL = new PageReference('/'+CancelCase.Id);     
            system.debug('selectedValue :----------------> '+selectedValue); 
            system.debug('selectedCancelOption :---------> '+selectedCancelOption);                       
            // End SFDC-7450

        }else if(selectedValue == 'Account Maintenance')
        { 
            // SFDC-5729 - Display Error if user selects more than one Subm. Sub-Type for Rate Change.      
              if (AMCase.GEMS_Submission_Type__c == 'Rate Change/Stop Loss Maintenance') {                                  
                string subtypeallvalues = AMCase.GEMS_Submission_Sub_Type__c;                                       
                if (subtypeallvalues.contains(';')) {       
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You cannot select more than one Submission Sub type.');        
                    ApexPages.addMessage(myMsg);        
                    return null;        
                }                       
            }      
            SRRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(selectedValue).getRecordTypeId();
            AMCase.RecordTypeId = SRRecordTypeId;
            AMCase.AccountId = acc.Id;
            AMCase.type=selectedValue;
            AMCase.HCSC_Division__c = acc.HCSC_Division__c;
            AMCase.GEMS_Line_of_Business__c = acc.Line_of_business__c;
            //SFDC-4250-GEMS - NO GET case should be created for cosmetic account maintenance case (even if account team has a CIC on it) 
            //SUbject and status values  
            //AMCase.GEMS_Case_Effective_Date__c = system.today();         
            AMCase.subject = acc.Name+' '+acc.External_ID__c+' '+ AMCase.GEMS_Submission_Type__c;
            //SFDC-5330: GEMS - Cosmetic Account Maintenance: Ready To Release
            AMCase.GEMS_Ready_to_release_to_screening__c='Not Released';
            insert AMCase;
            
            system.debug('CaseCommentdesc'+CaseCommentdesc);
            if(CaseCommentdesc!=null && CaseCommentdesc!=''){
                CaseComment cc = new CaseComment (ParentID = AMCase.id, isPublished=false);
                cc.CommentBody = CaseCommentdesc;
                insert cc;
            } 
            system.debug('AMCase.GEMS_Submission_Type__c' +AMCase.GEMS_Submission_Type__c);
            system.debug('AMCase.GEMS_Submission_Type__c' +AMCase.GEMS_Submission_Type__c);
            returnURL = new PageReference('/'+AMCase.Id);     
            system.debug('selectedValue 01: '+selectedValue);  
            system.debug('selectedLGNACaseOption 02: '+selectedLGNACaseOption);  
            
            /*** start SFDC-5750 ***/
        }else if (selectedValue == 'LGNA Case' && selectedLGNACaseOption == 'LGNA - General Case')  
        {       
            CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LGNA - General Case').getRecordTypeId();     
            returnURL = new PageReference('/'+CaseObjectId+'/e');   
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', CaseRecordTypeId);    
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');                 
            if (aId.Id != null){                                      
                returnURL.getParameters().put(CaseAccName, acc.Name);                 
            }
            /*** end SFDC-5750 ***/                
            /*** start SFDC-5751 ***/                
        }else if (selectedValue == 'LGNA Case' && selectedLGNACaseOption == 'Private Exchange - External')
        {
            CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Private Exchange - External').getRecordTypeId();
            returnURL = new PageReference('/'+CaseObjectId+'/e');  
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', CaseRecordTypeId);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            if (aId.Id != null){
                returnURL.getParameters().put(CaseAccName, acc.Name);
                returnURL.getParameters().put(CaseAccDivision, acc.HCSC_Division__c);                   
                returnURL.getParameters().put(CaseAccExec, acc.Account_Cluster_Name__c); 
            }
            /*** end SFDC-5751 ***/
            /*** start SFDC-6102 ***/                
        }else if (selectedValue == 'Contract Admin' && tempContractType == 'Custom Contracts')
        {
            CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
            returnURL = new PageReference('/'+CaseObjectId+'/e');  
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', CaseRecordTypeId);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            if (aId.Id != null){
                returnURL.getParameters().put(CaseAccName, acc.Name);
                returnURL.getParameters().put(CaseAccDistributionMethod, acc.Distribution_Method__c);
                returnURL.getParameters().put(CaseAccDivision, acc.HCSC_Division__c);                   
                returnURL.getParameters().put(CaseAccExec, acc.Account_Cluster_Name__c); //Account Exec 1               
                returnURL.getParameters().put(CaseAccUnderwriter, acc.Underwriter_Name__c);                 
            }     
        }else if (selectedValue == 'Contract Admin' && tempContractType == 'Standard Contracts')
        {
            CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Standard Contracts').getRecordTypeId();
            returnURL = new PageReference('/'+CaseObjectId+'/e');  
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', CaseRecordTypeId);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            if (aId.Id != null){
                returnURL.getParameters().put(CaseAccName, acc.Name);
                returnURL.getParameters().put(CaseAccNumber, acc.AccountNumber);               
                returnURL.getParameters().put(CaseAccDistributionMethod, acc.Distribution_Method__c);
                returnURL.getParameters().put(CaseAccDivision, acc.HCSC_Division__c);                   
                returnURL.getParameters().put(CaseAccExec, acc.Account_Cluster_Name__c); //Account Exec 1               
                returnURL.getParameters().put(CaseAccUnderwriter, acc.Underwriter_Name__c); 
                
                List<Contact> Contacts = new List<Contact>();
                Contacts = [SELECT Id, Title, Email, Name from Contact WHERE Id = :acc.Contract_Signer__c LIMIT 1];
                for (Contact AcctContact:Contacts)
                {
                    returnURL.getParameters().put(CaseAccContactFullName, AcctContact.Name);
                    returnURL.getParameters().put(CaseAccContactTitle, AcctContact.Title);
                    returnURL.getParameters().put(CaseAccContactEmail, AcctContact.Email); 
                }                                                                                                                                                        
            }                    
            /*** end SFDC-6102 ***/                 
            /*** start SFDC-5752 ***/   
        }else if (selectedValue == 'CSS Task')
        {        
            TaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CSS Task Record Type').getRecordTypeId();
            returnURL = new PageReference('/'+TaskObjectId+'/e');  
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', TaskRecordTypeId);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            if (aId.Id != null){
                returnURL.getParameters().put(TaskRelatedToID, aId.Id); 
                returnURL.getParameters().put(TaskRelatedToText, acc.Name);                  
            }
        }
        /*** End SFDC-5752 ***/  
        return returnURL;
    }
    
    public class recTypeTableRow {        
        public RecordType recType {get; set;}
        public String openReqs {get; set;}
        public String closedreqs {get; set;}
        public Report openRequestsReportObj {get; set;}
        public Report closedRequestsReportObj {get; set;}
        
        /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - BEGIN */
        public String NameColumn {get; set;}
        public String DescriptionColumn {get; set;}
        
        public recTypeTableRow(String oreqs, Report rpt, String creqs, Report clreqrpt, String InputNameColumn, String InputDescriptionColumn) {            
            this.openReqs = oreqs;
            this.openRequestsReportObj = rpt;
            this.closedreqs = creqs;
            this.closedRequestsReportObj = clreqrpt;
            
            this.NameColumn = InputNameColumn;
            This.DescriptionColumn = InputDescriptionColumn;
        }
        /*SFDC-5602, SFDC-5761, SFDC-5897 - 10/2017 - END   */
    }
    
    /***************************************************************************************
     * Method : createRequest (SFDC-7107)
     * Parameters : None
     * Return : URL for the newly created Contract Admin Request. 
     * Description : This method creates new Contract Admin Request if there are no existing requests assigned to the Opportunity. 
     *              This method is called from the screen on hitting Continue button after filling details in the Request Hub. 
     ***************************************************************************************/
    public pageReference createRequest(){
        system.debug('>>>> Continue Button -> createRequest()');
        returnURL = null;
        //Check whether a SBC/BB request already exists for this opportunity. 
        if(selectedValue == 'Contract Admin Request' && selectedSubCat == 'Custom SBC or Benefit Booklets'){
            checkRequestExists();
            //Proceed only if the Contract Admin request does not exist.
            if(!requestExists){
                try{
                    OppDet = [select id, name, AccountId, Requested_Effective_Date__c from Opportunity where id = :OppId limit 1];
                    AccDet = [select id, name, Market_Segment__c, Line_of_business__c, District__c, Cluster__c, Open_Enrollment_Date__c, HCSC_Division__c, Region__c from Account where id = :OppDet.AccountId limit 1];
                    newContractRequest = new GEMS_Contract_Admin_Request__c();
                    newContractRequest.RecordTypeId = Schema.SObjectType.GEMS_Contract_Admin_Request__c.getRecordTypeInfosByName().get('GEMS SBC & Benefit Booklet Request').getRecordTypeId();
                    newContractRequest.OwnerId = currentUserId;
                    newContractRequest.Opportunity_Link__c = OppId;
                    newContractRequest.Created_Date_Time__c = system.now();
                    newContractRequest.Market_Segment__c = AccDet.Market_Segment__c;
                    newContractRequest.District__c = AccDet.District__c;
                    newContractRequest.Cluster__c = AccDet.Cluster__c;
                    newContractRequest.Open_Enrollment_Start_Date__c = AccDet.Open_Enrollment_Date__c;
                    newContractRequest.Effective_Date__c = OppDet.Requested_Effective_Date__c;
                    newContractRequest.Hidden_HCSC_Division__c = AccDet.HCSC_Division__c;
                    newContractRequest.Region__c = AccDet.Region__c;
                    newContractRequest.Line_of_Business__c = AccDet.Line_of_business__c;
                    insert newContractRequest;
                    returnURL = new pageReference('/'+newContractRequest.Id);
                }
                catch(Exception e){
                    CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Account/Opportunity', null, 'ServiceRequestController.createRequest()','High');  
                    system.debug(e);
                }
            }
        }
        return returnURL;
    }
    
    /***************************************************************************************
     * Method : checkRequestExists (SFDC-7107)
     * Parameters : None
     * Return : None
     * Description : Checks whether a Contract Admin Request already exists for Opportunity and sets the flag requestExists accordingly. 
     ***************************************************************************************/
    public void checkRequestExists(){
        Integer count=[select count() from GEMS_Contract_Admin_Request__c where Opportunity_Link__c = :OppId];
        if(count>0){
            requestExists = true;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.INFO,'There already exists one request in this Opportunity. Navigate to Submission Case to add additional SBC or Benefit Booklet requests'));
        }
        else{
            requestExists = false;
        }
    }    

}