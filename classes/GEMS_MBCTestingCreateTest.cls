@isTest
public class GEMS_MBCTestingCreateTest {

    @testSetup  
    public static void setupTestData() {        
        test.startTest();
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        //oppty.StageName='Won';
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
        insert accSub;

        Case MBCParent = GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
            MBCParent.accountId = acc.Id;
            MBCParent.Funding_Type_Multiselect__c = 'ASO;Premium';
            MBCParent.Opportunity_Name__c = oppty.id;
            MBCParent.GEMS_Account_Submission_Info__c = accSub.Id;
            insert MBCParent;
        
        Case MBCSub = GEMS_UtilityClassTest.insertionCase('GEMS BA Level Medical Benefit Coding');
            MBCSub.accountId = acc.Id;
            MBCSub.Funding_Type_Multiselect__c = 'ASO;Premium';
            MBCSub.Opportunity_Name__c = oppty.id;
            MBCSub.GEMS_Account_Submission_Info__c = accSub.Id;
        	MBCSub.ParentId = MBCParent.Id;
            insert MBCSub;
    test.stopTest();

    }
    
    @isTest
    public  static void  testDTU() {
        test.startTest();
        //Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        Case c = [Select Id from Case where RecordType.name = 'GEMS BA Level Medical Benefit Coding' LIMIT 1];
        GEMS_MBCTestingCreate MBCTest = new GEMS_MBCTestingCreate();
        id dtuId = GEMS_MBCTestingCreate.NewMBCTest(C.Id, 'DTU');
        test.stopTest();
    }   
    @isTest
    public  static void  testCDHP() {
        test.startTest();
        //Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        Case c = [Select Id from Case where RecordType.name = 'GEMS BA Level Medical Benefit Coding' LIMIT 1];
        GEMS_MBCTestingCreate MBCTest = new GEMS_MBCTestingCreate();
        id dtuId = GEMS_MBCTestingCreate.NewMBCTest(C.Id, 'CDHP');
        test.stopTest();
    }   
    @isTest
    public  static void  testSAT() {
        test.startTest();
        //Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        Case c = [Select Id from Case where RecordType.name = 'GEMS BA Level Medical Benefit Coding' LIMIT 1];
        GEMS_MBCTestingCreate MBCTest = new GEMS_MBCTestingCreate();
        id dtuId = GEMS_MBCTestingCreate.NewMBCTest(C.Id, 'SAT');
        test.stopTest();
    }   
    @isTest
    public  static void  testFEAK() {
        test.startTest();
        //Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        Case c = [Select Id from Case where RecordType.name = 'GEMS BA Level Medical Benefit Coding' LIMIT 1];
        GEMS_MBCTestingCreate MBCTest = new GEMS_MBCTestingCreate();
        id dtuId = GEMS_MBCTestingCreate.NewMBCTest(C.Id, 'FEAK');
        test.stopTest();
    }       
}