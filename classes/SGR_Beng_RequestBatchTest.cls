@Istest
public class SGR_Beng_RequestBatchTest {
 Public static testmethod void Validte_sgrBengRequest(){
        try{
            
             Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', 
                                         Renewal_Date__c = date.today(),status__c = 'Active', Hold_End_Date__c =date.today(),
                                         Funding_Type__c='PREM',Product_Type__c='H',Market_Segment__c='SG',SGR_Hold_Reason__c='1st Year Renewal');
                                         
     insert newAccount1;
     
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Sent_Via_Mail_to_Producer__c = false;
        opp.Primary_Closed_Reason__c ='Political';
        opp.Distribute_Via_Mail_to_Producer__c=true;
        opp.Distribute_Via_Mail_to_Account__c  = true;
        opp.Sent_Via_Mail_to_Account__c=false;
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = UserInfo.getuserid();
        opp.Rating_Status__c = 'Actuarial-Released';
        insert opp;
     
            Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
            Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
            Test.starttest();
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSgr_bng()); 
                SGR_Beng_Schedule_RequestBatch sh1 = new SGR_Beng_Schedule_RequestBatch();
                String sch = '0 0 2 * * ?'; 
                system.schedule('Send Beng Request', sch, sh1);
            Test.stoptest();
        }
        catch(exception ex){
            System.debug('Exception while running test class ###: '+ex.getmessage());
        }
    }
}