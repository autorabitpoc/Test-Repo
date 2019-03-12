/* 
 * Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 03/20/2018
 * Modified date: 04/13/2018
 * Discription :Client side controller naviagation and sorting(Insatallation(GEMS), SAM REquests)
*/
({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.loadViewAllCasesGems");
        var recId = component.get("v.rID");
        var objectType = component.get("v.objectType");
        action.setParams({
            objectType:objectType,
            recordId:recId 
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.Cases",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        //SAM Cases
        var recId = component.get("v.rID");
        var actionSamAll = component.get("c.loadViewAllCasesSamRequest");
        actionSamAll.setParams({
            objectType:objectType,
            recordId:recId 
        });
        actionSamAll.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.SamCases",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(actionSamAll);
        
        
    },
    navigateToRecordPage : function (component, event, helper) {
        var recId = component.get("v.rID");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
        });
        navEvt.fire();
    },
    gemOrderByRecordType : function (component, event, helper) {
        var action = component.get("c.getGemCaseFilteredByRecType");
        var recId = component.get("v.rID");
        action.setParams({
            opId:recId 
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.Cases",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    samOrderByRecordType : function (component, event, helper) {
        var action = component.get("c.getSamCaseFilteredByRecType");
        var recId = component.get("v.rID");
        action.setParams({
            opId:recId 
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.SamCases",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    tabSelected: function(component, event, helper) {
        var tab = component.get("v.key");
    },
    
    sortByCaseNumber: function(component, event, helper) {
        var tab = component.get("v.key");
        var currentOrder = component.get("v.sortAsc");
        if(tab == "one"){
            var  currentList = component.get("v.Cases");
        }
        else{
            var  currentList = component.get("v.SamCases");
        }
        
        currentOrder = !currentOrder;
        currentList.sort(function(a,b) {
            var t1 = a.CaseNumber == b.CaseNumber, t2 = a.CaseNumber < b.CaseNumber;
            return t1? 0: (currentOrder?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", currentOrder);
        if(tab == "one"){
            component.set("v.Cases", currentList);
        }
        else{
            component.set("v.SamCases", currentList);
        }
    },
    
    sortByCaseSubject: function(component, event, helper) {
        
        var tab = component.get("v.key");
        var currentOrder = component.get("v.sortAsc");
        if(tab == "one"){
            var  currentList = component.get("v.Cases");
        }
        else{
            var  currentList = component.get("v.SamCases");
        }
        currentOrder = !currentOrder;
        currentList.sort(function(a,b) {
            var t1 = a.Subject == b.Subject, t2 = a.Subject < b.Subject;
            return t1? 0: (currentOrder?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", currentOrder);
        if(tab == "one"){
            component.set("v.Cases", currentList);
        }
        else{
            component.set("v.SamCases", currentList);
        }
    },
    sortByCaseStatus: function(component, event, helper) {
        var tab = component.get("v.key");
        var currentOrder = component.get("v.sortAsc");
        if(tab == "one"){
            var currentList = component.get("v.Cases");
        }else{
            var currentList = component.get("v.SamCases");
        }        
        currentOrder = !currentOrder;
        currentList.sort(function(a,b) {
            var t1 = a.Status == b.Status, t2 = a.Status < b.Status;
            return t1? 0: (currentOrder?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", currentOrder);
        if(tab == "one"){
            component.set("v.Cases", currentList);
        }
        else{
            component.set("v.SamCases", currentList);
        }    
    },
    sortByCaseOwner: function(component, event, helper) {
        var tab = component.get("v.key");
        var currentOrder = component.get("v.sortAsc");
        if(tab == "one"){
            var currentList = component.get("v.Cases");
        }else{
            var currentList = component.get("v.SamCases");
            
        } 
        currentOrder = !currentOrder;
        currentList.sort(function(a,b) {
            var t1 = a.Owner.Name == b.Owner.Name, t2 = a.Owner.Name < b.Owner.Name;
            return t1? 0: (currentOrder?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", currentOrder);
        if(tab == "one"){
            component.set("v.Cases", currentList);
        }
        else{
            component.set("v.SamCases", currentList);
            
        }     
    },
    sortByCaseRecordType: function(component, event, helper) {
        var tab = component.get("v.key");
        var currentOrder = component.get("v.sortAsc");
        if(tab == "one"){
            var currentList = component.get("v.Cases");
        }else{
            var currentList = component.get("v.SamCases");
            
        } 
        currentOrder = !currentOrder;
        currentList.sort(function(a,b) {
            var t1 = a.RecordType.Name == b.RecordType.Name, t2 = a.RecordType.Name < b.RecordType.Name;
            return t1? 0: (currentOrder?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", currentOrder);
        if(tab == "one"){
            component.set("v.Cases", currentList);
        }
        else{
            component.set("v.SamCases", currentList);
        }       
    },
    sortByCaseCreatedDate: function(component, event, helper) {
        var tab = component.get("v.key");
        var currentOrder = component.get("v.sortAsc");
        if(tab == "one"){
            var currentList = component.get("v.Cases");
        }else{
            var currentList = component.get("v.SamCases");
        }
        currentOrder = !currentOrder;
        currentList.sort(function(a,b) {
            var t1 = a.CreatedDate == b.CreatedDate, t2 = a.CreatedDate < b.CreatedDate;
            return t1? 0: (currentOrder?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", currentOrder);
        if(tab == "one"){
            component.set("v.Cases", currentList);
        }
        else{
            component.set("v.SamCases", currentList);
        }  
    },
    searchGemCase: function(component, event, helper) {
        var searchItem = component.get("v.keyword");
        var objectType = component.get("v.objectType");
        var gemSearch = component.get("c.searchGems");
        var recId = component.get("v.rID");
        gemSearch.setParams({
            objectType:objectType,
            recordId:recId,
            key:searchItem
            
        });
        
        gemSearch.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.Cases",response.getReturnValue());
            }
            });
        
        $A.enqueueAction(gemSearch);
        
        
    },
    searchSamRequestCase: function(component, event, helper) {
        var searchItem = component.get("v.samkeyword");
        var samSearch = component.get("c.searchSamRequest");
        var recId = component.get("v.rID");
        var objectType = component.get("v.objectType");
        samSearch.setParams({
            objectType:objectType,
            recordId:recId,
            key:searchItem
            
        });
        
        samSearch.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.SamCases",response.getReturnValue());
            }
            });
        
        $A.enqueueAction(samSearch);
        
        
    },
    
    goToParentRecord : function(component, event, helper) {
		var recId = component.get("v.rID");
        var redirectRecordPage = $A.get("e.force:navigateToSObject");
        redirectRecordPage.setParams({
             "recordId": recId
       });
        redirectRecordPage.fire();
	},
    goToParentHomePage : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var objectType = component.get("v.objectType");
        if(objectType == "Opportunity"){
            urlEvent.setParams({
            "url": "/006/o"
            });
        }
        else{
            urlEvent.setParams({
            "url": "/001/o"
            });
            
        }
    urlEvent.fire();
	},
    showdialog: function(component, event, helper) {
        component.set("v.del",true);
        var rId = event.getParam("rId");
        component.set("v.currentRecordId",rId);
        
    },
    closeDialog: function(component,event,helper){
    	component.set("v.del",false);
    
	},
    cancelDialog: function(component,event,helper){
       component.set("v.del",false);
    },
    deleteRecord:function(component,event,helper){
       var curRec = component.get("v.currentRecordId");
        var delAction = component.get("c.deleteCaseRecord");
        delAction.setParams({
            
            caseId :curRec
        });
        delAction.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                
                var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
        		"title": "Success!",
        		"message": "The record has been Deleted successfully."
    			});
    			toastEvent.fire();
                
                component.set("v.del",false);
                var searchItem = component.get("v.keyword");
                var searchSamItem = component.get("v.samkeyword");

                if(searchItem!=null){
                	component.searchGemMethod();
                }
                else if(searchSamItem!=null){
                    component.searchSamMethod();
                }
                else{
                	component.initMethod();
                }
            }
            
        });
        $A.enqueueAction(delAction);
        
    }

    
})