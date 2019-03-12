/**************************************************************************************
* Apex Class Name       : SGR_TriggerRenewal
* Version               : 1.0
* Function              : Apex class for TriggerRenewal component that checks the loggedin Uses Profile
* Modification Log      :
* Developer                           Date               Description
* ------------------------------------------------------------------------------------
* Keerthi Navya Poornima Motupalli   09/06/2018        Original Version 
***************************************************************************************/

public class SGR_TriggerRenewal{
    @AuraEnabled
    public static user getloggedinuserinfo(){
        String users = UserInfo.getUserId();
        User us = [SELECT Id, Name, ProfileId, Profile.Name, UserRole.Name from User Where Id =:users];
        system.debug('++++logged in user---'+us);
        return us;
        
    }
}