/**************************************************************************************
  Apex Class Name     : GEMS_FSUClaimsReturnStatusPagectrl_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_FSUClaimsReturnStatusPageController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_FSUClaimsReturnStatusPagectrl_TEST{
    private static testmethod void GEMS_FSUClaimsReturnStatusPagectrl_TEST1(){
    
     Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
         ApexPages.currentPage().getParameters().put('Id',subRec.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(subRec);
        GEMS_FSUClaimsReturnStatusPageController g = new GEMS_FSUClaimsReturnStatusPageController(sc);
 

        g.selectedStatus ='Return';
        g.addRow();
        g.showReturnReasonBlock();
        g.saveStatus();
        g.setSelectedStatus();
        g.cancel();
        g.getMyOptions();
      //  g.displayReturnReason=true;
       // g.selectedCaseIds='ABS';
       
        //g.scopeCode='ABS';
        //g.benefitCode='ABS';
        
         PageReference pageRef = Page.GEMSGetPage;
             Test.setCurrentPage(pageRef);
    
    }
}