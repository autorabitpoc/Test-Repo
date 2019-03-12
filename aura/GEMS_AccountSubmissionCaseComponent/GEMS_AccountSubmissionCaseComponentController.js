({
    doInit : function(component, event, helper) {
        
        console.log("GEMS_AccountSubmissionCaseComponent doInit");
        
        var reportAction= component.get("c.caseReportDetails");  
        
        reportAction.setCallback(this,function(response){
            var status = response.getState();
            
            console.log("Status: " + status);
            
            if(status === "SUCCESS"){              
                
                var tempCases=[];
                var tempCasesList=[];
                
                tempCases = response.getReturnValue();
                
                console.log("tempCases: " + tempCases);
                
                //maps used to create popover
                var ownerMap = {};
                var statusMap = {};
                var effDtMap = {};
                var oppMap = {};
                
                for(var i=0;i<tempCases.length;i++){ 
                    tempCasesList.push({
                        'sobjectType' : 'Case', 
                        'Id' :tempCases[i].Id,
                        'Subject' : tempCases[i].Subject,
                        'AccountId': tempCases[i].AccountId,
                        'Account.Name': tempCases[i].Account.Name,
                        'Milestone__c':tempCases[i].Milestone__c,
                        'Opportunity_Name__c':tempCases[i].Opportunity_Name__c,
                        'Opportunity_Name__r.Name' :tempCases[i].Opportunity_Name__r.Name,
                        'CaseNumber' :tempCases[i].CaseNumber,
                        'Account_Name__c': tempCases[i].Account_Name__c,
                        'Owner_Name__c': tempCases[i].Owner_Name__c,
                        'Status': tempCases[i].Status,
                        'GEMS_Case_Effective_Date__c': tempCases[i].GEMS_Case_Effective_Date__c
                    });
                    console.log("Id & Milestone & Opportunity: " + tempCasesList[i].Id + ' ' + tempCasesList[i].Milestone__c + ' ' + tempCases[i].Opportunity_Name__r.Name);
                    
                    ownerMap[tempCases[i].Id] = ownerMap[tempCases[i].Id] || [];
                    ownerMap[tempCases[i].Id].push(tempCases[i].Owner_Name__c);
                    
                    statusMap[tempCases[i].Id] = statusMap[tempCases[i].Id] || [];
                    statusMap[tempCases[i].Id].push(tempCases[i].Status);
                    
                    effDtMap[tempCases[i].Id] = effDtMap[tempCases[i].Id] || [];
                    effDtMap[tempCases[i].Id].push(tempCases[i].GEMS_Case_Effective_Date__c);                    
                    
                    oppMap[tempCases[i].Id] = oppMap[tempCases[i].Id] || [];
                    oppMap[tempCases[i].Id].push(tempCases[i].Opportunity_Name__r.Name); 
                    
                }
                console.log("tempCasesList: " + tempCasesList);
                component.set("v.returnedCases",tempCasesList);                
                
                //push maps to Attributes
                component.set("v.caseOwner", ownerMap);
                component.set("v.caseStatus",statusMap);
                component.set("v.caseEffDate",effDtMap);
                component.set("v.caseOpp",oppMap);                
            }
        });
        
        $A.enqueueAction(reportAction);
    },
    
    //Account or Case clicked navigates to the appropriate Object
    navigateToSObject: function(component, event, helper) {        
        var recordId = event.currentTarget.id.split('+')[0];       
        var evt = $A.get("e.force:navigateToSObject");
        evt.setParams({
            "recordId": recordId,            
        });
        evt.fire(); 
    },
    
    //View Report clicked call this and directs to the Report 
    getReportId: function(component, event, helper) {
        
        console.log('getReportId called');
        
        var reportIdAction= component.get("c.caseReportID");  
        
        reportIdAction.setCallback(this,function(response){
            var status = response.getState();
            var getReturnValue = response.getReturnValue();
            
            console.log("ReportId: " + response.getReturnValue());
            
            console.log("Status: " + status);
            
            if(status === "SUCCESS"){
                component.set("v.reportId",response);
                var evt = $A.get("e.force:navigateToSObject");
                evt.setParams({
                    "recordId": getReturnValue,            
                });
                evt.fire(); 
            }
        });
        $A.enqueueAction(reportIdAction);
    },
    
    handleShowPopover : function(component, event, helper) {
        if(component.get("v.showPopover") !=true){
            
            var popoverclass = event.currentTarget.id.split('+')[0];
            component.set("v.showPopover",true);
           // alert('Showpopover=true');
            console.log('handleShowPopover');
            
            var eventValue = event.currentTarget.id.split('+')[1];        
            console.log('eventValue: ' + eventValue);
            
            var theCaseOwner = String(component.get("v.caseOwner")[eventValue]);
            var theCaseStatus = String(component.get("v.caseStatus")[eventValue]);
            var theCaseEffDt = String(component.get("v.caseEffDate")[eventValue]);
            var theCaseOpp = String(component.get("v.caseOpp")[eventValue]);
            
            console.log('theCaseOwner: ' + theCaseOwner);
            console.log('theCaseStatus: ' + theCaseStatus);
            console.log('theCaseEffDt: ' + theCaseEffDt);
            console.log('theCaseOpp: ' + theCaseOpp)
            
            //var popOverString = 'Owner: '+theCaseOwner+' Status: '+theCaseStatus+' Eff Date:'+theCaseEffDt;
            
            var popOverBody;
            
            $A.createComponent("c:GEMS_AccountSubmissionCaseComponentPopOver",{
                'caseOwner':theCaseOwner,
                'caseStatus':theCaseStatus,
                'caseEffDt':theCaseEffDt,
                'caseOpp':theCaseOpp,
                'displayPopup':component.get("v.showPopover"),
                'CaseNumber': event.currentTarget.id.split('+')[2]
            },
                               function(content, status) {                               
                                   if (status === "SUCCESS") {
                                       console.log('content: '+ content);
                                       popOverBody = content;
                                       component.find('overlayLib1').showCustomPopover({
                                           body: popOverBody,
                                           referenceSelector: "."+popoverclass,
                                          // cssClass: "no-pointer"
                                       }).then(function (overlay) {
                                           component.set('v.hoverComponent', overlay);
                                          /* setTimeout(function(){ 
                                               //close the popover after 3 seconds
                                               //component.find('overlayLib1').notifyClose();
                                               overlay.close();
                                               component.set('v.showPopover',false);
                                           }, 3000);*/
                                       })
                                   }                               
                               });
        }
        
    },
    closePopover : function(component, event, helper){
        component.set('v.showPopover',false);
        var popOverComp = component.get('v.hoverComponent');
        console.log('popOverComp: '+popOverComp);
        if(popOverComp!=null){
            console.log('popOverComp: '+popOverComp);
            popOverComp.hide();
        }
    }
})