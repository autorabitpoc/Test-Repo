({
	 doInit: function(component, event, helper) 
    { 
        
        var recId=component.get("v.recordId");
        /*
        //var action = component.get("c.getaccountDetails");
        action.setParams({"accountId":recId});
        action.setCallback(this, function(response)
                            { 
                                var state = response.getState();                                 
                                if (state === "SUCCESS") 
                                {
                                    if(response.getReturnValue()!==null){  
                                        
                                    }
                                } 
                            });
         $A.enqueueAction(action);*/

               
         
        var usercontext = component.get("v.UserContext");
        var tablist=document.getElementById("Tablistdiv"); 
        var myParam = window.location.href.split('tabName=')[1];
        //console.log('myParam'+myParam);
        if(myParam === '' || typeof myParam === undefined || myParam === '#' || myParam ==null) 
        {
            //console.log('inside if'+myParam);
            helper.onClickOperationSupport(component,event,helper);
        }
        else
        {
           // console.log('inside else'+myParam);
            myParam=myParam.split('&')[0];
            if(myParam ==='cancelTab'){
            helper.onClickCancellation(component,event,helper);
            }
            if(myParam ==='amTab')
            {
                helper.onClickAccMaintanance(component,event,helper);
            } 
            if(myParam ==='asTab')
            {
                helper.onClickAccSupport(component,event,helper); 
            }
            if(myParam ==='cfTab')
            {
                helper.onClickCleentForms(component,event,helper);
            } 
            if(myParam ==='crTab')
            {
                helper.onClickClientRequest(component,event,helper);
            } 
        }
    },
    onClickOperationSupport: function(component, event, helper) 
    {
        helper.onClickOperationSupport(component,event,helper);
    },
    onClickCancellation: function(component, event, helper) 
    {
        helper.onClickCancellation(component,event,helper);
    },
    onClickAccMaintanance: function(component, event, helper) 
    {
        helper.onClickAccMaintanance(component,event,helper);
    },
     onClickAccSupport: function(component, event, helper) 
    {
        helper.onClickAccSupport(component,event,helper);
    },
     onClickCleentForms: function(component, event, helper) 
    {
        helper.onClickCleentForms(component,event,helper);
    },  
     onClickClientRequest: function(component, event, helper) 
    {
        helper.onClickClientRequest(component,event,helper);
    }, 
    
    
})