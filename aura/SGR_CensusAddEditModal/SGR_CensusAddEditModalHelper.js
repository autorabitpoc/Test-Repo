({
    apexPromise : function(action) {
        return new Promise($A.getCallback(function (resolve, reject) {
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    reject(Error("apexPromise: failed with state = " + state));
                }
            });
            $A.enqueueAction(action);
        }));
    },

    emptyPromise : function(doResolve, returnVal) {
        return new Promise($A.getCallback(function (resolve, reject) {
            if(doResolve){
                resolve(returnVal);
            }else{
                reject(returnVal);
            }
        }));
    },

    initPlanDataPromise : function(component) {
        return new Promise($A.getCallback(function (resolve, reject) {
            var planDataList = component.get("v.planDataList");
            var hPlanIdOptions = [];
            var dPlanIdOptions = [];
            var vPlanIdOptions = [];
            var planDataMap = {};
            planDataList.forEach(function (item) {
                switch (item.planType) {
                    case "H":
                        hPlanIdOptions.push({'label': item.planId, 'value': item.planId});
                        vPlanIdOptions.push({'label': item.planId, 'value': item.planId});
                        break;
                    case "D":
                        dPlanIdOptions.push({'label': item.planId, 'value': item.planId});
                        break;
                    case "V":
                        vPlanIdOptions.push({'label': item.planId, 'value': item.planId});
                        break;
                }
                planDataMap[item.planId] = item;
            });

            component.set("v.hPlanIdOptions", hPlanIdOptions);
            component.set("v.dPlanIdOptions", dPlanIdOptions);
            component.set("v.vPlanIdOptions", vPlanIdOptions);
            component.set("v.planDataMap", planDataMap);
            resolve("initPlanDataPromise");
        }));
    },

    popStatesPromise : function(component) {
        var helper = this;
        var action = component.get("c.getStateList");
        return helper.apexPromise(action).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusAddEditModalHelper:populateStates: result = " + JSON.stringify(result));
                if(result !== null && typeof result !== "undefined" && result.length > 0){
                    component.set("v.stateList", helper.cleanStateList(result));
                }
                return "popStatesPromise";
            }),

            $A.getCallback(function (error) {
                console.log("SGR_CensusAddEditModalHelper:populateStates: Promise was rejected: ", error);
            })
        );
    },

    cleanStateList : function(stateList) {
        var returnList = [];
        stateList.forEach(function (item) {
            returnList.push({'label': item.State_Code__c, 'value': item.State_Code__c});
        });
        return returnList;
    },

    setUiStates : function(component) {
        var helper = this;
        var tabId = component.get("v.tabId");
        var mode = component.get("v.mode");
        var memberType = component.get("v.memberType");
        if(memberType === "subscriber"){
            component.set("v.hPlanIdDisabled", false);
            component.set("v.dPlanIdDisabled", false);
            component.set("v.censusRecord.Relationship__c", "Subscriber");
            if(mode === "edit"){
                helper.readyCoverage(component, component.get("v.censusRecord"));
            }
        }else{
            helper.setRelationshipOptions(component);
            helper.readyCoverage(component, component.get("v.parentCensusRecord"));
            if(mode === "add"){
                helper.prepForNewDependant(component);
            }else{
                helper.prepForEditDependant(component);
            }
            //TODO:Need to set the plan values based on parent
        }
    },
    //<aura:attribute name="healthData" type="Object" default="{'planId: '', 'groupNum': '', 'groupSection': ''}"/>

    readyCoverage : function(component, censusRecord) {
        var helper = this;
        if(helper.verifyContent(censusRecord.Health_Plan_ID__c)){
            component.find("healthPlanId").set("v.value", censusRecord.Health_Plan_ID__c);
            helper.genGroupNumOptions(component, "health", censusRecord.Health_Plan_ID__c);
            component.find("healthGroupNumber").set("v.value", censusRecord.Health_Group_Number__c);
            helper.setGroupSection(component, "health", censusRecord.Health_Group_Number__c);
            component.find("healthGroupSection").set("v.value", censusRecord.Health_Group_Section__c);

        }
        if(helper.verifyContent(censusRecord.Dental_Plan_ID__c)){
            component.find("dentalPlanId").set("v.value", censusRecord.Dental_Plan_ID__c);
            helper.genGroupNumOptions(component, "dental", censusRecord.Dental_Plan_ID__c);
            component.find("dentalGroupNumber").set("v.value", censusRecord.Dental_Group_Number__c);
            helper.setGroupSection(component, "dental", censusRecord.Dental_Group_Number__c);
            component.find("dentalGroupSection").set("v.value", censusRecord.Dental_Group_Section__c);

        }
        if(helper.verifyContent(censusRecord.Vision_Plan_ID__c)){
            component.find("visionPlanId").set("v.value", censusRecord.Vision_Plan_ID__c);
            component.find("visionGroupNumber").set("v.value", censusRecord.Vision_Group_Number__c);
            helper.setGroupSection(component, "vision", censusRecord.Vision_Group_Number__c);
            component.find("visionGroupSection").set("v.value", censusRecord.Vision_Group_Section__c);
        }

    },

    prepForNewDependant : function(component) {
        var helper = this;
        var parentCensusRecord = component.get("v.parentCensusRecord");
        if(helper.verifyContent(parentCensusRecord.Health_Plan_ID__c)){
            component.set("v.hDepCoverageDisabled", false);
        }
        if(helper.verifyContent(parentCensusRecord.Dental_Plan_ID__c)){
            component.set("v.dDepCoverageDisabled", false);
        }
    },

    prepForEditDependant : function(component) {
        var helper = this;
        var censusRecord = component.get("v.censusRecord");
        if(helper.verifyContent(censusRecord.Health_Plan_ID__c)){
            component.set("v.hDepCoverageChecked", true);
        }
        if(helper.verifyContent(censusRecord.Dental_Plan_ID__c)){
            component.set("v.dDepCoverageChecked", true);
        }
        if(helper.verifyContent(censusRecord.Vision_Plan_ID__c)){
            component.set("v.vDepCoverageChecked", true);
        }
    },

    getAllDeps : function(component) {
        var parentCensusRecord = component.get("v.parentCensusRecord");
        var allCensusList = component.get("v.allCensusList");
        var returnList = [];
        allCensusList.forEach(function (item) {
            if(item.Relationship__c !== "Subscriber" && item.Opportunity__c === parentCensusRecord.Opportunity__c && item.Subscriber_Number__c === parentCensusRecord.Subscriber_Number__c){
                returnList.push(JSON.parse(JSON.stringify(item)));
            }
        });
        return returnList;
    },

    hasSpouseOrDp : function(depList) {
        if(depList != null && depList.length > 0){
            for(var i = 0; i < depList.length; i++){
                if(depList[i].Relationship__c === "Spouse" || depList[i].Relationship__c === "Domestic Partner"){
                    return true;
                }
            }
        }
        return false;
    },

    syncParentCoverage : function(component) {
        var parentCensusRecord = component.get("v.parentCensusRecord");
        var censusRecord = component.get("v.censusRecord");
        if(component.get("v.hDepCoverageChecked")){
            censusRecord.Health_Plan_ID__c = parentCensusRecord.Health_Plan_ID__c;
            censusRecord.Health_Group_Number__c = parentCensusRecord.Health_Group_Number__c;
            censusRecord.Health_Group_Section__c = parentCensusRecord.Health_Group_Section__c;
        }
        if(component.get("v.dDepCoverageChecked")){
            censusRecord.Dental_Plan_ID__c = parentCensusRecord.Dental_Plan_ID__c;
            censusRecord.Dental_Group_Number__c = parentCensusRecord.Dental_Group_Number__c;
            censusRecord.Dental_Group_Section__c = parentCensusRecord.Dental_Group_Section__c;
        }
        if(component.get("v.vDepCoverageChecked")){
            censusRecord.Vision_Plan_ID__c = parentCensusRecord.Vision_Plan_ID__c;
            censusRecord.Vision_Group_Number__c = parentCensusRecord.Vision_Group_Number__c;
            censusRecord.Vision_Group_Section__c = parentCensusRecord.Vision_Group_Section__c;
        }
    },

    setRelationshipOptions : function(component) {
        var censusRecord = component.get("v.censusRecord");
        var options = ['Spouse', 'Child', 'Domestic Partner'];
        var relationshipOptions = [];
        var found = false;
        options.forEach(function (item) {
            var selected = (item === censusRecord.Relationship__c);
            if(!found){
                found = selected;
            }
            relationshipOptions.push({label: item, value: item, selected: selected});
        });
        /*var relationshipOptions = [
            {label: 'Spouse', value: 'Spouse', selected: (censusRecord.Relationship__c === 'Spouse')},
            {label: 'Child', value: 'Child', selected: (censusRecord.Relationship__c === 'Child')},
            {label: 'Domestic Partner', value: 'Domestic Partner', selected: (censusRecord.Relationship__c === 'Domestic Partner')}
        ];*/
        if(!found){
            relationshipOptions.unshift({label: 'None', value: 'None', selected: true});
        }
        component.set("v.relationshipOptions", relationshipOptions);
    },

    genGroupNumOptions : function(component, covType, selectedId) {
        var grpNumOptions = [];
        var grpSecOptions = [];
        var planDataMap = component.get("v.planDataMap");
        var thisData = planDataMap[selectedId];
        if(thisData !== null && typeof thisData !== "undefined" && thisData.groupInfoList !== null && typeof thisData.groupInfoList !== "undefined" && thisData.groupInfoList.length > 0){
            thisData.groupInfoList.forEach(function (item) {
                grpNumOptions.push({'label': item.Opportunity_Group_Number__c, 'value': item.Opportunity_Group_Number__c});
                grpSecOptions.push({'label': item.Opportunity_Group_Section_Number__c, 'value': item.Opportunity_Group_Section_Number__c});
            });
            if(covType === "health"){
                component.set("v.hGroupNumOptions", grpNumOptions);
                component.set("v.hGroupSecOptions", grpSecOptions);
                component.set("v.vGroupNumOptions", grpNumOptions);
                component.set("v.vGroupSecOptions", grpSecOptions);
            }else{
                component.set("v.dGroupNumOptions", grpNumOptions);
                component.set("v.dGroupSecOptions", grpSecOptions);
            }
        }
    },

    setGroupSection : function(component, covType, selectedGrpNum) {
        var planDataMap = component.get("v.planDataMap");
        var auraId = (covType === "health" ? "healthPlanId" : "dentalPlanId");
        var planId = component.find(auraId).get("v.value");
        console.log("SGR_CensusAddEditModalHelper:setGroupSection: covType = " + JSON.stringify(covType));
        console.log("SGR_CensusAddEditModalHelper:setGroupSection: selectedGrpNum = " + JSON.stringify(selectedGrpNum));
        console.log("SGR_CensusAddEditModalHelper:setGroupSection: planId = " + JSON.stringify(planId));
        var thisData = planDataMap[planId];
        var searching = true;
        if(thisData !== null && typeof thisData !== "undefined" && thisData.groupInfoList !== null && typeof thisData.groupInfoList !== "undefined" && thisData.groupInfoList.length > 0){
            thisData.groupInfoList.forEach(function (item) {
                if(searching && item.Opportunity_Group_Number__c === selectedGrpNum){
                    searching = false;
                    if(covType === "health"){
                        component.find("healthGroupSection").set("v.value", item.Opportunity_Group_Section_Number__c);
                        component.set("v.censusRecord.Health_Group_Section__c", item.Opportunity_Group_Section_Number__c);
                        console.log("SGR_CensusAddEditModalHelper:setGroupSection: val = " + JSON.stringify(component.find("healthGroupSection").get("v.value")));
                    }else if(covType === "dental"){
                        component.find("dentalGroupSection").set("v.value", item.Opportunity_Group_Section_Number__c);
                        component.set("v.censusRecord.Dental_Group_Section__c", item.Opportunity_Group_Section_Number__c);
                        console.log("SGR_CensusAddEditModalHelper:setGroupSection: val = " + JSON.stringify(component.find("dentalGroupSection").get("v.value")));
                    }else{
                        component.find("visionGroupSection").set("v.value", item.Opportunity_Group_Section_Number__c);
                        component.set("v.censusRecord.Vision_Group_Section__c", item.Opportunity_Group_Section_Number__c);
                        console.log("SGR_CensusAddEditModalHelper:setGroupSection: val = " + JSON.stringify(component.find("visionGroupSection").get("v.value")));
                    }
                }
            });

        }
    },

    makeToast : function(title, msg) {
        var appEvent = $A.get("e.c:SGR_ModalClickEvent");
        appEvent.setParams({
            "data" : {
                "relayStage" : "toast",
                "toastPkg" : {
                    "title": title,
                    "message": msg,
                    "variant": "warning"
                }
            }
        });
        appEvent.fire();
    },

    showErrorMsg : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.removeClass(cmpTarget, 'hide-error');
    },

    hideErrorMsg : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.addClass(cmpTarget, 'hide-error');
    },

    verifyContent : function(fieldVal) {
        return (fieldVal !== null && typeof fieldVal !== "undefined" && String(fieldVal).length > 0);
    },

    validateFormFields : function(component) {
        var helper = this;
        var memberType = component.get("v.memberType");
        if(memberType === "subscriber"){
            return helper.validateFieldsNewSub(component);
        }
        return helper.validateFieldsNewDep(component);
    },

    validateFieldsNewSub : function(component) {
        var helper = this;
        var errorFields = [];
        var censusRecord = component.get("v.censusRecord");
        var tabId = component.get("v.tabId");
        if(tabId === "health"){
            if(!helper.verifyContent(censusRecord.Health_Plan_ID__c)){
                errorFields.push("Health Plan ID");
            }
            if(!helper.verifyContent(censusRecord.Health_Group_Number__c)){
                errorFields.push("Health Group Number");
            }
            if(!helper.verifyContent(censusRecord.Health_Group_Section__c)){
                errorFields.push("Health Group Section Number");
            }
            if(helper.verifyContent(censusRecord.Dental_Plan_ID__c)){
                if(!helper.verifyContent(censusRecord.Dental_Group_Number__c)){
                    errorFields.push("Dental Group Number");
                }
                if(!helper.verifyContent(censusRecord.Dental_Group_Section__c)){
                    errorFields.push("Dental Group Section Number");
                }
            }
        }else if(tabId === "dental"){
            if(!helper.verifyContent(censusRecord.Dental_Plan_ID__c)){
                errorFields.push("Dental Plan ID");
            }
            if(!helper.verifyContent(censusRecord.Dental_Group_Number__c)){
                errorFields.push("Dental Group Number");
            }
            if(!helper.verifyContent(censusRecord.Dental_Group_Section__c)){
                errorFields.push("Dental Group Section Number");
            }
            if(helper.verifyContent(censusRecord.Health_Plan_ID__c)){
                if(!helper.verifyContent(censusRecord.Health_Group_Number__c)){
                    errorFields.push("Health Group Number");
                }
                if(!helper.verifyContent(censusRecord.Health_Group_Section__c)){
                    errorFields.push("Health Group Section Number");
                }
            }
        }
        if(!helper.verifyContent(censusRecord.First_Name__c)){
            errorFields.push("First Name");
        }
        if(!helper.verifyContent(censusRecord.Last_Name__c)){
            errorFields.push("Last Name");
        }
        if(!helper.verifyContent(censusRecord.Zip_Code__c)){
            errorFields.push("Zip Code");
        }
        if(!helper.verifyContent(censusRecord.Gender__c) || censusRecord.Gender__c === "--None--"){
            errorFields.push("Gender");
        }
        if(errorFields.length > 0){
            helper.makeToast("Missing Required Fields", errorFields.join(", "));
            return false;
        }
        return true;
    },

    validateFieldsNewDep : function(component) {
        var helper = this;
        var errorFields = [];
        var censusRecord = component.get("v.censusRecord");
        if(!helper.verifyContent(censusRecord.First_Name__c)){
            errorFields.push("First Name");
        }
        if(!helper.verifyContent(censusRecord.Last_Name__c)){
            errorFields.push("Last Name");
        }
        if(!helper.verifyContent(censusRecord.Relationship__c) || censusRecord.Relationship__c === "None"){
            errorFields.push("Relationship");
        }
        if(!helper.verifyContent(censusRecord.Zip_Code__c)){
            errorFields.push("Zip Code");
        }
        if(!helper.verifyContent(censusRecord.Gender__c) || censusRecord.Gender__c === "--None--"){
            errorFields.push("Gender");
        }
        if(errorFields.length > 0){
            helper.makeToast("Missing Required Fields", errorFields.join(", "));
            return false;
        }
        return true;
    },

    runConfirmations : function(component) {
        var helper = this;
        var memberType = component.get("v.memberType");
        if(memberType === "subscriber"){
            return helper.runSubscriberConfirmations(component);
        }
        return helper.runDependentConfirmations(component);
    },

    runSubscriberConfirmations : function(component) {
        var helper = this;
        var oppRecord = component.get("v.oppRecord");
        var mtAgeConf = true;
        if(oppRecord.HCSC_Division__c === "MT"){
            mtAgeConf = helper.getMtAgeConfirmation(component);
            if(mtAgeConf){
                component.set("v.censusRecord.Vision_Plan_ID__c", null);
                component.set("v.censusRecord.Vision_Group_Number__c", null);
                component.set("v.censusRecord.Vision_Group_Section__c", null);
            }
        }
        if(mtAgeConf){
            var ageInputVal = helper.validateAgeInput(component);
            if(ageInputVal){
                var zipInputVal = helper.validateZipInput(component);
                if(zipInputVal){
                    helper.cleanSelectValues(component);
                    var ageExcVal = helper.confirmAgeException(component);
                    if(ageExcVal){
                        return helper.confirmRetirementException(component);
                        /*if(retireExcVal){
                            helper.executeSave(component);
                        }*/
                    }
                }
            }
        }
        return false;
    },

    runDependentConfirmations : function(component) {
        var helper = this;
        var ageInputVal = helper.validateAgeInput(component);
        if(ageInputVal === true){
            var relationshipVal = helper.validateDepRelationship(component);
            if(relationshipVal){
                var coverageVal = helper.validateDepCoverage(component);
                if(coverageVal){
                    var ageExcVal = helper.confirmAgeException(component);
                    if(ageExcVal){
                        var zipInputVal = helper.validateZipInput(component);
                        if(zipInputVal){
                            return helper.getMtAgeConfirmation(component);
                        }
                    }
                }
            }
        }
        return false;
    },

    validateDepCoverage : function(component) {
        var helper = this;
        if(component.get("v.hDepCoverageChecked") === false && component.get("v.dDepCoverageChecked") === false){
            helper.makeToast("No Coverage Selected", "You should select at lease one of Health Coverage / Dental Coverage / Vision Coverage");
            return false;
        }
        return true;
    },

    validateDepRelationship : function(component) {
        var helper = this;
        if(helper.hasSpouseOrDp(helper.getAllDeps(component))){
            helper.makeToast("Relationship", "Cannot add more than one spouse or domestic partner for a subscriber");
            return false;
        }
        return true;
    },

    calcAgeAtRenewal : function(component) {
        console.log("SGR_CensusAddEditModalHelper:calcAgeAtRenewal: Enter");
        console.log("SGR_CensusAddEditModalHelper:calcAgeAtRenewal: census.dob = " + component.get("v.censusRecord").Date_of_Birth__c);
        var dobStr = component.get("v.censusRecord").Date_of_Birth__c;
        var renewalStr = component.get("v.oppRecord").Renewal_Date__c;
        console.log("SGR_CensusAddEditModalHelper:calcAgeAtRenewal: renewalStr = " + JSON.stringify(renewalStr));
        var dobDate = new Date(JSON.stringify(dobStr));
        var renewalDate = new Date(JSON.stringify(renewalStr));
        var diffMs = renewalDate.getTime() - dobDate.getTime();
        var ageDate = new Date(diffMs);
        var ageNum =  Math.abs(ageDate.getUTCFullYear() - 1970);
        console.log("SGR_CensusAddEditModalHelper:calcAgeAtRenewal: ageNum = " + ageNum);
        return ageNum;
    },

    getMtAgeConfirmation : function(component) {
        var censusRecord = component.get("v.censusRecord");
        if(censusRecord.Age_New__c < 19){
            return confirm("Under 19 census will not be enrolled in Vision coverage and will only be enrolled into Health coverage.\nDo you wish to proceed?");
        }
        return true;
    },

    validateAgeInput : function(component) {
        var helper = this;
        var censusRecord = component.get("v.censusRecord");
        console.log("SGR_CensusAddEditModalHelper:validateAgeInput: censusRecord.Date_of_Birth__c = " + JSON.stringify(censusRecord.Date_of_Birth__c));
        console.log("SGR_CensusAddEditModalHelper:validateAgeInput: censusRecord.Age_New__c = " + JSON.stringify(censusRecord.Age_New__c));
        if(!helper.verifyContent(censusRecord.Date_of_Birth__c) && !helper.verifyContent(censusRecord.Age_New__c)){
            helper.makeToast("Error", "Either one of DOB or Age must be entered");
            return false;
        }
        return true;
    },

    validateZipInput : function(component) {
        var helper = this;
        var censusRecord = component.get("v.censusRecord");
        if(!helper.validZipcodeFormat(censusRecord.Zip_Code__c)){
            helper.makeToast("Error", "Please enter a valid Zip Code");
            return false;
        }
        return true;
    },

    validZipcodeFormat : function(zipcode) {
        var helper = this;
        if(helper.verifyContent(zipcode)){
            var zipParts = zipcode.split("-");
            if(zipParts.length === 2){
                return (zipParts[0].length === 5 && zipParts[1].length === 4);
            }
            return zipcode.length === 5;
        }
        return false;
    },

    cleanSelectValues : function(component) {
        var helper = this;
        var censusRecord = component.get("v.censusRecord");
        component.set("v.censusRecord.Employee_Status_Code__c", censusRecord.Employee_Status_Code__c === "None" ? "" : censusRecord.Employee_Status_Code__c);
        if(component.get("v.mode") === "add"){
            if(helper.verifyContent(censusRecord.Health_Plan_ID__c)){
                component.set("v.censusRecord.Health_Tier__c", "EO");
                component.set("v.censusRecord.Vision_Tier__c", "EO");
            }
            if(helper.verifyContent(censusRecord.Dental_Plan_ID__c)){
                component.set("v.censusRecord.Dental_Tier__c", "EO");
            }
        }
    },

    confirmAgeException : function(component) {
        var censusRecord = component.get("v.censusRecord");
        if(censusRecord.Age_New__c > 99){
            return confirm("Subscriber or dependent over the age of 99. Do you wish to proceed?");
        }
        if(censusRecord.Age_New__c < 16 && censusRecord.Relationship__c !== "Child"){
            return confirm("Subscriber/spouse/domestic partner census under the age of 16 for a non-cobra subscriber. Do you wish to proceed?");
        }
        return true;
    },

    confirmRetirementException : function(component) {
        var oppRecord = component.get("v.oppRecord");
        var censusRecord = component.get("v.censusRecord");
        if(censusRecord.Retiree__c === "Y"){
            if(oppRecord.HCSC_Division__c === "NM" || oppRecord.HCSC_Division__c === "TX"){
                return confirm("A Retired subscriber cannot exist in an Opportunity within a Regulated Market Segment. Do you wish to proceed?");
            }
            if(oppRecord.HCSC_Division__c === "OK"){
                return confirm("A Retired subscriber cannot exist in an Opportunity located within a Non-Public Entity account. Do you wish to proceed?");
            }
            if(oppRecord.HCSC_Division__c === "MT"){
                return confirm("A Retired subscriber cannot exist in an Opportunity located within a Non-Municipality account. Do you wish to proceed?");
            }
        }
        return true;
    },

    genSaveAction : function(component) {
        var action = component.get("c.saveCensus");
        var params = null
        if(component.get("v.memberType") === "dependant"){
            params = {
                "subOppCensus" : component.get("v.parentCensusRecord"),
                "depOppCensus" : component.get("v.censusRecord"),
                "allOppCensusList" : component.get("v.allCensusList"),
                "oppRecord" : component.get("v.oppRecord"),
                "tabId" : component.get("v.tabId")
            };
        }else{
            params = {
                "subOppCensus" : component.get("v.censusRecord"),
                "depOppCensus" : null,
                "allOppCensusList" : null,
                "oppRecord" : component.get("v.oppRecord"),
                "tabId" : component.get("v.tabId")
            };
        }
        action.setParams(params);
        return action;
    },

    executeSave : function(component) {
        var helper = this;
        component.set("v.isLoading", true);
        helper.apexPromise(helper.genSaveAction(component)).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusAddEditModalHelper:executeSave: save result = " + JSON.stringify(result));
                if(result === true){
                    var appEvent = $A.get("e.c:SGR_ModalClickEvent");
                    appEvent.setParams({
                        "data" : {
                            "relayStage" : "success"
                        }
                    });
                    appEvent.fire();
                }
                component.set("v.isLoading", false);
            }),

            $A.getCallback(function (error) {
                console.log("SGR_CensusAddEditModalHelper:executeSave: save Promise was rejected: ", error);
            })
        )
    }
})