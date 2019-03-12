/**************************************************************************************
  Apex Class Name     : GEMS_SelectCharValController_TEST
  Version             : 1.0
  Function            : This class serves as Unit Test Class for GEMSBACatAssignController.
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari       10/04/2016                Original Version
*************************************************************************************/
@isTest 
public class GEMS_SelectCharValController_TEST{
    public static testMethod void GEMS_SelectCharValController_TEST1()
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
       // GEMS_Category__c gemscat2 = GEMS_UtilityClassTest.insertiongemscat1(acc.ID,caseObj.Id);
       // catList.add(gemscat1);
       
        gemscat1.Usage_Billing__c = true;
        catList.add(gemscat1);
        
        insert catList;
        System.assertEquals('1234',catList[0].Name);

       /* List<GEMS_Group_Section__c> groupSectionList = new List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(acc.ID,caseObj.Id);
        insert gemsGroupObj;
        groupSectionList.add(gemsGroupObj);
        GEMS_Group_Section__c  grpquery =[select id,Group_No__c from GEMS_Group_Section__c where account__c=:acc.ID and case__c= :caseObj.Id];
        System.assertEquals('TeSt02',grpquery.Group_No__c);

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(acc.ID,caseObj.Id,catList[0].Id,gemsGroupObj.Id);
        insert gemsCatAsgmnt;
        */
        List<GEMS_Characteristic__c> CharList = new List<GEMS_Characteristic__c>();
        
        List<GEMS_Characteristic_Value__c> CharValList = new List<GEMS_Characteristic_Value__c>();
        
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(acc.ID,caseObj.Id);
        CharList.add(gemsCaract);
        insert gemsCaract ;
        GEMS_Characteristic__c gemsCaract2 = GEMS_UtilityClassTest.insertionCharacteristic2(acc.ID,caseObj.Id);
        CharList.add(gemsCaract2);
        insert gemsCaract2 ;
        System.assertEquals('ABS',gemsCaract.Usage__c );
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c gemsbenefit = GEMS_UtilityClassTest.insertionBenefit(acc.ID,caseObj.Id,product2Rec.id);
        baList.add(gemsbenefit);
        insert baList;
        System.assertEquals('1234',gemsbenefit.Name);
        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(acc.ID,caseObj.Id,baList[0].id,catList[0].Id);
        insert catass;

        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,caseObj.Id);
        CharValList.add(charval);
        insert charval;
        GEMS_Characteristic_Value__c charval2 = GEMS_UtilityClassTest.insertionCharacValue2(gemsCaract.id,caseObj.Id);
        CharValList.add(charval2);
        insert charval2;
         list<GEMS_Cat_Char_Value_Association__c> insertAssociations = new list<GEMS_Cat_Char_Value_Association__c>();
        GEMS_Cat_Char_Value_Association__c charValueCatAssoc = 
                        new GEMS_Cat_Char_Value_Association__c(Case__c = caseObj.Id, Category__c = gemscat1.Id, Characteristic_Value__c = charVal.Id, Account__c = catList[0].Account__c);
                        insertAssociations.add(charValueCatAssoc);
        insert insertAssociations;
        /*
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(caseObj.Id,acc.ID,charval.id,catList[0].Id);
        insert charass ;
        GEMS_Cat_Char_Value_Association__c charass2 = GEMS_UtilityClassTest.insertionAssociate(caseObj.Id,acc.ID,charval2.id,catList[0].Id);
        insert charass2 ;
        */
        PageReference pageRef = Page.GEMSBACatAssign;
        String strlist = baList[0].id;
        Test.setCurrentPage(pageRef);
       // Apexpages.StandardSetController stdControllerr = new Apexpages.StandardSetController(groupSectionList);
        GEMS_SelectCharValController gm = new GEMS_SelectCharValController ();
        List<Id> idlist=null;
        list < Id > newList ;
        list<list < Id >> newListList ;
        List<GEMS_SelectCharValController.CharWrapper> wrapList = new List<GEMS_SelectCharValController.CharWrapper>();
        
        List<GEMS_SelectCharValController.CharValWrapper> wrapListCharVal = new List<GEMS_SelectCharValController.CharValWrapper>();
        
        GEMS_SelectCharValController.CharWrapper charWrap = new GEMS_SelectCharValController.CharWrapper(true,true,gemsCaract);
        GEMS_SelectCharValController.CharWrapper charWrap2 = new GEMS_SelectCharValController.CharWrapper(true,true,gemsCaract2);
        
        
        
        GEMS_SelectCharValController.CharValWrapper chaValWrap = new GEMS_SelectCharValController.CharValWrapper(true,false,charval,insertAssociations);
        GEMS_SelectCharValController.CharValWrapper charValWrap2 = new GEMS_SelectCharValController.CharValWrapper(true,false,charval2,insertAssociations);
     //   GEMSBACatAssignController.CatWrapper catwrap = new GEMSBACatAssignController.CatWrapper(true,catList[0],idlist,newListList,null);
       
       
       Map < Id, GEMS_Characteristic__c > idcharmap = new Map < Id, GEMS_Characteristic__c >();
       idcharmap.put(CharList[0].id,CharList[0]);
        idcharmap.put(CharList[1].id,CharList[1]);
       Map < Id, GEMS_Characteristic_Value__c > idcharValmap = new Map < Id, GEMS_Characteristic_Value__c >();
       idcharValmap.put(CharValList[0].id,CharValList[0]);
        idcharValmap.put(CharValList[1].id,CharValList[1]);
       
      gm.limitSizeChar = 1;
      gm.offsetChar = 0;
     gm.sizeChar = 2;
      gm.limitSize = 1;
      gm.offset = 0;
       gm.offsetChar = 0;
        gm.selChar = CharList[0].id ;
        gm.selCharVal = CharValList[0].id;
        gm.cats = catList;
        wrapList.add(charWrap);
        wrapList.add(charWrap2);
        wrapListCharVal.add(chaValWrap);
        wrapListCharVal.add(charValWrap2);
        gm.chars = wrapList;
        gm.charValues = wrapListCharVal;
        gm.getRecords();
      gm.getSize();
      gm.getSizeValue();
      gm.goToCats();
        gm.assignChar();
        gm.isSelected = true;
        gm.assignValues();
        gm.updateCategory();
        gm.gotoCase();
        gm.selChar = null ;
        gm.assignChar();
        gm.refresh();
        gm.size = 2;   
        gm.offset = 0;
        gm.limitSize = 1;
        gm.pageNumber = 2;
        gm.hasPrevious = true;
        gm.hasNext = true;
        
        gm.last();
        gm.first();
        gm.next();
        gm.previous();
        
        gm.last();
        
        gm.refreshChar();
        gm.sizeChar = 2;   
        gm.offsetChar = 0;
        gm.limitSizeChar = 1;
        gm.pageNumberChar = 2;
        gm.hasPreviousChar = true;
        gm.hasNextChar = true;
        gm.lastChar();
        gm.firstChar();
        gm.nextChar();
        gm.previousChar();
        
    /*
        Map < Id, GEMS_Category__c > idcatmap = new Map < Id, GEMS_Category__c >();
        idcatmap.put(catList[0].id,catList[0]);
        idcatmap.put(catList[1].id,catList[1]);
        ApexPages.currentPage().getParameters().put('RecordCan',catList[0].id);
      */

        
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