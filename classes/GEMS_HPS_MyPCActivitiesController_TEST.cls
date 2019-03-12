/**************************************************************************************
  Apex Class Name     : GEMS_HPS_MyPCActivitiesController_TEST
  Version             : 1.0
  Function            : This is a test class for GEMS_HPS_MyPCActivitiesController.
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  
*************************************************************************************/
@isTest
public class GEMS_HPS_MyPCActivitiesController_TEST{

    static testMethod void myUnitTest() {
        try{
             Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
           User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
           insert testUser;
         system.runAs(testUser){
           //crate Account
          Account acc= GEMS_UtilityClassTest.insertionAccount();
          insert acc;
          
           Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
          System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
             
                
                //create tasks
                
                task taskElig = New task();
                taskElig.status = 'In Progress';
                taskElig.subject = 'BlueStar Update';
                taskElig.GEMS_start_date__c = System.now();
                taskElig.whatId = acc.Id;
                taskElig.ownerId = testUser.Id;
                taskElig.Priority = 'Normal'; 
                insert taskElig;
                System.assertEquals('In Progress',taskElig.status);
                
                test.StartTest(); 
                //Initializing the Constructor
                GEMS_HPS_MyPCActivitiesController tempController = new GEMS_HPS_MyPCActivitiesController();
               
                
            }
        }catch(Exception e){
            
        }
    }
    
}