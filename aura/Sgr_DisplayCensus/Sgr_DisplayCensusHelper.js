({
    getRelatedOpps : function(component) {
        var action = component.get("c.OppCensus");
        //alert(component.get("v.recordId"));
        action.setParams(
            {
                "oppId": component.get("v.recordId"),
            }
        );
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state:'+state);
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
               data.forEach(function(record){data.Last_Name__c='/'+record.id});
               /* if (data.Zip_Code__c.length==9) 
                    
              {
       data.Zip_Code__c  = data.Zip_Code__c.substring(0,4)+'-'+data.Zip_Code__c.substring(5) ;
              }
                              else 
                              {
                                  data.Zip_Code__c  = data.Zip_Code__c;
                              }; */
                //console.log('inside  data::'+JSON.stringify(data));
                if (data.length==0) {
                    component.set('v.err',"true");
                    component.set("v.errMsg", 'No  Opportunity Census found for this opportunity');
                    return;
                }
                /*  for (var i=0; i<data.length; i++) {
                    var row = data[i];
                    // Flatten/normalize field data
                    if (row.Account) {
                        row.AccountName = row.Account.Name;
                        row.AccountNum = row.Account.External_Id__c;                        
                    } 
                   
                        row.recId = '/'+row.Id;                                           

                    if (row.Assigned_UW__r) {
                        row.AssignedUW = row.Assigned_UW__r.Name;
                    } 
                    if (row.RecordType && row.RecordType.Name.includes('SGR') && row.RecordType.Name.includes('Opportunity')) {
                        row.RecordTypeName = row.RecordType.Name.replace('SGR','').replace('Opportunity','');
                    } else if(row.RecordType) {
                        row.RecordTypeName = row.RecordType.Name;
                    }
					if (!row.Health_Count__c) {
                        row.Health_Count__c = 0;
                    }
                    console.log('row.Dental_Count__c'+row.Dental_Count__c);
                    if (!row.Dental_Count__c) {
                        row.Dental_Count__c = 0;
                    }
                    if (!row.Subscribers_Count__c) {
                        row.Subscribers_Count__c = 0;
                    }
                }*/
                
                component.set("v.data", data);
                // TODO: Uncomment for server sorting
                /*var sortDir=component.get('v.sortDir');
                if (sortDir == 'asc') {
                	component.set("v.sortDir", 'desc');
                } else {
                    component.set("v.sortDir", 'asc');
                }*/
                //$A.get('e.force:refreshView').fire();   
            } else if (state === 'ERROR') {
                component.set("v.err", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errMsg", 'Opportunities could not be retreived. '+errors[0].message);
                    } else {
                        component.set("v.errMsg", 'Opportunities could not be retreived. Unknown server error');
                    }
                }
            } else {
                component.set("v.err", true);
                component.set("v.errMsg", 'Opportunities could not be retreived. Unknow error');
            }
        });
        $A.enqueueAction(action);
    },
    getData : function(component, event, helper){
        var clist = component.get("v.CensusList");
        var censList=[];
        var censListHealth=[];
        var censListVision=[];
        var Hsubscribercount=0;
        var Dsubscribercount=0;
        var Vsubscribercount=0;
        var memberscount=0;  
        for(var i=0;i<clist.length;i++){
            var row = clist[i];
            if(component.get("v.CurrentTabName")=='Vision'){
                row.isActive=true;
            }else{
                if(clist[i].Relationship__c=='Subscriber' && clist[i].Opportunity__r.Rating_Status__c!='Underwriting-Released'&&
                   clist[i].Opportunity__r.Rating_Status__c!='Marketing Release' && clist[i].Opportunity__r.Rating_Status__c!='Sold' &&
                   clist[i].Opportunity__r.Rating_Status__c!='Finalized' && clist[i].Opportunity__r.Rating_Status__c!='Closed'){
                        row.isActive=false;
                }else{
                    row.isActive=true;
                }
            }
            /*if(clist[i].Opportunity_Group_Section__c!=undefined && clist[i].Relationship__c=='Subscriber'){    
                row.Group_Section_Name = row.Opportunity_Group_Section__r.Opportunity_Group_Section_Number__c;
            }*/
            
             if (row.Zip_Code__c.length==9) 
                    
              {
      	 row.Zip_Code__c  = row.Zip_Code__c.substring(0,5)+'-'+row.Zip_Code__c.substring(5) ;
              } 
            else 
              {
                  row.Zip_Code__c  = row.Zip_Code__c;
              };
            row.CreatedBy=clist[i].CreatedBy.Name;
            row.LastModifiedBy=clist[i].LastModifiedBy.Name;
            row.Created_Date_only__c=$A.localizationService.formatDate(clist[i].CreatedDate, "M/D/YYYY h:M:SS a");
            row.Last_Modify_Date_Only__c=$A.localizationService.formatDate(clist[i].LastModifiedDate, "M/D/YYYY h:M:SS a");
            //SGR_DentalIsChecked__c check added by - Ravi
            if(clist[i].Dental_Plan_ID__c!=undefined && clist[i].SGR_DentalIsChecked__c){
                censList.push(clist[i]);
                if(clist[i].Relationship__c=='Subscriber'){                    
                    Dsubscribercount = Dsubscribercount+1;
                }
            }
            if(clist[i].Vision_Plan_ID__c!=undefined && clist[i].SGR_VisionIsChecked__c){
                censListVision.push(clist[i]);
                if(clist[i].Relationship__c=='Subscriber'){                    
                    Vsubscribercount = Vsubscribercount+1;
                }
            }
            if(clist[i].Health_Plan_ID__c!=undefined && clist[i].SGR_HealthIsChecked__c){
                censListHealth.push(clist[i]);
                if(clist[i].Relationship__c=='Subscriber'){                    
                    Hsubscribercount = Hsubscribercount+1;
                }
            }
            if(clist[i].Relationship__c!='Subscriber'){
                row.COBRA__c='';
                row.State_Continuation__c='';
                row.Retiree__c='';
                row.Health_Tier__c='';
                row.Dental_Tier__c='';
                row.Vision_Tier__c='';
                row.Health_Plan_ID__c='';
                row.Dental_Plan_ID__c='';
                row.Vision_Plan_ID__c='';
                row.Health_Group_Number__c='';
                row.Dental_Group_Number__c='';
                row.Vision_Group_Number__c='';
                row.Health_Group_Section__c='';
                row.Dental_Group_Section__c='';
                row.Vision_Group_Section__c='';
            }
        }
        component.set("v.CensusList",censList);
        component.set("v.CensusListVision",censListVision);
        component.set("v.CensusListHealth",censListHealth);
        
        //Set Back UP
        component.set("v.CensusListBackUp",censList);
        component.set("v.CensusListVisionBackUp",censListVision);
        component.set("v.CensusListHealthBackUp",censListHealth);
        
        if(component.get("v.CurrentTabName") === "Health"){
            component.set("v.totalSubscribers",Hsubscribercount);
        }
        if(component.get("v.CurrentTabName") === "Vision"){
            component.set("v.totalSubscribers",Vsubscribercount);
        }
        if(component.get("v.CurrentTabName") === "Dental"){
            component.set("v.totalSubscribers",Dsubscribercount);
        }
    
        //Setting the total memebr count         
        this.getTotalMemberCount(component,component.get("v.CurrentTabName"));//'Health'
    },
    getTotalMemberCount : function(component,Name){
        var dentalmemberscount=0;
        var visionmemberscount=0;
        var Helthmemberscount=0;
        var action=component.get("c.showSubscribersAndDependents");
        action.setParams({
            "oppId":component.get("v.recordId"),
            "Tier":component.get("v.CurrentTabName")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            var myClist = [];
            if(state==='SUCCESS'){
                myClist = response.getReturnValue();
                for(var i = 0;i<myClist.length;i++){   
                    console.log('plan'+myClist[i].Health_Plan_ID__c);
                    if(myClist[i].Dental_Plan_ID__c!=undefined || myClist[i].Dental_Tier__c!=undefined){
                        if(myClist[i].SGR_DentalIsChecked__c){
                        	dentalmemberscount = dentalmemberscount+1;
                        }
                    }
                    if(myClist[i].Vision_Plan_ID__c!=undefined || myClist[i].Vision_Tier__c!=undefined){
                        if(myClist[i].SGR_VisionIsChecked__c){
                        	visionmemberscount = visionmemberscount+1;
                        }
                    }
                    if(myClist[i].Health_Plan_ID__c!=undefined || myClist[i].Health_Tier__c!=undefined){
                        if(myClist[i].SGR_HealthIsChecked__c){
                        	Helthmemberscount = Helthmemberscount+1;
                        }
                    }
                }
                if(Name === 'Health'){
                    component.set("v.totalMembers",Helthmemberscount);
                }
                if(Name === 'Vision'){
                    component.set("v.totalMembers",visionmemberscount);
                }
                if(Name === 'Dental'){
                    component.set("v.totalMembers",dentalmemberscount);
                }
                
                //alert('total member set');
            }
        });
        $A.enqueueAction(action);
    },
    /*saveOptyCensus : function(component, draftValues){
        var action = component.get("c.saveOptyCensus");
        action.setParams({
            'OptyCensusList':draftValues,
            'tabName':component.get("v.CurrentTabName"),
            'opptyId':component.get("v.recordId")
        });
        action.setCallback(this,function(response){
        });
        $A.get('e.force:refreshView').fire();
        $A.enqueueAction(action);
    },*/
    
    addNewRow : function(component,dataList){
        
    },
    showSubscribersOnly : function(component, event,helper){
        helper.initializeData(component, true);
        /*var action=component.get("c.OppCensus");
        var recordId=component.get("v.recordId");//0064D000004HpZAQA0
        action.setParams({
            "oppId":recordId,
            "Tier":'other'
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                component.set("v.CensusList",response.getReturnValue());
                helper.getData(component, event, helper);
                /!* Ravi clone  *!/
                
                /!*var marketingPlanNumber =  component.get('v.marketingPlanNumber');
                var lineOfBusiness = component.get('v.lineOfBusiness');
                var IsItForIncludeBA = event.getParam("IsItForIncludeBA");
                //alert(marketingPlanNumber);
                helper.DAList(component, event,marketingPlanNumber, '', '',helper);*!/
                
                 /!* Ravi clone  *!/
                
            }
        });
        $A.enqueueAction(action);  */
    },
    //Vijaya - Disable/Enable delete button
    isDisableDelete : function(component, event,helper){
        var action=component.get("c.isDeleteEnabled");
        var recordId=component.get("v.recordId");//0064D000004HpZAQA0
        action.setParams({
            "oppId":recordId
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                console.log('response.getReturnValue()--'+response.getReturnValue());
                component.set("v.disableDelete",response.getReturnValue()); 
                //component.set("v.disableAdd",response.getReturnValue()); 
                //('+++'+component.get("v.disableDelete"));
            }
        });
        $A.enqueueAction(action);  
    },
    deleteHealthCensus : function(component, event, helper){
        //confirm("Do you Really want to delete this");
        var action=component.get("c.deleteOptyCensus");
        //var action=component.get("c.deleteHealthDependents");
        console.log(component.get("v.rowsSelected"));
        action.setParams({
            "optyCensusIds":component.get("v.rowsSelected"),
            "planType":'Health'
        });
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state==='SUCCESS'){  
                
                console.log(response.getReturnValue());
                var resVal = response.getReturnValue();
                if('Warning' in resVal){
                    var message = resVal['Warning'];
                    var type = 'Warning';
                }
                else if('Error' in resVal){
                    var message = resVal['Error'];
                    var type = 'Error';
                }
                else if('Success' in resVal){
                    var message = resVal['Success'];
                    var type = 'Success';                    
                    //$A.get('e.force:refreshView').fire();
                    helper.refreshCensus(component, event, helper);
                    //lightningEvent.fire();
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: message,//'Show',
                    duration:'5000',
                    //key: 'info_alt',
                    type: type,
                    //mode: 'sticky'     
        });
           toastEvent.fire(); 
            }          
        }); 
        $A.enqueueAction(action);
        //helper.refreshParent(component, event, helper);
    },
    isRefreshed: function(component, event, helper) {
        location.reload(false);
        
    }, 
    refreshParent : function(component, event, helper){
        var lightningEvent = $A.get("e.c:refreshOptyRatingStatus");
        	lightningEvent.setParams({
            "message" : "An application event fired me." });
       		lightningEvent.fire(); 
        /*var event = $A.get("lightningEvent");
		event.setParam("message", "the message to send" );
		event.fire();*/
    },
    refreshCensus: function(component, event, helper){
    	var enableEdit;
        var enableButtonEdit;
        console.log('recordId'+component.get("v.recordId"));
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
            oppId : component.get("v.recordId")
        });
        opps.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var editRecord;
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
        var Deletecen1=component.get("v.Deletecen");
       if(Deletecen1===false){
       this.showSubscribersOnly(component, event, helper);
       }
        else{
          var lightningEvent = $A.get("e.c:SGR_CensusDependent_Tab");
           lightningEvent.setParams({
           "message" : "An application event fired me." });
           lightningEvent.fire();
           
        }
    },
    deleteDentalCensus : function(component, event,helper){
        //var action=component.get("c.deleteDentalDependents");
        var action=component.get("c.deleteOptyCensus");
        console.log(component.get("v.rowsSelected"));
        action.setParams({
            "optyCensusIds":component.get("v.rowsSelected"),
            "planType":'Dental'
        });
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                //component.set("v.CensusList",response.getReturnValue());
                console.log(response.getReturnValue());
                var resVal = response.getReturnValue();
                component.set('v.deleteMessage',resVal);  
                if('Warning' in resVal){
                    var message = resVal['Warning'];
                    var type = 'Warning';
                }
                else if('Error' in resVal){
                    var message = resVal['Error'];
                    var type = 'Error';
                }
                else if('Success' in resVal){
                    var message = resVal['Success'];
                    var type = 'Success';
                     //$A.get('e.force:refreshView').fire();
                    helper.refreshCensus(component, event, helper);
                    var event = component.getEvent("lightningEvent");
					event.setParam("message", "the message to send" );
					event.fire();
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: message,//'Show',
                    //duration:' 5000',
                    //key: 'info_alt',
                    type: type,
                    //mode: 'sticky'
        });
           toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
        //helper.refreshParent(component, event, helper);
    },
    processBaCheckResults: function(component, event,helper){
    	var obaw=component.get("v.baCheckResults");
        var displayHealthTab = false;
        var displayDentalTab = false;
        var displayVisionTab = false;
        console.log('obaw : '+JSON.stringify(obaw));
        if(obaw != null) {
            var i;
            for (i = 0; i < obaw.length; i++) { 
                switch(obaw[i]) {
                    case 'H':
                        displayHealthTab = true;
                        break;                    
                    case 'D':
                        displayDentalTab = true;
                        break;
                    case 'V':
                        displayVisionTab = true;
                        break;
                }
            }
        }
        console.log('displayHealthTab '+displayHealthTab);
        console.log('displayDentalTab '+displayDentalTab);
        console.log('displayVisionTab '+displayVisionTab);
        component.set("v.displayHealthTab",displayHealthTab);
        component.set("v.displayDentalTab",displayDentalTab);
        component.set("v.displayVisionTab",displayVisionTab);
    },
    processBAModification: function(component, event,marketingPlanNumber, lineOfBusiness, IsItForIncludeBA,helper){
        console.log(marketingPlanNumber + lineOfBusiness + IsItForIncludeBA);
        if(!$A.util.isUndefinedOrNull(IsItForIncludeBA)){
            var modifiedHealthPlanList = [];
            var modifiedDentalPlanList = [];
            var modifiedVisionPlanList = [];
            
            if(lineOfBusiness == 'H'){
                var healthList = component.get("v.CensusListHealth");
                var healthListForIncluding = [];
                var healthListForExcluding = [];
                var modifyHealthList = false;
                console.log("healthList");
                console.log(healthList);
                for(var listItem in healthList){
                    if(marketingPlanNumber == healthList[listItem].Health_Plan_ID__c){
                        healthListForExcluding.push(healthList[listItem]);
                    }else{
                        healthListForIncluding.push(healthList[listItem]);
                    }
                } 
                component.set("v.CensusListHealth",healthListForIncluding); 
                
                console.log(component.get("v.CensusListHealth"));
            }else if(lineOfBusiness == 'D'){
                /*var dentalList = component.get("v.CensusList");
                var dentalListForIncluding = [];
                var dentalListForExcluding = [];
                console.log(dentalList);
                for(var listItem in dentalList){
                    if(marketingPlanNumber == dentalList[listItem].Health_Plan_ID__c){
                        dentalListForExcluding.push(dentalList[listItem]);
                    }else{
                        dentalListForIncluding.push(dentalList[listItem]);
                    }
                }
                component.set("v.CensusList",dentalListForIncluding); */
                helper.DAList(component, event,marketingPlanNumber, lineOfBusiness, IsItForIncludeBA,helper);
            }else if(lineOfBusiness == 'V'){
                var visionList = component.get("v.CensusListVision");
                var visionListForIncluding = [];
                var visionListForExcluding = [];
                console.log(visionList);
                for(var listItem in visionList){
                    if(marketingPlanNumber == visionList[listItem].Health_Plan_ID__c){
                        visionListForExcluding.push(visionList[listItem]);
                    }else{
                        visionListForIncluding.push(visionList[listItem]);
                    }
                }  
                component.set("v.CensusListVision",visionListForIncluding); 
            }
        }else{
            component.set("v.CensusListHealth",component.get("v.CensusListHealthBackUp")); 
            component.set("v.CensusList",component.get("v.CensusListBackUp")); 
            component.set("v.CensusListVision",component.get("v.CensusListVisionBackUp")); 
        }
    }
    ,
    DAList: function(component, event,marketingPlanNumber, lineOfBusiness, IsItForIncludeBA,helper){
        var dentalCensusRecords = component.get("v.CensusList");
        var subscribercount=0;
        var memberscount=0;
        var dentalList = [];
        //alert(marketingPlanNumber);
        for(var i=0; i<dentalCensusRecords.length;i++){
            memberscount = memberscount+1;
            if(dentalCensusRecords[i].Relationship__c=='Subscriber'){
                subscribercount = subscribercount+1;
            }
            //alert(dentalCensusRecords[i].Health_Plan_ID__c);
            if(!$A.util.isUndefinedOrNull(marketingPlanNumber)){
                 if(marketingPlanNumber === dentalCensusRecords[i].Dental_Plan_ID__c ){
                     //dentalList.push(dentalList[listItem]);
                 }else{
                      dentalList.push(dentalCensusRecords[i]);
                 }
            }
            else{
                dentalList.push(dentalCensusRecords[i])
            }
            component.set("v.CensusList",dentalList); 
        }
        
        component.set("v.totalSubscribers",subscribercount);
        component.set("v.totalMembers",subscribercount);
    },
    getOpportunityFields : function(component, event, helper){
    	var action = component.get("c.getOppData");
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.Opportunity",response.getReturnValue());
                //component.set("v.RenewalDate",response.getReturnValue().Renewal_Date__c);
            }
        });
        $A.enqueueAction(action);
    },
    apexPromise : function(action) {
        return new Promise($A.getCallback(function (resolve, reject) {
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    reject(Error("apexPromise: failed with state = " + state));
                }
            });
            $A.enqueueAction(action);
        }));
    },
    initializeData : function(component, subOnly){
        var helper = this;
        var action = component.get("c.showSubscribersAndDependents");
        action.setParams({
            "oppId":component.get("v.recordId"),
            "Tier":component.get("v.CurrentTabName")
        });
        helper.apexPromise(action).then(
            $A.getCallback(function (result) {
                console.log("Sgr_displayCensusHelper:initializeData: result = " + JSON.stringify(result));
                if(result !== null && result.length > 0){
                    var sortedData = helper.sortData(result);
                    if(subOnly){
                        component.set("v.CensusList", helper.filterSubscribers(sortedData));
                    }else{
                        component.set("v.CensusList", sortedData);
                    }
                    helper.getData(component, null, helper);
                }
            }),

            $A.getCallback(function (error) {
                console.log("Sgr_displayCensusHelper:initializeData: Promise was rejected: ", error);
            })
        );
    },

    filterSubscribers : function(data){
        var resultData = [];
        data.forEach(function (item) {
            if(item.Relationship__c === "Subscriber"){
                resultData.push(item);
            }
        });
        return resultData;
    },

    updateRowsPromise : function(component, updateList){
        var action = component.get("c.updateCensusRows");
        action.setParams({
            "updateObjects":updateList
        });
        return this.apexPromise(action);
    },
    sortData : function(data){
        /*data.sort(function (a, b) {
           if(a.Subscriber_Number__c === b.Subscriber_Number__c){
               return a.Membership_Number__c - b.Membership_Number__c;
           }
           return a.Subscriber_Number__c - b.Subscriber_Number__c;
        });*/
        data.forEach(function (item) {
            if(item.Medicare_Primary__c === true){
                item.medicareYesNo = "Y";
            }else{
                item.medicareYesNo = "N";
            }
        });
        return data;
    },
    formatData : function(data){
        console.log("**PCM**formatData: data = " + JSON.stringify(data));
        var sortedData = this.sortData(data);
        console.log("**PCM**formatData: sortedData = " + JSON.stringify(sortedData));
        var updateList = [];
        var subscriberRowNum = 0;
        var dependentRowNum = 0;
        sortedData.forEach(function (item) {
            var cloneItem = {Id : item.Id};
            if(item.Relationship__c === "Subscriber"){
                subscriberRowNum++;
                dependentRowNum = 0;
                var key = subscriberRowNum + ".0";
                var isValid = (item.Row__c !== null && typeof item.Row__c !== "undefined" && item.Row__c === key);
                cloneItem.Row__c = key;
                if(!isValid){
                    updateList.push(cloneItem);
                }
            }else{
                dependentRowNum++;
                var key = subscriberRowNum + "." + dependentRowNum;
                var isValid = (item.Row__c !== null && typeof item.Row__c !== "undefined" && item.Row__c === key);
                cloneItem.Row__c = key;
                if(!isValid){
                    updateList.push(cloneItem);
                }
            }
        });
        return updateList;
    },
    genCommonHeaders : function(component){
        var editRecord = component.get("v.booleanVar");
        return [
            {
                label: '', type: 'button-icon',
                typeAttributes: {
                    iconName: 'utility:new',
                    name: 'new_record',
                    title: 'Add Dependent',
                    variant: 'border-filled',
                    alternativeText: 'new',
                    disabled: {fieldName:'isActive'},
                    iconPosition: 'left'
                },fixedWidth:55
            },
            {
                label: 'Edit', type: 'button-icon',
                typeAttributes: {
                    iconName: 'utility:edit',
                    name: 'edit_record',
                    title: 'Edit Row',
                    variant: 'border-filled',
                    alternativeText: 'edit',
                    disabled: editRecord,
                    iconPosition: 'left'
                },fixedWidth:60
            },
            {label: 'Sub#', fieldName: 'Row__c', type: 'text',Strong:'true',cellAttributes: { alignment: 'left' }, initialWidth:89},
            {label: 'Last Name', fieldName: 'CensusId__c', type: 'url', typeAttributes: {label: { fieldName: 'Last_Name__c' }, disabled: {fieldName: 'Last_Name__c'}, target: '_blank'}, initialWidth:95},
            {label: 'First Name', fieldName: 'First_Name__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'DOB', fieldName: 'Date_of_Birth__c', type: 'date-local',Strong:'true',cellAttributes: { alignment: 'left' },typeAttributes:{year:'numeric',month:'2-digit',day:'2-digit'}, initialWidth:115},
            {label: 'Age', fieldName: 'Age_New__c', type: 'number',cellAttributes: { alignment: 'left' }, initialWidth:75},
            {label: 'Gender', fieldName: 'Gender__c', type: 'picklist',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Relationship', fieldName: 'Relationship__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:102},
            {label: 'Zip Code', fieldName: 'Zip_Code__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:85} ,
            {label: 'State', fieldName: 'State__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:81},
            {label: 'Tobacco', fieldName: 'Tobacco_Y_N__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:91},
            {label: 'Cobra', fieldName: 'COBRA__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:100},
            {label: 'State Continuation', fieldName: 'State_Continuation__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:124},
            {label: 'Medicare Primary', fieldName: 'medicareYesNo',type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:128},
            {label: 'Retiree', fieldName: 'Retiree__c', type: 'text',cellAttributes: { alignment: 'left' }, initialWidth:111},
            {label: 'Created Date', fieldName: 'Created_Date_only__c', type: 'Date',cellAttributes: { alignment: 'left' }, initialWidth:150},
            {label: 'Created By', fieldName: 'CreatedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified By', fieldName: 'LastModifiedBy', type: 'text', typeAttributes:{label: {fieldName: 'Name'}}, initialWidth:150},
            {label: 'LastModified Date', fieldName: 'Last_Modify_Date_Only__c', type: 'text', initialWidth:150}
        ];
    }
})