({  
    typeaheadInitStatus : {},
    
    typeaheadOldValue : {},
    
    cb : null,
    
    createTypeaheadComponent: function(component, helper){
        var self = this;
        var globalId = component.getGlobalId();
        //loading libraries sequentially
        var inputElement = jQuery('[id="'+globalId+'_typeahead"]');
        
        //inits the typeahead
        inputElement.typeahead({
            hint: true,
            highlight: true,
            minLength: 2,
        },
        {
        	name: 'objects',
            display: 'value',
            source: function(q,cb) {
                cb(component.get('v.resultList'));
            }
         })
        //selects the element
        .bind('typeahead:selected', 
			function(evnt, suggestion){
    	        component.set('v.recordId', suggestion.id);
                component.set('v.nameValue', suggestion.value);
                
                var compEvent = component.getEvent("updateInfo");
				compEvent.setParams({"uniqueName" : component.get('v.uniqueName'),
                                     "sobjectType" : component.get('v.sobjectType'),
                                     "recordId" : component.get('v.recordId')
                                    });
                compEvent.fire();
	        });
    },
    
    /*
     * Searches objects (server call)
     */
    searchAction : function(component, q){
        if(!component.isValid() || q.length<2) return;
        
        q = (q || "").replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
        var self = this;
        var action = component.get("c.searchSObject");
        action.setParams({
            "type" : component.get("v.sobjectType"),
            "searchString" : q,
            "filter" : component.get("v.filter")
        });

        action.setCallback(this, function(a) {
            if(a.error && a.error.length){
                return $A.error('Unexpected error: '+a.error[0].message);
            }
            var result = a.getReturnValue();
            var matches, substrRegex;
            
            // an array that will be populated with substring matches
            var matches = [];
            
            // regex used to determine if a string contains the substring `q`
            var substrRegex = new RegExp(q, 'i');
            var strs = JSON.parse(result);
            
            // iterate through the pool of strings and for any string that
            // contains the substring `q`, add it to the `matches` array
            jQuery.each(strs, function(i, str) {
                if (substrRegex.test(str.value)) {
                    // the typeahead jQuery plugin expects suggestions to a
                    // JavaScript object, refer to typeahead docs for more info
                    matches.push({ value: str.value , id: str.id});
                }
            });
            if(!strs || !strs.length){
                component.set('v.recordId', null);
            }
            
            component.set('v.resultList', matches);
        });
        $A.enqueueAction(action);
    },
    
    loadValue : function(component, helper, skipTypeaheadLoading){
        this.typeaheadOldValue[component.getGlobalId()] = component.get('v.recordId');
        var action = component.get("c.getCurrentValue");
        var self = this;
        action.setParams({
            'type' : component.get('v.sobjectType'),
            'value' : component.get('v.recordId'),
        });
        
        action.setCallback(this, function(a) {
            if(a.error && a.error.length){
                return $A.error('Unexpected error: '+a.error[0].message);
            }
            var result = a.getReturnValue();
            component.set('v.isLoading',false);
            component.set('v.nameValue',result);
            if(!skipTypeaheadLoading) self.createTypeaheadComponent(component, helper);
        });
        $A.enqueueAction(action);
    },
    
    loadFirstValue : function(component, helper) {
        //this is necessary to avoid multiple initializations (same event fired again and again)
        if(this.typeaheadInitStatus[component.getGlobalId()]){ 
            return;
        }
        this.typeaheadInitStatus[component.getGlobalId()] = true;
        this.loadValue(component, helper, false);
    }
})