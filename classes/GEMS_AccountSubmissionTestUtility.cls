@isTest
public class GEMS_AccountSubmissionTestUtility{
     public static Account CreateAccountRecord(String AccountName){
        Account newAccount  = new Account();
        newAccount .RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        newAccount .Name = 'BenefitAgreementControllerTest';
        newAccount .status__c = 'Active';
        return newAccount ;
    }
public static Contact CreateContactRecord(Id ContactAccountId, String ContactFirstName, String ContactLastName, Id ReportToContactId){
        Contact newContact = new Contact(AccountId = ContactAccountId,Fax = '1234567', FirstName = ContactFirstName, LastName = ContactLastName, ReportsToId = ReportToContactId);
        return newContact;
    }
    
    public static Contact_Relationship__c CreateContactRelationship(Id ContactId, Id RelatedContactId, Id RelatedUser){
        Contact_Relationship__c newContactRel = new Contact_Relationship__c(Contact__c = ContactId, Related_Contact__c = RelatedContactId, Related_User__c = RelatedUser);
        insert newContactRel;
        return newContactRel;
    }

    public static User CreateUserRecord(Id ProfileId, String UserNameStr, String LastNameStr, String EmailStr){
        User newUser = new User(Alias = 'test',Email=EmailStr, EmailEncodingKey='UTF-8', LastName=LastNameStr, LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, TimeZoneSidKey='America/Los_Angeles', UserName=UserNameStr);
        return newUser;
    }
       public static list<AccountTeamMember> createAccTeamMember(String accId,String userId){
        list<AccountTeamMember> accTeamMember = new list<AccountTeamMember>();
        accTeamMember.add(new AccountTeamMember(AccountId = accId,UserId = userId));
        return accTeamMember;
    }
    
    public static Opportunity CreateOpportunities(String accountId){
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest';
        opp.accountId= accountId;
        opp.Type='Other';
        opp.StageName='Won';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        return opp;
    }

 public static Product2 createProducts(){
        Product2 product = new Product2();
        product.Name='BCS Stop Loss';
        product.Product_Category__c='EPO';
        product.Family='Ancillary and other';
        product.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        product.IsActive=true;
        product.HCSC_State__c='IL';
        product.External_ID__c='IL-Accident Insurance (EPO)';
        return product;
    }
 public static Opportunity_Product__c createOppProducts(String oppId,String productId){
        Opportunity_Product__c oppProducts = new Opportunity_Product__c();
        oppProducts.Product__c=productId;
        oppProducts.Opportunity_Name__c=oppId;
        oppProducts.Status__c='In Progress';
        oppProducts.Win_Probability__c=10;
        oppProducts.Funding_Type__c='ACAP';
        oppProducts.Projected_Members__c=2;
        return oppProducts;
    }
     public static Case createcaseObject(String oppId,String accountId){
        Case caseObject = new Case();
        caseObject.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObject.Opportunity_Name__c=oppId;
        caseObject.Status='Design In Progress';
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra';
        caseObject.Accountid = accountId;
        caseObject.GEMS_Integrated__c = true;
        caseObject.GEMS_BCC_Products__c = 'Selective I/O';
        caseObject.GEMS_Bank__c = '' ;
        //caseObject.GEMS_Private_Exchange__c =False ;
        caseObject.GEMS_Rx_Vendor__c ='Prime' ;
        caseObject.GEMS_Vendor__c = '';
        caseObject.GEMS_Line_of_Business__c='Major National';
        caseObject.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseObject.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        return caseObject;
    
    }
    public static GEMS_Attachment__c createattachment(String caseobjectid){
       GEMS_Attachment__c attach = new GEMS_Attachment__c();
        attach.Attachment__c='test';
        attach.Case__c=caseobjectid;
        attach.Type__c='ABS';
        attach.Description__c='testing';
        return attach;
    }
    public static GEMS_Benefit_Agreement__c createbenefitagreement(String caseobjectid ,String accountId){ 
        GEMS_Benefit_Agreement__c gab = new GEMS_Benefit_Agreement__c();
        gab.BA_Description__c = 'test';
        gab.BA_Fund_Type__c = 'ACAP';   
        gab.Account__c = accountId;
        gab.AccountStructureCase__c = caseobjectid;
        gab.Name='1234';
        return gab;
    }
    public static GEMS_Category__c createcategory(String caseobjectid ,String accountId){ 
            GEMS_Category__c gemscat =new GEMS_Category__c();
            gemscat.Account__c=accountId;
            gemscat.Case__c=caseobjectid;
            gemscat.Category_Cobra_Code__c='CO';
            gemscat.Category_Description__c='ABS';
            gemscat.Usage_Billing__c=False;
            gemscat.Usage_Mailing__c=False;
            gemscat.Usage_Product__c=False;
            gemscat.Usage_Reporting__c=False;
            gemscat.name ='1234';
            return gemscat;
    }
public static GEMS_Group_Section__c creategroupsection(String caseobjectid ,String accountId){
        GEMS_Group_Section__c gemsSec = new GEMS_Group_Section__c();
        gemsSec.Name = 'Testing';
        gemsSec.Account__c = accountId;
        gemsSec.Case__c = caseobjectid;
        gemsSec.Group_No__c = '12345';
        gemsSec.Section_Description__c = 'section';
        gemsSec.Section_No__c = '1223';
        return gemsSec;

}

}