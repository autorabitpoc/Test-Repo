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

    initializeData : function(component, refresh) {
        var helper = this;
        var action = component.get("c.getOpportunity");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        helper.apexPromise(action).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusWidgetHelper:initializeData: getOpportunity result = " + JSON.stringify(result));
                component.set("v.recordOpp", result);
                if(result !== null){
                    action = component.get("c.getCensusListForOpportunity");
                    action.setParams({
                        "oppId" : component.get("v.recordId")
                    });
                    return helper.apexPromise(action);
                }else{
                    return helper.emptyPromise(false, "getOpportunity failed");
                }
            }),

            $A.getCallback(function (error) {
                console.log("initializeData:initializeData: getOpportunity Promise was rejected: ", error);
                component.set("v.isLoading", false);
            })
        ).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusWidgetHelper:initializeData: getCensusListForOpportunity result = " + JSON.stringify(result));
                component.set("v.censusList", result);
                if(result !== null){
                    action = component.get("c.getEditCapabilitiesMap");
                    action.setParams({
                        "oppId" : component.get("v.recordId")
                    });
                    return helper.apexPromise(action);
                }else{
                    return helper.emptyPromise(false, "getCensusListForOpportunity failed");
                }
            }),

            $A.getCallback(function (error) {
                console.log("initializeData:initializeData: getCensusListForOpportunity Promise was rejected: ", error);
                component.set("v.isLoading", false);
            })
        ).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusWidgetHelper:initializeData: getEditCapabilitiesMap result = " + JSON.stringify(result));
                component.set("v.editCapabilitiesMap", result);
                helper.restrictTabs(component);
                helper.parseCensusData(component);
                return helper.getAllPlanData(component);
            }),

            $A.getCallback(function (error) {
                console.log("initializeData:initializeData: getEditCapabilitiesMap Promise was rejected: ", error);
                component.set("v.isLoading", false);
            })
        ).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusWidgetHelper:initializeData: fetchAllPlanData result = " + JSON.stringify(result));
                component.set("v.planDataList", result);
                return helper.checkDeleteStatus(component);
            }),

            $A.getCallback(function (error) {
                console.log("initializeData:initializeData: fetchAllPlanData Promise was rejected: ", error);
            })
        ).then(
            $A.getCallback(function (result) {
                console.log("SGR_CensusWidgetHelper:initializeData: checkDeleteStatus result = " + JSON.stringify(result));
                component.set("v.deleteDisabled", result);
                component.set("v.isLoading", false);
                if(refresh){
                    helper.renderTab(component, component.get("v.currentTabId"));
                }
            }),

            $A.getCallback(function (error) {
                console.log("initializeData:initializeData: checkDeleteStatus Promise was rejected: ", error);
                component.set("v.isLoading", false);
            })
        );
    },

    getAllPlanData : function(component) {
        var helper = this;
        var action = component.get("c.fetchAllPlanData");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        return helper.apexPromise(action);
    },

    checkDeleteStatus : function(component) {
        var helper = this;
        var action = component.get("c.isDeleteDisabled");
        action.setParams({
            "opty" : component.get("v.recordOpp")
        });
        return helper.apexPromise(action);
    },

    makeColumns : function(component, tabName) {
        var helper = this;
        switch (tabName) {
            case "health":
                return helper.healthColumns(component);
            case "dental":
                return helper.dentalColumns(component);
            default:
                return helper.visionColumns(component);
        }
    },

    parseCensusData : function(component) {
        var helper = this;
        var censusList = component.get("v.censusList");
        var formattedCensusList = [];
        var healthCensusList = [];
        var dentalCensusList = [];
        var visionCensusList = [];
        for(var i = 0; i < censusList.length; i++){
            //var row = JSON.parse(JSON.stringify(censusList[i]));
            var row = censusList[i];
            row.CreatedBy = row.CreatedBy.Name;
            row.LastModifiedBy = row.LastModifiedBy.Name;
            row.Created_Date_only__c = $A.localizationService.formatDate(row.CreatedDate, "M/D/YYYY h:M:SS a");
            row.Last_Modify_Date_Only__c = $A.localizationService.formatDate(row.LastModifiedDate, "M/D/YYYY h:M:SS a");
            row.medicareYesNo = (row.Medicare_Primary__c === true ? "Y" : "N");
            if(typeof(row.Health_Plan_ID__c) !== 'undefined' && row.Health_Plan_ID__c.length > 0 && row.SGR_HealthIsChecked__c === true){
                healthCensusList.push(JSON.parse(JSON.stringify(row)));
            }
            if(typeof(row.Dental_Plan_ID__c) !== 'undefined' && row.Dental_Plan_ID__c.length > 0 && row.SGR_DentalIsChecked__c === true){
                dentalCensusList.push(JSON.parse(JSON.stringify(row)));
            }
            if(typeof(row.Vision_Plan_ID__c) !== 'undefined' && row.Vision_Plan_ID__c.length > 0 && row.SGR_VisionIsChecked__c === true){
                visionCensusList.push(JSON.parse(JSON.stringify(row)));
            }
            if(row.Relationship__c !== 'Subscriber'){
                row.COBRA__c='';
                row.State_Continuation__c='';
                row.Retiree__c='';
                row.Health_Tier__c='';
                row.Dental_Tier__c='';
                row.Vision_Tier__c='';
                row.Health_Plan_ID__c='';
                row.Dental_Plan_ID__c='';
                row.Vision_Plan_ID__c='';
                row.Health_Group_Number__c='';
                row.Dental_Group_Number__c='';
                row.Vision_Group_Number__c='';
                row.Health_Group_Section__c='';
                row.Dental_Group_Section__c='';
                row.Vision_Group_Section__c='';
            }
            formattedCensusList.push(JSON.parse(JSON.stringify(row)));
        }
        healthCensusList.forEach(function (value) {
            value.isActive = helper.checkRowActive(value);
        });
        dentalCensusList.forEach(function (value) {
            value.isActive = helper.checkRowActive(value);
        });
        visionCensusList.forEach(function (value) {
            value.isActive = true;
        });
        var resultData = {};
        resultData.formatted = formattedCensusList;
        resultData.health = healthCensusList;
        resultData.dental = dentalCensusList;
        resultData.vision = visionCensusList;
        //console.log("resultData = " + JSON.stringify(resultData));
        component.set("v.formattedCensusData", resultData);
    },

    checkRowActive : function(row) {
        return !(row.Relationship__c === 'Subscriber' && row.Opportunity__r.Rating_Status__c !== 'Underwriting-Released' &&
            row.Opportunity__r.Rating_Status__c !== 'Marketing Release' && row.Opportunity__r.Rating_Status__c !== 'Sold' &&
            row.Opportunity__r.Rating_Status__c !== 'Finalized' && row.Opportunity__r.Rating_Status__c !== 'Closed');
    },

    restrictTabs : function(component) {
        var editCapabilitiesMap = component.get("v.editCapabilitiesMap");
        component.set("v.displayHealthTab", editCapabilitiesMap["hTab"]);
        component.set("v.displayDentalTab", editCapabilitiesMap["dTab"]);
        component.set("v.displayVisionTab", editCapabilitiesMap["vTab"]);
    },

    mapSelectedRows : function(component, rowData) {
        var selectedIds = [];
        if(rowData !== null && typeof rowData !== "undefined" && rowData.length > 0){
            rowData.forEach(function (item) {
               selectedIds.push(item.Id);
            });

        }
        component.set("v.selectedIds", selectedIds);
    },

    healthColumns : function(component) {
        var editCapabilitiesMap = component.get("v.editCapabilitiesMap");
        var isDisabled = editCapabilitiesMap["Health"];
        return [
            {label: '', type: 'button-icon', typeAttributes: {iconName: 'utility:new', name: 'new_record', title: 'Add Dependent', variant: 'border-filled', alternativeText: 'new', disabled: {fieldName:'isActive'}, iconPosition: 'left'}, fixedWidth:55},
            {label: 'Edit', type: 'button-icon', typeAttributes: {iconName: 'utility:edit', name: 'edit_record', title: 'Edit Row', variant: 'border-filled', alternativeText: 'edit', disabled: isDisabled, iconPosition: 'left'}, fixedWidth:60},
            {label: 'Sub#', fieldName: 'Row__c', type: 'text', Strong:'true',cellAttributes: {alignment: 'left'}, initialWidth:89},
            {label: 'Last Name', fieldName: 'CensusId__c', type: 'url', typeAttributes: {label: {fieldName: 'Last_Name__c'}, disabled: {fieldName: 'Last_Name__c'}, target: '_blank'}, initialWidth:95},
            {label: 'First Name', fieldName: 'First_Name__c', type: 'text',cellAttributes: {alignment: 'left'}, initialWidth:102},
            {label: 'DOB', fieldName: 'Date_of_Birth__c', type: 'date-local', Strong:'true', cellAttributes: {alignment: 'left'}, typeAttributes:{year:'numeric', month:'2-digit', day:'2-digit'}, initialWidth:115},
            {label: 'Age', fieldName: 'Age_New__c', type: 'number',cellAttributes: { alignment: 'left' }, initialWidth:75},
            {label: 'Gender', fieldName: 'Gender__c', type: 'picklist',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Relationship', fieldName: 'Relationship__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Zip Code', fieldName: 'Zip_Code__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:85},
            {label: 'State', fieldName: 'State__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:81},
            {label: 'Tobacco', fieldName: 'Tobacco_Y_N__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:91},
            {label: 'Health Tier', fieldName: 'Health_Tier__c', type: 'text', initialWidth:120},
            {label: 'Health Plan Id', fieldName: 'Health_Plan_ID__c', type: 'text', initialWidth:120},
            {label: 'Group #', fieldName: 'Health_Group_Number__c', type: 'text', initialWidth:117},
            {label: 'Group Section #', fieldName: 'Health_Group_Section__c', type: 'text', initialWidth:117},
            {label: 'Cobra', fieldName: 'COBRA__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:100},
            {label: 'State Continuation', fieldName: 'State_Continuation__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:124},
            {label: 'Medicare Primary', fieldName: 'medicareYesNo',type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:128},
            {label: 'Retiree', fieldName: 'Retiree__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:111},
            {label: 'Created Date', fieldName: 'Created_Date_only__c', type: 'Date',cellAttributes: { alignment: 'left' }, initialWidth:150},
            {label: 'Created By', fieldName: 'CreatedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified By', fieldName: 'LastModifiedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified Date', fieldName: 'Last_Modify_Date_Only__c', type: 'text', initialWidth:150}
        ];
    },

    dentalColumns : function(component) {
        var editCapabilitiesMap = component.get("v.editCapabilitiesMap");
        var isDisabled = editCapabilitiesMap["Dental"];
        return [
            {label: '', type: 'button-icon', typeAttributes: {iconName: 'utility:new', name: 'new_record', title: 'Add Dependent', variant: 'border-filled', alternativeText: 'new', disabled: {fieldName:'isActive'}, iconPosition: 'left'}, fixedWidth:55},
            {label: 'Edit', type: 'button-icon', typeAttributes: {iconName: 'utility:edit', name: 'edit_record', title: 'Edit Row', variant: 'border-filled', alternativeText: 'edit', disabled: isDisabled, iconPosition: 'left'}, fixedWidth:60},
            {label: 'Sub#', fieldName: 'Row__c', type: 'text', Strong:'true',cellAttributes: {alignment: 'left'}, initialWidth:89},
            {label: 'Last Name', fieldName: 'CensusId__c', type: 'url', typeAttributes: {label: {fieldName: 'Last_Name__c'}, disabled: {fieldName: 'Last_Name__c'}, target: '_blank'}, initialWidth:95},
            {label: 'First Name', fieldName: 'First_Name__c', type: 'text',cellAttributes: {alignment: 'left'}, initialWidth:102},
            {label: 'DOB', fieldName: 'Date_of_Birth__c', type: 'date-local', Strong:'true', cellAttributes: {alignment: 'left'}, typeAttributes:{year:'numeric', month:'2-digit', day:'2-digit'}, initialWidth:115},
            {label: 'Age', fieldName: 'Age_New__c', type: 'number',cellAttributes: { alignment: 'left' }, initialWidth:75},
            {label: 'Gender', fieldName: 'Gender__c', type: 'picklist',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Relationship', fieldName: 'Relationship__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Zip Code', fieldName: 'Zip_Code__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:85},
            {label: 'State', fieldName: 'State__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:81},
            {label: 'Tobacco', fieldName: 'Tobacco_Y_N__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:91},
            {label: 'Dental Tier', fieldName: 'Dental_Tier__c', type: 'text', initialWidth:120},
            {label: 'Dental Plan Id', fieldName: 'Dental_Plan_ID__c', type: 'text', initialWidth:120},
            {label: 'Group #', fieldName: 'Dental_Group_Number__c', type: 'text', initialWidth:117},
            {label: 'Group Section #', fieldName: 'Dental_Group_Section__c', type: 'text', initialWidth:117},
            {label: 'Cobra', fieldName: 'COBRA__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:100},
            {label: 'State Continuation', fieldName: 'State_Continuation__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:124},
            {label: 'Medicare Primary', fieldName: 'medicareYesNo',type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:128},
            {label: 'Retiree', fieldName: 'Retiree__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:111},
            {label: 'Created Date', fieldName: 'Created_Date_only__c', type: 'Date',cellAttributes: { alignment: 'left' }, initialWidth:150},
            {label: 'Created By', fieldName: 'CreatedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified By', fieldName: 'LastModifiedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified Date', fieldName: 'Last_Modify_Date_Only__c', type: 'text', initialWidth:150}
        ];
    },

    visionColumns : function(component) {
        var editCapabilitiesMap = component.get("v.editCapabilitiesMap");
        var isDisabled = editCapabilitiesMap["Vision"];
        return [
            {label: '', type: 'button-icon', typeAttributes: {iconName: 'utility:new', name: 'new_record', title: 'Add Dependent', variant: 'border-filled', alternativeText: 'new', disabled: {fieldName:'isActive'}, iconPosition: 'left'}, fixedWidth:55},
            {label: 'Edit', type: 'button-icon', typeAttributes: {iconName: 'utility:edit', name: 'edit_record', title: 'Edit Row', variant: 'border-filled', alternativeText: 'edit', disabled: isDisabled, iconPosition: 'left'}, fixedWidth:60},
            {label: 'Sub#', fieldName: 'Row__c', type: 'text', Strong:'true',cellAttributes: {alignment: 'left'}, initialWidth:89},
            {label: 'Last Name', fieldName: 'CensusId__c', type: 'url', typeAttributes: {label: {fieldName: 'Last_Name__c'}, disabled: {fieldName: 'Last_Name__c'}, target: '_blank'}, initialWidth:95},
            {label: 'First Name', fieldName: 'First_Name__c', type: 'text',cellAttributes: {alignment: 'left'}, initialWidth:102},
            {label: 'DOB', fieldName: 'Date_of_Birth__c', type: 'date-local', Strong:'true', cellAttributes: {alignment: 'left'}, typeAttributes:{year:'numeric', month:'2-digit', day:'2-digit'}, initialWidth:115},
            {label: 'Age', fieldName: 'Age_New__c', type: 'number',cellAttributes: { alignment: 'left' }, initialWidth:75},
            {label: 'Gender', fieldName: 'Gender__c', type: 'picklist',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Relationship', fieldName: 'Relationship__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Zip Code', fieldName: 'Zip_Code__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:85},
            {label: 'State', fieldName: 'State__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:81},
            {label: 'Tobacco', fieldName: 'Tobacco_Y_N__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:91},
            {label: 'Vision Tier', fieldName: 'Vision_Tier__c', type: 'text', initialWidth:120},
            {label: 'Vision Plan Id', fieldName: 'Vision_Plan_ID__c', type: 'text', initialWidth:120},
            {label: 'Group #', fieldName: 'Vision_Group_Number__c', type: 'text', initialWidth:117},
            {label: 'Group Section #', fieldName: 'Vision_Group_Section__c', type: 'text', initialWidth:117},
            {label: 'Cobra', fieldName: 'COBRA__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:100},
            {label: 'State Continuation', fieldName: 'State_Continuation__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:124},
            {label: 'Medicare Primary', fieldName: 'medicareYesNo',type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:128},
            {label: 'Retiree', fieldName: 'Retiree__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:111},
            {label: 'Created Date', fieldName: 'Created_Date_only__c', type: 'Date',cellAttributes: { alignment: 'left' }, initialWidth:150},
            {label: 'Created By', fieldName: 'CreatedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified By', fieldName: 'LastModifiedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified Date', fieldName: 'Last_Modify_Date_Only__c', type: 'text', initialWidth:150}
        ];
    },

    renderTab: function (component, tabId) {
        var helper = this;
        var attrs = {};
        console.log("tabId = " + tabId);
        component.set("v.currentTabId", tabId);
        var formattedCensusData = component.get("v.formattedCensusData");
        attrs["aura:id"] = tabId + "Id";
        attrs["columns"] = helper.makeColumns(component, tabId);
        attrs["data"] = formattedCensusData[tabId];
        attrs["hideCheckboxCol"] = (tabId === "vision");
        attrs["deleteDisabled"] = component.get("v.deleteDisabled");
        attrs["showActionButtons"] = !(tabId === "vision");
        attrs['tableMsg'] = (tabId === "vision" ? "Vision Coverage can not be deleted without deleting Health Coverage.  If you delete the Health Coverage, Vision Coverage (if it exist) will also be deleted." : "");
        console.log("attrs = " + JSON.stringify(attrs));
        helper.injectTableComp(component.find(tabId), attrs);
    },

    injectTableComp: function (target, attrs) {
        $A.createComponent("c:SGR_CensusTable", attrs, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    },

    createModalComponents: function (component, eventData) {
        var helper = this;
        if(eventData.handlerName === "addSubscriber"){
            return [
                ["c:SGR_CensusAddEditHeader",{"title" : "Add New Subscriber"}],
                ["c:SGR_CensusAddEditModal", {"tabId" : component.get("v.currentTabId"), "mode" : "add", "memberType" : "subscriber", "oppRecord" : component.get("v.recordOpp"), "planDataList" : component.get("v.planDataList")}],
                ["c:SGR_CensusAddEditFooter",{}]
            ];
        }else if(eventData.handlerName === "handleRowAction"){
            if(eventData.actionName === "new_record"){
                return [
                    ["c:SGR_CensusAddEditHeader",{"title" : "Add New Dependant"}],
                    ["c:SGR_CensusAddEditModal", {"tabId" : component.get("v.currentTabId"), "mode" : "add", "memberType" : "dependant", "oppRecord" : component.get("v.recordOpp"), "planDataList" : component.get("v.planDataList"), "parentCensusRecord" : eventData.row, "allCensusList" : component.get("v.censusList")}],
                    ["c:SGR_CensusAddEditFooter",{}]
                ];
            }else if(eventData.row.Relationship__c === "Subscriber"){
                return [
                    ["c:SGR_CensusAddEditHeader",{"title" : "Edit Subscriber"}],
                    ["c:SGR_CensusAddEditModal", {"tabId" : component.get("v.currentTabId"), "mode" : "edit", "memberType" : "subscriber", "oppRecord" : component.get("v.recordOpp"), "planDataList" : component.get("v.planDataList"), "censusRecord" : eventData.row, "allCensusList" : component.get("v.censusList")}],
                    ["c:SGR_CensusAddEditFooter",{}]
                ];
            }else{
                var parentCensus = helper.extractParentRecord(component, eventData.row);
                console.log("SGR_CensusWidgetHelper:createModalComponents: parentCensus = " + JSON.stringify(parentCensus));
                return [
                    ["c:SGR_CensusAddEditHeader",{"title" : "Edit Dependant"}],
                    ["c:SGR_CensusAddEditModal", {"tabId" : component.get("v.currentTabId"), "mode" : "edit", "memberType" : "dependant", "oppRecord" : component.get("v.recordOpp"), "planDataList" : component.get("v.planDataList"), "censusRecord" : eventData.row, "parentCensusRecord" : parentCensus, "allCensusList" : component.get("v.censusList")}],
                    ["c:SGR_CensusAddEditFooter",{}]
                ];
            }
        }

    },

    extractParentRecord: function (component, depRow) {
        var censusList = component.get("v.censusList");
        for(var i = 0; i < censusList.length; i++){
            if(censusList[i].Subscriber_Number__c === depRow.Subscriber_Number__c && censusList[i].Relationship__c === "Subscriber"){
                return censusList[i];
            }
        }
        return null;
    },

    createAddEditModal: function(component, eventData) {
        var helper = this;
        var modalHeader;
        var modalBody;
        var modalFooter;
        console.log("SGR_CensusWidgetHelper:createAddEditModal: enter");
        var compList = helper.createModalComponents(component, eventData);
        $A.createComponents(compList,
            function(components, status){
                console.log("SGR_CensusWidgetHelper:createAddEditModal: status = " + status);
                if (status === "SUCCESS") {
                    modalHeader = components[0];
                    modalBody = components[1];
                    modalFooter = components[2];
                    component.find('overlayLib').showCustomModal({
                        header: modalHeader,
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: true,
                        cssClass: "modal-styley cSGR_CensusWidget slds-modal_medium",
                        closeCallback: function() {
                            console.log("SGR_CensusWidgetHelper:createAddEditModal: closed");

                        }
                    }).then(function (overlay) {
                    });
                }
            }
        );
    },

    makeToast : function(component, toastPkg) {
        component.find('notifLib').showToast(toastPkg);
    },

    deleteCensus : function(component, planType){
        var action=component.get("c.deleteOptyCensus");
        console.log(component.get("v.selectedIds"));
        action.setParams({
            "optyCensusIds":component.get("v.selectedIds"),
            "planType":planType
        });
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state==='SUCCESS'){

                console.log(response.getReturnValue());
                var resVal = response.getReturnValue();
                if('Warning' in resVal){
                    var message = resVal['Warning'];
                    var type = 'Warning';
                }
                else if('Error' in resVal){
                    var message = resVal['Error'];
                    var type = 'Error';
                }
                else if('Success' in resVal){
                    var message = resVal['Success'];
                    var type = 'Success';
                    $A.get('e.force:refreshView').fire();
                    //helper.refreshCensus(component, event, helper);
                    //lightningEvent.fire();
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: message,//'Show',
                    duration:'5000',
                    //key: 'info_alt',
                    type: type,
                    //mode: 'sticky'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        //helper.refreshParent(component, event, helper);
    }
})