/*
*	12/30/2018	Luke Chen		SFDC-14854 SGR-BEngaged: Post process (Displaying Draft exhibit in SGR)
*/
public with sharing class SGR_Beng_DocHandler { 
	public String fileName;
	public String documentBase64Encoded;
	public Id oppId;
	
	public void saveDraft(){
		if(fileName==null || documentBase64Encoded==null || oppId==null){system.debug('>>>>> One or more inputs is null. Please check inputs and try again');return;}
		try{
			ContentVersion conVer = new ContentVersion();
			conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
			conVer.PathOnClient = fileName; 
			conVer.Title = fileName; // Display name of the file
			// conVer.VersionData = blob.toPDF(documentBase64Encoded); // converting binary string to Blog
			conVer.VersionData = EncodingUtil.base64Decode(documentBase64Encoded);
			insert conVer;
			// First get the content document Id from ContentVersion
			Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
			//Create ContentDocumentLink
			ContentDocumentLink cDe = new ContentDocumentLink();
			cDe.ContentDocumentId = conDoc;
			cDe.LinkedEntityId = oppId; // you can use objectId,GroupId etc
			cDe.ShareType = 'V'; 
			// cDe.Visibility = 'InternalUsers';
			insert cDe;
		}catch (Exception e){
		  system.debug('Line#: '+ e.getLineNumber() + ' - SGR_Beng_DocHandler.saveDraft() exception: '+e);
		  throw e;  
		}
	}

}