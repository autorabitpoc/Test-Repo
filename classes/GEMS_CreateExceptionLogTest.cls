@isTest
public class GEMS_CreateExceptionLogTest {
    
     static testMethod void myUnitTest1() {
        List<Database.SaveResult> sr;
        List<Database.DeleteResult> dr;
        List<Database.UpsertResult> ur;
        list<case> LstCase;
        List<Attachment> insList;
        
        Id CBSR_IssueId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(system.label.CBSR_Issue).getRecordTypeId();
        
        Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
        LstCase = TestClassUtiltity.createCaseRecords(testAccount.id);
         LstCase[0].Recordtypeid = CBSR_IssueId;
         LstCase[0].External_id__C = '12345';
         Insert LstCase;
        try{
         
        test.StartTest();
           Blob b = Blob.valueOf('Test Data'); 
            Attachment attachment1 = new Attachment();  
        attachment1.ParentId = LstCase[0].id;  
        attachment1.Name = 'Test Attachment';  
        attachment1.Body = b;  
        //insert(attachment1); 
        insList = new List<Attachment>{attachment1};
        sr = Database.insert(insList);
        
        
         
        test.StopTest();
       }catch(Exception e){
         
         
         GEMS_CreateExceptionLog.insertErrorLog(e, null,null,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest' , 'High');
          GEMS_CreateExceptionLog.insertErrorLogWhileUpsert(null,null,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest ', 'high');
        // GEMS_CreateExceptionLog.insertErrorLog(e, null,dr,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest' , 'High');
        
          //System.Assert(e.getMessage().contains(system.label.MIME_type_not_allowed));
        //        throw e;
       }
       
        Blob b = Blob.valueOf('Test Data'); 
       Attachment attachment1 = new Attachment();  
        attachment1.ParentId = LstCase[0].id;    
        attachment1.Name = 'Test Attachment';  
        attachment1.Body = b;  
        //insert(attachment1); 
        insList = new List<Attachment>{attachment1};
        ur = Database.upsert(insList,false);
        GEMS_CreateExceptionLog.insertErrorLogWhileUpsert(null,ur,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest ', 'high');
       
        Attachment attachment4 = new Attachment();  
        attachment4.ParentId = LstCase[0].id;    
        attachment4.Name = 'Test Attachment';  
        attachment4.Body = b;  
        //insert(attachment1); 
        insList = new List<Attachment>{attachment4};
        ur = Database.upsert(insList,false);
        GEMS_CreateExceptionLog.insertErrorLogWhileUpsert(null,ur,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest ', 'high');
                
        Attachment attachment2 = new Attachment();  
        attachment2.ParentId = LstCase[0].id;    
        attachment2.Name = 'Test Attachment';  
        attachment2.Body = b;  
        //insert(attachment1); 
        insList = new List<Attachment>{attachment2};
        sr = Database.insert(insList ,false);        
        GEMS_CreateExceptionLog.insertErrorLog(null, sr,null,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest' , 'High'); 
         
        Attachment attachment3 = new Attachment();  
        attachment3.ParentId = testAccount.id;    
        attachment3.Name = 'Test Attachment';  
        attachment3.Body = b;  
        //insert(attachment3); 
        insList = new List<Attachment>{attachment3};
        sr = Database.insert(insList ,false); 
         dr = Database.Delete(insList ,false);
         GEMS_CreateExceptionLog.insertErrorLog(null, null,dr,insList,'GEMS_CreateExceptionLogTest ', 'Attachment','AttachmentTrigger','GEMS_CreateExceptionLogTest' , 'High');  
       List<Error_Log__c> errorLogs = [select Id from Error_Log__c];
       //system.assertEquals(errorLogs.size(),0);
        
        test.StopTest();
     }
}