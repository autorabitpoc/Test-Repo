({
	onClickOperationSupport: function(component, event, helper) 
    {      
        console.log('inside helper os');
        var operationTab = component.find('osTab');
        var osTabData = component.find('osTabData');
        
        var cancelTab = component.find('cancelTab');
        var cancelTabData = component.find('cancelTabData');
        
        var amTab = component.find('amTab');
        var amTabData = component.find('amTabData'); 

        var asTab = component.find('asTab');
        var asTabData = component.find('asTabData');   

        var cfTab = component.find('cfTab');  
        var cfTabData = component.find('cfTabData');   
        
        var crTab = component.find('crTab');  
        var crTabData = component.find('crTabData');
        
        $A.util.addClass(operationTab, 'slds-is-active');
        $A.util.addClass(osTabData, 'slds-show');
        $A.util.removeClass(osTabData, 'slds-hide');
        component.set("v.operationTabSelected", true);
        
        $A.util.removeClass(cancelTab, 'slds-is-active');
        $A.util.removeClass(cancelTabData, 'slds-show');
        $A.util.addClass(cancelTabData, 'slds-hide');
        component.set("v.cancelTabSelected", false);
        
        $A.util.removeClass(amTab, 'slds-is-active');
        $A.util.removeClass(amTabData, 'slds-show');
        $A.util.addClass(amTabData, 'slds-hide');
        component.set("v.amTabSelected", false);
        
        $A.util.removeClass(asTab, 'slds-is-active');
        $A.util.removeClass(asTabData, 'slds-show');
        $A.util.addClass(asTabData, 'slds-hide');
        component.set("v.asTabSelected", false);
        
        $A.util.removeClass(cfTab, 'slds-is-active');
        $A.util.removeClass(cfTabData, 'slds-show');
        $A.util.addClass(cfTabData, 'slds-hide');
        component.set("v.cfTabSelected", false);
        
        $A.util.removeClass(crTab, 'slds-is-active');
        $A.util.removeClass(crTabData, 'slds-show');
        $A.util.addClass(crTabData, 'slds-hide');
        component.set("v.crTabSelected", false);
        
    },
    onClickCancellation: function(component, event, helper) 
    {        
         console.log('inside helper cancel');
        var operationTab = component.find('osTab');
        var osTabData = component.find('osTabData');
        
        var cancelTab = component.find('cancelTab');
        var cancelTabData = component.find('cancelTabData');
        
        var amTab = component.find('amTab');
        var amTabData = component.find('amTabData'); 

        var asTab = component.find('asTab');
        var asTabData = component.find('asTabData');   

        var cfTab = component.find('cfTab');  
        var cfTabData = component.find('cfTabData');   
        
        var crTab = component.find('crTab');  
        var crTabData = component.find('crTabData');
     
        $A.util.addClass(cancelTab, 'slds-is-active');
        $A.util.addClass(cancelTabData, 'slds-show');
        $A.util.removeClass(cancelTabData, 'slds-hide');
        component.set("v.cancelTabSelected", true);
        
        $A.util.removeClass(operationTab, 'slds-is-active');
        $A.util.removeClass(osTabData, 'slds-show');
        $A.util.addClass(osTabData, 'slds-hide');
        component.set("v.operationTabSelected", false);       
        
       $A.util.removeClass(amTab, 'slds-is-active');
        $A.util.removeClass(amTabData, 'slds-show');
        $A.util.addClass(amTabData, 'slds-hide');
        component.set("v.amTabSelected", false);
        
        $A.util.removeClass(asTab, 'slds-is-active');
        $A.util.removeClass(asTabData, 'slds-show');
        $A.util.addClass(asTabData, 'slds-hide');
        component.set("v.asTabSelected", false);
        
        $A.util.removeClass(cfTab, 'slds-is-active');
        $A.util.removeClass(cfTabData, 'slds-show');
        $A.util.addClass(cfTabData, 'slds-hide');
        component.set("v.cfTabSelected", false);
        
        $A.util.removeClass(crTab, 'slds-is-active');
        $A.util.removeClass(crTabData, 'slds-show');
        $A.util.addClass(crTabData, 'slds-hide');
        component.set("v.crTabSelected", false);
    },
   onClickAccMaintanance: function(component, event, helper) 
    {        
         console.log('inside helper cancel');
        var operationTab = component.find('osTab');
        var osTabData = component.find('osTabData');
        
        var cancelTab = component.find('cancelTab');
        var cancelTabData = component.find('cancelTabData');
        
        var amTab = component.find('amTab');
        var amTabData = component.find('amTabData'); 

        var asTab = component.find('asTab');
        var asTabData = component.find('asTabData');   

        var cfTab = component.find('cfTab');  
        var cfTabData = component.find('cfTabData');   
        
        var crTab = component.find('crTab');  
        var crTabData = component.find('crTabData');
     
        $A.util.addClass(amTab, 'slds-is-active');
        $A.util.addClass(amTabData, 'slds-show');
        $A.util.removeClass(amTabData, 'slds-hide');
        component.set("v.amTabSelected", true);
        
        $A.util.removeClass(operationTab, 'slds-is-active');
        $A.util.removeClass(osTabData, 'slds-show');
        $A.util.addClass(osTabData, 'slds-hide');
        component.set("v.operationTabSelected", false);   

        $A.util.removeClass(cancelTab, 'slds-is-active');
        $A.util.removeClass(cancelTabData, 'slds-show');
        $A.util.addClass(cancelTabData, 'slds-hide');
        component.set("v.cancelTabSelected", false);
        
        $A.util.removeClass(asTab, 'slds-is-active');
        $A.util.removeClass(asTabData, 'slds-show');
        $A.util.addClass(asTabData, 'slds-hide');
        component.set("v.asTabSelected", false);
        
        $A.util.removeClass(cfTab, 'slds-is-active');
        $A.util.removeClass(cfTabData, 'slds-show');
        $A.util.addClass(cfTabData, 'slds-hide');
        component.set("v.cfTabSelected", false);
        
        $A.util.removeClass(crTab, 'slds-is-active');
        $A.util.removeClass(crTabData, 'slds-show');
        $A.util.addClass(crTabData, 'slds-hide');
        component.set("v.crTabSelected", false);
    },
    onClickAccSupport: function(component, event, helper) 
    {        
         console.log('inside helper cancel');
        var operationTab = component.find('osTab');
        var osTabData = component.find('osTabData');
        
        var cancelTab = component.find('cancelTab');
        var cancelTabData = component.find('cancelTabData');
        
        var amTab = component.find('amTab');
        var amTabData = component.find('amTabData'); 

        var asTab = component.find('asTab');
        var asTabData = component.find('asTabData');   

        var cfTab = component.find('cfTab');  
        var cfTabData = component.find('cfTabData');   
        
        var crTab = component.find('crTab');  
        var crTabData = component.find('crTabData');
     
        $A.util.addClass(asTab, 'slds-is-active');
        $A.util.addClass(asTabData, 'slds-show');
        $A.util.removeClass(asTabData, 'slds-hide');
        component.set("v.asTabSelected", true);
        
        $A.util.removeClass(operationTab, 'slds-is-active');
        $A.util.removeClass(osTabData, 'slds-show');
        $A.util.addClass(osTabData, 'slds-hide');
        component.set("v.operationTabSelected", false);   

        $A.util.removeClass(cancelTab, 'slds-is-active');
        $A.util.removeClass(cancelTabData, 'slds-show');
        $A.util.addClass(cancelTabData, 'slds-hide');
        component.set("v.cancelTabSelected", false);
        
        $A.util.removeClass(amTab, 'slds-is-active');
        $A.util.removeClass(amTabData, 'slds-show');
        $A.util.addClass(amTabData, 'slds-hide');
        component.set("v.amTabSelected", false);
        
        $A.util.removeClass(cfTab, 'slds-is-active');
        $A.util.removeClass(cfTabData, 'slds-show');
        $A.util.addClass(cfTabData, 'slds-hide');
        component.set("v.cfTabSelected", false);
        
        $A.util.removeClass(crTab, 'slds-is-active');
        $A.util.removeClass(crTabData, 'slds-show');
        $A.util.addClass(crTabData, 'slds-hide');
        component.set("v.crTabSelected", false);
    },
    onClickCleentForms: function(component, event, helper) 
    {        
         console.log('inside helper cancel');
        var operationTab = component.find('osTab');
        var osTabData = component.find('osTabData');
        
        var cancelTab = component.find('cancelTab');
        var cancelTabData = component.find('cancelTabData');
        
        var amTab = component.find('amTab');
        var amTabData = component.find('amTabData'); 

        var asTab = component.find('asTab');
        var asTabData = component.find('asTabData');   

        var cfTab = component.find('cfTab');  
        var cfTabData = component.find('cfTabData');  
       
        var crTab = component.find('crTab');  
        var crTabData = component.find('crTabData');
     
        $A.util.addClass(cfTab, 'slds-is-active');
        $A.util.addClass(cfTabData, 'slds-show');
        $A.util.removeClass(cfTabData, 'slds-hide');
        component.set("v.cfTabSelected", true);
        
        $A.util.removeClass(operationTab, 'slds-is-active');
        $A.util.removeClass(osTabData, 'slds-show');
        $A.util.addClass(osTabData, 'slds-hide');
        component.set("v.operationTabSelected", false);   

        $A.util.removeClass(cancelTab, 'slds-is-active');
        $A.util.removeClass(cancelTabData, 'slds-show');
        $A.util.addClass(cancelTabData, 'slds-hide');
        component.set("v.cancelTabSelected", false);
        
        $A.util.removeClass(amTab, 'slds-is-active');
        $A.util.removeClass(amTabData, 'slds-show');
        $A.util.addClass(amTabData, 'slds-hide');
        component.set("v.amTabSelected", false);
        
        $A.util.removeClass(asTab, 'slds-is-active');
        $A.util.removeClass(asTabData, 'slds-show');
        $A.util.addClass(asTabData, 'slds-hide');
        component.set("v.asTabSelected", false);
        
        $A.util.removeClass(crTab, 'slds-is-active');
        $A.util.removeClass(crTabData, 'slds-show');
        $A.util.addClass(crTabData, 'slds-hide');
        component.set("v.crTabSelected", false);
    },
    
    onClickClientRequest: function(component, event, helper) 
    {        
         console.log('inside helper cancel');
        var operationTab = component.find('osTab');
        var osTabData = component.find('osTabData');
        
        var cancelTab = component.find('cancelTab');
        var cancelTabData = component.find('cancelTabData');
        
        var amTab = component.find('amTab');
        var amTabData = component.find('amTabData'); 

        var asTab = component.find('asTab');
        var asTabData = component.find('asTabData');   

        var cfTab = component.find('cfTab');  
        var cfTabData = component.find('cfTabData');   
        
        var crTab = component.find('crTab');  
        var crTabData = component.find('crTabData');   

     
        $A.util.addClass(crTab, 'slds-is-active');
        $A.util.addClass(crTabData, 'slds-show');
        $A.util.removeClass(crTabData, 'slds-hide');
        component.set("v.crTabSelected", true);
        
        $A.util.removeClass(operationTab, 'slds-is-active');
        $A.util.removeClass(osTabData, 'slds-show');
        $A.util.addClass(osTabData, 'slds-hide');
        component.set("v.operationTabSelected", false);   

        $A.util.removeClass(cancelTab, 'slds-is-active');
        $A.util.removeClass(cancelTabData, 'slds-show');
        $A.util.addClass(cancelTabData, 'slds-hide');
        component.set("v.cancelTabSelected", false);
        
        $A.util.removeClass(amTab, 'slds-is-active');
        $A.util.removeClass(amTabData, 'slds-show');
        $A.util.addClass(amTabData, 'slds-hide');
        component.set("v.amTabSelected", false);
        
        $A.util.removeClass(asTab, 'slds-is-active');
        $A.util.removeClass(asTabData, 'slds-show');
        $A.util.addClass(asTabData, 'slds-hide');
        component.set("v.asTabSelected", false);
        
        $A.util.removeClass(cfTab, 'slds-is-active');
        $A.util.removeClass(cfTabData, 'slds-show');
        $A.util.addClass(cfTabData, 'slds-hide');
        component.set("v.cfTabSelected", false);
    },
    
})