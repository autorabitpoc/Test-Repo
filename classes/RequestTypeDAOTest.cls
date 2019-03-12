@isTest
private class RequestTypeDAOTest {

    @isTest static void testUpsertAndDelRequestType() {
        Test.startTest();
        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;
        Request_Type__c requestType = new Request_Type__c();
        requestType.Case__c = case1.id;
        RequestTypeDAO rtDao = new RequestTypeDAO();
        List<Request_Type__c> rtList = new List<Request_Type__c>();

        rtList.add(requestType);

        rtDao.upsertRequestType(rtList);


        List<Request_Type__c> soqlList = rtDao.getRequestTypes(case1.id);

        system.assertEquals(rtList.size(), soqlList.size());

       List<PROPOSAL_NI_TYPE__mdt> soqlLists = rtDao.getRequestType(case1.id);

        
        rtList.remove(0);
        rtDao.deleteRequestType(soqlList);
        soqlList = [SELECT Case__c FROM Request_Type__c WHERE case__c = : case1.id ];


        System.assertEquals(soqlList, rtList);

        Test.stopTest();
    }



}