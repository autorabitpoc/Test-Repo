/**************************************************************************************
  Apex Class Name     : GEMS_MassCaseStatusChangeContrTest
  Version             : 1.0
  Function            : This class serves as Unit Test Class for GEMS_MassCaseStatusChangeController.
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------     
* Ranjit Gandhi       6/1/2017               SFDC-4804- Display Message when trying to return a BA Level Case when the status is in a Closed State
* Siva Thimmannagari     06/29/2016                Original Version
*************************************************************************************/
@istest
Public class GEMS_MassCaseStatusChangeContrTest{
    Private static testmethod void  GEMS_MassCase(){
   
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.accountid= acc.id;
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        insert caseObj;
        
        GEMS_Return_Reason__c gemsRR = new GEMS_Return_Reason__c();
        gemsRR.GEMS_Case__c = caseObj.id;
        Insert gemsRR;
        
        List<GEMS_Return_Reason__c> gemsRRList = new List<GEMS_Return_Reason__c>();
        GEMS_Return_Reason__c gemsRec = new GEMS_Return_Reason__c();
        gemsRec.GEMS_Case__c = caseObj.id;
        
        GEMS_Return_Reason__c gemsRecord = new GEMS_Return_Reason__c();
        gemsRecord.GEMS_Case__c = caseObj.id;
        
        gemsRRList.add(gemsRec);
        gemsRRList.add(gemsRecord);
        insert gemsRRList;
       
        Test.startTest();
        ApexPages.currentpage().getParameters().put('caseId', caseObj.Id);
        ApexPages.currentpage().getParameters().put('Id',caseObj.Id);
        ApexPages.currentpage().getParameters().put('selectedCaseIds',caseObj.Id);
           
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass = new GEMS_MassCaseStatusChangeController(stdController);
        gemsMass.selectedStatus='Return';
        Boolean allChildCompleted = true;
        gemsMass.getMyScopeOptions();
        gemsMass.getMybenefitOptions();
        gemsMass.setSelectedStatus();
        gemsMass.showReturnReasonBlock();
        gemsMass.addRow();
        gemsMass.saveStatus();

        ApexPages.currentpage().getParameters().put('Id',caseObj.Id);
        ApexPages.currentpage().getParameters().put('caseId', caseObj.Id);
        ApexPages.currentpage().getParameters().put('selectedCaseIds', caseObj.Id);
        ApexPages.currentpage().getParameters().put('benefitCode','true');  
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass1 = new GEMS_MassCaseStatusChangeController(stdController1);
        gemsMass.selectedStatus='Approved';
        gemsMass.setSelectedStatus();
        gemsMass.showReturnReasonBlock();
        gemsMass.addRow();
        gemsMass.saveStatus();
        ApexPages.currentpage().getParameters().put('caseId', caseObj.Id);
        ApexPages.currentpage().getParameters().put('Id',caseObj.Id);
        ApexPages.currentpage().getParameters().put('selectedCaseIds', caseObj.Id);

        
        ApexPages.Standardcontroller stdController3 = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass3 = new GEMS_MassCaseStatusChangeController(stdController3);
        gemsMass3.benefitCode ='true';
        gemsMass3.selectedStatus='Approved';
        gemsMass3.setSelectedStatus();
        gemsMass3.showReturnReasonBlock();
        gemsMass3.addRow();
        gemsMass3.saveStatus();
        
        gemsMass3.selectedStatus='Return';
        gemsMass3.setSelectedStatus();
        gemsMass3.saveStatus();
        
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass2 = new GEMS_MassCaseStatusChangeController(stdController2);
        gemsMass.benefitCode ='true';
        gemsMass.selectedStatus='Routed in error';
        gemsMass.setSelectedStatus();
        gemsMass.showReturnReasonBlock();
        gemsMass.addRow();
        gemsMass.saveStatus();

        Test.stopTest(); 
        
    }
    
    Private static testmethod void  GEMS_MassCasechange()
    {
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
      
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.accountid= acc.id;
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        insert caseObj;
        
        GEMS_Return_Reason__c gemsRR = new GEMS_Return_Reason__c();
        gemsRR.GEMS_Case__c = caseObj.id;
        Insert gemsRR;
        
        List<GEMS_Return_Reason__c> gemsRRList = new List<GEMS_Return_Reason__c>();
        GEMS_Return_Reason__c gemsRec = new GEMS_Return_Reason__c();
        gemsRec.GEMS_Case__c = caseObj.id;
        
        GEMS_Return_Reason__c gemsRecord = new GEMS_Return_Reason__c();
        gemsRecord.GEMS_Case__c = caseObj.id;
        
        gemsRRList.add(gemsRec);
        gemsRRList.add(gemsRecord);
        
        insert gemsRRList;
        
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('benefitCode','true');
        ApexPages.currentpage().getParameters().put('Id',caseObj.Id);
        ApexPages.currentpage().getParameters().put('selectedCaseIds', caseObj.Id);
        id selectedCaseIds;
        system.debug('selectedCaseIds=============' +selectedCaseIds); 
          
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass = new GEMS_MassCaseStatusChangeController(stdController);
        gemsMass.setSelectedStatus();
        gemsMass.showReturnReasonBlock();
        gemsMass.addRow();
        gemsMass.saveStatus();
        gemsMass.displayReturnReason=true;
        gemsMass.getMyScopeOptions();
        gemsMass.getMybenefitOptions();
        Test.stopTest(); 
        
    }
    
     Private static testmethod void  GEMS_MassCase1(){
   
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.accountid= acc.id;
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        insert caseObj;
        
        GEMS_Return_Reason__c gemsRR = new GEMS_Return_Reason__c();
        gemsRR.GEMS_Case__c = caseObj.id;
        Insert gemsRR;
        
        List<GEMS_Return_Reason__c> gemsRRList = new List<GEMS_Return_Reason__c>();
        GEMS_Return_Reason__c gemsRec = new GEMS_Return_Reason__c();
        gemsRec.GEMS_Case__c = caseObj.id;
        
        GEMS_Return_Reason__c gemsRecord = new GEMS_Return_Reason__c();
        gemsRecord.GEMS_Case__c = caseObj.id;
        
        gemsRRList.add(gemsRec);
        gemsRRList.add(gemsRecord);
        insert gemsRRList;
       
        Test.startTest();
        ApexPages.currentpage().getParameters().put('caseId', caseObj.Id);
        ApexPages.currentpage().getParameters().put('Id',caseObj.Id);
        ApexPages.currentpage().getParameters().put('selectedCaseIds',caseObj.Id);
        ApexPages.currentpage().getParameters().put('benefitCode','true');   
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass = new GEMS_MassCaseStatusChangeController(stdController);
        gemsMass.selectedStatus='Return';
        Boolean allChildCompleted = true;
        gemsMass.getMyScopeOptions();
        gemsMass.getMybenefitOptions();
        gemsMass.setSelectedStatus();
        gemsMass.showReturnReasonBlock();
        gemsMass.addRow();
        gemsMass.saveStatus();
        Test.stopTest(); 
        
    }
    
      Private static testmethod void  GEMS_MassCase2(){
   
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.accountid= acc.id;
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.Type = 'Medical Benefit Coding';
        insert caseObj;
        
        GEMS_Return_Reason__c gemsRR = new GEMS_Return_Reason__c();
        gemsRR.GEMS_Case__c = caseObj.id;
        Insert gemsRR;
        
        List<GEMS_Return_Reason__c> gemsRRList = new List<GEMS_Return_Reason__c>();
        GEMS_Return_Reason__c gemsRec = new GEMS_Return_Reason__c();
        gemsRec.GEMS_Case__c = caseObj.id;
        
        GEMS_Return_Reason__c gemsRecord = new GEMS_Return_Reason__c();
        gemsRecord.GEMS_Case__c = caseObj.id;
        
        gemsRRList.add(gemsRec);
        gemsRRList.add(gemsRecord);
        insert gemsRRList;
       
        Test.startTest();
        ApexPages.currentpage().getParameters().put('caseId', caseObj.Id);
        ApexPages.currentpage().getParameters().put('Id',caseObj.Id);
        ApexPages.currentpage().getParameters().put('selectedCaseIds',caseObj.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(caseObj);
        GEMS_MassCaseStatusChangeController gemsMass = new GEMS_MassCaseStatusChangeController(stdController);
        gemsMass.selectedStatus='Approved';
        Boolean allChildCompleted = true;
        gemsMass.getMyScopeOptions();
        gemsMass.getMybenefitOptions();
        gemsMass.setSelectedStatus();
        gemsMass.showReturnReasonBlock();
        gemsMass.addRow();
        gemsMass.saveStatus();
        Test.stopTest(); 
        
    }
}