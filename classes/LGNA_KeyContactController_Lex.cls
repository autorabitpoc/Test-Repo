/********************************************************************************************
* Apex Class Name     : KeyContactController
* Version             : 1.0
* Function            : This is a Controller class for Key Contacts Lightning Component. 
* Created Date        : 08/30/2017
* Modification Log    :
*-------------------------------------------------------------------------------------------
********************************************************************************************/
public class LGNA_KeyContactController_Lex{
    public List<AccountContactRole> accountContactRoleList {get; set;}
    public list<TeamMemberWrapper> teamMembersList{get;set;}
    public List<AccountTeamMember> accountTeamMemberList {get; set;}
    public List<Account_Team_Non_SF__c> accountTeamMemberNonSFList {get; set;}
    public List<AccountContactRole> primaryContactList{get; set;}
    public Id accountId {get; set;}
    
    // Standard cController
    public LGNA_KeyContactController_Lex(ApexPages.standardController stdController) {
        try{
            accountTeamMemberList = new list<AccountTeamMember>();
            accountTeamMemberNonSFList = new list<Account_Team_Non_SF__c>();
            accountId = ApexPages.currentPage().getParameters().get('id');
             system.debug('accid'+accountId);
            accountContactRoleList = new List<AccountContactRole>();
            
            accountContactRoleList = [SELECT Contact.Email, Contact.Phone, Contact.Name, Role, Contact.PhotoUrl, AccountId FROM AccountContactRole WHERE AccountId =:accountId];
            primaryContactList = [SELECT Contact.Email, Contact.Phone, Contact.Name, Role, Contact.PhotoUrl, AccountId FROM AccountContactRole WHERE AccountId =:accountId and IsPrimary=true];
            teamMembersList = new list<TeamMemberWrapper>();
            
            list<AccountTeamMember> tempList1 = [SELECT TeamMemberRole, UserId, User.Name FROM AccountTeamMember WHERE AccountId=:accountId ];
            list<Account_Team_Non_SF__c> tempList2 = [SELECT Member_Role__c, Account_Name__c, Team_Member_Name__c, Team_Member_Name__r.Name FROM Account_Team_Non_SF__c WHERE Account_Name__c =:accountId];
           // system.debug('team role'+tempList1);
            for(Team_Member_360Views__c atm : [select Team_Role_Name__c,Sort_Order__c from Team_Member_360Views__c 
                                                where Account_Record_Types__c = 'Group_Account' 
                                                order By Sort_Order__c]){
                for(AccountTeamMember temp : tempList1){
                    //system.debug('team role'+atm.Team_Role_Name__c);
                    //  system.debug('team'+temp.TeamMemberRole);
                    if(atm.Team_Role_Name__c == temp.TeamMemberRole){
                        accountTeamMemberList.add(temp);
                        teamMembersList.add(new TeamMemberWrapper(atm.Team_Role_Name__c,temp.User.Name,temp.UserId));
                    }
              }
              // system.debug('team role'+tempList2);
                for(Account_Team_Non_SF__c temp : tempList2){
                    //system.debug('team role'+atm.Team_Role_Name__c);
                   // system.debug('team'+temp.Member_Role__c);
                    if(atm.Team_Role_Name__c == temp.Member_Role__c){
                        accountTeamMemberNonSFList.add(temp);
                        teamMembersList.add(new TeamMemberWrapper(atm.Team_Role_Name__c,temp.Team_Member_Name__r.Name,temp.Team_Member_Name__c));
                    }
                }
            }
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            System.debug( 'Exception : ' +e.getMessage() ); 
        }
    
    }
    
    public class TeamMemberWrapper{
        public string teamRoleName{get;set;}
        public string teamMemberName{get;set;}
        public string teamMemberId{get;set;}
        public TeamMemberWrapper(string teamRole,String memberName,String memberId){
            teamRoleName        = teamRole;
            teamMemberName      = memberName;
            teamMemberId        = memberId;
        }
    }
    
  }