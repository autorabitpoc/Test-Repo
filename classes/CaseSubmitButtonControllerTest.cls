/**************************************************************************************
Apex Class Name     : CaseSubmitButtonController 
Version             : 1.0
Function            : This is Test Class for CaseSubmitButtonController
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Sujatha Gondi       10/17/2017                Original Version
*************************************************************************************/
@isTest
public class CaseSubmitButtonControllerTest {
    static testMethod void testdetailpage12() {
        Case testcase,testcasepg,Nitestcase,Nitestcase2,PEtestcase,PEBtestcase;
        Blue_Directions_LOB__c bdLob;
        
        Id PGRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Performance Guarantee').getRecordTypeId();
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        Id PEBRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Private Exchange - Blue Directions').getRecordTypeId();
        Id PEERecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Private Exchange - External').getRecordTypeId();
        //Id bdedentalRecordTypeIdCase = Schema.SObjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get('Blue Directions - Dental').getRecordTypeId();
        // Id bdemedicalRecordTypeIdCase = Schema.SObjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get('Blue Directions - Medical').getRecordTypeId();
        // Id bdedRecordTypeIdCase = Schema.SObjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get('External - Dental').getRecordTypeId();
        Id bdemRecordTypeIdCase = Schema.SObjectType.Blue_Directions_LOB__c.getRecordTypeInfosByName().get('External - Medical').getRecordTypeId();
        
        testcase = new Case();
        testcase.Subject= 'totest';
        testcase.Status= 'New';
        testcase.Local_Contracts__c=1;
        testcase.National_Contracts__c= 2;
        testcase.Network_Designation__c= 'CA Cross';
        testcase.Cost_Center__c=16;
        testcase.Legal_Name__c='tes';
        testcase.RecordTypeId =PGRecordTypeIdCase;
        testcase.Group_Status__c = 'New Sold Group';
        testcase.Expected_Dental_Contracts__c = 10;
        testcase.Expected_Health_Contracts__c  = 5;
        insert testcase;
        
        
        testcasepg = new Case();
        testcasepg.Subject= 'todfdtest';
        testcasepg.Status= 'Inprogress';
        testcasepg.Local_Contracts__c=13;
        testcasepg.Medical_Guarantees__c='500 – 999 contracts';
        testcasepg.National_Contracts__c= 14;
        testcasepg.Network_Designation__c= 'CA Cross';
        testcasepg.Cost_Center__c=67;
        testcasepg.Legal_Name__c='gdfgdfgdfg';
        testcasepg.RecordTypeId =PGRecordTypeIdCase;
        testcasepg.Group_Status__c = 'New Sold Group';
        testcasepg.Expected_Dental_Contracts__c = 10;
        testcasepg.Expected_Health_Contracts__c  = 5;
        insert testcasepg;
        
        Nitestcase = new Case();
        Nitestcase.Subject= 'today test';
        Nitestcase.Status= 'New';
        Nitestcase.Local_Contracts__c=5;
        Nitestcase.National_Contracts__c= 6;
        Nitestcase.Network_Designation__c= 'CA Cross';
        Nitestcase.Cost_Center__c=10;
        //  Nitestcase.NI_Return_Date__c =mydate;
        Nitestcase.RecordTypeId =NIRecordTypeIdCase;
        insert Nitestcase;
        
        PEtestcase = new Case();
        PEtestcase.Subject= 'today test';
        PEtestcase.Status= 'New';
        PEtestcase.Local_Contracts__c=43;
        PEtestcase.National_Contracts__c= 4;
        PEtestcase.Network_Designation__c= 'CA Cross';
        PEtestcase.Cost_Center__c=15;
        PEtestcase.Legal_Name__c='ttss';
        //PEtestcase.RecordTypeId =PEERecordTypeIdCase;
        insert PEtestcase;
        PEtestcase.RecordTypeId =PEERecordTypeIdCase;
        update PEtestcase;
        
        
        PEBtestcase = new Case();
        PEBtestcase.Subject= 'today test';
        PEBtestcase.Status= 'New';
        PEBtestcase.Local_Contracts__c=63;
        PEBtestcase.National_Contracts__c=23;
        PEBtestcase.Network_Designation__c= 'CA Cross';
        PEBtestcase.Cost_Center__c=15;
        PEBtestcase.Legal_Name__c='twerewttss';
        insert PEBtestcase;
        PEBtestcase.RecordTypeId =PEERecordTypeIdCase;
        update PEBtestcase;
        
        bdLob =new Blue_Directions_LOB__c();
        bdLob.Case_Number__c =PEBtestcase.Id;
        bdLob.RecordTypeId=bdemRecordTypeIdCase;
        //bdLob.RecordTypeId=bdedRecordTypeIdCase;
        insert bdLob;
        
        //KK Added for Proposal Submit Button 6/25/2018 Start
        
        Id ProposalRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        
        Case testcaseProposal;
        testcaseProposal = new Case();
        testcaseProposal.Subject= 'todfdtest';
        testcaseProposal.Status= 'Inprogress';
        testcaseProposal.Local_Contracts__c=13;
        testcaseProposal.Medical_Guarantees__c='500 – 999 contracts';
        testcaseProposal.National_Contracts__c= 14;
        testcaseProposal.Network_Designation__c= 'CA Cross';
        testcaseProposal.Cost_Center__c=67;
        testcaseProposal.Legal_Name__c='gdfgdfgdfg';
        testcaseProposal.RecordTypeId =ProposalRecordTypeIdCase;
        testcaseProposal.Group_Status__c = 'New Sold Group';
        testcaseProposal.Expected_Dental_Contracts__c = 10;
        testcaseProposal.Expected_Health_Contracts__c  = 5;
        testcaseProposal.ppo__c = 'EPO';
        insert testcaseProposal;
        //KK Added for Proposal Submit Button 6/25/2018 End
        
        
        
        Test.startTest();
        PageReference testPage=Page.CaseSubmitButtons;
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('id',testcase.Id);
        
        CaseSubmitButtonController controller = new CaseSubmitButtonController(new ApexPages.StandardController(testcase));
        CaseSubmitButtonController controller1 = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase));
        CaseSubmitButtonController controller2 = new CaseSubmitButtonController(new ApexPages.StandardController(PEBtestcase));
        CaseSubmitButtonController controller3 = new CaseSubmitButtonController(new ApexPages.StandardController(PEtestcase));
        CaseSubmitButtonController controllersubpg = new CaseSubmitButtonController(new ApexPages.StandardController(testcasepg));
        //KK Added for Proposal Submit Button 6/25/2018 Start
        CaseSubmitButtonController controller4 = new CaseSubmitButtonController(new ApexPages.StandardController(testcaseProposal));
        //KK Added for Proposal Submit Button 6/25/2018 End
        
        controller.CaseSubmitFunction();
        controller1.CaseSubmitFunction();
        controller2.CaseSubmitFunction();
        controller3.CaseSubmitFunction();
        //KK Added for Proposal Submit Button 6/25/2018 Start
        controller4.CaseSubmitFunction();
        //KK Added for Proposal Submit Button 6/25/2018 End
        controller1.CaseSubmitFunctionAddNI();
        controller2.caseSubmitPEBDorPEE();
        controller3.caseSubmitPEBDorPEE();
        //KK Added for Proposal Submit Button 6/25/2018 Start
        controller4.ProposalTypeSubmit();
        //KK Added for Proposal Submit Button 6/25/2018 End
        controllersubpg.caseSubmitPgRequest();
        
        Test.stopTest();    
        
    }
    static testMethod void testdetailpage() {
        Case testcase,testcasepg,Nitestcase,Nitestcase2,PEtestcase,PEBtestcase;
        Request_Type__c rType;
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        //Date mydate=Date.today();
        
        Nitestcase2 = new Case();
        Nitestcase2.Subject= 'oct test';
        Nitestcase2.Status= 'New';
        Nitestcase2.Local_Contracts__c=23;
        Nitestcase2.National_Contracts__c= 34;
        Nitestcase2.Network_Designation__c= 'CA Cross';
        Nitestcase2.Cost_Center__c=16;
        // Nitestcase2.NI_Return_Date__c =mydate;
        Nitestcase2.Legal_Name__c='testtss';
        Nitestcase2.RecordTypeId =NIRecordTypeIdCase;
        Nitestcase2.Standard_Medical_Access_Criteria__c='Dental Standard USR';
        insert Nitestcase2;
        
        rType =new Request_Type__c();
        rType.number_of_requests__c=2;
        rType.Proposal_NI_Type__c='GeoAccess';
        rType.Case__c=Nitestcase2.Id;
        insert rType;
        
        Test.startTest();
        PageReference testPage=Page.CaseSubmitButtons;
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('id',Nitestcase2.Id);
        CaseSubmitButtonController controllerNiGeo = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase2));
        controllerNiGeo.CaseSubmitFunction();
        Test.stopTest();
    }
    
    
    static testMethod void testdetailpage3() {
        Case Nitestcase3;
        Request_Type__c rType1;
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        //Date mydate=Date.today();
        
        Nitestcase3 = new Case();
        Nitestcase3.Subject= 'oct test';
        Nitestcase3.Status= 'New';
        Nitestcase3.Local_Contracts__c=23;
        Nitestcase3.National_Contracts__c= 34;
        Nitestcase3.Network_Designation__c= 'CA Cross';
        Nitestcase3.Cost_Center__c=16;
        //Nitestcase3.NI_Return_Date__c =mydate;
        Nitestcase3.Legal_Name__c='testtss';
        Nitestcase3.RecordTypeId =NIRecordTypeIdCase;
        Nitestcase3.Standard_Medical_Access_Criteria__c='Dental Standard USR';
        insert Nitestcase3;
        
        rType1 =new Request_Type__c();
        rType1.number_of_requests__c=5;
        rType1.Proposal_NI_Type__c='Radius Page';
        rType1.Case__c=Nitestcase3.Id;
        insert rType1;
        
        Test.startTest();
        PageReference testPage=Page.CaseSubmitButtons;
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('id',Nitestcase3.Id);
        CaseSubmitButtonController controllerNinor = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase3));
        controllerNinor.CaseSubmitFunction();
        Test.stopTest();
    }
    
    static testMethod void testdetailpage4() {
        Case Nitestcase4;
        Request_Type__c rType2;
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        date myDate = date.today();
        system.debug('date toasdfsdf'+ConstantsController.hpsPerformanceMetricDateRequired);
        system.debug('test date today'+myDate);
        system.debug('test date'+date.today());
        Nitestcase4 = new Case();
        Nitestcase4.Subject= 'oct test';
        Nitestcase4.Status= 'New';
        Nitestcase4.Local_Contracts__c=23;
        Nitestcase4.National_Contracts__c= 34;
        Nitestcase4.Network_Designation__c= 'CA Cross';
        Nitestcase4.Cost_Center__c=16;
        //Nitestcase4.NI_Return_Date__c =mydate;
        Nitestcase4.Legal_Name__c='testtss';
        Nitestcase4.RecordTypeId =NIRecordTypeIdCase;
        Nitestcase4.Standard_Medical_Access_Criteria__c='Dental Standard USR';
        insert Nitestcase4;
        
        rType2 =new Request_Type__c();
        rType2.number_of_requests__c=5;
        rType2.Proposal_NI_Type__c='Provider Counts';
        rType2.Case__c=Nitestcase4.Id;
        insert rType2;
        
        Test.startTest();
        PageReference testPage=Page.CaseSubmitButtons;
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('id',Nitestcase4.Id);
        CaseSubmitButtonController controllerNipc = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase4));
        controllerNipc.CaseSubmitFunction();
        Test.stopTest();
    }
    static testMethod void testdetailpage5() {
        Case Nitestcase5;
        Request_Type__c rType3;
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        
        Nitestcase5 = new Case();
        Nitestcase5.Subject= 'oct test';
        Nitestcase5.Status= 'New';
        Nitestcase5.Local_Contracts__c=23;
        Nitestcase5.National_Contracts__c= 34;
        Nitestcase5.Network_Designation__c= 'CA Cross';
        Nitestcase5.Cost_Center__c=16;
        Nitestcase5.Legal_Name__c='testtss';
        Nitestcase5.RecordTypeId =NIRecordTypeIdCase;
        insert Nitestcase5;
        
        rType3 =new Request_Type__c();
        rType3.number_of_requests__c=5;
        rType3.Proposal_NI_Type__c='Radius Page';
        rType3.Case__c=Nitestcase5.Id;
        insert rType3;
        
        Test.startTest();
        PageReference testPage=Page.CaseSubmitButtons;
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('id',Nitestcase5.Id);
        CaseSubmitButtonController controllersma = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase5));
        controllersma.CaseSubmitFunction();
        Test.stopTest();
    }
    static testMethod void testdetailpage6() {
        Case Nitestcase6;
        Request_Type__c rType4,rType5;
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        
        Nitestcase6 = new Case();
        Nitestcase6.Subject= 'oct test';
        Nitestcase6.Status= 'New';
        Nitestcase6.Local_Contracts__c=23;
        Nitestcase6.National_Contracts__c= 34;
        Nitestcase6.Network_Designation__c= 'CA Cross';
        Nitestcase6.Cost_Center__c=16;
        Nitestcase6.Legal_Name__c='testtss';
        Nitestcase6.RecordTypeId =NIRecordTypeIdCase;
        //Nitestcase6.Owner_Name__c = 'Network Information';
        insert Nitestcase6;
        
        rType4 =new Request_Type__c();
        rType4.number_of_requests__c=5;
        rType4.Proposal_NI_Type__c='GeoAccess';
        rType4.Case__c=Nitestcase6.Id;
        insert rType4;
        
        //  Nitestcase6.Status = 'Assigned';
        Nitestcase6.Bypass_Validation__c = true;
        update Nitestcase6;
        system.debug(Nitestcase6.Record_update_counter__c +'Record_update_counter__c ++++');
        
        Test.startTest(); 
        PageReference testPage=Page.CaseSubmitButtons;
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('id',Nitestcase6.Id);
        CaseSubmitButtonController controllersma1 = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase6));
        controllersma1.CaseSubmitFunction();   
        
        
        controllersma1.caseSubmitAddorEditNItype();
        
        Test.stopTest();
    }
    /*static testMethod void testdetailpage7() {
Case Nitestcase7;
Request_Type__c rType5;
Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();

Nitestcase7 = new Case();
Nitestcase7.Subject= 'oct test';
Nitestcase7.Status= 'New';
Nitestcase7.Local_Contracts__c=23;
Nitestcase7.National_Contracts__c= 34;
Nitestcase7.Network_Designation__c= 'CA Cross';
Nitestcase7.Cost_Center__c=16;
Nitestcase7.Legal_Name__c='testtss';
Nitestcase7.RecordTypeId =NIRecordTypeIdCase;
//Nitestcase7.NI_Return_Date__c =ConstantsController.hpsPerformanceMetricDateRequired;
Nitestcase7.NI_Return_Date__c =Date.newInstance(2017, 12, 9);
insert Nitestcase7;

rType5 =new Request_Type__c();
rType5.number_of_requests__c=5;
rType5.Proposal_NI_Type__c='GeoAccess';
rType5.Case__c=Nitestcase7.Id;
insert rType5;

Test.startTest(); 
PageReference testPage=Page.CaseSubmitButtons;
Test.setCurrentPage(testPage);
ApexPages.currentPage().getParameters().put('id',Nitestcase7.Id);
CaseSubmitButtonController controllersma2 = new CaseSubmitButtonController(new ApexPages.StandardController(Nitestcase7));
controllersma2.CaseSubmitFunction();   
Test.stopTest();
}*/
}