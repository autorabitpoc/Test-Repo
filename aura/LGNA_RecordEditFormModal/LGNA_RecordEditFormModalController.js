({
	doInit : function(component, event, helper) {
		console.log('record edit form modal');
        var prod=component.get("v.ProdData");
        
        console.log('p21 id:'+component.get("v.prod2Id"));
        
       // console.log('from editmodal produc2 product type:'+prod.Product_Type__c);
	},
      handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        console.log('on load...');
    },
    onSubmit: function(cmp,event,helper){
         var obj=cmp.get("v.OppProdData");
       //  var carrierValue=cmp.find('carrierField').get('v.value');
         var winnier=cmp.get("v.WinninCarrier");
         var initialCarrier=obj.Account__c;
         var isInitial=cmp.get("v.isInitial");
         var validation=true;
         var prodData=cmp.get("v.ProdData");
                
      //  alert('current::'+carrierValue+'winnier::'+winnier);
      
      if(obj!=null && (obj.Status__c==='Lost'|| obj.Status__c==='Won')){//validate if nOte is null when status is lost
          console.log('object status----'+obj.Status__c+' Winning Carrier::'+obj.Account__c+'  3rd Vendor::: '+obj.Winning_Carrier_Vendor__c);
          console.log('funding type:::'+obj.Funding_Type__c);
       //  var fType=obj.Funding_Type__c;
            
          
          if(prodData.Product_Type__c=='Non-Medical' && obj.Funding_Type__c!=null && (obj.Funding_Type__c==='ASO' || obj.Funding_Type__c==='ACAP')) {
               
              var carveValue=cmp.find('carveField').get('v.value');
               console.log("carveLvalue:::::::"+carveValue);
              
                if(carveValue=== null ||carveValue==="" || carveValue==="--None--"){
                 //  alert('carveValue getyou:->'+carveValue+'<--');
                    $A.util.addClass(cmp.find('carveField'),'slds-has-error');
                    $A.util.removeClass(cmp.find('carveErrorMessage'),'slds-hide');
                     validation=false;
                }else{
                  
                  if(!$A.util.hasClass(cmp.find('carveErrorMessage'),'slds-hide')){
                     $A.util.addClass(cmp.find('carveErrorMessage'),'slds-hide');
                  }
                    
               }
                
          }
            
          console.log("here before lost....");
          
          if(obj.Status__c==='Lost'){
            //  alert('carrierValue='+carrierValue+'iniitalCarrier='+initialCarrier+' is initial:'+isInitial);
            
              var noteValue=cmp.find('noteField').get('v.value');
               console.log('note value::'+noteValue);
              
             var carrierValue=null;
              if(cmp.get("v.isInitial")){//default
                  carrierValue=cmp.find('carrierField1').get('v.value');
              }else{
                  carrierValue=cmp.find('carrierField').get('v.value');
               }
              
             // alert("carrierValue:::"+carrierValue+" winninCarrier::"+cmp.get("v.WinninCarrier")+"  initial:"+obj.Account__r.Name);//v.OppProdData.Account__r.Name
              console.log("carrier value:::"+carrierValue);
            
              if(carrierValue==null || carrierValue=="" || carrierValue=="undefined"){
                    //(carrierValue==null && initialCarrier==null && isInitial) ||(initialCarrier==carrierValue && winnier==null && !isInitial)) {
                   console.log("carrierValue is empty???"+carrierValue);
                   $A.util.addClass(cmp.find('carrierFieldDiv'),'slds-has-error');
                    $A.util.removeClass(cmp.find('cfErrorMessage'),'slds-hide');
                    validation=false;
               }else{
                   if(noteValue=== null || noteValue===""){
                  		$A.util.addClass(cmp.find('noteField'),'slds-has-error');
                    	$A.util.removeClass(cmp.find('errorMessage'),'slds-hide');
                    	validation=false;
                   
               		}else{
                    	if($A.util.hasClass(cmp.find('noteField'),'slds-has-error')){
                    		$A.util.removeClass(cmp.find('noteField'),'slds-has-error');
                 	 	}
                  
                 		if(!$A.util.hasClass(cmp.find('errorMessage'),'slds-hide')){
                    		$A.util.addClass(cmp.find('errorMessage'),'slds-hide');
                    	}
                   }
                   if($A.util.hasClass(cmp.find('carrierFieldDiv'),'slds-has-error')){
                   		$A.util.removeClass(cmp.find('carrierFieldDiv'),'slds-has-error');
                   }  
                   if(!$A.util.hasClass(cmp.find('cfErrorMessage'),'slds-hide')){
                      	 $A.util.addClass(cmp.find('cfErrorMessage'),'slds-hide');
                   }
               }
  
           }      //end of lost
           
          
         console.log("validation:::"+validation);
          
         if(validation){
             cmp.find("editForm").submit();
             cmp.set('v.showSpinner', true);
         }else{
             Alert("Error! there is an issue to perform your request. please cancel and try again later");
              cmp.set('v.showSpinner', false);
              cmp.set("v.editMode",false);             
             return false;
         }
            
        }else{
            
          console.log("on submit");
          cmp.find("editForm").submit();
          cmp.set('v.showSpinner', true);
         // cmp.set("v.editMode",false);
                     
        }
    },
    
   // onContinue :function(){
     //   cmp.set('v.currentTablMap', newOne):
    //},
    handleSubmit: function(cmp, event, helper) {
       // var obj=cmp.get("v.OppProdData");
   
        cmp.set('v.showSpinner', true);
       
        console.log("on submit");
        //save record to table
    },

    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
        
        console.log("on error");
    },

    handleSuccess: function(cmp, event, helper) {//after submitted successfully
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
        console.log("on success");
         cmp.set("v.editMode",false);
         var payload = event.getParams().response;
        console.log(JSON.stringify(payload));
    },
    CancelEdit : function (cmp, event, helper){
        cmp.set("v.editMode",false);
    }
})