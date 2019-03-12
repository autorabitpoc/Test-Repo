/**************************************************************************************
  Apex Class Name     : GEMSBACatAssignController_TEST
  Version             : 1.0
  Function            : This class serves as Unit Test Class for GEMSBACatAssignController.
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        07/19/2016                Original Version
*************************************************************************************/
@isTest 
public class GEMSBACatAssignController_TEST{
    public static testMethod void GEMSBACatAssignController_TEST1()
    {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;

        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);

        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        product2Rec.Product_Category__c='EPO;PPO;Dental';
        insert product2Rec;

        Opportunity opp = GEMS_UtilityClassTest.insertionOpp(acc.id);
        insert opp;

        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;

        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);

        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );

        Case caseObj= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        caseObj.accountId = acc.Id;
        caseObj.Status = 'Design In Progress';
        insert caseObj;

        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);

        List<GEMS_Category__c> catList = new List<GEMS_Category__c>();
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(acc.ID,caseObj.Id);
        gemscat1.Usage_Billing__c = true;
        gemscat1.Usage_Reporting__c = true;
      
        GEMS_Category__c gemscat2 = GEMS_UtilityClassTest.insertiongemscat2(acc.ID,caseObj.Id);
        gemscat2.Usage_Billing__c = true;
        catList.add(gemscat1);
        catList.add(gemscat2);
        insert catList;
        System.assertEquals('1234',catList[0].Name);
        gemscat1.Category_Description__c ='Changed';
        gemscat1.IsNew__c= False;
        Update gemscat1;
        List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(acc.ID,caseObj.Id);
        insert gemsGroupObj;
        groupSectionList.add(gemsGroupObj);
        GEMS_Group_Section__c  grpquery =[select id,Group_No__c from GEMS_Group_Section__c where account__c=:acc.ID and case__c= :caseObj.Id];
        System.assertEquals('TeSt02',grpquery.Group_No__c);

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(acc.ID,caseObj.Id,catList[0].Id,gemsGroupObj.Id);
        insert gemsCatAsgmnt;

        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(acc.ID,caseObj.Id);
        insert gemsCaract ;
        System.assertEquals('ABS',gemsCaract.Usage__c );
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c gemsbenefit = GEMS_UtilityClassTest.insertionBenefit(acc.ID,caseObj.Id,product2Rec.id);
        baList.add(gemsbenefit);
        insert baList;
        System.assertEquals('1234',gemsbenefit.Name);
        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(acc.ID,caseObj.Id,baList[0].id,catList[0].Id);
        insert catass;
