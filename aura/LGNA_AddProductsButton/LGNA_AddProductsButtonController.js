({
    init : function(cmp, event, helper) {
        cmp.set('v.mycolumns', [
            {label: 'Type', fieldName: 'Product_Type__c', type: 'Picklist'},
            {label: 'Product Name', fieldName: 'Name', type: 'text'},
            {label: 'Description', fieldName: 'Description', type: 'text Area'},
            {label: 'Category', fieldName: 'Product_Category__c', type: 'Picklist'},
            {label: 'State', fieldName: 'HCSC_State__c', type: 'Picklist'}
            
        ]);
       helper.getCustomOrderList(cmp);//load the custom order
        helper.getData(cmp);
    },
    getSelectedName: function (cmp, event) {
        // var tempIDs = [];
        var selectedRows = event.getParam('selectedRows');
        console.log("selectedRows::"+selectedRows);
        cmp.set("v.selectlist",selectedRows);
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
           // cmp.set("v.selectlist",selectedRows);
            console.log('you selected::'+selectedRows[i].Name);
          //  alert('you selected::'+selectedRows[i].Id);
        }
    },
    closeModelWindow : function(component,event,helper){
        component.set("v.showModal",false);
        component.destroy();
    },
    // Find/Search method Starting here 
    
    handleKeyUp : function(component,event,helper){
        
        var productList = component.get("v.mydataTempList");
        var keyword = component.get("v.keyword");
        var NameList =[];
        var ProductTypeList = [];
        if(keyword.length){
            var keys = Object.keys(productList);
            var nameMap = new Map();
            var productTypeMap = new Map();
            for (var i = 0; i < keys.length; i++) {
                
                var element = productList[i];
                var StringElement =JSON.stringify(element);
                var splitElement = StringElement.toString().split(",");
                //Split for Name,Map for Name and Matched Name
                var NameElementPart = splitElement[1];
                var prefinalName=NameElementPart.split(":").pop();
                var finalName  = prefinalName.substring(0, prefinalName.length-1);
                //var last  = finalName.slice(1, -1);
                var last  = finalName.slice(1,finalName.length);
                nameMap.set(last, element);
                var myReg = new RegExp(".*"+keyword + ".*$","i");
                var myMatch = last.match(myReg);
                
                if(myMatch!=null){
                    NameList.push(myMatch);
                }
                
                //Split for Decription,Map for Description and Matched Description
                //alert(splitElement);
                if(splitElement.length>1){
                 
                    var ProductTypePart = splitElement[2];
                    var preFinalDesc = ProductTypePart.split(":").pop();
                    var finalDesc = preFinalDesc.substring(0, preFinalDesc.length-1);
             
                    var lastDesc  = finalDesc.slice(1,finalDesc.length);
                    
                    //alert(lastDesc);
                    productTypeMap.set(lastDesc,element);
                    var myRegDesc = new RegExp(".*"+keyword+ ".*","i");
                    var myMatchDesc = lastDesc.match(myRegDesc);
                    if(myMatchDesc!=null){
                        ProductTypeList.push(myMatchDesc);
                    }
                }
                
            }
            
            //Map Iteration for Name
            var finalList =[]; 
            for (var [key, value] of nameMap) {
                for (var i = 0; i < NameList.length; i++) {
                    
                    if(key == NameList[i]){
                        
                        finalList.push(nameMap.get(key));
                    }
                }
            }
            //Map Iteration for ProductType
            var finalProductTypeList = [];
            for (var [key, value] of productTypeMap) {
                for (var i = 0; i < ProductTypeList.length; i++) {
                    
                    if(key == ProductTypeList[i]){
                        
                        finalProductTypeList.push(productTypeMap.get(key));
                    }
                }
            }
            //alert("finalProductList" +finalProductList);
            var finalProductList = finalList.concat(finalProductTypeList);
            var set = new Set(finalProductList);
            finalProductList = Array.from(set);
            component.set("v.productData",finalProductList);
        }   
    },
    // Search Functionality Ends here
    
    validateandAdd :function(component, event, helper){
       // alert('validate');
        var slectedlist = component.get("v.selectlist"); 
        var opprecname = component.get("v.Opportunityrecord");
        
        var currentTableMap=component.get("v.currentOppProductsMapFinal");
        var newList=component.get("v.selectlist");
        var newOpList=[];
        var oppRec=component.get("v.Opportunityrecord");
        
        for(var i=0;i<newList.length;i++){
            
            newOpList.push({'sobjectType':'Opportunity_Product__c',
                           'Product__c':newList[i].Id,
                           'Opportunity_Name__c':oppRec.Id,
                           'Record_Type_Name__c':oppRec.RecordType.Name,
                           'Product_Category__c':newList[i].Product_Type__c,
                           'Account_Product_Name__c':newList[i].Name});//temp store the opp product into account prod name, won't be saved to db
        }
    
        var isFound=false;
     
        console.log('new oplist szie::'+newOpList.length);
        
        if(newOpList.length>0){
            console.log('hello'+newOpList.length);
            
            for(var k in newOpList){
                isFound=false;
                console.log('isFound::'+isFound+"  "+k);
                
         		for(var index in currentTableMap ){
                    console.log("currentlyMap Key::"+currentTableMap[index].key+" new list Cat:"+newOpList[k].Product_Category__c);
                    
                    if(currentTableMap[index].key==newOpList[k].Product_Category__c){
                       console.log(" value:"+ currentTableMap[index].value);
                       currentTableMap[index].value.push(newOpList[k]);
                       isFound=true;
                    }
            
         	  }
                if(!isFound){//is not existing
                    console.log('add new new Section:'+newOpList[k].Product_Category__c);
                    var newOppList=[];
                    newOppList.push(newOpList[k]);
                    currentTableMap.push({value:newOppList,key:newOpList[k].Product_Category__c});
                }
            }
            component.set("v.hasData",true);
        }
         // component.set("v.currentOppProductsMapFinal", currentTableMap);  
          helper.sortCurrentTable(component,currentTableMap);
          component.set("v.showModal",false);//close the add product pop up
        
      
    },
    
    
})