@isTest
public class GEMS_OpportunityProdInfoController_test {
private static testmethod void GEMS_OpportunityProductInfoController() {         
        
    Account acc = new Account();
    acc.Name = 'Example';
    acc.status__c = 'Active';
    acc.Fax = '1234567';  
    insert acc;
    
    /*Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
    Opportunity opp =new Opportunity();
    opp.Accountid= acc.id;
    opp.Name ='Test3';
    opp.Type ='Other';
    opp.Clusters__c = '005';
    opp.Exchange_Offering_Type__c ='Private Exchange';
    opp.Primary_Closed_Reason__c ='Reputation of selected carrier';
    opp.StageName ='Won';
    opp.Requested_Effective_Date__c = system.today();    
    opp.Expected_Health_Members__c = 2;
    opp.HCSC_Division__c = 'IL';
    opp.CloseDate = system.today();
    opp.RFI_RFP_Received_Date__c = system.today();
    Opp.Probability = 100.00;
    Opp.recordTypeId = oppRecordTypeId;
    insert opp;  /*
     
    /*product2 prod = new product2();
    prod.name = 'BlueCard';    
    insert prod; 
    
     Opportunity_Product__c OppProd = New Opportunity_Product__c();
     OppProd.Product__c =prod.Id;
     OppProd.Funding_Type__c ='ACAP';
     OppProd.Opportunity_Name__c = opp.id;
     insert OppProd;*/
     
         Case caseObj = new case();
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        caseObj.status = 'New';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
       // caseObj.Opportunity_Name__c = OppProd.id;
        insert caseObj;    
        apexpages.currentpage().getparameters().put('id',caseObj.id);
      ApexPages.StandardController stdController   = new ApexPages.StandardController(caseObj);
    GEMS_OpportunityProductInfoController gems = new GEMS_OpportunityProductInfoController (stdController);
     
 
   }
  }