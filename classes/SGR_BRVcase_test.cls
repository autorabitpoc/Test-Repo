@isTest
public class SGR_BRVcase_test {

    @isTest static void BRVcase_test(){
        
       
          List<Opportunity> opps = new List<Opportunity>();
        
        Opportunity opp1 = new Opportunity();
        
       opp1.StageName='Triggered';
        opp1.SGR_Workflow_Activity__c='UW Review - Validation Errors';
       opp1.CloseDate=date.today();
        opp1.Name='Test VSR 9/9/2020 Analytical';
        opps.add(opp1);
        insert opps;
            system.debug('++++++++'+opps);
        SGR_BRValidationCaseService sr ;
       // sr.createCases(opps);
            
    
        
       
    }
}