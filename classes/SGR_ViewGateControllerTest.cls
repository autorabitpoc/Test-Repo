@isTest
public class SGR_ViewGateControllerTest { 
    
    @testSetup 
    public static void setup() {
        insertAccs();
        insertGate();
        insertOpps();
    }
    
    @isTest
    public static void testGetRelatedOpportunities() {
        Test.startTest();
        Actuary_Gate__c g = [Select Id from Actuary_Gate__c WHERE Division__c='IL' LIMIT 1][0];
        List<Opportunity> oppsList = SGR_ViewGateController.getRelatedOpportunities(g.id, 10, 'Renewal_Date__c','asc');
        Test.stopTest();
        System.assertEquals(2, oppsList.size());
    }

    @isTest
    public static void testGetRelOppsCount() {   
        Test.startTest();
        Actuary_Gate__c g1 = [Select Id from Actuary_Gate__c WHERE Division__c='IL' LIMIT 1][0];
        SGR_ViewGateController.getRelOppsCount(g1.id);
        Actuary_Gate__c g2 = [Select Id, OppCount__c from Actuary_Gate__c LIMIT 1][0];
        Test.stopTest();
        System.assertEquals(2, g2.OppCount__c);
    }
    @isTest
    public static void testGetRelOppsCountWithEmptyGate() { 
                    
            Test.startTest();
            Actuary_Gate__c g = [Select Id, OppCount__c from Actuary_Gate__c WHERE Division__c='OK' LIMIT 1][0];
            SGR_ViewGateController.getRelOppsCount(g.id);
            
            Test.stopTest();
            System.assertEquals(0, g.OppCount__c);
         
    }
    
    @isTest
    public static void testGetRelOppsCountWithInvalidGate() { 
        try {
            
            Test.startTest();           
            SGR_ViewGateController.getRelOppsCount('SomeInvalidGateId');            
            Test.stopTest();
        } catch(Exception e) {
            System.Assert(e.getMessage()!=null);
        } 
    }
/****** Added by Akhi *******/
    @isTest
    public static void tesprocessSelectedOpty() { 
        try {
            
            Test.startTest(); 
        Id prodRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        
       
         List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(Name='Oppty1', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(2),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55 , Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty2', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55 , Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty3', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(1),Renewal_Date__c = System.Today().addMonths(5), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55 , Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty4', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(1), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55 , Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty5', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(-3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55 , Assigned_UW__c = Userinfo.getUserId()));
        insert opps;
            SGR_ViewGateController.processSelectedOptys(opps);            
            Test.stopTest();
        } catch(Exception e) {
            System.Assert(e.getMessage()!=null);
        } 
    }
    
