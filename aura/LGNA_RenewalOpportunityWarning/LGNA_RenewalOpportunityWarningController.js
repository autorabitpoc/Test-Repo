// Ranjit Gandhi       03/27/2018    SFDC-8771 Group Account - Renewal Opportunity Button
({
    compInit : function(component, event, helper) {
        var accid= component.get("v.recordId");
        var oppreclistaction = component.get("c.getOpportunityRenewalList");
        oppreclistaction.setParams({"accountId": accid,
                                    "recordtypeId": "01233000000QMPD"
                                   });
        oppreclistaction.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('print result '+result); //console.log('test'+response.getReturnValue());
                if(result==='hasopprenewalrec'){
                    console.log('if'+result);
                    component.set("v.opphasRecordsList", result);
                    component.set("v.errorFlag",true); 
                    component.set("v.errorFlagdef",false);
                }
                if(result==='hasnotopprenewalrec'){
                    console.log('null'+result);
                    // component.set("v.opphasRecordsList", result);
                    component.set("v.errorFlag",false);  
                    component.set("v.errorFlagdef",true);
                }
            }
        });
        $A.enqueueAction(oppreclistaction);
    },
    
    cancel : function(component, event,helper)
    {  
        $A.get("e.force:closeQuickAction").fire();
    },
    createOpp : function(component, event, helper){
        console.log('test warn');
        var accid= component.get("v.recordId");         
        $A.createComponent(
            "c:LGNA_CreateNewOffCycleChange",
            {
                "recordId": accid,
                "recordTypeid": '01233000000QMPD'
            },
            function(msgBox){
                if(component.isValid()){
                    console.log('inside msg box warn');				
                    var targetCmp = component.find('requestopp');                    
                    var body = targetCmp.get("v.body");                    
                    body.push(msgBox);   
                    console.log('inside msg box warn'+body);
                    
                    targetCmp.set("v.body",body);                    
                }			
            }
        );
    },
})