({
    doInit : function(component, event, helper) {
        var RecId=component.get("v.recordId");
       // console.log('recid'+RecId);
        // To Dispaly BuyerHierarchy
        var redirection = "/apex/BuyerHierarchyOnAccount_Lex?Id="+RecId;
        component.set("v.Redirection",redirection);
       //To get the Strategic Plan Details starts here 
        var action = component.get("c.getsplanDetails");
            action.setParams({
                "accountId": RecId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result  = response.getReturnValue();
                    console.log('aug30 test'+response.getReturnValue());
                   // console.log('aug30 test'+response.getReturnValue());
                  //  if(result[0].Id!==null || result[0].Id!=='' || result[0].Id!==undefined){
                     if(result!==null && result!=='' && result!==undefined){
                    component.set("v.splanDetailsList", result);
                        console.log('test today '+result);
                    }
                } 
            });
            $A.enqueueAction(action);
        // Strategic Plan Details Ends here
    },
   openModelPlan: function(component, event, helper) {
       var results=component.get("v.splanDetailsList");
       console.log('+results'+results[0].Id);       
       var redirectURL="/one/one.app?source=aloha#/sObject/"+results[0].Id+"/view";
       console.log('+results'+redirectURL);
       //window.location.href = redirectURL;
        //window.location.target = "_blank";
       window.open(redirectURL,"_blank");
      // console.log('+results'+location.href);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpenBuyer", false);
   },

   openModelBuyer: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpenBuyer", true);
   },

   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      alert('thanks for like Us :)');
      component.set("v.isOpen", false);
   },
})