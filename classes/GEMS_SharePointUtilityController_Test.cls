@isTest(seeAllData=false)
private class GEMS_SharePointUtilityController_Test{

    static public Account accRec;
    static public Case caseRec;
    static public Opportunity oppRec;
    static public User usrs;
    static public GEMS_Contract_Admin_Request__c conreqRec;
    static public GEMS_SBC_BB_Form__c reqRec;
    
    @testSetUp
    public static void dataSetUp(){
        Id BBrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS BB Form').getRecordTypeId();        
        Id SBCrecordTypeId= Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get('GEMS SBC Form').getRecordTypeId();        
                
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();
        req.Effective_Date__c = System.today();
        req.Open_Enrollment_Start_Date__c = System.today();
        req.Hidden_HCSC_Division__c = 'IL';
        req.Status__c = 'New';
        req.Line_of_Business__c = 'SCP';
        req.Category__c  = 'Contract Admin';
        req.comments__c = '06';
        insert req;
    
        GEMS_SBC_BB_Form__c SBCForm= new GEMS_SBC_BB_Form__c();
        SBCForm.GEMS_SBC_Request__c = req.id;
        SBCForm.Form_Request_Type__c = 'Custom SBC';
        SBCForm.Form_Id__c = 'SBC-0000001';
        SBCForm.Form_Status__c = 'New';
        SBCForm.Grandfathered_Benefit_s__c = 'No';
        SBCForm.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        SBCForm.Associated_Benefit_Agreements__c = 'BA001';
        SBCForm.Minimum_Essential_Coverage_MEC__c = 'No';
        SBCForm.Minimum_Value_Standard_MV__c = 'No';
        SBCForm.Number_of_documents_being_requested__c = 2;
        SBCForm.Current_No_of_Members__c = 5;
        SBCForm.Distribution_Method__c = 'Portal';
        SBCForm.Mental_Health__c = false;
        SBCForm.Other__c = false;
        SBCForm.Resubmission__c = false;
        SBCForm.Rush__c = 'No';
        SBCForm.Rx__c = false;
        SBCForm.Standard_fully_insured_or_Blue_Direction__c = 'No';
        SBCForm.Translation__c = 'No';
        SBCForm.recordTypeId=SBCrecordTypeId;
        insert SBCForm;
                                 
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePointOAuthTEST__c cs = new SharePointOAuthTEST__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
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
        Id caseAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        Account a = new Account(Name='SLALOM TEST ACCOUNT2', External_Id__c='AC102981',recordTypeId = accRecTypeId);
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
      
        req.case__c=c.Id;
        req.Opportunity_link__c=o.id;
        update req;
        
        //SFDC-9616 Check for Account Maintenance case
        
        GEMS_Contract_Admin_Request__c req2 = new GEMS_Contract_Admin_Request__c();
        req2.Effective_Date__c = System.today();
        req2.Open_Enrollment_Start_Date__c = System.today();
        req2.Hidden_HCSC_Division__c = 'IL';
        req2.Status__c = 'New';
        req2.Line_of_Business__c = 'SCP';
        req2.Category__c  = 'Contract Admin';
        req2.comments__c = '06';
        insert req2;
    
        GEMS_SBC_BB_Form__c SBCForm2= new GEMS_SBC_BB_Form__c();
        SBCForm2.GEMS_SBC_Request__c = req2.id;
        SBCForm2.Form_Request_Type__c = 'Custom SBC';
        SBCForm2.Form_Id__c = 'SBC-0000002';
        SBCForm2.Form_Status__c = 'New';
        SBCForm2.Grandfathered_Benefit_s__c = 'No';
        SBCForm2.Carved_Out_Benefits_From_Other_Vendors__c = 'No';
        SBCForm2.Associated_Benefit_Agreements__c = 'BA001';
        SBCForm2.Minimum_Essential_Coverage_MEC__c = 'No';
        SBCForm2.Minimum_Value_Standard_MV__c = 'No';
        SBCForm2.Number_of_documents_being_requested__c = 2;
        SBCForm2.Current_No_of_Members__c = 5;
        SBCForm2.Distribution_Method__c = 'Portal';
        SBCForm2.Mental_Health__c = false;
        SBCForm2.Other__c = false;
        SBCForm2.Resubmission__c = false;
        SBCForm2.Rush__c = 'No';
        SBCForm2.Rx__c = false;
        SBCForm2.Standard_fully_insured_or_Blue_Direction__c = 'No';
        SBCForm2.Translation__c = 'No';
        SBCForm2.recordTypeId=SBCrecordTypeId;
        insert SBCForm2;
        
        Case c2 = new Case(Subject='Test');
        c2.AccountId = a.Id;
        c2.type = 'Account Maintenance';
        c2.recordtypeid = caseAccountMaintenanceId;
        insert c2;
        
        req2.case__c=c2.Id;
        update req2;
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='Integration Profile'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = profileRec.Id;
        insert testKey;
        
    }
   
