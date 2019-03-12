@isTest
public class GEMS_ScreeningCaseDocScreeningCont_test {
private static testmethod void GEMSScreeningCaseDocumentScreeningCont() {
        Case caseObj = new case();
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseObj.GEMS_ReviewDocuments__c =false;
        caseObj.GEMS_Return_Check__c = false;
        caseObj.GEMS_Approve__c =false;
        caseObj.GEMS_Return__c =false;
        caseObj.GEMS_Routed_In_Error__c = false;
        caseObj.status = 'New';
        //caseObj.GEMS_Account_Submission_Info__c = '';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
        //caseObj.Opportunity_Name__c ='Benfield Medical';
        insert caseObj; 
    ApexPages.StandardController stdController   = new ApexPages.StandardController(caseObj);
    /*GEMSScreeningCaseDocumentScreeningCont gems = new GEMSScreeningCaseDocumentScreeningCont(stdController);
    gems.getItems();
    gems.getScreeningStatus();
    gems.setScreeningStatus('pass');
    gems.setScreeningStatus('approve');
    gems.setScreeningStatus('Routed In Error');
    gems.setScreeningStatus('return');
    gems.saveScreeningDetails();
    gems.dispositionCheck();*/
  
   
   }
  }