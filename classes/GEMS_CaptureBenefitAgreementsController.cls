public class GEMS_CaptureBenefitAgreementsController {


    public Id caseId;
    public Id accountId;
    public List<BAWrapper> listOfBAs {get; set;}
    public Integer numberOfRowToRemove {get; set;}
    public Id recordToDelete {get; set;}
    public boolean hasEditAccess{get;set;}
    public string rowCount{get;set;}
    public string BARecordId{get;set;}
    public Map<Id, GEMS_Benefit_Agreement__c> mapOfIdAndBA;
    public BAWrapper BA;
    public List<GEMS_Benefit_Agreement__c> selectedBAs;
    public GEMS_CaptureBenefitAgreementsController(ApexPages.StandardSetController controller) {
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :caseId limit 1][0];
        if(userAccess.HasEditAccess){
            hasEditAccess= true;
            try{
                List<GEMS_Benefit_Agreement__c> existingBAs = getBAs();
                mapOfIdAndBA = new Map<Id, GEMS_Benefit_Agreement__c>(existingBAs);
                listOfBAs = new List<BAWrapper>();
                if(!existingBAs.isEmpty()){
                    GEMS_Benefit_Agreement__c tempBA;
                    for(GEMS_Benefit_Agreement__c existingBA : existingBAs){
                        BA = new BAWrapper(true, existingBA);
                        listOfBAs.add(BA);
                    }
                }else{
                    listOfBAs= new List<BAWrapper>();
                    BA = new BAWrapper(true, new GEMS_Benefit_Agreement__c(Account__c = accountId, AccountStructureCase__c = caseId));
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
    
    /*
    public Case getParentCase(){
    Case C = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                    Account.AccountNumber, Account.External_ID__c, Account.Name, GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c
                         FROM Case WHERE id =: caseId AND AccountId =: accountId];
      
     String[] tmpString = C.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c.split(';');                   
     for(String Val : tmpString){
         if (Val == 'ASO'){
             renderMe = 1;
         }
         else if (Val == 'Premium'){
             renderMe = 0;
         }
         else {
             renderMe = 2;
         }
     }
    return C;
    }
    
    */
    
    public Case ParCase {
    get{
    return     [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                    Account.AccountNumber, Account.External_ID__c, Account.Name, GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c
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
    /*
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name, Account__c, BA_Description__c, BA_Fund_Type__c,Effective_Date__c, Product__c,Cancel_Date__c,Schedule__c, Plan__c,
                    ID_Card_Type__c, Billing_Profile__c, Billing_Assoc__c,
                    AccountStructureCase__r.HCSC_Division__c
                     FROM GEMS_Benefit_Agreement__c
                     WHERE AccountStructureCase__c = : caseId
                     ORDER BY Name ASC]));
            }
            setCon.setPageSize(500);
            return setCon;
        }
        set;
    }
    */
    
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
    public List<GEMS_Benefit_Agreement__c> getBAs() {
        //return (List<GEMS_Benefit_Agreement__c>) setCon.getRecords();
        return (List<GEMS_Benefit_Agreement__c>) ([SELECT Id, Name, Account__c, BA_Description__c, BA_Fund_Type__c, Product__c,Schedule__c, Plan__c,
                    ID_Card_Type__c, Billing_Profile__c, Billing_Assoc__c,
                    AccountStructureCase__r.HCSC_Division__c
                     FROM GEMS_Benefit_Agreement__c
                     WHERE AccountStructureCase__c = : caseId
                     ORDER BY Name ASC]);
    }
    public PageReference addBA(){
        BA = new BAWrapper(true, new GEMS_Benefit_Agreement__c(Account__c = accountId, AccountStructureCase__c = caseId));
        listOfBAs.add(BA);
        return null;
    }
    public PageReference saveBAs() {
        selectedBAs = new List<GEMS_Benefit_Agreement__c>();
        try{
            for(BAWrapper BAWrapper : listOfBAs){
                if(BAWrapper .isSelected == true){
                    selectedBAs.add(BAWrapper.BA);
                    //TODO : Need to add duplicate check
                }
            }
            String recs = 'recs=';
            if(!selectedBAs.isEmpty()){
                upsert selectedBAs;
                Integer count = selectedBAs.size();
                recs = recs + selectedBAs[0].Id;
                Integer i = 1;
                while(i < count){
                    recs = recs + '%2C' + selectedBAs[i].id;
                    i = i +1;
                }
                return new PageReference( '/apex/GEMSAssignBACat?' + recs);
                //return new PageReference('/apex/GEMSCaptureBenefitAgreements?caseId=' + caseId + '&accountId=' + accountId);
                //return new PageReference('/'+CaseId);
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
    
    /*
     public PageReference gotoAssignment(){
        saveBAs();
        selectedBAs = new List<GEMS_Benefit_Agreement__c>();
        try{
            for(BAWrapper BAWrapper : listOfBAs){
                if(BAWrapper .isSelected == true){
                    selectedBAs.add(BAWrapper.BA);
                    //TODO : Need to add duplicate check
                }
            }
        String recs = 'recs=';
        if(!selectedBAs.isEmpty()){
            Integer count = selectedBAs.size();
            recs = recs + selectedBAs[0].Id;
            Integer i = 1;
            while(i < count){
                recs = recs + '%2C' + selectedBAs[i].id;
                i = i +1;
            }
        }
        return new PageReference( '/apex/GEMSAssignBACat?' + recs);
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
            return null;
        }
    }
    */
    public class BAWrapper {
        public boolean isSelected {get; set;}
        public GEMS_Benefit_Agreement__c BA {get; set;}
        //public boolean benefitAgreementCheck {get; set;}
        public BAWrapper (boolean isSelected, GEMS_Benefit_Agreement__c BA){
            this.isSelected = isSelected;
            this.BA = BA;
        }
    }
    
}