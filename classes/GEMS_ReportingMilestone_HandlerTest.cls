/* This test class tests both the GEMS_ReportingMilestone_Handler and GEMS_ReportingMilestoneUtil classes
 * Update History:
 * 09-28-2017   Luke Chen   SFDC-6129,6871,6872 GEMS Reporting Milestone
 * 
 */
@isTest
private class GEMS_ReportingMilestone_HandlerTest{

    private static testmethod void testProcessReportingMilestone00(){
        // this is just to test GEMSReportingMilestoneTrackingTrigger trigger with dummy case due to trigger coverage error only in PROD
        Account a = new Account();
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        a.Name = 'ReportingTrackingAcct';
        a.HCSC_Division__c = 'IL';
        insert a;
        Case c = new Case();
        c.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('LGNA - General Case').getRecordTypeId();
        c.Subject = 'test';
        c.Description = 'test';
        c.Type = 'Other';
        c.status = 'New';
        c.Priority = 'Low';
        c.Complexity__c = 'Level 1';
        c.account = a;
        insert c;
        
        // trigger GEMS_ReportingMilestone_Tracking__c trigger
        GEMS_ReportingMilestone_Tracking__c t = new GEMS_ReportingMilestone_Tracking__c();
        t.Submission_Case__c = c.id;
        insert t;
        t.Milestone__c = 'Member Ready';
        t.Milestone_Date__c = system.now();
        update t;
        t.Milestone__c = 'Service Ready';
        update t;
    }
    
    private static testmethod void testProcessReportingMilestone01(){
        // GEMS Medical Underwriting;GEMS Dental Underwriting;GEMS Additional Underwriting;GEMS ID Card;GEMS Dental Benefit Coding;GEMS Membership
        // data setup START
        List<Case> upsertCases = new List<Case>();
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
       Case subCase = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
       subCase.status = 'In Progress';
       subCase.GEMS_Submission_Type__c = 'New Account';
       subCase.GEMS_Submission_Sub_Type__c = null;
       subCase.GEMS_StdCust_Product__c = 'Standard Products only';
       subCase.GEMS_Ready_to_release_to_screening__c = 'Released';
       subCase.GEMS_Rx_Vendor__c = 'Prime';
       subCase.GEMS_Products__c = 'Dental;RX';
       subCase.accountId = acc.Id;
       insert subCase;  // upsertCases.add(subCase);
       
       // #TODO the dental and medical coding/UW will soon to use BA's info instead of the submission case's GEMS_Products__c field
       //       To use BAs, we need to add BAs to below struCase
       Case struCase= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
       struCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       struCase.accountId = acc.Id;
       struCase.status = 'In Progress';
      // insert struCase; 
       upsertCases.add(struCase);
       
       Case medUw= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
       medUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       medUw.accountId = acc.Id;
       medUw.status = 'Approved';
       upsertCases.add(medUw);    
       // insert  medUw; 
       Case denUw= GEMS_UtilityClassTest.insertionCase('GEMS Dental Underwriting');
       denUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       denUw.accountId = acc.Id;
       denUw.status = 'Approved';
       upsertCases.add(denUw);   
       // insert   denUw; 
       Case addUw= GEMS_UtilityClassTest.insertionCase('GEMS Additional Underwriting');
       addUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       addUw.accountId = acc.Id;
       addUw.status = 'Approved';
       upsertCases.add(addUw);  
       // insert  addUw;    
       Case idCase= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
       idCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       idCase.accountId = acc.Id;
       idCase.GEMS_ID_Cards_Format__c='Custom';
       idCase.status = 'New';
       idCase.parentid = subCase.Id;
       upsertCases.add(idCase);  
       // insert idCase;    
       Case denCoding= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
       denCoding.GEMS_Account_Submission_Info__c  = subCase.Id;
       denCoding.accountId = acc.Id;
       denCoding.status = 'In Progress';
       upsertCases.add(denCoding);  
       // insert denCoding; 
       Case memCase= GEMS_UtilityClassTest.insertionCase('GEMS Membership');
       memCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       memCase.accountId = acc.Id;
       memCase.status = 'In Progress';
       upsertCases.add(memCase); 
       // insert memCase;
       
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
        caseteammember tm = gems_utilityclasstest.insertioncaseteam(subCase.id,'Additional Underwriter');
        tm.MemberID = testUser1.ID;
        insert tm;
        upsert upsertCases;
       // data setup END

        // test Member Ready
        memCase.status = 'Completed';
        update memCase;
        // test Member Ready + ID card
        idCase.GEMS_ID_card_mailed_date__c = system.today();
        update idCase;
        // test Service Ready
        denCoding.status = 'Completed';
        update denCoding;
        
        // reset release
        subCase.GEMS_Ready_to_release_to_screening__c = 'Ready to Release';
        memCase.status = 'In Progress';
        List<Case> list1 = new List<Case>(); list1.add(subCase); list1.add(memCase);
        update list1;
        
        // re-release and test milestone again
        subCase.GEMS_Ready_to_release_to_screening__c = 'Released';
        memCase.status = 'Completed';
        List<Case> list2 = new List<Case>(); list2.add(subCase); list2.add(memCase);
        update list2;

    }
    
