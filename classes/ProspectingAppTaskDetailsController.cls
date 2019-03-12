public with sharing class ProspectingAppTaskDetailsController {
    @AuraEnabled
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) {
        return ProspectingAppUtilityClass.getPicklistValues(ObjectApi_name, Field_name);
    } 
    
	@AuraEnabled
    public static void updateTask(Task curTask) {
        update curTask;
    }
}