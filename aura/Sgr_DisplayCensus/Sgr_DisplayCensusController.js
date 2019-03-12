({
    doInit : function(component, event, helper) {
        console.log("doInit:enter");
        var tabName = component.get("v.CurrentTabName");
        var activeOppBAs = component.get("c.getActiveOppBA");
        activeOppBAs.setParams({
            oppId : component.get("v.recordId")
        });
        activeOppBAs.setCallback(this,function(response){
            var state = response.getState();
            console.log('activeOppBAs state '+state);
            if(state==='SUCCESS'){
                var oba = response.getReturnValue();
                console.log('obaw controller '+JSON.stringify(oba));
                if(oba!=null){
                    component.set("v.baCheckResults",oba);
                }
                helper.processBaCheckResults(component, event, helper);
                
            } else if(state == 'ERROR') {
                console.log('Error retrieving active opportunities for cesnsus tabs');
            }
        });
        $A.enqueueAction(activeOppBAs);
		
        var opps = component.get("c.getOpportunityData");
        opps.setParams({
            oppId : component.get("v.recordId"),
            tabName : tabName
        });
        opps.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var editRecord = response.getReturnValue();
                

                component.set("v.booleanVar",editRecord);
                var CommonHeaders1 = helper.genCommonHeaders(component);
                component.set("v.Headers",CommonHeaders1);
                var HealthHeaders = CommonHeaders1;
                HealthHeaders.splice(12,0,{label: 'Health Tier', fieldName: 'Health_Tier__c', type: 'text', initialWidth:120});
                HealthHeaders.splice(13,0,{label: 'Health Plan Id', fieldName: 'Health_Plan_ID__c', type: 'text', initialWidth:120});
                HealthHeaders.splice(14,0,{label: 'Group #', fieldName: 'Health_Group_Number__c', type: 'text', initialWidth:117});
                HealthHeaders.splice(15,0,{label: 'Section #', fieldName: 'Health_Group_Section__c', type: 'text', initialWidth:117});
                
                component.set("v.HealthHeaders",HealthHeaders);
                //alert(JSON.stringify(component.get("v.HealthHeaders")));
                
                var DentalHeaders = component.get("v.Headers");
                DentalHeaders.splice(12,0,{label: 'Dental Tier', fieldName: 'Dental_Tier__c', type: 'text', initialWidth:140});
                DentalHeaders.splice(13,0,{label: 'Dental Plan Id', fieldName: 'Dental_Plan_ID__c', type: 'text', initialWidth:143});
                DentalHeaders.splice(14,0,{label: 'Group #', fieldName: 'Dental_Group_Number__c', type: 'text', initialWidth:117});
                DentalHeaders.splice(15,0,{label: 'Section #', fieldName: 'Dental_Group_Section__c', type: 'text', initialWidth:117});
                
                component.set("v.DentalHeaders",DentalHeaders);
                
                var VisionHeaders = component.get("v.Headers");
                VisionHeaders.splice(12,1,{label: 'Vision Tier', fieldName: 'Vision_Tier__c', type: 'text', initialWidth:135});
                VisionHeaders.splice(13,1,{label: 'Vision Plan Id', fieldName: 'Vision_Plan_ID__c', type: 'text', initialWidth:145});
                VisionHeaders.splice(14,1,{label: 'Group #', fieldName: 'Vision_Group_Number__c', type: 'text', initialWidth:117});
                VisionHeaders.splice(15,1,{label: 'Section #', fieldName: 'Vision_Group_Section__c', type: 'text', initialWidth:117});
                component.set("v.VisionHeaders",VisionHeaders);
            }
        });
        $A.enqueueAction(opps);           
        
        helper.showSubscribersOnly(component, event, helper);
        
        //vijaya
        helper.isDisableDelete(component, event, helper);   
        helper.getOpportunityFields(component, event, helper);
    },
    
    loadFirstTab : function(component, event, helper) {
        // do whatever you want
    },
    LightningEvent : function(component, event, helper) {
        helper.refreshParent(component, event, helper);
    },
    
    loadSecondTab : function(component, event, helper) {
        // do whatever you want
    },
    handleValidationsAndSave: function(component, event, helper){
        
        var details = component.get("v.data");
        var isError = false;
        if(details.Status == 'Underwriting Release' || details.Status == 'Sold' || details.Status == 'Finalised' || details.Status == 'Closed'){
            component.set("v.isRatingStatus",'Fields cannot be edited for the Status');
            isError = true;
        }
    },
    /*handleSaveEdition : function(component, event, helper){
        var censusList = component.get("v.CensusList");
        var oppCensusList = [];
        var errorMessage = '';
        for(var i=0;i<censusList.length;i++){
            if((censusList[i].Date_of_Birth__c==undefined || censusList[i].Date_of_Birth__c=='' || censusList[i].Date_of_Birth__c==null) && (censusList[i].Age_New__c==undefined || censusList[i].Age_New__c=='' || censusList[i].Age_New__c==null )){
                	errorMessage = 'Either one of Date of Birth or Age must be entered';
            }else{
                oppCensusList.push(censusList[i]);
            }           
            if (errorMessage != undefined && errorMessage != '' && errorMessage != null) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": errorMessage,
                    "type": "error",
                    "mode": "sticky",
                    "duration": "500"
                });
                toastEvent.fire();
                return false;
        	}
        }
        if(oppCensusList.length>0){
            helper.saveOptyCensus(component,oppCensusList);
        }
    },*/
    handleCancel : function(component, event, helper){
        component.set("v.showSaveCancelBtn",false);
        helper.showSubscribersOnly(component, event, helper);
    },
    addRowHealth : function(component, event, helper){
        var newList = component.get("v.CensusListHealth");
        newList.push({
            'Opportunity__c' :  component.get("v.recordId")          
        });
        component.set("v.CensusListHealth",newList);
    },
    addRowDental : function(component, event, helper){
        var newList = component.get("v.CensusList");
        newList.push({
            'Opportunity__c' :  component.get("v.recordId"),
            // 'Dental_Plan_Id__c' : 
        });
        component.set("v.CensusList",newList);
    },
    addRowVision : function(component, event, helper){
        var newList = component.get("v.CensusListVision");
        newList.push({
            'Opportunity__c' :  component.get("v.recordId")          
        });
        component.set("v.CensusListVision",newList);
    },
    DentalHeaders : function(component, event, helper){
        var TabfilterDental1=component.get("v.TabfilterDental");
        if(TabfilterDental1===false){
            helper.showSubscribersOnly(component, event, helper);
        }
        else{
            var dI=component.get("c.handleSubDepLink");
            $A.enqueueAction(dI);
        }
        component.set("v.CurrentTabName","Dental");
        var dentalCensusRecords = component.get("v.CensusList");
        var subscribercount=0;
        var memberscount=0;
        for(var i=0; i<dentalCensusRecords.length;i++){
            memberscount = memberscount+1;
            if(dentalCensusRecords[i].Relationship__c=='Subscriber'){
                subscribercount = subscribercount+1;
            }
        }
        
        component.set("v.totalSubscribers",subscribercount);
        component.set("v.totalMembers",subscribercount);
        
    },
    VisionHeaders : function(component, event, helper){
        var TabfilterVision1=component.get("v.TabfilterVision");
        if(TabfilterVision1===false){
            helper.showSubscribersOnly(component, event, helper);
        }
        else{
            var dI=component.get("c.handleSubDepLink");
            $A.enqueueAction(dI);
        }
        component.set("v.CurrentTabName","Vision");
        var visionCensusRecords = component.get("v.CensusListVision");
        var subscribercount=0;
        var memberscount=0;
        for(var i=0; i<visionCensusRecords.length;i++){
            memberscount = memberscount+1;
            if(visionCensusRecords[i].Relationship__c=='Subscriber'){
                subscribercount = subscribercount+1;
            }
        }
        component.set("v.totalSubscribers",subscribercount);
        component.set("v.totalMembers",subscribercount);
    },
    HealthHeaders : function(component, event, helper){
        var TabfilterHealth1=component.get("v.TabfilterHealth");
        if(TabfilterHealth1===false ){
            helper.showSubscribersOnly(component, event, helper);
        }
        else{
            var dI=component.get("c.handleSubDepLink");
            $A.enqueueAction(dI);
        }
        component.set("v.CurrentTabName","Health");
        var HealthCensusRecords = component.get("v.CensusListHealth");
        var subscribercount=0;
        var memberscount=0;
        for(var i=0; i<HealthCensusRecords.length;i++){
            memberscount = memberscount+1;
            if(HealthCensusRecords[i].Relationship__c=='Subscriber'){
                subscribercount = subscribercount+1;
            }
        }
        component.set("v.totalSubscribers",subscribercount);
        component.set("v.totalMembers",subscribercount);
    },
    handlesubscriberfilter: function(component, event, helper){
        console.log("handlesubscriberfilter:enter");
        if(component.get("v.Healthfilter")===false){
            console.log("handlesubscriberfilter:firing init");
            var dI=component.get("c.doInit");
            $A.enqueueAction(dI);
        }
        else{
            console.log("handlesubscriberfilter:firing handleSubDepLink");
            var HI=component.get("c.handleSubDepLink");
            $A.enqueueAction(HI); 
        }
        
    },
    
    handleSubLink : function(component, event, helper){
        component.set("v.Deletecen",false);
        component.set("v.Healthfilter",false);
        if(component.get("v.CurrentTabName")=="Health"){
            component.set("v.TabfilterHealth",false);
        }
        if(component.get("v.CurrentTabName")=="Dental"){
            component.set("v.TabfilterDental",false);
        }
        if(component.get("v.CurrentTabName")=="Vision"){
            component.set("v.TabfilterVision",false);
        }
        helper.showSubscribersOnly(component, event, helper);
    },
    handleSubDepLink : function(component, event, helper){
        console.log("handleSubDepLink:enter");
        component.set("v.Deletecen",true);
        component.set("v.Healthfilter",true);
        if(component.get("v.CurrentTabName")=="Health"){
            component.set("v.TabfilterHealth",true);
        }
        if(component.get("v.CurrentTabName")=="Dental"){
            component.set("v.TabfilterDental",true);
        }
        if(component.get("v.CurrentTabName")=="Vision"){
            component.set("v.TabfilterVision",true);
        }
        /*var action=component.get("c.showSubscribersAndDependents");
        var recordId=component.get("v.recordId");
        action.setParams({
            "oppId":recordId,
            "Tier": component.get("v.CurrentTabName")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                component.set("v.CensusList",response.getReturnValue());
                helper.getData(component, event, helper);
            }
        });
        $A.enqueueAction(action);*/
        helper.initializeData(component, false);
    },
    handleNewRow : function(component,event,helper){   
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(JSON.stringify(row));
        var numberOfDependents = component.get("v.totalMembers") - component.get("v.totalSubscribers") ;
        if(action.name=='new_record'){
            if(row.Row__c=='' || row.Row__c==null || row.Row__c==undefined){
                alert("Please select the record having Subscriber #.");
            }
            else{
                var compEvent = $A.get("e.c:SGR_DisplayCensusGetRow");//component.getEvent("CensusGetRow");
                compEvent.setParams({
                    'OptyCensus' : event.getParam('row'),//Sending current cesnsus record to event
                    'NumberOfDependents' : numberOfDependents,
                    
                });
                compEvent.fire();
                component.set("v.openPopup",true);
            }
            var lightningEvent = $A.get("e.c:RatingStatusRefresh");
            lightningEvent.setParams({
                "message" : "An application event fired me." });
            lightningEvent.fire();
        } 
        else if(action.name=='edit_record'){
            var CensusRecord = event.getParam('row');
            console.log('++Opp'+JSON.stringify(component.get("v.Opportunity")));
            if(CensusRecord.Relationship__c=='Subscriber'){
                var evt = $A.get("e.force:navigateToComponent");
                console.log('Event '+evt);
                var recordId = component.get("v.recordId");
                evt.setParams({
                    componentDef  : "c:Sgr_AddSubscriberModal" ,
                    componentAttributes : {
                        oppId : recordId,
                        tabName : component.get("v.CurrentTabName"),
                        CensusRecord : CensusRecord,
                        context : 'Edit Census',
                        Opportunity : component.get("v.Opportunity")
                    }
                    
                });
                evt.fire();                       
            }else{
                var compEvent = $A.get("e.c:SGR_DisplayCensusGetRow");//component.getEvent("CensusGetRow");
                compEvent.setParams({
                    'OptyCensus' : event.getParam('row'),//Sending current cesnsus record to event
                    'NumberOfDependents' : numberOfDependents,
                    'context' : 'Edit Census',
                    'tabName' : component.get("v.CurrentTabName")
                });
                compEvent.fire();
                component.set("v.openPopup",true);
                var lightningEvent1 = $A.get("e.c:RatingStatusRefresh");
                lightningEvent1.setParams({
                    "message" : "An application event fired me." });
                lightningEvent1.fire();
            }
            var lightningEvent = $A.get("e.c:RatingStatusRefresh");
            lightningEvent.setParams({
                "message" : "An application event fired me." });
            lightningEvent.fire();
        }
        //console.log('Are you there popu '+component.get("c:SGR_DisplayCensusPopup"));
        
    },
    CloseEventHandler : function(component,event,helper){
        /*alert(event.getParam("Confirmed"));
        if(event.getParam("Confirmed")==true){
            helper.getData();
        }*/
        component.set("v.openPopup",false);
        console.log(component.get("v.openPopup"));
        // compEvent.setParams({
        // 'OptyCensus' : null,//Sending current cesnsus record to event
        
        // });
        //var dI=component.get("c.doInit");
        //$A.enqueueAction(dI);
    },
    //vijaya Delete Cencus records
    getSelectedRows : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');  
        var setRows = [];
        for (var i = 0; i < selectedRows.length; i++){
            setRows.push(selectedRows[i].Id);
        }
        console.log(setRows);
        component.set("v.rowsSelected", setRows); // <-- Crashed datatable if "v.selectedRows"
    },
    
    handleDelete : function(component, event, helper){
        component.set("v.ShowPopup",true);
        component.set("v.buttonName","HealthDelete");
        component.set("v.headerTxt","Delete Confirmation");
    },
    
    deleteHealthCensus : function(component, event, helper){
        //if(confirm("Do you Really want to delete..?"))
        helper.deleteHealthCensus(component, event, helper);
        //helper.refreshParent(component, event, helper);
        /*var lightningEvent = $A.get("e.c:refreshOptyRatingStatus");
        	lightningEvent.setParams({
            "message" : "An application event fired me." });
       		lightningEvent.fire();*/
        //roopa
        //var initAction = component.get('c.doInit'); 
        //$A.enqueueAction(initAction);
        var lightningEvent = $A.get("e.c:RatingStatusRefresh");
        lightningEvent.setParams({
            "message" : "An application event fired me." });
        lightningEvent.fire();
        
    },
    
    handleDental : function(component, event, helper){
        component.set("v.ShowPopup",true);
        component.set("v.buttonName","HandleDental");
        component.set("v.headerTxt","Delete Confirmation");
    },
    deleteDentalCensus : function(component, event, helper){
        //if(confirm("Do you Really want to delete..?"))
        helper.deleteDentalCensus(component, event, helper);
        
    },
    isRefreshed : function(component, event, helper){
        helper.isRefreshed(component, event, helper);
    }, 
    addSubscriber : function(component, event, helper){
        //component.set("v.addSubscriberModal",true);
        
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        var recordId = component.get("v.recordId");
        evt.setParams({
            componentDef  : "c:Sgr_AddSubscriberModal" ,
            componentAttributes : {
                oppId : recordId,
                tabName : component.get("v.CurrentTabName"),
                context : 'Add New Subscriber',
                Opportunity : component.get("v.Opportunity")
            }
        });
        evt.fire();
        var lightningEvent = $A.get("e.c:RatingStatusRefresh");
        lightningEvent.setParams({
            "message" : "An application event fired me." });
        lightningEvent.fire();
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", "true"); 
    },
    hideSpinner: function(component, event, helper) {
        component.set("v.spinner", "false");
    },
    handleRefresh : function(component, event, helper){
        // Start - JIRA # SFDC - 15909 - Verify Logged in user profile name to perform the Refresh action- by Balasubramanyam.Peri(Accenture)
        
        var loggedInUserProfileName;  
        //calling getOppData in init
        loggedInUserProfileName=component.get("v.Opportunity").CurrentUserProfileName__c;
        console.log('LoggedInUserRefresh->'+loggedInUserProfileName);
        if(loggedInUserProfileName=="SGR Operations User" || loggedInUserProfileName=="SGR SAM User" || loggedInUserProfileName=="SGR_Group Verifier")
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "Your profile is restricted to Refresh Census!",
                type: "Error"
            });
            toastEvent.fire();
        }
        else{
            console.log("Refresh Clicked");
            component.set("v.ShowPopup",true);
            component.set("v.buttonName","RefreshCensus");
            component.set("v.headerTxt","Refresh Confirmation");
        }
               
        // End - JIRA # SFDC - 15909 
    },
    UpdateRefresh:function(component,event,helper)
    {
        component.set("v.ShowPopup",false);
        var confirmed = event.getParam("Confirmed");
        if(confirmed===true){
            var action=component.get("c.refreshCensusData");
            var oppRecord=component.get("v.recordId");
            action.setParams({
                "oppId":oppRecord
            });
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state==='SUCCESS'){
                    //component.set("v.CensusList",response.getReturnValue());
                    //helper.getData(component, event, helper);
                    
                    var initAction = component.get('c.doInit'); 
                    $A.enqueueAction(initAction);
                    
                    var lightningEvent = $A.get("e.c:RatingStatusRefresh");
                    lightningEvent.setParams({
                        "message" : "An application event fired me." });
                    lightningEvent.fire();
                    
                }
            });
            $A.enqueueAction(action);
        }            
    },
    handleLightningEvent : function(component, event, helper){
        ;
    }, 
    
    fireApplicationEvent : function(cmp, event, helper) {
        var lightningEvent = $A.get("e.c:refreshOptyRatingStatus");
        lightningEvent.fire();
    },
    // Added by Ravi - start
    handleIncludeExcludeBAModification : function(component, event, helper) {
        var marketingPlanNumber = event.getParam("marketingPlanNumber");
        var lineOfBusiness = event.getParam("lineOfBusiness");
        var IsItForIncludeBA = event.getParam("IsItForIncludeBA");
        var marketingPlanNumberLst = [];
        marketingPlanNumberLst.push(component.get('v.marketingPlanNumber'));
        marketingPlanNumberLst.push(marketingPlanNumber);
        component.set('v.marketingPlanNumber',marketingPlanNumber);
        helper.processBAModification(component, event,marketingPlanNumber, lineOfBusiness, IsItForIncludeBA,helper);        
    }
})