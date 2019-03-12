/**************************************************************************************
Apex Class Name     : GEMS_CaseTriggerAccStructureHandler_Test 
Version             : 1.0
Function            : This class is serves as Unit Test Class for GEMS_CaseTriggerAccountStructureHandler
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva                    06/16/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_CaseTriggerAccStructureHandler_Test {
    public static testmethod void testMethod1() {
        Test.startTest();
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Name = 'Praveen Account';
        acc.Effective_Date__c = system.today().addDays(360);
        insert acc;
        List<Case> casesList = new List<Case>(); 
        
        List<Contact> ContactList = new List<Contact>();
        Contact cont = new Contact();
        cont.FirstName='Mr.';
        cont.LastName='test';
        cont.Accountid= acc.id;
        cont.Type__c ='Billing';
        ContactList.add(cont);
        
        Contact cont1 = new Contact();
        cont1.FirstName='Mr.';
        cont1.LastName='test1';
        cont1.Accountid= acc.id;
        cont1.Type__c ='Mailing';
        ContactList.add(cont1);
        
        Contact cont2 = new Contact();
        cont2.FirstName='Mr.';
        cont2.LastName='test2';
        cont2.Accountid= acc.id;
        cont2.Type__c ='Primary';
        ContactList.add(cont2);
        insert ContactList;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test1';
        opp.Probability =20;
        opp.LeadSource = 'Subscription Renewal';
        opp.CloseDate = System.Today();                
        opp.Type = 'RFI';
        opp.AccountId = acc.Id;
        opp.StageName = 'RFI Delivered';
        opp.Exchange_Offering_Type__c ='No Private Exchange';
        opp.Primary_Closed_Reason__c ='Reputation of selected carrier';
        opp.Requested_Effective_Date__c = system.today();
        opp.Expected_Health_Members__c = 23;
        opp.HCSC_Division__c = 'IL';
        opp.Region__c = 'N/A - IL';
        opp.District__c = '116';
        opp.Clusters__c = '029';
        opp.RFI_RFP_Received_Date__c = system.today();
        opp.Due_Date_Notification_in_Days__c = 2;
        insert opp;
        
        product2 prod = new product2();
        prod.name = 'Accident Insurance (Dearborn)';
        prod.isActive = true;
        prod.Product_Category__c = 'PPO';
        insert prod;
        
        Opportunity_Product__c OppProd = New Opportunity_Product__c();
        OppProd.Product__c =prod.Id;
        
        //OppProd.Product__r.Name ='Ancillary Products and Additional';
        OppProd.Funding_Type__c ='ACAP';
        OppProd.Win_Probability__c =100;
        OppProd.Projected_Members__c =230;   
        OppProd.Opportunity_Name__c = opp.id;
        OppProd.Incumbent__c = testCompetitorAccount.Id;
        insert OppProd;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        caseObj.ContactId=ContactList[0].Id;
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseObj.GEMS_ReviewDocuments__c =false;
        caseObj.GEMS_Return_Check__c = false;
        caseObj.GEMS_Approve__c =false;
        caseObj.GEMS_Return__c =false;
        caseObj.GEMS_Routed_In_Error__c = false;
        caseObj.status = 'New';
        caseObj.GEMS_Submission_Type__c = 'New Account';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.Opportunity_Name__c = opp.Id;
        //caseObj.OpportunityID__c ='';
        caseObj.GEMS_Enter_number_of_categories__c = '1';
        //caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '1';
        insert caseObj; 
        casesList.add(caseObj);
        
        GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();
        groupSection.Section_Eff_Date__c = system.today();
        groupSection.case__c = caseObj.id;
        groupSection.account__c = acc.id;
        groupSection.Section_No__c ='2001';
        groupSection.Group_No__c='TeSt02';                                       
        groupSection.Section_Description__c='TeSt02';
        insert groupSection;
        
        Product2 productRec1 = new Product2();
        productRec1.Name='BCS Stop Loss';
        productRec1.Product_Category__c='EPO';
        productRec1.Family='Ancillary and other';
        productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec1.IsActive=true;
        productRec1.HCSC_State__c='IL';
        productRec1.External_ID__c='IL-Accident Insurance (EPO)';
        insert productRec1;
        
        Plan__c plan = new Plan__c();
        plan.Product__c = productRec1.id;
        plan.Plan_Type__c ='PDent'; 
        plan.External_Id__c = 'plan999';
        insert plan;
        
        GEMS_Benefit_Agreement__c benfitAgrmt = new GEMS_Benefit_Agreement__c ();
        benfitAgrmt.Account__c = acc.id;
        benfitAgrmt.Name = '4561';
        benfitAgrmt.AccountStructureCase__c = caseObj.id;
        benfitAgrmt.Plan__c = plan.id;
        benfitAgrmt.Product__c = productRec1.id;
        insert benfitAgrmt;
        
        GEMS_BA_Assignment__c baGSAssign = new GEMS_BA_Assignment__c();
        baGSAssign.case__c = caseObj.id;      
        baGSAssign.account__c = acc.id;     
        baGSAssign.Benefit_Agreement__c = benfitAgrmt.id;
        baGSAssign.Group_Section__c = groupSection.id;                                    
        insert baGSAssign;
        
        
        GEMS_Category__c category = new GEMS_Category__c();
        category.Account__c = acc.id;
        category.Case__c = caseObj.id; 
        category.Name = '1212';
        category.Usage_Billing__c = true;
        insert category;
        
        GEMS_BA_Category_Assignment__c baCatAssign=  new GEMS_BA_Category_Assignment__c ();
        baCatAssign.Account__c = acc.id; 
        baCatAssign.Benefit_Agreement__c = benfitAgrmt.id;
        baCatAssign.Case__c = caseObj.id; 
        baCatAssign.Category__c = category.id;
        insert baCatAssign;
        
        GEMS_Category_Assignment__c catAssignment = new GEMS_Category_Assignment__c();
        catAssignment.Category__c = category.Id;
        catAssignment.Group_Section__c = groupSection.id;
        catAssignment.Case__c = caseObj.Id;
        catAssignment.Account__c = acc.Id;
        insert catAssignment;
        
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id);         
        GEMS_CaseTriggerAccountStructureHandler accStructHandler = new GEMS_CaseTriggerAccountStructureHandler();
        GEMS_CaseTriggerAccountStructureHandler.CreateBA_GS_Cat_Assignments(casesList);
        GEMS_CaseTriggerAccountStructureHandler.getContactFromAccount(casesList);
    }
    
    public static testmethod void testMethod2() {
        Test.startTest();
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Name = 'Praveen Account';
        acc.Effective_Date__c = system.today().addDays(360);
        insert acc;
        List<Case> casesList = new List<Case>();
        Contact cont = new Contact();
        cont.FirstName='Mr.';
        cont.LastName='GEMS1';
        cont.Accountid= acc.id;
        cont.Type__c ='Mailing';
        insert cont;
        
        Contact cont1 = new Contact();
        cont1.FirstName='Mr.';
        cont1.LastName='ContactMgr';
        cont1.Accountid= acc.id;
        cont1.Type__c ='Mailing';
        insert cont1;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test1';
        opp.Probability =20;
        opp.LeadSource = 'Subscription Renewal';
        opp.CloseDate = System.Today();                
        opp.Type = 'RFI';
        opp.AccountId = acc.Id;
        opp.StageName = 'RFI Delivered';
        opp.Exchange_Offering_Type__c ='No Private Exchange';
        opp.Primary_Closed_Reason__c ='Reputation of selected carrier';
        opp.Requested_Effective_Date__c = system.today();
        opp.Expected_Health_Members__c = 23;
        opp.HCSC_Division__c = 'IL';
        opp.Region__c = 'N/A - IL';
        opp.District__c = '116';
        opp.Clusters__c = '029';
        opp.RFI_RFP_Received_Date__c = system.today();
        opp.Due_Date_Notification_in_Days__c = 2;
        insert opp;
        
        product2 prod = new product2();
        prod.name = 'Accident Insurance (Dearborn)';
        prod.isActive = true;
        prod.Product_Category__c = 'PPO';
        insert prod;
        
        Opportunity_Product__c OppProd = New Opportunity_Product__c();
        OppProd.Product__c =prod.Id;
        //OppProd.Product__r.Name ='Ancillary Products and Additional';
        OppProd.Funding_Type__c ='ACAP';
        OppProd.Win_Probability__c =100;
        OppProd.Projected_Members__c =230;   
        OppProd.Opportunity_Name__c = opp.id;
        OppProd.Incumbent__c = testCompetitorAccount.Id;
        insert OppProd;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseObj.GEMS_ReviewDocuments__c =false;
        caseObj.GEMS_Return_Check__c = false;
        caseObj.GEMS_Approve__c =false;
        caseObj.GEMS_Return__c =false;
        caseObj.GEMS_Routed_In_Error__c = false;
        caseObj.status = 'New';
        caseObj.GEMS_Submission_Type__c = 'Renewal';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.Opportunity_Name__c = opp.Id;
        caseObj.GEMS_Enter_number_of_categories__c = '1';        
        insert caseObj; 
        casesList.add(caseObj);
        
        GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();
        groupSection.Section_Eff_Date__c = system.today();
        groupSection.case__c = caseObj.id;
        groupSection.account__c = acc.id;
        groupSection.Section_No__c ='2001';
        groupSection.Group_No__c='TeSt02';                                       
        groupSection.Section_Description__c='TeSt02';
        insert groupSection;
        
        Product2 productRec1 = new Product2();
        productRec1.Name='BCS Stop Loss';
        productRec1.Product_Category__c='EPO';
        productRec1.Family='Ancillary and other';
        productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec1.IsActive=true;
        productRec1.HCSC_State__c='IL';
        productRec1.External_ID__c='IL-Accident Insurance (EPO)';
        insert productRec1;
        
        Plan__c plan = new Plan__c();
        plan.Product__c = productRec1.id;
        plan.Plan_Type__c ='PDent'; 
        plan.External_Id__c = 'plan999';
        insert plan;
        
        GEMS_Benefit_Agreement__c benfitAgrmt = new GEMS_Benefit_Agreement__c ();
        benfitAgrmt.Account__c = acc.id;
        benfitAgrmt.Name = '4561';
        benfitAgrmt.AccountStructureCase__c =  caseObj.id;
        benfitAgrmt.Plan__c = plan.id;
        benfitAgrmt.Product__c = productRec1.id;
        
        insert benfitAgrmt;
        
        Benefit_Agreement__c ba = new Benefit_Agreement__c();
        ba.Group_Account__c = acc.id;
        //ba.Name = '4561';
        //ba.AccountStructureCase__c =  caseObj.id;
        ba.External_Id__c = '0012554';
        ba.Plan__c = plan.id;
        ba.Product__c = productRec1.id;
        ba.Effective_Date__c = system.today().addYears(-1);
        insert ba;
        
        Group_Section__c gs = new Group_Section__c();
        //Date dt= Date.newInstance(system.today()-1, system.today().month(), system.today().Day());
        gs.Effective_Date__c = system.today().addYears(-1);
        //gs.case__c = caseObj.id;
        gs.Group_Account__c = acc.id;
        gs.Section_Number__c ='2001';
        //gs.Group_No__c='TeSt02';                                       
        //gs.Section_Description__c='TeSt02';
        gs.External_ID__c = '022558896';
        gs.Group_Number__c = 'TeSt02';
        insert gs;
        
        
        
        GEMS_BA_Assignment__c baGSAssign = new GEMS_BA_Assignment__c();
        baGSAssign.case__c = caseObj.id;      
        baGSAssign.account__c = acc.id;     
        baGSAssign.Benefit_Agreement__c = benfitAgrmt.id;
        baGSAssign.Group_Section__c = groupSection.id;                                    
        insert baGSAssign;
        
        
        GEMS_Category__c category = new GEMS_Category__c();
        category.Account__c = acc.id;
        category.Case__c = caseObj.id; 
        category.Name = '1212';
        category.Usage_Billing__c = true;
        insert category;
        
        GEMS_BA_Category_Assignment__c baCatAssign=  new GEMS_BA_Category_Assignment__c ();
        baCatAssign.Account__c = acc.id; 
        baCatAssign.Benefit_Agreement__c = benfitAgrmt.id;
        baCatAssign.Case__c = caseObj.id; 
        baCatAssign.Category__c = category.id;
        insert baCatAssign;
        
        BA_GS_Assignment__c baAssign = new BA_GS_Assignment__c();
        baAssign.Group_Section__c = gs.Id;
        baAssign.External_ID__c = 'TestAssign';
        baAssign.Benefit_Agreement__c = ba.Id;
        insert baAssign;
        
        GEMS_Category_Assignment__c catAssignment = new GEMS_Category_Assignment__c();
        catAssignment.Category__c = category.Id;
        catAssignment.Group_Section__c = groupSection.id;
        catAssignment.Case__c = caseObj.Id;
        catAssignment.Account__c = acc.Id;
        insert catAssignment;
        
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id);         
        GEMS_CaseTriggerAccountStructureHandler accStructHandler = new GEMS_CaseTriggerAccountStructureHandler();        
        GEMS_CaseTriggerAccountStructureHandler.CreateBA_GS_Cat_Assignments(casesList);
        GEMS_CaseTriggerAccountStructureHandler.getContactFromAccount(casesList);
        
        
    }
    
    public static testmethod void testMethod3() {
        Test.startTest();
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Name = 'Praveen Account';
        acc.Effective_Date__c = system.today().addDays(360);
        insert acc;
        List<Case> casesList = new List<Case>();
        Contact cont = new Contact();
        cont.FirstName='Mr.';
        cont.LastName='test';
        cont.Accountid= acc.id;
        cont.Type__c ='Primary';
        insert cont;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test1';
        opp.Probability =20;
        opp.LeadSource = 'Subscription Renewal';
        opp.CloseDate = System.Today();                
        opp.Type = 'RFI';
        opp.AccountId = acc.Id;
        opp.StageName = 'RFI Delivered';
        opp.Exchange_Offering_Type__c ='No Private Exchange';
        opp.Primary_Closed_Reason__c ='Reputation of selected carrier';
        opp.Requested_Effective_Date__c = system.today();
        opp.Expected_Health_Members__c = 23;
        opp.HCSC_Division__c = 'IL';
        opp.Region__c = 'N/A - IL';
        opp.District__c = '116';
        opp.Clusters__c = '029';
        opp.RFI_RFP_Received_Date__c = system.today();
        opp.Due_Date_Notification_in_Days__c = 2;
        insert opp;
        
        product2 prod = new product2();
        prod.name = 'Accident Insurance (Dearborn)';
        prod.isActive = true;
        prod.Product_Category__c = 'PPO';
        insert prod;
        
        Opportunity_Product__c OppProd = New Opportunity_Product__c();
        OppProd.Product__c =prod.Id;
        //OppProd.Product__r.Name ='Ancillary Products and Additional';
        OppProd.Funding_Type__c ='ACAP';
        OppProd.Win_Probability__c =100;
        OppProd.Projected_Members__c =230;   
        OppProd.Opportunity_Name__c = opp.id;
        OppProd.Incumbent__c = testCompetitorAccount.Id;
        insert OppProd;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseObj.GEMS_ReviewDocuments__c =false;
        caseObj.GEMS_Return_Check__c = false;
        caseObj.GEMS_Approve__c =false;
        caseObj.GEMS_Return__c =false;
        caseObj.GEMS_Routed_In_Error__c = false;
        caseObj.status = 'Design In Progress';
        caseObj.GEMS_Submission_Type__c = 'New Account';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.Opportunity_Name__c = opp.Id;
        caseObj.GEMS_Enter_number_of_categories__c = '1';        
        insert caseObj;
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, OpportunityId__c, status,AccountId, RecordTypeId, GEMS_Submission_Type__c from Case 
                         where RecordTypeId=:accStrRecordTypeId and Accountid=:acc.id];
        System.assertEquals(opp.Id,strCaseRec.OpportunityId__c);
        
        casesList.add(strCaseRec);
        
        GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();
        groupSection.Section_Eff_Date__c = system.today();
        groupSection.case__c = caseObj.id;
        groupSection.account__c = acc.id;
        groupSection.Section_No__c ='2001';
        groupSection.Group_No__c='TeSt02';                                       
        groupSection.Section_Description__c='TeSt02';
        insert groupSection;
        
        Product2 productRec1 = new Product2();
        productRec1.Name='BCS Stop Loss';
        productRec1.Product_Category__c='EPO';
        productRec1.Family='Ancillary and other';
        productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec1.IsActive=true;
        productRec1.HCSC_State__c='IL';
        productRec1.External_ID__c='IL-Accident Insurance (EPO)';
        insert productRec1;
        
        Plan__c plan = new Plan__c();
        plan.Product__c = productRec1.id;
        plan.Plan_Type__c ='PDent'; 
        plan.External_Id__c = 'plan999';
        insert plan;
        
        /*GEMS_Benefit_Agreement__c benfitAgrmt = new GEMS_Benefit_Agreement__c ();
benfitAgrmt.Account__c = acc.id;
benfitAgrmt.Name = '4561';
benfitAgrmt.AccountStructureCase__c =  caseObj.id;
benfitAgrmt.Plan__c = plan.id;
benfitAgrmt.Product__c = productRec1.id;

insert benfitAgrmt;

Benefit_Agreement__c ba = new Benefit_Agreement__c();
ba.Group_Account__c = acc.id;
//ba.Name = '4561';
//ba.AccountStructureCase__c =  caseObj.id;
ba.External_Id__c = '0012554';
ba.Plan__c = plan.id;
ba.Product__c = productRec1.id;
ba.Effective_Date__c = system.today().addYears(-1);
insert ba;

Group_Section__c gs = new Group_Section__c();
//Date dt= Date.newInstance(system.today()-1, system.today().month(), system.today().Day());
gs.Effective_Date__c = system.today().addYears(-1);
//gs.case__c = caseObj.id;
gs.Group_Account__c = acc.id;
gs.Section_Number__c ='2001';
//gs.Group_No__c='TeSt02';                                       
//gs.Section_Description__c='TeSt02';
gs.External_ID__c = '022558896';
gs.Group_Number__c = 'TeSt02';
insert gs;



GEMS_BA_Assignment__c baGSAssign = new GEMS_BA_Assignment__c();
baGSAssign.case__c = caseObj.id;      
baGSAssign.account__c = acc.id;     
baGSAssign.Benefit_Agreement__c = benfitAgrmt.id;
baGSAssign.Group_Section__c = groupSection.id;                                    
insert baGSAssign;


GEMS_Category__c category = new GEMS_Category__c();
category.Account__c = acc.id;
category.Case__c = caseObj.id; 
category.Name = '1212';
insert category;

GEMS_BA_Category_Assignment__c baCatAssign=  new GEMS_BA_Category_Assignment__c ();
baCatAssign.Account__c = acc.id; 
baCatAssign.Benefit_Agreement__c = benfitAgrmt.id;
baCatAssign.Case__c = caseObj.id; 
baCatAssign.Category__c = category.id;
insert baCatAssign;

BA_GS_Assignment__c baAssign = new BA_GS_Assignment__c();
baAssign.Group_Section__c = gs.Id;
baAssign.External_ID__c = 'TestAssign';
baAssign.Benefit_Agreement__c = ba.Id;
insert baAssign;

GEMS_Category_Assignment__c catAssignment = new GEMS_Category_Assignment__c();
catAssignment.Category__c = category.Id;
catAssignment.Group_Section__c = groupSection.id;
catAssignment.Case__c = caseObj.Id;
catAssignment.Account__c = acc.Id;
insert catAssignment;*/
        
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id);         
        GEMS_CaseTriggerAccountStructureHandler accStructHandler = new GEMS_CaseTriggerAccountStructureHandler();        
        GEMS_CaseTriggerAccountStructureHandler.CreateBA_GS_Cat_Assignments(casesList);
        GEMS_CaseTriggerAccountStructureHandler.getContactFromAccount(casesList);
        
        
    }
    
    public static testmethod void testMethod4() {
        Test.startTest();
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Name = 'Praveen Account';
        acc.Effective_Date__c = system.today().addDays(360);
        insert acc;
        List<Case> casesList = new List<Case>();
        Contact cont = new Contact();
        cont.FirstName='Mr.';
        cont.LastName='MrLast1';
        cont.Accountid= acc.id;
        cont.Type__c ='Mailing';
        insert cont;
        
        Contact cont1 = new Contact();
        cont1.FirstName='Mr.';
        cont1.LastName='PrimaryL2';
        cont1.Accountid= acc.id;
        cont1.Type__c ='Primary';
        insert cont1;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test1';
        opp.Probability =20;
        opp.LeadSource = 'Subscription Renewal';
        opp.CloseDate = System.Today();                
        opp.Type = 'RFI';
        opp.AccountId = acc.Id;
        opp.StageName = 'RFI Delivered';
        opp.Exchange_Offering_Type__c ='No Private Exchange';
        opp.Primary_Closed_Reason__c ='Reputation of selected carrier';
        opp.Requested_Effective_Date__c = system.today();
        opp.Expected_Health_Members__c = 23;
        opp.HCSC_Division__c = 'IL';
        opp.Region__c = 'N/A - IL';
        opp.District__c = '116';
        opp.Clusters__c = '029';
        opp.RFI_RFP_Received_Date__c = system.today();
        opp.Due_Date_Notification_in_Days__c = 2;
        insert opp;
        
        product2 prod = new product2();
        prod.name = 'Accident Insurance (Dearborn)';
        prod.isActive = true;
        prod.Product_Category__c = 'PPO';
        insert prod;
        
        Opportunity_Product__c OppProd = New Opportunity_Product__c();
        OppProd.Product__c =prod.Id;
        //OppProd.Product__r.Name ='Ancillary Products and Additional';
        OppProd.Funding_Type__c ='ACAP';
        OppProd.Win_Probability__c =100;
        OppProd.Projected_Members__c =230;   
        OppProd.Opportunity_Name__c = opp.id;
        OppProd.Incumbent__c = testCompetitorAccount.Id;
        insert OppProd;
        
        Case caseObj = new case();
        caseObj.Accountid = acc.id; 
        caseObj.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        //caseObj.Return_Reasons__c = 'ABS';
        caseObj.GEMS_ReviewDocuments__c =false;
        caseObj.GEMS_Return_Check__c = false;
        caseObj.GEMS_Approve__c =false;
        caseObj.GEMS_Return__c =false;
        caseObj.GEMS_Routed_In_Error__c = false;
        caseObj.status = 'New';
        caseObj.GEMS_Submission_Type__c = 'Renewal';
        caseObj.GEMS_Case_Effective_Date__c = system.today();
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.Opportunity_Name__c = opp.Id;
        caseObj.GEMS_Enter_number_of_categories__c = '1';        
        insert caseObj; 
        casesList.add(caseObj);
        
        GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();
        groupSection.Section_Eff_Date__c = system.today();
        groupSection.case__c = caseObj.id;
        groupSection.account__c = acc.id;
        groupSection.Section_No__c ='2001';
        groupSection.Group_No__c='TeSt02';                                       
        groupSection.Section_Description__c='TeSt02';
        insert groupSection;
        
        Product2 productRec1 = new Product2();
        productRec1.Name='BCS Stop Loss';
        productRec1.Product_Category__c='EPO';
        productRec1.Family='Ancillary and other';
        productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec1.IsActive=true;
        productRec1.HCSC_State__c='IL';
        productRec1.External_ID__c='IL-Accident Insurance (EPO)';
        insert productRec1;
        
        Plan__c plan = new Plan__c();
        plan.Product__c = productRec1.id;
        plan.Plan_Type__c ='PDent'; 
        plan.External_Id__c = 'plan999';
        insert plan;
        
        GEMS_Benefit_Agreement__c benfitAgrmt = new GEMS_Benefit_Agreement__c ();
        benfitAgrmt.Account__c = acc.id;
        benfitAgrmt.Name = '4561';
        benfitAgrmt.AccountStructureCase__c =  caseObj.id;
        benfitAgrmt.Plan__c = plan.id;
        benfitAgrmt.Product__c = productRec1.id;
        
        insert benfitAgrmt;
        
        Benefit_Agreement__c ba = new Benefit_Agreement__c();
        ba.Group_Account__c = acc.id;
        //ba.Name = '4561';
        //ba.AccountStructureCase__c =  caseObj.id;
        ba.External_Id__c = '0012554';
        ba.Plan__c = plan.id;
        ba.Product__c = productRec1.id;
        ba.Effective_Date__c = system.today().addYears(-1);
        insert ba;
        
        Group_Section__c gs = new Group_Section__c();
        //Date dt= Date.newInstance(system.today()-1, system.today().month(), system.today().Day());
        gs.Effective_Date__c = system.today().addYears(-1);
        //gs.case__c = caseObj.id;
        gs.Group_Account__c = acc.id;
        gs.Section_Number__c ='2001';
        //gs.Group_No__c='TeSt02';                                       
        //gs.Section_Description__c='TeSt02';
        gs.External_ID__c = '022558896';
        gs.Group_Number__c = 'TeSt02';
        insert gs;
        
        
        
        GEMS_BA_Assignment__c baGSAssign = new GEMS_BA_Assignment__c();
        baGSAssign.case__c = caseObj.id;      
        baGSAssign.account__c = acc.id;     
        baGSAssign.Benefit_Agreement__c = benfitAgrmt.id;
        baGSAssign.Group_Section__c = groupSection.id;                                    
        insert baGSAssign;
        
        
        GEMS_Category__c category = new GEMS_Category__c();
        category.Account__c = acc.id;
        category.Case__c = caseObj.id; 
        category.Name = '1212';
        category.Usage_Billing__c = true;
        insert category;
        
        GEMS_BA_Category_Assignment__c baCatAssign=  new GEMS_BA_Category_Assignment__c ();
        baCatAssign.Account__c = acc.id; 
        baCatAssign.Benefit_Agreement__c = benfitAgrmt.id;
        baCatAssign.Case__c = caseObj.id; 
        baCatAssign.Category__c = category.id;
        insert baCatAssign;
        
        BA_GS_Assignment__c baAssign = new BA_GS_Assignment__c();
        baAssign.Group_Section__c = gs.Id;
        baAssign.External_ID__c = 'TestAssign';
        baAssign.Benefit_Agreement__c = ba.Id;
        insert baAssign;
        
        GEMS_Category_Assignment__c catAssignment = new GEMS_Category_Assignment__c();
        catAssignment.Category__c = category.Id;
        catAssignment.Group_Section__c = groupSection.id;
        catAssignment.Case__c = caseObj.Id;
        catAssignment.Account__c = acc.Id;
        insert catAssignment;
        
        ApexPages.currentPage().getParameters().put('caseId',caseObj.id);         
        GEMS_CaseTriggerAccountStructureHandler accStructHandler = new GEMS_CaseTriggerAccountStructureHandler();        
        GEMS_CaseTriggerAccountStructureHandler.CreateBA_GS_Cat_Assignments(casesList);
        GEMS_CaseTriggerAccountStructureHandler.getContactFromAccount(casesList);
        
        
    }
}