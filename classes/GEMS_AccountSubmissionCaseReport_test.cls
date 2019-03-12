@isTest
public class GEMS_AccountSubmissionCaseReport_test {    
    /* using SeeAllData as the Class being tested uses a Report and Custom Setting */    
    @isTest(SeeAllData='true')
    public static void testcaseReportDetailsMethod(){
        List<Case> returnList = new List<Case>();
           returnList = GEMS_AccountSubmissionCaseReport.caseReportDetails();
    }
}