@isTest
public class GEMS_StandardCaseController_test {

/* - VM Added
    public static testmethod void GEMSStandardCaseController() {  
        
        Account accRec = new Account();
        Id accountsubmissionRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'CaseControllerTest2';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<Account> accRecQuery=[Select ID, name from Account where name='CaseControllerTest2' LIMIT 1];
        System.assertEquals('CaseControllerTest2',accRecQuery[0].Name);
        
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest2';
        opp.accountId=accRecQuery[0].Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
        List<Opportunity> oppRecQuery=[SELECT Id, Name from Opportunity WHERE Name='BenefitAgreementControllerTest2' LIMIT 1];
        System.assertEquals('BenefitAgreementControllerTest2',oppRecQuery[0].Name);
        
        Product2 productRec5 = new Product2();
        productRec5.Name='BCS Stop Loss';
        productRec5.Product_Category__c='HSA'+ 'RX' + 'BCC';
        productRec5.Family='Ancillary and other';
        productRec5.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec5.IsActive=true;
        productRec5.HCSC_State__c='IL';
        productRec5.External_ID__c='IL-Accident Insurance (HSA)';
        insert productRec5;
        Opportunity_Product__c oppProd1 = new Opportunity_Product__c();
        oppProd1.Product__c=productRec5.Id;
        oppProd1.Opportunity_Name__c=oppRecQuery[0].Id;
        oppProd1.Status__c='In Progress';
        oppProd1.Win_Probability__c=10;
        oppProd1.Funding_Type__c='ACAP';
        oppProd1.Projected_Members__c=2;
        insert oppProd1;
        
        
        
        Case caseObject = new Case();
        caseObject.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObject.Opportunity_Name__c=oppRecQuery[0].Id;
        caseObject.Status='Design In Progress';
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.GEMS_Products__c = 'RX;HSA;FSA;BCC;Cobra';
        caseObject.Accountid=accRecQuery[0].ID;
        caseObject.GEMS_Integrated__c = false;
        caseObject.GEMS_BCC_Products__c = 'Selective I/O';
        caseObject.GEMS_Bank__c = '' ;
        //caseObject.GEMS_Private_Exchange__c =False ;
        caseObject.GEMS_Rx_Vendor__c ='Prime' ;
        caseObject.GEMS_Vendor__c = 'Benefit';
        caseObject.GEMS_Line_of_Business__c='Major National';
        caseObject.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseObject.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        insert caseObject;
      
        
        ApexPages.currentpage().getParameters().put('id', caseObject.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseObject);
        GEMS_StandardCaseController caseContr= new GEMS_StandardCaseController(std);
        
        caseContr.casesave();
        caseContr.checkProductCategory();
    }
    
     public static testmethod void GEMSStandardCaseProducts() {  
        Id accountsubmissionRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Account accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'CaseControllerTest2';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<Account> accRecQuery=[Select ID, name from Account where name='CaseControllerTest2' LIMIT 1];
        System.assertEquals('CaseControllerTest2',accRecQuery[0].Name);
        
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest2';
        opp.accountId=accRecQuery[0].Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
        List<Opportunity> oppRecQuery=[SELECT Id, Name from Opportunity WHERE Name='BenefitAgreementControllerTest2' LIMIT 1];
        System.assertEquals('BenefitAgreementControllerTest2',oppRecQuery[0].Name);
        
        Product2 productRec5 = new Product2();
        productRec5.Name='BCS Stop Loss';
        productRec5.Product_Category__c='HSA'+ 'RX' + 'BCC';
        productRec5.Family='Ancillary and other';
        productRec5.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec5.IsActive=true;
        productRec5.HCSC_State__c='IL';
        productRec5.External_ID__c='IL-Accident Insurance (HSA)';
        insert productRec5;
        Opportunity_Product__c oppProd1 = new Opportunity_Product__c();
        oppProd1.Product__c=productRec5.Id;
        oppProd1.Opportunity_Name__c=oppRecQuery[0].Id;
        oppProd1.Status__c='In Progress';
        oppProd1.Win_Probability__c=10;
        oppProd1.Funding_Type__c='ACAP';
        oppProd1.Projected_Members__c=2;
        insert oppProd1;
  
        Case caseObject = new Case();
        caseObject.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObject.Opportunity_Name__c=oppRecQuery[0].Id;
        caseObject.Status='Design In Progress';
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.GEMS_Products__c = 'RX;HSA;FSA;BCC;Cobra';
        caseObject.Accountid=accRecQuery[0].ID;
        caseObject.GEMS_Integrated__c = true;
        caseObject.GEMS_BCC_Products__c = 'Selective I/O';
        caseObject.GEMS_Bank__c = '' ;
        //caseObject.GEMS_Private_Exchange__c =False ;
        caseObject.GEMS_Rx_Vendor__c ='Prime' ;
        // caseObject.GEMS_Vendor__c = '';
        caseObject.GEMS_Line_of_Business__c='Major National';
        caseObject.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseObject.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        caseObject.GEMS_ReviewDocuments__c = true;
        caseObject.GEMS_Return_Check__c = true;
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.Origin = 'Phone';
        caseObject.GEMS_Return__c = true;
        caseObject.Funding_Type__c = 'Cost Plus';
        //caseObject.GEMS_Account_Submission_Info__c = caseobj.id;
        caseObject.GEMS_Routed_In_Error__c = true;
        caseObject.GEMS_Approve__c = true;
       //caseObject.ParentId = caseobj.id;
       caseObject.SuppliedEmail = 'test@capgemini.com';
       caseObject.Priority = 'Critical';
       caseObject.Description = 'testing';
       caseObject.GEMS_ID_Card_Changes__c = true;
       caseObject.GEMS_ID_card_Request__c = 'Full Re-issuance';
       caseObject.GEMS_Grandfathered_benefits__c = true;
       caseObject.GEMS_Benefit_Booklet_Required__c = 'Yes';
       caseObject.GEMS_Is_CBSR_required__c = true;
       //caseObject.GEMS_SBC_Required__c = true;
      // caseObject.GEMS_Medical_Underwriter__c = usrObj.id;
       caseObject.GEMS_Implementation_Audit_Types__c = 'Pre Implementation Audit';
       caseObject.GEMS_Implementation_Audit_Required__c  = true;
       caseObject.GEMS_Maint_Eligibility_Method__c = 'AEP';
       caseObject.GEMS_OE_Eligibility_Method__c = 'AEP';
       caseObject.GEMS_AEP_Account__c  = true;
       caseObject.GEMS_Open_Enrollment_End__c = system.today();
       caseObject.GEMS_Open_Enrollment_Start__c = system.today();
       caseObject.FSU_Location__c = 'Champaign';
       
      /*GEMS_VP__c 
       Sales_Executive__c 
       GEMS_Director__c 
       GEMS_Client_Implementation_Consultant__c 
       GEMS_Dental_Underwriter__c 
       GEMS_Client_Service_Specialist__c 
       GEMS_Additional_Medical_Underwriter__c 
       Account_Executive__c 
       GEMS_Strategic_Account_Executive__c 
       GEMS_Type__c */
 
