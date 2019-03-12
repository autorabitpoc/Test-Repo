({
    CreateForm : function(component, event, helper) {
        var errors = [];
        var action = component.get("c.getSBCBBForms");
        action.setParams({
            "sCARId": component.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(!response.getReturnValue().Region__c) { 
                    errors.push('"Region" '); 
                }
                if(!response.getReturnValue().Category__c) { 
                    errors.push('"Category" '); 
                }
                if(!response.getReturnValue().Cluster__c) { 
                    errors.push('"Cluster" '); 
                }
                if(!response.getReturnValue().District__c) { 
                    errors.push('"District" '); 
                }
                if(!response.getReturnValue().Effective_Date__c) { 
                    errors.push('"Effective Date" '); 
                }
                if(!response.getReturnValue().Line_of_Business__c) { 
                    errors.push('"Line of Business" '); 
                }
                if(!response.getReturnValue().Market_Segment__c) { 
                    errors.push('"Market Segment" '); 
                }
                if(!response.getReturnValue().Open_Enrollment_Start_Date__c) { 
                    errors.push('"Open Enrollment Start Date" '); 
                }
                if (errors.length > 0) { 
                    var errorString = ''; 
                    var errorString = errors.join(""); 
                    errorString='Required mandatory Fields :' + errorString;
                    helper.genericShowToast("Error!",
                                            "sticky",
                                            errorString,
                                            "error");
                } 
                else if(response.getReturnValue().Opportunity_Link__r.HCSC_Division__c != response.getReturnValue().Hidden_HCSC_Division__c) { 
                    helper.genericShowToast("Error!",
                                            "sticky",
                                            'HCSC Division in request should be same as in account (' + response.getReturnValue().Opportunity_Link__r.HCSC_Division__c  + ')',
                                            "error");
                } 
                    else{
                        var saction = component.get("c.getSBCBBFormsRecordType");
                        saction.setParams({
                            "sRecordType": event.getSource().getLocalId(),
                        });
                        saction.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var createRecordEvent = $A.get("e.force:createRecord");
                                if(event.getSource().getLocalId() == 'GEMS SBC Form'){
                                    createRecordEvent.setParams({
                                        "entityApiName": 'GEMS_SBC_BB_Form__c',
                                        "recordTypeId": response.getReturnValue(),
                                        "defaultFieldValues": {
                                            'GEMS_SBC_Request__c' : component.get('v.recordId'),
                                        }
                                    })
                                }
                                else
                                {
                                    createRecordEvent.setParams({
                                        "entityApiName": 'GEMS_SBC_BB_Form__c',
                                        "recordTypeId": response.getReturnValue(),
                                        "defaultFieldValues": {
                                            'GEMS_Benefit_Booklet_Request__c' : component.get('v.recordId'),
                                        }
                                    })
                                }
                                createRecordEvent.fire();
                                $A.get("e.force:closeQuickAction").fire();
                            }
                        })
                        $A.enqueueAction(saction);
                    }
            }
        })
        $A.enqueueAction(action);
    },
})