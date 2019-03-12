({
 handleCancel : function(component){ 
     	//component.set("v.CensusRecord",null);
        var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
     	compEvent.setParams({
        	"Confirmed" : false
     	});
     	compEvent.fire();

    },
    doInit: function(component, event, helper) {
        var content = component.get("v.contentTxt");
        console.log('content::'+content);
        var dataList = [];
        var statusTxt = component.get('v.status-id');
        var rowTxt = component.get('v.row-id');
        
        for (var i=0;i<content.length; i++ ) {
            if(content[i] && content[i].includes(statusTxt) && statusTxt == 'Error!') {
                dataList.push({
                    flag:'e',
                    txt:content[i]
                });
            } else if (content[i] && content[i].includes(statusTxt)) {
                dataList.push({
                    flag:'s',
                    txt:content[i]
                });        
            } else if (content[i] && content[i].includes(rowTxt)) {
                dataList.push({
                    flag:'r',
                    txt:content[i]
                });                
            } 
        }
        console.log('Data list::'+dataList);
        if (dataList.length>0) {
            component.set("v.dataList",dataList);
        }
        
      
    },
    DCEventHandler : function(component,event,helper){
        //component.set("v.CensusRecord",component.get("v.CensusRecord1"));
        var action = component.get("c.getStates");
        action.setParams({
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var stateMappping = response.getReturnValue();
                var stateList = [];
                for(var i=0;i<stateMappping.length;i++){
                    var row = stateMappping[i];
                    stateList.push(row.State_Code__c);
                }
                component.set("v.allStates",stateList);
            }
        });
        $A.enqueueAction(action);
        var subscriber='';
        var message = event.getParam("OptyCensus");
        //alert('++'+message.Zip_Code__c); 
        component.set("v.tabName",event.getParam("tabName"));
        console.log('++'+JSON.stringify(message));
        if(event.getParam("context")=='Edit Census'){
            component.set("v.headerTxt",'Edit Census');
            var action = component.get("c.getCensusFields");
            action.setParams({
                'oppId':message.Opportunity__c,
                'subIdNumber':message.Subscriber_number1__c
            });
            action.setCallback(this,function(response){
                if(JSON.stringify(response.getState() === "SUCCESS")){
              
                    var allFields = response.getReturnValue();
                    component.set("v.CensusRecord.Health_Plan_ID__c",allFields.Health_Plan_ID__c);
                    component.set("v.CensusRecord.Dental_Plan_ID__c",allFields.Dental_Plan_ID__c);
                    component.set("v.CensusRecord.Health_Group_Number__c",allFields.Health_Group_Number__c);
                    component.set("v.CensusRecord.Dental_Group_Number__c",allFields.Dental_Group_Number__c);
                    component.set("v.CensusRecord.Health_Group_Section__c",allFields.Health_Group_Section__c);
                    component.set("v.CensusRecord.Dental_Group_Section__c",allFields.Dental_Group_Section__c);
                    component.set("v.CensusRecord.Vision_Plan_ID__c",allFields.Vision_Plan_ID__c);
                    component.set("v.CensusRecord.Vision_Group_Section__c",allFields.Vision_Group_Section__c);
                    component.set("v.CensusRecord.Vision_Group_Number__c",allFields.Vision_Group_Number__c);
                    
                    //component.set("v.backendvalue",allFields.Backend_Created__c);
                    if(message.Vision_Plan_ID__c==null || message.Vision_Plan_ID__c=='' || message.Vision_Plan_ID__c==undefined){
            			component.set("v.VisionCoverage",false);
                    }else if(component.get("v.HealthCoverage") && message.Vision_Plan_ID__c!=null && message.Vision_Plan_ID__c!='' && message.Vision_Plan_ID__c!=undefined){
                        component.set("v.VisionCoverage",true);
                    }
                    //alert('gfyufggg'+allFields.Backend_Created__c);
                    if(allFields.First_Name__c!=null && allFields.First_Name__c!='' && allFields.First_Name__c!=undefined){
                        subscriber=allFields.First_Name__c+' ';
                    }
                    if(allFields.Last_Name__c!=null && allFields.Last_Name__c!='' && allFields.Last_Name__c!=undefined){
                        subscriber=subscriber+allFields.Last_Name__c;
                    }
                    component.set("v.subscriberId",allFields.Id);
                    component.set("v.subscriber",subscriber);
                    
                }
            });
            $A.enqueueAction(action);
            helper.getCoverageDetails(component,event,helper,message);
        }else{
            
        /*var message1 = event.getParam("OptyCensus");
          var action1 = component.get("c.getCensusFields");
            action1.setParams({
                'oppId':message1.Opportunity__c,
                'subIdNumber':message1.Subscriber_Number__c
            });
            action1.setCallback(this,function(response){
                if(JSON.stringify(response.getState() === "SUCCESS")){
                  var allFields = response.getReturnValue();
                    
                    component.set("v.backendvalue",allFields.Backend_Created__c);  
                    
                }
            });
            $A.enqueueAction(action1);*/
            //alert('++'+message.Zip_Code__c);
            component.set("v.subscriberId",message.Id);
            component.set("v.headerTxt",'Add Dependent');
            if(message.First_Name__c!=null && message.First_Name__c!='' && message.First_Name__c!=undefined){
                subscriber=subscriber+message.First_Name__c+' ';
            }
            if(message.Last_Name__c!=null && message.Last_Name__c!='' && message.Last_Name__c!=undefined){
                subscriber=subscriber+message.Last_Name__c;
            }
            component.set("v.subscriber",subscriber);
            message.Id=null;
            message.Last_Name__c='';
            message.First_Name__c = null;
            message.Tobacco_Use__c=false;
            //message.Health_Coverage__c=false;
            message.Age_New__c = '';
            message.Medicare_Primary__c = false;
            message.Gender__c = '';
            message.Date_of_Birth__c= null;
            message.Relationship__c='None';
            component.set("v.HealthCoverage",false);
            component.set("v.DentalCoverage",false);
            component.set("v.VisionCoverage",false); 
            if(message.Opportunity__r.HCSC_Division__c!='NM' && message.Opportunity__r.HCSC_Division__c!='MT'){
                message.Vision_Plan_ID__c='';
                message.Vision_Group_Number__c='';
                message.Vision_Group_Section__c='';
            }else{
                if(component.get("v.HealthCoverage") && message.Vision_Plan_ID__c!=null && message.Vision_Plan_ID__c!='' && message.Vision_Plan_ID__c!=undefined){
                	component.set("v.VisionCoverage",true);
                }else{
                    component.set("v.VisionCoverage",false);
                }
            }
            if(message.Health_Plan_ID__c==null || message.Health_Plan_ID__c==undefined || message.Health_Plan_ID__c==''){
                component.set("v.disableHCoverage",true);
            }else{
                component.set("v.disableHCoverage",false);
            }
            if(message.Dental_Plan_ID__c==null || message.Dental_Plan_ID__c==undefined || message.Dental_Plan_ID__c==''){
                component.set("v.disableDCoverage",true);
            }else{
                component.set("v.disableDCoverage",false);
            }
        }
        if(message.Opportunity__r.AccountId!=undefined )
            {
                if(message.Opportunity__r.Account.Domestic_Partner__c === 'Y'){
                    if(message.Relationship__c!=null && message.Relationship__c!=undefined && message.Relationship__c!='' && message.Relationship__c!='None'){
                        if(message.Relationship__c=='Child'){
                            var myOptions =[
                                { id: 'Domestic Partner', label: 'Domestic Partner' }
                            ];
                        }else{
                             var myOptions =[
                                { id: 'Child', label: 'Child' },
                            ];
                        }
                    }else{
                        var myOptions =[
                            { id: 'Child', label: 'Child' },
                            { id: 'Domestic Partner', label: 'Domestic Partner' }
                            ];          
                    }
                    
                 component.set("v.options",myOptions);
                    //alert(component.get("v.options"));
                }
                else{
                    if(message.Opportunity__r.Account.Domestic_Partner__c === 'N' || message.Opportunity__r.Account.Domestic_Partner__c == undefined ||message.Opportunity__r.Account.Domestic_Partner__c === ''){
                        if(message.Relationship__c!=null && message.Relationship__c!=undefined && message.Relationship__c!='' && message.Relationship__c!='None'){
                            if(message.Relationship__c=='Child'){
                                var myOptions1 =  [
                                    { id: 'Spouse', label: 'Spouse'},
                                    { id: 'Domestic Partner', label: 'Domestic Partner' }
                                ];
                            }else if(message.Relationship__c=='Spouse'){
                                var myOptions1 =  [
                                    { id: 'Child', label: 'Child' },
                                    { id: 'Domestic Partner', label: 'Domestic Partner' }
                                ];
                            }else if(message.Relationship__c=='Domestic Partner'){
                            	var myOptions1 =  [
                                    { id: 'Spouse', label: 'Spouse'},
                                    { id: 'Child', label: 'Child' },
                                ];
                            }
                        }else{    
                            var myOptions1 =  [
                            { id: 'Spouse', label: 'Spouse'},
                            { id: 'Child', label: 'Child' },
                            { id: 'Domestic Partner', label: 'Domestic Partner' }
                       		 ];
                        }
                        
                        component.set("v.options",myOptions1);
                    }
                }
            }
            //alert(message.Zip_Code__c);       
            component.set("v.CensusRecord",message);
            /*component.set("v.PreviousCoverageStatus",message.Health_Comp__c);
            component.set("v.PreviousDentalCoverageStatus",message.Dental_comp__c);
            component.set("v.PreviousVisionCoverageStatus",message.Vision_Comp__c);
			component.set("v.HealthCoverageStatus",message.Health_Coverage__c);//formula fields
            component.set("v.DentalCoverageStatus",message.Dental_Coverage__c);
            component.set("v.VisionCoverageStatus",message.Vision_Coverage__c);
            component.set("v.backendvalue",message.Backend_Created__c);*/
         	
        //component.find("Gender__c").set("v.value", component.get("v.CensusRecord").Gender__c);
        //helper.calculateMemberCount(component,event,message);
       // component.get("c.handleSave");
    },
    handleLoad : function(component,event,helper){
        //alert(component.get("v.CensusRecord.Zip_Code__c"));
        //component.find("Gender__c").set("v.value", component.get("v.CensusRecord").Gender__c);
        //component.find("Relationship__c").set("v.value", component.get("v.CensusRecord").Relationship__c);
        //$A.util.removeClass(component.find("DateOfBirth"), "none");
        //$A.util.removeClass(component.find("ZipCode"), "none");
	    //$A.get('e.force:refreshView').fire();
        /*var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.subscriberId")
        });
        editRecordEvent.fire(); */
        
    },
     
        Changevalue: function(component,event,helper){
            
            component.set("v.Test",true);
        },
            
    Dependenthandlesave: function(component,event,helper){
        component.set("v.DependentAge",false);
     	var dI=component.get("c.handleSave");
        $A.enqueueAction(dI);
 		 },      
    handleSave : function(component,event,helper){
       var rec = component.get("v.CensusRecord");
       console.log(rec);
        /*var Coverage=rec.Health_Plan_ID__c;
        var Coveragedental=rec.Dental_Plan_ID__c;
        var Coveragevision=rec.Vision_Plan_ID__c;
		var thirdhealth=rec.Health_Comp__c;
		var thirddental=rec.Dental_comp__c;
        var thirdvision=rec.Vision_Comp__c;
         var tem = rec.Health_Coverage__c;
        
        if(Coverage || thirdhealth || tem){
           // alert('roopa health reached');
         component.set("v.HealthCoverage",true);
            //alert('health completed');
        }
        if(Coveragedental || thirddental){
            component.set("v.DentalCoverage",true);
        }
        if(Coveragevision || thirdvision){
           component.set("v.VisionCoverage",true); 
        }*/
        rec.Relationship__c = component.find("InputSelectSingle").get("v.value");
        if(rec.Gender__c=='' ||rec.Gender__c==null||rec.Gender__c==undefined|| rec.Zip_Code__c==''||rec.Zip_Code__c==null||rec.Zip_Code__c==undefined || rec.Relationship__c=='None' || rec.First_Name__c==null || rec.First_Name__c==undefined || rec.First_Name__c=='' || rec.Last_Name__c==null || rec.Last_Name__c==undefined || rec.Last_Name__c==''){
            alert('Please fill in all required fields');
        }        
        else if((rec.Date_of_Birth__c==''||rec.Date_of_Birth__c==null||rec.Date_of_Birth__c==undefined) && (rec.Age_New__c==''||rec.Age_New__c==null||rec.Age_New__c==undefined)){
            alert('Either one of DOB or Age must be entered');
        }
       else if(component.get("v.headerTxt")=='Add Dependent' && component.get("v.isSpouseOrDpExists") && rec.Relationship__c!='Child'){    
           alert('Cannot add more than one spouse or domestic partner for a subscriber');
		}
        
            else if(!component.get("v.HealthCoverage") && !component.get("v.DentalCoverage") && !component.get("v.VisionCoverage") && component.get("v.headerTxt")!='Edit Census'){
                alert('You should select at lease one of Health Coverage / Dental Coverage / Vision Coverage');
            }
               
                else if(rec.Gender__c!='' && rec.Gender__c!=null && rec.Gender__c!=undefined && rec.Zip_Code__c!='' && rec.Zip_Code__c!=null && rec.Zip_Code__c!=undefined && rec.Relationship__c!='' && rec.Relationship__c!='None' && rec.Relationship__c!=null && rec.Relationship__c!=undefined && ((rec.Date_of_Birth__c!='' && rec.Date_of_Birth__c!=null && rec.Date_of_Birth__c!=undefined) || (rec.Age_New__c!=''&& rec.Age_New__c!=null && rec.Age_New__c!=undefined)) && (component.get("v.HealthCoverage") || component.get("v.DentalCoverage") || component.get("v.VisionCoverage") || component.get("v.headerTxt")=='Edit Census')){
                    console.log('recD-->',JSON.stringify(rec));
                    
                    if(!component.get("v.HealthCoverage") && component.get("v.headerTxt")!='Edit Census'){
                        rec.Health_Plan_ID__c = null;
                        rec.Health_Tier__c = null;
                        rec.Health_Group_Number__c=null;
                        rec.Health_Group_Section__c=null;
                    }
                    if(!component.get("v.DentalCoverage") && component.get("v.headerTxt")!='Edit Census'){
                        rec.Dental_Plan_ID__c = null;
                        rec.Dental_Tier__c=null;
                        rec.Dental_Group_Number__c=null;
                        rec.Dental_Group_Section__c=null;
                    }
                    if(!component.get("v.VisionCoverage") && component.get("v.headerTxt")!='Edit Census'){
                        rec.Vision_Plan_ID__c=null;
                        rec.Vision_Tier__c=null; 
                        rec.Vision_Group_Number__c=null;
                        rec.Vision_Group_Section__c=null;
                    }
              if(component.get("v.CensusRecord.Age_New__c")>99 || (component.get("v.CensusRecord.Age_New__c")<16 && component.get("v.CensusRecord.Age_New__c")!=null)|| (component.get("v.CensusRecord.Retiree__c")=='Y' && (component.get("{!v.NMString}")== 'NM' || component.get("{!v.NMString}")== 'TX' || component.get("{!v.NMString}")== 'OK' || component.get("{!v.NMString}")== 'MT'))){ 
                if(component.get("v.CensusRecord.Age_New__c")>99){ 
				var Agerate = confirm("Subscriber or dependent over the age of 99. Do you wish to proceed?");
					}
                    else{}
				if(component.get("v.CensusRecord.Age_New__c")<16 && component.get("v.CensusRecord.Age_New__c")!=null && (component.get("v.CensusRecord.Relationship__c")=='Spouse' ||component.get("v.CensusRecord.Relationship__c")=='Subscriber' || component.get("v.CensusRecord.Relationship__c")=='Domestic Partner') ){
			                    
				var censusage = confirm("Subscriber/spouse/domestic partner census under the age of 16 for a non-cobra subscriber. Do you wish to proceed?");
				}
                    else{}
                if(Agerate == true || censusage==true || component.get("v.CensusRecord.Relationship__c")=='Child'){
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
                        var getBool = true;
                        if(rec.Opportunity__r.HCSC_Division__c=='MT' && rec.Age_New__c<19){  
                            getBool = confirm("Under 19 census will not be enrolled vision and will only be enrolled into Health.\nDo you wish to proceed?");
                            if(getBool){
                                rec.Vision_Plan_ID__c='';
                                rec.Vision_Group_Number__c='';
                                rec.Vision_Group_Section__c='';
                            }
                        }if(getBool){
                            var action = component.get("c.saveCensusRecord");
                            action.setParams({
                                'OptyCensus':rec,
                                'subId':component.get("v.subscriberId"),
                                'tabName' : component.get("v.tabName")
                            });
                            action.setCallback(this,function(response){
                                if(response.getState() === "SUCCESS"){
                                    var lightningEvent = $A.get("e.c:SGR_CensusDependent_Tab");
                                    lightningEvent.setParams({
                                        "message" : "An application event fired me." });
                                    lightningEvent.fire();
                                    //window.history.back();
                                    var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
                                    compEvent.setParams({
                                        "Confirmed" : true
                                    });
                                    compEvent.fire(); 
                                    
                                    var lightningEvent1 = $A.get("e.c:RatingStatusRefresh");
                                    lightningEvent1.setParams({
                                        "message" : "An application event fired me." });
                                    lightningEvent1.fire();
                                    component.set("v.DependentAge",true);   
                                }       
                            });
                            $A.enqueueAction(action);
                    	}
                	}
                }
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
                        var action = component.get("c.saveCensusRecord");
                        action.setParams({
                            'OptyCensus':rec,
                            'subId':component.get("v.subscriberId"),
                            'tabName' : component.get("v.tabName")
                        });
                       
                        action.setCallback(this,function(response){
                            if(response.getState() === "SUCCESS"){
                               //Roopa Commented the below code.
                               /*var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId":rec.Opportunity__c,
                                });
                                navEvt.fire();*/
                                // u15480 new event 
                                
                                var lightningEvent = $A.get("e.c:SGR_CensusDependent_Tab");
                                    lightningEvent.setParams({
                                    "message" : "An application event fired me." });
                                    lightningEvent.fire();
                                //window.history.back();
                                var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
                                compEvent.setParams({
                                    "Confirmed" : true
                                });
                                compEvent.fire(); 
                                
                                var lightningEvent1 = $A.get("e.c:RatingStatusRefresh");
                                    lightningEvent1.setParams({
                                     "message" : "An application event fired me." });
                                    lightningEvent1.fire();
                                component.set("v.DependentAge",true);
                            }
                            else{
                                
                            }
                        });
                        $A.enqueueAction(action);
                    }
                }
                }
    },
        
    /*    handleSave : function(component,event,helper){
        var record = component.get("v.CensusRecord");
      if(record.Age_New__c>99){
             var Agerate = confirm("Subscriber or dependent over the age of 99. Do you wish to proceed?");
             if(Agerate == true){
      			 var dI=component.get("c.handleSavenew");
                 $A.enqueueAction(dI);
       			}
              }  
        else{
            var dI1=component.get("c.handleSavenew");
            $A.enqueueAction(dI1);
        	}
        },*/
    onSingleSelectChange : function(component,event,helper){
        //alert(component.find("InputSelectSingle").get("v.value"));
		var rec = component.get("v.CensusRecord"); 
        var oppId = rec.Opportunity__c;
        console.log(oppId);
        rec.Relationship__c = component.find("InputSelectSingle").get("v.value");
        var relationShipValue = rec.Relationship__c;
        console.log(relationShipValue);
        var subId = rec.Subscriber_Number__c;
        var action = component.get("c.CountSpouseOrDpExists");
      		action.setParams({
			'optyId' : oppId,
			'subNumber' : subId,
            'relationship' : relationShipValue
		});
        action.setCallback(this,function(response){
        	if(response.getState() === "SUCCESS"){
            	//console.log(response);
                //alert(response.getReturnValue());               
                if(response.getReturnValue() === true){
                    //alert('Reached 2nd loop');
                    component.set("v.isSpouseOrDpExists", true);
                }else{
                    component.set("v.isSpouseOrDpExists", false);
                }
        	}
        
        });
        $A.enqueueAction(action); 
    },
    getAge: function(component,event,helper){
        var rec = component.get("v.CensusRecord");
        var db = component.get("v.CensusRecord").Date_of_Birth__c;
        if(db!=null && db!='' && db!= undefined){
            var c = db.split("-");
            var dob = new Date(c[0],c[1],c[2]);
            //var d = new Date();
            var d = component.get("v.CensusRecord").Opportunity__r.Renewal_Date__c;
            if(d!=''&&d!=undefined&&d!=null){
            var d1 = d.split("-");
            var dob1  = new Date(d1[0],d1[1],d1[2]);
                var oneDay = 24*60*60*1000;
                var diffDays = Math.round(Math.abs((dob1.getTime() - dob.getTime())/(oneDay)));
                var ageVal = Math.floor(diffDays/365);
                if(isNaN(ageVal)){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Please provide Date of Birth in correct format",
                        "type": "error",
                        "mode": "sticky",
                        "duration": "500"
                    });
                    toastEvent.fire();
                }else{
                	component.set("v.CensusRecord.Age_New__c",ageVal);
                }
            }
        }else{
            component.set("v.CensusRecord.Age_New__c",'');
        }
    },
    handleHealthCheck : function(component,event,helper){
        if(component.get("v.HealthCoverage")){
            component.set("v.VisionCoverage",true);
        }else{
            component.set("v.VisionCoverage",false);
        }
    }
})