({
    /*firePlanIdEvent : function(component,event,helper) {
        var planIdValue;
        if(component.get("v.tabName")=='Health'){
            planIdValue=component.get("v.CensusRecord.Health_Plan_ID__c");
        }
        if(component.get("v.tabName")=='Dental'){
            planIdValue=component.get("v.CensusRecord.Dental_Plan_ID__c");
        }
        if(component.get("v.tabName")=='Vision'){
            planIdValue=component.get("v.CensusRecord.Vision_Plan_ID__c");
        }
		var planValueEvent = component.getEvent("planIdEvent");
        planValueEvent.setParam("planID",planIdValue);
        planValueEvent.fire();
	},*/
    fireHPlanIdEvent : function(component,event,helper) {
        var planValueEvent = component.getEvent("HplanIdEvent");
        planValueEvent.setParam("HplanID",component.get("v.CensusRecord.Health_Plan_ID__c"));
        planValueEvent.fire();
    },
    fireDPlanIdEvent : function(component,event,helper) {
        var planValueEvent = component.getEvent("DplanIdEvent");
        planValueEvent.setParam("DplanID",component.get("v.CensusRecord.Dental_Plan_ID__c"));
        planValueEvent.fire();
    },
    fireVPlanIdEvent : function(component,event,helper) {
        var planValueEvent = component.getEvent("VplanIdEvent");
        planValueEvent.setParam("VplanID",component.get("v.CensusRecord.Vision_Plan_ID__c"));
        planValueEvent.fire();
    },
    getFieldsData : function(component,event,helper){
        var action = component.get("c.getPlanIds");
        action.setParams({
            "oppId":component.get("v.oppId")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var mapVal = response.getReturnValue();
                var HList = [];
                var DList = [];
                var VList = [];
                for(var key in mapVal){
                    if(key=='H'){
                        HList.push(mapVal[key]);
                    }
                    if(key=='D'){
                        DList.push(mapVal[key]);
                    }
                    if(key=='V'){
                        VList.push(mapVal[key]);
                    }
                    
                }
                component.set("v.HPlanIds",HList);
                component.set("v.DPlanIds",DList);
                if(component.get("v.Opportunity").HCSC_Division__c=='NM' || (component.get("v.Opportunity").HCSC_Division__c=='MT' && component.get("v.CensusRecord.Age_New__c")>=19)){
                	component.set("v.VPlanIds",VList);
                    if(VList!=null && VList!=undefined){
                    	helper.vPlanEventHelper(component,event,helper,VList.toString().split(',')[0]);
                    }
                }
            }
        });
        $A.enqueueAction(action);
        //helper.getMemberBenefit(component,event,helper);
    },
    SaveRecord : function(component,event,helper){
        if(helper.checkValidation(component,event,helper)){
            var varForMT19;
            if((component.get("v.Opportunity").HCSC_Division__c=='MT' && component.get("v.CensusRecord.Age_New__c")<19)){
            	varForMT19 = confirm("Under 19 census will not be enrolled vision and will only be enrolled into Health.\nDo you wish to proceed?");
                component.set("v.CensusRecord.Vision_Plan_ID__c",'');
                component.set("v.CensusRecord.Vision_Group_Number__c",'');
                component.set("v.CensusRecord.Vision_Group_Section__c",'');
            }else{
               varForMT19 = true;
            } 
            if(component.get("v.Opportunity").HCSC_Division__c!='MT' || varForMT19 ){ 
                if((component.get("v.CensusRecord.Date_of_Birth__c")==undefined || component.get("v.CensusRecord.Date_of_Birth__c")=='' || component.get("v.CensusRecord.Date_of_Birth__c")==null) && (component.get("v.CensusRecord.Age_New__c")==undefined || component.get("v.CensusRecord.Age_New__c")=='' || component.get("v.CensusRecord.Age_New__c")==null)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Either one of DOB or Age must be entered",
                    "type": "error",
                    "mode": "sticky",
                    "duration": "500"
                });
                toastEvent.fire();
            }
            
            else{
                var zipcodeVal = component.get("v.CensusRecord.Zip_Code__c");
                if(!helper.validateZip(zipcodeVal)){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Please enter a valid Zip Code",
                        "type": "error",
                        "mode": "sticky",
                        "duration": "500"
                    });
                    toastEvent.fire();
                }else{
                    if(component.get("v.CensusRecord.Employee_Status_Code__c")=='None'){
                        component.set("v.CensusRecord.Employee_Status_Code__c",'');
                    }
                    if(component.get("v.CensusRecord.Health_Plan_ID__c")!='' && component.get("v.CensusRecord.Health_Plan_ID__c")!=null && component.get("v.CensusRecord.Health_Plan_ID__c")!=undefined && component.get("v.context")=='Add'){
                        component.set("v.CensusRecord.Health_Tier__c","EO");
                        component.set("v.CensusRecord.Vision_Tier__c","EO");
                    }if(component.get("v.CensusRecord.Dental_Plan_ID__c")!='' && component.get("v.CensusRecord.Dental_Plan_ID__c")!=null && component.get("v.CensusRecord.Dental_Plan_ID__c")!=undefined && component.get("v.context")=='Add'){
                        component.set("v.CensusRecord.Dental_Tier__c","EO");
                    }
                    /*if(component.get("v.CensusRecord.Vision_Plan_ID__c")!='' && component.get("v.CensusRecord.Vision_Plan_ID__c")!=null && component.get("v.CensusRecord.Vision_Plan_ID__c")!=undefined && component.get("v.context")=='Add'){
                        component.set("v.CensusRecord.Vision_Tier__c","EO");
                    }*/
                 var NMTXretiredNo=true;
                 var OKretiredNo=true;
                 var MTretiredNo=true;  
                
              	if(component.get("v.CensusRecord.Age_New__c")>99 || (component.get("v.CensusRecord.Age_New__c")<16 && component.get("v.CensusRecord.Age_New__c")!=null )|| (component.get("v.CensusRecord.Retiree__c")=='Y' && (component.get("{!v.NMString}")== 'NM' || component.get("{!v.NMString}")== 'TX' || component.get("{!v.NMString}")== 'OK' || component.get("{!v.NMString}")== 'MT'))){ 
                    if(component.get("v.CensusRecord.Age_New__c")>99){ 
				var Agerate = confirm("Subscriber or dependent over the age of 99. Do you wish to proceed?");
					}
                    else{
                        
                    }
                    
				if(component.get("v.CensusRecord.Age_New__c")<16 && component.get("v.CensusRecord.Age_New__c")!=null && component.get("v.CensusRecord.Relationship__c")!='Child'){
                    
				var censusage = confirm("Subscriber/spouse/domestic partner census under the age of 16 for a non-cobra subscriber. Do you wish to proceed?");
				}
                    else{
                        
                    }
                 if(component.get("v.CensusRecord.Retiree__c")=='Y' && (component.get("{!v.NMString}")== 'NM' || component.get("{!v.NMString}")== 'TX')){
                     
                       var NMTXretired = confirm("A Retired subscriber cannot exist in an Opportunity within a Regulated Market Segment. Do you wish to proceed?");
                   }
                    else{
                        
                    }
                  if(component.get("v.CensusRecord.Retiree__c")=='Y' && component.get("{!v.NMString}")== 'OK'){
                     
                       var OKretired = confirm("A Retired subscriber cannot exist in an Opportunity located within a Non-Public Entity account. Do you wish to proceed?");
                  } else{
                     
                  }
                  if(component.get("v.CensusRecord.Retiree__c")=='Y' && component.get("{!v.NMString}")== 'MT' ){
                     
                       var MTretired = confirm("A Retired subscriber cannot exist in an Opportunity located within a Non-Municipality account. Do you wish to proceed?");
                  }else{
                     
                  }
                                
               //if(((Agerate==true||censusage==true) && (MTretired== false || OKretired==false || NMTXretired==false )) || ((Agerate==false||censusage==false) && (MTretired== true || OKretired==true || NMTXretired==true ))){
               if(Agerate==false || censusage==false || MTretired== false || OKretired==false || NMTXretired==false || censusage==false ){
					//alert('stay here');
				}else{ 
					if(Agerate == true|| censusage==true || NMTXretired==true || OKretired==true || MTretired==true || varForMT19==true){                 
						//alert('test reached');
						var saveRec = component.get("c.saveOppCensus");
                        var OppCensusobj=component.get("v.CensusRecord");
                        var proceedswithhealthenrollment=component.get("v.YesToClose");
                        var abortsenrollment=component.get("v.NoToClose");
                        var age=OppCensusobj.Age_New__c;
						//alert(proceedswithhealthenrollment+'***'+abortsenrollment+'VVVV'+OppCensusobj.Age_New__c);
                        //if(age<19){component.set("v.isOpen",true);}
                        if(age>=19 || proceedswithhealthenrollment===true ||varForMT19){
                            saveRec.setParams({
                                "oppCensus" : component.get("v.CensusRecord"),
                                "tabName" : component.get("v.tabName")
                            });
                            saveRec.setCallback(this, function(response) {
                                if(response.getState() === "SUCCESS"){
                                    /* var navEvt = $A.get("e.force:navigateToSObject");
							navEvt.setParams({
								"recordId": component.get("v.oppId"),
							});
							navEvt.fire(); */ 
                                    component.set("v.CensusValidation",true);
                                    //$A.get("e.force:refreshView").fire();
                                    var lightningEvent1 = $A.get("e.c:RatingStatusRefresh");
                                    lightningEvent1.setParams({
                                        "message" : "An application event fired me." });
                                    lightningEvent1.fire();
                                    
                                    window.history.back();
                                }
                            });
                            $A.enqueueAction(saveRec);
                        }
                        if(abortsenrollment===true){
                            alert(proceedswithhealthenrollment+'VVV'+abortsenrollment+'VVVV'+OppCensusobj.Age_New__c);
                             var lightningEvent1 = $A.get("e.c:RatingStatusRefresh");
                                    lightningEvent1.setParams({
                                        "message" : "An application event fired me." });
                                    lightningEvent1.fire();
                                    
                                    window.history.back();
                        }
					
					}
				}
                }
                    else{ 
                        
                        //alert(component.get("v.CensusRecord.hcsc_division__c")+'----SaveRecord');
                        var saveRec = component.get("c.saveOppCensus");
                        console.log('O P P C E N S E F O R H E A L T H'+component.get("v.CensusRecord"));
                        saveRec.setParams({
                            "oppCensus" : component.get("v.CensusRecord"),
                            "tabName" : component.get("v.tabName")
                        });
                        saveRec.setCallback(this, function(response) {
                            if(response.getState() === "SUCCESS"){
                                /* var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": component.get("v.oppId"),
                        });
                        navEvt.fire(); */ 
                                component.set("v.CensusValidation",true);
                                //$A.get("e.force:refreshView").fire();
                                var lightningEvent1 = $A.get("e.c:RatingStatusRefresh");
                                lightningEvent1.setParams({
                                    "message" : "An application event fired me." });
                                lightningEvent1.fire();
                                
                                window.history.back();
                            }
                        });
                        $A.enqueueAction(saveRec);
                    }
            	}
            }
            }
        }
    },
    
    
    checkValidation : function(component,event,helper){
        var prefixErrorMessage = 'Please complete the following field(s): ';
        var errorMessage = '';
        if(component.get("v.tabName")=='Health'){
            if(component.get("v.CensusRecord.Health_Plan_ID__c")=='' || component.get("v.CensusRecord.Health_Plan_ID__c")==undefined || component.get("v.CensusRecord.Health_Plan_ID__c")==null){
                errorMessage += ' Health Plan ID';
            }
            if(component.get("v.CensusRecord.Health_Group_Number__c")=='' || component.get("v.CensusRecord.Health_Group_Number__c")==undefined || component.get("v.CensusRecord.Health_Group_Number__c")==null){
                errorMessage += ', Health Group Number';
            }
            if(component.get("v.CensusRecord.Health_Group_Section__c")=='' || component.get("v.CensusRecord.Health_Group_Section__c")==undefined || component.get("v.CensusRecord.Health_Group_Section__c")==null){
                errorMessage += ', Health Group Section Number';
            }
            if(component.get("v.CensusRecord.Dental_Plan_ID__c")!='' && component.get("v.CensusRecord.Dental_Plan_ID__c")!=undefined && component.get("v.CensusRecord.Dental_Plan_ID__c")!=null){
                if(component.get("v.CensusRecord.Dental_Group_Number__c")=='' || component.get("v.CensusRecord.Dental_Group_Number__c")==undefined || component.get("v.CensusRecord.Dental_Group_Number__c")==null){
                    errorMessage += ' Dental Group Number';
                }
                if(component.get("v.CensusRecord.Dental_Group_Section__c")=='' || component.get("v.CensusRecord.Dental_Group_Section__c")==undefined || component.get("v.CensusRecord.Dental_Group_Section__c")==null){
                    errorMessage += ', Dental Group Section Number';
                }
            }
            /*if(component.get("v.CensusRecord.Vision_Plan_ID__c")!='' && component.get("v.CensusRecord.Vision_Plan_ID__c")!=undefined && component.get("v.CensusRecord.Vision_Plan_ID__c")!=null){
                if(component.get("v.CensusRecord.Vision_Group_Number__c")=='' || component.get("v.CensusRecord.Vision_Group_Number__c")==undefined || component.get("v.CensusRecord.Vision_Group_Number__c")==null){
                    errorMessage += ' Vision Group Number';
                }
                if(component.get("v.CensusRecord.Vision_Group_Section__c")=='' || component.get("v.CensusRecord.Vision_Group_Section__c")==undefined || component.get("v.CensusRecord.Vision_Group_Section__c")==null){
                    errorMessage += ', Vision Group Section Number';
                }
            }*/
        }
        if(component.get("v.tabName")=='Dental' ){
            if(component.get("v.CensusRecord.Dental_Plan_ID__c")=='' || component.get("v.CensusRecord.Dental_Plan_ID__c")==undefined || component.get("v.CensusRecord.Dental_Plan_ID__c")==null){
                errorMessage += ' Dental Plan ID';
            }
            if(component.get("v.CensusRecord.Dental_Group_Number__c")=='' || component.get("v.CensusRecord.Dental_Group_Number__c")==undefined || component.get("v.CensusRecord.Dental_Group_Number__c")==null){
                errorMessage += ', Dental Group Number';
            }
            if(component.get("v.CensusRecord.Dental_Group_Section__c")=='' || component.get("v.CensusRecord.Dental_Group_Section__c")==undefined || component.get("v.CensusRecord.Dental_Group_Section__c")==null){
                errorMessage += ', Dental Group Section Number';
            }
            if(component.get("v.CensusRecord.Health_Plan_ID__c")!='' && component.get("v.CensusRecord.Health_Plan_ID__c")!=undefined && component.get("v.CensusRecord.Health_Plan_ID__c")!=null){
                if(component.get("v.CensusRecord.Health_Group_Number__c")=='' || component.get("v.CensusRecord.Health_Group_Number__c")==undefined || component.get("v.CensusRecord.Health_Group_Number__c")==null){
                    errorMessage += ' Health Group Number';
                }
                if(component.get("v.CensusRecord.Health_Group_Section__c")=='' || component.get("v.CensusRecord.Health_Group_Section__c")==undefined || component.get("v.CensusRecord.Health_Group_Section__c")==null){
                    errorMessage += ', Health Group Section Number';
                }
            }
            /*if(component.get("v.CensusRecord.Vision_Plan_ID__c")!='' && component.get("v.CensusRecord.Vision_Plan_ID__c")!=undefined && component.get("v.CensusRecord.Vision_Plan_ID__c")!=null){
                if(component.get("v.CensusRecord.Vision_Group_Number__c")=='' || component.get("v.CensusRecord.Vision_Group_Number__c")==undefined || component.get("v.CensusRecord.Vision_Group_Number__c")==null){
                    errorMessage += ' Vision Group Number';
                }
                if(component.get("v.CensusRecord.Vision_Group_Section__c")=='' || component.get("v.CensusRecord.Vision_Group_Section__c")==undefined || component.get("v.CensusRecord.Vision_Group_Section__c")==null){
                    errorMessage += ', Vision Group Section Number';
                }
            }*/
        }
        /*if(component.get("v.tabName")=='Vision'){
            if(component.get("v.CensusRecord.Vision_Plan_ID__c")=='' || component.get("v.CensusRecord.Vision_Plan_ID__c")==undefined || component.get("v.CensusRecord.Vision_Plan_ID__c")==null){
                errorMessage += ' Vision Plan ID';
            }
            if(component.get("v.CensusRecord.Vision_Group_Number__c")=='' || component.get("v.CensusRecord.Vision_Group_Number__c")==undefined || component.get("v.CensusRecord.Vision_Group_Number__c")==null){
                errorMessage += ', Vision Group Number';
            }
            if(component.get("v.CensusRecord.Vision_Group_Section__c")=='' || component.get("v.CensusRecord.Vision_Group_Section__c")==undefined || component.get("v.CensusRecord.Vision_Group_Section__c")==null){
                errorMessage += ', Vision Group Section Number';
            }
            if(component.get("v.CensusRecord.Health_Plan_ID__c")!='' && component.get("v.CensusRecord.Health_Plan_ID__c")!=undefined && component.get("v.CensusRecord.Health_Plan_ID__c")!=null ){
                if(component.get("v.CensusRecord.Health_Group_Number__c")=='' || component.get("v.CensusRecord.Health_Group_Number__c")==undefined || component.get("v.CensusRecord.Health_Group_Number__c")==null){
                    errorMessage += ' Health Group Number';
                }
                if(component.get("v.CensusRecord.Health_Group_Section__c")=='' || component.get("v.CensusRecord.Health_Group_Section__c")==undefined || component.get("v.CensusRecord.Health_Group_Section__c")==null){
                    errorMessage += ', Health Group Section Number';
                }
            }
            if(component.get("v.CensusRecord.Dental_Plan_ID__c")!='' && component.get("v.CensusRecord.Dental_Plan_ID__c")!=undefined && component.get("v.CensusRecord.Dental_Plan_ID__c")!=null ){
                if(component.get("v.CensusRecord.Dental_Group_Number__c")=='' || component.get("v.CensusRecord.Dental_Group_Number__c")==undefined || component.get("v.CensusRecord.Dental_Group_Number__c")==null){
                    errorMessage += ' Dental Group Number';
                }
                if(component.get("v.CensusRecord.Dental_Group_Section__c")=='' || component.get("v.CensusRecord.Dental_Group_Section__c")==undefined || component.get("v.CensusRecord.Dental_Group_Section__c")==null){
                    errorMessage += ', Dental Group Section Number';
                }
            }
        }*/
        if(component.get("v.CensusRecord.State_Continuation__c")=='' || component.get("v.CensusRecord.State_Continuation__c")==null || component.get("v.CensusRecord.State_Continuation__c")==undefined){
            errorMessage += ', State Continuation';
        }
        if(component.get("v.CensusRecord.Gender__c")=='--None--'){
            errorMessage += ', Gender';
        }
        if(component.get("v.CensusRecord.Zip_Code__c")==undefined || component.get("v.CensusRecord.Zip_Code__c")=='' || component.get("v.CensusRecord.Zip_Code__c")==null){
            errorMessage += ', Zip Code';
        }
        if (errorMessage != undefined && errorMessage != '' && errorMessage != null) {
            errorMessage = errorMessage.substring(1, errorMessage.length);
            errorMessage = prefixErrorMessage + errorMessage;
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
        }else{
            return true;
        }
    },
    hPlanEventHelper : function(component,event,helper,planID){
        var action = component.get("c.getgroupSection");
        action.setParams({
            "oppId":component.get("v.oppId"),
            "planId":planID
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var gsList = response.getReturnValue();
                var groupNumberList=[];
                var groupSectionList=[];
                for(var i=0;i<gsList.length;i++){
                    if(gsList[i].Opportunity_Group_Number__c!=null && gsList[i].Opportunity_Group_Number__c!=undefined){
                        groupNumberList.push(gsList[i].Opportunity_Group_Number__c );
                    }
                    if(gsList[i].Opportunity_Group_Section_Number__c!=null && gsList[i].Opportunity_Group_Section_Number__c!=undefined){
                        groupSectionList.push(gsList[i].Opportunity_Group_Section_Number__c);
                    }
                }
                groupNumberList.push("");
                groupSectionList.push("");
                component.set("v.HgroupNumbers",groupNumberList);
                component.set("v.HgroupSectionNumbers",groupSectionList);
            }
        });
        $A.enqueueAction(action);
    },
	dPlanEventHelper : function(component,event,helper,planID){
    	var action = component.get("c.getgroupSection");
        action.setParams({
            "oppId":component.get("v.oppId"),
            "planId":planID
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var gsList = response.getReturnValue();
                var groupNumberList=[];
                var groupSectionList=[];
                for(var i=0;i<gsList.length;i++){
                    if(gsList[i].Opportunity_Group_Number__c!=null && gsList[i].Opportunity_Group_Number__c!=undefined){
                        groupNumberList.push(gsList[i].Opportunity_Group_Number__c );
                    }
                    if(gsList[i].Opportunity_Group_Section_Number__c!=null && gsList[i].Opportunity_Group_Section_Number__c!=undefined){
                        groupSectionList.push(gsList[i].Opportunity_Group_Section_Number__c);
                    }
                }
                groupNumberList.push("");
                groupSectionList.push("");
                component.set("v.DgroupNumbers",groupNumberList);
                component.set("v.DgroupSectionNumbers",groupSectionList);
            }
        });
        $A.enqueueAction(action);
    },
    vPlanEventHelper : function(component,event,helper,planID){
    	var action = component.get("c.getgroupSection");
        action.setParams({
            "oppId":component.get("v.oppId"),
            "planId":planID
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var gsList = response.getReturnValue();
                var groupNumberList=[];
                var groupSectionList=[];
                for(var i=0;i<gsList.length;i++){
                    if(gsList[i].Opportunity_Group_Number__c!=null && gsList[i].Opportunity_Group_Number__c!=undefined){
                        groupNumberList.push(gsList[i].Opportunity_Group_Number__c );
                    }
                    if(gsList[i].Opportunity_Group_Section_Number__c!=null && gsList[i].Opportunity_Group_Section_Number__c!=undefined){
                        groupSectionList.push(gsList[i].Opportunity_Group_Section_Number__c);
                    }
                }
                component.set("v.VgroupNumbers",groupNumberList);
                component.set("v.VgroupSectionNumbers",groupSectionList);
            }
        });
        $A.enqueueAction(action);
    },
    validateZip : function(zipcode) {
        if(zipcode !== null && typeof zipcode !== "undefined" && zipcode.length > 0){
            var zipParts = zipcode.split("-");
            if(zipParts.length === 2){
                return (zipParts[0].length === 5 && zipParts[1].length === 4);
            }
            return zipcode.length === 5;
        }
        return false;
    }
})