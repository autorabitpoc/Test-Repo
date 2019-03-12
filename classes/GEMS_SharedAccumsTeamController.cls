/**************************************************************************************
Apex Class Name     : GEMS_SharedAccumTeamController
Version             : 1.0
Function            : This class is extension for GEMS_SharedAccumsTeamDetails
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jenny                       06/01/2018             Original Version
* Gokul Bharati               06/21/2018             SFDC-10379 GEMS: Allow only current assignee to close Shared Accums Forms
*************************************************************************************/
public class GEMS_SharedAccumsTeamController {
    
    public ID caseID{get;set;}
    public string str {get; set;}
    
    public List<selectOption> lstStatus {get; set;}
    //Collection of  the class/wrapper objects wrapperSharedAccums
    public List<wrapperSharedAccums> sharedAccumsList {get; set;}
    public GEMS_Shared_Accums__c teamMember {get; set;}
    List<GEMS_Shared_Accums__c> selectedSharedAccums {get; set;}
    
    public GEMS_SharedAccumsTeamController() {
        caseID = apexpages.currentpage().getparameters().get('id');
        str = 'New';                //Default value for Status input
        teamMember = new GEMS_Shared_Accums__c();               
        
        //Get a list of Shared Accums
        if(sharedAccumsList == NULL){
            sharedAccumsList = new List<wrapperSharedAccums>();
            for(GEMS_Shared_Accums__c s: [SELECT id, GEMS_Case__c, Name, Applicable_BAs__c,Shared_Accums_Effective_Date__c, 
                                          Accum_Period__c, Deductible__c,Out_of_Pocket__c,CreatedDate, Completion_Date__c,
                                          Status__c,Shared_Accums_Team_Member__c FROM  GEMS_Shared_Accums__c WHERE GEMS_Case__c =:caseID]) {
                                              // Create new wrapperSharedAccums object and add it to Shared Accums List
                                              sharedAccumsList.add(new wrapperSharedAccums(s)); 
                                          }
        }
        
    }
    
    //This method returns options for Status picklist
    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('New','New'));
        options.add(new SelectOption('In Progress','In Progress'));
        options.add(new SelectOption('Completed','Completed'));
        return options;
    }
    
    //Save Method for Shared Accums Teams Detail form
    public PageReference processSelected(){
        try{ 
            
            integer count = 0;//To check if at least one form is selected
            
            //Create a new list of Shared Accums and populate it with selected shared accums
            selectedSharedAccums = new List<GEMS_Shared_Accums__c>();
            
            //SFDC-10379 Form should be closed by the assigned the Team Member
            Boolean formOwnerCheck = false; 
            Id loginUserId = UserInfo.getUserId();
            //True = Super User and False = GEMS User without Super User Permission
            set<String> permissionSetNames = new set<string>{'GEMS_Permission_Set','Super_User_Permissions_GEMS'};
                Boolean checkSuperUser = GEMS_Utility.checkUserPermissionSet(loginUserId,permissionSetNames);
            //True = Sys Admin User and False = Non Sys Admin
            Boolean checkSysAdmin = GEMS_Utility.CurrentUserSysAdmin();
            
            //Populate selectedSharedAccums list with checked forms
            for(wrapperSharedAccums i:sharedAccumsList) {
                if(i.selected == true){
                    count++;
                    selectedSharedAccums.add(i.accums);
                    //SFDC-10379 Check form assigned to login user and by pass code if super User or Sys Admin
                    if(!checkSysAdmin){
                        if(!checkSuperUser){
                            if(i.accums.Shared_Accums_Team_Member__c!=NULL && i.accums.Shared_Accums_Team_Member__c!=loginUserId){
                                formOwnerCheck = true;
                            }
                        }
                    }
                }
            }
            
            if(count == 0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'No Shared Accums Form selected'));
                return null;
            }
            //SFDC-10379 Throw error when the user is not assigned to the form during status completion.
            if(formOwnerCheck && str == 'Completed' && str!=NULL){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'You must be the assigned Shared Accums Team Member to complete the Form.'));
                return null;
            }
            
            if(str == 'Completed' && teamMember.Completion_date__c == NULL ){ 
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Add Completion Date'));
                return null;
            }
            
            //perform updates on Shared Accum forms that are selected
            for(GEMS_Shared_Accums__c accums: selectedSharedAccums){
                if(str!=NULL && str == 'Completed'){
                    accums.Completion_Date__c = teamMember.Completion_date__c;  
                }
                //Cannot change status back to New once a form is in progress
                if(str == 'new' && accums.Status__c == 'In Progress'){
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot change from In Progress status to New'));
                    return null;
                }
                else{
                    accums.Status__c = str;
                }
                
                //If there is a team member assigned to a form, saving form again without a team member's name in the input field will not change the team  member on the form to null
                if(accums.Shared_Accums_Team_Member__c == NULL ||  (accums.Shared_Accums_Team_Member__c != teamMember.Shared_Accums_Team_Member__c && teamMember.Shared_Accums_Team_Member__c != NULL ))
                {
                    accums.Shared_Accums_Team_Member__c = teamMember.Shared_Accums_Team_Member__c;
                } 
            }
            update selectedSharedAccums;
            sharedAccumsList = null;
            
            return new PageReference('/'+caseId);
            
        }
        
        catch(Exception ex){
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Shared_Accums__c', null, 'GEMS_CaptureSharedAccumsController','High');     
            return null;
        }
    } 
    
    public PageReference Cancelform(){
        return new PageReference('/'+caseId);
    }
    
    //Wrapper Class for Shared Accums objects and Check boxes
    
    public class wrapperSharedAccums {
        public GEMS_Shared_Accums__c accums {get; set;}
        public Boolean selected {get; set;}
        
        public wrapperSharedAccums(GEMS_Shared_Accums__c s){
            accums = s;
            selected = false;
        }
    }
    
}