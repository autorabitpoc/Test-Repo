({
	callServer : function(component,method,callback,params) {
        console.log("method: "+method);
    var action = component.get(method);
 
    if (params) {
        action.setParams(params);
    }
      
      action.setCallback(this, function(response) {
          
        var state = response.getState();
         console.log(state);
        if (state === "SUCCESS") { 
            // pass returned value to callback function
            callback.call(this,response.getReturnValue());   
        } else if (state === "ERROR") {
            // generic error handler
            var errors = response.getError();
            
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
  },
    
    ShowToast : function(title,mode,message,type){
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "message": message,
                    "mode": mode,
                    "type":type
                });
                toastEvent.fire();        
    },
    
     validation: function( component,event, helper){
         
        var reqData=component.get("v.currentRecord");
         
        var yearOldDate = new Date(); 
        yearOldDate.setFullYear(yearOldDate.getFullYear()-1); 
        var msg="You have been successfully sumbitted request to Heron";
        var errorMsg="";
        console.log("current data:"+reqData);
        var hasError=false;
      //  alert(reqData.Status__c);
        if(reqData.Status__c!=null && reqData.Status__c !="New" && reqData.Status__c!=""){ 
          //alert('Error! This Quote Request Has been Sent. Only New Quote Request will be accepted.'); 
             errorMsg="Error! This Quote Request Has been Sent. Only New Quote Request will be accepted.";
            
        }else if(reqData.Request_Description__c===null || reqData.Request_Description__c.length<16){ 
           //  alert('Please provide Quote Request Description with minimal 16 characters.'); 
             errorMsg="Please provide Quote Request Description with minimal 16 characters.";
        }else if(reqData.HCSC_Division__c===null ||reqData.HCSC_Division__c===""){ 
        //  alert('Error! HCSC Division is missed!'); 
            errorMsg="Error! HCSC Division is missed!";
        }else if(reqData.Request_Effective_Date__c==null || reqData.Request_Effective_Date__c===""){ 
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
            return false;
        }else{
            component.set("v.hasError",false);
            component.set("v.message", msg);
            return true;
        }
    }
})