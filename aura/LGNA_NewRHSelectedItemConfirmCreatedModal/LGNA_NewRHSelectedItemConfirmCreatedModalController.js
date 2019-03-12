({
	doInit:function(component,event){
	//initialize 
	       
        var cmpTarget = component.find('Modalbox');
       	var cmpBack = component.find('MB-Back');
        
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');        
         component.set("v.createdModelConfirm_Case",true); //Ranjit G- 9626 - start
        },
   
    closeCreatedModel:function(component,event,helper){
        
         //Ranjit G- 9626 - start
        component.set("v.createdModelConfirm_Case",false);
        component.set("v.createdModelConfirm_ContractAdmin",false);
        //Ranjit G- 9626 - end
        
    },
    detailPage : function(component, event, helper) {
        var url= '/'+ component.get("v.caseId");
        window.open(url,"_parent");
        //Ranjit G- 9626 - start
        component.set("v.createdModelConfirm_Case",false);
          component.set("v.createdModelConfirm_ContractAdmin",false);
        //Ranjit G- 9626 - end
    }    
   
})