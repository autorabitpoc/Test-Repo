@IsTest
public class SGRCensusWidgetLtngControllerTest {

    @TestSetup
    static void setup(){
        Account a= new Account();
        a.Name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=Date.today();
        a.Hold_End_Date__c=Date.today()-1;
        a.SGR_Hold_Reason__c='1st Year Renewal';
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
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = Date.today().addDays(-1);
        opp.CloseDate = Date.today().addDays(2);
        opp.OwnerId=u.Id;
        opp.Assigned_UW__c=u.Id;
        opp.Rating_Status__c='Sold';
        opp.RecordTypeId = getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        insert opp;
        Plan__c pln = new Plan__c(Name='Test',Marketing_Plan_Number__c='1111000001010');
        insert pln;
        SGR_Opportunity_Benefit_Agreement__c opBA = new SGR_Opportunity_Benefit_Agreement__c(Name='Test',Opportunity__c = opp.Id,Plan1__c=pln.id);
        insert opBA;
        SGR_Opportunity_Census__c oppCenA = createOppCensus(opp.Id, a.Id, 1);
        oppCenA.Relationship__c = 'Subscriber';
        oppCenA.Subscriber_Number__c = 1234;
        oppCenA.Membership_Number__c = 1;
        List<SGR_Opportunity_Census__c> oppsList = new List<SGR_Opportunity_Census__c>();
        oppsList.add(oppCenA);
        SGR_Opportunity_Census__c oppCenb = createOppCensus(opp.Id, a.Id, 2);
        oppCenb.Relationship__c = 'Child';
        oppCenb.Subscriber_Number__c = 1234;
        oppCenb.Membership_Number__c = 2;
        oppsList.add(oppCenb);
        insert oppsList;
        SGR_Country_State_Mapping__c csm = new SGR_Country_State_Mapping__c();
        csm.Name = 'IL';
        csm.State_Code__c = 'IL';
        insert csm;
    }

    @IsTest
    static void testGetEditCapabilitiesMap(){
        User u = getUser();
        Map<String, Boolean> testMap = null;
        Test.startTest();
        System.runAs(u){
            testMap = SGRCensusWidgetLtngController.getEditCapabilitiesMap(getOppId());
        }
        Test.stopTest();
        System.assertNotEquals(testMap, null);
    }

    @IsTest
    static void testGetOpportunity(){
        User u = getUser();
        Opportunity testOpp = null;
        Test.startTest();
        System.runAs(u){
            testOpp = SGRCensusWidgetLtngController.getOpportunity(getOppId());
        }
        Test.stopTest();
        System.assertNotEquals(testOpp, null);
    }

    @IsTest
    static void testGetCensusListForOpportunity(){
        User u = getUser();
        List<SGR_Opportunity_Census__c> testList = null;
        Test.startTest();
        System.runAs(u){
            testList = SGRCensusWidgetLtngController.getCensusListForOpportunity(getOppId());
        }
        Test.stopTest();
        System.assertNotEquals(testList, null);
    }

    @IsTest
    static void testGetStateList(){
        User u = getUser();
        List<SGR_Country_State_Mapping__c> testList = null;
        Test.startTest();
        System.runAs(u){
            testList = SGRCensusWidgetLtngController.getStateList();
        }
        Test.stopTest();
        System.assertNotEquals(testList, null);
    }

    @IsTest
    static void testFetchAllPlanData(){
        User u = getUser();
        List<SGRPlanInfoWrapper> testList = null;
        Test.startTest();
        System.runAs(u){
            testList = SGRCensusWidgetLtngController.fetchAllPlanData(getOppId());
        }
        Test.stopTest();
        System.assertNotEquals(testList, null);
    }

    @IsTest
    static void testIsDeleteDisabled(){
        User u = getUser();
        Boolean testBool = false;
        Opportunity opp = [SELECT Id, Rating_Status__c FROM Opportunity WHERE Name = 'Sample'];
        Test.startTest();
        System.runAs(u){
            testBool = SGRCensusWidgetLtngController.isDeleteDisabled(opp);
        }
        Test.stopTest();
        System.assertEquals(testBool, true);
    }

