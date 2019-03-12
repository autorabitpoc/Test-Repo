@isTest
public class SGR_CaseReassignment_Test {

    testmethod static void testWorkflowActivityUpdate() {
        Test.startTest();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Prospecting';
        o.CloseDate = Date.today();
        o.Primary_Closed_Reason__c ='Political';
        insert o;
        List<Case> cases = new List<Case>();
        Case c = new Case();
        c.Opportunity_Name__c = o.Id;
        cases.add(c);
        insert cases;
        SGR_CaseReassignment.submitCaseToGroupVerifier(cases);
        Opportunity o2 = [Select Id, SGR_Workflow_Activity__c FROM Opportunity WHERE Id = :c.Opportunity_Name__c];
        Test.stopTest();
        System.assertEquals('Group Verifier Review - BlueSTAR Transfer', o2.SGR_Workflow_Activity__c);
    }
}