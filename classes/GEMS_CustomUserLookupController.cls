public with sharing class GEMS_CustomUserLookupController {

    public String getTextBox() {
        return null;
    }


    public String getFormTag() {
        return null;
    }


    public String getResults() {
        return null;
    }


    public PageReference Search() {
        userList=runSearch(searchString);
        System.debug('===searchString===='+searchString);
        return null;
    }



  public List<User> userList{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public String userId {set;get;}
  public String caseid;
  public Case casechild;
List<Case> caselist;

  public GEMS_CustomUserLookupController() {
  
    caseid = System.currentPageReference().getParameters().get('id');
    caselist =[select id,status,GEMS_Peer_Review__c  from case where parentid=:caseid];
 
  }
  

  
  public void updateCase() {
    System.debug('+++usrid+'+userId );
  
  if(caseid!= null && caseid != '') {
      for(case casechild:caselist){
      casechild.GEMS_Peer_Review__c = userId ;
      }
      update caselist;
  }
  }

  // run the search and return the records found. 
  private List<User> runSearch(string searchString) {

    String soql = 'select id, name,userrole.name from user';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where isactive = true and name LIKE \'%' + searchString +'%\'';
    //soql = soql + ;
    System.debug(soql);
    return database.query(soql); 

  }



}