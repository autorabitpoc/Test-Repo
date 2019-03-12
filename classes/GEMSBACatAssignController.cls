//************************************************************************************
// Name             : GEMSBACatAssignController .cls
// Description      : Controller Class for GemsBACatAssign VF Page
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer               Description
// 08/31/2017       Krishna Kuchibhotla     Added the ability add categories to multiple BAs 
// 08/31/2017       Phani Kommareddy        SFDC-5902 Account Structure: prevent entry of duplicate categories in the account structure
// -----------------------------------------------------------------------------------
// ************************************************************************************
public class GEMSBACatAssignController {

    public Id caseId;
    public Id accountId;
    public Account acct;
    public string recs;
    List <string> strIds = new List <string>();

    public List < GEMS_Benefit_Agreement__c > listOfBAs {get;set;}
    public List<CatWrapper> cats {get; set;}
    public List <GEMS_Category__c> newCats {get;set;}
    public List <GEMS_BA_Category_Assignment__c> baCatList = new List<GEMS_BA_Category_Assignment__c>();
    public Map<Id, GEMS_BA_Category_Assignment__c> baCatMap = new Map<Id,GEMS_BA_Category_Assignment__c>();
    
    public Id selectedCategory {get;set;}
    
    Public Integer size {get;set;}
    Public Integer limitSize {get;set;}
    Public Integer offset {get;set;}   
    
    public Integer numberOfRowToRemove {get;set;}
    public Integer numberOfNewRowToRemove {get;set;}
    public Id NewrecordToDelete {get;set;}
    public Id recordToDelete {get;set;}
    public Date cancelDate {get;set;}
    public Date effectiveDate;
    public boolean change;
    
    public GEMSBACatAssignController(ApexPages.StandardSetController controller) {
    
        recs = ApexPages.currentPage().getParameters().get('recs');
        system.debug('recs---------------' + recs);
        if (recs != null) strIds = recs.split(',', -2);
        system.debug('list of ba ids : ' + strIds);
        
        //Get BA and Account details.
        listOfBAs = getBAs();
        if (listOfBAs.size() > 0){
            caseId = listOfBAs[0].AccountStructureCase__c;
            accountId = listOfBAs[0].Account__c;
            acct = listOfBAs[0].Account__r;
        }
        
        //Existing categories        
        limitSize = 20;
        offset = 0;         
        size = getSize();
        cats = getCategories();
        
        //New category
        newCats = new list<GEMS_Category__c>();
        effectiveDate = listOfBAs[0].AccountStructureCase__r.GEMS_Case_Effective_Date__c;
        GEMS_Category__c newCat = new GEMS_Category__c(Case__c = caseId, Account__c = accountId, IsNew__c = true, 
                                    Usage_Billing__c = false, Usage_Reporting__c = false, Usage_Product__c = false, 
                                    Effective_Date__c = effectiveDate);
        newCats.add(newCat);
    }
    
    public Integer getSize(){
        list<GEMS_Category__c> records = new list<GEMS_Category__c>();        
        records = [SELECT Id FROM GEMS_Category__c WHERE Case__c = : caseId AND Has_Group_Sections__c = true];            
        return records.size();
    }
    
    public map<Id, GEMS_Category__c> getRecords(){   
                     
        map<Id, GEMS_Category__c> records = new map<Id, GEMS_Category__c>([SELECT Id, Account__c, Name, Case__c, Has_Group_Sections__c, Category_Cobra_Code__c, 
                                Category_Description__c, IsUpdated__c, Effective_Date__c, Cancel_Date__c, IsNew__c, IsCancelled__c, Members_Derivation_Type__c, 
                                Usage_Billing__c, Mailing_Address__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c, 
                                
                                (SELECT Id, Characteristic_Value__r.id, Characteristic_Value__r.Char_Code__c FROM GEMS_Category_Characteristic_Association__r), 
                                
                               // (Select Id, Benefit_Agreement__c, Category__c from Category_BA_Assignments__r WHERE Benefit_Agreement__c = : strIds)
                                (Select Id, Benefit_Agreement__c, Category__c from Category_BA_Assignments__r WHERE Benefit_Agreement__c = : recs)
                                    FROM GEMS_Category__c
                                        WHERE Case__c = : caseId AND Has_Group_Sections__c = true
                                            ORDER BY CreatedDate ASC, Name ASC 
                                            LIMIT : limitSize
                                            OFFSET : offset]);
            
         return records;
    }
    
