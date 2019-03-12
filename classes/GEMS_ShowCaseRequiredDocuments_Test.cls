@isTest
public class GEMS_ShowCaseRequiredDocuments_Test {

    public static testmethod void testMethod1() {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        insert subCaseRec;
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_ShowCaseSubmissionRequiredDocuments phTaskctrl= new GEMS_ShowCaseSubmissionRequiredDocuments(std);
     }
}