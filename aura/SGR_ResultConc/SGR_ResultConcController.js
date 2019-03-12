({
   doInit : function(component, event, helper) {
      $A.createComponent(
         "c:SGR_BatchAccountsRenewalsComponent",
         {
 
         },
         function(newCmp){
            if (component.isValid()) {
               component.set("v.body", newCmp);
            }
         }
      );
   },
   NavigateComponent : function(component,event,helper) {
      $A.createComponent(
         "c:ResultDisp",
         {
           "res" : event.getParam("result")
         },
         function(newCmp){
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
         }
      );
   }
})