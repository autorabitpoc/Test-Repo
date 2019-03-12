@isTest
public class SGR_ViewOppBAControllerTest {

    @testSetup
    public static void setup() {
        List<Plan__c> plans = insertPlans();
        List<Account> accs = insertAccs();
        List<Opportunity> opps = insertOpps(accs);
        List<Benefit_Agreement__c>ba = insertBA(accs);
        List<SGR_Opportunity_Group_Section__c> sgs = insertOgs(opps);
        List< Group_Section__c> gs = insertgs(accs);


        SGR_Opportunity_Benefit_Agreement__c BAgree = insertOBAs(opps, plans);
        List<SGR_Opportunity_Census__c> cs = insertCen(opps);
    }

    @isTest
    public static void testGetOppBAList() {


        Opportunity o = [Select Id from Opportunity LIMIT 1];
        List<String> accs = SGR_ViewOppBAController.initiaterefresh(o.id);
        List<SGR_Opportunity_Benefit_Agreement__c> obaList = SGR_ViewOppBAController.getOppBAList(o.Id, 'Renewal_Date__c', 'ASC');
        System.assert(!obaList.isEmpty());
        //System.assertEquals('Test4', obaList.get(0).Benefit_Agreement_Number__c);
    }

    @isTest
    public static void testGetOppBAListWithInvalidQuery() {
        Opportunity o = [Select Id from Opportunity LIMIT 1];
        Boolean excepThrown = false;
        try {


            List<SGR_Opportunity_Benefit_Agreement__c> obaList = SGR_ViewOppBAController.getOppBAList(o.Id, 'Renewal_Date__c', 'PSC');
        } catch (AuraHandledException e) {
            excepThrown = true;
        }
        System.assert(excepThrown);

    }

