global class SGR_FutureTriggerClass
{
    public static void captureFuture(list<SGRRenewalBatch__c> allsetInsertedIds)
    {  
    set<String> newbatch = new set<String>();
    if(allsetInsertedIds!=null){
        for(SGRRenewalBatch__c batLST:allsetInsertedIds){
            if(batLST.BatchID__c!=null){
                newbatch.add(batLST.BatchID__c);
            }
        }
        
    }
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Id sgrAnalytOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
        List<opportunity> lstopp =  [SELECT Id, name, Batch_Id__c,Funding_Type__c,HCSC_Division__c,Renewal_Date__c,Date_to_Account__c,Date_to_GA__c,SGR_Opportunity_Type__c,Date_to_Producer__c,Batch_Type__c FROM opportunity where (RecordTypeId =:sgrProdOpp OR RecordTypeId=:sgrAnalytOpp) AND(Batch_Id__c IN:newbatch)];
        List<opportunity> OLST = new List<opportunity>();
        list<SGRRenewalBatch__c> sgrLST=[select id,BatchID__c,Date_to_GA__c,Date_to_Account__c,Date_to_Producer__c from SGRRenewalBatch__c where id IN:allsetInsertedIds];
        try {
            if(sgrLST!=null){
                for(SGRRenewalBatch__c opps:sgrLST){
                    System.debug('List of sgrrenewal batch');
                    system.debug(lstopp + 'hi');
                    if(lstopp!=null){   
                        for(opportunity sgr:lstopp){
                            System.debug('List of opps ');
                           /* if(sgr.SGR_Opportunity_Type__c=='Production'){
                                sgr.RecordTypeId=sgrProdOpp;
                            }
                            else{
                                sgr.RecordTypeId=sgrAnalytOpp;
                            }*/
                            if(sgr.Batch_Id__c==opps.BatchID__c ){
                                System.debug('adding dates');
                                sgr.Date_to_GA__c=opps.Date_to_GA__c;
                                sgr.Date_to_Account__c=opps.Date_to_Account__c;
                                sgr.Date_to_Producer__c=opps.Date_to_Producer__c;
                            }
                            OLST.add(sgr);
                        } 
                    }
                }
            }
            if(!OLST.isEmpty()){
                try{
                    update OLST;
                }catch(DmlException de ){
                    System.debug(de);
                }
            }
            
            
        } catch (Exception ex) {
            system.debug(ex);
        }
        
    }
    public static void opptyUpdate(list<Id> rectypid){
        Set<Id> new1 = new Set<Id>();
        try {
            List<case> cases1 =  [select id,Status,Reason,OpportunityId__c,Owner.Profile.Name  from case where id IN:rectypid];
            //List<opportunity> OLST = new List<opportunity>();
            if(cases1!=null){ 
                for(case Cases:cases1){
                    if ( Cases.Status =='Closed12' && (Cases.Reason =='BlueSTAR Eligibility Fallout' || Cases.Reason=='BlueSTAR Transfer Fallout') && Cases.Owner.Profile.Name =='SGR_Group Verifier') {
                        new1.add(Cases.OpportunityId__c);
                        
                    }    
                }
                
                
                List<opportunity> opps = [SELECT SGR_Workflow_Activity__c FROM opportunity WHERE Id IN: new1];
                if(opps!=null){
                    for (opportunity opps1: opps) {
                        opps1.SGR_Workflow_Activity__c = null; 
                    }
                    update opps;
                }
            }
        }
        catch(DmlException de ){
            System.debug(de);
        }
    }
}