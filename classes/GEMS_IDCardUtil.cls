/**************************************************************************************
* Apex Class Name       : GEMS_IDCardUtil
* Version               : 1.0
* Function              : Utility Class with common methods for ID Cardforms
* Modification Log      :
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version 
*************************************************************************************/
public class GEMS_IDCardUtil {
    
	//Assignment Types for front end selections
    public static List<SelectOption> getAssignmentItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Benefit Agreement','Benefit Agreement'));
        options.add(new SelectOption('Group Section','Group Section'));
        return options;
    }
    
    
    //convert GEMS_Custom_ID_Request_Form__c to GEMS_IDCompare object
    public static List<GEMS_IDCompare> CopyCustomIDFormToIDCompare(List<GEMS_Custom_ID_Request_Form__c> customIDFormList) {
        List<GEMS_IDCompare> idCompareList = new List<GEMS_IDCompare>();
        for(GEMS_Custom_ID_Request_Form__c item : customIDFormList) {
           idCompareList.add(new GEMS_IDCompare(item.id,item.Applicable_BAs__c,item.Applicable_GSs__c,item.Assignment_Type__c));
        }
        return idCompareList;
    }
    
    //convert GEMS_IDCompare object to GEMS_Custom_ID_Request_Form__c with help of oldMap
    public static List<GEMS_Custom_ID_Request_Form__c> copyIDCompareToCustomIDForm(List<GEMS_IDCompare> idcompareList,Map<ID, GEMS_Custom_ID_Request_Form__c> oldMap) {
        List<GEMS_Custom_ID_Request_Form__c> customIDList = new List<GEMS_Custom_ID_Request_Form__c>();
        for(GEMS_IDCompare idCompareItem : idcompareList) {
            GEMS_Custom_ID_Request_Form__c customIDForm = oldMap.get(idCompareItem.formId);
            customIDForm.Applicable_BAs__c = idCompareItem.applicableBAs;
            customIDForm.Applicable_GSs__c = idCompareItem.applicableGSs;
            customIDForm.Assignment_Type__c = idCompareItem.assignmentType;
            customIDList.add(customIDForm);
        }
        return customIDList;
    }
    
    //convert GEMS_Prospective_ID_Card__c to GEMS_IDCompare object
    public static List<GEMS_IDCompare> CopyProspectiveIDFormToIDCompare(List<GEMS_Prospective_ID_Card__c> prospectiveIDFormList) {
        List<GEMS_IDCompare> idCompareList = new List<GEMS_IDCompare>();
        for(GEMS_Prospective_ID_Card__c item : prospectiveIDFormList) {
           idCompareList.add(new GEMS_IDCompare(item.id,item.Applicable_BAs__c,item.Applicable_GSs__c,item.Assignment_Type__c));
        }
        return idCompareList;
    }
    
    //convert GEMS_IDCompare object to GEMS_Prospective_ID_Card__c with help of oldMap
    public static List<GEMS_Prospective_ID_Card__c> copyIDCompareToProspectiveIDForm(List<GEMS_IDCompare> idcompareList,Map<ID, GEMS_Prospective_ID_Card__c> oldMap) {
        List<GEMS_Prospective_ID_Card__c> prospectiveIDList = new List<GEMS_Prospective_ID_Card__c>();
        for(GEMS_IDCompare idCompareItem : idcompareList) {
            GEMS_Prospective_ID_Card__c prospectiveIDForm = oldMap.get(idCompareItem.formId);
            prospectiveIDForm.Applicable_BAs__c = idCompareItem.applicableBAs;
            prospectiveIDForm.Applicable_GSs__c = idCompareItem.applicableGSs;
            prospectiveIDForm.Assignment_Type__c = idCompareItem.assignmentType;
            prospectiveIDList.add(prospectiveIDForm);
        }
        return prospectiveIDList;
    }
    
    
     //convert GEMS_ID_Card_Suppression__c to GEMS_IDCompare object
    public static List<GEMS_IDCompare> CopySuppressionIDFormToIDCompare(List<GEMS_ID_Card_Suppression__c> suppressionIDFormList) {
        List<GEMS_IDCompare> idCompareList = new List<GEMS_IDCompare>();
        for(GEMS_ID_Card_Suppression__c item : suppressionIDFormList) {
           idCompareList.add(new GEMS_IDCompare(item.id,item.Applicable_BAs__c,item.Applicable_GSs__c,item.Assignment_Type__c));
        }
        return idCompareList;
    }
    
    //convert GEMS_IDCompare object to GEMS_ID_Card_Suppression__c with help of oldMap
    public static List<GEMS_ID_Card_Suppression__c> copyIDCompareToSuppressionIDForm(List<GEMS_IDCompare> idcompareList,Map<ID, GEMS_ID_Card_Suppression__c> oldMap) {
        List<GEMS_ID_Card_Suppression__c> suppressionIDList = new List<GEMS_ID_Card_Suppression__c>();
        for(GEMS_IDCompare idCompareItem : idcompareList) {
            GEMS_ID_Card_Suppression__c suppressionIDForm = oldMap.get(idCompareItem.formId);
            suppressionIDForm.Applicable_BAs__c = idCompareItem.applicableBAs;
            suppressionIDForm.Applicable_GSs__c = idCompareItem.applicableGSs;
            suppressionIDForm.Assignment_Type__c = idCompareItem.assignmentType;
            suppressionIDList.add(suppressionIDForm);
        }
        return suppressionIDList;
    }
    
    
    //method updates old selections of BAs and GSs with new selections
    public static List<GEMS_IDCompare> updateExistingAssignments(GEMS_CustomFormInput customFormInput) {
        List<GEMS_IDCompare> compareFormUpdateList = new List<GEMS_IDCompare>();
        Id formId = customFormInput.formId;
        String assignmentType = customFormInput.assignmentType;
        String baCaseNums = customFormInput.baCaseNums;
        String gsCaseNums = customFormInput.gsCaseNums;
        List<GEMS_IDCompare> compareList = customFormInput.idCompareList;         
        List<String> newBAs = baCaseNums.split(',');
        List<String> newGSs = gsCaseNums.split(',');
        List<String> newEntries = new List<String>();
        String newAssignmentType = assignmentType;
        
        for(GEMS_IDCompare compareForm: compareList){
			String oldAssignmentType = compareForm.assignmentType;
            if(oldAssignmentType != newAssignmentType) {
                continue;
            }
            String oldEntries = '';
            String oldBAs = compareForm.applicableBAs;
            String oldGSs = compareForm.applicableGSs;
            if(newAssignmentType == 'Benefit Agreement') {
                oldEntries = oldBAs;
                newEntries = newBAs;
            } else {
                oldEntries = oldGSs;
                newEntries = newGSs;
            }
            if(!String.isEmpty(oldEntries)) {
                List<String> oldEntriesList = oldEntries.split(',');
                integer oldListSize =  oldEntriesList.size();
                List<integer> removeEntries = new List<integer>();
                for(String newEntry : newEntries) {
                    integer index = 0;
                    while(index < oldListSize) {
                        String oldEntry = oldEntriesList.get(index);
                        if(oldEntry == newEntry && compareForm.formId != formId) {
                            removeEntries.add(index);                                           
                        }
                        index++;
                    }
                }                
                //sort and reverse list for deletion
                removeEntries.sort();
                List<integer> removeFinalList = new List<integer>();
                for(integer i = removeEntries.size()-1; i>=0;i--) {
                    removeFinalList.add(removeEntries.get(i));
                }
                
                //remove value from current customform
                for(integer i : removeFinalList) {
                    oldEntriesList.remove(i);                
                }
                
                if(newAssignmentType == 'Benefit Agreement') {
                	compareForm.applicableBAs = String.join(oldEntriesList,',');
                    compareForm.applicableGSs = '';
                } else {
                    compareForm.applicableBAs = '';
                    compareForm.applicableGSs = String.join(oldEntriesList,',');
                }
                compareForm.assignmentType = newAssignmentType;
                compareFormUpdateList.add(compareForm);
            }
        }
        return compareFormUpdateList;
    }    
}