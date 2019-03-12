@isTest
public class GEMS_GenerateAccountStructureCtrl_Test {
 public static testMethod void GEMS_GenerateAccountStructureCtrl_Test1(){
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Type= 'Sub Producer';
        acc.Type= 'Sub Producer';
        acc.External_Id__c  = '1234555';
        acc.Email__c = 'test@test.com'; 
        insert acc;
        
        Case CaseObj = new case();
        CaseObj.AccountId =acc.id;
        CaseObj.Subject = 'Test';
        CaseObj.Type = 'Benefits';
        CaseObj.Sub_Category__c = 'Benefit Booklet';
        CaseObj.Status = 'Working';
        CaseObj.Priority = 'Low';
        CaseObj.Origin = 'Email';
        CaseObj.GEMS_Effective_Date__c = system.today();
        CaseObj.GEMS_Case_Effective_Date__c = system.today();
        insert CaseObj;
        
        product2 prod = new product2();
        prod.name = 'BlueCard';
        insert prod;
        
        GEMS_Benefit_Agreement__c gemsb = new GEMS_Benefit_Agreement__c(); 
        gemsb.Account__c = acc.id;
        gemsb.AccountStructureCase__c = CaseObj.id;
        gemsb.Product__c = prod.Id;
        gemsb.name='1234';
        insert gemsb;
        
       list<GEMS_Group_Section__c> Grouplist = new list<GEMS_Group_Section__c>();
     
        GEMS_Group_Section__c gemgs = new GEMS_Group_Section__c ();
        gemgs.Account__c = acc.id;
        gemgs.Case__c =CaseObj.id;
        gemgs.Group_No__c ='P04549';
        gemgs.Section_No__c ='1000';
        Grouplist .add(gemgs );
        insert Grouplist ;
       
        
        GEMS_Category__c gemcat = new GEMS_Category__c ();
        gemcat.Account__c = acc.id;
        gemcat.Case__c =CaseObj.id;
        gemcat.Category_Cobra_Code__c ='CO';
        gemcat.Name='1234';
        insert gemcat;
        
        GEMS_Category_Assignment__c gemCa = new GEMS_Category_Assignment__c();
        gemCa.Case__c =CaseObj.id;
        gemCa.Account__c =acc.id;
        gemCa.Group_Section__c =Grouplist[0].id;
        gemCa.Category__c=gemcat.id;
        insert gemCa;
        
        GEMS_BA_Assignment__c GemBa =new GEMS_BA_Assignment__c();
        GemBa.Case__c =CaseObj.id;
        GemBa.Account__c =acc.id;
        GemBa.Benefit_Agreement__c =gemsb.id;
        GemBa.Group_Section__c =Grouplist[0].id;
        insert GemBa;
        
        GEMS_BA_Assignment__c GemBa2 =new GEMS_BA_Assignment__c();
        GemBa2.Case__c =CaseObj.id;
        GemBa2.Account__c =acc.id;
        GemBa2.Benefit_Agreement__c =gemsb.id;
        GemBa2.Group_Section__c =Grouplist[0].id;
        insert GemBa2;     
        
     Test.startTest();
     ApexPages.currentpage().getParameters().put('caseId',CaseObj.id);
     GEMS_GenerateAccountStructureController gms = new GEMS_GenerateAccountStructureController();
     Set<Id> catIds = new Set<Id>();
     catIds.add(Grouplist[0].Id);
     gms.CalculateAssociations();
     gms.count = 2;
     gms.GSSet = catIds;
     gms.GenerateDocument();
     gms.GetAllObjects();
     gms.size = 2;
     gms.NavigateBack();
     gms.CalculateAssociations();
     //gms.GetlistofAllCombinations();     
     gms.getFinalBenefitAgreements();
     gms.getFinalCategories();
     gms.getFinalGroupSections();
     gms.getGS_BA_Associations();
     gms.getGS_Cat_Associations();
     List<Integer> intttt = gms.iter;
     
     Test.stopTest();
}
    
}