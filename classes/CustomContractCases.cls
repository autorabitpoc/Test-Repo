public with sharing class CustomContractCases {
    private ApexPages.StandardController controller;
    public String retURL {get; set;}
    public String rType {get; set;}
    public String ent {get; set;}
    public String accountID {get; set;}
    public Id CaseRecordTypeId;
    public String groupAccountRecordTypeName;
    public Account accountrec {get; set;}
    
    public CustomContractCases(ApexPages.StandardController controller){
        this.controller = controller;
    }
    public pageReference redirect()
    {
        PageReference returnURL;
     //   CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
        accountID = ApexPages.currentPage().getParameters().get('def_account_id');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        ent = ApexPages.currentPage().getParameters().get('ent');
        IF(accountID!=null){
            accountrec = [select id,Distribution_Method__c,recordtypeid from Account where Id=:accountID];
            groupAccountRecordTypeName = Schema.SObjectType.Account.getRecordTypeInfosById().get(accountrec.recordtypeid).getname();
        }
        IF(groupAccountRecordTypeName == 'Group Account') {
            returnURL = new PageReference('/500/e'); 
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', rType);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            returnURL.getParameters().put('def_account_id', accountID);
            returnURL.getParameters().put('00N330000038qYJ', accountrec.Distribution_Method__c);
        }
        ELSE {
            returnURL = new PageReference('/500/e'); 
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', rType);          
            returnURL.getParameters().put('ent', ent);           
            returnURL.getParameters().put('nooverride', '1');
            IF (accountID != null){
                returnURL.getParameters().put('def_account_id', accountID);
            }
        }
        returnURL.setRedirect(true);
        return returnURL;
    }
}