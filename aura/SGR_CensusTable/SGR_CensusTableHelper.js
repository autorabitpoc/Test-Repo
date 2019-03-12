({
    fireEvent : function(component, eventData) {
        var compEvent = component.getEvent("censusTableEvent");
        compEvent.setParams({"data" : eventData});
        compEvent.fire();
    },

    setTotals : function(component) {
        var helper = this;
        var data = component.get("v.displayData");
        var totalSubscribers = helper.countData(data, true);
        var totalMembers = helper.countData(component.get("v.data"), false);
        component.set("v.totalSubscribers", totalSubscribers);
        component.set("v.totalMembers", totalMembers);
    },

    countData : function(data, subscriberOnly) {
        var result = 0;
        if(subscriberOnly){
            data.forEach(function (row) {
                if(row.Relationship__c === 'Subscriber'){
                    result++;
                }
            });
        }else{
            result = Object.keys(data).length;
        }
        return result;
    },

    filterData : function(data) {
        var result = [];
        data.forEach(function (row) {
            if(row.Relationship__c === 'Subscriber'){
                result.push(row);
            }
        });
        return result;
    }
})