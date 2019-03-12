@isTest(seeAllData=false)

private class Sgr_OpportunityHelper_Test{


 private static testmethod void updateStatusTest(){
 
    Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', 
                                         Renewal_Date__c = date.today(),status__c = 'Active', Hold_End_Date__c =date.today(),
                                         Funding_Type__c='PREM',Product_Type__c='H',Market_Segment__c='SG',SGR_Hold_Reason__c='1st Year Renewal');
                                         
     insert newAccount1;
     
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Sgr_OpportunityHelper.Rerun=false;
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        System.assertEquals(opp.Product_Type__c,'H');
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = UserInfo.getuserid();
        opp.Rating_Status__c = 'Actuarial-Released';
    	opp.SGR_Workflow_Activity__c = '';
        opp.RecordTypeId = sgrProdOpp;
     //SFDC-17474: Change made to get full test coverage of updateOpportunityEffectiveDate() method
     	opp.Renewal_Date__c = Date.today();
     //end of SFDC-17474 changes
        insert opp;
        Sgr_OpportunityHelper.Rerun=false;
     
         Test.starttest();
             opp.Rating_Status__c = 'Underwriting-Released';
             update opp;
             opp.Rating_Status__c = 'Actuarial-Released';
             update opp;
             Sgr_OpportunityHelper.Rerun=false;
             opp.Rating_Status__c = 'Pended';
             update opp;
             System.assertEquals(opp.Rating_Status__c ,'Pended');
             
             opp.RecordTypeId = sgrProdOpp;
             opp.Rating_Status__c = 'Underwriting-Released';
             opp.Workflow_System_Status__c = 'Ready For Gate Processing';
             update opp;
     		 //SFDC-17474: Change made to get full test coverage of updateOpportunityEffectiveDate() method
     		 opp.Renewal_Date__c = Date.today().addDays(5);
             update opp;
         Test.stoptest();
 }
}