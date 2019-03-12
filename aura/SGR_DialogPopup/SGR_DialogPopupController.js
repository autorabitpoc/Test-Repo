({
    openModel: function (component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },

    AgeCancel: function (component, event, helper) {
        component.set("v.isOpen", false);
    },
    RetireeCancel: function (component, event, helper) {
        component.set("v.isOpen", false);
    },

    closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
        compEvent.setParams({"Confirmed": false});
        compEvent.fire();
    },
    closeModel1: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        var compEvent = $A.get("e.c:SGR_CancelButton");
        compEvent.setParams({"Confirmed": false});
        compEvent.fire();
    },
    cancelModel: function (component, evevnt, helper) {
        var compEvent = $A.get("e.c:SGR_RefreshOpty");
        compEvent.setParams({"Confirmed": false});
        compEvent.fire();

    },

    likenClose: function (component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        alert('thanks for like Us :)');
        component.set("v.isOpen", false);
    },
    UpdateStatus: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
    },

    UpdateLiftStatus: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_LiftGateOpty");
        //console.log("inside modal popup");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        var ShowPopupEvent = $A.get("e.c:SGR_CancelButton");
        ShowPopupEvent.setParams({"UpdateShowPopup": true});
        ShowPopupEvent.fire();
        component.set("v.isOpen", false);
    },

    UpdateRefresh: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_RefreshOpty");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        var ShowPopupEvent = $A.get("e.c:SGR_CancelButton");
        ShowPopupEvent.setParams({"UpdateShowPopup": true});
        ShowPopupEvent.fire();
        component.set("v.isOpen", false);
    },

    HealthDelete: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_DeleteHealthCensus");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },

    HandleDental: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_DeleteDentalCensus");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },

    HandleAgeCheck: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_CensusAgeCheckEvent");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },
    HandleRetireeCheck: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_CensusSubRetireeTrue");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },
    uprate: function (component, event, helper) {
        component.set("v.Likedisable", false);

    },

    DependentHandleAgeCheck: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_DependentCensusAgeCheckEvent");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },
    HandleAgeCobraCheck: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_CensusAgeCheckEvent");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },
    DependentHandleAgeCobraCheck: function (component, event, helper) {
        var compEvent = $A.get("e.c:SGR_DependentCensusAgeCobraCheckEvent");
        compEvent.setParams({
            "Confirmed": true
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },

    UpdateBA: function (component, event, helper) {
        var IsItIncludeBA = false;

        if (component.get("v.buttonName") == 'BAInclude') {
            IsItIncludeBA = true;
        }
        //var compEvent = $A.get("e.c:SGR_RefreshBA");
        var compEvent = $A.get("e.c:SGR_CensusPlan");
        compEvent.setParams({
            "Confirmed": true
            //"IsItForIncludeBA" : IsItIncludeBA,
            //"SelectedRecordId":component.get('v.SelectedRecordId')
        });
        compEvent.fire();
        component.set("v.isOpen", false);
    },
    PlanChangeNeeded: function (component, event, helper) {
        /*console.log('second Call');
    	var compEvent = $A.get("e.c:SGR_OpportunitySuppressionEvent");
        //console.log("inside modal popup");
        compEvent.setParams({
            "Confirmed" : true
        });
        compEvent.fire();
        var ShowPopupEvent = $A.get("e.c:SGR_CancelButton");
        ShowPopupEvent.setParams({"UpdateShowPopup" : true});
        ShowPopupEvent.fire();
        component.set("v.isOpen", false);*/
        component.set('v.opportunityUpdateRequired', true);
        component.closeModalBox();
    },

})