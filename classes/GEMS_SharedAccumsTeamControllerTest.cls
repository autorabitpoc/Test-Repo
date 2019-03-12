/**************************************************************************************
Apex Class Name     : GEMS_SharedAccumsTeamControllerTest 
Version             : 1.0
Function            : GEMS_SharedAccumsTeamControllerTest
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jenny                       06/01/2018             Original Version
* Gokul Bharati               06/21/2018             SFDC-10379 GEMS: Allow only current assignee to close Shared Accums Forms
*************************************************************************************/
@isTest
public class GEMS_SharedAccumsTeamControllerTest {
    
    @testSetUp
    private static void setUpData(){
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);  
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        //Ranjit    SFDC-2074 Create Account Structure case 
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        
        GEMS_Benefit_Agreement__c benefit = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subRec.id,product2Rec.id); 
        benefit.AccountStructureCase__c = subStrRec.Id; 
        insert benefit ;
        
        GEMS_Shared_Accums__c sharedAccums =new GEMS_Shared_Accums__c();
        sharedAccums.GEMS_Case__c=subRec.id;
        sharedAccums.Benefit_Agreement__c=benefit.id;                        
        sharedAccums.Accum_Period__c='Calendar Year';    
        sharedAccums.Shared_Accums_Effective_Date__c=Date.today();
        sharedAccums.HCSC_responsible_for_Vendor_Eligibility__c='Yes';
        boolean s = false;   
        boolean s2 = true;                         
        sharedAccums.Deductible__c= true;
        sharedAccums.Aggregate_or_Embedded_Deductible__c='Aggregate';
        Decimal d1 = 5000;
        Decimal d2 = 7000;
        Decimal d3 = 9000;
        sharedAccums.Individual_Deductible_Amount__c=d1;               
        sharedAccums.Family_Deductible_Amount__c=null;    
        sharedAccums.Does_Deductible_apply_to_Out_of_Pocket__c='';
        sharedAccums.Does_Copay_apply_to_Out_of_Pocket__c='';
        sharedAccums.Out_of_Pocket__c=s2;
        sharedAccums.Aggregate_or_Embedded_Out_of_Pocket__c='';
        sharedAccums.Individual_Out_of_Pocket_Amount__c=Null;                     
        sharedAccums.Family_Out_of_Pocket_Amount__c=null;               
        sharedAccums.Lifetime_Maximum__c=true;            
        sharedAccums.Amount__c=null;
        sharedAccums.Accums_Shared_With__c='';
        sharedAccums.Accums_Feeding_feaking__c='';
        sharedAccums.Shared_Accum_ID__c='';
        sharedAccums.Shared_Accum_with_Vendor_Using__c='';
        insert sharedAccums;      
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>'+sharedAccums);
    }
    
    private static testmethod void AsSystemAdminFormSelectedInProgress(){
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Test.startTest();       
        PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getParameters().put('id', subRec.id);
        GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();
        obj.str = 'In Progress';
        obj.getStatus(); 
        system.debug('Shared Accums List >>>>>>' +obj.sharedAccumsList);
        for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
            wrp.selected = true; 
        }
        obj.processSelected();
        obj.Cancelform();
        Test.stopTest();  
    }
    
    private static testmethod void AsSystemAdminFormNotSelectedInProgress(){
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Test.startTest();       
        PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getParameters().put('id', subRec.id);
        GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();   
        obj.str = 'In Progress';
        obj.getStatus();
        system.debug('Shared Accums List >>>>>>' +obj.sharedAccumsList);
        for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
            wrp.selected = false; 
        } 
        obj.processSelected();
        obj.Cancelform();
        Test.stopTest();
    }
    
    private static testmethod void AsSystemAdminFormSelectedCompleted(){
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Test.startTest();       
        PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getParameters().put('id', subRec.id);
        GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();
        obj.str = 'Completed';
        obj.teamMember.Completion_date__c = Date.Today();
        obj.getStatus(); 
        system.debug('Shared Accums List >>>>>>' +obj.sharedAccumsList);
        for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
            wrp.selected = true; 
        }
        obj.processSelected();
        obj.Cancelform();
        Test.stopTest();  
    }
    
    
    private static testmethod void AsSystemAdminFormNotSelectedCompleted(){
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Test.startTest();       
        PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getParameters().put('id', subRec.id);
        GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();
        obj.str = 'Completed';
        obj.teamMember.Completion_date__c = Date.Today();
        obj.getStatus();
        system.debug('Shared Accums List >>>>>>' +obj.sharedAccumsList);
        for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
            wrp.selected = false; 
        } 
        obj.processSelected();
        obj.Cancelform();
        Test.stopTest();
    }
    
    private static testmethod void AsSystemAdminFormSelectedCompletedDateNULL(){
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Test.startTest();       
        PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getParameters().put('id', subRec.id);
        GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();
        obj.str = 'Completed';
        obj.teamMember.Completion_date__c = NULL;
        obj.getStatus(); 
        system.debug('Shared Accums List >>>>>>' +obj.sharedAccumsList);
        for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
            wrp.selected = true; 
        }
        obj.processSelected();
        obj.Cancelform();
        Test.stopTest();  
    }
    
    private static testmethod void AsSystemAdminFormSelectedInProgressToNew(){
        
        List<GEMS_Shared_Accums__c> sharedAccumList = [select id,status__c from GEMS_Shared_Accums__c];
        for(GEMS_Shared_Accums__c  sa:sharedAccumList){
            sa.status__c = 'In Progress';
        }
        update sharedAccumList;
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Test.startTest();       
        PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getParameters().put('id', subRec.id);
        GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();
        obj.getStatus(); 
        obj.str = 'new';
        for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
            wrp.selected = true; 
        }
        obj.processSelected();
        obj.Cancelform();
        Test.stopTest();  
    }
    
    private static testmethod void NonSystemAdminFormSelectedCompleted(){
        List<GEMS_Shared_Accums__c> sharedAccumList = [select id,status__c from GEMS_Shared_Accums__c];
        for(GEMS_Shared_Accums__c  sa:sharedAccumList){
            sa.Shared_Accums_Team_Member__c = UserInfo.getUserId();
        }
        update sharedAccumList;
        Case subRec = [Select id, recordtype.id from case where recordtype.Name='GEMS Account Submission'];
        Profile prof = [SELECT ID  FROM Profile WHERE Name='GEMS Account Submitter' LIMIT 1];
        User usr = GEMS_UtilityClassTest.CreateUserRecord(prof.Id,'sharedaccumstest@test.com','testName','sharedaccumstest@test.com');
        insert usr;
        system.runAs(usr){
            Test.startTest();       
            PageReference pageRef = Page.GEMS_SharedAccumsTeamDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentpage().getParameters().put('id', subRec.id);
            GEMS_SharedAccumsTeamController obj = new GEMS_SharedAccumsTeamController();
            obj.str = 'Completed';
            obj.getStatus();
            obj.lstStatus = obj.getStatus();
            obj.teamMember.Shared_Accums_Team_Member__c = usr.Id;
            obj.teamMember.Completion_date__c = Date.Today();
            for(GEMS_SharedAccumsTeamController.wrapperSharedAccums wrp: obj.sharedAccumsList){
                wrp.selected = true; 
            } 
            obj.processSelected();
            obj.Cancelform();
            Test.stopTest();
        }
    }
}