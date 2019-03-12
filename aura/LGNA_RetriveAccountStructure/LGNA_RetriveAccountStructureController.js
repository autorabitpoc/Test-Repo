({
    AccountRetrieveServices: function(component, event, helper) {
        var CaseId = component.get("v.recordId");
        var CaseData = component.get("v.CaseData");
        if(CaseData.isRetrievalRequestSubmitted__c != true){
            if(CaseData.GEMS_Submission_Type__c != 'New Account'){
                component.set('v.cancleFlag','true');
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                var action = component.get("c.retrieveAccountStructure");
                action.setParams({
                    "accountStructureCaseID": CaseId,
                    "requestCode":'Call1',
                    "accStructResponseId":'',
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state =="SUCCESS") {
                        var sResult= response.getReturnValue();
                        if(sResult){
                            helper.helperMethod('Alert!',sResult); 
                             document.location.reload(true);
                        }
                        else{
                            helper.helperMethod('Alert!', 'Retrieve Account Structure Request Sent to BlueStar.'); 
                             document.location.reload(true);
                        }                   
                    }
                    else if (state == "INCOMPLETE") {
                        helper.helperMethod('Oops!','No Internet Connection');
                        
                    } else if (state == "ERROR") {
                        helper.helperMethod('Error!','Please contact your administrator');
                    }
                })
                $A.get("e.force:closeQuickAction").fire();
                $A.enqueueAction(action);
            }
            else 
            {
                helper.helperMethod('Alert!','Account Structure can only be retrieved for Renewal and Off Cycle Cases.');
            } 
        }
        else{
            helper.helperMethod('Alert!','Account Structure Retrieval Request already sent.');
        }
    },
    CaseDetails: function(component, event, helper) {
        
    },
    calloutToCBSRAccountSubmit :function(component,event,helper){
        
            var rec = component.get("v.CaseData");
        
        	//Mod Calculation Start
            var  timeSent = new Date();
            timeSent =rec.Time_Sent__c;
            var timeSentFinal = new Date(timeSent);
            timeSentFinal = timeSentFinal.toISOString().replace('T', ' ').replace(/\..*$/, '');
            var currentTime = new Date();
            var now=currentTime.toISOString().replace('T', ' ').replace(/\..*$/, '');
            
           
            var old_date = now;
            var new_date = timeSentFinal;
            var old_date_obj = new Date(Date.parse(old_date));
            var new_date_obj = new Date(Date.parse(new_date));
            var diffMs = Math.abs(new_date_obj - old_date_obj);
            var mod = ((diffMs*1440) % 60);
            	
        
        	//Mod Calculation End
            var time_diff;
            if(mod < 15){
                
                
                //alert('ind=side if');
                time_diff = true;
                
            }
            else{
                time_diff = false;
            } 
            helper.callServer(component,
                              "c.checkChildRecordCount", 
                              function(response){
                                  if(response == true){
                                      var status = rec.Status;
                                      var int_status = rec.Integration_Status__c;
                                      var time_diff = false; //Temporary
                                      var externalid = rec.External_Id__c;
                                      if((status !='Submitted' || (status =='Submitted' && (int_status =='Failure' || (int_status=='Sent' && time_diff==false) ) ) ) && externalid!=null && externalid!=''){
                                          //Call Web-Service
                                          helper.callServer(component,
                                                            "c.SubmitAccountCalloutLighning", 
                                                            function(response){
                                       							helper.helperMethod('Alert!', 'Account Submit Successful');
                                                                $A.get('e.force:refreshView').fire();
                                                            },{ 
                                                                caseId:component.get("v.recordId") 
                                                            }
                                                           );
                                         
                                      } 
                                      else{
                                          
                                          //alert('Invalid Action');
                                      	helper.helperMethod('Alert!', 'Invalid Action');

                                          
                                      }
                                      
                                  }
                                  else{
                                      
                                      //alert('Please add CBSR Issue(s) with status New before submitting CBSR Account');
                                      helper.helperMethod('Alert!', 'Please add CBSR Issue(s) with status New before submitting CBSR Account');
                                  }
                                  
                              },{ 
                                  caseId:component.get("v.recordId") 
                              }
                             );
  
        
    }
})