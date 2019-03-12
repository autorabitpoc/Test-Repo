public without Sharing class SGR_BlueSTAROptysPost {
@AuraEnabled
    public static string updateBlueSTAROptys(String division, String marketSegment, String fundingType, String renewaldate, Datetime scheduleDate){
        String value = '';
        Boolean isSuccess = false;
        List<SGRRenewalBatch__c> batchList;
        try{
            system.debug('++++String renewaldate--'+renewaldate);
            Date renewEffDate = Date.valueOf(renewaldate);
            system.debug('++++Date renewEffDate--'+renewEffDate);
            Integer renMonth = renewEffDate.month();
            Integer renYear = renewEffDate.month();
            system.debug('++++renMonth--'+renMonth);
            Datetime scheduledDate = scheduleDate;
            system.debug('++++Schduled Date---'+ scheduledDate);
            Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
            List<String> optyIds = new List<string>();
            //SFDC-16647 Added SOQL Filter on Rating_Status__c=Marketing Released and Workflow_System_Status__c = 'Ready for BlueSTAR Initiation' - Padma
            List<Opportunity> optyList = [select id, Rating_Status__c, SGR_Workflow_Activity__c from Opportunity where HCSC_Division__c = :division 
                                            AND ForeCast_Segment__c='Small Group' 
                                            AND Renewal_Date__c >=:renewEffDate AND Renewal_Date__c <:renewEffDate.addMonths(1) 
                                            AND Funding_Type__c = :fundingType AND Rating_Status__c = 'Marketing Release' AND RecordTypeId = :sgrProdOpp
                                            AND Workflow_System_Status__c =:system.label.UCR_WorkFlow_System_Status_Updated_Value
                                          //'Ready for BlueSTAR Initiation'
                                          ];
            
            system.debug('++++optylist size--'+optyList.size());
            
            if(optyList.size() > 0){
                batchList = [select id from SGRRenewalBatch__c where Renewal_Effective_date__c = :renewEffDate AND 
                                                          Action_Type__c = 'BlueSTAR Transfer' AND Division__c = :division AND FundingType__c = :fundingType AND MarketSegment__c = :marketSegment];// AND Scheduled_Date__c = :scheduleDate];
                system.debug('++++batchList.size()---'+batchList.size());
                if(batchList.size()>0){
                        value = system.label.SGR_BlueStar_Duplicate;
                }
                else{
                    //SFDC-16647 Updated workflow system status update - Padma
                    for(Opportunity opty : optyList){
                        opty.Rating_Status__c = system.label.BlueStar_Rating_Status_Update_Sold;//'Sold';
                        opty.SGR_Workflow_Activity__c = 
                            system.label.BlueStar_Workflow_Activity_Status_Awaiting_BlueSTAR_Transfer;//'Awaiting BlueSTAR Transfer';
                        opty.Workflow_System_Status__c = system.label.BlueSTAR_System_Status_Ready_to_Send_to_BlueSTAR;//'Ready to Send to BlueSTAR';
                        optyIds.add(opty.Id);
                    }
                    update optyList;
                    //SFDC-16647 Updated workflow system status update - Padma 
                    system.debug('++++Opty updated');
                    List<SGR_Opportunity_Plan_Rate__c> optyPlanRate = [select Sold_Date__c, Plan_Status__c from SGR_Opportunity_Plan_Rate__c 
                                                                       where Opportunity__c IN : optyIds 
                                                                       AND Opportunity__r.Rating_status__c = :system.label.BlueStar_Rating_Status_Update_Sold
                                                                       AND Type__c='Renewal'];
                    system.debug('++++optyPlanRate size--'+optyPlanRate.size());
                    if(optyPlanRate.size() > 0){
                        for(SGR_Opportunity_Plan_Rate__c oppPlanRate : optyPlanRate){
                            if(oppPlanRate.Plan_Status__c == 'Renewing' || oppPlanRate.Plan_Status__c == 'Mapped'){
                                oppPlanRate.Plan_Status__c = 'Sold';
                            }
                        }
                        update optyPlanRate;
                    }
                    value = system.label.SGR_BlueStar_success_message;//'Opportunities batch scheduled successfully';
                    isSuccess = true;
                    system.debug('++++isSuccess--'+isSuccess);
                    if(isSuccess){
                            SGRRenewalBatch__c optyBatch = new SGRRenewalBatch__c();
                            String bid=String.valueOf(System.currentTimeMillis());
                            optyBatch.BatchID__c = bid;
                            optyBatch.BatchType__c  = 'Batch';
                            optyBatch.Division__c = division;
                            optyBatch.RenewalType__c = 'Production';
                            optyBatch.FundingType__c = fundingType;
                            optyBatch.MarketSegment__c = marketSegment;
                            optyBatch.Renewal_Effective_date__c = renewEffDate;
                            optyBatch.Action_Type__c = 'BlueSTAR Transfer';
                            optyBatch.Scheduled_Date__c = scheduleDate;
                            insert optyBatch; 
                        SGR_BSTAR_TransferSchedulerHelper sheduleClass = new SGR_BSTAR_TransferSchedulerHelper();
                        //sheduleClass.scheduleJobs(optyBatch.Id, division, fundingType, marketSegment, renMonth, renYear, scheduleDate);
                        sheduleClass.scheduleJobs(optyBatch.Id, division, fundingType, marketSegment, renewEffDate, scheduleDate);
                    }
                }
            }
            else
                value = system.label.SGR_BlueStar_Message;//'No Opportunities found';
            system.debug('++++value--'+value); 
        }
        catch(exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_BlueSTAROptysPost', null, 'SGR_BlueSTAROptysPost.updateBlueSTAROptys','Low');  
        }
        system.debug('++++value--'+value);
        return value;
    }
}