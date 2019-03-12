/********************************************************************************

 *
 * Copyright (C) 2016
 * Health Care Service Corporation (HCSC)
 * All Rights Reserved
 * 
 * File: GEMSCaptureBAsController.cls

*********************************************************************************
 *  Ver     Date(MM/DD/YYYY)  Name              Description
 *  ---     ----------------  ---------------   ----------------------
 *  1.1     08/31/2016        Vijay             Controller for GEMSCaptureBA VF Page:
 
                                                Whenever user clicks on Add/Edit button on Account Structure Case, 
                                                class is initiated for the following scenarios 
                                                - Retrieving Benefit Agreements from the database 
                                                - Add BA 
                                                - Cancelling BA
                                                - Deleting a New BA    
                                                - Performing Validations 
*  1.2     07/11/2017        Ketki J            SFDC-3641 - Changes made in GEMSCaptureBA VF Page to 
                                                enable BA description field for Account struture for 
                                                type renewal or offcycle

*  1.3     07/17/2017        Shankar            SFDC-5071 - Changes to validate if associated BA Product (plan) has a product code
*  1.4     02/17/2018        Malathi            SFDC-4243 - Made changes for Special Handling.
*			4/30/2018	   	 Luke Chen			SFDC-6942 GEMS: Acct Structure - Move Billing Association to the Group Section level in the "Create Account Structure" view.
*  1.6     05/29/2018		 Malathi.K			SFDC-9952 Add Product Code Field to Account Structure Export and VF.
*********************************************************************************/


public class GEMSCaptureBAsController {

    public Id caseId;
    public Id accountId;
    public List<BAWrapper> listOfBAs {get; set;}
    public Integer numberOfRowToRemove {get; set;}
    public Id recordToDelete {get; set;}
    public Id recordToCancel {get;set;}
    public boolean hasEditAccess{get;set;}
    public string rowCount{get;set;}
    public string BARecordId{get;set;}
    public Date cancelDate {get;set;}
    public Date effectiveDate ;
    public Integer FinalCountOfBAs {get;set;}
    public Map<Id, GEMS_Benefit_Agreement__c> mapOfIdAndBA;
    public BAWrapper BA;
    public List<GEMS_Benefit_Agreement__c> selectedBAs;
   
    
   
    
    public string rowId{get;set;}

