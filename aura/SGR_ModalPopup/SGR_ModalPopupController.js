({
    defaultCloseAction : function(component, event, helper) {
       // alert('confirmed');
        //alert(component.get("v.selectedRowsCount"));
        if(component.get("v.selectedRowsCount")>0){
           var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
            compEvent.setParams({
                "Confirmed" : false
            });
            compEvent.fire();
        }
        else{
            
             var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
            compEvent.setParams({
                "Confirmed" : false
            });
            compEvent.fire();
            component.destroy();
        }
    },
    doInit: function(component, event, helper) {
        var content = component.get("v.contentTxt");
        console.log('content::'+content);
        var dataList = [];
        var statusTxt = component.get('v.status-id');
        var rowTxt = component.get('v.row-id');
        
        for (var i=0;i<content.length; i++ ) {
            if(content[i] && content[i].includes(statusTxt) && statusTxt == 'Error!') {
                dataList.push({
                    flag:'e',
                    txt:content[i]
                });
            } else if (content[i] && content[i].includes(statusTxt)) {
                dataList.push({
                    flag:'s',
                    txt:content[i]
                });        
            } else if (content[i] && content[i].includes(rowTxt)) {
                dataList.push({
                    flag:'r',
                    txt:content[i]
                });                
            } 
        }
        console.log('Data list::'+dataList);
        if (dataList.length>0) {
            component.set("v.dataList",dataList);
        }
        
    },
    UpdateStatus : function(component, event, helper){
        var compEvent = $A.get("e.c:SGR_SelectedOptyEvent");
        compEvent.setParams({
            "Confirmed" : true
        });
        compEvent.fire();
    }
})