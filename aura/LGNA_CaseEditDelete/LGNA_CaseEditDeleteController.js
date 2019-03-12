/*Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 04/10/2018
 * Discription : Client side Edit and Delete DropDown controller  for Insatallation(GEMS), SAM REquests Tabs
*/
({
    
    doInit : function(component, event, helper){
        //alert('hello');
        var recId = component.get("v.curentRecord");
        var action = component.get("c.userAccessLevel");
        action.setParams({
            caseId:recId
        });
        
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                component.set("v.hasDelete",response.getReturnValue().HasDeleteAccess);
                component.set("v.hasEdit",response.getReturnValue().HasEditAccess);
               //alert('edit'+response.getReturnValue().HasEditAccess);
                //alert('delete'+response.getReturnValue().HasEditAccess);
                if(response.getReturnValue().HasDeleteAccess == false && response.getReturnValue().HasEditAccess == false){
                  component.set("v.menu",false);  
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
	editCase : function(component, event, helper) {
		var recId = component.get("v.curentRecord");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": recId
       });
        editRecordEvent.fire();
	},
    
    deleteCase : function(component, event, helper) {
		var compEvent = component.getEvent("delGemRelListRecEvent");
        var recId = component.get("v.curentRecord");
        compEvent.setParams({
             					"del" : true,
                                "rId" :recId
                             });
		compEvent.fire();
  
    }

})