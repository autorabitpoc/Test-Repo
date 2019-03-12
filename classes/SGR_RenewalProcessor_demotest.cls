@isTest(SeeAllData=false)
public class SGR_RenewalProcessor_demotest{
    public static testmethod void testmethod1(){
        List<string> divisions = new List<String>{'IL','OK','TX'};
            
        String fundingType='PREM';
        String marketSegment='SG';
        String renewEffDateStr='2020-01-01';
        String renewEffDate='2020-01-01';
        String renType='Production';
        String division='IL';
        test.startTest();
        SGR_RenewalProcessor.initiateRenewalForBatch(divisions,marketSegment,fundingType,renewEffDateStr,renType);
        SGR_RenewalProcessor.initiateRenewalForOnDemand(division,'12345',renType,fundingType,marketSegment,renewEffDate);
        test.stopTest();
    }
}