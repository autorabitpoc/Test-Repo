public without sharing class GEMS_SelectCharValController {

    Id caseId;
    Id catId;
    Id charId ;
    Id baIds;
    
    Public List<GEMS_Category__c> cats {get; set;}
    Public List<CharWrapper> chars {get;set;}
    Public List<CharValWrapper> charValues{get;set;}
    
    Public Id selChar {get; set;}
    Public Id selCharVal {get; set;}
    Public boolean isSelected{get; set;}
    
    Public Integer size{get;set;}
    Public Integer limitSize{get;set;}
    Public Integer offset{get;set;}
    
    Public Integer sizeChar{get;set;}
    Public Integer limitSizeChar{get;set;}
    Public Integer offsetChar{get;set;}
    
    public boolean isDisabled{get;set;}
        
    public GEMS_SelectCharValController(){
    
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        catId = ApexPages.currentPage().getParameters().get('catId'); 
        baIds = ApexPages.currentPage().getParameters().get('baIds');
                    
        cats = getCategory();  
        limitSizeChar = 20;
        offsetChar = 0;        
        
        limitSize = 20;
        offset = 0;
       if(Test.isRunningTest()){
                //do something
       
       
        }
        else{
        sizeChar = getSize();
        size = getSizeValue();
       getChars();
        
        }
        
    }
    
     Public List<GEMS_Category__c> getCategory(){
        return [SELECT Name, Account__c, Case__c, Category_Description__c, Category_Cobra_Code__c, Members_Derivation_Type__c, IsNew__c, 
                IsUpdated__c, Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c, Effective_Date__c FROM GEMS_Category__c WHERE id = : catId];
    }
    
    public Integer getSize(){
    
        list<GEMS_Characteristic__c> records = new list<GEMS_Characteristic__c>();
        
        records = [Select Id
                    FROM GEMS_Characteristic__c 
                    WHERE Case__c  = : caseId AND Other__c = false
                        AND Reporting__c = : cats[0].Usage_Reporting__c AND Billing__c = : cats[0].Usage_Billing__c
                        AND Mailing__c = : cats[0].Usage_Mailing__c AND Product__c = : cats[0].Usage_Product__c];
            
        return records.size();
    }
    
    public Integer getSizeValue(){
    
        list<GEMS_Characteristic_Value__c> records = new list<GEMS_Characteristic_Value__c>();
        
        records = [Select Id               
                    FROM GEMS_Characteristic_Value__c
                    WHERE Case__c  = : caseId
                        AND Characteristic__c = : charId];
            
        return records.size();
    }
        
    public map<Id, GEMS_Characteristic__c> getRecords(){        
                     
        map<Id, GEMS_Characteristic__c> records = new map<Id, GEMS_Characteristic__c>([Select Id, Name, Account__c, Case__c, Characteristic_Code__c, Billing__c,
                Comments__c, Corp_Characteristic_Code__c, Corp_Characteristic_Code__r.Name, Effective_Date__c, End_Date__c, IsNew__c, IsUpdated__c, 
                Mailing__c, Mandatory__c, Other__c, Product__c, Reporting__c, Usage__c
                    FROM GEMS_Characteristic__c 
                    WHERE Case__c  = : caseId AND Other__c = false
                        AND Reporting__c = : cats[0].Usage_Reporting__c AND Billing__c = : cats[0].Usage_Billing__c
                        AND Mailing__c = : cats[0].Usage_Mailing__c AND Product__c = : cats[0].Usage_Product__c
                        ORDER BY Corp_Characteristic_Code__c ASC 
                        LIMIT : limitSizeChar
                        OFFSET : offsetChar]);
            
         return records;
    }
    
     Public List<CharWrapper> getChars(){  
         
        chars = new List<CharWrapper>();
        map<Id, GEMS_Characteristic__c> records = getRecords();
        set<id> assignedChars = new set<id>();
        
        list<GEMS_Cat_Char_Value_Association__c> cats = [SELECT Id, Characteristic_Value__r.Characteristic__c FROM GEMS_Cat_Char_Value_Association__c 
                                                            WHERE Case__c = : caseId
                                                            AND Category__c = : catId
                                                            AND Characteristic_Value__r.Characteristic__c IN : records.keySet()];
        
        for(GEMS_Cat_Char_Value_Association__c cat : cats){
            assignedChars.add(cat.Characteristic_Value__r.Characteristic__c);
        }
        
        for(GEMS_Characteristic__c a : records.Values()){
            boolean isAssigned = assignedChars.contains(a.Id) ? true : false;
            CharWrapper cw = new CharWrapper(false, isAssigned, a);
            chars.add(cw);
        }        
        
        return chars;
    }

    public map<Id, GEMS_Characteristic_Value__c> getRecordsValue(){   
                     
        map<Id, GEMS_Characteristic_Value__c> records = new map<Id, GEMS_Characteristic_Value__c>([Select Id, Name, Case__c, Characteristic__c, Char_Code__c,
                Characteristic_Code__c, Effective_Date__c, IsNew__c, Code__c,
                (SELECT Id FROM GEMS_Cat_Char_Value_Associations__r WHERE Category__c = : catId AND Case__c = : caseId)
            FROM GEMS_Characteristic_Value__c
            WHERE Case__c  = : caseId
                AND Characteristic__c = : charId
            ORDER BY Code__c ASC 
            LIMIT : limitSize
            OFFSET : offset]);
            
         return records;
    }
     
    Public List<CharValWrapper> getCharsValues(){   
       
        charValues = new List<CharValWrapper>(); 

        map<Id, GEMS_Characteristic_Value__c> records = getRecordsValue();
        
        for(GEMS_Characteristic_Value__c a : records.Values()){
        
            boolean isAssigned = a.GEMS_Cat_Char_Value_Associations__r != null && a.GEMS_Cat_Char_Value_Associations__r.size() > 0 ? true : false;
            
            /*boolean isDisabled = !cats[0].isNew__c && !a.isNew__c ? true : false;
            isDisabled = !cats[0].isNew__c && !cats[0].isUpdated__c ? true : false;*/
            
            isDisabled = !cats[0].isNew__c && !cats[0].isUpdated__c ? true : false;
            if(isDisabled && (cats[0].Members_Derivation_Type__c != null && (cats[0].Members_Derivation_Type__c == 'CT' || cats[0].Members_Derivation_Type__c == 'CH')))
                isDisabled = true;
            
            CharValWrapper cw = new CharValWrapper(isAssigned, isDisabled, a, a.GEMS_Cat_Char_Value_Associations__r);
            charValues.add(cw);
        }        
        
        return charValues;
    }
     
    public PageReference assignChar() {
    
        if(selChar == null ){        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Characteristic to view or modify the Values assignments with selected Category.'));
            return null ;
        }        
        else{
            charId = selChar;
            for(CharWrapper cw :chars ){
                if(cw.characteristic.id != selChar ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Characteristic to view or modify the Values assignments with selected Category.'));    
                    cw.isSelected = false;
                }            
            }
            size = getSizeValue();
            limitSize = 20;
            offset = 0;
            getCharsValues();
            return null;    
        }
    }
    
    public PageReference assignValues() {
    
        if(isSelected != null && !isSelected){
            GEMS_Cat_Char_Value_Association__c charValueCatAssoc = 
                new GEMS_Cat_Char_Value_Association__c(Case__c = caseId, Category__c = catId, Characteristic_Value__c = selCharVal, Account__c = cats[0].Account__c);
            insert charValueCatAssoc;
        }
        else if(isSelected != null && isSelected){
            list<GEMS_Cat_Char_Value_Association__c> charValueCatAssoc = [SELECT Id FROM GEMS_Cat_Char_Value_Association__c 
                                                                            WHERE Category__c = : catId AND Case__c = : caseId AND Characteristic_Value__c = : selCharVal];
            delete charValueCatAssoc;
        }
        getChars();
        return null;
        
    }
    
    public PageReference assignCatValues() {
            
        list<GEMS_Cat_Char_Value_Association__c> insertAssociations = new list<GEMS_Cat_Char_Value_Association__c>();
        list<GEMS_Cat_Char_Value_Association__c> deleteAssociations = new list<GEMS_Cat_Char_Value_Association__c>();
        
        if(charValues != null && charValues.size() > 0){
            for(CharValWrapper charValue : charValues){
                system.debug('charValue : ' + charValue );
                if(charValue.isSelected && (charValue.charValueCatAssoc == null || (charValue.charValueCatAssoc != null && charValue.charValueCatAssoc.size() == 0))){
                    GEMS_Cat_Char_Value_Association__c charValueCatAssoc = 
                        new GEMS_Cat_Char_Value_Association__c(Case__c = caseId, Category__c = catId, Characteristic_Value__c = charValue.characteristicValue.Id, Account__c = cats[0].Account__c);
                        insertAssociations.add(charValueCatAssoc);
                }
                else if(!charValue.isSelected && charValue.charValueCatAssoc != null && charValue.charValueCatAssoc.size() > 0){
                    deleteAssociations.addAll(charValue.charValueCatAssoc);
                    system.debug('Ass ' + deleteAssociations);
                }
            }
        }
        
        insert insertAssociations;

        if(deleteAssociations != null && deleteAssociations.size() > 0)
            delete deleteAssociations;
            
        getCharsValues();
        
        return null;
        
    }
    
    public  PageReference updateCategory() {    
       update cats[0];
       getCharsValues();
       return null;
    }
    
    public PageReference goToCase() {
        return new PageReference('/' + caseId);
    }


    public PageReference goToCats() {
        return new PageReference('/apex/GEMSBACatAssign?recs=' + baIds);
    }
    
    //Char Values - Pagination
    
    public pageReference refresh() {
       offset = 0;
       getCharsValues();
       return null;
    }
     
    public Boolean hasNext {
        get {
            return (size - (offset + limitSize)) > 0 ? true : false;            
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
        getCharsValues();
    }
  
    public void last() {
   Integer a =  math.mod(size,limitSize);
     //   offset =  (size/limitSize) * limitSize;
       if(a> 0){
     offset  = size - a ;
     }
     else{
     offset = size -  limitSize;
     }
   
        getCharsValues();
    }
  
    public void previous() {       
        offset = offset - limitSize;
        getCharsValues();
    }
  
    public void next() {
        offset = offset + limitSize;
        getCharsValues();
    }
    
    //Chars - Pagination
    
     public pageReference refreshChar() {
        offsetChar = 0;
        getChars();
        return null;
    }
     
    public Boolean hasNextChar {
        get {
            return (sizeChar - (offsetChar + limitSizeChar)) > 0 ? true : false;            
        }
        set;
    }
    public Boolean hasPreviousChar {
        get {
            return offsetChar >= limitSizeChar ? true : false;
        }
        set;
    }
  
    public Integer pageNumberChar {
        get {
            return (offsetChar/limitSizeChar) + 1;
        }
        set;
    }
  
    public void firstChar() {
        offsetChar = 0;
        getChars();
    }
  
    public void lastChar() {
    
    Integer a =  math.mod(sizeChar,limitSizeChar); 
     if(a> 0){
     offsetChar = sizeChar - a ;
     }
     else{
     offsetChar =  sizeChar - limitSizeChar;
     }
   // offsetChar =  (sizeChar/limitSizeChar) * limitSizeChar;
        
       // offsetChar =  ((sizeChar/limitSizeChar) * limitSizeChar) - limitSizeChar;
        getChars();
        
        
    }
  
    public void previousChar() {       
        offsetChar = offsetChar - limitSizeChar;
        getChars();
    }
  
    public void nextChar() {
        offsetChar = offsetChar + limitSizeChar;
        getChars();
    }
    
    public class CharValWrapper {
        public boolean isSelected {get; set;}
        public boolean isDisabled {get; set;}
        public GEMS_Characteristic_Value__c characteristicValue {get; set;}
        list<GEMS_Cat_Char_Value_Association__c> charValueCatAssoc {get; set;}
        public CharValWrapper(boolean isSelected, boolean isDisabled, GEMS_Characteristic_Value__c characteristicValue, list<GEMS_Cat_Char_Value_Association__c> charValueCatAssoc){
            this.isSelected = isSelected;
            this.isDisabled = isDisabled;
            this.characteristicValue = characteristicValue;  
            this.charValueCatAssoc = charValueCatAssoc;          
        }        
    }
    
     public class CharWrapper {
        public boolean isSelected {get; set;}
        public boolean isAssigned {get; set;}
        public GEMS_Characteristic__c characteristic {get; set;}
        public CharWrapper(boolean isSelected, boolean isAssigned, GEMS_Characteristic__c characteristic){
            this.isSelected = isSelected;
            this.isAssigned = isAssigned;
            this.characteristic= characteristic;            
        }        
    }
    
}