    /*Loading existing data for renewal Account structure case */
    public GEMSCaptureBAsController (ApexPages.StandardSetController controller) {
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :caseId limit 1][0];
        if(userAccess.HasEditAccess){
            hasEditAccess= true;
            try{
                List<GEMS_Benefit_Agreement__c> existingBAs = getBAs();
                System.debug('existingBAs::'+existingBAs);
                mapOfIdAndBA = new Map<Id, GEMS_Benefit_Agreement__c>(existingBAs);
                listOfBAs = new List<BAWrapper>();
                if(!existingBAs.isEmpty()){
                    GEMS_Benefit_Agreement__c tempBA;
                       String subType = ParCase.GEMS_Submission_Type__c ;
                    for(GEMS_Benefit_Agreement__c existingBA : existingBAs){
                            BA = new BAWrapper(false, existingBA);
                            listOfBAs.add(BA);                       
                    }
                }else{
                    listOfBAs= new List<BAWrapper>();
                    //BA = new BAWrapper(true, new GEMS_Benefit_Agreement__c(Account__c = accountId, AccountStructureCase__c = caseId));
                    effectiveDate = ParCase.GEMS_Case_Effective_Date__c ;
                    BA = new BAWrapper(false, new GEMS_Benefit_Agreement__c(Account__c = accountId,IsNew__c = true, AccountStructureCase__c = caseId, Effective_Date__c = effectiveDate ));
                     listOfBAs.add(BA);
                    System.debug('New - ' + listOfBAs);
                    
                 
                }
                

            }
            catch(Exception e){
                GEMS_CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'opportunity', null, 'GEMS_CaptureBenefitAgreementsController(ApexPages.StandardSetController controller)','High'); 
            }
        }else{
            hasEditAccess = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, system.label.InsufficientError)); 
        }
        
    }
    
   
   //SFDC-4243 Retrieve the special handling field from case
    public Case ParCase {
    get{
    
    return     [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c,
                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                    Account.AccountNumber, Account.External_ID__c, Account.Name, GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c, GEMS_Account_Submission_Info__r.GEMS_Number_of_Benefit_Agreements__c,GEMS_Special_Handling__c
                         FROM Case WHERE id =: caseId AND AccountId =: accountId];
                         }
                         
    set;
    }
    
        public Integer renderMe{
    get{
     String[] tmpString = ParCase.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c.split(';'); 
     Integer renderMe = 2;                  
     for(String Val : tmpString){
         if (Val == 'ASO'){
             renderMe =  1;
         }
         else if (Val == 'Premium'){
             renderMe = 0;
         }
     }
     return renderMe;
    }
    set;}
   
    // Delete Link Functionality for new Records
    public PageReference removeBA(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfBAs.remove(numberOfRowToRemove - 1);
            
            if(recordToDelete !=null && !mapOfIdAndBA.isEmpty()){
                if(mapOfIdAndBA.containsKey(recordToDelete)){
                    delete mapOfIdAndBA.get(recordToDelete);
                }
            }
            
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
        }
        return null;
    }
    public void getTheUpdatedMembersCount(){
        try{
            decimal recCount = 1;
            for(BAWrapper opw : listOfBAs){                
                ++recCount;
            }
        }catch(Exception e){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
        }
    }
    
    // Delete Button Functionality
    public PageReference removeRow(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfBAs.remove(numberOfRowToRemove - 1);
            if(recordToDelete !=null && !mapOfIdAndBA.isEmpty()){
                if(mapOfIdAndBA.containsKey(recordToDelete)){
                    delete mapOfIdAndBA.get(recordToDelete);
                }
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
        }
        return null;
    }
   
      
   // Pulling all the related Benefit Agreement Records for that Case
   //SFDC-4243 Retrieve the special handling field from the Benefit Agreement.
   //SFDC-9952 Retrieve Product Code
    public List<GEMS_Benefit_Agreement__c> getBAs() {
       
        return (List<GEMS_Benefit_Agreement__c>) ([SELECT Id, Name, Account__c,Has_Group_Sections__c,BA_Description__c, BA_Fund_Type__c, Product__c,Schedule__c, Plan__c,
                    ID_Card_Type__c, Billing_Profile__c, Billing_Assoc__c,Effective_Date__c ,Cancel_Date__c,IsNew__c,IsCancelled__c,Product_Name__c,Product_Type__c,GEMS_BAs_SpHandling__c,
                    AccountStructureCase__r.HCSC_Division__c, Product__r.Name,Product__r.ProductCode
                     FROM GEMS_Benefit_Agreement__c
                     WHERE AccountStructureCase__c = : caseId
                     ORDER BY Name ASC]);
    }
    
    // Add BA functionality
    public PageReference addBA(){
        effectiveDate = ParCase.GEMS_Case_Effective_Date__c ;
        BA = new BAWrapper(false, new GEMS_Benefit_Agreement__c(Account__c = accountId,IsNew__c = true, AccountStructureCase__c = caseId, Effective_Date__c = effectiveDate ));
        listOfBAs.add(BA);
        
        return null;
    }
    
    // Performing validation and checks before assigning a BA to Categories
    public PageReference assignBAs() {
        selectedBAs = new List<GEMS_Benefit_Agreement__c>();
        List<GEMS_Benefit_Agreement__c> baSaveCheck = new List<GEMS_Benefit_Agreement__c>();
        Map<Id,BAWrapper> idBAWrapperMap = new Map<Id,BAWrapper>();
        try{
            for(BAWrapper BAWrapper : listOfBAs){
                if(BAWrapper .isSelected == true) {
                    // SFDC-5071. Error out if BAs added via Opportunity products have no Plan
                    // Empty plan check is sufficient as user cannot add plan information in Opp Products screen
                    // Once user selects Plan in Add/Edit BA page subsequent validtion on product code will be done
                    System.debug('BAWrapper.BA.IsNew__c:'+BAWrapper.BA.IsNew__c);
                    System.debug('BAWrapper.BA.Plan__c:'+BAWrapper.BA.Plan__c);
                    if (BAWrapper.BA.IsNew__c && BAWrapper.BA.Plan__c == null) {
                        BAWrapper.prodTypeErr = Label.AddBAControllerBAWithoutPlanError;                        
                        return null;
                    }
                    selectedBAs.add(BAWrapper.BA);
                    idBAWrapperMap.put(BAWrapper.BA.id, BAWrapper);
                    
                    
                    //TODO : Need to add duplicate check
                   
                }
            }
            String recs = 'recs=';
            if(!selectedBAs.isEmpty()){
               
                Integer count = selectedBAs.size();
                system.debug('====selectedba'+selectedBAs[0].id);
                baSaveCheck = [select id,Name,IsNew__c, Plan__c from GEMS_Benefit_Agreement__c where id=: selectedBAs[0].Id] ;
                if(baSaveCheck.size() < 1){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save BA'));
                    return null ;
                }
                
                // SFDC-5071 Check if new BA's plan field is empty. Error out if that
                // BA is selected for Category assignment
                if (baSaveCheck[0].IsNew__c && baSaveCheck[0].Plan__c == null) {
                      BAWrapper baw = idBAWrapperMap.get(baSaveCheck[0].id);
                        baw.prodTypeErr = Label.AddBAControllerBAWithoutPlanError;                        
                        return null;
                    }
                recs = recs + selectedBAs[0].Id;
                system.debug('recs test'+recs);
                Integer i = 1;
                while(i < count){
                    recs = recs + '%2C' + selectedBAs[i].id;
                    i = i +1;
                }
                   if(selectedBAs.size()>1 ){
                    
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select  one BA'));
                        return null ;
                    }
                    else{
                    return new PageReference( '/apex/GEMSBACatAssign?' + recs);
                
                   }
                
                }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one BA'));
                return null;
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High');
            ApexPages.addMessages(ex);
            return null;
        }
    }        
    
    
    public PageReference gotoCase() {
        //return new PageReference('/GEMSAccountStructure?Id=' + caseId);
        return new PageReference('/'+caseId);
    }
    
      
    
    public class BAWrapper {
        public boolean isSelected {get; set;}
        public GEMS_Benefit_Agreement__c BA {get; set;}
        public boolean showCancel{get;set;}
        //SFDC-5071 - Field to hold product type error for BA
        public string prodTypeErr{get;set;}
        
        public BAWrapper (boolean isSelected, GEMS_Benefit_Agreement__c BA){
            this.isSelected = isSelected;
            this.BA = BA;
            
        }
        
    }
    
    public PageReference cancelRecord(){
        String para = Apexpages.currentPage().getParameters().get('RN');
       
        String para2 = Apexpages.currentPage().getParameters().get('RecordCan');
        String para4 = Apexpages.currentPage().getParameters().get('dDate');
        Integer para3 =  Integer.valueOf(para);
       
        
       String[] dts = para4.split('/');
         cancelDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
        
       
        
        try{
            List<GEMS_Benefit_Agreement__c> a = new List<GEMS_Benefit_Agreement__c>();
            
           
            if(para2 !=null && !mapOfIdAndBA.isEmpty()){
                if(mapOfIdAndBA.containsKey(para2)){
                    
                    a = [SELECT Id, IsCancelled__c,Cancel_Date__c,GEMS_BAs_SpHandling__c,
                            (SELECT Id, Group_Section__c, Group_Section__r.id, 
                                Group_Section__r.IsUpdated__c, Group_Section__r.IsCancelled__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c          
                            FROM BA_Assignments__r),
                        
                            (SELECT Id, Billing_Profile__c, Billing_Profile__r.id, 
                                Billing_Profile__r.IsUpdated__c, Billing_Profile__r.Effective_Date__c
                            FROM BA_Associations__r)
                        
                                FROM GEMS_Benefit_Agreement__c
                                WHERE id = : para2];
                    
                    a[0].IsCancelled__c = true ;
                    system.debug('I am Here U found me'+cancelDate) ;
                    
                    
                   a[0].Cancel_Date__c = cancelDate;
                   a[0].GEMS_BAs_SpHandling__c = false;
                      update a[0] ;                      
                }
            }
            
        }
        catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
        } 
        return new PageReference('/apex/GEMSCaptureBAs?caseId=' + caseId + '&accountId=' + accountId);
        
    }
    
    public PageReference saveBAs() {

     CalculateFinalCountBAs(listOfBAs);           
     Savepoint sp  ;
        selectedBAs = new List<GEMS_Benefit_Agreement__c>();
        
        Integer countBA = 0;
        Set<Id> planIds = new Set<Id>();
       Boolean hasErr = false;
        System.debug('listOfBAs::'+listOfBAs);
        for(BAWrapper baw : listOfBAs){
            countBA = countBA + 1;                    
            if(!baw.BA.isCancelled__c && baw.BA.Cancel_Date__c != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please remove the Cancel Date for the active BAs'));
                return null;                    
            }
            // SFDC-5071 - Error out if:
            // 1. Plan (Product Type) is blank 
            // 2. Plan has no product associated
            // 3. Plan's associated product has no product code
            System.debug('baw.BA.Plan__c:: '+baw.BA.Plan__c);
            if (baw.BA.IsNew__c && null == baw.BA.Plan__c) {
                baw.prodTypeErr = Label.AddBAControllerBAWithoutPlanError;
                hasErr = true;              
            } else {
                baw.prodTypeErr = null;
                selectedBAs.add(baw.BA);
                if (baw.BA.isNew__c) {
                  // Collect plan-ids for later validation
                  planIds.add(baw.BA.Plan__c);
                }
            }
        }   

        System.debug('selectedBAs::'+selectedBAs);
        String recs = 'recs=';
        
        // Get list of Plans associated with new BA's which has no product assigned or productcode is empty
        for(Plan__c p: [Select ProductCode__c from Plan__c where Id=:planIds]) {
            if (p.ProductCode__c != null) {
                // Retain only invalid Plans (Plans without Product or associated product has no ProductCode)
                planIds.remove(p.Id);
            }
        }
        for(BAWrapper baw: listOfBAs) {
            // Check if BA line item is mapped to an invalid plan
            if (baw.BA.isNew__c && planIds.contains(baw.BA.Plan__c)) {
                baw.prodTypeErr = Label.AddBAControllerPlansWithoutProdCodeError;
                hasErr = true;
            } else if (baw.BA.isNew__c && baw.prodTypeErr == null) {
                baw.prodTypeErr = null;
            }
        }
        try{          
            if(!selectedBAs.isEmpty() && !hasErr){                
                system.debug('===selectedbaname'+selectedBAs);
                try{
                    sp = Database.setSavepoint();
                    update getGroupSectionToUpdate(selectedBAs); // SFDC-6942
                    upsert selectedBAs;  
                }
               catch(Exception ex){
                        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMSCaptureBAsController.saveBAs()','High');
                        Database.rollback(sp);
                        ApexPages.addMessages(ex);
                }
                return null;
            }
            return null;
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High');
            Database.rollback(sp);
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    
    public Void CalculateFinalCountBAs(List<BAWrapper> FinalListOfBAs){
        List<Case> ParentAccSubCases = [SELECT Id, GEMS_Number_of_Benefit_Agreements__c FROM Case WHERE id =: ParCase.GEMS_Account_Submission_Info__c AND AccountId =: accountId];
        Integer Count = 0;
        
        
                     
        If(FinalListOfBAs != Null){
            //for (BAWrapper BA : FinalListOfBAs){
            //    Count = Count +1;
            //}
            Count = FinalListOfBAs.size();
        }
        
        if(ParentAccSubCases.size() > 0){
            Case ParentAccSubCase = ParentAccSubCases[0];
            ParentAccSubCase.GEMS_Number_of_Benefit_Agreements__c = Count;
            update ParentAccSubCase;
        }
   
    }
    
    // SFDC-6942
    // Populate BA's Billing Association to its Group-Section
    public List<GEMS_Group_Section__c> getGroupSectionToUpdate(List<GEMS_Benefit_Agreement__c> selectedBAs){
    	List<GEMS_Group_Section__c> gsList = new List<GEMS_Group_Section__c>();
    	Map<id, GEMS_Benefit_Agreement__c> baBeforeMap = new map<Id, GEMS_Benefit_Agreement__c>([SELECT Id, Billing_Assoc__c, (SELECT Id, Group_Section__r.id, Group_Section__r.Billing_Assoc__c FROM BA_Assignments__r) FROM GEMS_Benefit_Agreement__c WHERE AccountStructureCase__c = : caseId]);
    	for(GEMS_Benefit_Agreement__c baAfter : selectedBAs){
    		if(baAfter.id == null) continue; // new BA, not in system yet, skip because it has no group-sections yet
    		GEMS_Benefit_Agreement__c baBefore = baBeforeMap.get(baAfter.id);
    		// BA's Billing Association is modified, populate to its G-S
    		if(baAfter.Billing_Assoc__c != baBefore.Billing_Assoc__c) if(baBefore.BA_Assignments__r != null && !baBefore.BA_Assignments__r.isEmpty()) for(GEMS_BA_Assignment__c ba2Gs : baBefore.BA_Assignments__r) gsList.add(new GEMS_Group_Section__c(id=ba2Gs.Group_Section__r.id, Billing_Assoc__c=baAfter.Billing_Assoc__c));
    	}
    	return gsList;
    }
    
    
}