/*
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,caseObj.Id);
        insert charval;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(caseObj.Id,acc.ID,charval.id,catList[0].Id);
        insert charass ;
        */
        PageReference pageRef = Page.GEMSBACatAssign;
        String strlist = baList[0].id;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recs',strlist);
        ApexPages.currentPage().getParameters().put('RN','1234');
        ApexPages.currentPage().getParameters().put('RecordCan',CaseObj.id);
        ApexPages.currentPage().getParameters().put('dDate','07/05/16');
        Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);
        GEMSBACatAssignController gm = new GEMSBACatAssignController (stdControllerr);
        List<Id> idlist=null;
        list < Id > newList ;
        list<list < Id >> newListList ;
        List<GEMSBACatAssignController.CatWrapper> wrapList = new List<GEMSBACatAssignController.CatWrapper>();
        GEMSBACatAssignController.CatWrapper catwrap = new GEMSBACatAssignController.CatWrapper();
        
        gm.getRecords();
        gm.getSize();
        catwrap.IsAssigned = true;
        wrapList.add(catwrap);
        gm.cats = wrapList;
       // gm.selectedCat = catList;
      //  gm.getTheUpdatedMembersCount();
        gm.gotoCase();
        gm.numberOfRowToRemove=1;
        gm.numberOfNewRowToRemove = 1;
      //  gm.rowCount = '2';
       // String CancelDate = '10/03/2016' ;
        gm.cancelDate = date.parse('12/27/2009'); 
        gm.recordToDelete = caseObj.ID;
        gm.NewrecordToDelete = caseObj.ID;
       // gm.updateRecord();
        gm.removeNewRow();
        gm.removeRow();
        
        gm.refresh();
        gm.offset = 0;
        gm.limitSize = 1;
        gm.pageNumber = 2;
        gm.hasPrevious = true;
        gm.hasNext = true;
        gm.first();
        gm.last();
        gm.previous();
        gm.next();
        gm.goToCharacteristics();
        gm.addCat();
        gm.addAllCats();
        GEMS_Category__c newCat1 = GEMS_UtilityClassTest.insertiongemscat3(acc.ID,caseObj.Id);
        
        gm.newCats.add(newCat1) ;
        
        gm.saveCat();
       // gm.assignCat();
        gm.gotoCreateAccountStructure();
        gm.backtoBA();
        gm.cancelRecord();

        Map < Id, GEMS_Category__c > idcatmap = new Map < Id, GEMS_Category__c >();
        idcatmap.put(catList[0].id,catList[0]);
        idcatmap.put(catList[1].id,catList[1]);
       // gm.mapOfIdAndCat = idcatmap;
        ApexPages.currentPage().getParameters().put('RecordCan',catList[0].id);
        gm.cancelRecord();
      //  gm.mapOfIdAndCat = idcatmap;
        gm.recordToDelete = catList[0].id;
       // gm.selectedIda='ABS';
      //  gm.recordToCancel=caseObj.id;

        
        }
      
  /*public static testMethod void GEMSBACatAssignController_TEST2()
    {
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);

        case caseObj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj .GEMS_Submission_Type__c = 'Renewal';
        caseObj .GEMS_Case_Effective_Date__c = date.today();
        caseObj.accountid= acc.id;
        caseObj.Status= 'Design In Progress';
        insert caseObj;

        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertionGemsCatg(acc.ID,caseObj.Id);
        insert gemscat1;
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        product2Rec.Product_Category__c='EPO;PPO;Dental';
        insert product2Rec;
        List<GEMS_Group_Section__c> groupSectionList1 = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj1 = GEMS_UtilityClassTest.insertionGroup(acc.ID,caseObj.Id);
        insert gemsGroupObj1;
        groupSectionList1.add(gemsGroupObj1);
        GEMS_Group_Section__c  grpquery =[select id,Group_No__c from GEMS_Group_Section__c where account__c=:acc.ID and case__c= :caseObj.Id];
        System.assertEquals('TeSt02',grpquery.Group_No__c);
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c gemsbenefit = GEMS_UtilityClassTest.insertionBenefit(acc.ID,caseObj.Id,product2Rec.id);
        GEMS_Benefit_Agreement__c gemsbenefit1 = GEMS_UtilityClassTest.insertionBenefit(acc.ID,caseObj.Id,product2Rec.id);
        baList.add(gemsbenefit);
        baList.add(gemsbenefit1);
        insert baList;

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(acc.ID,caseObj.Id,gemsCat1.Id,gemsGroupObj1.Id);
        insert gemsCatAsgmnt;

        PageReference pageRef = Page.GEMSBACatAssign;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recs',gemsGroupObj1.Id);
        Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList1);
        GEMSBACatAssignController gm = new GEMSBACatAssignController (stdControllerr);

        gm.getTheUpdatedMembersCount();
        gm.gotoCase();
        gm.numberOfRowToRemove=2;
        gm.rowCount = '2';
        gm.recordToDelete= caseObj.ID;
        gm.numberOfNewRowToRemove  = 1;
        gm.recordToDelete  = caseObj.ID; 
        gm.removeNewRow();
        gm.removeRow(); 
        gm.assignCat();
        gm.gotoCreateAccountStructure();

        gm.backtoBA();
        gm.saveCat();
    }

    public static testMethod void GEMSBACatAssignController_TEST3()
    {

        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;

        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);

        case caseObj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj .GEMS_Submission_Type__c = 'Renewal';
        caseObj.accountid= acc.id;
        insert caseObj;
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        product2Rec.Product_Category__c='EPO;PPO;Dental';
        insert product2Rec;

        List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(acc.ID,caseObj.Id);
        insert gemsGroupObj;
        groupSectionList.add(gemsGroupObj);
        GEMS_Group_Section__c  grpquery =[select id,Group_No__c from GEMS_Group_Section__c where account__c=:acc.ID and case__c= :caseObj.Id];
        System.assertEquals('TeSt02',grpquery.Group_No__c);
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(acc.ID,caseObj.Id);

        insert gemscat1;
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c gemsbenefit = GEMS_UtilityClassTest.insertionBenefit(acc.ID,caseObj.Id,product2Rec.id);
        GEMS_Benefit_Agreement__c gemsbenefit1 = GEMS_UtilityClassTest.insertionBenefit(acc.ID,caseObj.Id,product2Rec.id);
        baList.add(gemsbenefit);
        baList.add(gemsbenefit1);
        insert baList;

        PageReference pageRef = Page.GEMSBACatAssign;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recs',gemsGroupObj.Id);
        Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);
        GEMSBACatAssignController gm = new GEMSBACatAssignController (stdControllerr);

        gm.getTheUpdatedMembersCount();
        gm.gotoCase();
        gm.numberOfRowToRemove=2;
        gm.rowCount = '2';

        gm.recordToDelete= caseObj.ID;
        gm.removeRow(); 
        gm.assignCat();
        gm.gotoCreateAccountStructure();
        gm.backtoBA();
        gm.saveCat();
        //List<Integer> ittt =gm.iter;
      //  List < List < SelectOption >> opplist = gm.listOfOptions;
    }    */  
}