/**************************************************************************************
  Apex Class Name     : GEMS_HPS_MyPCActivitiesController
  Version             : 1.0
  Function            : This is a controller class for GEMS_HPS_MyActivities Page for showing the information of account specialist pharmacy coding tasks.
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------    
  
*************************************************************************************/
public with sharing class GEMS_HPS_MyPCActivitiesController {

    public List<Task> myTaskList {get;set;}
    public List<Event> myEventList {get; set;}
   
    public GEMS_HPS_MyPCActivitiesController() {
        try{
            populateMyActivities();
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
  
   
      /******************************************************************** 
    * Method Name    : PopulateMyActivities
    *   @description :   Method to populate active Activities on home page slider.
    *   @parameters  :   none
    *   @return type :   none                     
    ***************************************************************/  
    private void PopulateMyActivities() {
        try{
            myTaskList = new List<Task>();
            myEventList = new List<Event>();
           
           // Query All open tasks of logged in user
            for(Task taskObj : [SELECT Id, Subject, WhatId, ActivityDate, Status, Priority,GEMS_Type__c, GEMS_Start_Date__c,GEMS_End_Date__c, GEMS_Pharmacy_Scope_Code__c FROM Task WHERE OwnerId =:UserInfo.getUserId() and Subject = 'BlueStar Update' and Status != :ConstantsController.TaskStageToExclude limit 1000]){
                myTaskList.add(taskObj);
            }


        }catch(Exception e){
            System.debug( 'Exception : ' +e.getMessage() );
            throw e;
        }
    }
}