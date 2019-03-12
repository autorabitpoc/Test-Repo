/* 
 * Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 03/24/2018
 * Discription : Client side to Redirect the Insatallation(GEMS), SAM Request Tabs 
*/

({
    doInit : function(component, event, helper) {
        var objectType = component.get("v.sObjectName");
        var action = component.get("c.loadInitialCasesGems");
        var recId = component.get("v.recordId");
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
        /* SAM Records */
        var actionSam = component.get("c.loadInitialCasesSamRequest");
        var recId = component.get("v.recordId");
        actionSam.setParams({
            objectType:objectType,
            recordId:recId 
        });
        actionSam.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.SamCases",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(actionSam);
        var getcaseList = component.get("c.totalcaseList");
        getcaseList.setParams({
            objectType:objectType,
            recordId : component.get("v.recordId") 
        });
        getcaseList.setCallback(this, function(a) {
            component.set("v.caseList", a.getReturnValue());
        });
        $A.enqueueAction(getcaseList);
    },
    /*navigatetab1 : function(component, event, helper) {
     
        var tabval = component.get("v.keytab1");
        helper.navigateToAllCase(component,event,tabval);
	},
    navigatetab2 : function(component,event,helper){
    	
    	var tabval = component.get("v.keytab2");
    	helper.navigateToAllCase(component,event,tabval);
	},*/
    /* selectTab : function(component, event, helper) { 
        
        //alert("=hello=");
        var tabval = component.get("v.key");
        alert("=tabval="+tabval);
        component.find("tabs").set("v.selectedTabId",tabval);
        //helper.navigateToAllCase(component,event,tabval);
    }, */
    
    navigateToSelectedTab : function(component,event,helper){
        var tabval = component.get("v.key");
        component.find("tabs").set("v.selectedTabId",tabval);
        helper.navigateToAllCase(component,event,tabval);
        
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
                component.initMethod();
            }
        });
        $A.enqueueAction(delAction);
        
    }
    
    
})