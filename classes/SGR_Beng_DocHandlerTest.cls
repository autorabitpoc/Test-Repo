@isTest
private class SGR_Beng_DocHandlerTest{
	
@isTest static void testSaveDraft(){
	Account a = new Account();
	a.name='Luke Bengage';
	a.AccountNumber='TX090909';
	a.Line_of_business__c='Major National';
	a.HCSC_Division__c='TX';
	insert a; system.debug(a);
	Opportunity opp = new Opportunity();
	opp.name='Luke Bengage';
	opp.stagename='Renewal Planning';
	opp.Closed_Comments__c = 'XYZ';
	opp.Date_Closed__c = date.today();
	opp.CloseDate = system.today();
	opp.Requested_Effective_Date__c=Date.newInstance(2019, 2, 1);
	opp.Renewal_Date__c=Date.newInstance(2019, 2, 1);
	opp.Expected_Dental_Members__c=20;
	opp.HCSC_Division__c='TX';
	opp.County_Name__c='Collin';
	opp.Zip_Code__c='75075';
	opp.FIPS_Code__c='75075';
	opp.Account_Market_Segment__c='SG';
	opp.accountId=a.id;
	insert opp; system.debug('>>>> opp.id = ' + opp.id);
	// produce pdf file
	String pdfText = 'This is a test string';
	Blob base64PDF = blob.toPDF(pdfText);  // convert into a PDF doc file
	String fileDocInputString = EncodingUtil.base64Encode(base64PDF);  // convert Blob object into base64Encode string
	// pass to SGR_Beng_DocHandler to start testing
	SGR_Beng_DocHandler handler = new SGR_Beng_DocHandler();
	handler.oppId = opp.id;	
	handler.fileName = 'B-engaged.pdf';	
	handler.documentBase64Encoded = fileDocInputString;
	handler.saveDraft();
	List<ContentDocumentLink> docLinks = [select id from ContentDocumentLink where LinkedEntityId = :opp.id];
	System.Assert(docLinks.size()==1);
}

}