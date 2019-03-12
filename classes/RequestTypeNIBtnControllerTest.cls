@isTest
public class RequestTypeNIBtnControllerTest {
    static testMethod void testdetailpage6() {
        Case Nitestcase;
        List<Request_Type__c> rType;
        Id NIRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
        
        Nitestcase = new Case();
        Nitestcase.Subject= 'oct test';
        Nitestcase.Status= 'New';
        Nitestcase.Local_Contracts__c=23;
        Nitestcase.National_Contracts__c= 34;
        Nitestcase.Network_Designation__c= 'CA Cross';
        Nitestcase.Cost_Center__c=16;
        Nitestcase.Legal_Name__c='testtss';
        Nitestcase.RecordTypeId =NIRecordTypeIdCase;
        insert Nitestcase;
        
        rType =new List<Request_Type__c>();
        Request_Type__c rtc = new Request_Type__c();
        rtc.number_of_requests__c=5;
        rtc.Proposal_NI_Type__c='GeoAccess';
        rtc.Case__c=Nitestcase.Id;
        rType.add(rtc);
        insert rType;
        
        Nitestcase.Bypass_Validation__c = true;
        update Nitestcase;

        Test.startTest(); 
        PageReference testPage=Page.LGNA_RequestTypeButtonNI;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id',Nitestcase.Id);
        RequestTypeNIBtnController controllersma1 = new RequestTypeNIBtnController(new ApexPages.StandardSetController(rType));
        controllersma1.CaseSubmitFunctionAddNI();   
        controllersma1.caseSubmitAddorEditNItype();

        Test.stopTest();
    }
}