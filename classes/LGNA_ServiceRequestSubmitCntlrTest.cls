/**************************************************************************************
  Apex Class Name     : LGNA_ServiceRequestSubmitCntlr 
  Version             : 1.0
  Function            : This is Test Class for LGNA_ServiceRequestSubmitCntlr
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       10/17/2017                Original Version
*************************************************************************************/
@isTest
public class LGNA_ServiceRequestSubmitCntlrTest {
  static  Account testAccount,testAccount1;
    static Service_Request__c srequest,srequest1;
    static
    {
     // List<CaseSubmitButtonController.TeamMemberWrapper> testwrapper;
     Id srRecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('Open Enrollment').getRecordTypeId();
        
        testAccount = new Account();
        testAccount.Ceded__c = true;
        testAccount.HCM_Program_Model__c = 'BCC Elite';
        testAccount.Funding_Type__c = 'PREM';
        testAccount.Cobra_Administration_Type__c = 'HCSC';
        testAccount.Exchange_Account__c = true;
        testAccount.Exchange_Name__c = 'Mercer Marketplace';
        testAccount.Sliced__c = true;
        
        testAccount.Current_Risk_Level__c = '3 - Medium';
        testAccount.Status__c = 'Active';
        testAccount.Critical_Account__c = True;
        testAccount.Risk_Reason__c = 'Test';
        testAccount.HCSC_Division__c = 'TX';
        testAccount.Account_Cluster_Name__c = 'John Testing';
        testAccount.Account_Executive_2__c = 'Jane Testing';
        testAccount.Underwriter_User_ID__c = 'UU456';
        testAccount.Name='Test Account Today'; 

        srequest = new Service_Request__c();
        srequest.Stage__c= 'New'; 
    srequest.Status__c= 'In Progress';
    srequest.Account__c=testAccount.Id;
        srequest.RecordTypeId =srRecordTypeId;
        insert srequest;
    }
  static testMethod void testdetailpage() {
    PageReference testPage=Page.LGNA_ServiceRequestSubmit;
      Test.setCurrentPage(testPage);
      ApexPages.currentPage().getParameters().put('id',srequest.Id);
      LGNA_ServiceRequestSubmitCntlr controller = new LGNA_ServiceRequestSubmitCntlr(new ApexPages.StandardController(srequest));
     controller.SubmitFunction();
    }
}