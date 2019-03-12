({
    compInit : function(component, event, helper) {
        //var testrec = component.get("v.recordtypeId");  
        var stageaction = component.get("c.getStageValues");
        stageaction.setCallback(this, function(response)
                                {
                                    //component.set("v.stage" ,response.getReturnValue());
                                    console.log('test suajthatha stage'+response.getReturnValue().length);
                                    var select=response.getReturnValue();
                                    select.splice(0,11);
                                    select.splice(2,4);
                                    select.splice(2,1);
                                    select.splice(10,1);
                                    
                                    console.log("---select "+typeof select);
                                    //console.log('test select'+prospect);
                                    //console.log('test'+select.splice(2,1));
                                    component.set("v.stage" ,select);
                                  
                                });
        $A.enqueueAction(stageaction);
        
        var finalistaction = component.get("c.getFinalistValues");
        finalistaction.setCallback(this, function(response)
                                   {
                                       component.set("v.finalist" ,response.getReturnValue());
                                   });
        $A.enqueueAction(finalistaction);
        
         var pclosedreasonaction = component.get("c.getPrimaryClosedReasonValues");
        pclosedreasonaction.setCallback(this, function(response)
                                   {
                                       component.set("v.pclosedlist" ,response.getReturnValue());
                                   });
        $A.enqueueAction(pclosedreasonaction);
        
        var typeaction = component.get("c.gettypeValues");
        typeaction.setCallback(this, function(response)
                               {
                                   component.set("v.type" ,response.getReturnValue());
                               });
        $A.enqueueAction(typeaction);
        
        var eoftypeaction = component.get("c.geteoftypeValues");
        eoftypeaction.setCallback(this, function(response)
                                  {
                                      component.set("v.eoftype" ,response.getReturnValue());
                                  });
        $A.enqueueAction(eoftypeaction);
        
        var accid= component.get("v.accountId");
        console.log('test acc sujatha'+accid);
        var action = component.get("c.getaccDetails");
        action.setParams({"accountId":accid});
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
        
        /* var opprecsaction = component.get("c.getOpportunityrectype");
        opprecsaction.setParams({"accountId": accid
                                  //"recordtypeId": "01233000000QMPD",
                                });
        opprecsaction.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('before response assgin'+result);
              	console.log('create opp test'+response.getReturnValue());
                component.set("v.oppRecordsList", result);
            }
        });
        $A.enqueueAction(opprecsaction);*/
    },
    
    cancel : function(component, event,helper)
    {  
        component.destroy();  
        $A.get("e.force:closeQuickAction").fire();
    },

    validationandsave: function(component, event,helper)
    {  
        console.log('test validation');
             
        //All fields otherthan date and picklist Validation
        var allValid = component.find('opname').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
         var cddDate = component.find("cddDate").get("v.value");
         var enteredoedate=component.find('oeDate').get("v.value");
         var enteredrfidate=component.find('rfiDate').get("v.value");
        
	 if(cddDate === undefined || cddDate === null || cddDate === '' || cddDate === 'null')
	{ 
        console.log('if cddDate validation'+cddDate);
		component.find("cddDate").set("v.errors", [{message:"Opportunity Client Due Date Required."}]);
	} 
     if(enteredoedate === undefined || enteredoedate === null || enteredoedate === '' || enteredoedate === 'null')
	{ 
        console.log('if validation'+enteredoedate);
		component.find("oeDate").set("v.errors", [{message:"Opportunity Effective Date Required."}]);
	}
    if(enteredrfidate === undefined || enteredrfidate === null || enteredrfidate === '' || enteredrfidate === 'null')
	{ 
        console.log('validation'+enteredrfidate);
		component.find("rfiDate").set("v.errors", [{message:"Opportunity RFI/RFP Date Required."}]);
	}else
        if (allValid) {
             console.log('else if validation'+allValid);
            helper.save(component, event, helper);
        } else {
            console.log('inside else validation'+allValid);
            //alert('Please enter Required values.');       
        }
        
    },
    cdddatevalidateblur:function(component, event,helper)
    {   
        var enteredcdddate=component.find('cddDate').get("v.value");
        console.log('test onblur'+enteredcdddate);
        if(enteredcdddate!==undefined || enteredcdddate!=='' || enteredcdddate != null ){ 
            console.log('test name onblur error'+enteredcdddate);
            component.find("cddDate").set("v.errors",'');
        }
    },
    oedatevalidateblur:function(component, event,helper)
    {   
        var enteredoedate=component.find('oeDate').get("v.value");
        if(enteredoedate!==undefined || enteredoedate!=='' || enteredoedate !== null ){ 
            console.log('error'+enteredoedate);
            component.find("oeDate").set("v.errors",'');
        }
    },
     rfidatevalidateblur:function(component, event,helper)
    {   
        var enteredrfidate=component.find('rfiDate').get("v.value");
        console.log('test onblur'+enteredrfidate);
        if(enteredrfidate!==undefined || enteredrfidate!=='' || enteredrfidate !== null ){ 
            console.log('test error'+enteredrfidate);
            component.find("rfiDate").set("v.errors",'');
        }
    }
})