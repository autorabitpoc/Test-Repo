@isTest
private class GEMS_WhereIsMyCaseExtTest {
    
    @testSetup  
    public static void setupTestData() {    
        Test.startTest();    
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty.Date_Closed__c = system.today();
        oppty.Primary_Closed_Reason__c='Other';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        Opportunity_Product__c insertionOppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        System.assertEquals('In Progress',insertionOppProd1.Status__c);     
        Case accSub = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        accSub.accountId = acc.Id;
        accSub.Funding_Type_Multiselect__c = 'ASO;Premium';
        accSub.Opportunity_Name__c = oppty.id;
        accSub.MileStone__c = '';
        insert accSub;
        
        Case elig = GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        elig.GEMS_Account_Submission_Info__c = accSub.Id;
        elig.status = 'In Progress';
        insert elig;
        
        Case req = GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        req.GEMS_Account_Submission_Info__c = accSub.Id;
        req.status = 'In Progress';
        insert req;
        
        Case get= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        get.GEMS_Account_Submission_Info__c = accSub.Id;
        get.status = 'In Progress';
        get.GEMS_Implementation_Is_Closed__c = true;
        get.GEMS_Verify_Benefit_Adhoc_Needed__c = 'No';
        get.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.Today(); 
        insert get;

        GEMS_Attachment__c att = new GEMS_Attachment__c();
        att.Name = 'BPA - ASO SIGNED';
        att.case__c = accSub.Id;
        att.Type__c = 'BPA - ASO SIGNED';
        insert att;
        Test.stopTest();
    }
    
    @isTest
    public static void testGetReportDet() {
        Test.startTest();
        Case accSub = [Select Id, CaseNumber from Case LIMIT 1];
        PageReference pgRef = Page.GEMS_Where_Is_My_Case;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('id', accSub.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accSub);
        GEMS_WhereIsMyCaseExt w = new GEMS_WhereIsMyCaseExt(stdCtrl);
        w.getReportDet();
        System.assert(w.commentsReportUrl!=null);
        System.assert(w.commentsReportUrl.contains('pv0='+accSub.CaseNumber));
        System.assert(w.commentsReportUrl.contains('pv2='+accSub.CaseNumber));
        Test.stopTest();
    }
    
    @isTest
    public static void StatusCompletedAutoUpdAccSubCaseBPA() {
        Test.startTest();
        Case accSub = [Select Id,MileStone__c,GEMS_Submission_Type__c,(select Id,Status from Cases1__r) from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        accSub.MileStone__c = 'Service Ready';
        accSub.GEMS_Submission_Type__c = GEMS_Constants.SubmissionTypeNewAc;
        update accSub;
        for(case cse:accSub.Cases1__r){
           cse.status = 'Completed';          
        }
        update accSub.Cases1__r;
        PageReference pgRef = Page.GEMS_Where_Is_My_Case;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('id', accSub.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accSub);
        GEMS_WhereIsMyCaseExt w = new GEMS_WhereIsMyCaseExt(stdCtrl);
        w.autoUpdAccSubCaseBPA();
        Case accChk = [Select Id,status from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        system.assertEquals(accChk.status,'Completed');
        Test.stopTest();
    }
    
    @isTest
    public static void StatusInProgressAutoUpdAccSubCaseBPA() {
        Test.startTest();
        Case accSub = [Select Id,MileStone__c,(select Id,Status from Cases1__r) from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        accSub.MileStone__c = '';
        accSub.GEMS_Submission_Type__c = GEMS_Constants.SubmissionTypeNewAc;
        update accSub;
        PageReference pgRef = Page.GEMS_Where_Is_My_Case;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('id', accSub.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accSub);
        GEMS_WhereIsMyCaseExt w = new GEMS_WhereIsMyCaseExt(stdCtrl);
        w.autoUpdAccSubCaseBPA();
        Case accChk = [Select Id,Status from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        system.assertEquals(accChk.status,'In Progress'); 
        Test.stopTest();  
    }
    
    @isTest
    public static void AutoUpdAccSubCaseNoBPA() {
        Test.startTest();
        Case accSub = [Select Id,(select Id from GEMS_Attachments__r LIMIT 1)from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        accSub.MileStone__c = 'Service Ready';
        accSub.GEMS_Submission_Type__c = GEMS_Constants.SubmissionTypeNewAc;
        update accSub;
        delete accSub.GEMS_Attachments__r[0];
        PageReference pgRef = Page.GEMS_Where_Is_My_Case;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('id', accSub.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accSub);
        GEMS_WhereIsMyCaseExt w = new GEMS_WhereIsMyCaseExt(stdCtrl);
        w.autoUpdAccSubCaseBPA();
        Case accChk = [Select Id,Status from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        system.assertEquals(accChk.status,'In Progress');
        Test.stopTest();
    }
    
    @isTest
    public static void AlreadyStatusCompletedAutoUpdAccSubCaseBPA() {
        Test.startTest();
        Case accSub = [Select Id,MileStone__c,GEMS_Submission_Type__c,(select Id,Status from Cases1__r) from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        accSub.MileStone__c = 'Service Ready';
        accSub.GEMS_Submission_Type__c = GEMS_Constants.SubmissionTypeNewAc;
        accSub.Status = GEMS_Constants.StatusCompleted;
        update accSub;
        for(case cse:accSub.Cases1__r){
           cse.status = 'Completed';          
        }
        update accSub.Cases1__r;
        PageReference pgRef = Page.GEMS_Where_Is_My_Case;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('id', accSub.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accSub);
        GEMS_WhereIsMyCaseExt w = new GEMS_WhereIsMyCaseExt(stdCtrl);
        w.autoUpdAccSubCaseBPA();
        Case accChk = [Select Id,status from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
        system.assertEquals(accChk.status,'Completed');
        Test.stopTest();
    }
    
}