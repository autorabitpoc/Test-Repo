({
    doInit: function (component, event, helper) {

        console.log('SGR_Opportunity_Plan_Rate_Summary:doInit()');

        var recId = component.get("v.recordId");
        var typeOfPlan = component.get("v.TypesOfPlans");

        console.log('SGR_Opportunity_Plan_Rate_Summary: recId' + recId + ' typeOfPlan ' + typeOfPlan);

        helper.callServer(component,
            "c.fetchRates",
            function (response) {
                if (response != null) {
                    console.log('Stringify opList: ' + JSON.stringify(response, null, 4));
                    component.set('v.wrapperOppPlanRateSummary', response);
                    var JSONString = JSON.stringify(response, null, 4);
                    if (JSONString.length > 0) {
                        component.set('v.hasValues', true)
                        console.log('hasValues: true');
                    } else {
                        component.set('v.hasValues', false)
                        console.log('hasValues: false');
                    }
                }
            }, {
                inputOpportunityId: recId,
                inputCoverageType: typeOfPlan
            }
        );
    }
})