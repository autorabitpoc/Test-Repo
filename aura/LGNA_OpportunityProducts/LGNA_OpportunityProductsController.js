({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var pickListmap=[];
        console.log('record id: '+recId);
        component.set("v.hasData",false);
        //KK Add below condition for Opportunity Product Read Write Access 6/25/2018
        if(recId!=null){
            helper.callServer(component,
                              "c.checkOptyAccess", 
                              function(response){
                                  if(response!=null){
                                      if(response == false){
                                          alert("You do not have access to add/edit opportunity products.\n Owner and team members with required permissions can only add/edit opportunity products.");
                                          window.open('/'+recId,'_top');
                                      }
                                      else{
                                          helper.callServer(component,
                                                            "c.getOppProductPickListMappingData", 
                                                            function(response){
                                                                
                                                                if(response!=null){
                                                                    
                                                                    var pickListMappingData=response;     
                                                                    var myOptMap=new Map();//component.get("v.PicklistOptionMap");
                                                                    
                                                                    for ( var key in pickListMappingData ) {//key is record type developername
                                                                        
                                                                        // pickListmap.push({value:pickListMappingData[key], key:key}); 
                                                                        myOptMap.set(key,pickListMappingData[key]);//map<recordtypename, optionString>
                                                                        // console.log(key+'<== key option value from apex;:;;;;;'+myOptMap.get(key).Status__c);
                                                                        // console.log(key+'<== key option value from apex;:;;;;;'+myOptMap.get(key).ForStatus__c);
                                                                        
                                                                    }
                                                                    
                                                                    helper.loadPickListOptions(component,helper, myOptMap);//convert to UI option
                                                                    
                                                                }
                                                                
                                                            }
                                                           );
                                          
                                          helper.callServer(component,
                                                            "c.getCurrentlySelectedOpportunityProducts", 
                                                            function(response){
                                                                var productmap=[];
                                                                //  var oppDataList=[];
                                                                
                                                                // var myMap=new Map();
                                                                
                                                                if(response!=null){
                                                                    var oppproducts=response;
                                                                    
                                                                    for ( var key in oppproducts ) {
                                                                        productmap.push({value:oppproducts[key], key:key});
                                                                        //  console.log(key+"==>"+oppproducts[key]);
                                                                        
                                                                    }
                                                                    if(productmap.length>0){
                                                                        component.set("v.hasData",true);
                                                                    }
                                                                    component.set("v.currentOppProductsMap",productmap); 
                                                                    
                                                                }
                                                                
                                                            },{ 
                                                                recordId:recId 
                                                            }
                                                           );
                                          
                                          helper.callServer(component,
                                                            "c.getPreviouslyQuotedOpportunityProducts", 
                                                            function(response){
                                                                
                                                                
                                                                if(response!=null){
                                                                    
                                                                    var previousProductmap=[];
                                                                    var previousOppproducts=response;             
                                                                    
                                                                    for ( var key in previousOppproducts ) {
                                                                        previousProductmap.push({value:previousOppproducts[key], key:key});
                                                                    }
                                                                    component.set("v.previouslyQuoted",previousProductmap);
                                                                    //	 console.log("previousProductmap"+previousProductmap);
                                                                    if(previousProductmap.length>0){
                                                                        component.set("v.hasData",true);
                                                                    }
                                                                }
                                                                
                                                            },{ 
                                                                recordId:recId 
                                                            }
                                                           );
                                          
                                      }
                                  }
                                  
                              },{ 
                                  OptyId:component.get("v.recordId") 
                              }
                             );
        }
    },
    
    
    cancelUpdate: function(component,event,helper){
        component.refresh();
        
    },
    CloseModal : function(component, event, helper){
        component.set("v.popUpEdit",false);
    },
    
    /**************
     * @author: Mei Chen
     * SFDC-9298 -inovked by clicking on the Save button from UI, save all changes made from UI to database. 
     * There are types of Data to Save: Upate from the existing data. Insert data that doesn't have Id (not yet in db). 
     **************** */
    Save : function (component,event, helper){
        
        var updateList=component.get("v.currentOppProductsMap");
        var opProductListToUpdate =[];
        var opProductListToInsert=[];
        
        console.log("update list size:"+updateList.length); //list of Map
        var opList=[];
        var eachList=[];
        var validation=true;
        for(var key in updateList){
            console.log("key:"+key+ ' size:'+updateList[key].value.length);
            opList=updateList[key].value;
            console.log('opList'+opList.length);
            
            //  opProductListToUpdate.push(opList[i]);
            for(var i=0;i<opList.length;i++){//list of opp prod object
                
                if(opList[i].Product_Type__c=='Product Term'){
                    opList[i].Status__c="Declined"; //need to manully assign to Decline when Product term is selected
                }
                
                var status=opList[i].Status__c;
                console.log(' Status:-->'+status+'<-- type::-->'+opList[i].Product_Type__c+'<---');
                console.log("prject contracted::"+opList[i].Projected_Contracts__c);
                console.log("prject members::"+opList[i].Projected_Members__c);
                console.log(" winn probability:::"+opList[i].Win_Probability__c );
                
                if(opList[i].Funding_Type__c!="PREM"){
                    console.log('funding type is not prem');
                    opList[i].Premium_Type__c=null;
                }
                if( opList[i].Premium_Type__c==='--None--'){
                    opList[i].Premium_Type__c=null;
                }
                
                if(
                    (opList[i].Projected_Contracts__c ==null ||opList[i].Projected_Contracts__c=="" || opList[i].Projected_Contracts__c=='0') ||
                    (opList[i].Projected_Members__c ==null || opList[i].Projected_Members__c=="" ||opList[i].Projected_Members__c=='0') ||
                    (status !=null && status !='Lost' && status !='Won' && status!='Declined' && status!='Migrated' &&
                     (opList[i].Win_Probability__c == null ||opList[i].Win_Probability__c=="" || opList[i].Win_Probability__c=='0')) 
                ){
                    console.log("missing contract member...");
                    component.set("v.errorMandatoryFlag",true);
                    component.set("v.loading",false);
                    validation=false;
                    return false;
                }
                else if(((opList[i].Product_Type__c == 'New Sale') || 
                         (opList[i].Product_Type__c == 'Upsell') ||
                         (opList[i].Product_Type__c == 'Market Check') ||
                         (opList[i].Product_Type__c == 'Upsell – IL')
                        ) && (opList[i].Incumbent__c == null)){
                    
                    component.set("v.errorIncumbentFlag",true);
                    component.set("v.loading",false);
                    validation=false;
                    return false;
                }else if(opList[i].Premium_Type__c ===null && opList[i].Funding_Type__c==="PREM"){                    
                    component.set("v.errorPremTypeFlag",true);
                    component.set("v.loading",false);
                    validation=false;
                    return false;                    
                }else if(
                    //SFDC-10546 - BEGIN
                    (opList[i].Product_Type__c == 'Add-On Loss' && opList[i].Projected_Contracts__c > -1) ||
                    (opList[i].Product_Type__c == 'Add-On Loss' && opList[i].Projected_Members__c > -1)
                ){
                    console.log("Add-On Loss section: " + opList[i].Projected_Contracts__c + ' ' + opList[i].Projected_Members__c);
                    component.set("v.errorAddOnLossFlag",true);
                    //Setting errorMandatoryFlag=False to make Messages less confusing
                    component.set("v.errorMandatoryFlag",false);                    
                    component.set("v.loading",false);
                    validation=false;
                    return false;
                    //SFDC-10546 - END
                }else{
                    component.set("v.loading",true);
                    if(opList[i].Id!=null){
                        opProductListToUpdate.push(opList[i]);
                    }else{
                        opProductListToInsert.push(opList[i]);
                    }
                    component.set("v.errorIncumbentFlag",false);
                    component.set("v.errorPremTypeFlag",false);
                    component.set("v.errorMandatoryFlag",false);
                    //SFDC-10546 - BEGIN
                    component.set("v.errorAddOnLossFlag",false);
                    //SFDC-10546 - END
                }
                
            }
            
            
            
        }
        console.log('final list to udpate: '+opProductListToUpdate.length+' newListszie::'+opProductListToInsert.length);
        
        if((opProductListToUpdate!=null && opProductListToUpdate.length>0) || (opProductListToInsert!=null && opProductListToInsert.length>0) ){
            console.log('ready to update. or insert.');
            
            helper.callServer(component,
                              "c.saveOpportunityProducts",
                              function(response){
                                  component.set("v.loading",false);
                                  var success=response;
                                  console.log(' result:'+response);
                                  
                                  if(response){
                                      console.log('show toast....');
                                      // alert('Saved! Opportunity Product Records have been Saved Successfully!');
                                      component.set("v.loading",false);
                                      
                                      /*  helper.showToast("Saved",
                                                     "The Opportunity Product Records were saved."
                                                   );  */
                                    component.refresh();
                                    
                                }else{
                                    console.log('save failed.something wrong...');
                                    alert('Error! Save Failed. Please Contact System Administrator.');
                                    
                                    
                                    /*    helper.showToast("Error!",
                                                  "Save failed, please contact System Administrator"
                                                  );  
                                   }*/
                                      
                                  }
                                 
                             },
                              {
                                  "updateList":opProductListToUpdate, //finalOpportinityProdList,
                                  "newList":opProductListToInsert
                              }
                              
                             );
            
        }
        
        
    },
    AddProduct : function(component,event,helper){
        console.log("add product.,.,.");
        component.set("v.showModal",true);
        
        /* $A.createComponent(
            "c:LGNA_AddProductsButton",
            {     
               "Opportunityrecord": opprec
            },
            function(msgBox){
                if(component.isValid()){
                    //console.log('register opened');
                    var targetCmp = component.find('editRegisterModal');                    
                    var body = targetCmp.get("v.body");                    
                    body.push(msgBox); 
                    //console.log('register opened2');
                    targetCmp.set("v.body",body);
                    //console.log('register opened3');
                }
                //console.log('register opened4');                                                                                                                              
            }                                                                                                                              
        );*/
   },
    addSelectedProducts :function(component,event,helper){
        //alert('heloo');
        //alert('event Params'+event.getParams());
        //alert('test Params'+event.getParam("opportunityProductMap"));
        //alert('tes'+event.getParams("opportunityProductMap"));
        var childMap =event.getParams("opportunityProductMap");
        //console.log('child map'+JSON.stringify(childMap));
        var curentMap = component.get("v.currentOppProductsMap");
        //alert('Parent'+curentMap);
        console.log('sujatha'+JSON.stringify(childMap));
        
        //var finalOpportunityProductMap = new Map([childMap].concat([curentMap]));
        //alert('=Inside Final=' + finalOpportunityProductMap);
        component.set("v.currentOppProductsMap", childMap);
        //console.log('final map'+JSON.stringify(finalOpportunityProductMap));
        
        //component.set("v.showmodeldata",'true');
        //component.refresh();
        
    },
    
    executeMyMethod : function (component, event, helper) {
        console.log("Inside Execute method.. ");
        var params = event.getParam('arguments');
        console.log('Param 1: '+ params.param1);
        console.log('Param 2: '+ params.param2);
    }, 
    
    
    updateSelectedStatus : function(component, event, helper){
        var et=event.currentTarget;
        var re=event.getSource().get("v.name");
        //var selected= event.getSource().get("v.value");
        var afName = re.split(":");
        var fName = afName[0];
        var fId = afName[1];
        var fFundingType = afName[2];
        var selectedProd2Id = afName[3];
        var selected= event.getSource().get("v.value");
        //KK Added
        if(fName.includes(fName) && (selected=="Won" || selected=="Lost")){
            component.set("v.currentSelectedId", fId);
            component.set("v.FundingType",fFundingType);
            component.set("v.oppProdStatus",selected);
            component.set("v.WinLosePopup ",true);
            component.set("v.currentSelectedP2Id",selectedProd2Id);
        }
        
        console.log("current target:"+et+" source:"+re+"selected value:-->"+selected);
        //  alert('current target:'+et+'  source:'+re+'selected value:'+selected);
        
        
    },
    handleActionSelect : function(component,event,helper){
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        
        var re=event.getSource().get("v.name");
        var item=event.currentTarget;
        var selectedMenuItemValue = event.getParam("value");
        var valuesStr= selectedMenuItemValue.split(":");//event.getParam("name");
        var selectedValue=valuesStr[0];
        var selectedId=valuesStr[1];
        var selectedProd2Id=valuesStr[2];
        
        component.set("v.currentSelectedId", selectedId);
        component.set("v.currentSelectedP2Id",selectedProd2Id);
        
        console.log("Menu item selected with value: -->" +selectedValue+"<<-  id: "+selectedId+' p2Id:'+selectedProd2Id);
        
        if(selectedValue==="Edit"){
            console.log('edit mod pop up');
            component.set("v.popUpEdit",true); 
            
        }else if (selectedValue==="Add"){
            var currentSelectedData=component.get("v.selectedOPData");
            console.log('current Selected data to ADD::::'+currentSelectedData);
            helper.addProductTable(component,currentSelectedData);
            
        }else if (selectedValue==="Delete"){
            component.set('v.DeletePopUp',true);
            console.log('selected action delete::: '+selectedValue);
        }
        
        
        //  alert("Menu item selected with value: " + selectedMenuItemValue+'  id: '+id[1]);
        //vealert(" id: "+);
    },
    /*handleShowPopover : function(component, event, helper) {
        var item=event.currentTarget;//event.getSource().get('v.name');
        var prodObjName="Opportunity_Product__c";
        
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
                    prod2Id=items[2];
                    // if(itemName!=null && itemName.startsWith("OP")){
                    //	 prodObjName="Opportunity_Product__c";
                    //}
                    //  if(items.length>3){
                    //   prod2Id=items[3];//get the product2 id
                    //	}
                }
            }
        }
        
        console.log('item id: '+itemId+' prod2 Id:'+prod2Id+' PopName:'+popClassName);
        
        var hoverContent;
        
        $A.createComponent(
            "c:LightningShowPopover", 
            { 'RecId':itemId,
             'prod2Id':prod2Id,
             'sObjectName':prodObjName,
             'source':'OpportunityProduct',
             'displayPopup':component.get("v.showPopover")  
            },
            
            function(content, status){
                console.log('status: '+status);
                // var promise;
                if(status==='SUCCESS')  {
                    hoverContent=content;//component[0];
                    var popUp=component.find('popOverlayLib');
                    console.log('pop up:'+popUp);
                    component.find('popOverlayLib').showCustomPopover({
                        body: hoverContent,
                        referenceSelector:"."+popClassName,//".popover2",//".popoverclass",
                        cssClass: "no-pointer,hideDiv"
                    }).then(function (overlay) {
                        component.set('v.hoverComponent', overlay);
                        console.log('overlay:::' +overlay);
                        setTimeout(function(){ 
                            //close the popover after 3 seconds
                           // overlay.close(); 
                        }, 3000);
                    });
                    
                }                  
            }
            
        );
        
    },
    
    closePopover : function(component, event, helper){
        var popOverComp =component.get('v.hoverComponent');// component.get('v.hoverPromise');//component.get('v.hoverComponent');
        
        console.log('overlayComponent: '+popOverComp);
        component.set("v.showPopover",false);
        // component.find("popOverlayLib").notifyClose();
        
        if(popOverComp!=null){
           // popOverComp.close();
             popOverComp.find("popOverlayLib").notifyClose();
      
            // component.find("overlayLib").notifyClose();
            console.log('closing????: '+popOverComp);
            // setTimeout(function(){ 
            //close the popover after 3 seconds
            // overlay.close(); 
            // popOverComp.close();
            //}, 0);
        }
        
        
    },
    HandlePopover :function (component,event,helper){
         component.set("v.showPopover", true);
    },
*/    
    ShowHoverPopover :function (component,event, helper){
        component.set("v.showPopover", true);
        //  alert('hello popover');
        console.log('hello popover');
        
    },
    HideHoverPopover :function (component,event,helper){
        console.log("hide popover");
        component.set("v.showPopover", false);
        /*  var popover = component.find("popover");
        if(!popover.length) popover = [popover];
       $A.util.removeClass(popover[parseInt(event.target.dataset.index)],'slds-show');
       $A.util.addClass(popover[parseInt(event.target.dataset.index)],'slds-hide');*/
        
        // $A.util.addClass(popover,"slds-hide");
        //$A.util.removeClass(popover,"slds-show");
        
    },
    
    
    display : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    
    displayOut : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    //KK Added For Delete
    DeleteOptyProd : function(component, event, helper){
        component.set('v.DeletePopUp','false');
        component.set('v.loading','true');
        helper.callServer(component,
                          "c.deleteOptyProduct", 
                          function(response){
                              component.set('v.loading','false');
                              if(response){
                                  component.refresh();
                              }
                              else
                              {
                                  alert('Error occured.Please Contact System Admin.');
                              }
                          }
                          ,{ 
                              OptyProdId:component.get('v.currentSelectedId') 
                          }
                         );
    },
    Deletecancel : function(component, event, helper){
        component.set('v.DeletePopUp','false');
    },
    WonLostRefresh : function(component, event, helper){
        var WinLoseOperation =event.getParam("WinLoseOperation");
        if(WinLoseOperation == 'Cancel'){
            component.refresh();
        }
        if(WinLoseOperation == 'Save'){
            component.Save();
        }
        component.set('v.WinLosePopup','false');
    }
})