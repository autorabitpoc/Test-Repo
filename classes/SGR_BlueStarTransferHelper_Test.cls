@isTest(SeeAlldata = false)
public class SGR_BlueStarTransferHelper_Test {
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
                                 Funding_Type__c='PREM', Renewal_Date__c = date.Today(), Product_Type__c='H', AccountNumber = '123456',
                                External_ID__c='125656');
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
        opp.Type = 'Renewal';
        opp.Workflow_System_Status__c = 'Ready to Send to BlueSTAR';
        opp.Assigned_UW__c = userinfo.getuserid();
        oplist.add(opp); 
       
        insert opp;
        
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
    Public static testmethod void helperTest(){
        Opportunity o =[Select AccountId,Account.Name,SGR_Account_Number__c, Renewal_Date__c, Opportunity_Number__c, Rating_Status__c,SGR_Opportunity_Auto_Number__c,
                        SGR_Workflow_Activity__c,Assigned_UW__c,Assigned_UW__r.EmployeeNumber, Account_Market_Segment__c,HCSC_Division__c,SGR_Renewal_Account_Name__c,
                        (Select Plan__c, Opportunity__c,Marketing_Plan_ID__c, Mapping_From_Plan_Id__c, Invitro_TX_only__c,Is_HSA__c, Type__c,
                         Plan_Status__c,Coverage_Type__c,Health_Rating_Area_Number__c,Rate_Size_Code__c From Opportunity_Plan_Rates__r                         
                        )
                        From Opportunity                       
                        LIMIT 1];
        system.debug('o:::::'+o.Opportunity_Plan_Rates__r);
         Test.startTest();
        SGR_BlueStarTransferRequest input = new SGR_BlueStarTransferRequest();
        SGR_BlueStarTransferRequest.opportunityDetails oppTransferDetails = new SGR_BlueStarTransferRequest.opportunityDetails();//initialized
        list<SGR_BlueStarTransferRequest.plan> oppPlans = new list<SGR_BlueStarTransferRequest.plan>();
		SGR_BlueStarTransferRequest.plan planreq =new SGR_BlueStarTransferRequest.plan();
        SGR_BlueStarTransferHelper sgrBlueStarHelpercon = new SGR_BlueStarTransferHelper();
        SGR_BlueStarTransferHelper sgrBlueStarHelper = new SGR_BlueStarTransferHelper(o);
        sgrBlueStarHelper.convertInputToRequest();
        Test.stopTest();
        // sgrBlueStarHelper.
    }
}