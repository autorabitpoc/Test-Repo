@Istest
public with sharing class Sgr_Beng_PreviewPDFTest {
  Public static testmethod void Validte_sgrBengRequest(){
      Beng_PDF_Preview_profiles__c cs = Beng_PDF_Preview_profiles__c.getValues(UserInfo.getProfileId());
        opportunity opp = new opportunity();
             Account newAccount1 = new Account(Name='TarunFinalTest',External_ID__c ='1992', HCSC_Division__c = 'IL', 
                                         Renewal_Date__c = date.today(),status__c = 'Active', Hold_End_Date__c =date.today(),
                                         Funding_Type__c='PREM',Product_Type__c='H',Market_Segment__c='SG',SGR_Hold_Reason__c='1st Year Renewal');
                                           
             insert newAccount1;
        
            opp.Accountid = newAccount1.id;
            opp.Name = 'Sample';
            opp.StageName = 'lost';
            opp.Product_Type__c='H';
            //opp.Rating_Status__c = 'Underwriting-Released'
            opp.Primary_Closed_Reason__c ='Political';
            opp.Closed_Comments__c = 'XYZ';
            opp.Date_Closed__c = date.today().adddays(-1);
            opp.CloseDate = date.today().adddays(2);
            opp.Assigned_UW__c = UserInfo.getuserid();
            opp.Rating_Status__c = 'Actuarial-Released';
            insert opp;
            
            Beng_PDF_Preview_profiles__c custS = new Beng_PDF_Preview_profiles__c(SetupOwnerId=UserInfo.getProfileId());
            insert custS;
            system.debug('+++custS'+custS );
            SGR_Beng_XML_Response xmlResponse = new SGR_Beng_XML_Response();
            Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
            Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
            Test.starttest();
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSgr_bng()); 
                
                Sgr_Beng_PreviewPDF.getOppData(opp.id);
                Sgr_Beng_PreviewPDF.oppDetails(opp.id,'DRAFT' ,'Account',newAccount1.External_ID__c);
                SGR_Beng_XML_Input inp = new SGR_Beng_XML_Input();

            Test.stoptest();
    }
}