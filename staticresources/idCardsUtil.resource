/********************************************************************************************************
Name        : idCardsUtil.js
Description : Javascript methods for id cards
Version History:
Date        Developer               Description
09/18/2017  Phani Kommareddy		Original Version for SFDC-4442,2835,4483 ID Cards BA/GS Associations
11/27/2017  Phani Kommareddy		SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
*******************************************************************************************************/
	var selectedBAIds = '';
    var selectedGSIds = '';
    var assignmentRadio = '';
    
    function setSelectedValues(checkID,name,assignmentType) {
            
        if(assignmentType == 'Benefit Agreement') {
            selectedIds = selectedBAIds;
        } else {
            selectedIds = selectedGSIds;
        }
        if(document.getElementById(checkID).checked) {
            if(selectedIds == '' || selectedIds.length == 0) {
                selectedIds = name;                    
            } else {
                selectedIds = selectedIds+','+name;                    
            }
        } else if(!document.getElementById(checkID).checked) {
            var commaString = ','+name;
            if(selectedIds.includes(commaString)) {
                selectedIds = selectedIds.replace(commaString,'');                    
            } else if(selectedIds.includes(name)) {
                selectedIds = selectedIds.replace(name,'');                    
            }
        }            
        if(assignmentType == 'Benefit Agreement') {
            selectedBAIds = selectedIds;
        } else {
            selectedGSIds = selectedIds;
        }
    }
    
	//SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
   	function saveAndAssignBAToCustForm(checkIssuance,submissionType) {
        var errorMessages= '';
        if(checkIssuance) {
            var issuanceTypeElementId = document.getElementById('pageId:formId:thePageBlock:pbs:issuanceTypeId');
            if(issuanceTypeElementId.value == null || issuanceTypeElementId.value == '') {
                errorMessages = errorMessages.concat('Issuance Type is a required field \n');
            } 
        }
        if(errorMessages.length == 0) {
            if(submissionType == 'ID Card Maintenance') {
                //if bas && gs is empty ask for a confirmation box
                var applicableBAsId = document.getElementById('pageId:formId:thePageBlock:pbs:applicableBAsId');
                var applicableGSsId = document.getElementById('pageId:formId:thePageBlock:pbs:applicableGSsId');
                selectedBAIds = applicableBAsId.value;
                selectedGSIds = applicableGSsId.value;
                if((applicableBAsId.value == null || applicableBAsId.value == '' ) || (applicableGSsId.value == null || applicableGSsId.value == '' )) {
                    if(!confirm("Applicable BAs and Applicable GSs data is needed, Do you want to proceed without them?")) {
                        errorMessages('Error in Applicable BAs and GSs');
                    }
                }
            } else {
                if(assignmentRadio == '' || assignmentRadio == null) {
                    checkValue('pageId:formId:assignmentTypePB:assignmentTypeId');
                } 
                var isBA = (assignmentRadio == 'Benefit Agreement') ?true:false;
                var isGS = (assignmentRadio == 'Group Section') ?true:false;
                if(isBA && (selectedBAIds == '' || selectedBAIds == ',')) {
                    errorMessages =errorMessages.concat('Please select BA \n');
                } else if(isGS && (selectedGSIds == '' || selectedGSIds == ',')) {
                    errorMessages =errorMessages.concat('Please select Group Section \n');
                }
                if(errorMessages.length > 0) 
                    alert(errorMessages);
            }
        }
        if(!errorMessages.length > 0) 
            saveAndAssignBAToCustFormCtrl(selectedBAIds,selectedGSIds);
    }    
    
    
     function checkValue(someId) {
        var theRadioButtonSet = document.getElementsByName(someId);
        for (var x = 0; x < theRadioButtonSet.length; x++) {
            if (theRadioButtonSet[x].checked) {
                assignmentRadio = theRadioButtonSet[x].value;
                updateAssignmentType(assignmentRadio);
                break;
            }
        }
    }