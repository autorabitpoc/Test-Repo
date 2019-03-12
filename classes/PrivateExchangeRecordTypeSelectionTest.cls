/**************************************************************************************
Apex Class Name     : PrivateExchangeRecordTypeSelection
Version             : 1.0
Function            : This is a test class for Case Customize Record Type Selection for PE-Product.
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  Padma Bedampeta/HCSC       3/16/2017
*************************************************************************************/
@isTest
public class PrivateExchangeRecordTypeSelectionTest {
    public Case peCase;
    public Id cId;
    public List<String> recordTypes;
    public String selectedValue;
    public String selectedrctyp;
    public List<SelectOption> recordOptions;
    public Blue_Directions_LOB__c privateExchangeProduct; 
    
    Public Static TestMethod void peRecordTypeSelectionBD(){
       
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                //create test account record
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Cluster__c = '005';
                testAccount.Region__c = 'IL';
                testAccount.District__c = '116';
                update testAccount;
                
                Account ProdAccount = TestClassUtiltity.CreateAccountRecord('Producer Account');
                ProdAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
                update ProdAccount;
                System.debug('----ProdAccount----'+ProdAccount);
                String teamMemberRole = 'Account Executive';	
                List<AccountTeamMember> members = new list<AccountTeamMember>();
                members.add(new AccountTeamMember(AccountId = testAccount.Id, TeamMemberRole = teamMemberRole, UserId = testUser.Id));
                insert members;
                
                //create test opportunity record
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = new Opportunity();
                testOpp.Name = 'Test Opp';
                testOpp.AccountId = testAccount.Id;
                testOpp.Probability = 10;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                testOpp.Type = 'RFI';
                testOpp.StageName = 'Expected In';
                testOpp.CloseDate = Date.today().addDays(20);
                testOpp.Exchange_Offering_Type__c = 'Private Exchange - Blue Directions';
                testOpp.Expected_RFP_Release_Date__c = Date.today().addDays(24);
                testOpp.Requested_Effective_Date__c =  Date.today().addDays(24);
                testOpp.Account_Market_Segment__c = 'LG';
                testOpp.HCSC_Division__c = 'IL';
                testOpp.Region__c = 'IL';
                testOpp.District__c = '408';
                testOpp.Clusters__c = '007';
                Insert testOpp;
                
          // Creating Case Record
                Case testCaseZ = new Case();
        		testCaseZ.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Private Exchange - Blue Directions').getRecordTypeId();
                testCaseZ.Subject = 'BlueDirections';
        		testCaseZ.Underwriter_Lookup__c = testUser.Id;
                testCaseZ.Ownerid = testUser.Id;
       		 	testCaseZ.AccountId = testAccount.Id;
                testCaseZ.Opportunity_Name__c = testOpp.Id;
        		testCaseZ.Status = 'New';
                testCaseZ.Group_Exchange_Platform__c = 'Blue Directions for Large Business';
                testCaseZ.Exchange_Lines_of_Business__c = 'Medical';
        		testCaseZ.Requested_Quote_Date__c = Date.today();
                testCaseZ.Effective_Date__c = Date.today().addDays(5);
        		testCaseZ.Rush_Quote_Requested__c = 'No';
        		testCaseZ.Consultant_Broker__c = ProdAccount.Id;
                testCaseZ.Client_moving_to_Defined_Contribution__c = 'Yes';
        		testCaseZ.Account_Executive__c = testUser.Id;
                testCaseZ.Name_of_Current_Medical_Underwriter__c= testUser.Id;
                testCaseZ.ASO_renewal_released_for_this_group__c = 'Yes';
                testCaseZ.Blue_Directions_Tech_Fee__c = 'B';
                testCaseZ.Reason_for_Blue_Directions_Quote__c = 'Interest to move to Defined Contribution';
           
                Test.startTest();
        		insert testCaseZ;                         
                List<Case> testCaseZlst = [select id,CaseNumber,RecordType.developerName from Case where id =:testCaseZ.Id LIMIT 1];
                List<Blue_Directions_LOB__c> lob = [SELECT Id FROM Blue_Directions_LOB__c WHERE Case_Number__c = :testCaseZlst[0].Id];
                Test.setCurrentPageReference(new PageReference('Page.PrivateExchangeRecordTypeSelection'));
                System.currentPageReference().getParameters().put('cId', testCaseZlst[0].Id);
                ApexPages.StandardController sc = new ApexPages.standardController(testCaseZlst[0]);
                PrivateExchangeRecordTypeSelection peRecordTypeSelection = new PrivateExchangeRecordTypeSelection(sc);
                peRecordTypeSelection.selectedValue = 'BlueDirections - Medical';
                peRecordTypeSelection.peContinue();                              
                Test.stopTest();             
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
    
    Public Static TestMethod void peRecordTypeSelectionEX(){       
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                //create test account record
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Cluster__c = '005';
                testAccount.Region__c = 'IL';
                testAccount.District__c = '116';
                update testAccount;
                
                Account ProdAccount = TestClassUtiltity.CreateAccountRecord('Producer Account');
                ProdAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
                update ProdAccount;
                System.debug('----ProdAccount----'+ProdAccount);
                String teamMemberRole = 'Account Executive';	
                List<AccountTeamMember> members = new list<AccountTeamMember>();
                members.add(new AccountTeamMember(AccountId = testAccount.Id, TeamMemberRole = teamMemberRole, UserId = testUser.Id));
                insert members;
                
                //create test opportunity record
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
              //  Opportunity testOpp = opportunities[0];
                Opportunity testOpp = new Opportunity();
                testOpp.Name = 'Test Opp';
                testOpp.AccountId = testAccount.Id;
                testOpp.Probability = 10;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                testOpp.Type = 'RFI';
                testOpp.StageName = 'Expected In';
                testOpp.CloseDate = Date.today().addDays(20);
                testOpp.Exchange_Offering_Type__c = 'Private Exchange - Blue Directions';
                testOpp.Expected_RFP_Release_Date__c = Date.today().addDays(24);
                testOpp.Requested_Effective_Date__c =  Date.today().addDays(24);
                testOpp.Account_Market_Segment__c = 'LG';
                testOpp.HCSC_Division__c = 'IL';
                testOpp.Region__c = 'IL';
                testOpp.District__c = '408';
                testOpp.Clusters__c = '007';
                Insert testOpp;
                                              
                Case testCaseZEx = new Case();
        		testCaseZEx.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Private Exchange - External').getRecordTypeId();
                testCaseZEx.Subject = 'BlueDirections';
        		testCaseZEx.Underwriter_Lookup__c = testUser.Id;
                testCaseZEx.Ownerid = testUser.Id;
       		 	testCaseZEx.AccountId = testAccount.Id;
                testCaseZEx.Opportunity_Name__c = testOpp.Id;
        		testCaseZEx.Status = 'New';
                testCaseZEx.Group_Exchange_Platform__c = 'Aon Hewitt Active Exchange';
                testCaseZEx.Exchange_Lines_of_Business__c = 'Medical';
        		testCaseZEx.Requested_Quote_Date__c = Date.today();
                testCaseZEx.Effective_Date__c = Date.today().addDays(5);
        		testCaseZEx.Rush_Quote_Requested__c = 'No';
        		testCaseZEx.Consultant_Broker__c = ProdAccount.Id;
                testCaseZEx.Client_moving_to_Defined_Contribution__c = 'Yes';
        		testCaseZEx.Account_Executive__c = testUser.Id;
                testCaseZEx.Name_of_Current_Medical_Underwriter__c= testUser.Id;
                testCaseZEx.ASO_renewal_released_for_this_group__c = 'Yes';
                testCaseZEx.Exchange_Fee__c = '5000+ subscribers $1.00 PEPM (ASO)';
                testCaseZEx.Reason_for_Blue_Directions_Quote__c = 'Interest to move to Defined Contribution';
                        
                Test.startTest();
        		insert testCaseZEx;
                List<Case> testCaseZlstEx = [select id,CaseNumber,RecordType.developerName from Case where id =:testCaseZEx.Id LIMIT 1];
                List<Blue_Directions_LOB__c> lobEx = [SELECT Id FROM Blue_Directions_LOB__c WHERE Case_Number__c = :testCaseZlstEx[0].Id];
				Test.setCurrentPageReference(new PageReference('Page.PrivateExchangeRecordTypeSelection'));
                System.currentPageReference().getParameters().put('cId', testCaseZlstEx[0].Id);
                ApexPages.StandardController sc = new ApexPages.standardController(testCaseZlstEx[0]);
                PrivateExchangeRecordTypeSelection peRecordTypeSelection = new PrivateExchangeRecordTypeSelection(sc);
                peRecordTypeSelection.selectedValue = 'External - Medical';
                peRecordTypeSelection.peContinue();
                Test.stopTest();
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
    
}