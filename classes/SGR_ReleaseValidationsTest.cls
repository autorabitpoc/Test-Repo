@isTest
public class SGR_ReleaseValidationsTest {

     static testmethod  void testmethod1()
     {
         // Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
   // List<Account> accLst = new List<Account>(); 
    Account a = new Account();
    a.Status__c='Active';
    a.Name='santosh1';
    a.HCSC_Division__c='IL';
    a.Market_Segment__c='SG';
    a.Funding_Type__c='PREM';
    a.renewal_duration_is_infinite__c=false;
    a.Renewal_Date__c=date.today();
    a.hold_end_date__c=Date.today()+2;

     a.SGR_Hold_Reason__c='Block Acquisition';
        
         insert a;

    List<Opportunity> oppLst1 = new List<Opportunity>();  
    Opportunity opp= new Opportunity();
         opp.Account = a;
        opp.Name = 'Sample';
        opp.Renewal_Date__c=Date.today().adddays(-1);
         
         opp.SGR_Workflow_Activity__c='';
         opp.Workflow_System_Status__c='Awaiting Hold Task Completion';
        opp.StageName = 'lost';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Rating_Status__c='Rated';
        opp.Closed_Comments__c = 'XYZ';
       
       opp.Assigned_UW__c = Userinfo.getUserId();
         opp.RecordTypeId=SGR_ReleaseValidationsTest.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//'SGR Analytical Opportunity');
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
         
        oppLst1.add(opp);
         
         insert oppLst1;
         
         // List<Opportunity> oppLst = new List<Opportunity>{opp,opp1,opp2,opp3};
         
         Test.startTest();
         SGR_ReleaseValidations.initiateValidation(oppLst1);

          Test.stopTest();
     }

    static testmethod  void testmethod2()
     {
         // Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
   // List<Account> accLst = new List<Account>();   
    Account a = new Account();
    a.Status__c='Active';
    a.Name='santosh1';
    a.HCSC_Division__c='IL';
    a.Market_Segment__c='SG';
    a.Funding_Type__c='PREM';
    a.renewal_duration_is_infinite__c=false;
    a.Renewal_Date__c=date.today();
    a.hold_end_date__c=Date.today();

     a.SGR_Hold_Reason__c='Block Acquisition';
        
         insert a;

    List<Opportunity> oppLst1 = new List<Opportunity>();
    Opportunity opp= new Opportunity();
         opp.Account = a;
        opp.Name = 'Sample';
        opp.Renewal_Date__c=Date.today().adddays(2);
         
         opp.SGR_Workflow_Activity__c='';
         opp.Workflow_System_Status__c='Awaiting Hold Task Completion';
        opp.StageName = 'lost';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Rating_Status__c='Rated';
        opp.Closed_Comments__c = 'XYZ';
       
       opp.Assigned_UW__c = Userinfo.getUserId();
         opp.RecordTypeId=SGR_ReleaseValidationsTest.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');//'SGR Analytical Opportunity');
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
         
        oppLst1.add(opp);
         insert oppLst1;
         
         // List<Opportunity> oppLst = new List<Opportunity>{opp,opp1,opp2,opp3};
         
         Test.startTest();
         
         SGR_ReleaseValidations.initiateValidation(oppLst1);
         opportunity oppcheck = [select Rating_Status__c from opportunity where id = :oppLst1[0].id];
        system.assertEquals('Marketing Release', oppcheck.rating_status__c, '2Opportunity is not updated as Marketing Release after it is updated as Underwriting Released.');

          Test.stopTest();
     }
    
     
     public Static String getOpptyRecordTypeIds(String ObjectName,String recTypeName){
         Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobalDescribe() ;
        Schema.SObjectType SchemaObject = mapSchemaobject.get(ObjectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = SchemaObject.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        System.debug(':::RECTYPE:::'+recordTypeId);
        return recordTypeId;
       
    }
    
}