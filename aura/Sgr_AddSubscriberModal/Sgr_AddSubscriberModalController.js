({
    doInit : function(component, event, helper) {
        console.log("enter Sgr_AddSubscriberModalController")
        helper.getFieldsData(component,event,helper);
        var recordId = component.get("v.oppId");
        component.set("v.CensusRecord.Opportunity__c",recordId);
        var action = component.get("c.getStates");
        action.setParams({
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var stateMappping = response.getReturnValue();
                var stateList = [];
                for(var i=0;i<stateMappping.length;i++){
                    var row = stateMappping[i];
                    stateList.push(row.State_Code__c);
                }
                component.set("v.allStates",stateList);
            }
        });
        $A.enqueueAction(action);
        //alert(component.get("v.oppId"));
        var opps1 = component.get("c.CensuValidation");
        opps1.setParams({
            oppId : component.get("v.oppId")
        });
        opps1.setCallback(this,function(response){
            //alert(response.getState());
            if(response.getState() === "SUCCESS"){
                var temdiv = response.getReturnValue();
                component.set("v.NMString",temdiv);
                // alert(component.get("v.NMString")+'TEst');
            }
        });
        $A.enqueueAction(opps1); 
        if(component.get("v.context")=="Edit Census"){
            helper.hPlanEventHelper(component,event,helper,component.get("v.CensusRecord.Health_Plan_ID__c"));
            helper.dPlanEventHelper(component,event,helper,component.get("v.CensusRecord.Dental_Plan_ID__c"));
            if(component.get("v.Opportunity").HCSC_Division__c=='NM' || (component.get("v.Opportunity").HCSC_Division__c=='MT' && component.get("v.CensusRecord.Age_New__c")>=19)){
            	helper.vPlanEventHelper(component,event,helper,component.get("v.CensusRecord.Vision_Plan_ID__c"));
            }
        }
    },
    handleCancel : function(component){
        var btnVisibility = component.get("v.isDisabled");
        btnVisibility.modalDisabled = 'slds-hide';
        component.set("v.isDisabled",btnVisibility);
        
        window.history.back();
    },
    handleSavenew : function(component,event,helper){
        component.set("v.CensusValidation",false);
        var DI=component.get("c.handleSave");
        $A.enqueueAction(DI);
        
    },
    handleSaveRetire : function(component,event,helper){
        component.set("v.RetireValidation",false);
        var DI=component.get("c.handleSave");
        $A.enqueueAction(DI);
    },
    handleSave : function(component,event,helper){
        
        helper.SaveRecord(component,event,helper);
        var lightningEvent = $A.get("e.c:SGR_Census_Tab");
        lightningEvent.setParams({
            "message" : "An application event fired me." });
        lightningEvent.fire();  
    },
    handleChangeHealthPlan : function(component,event,helper){
        component.set("v.CensusRecord.Health_Group_Number__c",'');
        component.set("v.CensusRecord.Health_Group_Section__c",'');  
        helper.fireHPlanIdEvent(component,event,helper);
    },
    handleChangeDentalPlan : function(component,event,helper){
        component.set("v.CensusRecord.Dental_Group_Number__c",'');
        component.set("v.CensusRecord.Dental_Group_Section__c",'');
        helper.fireDPlanIdEvent(component,event,helper);
    },
    handleChangeVisionPlan : function(component,event,helper){
        component.set("v.CensusRecord.Vision_Group_Number__c",'');
        component.set("v.CensusRecord.Vision_Group_Section__c",'');
        helper.fireVPlanIdEvent(component,event,helper);
    },
    handleHPlanEvent : function(component,event,helper){
        var planID = event.getParam("HplanID");
        helper.hPlanEventHelper(component,event,helper,planID);
    },
    handleDPlanEvent : function(component,event,helper,planID){
        var planID = event.getParam("DplanID"); 
        helper.dPlanEventHelper(component,event,helper,planID);
    },
    handleVPlanEvent : function(component,event,helper){
        var planID = event.getParam("VplanID"); 
        helper.vPlanEventHelper(component,event,helper,planID);
    },
    doChangeDOB : function(component,event,helper){
        var dobStr = component.get("v.CensusRecord").Date_of_Birth__c;
        var renewalStr = component.get("v.Opportunity").Renewal_Date__c;
        if(dobStr !== null && typeof dobStr !== "undefined" && dobStr.length > 0 && renewalStr !== null && typeof renewalStr !== "undefined" && renewalStr.length > 0){
            var dobDate = new Date(JSON.stringify(dobStr));
            var renewalDate = new Date(JSON.stringify(renewalStr));
            var diffMs = renewalDate.getTime() - dobDate.getTime();
            var ageDate = new Date(diffMs);
            var ageNum =  Math.abs(ageDate.getUTCFullYear() - 1970);
            if(isNaN(ageNum)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Please provide Date of Birth in correct format",
                    "type": "error",
                    "mode": "sticky",
                    "duration": "500"
                });
                toastEvent.fire();
            }else{
                component.set("v.CensusRecord.Age_New__c", ageNum);
            }
        }else{
            component.set("v.CensusRecord.Age_New__c",'');
        }
       /* var db = component.get("v.CensusRecord").Date_of_Birth__c;
        if(db!=null && db!='' && db!= undefined){
            var c = db.split("-");
            var dob = new Date(c[0],c[1],c[2]);
            //var test = new Date.newInstance(c[0],c[1],c[2]);
            //alert('dob'+dob);
           
            //alert('test'+test);
            var d = component.get("v.Opportunity").Renewal_Date__c;
            if(d!='' && d!=undefined && d!=null){
            var d1 = d.split("-");
            var dob1  = new Date(d1[0],d1[1],d1[2]);
               // alert('dob1'+dob1);
                
                var oneDay = 24*60*60*1000;
               // alert('Math.abs((dob1.getTime() - dob.getTime())/(oneDay))'+Math.abs((dob1.getTime() - dob.getTime())/(oneDay)));
                var diffDays = Math.round(Math.abs((dob1.getTime() - dob.getTime())/(oneDay)));
              // alert('diffDays'+diffDays); 
                var ageVal = Math.floor(diffDays/365);
               // var ageVal1 = diffDays/365;
               // alert(ageVal1+'ageVal1');
               // alert('ageVal'+ageVal);
                
                if(isNaN(ageVal)){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Please provide Date of Birth in correct format",
                        "type": "error",
                        "mode": "sticky",
                        "duration": "500"
                    });
                    toastEvent.fire();
                }else{
                	component.set("v.CensusRecord.Age_New__c",ageVal);
                }
            }
        }else{
            component.set("v.CensusRecord.Age_New__c",'');
        }*/
    },
    doChangeSectionNum : function(component,event,helper){
        /*var action = component.get("c.setGroupSection");
        action.setParams({
            "censusId":component.get("v.CensusRecordId"),
            "planId" : component.get("v.CensusRecordId.Health_Plan_ID__c"),
            "sectionNum":component.get("v.groupSectionSelected")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                component.set("v.CensusRecord.Opportunity_Group_Section__c",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);*/
    },
    handleEmpChnge : function(component,event,helper){
        var census = component.get("v.CensusRecord");
        if(census.Employee_Status_Code__c=='Cobra'){
            component.set("v.CensusRecord.COBRA__c",'Y');
            component.set("v.CensusRecord.Retiree__c",'N');
            component.set("v.CensusRecord.State_Continuation__c",'N');
        }else if(census.Employee_Status_Code__c=='Retired'){
            component.set("v.CensusRecord.Retiree__c",'Y');
            component.set("v.CensusRecord.COBRA__c",'N');
            component.set("v.CensusRecord.State_Continuation__c",'N');
        }else if(census.Employee_Status_Code__c=='State Continuation'){
            component.set("v.CensusRecord.State_Continuation__c",'Y');
            component.set("v.CensusRecord.COBRA__c",'N');
            component.set("v.CensusRecord.Retiree__c",'N');
        }else if(census.Employee_Status_Code__c=='None'){
            component.set("v.CensusRecord.State_Continuation__c",'N');
            component.set("v.CensusRecord.COBRA__c",'N');
            component.set("v.CensusRecord.Retiree__c",'N');
        }
    },
    openModel1: function(component, event, helper) {
        component.set("v.isOpen1", true);
    },
    
    closeModel1: function(component, event, helper) { 
        component.set("v.isOpen1", false);
    },
    NotoClose: function(component, event, helper) { 
        component.set("v.NoToClose", true);
        component.set("v.isOpen", false);
    },
    YestoClose: function(component, event, helper) { 
        component.set("v.YesToClose", true);
        component.set("v.isOpen", false);
         
    },
     
})