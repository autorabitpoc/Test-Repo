public class GEMS_AssociateBACatController {

    public Id caseId;
    public Id accountId;
    List<string> strIds = new List<string>();
    
    public List<GEMS_Benefit_Agreement__c> listOfBAs {get; set;}
    public List<CatWrapper> listOfCat {get; set;}
    public List<GEMS_Category__c> selectedCat {get; set;}
    
    public Integer numberOfRowToRemove {get; set;}
    public Id recordToDelete {get; set;}
    public boolean hasEditAccess{get;set;}
    public string rowCount{get;set;}
    
    public Map<Id, GEMS_Category__c> mapOfIdAndCat;
    public CatWrapper Cat;
    public Integer sizeOfList{
        get{
            if (listOfChars != Null)
               return listOfChars.size();
            else 
                return Null;
        }
        set;
    }
    
    public Integer sizeOfListNew{
        get{
            integer count = 0;
            if(listOfChars!= Null){
                for (GEMS_Characteristic__c C: listOfChars)
                    count = count +1;
                return count;                
            }
            else
                return Null;
        }
        
        set;
    }
    
    public List<Integer> iter {
       get{
           List<Integer> iter = new List<Integer>();
            Integer Count = 0; 
            while (Count < SizeOflist){
                Iter.add(Count);
                Count = Count +1;
            }
            return iter;
         }
         set;
    }
    
    public List<Integer> iterNew {
       get{
           List<Integer> iterNew = new List<Integer>();
            Integer Count = 0; 
            while (Count < SizeOflistNew){
                IterNew.add(Count);
                Count = Count +1;
            }
            return iterNew;
         }
         set;
    }

    
    public GEMS_AssociateBACatController(ApexPages.StandardSetController controller) {            
    
        //caseId = ApexPages.currentPage().getParameters().get('caseId');
        //accountId = ApexPages.currentPage().getParameters().get('accountId');
        
        string recs = ApexPages.currentPage().getParameters().get('recs');
        
        if(recs != null)        
            strIds = recs.split(',',-2);
        
        system.debug('dssdfdssfd' + strIds);
        
        //UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :caseId limit 1][0];
        //if(userAccess.HasEditAccess){
            hasEditAccess= true;

            try{
                    listOfBAs = getBAs();
                    
                    if(listOfBAs.size() > 0){
                        caseId = listOfBAs[0].AccountStructureCase__c;
                        accountId = listOfBAs[0].Account__c;
                    }
                    
                    List<GEMS_Category__c> existingCatValues = getCat();
                    mapOfIdAndCat = new Map<Id, GEMS_Category__c>(existingCatValues);
                    
                    listOfCat = new List<CatWrapper>();
                    
                    
                    if(!existingCatValues.isEmpty()){
                    
                        for(GEMS_Category__c existingCatValue : existingCatValues){
                        List<Id> listOfCharValues = new list<Id>();
                        for (GEMS_Cat_Char_Value_Association__c Ass : existingCatValue.GEMS_Category_Characteristic_Association__r ){
                         listOfCharValues.add(Ass.Characteristic_Value__r.id);
                        }
                        Integer count = 0;
                        if(listOfCharValues != Null){
                            for (Id cVal: listOfCharValues)
                                count = count +1;            
                        }
                        Integer sizeOfListOfCharValues = count; 
                        //Integer difference = sizeOfList - listOfCharValues.size();
                        Integer difference = sizeOfListNew - sizeOfListOfCharValues;
                        while(difference > 0){
                            listOfCharValues.add(CaseId);
                            difference = difference -1;
                        }
                            Cat = new CatWrapper(true, existingCatValue, listOfCharValues);
                            listOfCat.add(Cat);
                        }
                    }else{
                        listOfCat= new List<CatWrapper>();
                        list<Id> newList = new list<id>();
                        Integer Count = 0;
                        while (Count < sizeOflistNew){
                            Newlist.add(CaseId);
                            Count = Count +1;
                        }
                                      
                        Cat= new CatWrapper(true, new GEMS_Category__c(Case__c= caseId, Account__c = accountId), newlist);
                        
                        listOfCat.add(Cat);
                    }
                
            }
            catch(Exception e){Throw e;}
        //}else{
                //hasEditAccess = false;
                //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, system.label.InsufficientError)); 
        //}
        
    }
    /*
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Account__c, Name, AccountStructureCase__c, BA_Description__c, BA_Fund_Type__c, Plan__c,Product__c, Product_Name__c,Product_Type__c,
                        AccountStructureCase__r.HCSC_Division__c, AccountStructureCase__r.Account.AccountNumber, AccountStructureCase__r.Account.External_ID__c,AccountStructureCase__r.Account.Name, AccountStructureCase__r.GEMS_Case_Effective_Date__c, AccountStructureCase__r.GEMS_Submission_Type__c, AccountStructureCase__r.GEMS_Submission_Sub_Type__c,AccountStructureCase__r.GEMS_Line_of_Business__c, AccountStructureCase__r.GEMS_Account_Submission_Info__c, AccountStructureCase__r.Market_Segment__c, AccountStructureCase__r.Status, AccountStructureCase__r.Owner.Name, AccountStructureCase__r.GEMS_Type__c, GEMS_Is_Account_Derivated__c  
                                FROM GEMS_Benefit_Agreement__c
                                WHERE Id IN : strIds
                                    ORDER BY Name ASC]));
            }
            setCon.setPageSize(200);
            return setCon;
        }
        set;
    }
    */
    
    public PageReference removeCat(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfCat.remove(numberOfRowToRemove - 1);

            if(recordToDelete !=null && !mapOfIdAndCat.isEmpty()){
                if(mapOfIdAndCat.containsKey(recordToDelete)){
                    delete mapOfIdAndCat.get(recordToDelete);
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
            for(CatWrapper opw : listOfCat){                
                ++recCount;
            }
        }catch(Exception e){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
        }
    }
    public PageReference removeRow(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfCat.remove(numberOfRowToRemove - 1);
            if(recordToDelete !=null && !mapOfIdAndCat.isEmpty()){
                if(mapOfIdAndCat.containsKey(recordToDelete)){
                    delete mapOfIdAndCat.get(recordToDelete);
                }
            }

        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
             
        }
        return null;
    }
    
    public List<GEMS_Benefit_Agreement__c> getBAs() {
        //return (List<GEMS_Benefit_Agreement__c>) setCon.getRecords();
        return [SELECT Id, Account__c, Name, AccountStructureCase__c, BA_Description__c, BA_Fund_Type__c, Plan__c,Product__c, Product_Name__c,Product_Type__c,
                        AccountStructureCase__r.HCSC_Division__c, AccountStructureCase__r.Account.AccountNumber, AccountStructureCase__r.Account.External_ID__c,AccountStructureCase__r.Account.Name, AccountStructureCase__r.GEMS_Case_Effective_Date__c, AccountStructureCase__r.GEMS_Submission_Type__c, AccountStructureCase__r.GEMS_Submission_Sub_Type__c,AccountStructureCase__r.GEMS_Line_of_Business__c, AccountStructureCase__r.GEMS_Account_Submission_Info__c, AccountStructureCase__r.Market_Segment__c, AccountStructureCase__r.Status, AccountStructureCase__r.Owner.Name, AccountStructureCase__r.GEMS_Type__c, AccountStructureCase__r.GEMS_Is_Account_Derivated__c
                                FROM GEMS_Benefit_Agreement__c
                                WHERE Id IN : strIds
                                    ORDER BY Name ASC];
    }
    
    public List<GEMS_Category__c> getCat() {
        return [SELECT Id, Account__c, Name, Case__c, Category_Cobra_Code__c, Category_Description__c , Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c,
                       (SELECT Id, Characteristic_Value__r.id FROM GEMS_Category_Characteristic_Association__r)
                            FROM GEMS_Category__c
                                WHERE Case__c= : caseId
                                    ORDER BY Name ASC];
    }
    
     public PageReference addCat(){
        
        list<Id> newList = new list<id>();
        Integer Count = 0;
        while (Count < sizeOflistNew){
            Newlist.add(CaseId);
            Count = Count +1;
        }
        Cat = new CatWrapper(true, new GEMS_Category__c(Case__c= caseId, Account__c = accountId, Usage_Billing__c = True, Usage_Reporting__c = True), newlist);
            
        listOfCat.add(Cat);
        
        return null;
    }
    
    public PageReference assignCat() {
    
        selectedCat = new List<GEMS_Category__c>();
        List<List<Id>> listOfselectedCharVals = new List<List<Id>>();
        try{
            for(CatWrapper CatWrapper : listOfCat){
                if(CatWrapper.isSelected == true){
                    selectedCat.add(CatWrapper.Cat);
                    listOfselectedCharVals.add(CatWrapper.InputCharVals);
                    //TODO : Need to add duplicate check
                }
            }
            if(!selectedCat.isEmpty()){

                upsert selectedCat;    
                
                List<GEMS_BA_Category_Assignment__c> BAAssociations = [Select Id from GEMS_BA_Category_Assignment__c where Benefit_Agreement__c IN : strIds];
                delete BAAssociations;
                List<GEMS_Cat_Char_Value_Association__c> OldCatCharAss= [SELECT Id FROM GEMS_Cat_Char_Value_Association__c WHERE Case__c =: CaseId];
                delete OldCatCharAss;
                list<GEMS_BA_Category_Assignment__c> newBAAssociations = new list<GEMS_BA_Category_Assignment__c>();
                
                for(GEMS_Benefit_Agreement__c BA : listOfBAs){                
                    for(GEMS_Category__c Cat : selectedCat){                    
                        GEMS_BA_Category_Assignment__c BAAssignment = new GEMS_BA_Category_Assignment__c
                            (Account__c = accountId, Case__c = caseId, Benefit_Agreement__c=BA.id, Category__c = Cat.id);                                                                
                        newBAAssociations.add(BAAssignment);                        
                    }
                }
                
                insert newBAAssociations;
                                
                //List<List<GEMS_Cat_Char_Value_Association__c>> listOfAllCatCharValueAss = new List<List<GEMS_Cat_Char_Value_Association__c>>();
                Integer Count = 0;
                                for (GEMS_Category__c Cat : SelectedCat){
                    List<GEMS_Cat_Char_Value_Association__c> AllCatCharAss = new List<GEMS_Cat_Char_Value_Association__c>();
                    List<Id> SelectedCharVals = listOfselectedCharVals[Count];
                    for (Id CharVal: SelectedCharVals){
                        if(CharVal == CaseId) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select all Characteristics'));
                            return null;
                        }
                        else {
                            GEMS_Cat_Char_Value_Association__c CatCharAss = new GEMS_Cat_Char_Value_Association__c(Account__c = AccountId, Case__c = CaseId, Category__c = Cat.Id, Characteristic_Value__c = CharVal);
                            AllCatCharAss.add(CatCharAss);
                        }
                    } 
                    Count = Count + 1;
                    upsert AllCatCharAss;
                    //listOfAllCatCharValueAss.add(AllCatCharAss);
                }
                //upsert listOfAllCatCharValueAss;
                
                return new PageReference('/apex/GEMSCreateAccountStructure?caseId=' + caseId);
                //return Null;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one Benefit Agreement'));
                return null;
            }
            
            /*
            if(listOfselectedCharVals != Null){
                List<List<GEMS_Cat_Char_Value_Association__c>> listOfAllCatCharValueAss = new List<List<GEMS_Cat_Char_Value_Association__c>>();
                Integer Count = 0;
                for (GEMS_Category__c Cat : SelectedCat){
                    List<GEMS_Cat_Char_Value_Association__c> AllCatCharAss = new List<GEMS_Cat_Char_Value_Association__c>();
                    List<Id> SelectedCharVals = listOfselectedCharVals[Count];
                    for (Id CharVal: SelectedCharVals){
                        if(CharVal != Null || CharVal != CaseId) {
                            GEMS_Cat_Char_Value_Association__c CatCharAss = new GEMS_Cat_Char_Value_Association__c(Account__c = AccountId, Case__c = CaseId, Category__c = Cat.Id, Characteristic_Value__c = CharVal.Id);
                            AllCatCharAss.add(CatCharAss);
                        }
                    } 
                    Count = Count + 1;
                    listOfAllCatCharValueAss.add(AllCatCharAss);
                }
                upsert listOfAllCatCharValueAss;
                return new PageReference('/apex/GEMSCreateAccountStructure?caseId=' + caseId);
            }
            
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Characteristic Value Selected'));
                return null;
            }
            */
            
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High');
            ApexPages.addMessages(ex); 
            return null;
        }
        
    }
   
    public list<GEMS_Characteristic__c> listOfChars{
    get {
    return [SELECT Id, Name, Corp_Characteristic_Code__c, Characteristic_Code__c,
            (SELECT Id, Name FROM GEMS_Characteristic_Values__r) 
                FROM GEMS_Characteristic__c WHERE Case__c =: CaseId];
    }
    set;
    }

        public List<List<SelectOption>> getOptions(){
        List<List<SelectOption>> listOfOptions = new List<List<SelectOption>>();
        
        for (GEMS_Characteristic__c Charact: listOfChars){
            List<SelectOption> options = new List<SelectOption>();
            //options.add(new SelectOption(CaseId, '--None--'));
            if (Charact != Null){
                for(GEMS_Characteristic_Value__c CharVal : Charact.GEMS_Characteristic_Values__r) {
                    options.add(new SelectOption(CharVal.Id, CharVal.Name));
                }
            }
            listOfOptions.add(Options);
        }
        return listOfOptions;
    }
    
    public List<List<SelectOption>> listOfOptions{
    
    get{
        if (listOfChars !=NUll){
           return getOptions();
        }
        else
        return Null;
    }
    set;
    }

    
   /*
    public List<SelectOption> getOptions(){
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(CaseId, '--None--'));
        if (listOfChars != Null){
            for(GEMS_Characteristic__c Charact : listOfChars) {
                options.add(new SelectOption(Charact.Name, Charact.Name));
            }
        }
        return options;
    }
    */                         
    public PageReference gotoCreateAccountStructure() {
        return new PageReference('/apex/GEMSCreateAccountStructure?caseId=' + caseId);
    }    
   

    public PageReference gotoCase() {
        //return new PageReference('/GEMSAccountStructure?Id=' + caseId);
        return new PageReference('/'+caseId);
    }
    
    public class CatWrapper {
        public boolean isSelected {get; set;}
        public GEMS_Category__c Cat {get; set;}
        public List<Id> InputCharVals {get; set;}
        public CatWrapper (boolean isSelected, GEMS_Category__c Cat, List<Id> InputCharVals){
            this.isSelected = isSelected;
            this.Cat = Cat;
            this.InputCharVals = InputCharVals;
        }
    }


}