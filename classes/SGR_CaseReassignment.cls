//Author: Landry Harris
//Story: SFDC-15112
//Purpose: To serve as an extension to the Submit Case to Group Verifier flow and update the workflow activity of the related opportunity
public class SGR_CaseReassignment {
    
    @InvocableMethod
    public static void submitCaseToGroupVerifier(List<Case> cases) {
        List<Id> oppIds = new List<Id>();
        boolean isUpdateNecessary = false;
        for (Case c: cases) {
            if (c.Opportunity_Name__c != null) {
                oppIds.add(c.Opportunity_Name__c);
            }
        }
        if (oppIds.size() > 0) {
            List<Opportunity> opps = [Select Id, SGR_Workflow_Activity__c FROM Opportunity Where Id IN :oppIds];
            
            if (opps.size() > 0) {
                for (Opportunity o: opps) {
                    if (o.SGR_Workflow_Activity__c != 'Group Verifier Review - BlueSTAR Transfer') {
                        o.SGR_Workflow_Activity__c = 'Group Verifier Review - BlueSTAR Transfer';
                        isUpdateNecessary = true;
                    }
                }
                if (isUpdateNecessary) {
                    update opps;
                }      
            } 
        } 
    }
}