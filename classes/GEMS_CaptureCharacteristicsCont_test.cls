@isTest
public class GEMS_CaptureCharacteristicsCont_test {
private static testmethod void GEMS_CaptureCharacteristicsController()
{     
          Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
          User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com');
        
          Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='GEMS Account Specialist'];
          User testUserNoAccess = TestClassUtiltity.CreateUserRecord(profileRec1.Id, 'test@user12.com', 'testUser1', 'test@user1.com');
        
        
 Test.startTest();
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
       
         
        
        list<case> caselist = new list<case>();
        Case caseObj = GEMS_UtilityClassTest.insertionCase('GEMS Screening');
        caselist.add(caseObj);
        
      Case caseObj1 = GEMS_UtilityClassTest.insertionCase('GEMS Screening');
       caselist.add(caseObj1);
       insert caselist;
       
       
   GEMS_Characteristic__c gemscha =GEMS_UtilityClassTest.insertionCharacteristic(acc.id, caselist[0].id); 
    GEMS_Corp_Characteristic_Code__c corp = GEMS_UtilityClassTest.insertionCorp();
    insert corp ;
    gemscha.Corp_Characteristic_Code__c = corp.id;
    insert gemscha;
    
    List<GEMS_Characteristic__c> CharRec=[Select ID from GEMS_Characteristic__c];
         System.assertEquals(1,CharRec.Size());
   
        GEMS_Characteristic_Value__c gemschav = GEMS_UtilityClassTest.insertionCharacValue(gemscha.id, caselist[0].id);    
        insert gemschav;
        
         List<GEMS_Characteristic_Value__c> ChravalRec =[Select ID from GEMS_Characteristic_Value__c];
         System.assertEquals(1,ChravalRec.Size());
    
         List<Case> caseRec =[Select ID from case];
         System.assertEquals(2,caseRec.Size());
        system.runAs(testUser){
        Test.setCurrentPage(Page.GEMSCaptureCharacteristics);
        ApexPages.currentPage().getParameters().put('caseId',caselist[0].id);
        ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(caselist);
        stdSetController.setSelected(caselist);
        GEMS_CaptureCharacteristicsController gems = new GEMS_CaptureCharacteristicsController(stdSetController);
        gems.caseId = caselist[0].id;
        gems.accountId =acc.Id;
        gems.Characteristic =gemscha;
       
        
        
    GEMS_CaptureCharacteristicsController.Characteristic_ValueWrapper wraval = new GEMS_CaptureCharacteristicsController.Characteristic_ValueWrapper(true,gemschav);
                   
         //gems.recordToDelete='gemschar1.id';
        
         gems.getTheUpdatedMembersCount();
         gems.getCharacteristic_Values();
         gems.addCharacteristic_Value();
         gems.saveCharacteristicValues();
         gems.gotoCase(); 
         gems.removeCharacteristic_Value();
         gems.removeRow();
         gems.recordToDelete=gemschav.id;
         gems.rowCount ='3';
         gems.Characteristic_ValueRecordId=''; 
         gems.hasEditAccess =true;
         gems.listOfCharacteristic_Values =null;
         gems.getTheUpdatedMembersCount(); 
       
         }   
         
              system.runAs(testUserNoAccess){
        Test.setCurrentPage(Page.GEMSCaptureCharacteristics);
        ApexPages.currentPage().getParameters().put('caseId',caselist[0].id);
        ApexPages.currentPage().getParameters().put('accountId',acc.Id);
            
        ApexPages.StandardSetController stdSetController1 = new ApexPages.StandardSetController(caselist);
        stdSetController1.setSelected(caselist);
        GEMS_CaptureCharacteristicsController gems1 = new GEMS_CaptureCharacteristicsController(stdSetController1);
        gems1.caseId = caselist[0].id;
        gems1.accountId =acc.Id;
        gems1.Characteristic =gemscha;
       
        
        
    GEMS_CaptureCharacteristicsController.Characteristic_ValueWrapper wraval1 = new GEMS_CaptureCharacteristicsController.Characteristic_ValueWrapper(true,gemschav);
                   
         //gems.recordToDelete='gemschar1.id';
        
         gems1.getTheUpdatedMembersCount();
         gems1.getCharacteristic_Values();
         //gems1.addCharacteristic_Value();
         gems1.saveCharacteristicValues();
         gems1.gotoCase(); 
         gems1.removeCharacteristic_Value();
         gems1.removeRow();
         gems1.recordToDelete=gemschav.id;
         gems1.rowCount ='3';
         gems1.Characteristic_ValueRecordId=''; 
         gems1.hasEditAccess =true;
         gems1.listOfCharacteristic_Values =null;
         gems1.getTheUpdatedMembersCount(); 
       
         }  
         Test.stopTest();   
}
}