    @IsTest
    static void testSaveCensusSub(){
        User u = getUser();
        Boolean testBool = false;
        Opportunity opp = [SELECT Id, Rating_Status__c, CurrentUserProfileName__c, Renewal_Date__c, HCSC_Division__c FROM Opportunity WHERE Name = 'Sample'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test'];
        SGR_Opportunity_Census__c testOpp = createOppCensus(opp.Id, acc.Id, 8);
        testOpp.Relationship__c = 'Subscriber';
        testOpp.Subscriber_Number__c = 12345;
        testOpp.Membership_Number__c = 1;
        Test.startTest();
        System.runAs(u){
            testBool = SGRCensusWidgetLtngController.saveCensus(testOpp, null, null, opp, 'health');
        }
        Test.stopTest();
        System.assertEquals(testBool, true);
    }

    @IsTest
    static void testSaveCensusDep(){
        User u = getUser();
        Boolean testBool = false;
        Opportunity opp = [SELECT Id, Rating_Status__c FROM Opportunity WHERE Name = 'Sample'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test'];
        SGR_Opportunity_Census__c testOpp = createOppCensus(opp.Id, acc.Id, 8);
        testOpp.Relationship__c = 'Subscriber';
        testOpp.Subscriber_Number__c = 12345;
        testOpp.Membership_Number__c = 1;
        insert testOpp;
        List<SGR_Opportunity_Census__c> oppList = new List<SGR_Opportunity_Census__c>();
        oppList.add(testOpp);
        SGR_Opportunity_Census__c testOppB = createOppCensus(opp.Id, acc.Id, 9);
        testOppB.Relationship__c = 'Child';
        testOppB.Subscriber_Number__c = 12345;
        testOppB.Membership_Number__c = 2;
        oppList.add(testOppB);
        Test.startTest();
        System.runAs(u){
            testBool = SGRCensusWidgetLtngController.saveCensus(testOpp, testOppB, oppList, opp, 'health');
        }
        Test.stopTest();
        System.assertEquals(testBool, true);
    }

    @IsTest
    static void testDeleteOptyCensusAH(){
        testDeleteOptyCensusA('Health');
    }

    @IsTest
    static void testDeleteOptyCensusBH(){
        testDeleteOptyCensusB('Health');
    }

    @IsTest
    static void testDeleteOptyCensusCH(){
        testDeleteOptyCensusC('Health');
    }

    @IsTest
    static void testDeleteOptyCensusAD(){
        testDeleteOptyCensusA('Dental');
    }

    @IsTest
    static void testDeleteOptyCensusBD(){
        testDeleteOptyCensusB('Dental');
    }

    @IsTest
    static void testDeleteOptyCensusCD(){
        testDeleteOptyCensusC('Dental');
    }

    static void testDeleteOptyCensusA(String type){
        User u = getUser();
        Map<String, String> testMap = null;
        Opportunity opp = [SELECT Id, Rating_Status__c FROM Opportunity WHERE Name = 'Sample'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test'];
        SGR_Opportunity_Census__c testOpp = createOppCensus(opp.Id, acc.Id, 8);
        testOpp.Relationship__c = 'Subscriber';
        testOpp.Subscriber_Number__c = 12345;
        testOpp.Membership_Number__c = 1;
        insert testOpp;
        List<Id> idList = new List<Id>();
        idList.add(testOpp.Id);
        Test.startTest();
        System.runAs(u){
            testMap = SGRCensusWidgetLtngController.deleteOptyCensus(idList, type);
        }
        Test.stopTest();
        System.assertNotEquals(null, testMap);
    }

    static void testDeleteOptyCensusB(String type){
        User u = getUser();
        Map<String, String> testMap = null;
        Opportunity opp = [SELECT Id, Rating_Status__c FROM Opportunity WHERE Name = 'Sample'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test'];
        SGR_Opportunity_Census__c testOpp = createOppCensus(opp.Id, acc.Id, 8);
        testOpp.Relationship__c = 'Subscriber';
        testOpp.Subscriber_Number__c = 12345;
        testOpp.Membership_Number__c = 1;
        SGR_Opportunity_Census__c testOppB = createOppCensus(opp.Id, acc.Id, 9);
        testOppB.Relationship__c = 'Child';
        testOppB.Subscriber_Number__c = 12345;
        testOppB.Membership_Number__c = 2;
        List<SGR_Opportunity_Census__c> oppList = new List<SGR_Opportunity_Census__c>();
        oppList.add(testOpp);
        oppList.add(testOppB);
        insert oppList;
        List<Id> idList = new List<Id>();
        for(SGR_Opportunity_Census__c oppId : oppList){
            idList.add(oppId.Id);
        }
        Test.startTest();
        System.runAs(u){
            testMap = SGRCensusWidgetLtngController.deleteOptyCensus(idList, type);
        }
        Test.stopTest();
        System.assertNotEquals(null, testMap);
    }

    static void testDeleteOptyCensusC(String type){
        User u = getUser();
        Map<String, String> testMap = null;
        Opportunity opp = [SELECT Id, Rating_Status__c FROM Opportunity WHERE Name = 'Sample'];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test'];
        List<SGR_Opportunity_Census__c> oppList = new List<SGR_Opportunity_Census__c>();
        SGR_Opportunity_Census__c testOppB = createOppCensus(opp.Id, acc.Id, 9);
        testOppB.Relationship__c = 'Child';
        testOppB.Subscriber_Number__c = 12345;
        testOppB.Membership_Number__c = 2;
        oppList.add(testOppB);
        SGR_Opportunity_Census__c testOppC = createOppCensus(opp.Id, acc.Id, 10);
        testOppC.Relationship__c = 'Child';
        testOppC.Subscriber_Number__c = 12345;
        testOppC.Membership_Number__c = 3;
        oppList.add(testOppC);
        SGR_Opportunity_Census__c testOppD = createOppCensus(opp.Id, acc.Id, 10);
        testOppD.Relationship__c = 'Child';
        testOppD.Subscriber_Number__c = 12345;
        testOppD.Membership_Number__c = 3;
        oppList.add(testOppD);
        insert oppList;
        List<Id> idList = new List<Id>();
        for(SGR_Opportunity_Census__c oppId : oppList){
            idList.add(oppId.Id);
        }
        Test.startTest();
        System.runAs(u){
            testMap = SGRCensusWidgetLtngController.deleteOptyCensus(idList, type);
        }
        Test.stopTest();
        System.assertNotEquals(null, testMap);
    }

    static String getOpptyRecordTypeIds(String ObjectName,String recTypeName){
        Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobalDescribe() ;
        Schema.SObjectType SchemaObject = mapSchemaobject.get(ObjectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = SchemaObject.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        System.debug(':::RECTYPE:::'+recordTypeId);
        return recordTypeId;

    }

    static Id getOppId(){
        Opportunity opp = [SELECT Id, Rating_Status__c, CurrentUserProfileName__c, Renewal_Date__c, HCSC_Division__c FROM Opportunity WHERE Name = 'Sample'];
        return opp.Id;
    }

    static User getUser(){
        return [SELECT Id FROM User WHERE Email = 'test@test.com'];
    }

    static SGR_Opportunity_Census__c createOppCensus(id optyid,id accountID,integer i){
        SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c();
        oppcen.Name ='testOppCen_'+i;
        oppcen.Opportunity__c = optyid;
        oppcen.Account__c = accountId;
        oppcen.Health_Plan_ID__c = '1111';
        oppcen.Dental_Plan_ID__c = '2222';
        oppcen.Vision_Plan_ID__c = '3333';
        oppcen.Zip_Code__c='1234';
        oppcen.Gender__c='F';
        return oppcen;
    }
}