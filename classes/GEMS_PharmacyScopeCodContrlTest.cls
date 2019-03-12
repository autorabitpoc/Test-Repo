/**************************************************************************************
Apex Class Name       : GEMS_PharmacyScopeCodContrlTest
Version               : 1.0
Function              : 
Modification Log      :  
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            05/06/2016             Original Version
*************************************************************************************/
@istest
Public class GEMS_PharmacyScopeCodContrlTest{

    Private static testmethod void  GEMS_PharmacyScope(){
    
         Account accRec = new Account();
        //accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        accRec.Name = 'PharmacyCodingControllerTest';
        accRec.status__c = 'Active';
        accRec.External_ID__c ='1000151';
        accRec.AccountNumber='124578';
        insert accRec;
        
        Case caseRec = new Case();
        caseRec.HCSC_Division__c ='PL';
        caseRec.GEMS_Effective_Date__c = system.today();
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseRec.GEMS_Case_Effective_Date__c = date.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRec.GEMS_Enter_number_of_categories__c = '2';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRec.Status = 'In Progress';
        caseRec.AccountId = accRec.id;
        //caseRec.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRec.GEMS_Submission_Type__c='New Account';
         caseRec.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRec.GEMS_Line_of_Business__c='ENA';
        // caseRec.Parent=caseRecord;
        insert caseRec;
        
        
        List<case> caseList = new List<case>();
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.AccountId = accRec.id;
        caseObj.GEMS_Account_Submission_Info__c = caseRec.id;
        caseObj.GEMS_Submission_Type__c='New Account';
         caseObj.GEMS_Submission_Sub_Type__c='Rate Change';
         caseObj.GEMS_Line_of_Business__c='ENA';
         caseObj.Parent=caseRec;
        insert caseObj;
        Case caseRecord = new Case();
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Status = 'In Progress';
        caseRecord.AccountId = accRec.id;
        caseRecord.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRecord.GEMS_Submission_Type__c='New Account';
         caseRecord.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRecord.GEMS_Line_of_Business__c='ENA';
         
         //caseRecord.Owner.Name='Testing';
        caseList.add(caseRecord);
        
        insert caseList;
        
        
        
        user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = caseObj.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        insert CTM1;
        
         List<GEMS_Pharmacy_Scope_Code__c> gemsPhList = new List<GEMS_Pharmacy_Scope_Code__c>();
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
       gemsPhRec.Case__c = caseRecord.Id;
        gemsPhRec.Name='Test';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='No Scope Code Changes';
        //gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=12;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = 'Test';
        gemsPhRec.Related_Scope_Code__c = 'Real';
        insert gemsPhRec;
        gemsPhList.add(gemsPhRec);
     
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = caseRecord.Id;
        gemsRec.Name='Test';
        gemsRec.Temp__c=true;
        gemsRec.Type__c='Permanent';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Scope_Status__c='No Scope Code Changes';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Prime_Plan_ID__c='123456';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        insert gemsRec;
        
        gemsPhList.add(gemsRec);
       
        product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = accRec.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.BA_Description__c = 'Pharma';
        gemsb.BA_Fund_Type__c = 'BSO';
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
     
        ApexPages.currentpage().getParameters().put('caseId', caseList[0].Id);
        
        ApexPages.StandardSetcontroller stdSetController = new ApexPages.StandardSetcontroller(caseList);
        stdSetController.setSelected(caselist);
        GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
        GEMS_PharmacyScopeCodingController.BACaseWrapper  gemsWrapper = new GEMS_PharmacyScopeCodingController.BACaseWrapper(true, caseObj);
        gemsWrapper.isSelected = true;
        gemsWrapper.baCase = caseObj;
         GEMS_PharmacyScopeCoding  ref = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        GEMS_PharmacyScopeCoding  ref1 = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        List<GEMS_PharmacyScopeCoding> phlist = new List<GEMS_PharmacyScopeCoding>();
        phlist.add(ref);
         phlist.add(ref1);
         ref1.scopecode.Id=null;
        // insert phlist;
        //gemsPharmacy.selectedPSCName=''
        gemsPharmacy.recordToDelete = caseList[0].id;
        gemsPharmacy.selectedPCs=gemsPhList;
        gemsPharmacy.listOfPCs=phlist;
        gemsPharmacy.numberOfRowToRemove = 1;
        gemsPharmacy.saveResult = 'Test';
        gemsPharmacy.rowCount = '10';
        gemsPharmacy.pcRecordId = '2';
         gemsPharmacy.savePCs();
        gemsPharmacy.removePC();
        gemsPharmacy.removeRow();
        gemsPharmacy.getTheUpdatedMembersCount();
        
        gemsPharmacy.addPC();
        gemsPharmacy.addTemp();        
        gemsPharmacy.setSelected();
        gemsPharmacy.gotoCase();
        //gemsPharmacy.deletePC();
    }
    
    Private static testmethod void  GEMS_PharmacyScopeDelete(){
    
         Account accRec = new Account();
        //accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        accRec.Name = 'PharmacyCodingControllerTest';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<case> caseList = new List<case>();
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.AccountId = accRec.id;
        insert caseObj;
        Case caseRecord = new Case();
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Status = 'In Progress';
        caseRecord.AccountId = accRec.id;
        caseRecord.GEMS_Account_Submission_Info__c = caseObj.id;
        caseList.add(caseRecord);
        
        insert caseList;
        
        user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = caseObj.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        
        List<GEMS_Pharmacy_Scope_Code__c> gemsPhList = new List<GEMS_Pharmacy_Scope_Code__c>();
        insert CTM1;
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
       gemsPhRec.Case__c = caseRecord.Id;
        gemsPhRec.Name='Test';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';

        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='No Scope Code Changes';
        //gemsPhRec.Related__c=gemsPhRec.Id;

        gemsPhRec.Peer_Review_Reject_Counter__c=12;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = 'Test';
        gemsPhRec.Related_Scope_Code__c = 'Real';
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Copay_Type__c ='Flat';
        //insert gemsPhRec;
        gemsPhList.add(gemsPhRec);
        
        
        GEMS_Pharmacy_Scope_Code__c gemsRec1 = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec1.Name='Test';
        gemsRec1.Case__c = caseRecord.Id;
        gemsRec1.Group_Pay_Code__c = 'Test';
        gemsRec1.Related_Scope_Code__c = 'Real';
        gemsRec1.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec1.Formulary_Type__c='Basic';
        gemsRec1.Scope_Status__c='No Scope Code Changes';
        gemsRec1.Copay_Type__c ='Flat';
        
        GEMS_Pharmacy_Scope_Code__c gemsRec2 = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec2.Name='Test';
        gemsRec2.Case__c = caseRecord.Id;
        gemsRec2.Group_Pay_Code__c = 'Test';
        gemsRec2.Related_Scope_Code__c = 'Real';
        gemsRec2.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec2.Formulary_Type__c='Basic';
        gemsRec2.Scope_Status__c='No Scope Code Changes';
        gemsRec2.Copay_Type__c ='Flat';
        
        GEMS_Pharmacy_Scope_Code__c gemsRec3 = new GEMS_Pharmacy_Scope_Code__c();
       gemsRec3.Name='Test';
        gemsRec3.Case__c = caseRecord.Id;
        gemsRec3.Group_Pay_Code__c = 'Test';
        gemsRec3.Related_Scope_Code__c = 'Real';
        gemsRec3.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec3.Formulary_Type__c='Basic';
        gemsRec3.Scope_Status__c='No Scope Code Changes';
        gemsRec3.Copay_Type__c ='Flat';
        
        
        
         
         
        GEMS_Pharmacy_Scope_Code__c gemsRec4 = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec4.Case__c = caseRecord.Id;
        gemsRec4.Name='Test';
        gemsRec4.Temp__c=true;
        gemsRec4.Type__c='Permanent';
        gemsRec4.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec4.Retail__c='No Retail Benefits';
        gemsRec4.Copay_Type__c='Flat';
        gemsRec4.Rider_Code__c='00';
        gemsRec4.Scope_Status__c='No Scope Code Changes';
        gemsRec4.Related__c=gemsPhRec.Id;
        gemsRec4.Peer_Review_Reject_Counter__c=12;
        gemsRec4.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec4.Formulary_Type__c='Basic';
        gemsRec4.Prime_Certify_Date__c=system.today();
        gemsRec4.Prime_Plan_ID__c='123456';
        gemsRec4.Report_Format_Code__c='P';
        gemsRec4.Comments__c='Comments';
        gemsRec4.Group_Pay_Code__c = 'Test';
        gemsRec4.Related_Scope_Code__c = 'Real';
        //gemsPhList.add(gemsRec);
       // insert gemsRec4;
        gemsPhList.add(gemsRec1);
         gemsPhList.add(gemsRec2);
         gemsPhList.add(gemsRec3);
         gemsPhList.add(gemsRec4);
         insert gemsPhList;
   
         product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = accRec.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.BA_Description__c = 'Pharma';
        gemsb.BA_Fund_Type__c = 'BSO';
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
     
        ApexPages.currentpage().getParameters().put('caseId', caseList[0].Id);
        
        ApexPages.StandardSetcontroller stdSetController = new ApexPages.StandardSetcontroller(caseList);
        stdSetController.setSelected(caselist);
        GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
        //gemsPharmacy.setCon = gemsPhList;
        GEMS_PharmacyScopeCodingController.BACaseWrapper  gemsWrapper = new GEMS_PharmacyScopeCodingController.BACaseWrapper(true, caseObj);
        gemsWrapper.isSelected = true;
        gemsWrapper.baCase = caseObj;
         GEMS_PharmacyScopeCoding  ref = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        GEMS_PharmacyScopeCoding  ref1 = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        List<GEMS_PharmacyScopeCoding> phlist = new List<GEMS_PharmacyScopeCoding>();
        phlist.add(ref);
         phlist.add(ref1);
        // insert phlist;
        //gemsPharmacy.selectedPSCName=''
        gemsPharmacy.recordToDelete = caseList[0].id;
        gemsPharmacy.selectedPCs=gemsPhList;
        gemsPharmacy.listOfPCs=phlist;
        gemsPharmacy.numberOfRowToRemove = 1;
        gemsPharmacy.saveResult = 'Test';
        gemsPharmacy.rowCount = '10';
        gemsPharmacy.pcRecordId = '2';
        gemsPharmacy.removePC();
        gemsPharmacy.removeRow();
        gemsPharmacy.getTheUpdatedMembersCount();
        gemsPharmacy.savePCs();
        //gemsPharmacy.addPC();
        gemsPharmacy.selectedPSCId=gemsRec4.Id;
        gemsPharmacy.addTemp();        
        gemsPharmacy.setSelected();
        gemsPharmacy.gotoCase();
        //gemsPharmacy.deletePC();
        
         //GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
    }
    
      Private static testmethod void  GEMS_PharmacyScopeExp(){
    
         Account accRec = new Account();
        //accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        accRec.Name = 'PharmacyCodingControllerTest';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<case> caseList = new List<case>();
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.AccountId = accRec.id;
        insert caseObj;
        
        caseList.add(caseObj);
        Case caseRecord = new Case();
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Status = 'In Progress';
        caseRecord.AccountId = accRec.id;
        caseRecord.GEMS_Account_Submission_Info__c = caseObj.id;
               
        insert caseRecord;
        caseList.add(caseRecord);
        
        user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = caseObj.Id, MemberId = usr.Id , TeamRoleId = role.Id);
           insert CTM1;
      
        GEMS_Pharmacy_Scope_Code__c gemsRec4 = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec4.Case__c = caseRecord.Id;
        gemsRec4.Name='Test';
        gemsRec4.Temp__c=true;
        gemsRec4.Type__c='Permanent';
        gemsRec4.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec4.Retail__c='No Retail Benefits';
        gemsRec4.Copay_Type__c='Flat';
        gemsRec4.Rider_Code__c='00';
        gemsRec4.Scope_Status__c='No Scope Code Changes';
       // gemsRec4.Related__c=gemsPhRec.Id;
        gemsRec4.Peer_Review_Reject_Counter__c=12;
        gemsRec4.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec4.Formulary_Type__c='Basic';
        gemsRec4.Prime_Certify_Date__c=system.today();
        gemsRec4.Prime_Plan_ID__c='123456';
        gemsRec4.Report_Format_Code__c='P';
        gemsRec4.Comments__c='Comments';
        gemsRec4.Group_Pay_Code__c = 'Test';
        gemsRec4.Related_Scope_Code__c = 'Real';
        //gemsPhList.add(gemsRec);
        Insert gemsRec4;
        
   
         product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = accRec.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.BA_Description__c = 'Pharma';
        gemsb.BA_Fund_Type__c = 'BSO';
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
     
        ApexPages.currentpage().getParameters().put('caseId', caseList[0].Id );
        
        ApexPages.StandardSetcontroller stdSetController = new ApexPages.StandardSetcontroller(caseList);
        stdSetController.setSelected(caselist);
        GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
        //gemsPharmacy.setCon = gemsPhList;
        GEMS_PharmacyScopeCodingController.BACaseWrapper  gemsWrapper = new GEMS_PharmacyScopeCodingController.BACaseWrapper(false, caseObj);
        
       
        gemsPharmacy.recordToDelete = caseList[0].id;
        gemsPharmacy.numberOfRowToRemove = 1;
        gemsPharmacy.saveResult = 'Test';
        gemsPharmacy.rowCount = '10';
        gemsPharmacy.pcRecordId = '2';
        gemsPharmacy.removePC();
        gemsPharmacy.removeRow();
        gemsPharmacy.selectedPSCId=null;
        gemsPharmacy.getTheUpdatedMembersCount();
        gemsPharmacy.savePCs();
        gemsPharmacy.addTemp();        
        gemsPharmacy.setSelected();
        gemsPharmacy.gotoCase();
        //gemsPharmacy.deletePC();
        
         
    }
    
    Private static testmethod void  GEMS_PharmacyScopeSave(){
    
         Account accRec = new Account();
        //accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        accRec.Name = 'PharmacyCodingControllerTest';
        accRec.status__c = 'Active';
        accRec.External_ID__c ='1000151';
        accRec.AccountNumber='124578';
        insert accRec;
        
        Case caseRec = new Case();
        caseRec.HCSC_Division__c ='PL';
        caseRec.GEMS_Effective_Date__c = system.today();
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseRec.GEMS_Case_Effective_Date__c = date.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRec.GEMS_Enter_number_of_categories__c = '2';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRec.Status = 'In Progress';
        caseRec.AccountId = accRec.id;
        //caseRec.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRec.GEMS_Submission_Type__c='New Account';
         caseRec.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRec.GEMS_Line_of_Business__c='ENA';
        // caseRec.Parent=caseRecord;
        insert caseRec;
        
        
        List<case> caseList = new List<case>();
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='PL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.AccountId = accRec.id;
        caseObj.GEMS_Account_Submission_Info__c = caseRec.id;
        caseObj.GEMS_Submission_Type__c='New Account';
         caseObj.GEMS_Submission_Sub_Type__c='Rate Change';
         caseObj.GEMS_Line_of_Business__c='ENA';
         caseObj.Parent=caseRec;
        insert caseObj;
        Case caseRecord = new Case();
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Status = 'In Progress';
        caseRecord.AccountId = accRec.id;
        caseRecord.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRecord.GEMS_Submission_Type__c='New Account';
         caseRecord.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRecord.GEMS_Line_of_Business__c='ENA';
         
         //caseRecord.Owner.Name='Testing';
        caseList.add(caseRecord);
        
        insert caseList;
        
        
        
        user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = caseObj.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        insert CTM1;
        
         List<GEMS_Pharmacy_Scope_Code__c> gemsPhList = new List<GEMS_Pharmacy_Scope_Code__c>();
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
       gemsPhRec.Case__c = caseRecord.Id;
        gemsPhRec.Name='Test';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Temp';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='No Scope Code Changes';
        //gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=12;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = 'Test';
        gemsPhRec.Related_Scope_Code__c = 'Real';
        insert gemsPhRec;
        gemsPhList.add(gemsPhRec);
     
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = caseRecord.Id;
        gemsRec.Name='Test';
        gemsRec.Temp__c=true;
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Scope_Status__c='No Scope Code Changes';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Prime_Plan_ID__c='123456';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        insert gemsRec;
        
        gemsPhList.add(gemsRec);
       
        product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = accRec.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.BA_Description__c = 'Pharma';
        gemsb.BA_Fund_Type__c = 'BSO';
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
     
        ApexPages.currentpage().getParameters().put('caseId', caseList[0].Id);
        
        ApexPages.StandardSetcontroller stdSetController = new ApexPages.StandardSetcontroller(caseList);
        stdSetController.setSelected(caselist);
        GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
        GEMS_PharmacyScopeCodingController.BACaseWrapper  gemsWrapper = new GEMS_PharmacyScopeCodingController.BACaseWrapper(true, caseObj);
        gemsWrapper.isSelected = true;
        gemsWrapper.baCase = caseObj;
         GEMS_PharmacyScopeCoding  ref = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        GEMS_PharmacyScopeCoding  ref1 = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        ref1.scopecode.id=null;
        List<GEMS_PharmacyScopeCoding> phlist = new List<GEMS_PharmacyScopeCoding>();
        phlist.add(ref);
         phlist.add(ref1);
        // insert phlist;
        //gemsPharmacy.selectedPSCName=''
        gemsPharmacy.recordToDelete = caseList[0].id;
        gemsPharmacy.selectedPCs=gemsPhList;
        gemsPharmacy.listOfPCs=phlist;
        gemsPharmacy.numberOfRowToRemove = 1;
        gemsPharmacy.saveResult = 'Test';
        gemsPharmacy.rowCount = '10';
        gemsPharmacy.pcRecordId = '2';
         gemsPharmacy.savePCs();
        
    }
    
     Private static testmethod void  GEMS_PharmacyScopeSaveExp(){
    
         Account accRec = new Account();
        //accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        accRec.Name = 'PharmacyCodingControllerTest';
        accRec.status__c = 'Active';
        accRec.External_ID__c ='1000151';
        accRec.AccountNumber='124578';
        insert accRec;
        
        Case caseRec = new Case();
        caseRec.GEMS_Pharmacy_Scope_Code__c='Testing';
        caseRec.GEMS_Temp_Scope_Code__c='TempScope';
        caseRec.GEMS_Pharmacy_Group_Pay_Code__c='GrupScope';
        caseRec.GEMS_Pharmacy_Temp_Group_Pay_Code__c='TempScope';
        caseRec.HCSC_Division__c ='PL';
        caseRec.GEMS_Effective_Date__c = system.today();
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseRec.GEMS_Case_Effective_Date__c = date.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRec.GEMS_Enter_number_of_categories__c = '2';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRec.Status = 'In Progress';
        caseRec.AccountId = accRec.id;
        //caseRec.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRec.GEMS_Submission_Type__c='New Account';
         caseRec.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRec.GEMS_Line_of_Business__c='ENA';
        // caseRec.Parent=caseRecord;
        insert caseRec;
        
        
        List<case> caseList = new List<case>();
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='IL';
        caseObj.GEMS_Pharmacy_Scope_Code__c='Testing';
        caseObj.GEMS_Temp_Scope_Code__c='TempScope';
        caseObj.GEMS_Pharmacy_Group_Pay_Code__c='GrupScope';
        caseObj.GEMS_Pharmacy_Temp_Group_Pay_Code__c='TempScope';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.AccountId = accRec.id;
        caseObj.GEMS_Account_Submission_Info__c = caseRec.id;
        caseObj.GEMS_Submission_Type__c='New Account';
         caseObj.GEMS_Submission_Sub_Type__c='Rate Change';
         caseObj.GEMS_Line_of_Business__c='ENA';
         caseObj.ParentID=caseRec.Id;
        insert caseObj;
        Case caseRecord = new Case();
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Pharmacy_Scope_Code__c='Testing';
        caseRecord.GEMS_Temp_Scope_Code__c='TempScope';
        caseRecord.GEMS_Pharmacy_Group_Pay_Code__c='GrupScope';
        caseRecord.GEMS_Pharmacy_Temp_Group_Pay_Code__c='TempScope';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Status = 'In Progress';
        caseRecord.AccountId = accRec.id;
        caseRecord.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRecord.GEMS_Submission_Type__c='New Account';
         caseRecord.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRecord.GEMS_Line_of_Business__c='ENA';
         
         //caseRecord.Owner.Name='Testing';
        caseList.add(caseRecord);
        
        insert caseList;
 
        user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = caseObj.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        insert CTM1;
        
         List<GEMS_Pharmacy_Scope_Code__c> gemsPhList = new List<GEMS_Pharmacy_Scope_Code__c>();
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = caseRecord.Id;
        gemsPhRec.Name='Test';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Temp';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='No Scope Code Changes';
        //gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=12;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = 'Test';
        gemsPhRec.Related_Scope_Code__c = 'Real';
        insert gemsPhRec;
        gemsPhList.add(gemsPhRec);
     
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = caseRecord.Id;
        gemsRec.Name='Test';
        gemsRec.Temp__c=true;
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Scope_Status__c='No Scope Code Changes';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Prime_Plan_ID__c='123456';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        insert gemsRec;
        
        gemsPhList.add(gemsRec);
       
        product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = accRec.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.BA_Description__c = 'Pharma';
        gemsb.BA_Fund_Type__c = 'BSO';
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
     
        ApexPages.currentpage().getParameters().put('caseId', caseObj.Id);
        
        ApexPages.StandardSetcontroller stdSetController = new ApexPages.StandardSetcontroller(caseList);
        stdSetController.setSelected(caselist);
        GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
        GEMS_PharmacyScopeCodingController.BACaseWrapper  gemsWrapper = new GEMS_PharmacyScopeCodingController.BACaseWrapper(true, caseObj);
        gemsWrapper.isSelected = true;
        gemsWrapper.baCase = caseObj;
        gemsPharmacy.recordToDelete = caseList[0].id;
         GEMS_PharmacyScopeCoding  ref = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        GEMS_PharmacyScopeCoding  ref1 = new GEMS_PharmacyScopeCoding(true,gemsPhList[0]);
        List<GEMS_PharmacyScopeCoding> phlist = new List<GEMS_PharmacyScopeCoding>();
        phlist.add(ref);
         phlist.add(ref1);
        gemsPharmacy.caseId=caseObj.Id;
        gemsPharmacy.selectedPCs=gemsPhList;
        gemsPharmacy.listOfPCs=phlist;
        gemsPharmacy.numberOfRowToRemove = 1;
        gemsPharmacy.saveResult = 'Test';
        gemsPharmacy.rowCount = '10';
        gemsPharmacy.pcRecordId = '2';
         gemsPharmacy.savePCs();
         gemsPharmacy.getBACases();
         gemsPharmacy.validateMandatory();
         gemsPharmacy.HideTempPC();
         gemsPharmacy.deletePC();
        
    }
    
   /* Private static testmethod void  GEMS_PharmacyScope1(){
    
         Profile profileRec = [SELECT Id FROM Profile WHERE Name='SG - Read-only User'];
          User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com');        

        Account accRec = new Account();
        //accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        accRec.Name = 'PharmacyCodingControllerTest';
        accRec.status__c = 'Active';
        accRec.External_ID__c ='1000151';
        accRec.AccountNumber='124578';
        insert accRec;
        
        Case caseRec = new Case();
        caseRec.HCSC_Division__c ='IL';
        caseRec.GEMS_Effective_Date__c = system.today();
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseRec.GEMS_Case_Effective_Date__c = date.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRec.GEMS_Enter_number_of_categories__c = '2';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRec.Status = 'In Progress';
        caseRec.AccountId = accRec.id;
        //caseRec.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRec.GEMS_Submission_Type__c='New Account';
         caseRec.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRec.GEMS_Line_of_Business__c='ENA';
        // caseRec.Parent=caseRecord;
        insert caseRec;
        
        
        List<case> caseList = new List<case>();
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='IL';
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.AccountId = accRec.id;
        caseObj.GEMS_Account_Submission_Info__c = caseRec.id;
        caseObj.GEMS_Submission_Type__c='New Account';
         caseObj.GEMS_Submission_Sub_Type__c='Rate Change';
         caseObj.GEMS_Line_of_Business__c='ENA';
         caseObj.Parent=caseRec;
        insert caseObj;
        Case caseRecord = new Case();
        caseRecord.HCSC_Division__c ='IL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Status = 'In Progress';
        caseRecord.AccountId = accRec.id;
        caseRecord.GEMS_Account_Submission_Info__c = caseObj.id;
        caseRecord.GEMS_Submission_Type__c='New Account';
         caseRecord.GEMS_Submission_Sub_Type__c='Rate Change';
         caseRecord.GEMS_Line_of_Business__c='ENA';
         
         //caseRecord.Owner.Name='Testing';
        caseList.add(caseRecord);
        
        insert caseList;
 
        user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = caseObj.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        insert CTM1;
        
         List<GEMS_Pharmacy_Scope_Code__c> gemsPhList = new List<GEMS_Pharmacy_Scope_Code__c>();
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = caseRecord.Id;
        gemsPhRec.Name='Test';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='No Scope Code Changes';
        //gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=12;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123564';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = 'Test';
        gemsPhRec.Related_Scope_Code__c = 'Real';
        insert gemsPhRec;
        gemsPhList.add(gemsPhRec);
     
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = caseRecord.Id;
        gemsRec.Name='Test';
        gemsRec.Temp__c=true;
        gemsRec.Type__c='Permanent';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Scope_Status__c='No Scope Code Changes';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=system.today();
        gemsRec.Prime_Plan_ID__c='123456';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
          gemsRec.Accums_Integration__c='Yes, Integrate OPX Only';
        gemsRec.Formulary_Type__c ='Basic';
        insert gemsRec;
        
        gemsPhList.add(gemsRec);
       
        product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = accRec.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.BA_Description__c = 'Pharma';
        gemsb.BA_Fund_Type__c = 'BSO';
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
        
     system.runAs(testUser){ 
     
        ApexPages.currentpage().getParameters().put('caseId', caseList[0].Id);
        
        ApexPages.StandardSetcontroller stdSetController = new ApexPages.StandardSetcontroller(caseList);
        stdSetController.setSelected(caselist);
        //GEMS_PharmacyScopeCodingController  gemsPharmacy = new GEMS_PharmacyScopeCodingController(stdSetController);
        GEMS_PharmacyScopeCodingController.BACaseWrapper  gemsWrapper = new GEMS_PharmacyScopeCodingController.BACaseWrapper(true, caseObj);
        gemsWrapper.isSelected = true;
        //gemsWrapper.Type__c='Permanent';
        
        gemsWrapper.baCase = caseObj;
        //gemsWrapper.validateMandatory();
        //gemsPharmacy.recordToDelete = caseList[0].id;
        //gemsPharmacy.selectedPCs=gemsPhList;
        //gemsPharmacy.listOfPCs= new List<GEMS_PharmacyScopeCoding>();
        //gemsPharmacy.numberOfRowToRemove = 1;
        //gemsPharmacy.saveResult = 'Test';
       // gemsPharmacy.rowCount = '10';
       // gemsPharmacy.pcRecordId = '2';
        // gemsPharmacy.savePCs();
         
         
     }
        
    }*/
      
}