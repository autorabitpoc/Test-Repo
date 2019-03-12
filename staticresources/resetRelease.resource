{!requireScript("/soap/ajax/27.0/connection.js")}

function resetRelease(caseId,firstName) {
    var subQuery = "select Status,GEMS_Ready_to_release_to_screening__c,Is_screening_case_creation_is_in_progres__c from case where type = 'Account Submission' and id = '"+caseId+"' limit 1"; 
    var subCaseResult = sforce.connection.query(subQuery); 
    var subCaseRecords = subCaseResult.getArray("records"); 
    
    if(subCaseRecords[0].Status == 'Cancelled') {
        alert('Hey '+firstName+'- Cancelled case cannot be Reset'); 
    } else if(subCaseRecords[0].GEMS_Ready_to_release_to_screening__c == 'Ready to Release'  && subCaseRecords[0].Is_screening_case_creation_is_in_progres__c == 'false') { 
    	alert('Hey '+firstName +' - Did you notice the case is already in \'Ready to Release\' ?');         
    } else if(subCaseRecords[0].GEMS_Ready_to_release_to_screening__c != 'Released' && subCaseRecords[0].Is_screening_case_creation_is_in_progres__c == 'false') {
        alert('Hey '+firstName+' - \"'+subCaseRecords[0].GEMS_Ready_to_release_to_screening__c+'"\ case cannot be Reset');
    } else if(subCaseRecords[0].GEMS_Ready_to_release_to_screening__c == 'Released' || subCaseRecords[0].Is_screening_case_creation_is_in_progres__c != 'false') {
        var countQuery = "select id from case where type not in ('GET','Account Submission','Account Structure','Request Resource','Request Implementer') and (gems_account_submission_info__c = '"+caseId+"') order by caseNumber asc";
        var caseCount = sforce.connection.query(countQuery);
        var caseCountSize = caseCount.size;
        var batches = Math.ceil(caseCountSize/200);
        var timeSeconds = batches*9;
        var confirmSelection;
        if(caseCountSize==0)
            confirmSelection = confirm('Hey '+firstName+' - No Case deletion, just resetting the case creation flags');
        else
        	confirmSelection = confirm('<<<<WARNING>>>> \n\nHey '+firstName+' - You are about to \"DELETE\" cases under submission case except for categories - GET,Account Structure, Request Resource and Request Implementer. \n\nCases to be deleted: '+ caseCountSize + '\n\nEstimated Wait Time to Complete: '+timeSeconds+'s \n\nWe advise you to wait and NOT perform any actions, until the complete message. Do you want to proceed?');
        if (confirmSelection == true) {
            var batchIterator;
            for(batchIterator=0;batchIterator<batches;batchIterator++) {
                var deletionQuery = "select id from case where type not in ('GET','Account Submission','Account Structure','Request Resource','Request Implementer') and (gems_account_submission_info__c = '"+caseId+"') order by caseNumber asc limit 200";
                var allCases = sforce.connection.query(deletionQuery);
                var allRecords = allCases.getArray("records");
                var recordIds = [];
                for (var i = 0; i < allRecords.length; i++) {
                    recordIds.push(allRecords[i].Id);
                }
                sforce.connection.deleteIds(recordIds);
            }
            var subCase = new sforce.SObject('Case');
            subCase.id = caseId;
            subCase.GEMS_Ready_to_release_to_screening__c = 'Ready to Release';
            subCase.Is_screening_case_creation_is_in_progres__c = false;
            result = sforce.connection.update([subCase]);
            alert('Completed. Case is now \"Ready to Release\". \n\n Please wait while we refresh the page...');
            refreshPage(caseId);
        } 
    } 
    
}

function refreshPage(caseId) {
    var currentURL = "/"+caseId;
    top.location.href = currentURL;
}