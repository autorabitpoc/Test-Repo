({
    doInit : function(component, event, helper) {
    },
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
    onSubmit: function(cmp,event,helper){
        var sCallback='false';
        var sStatus = cmp.get('v.oppProdStatus');
        var sAccount,sNotes,sSplit,sCarve;
        if(cmp.get('v.oppProdStatus')==='Lost'){
            helper.errorcheck(cmp,'LCarrierField','LCarrierFielderrorMessage');
            helper.errorcheck(cmp,'LnoteField','LnoteFielderrorMessage');
            if(cmp.get('v.OppProdData.Category__c')!='Medical' && (cmp.get('v.FundingType') == 'ASO' || cmp.get('v.FundingType') == 'ACAP')){
                helper.errorcheck(cmp,'LCarveOut','LCarveOuterrorMessage');
            }
            if(cmp.get('v.OppProdData.Category__c')=='Medical'){
                helper.errorcheck(cmp,'Lsplit','LspliterrorMessage');   
            }
            if(cmp.get('v.LnoteFielderrorMessage') == 'false' && cmp.get('v.LCarrierFielderrorMessage') == 'false'){
                sCallback='true';
                sAccount = cmp.get('v.WinninCarrier');
                sNotes = cmp.find('LnoteField').get('v.value');
                if(cmp.get('v.OppProdData.Category__c')=='Medical'){
                    if(cmp.get('v.LspliterrorMessage') == 'false'){
                        sSplit = cmp.find('Lsplit').get('v.value');
                    }
                    else{
                        sCallback='false';
                    }
                }
                else{
                    if((cmp.get('v.FundingType') == 'ASO' || cmp.get('v.FundingType') == 'ACAP')){
                        if(cmp.get('v.LCarveOuterrorMessage') == 'false'){
                            sCarve = cmp.find('LCarveOut').get('v.value');
                        }
                        else{
                            sCallback='false';
                        }
                    }
                }
            }
        }
        if(cmp.get('v.oppProdStatus')==='Won'){
            sCallback='true';
            if(cmp.get('v.OppProdData.Category__c')=='Medical'){
                helper.errorcheck(cmp,'Wsplit','WspliterrorMessage');
                if(cmp.get('v.WspliterrorMessage') == 'false'){
                    sSplit = cmp.find('Wsplit').get('v.value');
                }
                else{
                    sCallback='false';
                }
            }
        }
        if(sCallback === 'true'){
            cmp.set('v.showSpinner', true);
            var action = cmp.get("c.SetOpptyProd");
            action.setParams({
                "optyId": cmp.get('v.recordId'),
                "sStatus": sStatus,
                "sAccount": sAccount,
                "sNotes": sNotes,
                "sSplit" : sSplit,
                "sCarve" : sCarve,
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.showSpinner', false);
                    cmp.set('v.saved', true);
                    var compEvent = cmp.getEvent("WonLostModel");
                    compEvent.setParams({
                        "WinLoseOperation":'Save'
                    });
                    compEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    handleSubmit: function(cmp, event, helper) {
         cmp.set('v.showSpinner', true);
     },

    handleError: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
     },

    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    CancelEdit : function (cmp, event, helper){
        var compEvent = cmp.getEvent("WonLostModel");
        compEvent.setParams({
            "WinLoseOperation":'Cancel'
        });
        compEvent.fire();
    }
})