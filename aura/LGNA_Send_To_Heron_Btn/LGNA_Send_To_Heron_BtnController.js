({
   doInit : function(component, event, helper) {
       
		 var recId= component.get("v.recordId");
        alert("record Id: "+recId);
        console.log("record id:"+recId);
        
       var cmpTarget = component.find('Modalbox');
       	var cmpBack = component.find('MB-Back');
        window.setTimeout(
         $A.getCallback(function() {
          $A.get("e.force:closeQuickAction").fire();
         }), -1
        );
         var dismissActionPanel = $A.get("e.force:closeQuickAction");
                               dismissActionPanel.fire();
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');        
        component.set("v.diplayResult",true);
        component.set("v.message", "You have been successfully sumbitted request to Heron");
      
	},
    
    Finish:function(component, event, helper) {
          component.set("v.diplayResult",false);
    },
    /*
    validation: function( reqData){
        var yearOldDate = new Date(); 
        yearOldDate.setFullYear(yearOldDate.getFullYear()-1); 
        var msg="You have been successfully sumbitted request to Heron";
        var errorMsg="";
       console.log("current data:"+reqData);
        var hasError=false;
       // alert(reqData.Status__c);
        if(reqData.Status__c!=null && reqData.Status__c !="New" && reqData.Status__c!=""){ 
          //alert('Error! This Quote Request Has been Sent. Only New Quote Request will be accepted.'); 
             errorMsg="Error! This Quote Request Has been Sent. Only New Quote Request will be accepted.";
            
        }else if(reqData.Request_Description__c===null || reqData.Request_Description__c.length<16){ 
           //  alert('Please provide Quote Request Description with minimal 16 characters.'); 
             errorMsg="Please provide Quote Request Description with minimal 16 characters.";
        }else if(reqData.HCSC_Division__c==null ||reqData.HCSC_Division__c==""){ 
        //  alert('Error! HCSC Division is missed!'); 
            errorMsg="Error! HCSC Division is missed!";
        }else if(reqData.Request_Effective_Date__c==null || reqData.Request_Effective_Date__c==""){ 
          //alert('Error! Request Effective Date is missed.'); 
          errorMsg="Error! Request Effective Date is missed."
          
        }else if(reqData.Request_Effective_Date__c<yearOldDate){ 
          //alert('Request Effective Date can not be older than 1 year.'); 
          errorMsg="Request Effective Date can not be older than 1 year.";
            
         }else if(reqData.Sales_Type__c==null || reqData.Sales_Type__c==""){ 
           //     alert('Error! Request Type is missed. New Sale or Renewal?'); 
             errorMsg="Error! Request Type is missed: New Sale or Renewal";
             
         }else if(reqData.Sales_Type__c==="New Sale" && (reqData.Account_Name_tx__c===null||reqData.Account_Name_tx__c==="")){ 
            //alert('Error! Account Name is missed.'); 
             errorMsg="Error! Account Name is missed.";
          }else if(reqData.Sales_Type__c==="Renewal" && (reqData.Account_Number__c===null || reqData.Account_Number__c==="")){ 
             //alert('Error! Account Number is missed.'); 
             errorMsg="Error! Account Number is missed.";
         }else{ 
             console.log("msg:  "+msg);
            
             //var retStr = sforce.apex.execute('QuoteRequestWebServiceHelper', 'CreateGetRateWSCallout',{quoteReqId :reqId}); 
          }
        if(errorMsg!=""){
            component.set("v.hasError",true);
            component.set("v.message", errorMsg);
        }else{
            component.set("v.hasError",false);
            component.set("v.message", msg);
        }
    },
    */
  
   Close: function(compnent, event, helper){
      
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
  },
   CallHeronWS: function(component, event, helper){
       
  // window.setTimeout(
     // $A.getCallback(function() {
       //   $A.get("e.force:closeQuickAction").fire();
      //}), -1
   //);
       //$A.get("e.force:closeQuickAction").fire();
       var recId= component.get("v.recordId");
       var result=null;
       var msg=null;
      
        console.log(recId);     
       
      // current qr record base on the record ID
      var action1=component.get("c.getCurrentQuoteRequest");
     //  action1.setParams({quoteReqId:recId});
       helper.callServer(component, "c.getCurrentQuoteRequest",
                         function(response){
                             if(response!=null){
                                component.set("v.currentRecord", response);
                                helper.validation(component, event, helper);
                                 
                                 if(component.get("v.hasError")){
                                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                    dismissActionPanel.fire();
                           								
                                     var errorMsg=component.get("v.message");
                                      helper.ShowToast("Validation Error",
                                        "sticky",
                                         errorMsg,
                                         "error");
                                 }else{
                                     helper.callServer(component,"c.CreateGetRateWSCallout",
                                                       function (response){
                                                               var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            										dismissActionPanel.fire();
                           								
                               								//	result=response.getReturnValue();  
                                							//	console.log("result: "+result);
                                								component.set("v.message", "You have been successfully sumbitted request to Heron.");
                               								    if(response==null){//no error msg returned
                                   									 msg="You have been successfully sumbitted request to Heron.";
                                								    
                                								   helper.ShowToast("WS Call Status",
                                              					   "dismissible",
                                                 					msg,
                                               						"Success"); 
                                                                }else{
                                    								msg="Service Call Error! Please Check Integration Information for Detail.";
                                								
                                								   helper.ShowToast("WS Call Status",
                                              					   "dismissible",
                                                 					msg,
                                               						"error");
                                                                }
                                  
                              							
                                                     } , 
                                                       { quoteReqId: recId}
                                                        
                                                      );
                                     
                                 }
                              }                             
                         },{
                             quoteReqId:recId}
                        );
                            
                       /*
       
      var action = component.get("c.CreateGetRateWSCallout");
      action.setParams({quoteReqId:  recId});
      action.setCallback(this, 
                         function(response) {
                            
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                            var state = response.getState();
                              console.log(state);
                             
                            if (state === "SUCCESS") { 
                               result=response.getReturnValue();  
                                console.log("result: "+result);
                                component.set("v.message", "You have been successfully sumbitted request to Heron.");
                                if(result==null){
                                    msg="You have been successfully sumbitted request to Heron.";
                                }else{
                                    msg="Service Call Error! Please Check Integration Information for Detail.";
                                }
                                 helper.ShowToast("WS Call Status",
                                               "dismissible",
                                                 msg,
                                                "success");
                                  
                              } else if (state === "ERROR") {
           
                                 var errors = response.getError();
                                 component.set("v.message", "Error! Please Contact System Administrator.");

                                  helper.ShowToast("WS Call Status",
                                  "sticky",
                                  "Error! Please contact System Administrator.",
                                  "error");
            
            				      if (errors) {
                						console.log("Errors", errors);
               						 if (errors[0] && errors[0].message) {
                    						throw new Error("Error" + errors[0].message);
                						}
                                   } else {
                						throw new Error("Unknown Error");
            						}
        						}
    					});
      $A.enqueueAction(action);
       */
   /* $A.enqueueAction(action);
     window.setTimeout(
    $A.getCallback(function() {
        $A.get("e.force:closeQuickAction").fire();
    }), -1
   );
       
      helper.ShowToast("WS Call Status",
                       "sticky",
                        "You have been successfully sumbitted request to Heron",
                        "success");
       */
    // var dismissActionPanel = $A.get("e.force:closeQuickAction");
      // dismissActionPanel.fire();

    }
})