({
	handleNext : function(component, event, helper) {
		var isValudationSuiccess = true;
        component.find("selectRenType").showHelpMessageIfInvalid();
        component.find("selectDivision").showHelpMessageIfInvalid();
		var selectedAccNum = component.get('v.selectedAccNum');
        
        if(!component.find("selectRenType").get("v.validity").valid 
          			|| !component.find("selectDivision").get("v.validity").valid
          			|| selectedAccNum ==''
          ){            
        	isValudationSuiccess = false;
        }        
        // validating Account number    
        if(selectedAccNum == ''){
            $A.util.addClass(component.find('selectedAccNum'), 'slds-has-error');
            component.find('selectedAccNum').set('v.errors',[{message:"Please enter an Account Number "}]);
            isValudationSuiccess = false;
        }else{
           $A.util.removeClass(component.find('selectedAccNum'), 'slds-has-error');
           component.find('selectedAccNum').set('v.errors',null);
        }
        if(!isValudationSuiccess){
            return;
        }
        helper.searchAccount(component);
         component.set("v.Triggerdisable",true);
	},
    handleCancel: function(component, event, helper) {        
        var cmpEvent = component.getEvent("closeTrigRenEvent");        
        cmpEvent.fire();                       
    },
    handleBack: function(component, event, helper) {     
        component.set('v.accountObj', null);
    },
    handleTrigger: function(component, event, helper) {
        var hasRenewalDate = true;
        if(component.find('rDate').get("v.value") == ''){
            $A.util.addClass(component.find('rDate'), 'slds-has-error');
            component.find('rDate').set('v.errors',[{message:"Please select a Renewal Date "}]);
            hasRenewalDate = false;
        } else {
           $A.util.removeClass(component.find('rDate'), 'slds-has-error');
           component.find('rDate').set('v.errors',null);
        }
        if(!hasRenewalDate) {
            return;
        } 
            helper.handleTrigger(component);
            component.set("v.Triggerdisable1",true);
                
    },
      showSpinner: function(component, event, helper) {
        component.set("v.spinner", "true"); 
    },
    hideSpinner: function(component, event, helper) {
        component.set("v.spinner", "false");
    }
    
    
})