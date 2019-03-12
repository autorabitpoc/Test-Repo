//*************************************************************************************
// Name             : SGR_GSPS_GetMappedPlansServiceHandler
// Description      : Output Class for Get All Mapped Plans GSPS Service
// Created By       : Padma Bedampeta
// Created Date     : 10/29/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 10/31/2018       Padma Bedampeta     Initial Draft to hold request for GSPS Mapped Plans
// 11/08/2018       Mei Chen			Updated Request DAO
// 11/10/2018		Luke Chen			SFDC-14006, update getMappedPlans method
// ************************************************************************************
global class SGR_GSPS_GetMappedPlansServiceHandler {
    private final static String SGR_PlanMapping_CallOut_Name = 'GSPS_PlanMappingCallOut';

    public static void getMappedPlans(String fipsCode, String clientId, Date effectiveDate, String division, String fundingType, String marketSegment, List<SGR_Opportunity_Plan_Rate__c> plans) {
        system.debug('calling get plan mapping service.....');
        String result = 'Success';
        SGR_GSPS_GetMappedPlansRequestDAO reqDAO = new SGR_GSPS_GetMappedPlansRequestDAO ();
        reqDAO.clientId = clientId;
        reqDAO.effectiveDate = effectiveDate;
        reqDAO.division = division;
        reqDAO.marketSegment = marketSegment;
        reqDAO.fundingType = fundingType;
        if (plans != null && !plans.isEmpty()) {
            reqDAO.opprId = plans[0].Opportunity__c;
            for (SGR_Opportunity_Plan_Rate__c plan : plans) {
                SGR_GSPS_GetMappedPlansRequestDAO dao = new SGR_GSPS_GetMappedPlansRequestDAO();
                SGR_GSPS_GetMappedPlansPlanWrapperDAO planData = new SGR_GSPS_GetMappedPlansPlanWrapperDAO ();
                if (plan.Marketing_Plan_ID__c != null && plan.Benefit_Agreement_Effective_Date__c != null) {
                    planData = new SGR_GSPS_GetMappedPlansPlanWrapperDAO();
                    planData.planName = plan.Marketing_Plan_ID__c;
                    planData.benefitEffectiveDate = plan.Benefit_Agreement_Effective_Date__c;
                    reqDAO.plans.add(planData);
                } else {
                    system.debug('this plan is not sent for getMappedPlan:(check if missing marketing plan Id or benefit effective date) ' + plan);
                }
            }
        }

        try {
            APICallOutRestWSUtility objUtility = new APICallOutRestWSUtility(SGR_PlanMapping_CallOut_Name);

            if (reqDAO != null && reqDAO.plans != null && !reqDAO.plans.isEmpty()) {

                SGR_GSPS_GetAvailablePlanServiceResponse resp = objUtility.invokePlanMappingService(reqDAO);
                system.debug('plan mapping response:::' + resp);
                if (resp.planGroups == null || resp.planGroups.isEmpty()) {
                    system.debug('no matched plans! No plans updated!');
                    return;
                }

                if (resp != null) {//there is only plan
                    Map<String, Product2> allProdMap = new Map<String, Product2>();
                    Map<String, Plan__c>allPlanMap = new Map<String, Plan__c>();
                    List<Product2> allProdList = new List<Product2>();
                    List<Plan__c> allPlansList = new List<Plan__c>();

                    SGR_GSPS_GetAvailablePlanUpdateData allPlanData = SGR_GSPS_GetAvailablePlanServiceHelper.processAllPlanResponseData(resp, null, fipsCode, division, marketSegment, fundingType, effectiveDate);
                    system.debug('get all plan data from mapped service-->' + allPlanData);
                    if (allPlanData != null) {

                        for (Product2 prod : allPlanData.allProductList) {
                            system.debug('prod Id--->' + prod.Id + ' external id: ' + prod.External_ID__c);
                            allProdMap.put(prod.External_ID__c, prod);// external Id is: name+state; use map to remember whole List of prods for insert plan
                        }

                        if (allProdMap != null && !allProdMap.isEmpty()) {
                            allProdList = allProdMap.values();
                        }

                        for (Plan__c plan : allPlanData.allPlanList) {
                            allPlanMap.put(plan.Marketing_Plan_Number__c, plan);// external Id is: name+state; use map to remember whole List of prods for insert plan
                        }

                        if (allPlanMap != null && !allPlanMap.isEmpty()) {
                            allPlansList = allPlanMap.values();
                        }

                        result = SGR_GSPS_GetAvailablePlanServiceHelper.savePlanData(allProdList, allPlansList, allPlanData.allBenefitHeaderDetailList,
                                allPlanData.allBenefitHeaderList, allPlanData.allNoteList,
                                allPlanData.allNoteDetailList, allPlanData.allPlanNoteAssignList,
                                allPlanData.allBHDAssignList, allPlanData.allBenefitHeaderAssoList,
                                allPlanData.allProductNoteDetailAssoList, allPlanData.allPlanFipsList);

                        updateOpprPlanRateWithMappedPlans(plans);
                    }
                }
            } else {

                system.debug('No Plan from request. GetMapping Service will not be invoked::' + reqDAO);
            }  //   

            if (objUtility != null && objUtility.newAccessToken != null) {
                objUtility.oAuthUtil.updateToken(objUtility.newAccessToken);
            }

        } catch (Exception e) {
            system.debug('exception from mappedplan:' + e.getLineNumber() + '--->' + e);
            result = 'failed';
        }

    }
    /* @Akbar - US15488
* this is method to update the Opportunity Plan Rate object with mapped plan from getMappedPlan services
*/
    @TestVisible
    private static void updateOpprPlanRateWithMappedPlans(List<SGR_Opportunity_Plan_Rate__c> opprPlanRateList) {
        List<SGR_Opportunity_Plan_Rate__c> opprPlanRates = new List<SGR_Opportunity_Plan_Rate__c>();
        List<SGR_Opportunity_Plan_Rate__c> updateOpprPlanRates = new List<SGR_Opportunity_Plan_Rate__c>();
        List<Plan__c> plansList = new List<Plan__c>();
        Map<String, Plan__c> planMap = new Map<String, Plan__c>();
        Set<String> planIdSet = new Set<String>();
        for (SGR_Opportunity_Plan_Rate__c plan : opprPlanRateList) {
            planIdSet.add(plan.Marketing_Plan_ID__c);
        }
        System.debug('planIdSet' + planIdSet);
        opprPlanRates = [
                SELECT Id,Marketing_Plan_ID__c,Sales_Plan_ID__c,Plan__c,Mapping_From_Plan_Id__c,Plan_Name__c,
                        Plan_Status__c
                FROM SGR_Opportunity_Plan_Rate__c
                WHERE Marketing_Plan_ID__c IN :planIdSet
        ];
        System.debug('opprPlanRates--->' + opprPlanRates);
        plansList = [
                SELECT Id,Name,Marketing_Plan_Number__c,Mapped_Plan_Name__c,MappedPlan__c,Plan_Sales_ID__c
                FROM
                        Plan__c
                WHERE Marketing_Plan_Number__c IN:planIdSet
        ];
        System.debug('plansList--->' + plansList);

        Set<String> mappedPlanIds = new Set<String>();

        if (plansList != null && !plansList.isEmpty() && opprPlanRates != null && !opprPlanRates.isEmpty()) {

            for (Plan__c pln : plansList) {
                planMap.put(pln.Marketing_Plan_Number__c, pln);

                if (pln != null && pln.Mapped_Plan_Name__c != null && pln.Mapped_Plan_Name__c != '') {
                    mappedPlanIds.add(pln.Mapped_Plan_Name__c);
                }
            }

        }

        System.debug('mappedPlanIds:' + mappedPlanIds);
        if (mappedPlanIds != null && !mappedPlanIds.isEmpty()) {
            List<Plan__c> mappedPlansList = [
                    SELECT Id,Name,Marketing_Plan_Number__c,Mapped_Plan_Name__c,MappedPlan__c,
                            Plan_Sales_ID__c
                    FROM Plan__c
                    WHERE Marketing_Plan_Number__c IN:mappedPlanIds
            ];
            System.debug('mappedPlansList:' + mappedPlansList);
            if (mappedPlansList != null && !mappedPlansList.isEmpty()) {
                for (Plan__c mpln : mappedPlansList) {
                    planMap.put(mpln.Marketing_Plan_Number__c, mpln);
                }
            }
        }
        System.debug('planMap:' + planMap);
        for (SGR_Opportunity_Plan_Rate__c opprPlnRate : opprPlanRates) {
            Plan__c plnObj = planMap.get(opprPlnRate.Marketing_Plan_ID__c);
            if (plnObj != null && plnObj.MappedPlan__c != null) {
                system.debug('opp plan rate id: ' + opprPlnRate.Id + ' mapped plan::' + plnObj.MappedPlan__c);
                Plan__c mpn = planMap.get(plnObj.Mapped_Plan_Name__c);//the mapped planed
                opprPlnRate.Plan__c = plnObj.MappedPlan__c;//current plan will become mapped plan
                opprPlnRate.Mapping_From_Plan_Id__c = opprPlnRate.Marketing_Plan_ID__c;//keep the current one

                if (mpn != null) {
                    opprPlnRate.Sales_Plan_ID__c = mpn.Plan_Sales_ID__c;
                    opprPlnRate.Marketing_Plan_ID__c = mpn.Marketing_Plan_Number__c;//replace the current one with mapped one
                }

                opprPlnRate.Plan_Status__c = 'Mapped';

                updateOpprPlanRates.add(opprPlnRate);

                system.debug(' mapping found, updating the record....' + opprPlnRate);

            }

        }

        system.debug('List of Opp Plan Rate to updated with Mapped Plan info::' + updateOpprPlanRates);

        if (updateOpprPlanRates != null && !updateOpprPlanRates.isEmpty()) {
            Database.SaveResult[] results = Database.update(updateOpprPlanRates, false);

            for (Database.SaveResult sr : results) {

                if (sr.isSuccess()) {
                    System.debug('Successfully updated current plans with mapped plans: ' + sr.getId());

                } else {
                    for (Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }//for

        }//if

    }
}