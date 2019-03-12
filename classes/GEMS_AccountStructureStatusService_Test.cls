@isTest
public class GEMS_AccountStructureStatusService_Test {
    public static testMethod void GEMS_AccountStructureStatusService_Test1(){
         Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case CaseObj = new Case();
        CaseObj.Funding_Type_Multiselect__c = 'ACAP';
        CaseObj.Subject = 'Test';
        CaseObj.Type = 'Benefits';
        CaseObj.Sub_Category__c = 'Benefit Booklet';
        CaseObj.Status = 'Working';
        CaseObj.Priority = 'Low';
        CaseObj.Origin = 'Email';
        CaseObj.GEMS_Effective_Date__c = system.today();
        CaseObj.GEMS_Case_Effective_Date__c = system.today();
        CaseObj.RecordTypeId = caseAccountStructureRecordTypeId;
        insert CaseObj;
        
        GEMS_AccountStructureStatusServiceInput input = new GEMS_AccountStructureStatusServiceInput();
        input.acctNbr = '324';
        input.status = 'S';
        input.accountStructureCaseID = CaseObj.Id;
        
        GEMS_AccountStructureStatusServiceOutput output = GEMS_AccountStructureStatusService.updateStatus(input); 
        input.status = 'P';
        GEMS_AccountStructureStatusServiceInput.ErrorData errData = new GEMS_AccountStructureStatusServiceInput.ErrorData();
        errData.acctErrorMessage = 'TestError';
        input.errorData = errData;
        GEMS_AccountStructureStatusServiceOutput output2 = GEMS_AccountStructureStatusService.updateStatus(input);
        Test.startTest();
         Id caseAccountStructureRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.External_ID__c = '000933';
        accObj.Cancellation_Date__c = system.today();
        accObj.Requested_Cancellation_Date__c = system.today();
        accObj.RecordTypeId = caseAccountStructureRecordTypeId1;
        insert accObj;
        
        GEMS_AccountStructureStatusServiceInput input1 = new GEMS_AccountStructureStatusServiceInput();
        input.acctNbr = '000933';
        input.status = 'S';
        input.accountStructureCaseID = accObj.Id;
        
        GEMS_AccountStructureStatusServiceOutput output3 = GEMS_AccountStructureStatusService.updateStatus(input); 
        input.status = 'P';
        GEMS_AccountStructureStatusServiceInput.ErrorData errData1 = new GEMS_AccountStructureStatusServiceInput.ErrorData();
        errData.acctErrorMessage = 'TestError';
        input.errorData = errData1;
        GEMS_AccountStructureStatusServiceOutput output4 = GEMS_AccountStructureStatusService.updateStatus(input);
        input.status = 'S';
        input.message = 'ACCOUNT CANCELLATION SUCCESSFULL';
        GEMS_AccountStructureStatusServiceOutput output5 = GEMS_AccountStructureStatusService.updateStatus(input);
        input.status = 'S';
        input.message = 'ACCOUNT CANCELLATION PENDED';
        GEMS_AccountStructureStatusServiceOutput output6 = GEMS_AccountStructureStatusService.updateStatus(input);
        input.status = 'S';
        input.message = 'MEIN SETUP PROCESS EXECUTED SUCCESSFULLY';
        GEMS_AccountStructureStatusServiceOutput output7 = GEMS_AccountStructureStatusService.updateStatus(input);    
        input.status = 'P';
        input.message = 'MEIN SETUP PROCESS EXECUTED PARTIALLY';
        GEMS_AccountStructureStatusServiceOutput output8 = GEMS_AccountStructureStatusService.updateStatus(input);            
        Test.stopTest();

    }   
}