    @IsTest
    static void testGetOpp() {
        Account a = new Account();
        a.Name = 'Test';
        a.HCSC_Division__c = 'IL';
        a.Market_Segment__c = 'SG';
        a.Funding_Type__c = 'ACAP';
        a.Renewal_Date__c = Date.today();
        a.Hold_End_Date__c = Date.today() - 1;
        a.SGR_Hold_Reason__c = '1st Year Renewal';
        insert a;
        User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'test@test.com',
                Username = 'test@test.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
        );
        insert u;
        Opportunity opp = new Opportunity();
        opp.AccountId = a.Id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Primary_Closed_Reason__c = 'Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = Date.today().addDays(-1);
        opp.CloseDate = Date.today().addDays(2);
        opp.OwnerId = u.Id;
        opp.Assigned_UW__c = u.Id;
        opp.Rating_Status__c = 'Sold';
        insert opp;
        Opportunity testOpp = null;
        Test.startTest();
        System.runAs(u) {
            testOpp = SGR_ViewOppBAController.getOppData(opp.Id);
        }
        Test.stopTest();
        System.assertNotEquals(testOpp, null);
    }


    public static List<Account> insertAccs() {
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name = 'TestAcc1', External_Id__c = 'A1234', Market_Segment__c = 'SG', hold_end_date__c = Date.today() - 1, SGR_Hold_Reason__c = '1st Year Renewal'));
        accs.add(new Account(Name = 'TestAcc2', External_Id__c = 'A5678', Market_Segment__c = 'SG', hold_end_date__c = Date.today() - 1, SGR_Hold_Reason__c = '1st Year Renewal'));
        insert accs;
        return accs;
    }
    public static List<Opportunity> insertOpps(List<Account> accs) {
        Id prodRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();


        List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(AccountId = accs.get(0).Id, Name = 'Oppty1', RecordTypeId = prodRecId, StageName = 'Triggered', CloseDate = System.today().addYears(2), Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c = 'Rated', Subscribers_Count__c = 4, Health_Count__c = 44, Dental_Count__c = 55));
        insert opps;
        return opps;
    }
    public static List<Benefit_Agreement__c> insertBA(List<Account> accs) {


        List<Benefit_Agreement__c> baa = new List<Benefit_Agreement__c>();
        baa.add(new Benefit_Agreement__c(Group_Account__c = accs.get(0).Id, Funding_Type__c = 'COST'));
        insert baa;
        return baa;
    }
    public static List<Group_Section__c> insertgs(List<Account> accs) {


        List<Group_Section__c> gaa = new List<Group_Section__c>();
        gaa.add(new Group_Section__c(Group_Account__c = accs.get(0).Id, Group_Number__c = '12345'));
        insert gaa;
        return gaa;
    }

    public static SGR_Opportunity_Benefit_Agreement__c insertOBAs(List<Opportunity> opps, List<Plan__c> plans) {
        List<SGR_Opportunity_Benefit_Agreement__c> obas = new List<SGR_Opportunity_Benefit_Agreement__c>();
        obas.add(new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c = 'Test4', Opportunity__c = opps.get(0).id, Plan1__c = plans.get(0).Id, Renewal_Date__c = System.today().addMonths(1)));
        obas.add(new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c = 'Test2', Opportunity__c = opps.get(0).id, Plan1__c = plans.get(1).Id, Renewal_Date__c = System.today().addMonths(2)));
        obas.add(new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c = 'Test3', Opportunity__c = opps.get(0).id, Plan1__c = plans.get(1).Id, Renewal_Date__c = System.today().addMonths(3)));
        obas.add(new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c = 'Test1', Opportunity__c = opps.get(0).id, Plan1__c = plans.get(0).Id, Renewal_Date__c = System.today().addMonths(4)));
        obas.add(new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c = 'Test4', Opportunity__c = opps.get(0).id, Plan1__c = plans.get(0).Id, Renewal_Date__c = System.today().addMonths(1)));

        obas.add(new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c = 'Test5', Opportunity__c = opps.get(0).id, Include_BA__c = false, Plan1__c = plans.get(1).Id, Renewal_Date__c = System.today().addMonths(5)));
        insert obas;
        return obas[0];
    }

    public static List<SGR_Opportunity_Group_Section__c> insertOgs(List<Opportunity> opps) {
        List<SGR_Opportunity_Group_Section__c> ogs = new List<SGR_Opportunity_Group_Section__c>();
        ogs.add(new SGR_Opportunity_Group_Section__c(Opportunity__c = opps.get(0).id, Group_Name__c = '12345'));

        insert ogs;
        return ogs;
    }

    public static List<Plan__c> insertPlans() {
        List<Plan__c> plans = new List<Plan__c>();
        plans.add(new Plan__c(Description__c = 'Plan1', Plan_Sales_ID__c = 'Plan1', Marketing_Plan_Number__c = 'MPlan1', Line_Of_Business__c = 'H'));
        plans.add(new Plan__c(Description__c = 'Plan2', Plan_Sales_ID__c = 'Plan2', Marketing_Plan_Number__c = 'MPlan2', Line_Of_Business__c = 'H'));
        insert plans;
        return plans;
    }

    @isTest
    public static void testGetbAgsList() {


        SGR_Opportunity_Benefit_Agreement__c b = [Select Id,Opportunity__c from SGR_Opportunity_Benefit_Agreement__c LIMIT 1];
        SGR_Opportunity_Benefit_Agreement__c b1 = [Select Id from SGR_Opportunity_Benefit_Agreement__c where Include_BA__c = false LIMIT 1];
        //List<String> bags=SGR_ViewOppBAController.initiaterefresh(b.id);
        List<SGR_Opportunity_Group_Section__c> bgsList = SGR_ViewOppBAController.getbaGSList(b.Id);
        //  System.assert(!bgsList.isEmpty());
        SGR_ViewOppBAController.updateBARecord(b);
        SGR_ViewOppBAController.updateBARecord(b1);
        SGR_ViewOppBAController.getratingStatus(b.Opportunity__c);
        SGR_ViewOppBAController.getloggedinuserinfo();


    }

    @isTest
    public static void Testgslist() {

        Opportunity o = [Select Id from Opportunity LIMIT 1];
        map<id, list<SGR_Opportunity_Group_Section__c>> balist = SGR_ViewOppBAController.getOppGSList(o.Id, 'Renewal_Date__c', 'ASC');

    }


    public static List<SGR_Opportunity_Census__c> insertCen(List<Opportunity> opps) {


        List<SGR_Opportunity_Census__c> baa = new List<SGR_Opportunity_Census__c>();
        baa.add(new SGR_Opportunity_Census__c(Opportunity__c = opps[0].Id, Relationship__c = 'Subscriber', Health_Plan_ID__c = 'MPlan1', Zip_Code__c = '12345', Gender__c = 'M'));
        insert baa;
        return baa;
    }


    /*Ravi*
   
    
    
    /*@isTest
public static void testGetOppVLList() {

Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
List<Opportunity> opp = new List<Opportunity>();
opp.add(new Opportunity(Name='Testvl',StageName='Prospecting',CloseDate=date.today(),RecordTypeId = sgrProdOpp ));
insert opp;

Opportunity o = [select Id from opportunity where Name='Testvl'];
List<Business_Rule_Validation_Log__c> vl = new List<Business_Rule_Validation_Log__c>();
vl.add(new Business_Rule_Validation_Log__c(Name='Test',OpportunityId__c= o.Id ));
insert vl;


//List<String> accs=SGR_ViewOppBAController.initiaterefresh(o.id);
List<Business_Rule_Validation_Log__c> obaList = SGR_ViewOppBAController.getOppVLList(o.Id);
System.assert(!obaList.isEmpty());
//System.assertEquals('Test4', obaList.get(0).Benefit_Agreement_Number__c);
}*/


}