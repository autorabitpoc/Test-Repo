@isTest
public class GEMS_ShowCaseSubReqDoctest {
private static testmethod void GEMS_ShowCaseSubmissionRequiredDocuments(){

       
        Case caseObj = new case();
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseObj.GEMS_ReviewDocuments__c =false;
        caseObj.GEMS_Return_Check__c = false;
        caseObj.HCSC_Division__c = 'TX';
        caseObj.GEMS_Submission_Type__c ='New Account';
        caseObj.GEMS_Products__c ='Traditional';
        caseObj.Funding_Type__c ='ASO';
        caseObj.GEMS_Approve__c =false;
        caseObj.GEMS_Return__c =false;
        caseObj.GEMS_Routed_In_Error__c = false;
        caseObj.status = 'New';
        //caseObj.GEMS_Account_Submission_Info__c = '';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
        insert caseObj;
        
    List<Case> caseRec =[Select ID from case];
    System.assertEquals(1,caseRec.Size());
    
       
        Test.startTest();
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id);          
        ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
        GEMS_ShowCaseSubmissionRequiredDocuments gems = new GEMS_ShowCaseSubmissionRequiredDocuments(stdController);
         Test.stopTest();


}
}