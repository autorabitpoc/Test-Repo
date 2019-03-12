public with sharing class GEMS_CustomCaseLookupController {

    public GEMS_CustomCaseLookupController(ApexPages.StandardController controller) {

    }


  public List<GEMS_Benefit_Agreement__c> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public Id caseId {get;set;}
  Case caserecord;
  Public string urlstring;
  Public integer casepos;
  Public integer casenewpos;
  public string TextBox{set;}

  public GEMS_CustomCaseLookupController() {
  
  try {

    searchString = System.currentPageReference().getParameters().get('lksrch');
    caseid = System.currentPageReference().getParameters().get('caseId');
    urlstring = System.currentPageReference().getUrl();
    System.debug('Binod+++');
    System.debug('URLstring+++' + urlstring);
    casepos=Urlstring.indexOf('caseId',0);
    system.debug('Casepos+++'+Casepos);
    casenewpos = casepos + 9;
   
    caseid=Urlstring.mid(casenewpos,15);     
    
    System.debug('Case id+++++' + caseId);
    
    caserecord=[select id from case where parentid=:caseid and recordtype.name='GEMS Account Structure' LIMIT 1 ];
    System.debug('Case record id id+++++' + caserecord.id);
    System.debug('searchStr+++++' +searchString );
    results = [select id,name,Product__r.Name from GEMS_Benefit_Agreement__c where AccountStructureCase__c =:caserecord.id];
    //runSearch();  
  }
  Catch(Exception ex){
      System.debug('+++Exception+++'+ex.getMessage());
  }
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
 @TestVisible private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  @TestVisible private List<GEMS_Benefit_Agreement__c> performSearch(string searchString) {
  List<GEMS_Benefit_Agreement__c>  baList;
      if(searchString == null || searchString == '') return null;
    try {
    String soql = 'select id,name,Product__r.Name from GEMS_Benefit_Agreement__c';
    if(searchString != '' && searchString != null)
     soql = soql + ' where AccountStructureCase__c ='+'\''+caserecord.id+'\'' +'and name LIKE \'%' + searchString +'%\'';
    //soql = soql + ' limit 25';
    System.debug(soql);
    baList =database.query(soql); 
    }
    catch(Exception ex) {
        System.debug('===exception==='+ex.getMessage());
        return null;
    }
    return baList;

  }


  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
      System.debug('====form====='+System.currentPageReference().getParameters().get('frm'));

    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
  String textid = System.currentPageReference().getParameters().get('txt').split(' ')[0];
  System.debug('==Stringtextid==='+textid);
  System.debug('====txt===='+System.currentPageReference().getParameters().get('txt'));
    return textid ;
  }

}