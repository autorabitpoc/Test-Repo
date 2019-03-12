@isTest

public class GEMS_IDCardUtil_Test {
    
    
    private static testmethod void testGetAssignmentItems() {
        List<SelectOption> options = GEMS_IDCardUtil.getAssignmentItems();
        SelectOption option = options.get(1);
        System.assertEquals('Group Section', option.getValue());
    }
    
    private static testmethod void testCopyCustomIDFormToIDCompare() {
        List<GEMS_Custom_ID_Request_Form__c> customIDFormList = new List<GEMS_Custom_ID_Request_Form__c>(); 
        GEMS_Custom_ID_Request_Form__c cForm = new GEMS_Custom_ID_Request_Form__c();
        cForm.Applicable_BAs__c = '1111,2222';
        cForm.Applicable_GSs__c = '';
        cForm.Assignment_Type__c = 'Benefit Agreement';
        cForm.Issuance_Type__c = 'Full Issuance';
        //insert cForm;
        customIDFormList.add(cForm);
        List<GEMS_IDCompare> idCompareList = GEMS_IDCardUtil.CopyCustomIDFormToIDCompare(customIDFormList);
        GEMS_IDCompare idCompare = idCompareList.get(0);
        System.assertEquals('1111,2222', idCompare.applicableBAs);
	}
    
    private static testmethod void testCopyIDCompareToProspectiveIDForm() {
        List<GEMS_IDCompare> idcompareList = new List<GEMS_IDCompare>();
        Map<ID, GEMS_Prospective_ID_Card__c> oldMap = new Map<ID, GEMS_Prospective_ID_Card__c>();
        GEMS_IDCardUtil.copyIDCompareToProspectiveIDForm(idcompareList, oldMap);
    }
    
    
    private static testmethod void testCopyIDCompareToSuppressionIDForm() {
     	List<GEMS_IDCompare> idcompareList = new List<GEMS_IDCompare>();
        Map<ID, GEMS_ID_Card_Suppression__c> oldMap = new Map<ID, GEMS_ID_Card_Suppression__c>();
        GEMS_IDCardUtil.copyIDCompareToSuppressionIDForm(idcompareList,oldMap);
    }
    
    private static testmethod void testUpdateExistingAssignments() {
    	Id formId;
        String assignmentType = 'Benefit Agreement';
        String baCaseNums = '0001';
        String gsCaseNums = '1234-1563';
    	List<GEMS_IDCompare> idCompareList = new List<GEMS_IDCompare>();
        GEMS_CustomFormInput customFormInput = new GEMS_CustomFormInput(formId,assignmentType,baCaseNums,gsCaseNums,idCompareList);
        List<GEMS_IDCompare> idCompareListNew = GEMS_IDCardUtil.updateExistingAssignments(customFormInput);
    }
}