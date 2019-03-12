@isTest

public class BatchDetaiWrapper_test {
   
  
    static  testmethod void testmethod1()
    {
        String batchId='12345';
        Integer count=124;
        String succMsg='Hello world'; 
        
        Test.startTest();
         BatchDetailWrapper BDW=new BatchDetailWrapper(batchId,count,succMsg);
        
        Test.stopTest();
        
    }
    

}