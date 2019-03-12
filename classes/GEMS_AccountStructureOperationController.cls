//************************************************************************************
// Name             : GEMS_AccountStructureOperationController.cls
// Description      : Controller for special operations on the account structures
// ********************************************Version Updates******************************************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------------------------------------------------
// 4/19/2018        Phani               SFDC-4903 GEMS: BlueSTAR - Un-assigning & re-assigning (moving) Group Sections
// 4/19/2018        Gokul               SFDC-8523 GEMS: BlueSTAR - Add existing Category to an existing BA
// *****************************************************************************************************************************

public class GEMS_AccountStructureOperationController{
    
    //Move Operation Variables to store user input
    public String sourceBAName{get;set;}
    public String enterTargetBA{get;set;}
    public String selectedGN{get;set;}
    public String enterSN{get;set;}
    public String sourceCATName{get;set;}
    public GEMSStructureWrapper asw{get;set;}
    public String bp{get;set;}
    public Boolean disableSubmitButton{set;get;}  
    
    //Add and Remove Operation Variables to store user input
    public string enterBA{get;set;}
    public string enterCAT{get;set;}
    public string enterGroupSection{get;set;}
    Set<string> resultSet = new Set<string>();
    
    //Move Operation Variables used to display search result 
    public List<GEMS_Group_Section__c> GSList{get;set;}
    public GEMS_Benefit_Agreement__c sourceBA{get;set;}
    public GEMS_Benefit_Agreement__c targetBA{get;set;}
    
    
    //Add and Remove Operation Variables used to display search result 
    public List<GEMS_Benefit_Agreement__c> BAList{get;set;}
    public List<GEMS_Category__c> CATList{get;set;}
    public List<ResultWrapper> results{get{
        if(results == null){         
            results = new List<ResultWrapper>();
        }
        if(results.isEmpty() && results != null){
            results = new List<ResultWrapper>();
        }
        return results;    
    }
                                       set;}    
    
    //variables to store select operation
    public string selectOperation {get;set;}
    
    //variables to store the account structure caseId
    public string caseId{get;set;}
    public string accountId{get;set;}
    
    //Get Operation List on Load
    public List<SelectOption> getoperations(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Add','Add Existing Category to Existing BA'));
        options.add(new SelectOption('Remove','Remove Existing Category to Existing BA'));
        options.add(new SelectOption('Move','Move Existing Group Section'));
        return options;
    }
    
    public GEMS_AccountStructureOperationController(){
        caseId = ApexPages.currentPage().getParameters().get('caseId');     
        if(caseId == null || string.isBlank(caseId)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Loading the Page');
            ApexPages.addMessage(myMsg);
        }
        else if((caseId != null || !string.isBlank(caseId))){ 
            if(Schema.Case.SObjectType != Id.valueOf(caseId).getSobjectType()){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Bad Parameter');
                ApexPages.addMessage(myMsg);   
            }
        }
        else{
            BAList = new List<GEMS_Benefit_Agreement__c>();
            CATList = new List<GEMS_Category__c>();
        }  
    }
    
    //Search BA
    public void SearchBA(){   
        if(string.isBlank(enterBA) || !enterBA.isNumeric() || enterBA.length() > 4 || enterBA.length() < 4){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter 4 digits BA#');
            ApexPages.addMessage(myMsg);       
        }
        else{
            BAList = GEMS_AccountStructureOperationHelper.getBA(enterBA,caseId);
            if(BAList.isEmpty()){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Record Exist');
                ApexPages.addMessage(myMsg);
            }
            else if(!BAList.isEmpty() && BAList[0].isNew__c){
                BAlist.clear();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter an existing benefit agreement');
                ApexPages.addMessage(myMsg);              
            }
        }
        
    }
    
