/********************************************************************************
 *
 * Copyright (C) 2016
 * Health Care Service Corporation (HCSC)
 * All Rights Reserved
 * 
 * File: GEMS_PharmacyScopeCodingController.cls
 
*********************************************************************************
 *  Ver     Date(MM/DD/YYYY)  Name              Description
 *  ---     ----------------  ---------------   ----------------------
 *  1.1     08/31/2016        Jalaj            Controller for GEMSPharmacyCoding VF Page:
 
                                                Whenever user clicks on Add/Edit on  Pharmacy Coding Case, 
                                                class is initiated for the following scenarios 
                                                - Retrieving all pharmacy Scope Code from the database for that Case
                                                - Addding New Scope Codes
                                                - Associating Scope Codes with BA leve Cases  
                                                - Performing Validations 
                                                - Associating temp scope codes with perm scope codes                                               
*   1.2     07/26/2017         Gokul            - SFDC-5100 -GEMS - Add "BA No" column to Pharmacy Scope Code save & assign page         
*   1.3	    02/20/2018	       Phani K			SFDC-4244 GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
*********************************************************************************/

public without sharing class GEMS_PharmacyScopeCodingController {

    public list<GEMS_PharmacyScopeCoding> listOfPCs {get; set;}
    public string saveResult {get; set;}
    
    public Id caseId {get; set;}
    public Id accountId;
    GEMS_PharmacyScopeCodingHelper helper = new GEMS_PharmacyScopeCodingHelper();
    
    public Integer numberOfRowToRemove {get; set;}
    public Id recordToDelete {get; set;}
    public boolean hasEditAccess{get;set;}
    public string rowCount{get;set;}
    public string pcRecordId{get;set;}
    public Map<Id, GEMS_Pharmacy_Scope_Code__c> mapOfIdAndPC;
    public GEMS_PharmacyScopeCoding PC;
    public list<GEMS_Pharmacy_Scope_Code__c> selectedPCs;
    public Id selectedPSCId {get; set;}
    public boolean disableNew {get; set;}
    public boolean PermTemp {get; set;}
    public List<BACaseWrapper> listOfBACases {get; set;}
    public Case ParentCase {get; set;}
    /********SFDC-5100*************/
    public Map<string,List<string>> ScopeBAMap;
    public Map<string,string> codeBAcolmn {get;set;}
    public Map<string,string> codeBAhover {get;set;}
    /********SFDC-5100*************/

    public GEMS_PharmacyScopeCodingController(ApexPages.StandardSetController controller) {
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        System.debug('CaseId====>'+caseId);        
        disableNew = false;
        //accountId = ApexPages.currentPage().getParameters().get('accountId');
        ParentCase = getParentCase();
        UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :caseId limit 1][0];
        if(userAccess.HasEditAccess){
            hasEditAccess= true;
            try{
                List<GEMS_Pharmacy_Scope_Code__c> existingPCs = getPCs();
                mapOfIdAndPC = new Map<Id, GEMS_Pharmacy_Scope_Code__c>(existingPCs);
                listOfPCs = new List<GEMS_PharmacyScopeCoding>();
                if(!existingPCs.isEmpty()){
                    //GEMS_Pharmacy_Scope_Code__c permPC;
                    //GEMS_Pharmacy_Scope_Code__c tempPC;
                    for(GEMS_Pharmacy_Scope_Code__c existingPC : existingPCs){
                        PC = new GEMS_PharmacyScopeCoding(false, existingPC);
                        listOfPCs.add(PC);
                        if(existingPC.Temp_Pharmacy_Scope_Codes__r != null && existingPC.Temp_Pharmacy_Scope_Codes__r.size() > 0){
                            PC = new GEMS_PharmacyScopeCoding(false, existingPC.Temp_Pharmacy_Scope_Codes__r[0]);
                            listOfPCs.add(PC);
                        }
                    }
                }else{
                    listOfPCs= new List<GEMS_PharmacyScopeCoding>();
                    PC = new GEMS_PharmacyScopeCoding(true, new GEMS_Pharmacy_Scope_Code__c(Case__c = caseId, Type__c = 'Permanent'));
                    listOfPCs.add(PC);
                    disableNew = true;
                    System.debug('New - ' + listOfPCs);
                }
                
                getBACases();
                
            }
            catch(Exception e){
                GEMS_CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'opportunity', null, 'GEMS_CaptureBenefitAgreementsController(ApexPages.StandardSetController controller)','High'); 
            }
        }else{
            hasEditAccess = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, system.label.InsufficientError)); 
        }
        
    }
   
    /*
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                     [SELECT Id, Name, Case__c, Temp__c, Type__c, Mail__c, Retail__c, Status__c,
                                      Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Related__c, Case__r.HCSC_Division__c, Peer_Review_Reject_Counter__c,
                                            Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c,
                                         
                               (SELECT Id, Name, Case__c, Temp__c, Type__c, Mail__c, Retail__c,
                                      Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Related__c, Case__r.HCSC_Division__c, Peer_Review_Reject_Counter__c,
                                            Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c, Related__r.id FROM Temp_Pharmacy_Scope_Codes__r)
                                                                   
                                                                        FROM GEMS_Pharmacy_Scope_Code__c
                                                                            WHERE Case__c = : caseId and Type__c = 'Permanent'
                                                                                ORDER BY CreatedDate ASC]));
            }
            return setCon;
        }
        set;
    }
    */
    
    public List<GEMS_Pharmacy_Scope_Code__c> getPCs() {
        return [SELECT Id, Name, Case__c, Temp__c, Type__c, Mail__c, Retail__c, Status__c,
                                      Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Related__c, Case__r.HCSC_Division__c, Peer_Review_Reject_Counter__c,
                                            Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c,
                                         
                               (SELECT Id, Name, Case__c, Temp__c, Type__c, Mail__c, Retail__c,
                                      Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Related__c, Case__r.HCSC_Division__c, Peer_Review_Reject_Counter__c,
                                            Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c, Related__r.id FROM Temp_Pharmacy_Scope_Codes__r)
                                                                   
                                                                        FROM GEMS_Pharmacy_Scope_Code__c
                                                                            WHERE Case__c = : caseId and Type__c = 'Permanent'
                                                                                ORDER BY CreatedDate ASC];
    }
    
        
    
    public Case getParentCase(){
    Case C = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                GEMS_Line_Of_Business__c,GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                    Account.AccountNumber, Account.External_ID__c, Account.Name
                         FROM Case WHERE id =: caseId];
    return C;
    }
    
    public PageReference removePC(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfPCs.remove(numberOfRowToRemove - 1);
            
            if(recordToDelete !=null && !mapOfIdAndPC.isEmpty()){
                if(mapOfIdAndPC.containsKey(recordToDelete)){
                    delete mapOfIdAndPC.get(recordToDelete);
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
            for(GEMS_PharmacyScopeCoding opw : listOfPCs){                
                ++recCount;
            }
        }catch(Exception e){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
        }
    }
    
    public PageReference removeRow(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfPCs.remove(numberOfRowToRemove - 1);
            if(recordToDelete !=null && !mapOfIdAndPC.isEmpty()){
                if(mapOfIdAndPC.containsKey(recordToDelete)){
                    delete mapOfIdAndPC.get(recordToDelete);
                }
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
        }
        return null;
    }

    public PageReference addPC(){
        for(GEMS_PharmacyScopeCoding  pc : listOfPCs){
                pc.isSelected = false;
        }
        PC = new GEMS_PharmacyScopeCoding(true, new GEMS_Pharmacy_Scope_Code__c(Case__c = caseId, Type__c = 'Permanent'));
        listOfPCs.add(PC);
        disableNew = true;
        return null;
    }
    
    public PageReference addTemp(){
    
        string selPSCName;
        boolean isNew = true;
        if (PermTemp != True){
            if(isNew){
                PC = new GEMS_PharmacyScopeCoding(true, new GEMS_Pharmacy_Scope_Code__c(Case__c = caseId, Type__c = 'Temp', Temp__c = false));
                listOfPCs.add(PC);
                disableNew = true;
            }
        }
        else {
        Integer firstIndex;
        Integer secIndex;
        Integer i = 0;
        for(GEMS_PharmacyScopeCoding PCWrapper : listOfPCs){            
            if(PCWrapper.isSelected == true){
                if(firstIndex != null)
                    secIndex = i;
                else
                    firstIndex = i;
            }
            i = i + 1;
        } 
        
            listOfPCs.remove(secIndex);
        }
        return null;
    }
    

    public PageReference HideTempPC(){
        Integer firstIndex;
        Integer secIndex;
        Integer i = 0;
        for(GEMS_PharmacyScopeCoding PCWrapper : listOfPCs){            
            if(PCWrapper.isSelected == true){
                if(firstIndex != null)
                    secIndex = i;
                else if(PCWrapper.ScopeCode.Scope_Status__c == 'No Scope Code Changes' || PCWrapper.ScopeCode.Scope_Status__c == 'Scope Change Only - NoBETSub')
                    firstIndex = i;
            }
            i = i + 1;
        } 
        
        if (firstIndex != Null)
            listofPCs[firstIndex].ScopeCode.Temp__c = false;
            
        if (secIndex != Null)
                listOfPCs.remove(secIndex);
        
        return null;
    }
    
    public PageReference deletePC(){
        selectedPCs = new List<GEMS_Pharmacy_Scope_Code__c>();
        List<Case> relatedBACases = new List<Case>();
        Integer firstIndex;
        Integer secIndex;
        Integer i = 0;
        for(GEMS_PharmacyScopeCoding PCWrapper : listOfPCs){            
            if(PCWrapper.isSelected == true){
                selectedPCs.add(PCWrapper.scopeCode);
                if(firstIndex != null)
                    secIndex = i;
                else
                    firstIndex = i;
            }
            i = i + 1;
        } 
        
        if(selectedPCs != null && selectedPCs[0].id != null)
             relatedBACases = [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                        GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, GEMS_Pharmacy_Group_Pay_Code__c, GEMS_Pharmacy_Temp_Group_Pay_Code__c,
                            GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c
                                FROM Case WHERE Parent.Id =: selectedPCs[0].Case__c AND Status != 'Routed In Error' AND GEMS_Pharmacy_Scope_Code__c =: selectedPCs[0].Name];
            if(relatedBACases != Null){
                for (Case C: relatedBACases){
                    C.GEMS_Pharmacy_Scope_Code__c = '';
                    C.GEMS_Temp_Scope_Code__c = '';
                    C.GEMS_Pharmacy_Temp_Group_Pay_Code__c = '';
                    C.GEMS_Pharmacy_Group_Pay_Code__c = ''; 
                    C.GEMS_Scope_Code_ID__c = '';
                    C.GEMS_Pharmacy_Scope_Code_Info__c = '';      
                }
            }
            update relatedBACases;
            delete selectedPCs;
        
        if(firstIndex != null)
            listOfPCs.remove(firstIndex);
        //if(secIndex != null)
          //  listOfPCs.remove(secIndex);
        
        disableNew = false;
        

        return null;
    }
    
    public PageReference savePCs() {
        selectedPCs = new List<GEMS_Pharmacy_Scope_Code__c>();
        list<Case> selectedCases = new List<Case>();
        string permScopeCode;
        string tempScopeCode;
        string PermGroupCode;
        String TempGroupCode;
        String PermStatus;
        String permScopeCodeID;
        boolean isTemp = false;
        boolean isNew = false;
        GEMS_Pharmacy_Scope_Code__c perm;
        GEMS_Pharmacy_Scope_Code__c temp;
        try{
            for(GEMS_PharmacyScopeCoding PCWrapper : listOfPCs){
                if(PCWrapper.isSelected == true){
                    if(PCWrapper.scopeCode.Type__c == 'Permanent'){
                       permScopeCode = PCWrapper.scopeCode.Name;
                       PermGroupCode = PCWrapper.scopeCode.Group_Pay_Code__c;
                       permScopeCodeID = PCWrapper.scopeCode.Id;
                       if (PCWrapper.scopeCode.Status__c == '' || PCWrapper.scopeCode.Status__c == Null){
                           PermStatus = 'In Progress';
                       }
                       else {
                           PermStatus = PCWrapper.scopeCode.Status__c;
                       }
                       if(PCWrapper.scopeCode.id == Null){
                           isNew = true;
                           perm = new GEMS_Pharmacy_Scope_Code__c();
                           perm = PCWrapper.scopeCode;
                       }
                    }
                    else if(PCWrapper.scopeCode.Type__c == 'Temp'){
                       PCWrapper.scopeCode.Temp__c = false;
                       tempScopeCode = PCWrapper.scopeCode.Name;
                       TempGroupCode = PCWrapper.scopeCode.Group_Pay_Code__c;
                       isTemp = true;
                       if(PCWrapper.scopeCode.id == null){
                           isNew = true;
                           temp = new GEMS_Pharmacy_Scope_Code__c();
                           temp = PCWrapper.scopeCode;
                       }
                     }
                    selectedPCs.add(PCWrapper.scopeCode);
                }                   
                
            } 
            
            if(permScopeCode == null || (isTemp && tempScopeCode == null)){  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Scope Code(s).'));
                    return null;
            }
            
            String recs = 'recs=';
            if(!selectedPCs.isEmpty()){
                if(selectedPCs.size() > 2){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Permanent and a Temp (if available) Scope Code for save and assign.'));
                    return null;
                }
                else{
                    
                       for(BACaseWrapper baCaseWrapper : listOfBACases){
                            if(baCaseWrapper.isSelected == true){
                                /*
                                baCaseWrapper.baCase.GEMS_Pharmacy_Scope_Code__c = permScopeCode;
                                baCaseWrapper.baCase.GEMS_Temp_Scope_Code__c = tempScopeCode;
                                baCaseWrapper.baCase.GEMS_Pharmacy_Group_Pay_Code__c = permGroupCode;
                                baCaseWrapper.baCase.GEMS_Pharmacy_Temp_Group_Pay_Code__c = tempGroupCode;
                                baCaseWrapper.baCase.Status = PermStatus;
                                */                             
                                selectedCases.add(baCaseWrapper.baCase);
                                
                                if(baCaseWrapper.baCase.id == null)
                                    disableNew = false;
                            }
                        }
                        
                        if(isNew){
                            insert perm;
                            permScopeCodeID = perm.Id;
                            if(temp != null){
                                temp.Related__c = perm.id;
                                temp.Prime_Plan_Id__c = perm.Prime_Plan_Id__c;
                                temp.Scope_Status__c = perm.Scope_Status__c;
                                insert temp;
                            }
                        }
                        else                                          
                            upsert selectedPCs;
                        if(selectedCases != null && selectedCases.size() > 0)
                        for(Case C : SelectedCases){
                                C.GEMS_Pharmacy_Scope_Code__c = permScopeCode;
                                C.GEMS_Temp_Scope_Code__c = tempScopeCode;
                                C.GEMS_Pharmacy_Group_Pay_Code__c = permGroupCode;
                                C.GEMS_Pharmacy_Temp_Group_Pay_Code__c = tempGroupCode;
                                C.GEMS_Scope_Code_ID__c = permScopeCodeID;
                                c.GEMS_Pharmacy_Scope_Code_Info__c = permScopeCodeID;
                                C.Status = PermStatus;
                          }
                            upsert selectedCases;
                            
                        getBACases();
                        disableNew = false;
                        return null;
                }
                
                return null;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Scope Code'));
                return null;
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High');
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    public PageReference setSelected(){
        
        for(GEMS_PharmacyScopeCoding  pc : listOfPCs){
            system.debug('selectedPSCId :' + selectedPSCId);
            if(selectedPSCId == null){
                 if(pc.scopeCode.id == null)
                    pc.isSelected = true;
            }
            else{
            
                if(pc.scopeCode.id == selectedPSCId || pc.scopeCode.Related__c == selectedPSCId)
                    pc.isSelected = true;
                else
                    pc.isSelected = false;
               
            }
            
        }
        
        return null;
    }
    
    public PageReference gotoCase() {
        return new PageReference('/'+caseId);
    }
    
    public List<BACaseWrapper> getBACases() {
        //SFDC-4244 - Added GEMS_BAs_SpHandling__c condition
        List<Case> existingCaseValues = [SELECT Id, Status, CaseNumber, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Pharmacy_Group_Pay_Code__c, GEMS_Pharmacy_Temp_Group_Pay_Code__c, GEMS_Benefit_Agreement__r.Name, GEMS_Benefit_Agreement__r.Product_Type__c,
                    GEMS_Benefit_Agreement__r.Product_Name__c, GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c
                            FROM Case
                                WHERE GEMS_Benefit_Agreement__r.GEMS_BAs_SpHandling__c = true and Parent.id = : caseId AND Status != 'Routed In Error' and GEMS_Benefit_Agreement__c!=NULL];
                                
        listOfBACases = new List<BACaseWrapper>();                    
        
        if(existingCaseValues != null && existingCaseValues.size() > 0){
            
            if(!existingCaseValues.isEmpty()){
                /********SFDC-5100*************/ 
                //Map have been used to store the column and hover message as a value and key as a pharmacy code name
                ScopeBAMap=new Map<string,List<String>>();
                codeBAcolmn=new Map<string,string>();
                codeBAhover=new Map<string,string>();
                /********SFDC-5100*************/
                for(Case existingCaseValue : existingCaseValues){
                    BACaseWrapper baCase = new BACaseWrapper(false, existingCaseValue);
                    listOfBACases.add(baCase);
                /********SFDC-5100*************/
                    if(!(String.isEmpty(existingCaseValue.GEMS_Pharmacy_Scope_Code__c))){
                        if(ScopeBAMap.containsKey(existingCaseValue.GEMS_Pharmacy_Scope_Code__c)){
                           List<String> BACases=ScopeBAMap.get(existingCaseValue.GEMS_Pharmacy_Scope_Code__c);
                           BACases.add(existingCaseValue.GEMS_Benefit_Agreement__r.Name);
                           ScopeBAMap.put(existingCaseValue.GEMS_Pharmacy_Scope_Code__c,BACases);
                        }
                        else{
                           List<String> BACases=new List<String>();
                           BACases.add(existingCaseValue.GEMS_Benefit_Agreement__r.Name);
                           ScopeBAMap.put(existingCaseValue.GEMS_Pharmacy_Scope_Code__c,BACases); 
                        }   
                    }
                  }
                /********SFDC-5100*************/
                }
            }
            /*************SFDC-5100***************/
              if( ScopeBAMap != null && !ScopeBAMap.isEmpty()){
                for(string key:ScopeBAMap.keySet()){
                    List<string> strlist=ScopeBAMap.get(key)!=null?ScopeBAMap.get(key):null;
                    List<string> templist=strlist.clone();
                    if(!templist.isEmpty()){
                        if(templist.size() > 0){
                            codeBAcolmn.put(key,strlist[0]);
                        }
                        if(templist.size() > 1 ){
                            codeBAcolmn.put(key,strlist[0]+','+strlist[1]);
                        }
                        if(templist.size() > 2 && templist.size() < 6){
                            strlist.remove(0);
                            strlist.remove(0);
                            codeBAhover.put(key,string.join(strlist,','));
                        }  
                        if(templist.size() > 5){
                            strlist.remove(0);
                            strlist.remove(0);
                            string value=strlist[0]+','+strlist[1]+','+strlist[2]+','+strlist[3];
                            if(templist.size() > 6){
                                value+='(+'+string.ValueOf(templist.size()-6)+')';
                            }
                            codeBAhover.put(key,value);
                        } 
                    }  
                  }
              }   
            /*************SFDC-5100***************/
        return listOfBACases;
    }
    
    public class BACaseWrapper {
        public boolean isSelected {get; set;}
        public Case baCase {get; set;}
        public BACaseWrapper (boolean isSelected, Case baCase){
            this.isSelected = isSelected;
            this.baCase= baCase;
        }
    }

    public void validateMandatory(){
    
         for(GEMS_PharmacyScopeCoding PCWrapper : listOfPCs){
                if(PCWrapper.isSelected == true){
                    if(PCWrapper.scopeCode.Type__c == 'Permanent'){
                        if(ParentCase.HCSC_Division__c == 'IL' || ParentCase.HCSC_Division__c == 'NM') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'IL & NM'));
                        }
                        
                        else if (ParentCase.HCSC_Division__c == 'MT'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'MT'));
                        }
                        
                        else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'OK & TX'));
                        }
                    }
                }
         }
         
    }
}