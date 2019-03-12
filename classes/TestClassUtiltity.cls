/**************************************************************************************
  Apex Class Name     : TestClassUtiltity
  Version             : 1.0
  Function            : This is a test class for ContactRelationShipController .
  Modification Log    :
  * Developer                   Date                   Description
  * ----------------------------------------------------------------------------                 
  *  
  *************************************************************************************/

public class TestClassUtiltity {

    public static List<Strategic_Plan_Super_Users__c> createStrategicHelperCustomSetting() {
        List<Strategic_Plan_Super_Users__c> toInsert = new List<Strategic_Plan_Super_Users__c> ();
        toInsert.add(new Strategic_Plan_Super_Users__c(Name = 'Administrator'));
        toInsert.add(new Strategic_Plan_Super_Users__c(Name = 'System Administrator'));

        insert toInsert;
        return toInsert;

    }

    public static UserRole createRole (String roleName){
    UserRole ur = new UserRole();
    ur.Name = roleName;
    Database.insert (ur);
    return ur;

    }
    

    public static User createStratgicPlanUser(Id ProfileId, String UserNameStr, String LastNameStr, String EmailStr) {

        User newUser = new User(Alias = 'test', Email = EmailStr, EmailEncodingKey = 'UTF-8', LastName = LastNameStr, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = ProfileId, TimeZoneSidKey = 'America/Los_Angeles', UserName = UserNameStr);
        insert newUser;
        return newUser;

    }

    public static Account createAccountWithRecType(String accountName, Id recordTypeId){
    Account newAccount = new Account(Name = accountName, RecordTypeId = RecordTypeID, Active_Health_Subscribers__c = 15000, Effective_Date__c = system.today().addyears(2));
    insert newAccount;
    return newAccount;
    }

    public static Account CreateAccountRecord(String AccountName) {
        Account newAccount = new Account(Name = AccountName, Fax = '1234567', Effective_Date__c = system.today().addyears(2));
        insert newAccount;
        return newAccount;
    }

    //KK Added code for SFDC-9391 US
    public static Account CreateCompAccountRecord(String AccountName) {
         Id CompRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account newAccount = new Account(Name = AccountName, RecordTypeId= CompRecordTypeId, Fax = '1234567', Effective_Date__c = system.today().addyears(2));
        insert newAccount;
        return newAccount;
    }
    public static Contact CreateContactRecord(Id ContactAccountId, String ContactFirstName, String ContactLastName, Id ReportToContactId) {
        Contact newContact = new Contact(AccountId = ContactAccountId, Fax = '1234567', FirstName = ContactFirstName, LastName = ContactLastName, ReportsToId = ReportToContactId);
        insert newContact;
        return newContact;
    }

    public static Contact_Relationship__c CreateContactRelationship(Id ContactId, Id RelatedContactId, Id RelatedUser) {
        Contact_Relationship__c newContactRel = new Contact_Relationship__c(Contact__c = ContactId, Related_Contact__c = RelatedContactId, Related_User__c = RelatedUser);
        insert newContactRel;
        return newContactRel;
    }

