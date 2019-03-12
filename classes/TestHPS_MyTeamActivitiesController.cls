/**************************************************************************************
* Apex Class Name     : TestHPS_MyTeamActivitiesController
* Version             : 1.0
* Function            : This is a test class for HPS_MyTeamActivitiesController.
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Zachary Campbell			  September 2016         Original version
*************************************************************************************/
@isTest
public class TestHPS_MyTeamActivitiesController {

    static testMethod void myUnitTest() {
        try{
           // Create test manager and employees. 
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u1 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev1@user.com', 'testUser1', 'test1@user.com');
            User u2 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev2@user.com', 'testUser2', 'test2@user.com');
            User u3 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev3@user.com', 'testUser3', 'test3@user.com');
            User u4 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev4@user.com', 'testUser4', 'test4@user.com');
            u2.ManagerId = u1.Id;
            u3.ManagerId = u1.Id;
            u4.ManagerId = u1.Id;
            update u2;
            update u3;
            update u4;
             
            System.runAs(u1) {
               // The following code runs as user 'u1' 
                System.debug('User1: ' + UserInfo.getUserName());
                System.debug('Profile1: ' + UserInfo.getProfileId()); 
            }
            
            System.runAs(u2) {
               // The following code runs as user 'u2' 
                System.debug('User2: ' + UserInfo.getUserName());
                System.debug('Profile2: ' + UserInfo.getProfileId()); 
            }
            
            system.runAs(u1){
               // Create Account
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.OwnerID = u2.ID;
                testAccount.status__c = 'Sold';
                testAccount.Fax = '1234567';
                update testAccount;
                System.debug('Account : ' +testAccount.Name);
                
               // Create tasks
                list<Task> tasks = TestClassUtiltity.createTasks(testAccount.Id);
                tasks[0].priority='Normal';
                tasks[0].status='In progress';
                insert tasks; 
                System.debug('Task code run.');
                
               // Create Activities
                list<Event> events = TestClassUtiltity.createEvents(testAccount.Id);
                events[0].subject='Meeting';
                insert events;
                System.debug('Event code run.');
                
                test.StartTest(); 
               // Initializing the Constructor
                HPS_MyTeamActivitiesController tempController = new HPS_MyTeamActivitiesController();
               // Assert the size of the generated lists
                System.assertEquals(tempController.teamUserIds.size(),3);
                System.assertEquals(tempController.myTeamTaskList.size(),1);
                System.assertEquals(tempController.myTeamEventList.size(),2);
                test.StopTest(); 
            }
        }catch(Exception e){
         System.debug( 'Exception : ' +e.getMessage() );  
        }
    }
    
}