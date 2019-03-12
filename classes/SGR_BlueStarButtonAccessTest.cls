@isTest
public class SGR_BlueStarButtonAccessTest {
    private static testmethod void loggedinUserTest(){
        Profile prof = [select id from profile where name='SGR UW User'];
        
        Boolean u1;
        system.debug('****'+prof);
        User u = new User(
            Alias = 'sTest', 
            Email='Tetr@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Tering1',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = prof.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='Ostusu@testorg.com'
            
        );
        List<PermissionSetAssignment> permission = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'SGR_Post_to_BlueSTAR_Permission' AND AssigneeId =:u.Id];        
        system.debug('**uid **'+u.Id);
        system.runAs(u){
            Test.startTest();
            u1=SGR_BlueStarButtonAccess.getloggedinuserinfo();
            system.assertEquals(false, u1);
            Test.stopTest();
            
        }
       
    }
    
}