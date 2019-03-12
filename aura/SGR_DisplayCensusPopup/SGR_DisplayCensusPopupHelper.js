({
	calculateMemberCount : function(component,event,message) {
        /*var subscriberNumber = message.Subscriber_Number__c;
        //alert(subscriberNumber);
        var action = component.get("c.CountDependents");
        action.setParams({'SN':subscriberNumber,'optyId':message.Opportunity__r.Id});
        action.setCallback(this,function(response){
            //alert(JSON.stringify(response.getState()));
            if(response.getState()==='SUCCESS'){
                var Returnvalue = response.getReturnValue();
                var count=1;
                count = count+Returnvalue.length;
                if(subscriberNumber!=undefined && subscriberNumber!=null && subscriberNumber!=''){
                    component.set("v.Member",subscriberNumber+'.'+count);
                }
                else{component.set("v.Member",'');}
            }
        });
        $A.enqueueAction(action);*/
	},
    getCoverageDetails : function(component,event,helper,oppCensus) {
    	var action = component.get("c.getDependentData");
        action.setParams({
            oppCensusId : oppCensus.Id
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var dependentData = response.getReturnValue();
                if(dependentData.Health_Plan_ID__c!=null && dependentData.Health_Plan_ID__c!=undefined && dependentData.Health_Plan_ID__c!=''){
                    component.set("v.HealthCoverage",true);
                    component.set("v.disableHCoverage",true);
                }else if(component.get("v.CensusRecord.Health_Plan_ID__c")==null || component.get("v.CensusRecord.Health_Plan_ID__c")==undefined || component.get("v.CensusRecord.Health_Plan_ID__c")==''){
                    component.set("v.disableHCoverage",true);
                }
                
                if(dependentData.Dental_Plan_ID__c!=null && dependentData.Dental_Plan_ID__c!=undefined && dependentData.Dental_Plan_ID__c!=''){
                    component.set("v.DentalCoverage",true); 
                    component.set("v.disableDCoverage",true);
                }else if(component.get("v.CensusRecord.Dental_Plan_ID__c")==null || component.get("v.CensusRecord.Dental_Plan_ID__c")==undefined || component.get("v.CensusRecord.Dental_Plan_ID__c")==''){
                    component.set("v.disableDCoverage",true);
                }
                /*if(dependentData.Vision_Plan_ID__c!=null && dependentData.Vision_Plan_ID__c!=undefined && dependentData.Vision_Plan_ID__c!=''){
                    component.set("v.VisionCoverage",true);
                    component.set("v.disableVCoverage",true);
                }else if(component.get("v.CensusRecord.Vision_Plan_ID__c")==null || component.get("v.CensusRecord.Vision_Plan_ID__c")==undefined || component.get("v.CensusRecord.Vision_Plan_ID__c")==''){
                    component.set("v.disableVCoverage",true);
                }*/
                
            }
        });
        $A.enqueueAction(action);
	},
    validateZip : function(zipcode) {
        if(zipcode !== null && typeof zipcode !== "undefined" && zipcode.length > 0){
            var zipParts = zipcode.split("-");
            if(zipParts.length === 2){
                return (zipParts[0].length === 5 && zipParts[1].length === 4);
            }
            return zipcode.length === 5;
        }
        return false;
    }
})