public class PrivateExchangeRecordTypeSelection {
    public Case peCase {get; set;}
    public Id cId{get; set;}
    public List<String> recordTypes {get;set;}
    public String selectedValue {get;set;}
    public String selectedrctyp {get; set;}
    public List<SelectOption> recordOptions {get;set;}
    public Blue_Directions_LOB__c privateExchangeProduct {get; set;}
    
    Public PrivateExchangeRecordTypeSelection(ApexPages.StandardController controller){
        cId = ApexPages.currentPage().getParameters().get('cId');
        System.debug('--------Case Record-----------'+cId);
        recordTypes = getPicklistValues('Case', 'Record_Type_Selelction__c');
        System.debug('--------picklist record types-----------'+recordTypes);
        
        List<Case> temp = [select id,CaseNumber,Recordtype.developerName from Case where id = :cId];
        peCase = temp[0];
        
        recordOptions = new List<SelectOption>();
        
        if(peCase.Recordtype.developerName.Contains('Blue_Directions')) {
            for(string rtype : recordTypes) {
                if(rtype.contains('Blue Direction')){
                    recordOptions.add(new SelectOption(rtype, rtype));
                } 
            }
        } else {
            for(string rtype : recordTypes) {
                if(rtype.contains('External')){
                    recordOptions.add(new SelectOption(rtype, rtype));
                } 
            }
        }
        System.debug('--------Case Record peCase-----------'+peCase.Recordtype.developerName);
    }
    
    private List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        return lstPickvals;
    }
    
    public PageReference peContinue(){
        Id selectedFieldId;
        List<RecordType> rts = [SELECT Id,Name FROM RecordType WHERE SobjectType='Blue_Directions_LOB__c'];
        for(RecordType rt : rts) {
            System.debug('--------record name-----'+rt.Name);  
            System.debug('--------record id-----'+rt.Id);  
            string name = rt.Name;
            if(selectedValue.contains(name)){
                
                selectedFieldId = rt.Id;
            }
            System.debug('--------BDMedicalrecTypeId-----------'+selectedFieldId);
        }
        privateExchangeProduct = new Blue_Directions_LOB__c();
        privateExchangeProduct.Case_Number__c = ApexPages.currentPage().getParameters().get('Casenum');
        string returnURL = apexpages.currentPage().getparameters().get('retURL');
        system.debug('---returnURL----'+returnURL);
        system.debug('---cId----'+cId);
        system.debug('---CaseNumber----'+peCase.CaseNumber);
        system.debug('---selectedValue----'+selectedValue);
        String URL = '/a1i/e?CF00N330000038UjW='+peCase.CaseNumber+'&CF00N330000038UjW_lkid='+cId+'&retURL=%2F'+cId+'&RecordType='+selectedFieldId+'&ent=01I33000000J1QQ';
        system.debug('---URL----'+URL);
        pageReference ref = new pageReference(URL);
        return ref;                
    }
}