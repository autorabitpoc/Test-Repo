@isTest
public class SGR_AccoutsHoldBatchTest {

    static  testmethod void testmethod1() {
        
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
            
            List<Account> acc=new List<Account>();
            //acc= SGR_AccontsHoldBatch.start();
        	//SGR_AccontsHoldBatch.execute();
        	//SGR_AccontsHoldBatch.finish();
            
            test.stopTest();
        }
        
    }