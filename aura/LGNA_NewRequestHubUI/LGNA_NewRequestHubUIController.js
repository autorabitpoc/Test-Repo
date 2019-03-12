({
    //SDFC-9053 & SFDC-8550
    doInit : function(component, event, helper) {
        var recId=component.get("v.recordId");
        
        var objectName=component.get("v.sObjectName");
        console.log("recId: "+recId+ " objectName: "+objectName);
        
        var tempReqList=[];//component.get('v.initialReqList'); 
        var tempFavList=[];//component.get('v.initialFavoriteList');
        
        //initially load the favorite list and request list from database     
        helper.callServer(component,
                          "c.getRequestHubItems", 
                          function(response){
                              
                              if(response!=null){
                                  
                                  component.set('v.requestItemList', response);
                                  component.set('v.requestItemListTemp', response);//Rakesh SFDC-9050
                                  
                                  for(var i=0;i<response.length;i++){
                                      tempReqList.push({
                                          'sobjectType' : 'Request_Hub_Items__c', 
                                          'Name' : response[i].Name,
                                          'Label__c': response[i].Label__c,
                                          'FavoriteColor__c':response[i].FavoriteColor__c,
                                          'isFavorite__c':response[i].isFavorite__c
                                      });
                                  }
                                  component.set('v.initialReqList',tempReqList);
                                  // console.log(tempReqList.length+' ---tempReqList: '+tempReqList[0].FavoriteColor__c);
                              }
                          },{ 
                              recordId:recId,
                              objectName:objectName 
                          }
                         );
        
        // console.log("ksut>>>"+component.get('v.requestItemList'));
        
        helper.callServer(component,
                          "c.getFavoriteItemsList", 
                          
                          function(response){
                              
                              if(response!=null){
                                  
                                  component.set('v.favoriteList', response);
                                  component.set('v.favoriteListTemp', response);//Rakesh SFDC - 9050
                                  
                                  for(var i=0;i<response.length;i++){
                                      tempFavList.push({
                                          'sobjectType' : 'Request_Hub_Items__c', 
                                          'Name' : response[i].Name,
                                          'Label__c': response[i].Label__c,
                                          'FavoriteColor__c':response[i].FavoriteColor__c,
                                          'isFavorite__c':response[i].isFavorite__c
                                      });
                                  }
                                  component.set('v.initialFavoriteList', tempFavList);//temp list use to compare
                              }
                          },{ 
                              recordId:recId,
                              objectName:objectName 
                          }
                         );
        
        
        // SFDC-9356 BEGIN //
        //get the CSS Task Record Type ID //
        helper.callServer(component,
                          "c.fetchTaskRecordId",
                          function(response){
                              console.log('getCSSTaskRecordTypeID response: ' + response );
                              component.set("v.CSSTaskRecordId", response);
                          },{
                              toFind : "CSS Task Record Type"
                          }
                         );
        
        //ensure access to specific Task Record Type
        helper.callServer(component,
                          "c.checkCSSTaskTypeAccess",
                          function(response){
                              console.log('checkCSSTaskTypeAccess response: ' + response );
                              component.set("v.CSSTaskRecordAccess", response);
                          },{
                              //no parameters needed
                          }
                         );        
        // SFDC-9356 END   
    },
    
    //SDFC-9053 & SFDC-8550
    ChangeFavoriteFromRequestList : function(component, event, helper){
        var index=event.getSource().get("v.name");//index
        var requestItemList=component.get('v.requestItemList');
        var FavoriteColor='GrayColor';
        
        var initialReqItemList=component.get('v.initialReqList');
        
        if( requestItemList!=null && requestItemList.length>0){
            
            FavoriteColor=requestItemList[index].FavoriteColor__c;
            
            if (FavoriteColor==='GreyColor'){//change the color from true to false
                requestItemList[index].isFavorited__c=true;
                requestItemList[index].FavoriteColor__c='OrangeColor';
                console.log('when is changed , initial color: '+index+': '+initialReqItemList[index].FavoriteColor__c);
                
            }else{
                requestItemList[index].isFavorited__c=false;
                requestItemList[index].FavoriteColor__c='GreyColor';
                console.log('when is changed , initial color: '+index+': '+initialReqItemList[index].FavoriteColor__c);
                
            }
            
            console.log(" after: "+requestItemList[index].FavoriteColor__c);    
            component.set('v.requestItemList',requestItemList );      
            helper.CompareTwoListForChange(requestItemList,initialReqItemList,component);
        }
        
        if(component.get('v.isChanged')===true){// 
            component.set('v.MarkReqChanged',true);
        }else{
            component.set('v.MarkReqChanged',false);
            if(component.get('v.MarkFavChanged')===true){
                //if fav list is true for change, isChange back to true
                component.set('v.isChanged',true);
            }
        }
        
        console.log('final change status: '+component.get('v.isChanged'));
    },
    //SDFC-9053 & SFDC-8550
    ChangeFavorite: function(component, event, helper){
        var index=event.getSource().get("v.name");//index
        var favoriteList=component.get('v.favoriteList');
        
        var FavoriteColor='OrangeColor';//favoriteList[index].FavoriteColor__c;
        var initialFavList=component.get('v.initialFavoriteList');
        
        
        if(favoriteList!=null && favoriteList.length>0){
            
            console.log(" before: "+favoriteList[index].isFavorited__c);
            FavoriteColor=favoriteList[index].FavoriteColor__c;
            if (FavoriteColor==='GreyColor'){//change the color from true to false
                favoriteList[index].isFavorited__c=true;
                favoriteList[index].FavoriteColor__c='OrangeColor';
            }else{
                favoriteList[index].isFavorited__c=false;
                favoriteList[index].FavoriteColor__c='GreyColor';
            }
            component.set('v.favoriteList',favoriteList );
            helper.CompareTwoListForChange(favoriteList,initialFavList,component);
        }
        
        if(component.get('v.isChanged')===true){// 
            component.set('v.MarkFavChanged',true);
        }else{
            component.set('v.MarkFavChanged',false);
            if(component.get('v.MarkReqChanged')===true){
                //if request list is true for change, isChange back to true
                component.set('v.isChanged',true);
            }
        }
        
        console.log('final change status: '+component.get('v.isChanged'));
        
    },
    
    loadRecord: function(component,event, helper){
        var eventParams = event.getParams();
        
        console.log(" eventParams:::"+eventParams.changeType);
        var currentAccount=component.get("v.currentAccount");
        
        if(eventParams.changeType==='LOADED'){
            
            //do something
            console.log("effective date: "+currentAccount.Effective_Date__c+" external Id: "+currentAccount.External_ID__c);
        }
    },
    HandleRequested : function(component, event, helper){
        
        //get the Item that was clicked/selected 
        var selected = event.getParam('name');
        var currentSelected=component.get('v.currentItem');
        var objectName=component.get("v.sObjectName");
        
        console.log('selected: '+selected +' current: '+currentSelected);
        
        //SFDC-9356 - BEGIN //
        if(selected === currentSelected){
            
            // Logic to handle individual Items
            if(selected === 'CSS_Tasks'){
                
                var checkAccess = component.get('v.CSSTaskRecordAccess');
                
                //If User Profile has access, create Task 
                if (checkAccess === true){
                    // create the Task
                    helper.createCSSTask(component, event, helper);                             
                }else{
                    //show Toast Message to other Users
                    helper.genericShowToast("Error!",
                                            "dismissible",
                                            "Only GET TEAM users can create CSS tasks. You do not have sufficient access, kindly contact your administrator.",
                                            "error");
                }                 
            }
            //SFDC- 9020 Sujatha/Rakesh Start
            else if(selected === 'Account_Maintenance'){
                if(objectName =='Account'){
                    
                    helper.callServer(component,
                                      "c.checkAccountMaintenanceTypeAccess",
                                      function(response){
                                          console.log('checkAccountMaintenanceTypeAccess response: ' + response );
                                          component.set("v.accMaintRecAccess", response);
                                          
                                          var checkActMaintenanceAccess = component.get("v.accMaintRecAccess");
                                          if(checkActMaintenanceAccess == true){
                                              helper.callServer(component,
                                                                "c.getaccDetails",
                                                                function(response){
                                                                     // alert('res'+response);
                                                                    if(response!=null){
                                                                        component.set("v.accDetails", response.Status__c); 
                                                                        //  alert('not null'+response.Status__c);
                                                                        if(response.Status__c === 'Cancelled'){
                                                                            helper.genericShowToast("Error!",
                                                                                                    "dismissible",
                                                                                                    "Account is already cancelled. You cannot raise a maintainance request",
                                                                                                    "error");  
                                                                        }else if(checkActMaintenanceAccess === true){
                                                                            var currentRecordId = component.get("v.recordId"); 
                                                                            var accMaintenanceCmp = component.find("reqMaint");
                                                                            accMaintenanceCmp.setModel(true,currentRecordId);
                                                                        }
                                                                        
                                                                    }           
                                                                },
                                                                {
                                                                    accountId:component.get("v.recordId")
                                                                }
                                                               ); 
                                          }
                                          else{
                                              helper.genericShowToast("Error!",
                                                                      "dismissible",
                                                                      "You do not have access to create Account Maintenance Request, kindly contact your administrator.",
                                                                      "error");
                                              
                                          } 
                                          
                                          
                                          
                                      },{
                                          //no parameters needed
                                      }
                                     ); 
                    
                    
                }
                if(objectName =='Opportunity'){
                    helper.callServer(component,
                                      "c.checkAccountMaintenanceTypeAccess",
                                      function(response){
                                          console.log('checkAccountMaintenanceTypeAccess response: ' + response );
                                          component.set("v.accMaintRecAccess", response);
                                          var checkActMaintenanceAccess = component.get("v.accMaintRecAccess");
                                          if(checkActMaintenanceAccess == true){
                                              helper.callServer(component,
                                                                "c.getOpportunityDetails",
                                                                function(response){
                                                                    //  alert('res'+response);
                                                                    if(response!=null){
                                                                        component.set("v.oppDetails", response.Status__c); 
                                                                        //  alert('not null'+response.Status__c);
                                                                        /*if(response.Status__c === 'cancelled'){
                                              helper.genericShowToast("Error!",
                                                                      "dismissible",
                                                                      "Account is already cancelled. You cannot raise a maintainance request",
                                                                      "error");  
                                                                    }*/
                                                                        if(checkActMaintenanceAccess === true){
                                                                            var currentRecordId = component.get("v.recordId"); 
                                                                            var accMaintenanceCmp = component.find("reqMaint");
                                                                            accMaintenanceCmp.setModel(true,currentRecordId);
                                                                        }
                                                                        
                                                                    }           
                                                                },
                                                                {
                                                                    recordId:component.get("v.recordId")
                                                                }
                                                               ); 
                                          }
                                          else{
                                              helper.genericShowToast("Error!",
                                                                      "dismissible",
                                                                      "You do not have access to create Account Maintenance Request, kindly contact your administrator.",
                                                                      "error");
                                              
                                          } 
                                      },{
                                          //no parameters needed
                                      }
                                     ); 
                    
                    
                }
            }// SFDC - 9020 Sujatha/Rakesh Ends
            
            else if(selected==='Create_Prospect'){ //SFDC-9234
                    var recordId=component.get("v.recordId");   
                    // var grpAccount=component.get("v.CancelledGrpAcccount");
                    
                    helper.callServer(component,"c.getRecordTypeId",
                                      function(response){
                                          if(response!=null){//get the prospect record type Id
                                              component.set('v.prospectRecordId',response);
                                              console.log('prospect recordtype id: '+component.get('v.prospectRecordId'));
                                          }
                                      },
                                      {
                                          recordDevName:"Group_Prospect_Account",
                                          objectName:"Account"
                                          
                                      });
                    
                    helper.callServer(component, "c.getProspectAccountAccess",
                                      function(response){
                                          console.log('get prospect account access:'+response);
                                          component.set('v.createProspectAccess', response);
                                      },{
                                          recordTypeId:component.get("v.prospectRecordId")
                                      }
                                     );
                    
                    helper.callServer(component,
                                      "c.getaccDetails",
                                      function(response){
                                          console.log('res::'+response);
                                          
                                          if(response!=null){
                                              
                                              if(response.Status__c !='Cancelled'){
                                                  helper.genericShowToast("Error!",
                                                                          "dismissible",
                                                                          "Group Account is not Cancelled. Prospect cannot be created.",
                                                                          "error");  
                                              }else{
                                                  
                                                  var hasAccess=component.get("v.createProspectAccess");
                                                  //  alert(hasAccess);
                                                  if(!hasAccess){
                                                      helper.genericShowToast("Error!",
                                                                              "dismissible",
                                                                              "You Do Not have Access to Create Prospect Account.",
                                                                              "error");  
                                                  }else{
                                                      component.set("v.CancelledGrpAcccount", response);//account needed to be clone from
                                                      helper.Create_Prospect(component,event, helper);
                                                  }
                                              }
                                              
                                          }           
                                      },
                                      {
                                          accountId:recordId//component.get("v.recordId")
                                      }
                                     );
                }// end of create prospect
            else if(selected==='Reserve_Group_Number'){
                        var recordId = component.get("v.recordId");
                        var eventParams = event.getParams();
                     console.log(" current account load error:::"+component.get("v.loadError"));
                
                        var currentAccount=component.get("v.currentAccount");
                        var msg1=$A.get("$Label.c.BlueStarAccountReservationMsg8");
                        var msg2=$A.get("$Label.c.BlueStarAccountReservationMsg9"); //	Effective Date is required to submit a request to reserve Account/Group Number(s).
                        var validated=true;
                         console.log('validation before calling Blue star page....');
                        console.log('current account:::'+currentAccount);
                
                        if(currentAccount!==null) {
                            console.log("account effectivate;;;;"+currentAccount.Effective_Date__c+" external Id:"+currentAccount.External_ID__c);
                            
                            console.log("effective date: "+currentAccount.Effective_Date__c+" external Id: "+currentAccount.External_ID__c);
                            
                            if(currentAccount.External_ID__c!=null){
                                validated=false;
                                helper.genericShowToast("Error!",
                                                        "dismissible",
                                                        msg1,
                                                        "error");  
                            }
                            if(currentAccount.Effective_Date__c===null|| currentAccount.Effective_Date__c===""){
                                validated=false;
                                helper.genericShowToast("Error!",
                                                        "dismissible",
                                                        msg2,
                                                        "error");  
                            }
                            
                            if(validated){
                               
                                var url = '/apex/BlueStarAccountReservation?id=' + recordId;
                                
                                console.log(" validation clear... ready to call blue start page==>"+url);
                                
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({ "url":url });
                                urlEvent.fire();
                            }
                        }  else{
                             helper.genericShowToast("Error!",
                                                        "dismissible",
                                                        "Please contact System Administrator (make sure user has access to the account fields).",
                                                        "error"); 
                           console.log('Account is null!!!!');
                        }
                        
                    }// end of 
            
            //SFDC - 8918 Begin Here
            
             else if(selected === 'Contract_Admin'){
                            
                            helper.callServer(component,
                                              "c.contractAdminAccess",
                                              function(response){
                                                  component.set("v.contractAdminAccess", response);
                                                  var contractAdminAccess = component.get("v.contractAdminAccess");
                                                  if(contractAdminAccess == true){
                                                      component.set("v.openContractAdmin",true);
                                                      
                                                  }
                                                  else{
                                                      helper.genericShowToast("Error!",
                                                                              "dismissible",
                                                                              "You do not have access to create Contract Admin Request, kindly contact your administrator.",
                                                                              "error"); 
                                                      
                                                  }
                                              },{
                                                  // No Params Needed
                                              }
                                             ); 
                            
                        }  //SFDC - 8918 ENDS Here
            
             else if(selected==='Request_Quote'){//SFDC-9508 Mei
                                //alert('create quote22');
                                var recordId = component.get("v.recordId");
                                var url = '/apex/OpportunityQuoteRequest?id=' + recordId;
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({ "url":url });
                                urlEvent.fire();
                            
                                
                            }///end of SFDC-9508
            
            //Ranjit G- 9626 - start
             else if(selected === 'GEMS_SBC_Benefit_Booklet_Request')
             {
                //alert(selected);
                 selectedItemLabel='Contract Admin Request'
                 helper.callServer(component,
                                       "c.contractAdminRequestRecordTypeAccess",
                                       function(response){                                          
                                           console.log('contractAdminRequestRecordTypeAccess response: ' + response );
                                           component.set("v.contractAdminRequestRecordTypeAccess", response);
                                           component.set("v.selectedItem", selectedItemLabel); 
                                          //alert('response'+response);
                                           var currentRecordId = component.get("v.recordId");
                                          //alert('currentRecordId'+currentRecordId)
                                           if(response==null){
                                               var selectedItemConfirm = component.find("reqItemConfirmContractAdminRequest");
                                               selectedItemConfirm.setModel(true,currentRecordId,selectedItemLabel,false,true);
                                             
                                           }
                                           
                                           else if(response=='false'){
                                               helper.genericShowToast("Error!",
                                                                       "dismissible",
                                                                       "You do not have access to create Contract Admin Request. Kindly contact your Administrator",
                                                                       "error");
                                           }
                                           else 
                                           {
                                                
                                                helper.genericShowToastPester("Warning!",
                                                                       "pester",
                                                                       "There already exists one contract admin request in this Opportunity.\n To add additional Contract admin (SBC or Benefit Booklet) request, Navigate to Submission Case..",
                                                                       "Warning","10000");
                                    
                                           }
                                       },{
                                           selectedItem:selectedItemLabel,recordId:component.get("v.recordId")
                                       }
                                      ); 
             }
             //Ranjit G- 9626 - end
            
            //Padma Bedampeta - 9055,9056,9235,9470,9471,9473,9476 - start
                 else if(
                     (selected === 'Proposal' || 
                      selected === 'Cede' || 
                      selected === 'Network_Information' ||
                      selected === 'Performance_Guarantee'||
                      selected === 'Custom_Benefit_Service' ||
                      selected === 'Private_Exchange_External') 
                 ){  
                     var selectedItemLabel;                
                     if(selected === 'Network_Information'){
                         selectedItemLabel = 'Network Information';
                     }
                     else if(selected === 'Performance_Guarantee'){
                         selectedItemLabel = 'Performance Guarantee';
                     }
                         else if(selected === 'Custom_Benefit_Service'){ // SFDC- 9578
                             selectedItemLabel = 'Custom Benefit/Service';
                         }
                             else if(selected === 'Private_Exchange_External' 
                                     && objectName==='Opportunity'){                                
                                 var selectedItemLabel = 'Private Exchange - External';
                             }    
                             else{
                                 selectedItemLabel = selected; 
                             }         
                     //Access check for Network INformation, Proposal, Cede, Private Exchange type Case recordtypes.
                     helper.callServer(component,
                                       "c.checkCaseRecordTypeAccess",
                                       function(response){
                                           console.log('checkCaseRecordTypeAccess response: ' + response );
                                           component.set("v.caseRecordTypeAccess", response);
                                           component.set("v.selectedItem", selectedItemLabel);
                                           var currentRecordId = component.get("v.recordId");
                                           if(response){
                                               var selectedItemConfirm = component.find("reqItemConfirm");
                                               selectedItemConfirm.setModel(true,currentRecordId,selectedItemLabel,true,false);//Ranjit G-9626
                                           }else{
                                               helper.genericShowToast("Error!",
                                                                       "dismissible",
                                                                       "You do not have access to the requested Case type, kindly contact your administrator.",
                                                                       "error");
                                           }
                                       },{
                                           selectedItem:selectedItemLabel
                                       }
                                      ); 
                     //Padma Bedampeta -9055,9056,9235,9470,9471,9473,9476 - End
                 }
            
            //SFDC-9269 - Start
            else if(selected === 'Secure_Information'&& objectName === 'Opportunity'){
                var recordId=component.get("v.recordId");
                var objectName=component.get("v.sObjectName");
                var selectedItem = selected;
                // alert(selectedItem);
                //  alert(objectName);
                var selectedItemConfirm = component.find("selectedSI");
                selectedItemConfirm.setModel(true,recordId,selectedItem,objectName);
            }//SFDC-9269 - End
            
            // SFDC-9466 SFDC-9579 Start
            else if(selected === 'Cancellation'){
                var recordId=component.get("v.recordId");
                var objectName=component.get("v.sObjectName");
                var selectedItemLabel = 'Account Cancellation';
                helper.callServer(component,"c.isSGAccount",
                                  function(response){
                                      var checkSGAccount = response;
                                     // alert(checkSGAccount);
                                      if(checkSGAccount === true){
                                          var url = '/apex/AccountCompleteCancellation?id=' + recordId;
                                          var urlEvent = $A.get("e.force:navigateToURL");
                                          urlEvent.setParams({ "url":url });
                                          urlEvent.fire();
                                      }
                                      else{
                                          component.set('v.canReqModal', true);
                                      }
                                  },
                                  {
                                      recordId:recordId
                                  }
                                 );
                
            }// SFDC-9466 SFDC-9579 End
            
            //SFDC 9041 Start
                else if(selected === 'Open_Enrollment'){
                    helper.callServer(component,"c.checkSRAccess",
                                      function(response){
                                          var checkOptyOpenEnrAccess = response;
                                          if(checkOptyOpenEnrAccess === true){
                                              helper.callServer(component,"c.getRecordTypeId",
                                                                function(response){
                                                                    var SRRecTypeId = response;
                                                                    if(SRRecTypeId !=''){
                                                                        if(component.get("v.sObjectName") == 'Opportunity'){
                                                                            helper.callServer(component,"c.getOpportunityDetails",
                                                                                              function(response){
                                                                                                  if(response != ''){
                                                                                                      var createRecordEvent = $A.get("e.force:createRecord");
                                                                                                      createRecordEvent.setParams({
                                                                                                          "entityApiName": 'Service_Request__c',
                                                                                                          "recordTypeId": SRRecTypeId,
                                                                                                          "defaultFieldValues": {
                                                                                                              'Account__c':response.AccountId,
                                                                                                              'Status__c' : 'Not Staffed',
                                                                                                              'Opportunity_Name__c' : response.Id,
                                                                                                          }
                                                                                                      })
                                                                                                      createRecordEvent.fire();
                                                                                                      $A.get("e.force:closeQuickAction").fire();
                                                                                                  }
                                                                                              },
                                                                                              {
                                                                                                  'recordId' : component.get("v.recordId")
                                                                                              }
                                                                                              
                                                                                             );
                                                                        }
                                                                        if(component.get("v.sObjectName") == 'Account'){
                                                                            var createRecordEvent = $A.get("e.force:createRecord");
                                                                            createRecordEvent.setParams({
                                                                                "entityApiName": 'Service_Request__c',
                                                                                "recordTypeId": SRRecTypeId,
                                                                                "defaultFieldValues": {
                                                                                    'Account__c':component.get('v.recordId'),
                                                                                    'Status__c' : 'Not Staffed',
                                                                                }
                                                                            })
                                                                            createRecordEvent.fire();
                                                                            $A.get("e.force:closeQuickAction").fire();
                                                                        }
                                                                    }
                                                                    
                                                                },
                                                                {
                                                                    'recordDevName' :'Open_Enrollment',
                                                                    'objectName' :'Service_Request__c'  
                                                                });
                                          }
                                          else{
                                              helper.genericShowToast("Error!",
                                                                      "dismissible",
                                                                      "You do not have access to create Open Enrollment request. Kindly contact your Administrator.",
                                                                      "error");
                                          }
                                      },
                                      {
                                          'selectedItem' : 'Open Enrollment'
                                      });
                    
                }else if(selected === 'Transmit EIN to BlueStar'){
                    //SFDC-10022 : Show the pop-up for EIN transmission confirmation when the user chooses option for EIN transmission.
                    component.set('v.einSendModal',true);
                }
        }//SFDC 9041 End
        //SFDC-9356 - END   //
        component.set('v.currentItem', selected);
    },
    
    
    //SFDC - 9050    Find/Search method Starting here  
    handleKeyUp : function(component,event,helper){
        //Code for Request Items
        var requestItemList = component.get("v.requestItemListTemp");
        var keyword = component.get("v.keyword");
        var descriptionArr =[];
        var finalRequestItemsList = [];
        var arr=[];
        if(keyword.length){
            var keys = Object.keys(requestItemList);
            var nameObjectMap = new Map();
            var descriptionObjectMap = new Map();
            for (var i = 0; i < keys.length; i++) {
                
                var element = requestItemList[i];
                var StringElement =JSON.stringify(element);                
                var splitElement = StringElement.toString().split(",");
                //Split for Name,Map for Name and Matched Name
                var NameElementPart = splitElement[5];
                var prefinalName=NameElementPart.split(":").pop();
                var finalName  = prefinalName.substring(0, prefinalName.length-1);
                //var last  = finalName.slice(1, -1);
                var last  = finalName.slice(1,finalName.length);
                nameObjectMap.set(last, element);
                var myReg = new RegExp(".*"+keyword + ".*$","i");
                var myMatch = last.match(myReg);
                
                if(myMatch!=null){
                    arr.push(myMatch);
                }
                
                //Split for Decription,Map for Description and Matched Description
                //alert(splitElement);
                if(splitElement.length>3){
                    //alert("heloo");
                    var descriptionPart = splitElement[4];
                    //alert(descriptionPart);
                    var preFinalDesc = descriptionPart.split(":").pop();
                    var finalDesc = preFinalDesc.substring(0, preFinalDesc.length-1);                    
                    var lastDesc = finalDesc.slice(1, -1);                    
                    //alert(lastDesc);
                    descriptionObjectMap.set(lastDesc,element);
                    var myRegDesc = new RegExp(".*"+keyword+ ".*","i");
                    var myMatchDesc = lastDesc.match(myRegDesc);
                    if(myMatchDesc!=null){
                        descriptionArr.push(myMatchDesc);
                    }
                }
                
            }
            
            //Map Iteration for Name
            var finalList =[]; 
            for (var [key, value] of nameObjectMap) {
                for (var i = 0; i < arr.length; i++) {
                    
                    if(key == arr[i]){
                        
                        finalList.push(nameObjectMap.get(key));
                    }
                }
            }
            //component.set("v.requestItemList",finalList)
            //Map Iteration for Description
            var finalDescriptionList = [];
            for (var [key, value] of descriptionObjectMap) {
                for (var i = 0; i < descriptionArr.length; i++) {
                    
                    if(key == descriptionArr[i]){
                        
                        finalDescriptionList.push(descriptionObjectMap.get(key));
                    }
                }
            }
            //alert("final Desc"+finalDescriptionList);
            finalRequestItemsList = finalList.concat(finalDescriptionList);
            var set = new Set(finalRequestItemsList);
            finalRequestItemsList = Array.from(set);
            
            component.set("v.requestItemList",finalRequestItemsList);
            
            
            //Code for Favorite
            
            var requestItemListfav = component.get("v.favoriteListTemp");
            var keywordfav = component.get("v.keyword");
            var descriptionArrfav =[];
            var finalRequestItemsListfav = [];
            var arrfav=[];
            var keysfav = Object.keys(requestItemListfav);
            var nameObjectMapfav = new Map();
            var descriptionObjectMapfav = new Map();
            for (var i = 0; i < keysfav.length; i++) {
                
                var elementfav = requestItemListfav[i];
                var StringElementfav =JSON.stringify(elementfav);
                var splitElementfav = StringElementfav.toString().split(",");
                //Split for Name,Map for Name and Matched Name
                var NameElementPartfav = splitElementfav[5];
                var prefinalNamefav=NameElementPartfav.split(":").pop();
                var finalNamefav  = prefinalNamefav.substring(0, prefinalNamefav.length-1);
                //var last  = finalName.slice(1, -1);
                var lastfav  = finalNamefav.slice(1,finalNamefav.length);
                nameObjectMapfav.set(lastfav, elementfav);
                var myRegfav = new RegExp(".*"+keywordfav + ".*$","i");
                var myMatchfav = lastfav.match(myRegfav);
                
                if(myMatchfav!=null){
                    arrfav.push(myMatchfav);
                }
                
                //Split for Decription,Map for Description and Matched Description
                //alert(splitElement);
                if(splitElementfav.length>3){
                    //alert("heloo");
                    var descriptionPartfav = splitElementfav[4];
                    //alert(descriptionPart);
                    var preFinalDescfav = descriptionPartfav.split(":").pop();
                    var finalDescfav = preFinalDescfav.substring(0, preFinalDescfav.length-1);
                    var lastDescfav = finalDescfav.slice(1, -1);
                    //alert(lastDesc);
                    descriptionObjectMapfav.set(lastDescfav,elementfav);
                    var myRegDescfav = new RegExp(".*"+keywordfav+ ".*","i");
                    var myMatchDescfav = lastDescfav.match(myRegDescfav);
                    if(myMatchDescfav!=null){
                        descriptionArrfav.push(myMatchDescfav);
                    }
                }
                
            }
            
            //Map Iteration for Name
            var finalListfav =[]; 
            for (var [key, value] of nameObjectMapfav) {
                for (var i = 0; i < arrfav.length; i++) {
                    
                    if(key == arrfav[i]){
                        
                        finalListfav.push(nameObjectMapfav.get(key));
                    }
                }
            }
            //component.set("v.requestItemList",finalList)
            //Map Iteration for Description
            var finalDescriptionListfav = [];
            for (var [key, value] of descriptionObjectMapfav) {
                for (var i = 0; i < descriptionArrfav.length; i++) {
                    
                    if(key == descriptionArrfav[i]){
                        
                        finalDescriptionListfav.push(descriptionObjectMapfav.get(key));
                    }
                }
            }
            //alert("final Desc"+finalDescriptionList);
            finalRequestItemsListfav = finalListfav.concat(finalDescriptionListfav);
            var setfav = new Set(finalRequestItemsListfav);
            finalRequestItemsListfav = Array.from(setfav);
            
            component.set("v.favoriteList",finalRequestItemsListfav);
            
            
        }
        
        
        else{
            component.refresh();
            
        }
        
    },
    
    // SFDC - 9050 Find/searching method ending here 
    
    
    
    // SFDC-9052 Save Preferences Functionality Start
    
    SaveUserFavorite: function(component, helper){
        var reqList=component.get('v.requestItemList');
        var favList=component.get('v.favoriteList');
        
        var action = component.get("c.saveFavoriteItemsList");
        //alert('action');
        action.setParams({
            "favoriteItems":favList,
            "requestItems":reqList            
        });
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   $A.get('e.force:refreshView').fire();
                               } else {
                                   //do something
                               }
                           }
                          );
        $A.enqueueAction(action);
        
        component.set('v.isChanged', false);
        component.refresh();
        
    },
    // SFDC-9052 Save Preferences Functionality Start 
    // } 
    
    
    // SFDC -8918 Start 
    closeModelWindow : function(component,event,helper){
        component.set("v.openContractAdmin",false);
        component.set("v.canReqModal",false);
        //SFDC-10022 - Close the EIN pop-up window when the user chooses close option. 
        component.set('v.einSendModal',false);
        
    },
    
    //SFDC -8918 Redirecting to the Specific Rectype
    redirectToContract : function(component,event,helper){
        var selectedItem = event.currentTarget;
        var recordType = selectedItem.dataset.name;
        console.log("selected Item:::"+selectedItem+"...record type::"+recordType);
        if(recordType!=null){
            
            helper.callServer(component,
                              "c.fetchCurrentAccountInfo",
                              function(response){
                                  console.log('fetchCurrentAccountInfo response: ' + response );
                                  component.set("v.accountRecord", response);
                                  
                                  // Start
                                  helper.callServer(component,
                                                    "c.fetchCaseRecordTypeId", 
                                                    function(response){
                                                        //component.set('v.requestItemList', response);
                                                        var accountRecord = component.get("v.accountRecord");
                                                        var hcsc= accountRecord.HCSC_Division__c;
                                                        var createAcountContactEvent = $A.get("e.force:createRecord");
                                                        createAcountContactEvent.setParams({
                                                            "entityApiName": "Case",
                                                            "defaultFieldValues": {
                                                                'RecordTypeId' : response,
                                                                'AccountId' : component.get("v.recordId"),
                                                                'Priority':'Medium',
                                                                'HCSC_Division__c':hcsc,
                                                                'Status':'Final Sent to Sales & Marketing',
                                                                'Negotiation_Type__c':'',
                                                                'Account_Executive__c':accountRecord.OwnerId,
                                                                'Underwriter_From_Account__c':accountRecord.Underwriter_Name__c,
                                                                'Requestor_Name__c':$A.get("$SObjectType.CurrentUser.Id")
                                                            }
                                                        });
                                                        createAcountContactEvent.fire();
                                                        
                                                        
                                                    },{ 
                                                        selectedRecordType:recordType 
                                                    }
                                                   );
                                  
                              },{
                                  recordId:component.get("v.recordId")
                              }
                             ); 
            
        }
    },
    // SFDC -8918 ENDS
    handleChange: function (component,event,helper) {
        var changeValue = event.getParam("value");
        //alert(changeValue);
        component.set("v.canReqSelected",changeValue);
    },
   
    navtoCancelPage:  function(component,event,helper){
        //canReqSelected
        
        var selected = component.get('v.canReqSelected');
        var recordId = component.get("v.recordId");
        var selectedItemLabel = 'Account Cancellation'; 
        if(selected === 'Account'){
            var url = '/apex/AccountCompleteCancellation?id=' + recordId;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({ "url":url });
            urlEvent.fire();
            component.set("v.canReqModal",false);
            //alert(selected);
        }
        else if(selected === 'Group Section, Billing Profile and Category Cancellation'){
            helper.callServer(component,
                              "c.createCase", 
                              function(response){                                  
                                  var url ='/'+response.Id;
                                  window.open(url, "_blank");
                                  
                              },
                              {
                                  caseRecTypeLabel:selectedItemLabel,
                                  recordId:recordId
                                  
                              });
            component.set("v.canReqModal",false);
        }
    }
})