// Ranjit Gandhi       03/27/2018    SFDC-8771 Group Account - Renewal Opportunity Button
// Kishore Nallamothu  05/14/2018 Added code to check if Effective Date is nill or not.
({ 
    doInit: function(component, event, helper) {
        var action = component.get("c.getAccDetails");
        var accountId = component.get("v.recordId");
        var recordTypeid = component.get("v.recordTypeid"); 
        action.setParams({
            "accountId": accountId,
            "recordTypeid":recordTypeid,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('test inside success '+state);
                var createRecordEvent = $A.get("e.force:createRecord");
                var marketSegment = response.getReturnValue().Market_Segment__c;
                var district = response.getReturnValue().District__c;
                var division = response.getReturnValue().HCSC_Division__c;
                var clusters =  response.getReturnValue().Clusters__c;
                console.log('marketSegment'+marketSegment);console.log('district'+district);
                console.log('clusters'+clusters);
                var fsuLocation = response.getReturnValue().FSU_Location__c;
                var region = response.getReturnValue().Region__c;
                var hcmProgramModel =  response.getReturnValue().HCM_Program_Model__c;
                var wellnessConsulting = response.getReturnValue().Wellness_Consulting__c;
                var bccProgram = response.getReturnValue().BCC_Program_s__c;
                var wellnessConsultingCoordinator =  response.getReturnValue().Wellness_Consulting_Coordinator__c;
                var hcmClientIntensity = response.getReturnValue().HCM_Client_Intensity__c;
                var otherHcmInfo =  response.getReturnValue().Other_HCM_Information__c;
                var activehealthMembers =  response.getReturnValue().Active_Health_Members__c;
                var activehealthSubscribers = response.getReturnValue().Active_Health_Subscribers__c;
                var activeDentalMembers= response.getReturnValue().Active_Dental_Members__c;
                var acticvDentalsubscribers =  response.getReturnValue().Active_Dental_Subscribers__c;
                var EffectiveDate =  response.getReturnValue().Renewal_Date__c; 
                var ContractEffectiveDate;
                if(EffectiveDate){
                    var EffDate1=new Date(EffectiveDate); 
                    EffDate1=new Date( EffDate1.getTime() - EffDate1.getTimezoneOffset() * -60000 );
                    var yyyy = EffDate1.getFullYear()+1; 
                    var dd = EffDate1.getDate();
                    var mm = EffDate1.getMonth()+1; 
                    ContractEffectiveDate = yyyy+'-'+mm+'-'+dd;                     
                }
                console.log('EffDate1'+EffDate1);
                console.log('ContractEffectiveDate'+ContractEffectiveDate);
                createRecordEvent.setParams({
                    "entityApiName": 'Opportunity',
                    "recordTypeId": recordTypeid,
                    "defaultFieldValues": {
                        'AccountId' : accountId,
                        'HCSC_Division__c' : division,
                        'Account_Market_Segment__c' : marketSegment,
                        'District__c' : district,
                        'Clusters__c' : clusters,
                        'FSU_Location__c' : fsuLocation,
                        'Region__c' : region,
                        'HCM_Program_Model__c': hcmProgramModel,
                        'Wellness_Consulting__c': wellnessConsulting,
                        'BCC_Program_s__c': bccProgram,
                        'Wellness_Consulting_Coordinator__c': wellnessConsultingCoordinator,
                        'HCM_Client_Intensity__c' : hcmClientIntensity,
                        'Other_HCM_Information__c' : otherHcmInfo,
                        'Expected_Health_Members__c' : activehealthMembers,
                        'Expected_Health_Contracts__c' : activehealthSubscribers,
                        'Expected_Dental_Members__c' : activeDentalMembers,
                        'Expected_Dental_Contracts__c' : acticvDentalsubscribers,
                        'Requested_Effective_Date__c' : EffectiveDate,
                        'Rate_End_Date__c' : ContractEffectiveDate,
                    }
                });
                createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            } else if (state == "INCOMPLETE") {
                console.log('test inside INCOMPLETE '+state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
            } else if (state == "ERROR") {
                console.log('test inside error '+state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    cancel : function(component, event,helper)
    {  
        $A.get("e.force:closeQuickAction").fire();
    },
})