    public static User CreateUserRecord(Id ProfileId, String UserNameStr, String LastNameStr, String EmailStr) {
        string temp = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');
        User newUser = new User(Alias = 'test', Email =temp+EmailStr, EmailEncodingKey = 'UTF-8', LastName = 'test'+LastNameStr, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = ProfileId, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testttt'+UserNameStr);
        insert newUser;
        return newUser;
    }

    public static list<Opportunity> CreateOpportunities(String accountId) {
        list<Opportunity> opportunities = new list<Opportunity> ();
        opportunities.add(new Opportunity(AccountId = accountId, Name = 'oppName 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
        opportunities.add(new Opportunity(AccountId = accountId, Name = 'testopp 2', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
        opportunities.add(new Opportunity(AccountId = accountId, Name = 'opp6352', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
        opportunities.add(new Opportunity(AccountId = accountId, Name = 'killer', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
        opportunities.add(new Opportunity(AccountId = accountId, Name = 'newO', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
        opportunities.add(new Opportunity(AccountId = accountId, Name = 'randome', StageName = 'Qualification', CloseDate = system.Today().addYears(2), 
                                          Expected_Decision_Date__c = system.Today().addYears(1), Requested_Effective_Date__c=System.today(),RFI_RFP_Received_Date__c = system.Today().addYears(1)));
        return opportunities;
    }

    public static list<OpportunityTeamMember> createOppTeamMember(String oppId, String userId) {
        list<OpportunityTeamMember> oppTeamMembers = new list<OpportunityTeamMember> ();
        oppTeamMembers.add(new OpportunityTeamMember(OpportunityId = oppId, UserId = userId));
        return oppTeamMembers;
    }

    public static list<AccountTeamMember> createAccTeamMember(String accId, String userId) {
        list<AccountTeamMember> accTeamMember = new list<AccountTeamMember> ();
        accTeamMember.add(new AccountTeamMember(AccountId = accId, UserId = userId));
        return accTeamMember;
    }

    public static list<Opportunity_Team_Non_SF__c> createOppTeamNonSF(String oppId, String contactId) {
        list<Opportunity_Team_Non_SF__c> oppTeamMembers = new list<Opportunity_Team_Non_SF__c> ();
        oppTeamMembers.add(new Opportunity_Team_Non_SF__c(Opportunity_Name__c = oppId, Opportunity_Team_Member__c = contactId, Member_Role__c = 'Accountant'));
        return oppTeamMembers;
    }

    public static list<Opportunity_Product__c> createOppProducts(String oppId, String productId) {
        list<Opportunity_Product__c> oppProducts = new list<Opportunity_Product__c> ();
        oppProducts.add(new Opportunity_Product__c(Opportunity_Name__c = oppId, Product__c = productId));
      
        return oppProducts;
    }
      public static list<Account_Products__c> createAccProducts(id accid, id productId) {
        list<Account_Products__c> acccProducts = new list<Account_Products__c> ();
        acccProducts.add(new Account_Products__c(Account__c = accid, Product2__c = productId, Effective_End_Date__c=System.today()));
        acccProducts.add(new Account_Products__c(Account__c = accid, Product2__c = productId));
        return acccProducts;
    }
   public static User CreateUserRecordWithRole(Id ProfileId, String UserNameStr, String LastNameStr, String EmailStr, Id roleId) {
        string temp = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');
      //  Id roleId=createRole('Contract Administration');
        User newUser = new User(Alias = 'test', Email =temp+EmailStr, EmailEncodingKey = 'UTF-8', LastName = 'test'+LastNameStr, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = ProfileId, userRoleId=roleId, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testttt'+UserNameStr);
        insert newUser;
        return newUser;
    }

 public static Group GetGroupRecord(String grpName,String grpType){
     Group g = [select id, name, type from Group where type=:grpType and name=:grpName limit 1];
     
     return g;
  }
   
    public static list<Product2> createProducts() {
    	Id recTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
    	
        list<Product2> products = new list<Product2> ();
        
        products.add(new Product2(Name = 'test', IsActive = true, Family = 'Ancillary and other', recordTypeId=recTypeId,Product_Type__c='Medical'));
        products.add(new Product2(Name = 'test1', IsActive = true,recordTypeId=recTypeId,Product_Type__c='ABC'));
        products.add(new Product2(Name = 'test2', IsActive = true,recordTypeId=recTypeId));
        return products;
    }
    
    public static list<Product2> createProducts(Id recId) {
    	
        list<Product2> products = new list<Product2> ();
        products.add(new Product2(Name = 'test', recordTypeId=recId,IsActive = true,Family = 'Ancillary and other'));
        products.add(new Product2(Name = 'test1', recordTypeId=recId,IsActive = true));
        products.add(new Product2(Name = 'test3',recordTypeId=recId, IsActive = true));
        
        return products;
    }

    public static list<Event> createEvents(String accountId) {
        list<Event> events = new list<Event> ();
        events.add(new Event(WhatId = accountId, Subject = 'Test Event 1', StartDateTime = system.now().addMonths(1), EndDateTime = system.now().addMonths(1).addHours(1)));
        events.add(new Event(WhatId = accountId, Subject = 'Test Event 2', StartDateTime = system.now().addMonths(1), EndDateTime = system.now().addMonths(1).addHours(1)));
        events.add(new Event(WhatId = accountId, Subject = 'Test Event 3', StartDateTime = system.now().addMonths(- 1), EndDateTime = system.now().addMonths(- 1).addHours(1)));
        events.add(new Event(WhatId = accountId, Subject = 'Test Event 4', StartDateTime = system.now().addMonths(- 1), EndDateTime = system.now().addMonths(- 1).addHours(1)));
        return events;
    }

    public static list<EventRelation> createEventRelations(String eventId) {
        list<EventRelation> events = new list<EventRelation> ();
        events.add(new EventRelation(EventId = eventId));
        return events;
    }


    public static list<Strategic_Plan__c> createStrategicPlans(String accountId) {
        list<Strategic_Plan__c> strategicPlans = new list<Strategic_Plan__c> ();
        strategicPlans.add(new Strategic_Plan__c(Account_Name__c = accountId, Effective_Date__c = System.today()));
        strategicPlans.add(new Strategic_Plan__c(Account_Name__c = accountId, Effective_Date__c = System.today()));
        strategicPlans.add(new Strategic_Plan__c(Account_Name__c = accountId, Effective_Date__c = System.today()));
        strategicPlans.add(new Strategic_Plan__c(Account_Name__c = accountId, Effective_Date__c = System.today()));
        return strategicPlans;
    }

    public static list<Task> createTasks(String accountId) {
        List<task> tasks = new List<task> ();
        tasks.add(new task(WhatID = accountId, ActivityDate = system.today().addDays(- 1), Subject = 'Donni', Status = 'Completed', Priority = 'Normal'));
        tasks.add(new task(WhatID = accountId, ActivityDate = system.today().addDays(- 1), Subject = 'Donni1', Status = 'Completed', Priority = 'Normal'));
        return tasks;
    }

    public static list<AccountContactRole> createAccountContactRoleRecords(String accId, String contactId) {
        list<AccountContactRole> accountContactRoles = new list<AccountContactRole> ();
        accountContactRoles.add(new AccountContactRole(accountId = accId, ContactId = contactId));
        return accountContactRoles;
    }

    public static list<AccountTeamMember> createAccountTeamMembersRecords(String accId, String userId) {
        list<AccountTeamMember> accountTeamMembers = new list<AccountTeamMember> ();
        accountTeamMembers.add(new AccountTeamMember(accountId = accId, UserId = userId));
        return accountTeamMembers;
    }

    public static list<Case> createCaseRecords(String accId) {
        list<Case> cases = new list<Case> ();
        cases.add(new Case(accountId = accId));
        return cases;
    }

  
    public static list<CaseTeamMember> createCaseTeamMembersRecords(string caseId, String userId) {
        list<CaseTeamMember> caseTeamMembers = new list<CaseTeamMember> ();
        caseTeamMembers.add(new CaseTeamMember(parentId = caseId, MemberId = userId));
        return caseTeamMembers;
    }

    public static list<Playbook__c> createPlayBookRecords() {
        list<Playbook__c> playBooks = new list<Playbook__c> ();
        playBooks.add(new Playbook__c(name = 'newSale', active__c = true));
        playBooks.add(new Playbook__c(name = 'renewal', active__c = true));
        return playBooks;
    }

    public static list<Stage__c> createStageRecords(string playBookId) {
        list<Stage__c> stages = new list<Stage__c> ();
        stages.add(new Stage__c(Closed_Lost_Stage__c = true, Playbook__c = playBookId, Stage_Sort_Order__c = 1));
        stages.add(new Stage__c(Closed_Lost_Stage__c = false, Playbook__c = playBookId, Stage_Sort_Order__c = 2));
        return stages;
    }

    public static list<Substage__c> createSubStageRecords(string stageId) {
        list<Substage__c> substages = new list<Substage__c> ();
        substages.add(new Substage__c(Stage__c = stageId, Substage_Sort_Order__c = 1));
        substages.add(new Substage__c(Stage__c = stageId, Substage_Sort_Order__c = 2));
        return substages;
    }

    public static list<Task__c> createTaskSubStageRecords(string substageId) {
        list<Task__c> tasks = new list<Task__c> ();
        tasks.add(new Task__c(Case_Record_Type__c = 'Proposal', Substage__c = substageId, Task_Sort_Order__c = 1, Trigger_After_Completion__c = 'Create a Case'));
        tasks.add(new Task__c(Case_Record_Type__c = 'Performance Guarantee', Substage__c = substageId, Task_Sort_Order__c = 2, Trigger_After_Completion__c = 'Create a Case'));
        return tasks;
    }

    public static list<Stage_Mapping__c> createStageMappings(string stageId, String playbookId, String OppId) {
        list<Stage_Mapping__c> subStages = new list<Stage_Mapping__c> ();
        subStages.add(new Stage_Mapping__c(Stage__c = stageId, Playbook__c = playbookId, Opportunity__c = OppId));
        subStages.add(new Stage_Mapping__c(Completed__c = true, Stage__c = stageId, Playbook__c = playbookId, Opportunity__c = OppId));
        return subStages;
    }

    public static list<Substage_Mapping1__c> createSubStageMappings(string stageMappIngId, String subStageId) {
        list<Substage_Mapping1__c> subStageMappings = new list<Substage_Mapping1__c> ();
        subStageMappings.add(new Substage_Mapping1__c(Started__c = true, Stage_Mapping__c = stageMappIngId, Substage__c = subStageId));
        subStageMappings.add(new Substage_Mapping1__c(Started__c = false, Stage_Mapping__c = stageMappIngId, Substage__c = subStageId));
        return subStageMappings;
    }

    public static list<Task_Mapping__c> createTaskMappings(string stageMappIngId, String taskId) {
        list<Task_Mapping__c> taskMappings = new list<Task_Mapping__c> ();
        taskMappings.add(new Task_Mapping__c(Completed__c = true, Substage_Mapping__c = stageMappIngId, Task__c = taskId));
        taskMappings.add(new Task_Mapping__c(Completed__c = false, Substage_Mapping__c = stageMappIngId, Task__c = taskId));
        return taskMappings;
    }

    public static void createHomePageSliderComponents() {
        list<Home_Page_Slider_Components__c> customSettingInsert = new list<Home_Page_Slider_Components__c> ();
        customSettingInsert.add(new Home_Page_Slider_Components__c(Name = 'one', Component_Code__c = 'one', Component_Description__c = 'one', Component_URL__c = 'www.google.com', Icon_Class__c = 'one'));
        customSettingInsert.add(new Home_Page_Slider_Components__c(Name = 'two', Component_Code__c = 'two', Component_Description__c = 'two', Component_URL__c = 'www.google.com', Icon_Class__c = 'two'));
        customSettingInsert.add(new Home_Page_Slider_Components__c(Name = 'three', Component_Code__c = 'thre', Component_Description__c = 'three', Component_URL__c = 'www.google.com', Icon_Class__c = 'three'));
        customSettingInsert.add(new Home_Page_Slider_Components__c(Name = 'MP', Component_Code__c = 'MP', Component_Description__c = 'MP', Component_URL__c = 'www.google.com', Icon_Class__c = 'MP'));
        insert customSettingInsert;
    }

    public static void createHomePageSliderPreferences() {
        list<Home_Page_Slider_Preferences__c> customSettingInsert = new list<Home_Page_Slider_Preferences__c> ();
        customSettingInsert.add(new Home_Page_Slider_Preferences__c(name = 'one1', Component_Codes__c = 'MP:MO:one'));
        /*customSettingInsert.add( new Home_Page_Slider_Preferences__c(name='two1',Component_Codes__c='two'))       ;
          customSettingInsert.add( new Home_Page_Slider_Preferences__c(name='three1',Component_Codes__c='thre'))  ;*/
        insert customSettingInsert;
    }

    public static void createBlueStartFields() {
        list<BLue_star_callout_fields__c> customSettingInsert = new list<BLue_star_callout_fields__c> ();
        customSettingInsert.add(new BLue_star_callout_fields__c(Account_API_Name__c = 'Name', Name = 'test1'));
        insert customSettingInsert;
    }

    public static void createBlueStartProductFields() {
        list<Blue_star_Account_Products__c> customSettingInsert = new list<Blue_star_Account_Products__c> ();
        customSettingInsert.add(new Blue_star_Account_Products__c(Product_Name__c = 'Name', Name = 'test', prefix__c = 'XXXXX', Display_Prefix__c = 'XX'));
        insert customSettingInsert;
    }

    public static void createUserNamePasswordFields() {
        list<Username_Password__c> customSettingInsert = new list<Username_Password__c> ();
        customSettingInsert.add(new Username_Password__c(UserName__c = 'testuser@test.com', EndPoinUrl__c = 'test', Password__c = 'test', Name = 'Bluestar'));
        customSettingInsert.add(new Username_Password__c(UserName__c = 'testuser@test.com', EndPoinUrl__c = 'test', Password__c = 'test', Name = 'ESalesModule'));
        customSettingInsert.add(new Username_Password__c(UserName__c = 'testuser@test.com', EndPoinUrl__c = 'test', Password__c = 'test', Name = 'CaseModule1'));
        insert customSettingInsert;
    }

    public static void createPlaybookSettingsFields() {
        list<Playbook_Settings__c> customSettingInsert = new list<Playbook_Settings__c> ();
        customSettingInsert.add(new Playbook_Settings__c(New_Sale_Default_Playbook__c = 'newSale', Renewal_Default_Playbook__c = 'renewal', Name = 'Bluestar'));
        insert customSettingInsert;
    }

    public static void createHomePageSliderProfileConfig() {
        list<Home_Page_Slider_Profile_Configuration__c> customSettingInsert = new list<Home_Page_Slider_Profile_Configuration__c> ();
        customSettingInsert.add(new Home_Page_Slider_Profile_Configuration__c(name = 'one2', Component_Codes__c = 'MP:MO:one'));
        /*customSettingInsert.add( new Home_Page_Slider_Profile_Configuration__c(name='two2',Component_Codes__c='two'))     ;
          customSettingInsert.add( new Home_Page_Slider_Profile_Configuration__c(name='three3',Component_Codes__c='thre'))        ;*/
        insert customSettingInsert;
    }

    public static void createEsalesFields() {
        list<ESales_Callout_Fields_Set__c> customSettingInsert = new list<ESales_Callout_Fields_Set__c> ();
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1001', FieldName__c = 'Opportunity_Name__c', Insert__c = true, Tag_Name__c = 'sf:Opportunity'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1002', FieldName__c = 'Account.Name', Insert__c = true, Tag_Name__c = 'sf:Account_Name__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1003', FieldName__c = 'Account.HCSC_Division__c', Insert__c = true, Tag_Name__c = 'Account.HCSC_Division__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1004', FieldName__c = 'LastModifiedby.Lan_ID__c', Insert__c = true, Tag_Name__c = 'LastModifiedby.Lan_ID__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1005', FieldName__c = 'Opportunity_Name__r.Account_Market_Segment__c', Insert__c = true, Tag_Name__c = 'Account_Market_Segment__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1006', FieldName__c = 'Account.Phone', Insert__c = true, Tag_Name__c = 'sf:Account_Phone__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1007', FieldName__c = 'Account.Fax', Insert__c = true, Tag_Name__c = 'sf:Account_Fax__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1008', FieldName__c = 'Account.BillingStreet', Insert__c = true, Tag_Name__c = 'sf:Account_BillingStreet__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1009', FieldName__c = 'Account.Billingstate', Insert__c = true, Tag_Name__c = 'sf:Account_Billingstate__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1010', FieldName__c = 'Account.BillingCity', Insert__c = true, Tag_Name__c = 'sf:Account_BillingCity__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1011', FieldName__c = 'Account.Billingpostalcode', Insert__c = true, Tag_Name__c = 'sf:Account_Billingpostalcode__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1012', FieldName__c = 'Producer_Account__r.Tax_ID__c', Insert__c = true, Tag_Name__c = 'Producer_Account__r.Tax_ID__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1013', FieldName__c = 'Opportunity_Name__r.Requested_Effective_Date__c', Insert__c = true, Tag_Name__c = 'Requested_Effective_Date__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1014', FieldName__c = 'Account.District__c', Insert__c = true, Tag_Name__c = 'sf:Account_District__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1015', FieldName__c = 'Account.Cluster__c', Insert__c = true, Tag_Name__c = 'sf:Account_Cluster__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1016', FieldName__c = 'Account.Region__c', Insert__c = true, Tag_Name__c = 'sf:Account_Region__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1017', FieldName__c = 'Account.Sic', Insert__c = true, Tag_Name__c = 'sf:Account_Sic__c'));
        customSettingInsert.add(new ESales_Callout_Fields_Set__c(Name = '1018', FieldName__c = 'Integration_Action__c', Insert__c = true, Tag_Name__c = 'sf:Integration_Action__c'));
        insert customSettingInsert;
    }

    public static void createAccountFieldMapping() {
        List<AccountFieldMapping__c> RecordList = new List<AccountFieldMapping__c> ();
        RecordList.add(new AccountFieldMapping__c(Name = '1001', AccountField__c = 'TeamMemberRole', ObjectFieldName__c = 'TeamMemberRole', Type__c = 'TeamMember'));
        RecordList.add(new AccountFieldMapping__c(Name = '1002', AccountField__c = 'UserId', ObjectFieldName__c = 'UserId', Type__c = 'TeamMember'));
        insert RecordList;
    }

    public static void createAccountOpportunityObjectRelations() {
        List<AccountOpportunityObjectRelations__c> RecordList = new List<AccountOpportunityObjectRelations__c> ();
        RecordList.add(new AccountOpportunityObjectRelations__c(Name = '1001', ObjectAPIName__c = 'AccountTeamMember', ObjectRelation__c = 'Account', Type__c = 'TeamMember'));
        RecordList.add(new AccountOpportunityObjectRelations__c(Name = '1002', ObjectAPIName__c = 'OpportunityTeamMember', ObjectRelation__c = 'Opportunity', Type__c = 'TeamMember'));
        insert RecordList;
    }

    public static void createObjectFieldSet() {
        List<ObjectFieldSet__c> RecordList = new List<ObjectFieldSet__c> ();
        RecordList.add(new ObjectFieldSet__c(Name = '1001', FieldName__c = 'Id', ObjectName__c = 'Opportunity', Type__c = 'RecordId'));
        RecordList.add(new ObjectFieldSet__c(Name = '1002', FieldName__c = 'AccountId', ObjectName__c = 'Opportunity', Type__c = 'AccountId'));
        insert RecordList;
    }

    public static void createImportOpptyFields() {
        List<ImportOpptyFields__c> RecordList = new List<ImportOpptyFields__c> ();
        RecordList.add(new ImportOpptyFields__c(Name = '1001', ConditionField__c = true, FieldName__c = 'AccountId', ObjectName__c = 'AccountTeamMember', Type__c = 'TeamMember'));
        RecordList.add(new ImportOpptyFields__c(Name = '1002', Column_Header__c = 'Team Member ', DisplayField__c = true, FieldName__c = 'UserId', IdCompareField__c = true, ObjectName__c = 'AccountTeamMember', Type__c = 'TeamMember'));
        RecordList.add(new ImportOpptyFields__c(Name = '1003', Column_Header__c = 'Role', DisplayField__c = true, FieldName__c = 'TeamMemberRole', IsInputField__c = true, ObjectName__c = 'AccountTeamMember', Type__c = 'TeamMember'));
        RecordList.add(new ImportOpptyFields__c(Name = '1004', ConditionField__c = true, FieldName__c = 'OpportunityId', ObjectName__c = 'OpportunityTeamMember', ParentField__c = true, Type__c = 'TeamMember'));
        RecordList.add(new ImportOpptyFields__c(Name = '1005', FieldName__c = 'TeamMemberRole', ObjectName__c = 'OpportunityTeamMember', Type__c = 'TeamMember'));
        RecordList.add(new ImportOpptyFields__c(Name = '1006', FieldName__c = 'UserId', ObjectName__c = 'OpportunityTeamMember', IdCompareField__c = true, Type__c = 'TeamMember'));
        insert RecordList;
    }

    public static List<Producer_Association_For_Opportunity__c> createProducerAssociationForOpportunity(Id AccountId, Id OpptyId) {
        List<Producer_Association_For_Opportunity__c> lst = new List<Producer_Association_For_Opportunity__c> ();
        Producer_Association_For_Opportunity__c pao = new Producer_Association_For_Opportunity__c();
        pao.Producer_Consultant__c = AccountId;
        pao.Opportunity__c = OpptyId;
        lst.add(pao);
        return lst;
    }

    public static List<Opportunity_Product__c> createOpptyProducts(Id OpportunityId, Id ProductId) {
        List<Opportunity_Product__c> opptyProds = new List<Opportunity_Product__c> ();
        Opportunity_Product__c opptyprd = new Opportunity_Product__c();
        opptyprd.Opportunity_Name__c = OpportunityId;
        opptyprd.Product__c = ProductId;
        opptyProds.add(opptyprd);
        opptyprd = new Opportunity_Product__c();
        opptyprd.Opportunity_Name__c = OpportunityId;
        opptyprd.Product__c = ProductId;
        opptyProds.add(opptyprd);
        return opptyProds;
    }
    
        public static List<Opportunity_Product__c> createOpptyProductsComp(Id OpportunityId, Id ProductId, Id AccountCompId) {
        List<Opportunity_Product__c> opptyProds = new List<Opportunity_Product__c> ();
        Opportunity_Product__c opptyprd = new Opportunity_Product__c();
        opptyprd.Opportunity_Name__c = OpportunityId;
        opptyprd.Product__c = ProductId;
        opptyprd.Incumbent__c = AccountCompId;
        opptyProds.add(opptyprd);
        opptyprd = new Opportunity_Product__c();
        opptyprd.Opportunity_Name__c = OpportunityId;
        opptyprd.Product__c = ProductId;
		opptyprd.Incumbent__c = AccountCompId;		
        opptyProds.add(opptyprd);
        return opptyProds;
    }

    public static List<CaseTeamRole> CreateCaseTeamRole() {
        List<CaseTeamRole> csTeamRoleLst = new List<CaseTeamRole> ();
        CaseTeamRole csTR = new CaseTeamRole();
        csTR.Name = 'Requestor';
        csTR.AccessLevel = 'Edit';
        csTeamRoleLst.add(csTR);
        return csTeamRoleLst;
    }

    public static List<Integration_Status__c> createIntegrationStatus(Id ObjectId) {
        List<Integration_Status__c> IntStatusLst = new List<Integration_Status__c> ();
        Integration_Status__c intSt = new Integration_Status__c();
        intSt.ObjectId__c = ObjectId;
        IntStatusLst.add(intSt);
        return IntStatusLst;
    }

    public static void createCaseCalloutFields() {
        List<Case_Callout_Fields__c> callOutList = new List<Case_Callout_Fields__c> ();
        callOutList.add(new Case_Callout_Fields__c(Name = 'AccountId', API_Name__c = 'AccountId', CBSR_Insert__c = true));
        callOutList.add(new Case_Callout_Fields__c(Name = 'Account_Name__c', API_Name__c = 'Account_Name__c', CBSR_Insert__c = true, CBSR_Issue_Insert__c = true, CBSR_Issue_Update__c = true));
        callOutList.add(new Case_Callout_Fields__c(Name = 'External_ID__c', API_Name__c = 'External_ID__c', CBSR_Button__c = true, CBSR_Delete__c = true, CBSR_Issue_Update__c = true));
        callOutList.add(new Case_Callout_Fields__c(Name = 'Id', API_Name__c = 'Id', CBSR_Insert__c = true, CBSR_Button__c = true, CBSR_Delete__c = true, CBSR_Issue_Update__c = true, CBSR_Issue_Insert__c = true));
        callOutList.add(new Case_Callout_Fields__c(Name = 'Integration_Action__c', API_Name__c = 'Integration_Action__c', CBSR_Insert__c = true, CBSR_Button__c = true, CBSR_Delete__c = true, CBSR_Issue_Update__c = true, CBSR_Issue_Insert__c = true));
        callOutList.add(new Case_Callout_Fields__c(Name = 'LastModifiedBy_LanID__c', API_Name__c = 'LastModifiedBy_LanID__c', CBSR_Insert__c = true, CBSR_Button__c = true, CBSR_Delete__c = true, CBSR_Issue_Update__c = true, CBSR_Issue_Insert__c = true));
        callOutList.add(new Case_Callout_Fields__c(Name = 'Time_Sent__c', API_Name__c = 'Time_Sent__c', CBSR_Insert__c = true, CBSR_Button__c = true, CBSR_Delete__c = true, CBSR_Issue_Update__c = true, CBSR_Issue_Insert__c = true));
        insert callOutList;
    }

    public static List<Competitor_Relationship__c> createCompRel(Id AccountId) {
        List<Competitor_Relationship__c> lstCompRel = new List<Competitor_Relationship__c> ();
        lstCompRel.add(new Competitor_Relationship__c(Group_Account__c = AccountId, Rate_Effective_Date__c = system.today().addyears(1), Contract_End_Date__c = system.today().addyears(2)));
        lstCompRel.add(new Competitor_Relationship__c(Group_Account__c = AccountId, Rate_Effective_Date__c = system.today().addyears(2), Contract_End_Date__c = system.today().addyears(3)));
        return lstCompRel;
    }
    public static List<Competitor_Products__c> createCompProd(Id relationShipId, Id productId) {
        List<Competitor_Products__c> lstCompProd = new List<Competitor_Products__c> ();
        lstCompProd.add(new Competitor_Products__c(Carrier__c = relationShipId, Product__c = productId, Effective_Date__c = system.today().addyears(1), Sliced_Carveout__c = 'Sliced', Status__c = 'Active'));
        lstCompProd.add(new Competitor_Products__c(Carrier__c = relationShipId, Product__c = productId, Effective_Date__c = system.today().addyears(2), Sliced_Carveout__c = 'Carve Out', Status__c = 'Active'));
        return lstCompProd;
    }
    
    public static Quote_Request_Summary__c createQuoteReq(id QuoteId, id ownerId){
    	//List<Quote_Request_Summary__c> reqs=new list<Quote_Request_Summary__c>();
    	Quote_Request_Summary__c req=new Quote_Request_Summary__c();
    	 req.Quote_Name__c=quoteId;
    	 req.ownerId=ownerId;
    	
    	 
    //	 reqs.add(req);
    	// insert req;
    	return req;
    }
    
 
  
    public static Quote createQuote(Id oppId) {
        Quote quote = new Quote();
        quote.Name = 'TestQuote';
        quote.OpportunityId = oppId;
        return quote;
    }
    
     public static QuoteLineItem createQuoteLineItem(Id quoteId, Id fReqId, Id dReqId, Id mReqId, Id prodId, Id notStdPBId) {
        QuoteLineItem line = new QuoteLineItem();
      //  CreateStandarPricebookEntry(prodId);
       
         Id standardPBId =Test.getStandardPricebookId();//[select id from Pricebook2 where isStandard=true limit 1];
         
        PricebookEntry standardPriceEntry = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = prodId, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPriceEntry;
        
       // Id pbId =getNonStandardPriceBook('Underwriting Price Book');
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = notStdPBId, Product2Id = prodId, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);

        insert pbe;
  	
         
         
      //  PriceBookEntry pbe=;//CreateNotStandardPriceBookEntry(prodId);
        
        line.QuoteId = quoteId;
        line.Product2Id=prodId;
        line.Request_For_Product_Marked_For_Future__c=fReqId;
        line.RequestForProductMarkedForDelete__c=dReqId;
        line.RequestForProductMarkedMarketCheck__c=mReqId;
        line.PricebookEntryId=pbe.id;
        line.Quantity = 1;
        line.UnitPrice = 1;
       
        return line;
    }

    public static Opportunity createOpportunity(Id accountId) {
        Opportunity opp = newOpportunity(accountId, 'testOpp');
        opp.Name = opp.Name+String.valueOf(DateTime.now().millisecond());
        insert opp;
        return opp;
    }
   
    public static list<Opportunity> CreateOpportunities2 (Id accountId){
    	list<Opportunity> opps=new list<Opportunity> ();
    	Opportunity opp1=newOpportunity(accountId, 'testOpp1');
    	 opps.add(opp1);
    	 
    	Opportunity opp2=newOpportunity(accountId,'testOpp2');
    	 opps.add(opp2);
    	 
    	// insert opps;
    	 return opps;
    	    	
    }
    public static Opportunity newOpportunity(Id accountId,String OppName){
        Opportunity opp = new Opportunity();
        opp.AccountId = accountId;
        opp.StageName = 'Expected In';
        opp.Requested_Effective_Date__c = System.now().date();
        opp.CloseDate = System.today();
        opp.Name = oppName;
        return opp;
    }
    /*  public static list<Carrier_History__c> createCarrierHistories(String quoteReId){
      list<Carrier_History__c> carrierHistories = new list<Carrier_History__c>();
         carrierHistories.add(new Carrier_History__c(Quote = quoteReId,Coverage_Type__c = 'Current Health'));
         return carrierHistories;
      }
   */
  /*  public static Quote createQuote(Id oppId, String quoteId) {
        Quote quote = newQuote(oppId, quoteId);
        insert quote;
        return quote;
    }
    */
   
    
    
    /*
    public static PriceBookEntry  CreateStandarPricebookEntry(Id prodId){
    	
    	 id standardPBid=getStandardPriceBook('Standard Price Book');// [select id from Pricebook2 where name='Standard Price Book' and isStandard=true limit 1];
   
    	 Id stdPb2Id=standardPBid;
    	 
    	  PriceBookEntry se=new PriceBookEntry();
            se.product2Id=prodId;
            se.IsActive=true;
            se.priceBook2Id=stdPb2Id;
            se.UnitPrice=1.0;
       
            se.UseStandardPrice=false;
           // stdpbe.add(se);
           insert se;
           return se;
    }
    
  */
    public static PriceBookEntry CreateNotStandardPriceBookEntry(Id prodId){
    	
    	id stdPbid=getStandardPriceBook();
    	
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = stdPbid, Product2Id = prodId, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
 
     //   PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
       // insert pbe;
    	 
    	 Id stdPb2Id=getNonStandardPriceBook('Test Price Book');
    	 
    	  PriceBookEntry se=new PriceBookEntry();
            se.product2Id=prodId;
            se.IsActive=true;
            se.priceBook2Id=stdPb2Id;
            se.UnitPrice=1.0;
         
            se.UseStandardPrice=false;
           // se.HCSC_State__c='IL';
           // stdpbse.e.add(se);
           insert se;
           return se;
           
    }
 
      public static Id getNonStandardPriceBook(String bname) {

         
        PriceBook2 prcObj = new PriceBook2(Name = bname, IsActive = true);
        insert prcObj;

        return prcObj.Id;

    }
     public static Id getStandardPriceBook() {
           
       list<PriceBook2> pb = [select id from PriceBook2 where isStandard=true limit 1] ;
       priceBook2 prcObj;
        
        if(pb==null || pb.isEmpty()){
          prcObj= new PriceBook2(Name ='Standard Price Book', IsActive = true);
        }else{
          prcObj=pb[0];
        }
        insert prcObj;

        return prcObj.Id;

    }
    
  
   public static list<Competitor_Relationship__c> createCarrierHistory(Id accountId){
   	
    	list<Competitor_Relationship__c> carriers=new list<Competitor_Relationship__c>();
    	 Competitor_Relationship__c carrier=new Competitor_Relationship__c();
    	 
      list<RecordType>  crt = [select Id from RecordType where DeveloperName = 'Carrier' and SobjectType='Competitor_Relationship__c' limit 1];
      if(crt!=null && crt.size()>0){
       
    	 carriers.add(new Competitor_Relationship__c(RecordTypeId = crt[0].Id,Group_Account__c =accountId,status__c='Active'));//,false,1);
      } 
       return carriers;
    }
      
}