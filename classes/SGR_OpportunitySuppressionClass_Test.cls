@isTest
public class SGR_OpportunitySuppressionClass_Test {
   //Static Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
     @isTest 
    static void OpportunitySuppression(){
        
        
        String updatePlanChange = 'Yes';
        String ratingStatus = 'sold';
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='LG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.SGR_Hold_Reason__c = 'Miscellaneous';
        a.renewal_duration_is_infinite__c = True;
        a.SGR_Other_Hold_Reasons__c = 'Saurav';
        insert a;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.AccountId = a.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Rating_Status__c = 'Sold';
        opp.Plan_Change_Needed__c = 'Yes';
        opp.SGR_Workflow_Activity__c = 'Plan Change in Progress';
        opp.RecordTypeId = sgrProdOpp;
        
        oplist.add(opp);      
        
        
        insert oplist;
        opportunity oppr = [select id,SGR_Workflow_Activity__c from opportunity where id =:oplist[0].id ];
        //System.AssertEquals(oppr.SGR_Workflow_Activity__c,'Plan Change in Progress');
        id ide = oplist[0].id;
        
        SGR_OpportunitySuppressionClass.getOpportunityData(ide);
        SGR_OpportunitySuppressionClass.updateOpportunityData(ide, updatePlanChange, ratingStatus);
        
             
        
    }
    @isTest 
    static void OpportunitySuppressionStatusChange(){
        
        
        String updatePlanChange = 'Complete';
        String ratingStatus = 'Finalized';
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='LG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.SGR_Hold_Reason__c = 'Miscellaneous';
        a.renewal_duration_is_infinite__c = True;
        a.SGR_Other_Hold_Reasons__c = 'Saurav';
        insert a;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.AccountId = a.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Rating_Status__c = 'Finalized';
        opp.Plan_Change_Needed__c = 'Complete';
        opp.SGR_Workflow_Activity__c = 'Plan Change in Progress';
        opp.RecordTypeId = sgrProdOpp;
        oplist.add(opp);      
        
        
        insert oplist;
        id ide = oplist[0].id;
        
        SGR_OpportunitySuppressionClass.getOpportunityData(ide);
        SGR_OpportunitySuppressionClass.updateOpportunityData(ide, updatePlanChange, ratingStatus);
        
             
        
    }

    	 @isTest 
    static void OpportunitySuppressionStatusChange1(){
        
        
        String updatePlanChange = 'Complete';
        String ratingStatus = 'Sold';
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='LG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.SGR_Hold_Reason__c = 'Miscellaneous';
        a.renewal_duration_is_infinite__c = True;
        a.SGR_Other_Hold_Reasons__c = 'Saurav';
        insert a;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.AccountId = a.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Rating_Status__c = 'Sold';
        opp.Plan_Change_Needed__c = 'Complete';
        opp.SGR_Workflow_Activity__c = 'Plan Change in Progress';
        opp.RecordTypeId = sgrProdOpp;
        oplist.add(opp);      
        
        
        insert oplist;
        id ide = oplist[0].id;
        
        SGR_OpportunitySuppressionClass.getOpportunityData(ide);
        SGR_OpportunitySuppressionClass.updateOpportunityData(ide, updatePlanChange, ratingStatus);
        
             
        
    }
    
      	 @isTest 
    static void OpportunitySuppressionStatusChange2(){
        
        
        String updatePlanChange = 'Complete';
        String ratingStatus = 'Sold';
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='LG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.SGR_Hold_Reason__c = 'Miscellaneous';
        a.renewal_duration_is_infinite__c = True;
        a.SGR_Other_Hold_Reasons__c = 'Saurav';
        insert a;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
       	List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.AccountId = a.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Rating_Status__c = 'Finalized';
        opp.Plan_Change_Needed__c = 'Complete';
        opp.SGR_Workflow_Activity__c = 'Plan Change Progress';
        opp.RecordTypeId = sgrProdOpp;
        oplist.add(opp);      
        
        
        insert oplist;
        id ide = oplist[0].id;
        
        SGR_OpportunitySuppressionClass.getOpportunityData(ide);
        SGR_OpportunitySuppressionClass.updateOpportunityData(ide, updatePlanChange, ratingStatus);
        
             
        
    }

      	 @isTest 
    static void OpportunitySuppressionStatusChange3(){
        
        
        String updatePlanChange = 'Complete';
        String ratingStatus = 'Marketing Release';
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='LG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.SGR_Hold_Reason__c = 'Miscellaneous';
        a.renewal_duration_is_infinite__c = True;
        a.SGR_Other_Hold_Reasons__c = 'Saurav';
        insert a;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
       	List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.AccountId = a.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Rating_Status__c = 'Marketing Release';
        opp.Plan_Change_Needed__c = 'Complete';
        opp.SGR_Workflow_Activity__c = 'Plan Change Progress';
        opp.RecordTypeId = sgrProdOpp;
        oplist.add(opp);      
        
        
        insert oplist;
        id ide = oplist[0].id;
        
        SGR_OpportunitySuppressionClass.getOpportunityData(ide);
        SGR_OpportunitySuppressionClass.updateOpportunityData(ide, updatePlanChange, ratingStatus);
        
             
        
    }
}