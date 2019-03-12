/*US-13467
Author:Padmini*/
@isTest
public class SGRCountOpportunityNotes_test{    
	
static testmethod void test1(){ 
    
   //Create Opportunity 
    List<Opportunity> opList = new List<Opportunity>();
    Opportunity opp = new Opportunity(name='Test Opportunity 1',StageName='Prospecting',CloseDate= system.today()+30);
    Opportunity opp1 = new Opportunity(name='Test Opportunity 2',StageName='Prospecting',CloseDate= system.today()+60);	
    Opportunity opp2 = new Opportunity(name='Test Opportunity 3',StageName='Prospecting',CloseDate= system.today()+70);
    opList.add(opp);
    opList.add(opp1);
    opList.add(opp2);
    insert opList;   
    
    //ContentVersion creates ContentDocument data
    ContentVersion conVersion1 = new ContentVersion(Title = 'Test ContentVersionData',Description = 'Test for ContentDocument creation',PathOnClient = 'download.jpg',VersionData = Blob.valueOf('Test Content'),IsMajorVersion = true);
	insert conVersion1;
    ContentVersion conVersion2 = new ContentVersion(Title = 'Test ContentVersionData1',Description = 'Test for ContentDocument creation1',PathOnClient = 'f1.jpg',VersionData = Blob.valueOf('Test Content1'),IsMajorVersion = true);
	insert conVersion2;
    ContentVersion conVersion3 = new ContentVersion(Title = 'Test ContentVersionData2',Description = 'Test for ContentDocument creation2',PathOnClient = 'download1.jpg',VersionData = Blob.valueOf('Test Content2'),IsMajorVersion = true);
	insert conVersion3;
    ContentVersion conVersion4 = new ContentVersion(Title = 'Test ContentVersionData3',Description = 'Test for ContentDocument creation3',PathOnClient = 'download1.jpg',VersionData = Blob.valueOf('Test Content3'),IsMajorVersion = true);
	insert conVersion4;
    
    ContentVersion cVersion = [select id,Title,ContentDocumentId from ContentVersion where Id =: conVersion4.Id LIMIT 1];
    
    //ContentDocument list for CountEnhanceNotesOnBeforeDelete()
    List<ContentDocument> contentDocuments1 =[select id,Title from ContentDocument where id =:cVersion.ContentDocumentId LIMIT 1 ];
    
    //Retrieve ContentDocument data
    List<ContentDocument> contentDocuments = [select id,Title,LatestPublishedVersionId from ContentDocument];
    
    //Create ContentDocumentLink data
    List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();    
    ContentDocumentLink cdl = new ContentDocumentLink();
	cdl.LinkedEntityId = opp.id;
    if(contentDocuments.size()>0)
    {
	cdl.ContentDocumentId = contentDocuments[1].id;
    }
    cdl.shareType = 'V';
	contentDocumentLinkList.add(cdl);
    
    ContentDocumentLink cdl1 = new ContentDocumentLink();
	cdl1.LinkedEntityId = opp.id;
    if(contentDocuments.size()>0){
	cdl1.ContentDocumentId = contentDocuments[2].id;
    }
    cdl1.shareType = 'V';
	contentDocumentLinkList.add(cdl1);
    
    ContentDocumentLink cdl2 = new ContentDocumentLink();
	cdl2.LinkedEntityId = opp2.id;
    if(contentDocuments.size()>0){
	cdl2.ContentDocumentId = contentDocuments[0].id;
    }
    cdl2.shareType = 'V';
	contentDocumentLinkList.add(cdl2);    
    insert contentDocumentLinkList;   
    
    try{
    //deleting ContentDocumentLink data    
    delete cdl1;
    //deleting ContentDocument data
    delete   contentDocuments1;
    }catch(Exception e)    {
      System.debug('Exception message::'+e.getMessage());  
    }    
    
    Test.starttest();   
	SGRCountOpportunityNotes.CountEnhanceNotes(contentDocumentLinkList);
    SGRCountOpportunityNotes.CountEnhanceNotesOnBeforeDelete(contentDocuments1);
	Test.stoptest();
    }
}