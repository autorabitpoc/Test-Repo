@isTest
public class ServiceRequestTriggerTest {
    
    /* Service Requests that are Rejected */
    private static testmethod void testRejection()
    {
              
        /* Create the Custom Setting */
        ServiceRequestTriggerRecordTypes__c ACustomSetting = new ServiceRequestTriggerRecordTypes__c();
        
        ACustomSetting.Name = 'GFRA - Adjustment';
        ACustomSetting.Record_Type_Name__c = 'GFRA - Adjustment';
        
        insert ACustomSetting;        
        
        // Create a sample Service Request object and then submit it for approval.
        Service_Request__c testSR = new Service_Request__c();
        
        Id GFRARecordTypeId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
        
        testSR.Adjustment_Type__c = 'T' + String.valueOf(DateTime.now());
        testSR.Adjustment_Request_ID__c = '123456';
        testSR.Adjustment_Amount__c = 1.00;
        testSR.Adjustment_Process_Date__c = Date.today() + 7;
        testSR.RecordTypeId = GFRARecordTypeId;
        testSR.Status__c = 'New';
        testSR.Stage__c = 'New';
        testSR.Adjustment_Request_Type_Indicator__c = 'Single';

        insert testSR;
        
        System.debug('testSR.Id: ' + testSR.Id);
        
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setComments('Submitting for Approval');
        testReq.setObjectId(testSR.Id);
        
        Approval.ProcessResult reqResult = Approval.process(testReq);
        
        System.assert(reqResult.isSuccess(),'Unable to submit new invoice statement record for approval');       
 
        List<Id> newWorkItemIds = reqResult.getNewWorkitemIds();
        //Id testWorkItemId = reqResult.getNewWorkitemIds()[0];        
        
        // Reject the submitted request, providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejecting request with a comment.');
        testRej.setAction  ('Reject');
        testRej.setWorkitemId(newWorkItemIds.get(0));
        
        Test.startTest();        
        // Process the rejection
        Approval.ProcessResult testRejResult =  Approval.process(testRej);
        Test.stopTest();
        
        // Verify the rejection results
        System.assert(testRejResult.isSuccess(), 'Rejections that include comments should be permitted');
        System.assertEquals('Rejected', testRejResult.getInstanceStatus(), 
                            'Rejections that include comments should be successful and instance status should be Rejected');
        
        List<Service_Request__c> AfterUpdateVerify = [SELECT Id, Rejection_Reason__c 
                                                     FROM Service_Request__c
                                                     WHERE Id = :testSR.Id LIMIT 1];
        
        System.debug('AfterUpdateVerify[0].Rejection_Reason__c' + AfterUpdateVerify[0].Rejection_Reason__c);
        
        /* Final Comment on Approval Process carried up to Service Request */
        /* System.assertEquals(AfterUpdateVerify[0].Rejection_Reason__c,'Rejecting request with a comment.');*/
        
    }    
   
    private static testMethod void testUpdateRejectPending(){
    	Service_Request__c sr=new Service_Request__c();
    	sr.recordTypeId= Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
    	sr.Adjustment_Entry_Date__c=system.today();
    	sr.Adjustment_Process_Date__c=system.today();
    	sr.Adjustment_Request_Link__c='www.yahoo.com';
    	sr.Adjustment_Request_ID__c='12345';
        sr.Adjustment_Type__c='test';
        sr.BARS_Customer_Number__c='test2345';
        sr.Rejection_Reason__c=null;
        sr.Final_Approver_Name__c='test tester';
        sr.Adjustment_Amount__c=100000.00;
        sr.status__c='New';
        insert sr;
        
        Test.startTest();
        
        
        Service_Request__c oldSR=[select id, Adjustment_Request_ID__c,status__c, rejection_Reason__c from Service_Request__c where Adjustment_Request_ID__c='12345'];
        oldsr.Status__c='Rejected';
        oldsr.Rejection_Reason__c=null;
        update oldsr;
        
        Service_Request__c nwSR=[select id, Adjustment_Request_ID__c,status__c, rejection_Reason__c from Service_Request__c where Adjustment_Request_ID__c='12345'];
     
        nwsr.status__c='Pending for Rejection';
        nwsr.Rejection_Reason__c='test for rejection';
        update nwsr;
        
        Test.stopTest();
        
      	
    }
    
       private static testMethod void testCallSentOut(){
    	Service_Request__c sr=new Service_Request__c();
    	sr.recordTypeId= Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
    	sr.Adjustment_Entry_Date__c=system.today();
    	sr.Adjustment_Process_Date__c=system.today();
    	sr.Adjustment_Request_Link__c='www.yahoo.com';
    	sr.Adjustment_Request_ID__c='12345';
        sr.Adjustment_Type__c='test';
        sr.BARS_Customer_Number__c='test2345';
        sr.Rejection_Reason__c=null;
     //   sr.Final_Approver_Name__c='test tester';
        sr.Adjustment_Amount__c=100000.00;
        sr.status__c='New';
        insert sr;
        
        Test.startTest();
        
        
        Service_Request__c oldSR=[select id, Adjustment_Request_ID__c,status__c, rejection_Reason__c from Service_Request__c where Adjustment_Request_ID__c='12345'];
        oldsr.Status__c='Approved';
        oldsr.Final_Approver_Name__c='test tester';
        oldsr.Rejection_Reason__c=null;
        update oldsr;
        
       
        Test.stopTest();
        
      	
    }
    
}