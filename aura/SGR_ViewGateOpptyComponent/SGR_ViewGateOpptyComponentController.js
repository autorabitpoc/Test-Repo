({
    doInit : function(component, event, helper) {
        component.set("v.columns", [
            {label: 'Account Number', fieldName:'AccountNum', type:'text', sortable:'true'},
            {label: 'Opportunity ID', fieldName:'Name', type:'text', sortable:'true'},
            {label: 'Renewal Effective Date', fieldName:'Renewal_Date__c', type:'text', sortable:'true'},
            {label: 'Account Name', fieldName:'AccountName', type:'text', sortable:'true'},
            {label: 'Opportunity Type', fieldName:'RecordTypeName', type:'text', sortable:'true'},            
            {label: '# of Subscribers', fieldName:'Subscribers_Count__c', type:'number',cellAttributes: { alignment: 'left' }, sortable:'true'},
            {label: '# of Dental', fieldName:'Health_Count__c', type:'number', cellAttributes: { alignment: 'left' },  sortable:'true'},
            {label: '# of Medical', fieldName:'Dental_Count__c', type:'number', cellAttributes: { alignment: 'left' }, sortable:'true'},
            {label: 'Assigned Underwriter', fieldName:'AssignedUW', type:'text', sortable:'true'}
        ]);
        
        helper.getRelatedOpps(component, event, helper);
        helper.getRelatedOppsCount(component, event, helper); 
        
    }, 
    /*getRelatedOpps: function(component, event, helper) {
        console.log('sort dir:'+component.get('v.sortDir'));
        
        helper.getRelatedOpps(component);
        
    },*/
    sortRows: function(component, event, helper) {
        
        var fieldName = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");

        console.log('sort dir from event:'+sortDirection);
        helper.sortData(component, fieldName, sortDirection);        
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", "true");
    },
    hideSpinner: function(component, event, helper) {
        component.set("v.spinner", "false");
    },
    updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        console.log('selectedRows--->'+JSON.stringify(selectedRows));
        component.set('v.selectedRowsCount', selectedRows.length);
        var IdList=[];
        for(var i=0;i<selectedRows.length;i++){
            IdList.push(selectedRows[i].Id);
        }
        component.set("v.selectedIds",IdList);
    },
    handleSelectedOptys : function (component, event, helper) {
        component.set("v.ShowPopup",true);
        var action = component.get("c.getSelectedOpty");
        action.setParams({
            Ids:component.get("v.selectedIds")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.selectedRecords",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    UpdateStatus : function (component, event, helper) {
        component.set("v.ShowPopup",false);
        var confirmed = event.getParam("Confirmed");
        if(confirmed===true){
        var action=component.get("c.processSelectedOptys");
        action.setParams({
            SelOptyRecords:component.get("v.selectedRecords")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                //this.doInit(component, event, helper);
                helper.getRelatedOpps(component, event, helper);
                helper.getRelatedOppsCount(component, event, helper);
                 var recordId = component.get( 'v.recordId' );

    var event = $A.get( 'e.force:navigateToSObject' );

                if ( event ) {
                    
                    // I never get here, the event isn't available
                    // from Visualforce context even though I'm rendering in LEX
                    
                    event.setParams({
                        'recordId' : recordId
                    }).fire();
                }
            }
        });$A.enqueueAction(action);
        }
    },
    defaultCloseAction : function(component, event, helper) {
        //component.destroy();
        component.set("v.ShowPopup",false);
    }
    
    
})