    Public List<CatWrapper> getCategories(){      
        
        cats = new List<CatWrapper>();
        map<Id, GEMS_Category__c> records = getRecords();
        //system.debug('records: '+records);
        
        for(GEMS_Category__c a : records.Values()){
            CatWrapper cw = new CatWrapper();
            cw.isAssigned = a.Category_BA_Assignments__r != null && a.Category_BA_Assignments__r.size() > 0 ? true : false;   
            cw.disableAssignment = !a.isNew__c ? true : false;
            cw.isChanged = false;
            cw.hasCharacteristics = a.GEMS_Category_Characteristic_Association__r!= null && a.GEMS_Category_Characteristic_Association__r.size() > 0 ? true : false;
            cw.cat = a;
            cw.baCats = a.Category_BA_Assignments__r;
           
            cats.add(cw);
        }        
        
        return cats;
    }

    
    //Categories - Pagination - Start
    
    public pageReference refresh() {
       offset = 0;
       getCategories();
       return null;
    }
     
    public Boolean hasNext {
        get {
            return (size - limitSize) >= offset ? true : false;            
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return offset >= limitSize ? true : false;
        }
        set;
    }
  
    public Integer pageNumber {
        get {
          return (offset/limitSize) + 1;
          
           
           
        }
        set;
    }
  
    public void first() {
        offset = 0;
        getCategories();
    }
  
    public void last() {
     //offset =  ((size/limitSize) * limitSize) - limitSize;
     Integer a =  math.mod(size,limitSize); 
     if(a> 0){
     offset  = size - a ;
     }
     else{
     offset =  ((size/limitSize) * limitSize) - limitSize;
     }
        getCategories();
    }
  
    public void previous() {       
        offset = offset - limitSize;

        getCategories();
    }
  
    public void next() {
        offset = offset + limitSize;
        getCategories();
    }
    
    //Categories - Pagination - End  

    // Delete functionality for a new Category
    public PageReference removeRow() {
        //system.debug('numberOfRowToRemove--' + numberOfRowToRemove);
        try {
            cats.remove(numberOfRowToRemove - 1);
           
            
            if(recordToDelete != null){
                list<GEMS_Category__c> delCats = [select id, IsUpdated__c from GEMS_Category__c where id = : recordToDelete];
                delete delCats[0] ;
                size = getSize();
                cats = getCategories();
            }

        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()', 'High');

        }
       return null;
    }
    
