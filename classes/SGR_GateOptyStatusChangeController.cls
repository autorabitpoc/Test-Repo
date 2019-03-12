/**************************************************************************************
Apex Class Name     : SGR_GateOptyStatusChangeController  
Version             : 1.0
Function            : This is controller class for GateoptyStatusChange Component.
Modification Log    :
* Developer:                   Date  : 02/10/2018               Description
* Developer:Nidhi Reddy        Date  : 10/3/2018                  Description
* ----------------------------------------------------------------------------               
*************************************************************************************/
public class SGR_GateOptyStatusChangeController {
    @AuraEnabled Public static List<OptyWrapper> getOptyList(string GateId){
        list<OptyWrapper> RetOptyList = new list<OptyWrapper>();
        //Processing optys of current gate
        //Nidhi: replaced accountnumber with external_ID__c 
        for(Opportunity opty:[SELECT Gate__r.Status__c,Account.hold_end_date__c,Account.renewal_duration_is_infinite__c,Account.Renewal_Date__c,Account.Status__c,SGR_Workflow_Status__c,Name, Account.Name, Account.external_ID__c, RecordType.Name, Renewal_Date__c, Rating_Status__c, Expected_Health_Members__c, Expected_Dental_Members__c, LastModifiedBy.Name FROM Opportunity where Gate__c= :GateId ORDER BY Renewal_Date__c]){
            //Creating new wrapper 
            OptyWrapper ow = new OptyWrapper();
            ow.GateStatus = opty.Gate__r.Status__c;//Assign GateStatus
            ow.RenewalDurationInfinite = opty.Account.renewal_duration_is_infinite__c;//Assign 
            ow.AccountHoldDate = opty.Account.hold_end_date__c;//Assign
            ow.AccountRenewalDate = opty.Account.Renewal_Date__c;//Assign
            ow.AccountStatus = opty.Account.Status__c;//Assign
            ow.SGRWorkflowStatus = opty.SGR_Workflow_Status__c;//Assign SGR work flow status
            ow.AccountName=opty.Account.Name;//Assign Account name
            //ow.RecordTypeName=opty.RecordType.Name;
            ow.RenewalDate=opty.Renewal_Date__c;//Assign Renewal date
            //ow.external_ID__c=opty.account.external_ID__c;
            //ow.ExpectedHealthMembers=opty.Expected_Dental_Members__c;
            ow.isSelected=false;//Assign Checkbox
            ow.OptyId=opty.Id;//Assign Opty id
            ow.Name=opty.Name;//Assign Opty name
            ow.RatingStatus = opty.Rating_Status__c;//Assign Rating status
            ///ow.LastModifiedbyName=opty.LastModifiedBy.Name;
            //ow.ExpectedDentalMembers=opty.Expected_Dental_Members__c;
            RetOptyList.add(ow);//Adding wrapper to wrapper list 
        }
        //Returning Wrapper list
        return RetOptyList;
    }
    
    @AuraEnabled
    public static List<Opportunity> getSelectedOpty(List<Id> Ids){
        return [select id,Name,Rating_Status__c,Gate__r.Status__c,SGR_Workflow_Status__c,Account.Name from Opportunity
                where id=:Ids];
    }
    
    @AuraEnabled Public static List<Opportunity> processSelectedOptys(List<Opportunity> SelOptyRecords){
        list<Opportunity> OptyListToUpdate = new list<Opportunity>();
        if(!SelOptyRecords.isEmpty()){
            for(Opportunity  opp : SelOptyRecords){
                opp.Rating_Status__c='Actuarial-Released';
                OptyListToUpdate.add(opp);
            }
        }
        try{
            update OptyListToUpdate;
            return OptyListToUpdate;
        }
        catch(Exception e){
            return null;
        }
    } 
    //Wrapper class for opty list
    public class OptyWrapper{
        @AuraEnabled public String GateStatus {get;set;}
        @AuraEnabled public boolean RenewalDurationInfinite {get;set;}
        //SFDC-15482Bug-AccountHoldDate data type changed from Datetime to Date
        @AuraEnabled public Date AccountHoldDate {get;set;}
        @AuraEnabled public date AccountRenewalDate {get;set;}
        @AuraEnabled public String AccountStatus {get;set;}
        @AuraEnabled public String SGRWorkflowStatus {get;set;} 
        @AuraEnabled public String OptyId {get;set;}
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled public String AccountName {get;set;}
        //@AuraEnabled public String AccountNumber {get;set;}
        //@AuraEnabled public String RecordTypeName {get;set;}
        @AuraEnabled public date RenewalDate {get;set;}
        @AuraEnabled public String RatingStatus {get;set;}
        //@AuraEnabled public double ExpectedHealthMembers {get;set;}
        //@AuraEnabled public double ExpectedDentalMembers {get;set;}
        //@auraEnabled Public string LastModifiedbyName {get;set;}
        @AuraEnabled public boolean isSelected {get;set;}
    }
}