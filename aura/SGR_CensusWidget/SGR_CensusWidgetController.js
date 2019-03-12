({
    init: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        if(recordId !== null && typeof recordId !== "undefined" && recordId.length > 0){
            helper.initializeData(component, false);
        }
    },

    onTabActive: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        if(recordId !== null && typeof recordId !== "undefined" && recordId.length > 0){
            var tab = event.getSource();
            var tabId = tab.get("v.id");
            helper.renderTab(component, tabId);
        }
    },

    handleTableAction: function (component, event, helper) {
        var data = event.getParam("data");
        console.log("data = " + JSON.stringify(data));

        if(data.handlerName === "handleRowSelection") {
            var selectedRows = data.selectedRows;
            helper.mapSelectedRows(component, selectedRows);
        }else if(data.handlerName === "delete"){
            var selectedIds = component.get("v.selectedIds");
            if(selectedIds.length > 0){
                console.log("currentTabId = " + component.get("v.currentTabId"));
                if(component.get("v.currentTabId") === "health"){
                    component.set("v.showPopup",true);
                    component.set("v.buttonName","HealthDelete");
                    component.set("v.headerTxt","Delete Confirmation");
                }else if(component.get("v.currentTabId") === "dental"){
                    component.set("v.showPopup",true);
                    component.set("v.buttonName","HandleDental");
                    component.set("v.headerTxt","Delete Confirmation");
                }
            }
        }else{
            helper.createAddEditModal(component, data);
        }
    },

    deleteHealthCensus : function(component, event, helper){
        console.log("deleteHealthCensus fire");
        helper.deleteCensus(component, "Health");
    },

    deleteDentalCensus : function(component, event, helper){
        console.log("deleteDentalCensus fire");
        helper.deleteCensus(component, "Dental");
    },

    handleModalEvent: function (component, event, helper) {
        var data = event.getParam("data");
        console.log("data = " + JSON.stringify(data));
        if(data.relayStage === "success"){
            $A.get("e.force:refreshView").fire();
            helper.initializeData(component, true);
        }
    }
})