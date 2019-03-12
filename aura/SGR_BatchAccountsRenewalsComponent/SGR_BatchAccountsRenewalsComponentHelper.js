({
    invokeRenewals : function(component) {
        var action = component.get("c.initiateRenewalForBatch");
        var divisions = component.get("v.selectedDivision");
        
        var selYear=component.get("v.selectedYear");
        var selMonth=component.get("v.selectedMonth");
        var renEffDate = selYear + '-' + selMonth +'-01';
        console.log('renEffDate::'+renEffDate);
       
        var divArrs = divisions.split(";");
        action.setParams({                               
            "divisions": divArrs,
            "marketSegment": component.get("v.selectedMarketSeg"),                        
            "fundingType": component.get("v.selectedFundingType"),
            "renewEffDateStr": renEffDate,
            "renType": component.get("v.selectedRenType")
        });
        var opts = [];
        action.setCallback(this, function(response) {
            
            var responseMsg = [];
            var state = response.getState();
            var statusIcon = '';
            var statusId='';
            var rowIcon = '';
            var rowId = '';
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                
                var titleMsg=retVal['title']+'<br/>';
                responseMsg.push(titleMsg);
                
                Object.keys(retVal).forEach(function(key) {
                    if (key!='title') {
                    	responseMsg.push(retVal[key]+'<br/>');
                    }
                });

                statusIcon = 'success-icon';
                statusId=retVal['title'];
                rowIcon = 'success-icon';
                rowId='division';
                console.log('response text:>>> '+responseMsg);
            }else if (state === "ERROR") {
                var errors = response.getError();
                statusIcon = 'error-icon';
                statusId='Error!';
                rowIcon = 'error-icon';
                rowId='Error!';
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        console.log('response errors:>>> '+errors);
                        responseMsg.push('Error! Renewal(s) not initiated<br/><br/>');
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