        public PageReference removeNewRow() {
        //system.debug('numberOfRowToRemove--' + numberOfNewRowToRemove );
        try {
            newCats.remove(numberOfNewRowToRemove - 1);
         } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()', 'High');

        }
       return null;
    }

    public List < GEMS_Benefit_Agreement__c > getBAs() {
        return [SELECT Id, Account__c, Account__r.id, Name, isNew__c, AccountStructureCase__c, BA_Description__c, BA_Fund_Type__c, Plan__c, Product__c, 
                Product_Name__c, Product_Type__c,
                AccountStructureCase__r.HCSC_Division__c, AccountStructureCase__r.GEMS_Is_Account_Derivated__c, AccountStructureCase__r.Account.AccountNumber, 
                AccountStructureCase__r.Account.External_ID__c, AccountStructureCase__r.Account.Name, Effective_Date__c, 
                AccountStructureCase__r.GEMS_Case_Effective_Date__c, AccountStructureCase__r.GEMS_Submission_Type__c, 
                AccountStructureCase__r.GEMS_Submission_Sub_Type__c, AccountStructureCase__r.GEMS_Line_of_Business__c, 
                AccountStructureCase__r.GEMS_Account_Submission_Info__c, AccountStructureCase__r.Market_Segment__c, 
                AccountStructureCase__r.Status, AccountStructureCase__r.Owner.Name, AccountStructureCase__r.GEMS_Type__c
                FROM GEMS_Benefit_Agreement__c
                    WHERE Id IN: strIds
                    ORDER BY Name ASC
        ];
    }

    // Cancelling a Record
    public PageReference cancelRecord() {

        String para = Apexpages.currentPage().getParameters().get('RN');
        String para2 = Apexpages.currentPage().getParameters().get('RecordCan');
        String para4 = Apexpages.currentPage().getParameters().get('dDate');
        Integer para3 = Integer.valueOf(para);
        String[] dts = para4.split('/');
        cancelDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));

        try {
            GEMS_Category__c c = new GEMS_Category__c();
            if (para2 != null) {
                List < GEMS_Category__c > a = [SELECT Id, IsCancelled__c, Cancel_Date__c FROM GEMS_Category__c WHERE id = : para2];
                if (!a.isEmpty()) {
                    c = a[0];
                    c.Cancel_Date__c = cancelDate;
                    c.IsCancelled__c = true;

                    update c;
                }
            }

            for (CatWrapper catwrap: cats) {
                if (catwrap.cat.Name == c.Name)
                    catwrap.cat.IsCancelled__c = true;
            }

        } 
        catch (Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.cancelRow()', 'High');
        }
        
        return null;
    }
    
    public PageReference goToCharacteristics() {
        if(selectedCategory == null ){        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Category to view or modify the Characteristic and Value assignments.'));
            return null ;
        }
        else{
            return new PageReference('/apex/GEMSSelectCharValue?caseId=' + caseId+ '&catId=' + selectedCategory + '&baIds=' + recs);    
        }
    }
    
    public PageReference backtoBA() {
        return new PageReference('/apex/GEMSCaptureBAs?caseId=' + caseId + '&accountId=' + accountId);
    }

    public PageReference gotoCase() {
        return new PageReference('/' + caseId);
    }
    
    public PageReference gotoCreateAccountStructure() {
        return new PageReference('/apex/GEMSCreateAS?caseId=' + caseId);
    }
    
    //Adding a New Category
    public PageReference addCat() {

        effectiveDate = listOfBAs[0].AccountStructureCase__r.GEMS_Case_Effective_Date__c;
        GEMS_Category__c newCat = new GEMS_Category__c(Case__c = caseId, Account__c = accountId, IsNew__c = true, 
                                    Usage_Billing__c = false, Usage_Reporting__c = false, Usage_Product__c = false, 
                                    Effective_Date__c = effectiveDate);

        newCats.add(newCat);

        return null;
    }
    
    //Save all new Categories
    public PageReference addAllCats() {

        try{
        
            //Insert All new records
            //system.debug('New Cats  List'+newCats);
            if(newCats != null && newCats.size() > 0){
                for (integer i=0; i< newCats.size(); i++){
                    //system.debug('New Cat : '+newCats[i]);
                    if(newCats[i].name == null || newCats[i].name == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Category Numbers for all categories'));
                        return null;
                    }
                    if (newCats[i].Usage_Mailing__c == true && newCats[i].Mailing_Address__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Mailing Address for Category#' + newCats[i].name));
                        return null;
                    } 
                    else if(newCats[i].Usage_Mailing__c == false && newCats[i].Mailing_Address__c != null) {
                        newCats[i].Mailing_Address__c = null;
                    }
                }                
                insert newCats;                
             }
            
            //Add a new Category             
            newCats = new list<GEMS_Category__c>();
            effectiveDate = listOfBAs[0].AccountStructureCase__r.GEMS_Case_Effective_Date__c;
            GEMS_Category__c newCat = new GEMS_Category__c(Case__c = caseId, Account__c = accountId, IsNew__c = true, 
                                    Usage_Billing__c = false, Usage_Reporting__c = false, Usage_Product__c = false, 
                                    Effective_Date__c = effectiveDate);

            newCats.add(newCat);
            
            size = getSize();
            offset =  (size/limitSize) * limitSize;
            //offset =  ((size/limitSize) * limitSize) - limitSize ;
            getCategories();
            
        }
        catch(Exception ex){
            //SFDC-5902 Account Structure: prevent entry of duplicate categories in the account structure
            if(ex.getMessage().contains('duplicate value found')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A duplicate category cannot exist in the structure'));
            } 
            else {
                ApexPages.addMessages(ex);
            }
            
            
            return null;
        }

        return null;
    }
    
   
    public PageReference saveCat() {
        
        Savepoint sp;
        
        List < GEMS_Category__c > allCat = new List < GEMS_Category__c > ();

        try {        
            
            List<GEMS_Category__c > updatedCats = new List < GEMS_Category__c > ();
            list <GEMS_BA_Category_Assignment__c> newBAAssociations = new list <GEMS_BA_Category_Assignment__c> ();
            list <GEMS_BA_Category_Assignment__c> delBAAssociations = new list <GEMS_BA_Category_Assignment__c> ();
            
            for (CatWrapper c: cats) {
                        
                if (c.cat.Usage_Mailing__c == true && c.cat.Mailing_Address__c == null && c.Cat.isNew__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Mailing Address'));
                    return null;
                } 
                else if(c.cat.Usage_Mailing__c == false && c.cat.Mailing_Address__c != null && c.Cat.isNew__c)
                    c.cat.Mailing_Address__c = null;
                
                if ((c.isAssigned == true && c.Cat.Cancel_Date__c != null) && (c.Cat.IsCancelled__c != true)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please remove the Cancel Date for the active Categories'));
                    return null;
                }

                    updatedCats.add(c.cat)  ;
                    //system.debug('Save Cat Name'+c.cat.Name);
                    //system.debug('Cat Assigned'+c.isAssigned);
                    //system.debug('Cat DBAssigned' + c.isDBAssigned);
                    //system.debug('baCats' + c.baCats);
                    
                if (c.isAssigned == true) {
                    if (c.baCats == null || (c.baCats != null && c.baCats.isEmpty())) {
                        system.debug('I am Empty');
                        for (GEMS_Benefit_Agreement__c BA: listOfBAs) {
                            System.debug('Counter Vijay ' + c.Cat.Name);
                            GEMS_BA_Category_Assignment__c BAAssignment = new GEMS_BA_Category_Assignment__c(Account__c = accountId, Case__c = caseId, Benefit_Agreement__c = BA.id, isNew__c = true, Category__c = c.Cat.id);
                            newBAAssociations.add(BAAssignment);
                        }

                    }
                }
                else{
                    if (c.baCats != null && c.baCats.size() > 0) {
                        delBAAssociations.addAll(c.baCats);
                    }
                }
               }
            
            sp = Database.setSavepoint();
            
            if (!updatedCats.isEmpty()) {
                update updatedCats;
            }


                        insert newBAAssociations;
            if(delBAAssociations != null && delBAAssociations.size() > 0)
                delete delBAAssociations;

           cats = getCategories();
                
            return Null;
                
        } catch (Exception ex) {
            Database.rollback(sp);
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'Category Save', 'High');
            system.debug('Line No' + ex.getLineNumber());
            ApexPages.addMessages(ex);
            return null;
        }

    
    }        
    
    public class CatWrapper {
    
        public CatWrapper(){}
               
        public boolean isAssigned {get;set;}
        
        public boolean disableAssignment {get;set;}
        public boolean isChanged {get;set;}
        public boolean hasCharacteristics {get;set;}
        
        public GEMS_Category__c cat {get;set;}
        public list < GEMS_BA_Category_Assignment__c > baCats {get;set;}       
        
    }

}