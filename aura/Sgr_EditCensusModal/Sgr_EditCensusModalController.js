({
	myAction : function(component, event, helper) {
		
	},
    editEventHandler : function(component,event,helper){
        var message = event.getParam("OptyCensus");
        var tab = event.getParam("tabName");
        component.set("v.tabName",tab);
        component.set("v.CensusRecord",message); 
        if(component.get("v.CensusRecord.Relationship__c")=='Subscriber'){
            var action = component.get("c.getPlanIds");
            action.setParams({
                "oppId":component.get("v.CensusRecord.Opportunity__c")
            });
            action.setCallback(this,function(response){
                var state=response.getState();
                var planList = [];
                if(state==='SUCCESS'){
                    var mapVal = response.getReturnValue();
                    for(var key in mapVal){
                        if(component.get("v.tabName")=='Health' && key=='H'){
                            planList.push(mapVal[key]);
                        }
                        if(component.get("v.tabName")=='Dental' && key=='D'){
                            planList.push(mapVal[key]);
                        }
                        if(component.get("v.tabName")=='Vision' && key=='V'){
                            planList.push(mapVal[key]);
                        }
                    }
                    component.set("v.plans",planList);
                }
            });
            $A.enqueueAction(action);
        }else{
            var action = component.get("c.getRelationShip");
            action.setParams({
                "oppId":component.get("v.CensusRecord.Opportunity__c"),
                "currentPlanId":component.get("v.CensusRecord.Relationship__c")
            });
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state==='SUCCESS'){
                    component.set("v.relations",response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },
    handleCancel : function(component,event,helper){
    	//component.destroy();
    	//$A.get('e.force:refreshView').fire();
    	//window.close();
    	component.set("v.CensusRecord",null);
    	var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
        compEvent.setParams({
            "Confirmed" : false
        });
        compEvent.fire();
    },
    handleOnload : function(component, event, helper) {
        var parentId = component.get("v.CensusRecord");
        if(parentId!=null){
            /*var action = component.get("c.setGroupSection");
            action.setParams({
                "sectionNum":component.get("v.CensusRecord.Opportunity_Group_Section__c")
            });
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state==='SUCCESS'){
                    component.set("v.groupSectionSelected",response.getReturnValue());
                }
            });
            $A.enqueueAction(action);*/
        }
        //component.find("lastName").set("v.value", "Accounting");*/
    },
    handleOnSubmit : function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam("fields");
        //alert(fields.Date_of_Birth__c);
        fields["Id"] = component.get("v.CensusRecord.Id");
        fields["Group_Number__c"] = component.get("v.CensusRecord.Group_Number__c");
        fields["Relationship__c"] = component.get("v.CensusRecord.Relationship__c");
        fields["Employee_Status_Code__c"] = component.get("v.CensusRecord.Employee_Status_Code__c");
        if(component.get("v.groupSectionId")!='' && component.get("v.groupSectionId")!=null && component.get("v.groupSectionId")!=undefined){
           fields["Opportunity_Group_Section__c"] = component.get("v.groupSectionId");
        }
        if(component.get("v.tabName")=='Health'){
            fields["Health_Plan_ID__c"] = component.get("v.planSelected");
        }else if(component.get("v.tabName")=='Dental'){
            fields["Dental_Plan_ID__c"] = component.get("v.planSelected");
        }else if(component.get("v.tabName")=='Vision'){
            fields["Vision_Plan_ID__c"] = component.get("v.planSelected");
        }
        if((fields.Date_of_Birth__c==undefined || fields.Date_of_Birth__c=='' || fields.Date_of_Birth__c==null) && (fields.Age_New__c==undefined || fields.Age_New__c=='' || fields.Age_New__c==null )){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": "Either one of Date of Birth or Age must be entered",
                "type": "error",
                "mode": "sticky",
                "duration": "500"
            });
            toastEvent.fire();
        }else{
            component.find("form").submit(fields);
            var action = component.get("c.saveOptyCensus");
        	action.setParams({
            'OptyCensusList':fields,
            'tabName':component.get("v.tabName"),
            'opptyId':component.get("v.CensusRecord.Opportunity__c")
            });
            action.setCallback(this,function(response){
            	if(response.getState() === "SUCCESS"){
                }
            });
            $A.enqueueAction(action);
        }
    },
    getgroupData : function(component, event, helper) {
        var planValueEvent = component.getEvent("planIdValueEvent");
        planValueEvent.setParam("planID",component.get("v.planSelected"));
        planValueEvent.fire();
    },
    handlePlanIdEvent : function(component, event, helper) {
        var planID = event.getParam("planID"); 
        var action = component.get("c.getgroupSection");
        action.setParams({
            "oppId":component.get("v.CensusRecord.Opportunity__c"),
            "planId":planID
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var gsList = response.getReturnValue();
                var groupNumberList=[];
                var groupSectionList=[];
                for(var i=0;i<gsList.length;i++){
                	if(gsList[i].Opportunity_Group_Number__c!=null){
                    	groupNumberList.push(gsList[i].Opportunity_Group_Number__c );
                    }
                    if(gsList[i].Opportunity_Group_Section_Number__c!=null){
                     	groupSectionList.push(gsList[i].Opportunity_Group_Section_Number__c);
                    }
                }
                component.set("v.groupNumbers",groupNumberList);
                component.set("v.groupSectionNumbers",groupSectionList);
            }
        });
        $A.enqueueAction(action);
    },
    doSectionNum : function(component,event,helper){
        var action = component.get("c.setGroupSection");
        action.setParams({
            "sectionNum":component.get("v.groupSectionSelected")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                component.set("v.groupSectionId",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    handleOnSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": "Success! Record has been saved successfully.",
            "type": "success",
            "mode": "sticky",
            "duration": "500"
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
    }
})