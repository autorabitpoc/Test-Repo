@isTest
public class GEMS_CustomCaseLookupControllerTest {

private static testmethod void GEMS_CustomCaseLookupController1() {
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Case accStrcaserec = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        accStrcaserec.accountId = acc.id;
       accStrcaserec.GEMS_Submission_Type__c ='Renewal';
        Case accSubcaserec = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');

        insert accSubcaserec;
        accStrcaserec.parentid= accSubcaserec.GEMS_Account_Submission_Info__c;
        insert accStrcaserec;
        
        PageReference pageRef = Page.GEMSCustomCaseLookup;
        Test.setCurrentPage(pageRef);         
        ApexPages.currentpage().getParameters().put('caseId', accSubcaserec.id);
        ApexPages.currentpage().getParameters().put('lksrch', 'test');
        ApexPages.StandardController std = new ApexPages.standardController(accSubcaserec);
        GEMS_CustomCaseLookupController caseContr= new GEMS_CustomCaseLookupController(std);
        
}
}