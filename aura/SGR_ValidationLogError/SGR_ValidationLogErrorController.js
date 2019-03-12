({
	doInit : function(component, event, helper) {
        /*component.set("v.columns", [
            {label: 'RULE ID', fieldName:'Rule_ID__c', type:'text', sortable:'true'},
            {label: 'TYPE', fieldName:'Rule_Type__c', type:'text', sortable:'true'},
            {label: 'RULE DESCRIPTION', fieldName:'Rule_Description__c', type:'text', sortable:'true'},            
            {label: 'VALUE', fieldName:'Fail_Pass_Reason__c', type:'text', sortable:'true'},
            {label: 'STATUS', fieldName:'Status__c', type:'text', cellAttributes: { alignment: 'left' },  sortable:'true'},
            {label: 'DATE/TIME CREATED ',fieldName:'CreatedDate',type:'date', typeAttributes:{month:'2-digit',day:'2-digit',year: '2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'},sortable:true,initialWidth:120, cellAttributes: { alignment: 'left' }}
           ]);        

       //helper.getRelatedVLList(component); 
     
    },
    
   sortRow: function(component, event, helper) {
        
       var fieldName = event.getParam("fieldName");
      var sortDirection = event.getParam("sortDirection");

      console.log('sort dir from event:'+sortDirection);
        helper.sortData(component, fieldName, sortDirection);        
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }*/
    }
})