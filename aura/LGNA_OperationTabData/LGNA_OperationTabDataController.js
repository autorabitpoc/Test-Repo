({
	compInit : function(component, event, helper) {
        var curAccount = component.get("v.recordId");  
        
        var action = component.get("c.getaccDetails");
        action.setParams({"accountId":curAccount});
        action.setCallback(this, function(response)
                            { 
                                var state = response.getState();                                 
                                if (state === "SUCCESS") 
                                {
                                    if(response.getReturnValue()!==null){  
                                        component.set("v.accDetails" ,response.getReturnValue()); 
                                    }
                                } 
                            });
         $A.enqueueAction(action);
       
        //Distribution Method field
        var dmaction = component.get("c.fetchAccdmList");
        dmaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha DM list'+ response.getReturnValue());
                component.set("v.distributionlist", response.getReturnValue());
                
                // var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                var opts = [];
                    var dmList=component.get("v.distributionlist");
                    for(var i=0;i<dmList.length;i++)
                    {
                        if(dmList[i]===component.get("v.accDetails").Distribution_Method__c)
                        {
                            opts.push({"class":"optionClass" , label:dmList[i] , value:dmList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:dmList[i] , value:dmList[i]});
                        }
                    }
                    component.find("dm").set("v.options", opts);
                //console.log('sujatha dm'+ component.find("risklevel").set("v.options", opts));
            }
        });  
        $A.enqueueAction(dmaction);
        
        //Risk Type field
        var riskaction = component.get("c.fetchRiskTypeList");
        riskaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                //console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.risktypeList" , response.getReturnValue());
                
                var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var rtypeList=component.get("v.risktypeList");
                    for(var i=0;i<rtypeList.length;i++)
                    {
                        if(rtypeList[i]===component.get("v.accDetails").Risk_Type__c)
                        {
                            opts.push({"class":"optionClass" , label:rtypeList[i] , value:rtypeList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:rtypeList[i] , value:rtypeList[i]});
                        }
                    }
                    component.find("risktype").set("v.options", opts);
                //  console.log('sujatha gmtpye'+ component.find("risklevel").set("v.options", opts));
            }
        });  
        $A.enqueueAction(riskaction);
        
        //Risk Level Field
        var risklevelaction = component.get("c.fetchRiskLevelList");
        risklevelaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
               // console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.risklevelList" , response.getReturnValue());
                
                var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var rlevelList=component.get("v.risklevelList");
                    for(var i=0;i<rlevelList.length;i++)
                    {
                        if(rlevelList[i]===component.get("v.accDetails").Current_Risk_Level__c)
                        {
                            opts.push({"class":"optionClass" , label:rlevelList[i] , value:rlevelList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:rlevelList[i] , value:rlevelList[i]});
                        }
                    }
                    component.find("risklevel").set("v.options", opts);
                  //console.log('sujatha gmtpye'+ component.find("risklevel").set("v.options", opts));
            }
        });  
        $A.enqueueAction(risklevelaction);
       
        //Group Medicare Type  Field
        var gmtaction = component.get("c.fetchGroupMTList");
        gmtaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                //console.log('sujatha gmt'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.gmtypeList" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var gmtList=component.get("v.gmtypeList");
                    for(var i=0;i<gmtList.length;i++)
                    {
                        if(gmtList[i]===component.get("v.accDetails").Group_Medicare_Type__c)
                        {
                            opts.push({"class":"optionClass" , label:gmtList[i] , value:gmtList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:gmtList[i] , value:gmtList[i]});
                        }
                    }
                    component.find("gmt").set("v.options", opts);
                  //console.log('sujatha gmtpye'+ component.find("gmt").set("v.options", opts));
            }
        });  
        $A.enqueueAction(gmtaction);
        
        //Group Medicare Plan Field
        var gmpaction = component.get("c.fetchGroupMPList");
        gmpaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                //console.log('sujatha gmplan'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.gmplanList" , response.getReturnValue());
                
                    var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var gplanList=component.get("v.gmplanList");
                    for(var i=0;i<gplanList.length;i++)
                    {
                        if(gplanList[i]===component.get("v.accDetails").Group_Medicare_Plan__c)
                        {
                            opts.push({"class":"optionClass" , label:gplanList[i] , value:gplanList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:gplanList[i] , value:gplanList[i]});
                        }
                    }
                    component.find("gmp").set("v.options", opts);
                  //console.log('sujatha gmplan'+ component.find("gmp").set("v.options", opts));
            }
        });  
        $A.enqueueAction(gmpaction);
        
        var recordtypenameaction = component.get("c.getaccRecordTypename");
        var accountid = component.get("v.recordId"); 
        console.log('oPeration accountid'+accountid); 
        recordtypenameaction.setParams({"accountId":accountid});
        recordtypenameaction.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if (state === "SUCCESS") 
                               {
                                console.log('test '+state);
                                component.set("v.recordTypename" ,response.getReturnValue());
                                console.log('test record type'+response.getReturnValue());
                               }
                               else if(state === "ERROR")
                               {
                                   var errors = response.getError();
                                   if (errors) 
                                   {                                           
                                       if (errors[0] && errors[0].message)
                                       {
                                           //console.log("Error message: " + errors[0].message);
                                       }
                                   } 
                                   else 
                                   {
                                       //console.log("Unknown error");
                                   }
                               }
                           });
        $A.enqueueAction(recordtypenameaction);

       //FSU Location Field
        /* var fsuaction = component.get("c.fetchfsulocationList");
        fsuaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                //console.log('sujatha gmplan'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.fsulocationplanList", response.getReturnValue());
                console.log('fsulocationplanList'+response.getReturnValue());
                    var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var floList=component.get("v.fsulocationplanList");
                    for(var i=0;i<floList.length;i++)
                    {
                        if(floList[i]===component.get("v.accDetails").FSU_Location__c)
                        {
                            opts.push({"class":"optionClass" , label:floList[i] , value:floList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:floList[i] , value:floList[i]});
                        }
                    }
                    component.find("fsuloc").set("v.options", opts);
                  //console.log('sujatha gmplan'+ component.find("gmp").set("v.options", opts));
            }
        });  
        $A.enqueueAction(fsuaction);*/  
        
        /*var lookupaction = component.get("c.getRecordUsingChildRecord"); 
        lookupaction.setParams({accId:component.get("v.recordId")}); 
        lookupaction.setCallback(this, function(response){ 
            var state = response.getState(); 
            if(state != "SUCCESS"){ 
                alert('Failed to get record'); 
            } 
            else{ 
                var ret = response.getReturnValue(); 
                alert(ret); 
                component.set("v.Lookupvalues", ret); 
            } 
        }); 
        $A.enqueueAction(lookupaction);*/
  
	},
    
    //Save logic
    save:function(component,event,helper){
        var accdetailrec =component.get("v.accDetails");
         //console.log('save accdetailrec'+accdetailrec);
        
        var action = component.get("c.updateAcc");
        action.setParams({"accdetailrecord": accdetailrec
                          });
        action.setCallback(this, function(response){       
            var state = response.getState();           
            if (state === "SUCCESS") 
            {   
               console.log('------state----->'+state); 
                console.log('------state----->'+response.getReturnValue());
                component.set("v.accDetails" , response.getReturnValue());
                //var url1=  '/one/one.app#/sObject/'+response.getReturnValue().Id;
                //window.location.href=url1;
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been updated successfully.",
                        "type":"success"
                    });
                    toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
        
    }
    
})