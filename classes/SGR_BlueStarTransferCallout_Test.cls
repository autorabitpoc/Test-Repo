@isTest(SeeAlldata = false)
public class SGR_BlueStarTransferCallout_Test {
    
    @testSetup 
    public static void setupData() {
        Profile prof = [select id from profile where name='SGR UW User'];
        
        system.debug('****'+prof);
        User u = new User(
            Alias = 'sTest', 
            Email='Tetr@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Tering1',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = prof.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='Ostusu@testorg.com'
        );
        List<Account> accList = new List<Account>();
        Account a = new Account(Name = 'Test Account', hold_end_date__c = date.today().addMonths(-3), HCSC_Division__c='IL', Market_Segment__c='SG', 
                                Funding_Type__c='PREM', Renewal_Date__c = date.Today(), Product_Type__c='H', AccountNumber = '12345',
                                External_ID__c='124343');
        accList.add(a);
        Account a1 = new Account(Name = 'Test Account1', hold_end_date__c = date.today().addMonths(-3), HCSC_Division__c='IL', Market_Segment__c='SG', 
                                 Funding_Type__c='PREM', Renewal_Date__c = date.Today(), Product_Type__c='H', AccountNumber = '123456' );
        accList.add(a1);
        insert accList;
        
        Id sgrProdOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = a.id;
        opp.Name = 'Sample Opp';
        opp.SGR_Renewal_Account_Name__c='STORYLINE RENOVATIONS, LLC';
        opp.HCSC_Division__c = 'IL';
        opp.Funding_Type__c = 'PREM';
        opp.Account_Market_Segment__c ='SG';
        opp.StageName = 'Triggered';
        opp.Renewal_Date__c = System.today().addDays(4);
        opp.CloseDate = System.today().addMonths(1);
        opp.RecordTypeId = sgrProdOppRecTypeId;
        opp.Rating_Status__c = 'Sold';
        opp.Assigned_UW__c = userinfo.getuserid();
        
        opportunity opp1 = new opportunity();
        opp1.Accountid = a1.id;
        opp1.Name = 'Sample Opp';
        opp1.SGR_Renewal_Account_Name__c='STORYLINE RENOVATIONS, LLC';
        opp1.HCSC_Division__c = 'IL';
        opp1.Funding_Type__c = 'PREM';
        opp1.Account_Market_Segment__c ='SG';
        opp1.StageName = 'Triggered';
        opp1.Renewal_Date__c = System.today().addDays(4);
        opp1.CloseDate = System.today().addMonths(1);
        opp1.RecordTypeId = sgrProdOppRecTypeId;
        opp1.Rating_Status__c = 'Sold';
        opp1.Assigned_UW__c = userinfo.getuserid();
        oplist.add(opp1); 
        
        insert oplist;
		
        
        List<Plan__c> plans = new List<Plan__c>();
        Plan__c PPOPlan = new Plan__c(name='Plan1',Network__c='PPO');
        plans.add(PPOPlan);
        
        Plan__c HMOPlan = new Plan__c(name='Plan1',Network__c='HMO');
        plans.add(HMOPlan);
        insert plans;
        List<SGR_Opportunity_Plan_Rate__c> planRateRecs = new List<SGR_Opportunity_Plan_Rate__c>();                                                                       
        SGR_Opportunity_Plan_Rate__c planRate1 = new SGR_Opportunity_Plan_Rate__c(Name='Plan Rate1', Opportunity__c=opp.id, Type__c='Renewal', Plan__c=PPOPlan.Id); 
        planRate1.Marketing_Plan_ID__c = 'SPSG15BCASTXO';
        planRate1.Plan_Status__c = 'Sold';
        planRateRecs.add(planRate1);
        SGR_Opportunity_Plan_Rate__c planRate2 = new SGR_Opportunity_Plan_Rate__c(Name='Plan Rate2', Opportunity__c=opp.id, Type__c='Renewal', Plan__c=HMOPlan.Id);                                                                         
        planRateRecs.add(planRate2);
        insert planRateRecs;
        
    }
    
    Public static testmethod void Validte_BlueSTARRequest(){
        try{
            Set<Id> oppIds = new Set<Id>();
            
            Opportunity o =[Select id,Account_Market_Segment__c from Opportunity Limit 1];
            oppIds.add(o.id);
            system.debug('o in Test Class method Validte_BlueSTARRequest():::::'+o);
            Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');          
            Test.starttest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSGR_blueStar()); 
            SGR_BlueStarTransferCallout.sendPlanOrRateChangeReqListToBStar(oppIds);
            SGR_BlueStarTransferCallout.isValidOpp(o); 
            SGR_BlueStarTransferCallout sgrCallout = new SGR_BlueStarTransferCallout();
            sgrCallout.createXMLDoc(o);
            Case c = SGR_BlueStarTransferCallout.getBlueStarCaseDefaultsByOpportunity(o);
            
            Test.stoptest();
        }
        catch(exception ex){
            System.debug('Exception while running test class : '+ex.getmessage());
        }
    }
    Public static testmethod void parseResponseXMLTest(){
        string responseBody=
            '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
            '<soap:Body>'+
            '<ns2:executeResponse xmlns:ns2="http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/">'+
            '<AutomatedPlanChangeServiceResponse>'+  
            '<corpEntCd>TX1</corpEntCd>'+     
            '<acctNbr>219371</acctNbr>'+     
            '<opportunityId>317789</opportunityId>'+     
            '<modNbr>0</modNbr>'+    
            '<rtSzUpdateTxt>account rtSzCd not updated</rtSzUpdateTxt>'+    
            '<planResponses>'+   
            '<planResponse>' +     
            '<mktgPlnNbr>SPSG15BCASTXO</mktgPlnNbr>'+         
            '<planExecutedSuccessFully>Y</planExecutedSuccessFully>'+        
            '<grpSectTab/>'+        
            '<messagesList>' +      
            '<message>'+           
            '<msgTxt>Benefit Agreement Number 0002 has been successfully Approved.</msgTxt>'+             
            '</message>'+          
            '</messagesList>'+      
            '</planResponse>'+  
            '</planResponses>'+  
            '</AutomatedPlanChangeServiceResponse>'+ 
            '</ns2:executeResponse>'+  
            '</soap:Body>'+ 
            '</soap:Envelope>';
        Test.startTest();
        SGR_BlueStarTransferCallout.parseResponseXML(responseBody); 
        Test.stopTest();
    }
    Public static testmethod void invalidOpp(){
        List<Opportunity> o =[Select id,Account_Market_Segment__c,Renewal_Date__c,SGR_Renewal_Account_Name__c,HCSC_Division__c,
                        Assigned_UW__c from Opportunity Limit 2];
        Test.startTest();
        SGR_BlueStarTransferCallout.isValidOpp(o[0]);
        Test.stopTest();
    }
    
}