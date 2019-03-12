/**************************************************************************************
  Apex Class Name     : HPS_MyActivitiesController
  Version             : 1.0
  Function            : This is a controller class for HPS_MyActivities Page for showing the information of current logged in user tasks and events.
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------    
  Dinesh           :       March                    Original Version
  mayuri           :       June                     Updated Code comments
  ketki            :       June 2017                Code added to display case account name and case status associated with task
*************************************************************************************/
public with sharing class HPS_MyActivitiesController {

    public List<Event> myEventList {get; set;}
    public List<TaskExtension> TaskExtensionList{get;set;}
    
    public  class TaskExtension{
        public Task mytask{get;set;} 
        public String accountName{get;set;} 
        public String caseStatus{get;set;} 
    }
    
    
    /******************************************************************** 
    * Method Name    : HPS_MyActivitiesController
    *   @description :   controller of class.
    *   @parameters  :   none
    *   @return type :   none                     
    ***************************************************************/  
    public HPS_MyActivitiesController() {
        try{
            populateMyActivities();
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
   
   
    /******************************************************************** 
    * Method Name    : offset
    *   @description :   Method to format timezone for logged in user.
    *   @parameters  :   none
    *   @return type :   none                     
    ***************************************************************/  
  
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    
    
    /******************************************************************** 
    * Method Name    : PopulateMyActivities
    *   @description :   Method to populate active Activities on home page slider.
    *   @parameters  :   none
    *   @return type :   none                     
    ***************************************************************/  
    private void PopulateMyActivities() {
        try{
            myEventList = new List<Event>();
            List<Id> caseId=new List<Id>();
            List<Id> pharmacyCdId=new List<Id>();
            TaskExtensionList = new List<TaskExtension>();
            List<Task> taskList= [SELECT Id, Subject, WhatId, GEMS_Start_Date__c, Status, Priority 
                                        FROM Task WHERE OwnerId =:UserInfo.getUserId() and isClosed = false limit 1000];
                                            // Status != :ConstantsController.TaskStageToExclude limit 1000];
                                            // Task.IsClosed =false
           // Query All open tasks of logged in user
            for(Task taskObj : taskList){              
                    TaskExtension  tr = new TaskExtension();
                    tr.mytask=taskObj ;
                    if(taskObj.WhatId.getSObjectType() ==Schema.getGlobalDescribe().get('Case') )
                        caseId.add(taskObj.WhatId);
                    if(taskObj.WhatId.getSObjectType() ==Schema.getGlobalDescribe().get('GEMS_Pharmacy_Scope_Code__c') )
                        pharmacyCdId.add(taskObj.WhatId);
                         TaskExtensionList.add(tr);
            }
           //get case associated with open tasks
           List<Case> myCaseList = [SELECT Id,Account.Name,Status FROM case where Id IN :caseId];
           
           //get pharmacy scope code associated with open tasks
           List<GEMS_Pharmacy_Scope_Code__c > myPharmacyCaseList = [SELECT Id,Case__r.Account.Name,Case__r.Status FROM GEMS_Pharmacy_Scope_Code__c where Id IN :pharmacyCdId];
           
            for(TaskExtension r: TaskExtensionList){
            
                  if(r.mytask.WhatId.getSObjectType() ==Schema.getGlobalDescribe().get('Case') )
                  {
                  
                      for(Case c: myCaseList)
                       {
                            if ( r.mytask.whatID == c.ID)
                            {
                                r.accountName= c.account.name;
                                r.caseStatus= c.status;
                                break;
                            }
                        }
                    }     
                  if(r.mytask.WhatId.getSObjectType() ==Schema.getGlobalDescribe().get('GEMS_Pharmacy_Scope_Code__c') )
                  {
                  
                         for(GEMS_Pharmacy_Scope_Code__c p: myPharmacyCaseList )
                        {
                            if ( r.mytask.whatID == p.ID)
                            {
                                r.accountName= p.Case__r.Account.Name;
                                r.caseStatus= '';
                                break;
                            }
                        }
                   }
               }
               
           
            
               
           // Query All open Eventsof logged in user
            for(Event eventObj : [SELECT Id, Subject, WhatId, ActivityDate FROM Event WHERE OwnerId =:UserInfo.getUserId() and ActivityDate >= :date.Today() limit 1000]){
                myEventList.add(eventObj);
            }
        }catch(Exception e){
            System.debug( 'Exception : '+e.getMessage() );
            throw e;
        }
    }
}