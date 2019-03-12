@isTest(SeeAllData=false)
private class BatchAddressCacheTest {

    public static testMethod void setUpBatchDeleteSearchFIPS() {
        
        SearchFIPS__c searchFIPSRecord;
        List<SearchFIPS__c> searchFIPSList = new List<SearchFIPS__c>();
          
        for(integer i=0;i<200;i++){
            searchFIPSRecord = new SearchFIPS__c();
            searchFIPSRecord.Name = String.valueOf(i);
            searchFIPSRecord.State__c = 'State' + String.valueOf(i);
            searchFIPSList.add(searchFIPSRecord);
        }
          
        if (searchFIPSList.size() > 0) {
        }
    }

    public static testmethod void BatchAddressCacheScheduleTest()  {       
        
            Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2022';

            String jobId = System.schedule('BatchAddressCacheScheduleTest', CRON_EXP, new BatchAddressCacheSchedule());

            Test.stopTest();
    }
    
    public static testMethod void BatchAddressCacheTest(){        
        User AUser = TestUtils.createTestUser('RunAsUser1', 'System Administrator');
        System.runAs(AUser){
            Test.startTest();
            Test.setMock(WebServiceMock.class, new BatchAddressCacheMock()); 
            BatchAddressCache batch = new BatchAddressCache('IL',0);
            BatchAddressCache.CountyDetails wrapper = new BatchAddressCache.CountyDetails('','','','','');
            database.executeBatch(batch);
            Test.stopTest();
        }
        
    }    
     
     public static testMethod void setUpBatchRatingSearchFIPS() {
         SearchFIPS__c searchFIPSRecord, searchFIPSRecord2;
         List<SearchFIPS__c> searchFIPSList = new List<SearchFIPS__c>();
          
         searchFIPSRecord = new SearchFIPS__c();
         searchFIPSRecord.Name = '0001';
         searchFIPSRecord.State__c = 'TX';
         searchFIPSList.add(searchFIPSRecord);
       
         searchFIPSRecord2 = new SearchFIPS__c();
         searchFIPSRecord2.Name = '0002';
         searchFIPSRecord2.State__c = 'IL';
         searchFIPSList.add(searchFIPSRecord2);
          
         if(searchFIPSList.size() > 0) {
             insert searchFIPSList;
         }
     }
}