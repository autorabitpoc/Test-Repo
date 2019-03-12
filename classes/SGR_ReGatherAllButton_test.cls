@istest
public class SGR_ReGatherAllButton_test {

    static testmethod void RegatherAll() {
        try {
            Account newAccount1 = new Account(Name = 'Test Account', external_ID__c = 'AC12345', HCSC_Division__c = 'IL', Product_Type__c = 'HD', Renewal_Date__c = date.today(), status__c = 'Active', Market_Segment__c = 'SG', Funding_Type__c = 'PREM', ShippingPostalCode__c = '123456789', hold_end_date__c = Date.today() - 1, SGR_Hold_Reason__c = '1st Year Renewal');
            List<Account> accList = new List<Account>();
            accList.add(newAccount1);
            insert accList;
            List<Opportunity> opps = new List<Opportunity>();
            for (Integer j = 0; j < 1; j++) {

                opps.add(new Opportunity(Name = 'Test Opportunity' + j,
                        StageName = 'Prospecting', CloseDate = system.today(), Zip_Code__c = string.valueof(123.45),
                        AccountId = newAccount1.Id, recordTypeId = SGR_ReGatherAllButton_test.getOpptyRecordTypeIds('Opportunity', 'SGR Analytical Opportunity'), Assigned_UW__c = Userinfo.getUserId()));

            }
            insert opps;
            list<opportunity> Opplist = [select id from Opportunity];
            String OppId = Opplist[0].Id;
            Test.startTest();
            SGR_ReGatherAllButton.Regatherall(OppId);
            Test.stopTest();
        } Catch (Exception E) {
            System.debug('Error' + E);
        }
    }

    public Static String getOpptyRecordTypeIds(String ObjectName, String recTypeName) {
        Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobalDescribe() ;
        Schema.SObjectType SchemaObject = mapSchemaobject.get(ObjectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = SchemaObject.getDescribe() ;
        Map<String, Schema.RecordTypeInfo> RecordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        System.debug(':::RECTYPE:::' + recordTypeId);
        return recordTypeId;

    }

}