public class LGNA_ServiceRequestSubmitCntlr{

private final Service_Request__c sr,sr1;
    public string errorMessage {get;set;}
    public LGNA_ServiceRequestSubmitCntlr(ApexPages.StandardController stdController) {
        this.sr1= (Service_Request__c )stdController.getRecord();
        system.debug(sr1+'testss+++++');
         this.sr=[select Stage__c, Status__c from Service_Request__c  where Id=:sr1.Id];
        }

 public void SubmitFunction(){
        string recordTypeName = Schema.SObjectType.Service_Request__c.getRecordTypeInfosById().get(sr1.RecordTypeId).getName();
        if(recordTypeName == 'Open Enrollment'){
            // call the submit button. 
            srSubmitRequest();
        }
       }
       
    public PageReference srSubmitRequest(){
    system.debug('test suajtha');
     sr1.Stage__c = 'Submitted'; 
     update sr1;
     system.debug('Update suajtha'+sr1.Stage__c);
     return null;
    }
    
}