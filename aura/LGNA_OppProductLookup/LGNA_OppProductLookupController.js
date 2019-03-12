({
    doInit : function(component, event, helper) {
	var AccId = component.get("v.selectedRecordId");
        	var AccId2 = component.get("v.selectedRecord");
    //alert('==AccId2=='+AccId2);
        //alert('=Lookup AccId='+AccId);
		component.set("v.SearchKeyWord", AccId);
       // component.set("v.isInitial",false);
      //  if(component.get('v.isCarrier')){
       //    component.set('v.initialWinninCarrier', component.get("v.selectedRecordId"));//initalized the selected record
       // }
	},
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
       component.set("v.isInitial",false);
       
    },
  
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.isInitial",false);
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
       
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
              component.set("v.selectedRecord",null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
        
        component.set("v.isInitial",false);
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
        // component.set("v.selectedRecord", {} ); 
         component.set("v.selectedRecord",null );   
         component.set("v.isInitial",false);
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       //var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent").Id;
        var selectedAccountGetFromEventName = event.getParam("recordByEvent").Name;
    //    alert('=xxx='+event.getParam("recordByEvent").Name);
     //   alert('=xxx='+event.getParam("recordByEvent").Id);
	   //component.set("v.SearchKeyWord" , selectedAccountGetFromEvent); 
        component.set("v.selectedRecordName",selectedAccountGetFromEventName);
        component.set("v.selectedRecord",selectedAccountGetFromEvent);
        component.set("v.isInitial",false);
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
})