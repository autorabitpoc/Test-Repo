@isTest
private class SGR_AccRenwCopyMemberBenefitsHelperTest {
    
    @testSetup static void setup() {
        Plan__c plan =  new Plan__c(Name = 'DILLR07', Marketing_Plan_Number__c = 'DILLR07');

        insert plan;

        Account newAccount1 = new Account(Name='TarunFinalTest',
                                                external_ID__c ='1992', 
                                                HCSC_Division__c = 'IL', 
                                                Renewal_Date__c = date.today(),status__c = 'Active', 
                                                Market_Segment__c='SG',Funding_Type__c='PREM',
                                                Product_Type__c='H', hold_end_date__c=Date.today()-1, 
                                                SGR_Hold_Reason__c='1st Year Renewal');
                                            
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;

        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.Id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Renewal_Date__c=date.today();
        opp.Assigned_UW__c = Userinfo.getUserId();
        opp.recordTypeId=SGR_AccountRenewalsHelper_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');

        oplist.add(opp);

        insert oplist;

        SGR_Account_Plan_Rate__c planRate0 =  new SGR_Account_Plan_Rate__c(     Type__c = SGR_URE_RatingOption.CURRENT_PLAN_TYPE,   
                                                                                Group_Account__c = newAccount1.Id,
                                                                                Plan__c = plan.Id);

        insert planRate0;

        SGR_Opportunity_Plan_Rate__c planRate1 =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test-DILLR07', 
                                                                                Type__c = SGR_URE_RatingOption.CURRENT_PLAN_TYPE,   
                                                                                Opportunity__c = opp.Id,
                                                                                Marketing_Plan_ID__c = 'DILLR07' ,
                                                                                Plan__c = plan.Id);

        SGR_Opportunity_Plan_Rate__c planRate2 =  new SGR_Opportunity_Plan_Rate__c(Name = 'Test-DILLR07', 
                                                                                Type__c = SGR_URE_RatingOption.RENEWING_PLAN_TYPE,  
                                                                                Opportunity__c = opp.Id,
                                                                                Marketing_Plan_ID__c = 'DILLR07' ,
                                                                                Plan__c = plan.Id);

        List<SGR_Opportunity_Plan_Rate__c> opptyPlanRatelist = new List<SGR_Opportunity_Plan_Rate__c>();

        opptyPlanRatelist.add(planRate1);
        opptyPlanRatelist.add(planRate2);


        SGR_Account_Census__c oppcen1 = new SGR_Account_Census__c();
        list<SGR_Account_Census__c> opBenList1 = new list<SGR_Account_Census__c>();
        oppcen1.Name = 'Test Census';
        oppcen1.Account__c = newAccount1.Id;
        oppcen1.Member_Cancel_Date__c = date.today().AddDays(30);
        oppcen1.Member_Effective_Date__c = date.today().AddDays(-10);

        insert oppcen1;

        SGR_Account_Member_Benefit__c mbs = new SGR_Account_Member_Benefit__c();
       // mbs.Name='demo34Cloned';
        mbs.Account__c = newAccount1.Id;
        mbs.Marketing_Plan_Number__c = 'DILLR07';
        mbs.Account_Census__c = oppcen1.Id;
       // mbs.SGR_Plan_Rate_Account__c = planRate0.id;
        mbs.Member_Policy_Tier__c = 'ES';
        insert mbs;
        
        SGR_Account_Member_Benefit__c mbs2 = new SGR_Account_Member_Benefit__c();
       // mbs2.Name='demo34Cloned2';
        mbs2.Account__c = newAccount1.Id;
        mbs2.Marketing_Plan_Number__c = 'DILLR07';
        mbs2.Account_Census__c = oppcen1.Id;
       // mbs2.SGR_Plan_Rate_Account__c=planRate0.id;
        mbs2.Member_Policy_Tier__c = 'EO';
        insert mbs2;

        SGR_Account_Member_Benefit__c mbs3 = new SGR_Account_Member_Benefit__c();
       // mbs3.Name='demo34Cloned3';
        mbs3.Account__c = newAccount1.Id;
        mbs3.Marketing_Plan_Number__c = 'DILLR07';
        mbs3.Account_Census__c = oppcen1.Id;
       // mbs3.SGR_Plan_Rate_Account__c=planRate0.id;
        mbs3.Member_Policy_Tier__c = 'EC';
        insert mbs3;

        insert opptyPlanRatelist;
    }

    @isTest static void CanCreateMemberBenefitsForCurrentPlan() {
        Set<Id> accountIdSet = new Set<Id>();

        for(Account acc : [SELECT Id FROM ACCOUNT]) {
            accountIdSet.add(acc.Id);
        }

        System.assertEquals(1, accountIdSet.size());

        List<Opportunity> oppty = [SELECT Id FROM Opportunity];

        System.assertEquals(1, oppty.size());

        SGR_AccRenewalCopyMemberBenefitsHelper.InsertOpportunitiesMemberBenefit(accountIdSet, oppty, 'error');

        List<SGR_Opportunity_Member_Benefits__c> opptyPlanRates = [SELECT Id FROM SGR_Opportunity_Member_Benefits__c 
                                                                    WHERE Opportunity_Plan_Rate__r.Plan__r.Marketing_Plan_Number__c = 'DILLR07'];
        System.debug('+++opptyPlanRates'+opptyPlanRates);
        System.assertEquals(6, opptyPlanRates.size()); 
    }
    
    
}