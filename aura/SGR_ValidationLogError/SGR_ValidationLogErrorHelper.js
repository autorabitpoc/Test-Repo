({
  getRelatedVLList : function(component) {
        /*var action = component.get("c.getOppVLList");
		
        action.setParams(
            {
                "oppId": component.get("v.recordId"),
             
            }
        );
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                console.log('Found ' + data.length + ' VL records');
                if (data.length==0) {
                    component.set('v.err',"true");
                    component.set("v.errMsg", 'No validation Log records found for this Opportunity');
                    return;
                    
                }
                component.set("v.data", data);
               // console.log('data.length:'+data.length);
            }
            else if (state === 'ERROR') {
                component.set("v.errFlag", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	component.set('v.err',"true");
                        component.set("v.errMsg", errors[0].message);
                    } else {
                    	component.set('v.err',"true");
                        component.set("v.errMsg", 'Validation Logs could not be retreived. Unknown server error');
                    }
                }
            } else {
                component.set("v.err", true);
                component.set("v.errMsg", 'Opportunities could not be retreived. Unknow error');
            }
        });
       $A.enqueueAction(action);
   },
    
    sortData: function (component, fieldName, sortDirection) {
        
        var data = component.get("v.data");      
        
        var isDesc = (sortDirection !== 'asc');
        console.log('Inside helper.sortData1::fieldName='+fieldName+' sortDirection='+sortDirection);   
        console.log('isDesc::'+isDesc);   
        
        component.set("v.sortedBy", fieldName);
    	component.set("v.sortedDirection", sortDirection);
        
        //sorts the rows based on the column header that's clicked
   //    data.sort(this.toCompare(fieldName, isDesc)) 
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
        }*/
    } 
   
  
    
  
 })