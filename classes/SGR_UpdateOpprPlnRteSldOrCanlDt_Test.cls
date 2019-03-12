@isTest
public class SGR_UpdateOpprPlnRteSldOrCanlDt_Test {

    public testmethod static void updateSoldOrCancelDateTest(){
        
        list<SGR_Opportunity_Group_Section__c>  OppGSold = new list<SGR_Opportunity_Group_Section__c>();
        list<SGR_Opportunity_Group_Section__c>  OppGSnew = new list<SGR_Opportunity_Group_Section__c>();
        Test.startTest();
           SGR_Opportunity_Group_Section__c OppGS= new SGR_Opportunity_Group_Section__c();
        	OppGS.Name='GS1';
        	OppGS.Benefit_Agreement_Cancel_Date__c= System.today();
            OppGS.BEN_AGMT_renewal_date__c=system.today();
            OppGSold.add(OppGS);
        	insert OppGS;
        	
        	SGR_Opportunity_Plan_Rate__c OppPlan= new SGR_Opportunity_Plan_Rate__c();
        	OppPlan.name='OppPlan';
        	OppPlan.Group_Section__c=OppGS.Id;        	
        	Insert OppPlan;
        
        	OppGS.Benefit_Agreement_Cancel_Date__c= System.today()+1;
        	OppGS.BEN_AGMT_renewal_date__c=system.today()+1;
        	OppGSnew.add(OppGS);
        	update OppGS;
        	
        	list<SGR_Opportunity_Plan_Rate__c> OppPlanCheck=[SELECT id, Name, Canceled_Date_Copy__c, Sold_Date_Copy__c,Group_Section__c FROM SGR_Opportunity_Plan_Rate__c WHERE Group_Section__c=:OppGS.Id];
        	System.assertEquals(OppPlanCheck[0].Canceled_Date_Copy__c, system.today()+1);
        	update OppPlan;
        	
      		Delete OppGS;
        	Delete OppPlan;
        	
          	Test.stopTest();
    }
}