    @isTest static void SuccessOpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();    
        try{
          Test.startTest();     
          con.fakeErrorCode = 200;
          con.fetchOpportunityInitialDocumentSet();
          con.oppverifySharePointButton();
          con.oppnext();
          con.oppprevious();
          con.oppFileName='change orders.docx';
          con.oppFileType='docx';
          con.opplinkFile();
          con.oppdownloadURL();
          con.oppqueryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }
    
    @isTest static void Error1OpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();    
        try{
          Test.startTest(); 
          con.fakeErrorCode = 401;
          con.fetchOpportunityInitialDocumentSet();
          con.oppverifySharePointButton();
          con.oppnext();
          con.oppprevious();
          con.oppFileName='change orders.docx';
          con.oppFileType='docx';
          con.opplinkFile();
          con.oppdownloadURL();
          con.oppqueryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }
    
    @isTest static void Error2OpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();    
        try{
          Test.startTest();     
          con.fakeErrorCode = 500;
          con.fetchOpportunityInitialDocumentSet();
          con.oppverifySharePointButton();
          con.oppnext();
          con.oppprevious();
          con.oppFileName='change orders.docx';
          con.oppFileType='docx';
          con.opplinkFile();
          con.oppdownloadURL();
          con.oppqueryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }
    
    @isTest static void Error3OpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();    
        try{
          Test.startTest();     
          con.fakeErrorCode = 201;
          con.fetchOpportunityInitialDocumentSet();
          con.oppverifySharePointButton();
          con.oppnext();
          con.oppprevious();
          con.oppFileName='change orders.docx';
          con.oppFileType='docx';
          con.opplinkFile();
          con.oppdownloadURL();
          con.oppqueryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }

@isTest static void Error4OpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();    
        try{
          Test.startTest();     
          con.fakeErrorCode = 200;
          con.fetchOpportunityInitialDocumentSet();
          con.oppverifySharePointButton();
          con.oppnext();
          con.oppprevious();
          con.oppFileName='change orders.docx';
          con.oppFileType='jsp';
          con.opplinkFile();
          con.oppdownloadURL();
          con.oppqueryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }


     @isTest static void ExceptionOpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id);     
        try{
          Test.startTest();     
          con.fakeErrorCode = 200;
          con.fetchOpportunityInitialDocumentSet();
          con.oppverifySharePointButton();
          con.oppnext();
          con.oppprevious();
          con.oppFileName='change orders.docx';
          con.oppFileType='docx';
          con.opplinkFile();
          con.oppdownloadURL();
          con.oppqueryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }
    @isTest static void ResponseNullOpportunitySharePointMethod() {   
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();    
        try{
          Test.startTest();     
          con.fakeErrorCode = 0;
          con.fetchOpportunityInitialDocumentSet();
          Test.stopTest();
        }
        catch(Exception e) {
        }
        
    }

    @isTest static void SuccessCaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 200;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='xlsx';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
         
    }
    
     @isTest static void SuccessCaseSharePointAccountMaintenanceMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c WHERE GEMS_SBC_Request__r.Opportunity_link__c = NULL LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 200;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='xlsx';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
         
    }
    
    @isTest static void Errro1CaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 401;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='xlsx';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
         
    }
    
    @isTest static void Error2CaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 500;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='xlsx';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
         
    }
    
    @isTest static void Error3CaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 201;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='xlsx';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }
         
    }
    
    @isTest static void Error4CaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 200;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='jsp';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }        
    }
    
    @isTest static void ResponseNullCaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id); 
        con.setopportunityId(reqform.GEMS_SBC_Request__r.Opportunity_link__c);
        con.setcaseId(reqform.GEMS_SBC_Request__r.Case__c);
        con.getrecordId();
        con.getopportunityId();
        con.getcaseId();  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 0;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          Test.stopTest();
        }
        catch(Exception e) {
        }
         
    }
    
    @isTest static void ExceptionCaseSharePointMethod() {
        GEMS_SBC_BB_Form__c reqform=[select id,case__c,opportunity__c,GEMS_SBC_Request__r.Case__c,GEMS_SBC_Request__r.Opportunity_link__c from GEMS_SBC_BB_Form__c LIMIT 1];            
        PageReference pageRef = Page.GEMSSharePointRequestForm;
        Test.setCurrentPage(pageRef);       
        ApexPages.CurrentPage().getParameters().put('id', reqform.Id); 
        GEMS_SharePointUtilityController con = new GEMS_SharePointUtilityController();
        con.setrecordId(reqform.Id);  
        try{    
          Test.startTest(); 
          con.fakeErrorCode = 200;
          con.fetchCaseInitialDocumentSet();
          con.caseverifySharePointButton();
          con.casenext();
          con.caseprevious();
          con.caseFileName='Salesforce tickets from CASD.xlsx';
          con.caseFileType='xlsx';
          con.caselinkFile();
          con.casedownloadURL();
          con.casequeryDocuments();
          Test.stopTest();
        }
        catch(Exception e) {
        }        
    }
    

}