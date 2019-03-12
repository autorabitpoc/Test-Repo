//************************************************************************************
// Name             : GEMS_LEX_ReleaseScreeningCase_Test.cls
// Description      : 
// Created By       : 
// Created Date     : 1/18/2018
// ************************Version Updates********************************************
// Date             Developer           Description
// 01/21/2018       Gokul Bharati       US-6935
// -----------------------------------------------------------------------------------
@isTest
private class GEMS_LEX_ReleaseScreeningCase_Test{
    
    public static testmethod void failurevalAccSubBeforeRelease(){
        
        //Create GEMS User
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
        User testuser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec1.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser1 ;
        
        //Create LGNA User 
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='LGNA - Account Management'];
        User testuser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec2.Id, 'test2@user22.com', 'testUser2', 'test2@user.com');
        insert testuser2 ;
        
        //Create Product
        Product2 testprd1= GEMS_UtilityClassTest.insertionProduct();
        insert testprd1;
        
        //Run As LGNA User
        system.RunAs(testuser2){
            Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
            Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
            //Create Account
            Account testaccount1 = GEMS_UtilityClassTest.insertionAccount();
            insert testaccount1;
            //Create Opportunity
            Opportunity testOpp1 = GEMS_UtilityClassTest.insertionOpp(testaccount1.Id);
            insert testOpp1; 
            //Create Opportunity Product
            Opportunity_Product__c  testOppProd1 = GEMS_UtilityClassTest.insertionOppProd8(testprd1.Id,testOpp1 .Id);
            testOppProd1.Incumbent__c = testCompetitorAccount.Id;
            insert testOppProd1;
            //Create Case
            Case testcase1 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
            testcase1.accountId = testaccount1.Id;
            testcase1.Opportunity_Name__c = testOpp1.Id;
            testcase1.ownerId = testuser1.Id;
            testcase1.GEMS_Submission_Type__c = 'New Account';
            testcase1.GEMS_OE_Eligibility_Method__c = 'AEP';
            insert testcase1;
        }
        
        //Run As GEMS User
        system.RunAs(testuser1){
            Case testcase1 = [select id from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
            //Release Case
            string message1 = GEMS_LEX_ReleaseScreeningCase.valAccSubBeforeRelease(testcase1.Id);
            system.assertNotEquals(message1,'validated');
            
        }
        
        //Run As GEMS User
        system.RunAs(testuser1){
            Case testcase1 = [select id from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
            //Release Case
            string message2 = GEMS_LEX_ReleaseScreeningCase.valAccSubBeforeRelease('006000000000000000');
            system.assertEquals(message2,'Failed.Please contact GEMS support for assistance');
            
        }
    }
    
    public static testmethod void successvalAccSubBeforeRelease(){
        //Create GEMS User
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
        User testuser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec1.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser1 ;
        
        //Create LGNA User 
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='LGNA - Account Management'];
        User testuser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec2.Id, 'test2@user22.com', 'testUser2', 'test2@user.com');
        insert testuser2 ;
        
        //Create Product
        Product2 testprd1= GEMS_UtilityClassTest.insertionProduct();
        insert testprd1;
        
        //Run As LGNA User
        system.RunAs(testuser2){
            Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
            Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
            
            //Create Account
            Account testaccount1 = GEMS_UtilityClassTest.insertionAccount();
            insert testaccount1;
            //Create Opportunity
            Opportunity testOpp1 = GEMS_UtilityClassTest.insertionOpp(testaccount1.Id);
            insert testOpp1; 
            //Create Opportunity Product
            Opportunity_Product__c  testOppProd1 = GEMS_UtilityClassTest.insertionOppProd8(testprd1.Id,testOpp1 .Id);
            testOppProd1.Incumbent__c = testCompetitorAccount.Id;
            insert testOppProd1;
            //Create Case
            Case testcase1 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
            testcase1.accountId = testaccount1.Id;
            testcase1.Opportunity_Name__c = testOpp1.Id;
            testcase1.ownerId = testuser1.Id;
            testcase1.GEMS_OE_Eligibility_Method__c = 'Portal';
            testcase1.GEMS_SBC_Required__c = 'Yes';
            testcase1.GEMS_ID_Cards_Format__c  = 'Standard';
            testcase1.GEMS_Benefit_Booklet_Required__c = 'Yes';
            testcase1.GEMS_Maint_Eligibility_Method__c = 'Portal';
            testcase1.GEMS_Target_Date_Production_OE_File__c = Date.valueOf('2017-09-11 21:34:07');
            insert testcase1;
        }
        
        //Run As GEMS User
        system.RunAs(testuser1){
            Case testcase1 = [select id from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
            //Release Case
            string message1 = GEMS_LEX_ReleaseScreeningCase.valAccSubBeforeRelease(testcase1.Id);
            system.assertEquals(message1,'validated');
        }
    }
    
    public static testmethod void failurevalAccSubBeforeCreateAcctStruct(){  
        //Create GEMS User
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
        User testuser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec1.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser1 ;
        
        //Create LGNA User 
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='LGNA - Account Management'];
        User testuser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec2.Id, 'test2@user22.com', 'testUser2', 'test2@user.com');
        insert testuser2 ;
        
        //Create Product
        Product2 testprd1= GEMS_UtilityClassTest.insertionProduct();
        insert testprd1;
        
        //Run As LGNA User
        system.RunAs(testuser2){
            Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
            Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
            //Create Account
            Account testaccount1 = GEMS_UtilityClassTest.insertionAccount();
            insert testaccount1;
            //Create Opportunity
            Opportunity testOpp1 = GEMS_UtilityClassTest.insertionOpp(testaccount1.Id);
            insert testOpp1; 
            //Create Opportunity Product
            Opportunity_Product__c  testOppProd1 = GEMS_UtilityClassTest.insertionOppProd8(testprd1.Id,testOpp1 .Id);
            testOppProd1.Incumbent__c = testCompetitorAccount.Id;
            insert testOppProd1;
            //Create Case
            Case testcase1 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
            testcase1.accountId = testaccount1.Id;
            testcase1.Opportunity_Name__c = testOpp1.Id;
            testcase1.ownerId = testuser1.Id;
            insert testcase1;
        }
        
        //Run As GEMS User
        system.RunAs(testuser1){
            Case testcase1 = [select id from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
            //Release Case
            string message1 = GEMS_LEX_ReleaseScreeningCase.valAccSubBeforeCreateAcctStruct(testcase1.Id);
            system.assertNotEquals(message1,'validated');
            
        }
        
        //Run As GEMS User
        system.RunAs(testuser1){
            Case testcase1 = [select id from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
            //Release Case
            string message2 = GEMS_LEX_ReleaseScreeningCase.valAccSubBeforeCreateAcctStruct('006000000000000000');
            system.assertEquals(message2,'Failed.Please contact GEMS support for assistance');
            
        }
    }
    
    public static testmethod void successvalAccSubBeforeCreateAcctStruct(){
        //Create GEMS User
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
        User testuser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec1.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser1 ;
        
        //Create LGNA User 
        Profile profileRec2 = [SELECT Id FROM Profile WHERE Name='LGNA - Account Management'];
        User testuser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec2.Id, 'test2@user22.com', 'testUser2', 'test2@user.com');
        insert testuser2 ;
        
        //Create Product
        Product2 testprd1= GEMS_UtilityClassTest.insertionProduct();
        insert testprd1;
        
        //Run As LGNA User
        system.RunAs(testuser2){
            Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
            Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
            
            //Create Account
            Account testaccount1 = GEMS_UtilityClassTest.insertionAccount();
            insert testaccount1;
            //Create Opportunity
            Opportunity testOpp1 = GEMS_UtilityClassTest.insertionOpp(testaccount1.Id);
            insert testOpp1; 
            //Create Opportunity Product
            Opportunity_Product__c  testOppProd1 = GEMS_UtilityClassTest.insertionOppProd8(testprd1.Id,testOpp1 .Id);
            testOppProd1.Incumbent__c = testCompetitorAccount.Id;
            insert testOppProd1;
            //Create Case
            Case testcase1 = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
            testcase1.accountId = testaccount1.Id;
            testcase1.Opportunity_Name__c = testOpp1.Id;
            testcase1.ownerId = testuser1.Id;
            testcase1.GEMS_OE_Eligibility_Method__c = 'Portal';
            testcase1.GEMS_SBC_Required__c = 'Yes';
            testcase1.GEMS_ID_Cards_Format__c  = 'Standard';
            testcase1.GEMS_Benefit_Booklet_Required__c = 'Yes';
            testcase1.GEMS_Maint_Eligibility_Method__c = 'Portal';
            testcase1.GEMS_Target_Date_Production_OE_File__c = Date.valueOf('2017-09-11 21:34:07');
            insert testcase1;
        }
        
        //Run As GEMS User
        system.RunAs(testuser1){
            Case testcase1 = [select id from Case where RecordType.Name = 'GEMS Account Submission' LIMIT 1];
            //Release Case
            string message1 = GEMS_LEX_ReleaseScreeningCase.valAccSubBeforeCreateAcctStruct(testcase1.Id);
            system.assertEquals(message1,'validated');
        }
    }
}