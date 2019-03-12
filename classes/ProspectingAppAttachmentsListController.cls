public with sharing class ProspectingAppAttachmentsListController {
	@AuraEnabled
    public static List<Attachment> queryAccountAttachments(Account curAccount) {
        return ProspectingAppUtilityClass.queryAccountAttachments(curAccount);
    }
}