@isTest
public class GEMS_CasehierarchyTest {
private static testmethod void GEMS_Casehierarchy(){

         Case caseRecordsub = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseRecordsub .HCSC_Division__c ='PL';
        caseRecordsub .GEMS_Effective_Date__c = system.today();
        caseRecordsub .RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseRecordsub .GEMS_Case_Effective_Date__c = date.today();
        caseRecordsub .GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecordsub .GEMS_Enter_number_of_categories__c = '2';
        caseRecordsub .GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecordsub .Type = 'Account Structure Change';
        caseRecordsub .Status = 'New';
        //caseRecord.Owner_Name__c = 'Test';
        insert caseRecordsub ;
        
       List<case> caseList = new List<case>();
        for(integer i=0;i<2;i++) {
         Case caseRecord = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Type = 'Account Structure Change';
        caseRecord.Status = 'New';
        caseRecord.parentid = caseRecordsub.id;
        //caseRecord.Owner_Name__c = 'Test';
        caseList.add(caseRecord);
        }
        
        insert caseList;
        
         List<case> caseType = new List<case>();
        for(integer i=0;i<2;i++) {
         Case caseRecType = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseRecType.HCSC_Division__c ='PL';
        caseRecType.GEMS_Effective_Date__c = system.today();
        caseRecType.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseRecType.GEMS_Case_Effective_Date__c = date.today();
        caseRecType.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecType.GEMS_Enter_number_of_categories__c = '2';
        caseRecType.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        
        caseRecType.Type = 'Blue Directions';
        caseRecType.Status = 'New';
       // caseRecType.Owner_Name__c = 'Test';
        caseType.add(caseRecType);
        }
        
        insert caseType;

       
        Account acc = new Account();
        acc.status__c = 'Sold';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
   
        Test.startTest();
        ApexPages.currentPage().getParameters().put('caseId', caseList[0].id);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(caseList);
        Map<Id ,Case> mapHierarchy1 = new Map<Id , Case>(); 
        
        
        GEMS_Casehierarchy gemsHr = new GEMS_Casehierarchy();
        mapHierarchy1.put(caseList[0].id,caseList[0]);
        gemsHr.mapHierarchy =mapHierarchy1;
        gemsHr.CaseCategory = 'Account Setup Screening';
        Integer hirarchyIndexNo = 2;
        List<GEMS_Casehierarchy.hierarchyItem> list1 = new List<GEMS_Casehierarchy.hierarchyItem>();
        //GEMS_Casehierarchy.hierarchyItem  hier = new GEMS_Casehierarchy.hierarchyItem();
        GEMS_Casehierarchy.hierarchyItem hier = new GEMS_Casehierarchy.hierarchyItem(caseList[0].Type,caseList[0].Status,caseList[0].Owner_Name__c ,hirarchyIndexNo);
        list1.add(hier);
        gemsHr .getChildHierarchy(caseRecordsub.id,list1);
        caseList[0].parentid=null;
        update caseList[0];
        mapHierarchy1.put(caseList[0].id,caseList[0]);
        gemsHr.mapHierarchy =mapHierarchy1;
        gemsHr .getChildHierarchy(null,list1);
        Test.stopTest();
}

private static testmethod void GEMS_CasehierarchyException(){

         Case caseRecordsub = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseRecordsub .HCSC_Division__c ='PL';
        caseRecordsub .GEMS_Effective_Date__c = system.today();
        caseRecordsub .RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseRecordsub .GEMS_Case_Effective_Date__c = date.today();
        caseRecordsub .GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecordsub .GEMS_Enter_number_of_categories__c = '2';
        caseRecordsub .GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecordsub .Type = 'Account Structure Change';
        caseRecordsub .Status = 'New';
        //caseRecord.Owner_Name__c = 'Test';
        insert caseRecordsub ;
        
       List<case> caseList = new List<case>();
        for(integer i=0;i<2;i++) {
         Case caseRecord = new case();
        //caseObj.Id = ApexPages.currentPage().getParameters().get('Id');
        caseRecord.HCSC_Division__c ='PL';
        caseRecord.GEMS_Effective_Date__c = system.today();
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseRecord.GEMS_Case_Effective_Date__c = date.today();
        caseRecord.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecord.GEMS_Enter_number_of_categories__c = '2';
        caseRecord.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseRecord.Type = 'Account Structure Change';
        caseRecord.Status = 'New';
        caseRecord.parentid = null;
        //caseRecord.Owner_Name__c = 'Test';
        caseList.add(caseRecord);
        }
        
        insert caseList;
        
         List<case> caseType = new List<case>();
        for(integer i=0;i<2;i++) {
         Case caseRecType = new case();
        //caseObj.Id =  ApexPages.currentPage().getParameters().get('Id');
        caseRecType.HCSC_Division__c ='PL';
        caseRecType.GEMS_Effective_Date__c = system.today();
        caseRecType.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        caseRecType.GEMS_Case_Effective_Date__c = date.today();
        caseRecType.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseRecType.GEMS_Enter_number_of_categories__c = '2';
        caseRecType.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        
        caseRecType.Type = 'Blue Directions';
        caseRecType.Status = 'New';
       // caseRecType.Owner_Name__c = 'Test';
        caseType.add(caseRecType);
        }
        
        insert caseType;

       
        Account acc = new Account();
        acc.status__c = 'Sold';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
   
        Test.startTest();
        ApexPages.currentPage().getParameters().put('caseId', caseRecordsub.id);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(caseList);
        Map<Id ,Case> mapHierarchy1 = new Map<Id , Case>(); 
        
        
        GEMS_Casehierarchy gemsHr = new GEMS_Casehierarchy();
        mapHierarchy1.put(caseList[0].id,caseList[0]);
        gemsHr.mapHierarchy =mapHierarchy1;
        gemsHr.CaseCategory = 'Account Setup Screening';
        Integer hirarchyIndexNo = 2;
        List<GEMS_Casehierarchy.hierarchyItem> list1 = new List<GEMS_Casehierarchy.hierarchyItem>();
        //GEMS_Casehierarchy.hierarchyItem  hier = new GEMS_Casehierarchy.hierarchyItem();
        GEMS_Casehierarchy.hierarchyItem hier = new GEMS_Casehierarchy.hierarchyItem(caseList[0].Type,caseList[0].Status,caseList[0].Owner_Name__c ,hirarchyIndexNo);
        list1.add(hier);
        gemsHr .getChildHierarchy(caseRecordsub.id,list1);
        caseList[0].parentid=null;
        update caseList[0];
        mapHierarchy1.put(caseList[0].id,caseList[0]);
        gemsHr.mapHierarchy =mapHierarchy1;
        gemsHr .getChildHierarchy(null,list1);
        Test.stopTest();
}


}