      public static testmethod void tesSelectedOpty() { 
        try {
            
            Test.startTest(); 
        Id prodRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        
       
         List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(Name='Oppty1', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(2),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty2', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty3', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(1),Renewal_Date__c = System.Today().addMonths(5), Rating_Status__c='Some Rating Status', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty4', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(1), Rating_Status__c='Actuarial-Released', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55,Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty5', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(-3), Rating_Status__c='Released', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55,Assigned_UW__c = Userinfo.getUserId()));
        insert opps;
        SGR_ViewGateController.getSelectedOpty(new List<Id>{opps[0].Id,opps[1].Id});
            
                      
            Test.stopTest();
        } catch(Exception e) {
            System.Assert(e.getMessage()!=null);
        } 
    }
    
    /************Akhil End ************/
    
    /****** Added by Saurav *******/
    @isTest
    public static void testliftGate() { 
        try {
            
            Test.startTest(); 
        Id prodRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        
        List<Actuary_Gate__c> gates = new List<Actuary_Gate__c>();
        gates.add(new Actuary_Gate__c(Division__c='IL',OppCount__c=0,Funding_Type__c='PREM',Status__c='Down',Market_Segment__c='SG', Effective_Date__c=System.Today().addMonths(-5)));
        insert gates;
        
         List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(Name='Test VSR1', RecordTypeId=analyRecId, StageName='Qualify', CloseDate= System.today().addYears(2),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated',Gate__c=gates[0].Id, Assigned_UW__c = Userinfo.getUserId() ));
        opps.add(new Opportunity(Name='Oppty2', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated',Gate__c=gates[0].Id, Assigned_UW__c = Userinfo.getUserId() ));
        opps.add(new Opportunity(Name='Oppty3', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(1),Renewal_Date__c = System.Today().addMonths(5), Rating_Status__c='Some Rating Status',Gate__c=gates[0].Id, Assigned_UW__c = Userinfo.getUserId() ));
        opps.add(new Opportunity(Name='Oppty4', RecordTypeId=prodRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(1), Rating_Status__c='Actuarial-Released',Gate__c=gates[0].Id, Assigned_UW__c = Userinfo.getUserId() ));
        opps.add(new Opportunity(Name='Oppty5', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(-3), Rating_Status__c='Released',Gate__c=gates[0].Id, Assigned_UW__c = Userinfo.getUserId() ));
        insert opps;
        
            SGR_ViewGateController.liftGate(gates[0].Id);            
            Test.stopTest();
        } catch(Exception e) {
            System.Assert(e.getMessage()!=null);
        } 
    }
    
    @isTest
    public static void testgetGateStatus() { 
                    
            Test.startTest();
            Actuary_Gate__c g = [Select Id, OppCount__c from Actuary_Gate__c WHERE Division__c='OK' LIMIT 1][0];
            SGR_ViewGateController.getGateStatus(g.id);
            
            Test.stopTest();
            System.assertEquals(0, g.OppCount__c);
         
    }
    @isTest
    public static void testGateStatus() { 
                    
            Test.startTest();
            Actuary_Gate__c g = [Select Id, OppCount__c from Actuary_Gate__c WHERE Division__c='OK' LIMIT 1];        	
            SGR_ViewGateController.GateStatus(g.id);
            
            Test.stopTest();
            System.assertEquals(0, g.OppCount__c);
         
    }
     /************Saurav End ************/
    
    
    public static void insertAccs() {
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name='TestAcc1', External_Id__c='A1234',Market_Segment__c='SG',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal'));
        accs.add(new Account(Name='TestAcc2', External_Id__c='A5678',Market_Segment__c='SG',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal'));
        insert accs;
    }
    public static void insertOpps() {
        Id prodRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        Actuary_Gate__c g1 =[SELECT Id from Actuary_Gate__c where Division__c='IL' LIMIT 1];
        Actuary_Gate__c g2 =[SELECT Id from Actuary_Gate__c where Division__c='OK' LIMIT 1];
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(Name='Oppty1', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(2),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Gate__c=g1.Id, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty2', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c='Rated', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Gate__c=g1.Id, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty3', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(1),Renewal_Date__c = System.Today().addMonths(5), Rating_Status__c='Some Rating Status', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Gate__c=g2.Id, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty4', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(1), Rating_Status__c='Actuarial-Released', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Gate__c=g1.Id, Assigned_UW__c = Userinfo.getUserId()));
        opps.add(new Opportunity(Name='Oppty5', RecordTypeId=analyRecId, StageName='Triggered', CloseDate= System.today().addYears(3),Renewal_Date__c = System.Today().addMonths(-3), Rating_Status__c='Released', Subscribers_Count__c=4, Health_Count__c=44, Dental_Count__c=55, Gate__c=g2.Id, Assigned_UW__c = Userinfo.getUserId()));
        insert opps;
    }
    public static void insertGate() {
        List<Actuary_Gate__c> gates = new List<Actuary_Gate__c>();
        gates.add(new Actuary_Gate__c(Division__c='IL', OppCount__c=0,Funding_Type__c='PREM',Status__c='Down',Market_Segment__c='SG', Effective_Date__c=System.Today().addMonths(-5)));
        gates.add(new Actuary_Gate__c(Division__c='OK', OppCount__c=0,Funding_Type__c='PREM',Status__c='Down',Market_Segment__c='SG', Effective_Date__c=System.Today().addMonths(-4)));
        insert gates;
    }    
}