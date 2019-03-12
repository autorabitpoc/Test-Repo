public class SGR_BlueStarButtonAccess {
    @AuraEnabled
    public static boolean getloggedinuserinfo(){
        boolean flag = false;
        String userId = UserInfo.getUserId();
        system.debug('++++UserId---'+userId);
        User us = [SELECT Id, Name, ProfileId, Profile.Name, UserRole.Name from User Where Id =:userId];
        List<PermissionSetAssignment> permission = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'SGR_Post_to_BlueSTAR_Permission' AND AssigneeId =:us.Id];        
        system.debug('++++permission.size()---'+permission.size());
        if(permission.size() > 0)
            flag = true;
        return flag;
        
    }

}