({
    Cancellation : function(component, event, helper){
        var action = component.get("c.CaseAccountCancellationController");
        action.setParams({
            "sCaseId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().GEMS_Integration_Message__c === null && response.getReturnValue().GEMS_Integration_Message__c === ''){
                    alert('Please Retrieve Account Structure first before clicking on this button.');
                    window.open('/'+component.get('v.recordId'),'_top');
                }
                else if(response.getReturnValue().GEMS_Integration_Message__c !='Account Structure details retrieved successfully from BlueSTAR'){          
                    alert('Either Account Structure has been retrieved partially OR This case has been previously used for a cancellation. Please initiate a new Cancellation from Request Hub.');
                    
                    window.open('/'+component.get('v.recordId'),'_top');
                }
                    else{
                        var sural = "/apex/"+component.get("v.CancellationPage")+"?id="+response.getReturnValue().Account.Id+"&Case="+component.get('v.recordId')+"&selectedValue="+component.get("v.CancellationType");
                        window.open(sural,"_self");
                    }
            }
        });
        $A.enqueueAction(action);
    },
})