//*************************************************************************************
// Name             : SGR_GSPS_GetAvailablePlansForkedBatch.cls
// Description      : Batch class to invoke Callout for fetching All Available Plans GSPS Service
// Created By       : Tarun
// Created Date     : 20/11/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 20/11/2018       Tarun              SFDC-14003 Initial version
// 11/20/2018       Mei Chen           SFDC-14003 add to invoke getAllPlan service
// ************************************************************************************

public class SGR_GSPS_GetAvailablePlansForkedBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public Set<Id> productIDS = new Set<Id>();

    String stateCode;
    String fundingType = System.Label.SGR_GSPS_Funding_Type;
    String clientId = System.Label.SGR_GSPS_ClientId;
    String marketSegment = System.Label.SGR_GSPS_Market_Segment;
    Date renEffDate = System.today().addDays(Integer.valueOf(System.Label.SGR_GSPS_FIPS_AddDays));
    Boolean hasError = false;
    Integer attempt;

    public SGR_GSPS_GetAvailablePlansForkedBatch(Set<Id> productIDS) {
        this.productIDS = productIDS;
    }

    public SGR_GSPS_GetAvailablePlansForkedBatch(Date effDate, String state, Integer attempt, Boolean hasError) {
        if (effDate != null) {
            this.renEffDate = effDate;
        }
        this.stateCode = state;
        this.attempt = attempt;
        this.hasError = hasError;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'Select name, Fips_Code__c,HCSC_State__c,Product_Group_Code_List__c from Fips_Mapping_for_Plan_Batch__c where HCSC_State__c =\'' + stateCode + '\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<SObject> scope) {

        List<Fips_Mapping_for_Plan_Batch__c> fipsToRun = (List<Fips_Mapping_for_Plan_Batch__c>) scope;
        try {
            if (fipsToRun != null && !fipsToRun.isEmpty()) {
                for (Fips_Mapping_for_Plan_Batch__c fips : fipsToRun) {
                    SGR_GSPS_GetAvailablePlanServiceHelper.callGetAvailablePlansService(fips.Fips_Code__c, renEffDate, stateCode, marketSegment,
                            fundingType, clientId, 1);
                }
            }

        } catch (Exception e) {
            System.debug('Exception from Batch:' + e);
            hasError = true;
        }
    }

    public void finish(Database.BatchableContext BC) {
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
                SGR_GSPS_GetAvailablePlansForkedBatch batch = new SGR_GSPS_GetAvailablePlansForkedBatch (renEffDate, stateCode, attempt, hasError);
                Database.executeBatch(batch, 1);
            } else {
                emailMessage = 'Your batch job of Get SGR_GSPS_GetAvailablePlansForkedBatch for plan  ' + renEffDate + ' has finished for all states <br/>';
                System.debug(emailMessage);
            }
        } else if (hasError) {
            attempt++;
            if (attempt <= 4) {
                SGR_GSPS_GetAvailablePlansForkedBatch batch = new SGR_GSPS_GetAvailablePlansForkedBatch(renEffDate, stateCode, attempt, hasError);
                Database.executeBatch(batch, 1);
            } else {
                emailMessage = 'Your batch job SGR_GSPS_GetAvailablePlansForkedBatch has been stopped with error for ' + stateCode + ' state<br/>';
                System.debug(emailMessage);
            }
        }
    }
}