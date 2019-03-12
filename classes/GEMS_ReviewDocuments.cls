public with sharing class GEMS_ReviewDocuments 
{
    public Case cases{get;set;}
    public Case caseRecord{get;set;}
    public List<GEMS_Attachment__c> documentsList{get;set;}
    
    public GEMS_ReviewDocuments(ApexPages.StandardController controller) 
    {
        try {
        cases = (case)controller.getRecord();
        caseRecord = [Select ID, GEMS_Return_Check__c, GEMS_ReviewDocuments__c, GEMS_Approve__c,GEMS_Return__c,GEMS_Routed_In_Error__c, Status, GEMS_Account_Submission_Info__c,RecordType.name from Case where ID =: cases.ID];
        documentsList = [Select ID, name, Attachment__c, Case__c, Description__c, Type__c, View__c, CreatedBy.name, createdDate from GEMS_Attachment__c where Case__c =: caserecord.GEMS_Account_Submission_Info__c ];
        }
        catch(Exception ex){
        System.debug('======Exception==========='+ex.getMessage());
        }
    }

}