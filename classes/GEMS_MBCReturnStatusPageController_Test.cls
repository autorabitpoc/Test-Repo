/**************************************************************************************
  Apex Class Name     : GEMS_MBCReturnStatusPageController
  Version             : 1.0
  Function            : This is a handler class for CaseTrigger. The methods in this class are used as utility methods for CaseTrigger
  Modification Log    :
* Developer           : Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari    06/01/2016             Original Version
*************************************************************************************/
@isTest 
public class GEMS_MBCReturnStatusPageController_Test {
    public static testMethod void GEMS_MBCReturnStatusPageController_Test1(){
            Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        //caseObj.Opportunity_Name__c = opp.id; 
        caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        //caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        caseObj.Subject = 'AONCORPORATION';
        caseobj.status = 'In Progress';
        caseobj.GEMS_Approve__c=true;
        caseobj.GEMS_Account_Submission_Info__c = caseObj.Id;
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseobj.GEMS_Effective_Date__c = system.today(); 
        caseobj.Type = 'Dental Benefit Coding';
        caseobj.OwnerId = Userinfo.getUserId();
        insert caseObj; 
        
        list< GEMS_Return_Reason__c> gmlst = new list< GEMS_Return_Reason__c>();
        GEMS_Return_Reason__c gm = new GEMS_Return_Reason__c();
        gm.GEMS_Case__c =caseObj.id;
        gm.Process_Name__c='Account Setup Screening';
        gm.Return_Reason__c ='CBSR required;Benefit discrepancy';
        gmlst.add(gm);
        insert gmlst;
        ApexPages.currentPage().getParameters().put('Id',caseObj.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        GEMS_MBCReturnStatusPageController g = new GEMS_MBCReturnStatusPageController(sc);
 
          
        g.selectedStatus ='Routed In Error';
        g.addRow();
        g.showReturnReasonBlock();
        g.saveStatus();
        g.setSelectedStatus();
        g.cancel();
        g.getMyOptions();
        g.displayReturnReason=true;
        g.selectedCaseIds='ABS';
       
        g.scopeCode='ABS';
        g.benefitCode='ABS';
                
    }
       public static testMethod void GEMS_MBCReturnStatusPageController_Test2(){
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        //caseObj.Opportunity_Name__c = opp.id; 
        caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        //caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        caseObj.Subject = 'AONCORPORATION';
        caseobj.status = 'In Progress';
        caseobj.GEMS_Approve__c=true;
        //caseobj.GEMS_Account_Submission_Info__c = caseObj.Id;
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseobj.GEMS_Effective_Date__c = system.today(); 
        caseobj.Type = 'Pharmacy Coding';
        insert caseObj; 
           
        Case caseObj1 = new case();
        caseObj1.Accountid = acc.id; 
        //caseObj.Opportunity_Name__c = opp.id; 
        caseobj1.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        //caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        caseObj1.Subject = 'AONCORPORATION';
        caseobj1.status = 'Return';
        caseobj1.GEMS_Approve__c=true;
        caseobj1.GEMS_Account_Submission_Info__c = caseObj.Id;
        caseObj1.HCSC_Division__c ='PL';
        caseObj1.GEMS_Case_Effective_Date__c = system.today();
        caseobj1.GEMS_Effective_Date__c = system.today(); 
        caseobj1.Type = 'Pharmacy Coding';
        insert caseObj1; 
        
        list< GEMS_Return_Reason__c> gmlst = new list< GEMS_Return_Reason__c>();
        GEMS_Return_Reason__c gm = new GEMS_Return_Reason__c();
        gm.GEMS_Case__c =caseObj1.id;
        gm.Process_Name__c='Account Setup Screening';
        gm.Return_Reason__c ='CBSR required;Benefit discrepancy';
        gmlst.add(gm);
        insert gmlst;
        ApexPages.currentPage().getParameters().put('Id',caseObj1.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj1);
        GEMS_MBCReturnStatusPageController g = new GEMS_MBCReturnStatusPageController(sc);
 
        g.childComments = 'Test';  
        g.selectedStatus ='Return';
        g.addRow();
        g.showReturnReasonBlock();
        g.saveStatus();
        g.setSelectedStatus();
        g.cancel();
        g.getMyOptions();
        g.displayReturnReason=true;
        g.selectedCaseIds='ABS';
       
        g.scopeCode='ABS';
        g.benefitCode='ABS';
                
    }
     public static testMethod void GEMS_MBCReturnStatusPageController_Test3(){
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        //caseObj.Opportunity_Name__c = opp.id; 
        caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        //caseobj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        caseObj.Subject = 'AONCORPORATION';
        caseobj.status = 'Return';
        caseobj.GEMS_Approve__c=true;
        caseobj.GEMS_Account_Submission_Info__c = caseObj.Id;
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseobj.GEMS_Effective_Date__c = system.today();        
        insert caseObj; 
        
        
        ApexPages.currentPage().getParameters().put('Id',caseObj.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        GEMS_MBCReturnStatusPageController g = new GEMS_MBCReturnStatusPageController(sc);
 
         
        g.selectedStatus ='Return';
        g.saveStatus();
     }
    }