 /*  VM Changes    
       caseObject.GEMS_Is_HCSC_Administering_COBRA__c = true;
       caseObject.GEMS_Private_Exchange_Values__c = 'AONHewitt';
       caseObject.GEMS_Submission_Sub_Type__c = 'No Changes';
       caseObject.GEMS_Performance_Guarantees_Type__c = 'Contract Booklet Delivery';
      // CaseNumber 
       //OwnerId
       caseObject.Performance_Guarantees__c = true;
       caseObject.Type = 'Account Level';
       //caseObject.Is_Off_Cycle_Retroactive_or_Prospective__c = 'Retroactive';
       caseObject.GEMS_Submission_Type__c ='New Account';
       caseObject.recordtypeid = accountsubmissionRecordTypeid ;//caseObj.Id;
       //caseObject.recordtype.name = 'GEMS Account Submission';
       caseObject.Subject = 'Testing';
       //Account_Number__c
       caseObject.HCSC_Division__c = 'Marketing District';
      // Market_Segment__c
        insert caseObject;
        
        ApexPages.currentpage().getParameters().put('id', caseObject.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseObject);
        GEMS_StandardCaseController caseContr= new GEMS_StandardCaseController(std);
        
        caseContr.casesave();
        caseContr.checkProductCategory();
    }
    
    public static testmethod void GEMSStandardCategory() {  
        
        Account accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'CaseControllerTest2';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<Account> accRecQuery=[Select ID, name from Account where name='CaseControllerTest2' LIMIT 1];
        System.assertEquals('CaseControllerTest2',accRecQuery[0].Name);
        
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest2';
        opp.accountId=accRecQuery[0].Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
        List<Opportunity> oppRecQuery=[SELECT Id, Name from Opportunity WHERE Name='BenefitAgreementControllerTest2' LIMIT 1];
        System.assertEquals('BenefitAgreementControllerTest2',oppRecQuery[0].Name);
        
        Product2 productRec5 = new Product2();
        productRec5.Name='BCS Stop Loss';
        productRec5.Product_Category__c='';
        productRec5.Family='Ancillary and other';
        productRec5.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec5.IsActive=true;
        productRec5.HCSC_State__c='IL';
        productRec5.External_ID__c='IL-Accident Insurance (HSA)';
        insert productRec5;
        Opportunity_Product__c oppProd1 = new Opportunity_Product__c();
        oppProd1.Product__c=productRec5.Id;
        oppProd1.Opportunity_Name__c=oppRecQuery[0].Id;
        oppProd1.Status__c='In Progress';
        oppProd1.Win_Probability__c=10;
        oppProd1.Funding_Type__c='ACAP';
        oppProd1.Projected_Members__c=2;
        insert oppProd1;
        
        
        
        Case caseObject = new Case();
        caseObject.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObject.Opportunity_Name__c=oppRecQuery[0].Id;
        caseObject.Status='Design In Progress';
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.GEMS_Products__c = ';;';
        caseObject.Accountid=accRecQuery[0].ID;
        caseObject.GEMS_Integrated__c = false;
        caseObject.GEMS_BCC_Products__c = 'Selective I/O';
        caseObject.GEMS_Bank__c = '' ;
        //caseObject.GEMS_Private_Exchange__c =False ;
        caseObject.GEMS_Rx_Vendor__c ='Prime' ;
        caseObject.GEMS_Vendor__c = 'Benefit';
        caseObject.GEMS_Line_of_Business__c='Major National';
        caseObject.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseObject.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        insert caseObject;
      
        
        ApexPages.currentpage().getParameters().put('id', caseObject.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseObject);
        GEMS_StandardCaseController caseContr= new GEMS_StandardCaseController(std);
        
        caseContr.casesave();
        caseContr.checkProductCategory();
    }
    
     public static testmethod void GEMSStandardNotProducts() {  
        
        Account accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'CaseControllerTest2';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<Account> accRecQuery=[Select ID, name from Account where name='CaseControllerTest2' LIMIT 1];
        System.assertEquals('CaseControllerTest2',accRecQuery[0].Name);
        
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest2';
        opp.accountId=accRecQuery[0].Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
        List<Opportunity> oppRecQuery=[SELECT Id, Name from Opportunity WHERE Name='BenefitAgreementControllerTest2' LIMIT 1];
        System.assertEquals('BenefitAgreementControllerTest2',oppRecQuery[0].Name);
        
        Product2 productRec5 = new Product2();
        productRec5.Name='BCS Stop Loss';
        productRec5.Product_Category__c='';
        productRec5.Family='Ancillary and other';
        productRec5.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec5.IsActive=true;
        productRec5.HCSC_State__c='IL';
        productRec5.External_ID__c='IL-Accident Insurance (HSA)';
        insert productRec5;
        Opportunity_Product__c oppProd1 = new Opportunity_Product__c();
        oppProd1.Product__c=productRec5.Id;
        oppProd1.Opportunity_Name__c=oppRecQuery[0].Id;
        oppProd1.Status__c='In Progress';
        oppProd1.Win_Probability__c=10;
        oppProd1.Funding_Type__c='ACAP';
        oppProd1.Projected_Members__c=2;
        insert oppProd1;
        
        
        
        Case caseObject = new Case();
        caseObject.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObject.Opportunity_Name__c=oppRecQuery[0].Id;
        caseObject.Status='Design In Progress';
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.GEMS_Products__c = 'Test;Test2';
        caseObject.Accountid=accRecQuery[0].ID;
        caseObject.GEMS_Integrated__c = false;
        caseObject.GEMS_BCC_Products__c = 'Selective I/O';
        caseObject.GEMS_Bank__c = '' ;
        //caseObject.GEMS_Private_Exchange__c =False ;
        caseObject.GEMS_Rx_Vendor__c ='Prime' ;
        caseObject.GEMS_Vendor__c = 'Benefit';
        caseObject.GEMS_Line_of_Business__c='Major National';
        caseObject.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseObject.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        insert caseObject;
      
        
        ApexPages.currentpage().getParameters().put('id', caseObject.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseObject);
        GEMS_StandardCaseController caseContr= new GEMS_StandardCaseController(std);
        
        caseContr.casesave();
        caseContr.checkProductCategory();
    }
     
     
      public static testmethod void GEMSStandardProductsException() {  
        
        Account accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'CaseControllerTest2';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<Account> accRecQuery=[Select ID, name from Account where name='CaseControllerTest2' LIMIT 1];
        System.assertEquals('CaseControllerTest2',accRecQuery[0].Name);
        
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest2';
        opp.accountId=accRecQuery[0].Id;
        opp.Type='Other';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.Account_Market_Segment__c='LG';
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        insert opp;
        
        List<Opportunity> oppRecQuery=[SELECT Id, Name from Opportunity WHERE Name='BenefitAgreementControllerTest2' LIMIT 1];
        System.assertEquals('BenefitAgreementControllerTest2',oppRecQuery[0].Name);
        
        Product2 productRec5 = new Product2();
        productRec5.Name='BCS Stop Loss';
        productRec5.Product_Category__c='';
        productRec5.Family='Ancillary and other';
        productRec5.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec5.IsActive=true;
        productRec5.HCSC_State__c='IL';
        productRec5.External_ID__c='IL-Accident Insurance (HSA)';
        insert productRec5;
        Opportunity_Product__c oppProd1 = new Opportunity_Product__c();
        oppProd1.Product__c=productRec5.Id;
        oppProd1.Opportunity_Name__c=oppRecQuery[0].Id;
        oppProd1.Status__c='In Progress';
        oppProd1.Win_Probability__c=10;
        oppProd1.Funding_Type__c='ACAP';
        oppProd1.Projected_Members__c=2;
        insert oppProd1;
        
        Case caseObject = new Case();
        caseObject.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseObject.Opportunity_Name__c=oppRecQuery[0].Id;
        caseObject.Status='Design In Progress';
        caseObject.Funding_Type_Multiselect__c = 'ACAP';
        caseObject.GEMS_Products__c = 'Test;Test2';
        caseObject.Accountid=accRecQuery[0].ID;
        caseObject.GEMS_Integrated__c = false;
        caseObject.GEMS_BCC_Products__c = 'Selective I/O';
        caseObject.GEMS_Bank__c = '' ;
        //caseObject.GEMS_Private_Exchange__c =False ;
        caseObject.GEMS_Rx_Vendor__c ='Prime' ;
        caseObject.GEMS_Vendor__c = 'Benefit';
        caseObject.GEMS_Line_of_Business__c='Major National';
        //caseObject.GEMS_Effective_Date__c= Date.today().addDays(9);
        //caseObject.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        insert caseObject;
        //CaseTeamMember cs = new CaseTeamMember();
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(caseObject.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        ApexPages.currentpage().getParameters().put('id', caseObject.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseObject);
        GEMS_StandardCaseController caseContr= new GEMS_StandardCaseController(std);
        
        caseContr.casesave();
          caseContr.bank= True;
         caseContr.noOfOpportunityProducts = 2;
         // caseContr.removeTeamMember();
        caseContr.checkProductCategory();
          caseContr.displayCobra=True;
          caseContr.redirectPage();
          caseContr.cancel();
          caseContr.updateCaseTeamMembers();
          caseContr.caseTeamMemberId = caseTeamAccSpecMem.Id;
          caseContr.removeTeamMember();

    }
*/ 
}