@isTest
public class SGR_UWHoldAccountTest {
    
    static testmethod  void testmethod1()
    {
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Status__c='Active';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.hold_end_date__c=date.today();
        a.SGR_Hold_Reason__c='Wage & Tax Audit';
        insert a;
        
         Test.startTest();
               SGR_UWHoldAccount uc=new SGR_UWHoldAccount();
                 String s='0 39 16 * * ? ';
                Id jobid=System.Schedule('Myjob',s,uc);
        Test.stopTest();

}
}