({
    doInit: function(component, event, helper) { 
        var recId = component.get("v.recordId");
        // var oppRec= component.get("v.OpportunityId");
        //alert('tetststs'+recId);
        helper.callServer(component,
                          "c.getaccDetails",
                          function(response){
                              if(response!=null){
                                  component.set("v.accDetails", response); 
                              }           
                          },
                          {
                              accountId:component.get("v.recordId")
                          }
                         ); 
        
        helper.callServer(component,
                          "c.getOpportunityDetails",
                          function(response){
                              if(response!=null){
                                  component.set("v.oppDetails", response); 
                              }           
                          },
                          {
                              recordId:component.get("v.recordId")
                          }
                         );
      
    },
    
    handleSubTypeChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
        //Update the Selected Values  
        component.set("v.selectedSubTypeList", selectedValues);
    },
    
    continuetosave : function(component, event, helper) {
        var submissiontypeval =component.find("submiss").get("v.value");  
        if(submissiontypeval!=null && submissiontypeval== '' || submissiontypeval == '--None--')
        {
            component.set("v.errorFlag",true);
        }
        else if(submissiontypeval!=null && submissiontypeval!= '' && submissiontypeval != '--None--')
        {
            component.set("v.errorFlag",false);
            component.find("submiss").set("v.errors", [{message:""}]);
            var submissionsubtypeval =component.find("selectSubType").get("v.value");
            if(submissionsubtypeval =='')
            {
                component.set("v.errorsubtype",true);
            }else if(submissionsubtypeval != ''){
                //alert('test in else'+submissionsubtypeval.length);
                component.set("v.errorsubtype",false);
                if(submissiontypeval =='Rate Change/Stop Loss Maintenance' && submissionsubtypeval.length>1)
                {
                    //alert('etst');
                    component.set("v.errorRCM",true);
                }
                else{
                    component.set("v.errorRCM",false);
                    // helper.saverecord(component,event,helper);
                    var submissionsubtypeval =component.find("selectSubType").get("v.value");
                    var submissiontypeval =component.find("submiss").get("v.value");
                    var commentval = component.find("commentid").get("v.value");
                    console.log('test'+commentval);
                    var accountdetails= component.get("v.accDetails");
                    var opportunitydetails= component.get("v.oppDetails");
                    //alert('tets today opp'+opportunitydetails);
                    var casedetailRecord = component.get("v.newcase");
                    var saveaction = component.get("c.insertAMCaseRec");
                    saveaction.setParams({
                        "accountdetail" :accountdetails,
                        "opportunitydetail" : opportunitydetails,
                        "newRec": casedetailRecord,
                        "submissiontype" :submissiontypeval,
                        "submissionsubtype" :submissionsubtypeval,
                        "Commentsvalue": commentval
                    });
                    saveaction.setCallback(this, function(response)
                                           { 
                                               var state = response.getState();  
                                               if (state === "SUCCESS") {
                                                   if(response!=null){
                                                       var url ='/'+response.getReturnValue().Id;
                                                       window.open(url, "_blank");
                                                       // $A.get("e.force:closeQuickAction").fire();
                                                   } 
                                               }
                                           });
                    $A.enqueueAction(saveaction);
                    component.set("v.openModelAMC",false);
                    component.find('submiss').set("v.value",'--None--');
                    component.set("v.selectedSubTypeList",'');
                    
                }
            }
        }
    },
    
    openAccMaintModel:function(component,event,helper){
        
        var recId = component.get("v.recordId");
        helper.callServer(component,
                          "c.getSubmissionTypePiklistValues",
                          function(response){
                              if(response!=null){
                                  var select=response;
                                  select.splice(0,4);
                                  component.set("v.SubmissionTypeList" ,select);
                              }           
                          },
                          {
                              //No Params
                          }
                         ); 
        helper.callServer(component,
                          "c.getSSubTypePiklistValues",
                          function(response){
                              if(response!=null){
                                  var result = response;
                                  var plValues = [];
                                  for (var i = 0; i < result.length; i++) {
                                      plValues.push({
                                          label: result[i],
                                          value: result[i]
                                      });
                                  }
                                  component.set("v.SubTypeList", plValues);
                              }               
                          },
                          {
                              //No params
                          }
                          
                         ); 
        
        helper.callServer(component,
                          "c.getselectOptionsCAM",
                          function(response){
                              if(response!=null){
                                  var listOptions=response.split(';');
                                  var mulplValues = [];
                                  for (var i = 0; i < listOptions.length; i++) {
                                      mulplValues.push({
                                          label: listOptions[i],
                                          value: listOptions[i]
                                      });
                                  }     
                                  component.set("v.optionsListCAM", mulplValues);
                              }
                          },
                          {
                              //No params
                          }
                         );  
        
        
        helper.callServer(component,
                          "c.getselectOptionsASM",
                          function(response){
                              if(response!=null){
                                  var asmlistOptions=response.split(';');
                                  console.log('------------->'+asmlistOptions);
                                  var mulplValues = [];
                                  for (var i = 0; i < asmlistOptions.length; i++) {
                                      mulplValues.push({
                                          label: asmlistOptions[i],
                                          value: asmlistOptions[i]
                                      });
                                  }
                                  component.set("v.optionsListASM", mulplValues);
                              }
                          },
                          {
                              //No Params
                          }
                          
                         ); 
        
        helper.callServer(component,
                          "c.getselectOptionsAEM",
                          function(response){
                              if(response!=null){
                                  var aemlistOptions=response.split(';');
                                  var mulplValues = [];
                                  for (var i = 0; i < aemlistOptions.length; i++) {
                                      mulplValues.push({
                                          label: aemlistOptions[i],
                                          value: aemlistOptions[i]
                                      });
                                  }
                                  component.set("v.optionsListAEM", mulplValues);
                              }
                          },
                          {
                              
                              //No Params
                          }
                          
                         ); 
        
        
        helper.callServer(component,
                          "c.getselectOptionsRCM",
                          function(response){
                              if(response!=null){
                                  
                                  var rcmlistOptions=response.split(';');
                                  var mulplValues = [];
                                  for (var i = 0; i < rcmlistOptions.length; i++) {
                                      mulplValues.push({
                                          label: rcmlistOptions[i],
                                          value: rcmlistOptions[i]
                                      });
                                  }
                                  component.set("v.optionsListRCM", mulplValues);
                              }
                          },
                          {
                              //No Params
                          }
                          
                         ); 
        
        helper.callServer(component,
                          "c.getselectOptionsAEPFM",
                          function(response){
                              if(response!=null){
                                  var aepfmlistOptions=response.split(';');
                                  var mulplValues = [];
                                  for (var i = 0; i < aepfmlistOptions.length; i++) {
                                      mulplValues.push({
                                          label: aepfmlistOptions[i],
                                          value: aepfmlistOptions[i]
                                      });
                                  }
                                  component.set("v.optionsListAEPFM", mulplValues);
                              }
                              
                              
                          },
                          {
                              
                              //No Params
                          }
                          
                         ); 
        
        helper.callServer(component,
                          "c.getselectOptionsICM",
                          function(response){
                              if(response!=null){
                                  var icmlistOptions=response.split(';');
                                  var mulplValues = [];
                                  for (var i = 0; i < icmlistOptions.length; i++) {
                                      mulplValues.push({
                                          label: icmlistOptions[i],
                                          value: icmlistOptions[i]
                                      });
                                  }
                                  component.set("v.optionsListICM", mulplValues);
                                  
                              }
                          },
                          
                          {
                              // No Params 
                          }
                          
                         );
        
        var params = event.getParam("arguments");
        component.set("v.openModelAMC",params.showMaintenanceModel);
        component.set("v.recordId",params.currentRecord);
        //component.loadInitialData();
    },
    closeModelpopup:function(component,event,helper){
        component.set("v.openModelAMC",false);
        component.find('submiss').set("v.value",'--None--');
        component.set("v.selectedSubTypeList",'');
        
        
    },   
    
})