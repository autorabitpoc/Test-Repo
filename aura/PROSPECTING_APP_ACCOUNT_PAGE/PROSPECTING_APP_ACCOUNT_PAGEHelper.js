({
    initAccount : function(component, helper) {
        var curAccount = component.get("v.currentAccount");
        component.set("v.currentAccountComplete", curAccount);
        
        if(curAccount.Id) {
            helper.toggleShowButton(component);
            helper.toggleShowList(component);
        }
    },
    
    toggleShowButton : function(component) {
        var show = component.get("v.showButton");
        component.set("v.showButton", !show);
    },
    
    toggleShowList : function(component) {
        var show = component.get("v.showList");
        component.set("v.showList", !show);
    },
    
    createContactsList : function(component) {
        var contacts = (component.get('v.currentAccountComplete').Contacts ? 
                        component.get('v.currentAccountComplete').Contacts : 
                        component.get('v.emptyAccountContacts'));
        
        $A.createComponent(
            "c:PROSPECTING_APP_CONTACT_LIST",
            {
                "curAccount" : component.get("v.currentAccountComplete"),
                "accountContacts" : contacts
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("contactsList");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        alert("Error: " + errorMsg);
                    }
            }
        );
    },
    
    createCompetitorsAndVendorsList : function(component) {
        var accountCompetitorsAndVendors = (component.get('v.currentAccountComplete').Competitor_Relationships1__r ? 
                                            component.get('v.currentAccountComplete').Competitor_Relationships1__r : 
                                            component.get('v.emptyAccountCompetitorsAndVendors'));
        
        $A.createComponent(
            "c:PROSPECTING_APP_COMP_VEND_LIST",
            {
                "curAccount" : component.get("v.currentAccountComplete"),
                "accountCompetitorsAndVendors" : accountCompetitorsAndVendors
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("competitorsAndThirdPartyVendorsList");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        alert("Error: " + errorMsg);
                    }
            }
        );
    },
    
    createGroupProducersList : function(component) {
        var accountProducers = (component.get('v.currentAccountComplete').Group_Associated__r ? 
                                component.get('v.currentAccountComplete').Group_Associated__r : 
                                component.get('v.emptyAccountProducers'));
        
        $A.createComponent(
            "c:PROSPECTING_APP_PRODUCERS_LIST",
            {
                "curAccount" : component.get("v.currentAccountComplete"),
                "accountProducers" : accountProducers
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("producersAssociatedToGroupList");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        alert("Error: " + errorMsg);
                    }
            }
        );
    },
    
    createActivitiesList : function(component) {
        var notes = (component.get('v.currentAccountComplete').Notes ? 
                     component.get('v.currentAccountComplete').Notes : 
                     component.get('v.emptyNotes'));
        
        var tasks = (component.get('v.currentAccountComplete').Tasks ? 
                     component.get('v.currentAccountComplete').Tasks : 
                     component.get('v.emptyTasks'));
        
        $A.createComponent(
            "c:PROSPECTING_APP_ACTIVITIES_LIST",
            {
                "curAccount" : component.get("v.currentAccountComplete"),
                "notes" : notes,
                "tasks" : tasks
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("notesAndActivitiesList");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        alert("Error: " + errorMsg);
                    }
            }
        );
    },
    
    createAttachmentsList : function(component) {
        var accountAttachments = (component.get('v.currentAccountComplete').Attachments ? 
                                  component.get('v.currentAccountComplete').Attachments : 
                                  component.get('v.emptyAttachments'));
        
        $A.createComponent(
            "c:PROSPECTING_APP_ATTACHMENTS_LIST",
            {
                "curAccount" : component.get("v.currentAccountComplete"),
                "accountAttachments" : accountAttachments
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("attachmentsList");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        alert("Error: " + errorMsg);
                    }
            }
        );
    },
    
    openAddNewNoteOrTaskModal : function(component) {
        var spinner = component.find("accountSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        $A.createComponent(
            "c:PROSPECTING_APP_NEW_NOTES_TASKS_MODAL",
            {
                "curAccount" : component.get("v.currentAccountComplete")
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("newNoteTaskModal");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        alert("Error: " + errorMsg);
                    }
                
                $A.util.toggleClass(spinner, "slds-hide");
            }
        );
    },
    
    setupPicklistValue : function(component, objectApi_name, field_name, compId) {
        var action = component.get("c.getPicklistValues");
        
        action.setParams({ 
            ObjectApi_name : objectApi_name,
            Field_name : field_name
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var opts = response.getReturnValue();
                
                var defaultValue;
                if(component.get("v.currentAccountComplete")[field_name]){
                    defaultValue = component.get("v.currentAccountComplete")[field_name].toString();
                } else {
                        defaultValue = opts[0];
                    }
                var cmp = component.find(compId);
                cmp.set("v.body", []); // clear all options
                var body = cmp.get("v.body");
                
                for(var i=0; i<opts.length; i++) {
                    if(opts[i] === defaultValue) {
                        $A.createComponent(
                            "aura:html",
                            {
                                tag: "option",
                                HTMLAttributes: {
                                    value: opts[i],
                                    text: opts[i],
                                    selected: "selected"
                                }
                            },
                            
                            function (newOption) {
                                //Add options to the body
                                if (component.isValid()) {
                                    body.push(newOption);
                                    cmp.set("v.body", body);
                                }
                            })
                    }
                    else {
                        $A.createComponent(
                            "aura:html",
                            {
                                tag: "option",
                                HTMLAttributes: {
                                    value: opts[i],
                                    text: opts[i]
                                }
                            },
                            
                            function (newOption) {
                                //Add options to the body
                                if (component.isValid()) {
                                    body.push(newOption);
                                    cmp.set("v.body", body);
                                }
                            })
                    }
                }
                
                cmp.set("v.value", defaultValue);
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Picklist not initialized properly.\n Please close modal and try again.");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                        }
                        else if (errors[0] && errors[0].pageErrors) {
                            alert("Error message: " + errors[0].pageErrors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
    openLandingPageHelper : function(component) {
        var compEvent = component.getEvent("openLandingPage");
        compEvent.fire();
        
        component.destroy();
    },
    
    saveRecord : function(component, helper){
        var spinner = component.find("accountSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var action = component.get("c.upsertRecord");
        
        action.setParams({ 
            acc : component.get("v.currentAccountComplete") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(!component.get("v.showList")) {
                    component.set("v.showList", true);
                    
                    helper.createContactsList(component);	
                    helper.createCompetitorsAndVendorsList(component);
                    helper.createGroupProducersList(component);
                    helper.createActivitiesList(component);
                    helper.createAttachmentsList(component);   
                    
                    component.set("v.currentAccount", response.getReturnValue());
                    var curAccount = component.get("v.currentAccount");
                    component.set("v.currentAccountComplete", curAccount);
                }
                
                if(!component.get("v.showButton")) {
                    component.set("v.showButton", true);
                }
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Process did not finish.\n Please try again.");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                        }
                        else if (errors[0] && errors[0].pageErrors) {
                            if(errors[0].pageErrors[0])
                                alert("Error message: " + errors[0].pageErrors[0].message);
                            else
                                alert("Error message: You do not have permission to update the Account Name");
                            //Else condition exists because pageErrors does not seem to contain any message
                            //even though a pageError is actually being returned. Another Salesforce shortcoming perhaps?
                            //This might change in the future
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            
            $A.util.toggleClass(spinner, "slds-hide");
        });
        
        $A.enqueueAction(action);
    },
    
    // SFDC-4752 - 07/2017 - Shuyler - Begin //
    setUpStatePicklist : function(component, compId){
        
        var defaultValue;
        
        var cmp = component.find(compId);
        cmp.set("v.body", []); // clear all options
        var body = cmp.get("v.body");
        
        //JSON for all US States with Abbreviations //
        var theStates = '{"states":[' +
            '{"name":"--None--","abbreviation":""},' +     
            '{"name":"Alabama","abbreviation":"AL"},' +     
            '{"name":"Alaska", "abbreviation":"AK"},' +
            '{"name":"Arizona","abbreviation":"AZ"},' +
            '{"name":"Arkansas","abbreviation":"AR"},' +
            '{"name":"California","abbreviation":"CA"},' +    
            '{"name":"Colorado","abbreviation":"CO"},' +
            '{"name":"Connecticut","abbreviation":"CT"},' +
            '{"name":"Delaware","abbreviation":"DE"},' +   
            '{"name":"Florida","abbreviation":"FL"},' +
            '{"name":"Georgia","abbreviation":"GA"},' +   
            '{"name":"Hawaii","abbreviation":"HI"},' +
            '{"name":"Idaho","abbreviation":"ID"},' +
            '{"name":"Illinois","abbreviation":"IL"},' +
            '{"name":"Indiana","abbreviation":"IN"},' +
            '{"name":"Iowa","abbreviation":"IA"},' +
            '{"name":"Kansas","abbreviation":"KS"},' +
            '{"name":"Kentucky","abbreviation":"KY"},' +
            '{"name":"Louisiana","abbreviation":"LA"},' +
            '{"name":"Maine","abbreviation":"ME"},' +	    
            '{"name":"Maryland","abbreviation":"MD"},' +
            '{"name":"Massachusetts","abbreviation":"MA"},' +
            '{"name":"Michigan","abbreviation":"MI"},' +
            '{"name":"Minnesota","abbreviation":"MN"},' +
            '{"name":"Mississippi","abbreviation":"MS"},' +
            '{"name":"Missouri","abbreviation":"MO"},' +
            '{"name":"Montana","abbreviation":"MT"},' +
            '{"name":"Nebraska","abbreviation":"NE"},' +
            '{"name":"Nevada","abbreviation":"NV"},' +
            '{"name":"New Hampshire","abbreviation":"NH"},' +
            '{"name":"New Jersey","abbreviation":"NJ"},' +
            '{"name":"New Mexico","abbreviation":"NM"},' +
            '{"name":"New York","abbreviation":"NY"},' +   
            '{"name":"North Carolina","abbreviation":"NC"},' +
            '{"name":"North Dakota","abbreviation":"ND"},' +
            '{"name":"Ohio","abbreviation":"OH"},' +
            '{"name":"Oklahoma","abbreviation":"OK"},' +
            '{"name":"Oregon","abbreviation":"OR"},' +
            '{"name":"Pennsylvania","abbreviation":"PA"},' +
            '{"name":"Rhode Island","abbreviation":"RI"},' +
            '{"name":"South Carolina","abbreviation":"SC"},' +
            '{"name":"South Dakota","abbreviation":"SD"},' +
            '{"name":"Tennessee","abbreviation":"TN"},' +
            '{"name":"Texas","abbreviation":"TX"},' +
            '{"name":"Utah","abbreviation":"UT"},' +
            '{"name":"Vermont","abbreviation":"VT"},' +
            '{"name":"Virginia","abbreviation":"VA"},' +
            '{"name":"Washington","abbreviation":"WA"},' +
            '{"name":"West Virginia","abbreviation":"WV"},' +
            '{"name":"Wisconsin","abbreviation":"WI"},' +
            '{"name":"Wyoming","abbreviation":"WY"}]}'; 
        
        parsedTheStates = JSON.parse(theStates);
        
        //look thru the JSON to add each picklist value to the page //
        for(var i = 0; i < parsedTheStates.states.length; i++) {            
            $A.createComponent(
                "aura:html",
                {
                    tag: "option",
                    HTMLAttributes: {
                        value: parsedTheStates.states[i].abbreviation,
                        text: parsedTheStates.states[i].name
                    }	
                },                
                function (newOption) {
                    //Add options to the body
                    if (component.isValid()) {
                        body.push(newOption);
                        cmp.set("v.body", body);
                    }
                })
        }    
    }
    // SFDC-4752 - 07/2017 - Shuyler - End  //
    
})