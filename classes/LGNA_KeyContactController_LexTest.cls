/**************************************************************************************
  Apex Class Name     : LGNA_KeyContactController_Lex 
  Version             : 1.0
  Function            : This is Test Class for LGNA_KeyContactController_Lex
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       09/12/2017                Original Version
*************************************************************************************/
@isTest
public class LGNA_KeyContactController_LexTest {
    static  Account testAccount,testAccount1;
    public List<Team_Member_360Views__c> teammember360;
    public List<LGNA_KeyContactController_Lex.TeamMemberWrapper> testwrapper;
     
     String teamRoleName='Billing';
     String teamMemberName='testUsers[0].Id';
     String teamMemberId='testUsers[0].Id';
    
    static
    {
      List<LGNA_KeyContactController_Lex.TeamMemberWrapper> testwrapper;
      Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();

        testAccount = new Account();
        testAccount.Ceded__c = true;
        testAccount.HCM_Program_Model__c = 'BCC Elite';
        testAccount.Funding_Type__c = 'PREM';
        testAccount.Cobra_Administration_Type__c = 'HCSC';
        testAccount.Exchange_Account__c = true;
        testAccount.Exchange_Name__c = 'Mercer Marketplace';
        testAccount.Sliced__c = true;
        
        testAccount.Current_Risk_Level__c = '3 - Medium';
        testAccount.Status__c = 'Active';
        testAccount.Critical_Account__c = True;
        testAccount.Risk_Reason__c = 'Test';
        testAccount.HCSC_Division__c = 'TX';
        testAccount.Account_Cluster_Name__c = 'John Testing';
        testAccount.Account_Executive_2__c = 'Jane Testing';
        testAccount.Underwriter_User_ID__c = 'UU456';
        testAccount.Name='Test Account Today';
        testAccount.RecordtypeId=RecordTypeIdContact;
        insert testAccount;
        
        testAccount1 = new Account(); 
    }
    
    @TestSetup 
    static void setupData() {
        List<AccountTeamMember> accountTeamMemberList=new list<AccountTeamMember>();
        List<Account_Team_Non_SF__c> accountTeamMemberNonSFList=new list<Account_Team_Non_SF__c>();
        list<AccountTeamMember> accteammember = new list<AccountTeamMember>();
        List<Account_Team_Non_SF__c> accteamnonsf= new list<Account_Team_Non_SF__c>();
        
        List<User> testUsers = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            testUsers.add(new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE));
            testUsers.add(new User(Alias = 'standt6', Email = 'sana.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Sana', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'sana.testing@testorg.com', isActive = TRUE, Lan_Id__c = 'UU4569'));
        insert testUsers;
        
       accteammember.add(new AccountTeamMember(AccountId= testAccount.Id,TeamMemberRole ='Account Executive',UserId=testUsers[0].Id));
       insert accteammember;
        
       accteamnonsf.add(new Account_Team_Non_SF__c(Account_Name__c= testAccount.Id,Member_Role__c='Account Executive'));
       insert accteamnonsf;

       Team_Member_360Views__c teammember360 = new Team_Member_360Views__c(Team_Role_Name__c='Account Executive',Sort_Order__c=3,name='record 1',Account_Record_Types__c='Group_Account');
       insert teammember360;

         for(AccountTeamMember temp : accteammember){
                   if(teammember360.Team_Role_Name__c == temp.TeamMemberRole){
                       accountTeamMemberList.add(temp);
                    }
                }

        for(Account_Team_Non_SF__c templist : accteamnonsf){
                    if(teammember360.Team_Role_Name__c == templist.Member_Role__c){
                        accountTeamMemberNonSFList.add(templist);
                    }
                }
 }

  static testMethod void testdetailpage() {
      PageReference testPage=Page.KeyContacts_lex;
      Test.setCurrentPage(testPage);
      ApexPages.currentPage().getParameters().put('id',testAccount.Id);
      LGNA_KeyContactController_Lex controller = new LGNA_KeyContactController_Lex(new ApexPages.StandardController(testAccount));
      system.debug('account id test'+testAccount.Id);
      LGNA_KeyContactController_Lex.TeamMemberWrapper testwrapper=new LGNA_KeyContactController_Lex.TeamMemberWrapper('Billing','UserId','UserId');
 }
}