({
    getRelatedBAList: function (component) {
        var action = component.get("c.getOppBAList");

        action.setParams(
            {
                "oppId": component.get("v.recordId"),
                "sortField": component.get("v.baSortBy"),
                "sortOrder": component.get("v.baSortOrder")
            }
        );

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state:' + state);
            if (state === 'SUCCESS') {

                var data = response.getReturnValue();

                if (data.length === 0) {
                    component.set('v.err', "true");
                    component.set("v.errMsg", 'No Benefit Agreement records found for this Opportunity');
                    return;
                }
                console.log(data);
                console.log(data + 'checking the data');
                component.set("v.baList", data);


                console.log('data.length:' + data.length);
            } else if (state === 'ERROR') {
                component.set("v.errFlag", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.err', "true");
                        component.set("v.errMsg", errors[0].message);
                    } else {
                        component.set('v.err', "true");
                        component.set("v.errMsg", 'Benefit Agreements could not be retreived. Unknown server error');
                    }
                }
            } else {
                component.set("v.err", true);
                component.set("v.errMsg", 'Opportunities could not be retreived. Unknow error');
            }
        });
        $A.enqueueAction(action);
    },

    getRelatedgslist: function (component) {
        var action = component.get("c.getOppGSList");

        action.setParams(
            {
                "oppId": component.get("v.recordId"),
                "sortField": component.get("v.baSortBy"),
                "sortOrder": component.get("v.baSortOrder")
            }
        );

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('hi' + state);
            if (state === "SUCCESS") {
                var custs = [];
                var conts = response.getReturnValue();
                for (var key in conts) {
                    custs.push({value: conts[key], key: key});
                }
                if (custs.length === 0) {
                    component.set('v.err1', "true");
                    component.set("v.errMsg1", 'No Group Section found for this benefit agreement');
                    return;
                }
                component.set("v.customers", custs);
            } else if (state === 'ERROR') {
                component.set("v.errFlag", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.err', "true");
                        component.set("v.errMsg", errors[0].message);
                    } else {
                        component.set('v.err', "true");
                        component.set("v.errMsg", 'Group Sections could not be retreived. Unknown server error');
                    }
                }
            } else {
                component.set("v.err", true);
                component.set("v.errMsg", 'Opportunities could not be retreived. Unknow error');
            }
        });
        $A.enqueueAction(action);
    },
    getLoggedinUsers: function (component, event) {
        var action = component.get("c.getloggedinuserinfo");
        action.setCallback(this,
            function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.userinfo", storeResponse);
                    component.set("v.userProfileName", response.getReturnValue().Profile.Name);
                }
            });
        $A.enqueueAction(action);
    },
    updateCensusInfo: function (component) {
        // alert('a');
        var baRecord = component.get('v.selectedRecordId')
        var action = component.get("c.updateBARecord");
        //alert(JSON.stringify(baRecord));
        //console.log(baRecord);
        var baRec = {
            'sObjectType': 'SGR_Opportunity_Benefit_Agreement__c',
            'Id': baRecord.Id[0],
            'Include_BA__c': baRecord.Include_BA__c
        }
        action.setParams({"BARec": baRec});
        action.setCallback(this,
            function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    //window.location.reload();
                }
            });
        $A.enqueueAction(action);
    }
})