//*************************************************************************************
// Name             : SGR_GSPS_GetAvailablePlanServiceBatch.cls
// Description      : Batch class to invoke Callout for fetching Product Group from  GSPS Service
// Created By       : Tarun
// Created Date     : 06/11/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 06/11/2018       Tarun              SFDC-14003 Initial version
// 11/21/2018       Mei Chen           updated to remove the loop of state and fips code
// ************************************************************************************

global class SGR_GSPS_GetProductGroupBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
    Set<Id> productIDS = new Set<Id>();

    String stateCode;
    String fundingType = System.Label.SGR_GSPS_Funding_Type;
    String clientId = System.Label.SGR_GSPS_ClientId;
    String marketSegment = System.Label.SGR_GSPS_Market_Segment;
    Date renEffDate = System.today().addDays(Integer.valueOf(System.Label.SGR_GSPS_FIPS_AddDays));
    Boolean hasError = false;
    Integer attempt;

    public SGR_GSPS_GetProductGroupBatch(String state, Integer attempt, Boolean hasError) {
        this.stateCode = state;
        this.hasError = hasError;
        this.attempt = attempt;

    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String dummyQuery = 'select Id from Opportunity limit 1';
        return Database.getQueryLocator(dummyQuery);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {

        system.debug('number of search fipsList::' + scope);

        try {

            SGR_GSPS_GetProductGroups productDetails = new SGR_GSPS_GetProductGroups();

            system.debug(' State:' + stateCode);

            productDetails.callGSPSProductGroupService(clientId, 1, renEffDate, stateCode, marketSegment, fundingType);
        } catch (Exception e) {
            system.debug('Exception from Batch:' + e);
            hasError = true;
        }
    }

    global void finish(Database.BatchableContext BC) {
        String emailMessage = '';
        if (!hasError) {
            attempt = 0;
            // IL
            if (stateCode == 'IL') {
                stateCode = 'NM'; // NM
            }
            // NM
            else if (stateCode == 'NM') {
                stateCode = 'OK'; // OK
            }
            // OK
            else if (stateCode == 'OK') {
                stateCode = 'TX'; // TX

            }
            // TX
            else if (stateCode == 'TX') {
                stateCode = 'MT'; // MT 
            }
            // MT
            else if (stateCode == 'MT') {
                stateCode = null;
            }

            if (stateCode != null) {
                SGR_GSPS_GetProductGroupBatch batch = new SGR_GSPS_GetProductGroupBatch (stateCode, attempt, hasError);
                Database.executeBatch(batch, 1);
            } else {
                emailMessage = 'Your batch job of Get SGR_ProductGroupBatch for plan ' + renEffDate + ' has finished for all states <br/>';
                system.debug(emailMessage);
            }
        } else if (hasError) {
            attempt++;
            if (attempt <= 4) {
                SGR_GSPS_GetProductGroupBatch batch = new SGR_GSPS_GetProductGroupBatch(stateCode, attempt, hasError);
                Database.executeBatch(batch, 1);
            } else {
                emailMessage = 'Your batch job SGR_GSPS_GetAvailablePlanServiceBatch  has been stopped with error for ' + stateCode + ' state<br/>';
                system.debug(emailMessage);
            }
        }
    }
}