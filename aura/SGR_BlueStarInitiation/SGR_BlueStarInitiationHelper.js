({
    invokeBlueSTAR : function(component) {
        var action = component.get("c.updateBlueSTAROptys");
        var division = component.get("v.selectedDivision");
        var scheduleDate = component.get("v.scheduledDate");
        var selYear=component.get("v.selectedYear");
        var selMonth=component.get("v.selectedMonth");
        var renEffDate = selYear + '-' + selMonth +'-01';
        var closeModal = false;
        console.log('divisions::'+division);
        console.log('selYear::'+selYear);
        console.log('selMonth::'+selMonth);
        console.log('renEffDate::'+renEffDate);
        console.log('Scheduled Date::'+scheduleDate);      
        //var divArrs = divisions.split(";");
        action.setParams({                               
            "division": division,
            "marketSegment": component.get("v.selectedMarketSeg"),                        
            "fundingType": component.get("v.selectedFundingType"),
            "renewaldate": renEffDate,
            "scheduleDate": scheduleDate
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
                
                var titleMsg=retVal + '<br/>';
                responseMsg.push(titleMsg);
                statusIcon = 'success-icon';
                statusId=retVal;
                rowIcon = 'success-icon';
                rowId='division';
                console.log('response text:>>> '+responseMsg);
                closeModal = true;
            }else if (state === "ERROR") {
                var errors = response.getError();
                statusIcon = 'error-icon';
                statusId='Error!';
                rowIcon = 'error-icon';
                rowId='Error!';
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        console.log('response errors:>>> '+errors);
                        responseMsg.push('Error! Post to BLUESTAR not initiated<br/><br/>');
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
                        "headerTxt": "Blue STAR Post"
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