({
    searchAccount : function(component) {
        var action = component.get("c.searchAccounts");
        action.setParams({                               
            "division": component.get("v.selectedDivision"),
            "acctNo": component.get("v.selectedAccNum")
        });

        action.setCallback(this, function(response) {
            console.log('demand '+response);
            var responseMsg = [];
            var state = response.getState();
            console.log('state '+state);
            var statusIcon = '';
            var statusId='';
            var rowIcon = '';
            var rowId = '';
            if (state === "SUCCESS") {
                //create review component to have ondemand trigger
                console.log('returnValue '+response.getReturnValue());
				component.set('v.accountObj', response.getReturnValue());

            } else if (state === "ERROR") {
                var errors = response.getError();
                statusIcon = 'error-icon';
                statusId='Error!';
                rowIcon = 'error-icon';
                rowId='Error!';
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        responseMsg.push('Error! Renewal(s) not initiated<br/><br/>');
                        responseMsg.push(errors[0].message);
                    }
                }
                console.log('ERRORS - '+responseMsg);
            }
            
            if (responseMsg.length>0) {
                $A.createComponent(
                    "c:SGR_ModalPopup",
                    {
                        "contentTxt": responseMsg,
                        "status-icon": statusIcon,
                        "status-id" : statusId,
                        "row-id" : rowId,
                        "row-icon": rowIcon,
                        "headerTxt": "On Demand Trigger Renewal"
                    },
                    function(msgBox) {
                        var targetCmp = component.find("ModalPopupPlaceholder");
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body);
                    }
                    
                )
            } 
        });
        $A.enqueueAction(action);    
    },
  
    handleTrigger : function(component){
        var action = component.get("c.initiateRenewalForOnDemand");
        
        action.setParams({                               
            "division": component.get("v.selectedDivision"),
            "accNum": component.get("v.selectedAccNum"),
            "renType": component.get("v.selectedRenType"),
            "fundingType": component.get("v.accountObj.Funding_Type__c"),
            "marketSegment":component.get("v.accountObj.Market_Segment__c"),
            "renewEffDate" : component.find("rDate").get("v.value")
        });
        
        action.setCallback(this, function(response) {
            console.log('demand '+response);
            var responseMsg = [];
            var state = response.getState();
            console.log('state '+state);
            var statusIcon = '';
            var statusId='';
            var rowIcon = '';
            var rowId = '';
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                var successMsg='Success! Renewal(s) successfully initiated.<br/>';
                responseMsg.push(successMsg);
                responseMsg.push(retVal[0]);
                statusIcon = 'success-icon';
                statusId='Success';
                rowIcon = 'success-icon';
                rowId='Batch ID';
                console.log('response text:>>> '+responseMsg);
            }else if (state === "ERROR") {
                var errors = response.getError();
                statusIcon = 'error-icon';
                statusId='Error!';
                rowIcon ='error-icon';
                rowId='Error!';
                if(errors) {
                    if (errors[0] && errors[0]) {
                        responseMsg.push('Error! Renewal not initiated.<br/><br/>');
                        responseMsg.push(errors[0].message);
                    }
                }
                
            }
            
            if (responseMsg.length>0) {
                $A.createComponent(
                    "c:SGR_ModalPopup",
                    {
                        "contentTxt": responseMsg,
                        "status-icon": statusIcon,
                        "status-id" : statusId,
                        "row-id" : rowId,
                        "row-icon": rowIcon,
                        "headerTxt": "Trigger Renewal"
                    },
                    function(msgBox) {
                        var targetCmp = component.find("ModalPopupPlaceholder");
                        
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body);
                    })
                
            }
            
        });
        
        $A.enqueueAction(action);      
        
    }
})