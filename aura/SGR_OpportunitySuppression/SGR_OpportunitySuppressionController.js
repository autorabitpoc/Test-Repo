({
    doInit: function (component, event, helper) {

        var action = component.get('c.getOpportunityData');


        action.setParams({
            'opportunityId': component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var resp = response.getReturnValue();
            if (state === 'SUCCESS') {
                console.log('resp');
                console.log(resp.Plan_Change_Needed__c);
                if (resp.Plan_Change_Needed__c === undefined || resp.Plan_Change_Needed__c === '') {
                    component.set('v.StatusForLabel', 'Yes');

                } else if (resp.Plan_Change_Needed__c === 'Yes') {
                    component.set('v.StatusForLabel', 'Review');
                } else if (resp.Plan_Change_Needed__c === 'Review') {
                    component.set('v.StatusForLabel', 'Complete');
                } else if (resp.Plan_Change_Needed__c === 'Complete') {
                    component.set('v.disableButton', true);
                    component.set('v.buttonLabel', 'Update Plan Change Needed');
                    // if(resp.Rating_Status__c == 'Sold' || resp.Rating_Status__c == 'Marketing Release'){

                    ///var finalval= 'Finalized';

                    //component.set('v.RatingStatus',finalval);

                    //}

                }
            }
        });
        $A.enqueueAction(action);
    },
    updateOpportunity: function (component, event, helper) {
        var action = component.get('c.updateOpportunityData');
        action.setParams({
            'opportunityId': component.get('v.recordId'),
            'updatePlanChange': component.get('v.StatusForLabel'),
            'ratingStatus': component.get('v.RatingStatus')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var resp = response.getReturnValue();
            console.log('resp');
            console.log(resp);
            if (state === 'SUCCESS') {
                if (resp === 'SUCCESS') {
                    //alert('Record updated');
                    window.location.reload();
                } else {
                    alert('Record update failed')
                }
            }
        });
        $A.enqueueAction(action);
    },
    handlePlanUpdate: function (component, event, helper) {
        console.log('First Call');
        component.set("v.ShowPopup", true);
        component.set("v.headerTxt", "Change Plan Status");
        component.set("v.buttonName", "UpdatePlanChange");
        component.set("v.planStatus", "Yes");

    },


    UpdateShowPopup: function (component, event, helper) {
        component.set("v.ShowPopup", false);
        var showpopup = event.getParam("UpdateShowPopup");
        //if(showpopup===true){component.set("v.ShowPopup",false);}
    }


})