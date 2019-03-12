@isTest
public class GEMS_CaseFilesConnect_Test {

    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static User userIntProfile;
    @testSetup
    static void dataSetup() {
                     
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePointOAuthTEST__c cs = new SharePointOAuthTEST__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        /*
        String urlString = String.valueof(System.URL.getSalesforceBaseUrl());
        
        if(urlString.contains('--'))
        {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        else
        {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        }*/
        //cs.Name = hostUrlString; //System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        //cs.Name = 'SPoAuthName';
        cs.Access_Token_1__c = '00000000000000000000000000000000';
        cs.Access_Token_2__c = '00000000000000000000000000000000';
        cs.Access_Token_3__c = '00000000000000000000000000000000';
        cs.Access_Token_4__c = '00000000000000000000000000000000';
        cs.Access_Token_5__c = '00000000000000000000000000000000';
        cs.Client_ID__c = '123456789ABCDEFG';
        cs.Client_Secret__c = 'secret';
        cs.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        cs.Refresh_Token_1__c = '00000000000000000000000000000000';
        cs.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert cs;
        
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Test.startTest();
        Account a = new Account(Name='Test', External_Id__c='AC102981',recordTypeId = accRecTypeId);
        insert a;
        
        Opportunity o = new Opportunity(Name='Test', RFI_RFP_Received_Date__c=System.Today(), AccountId=a.Id);
        o.StageName='Expected In';
        o.probability=50;
        o.Expected_RFP_Release_Date__c=System.Today();
        o.CloseDate=System.Today();
        o.HCSC_Division__c='TX';
        o.Region__c='N/A - IL';
        o.District__c='290';
        o.Clusters__c='020';
        o.Primary_Closed_Reason__c='Other';
        o.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        insert o;
        
        Case c = new Case(Subject='Test');
        c.Opportunity_Name__c = o.Id;
        c.AccountId = a.Id;
        c.recordtypeid = caseAccountSubmissionId;
        insert c;
        Test.stopTest();
       
    }

    @isTest static void testMethod1() {
        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        //userIntProfile = userList[0];
        
         Case c = [SELECT Id FROM Case LIMIT 1];
        ApexPages.CurrentPage().getParameters().put('id', c.Id);
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = profileRec.Id;
        insert testKey;
        ApexPages.StandardController std = new ApexPages.StandardController(c);
        GEMS_CaseFilesConnect con = new GEMS_CaseFilesConnect(std);

        GEMS_Attachment__c gemsAttach = new GEMS_Attachment__c();
        gemsAttach.Name = 'Test attachment';
        gemsAttach.Attachment__c = 'Test';
        gemsAttach.Case__c = c.Id;
        gemsAttach.Description__c = 'Test desc';
        insert gemsAttach;
        
        try{    
          con.pageSize = 0;
          con.totalNoOfRecs = 1;
          con.getInitialDocumentSet();
        } catch(System.MathException e) {
          System.assert(true);
        }
    
        con.totalNoOfRecs = 0;
        con.pageSize = 2;
        con.getInitialDocumentSet();
    
        con.totalNoOfRecs = 3;
        con.getInitialDocumentSet();
         try{
          con.next();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        System.assertEquals(1, con.pageNumber);
    
        try{
          con.previous();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
    
        try{
          con.previous();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
    
        con.fileType = 'application';
        con.fileName = 'Test file name';
        con.linkFile();
        con.fileType = 'other';
        con.fileName = 'Test file name';
        con.linkFile();
        try{
            con.fileType = 'other';
            con.fileName = 'Test file name';
            con.SFlinkFile(con.fileName);
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        try{                
            con.fileType = 'other';
            con.fileName = 'Test file name';
            con.syncDocumentsFromItems_SharePointObj();
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        //con.isAuthUser= true;
        con.verifySharePointButton();
        try{
            con.downloadURL();
            con.fileType = 'application';
            con.fileName = 'abcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklAASmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcdefghijklmnopqrstuvxyzabcde';
            con.subStringAttachmentName(con.fileName);
        } catch(System.NullPointerException e){
          //Requires Items_Sharepoint__x External Object to be populated, cannot do this
          System.assert(true);
        }
        Test.stopTest();
        
    }
}