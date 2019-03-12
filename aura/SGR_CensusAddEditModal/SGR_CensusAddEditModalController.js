({
    init: function (component, event, helper) {
        console.log("memberType = " + JSON.stringify(component.get("v.memberType")));
        //helper.initializePlanData(component);
        component.set("v.isLoading", false);
        component.set("v.censusRecord.Opportunity__c", component.get("v.oppRecord.Id"));
        //NEW
        var promList = [];
        promList.push(helper.popStatesPromise(component));
        promList.push(helper.initPlanDataPromise(component));
        Promise.all(promList).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusAddEditModalController:init: result = " + JSON.stringify(result));
                helper.setUiStates(component);
                console.log("SGR_CensusAddEditModalController:init: hPlanIdOptions = " + JSON.stringify(component.get("v.hPlanIdOptions")));
            }),

            $A.getCallback(function (error) {
                console.log("SGR_CensusAddEditModalController:init: Promise was rejected: ", error);
            })
        );
    },

    handleHPlanIdChange: function (component, event, helper) {
        console.log("Selected = " + event.getParam("value"));
        component.set("v.censusRecord.Health_Plan_ID__c", event.getParam("value"));
        helper.genGroupNumOptions(component, "health", event.getParam("value"));
        component.set("v.hPlanGrpNumDisabled", false);
    },

    handleHGroupNumChange: function (component, event, helper) {
        console.log("Selected value = " + event.getParam("value"));
        component.set("v.censusRecord.Health_Group_Number__c", event.getParam("value"));
        helper.setGroupSection(component, "health", event.getParam("value"));
    },

    handleDPlanIdChange: function (component, event, helper) {
        console.log("Selected = " + event.getParam("value"));
        component.set("v.censusRecord.Dental_Plan_ID__c", event.getParam("value"));
        helper.genGroupNumOptions(component, "dental", event.getParam("value"));
        component.set("v.dPlanGrpNumDisabled", false);
    },

    handleDGroupNumChange: function (component, event, helper) {
        console.log("Selected = " + event.getParam("value"));
        component.set("v.censusRecord.Dental_Group_Number__c", event.getParam("value"));
        helper.setGroupSection(component, "dental", event.getParam("value"));
    },

    handleVisionDataChange: function (component, event, helper) {
        var visionData = event.getParam("value");
        console.log("visionData = " + JSON.stringify(visionData));
        component.set("v.censusRecord.Vision_Plan_ID__c", visionData.planId);
        component.set("v.censusRecord.Vision_Group_Number__c", visionData.groupNum);
        component.set("v.censusRecord.Vision_Group_Section__c", visionData.groupSection);
    },

    handleDobChange: function (component, event, helper) {
        helper.hideErrorMsg(component, "dobErrorMsg");
        component.set("v.ageDisabled", false);
        var dobStr = component.get("v.censusRecord").Date_of_Birth__c;
        if(dobStr === null || typeof dobStr === "undefined" || dobStr.length === 0){
            component.set("v.ageDisabled", false);
        }else{
            var ageNum = helper.calcAgeAtRenewal(component);
            if(isNaN(ageNum)){
                helper.showErrorMsg(component, "dobErrorMsg");
            }else{
                component.set("v.ageDisabled", true);
                component.set("v.censusRecord.Age_New__c", ageNum);
                helper.hideErrorMsg(component, "ageErrorMsg");
            }
        }
    },

    handleAgeChange: function (component, event, helper) {
        helper.hideErrorMsg(component, "ageErrorMsg");
        component.set("v.dobDisabled", false);
        console.log("SGR_CensusAddEditModalController:handleAgeChange: Enter");
        var ageNum = component.get("v.censusRecord").Age_New__c;
        console.log("SGR_CensusAddEditModalController:handleAgeChange: census.age = " + ageNum);
        if(ageNum === null || ageNum.length === 0){
            component.set("v.dobDisabled", false);
        }else if(typeof Number(ageNum) === "number" && Number(ageNum) >= 0){
            helper.hideErrorMsg(component, "dobErrorMsg");
            component.set("v.dobDisabled", true);
            component.set("v.censusRecord.Date_of_Birth__c", null);
        }else{
            helper.showErrorMsg(component, "ageErrorMsg");
        }
    },

    handleStateChange: function (component, event, helper) {
        component.set("v.censusRecord.State__c", event.getParam("value"));
    },

    handleHealthDepCovChange: function (component, event, helper) {
        component.set("v.vDepCoverageChecked", component.get("v.hDepCoverageChecked"));
    },

    handleStatusCodeChange: function (component, event, helper) {
        var censusRecord = component.get("v.censusRecord");
        switch (censusRecord.Employee_Status_Code__c) {
            case "Cobra":
                component.set("v.censusRecord.COBRA__c",'Y');
                component.set("v.censusRecord.Retiree__c",'N');
                component.set("v.censusRecord.State_Continuation__c",'N');
                break;
            case "Retired":
                component.set("v.censusRecord.Retiree__c",'Y');
                component.set("v.censusRecord.COBRA__c",'N');
                component.set("v.censusRecord.State_Continuation__c",'N');
                break;
            case "State Continuation":
                component.set("v.censusRecord.State_Continuation__c",'Y');
                component.set("v.censusRecord.COBRA__c",'N');
                component.set("v.censusRecord.Retiree__c",'N');
                break;
            default:
                component.set("v.censusRecord.State_Continuation__c",'N');
                component.set("v.censusRecord.COBRA__c",'N');
                component.set("v.censusRecord.Retiree__c",'N');
                break;
        }
    },

    handleModalEvent: function (component, event, helper) {
        console.log("SGR_CensusAddEditModalController:handleModalEvent: data = " + JSON.stringify(event.getParam("data")));
        var data = event.getParam("data");
        if(data.relayStage === "click"){
            if(helper.validateFormFields(component)){
                if(helper.runConfirmations(component)){
                    if(component.get("v.memberType") === "dependant"){
                        helper.syncParentCoverage(component);
                    }
                    helper.executeSave(component);
                }
            }
        }
    }
})