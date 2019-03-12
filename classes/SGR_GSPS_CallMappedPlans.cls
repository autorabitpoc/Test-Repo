//16508 - Batch class to be called between the SGR_AccountRenewalBatch and SGR_validationCheckBatch. 
//This batch will call the BSPS service to receive the plan mapping information. The callout is made with one opportunity at a time.

global class SGR_GSPS_CallMappedPlans implements Database.Batchable
<sObject>, Database.stateful,Database.AllowsCallouts{
    String BatchId;
    
    global SGR_GSPS_CallMappedPlans(String BatchId){
        this.BatchId = BatchId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id,Renewal_Date__c,FIPS_Code__c,HCSC_Division__c,Funding_Type__c,Account_Market_Segment__c from Opportunity where Batch_Id__c = :BatchId');
    }
    
    global void execute(Database.BatchableContext bc, List
	<Opportunity> OppList){
        system.debug('Bharath we are inside execute method.');
        list<id> oppId = new list<id>();
        for(Opportunity opp1 : OppList){
            oppId.add(opp1.Id);
        }
        //Retrieve the Opportunity Plan rate information to be sent to the callout code. just dont have the context
        //urgent fixes offshore : added extra filter of type='Renewal' for the soql
        list<SGR_Opportunity_Plan_Rate__c> OppPlanRateList = [select id,Plan_Name__c,Marketing_Plan_ID__c,Plan_Status__c, Opportunity__c,Benefit_Agreement_Effective_Date__c from SGR_Opportunity_Plan_Rate__c where Opportunity__c in :oppId AND Type__c=:'Renewal' AND Plan_Status__c !='Cancelled' AND Benefit_Agreement_Effective_Date__c <> NULL order by Opportunity__c];
        system.debug('The size of plan rates list is ' + OppPlanRateList.size());
        //Opportunity group logic start - 
        //This branch of code will group the Opportunity Plan Rates into a map indexed by opportunity id. Each item in the map is a list of opportunity plan rate. 
        //This grouping is done since the callout code should be called for one opportunity at a time. 
        //This logic also helps with avoiding seperate query for each opportunity on the opportunity plan rate.
        List<SGR_Opportunity_Plan_Rate__c> TempOPRList = new List<SGR_Opportunity_Plan_Rate__c>();
        Id TempId;
        Map<Id,List<SGR_Opportunity_Plan_Rate__c>> OppPlanRateMap = new Map<Id,List<SGR_Opportunity_Plan_Rate__c>>();
        for(SGR_Opportunity_Plan_Rate__c SOPR : OppPlanRateList){
            system.debug('Bharath there are opportunity plan rates');
            if(TempId == null || TempId <> SOPR.Opportunity__c){
                if(TempId <> null){
                    OppPlanRateMap.put(TempId,TempOPRList);
                    system.debug('The id of first index is :' + TempId);
                }
                TempId = SOPR.Opportunity__c;
            }           
            TempOPRList.add(SOPR);
        }
        OppPlanRateMap.put(TempId,TempOPRList);
        system.debug('the id of last index is :' + TempId);
        //Opportunity group logic end.
        
        //Callout code to be called once per opportunity.
        for(Opportunity opp : OppList){
            if(OppPlanRateMap.containsKey(opp.id)){
              SGR_GSPS_GetMappedPlansServiceHandler.getMappedPlans(opp.FIPS_Code__c,'RENEWALS', opp.Renewal_Date__c, 
                                                                   opp.HCSC_Division__c, opp.Funding_Type__c, 
                                                                   opp.Account_Market_Segment__c, OppPlanRateMap.get(opp.id));
            }
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        SGR_validationCheckBatch svc = new SGR_validationCheckBatch(BatchId);
        ID batchId1 = Database.executeBatch(svc,50);
        
    }

}