    private static testmethod void testProcessReportingMilestone02(){
        // GEMS Medical Underwriting;GEMS Dental Underwriting;GEMS Additional Underwriting;GEMS ID Card;GEMS Dental Benefit Coding;GEMS Membership
        // data setup START
        List<Case> upsertCases = new List<Case>();
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
       Case subCase = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
       subCase.status = 'In Progress';
       subCase.GEMS_Submission_Type__c = 'Renewal';
       subCase.GEMS_Submission_Sub_Type__c = 'Account Structure Change; Benefit Change';
       subCase.GEMS_StdCust_Product__c = 'Standard Products only';
       subCase.GEMS_Ready_to_release_to_screening__c = 'Released';
       subCase.GEMS_Rx_Vendor__c = 'Prime';
       subCase.GEMS_Products__c = 'Dental;RX';
       subCase.accountId = acc.Id;
       insert subCase;  upsertCases.add(subCase);
       
       // #TODO the dental and medical coding/UW will soon to use BA's info instead of the submission case's GEMS_Products__c field
       //       To use BAs, we need to add BAs to below struCase
       Case struCase= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
       struCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       struCase.accountId = acc.Id;
       struCase.status = 'In Progress';
      // insert struCase; 
       upsertCases.add(struCase);
       
       Case medUw= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
       medUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       medUw.accountId = acc.Id;
       medUw.status = 'Approved';
       upsertCases.add(medUw);    
       // insert  medUw; 
       Case denUw= GEMS_UtilityClassTest.insertionCase('GEMS Dental Underwriting');
       denUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       denUw.accountId = acc.Id;
       denUw.status = 'Approved';
       upsertCases.add(denUw);   
       // insert   denUw; 
       Case addUw= GEMS_UtilityClassTest.insertionCase('GEMS Additional Underwriting');
       addUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       addUw.accountId = acc.Id;
       addUw.status = 'Approved';
       upsertCases.add(addUw);  
       // insert  addUw;    
       Case idCase= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
       idCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       idCase.accountId = acc.Id;
       idCase.GEMS_ID_Cards_Format__c='Custom';
       idCase.status = 'New';
       idCase.parentid = subCase.Id;
       upsertCases.add(idCase);  
       // insert idCase;    
       Case denCoding= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
       denCoding.GEMS_Account_Submission_Info__c  = subCase.Id;
       denCoding.accountId = acc.Id;
       denCoding.status = 'In Progress';
       upsertCases.add(denCoding);  
       // insert denCoding; 
       Case memCase= GEMS_UtilityClassTest.insertionCase('GEMS Membership');
       memCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       memCase.accountId = acc.Id;
       memCase.status = 'In Progress';
       upsertCases.add(memCase); 
       // insert memCase;
       
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
        caseteammember tm = gems_utilityclasstest.insertioncaseteam(subCase.id,'Additional Underwriter');
        tm.MemberID = testUser1.ID;
        insert tm;
        upsert upsertCases;
       // data setup END

        // test Member Ready
        memCase.status = 'Completed';
        update memCase;
        // test Member Ready + ID card
        idCase.GEMS_ID_card_mailed_date__c = system.today();
        update idCase;
        // test Service Ready
        denCoding.status = 'Completed';
        update denCoding;
        
        // reset release
        subCase.GEMS_Ready_to_release_to_screening__c = 'Ready to Release';
        memCase.status = 'In Progress';
        List<Case> list1 = new List<Case>(); list1.add(subCase); list1.add(memCase);
        update list1;
        
        // re-release and test milestone again
        subCase.GEMS_Ready_to_release_to_screening__c = 'Released';
        memCase.status = 'Completed';
        List<Case> list2 = new List<Case>(); list2.add(subCase); list2.add(memCase);
        update list2;
    }

