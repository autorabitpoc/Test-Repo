@isTest
public class SGR_BAP_GetProducerDataHelperTest {
    
    @isTest
  static void testProducerNumberNotNull(){
        
    SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
    SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
    req.producerNumber= '35435';
        req.pageSize = 10;
        req.pageNumber =1;
        req.producerName='xyz';
        req.effectiveDate='2019-01-01';
        req.accountNumber='35435345';
        req.accountName='grpxyz';
    String myJSON = JSON.serialize(req);

        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
        Id RecordTypeIdGrpAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account acc = new Account(name='xyz',recordtypeid=RecordTypeIdAccount,Type='Producer',External_ID__c='35435');
        insert acc;
            
        Account grpacct = new Account(name='grpxyz',recordtypeid=RecordTypeIdGrpAccount,External_ID__c='35435345');
        insert grpacct;
        
        Producer_Group_Association__c grpAcc = new Producer_Group_Association__c(Group_Account__c =grpacct.id,Producer_Account__c=acc.id,Effective_Date__c = Date.valueOf('2019-01-01'));
        insert grpAcc;
        
        Opportunity oppr = new Opportunity(Name='Oppr1',Renewal_Date__c=system.today(),AccountId=grpacct.id);
        RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
        request.httpMethod = 'POST';
    request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        res.pageNumber=0;
        res.pageSize=1;
        RestResponse response = new RestResponse();
        response.responseBody = Blob.valueOf(String.valueof(res));
        RestContext.response = response;
    SGR_BAP_GetProducerData.getProducerData();
    System.assertNotEquals(RestContext.response,null);
    
    
  }
  @isTest
  static void testProducerGrpAccNull(){
        
    SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
    SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
    req.producerNumber= '35435';
        req.pageSize = 10;
        req.pageNumber =1;
        req.producerName='xyz';
        req.effectiveDate='2018-01-01';
        req.accountNumber='35435345';
        req.accountName='grpxyz';
    String myJSON = JSON.serialize(req);

        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
        Id RecordTypeIdGrpAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account acc = new Account(name='xyz',recordtypeid=RecordTypeIdAccount,Type='Producer',External_ID__c='35435');
        insert acc;
            
        Account grpacct = new Account(name='grpxyz',recordtypeid=RecordTypeIdGrpAccount,External_ID__c='35435345');
        insert grpacct;
        
        Producer_Group_Association__c grpAcc = new Producer_Group_Association__c(Group_Account__c =grpacct.id,Producer_Account__c=acc.id,Effective_Date__c = Date.valueOf('2019-01-01'));
        insert grpAcc;
        
        Opportunity oppr = new Opportunity(Name='Oppr1',Renewal_Date__c=system.today(),AccountId=grpacct.id);
        RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
        request.httpMethod = 'POST';
    request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        res.pageNumber=0;
        res.pageSize=1;
        RestResponse response = new RestResponse();
        response.responseBody = Blob.valueOf(String.valueof(res));
        RestContext.response = response;
    SGR_BAP_GetProducerData.getProducerData();
    System.assertNotEquals(RestContext.response,null);
    
    
  }    
     @isTest
  static void testProducerAccNull(){
        
    SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
    SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
    req.producerNumber= '45346456';
        req.pageSize = 10;
        req.pageNumber =1;
    String myJSON = JSON.serialize(req);
    
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
        Id RecordTypeIdGrpAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account acc = new Account(name='xyz',recordtypeid=RecordTypeIdAccount,Type='Sub Producer',External_ID__c='35435');
        insert acc;
        
        Account grpacct = new Account(name='grpxyz',recordtypeid=RecordTypeIdGrpAccount,External_ID__c='35435345');
        insert grpacct;
        
        Producer_Group_Association__c grpAcc = new Producer_Group_Association__c(Group_Account__c =grpacct.id,Producer_Account__c=acc.id,Effective_Date__c = system.today().addDays(-2));
        insert grpAcc;
        
        Opportunity oppr = new Opportunity(Name='Oppr1',Renewal_Date__c=system.today(),AccountId=acc.id);
        RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
        request.httpMethod = 'POST';
    request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        res.pageNumber=0;
        res.pageSize=1;
        RestResponse response = new RestResponse();
        response.responseBody = Blob.valueOf(String.valueof(res));
        RestContext.response = response;
    SGR_BAP_GetProducerData.getProducerData();
    System.assertNotEquals(RestContext.response,null);
    
    
  }
    
     @isTest
  static void testProducerNumberNull(){
        
    SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
    SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
    req.producerNumber= '';
        req.pageSize = 10;
        req.pageNumber =1;
    String myJSON = JSON.serialize(req);
    
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
        Id RecordTypeIdGrpAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account acc = new Account(name='xyz',recordtypeid=RecordTypeIdAccount,Type='Producer',External_ID__c='456456');
        insert acc;
        
        Account grpacct = new Account(name='grpxyz',recordtypeid=RecordTypeIdGrpAccount,External_ID__c='35435345');
        insert grpacct;
        
        Producer_Group_Association__c grpAcc = new Producer_Group_Association__c(Group_Account__c =grpacct.id,Producer_Account__c=acc.id,Effective_Date__c = system.today().addDays(-2));
        insert grpAcc;
        
        Opportunity oppr = new Opportunity(Name='Oppr1',Renewal_Date__c=system.today(),AccountId=acc.id);
        RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
        request.httpMethod = 'POST';
    request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        res.pageNumber=0;
        res.pageSize=1;
        RestResponse response = new RestResponse();
        response.responseBody = Blob.valueOf(String.valueof(res));
        RestContext.response = response;
    SGR_BAP_GetProducerData.getProducerData();
    System.assertNotEquals(RestContext.response,null);
    
    
  }
    
     @isTest
  static void testGroupAccNull(){
        
    SGR_BAP_GetProducerDataRequest req = new SGR_BAP_GetProducerDataRequest();
    SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
    req.producerNumber= '35435';
        req.pageSize = 10;
        req.pageNumber =1;
    String myJSON = JSON.serialize(req);
    
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
        Id RecordTypeIdGrpAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account acc = new Account(name='xyz',recordtypeid=RecordTypeIdAccount,Type='Producer',External_ID__c='456456');
        insert acc;
        
        Account acc2 = new Account(name='xyz',recordtypeid=RecordTypeIdAccount,Type='Sub Producer',External_ID__c='4575676');
        insert acc2;
        
        Account grpacct = new Account(name='grpxyz',recordtypeid=RecordTypeIdGrpAccount,External_ID__c='35435345');
        insert grpacct;
        
        Producer_Group_Association__c grpAcc = new Producer_Group_Association__c(Group_Account__c =grpacct.id,  Effective_Date__c=system.today(),Producer_Account__c=acc2.id);
        insert grpAcc;
        
        Opportunity oppr = new Opportunity(Name='Oppr1',Renewal_Date__c=system.today(),AccountId=acc.id);
        RestRequest request = new RestRequest();
        request.requestUri =URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/BAP_GetProducerData';
        request.httpMethod = 'POST';
    request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        res.pageNumber=0;
        res.pageSize=1;
        RestResponse response = new RestResponse();
        response.responseBody = Blob.valueOf(String.valueof(res));
        RestContext.response = response;
    SGR_BAP_GetProducerData.getProducerData();
    System.assertNotEquals(RestContext.response,null);
    
    
  }


}