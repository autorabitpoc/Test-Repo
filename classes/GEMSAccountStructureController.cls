//************************************************************************************
// Name             : GEMSAccountStructureController.cls
// Description      : Controller for GemsCreateAS Page
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 5/18/2017        Luke Chen           SFDC-4277 add Save Draft functionality
// 4/19/2018        Phani               SFDC-4903 GEMS: BlueSTAR - Un-assigning & re-assigning (moving) Group Sections
// 4/19/2018        Gokul               SFDC-8523 GEMS: BlueSTAR - Add existing Category to an existing BA
// 4/30/2018		Luke Chen			SFDC-6942 GEMS: Acct Structure - Move Billing Association to the Group Section level in the "Create Account Structure" view.
// 5/11/2018		Luke Chen			SFDC-8446 GEMS: Acct Structure - Select group number for overall BAs (but still be editable)	
// ************************************************************************************

public class GEMSAccountStructureController {
    
    public GEMS_AccountSetup accStr {get; set;}
    public string saveResult {get; set;}
    public Boolean validation {get; set;}
    
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    public map<Id, GEMS_Group_Section__c> mapOfSavedGroupSectionIds = new map<Id, GEMS_Group_Section__c>();
    public map<string, GEMS_Group_Section__c> mapOfSavedGroupSections = new map<string, GEMS_Group_Section__c>();
    
    public PageReference init(){
        mapOfSavedGroupSectionIds = new map<Id, GEMS_Group_Section__c>([SELECT Id, Name, Case__c, Account__c, Group_No__c, Section_No__c, Section_Description__c, 
                                                                        Section_Eff_Date__c, Section_Can_Date__c, SPI_Codes__c, Par_Plan_Codes__c, Alpha_Prefix__c,isNew__c, isUpdated__c, Billing_Assoc__c // SFDC-6942 added Billing_Assoc__c                                                        
                                                                        FROM GEMS_Group_Section__c
                                                                        WHERE Case__c= : ApexPages.currentPage().getParameters().get('caseId')
                                                                        ORDER BY Name ASC]);
        for(Id gsId : mapOfSavedGroupSectionIds.keySet()){
            GEMS_Group_Section__c gs = mapOfSavedGroupSectionIds.get(gsId);
            mapOfSavedGroupSections.put(gs.Group_No__c + '-' + gs.Section_No__c, gs);
        }
        
        return null;
    }
    
    public Id caseId {get; set;}
    public Id accountId{get;set;}
    public Integer noOfBAs {get; set;}
    public Integer limitSize {get; set;}
    public Integer offsetSize {get; set;}
    public boolean disableNext {get; set;}
    public boolean disablePrev {get; set;}
    list<GEMS_Benefit_Agreement__c> bas;
    public decimal basperpage;
    
    GEMS_AccountSetupHelper helper = new GEMS_AccountSetupHelper();
    
    public GEMSAccountStructureController(ApexPages.StandardSetController controller) {
        
        caseId = ApexPages.currentPage().getParameters().get('caseId');      
        System.debug('CaseId====>'+caseId);

        validation = true;    
        // Implmenting Pagination 
        bas = [SELECT Id, AccountStructureCase__r.GEMS_BAs_Per_Page__c, Account__c, name FROM GEMS_Benefit_Agreement__c WHERE AccountStructureCase__c = : caseId];
        if(caseId != null && bas != null && bas.size() > 0){
            helper.pagination = true;
            basperpage = bas[0].AccountStructureCase__r.GEMS_BAs_Per_Page__c;
            if(basperpage == null)
                basperpage = 20;
            helper.limitSize = Integer.ValueOf(basperpage);
            helper.offsetSize = 0;
            accStr = helper.getAccountStructure(caseId);
            noOfBAs = bas.size();
            limitSize = helper.limitSize;
            offsetSize = helper.offsetSize;
            disablePrev = true;
            if(noOfBAs < = limitSize)
                disableNext = true;
            else
                disableNext = false;
        }
    }
    
    
    //Get Next Buttong on Page  -  Implementing Pagination
    public PageReference getNext(){
        if(caseId != null){
            helper.limitSize = Integer.ValueOf(basperpage);
            helper.offsetSize = helper.offsetSize + helper.limitSize;
            accStr = helper.getAccountStructure(caseId);
            noOfBAs = bas.size();
            limitSize = helper.limitSize;
            offsetSize = helper.offsetSize;
            disablePrev = false;
            if(noOfBAs < = (offsetSize + limitSize))
                disableNext = true;
            else
                disableNext = false;
            
            init();
        }
        return null;
    }
    
