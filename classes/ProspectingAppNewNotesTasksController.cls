public with sharing class ProspectingAppNewNotesTasksController {
	@AuraEnabled
    public static void saveNote(Note newNote) {
        upsert newNote;
    }
    
    @AuraEnabled
    public static void saveTask(Task newTask) {
        upsert newTask;
    }
    
    @AuraEnabled 
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) {
        return ProspectingAppUtilityClass.getPicklistValues(ObjectApi_name, Field_name);
    }
}