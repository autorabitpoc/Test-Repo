({
    doInit : function(component, event, helper) {
 
         var objectType = component.get("v.sObjectName");
        var recId = component.get("v.recordId");
        
        var RecordtypeAction= component.get("c.getAccRecordId");  
         RecordtypeAction.setParams({            
            recordId:recId
        });
        RecordtypeAction.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var g=response.getReturnValue();
              
                
                if(g=='Group Account'){
                    var objectType = component.get("v.sObjectName");
                    var action = component.get("c.loadInitialAccountProducts");
                    var recId = component.get("v.recordId");
                    component.set("v.groupRec",g);
                    //alert(g);
                    console.log("recId"+recId);
                    action.setParams({
                        objectType:objectType,
                        recordId:recId
                    });
                    action.setCallback(this,function(response){
                        var status = response.getState();
                        if(status === "SUCCESS"){
                            var productmap=[];
                               var accproducts=response.getReturnValue();             
                            for ( var key in accproducts ) {
                                productmap.push({value:accproducts[key], key:key});
                            }
                            component.set("v.AccountActiveProductsMap",productmap);
                            console.log("productmap"+productmap);
                        }
                    });
                    $A.enqueueAction(action);
                    	
                }
                else
                {
                    component.set("v.prospectRec",g);
                    //alert(g);
                }
                
                 /*Account Historical Records*/
        var actionHistorical = component.get("c.loadHistoricalAccountProducts");
        var recId = component.get("v.recordId");
        console.log("recId"+recId);
        actionHistorical.setParams({
            objectType:objectType,
            recordId:recId 
        });      
        
        actionHistorical.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var productmap=[];
				   var accproducts=response.getReturnValue();             
                for ( var key in accproducts ) {
                    productmap.push({value:accproducts[key], key:key});
                }
                component.set("v.AccountHistoricalProductsMap",productmap);              
                console.log("productmap"+productmap);
                
                /*Opportunity Historical Records*/    
        
                var actionOppHistorical = component.get("c.loadHistoricalOpportunityProducts");
                var recId = component.get("v.recordId");
                console.log("recId"+recId);
                actionOppHistorical.setParams({
                    objectType:objectType,
                    recordId:recId
                });
                
                 actionOppHistorical.setCallback(this,function(response){
                    var status = response.getState();
                    if(status === "SUCCESS"){
                        var productmap=[];
                           var accproducts=response.getReturnValue();             
                        for ( var key in accproducts ) {
                            productmap.push({value:accproducts[key], key:key});
                        }
                        component.set("v.OpportunityHistoricalProductsMap",productmap);
                        console.log("productmap"+productmap);
                    }
                });
                 $A.enqueueAction(actionOppHistorical);
            }
        });
        $A.enqueueAction(actionHistorical);
        }
            
        });
         $A.enqueueAction(RecordtypeAction);
        
    },
    
      
   handleShowPopover : function(component, event, helper) {
       if(component.get("v.showPopover") !=true){
       var item=event.currentTarget;//event.getSource().get('v.name');
       var prodObjName="Account_Products__c";
       
       console.log('item --->'+item.id+' name:-->>> '+item.name);//div class name
       var itemStr=item.id;
       var items;
       var itemId;
       var itemName;
       var popClassName;
       var prod2Id;
       console.log('items Id + Name str: '+itemStr);
       component.set("v.showPopover",true);
       
       if(itemStr!=null && itemStr.length>0){
           
           items=itemStr.split('+'); 
           console.log('items array after split:'+items);
           if(items.length>1){
            popClassName=items[0];//div class name
            itemId=items[1];//'a3L29000000ogizEAA';//item.dataset.recId;
            
            if(items.length>2){
            	itemName=items[2];//AP-xxxx or OP-xxxx
                
              if(itemName!=null && itemName.startsWith("OP")){
               	 prodObjName="Opportunity_Product__c";
             }
              if(items.length>3){
                 prod2Id=items[3];//get the product2 id
             	}
              }
           }
       }
       
        
       console.log('item id: '+itemId+' itemName::'+itemName+' prod2 Id:'+prod2Id+' PopName:'+popClassName);
      
       var hoverContent;
       
       $A.createComponent(
          "c:LightningShowPopover", 
           { 'RecId':itemId,
             'prod2Id':prod2Id,
             'sObjectName':prodObjName,
             'displayPopup':component.get("v.showPopover")  //'Account_Products__c' //component.get("v.sObjectName")
           },
           
          function(content, status){
              console.log('status: '+status);
             // var promise;
              if(status==='SUCCESS')  {
                 hoverContent=content;//component[0];
                 component.find('popOverlayLib').showCustomPopover({
                   body: hoverContent,
                   referenceSelector:"."+popClassName,//".popover2",//".popoverclass",
                     cssClass: "no-pointer,hideDiv"
              }).then(function (overlay) {
                  component.set('v.hoverComponent', overlay);
                //  component.set('v.hoverPromise',overlay);
                     console.log('overlay:::' +overlay);
                    /*setTimeout(function(){ 
                    //close the popover after 3 seconds
                     overlay.close(); 
                   }, 3000);*/
               });
                 // component.set('v.hoverPromise',promise);
              }                  
          }
                            
        );
       }
    },
    
    closePopover : function(component, event, helper){
        var popOverComp =component.get('v.hoverComponent');// component.get('v.hoverPromise');//component.get('v.hoverComponent');
         
        console.log('overlayComponent: '+popOverComp);
        component.set("v.showPopover",false);
        // component.find("popOverlayLib").notifyClose();
        var popover=component.find("popOverlayLib");
     //   $A.util.removeClass(popover,'slds-hide');
        
        if(popOverComp!=null){
            popOverComp.hide();
              //component.get('v.hoverComponent').find("popOverlayLib").notifyClose();
           // component.find("overlayLib").notifyClose();
            console.log('closing????: '+popOverComp);
        
        }
     
        
    },
    
   
})