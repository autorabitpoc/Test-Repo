({
    doInit : function(component, event, helper) {
        component.set("v.columns", [
            {label: 'Account Number', fieldName:'SGR_Account_Number__c', type:'text', sortable:'true'},
            {label: 'Opportunity ID', fieldName:'recId', type:'url', sortable:'true', target: '_blank',
             typeAttributes:{
                 label: {fieldName: 'Name'}
             } },
            {label: 'Renewal Effective Date', fieldName:'Renewal_Date__c', type:'text', sortable:'true'},
            {label: 'Account Name', fieldName:'AccountName', type:'text', sortable:'true'},            
            {label: 'Opportunity Type', fieldName:'RecordTypeName', type:'text', sortable:'true'},            
            {label: '# of Subscribers', fieldName:'Subscribers_Count__c', type:'number',cellAttributes: { alignment: 'left' }, sortable:'true'},
            {label: '# of Dental', fieldName:'Dental_Count__c', type:'number', cellAttributes: { alignment: 'left' },  sortable:'true'},
            {label: '# of Medical', fieldName:'Health_Count__c', type:'number', cellAttributes: { alignment: 'left' }, sortable:'true'},
            {label: 'Assigned Underwriter', fieldName:'AssignedUW', type:'text', sortable:'true'}
        ]);
        
        helper.getRelatedOpps(component, event, helper);
        helper.getRelatedOppsCount(component, event, helper); 
        helper.getGateStatus(component, event, helper);
        
    }, 
    getRelatedOpps: function(component, event, helper) {
        console.log('sort dir:'+component.get('v.sortDir'));
        
        helper.getRelatedOpps(component);
        
    },
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
        component.set("v.selectedopty",selectedRows);
        for(var i=0;i<selectedRows.length;i++){
            IdList.push(selectedRows[i].Id);
        }
        component.set("v.selectedIds",IdList);
    },
    handleSelectedOptys : function (component, event, helper) {
        component.set("v.ShowPopup",true);
        component.set("v.headerTxt","Change Status");
        component.set("v.buttonName","Release");
        var action = component.get("c.getSelectedOpty");
        action.setParams({
            Ids:component.get("v.selectedIds")
            
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.selectedRecords",response.getReturnValue());
                helper.getRelatedOpps(component, event, helper);
        		helper.getRelatedOppsCount(component, event, helper);
            }
        });
        $A.get('e.force:refreshView').fire();
        $A.enqueueAction(action);
    },
    
    handleGateStatus : function (component, event, helper) {
        //component.set("v.ShowPopup",true);
        //component.set("v.headerTxt","Change Status");
        //component.set("v.gatestatus","Release");
        var action = component.get("c.GateStatus");
        action.setParams({
            gateId:component.get("v.recordId")
            
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.gatestatus1",response.getReturnValue());
                //alert(component.get("v.gatestatus1"));
                helper.getRelatedOpps(component, event, helper);
                helper.getRelatedOppsCount(component, event, helper); 
                
            }});
        //SFDC-17611: placed call to refresh event after action is queued
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    
    UpdateStatus : function (component, event, helper) {
        //Alert('Enter LiftGate');
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
                    helper.getRelatedOpps(component, event, helper);
                    helper.getRelatedOppsCount(component, event, helper);
                    
                }
            });
            $A.get('e.force:refreshView').fire();
            $A.enqueueAction(action);
        }
         $A.get('e.force:refreshView').fire();
    },
    defaultCloseAction : function(component, event, helper) {
        component.set("v.ShowPopup",false);
        
    },
    UpdateShowPopup : function(component, event, helper) {
        //component.destroy();
        var showpopup = event.getParam("UpdateShowPopup");
        if(showpopup===true){component.set("v.ShowPopup",false);}
    },
    
    handleLiftSelectedOptys: function(component, event, helper){
        component.set("v.ShowPopup",true);
        component.set("v.buttonName","Lift");
        component.set("v.headerTxt","Gate Lift Confirmation");
        //component.set("v.selectedRowsCount",component.get("v.data").length);
        //alert(component.get("v.data").length);
    },
    
    handleLiftStatus : function(component,event,helper){
        component.set("v.ShowPopup",false);
        var confirmed = event.getParam("Confirmed");
        if(confirmed===true){
        var action=component.get("c.liftGate");
        var opportunityIds = component.get("v.selectedopty");
        action.setParams({        
            SelOptyRecords:component.get("v.recordId")
           
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==="SUCCESS"){
                component.set("v.gatestatus1",response.getReturnValue());
                //alert(component.get("v.gatestatus1"));
                // Added by Shankar to force list and count update
                helper.getRelatedOpps(component, event, helper);
                helper.getRelatedOppsCount(component, event, helper);
                var data = response.getReturnValue(); 
                
            }  
    });
    //SFDC-17611: placed call to refresh event after action is queued
    $A.enqueueAction(action);
    $A.get('e.force:refreshView').fire();
        }
         //$A.get('e.force:refreshView').fire();
    }
    
    
})