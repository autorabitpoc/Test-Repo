@isTest
public class GEMS_CustomCaseLookupTest {
private static testmethod void GEMS_CustomCaseLookup(){
        
        List<case> csL = new List<case>();
        for(integer i=0;i<2;i++) {
         Case caseObj = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        csL.add(caseObj);
        }
        
        insert csL;
        
          
        Account acc = new Account();
        acc.status__c = 'Sold';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
         Case caseGems = new case();
        caseGems.Accountid = acc.id; 
        caseGems.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseGems.GEMS_ReviewDocuments__c =false;
        caseGems.GEMS_Return_Check__c = false;
        caseGems.GEMS_Approve__c =false;
        caseGems.GEMS_Return__c =false;
        caseGems.GEMS_Routed_In_Error__c = false;
        caseGems.status = 'New';
        caseGems.GEMS_Case_Effective_Date__c = system.today();
        caseGems.GEMS_Effective_Date__c = system.today();
        caseGems.GEMS_Test_File_Receipt_Date__c = system.today();
        caseGems.GEMS_Test_Files_Sent_to_Client_Vendor__c = system.today();
        caseGems.GEMS_Request_for_Reports_Sent_to_ITG__c = system.today();
        caseGems.GEMS_AEP_Reports_Received_from_ITG__c = system.today();
        caseGems.GEMS_Release_to_Compare_date__c  = system.today();
        caseGems.GEMS_Authorization_to_valid_date__c = system.today();
        caseGems.GEMS_Actual_Date_for_Production_File_1__c = system.today();
        caseGems.GEMS_Actual_Date_for_Production_File_2__c = system.today();
        caseGems.GEMS_Target_Date_for_Production_File_1__c = system.today();
        caseGems.GEMS_Target_Date_for_Production_File_2__c = system.today();
        caseGems.Parentid = csL[0].id;
        insert caseGems;
      
        product2 prod = new product2();
        prod.name = 'Accident Insurance (Dearborn)';
        prod.IsActive =true;
        insert prod;
      
        
       List<GEMS_Benefit_Agreement__c> gemBenList = new List<GEMS_Benefit_Agreement__c>();
       GEMS_Benefit_Agreement__c gemObj = new GEMS_Benefit_Agreement__c();
       gemObj.Account__c = acc.id;
       gemObj.AccountStructureCase__c = caseGems.id;
       gemObj.Name = 'Test';
       gemObj.Product__c = prod.id;
       gemBenList.add(gemObj);
       
       insert gemBenList;
       
       GEMS_Shared_Accums__c shrdObj = new GEMS_Shared_Accums__c();
       shrdObj.Benefit_Agreement__c = gemBenList[0].id;
       shrdObj.GEMS_Case__c = caseGems.Id;
       insert shrdObj;
       
         Test.startTest();
        //Test.setCurrentPage(Page.GEMSCaptureGroupSections);
        ApexPages.currentpage().getParameters().put('caseId', caseGems.Id);
        ApexPages.currentpage().getParameters().put('txt', 'testingText');
        ApexPages.currentpage().getParameters().put('lksrch', 'Test');
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(caseGems);
        GEMS_CustomCaseLookupController gemCaseController = new GEMS_CustomCaseLookupController(stdController);
        
        GEMS_CustomCaseLookupController gemCase = new GEMS_CustomCaseLookupController();
  
        gemCase.getFormTag();
        gemCase.search();
        gemCase.getTextBox();
        string searchString;
        gemCase.searchString = 'Testing';
        gemCase.performSearch(searchString);
        Test.stopTest();
        
}

private static testmethod void GEMS_CustomCaseURL(){
        
        List<case> csL = new List<case>();
        for(integer i=0;i<2;i++) {
         Case caseObj = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        csL.add(caseObj);
        }
        
        insert csL;
        
          
        Account acc = new Account();
        acc.status__c = 'Sold';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
         Case caseRec = new case();
        caseRec.Accountid = acc.id; 
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseRec.GEMS_ReviewDocuments__c =false;
        caseRec.GEMS_Return_Check__c = false;
        caseRec.GEMS_Approve__c =false;
        caseRec.GEMS_Return__c =false;
        caseRec.GEMS_Routed_In_Error__c = false;
        caseRec.status = 'New';
        caseRec.GEMS_Case_Effective_Date__c = system.today();
        caseRec.GEMS_Effective_Date__c = system.today();
        caseRec.GEMS_Test_File_Receipt_Date__c = system.today();
        caseRec.GEMS_Test_Files_Sent_to_Client_Vendor__c = system.today();
        caseRec.GEMS_Request_for_Reports_Sent_to_ITG__c = system.today();
        caseRec.GEMS_AEP_Reports_Received_from_ITG__c = system.today();
        caseRec.GEMS_Release_to_Compare_date__c  = system.today();
        caseRec.GEMS_Authorization_to_valid_date__c = system.today();
        caseRec.GEMS_Actual_Date_for_Production_File_1__c = system.today();
        caseRec.GEMS_Actual_Date_for_Production_File_2__c = system.today();
        caseRec.GEMS_Target_Date_for_Production_File_1__c = system.today();
        caseRec.GEMS_Target_Date_for_Production_File_2__c = system.today();
        caseRec.Parentid = csL[0].id;
        insert caseRec;
      
        product2 prod = new product2();
        prod.name = 'Accident Insurance (Dearborn)';
        prod.IsActive =true;
        insert prod;
      
        
       List<GEMS_Benefit_Agreement__c> gemBenList = new List<GEMS_Benefit_Agreement__c>();
       GEMS_Benefit_Agreement__c gemObj = new GEMS_Benefit_Agreement__c();
       gemObj.Account__c = acc.id;
       gemObj.AccountStructureCase__c = caseRec.Id;
       gemObj.Name = 'Test';
       gemObj.Product__c = prod.id;
       gemBenList.add(gemObj);
       
       insert gemBenList;
       
       GEMS_Shared_Accums__c shrdObj = new GEMS_Shared_Accums__c();
       shrdObj.Benefit_Agreement__c = gemBenList[0].id;
       shrdObj.GEMS_Case__c = caseRec.Id;
       insert shrdObj;
       
         Test.startTest();
        //Test.setCurrentPage(Page.GEMSCaptureGroupSections);
        ApexPages.currentpage().getParameters().put('caseId', caseRec.Id);
        ApexPages.currentpage().getParameters().put('txt', 'testingText');
        ApexPages.currentpage().getParameters().put('lksrch', 'Test');
        PageReference pageRef = Page.GEMSCaptureSharedAccums;
        Test.setCurrentPage(pageRef);   
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(caseRec);
        GEMS_CustomCaseLookupController gemCaseController = new GEMS_CustomCaseLookupController(stdController);
        
        GEMS_CustomCaseLookupController gemCase = new GEMS_CustomCaseLookupController();
  
        gemCase.getFormTag();
        gemCase.search();
        //gemCase.getTextBox();
        string searchString;
        gemCase.searchString = 'Testing';
        gemCase.performSearch(searchString);
        Test.stopTest();
        
}

}