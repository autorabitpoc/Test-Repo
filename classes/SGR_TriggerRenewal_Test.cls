/**************************************************************************************
* Test Class Name       : SGR_TriggerRenewal_Test
* Version               : 1.0
* Function              : This class is used for testing the TriggerRenewal Apex class
* Modification Log      :
* Developer                           Date               Description
* ------------------------------------------------------------------------------------
* Keerthi Navya Poornima Motupalli   09/05/2018         Original Version 
**************************************************************************************/
@isTest
public class SGR_TriggerRenewal_Test {
    private static testmethod void chngeStatusTest1(){
        Profile prof = [select id from profile where name='SGR UW User'];
        user u1;
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
        system.debug('**uid **'+u.Id);
        system.runAs(u){
            Test.startTest();
            u1=SGR_TriggerRenewal.getloggedinuserinfo();
            system.assertEquals(u.ProfileId, u1.ProfileId);
            Test.stopTest();
            
        }
       
    }
    
}