({
    callServer : function(component,method,callback,params) {
        console.log("method: "+method);
        var action = component.get(method);
        
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") { 
                // pass returned value to callback function
                callback.call(this,response.getReturnValue());  
               //   console.log('Record is saved successfully');
          
                
            } else if (state === "ERROR") {
                // generic error handler
                var errors = response.getError();
                
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    loadPickListOptions : function (component, helper, optionsMap){
        var tOptMap=component.get("v.TypeOptionMap");//[];//new Map();//component.get("v.TypeOptionMap");
        var sOptMap=component.get("v.StatusOptionMap");//[];//new Map();//component.get("v.StatusOptionMap");
    
        optionsMap.forEach(function (value, key, mapObj)  {
            console.log('key::'+key+' value:'+value.Status__c+' '+value.ForStatus__c);
            console.log('key::'+key+' value:'+value.Type__c+' '+value.ForType__c);
            var statusOptions=[];//
            var typeOptions=[];
            var fundingTypeOptions=[];
            var premiumTypeOptions=[];
            
                  
            if(key==='Master'){//funding type, premium don't dependent on record type
               var fOptions=value.Funding_Type__c.split(";");
               var pOptions=value.Premium_Type__c.split(";");
               for(var i=0;i<fOptions.length;i++){
                  console.log("funding type options--> "+fOptions[i]);
                  fundingTypeOptions.push({
                               "value":fOptions[i],                             
                               "label":fOptions[i]
                                });
              }
                
               //premiumTypeOptions.push({id:"None",
                 //                       lable:"None"});
                
                for(var j=0;j<pOptions.length;j++){
                  console.log(" preium options--> "+pOptions[j]);
                    if(pOptions[j]==="--None--"){
                        premiumTypeOptions.push({
                               "value":"",                             
                               "label":pOptions[j]
                                });
                    }else{
                        premiumTypeOptions.push({
                               "value":pOptions[j],                             
                               "label":pOptions[j]
                                });
                    }
               }
                component.set("v.fundingTypeOptions",fundingTypeOptions);
                component.set("v.premiumTypeOptions",premiumTypeOptions);
            }//master 
          
          if(value.ForStatus__c){
           var sOptions=value.Status__c.split(";");
              
            for(var m=0;m<sOptions.length;m++){
                  console.log(" status options: "+sOptions[m]);
                  statusOptions.push({
                               "value":sOptions[m],                             
                               "label":sOptions[m]
                                });
            }
                //sOptMap.set(key, statusOptions);
             sOptMap[key]=statusOptions;
           }
            if(value.ForType__c){
            
              var tOptions=value.Type__c.split(";");
                
              for(var n=0;n<tOptions.length;n++){
               console.log(" type options: "+tOptions[n]);
               typeOptions.push({
                                 "value":tOptions[n],
                                "label":tOptions[n]
                               });
              }  
                  //tOptMap.set(key, typeOptions);
              tOptMap[key]=typeOptions;
                                          
            }
             
        });
        
     
       component.set("v.StatusOptionMap",sOptMap); 
       component.set("v.TypeOptionMap",tOptMap);
                                                      
    },
    addProductTable :function(component, newOppProdData){
        
        var currentTable=component.get("v.currentOppProductsMap");
        var opProductListToUpdate = component.get("v.opportunityProductList");
        var newList=[];
        
        if(newOppProdData!=null &&newOppProdData.Product__c!=null){
         var cat=newOppProdData.Product__r.Product_Type__c;
           console.log('new category::::'+cat+' size before added:::'+currentTable[cat].length);
            if(currentTable[cat]!=null && currentTable[cat]!='undefined'){//if category existing
               currentTable[cat].push(newOppProdData);
              console.log('new size after added:'+currentTable[cat].length);
            }else{
                newList.push(newOppProdData);
                currentTable.set(cat,newList);
                console.log('New list: '+newList);
             }
            component.set("v.currentOppProductsMap", currentTable);
           
        }
           
        
    },
    //to remove ignore
    loadStatusPicklist : function(component, helper, recordId){//test method
       var Status = [
            { id: "In Progress", label: "In Progress" },
            { id: "Won", label: "Won" },
            { id: "Lost", label: "Lost" }
        ];
        
        var StatusPT = [
            { value: "Decline", label: "Decline" }
        ];
        var Status_UpSell_IL=[ 
            { id: "In Progress", label: "In Progress" },
            { id: "Won", label: "Won" },
            { id: "Lost", label: "Lost" },
            { id:"GeoAccess/Discount Analysis/Proposal Provided", label:"GeoAccess/Discount Analysis/Proposal Provided"},
            { id:"Pricing/Presentation to Client", label:"Pricing/Presentation to Client"}
           ];
        console.log('status option from helper:'+Status);
        component.set("v.StatusOptions", Status);

        component.set("v.StatusDeclinedOptions", StatusPT);
        component.set('v.StatusUpSell_IL',Status_UpSell_IL);
    },
    showToast : function(component, event, helper) {
        console.log('fire me');
    var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                                       "title": "Success!",
                                        "message": "The record has been updated successfully."
                                      });
                   toastEvent.fire();
      },
    
    genericShowToast : function(title,message,mode,type){
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "message": message,
                    "mode": mode,
                    "type":type
                });
                toastEvent.fire();        
    },
    
    VF_showToast : function(component, event){
        
        var postEventToOneApp = function(name, params, fallbackAction) {
        if (SfdcApp && SfdcApp.projectOneNavigator && SfdcApp.projectOneNavigator.fireContainerEvent) {
    // Not officially supported by Salesforce
           SfdcApp.projectOneNavigator.fireContainerEvent(name, params);
      } else if (fallbackAction) {
    // Fallback if no Salesforce support of fireContainerEvent
          fallbackAction();
      }
     };

       component.addEventHandler({
             event: 'force:showToast',
             handler: function(event) {
             postEventToOneApp('force:showToast', event.$params$, function() {
                alert(event.$params$.message);
         });
       }
      });
    },
    
    addProductToTable : function (recordId){
        var currentTable =component.get("v.currentOppProductsMap");
    },
   
   toggleHelper : function(component,event) {
    var toggleText = component.find("tooltip");
    $A.util.toggleClass(toggleText, "toggle");
   }
})