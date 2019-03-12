@isTest
private class GEMS_Items_To_Approve_Controller_Test{


    @testSetUp
    static void testDataSetup(){   
        Group g1 = new Group(Name='GEMS EEE Queue', type='Queue');
        insert g1;
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
        insert q1;
        
        Group g2 = new Group(Name='GEMS CDHP Operations Queue', type='Queue');
        insert g2;
        QueuesObject q2 = new QueueSObject(QueueID = g2.id, SobjectType = 'Case');
        insert q2;
    }
    
    static testmethod void ProcessInstanceRecords(){
        User usr=[select id from User where Id=:userInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            Id caseAccountSetUpId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
            Id caseAccountStructId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
             
            Account a = new Account(Name='SLALOM TEST ACCOUNT2', External_Id__c='AC102981',recordTypeId = accRecTypeId);
            insert a;
             
            Opportunity o = new Opportunity(Name='Test', RFI_RFP_Received_Date__c=System.Today(), AccountId=a.Id);
            o.StageName ='Expected In';
            o.probability = 50;
            o.Expected_RFP_Release_Date__c = System.Today();
            o.CloseDate=System.Today();
            o.HCSC_Division__c = 'TX';
            o.Region__c = 'N/A - IL';
            o.District__c = '290';
            o.Clusters__c = '020';
            o.Primary_Closed_Reason__c = 'Other';
            o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            insert o;
            
            Case cse1 = new Case();
            cse1.AccountID = a.Id;
            cse1.Opportunity_Name__c = o.id;
            cse1.recordTypeId = caseAccountSetUpId;
            cse1.status = 'BW Approval Pending';
            cse1.GEMS_BlueSTAR_Walkthrough_Resource_1__c = UserInfo.getUserId();
            cse1.ownerId = UserInfo.getUserId();
            insert cse1;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(cse1.Id);
            
            Approval.ProcessResult result1 = Approval.process(req1);
            
            Case cse2 = new Case();
            cse2.AccountID = a.Id;
            cse2.Opportunity_Name__c = o.id;
            cse2.recordTypeId = caseAccountStructId;
            cse2.status ='Internal Approval Pending';
            cse2.ownerId = UserInfo.getUserId();
            insert cse2;
            Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
            req2.setComments('Submitting request for approval.');
            req2.setObjectId(cse2.Id);
            
            Approval.ProcessResult result2 = Approval.process(req2);
            
            PageReference pageRef = Page.GEMS_Items_To_Approve;
            Test.setCurrentPage(pageRef);       
            GEMS_Items_To_Approve_Controller con = new GEMS_Items_To_Approve_Controller();    
            Test.stopTest();
        }
    }
    
}