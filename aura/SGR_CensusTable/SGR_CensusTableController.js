({
    init: function (component, event, helper) {
        var displayData = helper.filterData(component.get("v.data"));
        component.set("v.displayData", displayData);
        helper.setTotals(component);
    },

    handleRowAction: function (component, event, helper) {
        var eventData = {};
        eventData.handlerName = "handleRowAction";
        var action = event.getParam('action');
        eventData.actionName = action.name;
        eventData.row = event.getParam('row');
        helper.fireEvent(component, eventData);
    },

    handleRowSelection: function (component, event, helper) {
        var eventData = {};
        eventData.handlerName = "handleRowSelection";
        eventData.selectedRows = event.getParam('selectedRows');
        helper.fireEvent(component, eventData);
    },

    showSubOnly: function (component, event, helper) {
        var displayData = helper.filterData(component.get("v.data"));
        component.set("v.displayData", displayData);
        helper.setTotals(component);
    },

    showAll: function (component, event, helper) {
        var displayData = component.get("v.data");
        component.set("v.displayData", displayData);
        helper.setTotals(component);
    },

    addSubscriber: function (component, event, helper) {
        var eventData = {};
        eventData.handlerName = "addSubscriber";
        helper.fireEvent(component, eventData);
    },

    deleteRows: function (component, event, helper) {
        var eventData = {};
        eventData.handlerName = "delete";
        helper.fireEvent(component, eventData);
    }
})