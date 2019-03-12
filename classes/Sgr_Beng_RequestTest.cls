@isTest
public class Sgr_Beng_RequestTest {
    Public static testmethod void Validte_sgrBengRequest(){
       try{
           Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
            Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
            opportunity opp = new opportunity();
            Account newAccount1 = new Account(Name='TarunFinalTest',External_ID__c ='1992', HCSC_Division__c = 'IL', 
                                         Renewal_Date__c = date.today(),status__c = 'Active', Hold_End_Date__c =date.today(),
                                         Funding_Type__c='PREM',Product_Type__c='H',Market_Segment__c='SG',SGR_Hold_Reason__c='1st Year Renewal');
                                           
            insert newAccount1;
        
            opp.Accountid = newAccount1.id;
            opp.Name = 'Sample';
            opp.StageName = 'lost';
            opp.Product_Type__c='H';
            opp.Primary_Closed_Reason__c ='Political';
            opp.Closed_Comments__c = 'XYZ';
            opp.Date_Closed__c = date.today().adddays(-1);
            opp.CloseDate = date.today().adddays(2);
            opp.Assigned_UW__c = UserInfo.getuserid();
            opp.Rating_Status__c = 'Actuarial-Released';
            insert opp;
            Test.starttest();
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSgr_bng()); 
                Sgr_Beng_Request.SendRequest(opp.id,'DRAFT',null);
            Test.stoptest();
       }
        catch(exception ex){
           System.debug('Exception while running test class ###: '+ex.getmessage());
        }
    }
}