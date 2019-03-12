({
    doInit : function(component, event, helper) {
        
        var recordId=component.get("v.recordId");
        var objectName=component.get("v.sObjectName");
        var currSelected=component.get("v.selectedItem");
        
        var tempPickList=[];
        helper.callServer(component,
                          "c.getSIRecordTypesList", 
                          function(response){
                              
                              if(response!=null){                               
                                  
                                  for(var i=0;i<response.length;i++){
                                      tempPickList.push({
                                          'sobjectType' : 'SI_Record_Types__c', 
                                          'Name' : response[i].Name,
                                          'HCSC_Division__c': response[i].HCSC_Division__c,
                                          'SI_Request_Hub_UI_Label__c':response[i].SI_Request_Hub_UI_Label__c                                     
                                      });
                                      // alert(response[i].SI_Request_Hub_UI_Label__c);
                                  }
                                  component.set("v.SIRecordTypePickList" ,response);
                              }
                          },{ 
                              recordId:recordId,
                              objectName:objectName, 
                              selectedItem:currSelected
                          }
                         ); 
        
        helper.callServer(component,
                          "c.getOpportunityDetails",
                          function(response){
                              console.log('getOpportunityDetails response: ' + response );
                              component.set("v.oppDetails", response);
                          },{
                              recordId : recordId
                          }
                         );	
    },
    openSIModal:function(component,event,helper){       
        var params = event.getParam("arguments");
        component.set("v.openModelConfirm",params.showConfirmModel);
        component.set("v.recordId",params.recordId);
        component.set("v.selectedItem",params.selected);        
        component.set("v.sObjectName",params.objectName);
        component.loadInitialData();
    },
    closeModelpopup : function(component,event,helper){
        component.set("v.openModelConfirm",false);
        
    },
    
    createRecord: function(component, event, helper) {
        var selectedSIRecordTypeLabel = component.find("siRecType").get("v.value");
        // alert(selectedSIRecordTypeLabel);
        var opprecordId = component.get("v.recordId");
        //alert(opprecordId);
        var action = component.get("c.fetchSIRecordTypeId");
        action.setParams({
            "recordTypeLabel" : selectedSIRecordTypeLabel        
        });
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               var result = response.getReturnValue();
                               
                               if (state === 'SUCCESS'){
                                   component.set("v.SIRecordTypeId", response);
                                   console.log("result" + result);
                                   var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                   dismissActionPanel.fire();                             
                                   var recTypeId = response.getReturnValue();
                                   if(recTypeId != 'No Access'){
                                       var createRecordEvent = $A.get('e.force:createRecord');
                                       var oppDetails = component.get('v.oppDetails');
                                       
                                       //alert(recTypeId);
                                       
                                       if ( createRecordEvent && oppDetails!=null ) {
                                           
                                           createRecordEvent.setParams({
                                               'entityApiName': 'Secure_Information__c',
                                               'defaultFieldValues': {
                                                   'Opportunity__c' : oppDetails.Id,
                                                   'Account__c' : oppDetails.AccountId,
                                                   'Opportunity_Name__c' : oppDetails.Id
                                               },
                                               "recordTypeId": recTypeId
                                           });
                                           createRecordEvent.fire();
                                       } else {
                                           /* Create Record Event is not supported */
                                           alert("Client Form Cannot be created, Please Contact System Administrator.");
                                       }
                                   }else {
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "type": "error",
                                       "title": "Error!",
                                       "message": "No access to Client Form type, Please contact your administrator"
                                   });
                                   toastEvent.fire();
                               }
                                   component.set("v.openModelConfirm",false);
                               }else if (state == "ERROR") {
                                   console.log('test inside error '+state);
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "title": "Error!",
                                       "message": "Please contact your administrator"
                                   });
                                   toastEvent.fire();
                               }
                           });
        $A.enqueueAction(action);     
    },
})