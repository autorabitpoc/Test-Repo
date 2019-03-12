({
	myAction : function(component, event, helper) {
		
	},
    doInit : function(component, event, helper) {
		if(component.get("v.typ")=='Plan'){
            if(component.get("v.CensusList.Relationship__c")=='Subscriber'){
                var action = component.get("c.getPlanIds");
                action.setParams({
                    "oppId":component.get("v.oppId")
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
            }
        }
        if(component.get("v.typ")=='GrpSection' || component.get("v.typ")=='GrpNumber'){
            if(component.get("v.CensusList.Relationship__c")=='Subscriber'){
                var action = component.get("c.getgroupSection");
                action.setParams({
                    "oppId":component.get("v.oppId"),
                    "planId":component.get("v.planID")
                });
                action.setCallback(this,function(response){
                    var state=response.getState();
                    if(state==='SUCCESS'){
                        var gsList = response.getReturnValue();
                        var groupNumberList=[];
                        var groupSectionList=[];
                        for(var i=0;i<gsList.length;i++){
                            if(gsList[i].Opportunity_Group_Number__c!=null){
                                groupNumberList.push(gsList[i].Opportunity_Group_Number__c);
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
        	}
		}
        if(component.get("v.typ")=='Relationship'){
            var action = component.get("c.getRelationShip");
            action.setParams({
                "oppId":component.get("v.oppId"),
                "currentPlanId":component.get("v.currentPlanId")
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
    handleCancel : function(component){
        var btnVisibility = component.get("v.isDisabled");
        btnVisibility.modalDisabled = 'slds-hide';
        component.set("v.isDisabled",btnVisibility);
        window.history.back();
    },
    handleSave : function(component,event,helper){
        if(component.get("v.typ")=='Plan' || component.get("v.typ")=='GrpNumber'){
            if(component.get("v.CensusList.Relationship__c")=='Subscriber'){
                if(component.get("v.tabName")=='Health'){
                component.set("v.CensusList.Health_Plan_ID__c",component.get("v.healthPlanSelected"));
                }
                if(component.get("v.tabName")=='Dental'){
                    component.set("v.CensusList.Dental_Plan_ID__c",component.get("v.healthPlanSelected"));
                }
                if(component.get("v.tabName")=='Vision'){
                    component.set("v.CensusList.Vision_Plan_ID__c",component.get("v.healthPlanSelected"));
                }
                var action = component.get("c.saveCensus");
                action.setParams({
                    "OptyCensusList":component.get("v.CensusList")
                });
                action.setCallback(this,function(response){
                });
                $A.enqueueAction(action);
            }
        }
        if(component.get("v.typ")=='GrpSection'){
            if(component.get("v.CensusList.Relationship__c")=='Subscriber'){
                var actionSC = component.get("c.setGroupSectionID");
                actionSC.setParams({
                    "sectionNum":component.get("v.groupSectionSelected"),
                    "censusList":component.get("v.CensusList.Id")
                });
                actionSC.setCallback(this,function(response){
                });
                $A.enqueueAction(actionSC);
            }
        }
        if(component.get("v.typ")=='Relationship'){
            var action = component.get("c.saveOptyCensus");
            var censusList = [];
            censusList.push(component.get("v.CensusList"));
            action.setParams({
                'OptyCensusList':censusList,
                'tabName':component.get("v.tabName"),
                'opptyId':component.get("v.oppId")
            });
            action.setCallback(this,function(response){
            });
            $A.get('e.force:refreshView').fire();
            $A.enqueueAction(action);
        }
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.oppId")
        });
        navEvt.fire();
    }
})