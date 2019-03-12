/**************************************************************************************
  Apex Class Name     : GEMS_HPS_MyCasesController
  Version             : 1.0
  Function            : This is a controller class for GEMS_HPS_MyCases Page for showing the information of current logged in user Cases.
 Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------    

*************************************************************************************/
public with sharing class GEMS_HPS_MyCasesController {
    
    public List<Case> myCasesList   {get; set;} // List of cases assigned to logged in user
    public Id medicalUWRecordTypeId {get;set;}
    public Id dentalUWRecordTypeId  {get;set;}
    
    Set<string>  statusClosed;
   
   /*************************************************
     * Method name  : HPS_MyCasesController
     * Description  : Constructor of the Controller class HPS_MyCasesController
     * Return Type  : Void
     * Parameter    : StandardController
   *************************************************/
    public GEMS_HPS_MyCasesController(){
        populateMyCases();
    }
    
   
     /*************************************************************
     * Method name  : populateMyCases
     * Description  : Method to Collect cases whose owner/case team member is logged in user in a list to populate on Page.
     * Return Type  : void
     * Parameter    : None
  ************************************************************ */
    
    private void PopulateMyCases(){
        myCasesList         = new List<Case>();
        Set<Id> accountIds  = new Set<Id>();
        Set<Id> caseIds     = new Set<Id>(); // stores Case Ids
       // Id lgnaCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LGNA - General Case').getRecordTypeId();
        try{
          // Query All case Ids of cases where case team has  logged in User as a member
            for(CaseTeamMember caseteamObj :[   SELECT  parentId, Memberid 
                                                FROM    CaseTeamMember 
                                                WHERE   Memberid =: UserInfo.getUserId() 
                                                limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ] ) {
                caseIds.add( caseteamObj.parentId );
            }
         
         // Query All cases details of case Ids queried above
            for(Case caseObj :[ SELECT  Id, AccountId, Status, Type, ownerid,Account.Name, Account.AccountNumber, HCSC_Division__c, GEMS_Submission_Type__c,sub_category__c, GEMS_Benefit_Agreement__c,CreatedDate, Days_Open__c, caseNumber
                                FROM    Case 
                                WHERE   (ownerid=: UserInfo.getUserId() ) 
                                    AND ISCLOSED = false
                                    order by Days_Open__c asc
                                limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ] ) {
                if(myCasesList.size()<10000)
                    myCasesList.add( caseObj );
            }
        } catch( Exception e ) {
              System.debug( 'Exception : ' +e.getMessage() );   
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
              ApexPages.addMessage(myMsg);
        }  
    }
   
}