    /*
     * This method is to test the code for Check_Dental_Coding__c, Check_Medical_Coding__c, Check_Rx_Coding__c fields
     * added to tracking object due to SFDC-7461,7462,7463
     */
    private static testmethod void testProcessReportingMilestone03(){
        // data setup START
        List<Case> upsertCases = new List<Case>();
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
       Case subCase = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
       subCase.status = 'In Progress';
       subCase.GEMS_Submission_Type__c = 'Renewal';
       subCase.GEMS_Submission_Sub_Type__c = 'Account Structure Change; Benefit Change';
       subCase.GEMS_StdCust_Product__c = 'Custom Products only';
       subCase.GEMS_Ready_to_release_to_screening__c = 'Released';
       subCase.GEMS_Rx_Vendor__c = 'Prime';
       subCase.GEMS_Products__c = 'Dental;RX';
       subCase.accountId = acc.Id;
       insert subCase;  upsertCases.add(subCase);

       Case struCase= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
       struCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       struCase.accountId = acc.Id;
       struCase.status = 'In Progress';
      // insert struCase; 
       upsertCases.add(struCase);
       
       Case medUw= GEMS_UtilityClassTest.insertionCase('GEMS Screening');
       medUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       medUw.accountId = acc.Id;
       medUw.Sub_Category__c = 'Benefit Coding Screening';
       medUw.status = 'In Progress';
       upsertCases.add(medUw);    
       // insert  medUw; 
       Case denUw= GEMS_UtilityClassTest.insertionCase('GEMS Screening');
       denUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       denUw.accountId = acc.Id;
       denUw.Sub_Category__c = 'Dental Benefit Coding Screening';
       denUw.status = 'In Progress';
       upsertCases.add(denUw);   
       // insert   denUw; 
       Case addUw= GEMS_UtilityClassTest.insertionCase('GEMS Screening');
       addUw.GEMS_Account_Submission_Info__c  = subCase.Id;
       addUw.accountId = acc.Id;
       addUw.Sub_Category__c = 'Pharmacy Coding Screening';
       addUw.status = 'In Progress';
       upsertCases.add(addUw);  
       // insert  addUw;    
       Case idCase= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
       idCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       idCase.accountId = acc.Id;
       idCase.GEMS_ID_Cards_Format__c='Custom';
       idCase.status = 'New';
       idCase.parentid = subCase.Id;
       upsertCases.add(idCase);  
       // insert idCase;    
       Case memCase= GEMS_UtilityClassTest.insertionCase('GEMS Membership');
       memCase.GEMS_Account_Submission_Info__c  = subCase.Id;
       memCase.accountId = acc.Id;
       memCase.status = 'In Progress';
       upsertCases.add(memCase); 
       // insert memCase;
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
        caseteammember tm = gems_utilityclasstest.insertioncaseteam(subCase.id,'Additional Underwriter');
        tm.MemberID = testUser1.ID;
        insert tm;
        upsert upsertCases;
       // data setup END
        memCase.status = 'Completed';
        update memCase;
        medUw.status = 'Routed In Error';
        update medUw;
        denUw.status = 'Routed In Error';
        update denUw;
        addUw.status = 'Routed In Error';
        update addUw;
    }
}