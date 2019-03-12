/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class GFRA_AdjustmentRequestWebServiceTEST {

   
   public static testMethod void TestCreateAdjustmentRequest(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='test123';
      reqDTO.accountNumber='IL123456';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
       
    }
    
    public static testMethod void TestCreateAdjustmentRequestMissingId(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID=null;
      reqDTO.accountNumber='IL123456';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
       
    }
    
    
    public static testMethod void TestCreateAdjustmentRequestMissingAcctForSingle(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='test123';
      reqDTO.accountNumber=null;
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
       
    }
    public static testMethod void TestCreateAdjustmentRequestMissingAmt(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='test123';
      reqDTO.accountNumber='IL123456';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=0.00;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
       
    }
     public static testMethod void TestCreateAdjustmentRequestMissingIndicator(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='test123';
      reqDTO.accountNumber='IL123456';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=190000.00;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator=null;
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
       
    }
    
    public static testMethod void TestCreateAdjustmentRequestMissingBAR(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='test123';
      reqDTO.accountNumber='IL123456';
      reqDTO.barsCustomerNumber=null;
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=500000.10;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
       
    }
    public static testMethod void TestCreateAdjustmentRequestMass(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='test123';
      reqDTO.accountNumber=null;
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='tester@noemail.com';
      reqDTO.adjustmentRequestTypeIndicator='Mass';
      reqDTO.adjustmentRequestLink='www.google.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
  
       
       Test.StopTest();
       
    }
    
      public static testMethod void TestUpdateAdjustmentRequest(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='NM23344';
      update testAcct;
      createGFRAServiceRequest('1232');
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='1232';
      reqDTO.accountNumber='NM23344';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='nomail@test.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.yahoo.com';//null;
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
      }
    
    
    public static testMethod void TestUpdateAdjustmentRequestMissingSR(){
      	
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='NM23344';
      update testAcct;
   //   createGFRAServiceRequest('1232');
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='1232';
      reqDTO.accountNumber='NM23344';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName='test tester';
      reqDTO.submitterEmail='nomail@test.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.yahoo.com';//null;
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
     }
      
     public static testMethod void TestUpdatePendingAdjustmentRequest(){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='NM23344';
      update testAcct;
      createPendingGFRAServiceRequest('2445');
      
      Test.StartTest();
      DTOGFRA_AdjustmentRequest reqDTO=new DTOGFRA_AdjustmentRequest();
      reqDTO.adjustmentRequestID='2445';
      reqDTO.accountNumber='NM23344';
      reqDTO.barsCustomerNumber='bar123';
      reqDTO.adjustmentType='external';
      reqDTO.adjustmentAmount=10000.09;
      reqDTO.adjustmentProcessedDate=system.today();
      reqDTO.adjustmentEntryDate=system.today();
      reqDTO.submitterName=null;///'test tester';
      reqDTO.submitterEmail='noemail@test.com';
      reqDTO.adjustmentRequestTypeIndicator='Single';
      reqDTO.adjustmentRequestLink='www.yahoo.com';
    	
      DTOGFRA_AdjustmentRequestRTResponse res=new DTOGFRA_AdjustmentRequestRTResponse();
      res=GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest(reqDTO);
     // Service_Request__c newSR=new Service_Request__c();
       
       Test.StopTest();
      }
    
    
    
     private static void createPendingGFRAServiceRequest(String reqId){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
        Service_Request__c newSR=new Service_Request__c();
    	newSR.RecordTypeId=Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
        newSR.Adjustment_Request_ID__c=reqId;
        newSR.Adjustment_Entry_Date__c=system.today();
        newSR.Adjustment_Process_Date__c=system.today();
        newSR.Adjustment_Request_Link__c=null;///'www.yahoo.com';
        newSR.Adjustment_Request_Type_Indicator__c='Mass';
        newSR.Adjustment_Type__c='Internal';
        newSR.BARS_Customer_Number__c='bar1234';
        newSR.Submitter_Email__c='noone@email.com';
        newSR.Submitter_Name__c='test tester1';
        newSR.status__c='In Pending';
        
        newSR.Account_Number__c=testAcct.External_ID__c;
        insert newSR;
    }
    
    private static void createGFRAServiceRequest(String reqId){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
        Service_Request__c newSR=new Service_Request__c();
    	newSR.RecordTypeId=Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
        newSR.Adjustment_Request_ID__c=reqId;
        newSR.Adjustment_Entry_Date__c=system.today();
        newSR.Adjustment_Process_Date__c=system.today();
        newSR.Adjustment_Request_Link__c=null;//'www.yahoo.com';
        newSR.Adjustment_Request_Type_Indicator__c='Mass';
        newSR.Adjustment_Type__c='Internal';
        newSR.BARS_Customer_Number__c='bar1234';
        newSR.Submitter_Email__c='noone@email.com';
        newSR.Submitter_Name__c='test tester1';
        newSR.status__c='New';
        newSR.Account_Number__c=testAcct.External_ID__c;
        insert newSR;
    }
    
    private static Service_Request__c createApprovedGFRAServiceRequest(String reqId){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
        Service_Request__c newSR=new Service_Request__c();
    	newSR.RecordTypeId=Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
        newSR.Adjustment_Request_ID__c=reqId;
        newSR.Adjustment_Entry_Date__c=system.today();
        newSR.Adjustment_Process_Date__c=system.today();
        newSR.Adjustment_Request_Link__c='www.yahoo.com';
        newSR.Adjustment_Request_Type_Indicator__c='Single';
        newSR.Adjustment_Type__c='Internal';
        newSR.BARS_Customer_Number__c='bar1234';
        newSR.Submitter_Email__c='noone@email.com';
        newSR.Submitter_Name__c='test tester1';
        newSR.status__c='Approved';
        
        newSR.Account_Number__c=testAcct.External_ID__c;
        insert newSR;
        return newSR;
    }
    
     private static Service_Request__c createRejectedGFRAServiceRequest(String reqId){
      Account testAcct=TestClassUtiltity.CreateAccountRecord('testAcct');
      testAcct.External_ID__c='IL123456';
      update testAcct;
      
        Service_Request__c newSR=new Service_Request__c();
    	newSR.RecordTypeId=Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('GFRA - Adjustment').getRecordTypeId();
        newSR.Adjustment_Request_ID__c=reqId;
        newSR.Adjustment_Entry_Date__c=system.today();
        newSR.Adjustment_Process_Date__c=system.today();
        newSR.Adjustment_Request_Link__c='www.yahoo.com';
        newSR.Adjustment_Request_Type_Indicator__c='Mass';
        newSR.Adjustment_Type__c='Internal';
        newSR.BARS_Customer_Number__c='bar1234';
        newSR.Submitter_Email__c='noone@email.com';
        newSR.Submitter_Name__c='test tester1';
        newSR.status__c='Rejected';
        
        newSR.Account_Number__c=testAcct.External_ID__c;
        insert newSR;
        return newSR;
    }
    
    public static testMethod void TestApprovedGFRA_MakeAdjusterWSCall() {
        // TO DO: implement unit test
        Service_Request__c approvedSR=createApprovedGFRAServiceRequest('1232');
        test.startTest();
        try{
         GFRA_AdjustmentRequestWebServiceHelper.GFRA_MakeAdjusterWSCall(approvedSR.id);
         }catch (Exception e){
          	approvedSR.Integration_Status__c='Sent Failed';
            approvedSR.Integration_Message__c='Callout Exception. Please contact System Administrator.' ;
    	    approvedSR.Integration_Error_Message__c=e.getMessage();
    	    approvedSR.Integration_Date_Time__c=system.now();
    	   update approvedSR;
        }
        test.stopTest();
    }
    public static testMethod void TestRejectedGFRA_MakeAdjusterWSCall() {
        // TO DO: implement unit test
        
        Service_Request__c rejectedSR=createRejectedGFRAServiceRequest('1233');
        test.startTest();
        try{
        GFRA_AdjustmentRequestWebServiceHelper.GFRA_MakeAdjusterWSCall(rejectedSR.id);
        
         }catch (Exception e){
          	rejectedSR.Integration_Status__c='Sent Failed';
            rejectedSR.Integration_Message__c='Callout Exception. Please contact System Administrator.' ;
    	    rejectedSR.Integration_Error_Message__c=e.getMessage();
    	    rejectedSR.Integration_Date_Time__c=system.now();
    	   update rejectedSR;
          }
        
        test.stopTest();
    }
    
      public static testMethod void TestRejectedGFRA_MakeAdjusterWSCall2() {
        // TO DO: implement unit test
        
        Service_Request__c rejectedSR=createRejectedGFRAServiceRequest('1233');
        rejectedSR.Rejection_Reason__c='testestetest';
        update rejectedSR;
        DTOStatus status=new DTOStatus();
        DTOGFRA_AdjustmentRequestRTResponse updateResp=new DTOGFRA_AdjustmentRequestRTResponse();
  	
        test.startTest();
        try{
        GFRA_AdjustmentRequestWebServiceHelper.GFRA_MakeAdjusterWSCall(rejectedSR.id);
        }catch (Exception e){
          	rejectedSR.Integration_Status__c='Sent Failed';
            rejectedSR.Integration_Message__c='Callout Exception. Please contact System Administrator.' ;
    	    rejectedSR.Integration_Error_Message__c=e.getMessage();
    	    rejectedSR.Integration_Date_Time__c=system.now();
    	   update rejectedSR;
        }
        test.stopTest();
    }
}