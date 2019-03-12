({
    
    openRHItemConfirmModel:function(component,event,helper){
         
        var params = event.getParam("arguments");
       
        component.set("v.openModelConfirm",params.showConfirmModel);
        component.set("v.recordId",params.currentRecord);
        component.set("v.selectedItem",params.selected);
        
        //Ranjit G- 9626- start
        component.set("v.createdModelConfirmCase",params.createdModelConfirm_Case);
        component.set("v.createdModelConfirmContractAdmin",params.createdModelConfirm_ContractAdmin);
        
       // alert('params.showConfirmModel'+component.get("v.createdModelConfirmCase"));
       // alert('params.createdModelConfirm_ContractAdmin'+component.get("v.createdModelConfirmContractAdmin"));
      
        
        // Ranjit G- 9626- end
    },
    createRecord: function(component, event, helper) {
        var spinner = component.find("mySpinner");       
        component.set("v.spinnerOnOff",true);
        var action = component.get("c.createCase");
        var recordTypeLabel = component.get("v.selectedItem");
        var recId = component.get("v.recordId");
        action.setParams({
            "caseRecTypeLabel": recordTypeLabel,
            "recordId":recId
        });
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               var result = response.getReturnValue();
                               if(result != null){
                                   var caseId = response.getReturnValue().Id;
                                   var caseNum = response.getReturnValue().CaseNumber;
                                   // alert(caseNum);
                                   var accId = response.getReturnValue().AccountId;
                                   if (state === 'SUCCESS'){
                                       if(caseId != null){
                                           component.set("v.caseId",caseId);
                                           component.set("v.caseNum",caseNum);
                                           component.set("v.spinnerOnOff",false);
                                           component.set("v.createdModelConfirm_Case",true);  //9626
                                           var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                           dismissActionPanel.fire(); 
                                           $A.createComponent(
                                               "c:LGNA_NewRHSelectedItemConfirmCreatedModal",{
                                                   "caseId": caseId,
                                                   "caseNum": caseNum
                                               },
                                               function(newcomponent){
                                                   if (component.isValid()) {
                                                       var body = component.get("v.body");                  
                                                       body.push(newcomponent);
                                                       component.set("v.body", body);                    
                                                   }
                                               }            
                                           );  
                                   }
                                   else{
                                       component.set("v.spinnerOnOff",false);
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Error!",
                                           "message": "Error occured while creating request type, Please contact your administrator"
                                       });
                                       toastEvent.fire(); 
                                   }
                               }
                               else if (state == "INCOMPLETE") {
                                   component.set("v.spinnerOnOff",false);
                                   console.log('test inside INCOMPLETE '+state);
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "title": "Oops!",
                                       "message": "No Internet Connection"
                                   });
                                   toastEvent.fire();
                                   
                               } 
                                   else if (state == "ERROR") {
                                   component.set("v.spinnerOnOff",false);
                                   console.log('test inside error '+state);
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "title": "Error!",
                                       "message": "Error occured while creating request type, Please contact your administrator"
                                   });
                                   toastEvent.fire();
                               } 
                               }
                               else{
                                  component.set("v.spinnerOnOff",false);
                                  var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "title": "Error!",
                                       "message": "Error occured while creating request type, Please contact your administrator"
                                   });
                                   toastEvent.fire(); 
                               }
                           });
        
        $A.enqueueAction(action);
        component.set("v.openModelConfirm",false);
        component.set("v.createdModelConfirm_Case",true);
        $A.util.toggleClass(spinner, "slds-hide");
    }, 
     //9626- start
    createContractAdminRequestRecord: function(component, event, helper) {  
         //alert('createContractAdminRequestRecord');
        var spinner = component.find("mySpinner");       
        component.set("v.spinnerOnOff",true);
        var action = component.get("c.createContractAdminRequest");       
        var recordTypeLabel = 'Contract Admin Request';         
        var recId = component.get("v.recordId"); 
        
        action.setParams({
            "caseRecTypeLabel": recordTypeLabel,
            "recordId":recId
        });
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();                               
                               var caserec=response.getReturnValue(); 
                               //alert('state+'+state);
                               if (state === 'SUCCESS'){                                   
                                   component.set("v.caseId",caserec.Id);
                                   component.set("v.caseNum",caserec.Name); 
                                   component.set("v.spinnerOnOff",false);
                                   component.set("v.createdModelConfirm_ContractAdmin",true);   //9626
                                   var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                   dismissActionPanel.fire(); 
                                   $A.createComponent(
                                       "c:LGNA_NewRHSelectedItemConfirmCreatedModal",{
                                           "caseId": caserec.Id,
                                           "caseNum": caserec.Name,
                                           "createdModelConfirm_ContractAdmin": true  //9626
                                           
                                       },
                                       function(newcomponent){
                                           if (component.isValid()) {
                                               var body = component.get("v.body");                  
                                               body.push(newcomponent);
                                               component.set("v.body", body);                    
                                           }
                                       }            
                                   );
                                   
                               } 
                           });
        
        $A.enqueueAction(action);
        component.set("v.openModelConfirm",false);
        component.set("v.createdModelConfirm_ContractAdmin",true);
        $A.util.toggleClass(spinner, "slds-hide");
        
         //9626- end
    },
    closeModelpopup:function(component,event,helper){
        component.set("v.openModelConfirm",false);
    },
    closeCreatedModel:function(component,event,helper){
        component.set("v.createdModelConfirm_Case",false); component.set("v.createdModelConfirm_ContractAdmin",false); 
    },
    removeComponent:function(component, event, helper){
        //get the parameter you defined in the event, and destroy the component
        var comp = event.getParam("comp");		
        comp.destroy();
    },
})