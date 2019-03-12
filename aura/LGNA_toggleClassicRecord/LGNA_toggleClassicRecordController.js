({
    redirectToClassicRecordPage : function(component, event, helper) {
        var recordId = component.get("v.recordId");        
        var classicHomePage = window.open(
              "/ltng/switcher?destination=classic"
        );  
        setTimeout(function() {
            classicHomePage.close(); 
            var classicRecordPage = window.open(
            "/" + recordId
                );    
        }, 300);
    }
})