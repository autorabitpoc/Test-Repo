/**************************************************************************************************************************
* Apex Class: SGR_Renewal_OnDemand_Invoker
* Function  : Apex Controller for SGR_OnDemandAccountsRenwalComponent 
**********************************************************************************************************************************
* Developer                       Date                 Description
**********************************************************************************************************************************
* Phani Kommareddy                09/19/2018           Original Version 
* Nidhi Reddy                     10/03/2018           Modified Original Version
**********************************************************************************************************************************/

public class SGR_Renewal_OnDemand_Invoker {
    
    //search accounts with the criteria
    @AuraEnabled
    public static Account searchAccounts(String division,String acctNo) {
        //Nidhi: replaced accountnumber with external_ID__c
        List<Account> accList=[select id,Name, external_ID__c,HCSC_Division__c,Renewal_Date__c,status__c,Market_Segment__c,Funding_Type__c,
                               (select id,stageName,status__c,Renewal_Date__c from opportunities) from Account where external_ID__c=:acctNo and HCSC_Division__c = :division];
        Integer accListSize = accList.size();
       
        if(accListSize == 0) {
            throw new AuraHandledException('No Accounts Found');
        } else if(accListSize > 1) {
            throw new AuraHandledException('Multiple accounts were found for the specified criteria');
        } 
        return accList[0];
    }   
    
    
    //TODO: SAURAB AND SANTOSH - USE RENEWAL DATE INSTEAD OF RENEWAL EFFECTIVE DATE. 
    //TOD0: Santosh to check oppurtunities to make sure the Renewal_Date__c  validation criteria is covered
    
    
    
    /*
    @AuraEnabled
    public static String onDemandHandler(String division,String acctNo,String renewalType,String renEffDate){
        
        String msg;
        List<Account> accList=[select id,Name, HCSC_Division__c,Renewal_Effective_Date__c,status__c, (select id,stageName,status__c from opportunities) from Account 
                               where external_ID__c=:acctNo and HCSC_Division__c = :division];
        list<Opportunity> opps=new list<Opportunity>();
       
opps=[select id,name from opportunity where stageName!='Won' AND stageName!='Lost' AND Account.external_ID__c=:acctNo AND Account.HCSC_Division__c=: division];
  var name= opps.name;
         if(opps.size()>0){
           msg ='Multiple Production Opportunities are not allowed for the same account and renewal date in Production. Production Opportunity :   '<link>opps[0].name<link>'  +'Already exists';
            return msg; 
        }
        else{
           msg=SGR_Opportunity_Helper.batchAndDemandHandler(accList,renewalType,renEffDate);
        System.debug(msg);
        return msg; 
        }
        
    } */


    
}