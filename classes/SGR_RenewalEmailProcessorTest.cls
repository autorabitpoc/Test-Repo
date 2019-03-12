@isTest
public class SGR_RenewalEmailProcessorTest {
    private static testmethod void emailTest(){
        
        List<SGRRenewalBatch__c> renewals = new List<SGRRenewalBatch__c>(); 
        
            SGRRenewalBatch__c ren1 = Sgr_TestDataUtility.createRenewalBatch1('SGR Ren1', '1234', 'Analytical', 'IL', 'SG', 'PREM', 10);
            SGRRenewalBatch__c ren2 = Sgr_TestDataUtility.createRenewalBatch1('SGR Ren2', '1235', 'Analytical', 'OK', 'SG', 'PREM', 100);
            SGRRenewalBatch__c ren3 = Sgr_TestDataUtility.createRenewalBatch1('SGR Ren3', '1236', 'Analytical', 'TX', 'SG', 'PREM', 200);
            renewals.add(ren1);
            renewals.add(ren2);
            renewals.add(ren3);
            
            List<Id> renewalIds = new List<Id>{ren1.Id, ren2.Id, ren3.Id};
            SGR_RenewalEmailProcessor.sendRenewalEmail(renewalIds);
            SGR_RenewalEmailProcessor.sendFinalRenewalEmail(10, '1234');
            SGR_RenewalEmailProcessor.sendFinalRenewalEmail(10, '1234');
            SGRRenewalBatch__c ren4 = Sgr_TestDataUtility.createRenewalBatch1('SGR Ren1', '12345', 'Production', 'IL', 'SG', 'PREM', 10);
            SGRRenewalBatch__c ren5 = Sgr_TestDataUtility.createRenewalBatch1('SGR Ren2', '12357', 'Production', 'OK', 'SG', 'PREM', 100);
            
            renewals.add(ren4);
            renewals.add(ren5);
            
            Insert renewals;
            List<Id> renewalIds1 = new List<Id>{ren3.Id, ren4.Id};
            SGR_RenewalEmailProcessor.sendRenewalEmail(renewalIds1);
            SGR_RenewalEmailProcessor.sendFinalRenewalEmail(10, '12357');
          SGRRenewalBatch__c ren6 = Sgr_TestDataUtility.createRenewalBatch();
            List<Id> renewalIds2 = new List<Id>{ren6.Id};
            SGR_RenewalEmailProcessor.sendRenewalEmail(renewalIds2);
            SGR_RenewalEmailProcessor.sendFinalRenewalEmail(10, ren6.BatchID__c);
    }
}