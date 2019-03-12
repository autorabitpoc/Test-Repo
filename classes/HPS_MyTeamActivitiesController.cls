/********************************************************************************************
* Apex Class Name     : HPS_MyTeamActivitiesController
* Version             : 1.0
* Function            : This is a controller class for HPS_MyTeamActivities Page for showing 
*                       the information of tasks and events of those managed by current user.
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------    
* Zachary Campbell    :       Sepetember 2016        Original Version
********************************************************************************************/
public with sharing class HPS_MyTeamActivitiesController {

    public Set<ID> teamUserIds {get;set;}
    public List<Task> myTeamTaskList {get;set;}
    public List<Event> myTeamEventList {get;set;}
   
    /******************************************************************** 
    * Method Name    : HPS_MyTeamActivitiesController
    *   @description :   controller of class.
    *   @parameters  :   none
    *   @return type :   none                     
    ***************************************************************/  
    public HPS_MyTeamActivitiesController() {
        try{
            populateMyTeamsActivities();
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }

    /***************************************************************************** 
    * Method Name    : PopulateMyTeamsActivities
    *   @description :   Method to populate active Activities on home page slider.
    *   @parameters  :   none
    *   @return type :   none                     
    ******************************************************************************/  
    private void populateMyTeamsActivities(){
        try{
            teamUserIds = new Set<Id>();
            myTeamTaskList = new List<Task>();
            myTeamEventList = new List<Event>();
            
            for( User userObj :[    SELECT  Id 
                                    FROM    User 
                                    WHERE   ManagerId = :UserInfo.getUserId() 
                                    limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ] ) {
                teamUserIds.add( userObj.Id );
            }
            
           // Get all the users who are 2 level below the current login user
            teamUserIds.addAll(ConstantsController.getAllSubordinateUsers(teamUserIds));
            
           // Query all open tasks of users managed by logged in user
            for( Task taskObj : [   SELECT Id, Subject, WhatId, ActivityDate, Status, Priority 
                                    FROM   Task 
                                    WHERE  (OwnerId = :UserInfo.getUserId() OR OwnerId IN :teamUserIds) 
                                    AND    Status != :ConstantsController.TaskStageToExclude limit 1000]){
                myTeamTaskList.add( taskObj );
            }
            
           // Query all open events of users managed by logged in user
            for(Event eventObj : [  SELECT Id, Subject, WhatId, ActivityDate 
                                    FROM   Event  
                                    WHERE  (OwnerId = :UserInfo.getUserId() 
                                    OR     OwnerId IN :teamUserIds) 
                                    AND    ActivityDate >= :date.Today() limit 1000]){
                myTeamEventList.add(eventObj);
            }
        }
        catch(Exception e){
            System.debug( 'Exception : ' +e.getMessage() );
            throw e;
        }
    }
}