    //Search Category
    public void SearchCAT(){
        if(string.isBlank(enterCAT)|| !enterCAT.isNumeric() || enterCAT.length() > 4 || enterCAT.length() < 4){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter 4 digits Category#');
            ApexPages.addMessage(myMsg);       
        }
        else{
            CATList = GEMS_AccountStructureOperationHelper.getCAT(enterCAT,caseId);
            if(CATList.isEmpty()){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Record Exist');
                ApexPages.addMessage(myMsg);
            }
            else if(!CATList.isEmpty() && CATList[0].isNew__c){//New Category
                CATList.clear();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter an existing category');
                ApexPages.addMessage(myMsg);              
            }
        }         
    }
    //Add Existing BA- Existing CAT Associations
    public PageReference Add(){
        List<sObject> insertList= new List<sObject>();
        for(ResultWrapper res:results){
            if(Test.isRunningTest()){
                res.selected = true;
            } 
            if(res.selected == true){
                GEMS_BA_Category_Assignment__c BAAssignment = new GEMS_BA_Category_Assignment__c(Account__c = res.ba.Account__c, Case__c = caseId, Benefit_Agreement__c = res.ba.id, isNew__c = true, Category__c = res.cat.id);
                insertList.add(BAAssignment);
            }
        }  
        if(!insertList.isEmpty()){
            string message = GEMS_AccountStructureOperationHelper.insertSObjects(insertList);
            if(message == 'Successfully Inserted'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'BA and CAT Assignments inserted successfully.');
                ApexPages.addMessage(myMsg);   
                showSelectedOperation();
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,message);
                ApexPages.addMessage(myMsg); 
            }
        } 
        return null;    
    }
    //Add Existing BA-CAT Association to the wrapper
    public void AddRow(){    
        List<GEMS_BA_Category_Assignment__c> BACat = GEMS_AccountStructureOperationHelper.getBACAT(enterBa,enterCAT,caseId);
        if(!BACat.isEmpty()){                  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Already this combination exist.Please enter some other existing category');
            ApexPages.addMessage(myMsg);  
        }
        //add it to the wrapper 
        else if(!resultSet.isEmpty() && resultSet.contains(BAList[0].name+'-'+ CATList[0].Name)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Already this combination has been added');
            ApexPages.addMessage(myMsg); 
            
        }
        else{         
            results.add(new ResultWrapper(BAList[0],CATList[0],null));
            resultSet.add(BAList[0].Name +'-'+ CATList[0].Name);
        }
    }
    
    public void RemoveRow(){
        for(Integer i = results.size() - 1; i >= 0; i--){ 
            if(Test.isRunningTest()){
                results[i].selected = true;
            }       
            if(results[i].selected == true){
                ResultWrapper res = results[i];
                results.remove(i);
                resultSet.remove(res.ba.Name +'-'+res.cat.Name);            
            }        
        }          
    }
    
    //Remove BA-CAT-GS-BP Association from draft account structure
    public PageReference remove(){
        //Assign removal of objects here using the wrapper        
        List<SObject> delList = new List<SObject>();
        List<GEMS_BA_Category_Assignment__c> bacats = new List<GEMS_BA_Category_Assignment__c>();
        for(integer i=0;i<results.size();i++){ 
            if(Test.isRunningTest()){
                results[i].selected = true;
            }
            if(results[i].selected == true){
                if(results[i].bacat.Id != null){      
                    delList.add(results[i].bacat);
                }
            }          
        }
        if(!delList.isEmpty()){
            string message = GEMS_AccountStructureOperationHelper.deleteSObjects(delList);
            if(message == 'Successfully Deleted'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'BA and CAT Assignments deleted successfully.');
                ApexPages.addMessage(myMsg);
                showSelectedOperation();
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,message);
                ApexPages.addMessage(myMsg);
            }
        }      
        return null;
    }
    
    //Redirect the page after operation
    public Pagereference ReloadPage(){
        Pagereference ref = new PageReference('/apex/GEMSAccountStructureOperation?caseId='+caseId);
        ref.setRedirect(true);
        return ref; 
    }
    
    //Remove existing BA - CAT from the result wrapper
    public void RemoveAddRow(){           
        //Get New BA-CAT association
        List<GEMS_BA_Category_Assignment__c>  BaCat = GEMS_AccountStructureOperationHelper.getNewBACAT(enterBA,enterCAT,caseId);                         
        if(BaCat.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This combination does not exist.Please try with some other combination');
            ApexPages.addMessage(myMsg); 
        }
        else{
            //add it to the wrapper 
            if(!resultSet.isEmpty() && resultSet.contains(BAList[0].name+'-'+ CATList[0].Name)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Already this combination has been added');
                ApexPages.addMessage(myMsg); 
                
            }
            else{         
                results.add(new ResultWrapper(BAList[0],CATList[0],BaCat[0]));
                resultSet.add(BAList[0].Name +'-'+ CATList[0].Name);
            }
        }             
    }
    
    //Create a wrapper to store th combination
    public class ResultWrapper{
        public GEMS_Benefit_Agreement__c ba{get;set;}
        public GEMS_Category__c cat{get;set;} 
        public GEMS_BA_Category_Assignment__c bacat{get;set;}
        public Boolean selected{get;set;} 
        
        public ResultWrapper(GEMS_Benefit_Agreement__c  baobj,GEMS_Category__c catobj,GEMS_BA_Category_Assignment__c bacatobj){
            ba = baobj;
            cat = catobj;
            bacat = bacatobj;
            selected = false;
        }
    }
    
    
    //Clear the List 
    public void showSelectedOperation(){ 
        if(BAList != null && !BAList.isEmpty()){
            BAList.clear();
        }  
        if(CATList != null && !CATList.isEmpty()){
            CATList.clear();
        }
        if(!String.isBlank(enterBA) || !String.isBlank(enterCAT)){
            enterBA = enterCAT='';
        }
        if(results != null && !results.isEmpty()){
            results.clear();
        }
        if(resultSet != null && !resultSet.isEmpty()){
            resultSet.clear();
        }
        ApexPages.getMessages().clear();
    }
    
    //Redirect To Create Account Struture Page
    public PageReference GoBackToAccountStructureCase(){
        PageReference ref = new PageReference('/apex/GEMSCreateAS?caseId='+caseId);
        ref.setRedirect(true);
        return ref;   
    }
    
    //Returns reserved groups
    public List<SelectOption> getGroups(){
        List<SelectOption> groupNumbers = new List<SelectOption>();  
        Case asCase = GEMS_AccountSetupHelper.getAccountStructureCaseDetails(caseId);
        groupNumbers = new GEMS_AccountSetupHelper().getGroupNumbers(asCase.GEMS_Reserved_Group_Numbers__c);
        return groupNumbers;
    }
    
    //Search GS and return BA-CAT-GS-BP to display in single line in the UI
    public void SearchGS() {
        String message = '';
        asw = null;
        if(String.isBlank(enterSN)|| !enterSN.isNumeric() || enterSN.length() > 4 || enterSN.length() < 4){
            message ='Please enter 4 digit section#';            
        } else {
            List<GEMS_Group_Section__c> gsAssociations = GEMS_AccountStructureOperationHelper.getGSAssociations(caseId,selectedGN,enterSN);
            if(gsAssociations.isEmpty()) {
                message = 'No records found with the GS';                
            } else if(gsAssociations[0].isNew__c) {
                message = 'Group section needs to be an existing one';                
            } else {
                List<GEMS_BA_Assignment__c> baGS = gsAssociations[0].GS_Assignments__r.isEmpty() ? null : gsAssociations[0].GS_Assignments__r;
                List<GEMS_Category_Assignment__c> catGS = gsAssociations[0].Category_Assignments__r.isEmpty() ? null :gsAssociations[0].Category_Assignments__r;
                if(baGS == null || catGS == null) {
                    if(baGS == null) {
                        message = 'No BA-GS found with the Existing GS, Is the GS active?'; 
                    } else if(catGS == null) {
                        message = 'No CAT-GS found with the Existing GS Is the GS active?';
                    }
                } else if(baGS.size() > 1) {
                    message = 'Multiple BA-GS found with the Existing GS'; 
                } else if(catGS.size() > 1) {
                    message = 'Multiple CAT-GS found with the Existing GS'; 
                } else {
                    //Transforming result to wrapper for display
                    String result = transformForDisplay(gsAssociations);
                    if(!String.isEmpty(result))
                        message = result;
                }
                
            }
        }
        if(!String.isEmpty(message)) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,message);
            ApexPages.addMessage(myMsg);       
        }
    }
    
    
    public String transformForDisplay(List<GEMS_Group_Section__c> gsAssociations) {
        String message = '';
        asw = new GEMSStructureWrapper();
        GEMS_BA_Assignment__c gsBA = gsAssociations[0].GS_Assignments__r;
        asw.gsbaId = gsBA.Id;
        asw.sourceBAId = gsBA.benefit_agreement__c;
        asw.baName = gsBA.benefit_agreement__r.name;
        sourceBAName = asw.baName;
        asw.baProduct = gsBA.benefit_agreement__r.Product__r.Name;
        asw.baDescription = gsBA.benefit_agreement__r.BA_Description__c;
        asw.baFundType = gsBA.benefit_agreement__r.BA_Fund_Type__c;
        GEMS_Category_Assignment__c gsCAT = gsAssociations[0].Category_Assignments__r;
        asw.gsCatId = gsCAT.id;
        asw.catId = gsCAT.category__c;
        asw.categoryName = gsCAT.Category__r.name;
        sourceCATName = asw.categoryName;
        asw.catDescription = gsCAT.Category__r.Category_Description__c;
        asw.categoryUsageBilling = gsCAT.Category__r.Usage_Billing__c;
        asw.categoryUsageReporting = gsCAT.Category__r.Usage_Reporting__c;
        asw.categoryUsageProduct = gsCAT.Category__r.Usage_Product__c;
        asw.categoryUsageMailing = gsCAT.Category__r.Usage_Mailing__c;
        asw.gsId = gsAssociations[0].id;
        asw.groupNumber = gsAssociations[0].Group_No__c;
        asw.sectionNumber = gsAssociations[0].Section_No__c;
        asw.sectionDesc = gsAssociations[0].Section_Description__c;
        asw.gsEffDate = gsAssociations[0].Section_Eff_Date__c;
        asw.gsAlphaPrefix = gsAssociations[0].Alpha_Prefix__c;
        asw.gsSpiCodes = gsAssociations[0].SPI_Codes__c;
        asw.gsParPlanCodes = gsAssociations[0].Par_Plan_Codes__c;    
        asw.gsIsUpdated = gsAssociations[0].isUpdated__c;
        if(!asw.gsIsUpdated) {
            asw.gsObj = gsAssociations[0];
        }
        if(asw.baFundType == 'PREM' && asw.categoryUsageBilling == true) {
            asw.needBPAssoc = true;
            //find billing profile
            List<GEMS_BP_BA_Association__c> bpbaAssociations = GEMS_AccountStructureOperationHelper.getBPBAAssociations(caseId,sourceBAName,sourceCATName);
            if(bpbaAssociations.isEmpty()) {
                message = 'BP not found with the GS';                
            } else if(bpbaAssociations.size() > 1) {
                message = 'Multiple BP-BA/BP-CAT associations found for BA-'+sourceBAName+' CAT-'+sourceCATName;
            } else {
                asw.bpbaId = bpbaAssociations[0].id;
                asw.bpName = bpbaAssociations[0].Billing_Profile__r.name;
                asw.bpid = bpbaAssociations[0].Billing_Profile__c;
                bp = asw.bpName;
                //asw.deleteSourceBABP = !bpbaAssociations.isEmpty() && bpbaAssociations.size() == 1?true:false;
                //System.debug('>>>>>> asw.deleteSourceBABP '+asw.deleteSourceBABP);
            } 
        } 
        if(!String.isBlank(message)) {
            asw=null;
            targetBA = null;
            enterTargetBA = null;
        }
        return message;
    }
    
    
    
    
    //search target BA records
    public void SearchTargetBA(){
        String message = '';
        List<GEMS_Benefit_Agreement__c> BATList = new List<GEMS_Benefit_Agreement__c>();
        if(String.isBlank(enterTargetBA) || !enterTargetBA.isNumeric() || enterTargetBA.length() > 4 || enterTargetBA.length() < 4){
            message = 'Please enter 4 digits Target BA#';            
        } else if(sourceBAName == enterTargetBA) {
            message = 'Source BA and Target BA are the same';            
        } else {
            BATList = GEMS_AccountStructureOperationHelper.getBAAssociations(enterTargetBA,sourceCATName,caseId);
            if(BATList.isEmpty()){
                message = 'No Target BA Record Exist';
            /*} else if(!BATList.isEmpty() && BATList[0].isNew__c){
                message = 'Target BA should not be New'; */
            } else {
                List<GEMS_BA_Category_Assignment__c> baCatList = BATList[0].BA_Category_Assignments__r;
                List<GEMS_BP_BA_Association__c> bpBAList = BATList[0].BA_Associations__r;
                if(!baCatList.isEmpty()){
                    message = 'CAT '+sourceCATName +' exists in target'; 
                } else {
                    String targetBAFundType = BATList[0].BA_Fund_Type__c;
                    if(asw.needBPAssoc != null && asw.needBPAssoc && (String.isEmpty(targetBAFundType) || targetBAFundType != 'PREM') ){
                        message = 'Target BA needs to have PREM fund type';
                    }  else {
                        //retrieve target BA-BP to check if exists        
                        List<GEMS_BP_BA_Association__c> bpbaTargetList = GEMS_AccountStructureOperationHelper.getBPBAAssociations(caseId,enterTargetBA,sourceCATName);      
                        asw.createTargetBABP  = bpbaTargetList.isEmpty()?true:false;
                        System.debug('>>>>>> asw.createTargetBABP '+asw.createTargetBABP);
                        targetBA = BATList[0];
                        asw.targetBAId = targetBA.id;
                        disableSubmitButton = false;                         
                    }
                }
            }
        }
        if(!String.isEmpty(message)) {
            BATList.clear();
            targetBA = null;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,message);
            ApexPages.addMessage(myMsg);       
        }
    }
    
    //Reset Search fields
    public void AddRemoveReset(){
        ApexPages.getMessages().clear();
        enterBA = enterCAT='';
        if(BAList!=null && !BAList.isEmpty()){
            BAList.clear();
        }
        if(CATList!=null && !CATList.isEmpty()){
            CATList.clear(); 
        }   
    }
    
    public void MoveReset(){
        ApexPages.getMessages().clear();
        sourceBAName = '';
        enterTargetBA = '';
        selectedGN = '';
        enterSN = '';
        sourceCATName = '';
        bp = null;
        asw = null;
        sourceBA = null;
        targetBA = null;
    }
    
    //move existing GS and CAT from sourceBA to targetBA
    public void move(){
        disableSubmitButton = true;
        getBACATBP();
        String message = '';
        //remove ba-cat,ba-gs,ba-bp,cat-bp
        Savepoint sp = Database.setSavepoint();
        List<sobject> deleteList = new List<sobject>();
        GEMS_BA_Category_Assignment__c baCat = new GEMS_BA_Category_Assignment__c();
        baCat.Id = asw.catBAId;
        //auto deletes BA-GS,GS-CAT
        deleteList.add(baCat);
        /* if(asw.needBPAssoc != null && asw.needBPAssoc && asw.deleteSourceBABP) {
            GEMS_BP_BA_Association__c bpBA = new GEMS_BP_BA_Association__c();
            bpBA.id = asw.bpbaId;
            deleteList.add(bpBA);
        } */
        message = GEMS_AccountStructureOperationHelper.deleteSObjects(deleteList);
        if(message != 'Successfully Deleted') {
            ApexPages.Message myMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Move Failed. Technical Info - '+message);
            ApexPages.addMessage(myMessage);    
            Database.rollback(sp);
        } else {
            List<sobject> insertList = new List<sobject>();
            List<sobject> updateList = new List<sobject>();
            //add ba-cat,ba-gs,ba-bp,cat-bp + gs isupdate to true
            GEMS_BA_Category_Assignment__c baCat1 = new GEMS_BA_Category_Assignment__c();
            baCat1.Benefit_Agreement__c = asw.targetBAId;
            baCat1.Category__c = asw.catId;
            baCat1.Case__c = caseId;
            baCat1.Account__c = asw.accountId;
            insertList.add(baCat1);
            
            GEMS_BA_Assignment__c baGS1 = new GEMS_BA_Assignment__c();
            baGS1.Benefit_Agreement__c = asw.targetBAId;
            baGS1.Group_Section__c = asw.gsId;
            baGS1.Case__c = caseId;
            baGS1.Account__c = asw.accountId;
            insertList.add(baGS1);
            
            if(asw.needBPAssoc != null && asw.needBPAssoc && asw.createTargetBABP != null && asw.createTargetBABP) {
                GEMS_BP_BA_Association__c bpBA1 = new GEMS_BP_BA_Association__c();
                bpBA1.Benefit_Agreement__c = asw.targetBAId;
                bpBA1.Billing_Profile__c = asw.bpId;
                bpBA1.Case__c = caseId;
                insertList.add(bpBA1);
                
                
            }
            
            if(asw.needBPAssoc != null && asw.needBPAssoc) {
            	GEMS_Billing_Profile__c updateBP = new GEMS_Billing_Profile__c();
                updateBP.id = asw.bpId;
                updateBP.IsUpdated__c = true;
                updateList.add(updateBP);
            }
            
            if(!asw.gsIsUpdated) {
                asw.gsObj.isUpdated__c = true;
                updateList.add(asw.gsObj);
            }
            
            GEMS_Category_Assignment__c catGs = new GEMS_Category_Assignment__c();
            catGS.Category__c = asw.catId;
            catGS.Group_Section__c = asw.gsId;
            catGS.Case__c = caseId;
            catGS.Account__c = asw.accountId;
            insertList.add(catGs);
            
            message = GEMS_AccountStructureOperationHelper.insertSObjects(insertList);
            if(message != 'Successfully Inserted') {
                ApexPages.Message myMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Move Failed. Technical Info - '+message);
                ApexPages.addMessage(myMessage);    
                Database.rollback(sp);
            } else {
               	message = GEMS_AccountStructureOperationHelper.updateSObjects(updateList);
              	if(message != 'Successfully Updated') {
                    ApexPages.Message myMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Move Failed. Technical Info - '+message);
                	ApexPages.addMessage(myMessage);    
                	Database.rollback(sp);
                } 
			}
            ApexPages.Message myMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM,'GS '+asw.groupNumber+'-'+asw.sectionNumber+' moved from BA '+sourceBAName+' to BA '+enterTargetBA);
            ApexPages.addMessage(myMessage);
            
        }
    }
    
    
    public void getBACATBP() {
        list<GEMS_Category__c> baCatBPList = [select id,Account__c,  (select id from Category_BA_Assignments__r where benefit_agreement__r.id = :asw.sourceBAId), 
                                              (select id from Category_Associations__r where billing_profile__r.id = :asw.bpId) 
                                              from gems_category__c where id = :asw.catId and case__c = :caseId];
        GEMS_Category__c cat = baCatBPList[0];
        List<GEMS_BA_Category_Assignment__c> catBA = cat.Category_BA_Assignments__r;
        List<GEMS_BP_Category_Association__c> catBP = cat.Category_Associations__r;
        asw.catBAId = catBA[0].id;
        asw.accountId = cat.Account__c;    
    }
    
    public class GEMSStructureWrapper {
        public Id gsbaId{get;set;}
        public Id sourceBAId{get;set;}
        public Id targetBAId{get;set;}
        public string baName{get;set;}
        public string baProduct{get;set;}
        public string baDescription{get;set;}
        public string baFundType{get;set;}
        public Id gsCatId{get;set;}
        public Id catBAId{get;set;}
        public Id catId{get;set;}
        public string categoryName{get; set;}
        public string catDescription{get; set;}
        public boolean categoryUsageBilling{get; set;}
        public boolean categoryUsageReporting{get; set;}
        public boolean categoryUsageProduct{get; set;}
        public boolean categoryUsageMailing{get; set;}
        public GEMS_Group_Section__c gsObj;
        public Id gsId{get;set;}
        public boolean gsIsUpdated{get;set;}
        public string groupNumber{get; set;}
        public string sectionNumber{get; set;}
        public string sectionDesc{get; set;}
        public date gsEffDate{get; set;}
        public string gsAlphaPrefix{get; set;}
        public string gsSpiCodes{get; set;}
        public string gsParPlanCodes{get; set;}
        public Id bpbaId{get;set;}
        public Id bpId{get;set;}
        public Id bpCatId{get;set;}
        public string bpName{get;set;}   
        public Id accountId{get;set;}
        public boolean createTargetBABP{get;set;}
        public boolean deleteSourceBABP{get;set;}
        public boolean needBPAssoc{get;set;}
    }
    
}