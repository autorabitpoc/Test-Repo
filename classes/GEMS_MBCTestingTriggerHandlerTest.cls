/**************************************************************************************
  Apex Class Name     : GEMS_MBCTestingTriggerHandler 
  Version             : 1.0
  Function            : This is a handler class for GEMS_MBC_Testing__c(For GEMS Project).
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Ranjit Gandhi         10/22/2017              SFDC-7430 GEMS: MBC - Update BA Level Status Field when FEAK Analysis is in progress
*************************************************************************************/

@isTest
private class GEMS_MBCTestingTriggerHandlerTest{
    //static public List<case> mbcCase;
private static testmethod void TriggerTest(){
    Test.startTest();
    Id CDHPTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('CDHP Testing').getRecordTypeId();
    Id DTUTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('DTU Testing').getRecordTypeId();
    Id FEAKAnalysisid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Analysis').getRecordTypeId();
    Id FEAKTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Testing').getRecordTypeId();
    Id SharedAccumsTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('Shared Accums Testing').getRecordTypeId();
    Id mbcCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
    GEMS_MBC_Testing__c NewMBCTestRec;
    //Account acc = [select id,name from account limit 1];
   //List<Case> mbcCase = new List<Case>([Select id from Case where recordtypeId =: mbcCaseId limit 1]);
    Account acc = new Account();
    acc.Name = 'Test Account';
    insert acc;
    
    /*Case mbcCase = new Case();
    mbcCase.Account = acc;
    mbcCase.recordtypeid = mbcCaseId;
    mbcCase.Production_Availability_Date__c = system.Today();
    insert mbcCase;*/
    
    Case mbcCase1 = new Case();
    mbcCase1.Account = acc;
    mbcCase1.recordtypeid = mbcCaseId;
    mbcCase1.Production_Availability_Date__c = system.Today();
    insert mbcCase1;
    
    /*Case mbcCase2 = new Case();
    mbcCase2.Account = acc;
    mbcCase2.recordtypeid = mbcCaseId;
    mbcCase2.Production_Availability_Date__c = system.Today();
    insert mbcCase2;
    
    Case mbcCase3 = new Case();
    mbcCase3.Account = acc;
    mbcCase3.recordtypeid = mbcCaseId;
    mbcCase3.Production_Availability_Date__c = system.Today();
    insert mbcCase3;
    
    Case mbcCase4 = new Case();
    mbcCase4.Account = acc;
    mbcCase4.recordtypeid = mbcCaseId;
    mbcCase4.Production_Availability_Date__c = system.Today();
    insert mbcCase4;*/
    
    //Test.startTest();
    GEMS_MBC_Testing__c mbcTest = new GEMS_MBC_Testing__c();
   // mbcTest.Account_Name__c = acc.name;
   // mbcTest.Account_Number__c = acc.AccountNumber;
    mbcTest.recordtypeid = DTUTestingid;
    mbcTest.status__c = 'In Progress';
    mbcTest.MBC_BA_Level_Case_DTU__c = mbcCase1.id;
    insert mbcTest;
    
    GEMS_MBC_Testing__c mbcTest1 = new GEMS_MBC_Testing__c();
    //mbcTest1.Account_Name__c = acc.name;
   // mbcTest1.Account_Number__c = acc.AccountNumber;
    mbcTest1.recordtypeid = CDHPTestingid;
    mbcTest1.status__c = 'In Progress';
    mbcTest1.MBC_BA_Level_Case_CDHP__c = mbcCase1.id;
    insert mbcTest1;
    
    GEMS_MBC_Testing__c mbcTest2 = new GEMS_MBC_Testing__c();
    //mbcTest2.Account_Name__c = acc.name;
    //mbcTest2.Account_Number__c = acc.AccountNumber;
    mbcTest2.recordtypeid = FEAKAnalysisid;
    mbcTest2.status__c = 'In Progress';
    mbcTest2.MBC_BA_Level_Case_FEAK__c = mbcCase1.id;
    insert mbcTest2;
    
    GEMS_MBC_Testing__c mbcTest3 = new GEMS_MBC_Testing__c();
    //mbcTest3.Account_Name__c = acc.name;
    //mbcTest3.Account_Number__c = acc.AccountNumber;
    mbcTest3.recordtypeid = FEAKTestingid;
    mbcTest3.status__c = 'Passed';
    mbcTest3.MBC_BA_Level_Case_FEAK_Testing__c = mbcCase1.id;
    insert mbcTest3;
    
    GEMS_MBC_Testing__c mbcTest4 = new GEMS_MBC_Testing__c();
    //mbcTest4.Account_Name__c = acc.name;
    //mbcTest4.Account_Number__c = acc.AccountNumber;
    mbcTest4.recordtypeid = SharedAccumsTestingid;
    mbcTest4.status__c = 'In Progress';
    mbcTest4.MBC_BA_Level_Case_Shared_Accums__c = mbcCase1.id;
    insert mbcTest4;
    
/*    GEMS_MBC_Testing__c mbcTest5 = new GEMS_MBC_Testing__c();
    //mbcTest4.Account_Name__c = acc.name;
    //mbcTest4.Account_Number__c = acc.AccountNumber;
    mbcTest5.recordtypeid = CDHPTestingid;
    mbcTest5.status__c = 'In Progress';
    mbcTest5.MBC_BA_Level_Case_Shared_Accums__c = mbcCase1.id;
    insert mbcTest5;    */
    
    mbcTest.Status__c = 'Failed';
    mbcTest.DTU_Sign_Off_Date__c = system.today();
    update mbcTest;    
    Test.stopTest();

        }
    //7430- New Test method for coverage
    private static testmethod void TriggerTest1(){
    Test.startTest();    
    Id FEAKAnalysisid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Analysis').getRecordTypeId();
    Id FEAKTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Testing').getRecordTypeId();   
    Id mbcCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
    GEMS_MBC_Testing__c NewMBCTestRec;
    //Account acc = [select id,name from account limit 1];
   //List<Case> mbcCase = new List<Case>([Select id from Case where recordtypeId =: mbcCaseId limit 1]);
    Account acc = new Account();
    acc.Name = 'Test Account';
    insert acc;  
    
    Case mbcCase1 = new Case();
    mbcCase1.Account = acc;
    mbcCase1.recordtypeid = mbcCaseId;
    mbcCase1.Production_Availability_Date__c = system.Today();
    insert mbcCase1;   
    
   
    GEMS_MBC_Testing__c mbcTest2 = new GEMS_MBC_Testing__c();
    //mbcTest2.Account_Name__c = acc.name;
    //mbcTest2.Account_Number__c = acc.AccountNumber;
    mbcTest2.recordtypeid = FEAKAnalysisid;
    mbcTest2.status__c = 'In Progress';
    mbcTest2.MBC_BA_Level_Case_FEAK__c = mbcCase1.id;
    insert mbcTest2;
    
    GEMS_MBC_Testing__c mbcTest3 = new GEMS_MBC_Testing__c();
    //mbcTest3.Account_Name__c = acc.name;
    //mbcTest3.Account_Number__c = acc.AccountNumber;
    mbcTest3.recordtypeid = FEAKTestingid;
    mbcTest3.status__c = 'Passed';
    mbcTest3.MBC_BA_Level_Case_FEAK_Testing__c = mbcCase1.id;
    insert mbcTest3;
    
    

    
    mbcTest2.Status__c = 'No FEAK Testing Needed';
   
    update mbcTest2;    
    Test.stopTest();

        }

}