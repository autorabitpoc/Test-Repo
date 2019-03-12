({
	compInit : function(component, event, helper) {
       helper.helperdoInit(component, event, helper);     
        var cataction = component.get("c.fetchcatList");
        cataction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.catlist", response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var cobraList=component.get("v.catlist");
                    for(var i=0;i<cobraList.length;i++)
                    {
                        if(cobraList[i]===component.get("v.accDetails").COBRA_Administration_Type__c)
                        {
                            opts.push({"class":"optionClass" , label:cobraList[i] , value:cobraList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:cobraList[i] , value:cobraList[i]});
                        }
                    }
                    component.find("cat").set("v.options", opts);
            }
        });  
        $A.enqueueAction(cataction);
        
        
        var postpeaction = component.get("c.fetchpostpeList");
        postpeaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.postpelist" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var post65List=component.get("v.postpelist");
                    for(var i=0;i<post65List.length;i++)
                    {
                        if(post65List[i]===component.get("v.accDetails").Post_65_Individual_Private_Exchange__c)
                        {
                            opts.push({"class":"optionClass" , label:post65List[i] , value:post65List[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:post65List[i] , value:post65List[i]});
                        }
                    }
                    component.find("posti").set("v.options", opts);
            }
        });  
        $A.enqueueAction(postpeaction);
        
        var enameaction = component.get("c.fetchexchangenameList");
        enameaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.exchanegnamelist" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var exnameList=component.get("v.exchanegnamelist");
                    for(var i=0;i<exnameList.length;i++)
                    {
                        if(exnameList[i]===component.get("v.accDetails").Exchange_Name__c)
                        {
                            opts.push({"class":"optionClass" , label:exnameList[i] , value:exnameList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:exnameList[i] , value:exnameList[i]});
                        }
                    }
                    component.find("ename").set("v.options", opts);
            }
        });  
        $A.enqueueAction(enameaction);
        
        var prepeaction = component.get("c.fetchprepeList");
        prepeaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.pre65list" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var preList=component.get("v.pre65list");
                    for(var i=0;i<preList.length;i++)
                    {
                        if(preList[i]===component.get("v.accDetails").Pre_65_Individual_Private_Exchange__c)
                        {
                            opts.push({"class":"optionClass" , label:preList[i] , value:preList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:preList[i] , value:preList[i]});
                        }
                    }
                    component.find("pre65").set("v.options", opts);
            }
        });  
        $A.enqueueAction(prepeaction);
        
        var hpmaction = component.get("c.fetchhcmprogramList");
        hpmaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.hcmprogramlist" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var hcmpmList=component.get("v.hcmprogramlist");
                    for(var i=0;i<hcmpmList.length;i++)
                    {
                        if(hcmpmList[i]===component.get("v.accDetails").HCM_Program_Model__c)
                        {
                            opts.push({"class":"optionClass" , label:hcmpmList[i] , value:hcmpmList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:hcmpmList[i] , value:hcmpmList[i]});
                        }
                    }
                    component.find("hcm").set("v.options", opts);
            }
        });  
        $A.enqueueAction(hpmaction);
        
        var bccpgmaction = component.get("c.fetchbccprogramList");
        bccpgmaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.bccprogramlist" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var bpgmList=component.get("v.bccprogramlist");
                    for(var i=0;i<bpgmList.length;i++)
                    {
                        if(bpgmList[i]===component.get("v.accDetails").BCC_Program_s__c)
                        {
                            opts.push({"class":"optionClass" , label:bpgmList[i] , value:bpgmList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:bpgmList[i] , value:bpgmList[i]});
                        }
                    }
                    component.find("bpgm").set("v.options", opts);
            }
        });  
        $A.enqueueAction(bccpgmaction);
        
        var hcmaction = component.get("c.fetchhcmclientList");
        hcmaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.hcmclientlist" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var hciList=component.get("v.hcmclientlist");
                    for(var i=0;i<hciList.length;i++)
                    {
                        if(hciList[i]===component.get("v.accDetails").HCM_Client_Intensity__c)
                        {
                            opts.push({"class":"optionClass" , label:hciList[i] , value:hciList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:hciList[i] , value:hciList[i]});
                        }
                    }
                    component.find("hci").set("v.options", opts);
            }
        });  
        $A.enqueueAction(hcmaction);

        var wellnessaction = component.get("c.fetchwellnesscList");
        wellnessaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //console.log('sujatha sep1'+state);
                console.log('sujatha'+ response.getReturnValue());
               // component.set("v.saveAndNewFlag",false);
                component.set("v.wellnesslist" , response.getReturnValue());
                
                 var opts = [{"class":"optionClass" , label:"--None--" , value:""}];
                    var wcList=component.get("v.wellnesslist");
                    for(var i=0;i<wcList.length;i++)
                    {
                        if(wcList[i]===component.get("v.accDetails").Wellness_Consulting_Coordinator__c)
                        {
                            opts.push({"class":"optionClass" , label:wcList[i] , value:wcList[i] , selected: "true"});
                        }
                        else
                        {
                            opts.push({"class":"optionClass" , label:wcList[i] , value:wcList[i]});
                        }
                    }
                    component.find("wc").set("v.options", opts);
            }
        });  
        $A.enqueueAction(wellnessaction);
        
        
        var recordtypeaction = component.get("c.getaccRecordType");
        var accountid = component.get("v.recordId"); 
        console.log('209 Product accountid'+accountid); 
        recordtypeaction.setParams({"accountId":accountid});
        recordtypeaction.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if (state === "SUCCESS") 
                               {
                                console.log('test '+state);
                                component.set("v.recordTypelist" ,response.getReturnValue());
                                console.log('test record type'+response.getReturnValue());
                                //alert('test type'+component.get("v.recordTypelist[2]"));
 
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
        $A.enqueueAction(recordtypeaction);
	},
    saveproduct:function(component,event,helper){
        var accdetailrec =component.get("v.accDetails");
         console.log('save accdetailrec'+accdetailrec);
        
        var action = component.get("c.updateproductAcc");
        action.setParams({"accdetailrecord": accdetailrec
                          });
        action.setCallback(this, function(response){       
            var state = response.getState();           
            if (state === "SUCCESS") 
            {   
                //console.log('------state----->'+response.getReturnValue().Exchange_Account__c ); 
                console.log('------state----->'+response.getReturnValue());
                component.set("v.accDetails" , response.getReturnValue());
               // var url= '/'+response.getReturnValue().Id;
               // var url1=  '/one/one.app#/sObject/'+response.getReturnValue().Id;
                //console.log('----------->'+url1);
                //window.location.href=url1;
               // sforce.one.navigateToURL(url);
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