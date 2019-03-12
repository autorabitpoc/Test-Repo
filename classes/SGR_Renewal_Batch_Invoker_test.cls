@isTest
public class SGR_Renewal_Batch_Invoker_test {
    
    static  testmethod void testmethod1() {
        try {
            Account a = new Account();
            a.Name ='Test';
            a.HCSC_Division__c='IL';
            a.Market_Segment__c='FEP';
            a.Funding_Type__c='ACAP';
            a.Renewal_Date__c=date.today();
            insert a;
            
            List<String> divisions;
            String marketSegment;
            String fundingType;
            String renewEffDate;
            String renType;
            String returnMsg;
            divisions=new List<String>{'IL'};
                marketSegment='FEP';
            fundingType='ACAP';
            renewEffDate ='2018-09-10';
            renType='Production';
            
            
            test.startTest();
            
            
            SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, renewEffDate, renType);
            
            test.stopTest();
        }
        
        catch(Exception e)
            
        {
            
            Boolean expectedExceptionThrown =  e.getMessage().contains('Entered Criteria Resulted 0 records') ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, false);
            
        }
        
        
    }
    
}