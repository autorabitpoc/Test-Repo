/********************************************************************************
* Apex Class Name     : TestGroupAccount360Controller
* Version             : 1.0
* Function            : This is a test class for GroupAccount360Controller .
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Zachary Campbell		6/09/2017	added code to create and populate
*									Lightning_Prospecting_Profiles__c.  
* Zachary Campbell		10/20/2017	SFDC-5801 To increase code coverage of GroupAccount360Controller
*									myUnitTest2() and myUnitTest3() was added and code was split with myUnitTest()
*********************************************************************************/
@isTest
public  class TestGroupAccount360Controller {
    
    static testMethod void myUnitTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        System.runAs(testUser) {        
            try{
                //create account
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account 1');
                /*** start SFDC-5801 ***/
                testAccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                /*** end SFDC-5801 ***/
                testAccount.ShippingStreet = 'test';
                testAccount.ShippingCity = 'test';
                testAccount.ShippingState = 'TX';
                //testAccount.ShippingCountry= 'United States';
                testAccount.ShippingPostalCode = '1002';
                testAccount.Website = 'test.com';
                testAccount.Industry = 'test';
                testAccount.External_ID__c = 'test';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Effective_Date__c = system.today().addYears(1);
                testAccount.Open_Enrollment_Date__c = system.today().addYears(-2);
                testAccount.HCSC_Client_Since__c = system.today().addYears(-4);
                testAccount.Contract_End__c = system.today().addYears(2);
                testAccount.Open_Enrollment_End_Date__c = system.today().addYears(3);
                testAccount.Total_Num_of_Potential_Subscribers__c = 10;
                testAccount.Active_Health_Subscribers__c = 8;
                update testAccount;

                /*** SFDC-5801 create producer account ***/ 
				Account prodAccount = TestClassUtiltity.CreateAccountRecord('Test Account 2');
				prodAccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
				update prodAccount;
                
                list<AccountTeamMember> accountTeamMembers = TestClassUtiltity.createAccountTeamMembersRecords(testAccount.Id,testUser.Id);
                accountTeamMembers[0].TeamMemberRole = 'Consultant';
                upsert accountTeamMembers[0];

                /*** SFDC-5801 create account framework ***/
                Account_Framework__c afw = new Account_Framework__c();
                afw.Account__c = testAccount.Id;
				insert afw;

                List<Lightning_Prospecting_Profiles__c> pProfiles = new List<Lightning_Prospecting_Profiles__c>();
                Lightning_Prospecting_Profiles__c pProfiles1 = new Lightning_Prospecting_Profiles__c();            
                pProfiles1.Name = 'System Administrator';       
                pProfiles.add(pProfiles1);
                insert pProfiles;
                
                List<Lightning_Prospecting_Pilot_Names__c> pNames = new List<Lightning_Prospecting_Pilot_Names__c>();
                Lightning_Prospecting_Pilot_Names__c pNames1 = new Lightning_Prospecting_Pilot_Names__c();            
                pNames1.Name = 'testtestUser';       
                pNames.add(pNames1);
                insert pNames;
                
                test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
                ApexPages.currentPage().getParameters().put('id',testAccount.Id);
                GroupAccount360Controller tempExtension = new GroupAccount360Controller(sc);
                tempExtension.getPieData();
                tempExtension.nextActivityDate = null;
                tempExtension.lastActivityDate = null;
                tempExtension.strategyPlanId = null;
                tempExtension.openActivitiesReportObj = new Report();
                tempExtension.pastDueActivitiesReportObj = new Report();
                tempExtension.openCasesByPriorityReportObj = new Report();
                tempExtension.LastrenewalOppId = null;
                system.assertEquals(accountTeamMembers.size(),1);
                test.stopTest();
                
            }catch(Exception e){
                throw e;
            }
        }
    }
    
    /*** SFDC-5801 add myUnitTest2() ***/
    static testMethod void myUnitTest2() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        System.runAs(testUser) {        
            try{
                //create account
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account 1');
                /*** start SFDC-5801 ***/
                testAccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                /*** end SFDC-5801 ***/
                testAccount.ShippingStreet = 'test';
                testAccount.ShippingCity = 'test';
                testAccount.ShippingState = 'TX';
                //testAccount.ShippingCountry= 'United States';
                testAccount.ShippingPostalCode = '1002';
                testAccount.Website = 'test.com';
                testAccount.Industry = 'test';
                testAccount.External_ID__c = 'test';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Effective_Date__c = system.today().addYears(1);
                testAccount.Open_Enrollment_Date__c = system.today().addYears(-2);
                testAccount.HCSC_Client_Since__c = system.today().addYears(-4);
                testAccount.Contract_End__c = system.today().addYears(2);
                testAccount.Open_Enrollment_End_Date__c = system.today().addYears(3);
                testAccount.Total_Num_of_Potential_Subscribers__c = 10;
                testAccount.Active_Health_Subscribers__c = 8;
                update testAccount;
                
                /*** SFDC-5801 create opportunity ***/
            	list<Opportunity> opps = TestClassUtiltity.CreateOpportunities(testAccount.Id);
            	opps[0].Requested_Effective_Date__c = date.today() + 5;
				opps[0].recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opps[0].stageName = 'Expected In';
				upsert opps[0];  
                opps[0].stageName = 'Won';
                opps[0].Primary_Closed_Reason__c = 'Other';
                opps[0].Date_Closed__c = system.today();
				upsert opps[0];  

                list<AccountTeamMember> accountTeamMembers = TestClassUtiltity.createAccountTeamMembersRecords(testAccount.Id,testUser.Id);
                accountTeamMembers[0].TeamMemberRole = 'Consultant';
                upsert accountTeamMembers[0];
               
                test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
                ApexPages.currentPage().getParameters().put('id',testAccount.Id);
                GroupAccount360Controller tempExtension = new GroupAccount360Controller(sc);
                tempExtension.getPieData();
                tempExtension.nextActivityDate = null;
                tempExtension.lastActivityDate = null;
                tempExtension.strategyPlanId = null;
                tempExtension.openActivitiesReportObj = new Report();
                tempExtension.pastDueActivitiesReportObj = new Report();
                tempExtension.openCasesByPriorityReportObj = new Report();
                tempExtension.LastrenewalOppId = null;
                system.assertEquals(accountTeamMembers.size(),1);
                test.stopTest();
                
            }catch(Exception e){
                throw e;
            }
        }
    }    
    
    /*** SFDC-5801 add myUnitTest3() ***/
    static testMethod void myUnitTest3() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        System.runAs(testUser) {        
            try{
                //create account
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account 1');
                /*** start SFDC-5801 ***/
                testAccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                /*** end SFDC-5801 ***/
                testAccount.ShippingStreet = 'test';
                testAccount.ShippingCity = 'test';
                testAccount.ShippingState = 'TX';
                //testAccount.ShippingCountry= 'United States';
                testAccount.ShippingPostalCode = '1002';
                testAccount.Website = 'test.com';
                testAccount.Industry = 'test';
                testAccount.External_ID__c = 'test';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Effective_Date__c = system.today().addYears(1);
                testAccount.Open_Enrollment_Date__c = system.today().addYears(-2);
                testAccount.HCSC_Client_Since__c = system.today().addYears(-4);
                testAccount.Contract_End__c = system.today().addYears(2);
                testAccount.Open_Enrollment_End_Date__c = system.today().addYears(3);
                testAccount.Total_Num_of_Potential_Subscribers__c = 10;
                testAccount.Active_Health_Subscribers__c = 8;
                update testAccount;

                /*** SFDC-5801 create producer account ***/
                Account prodAccount = TestClassUtiltity.CreateAccountRecord('Test Account 2');
				prodAccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
				update prodAccount;

                list<AccountTeamMember> accountTeamMembers = TestClassUtiltity.createAccountTeamMembersRecords(testAccount.Id,testUser.Id);
                accountTeamMembers[0].TeamMemberRole = 'Consultant';
                upsert accountTeamMembers[0];
                
                /*** SFDC-5801 create strategic plan ***/
				Strategic_Plan__c stPlan = new Strategic_Plan__c();
				stPlan.Account_Name__c = testAccount.id;
				stPlan.Active__c = true;
				stPlan.Effective_Date__c = system.today();
				insert stPlan;

                /*** SFDC-5801 create producer group association ***/
				Producer_Group_Association__c pga = new Producer_Group_Association__c();
				pga.Producer_Account__c = prodAccount.id;
				pga.Group_Account__c = testAccount.id;
				insert pga;

                /*** SFDC-5801 create non-salesforce account team ***/              
                Account_Team_Non_SF__c att = new Account_Team_Non_SF__c();
                att.Member_Role__c = 'Consultant';
                att.Account_Name__c = testAccount.Id;
                att.Team_Member_Name__c = null;
                insert att;

                /*** SFDC-5801 create account 360 team ***/               
				Team_Member_360Views__c tm360 = new Team_Member_360Views__c();
                tm360.Name = 'test record';
				tm360.Team_Role_Name__c = 'Consultant';
				tm360.Sort_Order__c = 1;
				tm360.Account_Record_Types__c = 'Group_Account';
                insert tm360;
                
                List<Lightning_Prospecting_Profiles__c> pProfiles = new List<Lightning_Prospecting_Profiles__c>();
                Lightning_Prospecting_Profiles__c pProfiles1 = new Lightning_Prospecting_Profiles__c();            
                pProfiles1.Name = 'System Administrator';       
                pProfiles.add(pProfiles1);
                insert pProfiles;
              
                test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
                ApexPages.currentPage().getParameters().put('id',testAccount.Id);
                GroupAccount360Controller tempExtension = new GroupAccount360Controller(sc);
                tempExtension.getPieData();
                tempExtension.nextActivityDate = null;
                tempExtension.lastActivityDate = null;
                tempExtension.strategyPlanId = null;
                tempExtension.openActivitiesReportObj = new Report();
                tempExtension.pastDueActivitiesReportObj = new Report();
                tempExtension.openCasesByPriorityReportObj = new Report();
                tempExtension.LastrenewalOppId = null;
                system.assertEquals(accountTeamMembers.size(),1);
                test.stopTest();
                
            }catch(Exception e){
                throw e;
            }
        }
    }    
}