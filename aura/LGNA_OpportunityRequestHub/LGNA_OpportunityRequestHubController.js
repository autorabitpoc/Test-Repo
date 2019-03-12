({
	 doInit: function(component, event, helper) 
    { 
        
        var recId=component.get("v.recordId");
        var action = component.get("c.getAccountId");
        action.setParams({"OpptyId":recId});
        action.setCallback(this, function(response)
                            { 
                                var state = response.getState();                                 
                                if (state === "SUCCESS") 
                                {
                                    if(response.getReturnValue()!==null){  
                                        component.set("v.accountId" ,response.getReturnValue());
                                    }
                                } 
                            });
         $A.enqueueAction(action);

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
        //console.log('inside onclick os tab');
        helper.onClickOperationSupport(component,event,helper);
        //helper.onTabItemClick(component,event,helper,"Info Tab");
    },
    onClickCancellation: function(component, event, helper) 
    {
          //console.log('inside onclick cancel tab');
        helper.onClickCancellation(component,event,helper);
        //helper.onTabItemClick(component,event,helper,"Info Tab");
    },
    onClickAccMaintanance: function(component, event, helper) 
    {
          //console.log('inside onclick oam tab');
        helper.onClickAccMaintanance(component,event,helper);
        //helper.onTabItemClick(component,event,helper,"Info Tab");
    },
     onClickAccSupport: function(component, event, helper) 
    {
        //console.log('inside onclick oas tab');
        helper.onClickAccSupport(component,event,helper);
        //helper.onTabItemClick(component,event,helper,"Info Tab");
    },
     onClickCleentForms: function(component, event, helper) 
    {
          //console.log('inside onclick cf tab');
        helper.onClickCleentForms(component,event,helper);
        //helper.onTabItemClick(component,event,helper,"Info Tab");
    }, 
    onClickClientRequest: function(component, event, helper) 
    {
        helper.onClickClientRequest(component,event,helper);
    }, 
})