({
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
 
   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      alert('thanks for like Us :)');
      component.set("v.isOpen", false);
   },
    
        doInit : function(component, event) {       
        console.log('Hi')
// Call the Apex Class Method from Javascript       
var action = component.get("c.accountCounter"); 
            //var action = component.get("c.Renewal_Batch_Invoker");

        
// Callback which will fetch the response from Apex and set the value to Component        
action.setCallback(this, function(a) {  
    alert(JSON.stringify(response.getReturnValue()));

   // component.set("v.myMap",response.getReturnValue());
        console.log('Hi');
    
// Set the value in the Accounts List an attribute that we created into Apex Controller        
//component.set(“v.accounts”, a.getReturnValue());
    });     
       $A.enqueueAction(action);  
}      
// Place the Action in the Queue    

})