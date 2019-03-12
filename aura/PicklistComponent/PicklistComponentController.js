({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, component.get("v.objInfo"), component.get("v.fieldName"), 'ObjectField');
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        //alert(event.getSource().get("v.value"));
        component.set("v.selectedValue", event.getSource().get("v.value"));
    },
})