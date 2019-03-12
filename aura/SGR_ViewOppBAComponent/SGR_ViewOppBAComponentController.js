({
    doInit: function (component, event, helper) {
        //   var action=component.get("c.getratingStatus");
        //  console.log('came into in it');

        // console.log('came into in it with opp value '+component.get("v.opportunity.Rating_Status__c"));
        //      action.setParams({

        //    "oppId": component.get("v.recordId")
        //    });
        // action.setCallback(this, function(response) {
        // console.log('got the response');
        //  var state = response.getState();
        //  console.log('hi');
        // if (state === 'SUCCESS'){
        //  console.log('hi'); 
        //   console.log(state);
        //    var data = response.getReturnValue();
        //    console.log(data);
        //    component.set("v.ratingstatus", data);
        //  } 
        // });    
        // $A.enqueueAction(action);
        // $A.get('e.force:refreshView').fire();
        helper.getLoggedinUsers(component);
        helper.getRelatedBAList(component);
        helper.getRelatedgslist(component);
        //alert(JSON.stringify(component.get("v.userinfo")));

    },
    showSpinner: function (component, event, helper) {
        component.set("v.spinner", "true");
    },
    hideSpinner: function (component, event, helper) {
        component.set("v.spinner", "false");
    },
    updateShowPopup: function (component, event, helper) {
        //component.destroy();
        var showpopup = event.getParam("UpdateShowPopup");
        if (showpopup === true) {
            component.set("v.ShowPopup", false);
        }
    },
    updateBA: function (cmp, evt, helper) {
        //Added by Ravi
        //console.log(evt.getParam('BARecord')); alert('a');
        /*if(evt.getParam("IsItForIncludeBA")){
            helper.updateCensusInfo(cmp, evt.getParam('BARecord'));
        }else{
           // helper.changeCensusData();
           helper.updateCensusInfo(cmp, evt.getParam('BARecord'));
        }*/
        if (evt.getParam("Confirmed")) {
            helper.updateCensusInfo(cmp);
        } else {

        }
    },
    updateRefresh: function (component, event, helper) {
        component.set("v.ShowPopup", false);
        var confirmed = event.getParam("Confirmed");
        if (confirmed === true) {

            console.log("came here");
            var action = component.get("c.initiaterefresh");
            var OppBAList = component.get("v.baList");
            console.log("came here");

            action.setParams({
                //"obfaList":component.get("v.baList"),
                "oppId": component.get("v.recordId")

            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    console.log('Message  retreived successfully');
                    //alert(JSON.stringify(response.getReturnValue()));
                    var initAction = component.get('c.doInit');


                    $A.enqueueAction(initAction);
                    var lightningEvent = $A.get("e.c:RatingStatusRefresh");
                    lightningEvent.setParams({
                        "message": "An application event fired me."
                    });
                    lightningEvent.fire();

                    //$A.get('e.force:refreshView').fire();   
                } else if (state === 'ERROR') {
                    component.set("v.err", true);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            component.set("v.errMsg", errors[0].message);
                        }
                    }
                } else {
                    component.set("v.errMsg", 'Refresh Is not Done.Unknown error has occured!');
                }
            });
            $A.enqueueAction(action);

        }
    },

    handleRefresh: function (component, event, helper) {

        // Start - JIRA # SFDC - 15909 - Verify Logged in user profile name to perform the Refresh action- by Balasubramanyam.Peri(Accenture)

        var loggedInUserProfileName;
        var action = component.get("c.getOppData");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.Opp", response.getReturnValue());
                loggedInUserProfileName = component.get("v.Opp").CurrentUserProfileName__c;
                console.log('LoggedInUserRefresh->' + loggedInUserProfileName);
                if (loggedInUserProfileName === "SGR Operations User" || loggedInUserProfileName === "SGR SAM User" || loggedInUserProfileName === "SGR_Group Verifier") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        message: "Your profile is restricted to Refresh Benefit Agreement!",
                        type: "Error"
                    });
                    toastEvent.fire();
                } else {
                    console.log("Refresh Clicked");
                    component.set("v.ShowPopup", true);
                    component.set("v.buttonName", "Refresh");
                    component.set("v.headerTxt", "Refresh Confirmation");
                }
            }
        });
        $A.enqueueAction(action);
        // End - JIRA # SFDC - 15909 


    },
    // added by Ravi - start
    handleBAInclude: function (component, event) {
        component.set("v.ShowPopup", true);
        component.set("v.buttonName", "BAInclude");
        component.set("v.headerTxt", "Benefit Agreement");

        var position = event.getSource().get("v.id");
        alert("id::" + position);
        //component.set("v.selectedRecordId",BAId);
        component.set("v.selectedRecordId", component.get('v.baList')[position]);
        //console.log(component.get("ba.Id"));
        //Component.set("v.BAId","ba.Id");

        //console.log(component.get("ba[0].Id"));
        //alert(v.baList.Include_BA__c);
        //var OppBAListID = component.get("v.baList");
        //alert(OppBAListID.Include_BA__c);

    },
    handleBAExclude: function (component, event, helper) {
        component.set("v.ShowPopup", true);
        component.set("v.buttonName", "BAExclude");
        component.set("v.headerTxt", "Benefit Agreement");

        var position = event.getSource().get("v.id");
        //component.find('checkbox').get('id');
        console.log(component.get('v.baList')[position]);
        component.set("v.selectedRecordId", component.get('v.baList')[position]);
        // Added by Ravi Teja -- End
    },
    /*handleLinkClick:function(component,event,helper)
    {     
        var position = event.getSource().get("v.id");
        alert('idddd'+newId);
        //var position = event.getSource().get("v.id");
        //alert(event.currentTarget.name);
        //alert(event.currentTarget.value);
        //alert(position+"position");
        //component.set("v.detailRecordId",component.get('v.baList')[position]);
		//window.open("{!'/one/one.app?#/sObject/'+ v.detailRecordId + '/view'}");
		//alert("v.detailRecordId"+v.detailRecordId);
        //window.open("{!'/'+resultWrap.v.detailRecordId}");
        //console.log('Button click for: ' + position);
        
    },*/
    modifyCensusData: function (component, event) {
        var baList = component.get("v.baList");
        console.log(baList + '**');
        var planNumber, lineOfBusiness;

        var BAId = component.get("v.selectedRecordId");

        for (var BAInfo in baList) {
            console.log(baList[BAInfo]);
            if (baList[BAInfo].Id === BAId) {
                planNumber = baList[BAInfo].Marketing_Plan_ID_13__c;
                lineOfBusiness = baList[BAInfo].Line_of_Business__c;
            }
        }
        console.log(planNumber);
        console.log(lineOfBusiness);
        var sendBAData = $A.get("e.c:SGR_ModifyCensusOnIncludeBAEvent");
        sendBAData.setParams({
            "marketingPlanNumber": planNumber,
            "lineOfBusiness": lineOfBusiness,
            "IsItForIncludeBA": true
        });
        sendBAData.fire();
    },
    updateCensusData: function (component, event) {
        var sendBAData = $A.get("e.c:SGR_ModifyCensusOnIncludeBAEvent");
        sendBAData.setParams({
            "IsItForIncludeBA": false
        });
        sendBAData.fire();
    },
    //added by Ravi - end
    defaultCloseAction: function (component, event, helper) {
        //Change added by Ravi--New
        helper.getRelatedBAList(component);
        component.set("v.ShowPopup", false);

    }
})