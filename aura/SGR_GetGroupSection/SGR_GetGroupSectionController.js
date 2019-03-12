({
    doInit: function (component, event, helper) {
        component.set("v.columns", [
            {label: 'Group Number', fieldName: 'Group_Name__c', type: 'text', sortable: 'true'},
            {
                label: 'Effective Date',
                fieldName: 'Group_Section_Original_Effective_Date__c',
                type: 'text',
                sortable: 'true'
            },
            {label: 'Status', fieldName: 'Status__c', type: 'text', sortable: 'true'},
            {label: 'Cancel Date', fieldName: 'Group_Section_Cancel_Date__c', type: 'text', sortable: 'true'},
            {
                label: 'Section Number',
                fieldName: 'Opportunity_Group_Section_Number__c',
                type: 'text',
                cellAttributes: {alignment: 'left'},
                sortable: 'true'
            },
            {
                label: 'Cancel Code ',
                fieldName: 'Group_Section_Cancel_Code__c',
                type: 'text',
                cellAttributes: {alignment: 'left'},
                sortable: 'true'
            }
        ]);

        //helper.getRelatedGSList(component); 

    },

    sortRow: function (component, event, helper) {

        var fieldName = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");

        console.log('sort dir from event:' + sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    }
})