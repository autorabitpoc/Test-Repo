({
    getRelatedOpps : function(component) {
        //console.log("getting realted opty");
        var action = component.get("c.getRelatedOpportunities");
        //alert(component.get("v.recordId"));
        action.setParams(
            {
                "gateId": component.get("v.recordId"),
                "maxRows": component.get("v.maxRows"),
                "sortField": component.get("v.sortBy"),
                "sortOrder": component.get("v.sortDir")
            }
        );
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state:'+state);
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                //console.log('inside  data::'+JSON.stringify(data));
                if (data.length==0) {
                    component.set('v.err',"true");
                    component.set("v.errMsg", 'No opportunities found for this gate');
                    return; 
                }
                for (var i=0; i<data.length; i++) {
                    var row = data[i];
                    // Flatten/normalize field data
                    if (row.Account) {
                        row.AccountName = row.Account.Name;
                        row.AccountNum = row.Account.External_Id__c;                        
                    } 
                   
                        row.recId = '/'+row.Id;                                           

                    if (row.Assigned_UW__r) {
                        row.AssignedUW = row.Assigned_UW__r.Name;
                    } 
                    if (row.RecordType && row.RecordType.Name.includes('SGR') && row.RecordType.Name.includes('Opportunity')) {
                        row.RecordTypeName = row.RecordType.Name.replace('SGR','').replace('Opportunity','');
                    } else if(row.RecordType) {
                        row.RecordTypeName = row.RecordType.Name;
                    }
					if (!row.Health_Count__c) {
                        row.Health_Count__c = 0;
                    }
                    console.log('row.Dental_Count__c'+row.Dental_Count__c);
                    if (!row.Dental_Count__c) {
                        row.Dental_Count__c = 0;
                    }
                    if (!row.Subscribers_Count__c) {
                        row.Subscribers_Count__c = 0;
                    }
                }
                
                component.set("v.data", data);
                // TODO: Uncomment for server sorting
                /*var sortDir=component.get('v.sortDir');
                if (sortDir == 'asc') {
                	component.set("v.sortDir", 'desc');
                } else {
                    component.set("v.sortDir", 'asc');
                }*/
               // $A.get('e.force:refreshView').fire();   
            } else if (state === 'ERROR') {
                component.set("v.err", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errMsg", 'Opportunities could not be retreived. '+errors[0].message);
                    } else {
                        component.set("v.errMsg", 'Opportunities could not be retreived. Unknown server error');
                    }
                }
            } else {
                component.set("v.err", true);
                component.set("v.errMsg", 'Opportunities could not be retreived. Unknow error');
            }
        });
        $A.enqueueAction(action);
    },
    getRelatedOppsCount : function(component) {
        var action = component.get("c.getRelOppsCount");
        action.setParams(
            {
                "gateId": component.get("v.recordId")
            }
        );
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.optycount",response.getReturnValue());
                //console.log('Count retreived successfully');
                //$A.get('e.force:refreshView').fire();   
            } else if (state === 'ERROR') {
                component.set("v.err", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errMsg", errors[0].message);
                    } 
                }
            } else {
                component.set("v.errMsg", 'Opportunities count could not be retreived. Unknown error has occured!');
            }
        });
        $A.enqueueAction(action);
    }, 
    
   /*----------------Added by saurav ---------------*/
    
    getGateStatus : function(component) {
        
        var action = component.get("c.getGateStatus");
        action.setParams({
            gateId:component.get("v.recordId")
            
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.gatestatus1",response.getReturnValue());
                //alert(component.get("v.gatestatus1"));
                
            }});
        $A.enqueueAction(action);
    },
    
/*----------------End saurav ---------------*/   
    
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.data");      
        
        var isDesc = (sortDirection !== 'asc');
        console.log('Inside helper.sortData::fieldName='+fieldName+' sortDirection='+sortDirection);   
        console.log('isDesc::'+isDesc);   
        
        component.set("v.sortedBy", fieldName);
    	component.set("v.sortedDirection", sortDirection);
        
        //sorts the rows based on the column header that's clicked
        
        data.sort(this.toCompare(fieldName, isDesc))        
        component.set("v.data", data);
        
		
    },
    toCompare: function (field, isDesc, primer) {
            //var key = primer ?
            //function(x) {return primer(x[field])} :
            //function(x) {return x[field]};
            var key = primer ?
            function(x) {
                return primer(x.hasOwnProperty(field) ? (typeof x[field] === 'string' ? x[field].toLowerCase() : x[field]) : '000')
            } :
            function(x) {
                return x.hasOwnProperty(field) ? (typeof x[field] === 'string' ? x[field].toLowerCase() : x[field]) : '000'
            };
        //reverse = !reverse ? 1 : -1;
        var multiplier = isDesc ? -1 : 1;
        console.log('multiplier:'+multiplier);
        
        return function (a, b) {                      
            return a = key(a), b = key(b), multiplier * ((a > b) - (b > a));
        }
    } 
})