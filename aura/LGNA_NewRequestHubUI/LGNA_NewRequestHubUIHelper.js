({
	callServer : function(component,method,callback,params) {
        console.log("method: "+method);
    var action = component.get(method);
     if (params) {
        action.setParams(params);
    }
    
        
   // debugger;
       // console.log("parameter: "+params);
        
      action.setCallback(this, function(response) {
          
        var state = response.getState();
         console.log(state);
        if (state === "SUCCESS") { 
            // pass returned value to callback function
            callback.call(this,response.getReturnValue());   
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
    
   CompareTwoListForChange : function(newList,oldList, component){
        var newColor='';
        var oldColor='';
      //  var i=0;
      //  alert(oldList.length+ ':'+newList.length);
        
        if(oldList!=null && oldList.length>0){//compare the old one and new
         
            if(newList!=null&& newList.length>0){
               for(var i=0;i<newList.length;i++){
                   // alert( i+'why?not here');
                    if(newList[i].FavoriteColor__c!=null){
                      newColor=newList[i].FavoriteColor__c;
                    }
                    if(oldList[i].FavoriteColor__c!=null){
                       oldColor=oldList[i].FavoriteColor__c;
                    }
                 // alert(newColor+' old color: '+oldColor);
                   console.log(i+'-->'+newColor+' old color: '+oldColor);
                   
                    if(newColor!='' && oldColor!='' && newColor!=oldColor){
                       // alert('is changed');
                        component.set('v.isChanged', true);
                        component.set('v.SaveBtnClass','floateSaveBtn' );
                        console.log(" new IsChanged Value:"+component.get('v.isChanged'));
                        break;
                    }else{
                        component.set('v.isChanged', false);
                        component.set('v.SaveBtnClass','HideSaveBtn' );
                    }
                }
                
            }
        }
    },
    
    toggleSaveBtn: function(component){
         
        var saveButton = component.find("SaveBtn");
        var isChanged=component.get('v.isChanged');
        
        if(isChanged){
         // $A.util.addClass(button.getElement(), 'floateSaveBtn');
           $A.util.toggleClass(saveButton,'floateSaveBtn');
        }else{
          //  alert('hide button');
           $A.util.toggleClass(saveButton, 'HideSaveBtn');
        }       
    },
     
    // SFDC-9356 - BEGIN //
    createCSSTask : function (component, event, helper) {        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({ 
            "entityApiName": "Task",
            "defaultFieldValues": {                
                'Status':'In Progress',
                'WhatId':component.get('v.recordId')
            },           
            "recordTypeId": component.get('v.CSSTaskRecordId')
        });
        createRecordEvent.fire();
    },
    // SFDC-9356 - END //
     
    // SFDC-9356 - BEGIN //
    genericShowToast : function(title,mode,message,type){
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "message": message,
                    "mode": mode,
                    "type":type
                });
                toastEvent.fire();        
    },
    // SFDC-9356 - END   // 
    
    //Ranjit G- 9626 - Begin
    genericShowToastPester : function(title,mode,message,type,duration){
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "message": message,
                    "mode": mode,
                    "type":type,
                    "duration":duration
                });
                toastEvent.fire();        
    },
   //Ranjit G- 9626 - end
   
    //SFDC-9234
   Create_Prospect: function(component,event, helper){
      
         var createRecordEvent = $A.get('e.force:createRecord');
         var grpAccount=component.get('v.CancelledGrpAcccount');
    
       if ( createRecordEvent && grpAccount!=null ) {
           
            createRecordEvent.setParams({
                'entityApiName': 'Account',
                'defaultFieldValues': {
                    'Type' : 'Prospect',
                   // 'Rating' : 'Hot',
                    'Status__c':'',
                    'Name':grpAccount.Name,
                    'ParentId':grpAccount.ParentId,
                    'OwnerId':grpAccount.OwnerId,
                    'HCSC_Division__c':grpAccount.HCSC_Division__c,
                    'Primary_Producer_Account__c':grpAccount.Primary_Producer_Account__c,
                   'HCSC_as_Fiduciary__c':grpAccount.HCSC_as_Fiduciary__c,
                    'Duration_of_client_in_Prospect_State__c':grpAccount.Duration_of_client_in_Prospect_State__c,
                    'AccountSource':grpAccount.AccountSource,
                    'Sales_Team__c':grpAccount.Sales_Team__c,
                    'RFP_Cycle__c':grpAccount.RFP_Cycle__c,
                   'HCSC_Client_Since__c':grpAccount.HCSC_Client_Since__c,
                   'Enterprise_National_Account__c':grpAccount.Enterprise_National_Account__c,
                   'Ownership':grpAccount.Ownership,
                   'Phone':grpAccount.Phone,
                    'Fax':grpAccount.Fax,
                   'Website':grpAccount.Website,
                    'LinkedIn__c':grpAccount.LinkedIn__c,
                    'DandbCompanyId':grpAccount.DandbCompanyId,
                    'Description':grpAccount.Description,
                    'Industry':grpAccount.Industry,
                    'Sic':grpAccount.Sic,
                  'SicDesc':grpAccount.SicDesc,
                  'DunsNumber':grpAccount.DunsNumber,
                    'YearStarted':grpAccount.YearStarted,
                   'NaicsCode':grpAccount.NaicsCode,
                'NaicsDesc':grpAccount.NaicsDesc,
                'EIN__c':grpAccount.EIN__c,
                'TickerSymbol':grpAccount.TickerSymbol,
                'AnnualRevenue':grpAccount.AnnualRevenue,
                'Net_Income__c':grpAccount.Net_Income__c,
                'Market_Capitalization__c':grpAccount.Market_Capitalization__c,
               'Credit_Rating__c':grpAccount.Credit_Rating__c,
                'Company_Financial_Health__c':grpAccount.Company_Financial_Health__c,
                'Most_Recent_Financial_Position__c':grpAccount.Most_Recent_Financial_Position__c,
                'Recent_Mergers_Acquisitions_Divestures__c':grpAccount.Recent_Mergers_Acquisitions_Divestures__c,
                'Total_Num_of_Potential_Subscribers__c':grpAccount.Total_Num_of_Potential_Subscribers__c,
                'Eligible_Members_O65__c':grpAccount.Eligible_Members_O65__c,
                'Group_Total_Eligible_Members__c':grpAccount.Group_Total_Eligible_Members__c,
                'NumberOfEmployees':grpAccount.NumberOfEmployees,
                'of_retiree_members__c':grpAccount.of_retiree_members__c,
               'Billing_County__c':grpAccount.Billing_County__c,
                'BillingStreet':grpAccount.BillingStreet,
                'BillingState':grpAccount.BillingState,
                'BillingCity':grpAccount.BillingCity,
                'BillingPostalCode':grpAccount.BillingPostalCode,
                'BillingCountry':grpAccount.BillingCountry,
                'ShippingCountry':grpAccount.ShippingCountry,
                'ShippingState':grpAccount.ShippingState,
                'ShippingCity':grpAccount.ShippingCity,
                'ShippingPostalCode':grpAccount.ShippingPostalCode,
                'ShippingStreet':grpAccount.ShippingStreet,
               'Key_Locations__c':grpAccount.Key_Locations__c,
                'Market_Segment__c':grpAccount.Market_Segment__c,
                'Region__c':grpAccount.Region__c,
                'District__c':grpAccount.District__c,
                'Cluster__c':grpAccount.Cluster__c,
                'FSU_Location__c':grpAccount.FSU_Location__c,
                'Underwriter__c':grpAccount.Underwriter__c,
                'Ceded_From_ICL__c':grpAccount.Ceded_From_ICL__c,
                'Ceded_To_ACL__c':grpAccount.Ceded_To_ACL__c,
                'Ceded__c':grpAccount.Ceded__c,
                'Coalition__c':grpAccount.Coalition__c,
                'Cooperative__c':grpAccount.Cooperative__c,
                'Funding_Type__c':grpAccount.Funding_Type__c,
                'Critical_Account__c':grpAccount.Critical_Account__c,
                'Premium_Type__c':grpAccount.Premium_Type__c,
                'Labor_fund_ID__c':grpAccount.Labor_fund_ID__c,
                'Grandfathered_Date__c':grpAccount.Grandfathered_Date__c,
                'Grandfathered_Account__c':grpAccount.Grandfathered_Account__c
                    
                },
                 "recordTypeId": component.get('v.prospectRecordId')
            });
            createRecordEvent.fire();
        } else {
            /* Create Record Event is not supported */
            alert("Account creation not supported, Please Contact System Administrator.");
        }
    }//SFDC-9234   
})