public with sharing class ProspectingAppActivitiesListController {
	@AuraEnabled
    public static List<Note> queryAccountNotes(Account curAccount) {
        return ProspectingAppUtilityClass.queryAccountNotes(curAccount);
    }
    
    @AuraEnabled
    public static List<Task> queryAccountTasks(Account curAccount) {
        return ProspectingAppUtilityClass.queryAccountTasks(curAccount);
    }
}