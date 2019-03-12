/**************************************************************************************
  Apex Class Name     : GEMS_DocumentScreeningPageController
  Version             : 1.0
  Function            : This is a handler class for CaseTrigger. The methods in this class are used as utility methods for CaseTrigger
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        06/01/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_DocumentScreeningPageControllertest{

private static testmethod void GEMS_DocumentScreeningPageController1()
 {
 
 String screeningStatus;
     Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
         Opportunity opp = new Opportunity();
       // opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest';
        opp.accountId=acc.Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        //opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
                  Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
         Case caseRec = new Case();
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        //caseRec.Opportunity_Name__c=opptyId;
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra';
       // caseRec.Accountid=accRec.ID;
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec.GEMS_Vendor__c = '';
        caseRec.GEMS_Approve__c=true;
        caseRec.GEMS_Line_of_Business__c='Major National';
        caseRec.GEMS_Submission_Type__c='Renewal';
        caseRec.GEMS_Submission_Sub_Type__c='Funding Change';
        caseRec.GEMS_Effective_Date__c= system.today();
        caseRec.GEMS_Case_Effective_Date__c=system.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c='4';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c='2';
        caseRec.GEMS_Enter_number_of_categories__c='3';
        insert caseRec;
         
 GEMS_Return_Reason__c reason = new GEMS_Return_Reason__c();  
      reason.GEMS_Sub_Type__c='ABS';
      reason.GEMS_Case__c=caseRec.id;
      reason.GEMS_Comments__c='ABC';
      reason.Process_Name__c='Account Setup Screening';
      reason.GEMS_Type__c='ABS/Matrix';
      reason.Return_Reason__c='Missing doc';
      insert reason;
        
        
        ApexPages.currentpage().getParameters().put('Id',caseRec.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseRec);
        GEMS_DocumentScreeningPageController g1 = new GEMS_DocumentScreeningPageController(sc1);
        
        g1.getItems();
        g1.getScreeningStatus();
        g1.displayReturnReasonCheck();
        g1.addRow();
       // g1.deleteRow();
      //  g1.saveScreeningDetailsAndReturnReason();
     //   g1.screeningStatus='Approve';
        g1.setScreeningStatus ('Routed In Error');
       g1.rowIndex=2;
       
       
        
          }
          
       private static testmethod void GEMS_DocumentScreeningPageController2()
 {
 
 String screeningStatus;
     Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
         Opportunity opp = new Opportunity();
       // opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest';
        opp.accountId=acc.Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        //opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
                  Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
         Case caseRec = new Case();
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        //caseRec.Opportunity_Name__c=opptyId;
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra';
       // caseRec.Accountid=accRec.ID;
       caseRec.GEMS_Routed_In_Error__c=true;
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec.GEMS_Vendor__c = '';
        
        caseRec.GEMS_Line_of_Business__c='Major National';
        caseRec.GEMS_Submission_Type__c='Renewal';
        caseRec.GEMS_Submission_Sub_Type__c='Funding Change';
        caseRec.GEMS_Effective_Date__c= system.today();
        caseRec.GEMS_Case_Effective_Date__c=system.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c='4';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c='2';
        caseRec.GEMS_Enter_number_of_categories__c='3';
        insert caseRec;
         
 GEMS_Return_Reason__c reason = new GEMS_Return_Reason__c();  
      reason.GEMS_Sub_Type__c='ABS';
      reason.GEMS_Case__c=caseRec.id;
      reason.GEMS_Comments__c='ABC';
      reason.Process_Name__c='Account Setup Screening';
      reason.GEMS_Type__c='ABS/Matrix';
      reason.Return_Reason__c='Missing doc';
      insert reason;
        
        
        ApexPages.currentpage().getParameters().put('Id',caseRec.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseRec);
        GEMS_DocumentScreeningPageController g1 = new GEMS_DocumentScreeningPageController(sc1);
        
        g1.getItems();
        g1.getScreeningStatus();
        g1.displayReturnReasonCheck();
        g1.addRow();
       // g1.deleteRow();
       // g1.saveScreeningDetailsAndReturnReason();
     //   g1.screeningStatus='Approve';
        g1.setScreeningStatus ('Routed In Error');
       g1.rowIndex=2;
       
       
        
          }   
                private static testmethod void GEMS_DocumentScreeningPageController3()
 {
 
 String screeningStatus;
     Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
         Opportunity opp = new Opportunity();
       // opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest';
        opp.accountId=acc.Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        //opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
                  Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
         Case caseRec = new Case();
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        //caseRec.Opportunity_Name__c=opptyId;
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra';
       // caseRec.Accountid=accRec.ID;
       caseRec.GEMS_Return__c=true;
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec.GEMS_Vendor__c = '';
        
        caseRec.GEMS_Line_of_Business__c='Major National';
        caseRec.GEMS_Submission_Type__c='Renewal';
        caseRec.GEMS_Submission_Sub_Type__c='Funding Change';
        caseRec.GEMS_Effective_Date__c= system.today();
        caseRec.GEMS_Case_Effective_Date__c=system.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c='4';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c='2';
        caseRec.GEMS_Enter_number_of_categories__c='3';
        insert caseRec;
         
 GEMS_Return_Reason__c reason = new GEMS_Return_Reason__c();  
      reason.GEMS_Sub_Type__c='ABS';
      reason.GEMS_Case__c=caseRec.id;
      reason.GEMS_Comments__c='ABC';
      reason.Process_Name__c='Account Setup Screening';
      reason.GEMS_Type__c='ABS/Matrix';
      reason.Return_Reason__c='Missing doc';
      insert reason;
        
        
        ApexPages.currentpage().getParameters().put('Id',caseRec.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseRec);
        GEMS_DocumentScreeningPageController g1 = new GEMS_DocumentScreeningPageController(sc1);
        
        g1.getItems();
        g1.getScreeningStatus();
        g1.displayReturnReasonCheck();
        g1.addRow();
       // g1.deleteRow();
        g1.saveScreeningDetailsAndReturnReason();
     //   g1.screeningStatus='Approve';
        g1.setScreeningStatus ('Routed In Error');
       g1.rowIndex=2;
       
       
        
          }   
                         private static testmethod void GEMS_DocumentScreeningPageController4()
 {
 
 String screeningStatus;
     Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
         Opportunity opp = new Opportunity();
       // opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest';
        opp.accountId=acc.Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        //opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
                  Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
         Case caseRec = new Case();
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        //caseRec.Opportunity_Name__c=opptyId;
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra';
       // caseRec.Accountid=accRec.ID;
       caseRec.GEMS_Return__c=true;
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec.GEMS_Vendor__c = '';
        
        caseRec.GEMS_Line_of_Business__c='Major National';
        caseRec.GEMS_Submission_Type__c='Renewal';
        caseRec.GEMS_Submission_Sub_Type__c='Funding Change';
        caseRec.GEMS_Effective_Date__c= system.today();
        caseRec.GEMS_Case_Effective_Date__c=system.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c='4';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c='2';
        caseRec.GEMS_Enter_number_of_categories__c='3';
        caseRec.GEMS_Account_Submission_Info__c=subRec.id;
        insert caseRec;
         
 GEMS_Return_Reason__c reason = new GEMS_Return_Reason__c();  
      reason.GEMS_Sub_Type__c='ABS';
      reason.GEMS_Case__c=caseRec.id;
      reason.GEMS_Comments__c='ABC';
      reason.Process_Name__c='Account Setup Screening';
      reason.GEMS_Type__c='ABS/Matrix';
      reason.Return_Reason__c='Missing doc';
      insert reason;
        
        
        ApexPages.currentpage().getParameters().put('Id',caseRec.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseRec);
        GEMS_DocumentScreeningPageController g1 = new GEMS_DocumentScreeningPageController(sc1);
        
        g1.getItems();
        g1.getScreeningStatus();
        g1.displayReturnReasonCheck();
        g1.addRow();
       // g1.deleteRow();
        g1.saveScreeningDetailsAndReturnReason(); 
     //   g1.screeningStatus='Approve';
        g1.setScreeningStatus ('Routed In Error');
       g1.rowIndex=2;
       
       
        
          } 
 }