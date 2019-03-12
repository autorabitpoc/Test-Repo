/**************************************************************************************
Apex Class Name     : ARCancellationHelperTest
Version             : 1.0
Function            : This class is serves as Unit Test Class for ARCancellationHelper
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------   
* Padma Bedampeta            8/27/2017               Original Version
* Padma Bedampeta            12/15/2017              Added Test Method for G.S and B.P cancellation
************************************************************************************/
@isTest
public class ARCancellationHelperTest {
    static public Account accRec;
  //  static public List<Case> accSubCase;
    // static public Account accRec;
  //  static public product2 prd;
  //  static public case cs2;
 //   static public List<case> accStructureCase;
 //   static public GEMS_BA_Assignment__c BAassignRec;
    
    public static testmethod void method1() {
        
        List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'accountStructureCaseID',ARCancelRequiredField__c = 'dummyAccStrcturCId'));        
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'cobraAutoCancel',ARCancelRequiredField__c = 'X'));
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'autoCatInd',ARCancelRequiredField__c = 'X'));
        insert CSobjlst1;
        
        List<ARCancelMapReasonCode__c> ARobjlst = new List<ARCancelMapReasonCode__c>();
        ARobjlst.add(new ARCancelMapReasonCode__c(Name = '401 Misc - Below Percentage',BlueStar_Cancel_Code__c = '14'));        
        ARobjlst.add(new ARCancelMapReasonCode__c(Name = '402 Misc - Reason/Unknown',BlueStar_Cancel_Code__c = '13'));
        insert ARobjlst;
        
        accRec = new Account();
        accRec.Name = 'Test Account';
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.RecordTypeId = recTypeId;
        accRec.External_Id__c = 'TXEF04IL';
        accRec.Effective_Date__c = system.today() - 360;
        accRec.Cancellation_Reason__c = '401 Misc - Below Percentage';
        Date date1 = system.today();
        accRec.Requested_Cancellation_Date__c = Date.valueOf(date.newinstance(date1.year(), date1.month(), 01));
        accRec.Cancellation_Date__c = Date.valueOf(date.newinstance(date1.year(), date1.month(), 01));
        accRec.COBRA_Administration_Type__c = 'GRP';    
        accRec.Market_Segment__c = 'FEP';
        accRec.HCSC_Division__c = 'IL';
        
        Account accRec1 = new Account();
        accRec1.Name = 'Test Account1';
        accRec1.RecordTypeId = recTypeId;
        //Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec1.RecordTypeId = recTypeId;
        accRec1.External_Id__c = 'TXEF04TX';
        accRec1.Effective_Date__c = system.today() - 360;
        accRec1.Cancellation_Reason__c = '402 Misc - Reason/Unknown';
        accRec1.Requested_Cancellation_Date__c = Date.valueOf(date.newinstance(date1.year(), date1.month(), 01));
        // Date date1 = system.today();
        accRec1.Cancellation_Date__c = Date.valueOf(date.newinstance(date1.year(), date1.month(), 01));
        accRec1.COBRA_Administration_Type__c = 'GRP';    
        accRec1.Market_Segment__c = 'FEP';
        accRec1.HCSC_Division__c = 'TX';
        
        
        Test.startTest();
        List<Account> acclist = new List<Account>();
        acclist.add(accRec);
        acclist.add(accRec1);
        insert acclist;
        
        List<Account> accountreclst = [select id,Name,External_ID__c,HCSC_Division__c,Effective_Date__c,
                                       Cancellation_Reason__c,Cancellation_Date__c,COBRA_Administration_Type__c,
                                       Market_Segment__c,AccountNumber,RecordTypeId from Account where Id IN:acclist];
        
        
        // Test.startTest();
        Id accId = accRec.Id;
        system.debug('accId::::::::::'+accId);
        Id accId1 = accRec1.Id;
        system.debug('accId1::::::::::'+accId1);
        
        List<Id> Idslist = new List<Id>();
        Idslist.add(accId);
        //Idslist.add(accId1);
        
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        // String accountStructureCaseIDlValue = ARCancellationConstants__c.getValues('accountStructureCaseID').ARCancelRequiredField__c;
        ARCancelllationHelper.sendAccountCancellation(accRec.Id);
        LGNA_ARCancellationInput.accountCanDetails accountCanDetailsobj = new LGNA_ARCancellationInput.accountCanDetails();
        ARCancelllationHelper.sendAccountCancellation(Idslist);
        ARCancelllationHelper.sendAccountCancellationInFuture(Idslist);
        ARCancelllationHelper.sendAccountCancellation(accRec1.Id);      
        Test.stopTest();
        //acclist.clear();
        
    }
    Public static testmethod void sendLGNAAccountStructureCancellation(){
        Test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'marketSegment',ARCancelRequiredField__c = 'CAN'));        
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'cobraAutoCancel',ARCancelRequiredField__c = 'X'));
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'autoCatInd',ARCancelRequiredField__c = 'X'));
        insert CSobjlst1;
        
        List<ARCancelMapReasonCode__c> ARobjlst = new List<ARCancelMapReasonCode__c>();
        ARobjlst.add(new ARCancelMapReasonCode__c(Name = '401 Misc - Below Percentage',Grp_Section_Bluestar_Code__c = '14',	BP_BlueStar_Code__c = '44'));        
        ARobjlst.add(new ARCancelMapReasonCode__c(Name = '404 Misc - Grp Moved Out of State',Grp_Section_Bluestar_Code__c = '01',BP_BlueStar_Code__c = '44'));
        insert ARobjlst;
        
        Account accRec3 = new Account();
        accRec3 = new Account();
        accRec3.Name = 'Test Account3';
        accRec3.RecordTypeId = recTypeId;
        accRec3.External_Id__c = 'ILEF06IL';
        accRec3.Effective_Date__c = system.today() - 360;
        accRec3.COBRA_Administration_Type__c = 'GRP';    
        accRec3.Market_Segment__c = 'FEP';
        accRec3.HCSC_Division__c = 'IL';
        
        Account accRec4 = new Account();
        accRec4.Name = 'Test Account4';
        accRec4.RecordTypeId = recTypeId;
        accRec4.External_Id__c = 'ILEF07TX';
        accRec4.Effective_Date__c = system.today() - 360;
        accRec4.COBRA_Administration_Type__c = 'GRP';    
        accRec4.Market_Segment__c = 'FEP';
        accRec4.HCSC_Division__c = 'TX';
        List<Account> acclist = new List<Account>();
        acclist.add(accRec3);
        acclist.add(accRec4);
        insert acclist;
        
        Case accCanCase = new Case();
        accCanCase.AccountId = accRec3.Id;
        accCanCase.GEMS_Effective_Date__c = system.today();
        Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
        accCanCase.RecordTypeId = caseRecTypeId;
        accCanCase.Status = 'New';                
        insert accCanCase;
        
        Case accCanCase1 = new Case();
        accCanCase.AccountId = accRec4.Id;
        accCanCase.GEMS_Effective_Date__c = system.today();
       // Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
        accCanCase.RecordTypeId = caseRecTypeId;
        accCanCase.Status = 'New';                
        insert accCanCase1;
        
        CASE accountStructureCancelCase = [SELECT 
                                           Account.Id, Account.Name, Account.External_Id__c, Account.COBRA_Administration_Type__c, 
                                           Account.HCSC_Division__c, Account.Market_Segment__c,Account.Effective_Date__c,
                                           Id,                                                  
                                           GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Request_Time__c, GEMS_Integration_Response_Time__c,
                                           GEMS_Failed_Account_Message__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                           Status                           
                                           FROM CASE WHERE Id = : accCanCase.Id];
        
        GEMS_Group_Section__c grps = new GEMS_Group_Section__c();
        grps.Account__c = accRec3.Id;
        grps.Case__c = accCanCase.Id;
        grps.Group_No__c = '014367';
        grps.Section_No__c = '0035';
        insert grps;
        
        Id recTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE id=:accRec4.id ];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
        
      /*  product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  id =:accountStructureCancelCase.id];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='Account Cancellation'];*/
        
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();//GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.Account__c = accRec3.Id;
        benefit.AccountStructureCase__c = accountStructureCancelCase.Id;
        benefit.Name = '1212';
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        benefit.BA_Fund_Type__c='PREM';
        insert benefit;
        
      /*  GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Product/Reporting';
        insert gemsCaract ;
        
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;*/
        
        GEMS_Category__c gemscat1 = new GEMS_Category__c();//GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Account__c =accRec3.Id;
        gemscat1.Case__c = accountStructureCancelCase.Id;
        gemscat1.Category_Description__c='ABS';
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Name = '0001';
        gemscat1.Category_Cobra_Code__c = 'MC';
      /*  gemscat1.Requested_Cancellation_Date__c = system.today() + 2;
        gemscat1.Cancellation_Reason__c = '401 Misc - Below Percentage';
        gemscat1.Cancellation_Status__c = 'Requested Cancellation';
        gemscat1.Cancellation_Explanation__c= 'Test';*/
        insert gemscat1;
        
        GEMS_Category__c gemscat2 = new GEMS_Category__c();//GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat2.Account__c =accRec3.Id;
        gemscat2.Case__c = accountStructureCancelCase.Id;
        gemscat2.Category_Description__c='ABS2';
        gemscat2.Usage_Product__c =true;
        gemscat2.Usage_Billing__c=true;
        gemscat2.Usage_Reporting__c=true;
        gemscat2.Usage_Mailing__c=true;
        gemscat2.Name = '0002';
        gemscat2.Category_Cobra_Code__c = 'MC';
       /* gemscat2.Requested_Cancellation_Date__c = system.today() + 2;
        gemscat2.Cancellation_Reason__c = '401 Misc - Below Percentage';
        gemscat2.Cancellation_Status__c = 'Requested Cancellation';
        gemscat2.Cancellation_Explanation__c= 'Test';*/
        insert gemscat2;
        
        GEMS_BA_Category_Assignment__c catass = new GEMS_BA_Category_Assignment__c();//GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        catass.Account__c =accRec3.Id;
        catass.Case__c = accountStructureCancelCase.Id;
        catass.Category__c = gemscat1.id;
        catass.Benefit_Agreement__c = benefit.id;
        insert catass;
        
      /*  GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass;*/
        
        GEMS_Group_Section__c gemsGroupObj = new GEMS_Group_Section__c();//GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj.Account__c =accRec3.Id;
        gemsGroupObj.Case__c = accountStructureCancelCase.Id;
        gemsGroupObj.Section_No__c ='2001';
        gemsGroupObj.Group_No__c='TeSt02';                                       
        gemsGroupObj.Section_Description__c='TeSt02';
        gemsGroupObj.Cancellation_Status__c = 'Requested Cancellation';
        gemsGroupObj.Requested_Cancellation_Date__c = system.today() + 2;
        gemsGroupObj.Cancellation_Reason__c = '401 Misc - Below Percentage';
        gemsGroupObj.Cancellation_Explanation__c = 'Test';
        //gemsGroupObj.
        insert gemsGroupObj;
        
        GEMS_Category_Assignment__c gemsCatAsgmnt = new GEMS_Category_Assignment__c();//GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,gemsGroupObj.Id);
        gemsCatAsgmnt.Account__c =accRec3.Id;
        gemsCatAsgmnt.Case__c = accountStructureCancelCase.Id;
        gemsCatAsgmnt.Group_Section__c = gemsGroupObj.id;
        gemsCatAsgmnt.Category__c =gemscat1.id;
        insert gemsCatAsgmnt;
        
        GEMS_Category_Assignment__c catAssign = new GEMS_Category_Assignment__c();
        catAssign.Account__c=accRec3.Id;
        catAssign.Case__c=accountStructureCancelCase.Id;
        catAssign.Category__c=gemscat1.Id;
        catAssign.Group_Section__c=gemsGroupObj.Id;
        
        GEMS_BA_Assignment__c gemsbaass = new GEMS_BA_Assignment__c();//GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
        gemsbaass.Account__c=accRec3.Id;
        gemsbaass.Case__c=accountStructureCancelCase.Id;
        gemsbaass.Group_Section__c=gemsGroupObj.Id;
        gemsbaass.Benefit_Agreement__c=benefit.id;
        gemsbaass.Name='ABS';
        insert gemsbaass;
        
        GEMS_BA_Assignment__c BAassign = new GEMS_BA_Assignment__c();
        BAassign.Account__c=accRec3.Id;
        BAassign.Case__c=accountStructureCancelCase.Id;
        BAassign.Group_Section__c=gemsGroupObj.Id;
        BAassign.Benefit_Agreement__c=benefit.id;
        BAassign.Name='ABS';
        insert BAassign;
        
        GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRec3.Id;
        address.Address_Sequence__c ='2345-1201-1234';
        address.Contact_Phone__c='1458522';
        address.Usage__c='Billing';
        insert address;
        
        GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
        billpro.Account__c=accRec3.Id;
        billpro.Case__c=accountStructureCancelCase.Id;
        billpro.Billing_Address__c=address.id;
        billpro.IsNew__c=true;
        billpro.IsUpdated__c=true;
        billpro.Cancellation_Status__c = 'Requested Cancellation';
        billpro.Requested_Cancellation_Date__c = system.today() + 2;
        billpro.Cancellation_Reason__c = '401 Misc - Below Percentage';
        billpro.Cancellation_Explanation__c = 'Test';
        insert billpro;
        
        GEMS_BP_BA_Association__c bpbaass = new GEMS_BP_BA_Association__c();
        bpbaass.Billing_Profile__c=billpro.id;
        bpbaass.Benefit_Agreement__c=benefit.id;
        bpbaass.Case__c=accountStructureCancelCase.Id;
        bpbaass.IsNew__c=true;
        insert bpbaass;
        
        GEMS_BP_Category_Association__c bpcat =New GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c=billpro.id;
        bpcat.Case__c=accountStructureCancelCase.Id;
        bpcat.Category__c=gemscat1.id;
        bpcat.IsNew__c=true; 
        insert bpcat;
        
        list<GEMS_Group_Section__c> grpsecnlst = [SELECT Group_No__c, Section_No__c, Cancellation_Code__c, Section_Description__c,Requested_Cancellation_Date__c,
                                                          Cancellation_Date__c, Cancellation_Status__c, Cancellation_Reason__c, Cancellation_Explanation__c,
                                                          (SELECT Benefit_Agreement__r.Name
                                                           FROM GS_Assignments__r
                                                           WHERE Benefit_Agreement__r.IsCancelled__c = false),
                                                          (SELECT Category__r.Name
                                                           FROM Category_Assignments__r
                                                           WHERE Category__r.IsCancelled__c = false)
                                                          FROM GEMS_Group_Section__c
                                                          WHERE Account__c =:accountStructureCancelCase.Account.Id AND 
                                                          Case__c =: accountStructureCancelCase.Id AND
                                                          Cancellation_Status__c = 'Requested Cancellation' AND
                                                          Requested_Cancellation_Date__c != NULL AND
                                                          Cancellation_Reason__c  != NULL                                                                                                     
                                                         ];  
        
        Id accId = accRec3.Id;
        system.debug('accId::::::::::'+accId);
        Id accId1 = accRec4.Id;
        system.debug('accId1::::::::::'+accId1);
        
        List<Id> Idslist = new List<Id>();
        Idslist.add(accId);
        
        List<Id> caseIdslist = new List<Id>();
        caseIdslist.add(accountStructureCancelCase.Id);
        //Idslist.add(accId1);
        list<GEMS_Group_Section__c> grpsecnlst1 = new list<GEMS_Group_Section__c> ();
        grpsecnlst1.add(gemsGroupObj);
        
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        
        LGNA_ARCancellationInput.accountCanDetails accountCanDetailsobj = new LGNA_ARCancellationInput.accountCanDetails();
        list<LGNA_ARCancellationInput.GroupSection> groupSections = new list<LGNA_ARCancellationInput.GroupSection>();
        LGNA_ARCancellationInput.GroupSection groupSection = new LGNA_ARCancellationInput.GroupSection();
        list<LGNA_ARCancellationInput.BillingProfile> billingProfiles = new list<LGNA_ARCancellationInput.BillingProfile>();
        LGNA_ARCancellationInput.BillingProfile billingProfile = new LGNA_ARCancellationInput.BillingProfile();
        list<LGNA_ARCancellationInput.Category> categories = new list<LGNA_ARCancellationInput.Category>();
        LGNA_ARCancellationInput.Category category = new LGNA_ARCancellationInput.Category();
       // ARCancelllationHelper.sendAccountCancellation(Idslist);
       // ARCancelllationHelper.sendLGNAAccountStructureCancellation(accRec3.Id,accountStructureCancelCase.Id);
        ARCancelllationHelper.sendLGNAAccountStructureCancellation(accountStructureCancelCase.Id);
        ARCancelllationHelper.sendLGNAAccountStructureCancellation(caseIdslist);
        Test.stopTest();
    }
    Public static testmethod void sendLGNAAccountStructureCatCancellation(){
        Test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<ARCancellationConstants__c> CSobjlst1 = new List<ARCancellationConstants__c>();
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'changeReasonCode',ARCancelRequiredField__c = 'CAN'));        
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'cobraAutoCancel',ARCancelRequiredField__c = 'X'));
        CSobjlst1.add(new ARCancellationConstants__c(Name = 'autoCatInd',ARCancelRequiredField__c = 'X'));
        insert CSobjlst1;
        
        List<ARCancelMapReasonCode__c> ARobjlst = new List<ARCancelMapReasonCode__c>();
        ARobjlst.add(new ARCancelMapReasonCode__c(Name = '401 Misc - Below Percentage',Grp_Section_Bluestar_Code__c = '14',	BP_BlueStar_Code__c = '44'));        
        ARobjlst.add(new ARCancelMapReasonCode__c(Name = '404 Misc - Grp Moved Out of State',Grp_Section_Bluestar_Code__c = '01',BP_BlueStar_Code__c = '44'));
        insert ARobjlst;
        
        Account accRec3 = new Account();
        accRec3 = new Account();
        accRec3.Name = 'Test Account3';
        accRec3.RecordTypeId = recTypeId;
        accRec3.External_Id__c = 'ILEF06IL';
        accRec3.Effective_Date__c = system.today() - 360;
        accRec3.COBRA_Administration_Type__c = 'GRP';    
        accRec3.Market_Segment__c = 'FEP';
        accRec3.HCSC_Division__c = 'IL';
        
        Account accRec4 = new Account();
        accRec4.Name = 'Test Account4';
        accRec4.RecordTypeId = recTypeId;
        accRec4.External_Id__c = 'ILEF07TX';
        accRec4.Effective_Date__c = system.today() - 360;
        accRec4.COBRA_Administration_Type__c = 'GRP';    
        accRec4.Market_Segment__c = 'FEP';
        accRec4.HCSC_Division__c = 'TX';
        List<Account> acclist = new List<Account>();
        acclist.add(accRec3);
        acclist.add(accRec4);
        insert acclist;
        
        Case accCanCase = new Case();
        accCanCase.AccountId = accRec3.Id;
        accCanCase.GEMS_Effective_Date__c = system.today();
        Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
        accCanCase.RecordTypeId = caseRecTypeId;
        accCanCase.Status = 'New';                
        insert accCanCase;
        CASE accountStructureCancelCase = [SELECT 
                                           Account.Id, Account.Name, Account.External_Id__c, Account.COBRA_Administration_Type__c, 
                                           Account.HCSC_Division__c, Account.Market_Segment__c,Account.Effective_Date__c,
                                           Id,                                                  
                                           GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Request_Time__c, GEMS_Integration_Response_Time__c,
                                           GEMS_Failed_Account_Message__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                           Status                           
                                           FROM CASE WHERE Id = : accCanCase.Id];
        
         GEMS_Category__c gemscat2 = new GEMS_Category__c();//GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat2.Account__c =accRec3.Id;
        gemscat2.Case__c = accountStructureCancelCase.Id;
        gemscat2.Category_Description__c='ABS2';
        gemscat2.Usage_Product__c =true;
        gemscat2.Usage_Billing__c=true;
        gemscat2.Usage_Reporting__c=true;
        gemscat2.Usage_Mailing__c=true;
        gemscat2.Name = '0002';
        gemscat2.Category_Cobra_Code__c = 'MC';
        Date date1 = system.today();
        gemscat2.Requested_Cancellation_Date__c = date1;
        gemscat2.Cancellation_Reason__c = '401 Misc - Below Percentage';
        gemscat2.Cancellation_Status__c = 'Requested Cancellation';
        gemscat2.Cancellation_Explanation__c= 'Test';
        insert gemscat2;
        
        List<Id> caseIdslist = new List<Id>();
        caseIdslist.add(accountStructureCancelCase.Id);
        
         list<LGNA_ARCancellationInput.Category> categories = new list<LGNA_ARCancellationInput.Category>();
        LGNA_ARCancellationInput.Category category = new LGNA_ARCancellationInput.Category();
       // ARCancelllationHelper.sendAccountCancellation(Idslist);
       // ARCancelllationHelper.sendLGNAAccountStructureCancellation(accRec3.Id,accountStructureCancelCase.Id);
        ARCancelllationHelper.sendLGNAAccountStructureCancellation(accountStructureCancelCase.Id);
        ARCancelllationHelper.sendLGNAAccountStructureCancellation(caseIdslist);
        Test.stopTest();
    }
}