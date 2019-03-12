@isTest
public  class SGR_BRVFalloutCaseForUW_Impl_Test{
	
 	@isTest static void testCreateCases(){
        try{
        List<Opportunity> opp = new List<Opportunity>();
        
        Opportunity opp1 = new Opportunity();
        
       opp1.StageName='Triggered';
        opp1.SGR_Workflow_Activity__c='UW Review - Validation Errors';
       opp1.CloseDate=date.today();
       opp1.Assigned_UW__c = Userinfo.getUserId();   
        opp1.Name='Test VSR 9/9/2020 Analytical';
        opp1.recordTypeId=SGR_BRVFalloutCaseForUW_Impl_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        //opp1.Assigned_UW__c='0054D000001FFfi';
        opp.add(opp1);
        insert opp;
        system.debug(opp);
       Business_Rule_Validation_Log__c br = new Business_Rule_Validation_Log__c();
        br.OpportunityId__c=opp1.id;
        br.Status__c='Failed';
        
        //br.SGR_caseId__c='';
        insert br;
            
            case c = new case();
            c.Opportunity_Name__c=opp1.id;
            c.OwnerId=opp1.Assigned_UW__c;
            insert c;
       SGR_BRValidationFalloutCaseForUW_Impl sr = new SGR_BRValidationFalloutCaseForUW_Impl();
        
       
           sr.createCases(opp);
           //sr.GetCaseDefaultsByOpportunity(opp1);
        }
        catch(Exception e){}
        
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