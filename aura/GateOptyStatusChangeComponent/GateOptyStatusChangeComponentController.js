({
    doInit : function(component, event, helper) {
        helper.initializeRecords(component,event);
        /*var action = component.get("c.getOptyList");
        action.setParams({"GateId":"a4E4D0000003qrMUAQ"});//component.get("v.recordId")
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.optyList",result.getReturnValue());   
            }
        });
        $A.enqueueAction(action);*/
    },
    ProcessAllOptys :function(component, event, helper) {
        var getID = component.get("v.optyList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkOpty = component.find("checkOpty"); //checkOpty
        if(checkvalue == true){
            for(var i=0; i<checkOpty.length; i++){
                checkOpty[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkOpty.length; i++){
                checkOpty[i].set("v.value",false);
            }
        }
    },
    HandleSelOpty:function(component, event, helper) {
        var filtersmap = event.getParam("SelectedOptys");
        var idList=[];//component.get("v.SelectedOptyIds");
        
        for(var i=0;i<filtersmap.length;i++){
            idList.push(filtersmap[i].Id);
        }
        component.set("v.SelectedOptyIds",idList);
        helper.initializeRecords1(component,event);
    },
    //Process the selected contacts
    handleSelectedOptys: function(component, event, helper) {
        if(confirm("Are you sure you want to Release selected Opportunity?")){
            var OptyList = component.get("v.optyList");
            var isSelectAll = component.get("v.isSelectAll");
            
            //var selectedOptys = [];
            
            /*if(isSelectAll){
                selectedOptys = OptyList;
            }
            else{
                var k = 0;
                for (var i=0; i<OptyList.length; i++){
                    var c = OptyList[i];
                    if(c.isSelected) {
                        selectedOptys[k] = c;
                        k++; 
                    }     
                }
            }*/
            
            if(component.get("v.SelectedOptys").length > 0){
                //var OptyRecords = JSON.stringify(selectedOptys);
                var action = component.get("c.processSelectedOptys");
                action.setParams({
                    SelOptyRecords : component.get("v.SelectedOptys")
                });
                action.setCallback(this, function(result){
                    //alert(result.getReturnValue());
                    var state = result.getReturnValue();
                    if (state){
                        //alert('Status updated');
                        helper.initializeRecords(component,event);
                        component.set("v.SelectedOptys",result.getReturnValue());
                    }
                    else{
                        alert('Error while updating.');
                    }
                });
                //this.doInit(component,event);
                $A.enqueueAction(action);
            }
            else {
                alert('Please select at least one opportunity');
            }
            
        }
        
    }
})