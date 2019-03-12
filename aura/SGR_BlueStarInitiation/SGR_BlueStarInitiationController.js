({
    doInit : function(component, event, helper) {
        // Initialize the Months        
        var monthOpts = [];
        monthOpts.push({ label: "Month", value: "Month", selected: "true"});        
        for (var i = 1; i < 13; i++) {
            monthOpts.push({                
                label: i,
                value: i
            });
        }       
        component.find("selectMonth").set("v.options", monthOpts);
        // Initialize the Year        
        var yearOpts = [];
        var yr = (new Date()).getFullYear()-1;
        yearOpts.push({label: "Year", value: "Year", selected: "true"});        
        for (var i = 0; i < 10; i++) {
            yearOpts.push({                
                label: yr+i,
                value: yr+i
            });
        }       
        component.find("selectYear").set("v.options", yearOpts);
        component.set("v.scheduleddate", '');
    },
    handleCancel: function(component, event, helper) {       
        var cmpEvent = component.getEvent("closeTrigRenEvent");        
        cmpEvent.fire();                       
    },
    handlePostToBlueStar: function(component, event, helper) {         
        var selectedMonth = component.get("v.selectedMonth");
        var selectedYear = component.get("v.selectedYear");
        var selectedDiv = component.get("v.selectedDivision"); 
        var selectedScheduledDate = component.get("v.scheduledDate");
        var isValidationSuccess = true;                      
        var hasInitError = false;
        var now = new Date();
        var schduletomilli = new Date(selectedScheduledDate);
        
        component.find("selectmarketSeg").showHelpMessageIfInvalid();
        component.find("selectfundingType").showHelpMessageIfInvalid();
        
        if(!component.find("selectmarketSeg").get("v.validity").valid
                    || !component.find("selectfundingType").get("v.validity").valid 
                    || selectedMonth =='Month'
                    || selectedYear == 'Year'
                    || selectedDiv == ''
                    || selectedScheduledDate == ''
                    || schduletomilli < now
          ){            
            isValidationSuccess = false;    
        }
        // validating month    
        if(selectedMonth == 'Month'){
            $A.util.addClass(component.find('selectMonth'), 'slds-has-error');
            component.find('selectMonth').set('v.errors',[{message:"Please select a month "}]);            
        }else{
           $A.util.removeClass(component.find('selectMonth'), 'slds-has-error');
           component.find('selectMonth').set('v.errors',null);  
        }
        // validating Year
        if(selectedYear == 'Year'){
            $A.util.addClass(component.find('selectYear'), 'slds-has-error');
            component.find('selectYear').set('v.errors',[{message:"Please select a year "}]);            
        }else{
           component.find('selectYear').set('v.errors',null);  
            $A.util.removeClass(component.find('selectYear'), 'slds-has-error');
        }
        // validating Scheduled date
       
        if(selectedScheduledDate == '' || selectedScheduledDate == null){
            $A.util.addClass(component.find('scheduleDate'), 'slds-has-error');
            component.find('scheduleDate').set('v.errors',[{message:"Please select Date and time "}]);            
        }else{
           component.find('scheduleDate').set('v.errors',null);  
            $A.util.removeClass(component.find('scheduleDate'), 'slds-has-error');
        }
        if(schduletomilli < now){
           $A.util.addClass(component.find('scheduleDate'), 'slds-has-error');
            component.find('scheduleDate').set('v.errors',[{message:"Please select Date and time greater than today "}]);  
        }
        // validating Division
        if(selectedDiv == 'Select' || selectedDiv == ''){
            component.set("v.isMultMarkSegs",false);
            $A.util.addClass(component.find('selectDivision'), 'slds-has-error');
            component.find('selectDivision').set('v.errors',[{message:"Please select Division "}]);            
        }else if(!hasInitError){
            $A.util.removeClass(component.find('selectDivision'), 'slds-has-error');
            component.find('selectDivision').set('v.errors',null);              
        }   
        if(isValidationSuccess === false)
        {
            return ;
        }
        var isMultSelDivPass = false;
        if(null != selectedDiv && selectedDiv != ''){
            var strArr = selectedDiv.split(";");
            
            if(strArr.length >1){
                if(component.get("v.isMultMarkSegs") === false){
                    isMultSelDivPass = false;
                    component.set("v.isMultMarkSegs",true);
                    component.find('selectDivision').set('v.errors',[{message:"You have selected multiple divisions for trigger batch accounts renewal. Do you wish to proceed?"}]);
                }else{
                    isMultSelDivPass = true;
                    $A.util.removeClass(component.find('selectDivision'), 'slds-has-error');
                }                
            }else{
                isMultSelDivPass = true;
            }
        }
        if(isMultSelDivPass === true){
            helper.invokeBlueSTAR(component);
                      
        }
    },
    onMonthSelectChange: function(cmp) {
        var selectCmp = cmp.find("selectMonth");
        cmp.set("v.selectedMonth", selectCmp.get("v.value"));
    },
    onYearSelectChange: function(cmp) {
        var selectCmp = cmp.find("selectYear");
        cmp.set("v.selectedYear", selectCmp.get("v.value"));
    },
    onDivisionSelectChange: function(component, event, helper) {
        var selectCmp = component.find("selectDivision");       
        component.set("v.selectedDivision", selectCmp.get("v.value"));          
    },
    onScheduleDateSelectChange: function(component, event, helper){
        var selectCmp = component.find("scheduleDate");
        component.set("v.scheduledDate", selectCmp.get("v.value"));
    }
})