@istest
public class REST_UCRKafkaUpdate_Test{
    
    @isTest
    public static void testHttpPost() {
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='LG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.Projected_Dental_Members__c = 23456;
        insert a;
        
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.AccountId = a.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        oplist.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.AccountId = a.id;
        opp1.Name = 'Sample';
        opp1.StageName = 'lost';
        opp1.Product_Type__c='H';
        opp1.Primary_Closed_Reason__c ='Political';
        opp1.Closed_Comments__c = 'XYZ';
        opp1.Date_Closed__c = date.today().adddays(-1);
        opp1.CloseDate = date.today().adddays(2);
        oplist.add(opp1);
        insert oplist;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UCRKafkaUpdate'; //Request URL
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;
        
        //String AccountNumber = '987456321';
        String AccountNumber = 'AD1234';
        String OpportunityId = 'Opp1234';
        String CorrespondanceId = 'Co12344';
        String failMessage = 'Request process failed';
        String FailureStatus = 'FAILURE';
        
        Test.startTest();
        List<account> acclist = new List<account>();
        String ide = oplist[0].id;
        String opportunityId1 = '0064D000004HnsiQAC';
        REST_UCRKafkaUpdate.updateOpportuniy(AccountNumber,ide,CorrespondanceId);
        acclist = REST_UCRKafkaUpdate.getAccounts(AccountNumber);
        oplist = REST_UCRKafkaUpdate.getOpportunities(opportunityId1);
        // REST_UCRKafkaUpdate.updateOpportuniy(AccountNumber,ide,CorrespondanceId);
        
        REST_UCRKafkaUpdate.UCRKafkaSFResponse response = new REST_UCRKafkaUpdate.UCRKafkaSFResponse();
        response.Message = failMessage;
        response.Status = FailureStatus;
        Test.stopTest();
    }
    
}