    // Previous Button Functionality  -  Implementing Pagination
    public PageReference getPrevious(){
        if(caseId != null){
            helper.limitSize = Integer.ValueOf(basperpage);
            helper.offsetSize = helper.offsetSize - helper.limitSize;
            accStr = helper.getAccountStructure(caseId);
            noOfBAs = bas.size();
            limitSize = helper.limitSize;
            offsetSize = helper.offsetSize;
            if(noOfBAs < = limitSize)
                disableNext = true;
            else
                disableNext = false;
            init();
        }
        return null;
    }
    
    // Save Account Structure functionality
    public PageReference saveAccountStructure(){
        system.debug('accStr : xx : ' + accStr);
        helper.mapOfSavedGroupSectionIds = mapOfSavedGroupSectionIds;
        helper.mapOfSavedGroupSections = mapOfSavedGroupSections;
        saveResult = helper.saveAccountStructure(accStr);
        if(saveResult != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, saveResult));
            return Null;
        }
        else
            return new PageReference('/apex/GEMSGenerateAccountStructure?caseId='+caseId);//Or got to 'View Account Structure page'
    }
    
    // Save Draft Account Structure functionality
    public PageReference saveDraftAccountStructure(){
        system.debug('accStr : xx : ' + accStr);
        init(); // need to update mapOfSavedGroupSectionIds and mapOfSavedGroupSections from DB every time so we don't save duplicate records that DB already has
        helper.mapOfSavedGroupSectionIds = mapOfSavedGroupSectionIds;
        helper.mapOfSavedGroupSections = mapOfSavedGroupSections;
        saveResult = helper.saveAccountStructure(accStr, true);  // save draft if passed true
        if(saveResult == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Save Draft is complete!'));
            return Null;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, saveResult));
            return Null;            
        }
    }        
    
    public PageReference GenerateDocument(){
        return new PageReference('/apex/GEMSAccountStructureDocument');
    }
    
    public PageReference DownloadPDF(){
        return new PageReference('/apex/GEMSAccountStructureTreePDF?caseId='+caseId);
    }
    
    public PageReference gotoCase() {
        return new PageReference('/'+caseId);
    }
    
    
    //SFDC-4903,SFDC-8523 Redirect To Account Structure Operation
    public PageReference GoBackToAccountStructureOperationCase(){
        PageReference ref = new PageReference('/apex/GEMSAccountStructureOperation?caseId='+caseId);
        ref.setRedirect(true);
        return ref;  
    }
    
	// SFDC-8446, populate BA's group number to all its group-section in UI
    public PageReference populateGroupNo(){
        for(GEMS_AccountSetup.BenefitAgreement uiBa : accStr.benefitAgreements )
            if(!String.isEmpty(uiBa.groupnumber) && uiBa.groupnumber != 'None')   // there is a change in BA's group number, populate it to its group-sections
            for(GEMS_AccountSetup.Category uiCategory : uiBa.categories)
                if(uiCategory.gs!=null && (uiCategory.cat.IsNew__c == true || uiBa.ba.IsNew__c == true || (uiCategory.bacat.IsNew__c == true && (uiCategory.groupsection==null || uiCategory.groupsection.IsNew__c))))
                   uiCategory.gs.groupNumber = uiBa.groupnumber;
        return null;
    }        

}