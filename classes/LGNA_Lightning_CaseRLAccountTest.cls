/* 
 * Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 03/24/2018
 * Modified date: 04/13/2018
 * Discription : Test Class for Account related Case Subtabs(Insatallation(GEMS), SAM REquests)
*/
@isTest(SeeAllData=false)
public class LGNA_Lightning_CaseRLAccountTest {
    
    static testMethod void LGNA_Lightning(){
          
        System.debug('==Inside test method==');
    	//Id GroupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group_Account').getRecordTypeId();
	    List<RecordType> AccRtIdList = [Select Id,Name from RecordType where SObjecttype='Account'];
        System.debug('=='+AccRtIdList);
        Id AccRtId = [Select Id,Name from RecordType where SObjecttype='Account' AND DeveloperName = 'Group_Account'].Id;
        System.debug('=Rec Type='+AccRtId);
        Account acc = new Account(Name='Test Group Account',HCSC_Division__c='IL',RecordTypeId=AccRtId);
        System.debug('acc'+acc);
        
        //create Opportunity Record
       Id opRecTypeId = [Select Id,Name from RecordType where SObjecttype='Opportunity' AND DeveloperName = 'New_Sale'].Id;
       Opportunity op = new Opportunity(Name='Test Opportunity',RecordTypeId=opRecTypeId,AccountId=acc.Id,StageName='Expected In',CloseDate=System.today(),Type='RFI',Exchange_Offering_Type__c	='No Private Exchange',Requested_Effective_Date__c=System.today(),HCSC_Division__c='Cluster'); 
       insert op; 
        
        CaseRecordTypes__c	crt = new CaseRecordTypes__c(Name='GEMS Account Structure',Gems__c=true);
        insert crt;
        //Id GemCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS_Account_Setup_Process').getRecordTypeId();
        Id CaseRtId = [Select Id,Name from RecordType where SObjecttype='Case' AND DeveloperName = 'GEMS_Account_Structure'].Id;
        Case gemCase = new Case(Status='In Progress',AccountId=acc.Id,RecordTypeId=CaseRtId,Opportunity_Name__c=op.Id);
        insert gemCase;
        
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadInitialCasesGems('Account',acc.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadViewAllCasesGems('Account',acc.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadInitialCasesSamRequest('Account',acc.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadViewAllCasesSamRequest('Account',acc.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.searchGems('Account',acc.Id,'CBSR');
        LGNA_Lightning_GPAccCasesWithTabCotoller.searchSamRequest('Account',acc.Id,'CBSR');
        LGNA_Lightning_GPAccCasesWithTabCotoller.totalcaseList('Account',acc.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.deleteCaseRecord(gemCase.Id);
        LGNA_CaseAccessController.userAccessLevel(gemCase.Id);


        
    }
    
    static testMethod void LGNA_Lightning_SAM(){
          
        System.debug('==Inside test method==');
    	//Id GroupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group_Account').getRecordTypeId();
	    List<RecordType> AccRtIdList = [Select Id,Name from RecordType where SObjecttype='Account'];
        System.debug('=='+AccRtIdList);
        Id AccRtId = [Select Id,Name from RecordType where SObjecttype='Account' AND DeveloperName = 'Group_Account'].Id;
        System.debug('=Rec Type='+AccRtId);
        Account acc = new Account(Name='Test Group Account',HCSC_Division__c='IL',RecordTypeId=AccRtId);
        System.debug('acc'+acc);
        
        Id opRecTypeId = [Select Id,Name from RecordType where SObjecttype='Opportunity' AND DeveloperName = 'New_Sale'].Id;
        Opportunity op = new Opportunity(Name='Test Opportunity',RecordTypeId=opRecTypeId,AccountId=acc.Id,StageName='Expected In',CloseDate=System.today(),Type='RFI',Exchange_Offering_Type__c	='No Private Exchange',Requested_Effective_Date__c=System.today(),HCSC_Division__c='Cluster'); 
        insert op; 
        
        CaseRecordTypes__c	crt = new CaseRecordTypes__c(Name='LGNA_General_Case',Sam_Requests__c=true);
        insert crt;
        
        
        //Id GemCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS_Account_Setup_Process').getRecordTypeId();
        Id CaseRtId = [Select Id,Name from RecordType where SObjecttype='Case' AND DeveloperName = 'LGNA_General_Case'].Id;
        Case samCase = new Case(Status='In Progress',AccountId=acc.Id,RecordTypeId=CaseRtId,Opportunity_Name__c=op.Id);
        insert samCase;
        
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadInitialCasesGems('Opportunity',op.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadViewAllCasesGems('Opportunity',op.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadInitialCasesSamRequest('Opportunity',op.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.loadViewAllCasesSamRequest('Opportunity',op.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.searchGems('Opportunity',op.Id,'CBSR');
        LGNA_Lightning_GPAccCasesWithTabCotoller.searchSamRequest('Opportunity',op.Id,'CBSR');
        LGNA_Lightning_GPAccCasesWithTabCotoller.totalcaseList('Opportunity',op.Id);
        LGNA_Lightning_GPAccCasesWithTabCotoller.deleteCaseRecord(samCase.Id);
        
    }

    
    

}