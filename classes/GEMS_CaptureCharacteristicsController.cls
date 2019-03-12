public class GEMS_CaptureCharacteristicsController {
  
    public Id caseId;
    public Id accountId;
    public Id charId;
    public List<Characteristic_ValueWrapper> listOfCharacteristic_Values {get; set;}
    
    public Integer numberOfRowToRemove {get; set;}
    public Id recordToDelete {get; set;}
    public boolean hasEditAccess{get;set;}
    public string rowCount{get;set;}
    public string Characteristic_ValueRecordId{get;set;}
    public GEMS_Characteristic__c Characteristic{get; set;}
    public Map<Id, GEMS_Characteristic_Value__c> mapOfIdAndCharacteristic_Value;
    public Characteristic_ValueWrapper Characteristic_Value;
    public List<GEMS_Characteristic_Value__c> selectedCharacteristic_Values;
    
    /*
        public GEMS_Characteristic__c Characteristic {
        get{
            return new GEMS_Characteristic__c(Case__c = caseId, Account__c = AccountId);
        }
        set;
    }
    
    */
    
     public GEMS_CaptureCharacteristicsController(ApexPages.StandardSetController controller) {
    
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        charId = ApexPages.currentPage().getParameters().get('charId');
         if(charId != null){
             Characteristic = [SELECT Account__c, Case__c, Characteristic_Code__c, Comments__c, Corp_Characteristic_Code__c,
                              Effective_Date__c, End_Date__c, Mandatory__c, Usage__c FROM GEMS_Characteristic__c WHERE id =: charid ];
         	caseId = Characteristic.Case__c;
             accountId = Characteristic.Account__c;
         }
         else
        	Characteristic = new GEMS_Characteristic__c(Case__c = caseId, Account__c = AccountId);
        
        UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :caseId limit 1][0];
        if(userAccess.HasEditAccess){
            hasEditAccess= true;

            try{
                    List<GEMS_Characteristic_Value__c> existingCharacteristic_Values = getCharacteristic_Values();
                    mapOfIdAndCharacteristic_Value = new Map<Id, GEMS_Characteristic_Value__c>(existingCharacteristic_Values);
                    
                    listOfCharacteristic_Values = new List<Characteristic_ValueWrapper>();
                    
                    if(!existingCharacteristic_Values.isEmpty()){
                    
                        GEMS_Characteristic_Value__c tempCharacteristic_Value;
                    
                        for(GEMS_Characteristic_Value__c existingCharacteristic_Value : existingCharacteristic_Values){
                            Characteristic_Value = new Characteristic_ValueWrapper(true, existingCharacteristic_Value);
                            listOfCharacteristic_Values.add(Characteristic_Value);
                        }
                    }else{
                        listOfCharacteristic_Values= new List<Characteristic_ValueWrapper>();
                        
                        Characteristic_Value = new Characteristic_ValueWrapper(true, new GEMS_Characteristic_Value__c(Case__c = CaseId));
                        
                        listOfCharacteristic_Values.add(Characteristic_Value);
                        System.debug('New - ' + listOfCharacteristic_Values);
                    }
                
            }
            catch(Exception e){Throw e;}
            
        }else{
                hasEditAccess = false;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, system.label.InsufficientError)); 
        }
        
    }
    
     public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name, Characteristic__c, Code__c
                     FROM GEMS_Characteristic_Value__c
                     WHERE Characteristic__c =: Characteristic.id
                                    ORDER BY Name ASC]));
            }
            return setCon;
        }
        set;
    }
    
    public PageReference removeCharacteristic_Value(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
        listOfCharacteristic_Values.remove(numberOfRowToRemove - 1);

            if(recordToDelete !=null && !mapOfIdAndCharacteristic_Value.isEmpty()){
                if(mapOfIdAndCharacteristic_Value.containsKey(recordToDelete)){
                    delete mapOfIdAndCharacteristic_Value.get(recordToDelete);
                }
            }
        
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'GEMS_CaptureCharacteristicsController.removeCharacteristic_Value()','High'); 
             
        }
        return null;
    }
    
    public void getTheUpdatedMembersCount(){
        try{
            decimal recCount = 1;
            for(Characteristic_ValueWrapper opw : listOfCharacteristic_Values){                
                ++recCount;
            }
        }catch(Exception e){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
        }
    }
    public PageReference removeRow(){
        system.debug('numberOfRowToRemove--'+numberOfRowToRemove);
        try{
            listOfCharacteristic_Values.remove(numberOfRowToRemove - 1);
            if(recordToDelete !=null && !mapOfIdAndCharacteristic_Value.isEmpty()){
                if(mapOfIdAndCharacteristic_Value.containsKey(recordToDelete)){
                    delete mapOfIdAndCharacteristic_Value.get(recordToDelete);
                }
            }

        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'GEMS_CaptureCharacteristicsController.removeRow()','High'); 
             
        }
        return null;
    }
    
    public List<GEMS_Characteristic_Value__c> getCharacteristic_Values() {
        return (List<GEMS_Characteristic_Value__c>) setCon.getRecords();
    }
    
     public PageReference addCharacteristic_Value(){

        Characteristic_Value = new Characteristic_ValueWrapper(true, new GEMS_Characteristic_Value__c(Case__c = CaseId));
            
        listOfCharacteristic_Values.add(Characteristic_Value);
        
        return null;
    }
    
    
    public PageReference saveCharacteristicValues() {
    
        selectedCharacteristic_Values = new List<GEMS_Characteristic_Value__c>();
        try{
            for(Characteristic_ValueWrapper Characteristic_ValueWrapper : listOfCharacteristic_Values){
                if(Characteristic_ValueWrapper .isSelected == true){
                    selectedCharacteristic_Values.add(Characteristic_ValueWrapper.Characteristic_Value);
                    //TODO : Need to add duplicate check
                }
            }
            if(!selectedCharacteristic_Values.isEmpty()){
                /* GEMS_Characteristic__c CharactNew = new GEMS_Characteristic__c();
                CharactNew = Characteristic;
                insert CharactNew;
                CharactNew.Effective_Date__c = Characteristic.Effective_Date__c;
                CharactNew.End_Date__c = Characteristic.End_Date__c;
                CharactNew.Mandatory__c = Characteristic.Mandatory__c;
                CharactNew.Usage__c = Characteristic.Usage__c;
                CharactNew.Comments__c = Characteristic.Comments__c;
                CharactNew.Corp_Characteristic_Code__c = Characteristic.Corp_Characteristic_Code__c;
                update CharactNew;
                Id result = CharactNew.Id; 
                System.debug('Characteristic before insert is ' + Characteristic);
                System.debug('result id ' + result);
                */
                upsert Characteristic;
                System.debug('Characteristic is ' + Characteristic);
                for(GEMS_Characteristic_Value__c Characteristic_Value : selectedCharacteristic_Values){
                   // Characteristic_Value.Characteristic__c = result;
                   if(Characteristic_Value.Characteristic__c == null)
                   	Characteristic_Value.Characteristic__c = Characteristic.Id;
                }
                System.debug('Characteristic Values before insert - ' + selectedCharacteristic_Values);
                upsert selectedCharacteristic_Values;
                //return new PageReference('/apex/GEMSCaptureBenefitAgreements?caseId=' + caseId + '&accountId=' + accountId);
                return new PageReference('/'+CaseId);
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one Characteristic_Value'));
                return null;
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'GEMS_CaptureCharacteristicsController.saveCharacteristicValues()','High'); 
            return null;
        }
    }
    
    public PageReference gotoCase() {
        //return new PageReference('/GEMSAccountStructure?Id=' + caseId);
        return new PageReference('/'+caseId);
    }
    
    public class Characteristic_ValueWrapper {
        public boolean isSelected {get; set;}
        public GEMS_Characteristic_Value__c Characteristic_Value {get; set;}
        //public boolean benefitAgreementCheck {get; set;}
        
        public Characteristic_ValueWrapper (boolean isSelected, GEMS_Characteristic_Value__c Characteristic_Value){
            this.isSelected = isSelected;
            this.Characteristic_Value = Characteristic_Value;
        }
    }

}