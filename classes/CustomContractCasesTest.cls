/**************************************************************
   Apex Class Name     : CustomContractCasesTest 
  Version             : 1.0
  Function            : This is a test class for CustomContractCases 
  Modification Log    :
  Developer                   Date           Description        
  Padma Beadmpeta(HCSC)       6/6/2017       Prepopulate Distribution Methos from Group Account
***************************************************************/
@isTest
public class CustomContractCasesTest {
       
    @isTest static void CustomContractCasesTestGroup() {

        Account testAcntGrp = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
		testAcntGrp.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
		testAcntGrp.HCSC_Division__c = 'IL';
		testAcntGrp.Status__c = 'Active';
        testAcntGrp.Distribution_Method__c = 'Broker';
		insert testAcntGrp;       
       
        Account accountrec = [select id,Distribution_Method__c from Account where Id=:testAcntGrp.Id];
      
		Case testCase = new Case(Number_of_Lives__c = 10, Negotiation_Type__c = 'Negotiation Type', Agreement_Submitted__c = 'Agreement Submitted',
		State__c = 'State', Status = 'Request from Sales & Marketing, Draft', Account_Type_Custom_Contract__c = 'Account Type', Type__c = 'Value 1',
		Type = 'Value 2', Distribution_Method__c=accountrec.Distribution_Method__c);
		testCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
  		Test.setCurrentPageReference(new PageReference('Page.CustomContractCases')); 
		System.currentPageReference().getParameters().put('id', testCase.Id);
        System.currentPageReference().getParameters().put('def_account_id', accountrec.Id);
        
        CustomContractCases CustomContractCasesobj = new CustomContractCases(new ApexPages.StandardController(testCase));       
        CustomContractCasesobj.redirect(); 
        
        Account testAcntGrp1 = new Account(Name = 'TestAccountGrp', Fax = '1234567', Effective_Date__c = system.today() - 1);
		testAcntGrp1.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
		testAcntGrp1.HCSC_Division__c = 'IL';
		testAcntGrp1.Status__c = 'Active';
		insert testAcntGrp1;
        
        Case testCase1 = new Case(Number_of_Lives__c = 10, Negotiation_Type__c = 'Negotiation Type', Agreement_Submitted__c = 'Agreement Submitted',
		State__c = 'State', Status = 'Request from Sales & Marketing, Draft', Account_Type_Custom_Contract__c = 'Account Type', Type__c = 'Value 1',
		Type = 'Value 2');
  		Test.setCurrentPageReference(new PageReference('Page.CustomContractCases')); 
		System.currentPageReference().getParameters().put('id', testCase1.Id);
        System.currentPageReference().getParameters().put('def_account_id', testAcntGrp1.Id);
        
        CustomContractCases CustomContractCasesobj1 = new CustomContractCases(new ApexPages.StandardController(testCase1));       
        CustomContractCasesobj1.redirect();  
   
    }     
}