({
	doInit : function(component, event, helper) {
        /*var EID =0;
        var RecId=component.get("v.recordId");
        console.log('recid'+RecId);
        var LA = "0";     
        var redirection = "/apex/dsfs__DocuSign_CreateEnvelope?DSEID="+EID+"&SourceID="+RecId+"&LA="+LA;
        component.set("v.Redirection",redirection);
        */	
    },
    
    gotoURL: function (component,event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        var EID =0;
        var RecId=component.get("v.recordId");
        console.log('recid'+RecId);
        var LA = "0"; 
        var redirection = "/apex/dsfs__DocuSign_CreateEnvelope?DSEID="+EID+"&SourceID="+RecId+"&LA="+LA;

        urlEvent.setParams({ "url": redirection});

       urlEvent.fire();

    }
})