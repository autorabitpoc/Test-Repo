({
    errorcheck : function(cmp,fieldid,sError) {
        cmp.set('v.'+sError,'true');
        var sFieldValue;
        if(fieldid == 'LCarrierField')
        {
            if(cmp.get('v.WinninCarrier') =='[object Object]'){
                sFieldValue='';
                
            }else{
                sFieldValue = cmp.get('v.WinninCarrier');
            }
        }
        else
        {
            sFieldValue = cmp.find(fieldid).get('v.value');
        }
        if(sFieldValue === null || sFieldValue === ''){
            $A.util.addClass(cmp.find(fieldid),'slds-has-error');
            $A.util.removeClass(cmp.find(sError),'slds-hide')
        }
        else{
            if($A.util.hasClass(cmp.find(fieldid),'slds-has-error')){
                $A.util.removeClass(cmp.find(fieldid),'slds-has-error')
            }
            if(!$A.util.hasClass(cmp.find(sError),'slds-hide')){
                $A.util.addClass(cmp.find(sError),'slds-hide');
            }
            cmp.set('v.'+fieldid+'errorMessage','false');
        }
        
    }
})