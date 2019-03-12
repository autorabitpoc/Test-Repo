/***********************************************************************************************************
 * This component is to display hover popup content base on the recordId
 *
 *  Developer        Date         Version       Description
 *  Mei Chen         5/20/2018     initial      display product info as hover on the Account Product table
 * ***********************************************************************************************************/
({
	doInit : function(component, event, helper) {
	   var recId=component.get('v.RecId'); //can be oppProd Id or Account Prod Id
       var objectName=component.get('v.sObjectName');
       var p2Id=component.get('v.prod2Id');
       var simpleProd=component.get('v.simpleAccountProduct');
        if(simpleProd!=null){
            console.log('simple prod: '+simpleProd.Product2__c);
        }else{
            console.log('simple prod is null:'+simpleProd);
        }
        console.log('recId:'+recId+ 'object name::'+objectName);
        
        var simpleOPProd=component.get('v.simpleOppoProduct');
         if(simpleOPProd!=null){
            console.log('simple opp prod: '+simpleOPProd.Product__c);
        }else{
            console.log('simple  opp prod is null:');
        }
        /*
         helper.callServer(component, "c.getAccoutOppProdData", 
                          function (response){
                               
                              if(response!=null){
                                  component.set("v.accProdObj", response);
                                  component.set("v.prod2Id",response.Product2__c);
                                  p2Id=response.Product2__c;
                                  console.log('account prod2:::'+response.Name+'---->'+p2Id);
                                
                                  helper.callServer(component, "c.getProductData",
                                   function(data){
                                        if(data!=null){
                                           console.log('p2 id-->  '+data.id);
                                           component.set('v.productObj',data);
                                       }
                                   },{recordId:p2Id}
                              
                                    );
                              }
               
                           },{ recordId:recId, objectName:objectName }
                     );

        */
        
        console.log(' object name:'+objectName);
      if(objectName=='Account_Products__c'){
        
      /*  helper.callServer(component, "c.getAccountProductData", 
                          
                          function (response){
                               
                              if(response!=null){
                                  component.set("v.accProdObj", response);
                                //  component.set("v.prod2Id",response.Product2__c);
                                //  p2Id=response.Product2__c;
                                //  console.log('account prod2:::'+response.Name+'-p2Id inside--->'+p2Id);
                                /*
                                  helper.callServer(component, "c.getProductData",
                                   function(data){
                                        if(data!=null){
                                           console.log('p2 id-->  '+data.id);
                                           component.set('v.productObj',data);
                                       }
                                   },{recordId:p2Id}
                         
                                    );
                              }
               
                           },{ recordId:recId }
                     );
          console.log('p2Id:::::after loop:'+p2Id); */
        }
      /*  helper.callServer(component, "c.getProductData",
                                   function(data){
                                        if(data!=null){
                                           console.log('p2 id-->  '+data.id);
                                           component.set('v.productObj',data);
                                       }
                                   },{recordId:p2Id}
                         
                                    );
        console.log('p2Id:::::after loop:'+p2Id);   */     
     },
    loadPopover: function(component, event, helper){//test
        
       var recId=component.get('v.recordId'); //can be oppProd Id or Account Prod Id
       var objectName=component.get('v.sObjectName');
       var p2Id=component.get('v.prod2Id');  
         var simpleProd=component.get('v.simpleAccountProduct');
        if(simpleProd!=null){
            console.log('simple prod: '+simpleProd.Product2__c);
        }else{
            console.log('simple prod is null:'+simpleProd);
        }
        console.log('recId:'+recId+ 'object name::'+objectName);
    },
   /* closePopover: function(component, event, helper){
        component.set("v.displayPopup", false);
       
       helper.removePopover(component); //fire event to remove popup component from parent comp
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();

        //component.find("overlayLib").notifyClose();
      //  helper.closePopover(component);
    }*/
})