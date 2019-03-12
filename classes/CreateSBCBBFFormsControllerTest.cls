@isTest
public class CreateSBCBBFFormsControllerTest {
    static testMethod void testdetailpage6() {
        GEMS_Contract_Admin_Request__c CARObj;
        List<Request_Type__c> rType;
        
        CARObj = new GEMS_Contract_Admin_Request__c();
        insert CARObj;
        
        Test.startTest(); 
        CreateSBCBBFormsController.getSBCBBForms(CARObj.Id);   
        CreateSBCBBFormsController.getSBCBBFormsRecordType('GEMS SBC Form');
        
        Test.stopTest();
    }
}