@isTest
public class Sgr_displayCensus_Test {
   
    public static List<Profile> objProfile = [Select Id, Name from Profile where Name = 'SGR Actuary User' OR Name = 'SGR UW User']; 
   
    
    public static testmethod  void testmethod1()
    {
        List<Account> lstAcc= new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.hold_end_date__c=Date.today()-1;
        a.SGR_Hold_Reason__c='1st Year Renewal';
        insert a;
        Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount11 = new Account(Name='ABC',external_ID__c ='123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList1 = new List<Account>();
        accList1.add(newAccount11);
        insert accList1;
        User u = [select id,firstname from user where id=:userinfo.getuserid()];
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount11.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.OwnerId=u.Id;
        opp.Assigned_UW__c=userInfo.getuserId();
        opp.RecordTypeId=Sgr_displayCensus_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opp);
        insert oplist;  
        SGR_Opportunity_Census__c oppC = createOppCensus(opp.id,newAccount11.Id,1) ;  
        oppC.Relationship__c='Subscriber';
        oppC.Subscriber_Number__c=50;
        insert oppC;
        list<SGR_Opportunity_Census__c> opCenList = new list<SGR_Opportunity_Census__c>();
        opCenList.add(createOppCensus(opp.id,newAccount11.Id,1));
        opCenList.add(createOppCensus(opp.id,newAccount11.Id,2));
        opCenList.add(createOppCensus(opp.id,newAccount11.Id,3));
        Insert opCenList;
        opCenList[0].Relationship__c = 'Spouse';
        opCenList[0].Dental_Plan_ID__c='534';
        opCenList[0].Subscriber_Number__c=50;
        update opCenList;
        SGR_Opportunity_Group_Section__c opGS =  new SGR_Opportunity_Group_Section__c(Name='test',Opportunity__c=opp.id,Opportunity_Group_Number__c='123112');
        insert opGS;
        Test.startTest();
        Sgr_displayCensus.OppCensus(opp.id,'Vision');
        Sgr_displayCensus.showSubscribersAndDependents(opp.id,'Dental');
        //Sgr_displayCensus.saveOptyCensus(opCenList,'Dental',opp.id);
        Group_Section__c gs = new Group_Section__c(Group_Account__c=newAccount11.Id,Group_Section_Number__c=123);
        insert gs;
        //Sgr_displayCensus.getCensusFields(opp.id,50);
        system.debug('+++opGS'+opGS);
        SGR_Opportunity_Plan_Rate__c plR = new SGR_Opportunity_Plan_Rate__c();
        plR.Name='Testo';
        plR.opportunity__c=opp.id;
        plR.Group_Section__c=opGS.id;
        insert plR;
        String nam = [select id,name,Opportunity_Group_Section_Number__c from SGR_Opportunity_Group_Section__c limit 1].Opportunity_Group_Section_Number__c;
        Sgr_displayCensus.getActiveOppBA(opp.id);
        Sgr_displayCensus.refreshCensusData(opp.id);
        Sgr_displayCensus.OppHeader(opp.id);
        Test.stopTest();
    }
    public static SGR_Opportunity_Census__c createOppCensus(id optyid,id accountID,integer i){
        SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c();
        oppcen.Name ='testOppCen_'+i;
        oppcen.Opportunity__c = optyid;
        oppcen.Account__c = accountId;
        oppcen.Relationship__c = 'Subscriber';
        oppcen.Vision_Plan_ID__c='234';
        oppcen.Zip_Code__c='1234';
        oppcen.Gender__c='F';
        
        SGR_Opportunity_Census__c oppcen6 = new SGR_Opportunity_Census__c(Name ='OppCen6', Opportunity__c = optyid, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2212);
        //Sgr_displayCensus.saveOppCensus(oppcen6,'Dental','HgroupNumberSelected','HgroupSectionSelected','DgroupNumberSelected','DgroupSectionSelected','VgroupNumberSelected','VgroupSectionSelected');
        Plan__c pln = new Plan__c(Name='Test',Marketing_Plan_Number__c='1111000001010');
        insert pln;
        SGR_Opportunity_Benefit_Agreement__c opBA = new SGR_Opportunity_Benefit_Agreement__c(Name='Test',Opportunity__c = optyid,Plan1__c=pln.id);
        insert opBA;
        Sgr_displayCensus.getPlanIds(optyid);
        Sgr_displayCensus.getStates(optyid);
        //Sgr_displayCensus.getMemberBenefit(oppcen6.ID);
        //Sgr_displayCensus.getMemberBenefitData(oppcen6.ID);
        
        return oppcen;
    }
    public static testmethod  void testmethod2(){
        
        Account newAccount11 = new Account(Name='ABC',external_ID__c ='123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList1 = new List<Account>();
        accList1.add(newAccount11);
        insert accList1;
        User u = [select firstname from user where id=:userinfo.getuserid()];
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount11.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.OwnerId=U.Id;
        opp.Assigned_UW__c=userInfo.getuserId();
        opp.RecordTypeId=Sgr_displayCensus_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opp);
        insert oplist;        
        list<SGR_Opportunity_Census__c> opCenList = new list<SGR_Opportunity_Census__c>();
        opCenList.add(createOppCensus(opp.id,newAccount11.Id,1));
        opCenList.add(createOppCensus(opp.id,newAccount11.Id,2));
        opCenList.add(createOppCensus(opp.id,newAccount11.Id,3));
        Insert opCenList;
        opCenList[0].Relationship__c = 'Spouse';
        update opCenList;
        Test.startTest();
        Sgr_displayCensus.showSubscribersAndDependents(opp.id,'Vision');
        SGR_Opportunity_Census__c oppcen6 = new SGR_Opportunity_Census__c(Name ='OppCen6', Opportunity__c = opp.Id, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2212);
        Sgr_displayCensus.saveOppCensus(oppcen6,'Vision');
        Sgr_displayCensus.CountSpouseOrDpExists(opp.id,1,'subsciber');
        Sgr_displayCensus.CensuValidation(opp.id);
        Test.stopTest();
     } 
    //vijaya SFDC-13011, SFDC-13046 Start
    public static testmethod  void DeleteEnabled(){
       //objProfile = [Select Id, Name from Profile where Name = 'SGR Actuary User' OR Name = 'SGR UW User'];
        
       User userRec = new User(alias = 'standt',
          email='standarduser@testorg.com',
          emailencodingkey='UTF-8',
          lastname='Testing', 
          languagelocalekey='en_US',
          localesidkey='en_US',
          profileid = objProfile[0].id,//profiles.get('Standard User'),
          timezonesidkey='America/Los_Angeles',
          username='standarduser11@testClass.com');
          
       User userRec1 = new User(alias = 'standt1',
          email='standarduser1@testorg.com',
          emailencodingkey='UTF-8',
          lastname='Testing1', 
          languagelocalekey='en_US',
          localesidkey='en_US',
          profileid = objProfile[1].id,
          timezonesidkey='America/Los_Angeles',
          username='standarduser101@testClass.com');
       
       List<User> userList = new List<User>{userRec, userRec1};
       insert userList;
   
       //String user = userRec.Id;
       User u = [select id,firstname from user where id=:userinfo.getuserid()];
       Opportunity opp = new opportunity( Name = 'Opty', Rating_status__c='Rated', StageName = 'lost', Primary_Closed_Reason__c ='Political', Closed_Comments__c = 'XYZ',  Date_Closed__c = date.today().adddays(-1), CloseDate = date.today().adddays(2),OwnerId=u.Id,Assigned_UW__c=userInfo.getuserId());
       insert opp;
       Opportunity opp1 = new opportunity( Name = 'Opty1', Rating_status__c='Sold', StageName = 'lost', Primary_Closed_Reason__c ='Political', Closed_Comments__c = 'XYZ',  Date_Closed__c = date.today().adddays(-1), CloseDate = date.today().adddays(2),OwnerId=u.id,Assigned_UW__c=userInfo.getuserId());
       insert opp1;
       Sgr_displayCensus.isDeleteEnabled(opp.id);
       Sgr_displayCensus.isDeleteEnabled(opp1.id);
       System.runas(userRec){//new user(id = UserInfo.getUserId())){
         Sgr_displayCensus.isDeleteEnabled(opp1.id);
         Sgr_displayCensus.isDeleteEnabled(opp.id);
        }
        System.runas(userRec1){//new user(id = UserInfo.getUserId())){
         Sgr_displayCensus.isDeleteEnabled(opp1.id);
         Sgr_displayCensus.isDeleteEnabled(opp.id);
        }
        SGR_Opportunity_Census__c oppcen1 = new SGR_Opportunity_Census__c(Name = 'OppCen1', Row__c='1',Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Subscriber', Vision_Plan_ID__c='123', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=1111);
        insert oppcen1;
        SGR_Opportunity_Census__c oppcen2 = new SGR_Opportunity_Census__c(Name = 'OppCen2',Row__c= '1', Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Child', Vision_Plan_ID__c='123', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=1111);
        Sgr_displayCensus.saveCensusRecord(oppcen2,oppcen1.Id,'Vision');
    }
    public static testmethod void deleteOptyCensus(){
      
        Account acc = Sgr_TestDataUtility.createAcc('Acc');
        User u = [select id,firstname from user where id=:userinfo.getuserid()];
        Opportunity opp = Sgr_TestDataUtility.createOptyRec(acc.Id,'Sold');
            opp.OwnerId=u.Id;
            insert opp; 
            Sgr_Opportunity_Census__c optyCen = Sgr_TestDataUtility.OptyCensus(111, 'Subscriber', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen1 = Sgr_TestDataUtility.OptyCensus(111, 'Spouse', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen2 = Sgr_TestDataUtility.OptyCensus(111, 'Child', opp.Id, acc.Id);
            optyCen2.Vision_Plan_ID__c = '';
            optyCen2.Health_Plan_ID__c = '';
            Sgr_Opportunity_Census__c optyCen3 = Sgr_TestDataUtility.OptyCensus(222, 'Subscriber', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen4 = Sgr_TestDataUtility.OptyCensus(222, 'Spouse', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen5 = Sgr_TestDataUtility.OptyCensus(222, 'Child', opp.Id, acc.Id);
            optyCen3.Dental_Plan_ID__c = '';
            Sgr_Opportunity_Census__c optyCen6 = Sgr_TestDataUtility.OptyCensus(333, 'Subscriber', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen7 = Sgr_TestDataUtility.OptyCensus(333, 'Spouse', opp.Id, acc.Id);
            optyCen7.Dental_Tier__c = '';
            Sgr_Opportunity_Census__c optyCen8 = Sgr_TestDataUtility.OptyCensus(222, 'Subscriber', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen9 = Sgr_TestDataUtility.OptyCensus(222, 'Spouse', opp.Id, acc.Id);
            Sgr_Opportunity_Census__c optyCen10 = Sgr_TestDataUtility.OptyCensus(222, 'Child', opp.Id, acc.Id);
            optyCen8.Health_Plan_ID__c = '';
            optyCen8.Vision_Plan_ID__c = '';
        List<Sgr_Opportunity_Census__c> oppCensus = new List<Sgr_Opportunity_Census__c>{optyCen,optyCen1,optyCen2,optyCen3,optyCen4,optyCen5,optyCen6,optyCen7,optyCen8,optyCen9,optyCen10};
            upsert oppCensus;            
        List<Id> optyCensusIds = new List<Id>{optyCen2.Id};
        User userRec = new User(alias = 'standt',
          email='standarduser@testorg.com',
          emailencodingkey='UTF-8',
          lastname='Testing', 
          languagelocalekey='en_US',
          localesidkey='en_US',
          profileid = objProfile[0].id,//profiles.get('Standard User'),
          timezonesidkey='America/Los_Angeles',
          username='standarduser11@testClass.com');
        insert userRec;
        System.runas(userRec){
            Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Dental');
        }
        optyCensusIds.clear();
        optyCensusIds.add(optyCen8.Id); 
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Dental');    
        
        optyCensusIds.clear();
        optyCensusIds.add(optyCen4.Id); 
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Dental');
        
        optyCensusIds.clear();
        optyCensusIds.add(optyCen4.Id);
        optyCensusIds.add(optyCen7.Id);
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Health');
        
        optyCensusIds.clear();
        optyCensusIds.add(optyCen4.Id);
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Health');
        
        optyCensusIds.clear();
        optyCensusIds.add(optyCen1.Id);
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Health');
        optyCensusIds.clear();
        optyCensusIds.add(optyCen3.Id);
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Health');
        optyCensusIds.clear();
        optyCensusIds.add(optyCen6.Id);
        Sgr_displayCensus.deleteOptyCensus(optyCensusIds, 'Health'); 
        Sgr_displayCensus.saveCensusRecord(optyCen1,optyCen.Id,'Dental');  
        
    }
     public static testmethod void saveCensusRecord(){
        
        User u = [select firstname from user where id=:userinfo.getuserid()];
         Opportunity opp = new opportunity( Name = 'Opty2', Rating_status__c='Sold', StageName = 'lost', Primary_Closed_Reason__c ='Political', Closed_Comments__c = 'XYZ',  Date_Closed__c = date.today().adddays(-1), CloseDate = date.today().adddays(2),OwnerId=u.Id,Assigned_UW__c=userInfo.getUserId());
         insert opp;

         Plan__c pln = new Plan__c(Name='Test',marketing_plan_number__c='Health1');
         insert pln;
         SGR_Opportunity_Benefit_Agreement__c opBA = new SGR_Opportunity_Benefit_Agreement__c(Name='Test',Opportunity__c = opp.Id,Plan1__c=pln.id);
         insert opBA;


         List<Sgr_Opportunity_Census__c> oppCensus = new List<Sgr_Opportunity_Census__c>();
         SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c(Name = 'OppCen', row__c= '1',Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Subscriber', Dental_Plan_ID__c='123', Health_Plan_ID__c='100', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222);
         oppCensus.add(oppcen);
         SGR_Opportunity_Census__c oppcen1 = new SGR_Opportunity_Census__c(Name = 'OppCen1',row__c= '2', Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Subscriber', Dental_Plan_ID__c='123', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=1111);
         oppCensus.add(oppcen1);
         SGR_Opportunity_Census__c oppcen2 = new SGR_Opportunity_Census__c(Name ='OppCen2',row__c= '3', Opportunity__c = opp.Id, Relationship__c = 'Spouse',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='F', Subscriber_Number__c=1111);
         oppCensus.add(oppcen2);
         SGR_Opportunity_Census__c oppcen3 = new SGR_Opportunity_Census__c(Name ='OppCen3', row__c= '2',Opportunity__c = opp.Id, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=1111);
         oppCensus.add(oppcen3);
         SGR_Opportunity_Census__c oppcen4 = new SGR_Opportunity_Census__c(Name ='OppCen4',row__c= '2.1', Opportunity__c = opp.Id, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Health_Plan_ID__c='100',Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222);
         oppCensus.add(oppcen4);
         SGR_Opportunity_Census__c oppcen5 = new SGR_Opportunity_Census__c(Name ='OppCen5',row__c = '4', Opportunity__c = opp.Id, Relationship__c = 'Domestic Partner',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222,Health_Plan_ID__c='16842500');
         oppCensus.add(oppcen5);
         insert  oppCensus;
         SGR_Opportunity_Census__c oppcen51 = new SGR_Opportunity_Census__c(Name ='OppCen5',row__c = '4', Opportunity__c = opp.Id, Relationship__c = 'Domestic Partner',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222,Health_Plan_ID__c='1684');

         Test.starttest();
              Sgr_displayCensus.saveOppCensus(oppcen5,'Health');
              Sgr_displayCensus.saveOppCensus(oppcen4,'Vision');
              Sgr_displayCensus.saveOppCensus(oppcen51,'Health');
              Sgr_displayCensus.CountDependents(opp.id,oppcen.Subscriber_Number__c);
         sgr_displayCensus.getOpportunityData(opp.id,'vision');
         sgr_displayCensus.getRelationShip(opp.id,'Spouse');
         sgr_displayCensus.showSubscribersAndDependents(opp.id,'Health');
            /*for(Sgr_Opportunity_Census__c optycens : oppCensus){
                Sgr_displayCensus.CountDependents(opp.id,optycens.Subscriber_Number__c);
                //Sgr_displayCensus.CountDependentsSpouseAndDP(opp.id,optycens.Subscriber_Number__c);
               sgr_displayCensus.getOpportunityData(opp.id,'vision');
                sgr_displayCensus.getRelationShip(opp.id,'Spouse');
                sgr_displayCensus.showSubscribersAndDependents(opp.id,'Health');
            }*/
            Sgr_displayCensus.saveCensusRecord(oppCensus[4],oppCensus[0].Id,'Health');
            //sgr_displayCensus.saveOptyCensus(oppCensus,'Health',opp.id);
            
             SGR_Opportunity_Census__c oppcens = new SGR_Opportunity_Census__c(Name ='OppCen3', row__c= '6',Opportunity__c = opp.Id, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2321);
            insert oppcens;
             Sgr_displayCensus.saveOppCensus(oppcens,'Vision');
            sgr_displayCensus.getRelationShip(opp.id,'Spouse');
            sgr_displayCensus.getRelationShip(opp.id,'Child');
            sgr_displayCensus.getRelationShip(opp.id,'ROOPA');
            Sgr_displayCensus.getPlanIds(opp.Id);
            Sgr_displayCensus.getgroupSection(opp.Id,'10984563');
               Test.stopTest();
         
    } 
    
     public Static String getOpptyRecordTypeIds(String ObjectName,String recTypeName){
         Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobalDescribe() ;
        Schema.SObjectType SchemaObject = mapSchemaobject.get(ObjectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = SchemaObject.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        System.debug(':::RECTYPE:::'+recordTypeId);
        return recordTypeId;
       
    }

    @IsTest
    static void testGetDependentData(){
        User u = [select firstname from user where id=:userinfo.getuserid()];
        Opportunity opp = new opportunity( Name = 'Opty2', Rating_status__c='Sold', StageName = 'lost', Primary_Closed_Reason__c ='Political', Closed_Comments__c = 'XYZ',  Date_Closed__c = date.today().adddays(-1), CloseDate = date.today().adddays(2),OwnerId=u.Id,Assigned_UW__c=userInfo.getUserId());
        insert opp;
        SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c(Name = 'OppCen', row__c= '1',Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Subscriber', Dental_Plan_ID__c='123', Health_Plan_ID__c='100', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222);
        insert oppcen;
        Test.starttest();
        SGR_Opportunity_Census__c testCensus = Sgr_displayCensus.getDependentData(oppcen.Id);
        Test.stopTest();
        System.assertNotEquals(testCensus, null, 'Failed to retrieve record');
    }

    @IsTest
    static void testGetOppData(){
        User u = [select firstname from user where id=:userinfo.getuserid()];
        Opportunity opp = new opportunity( Name = 'Opty2', Rating_status__c='Sold', StageName = 'lost', Primary_Closed_Reason__c ='Political', Closed_Comments__c = 'XYZ',  Date_Closed__c = date.today().adddays(-1), CloseDate = date.today().adddays(2),OwnerId=u.Id,Assigned_UW__c=userInfo.getUserId());
        insert opp;
        Test.starttest();
        Opportunity testOpp = Sgr_displayCensus.getOppData(opp.Id);
        Test.stopTest();
        System.assertNotEquals(testOpp, null, 'Failed to retrieve record');
    }

    @IsTest
    static void testUpdateCensusRows(){
        User u = [select firstname from user where id=:userinfo.getuserid()];
        Opportunity opp = new opportunity( Name = 'Opty2', Rating_status__c='Sold', StageName = 'lost', Primary_Closed_Reason__c ='Political', Closed_Comments__c = 'XYZ',  Date_Closed__c = date.today().adddays(-1), CloseDate = date.today().adddays(2),OwnerId=u.Id,Assigned_UW__c=userInfo.getUserId());
        insert opp;

        Plan__c pln = new Plan__c(Name='Test',marketing_plan_number__c='Health1');
        insert pln;
        SGR_Opportunity_Benefit_Agreement__c opBA = new SGR_Opportunity_Benefit_Agreement__c(Name='Test',Opportunity__c = opp.Id,Plan1__c=pln.id);
        insert opBA;
        List<Sgr_Opportunity_Census__c> oppCensus = new List<Sgr_Opportunity_Census__c>();
        SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c(Name = 'OppCen', row__c= '1',Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Subscriber', Dental_Plan_ID__c='123', Health_Plan_ID__c='100', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222);
        oppCensus.add(oppcen);
        SGR_Opportunity_Census__c oppcen1 = new SGR_Opportunity_Census__c(Name = 'OppCen1',row__c= '2', Health_Tier__c = 'EF', Vision_Tier__c = 'EF', Dental_Tier__c = 'EF', Opportunity__c = opp.Id, Relationship__c = 'Subscriber', Dental_Plan_ID__c='123', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=1111);
        oppCensus.add(oppcen1);
        SGR_Opportunity_Census__c oppcen2 = new SGR_Opportunity_Census__c(Name ='OppCen2',row__c= '3', Opportunity__c = opp.Id, Relationship__c = 'Spouse',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='F', Subscriber_Number__c=1111);
        oppCensus.add(oppcen2);
        SGR_Opportunity_Census__c oppcen3 = new SGR_Opportunity_Census__c(Name ='OppCen3', row__c= '2',Opportunity__c = opp.Id, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=1111);
        oppCensus.add(oppcen3);
        SGR_Opportunity_Census__c oppcen4 = new SGR_Opportunity_Census__c(Name ='OppCen4',row__c= '2.1', Opportunity__c = opp.Id, Relationship__c = 'Child',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Health_Plan_ID__c='100',Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222);
        oppCensus.add(oppcen4);
        SGR_Opportunity_Census__c oppcen5 = new SGR_Opportunity_Census__c(Name ='OppCen5',row__c = '4', Opportunity__c = opp.Id, Relationship__c = 'Domestic Partner',  Dental_Plan_ID__c='298', Vision_Plan_ID__c='234', Zip_Code__c='1234', Gender__c='M', Subscriber_Number__c=2222,Health_Plan_ID__c='16842500');
        oppCensus.add(oppcen5);
        insert  oppCensus;
        Test.starttest();
        Boolean testResult = Sgr_displayCensus.updateCensusRows(oppCensus);
        Test.stopTest();
        System.assertEquals(testResult, true, 'Failed to update records');
    }
}