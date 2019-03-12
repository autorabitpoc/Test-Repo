/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.

**  Author                 Date                              Update
**     Mei Chen              03/10/2015                         Initial   
*/
@isTest
private class TestBatchCaseMarkedForDelete {
    
    static testMethod void BatchCaseMarkedForDeleteTestMethodSomeToSelect() {
        
        /***************************************************************************/
        /* This method should end successfully and result in Cases being selected, */
        /* deleted, and and email notification being sent                          */
        /***************************************************************************/
        
        system.debug('!!BEGIN BatchCaseMarkedForDeleteTestMethodSomeToSelect()');
        
        list <Case> testCases=new list<Case>();
        
        Case case1=new Case();
        case1.Subject ='Selected Because of Status and Created Date';
        case1.Description='Test Case #1';
        case1.Status ='Closed (Marked for Delete)';
        case1.LastModifiedDate = system.today()-1; 
        case1.CreatedDate =system.today()-2; 
        testCases.add(case1);
        
        Case case2=new Case();
        case2.Subject = 'Not Selected Because of Status and Created Date';
        case2.Description='Test Case #2';
        case2.Status='Closed (Marked for Delete)';
        testCases.add(case2);
        insert testCases;
        system.debug('Inserted Test Cases');
        
        List<Case> AfterInsert = [SELECT Id, Description, Subject, CreatedDate, Status
                                  FROM Case LIMIT 2];
        
        /* Log what was inserted */
        For(Case ACase: AfterInsert ){
            System.debug('Description: ' + ACase.Description);
            System.debug('Id & Subject : ' + ACase.Id + ' ' + ACase.Subject);           
            System.debug('CreatedDate & Status:  ' + ACase.CreatedDate + ' ' + ACase.Status);    
        }
        
        /* this should equal the dt value in the BatchCaseMarkedForDelete Class - used in SOQL query */
        Date DateUsedInClass = system.today()-1;
        System.debug('DateUsedInClass:  '+ DateUsedInClass);
        
        User user = TestUtils.createTestUser('RunAsUser1', 'System Administrator');
        
        System.runAs(user){
            Test.startTest();
            Database.batchableContext bc ;
            BatchCaseMarkedForDelete b=new BatchCaseMarkedForDelete();
            Id batchId=Database.executeBatch(b,200);
            System.assertNOTEquals(batchId,null);            
            Test.stopTest();
            
            /* Only 1 Case should be deleted as they match the Selection criteria (CreatedDate & Status) */
            /* There should be 1 Case left as it did not meet the Selection criteria.                    */
            System.assertEquals(1, [SELECT count() FROM Case WHERE Status = 'Closed (Marked for Delete)']);
            
            system.debug('!!END BatchCaseMarkedForDeleteTestMethodSomeToSelect()');            
        }
    }
    
    static testMethod void BatchCaseMarkedForDeleteTestMethodNoneToSelect() {
        
        /***************************************************************************/
        /* This method should end successfully and result in Cases being selected, */
        /* deleted, and and email notification being sent                          */
        /***************************************************************************/
        
        system.debug('!!BEGIN BatchCaseMarkedForDeleteTestMethodNoneToSelect()');
        
        list <Case> testCases=new list<Case>();       
        
        Case case1=new Case();
        case1.Subject ='Not Selected Because of Status and Created Date';
        case1.Description='Test Case #1';
        case1.Status ='Closed - No Response';
        case1.LastModifiedDate = system.today()-1; 
        case1.CreatedDate =system.today()-2; 
        testCases.add(case1);
        
        Case case2=new Case();
        case2.Subject = 'Not Selected Because of Status and Created Date';
        case2.Description='Test Case #2';
        case2.Status='Closed - No Response';
        testCases.add(case2);
        insert testCases;
        system.debug('Inserted Test Cases');
        
        List<Case> AfterInsert = [SELECT Id, Description, Subject, CreatedDate, Status
                                  FROM Case LIMIT 2];
        
        /* Log what was inserted */
        For(Case ACase: AfterInsert ){
            System.debug('Description: ' + ACase.Description);
            System.debug('Id & Subject : ' + ACase.Id + ' ' + ACase.Subject);           
            System.debug('CreatedDate & Status:  ' + ACase.CreatedDate + ' ' + ACase.Status);    
        }
        
        /* this should equal the dt value in the BatchCaseMarkedForDelete Class - used in SOQL query */
        Date DateUsedInClass = system.today()-1;
        System.debug('DateUsedInClass:  '+ DateUsedInClass);
        
        User user = TestUtils.createTestUser('RunAsUser1', 'System Administrator');
        
        System.runAs(user){
            Test.startTest();
            Database.batchableContext bc ;
            BatchCaseMarkedForDelete b=new BatchCaseMarkedForDelete();
            Id batchId=Database.executeBatch(b,200);
            System.assertNOTEquals(batchId,null);
            Test.stopTest();
            
            /* The Test Cases should persist as they do not match the Selection criteria (CreatedDate & Status) */
            System.assertEquals(2, [SELECT count() FROM Case]);
            
            system.debug('!!END BatchCaseMarkedForDeleteTestMethodNoneToSelect()');
            
        }
    }
    
    static testMethod void BatchCaseMarkedForDeleteTestMethodThrowAnError() {
        
        /***************************************************************************/
        /* This method should cause an error in the Try/Catch of the Execute and   */
        /* not perform the Delete                                                  */
        /***************************************************************************/
        
        system.debug('!!BEGIN BatchCaseMarkedForDeleteTestMethodThrowAnError()');
        
        list <Case> testCases=new list<Case>();
        
        Case case1=new Case();
        case1.Subject ='Selected Because of Status and Created Date';
        case1.Description='Test Case #1';
        case1.Status ='Closed (Marked for Delete)';
        case1.LastModifiedDate = system.today()-1; 
        case1.CreatedDate =system.today()-2; 
        testCases.add(case1);
        
        Case case2=new Case();
        case2.Subject = 'Not Selected Because of Status and Created Date';
        case2.Description='Test Case #2';
        case2.Status='Closed (Marked for Delete)';
        testCases.add(case2);
        insert testCases;
        system.debug('Inserted Test Cases');
        
        List<Case> AfterInsert = [SELECT Id, Description, Subject, CreatedDate, Status
                                  FROM Case LIMIT 2];
        
        /* Log what was inserted */
        For(Case ACase: AfterInsert ){
            System.debug('Description: ' + ACase.Description);
            System.debug('Id & Subject : ' + ACase.Id + ' ' + ACase.Subject);           
            System.debug('CreatedDate & Status:  ' + ACase.CreatedDate + ' ' + ACase.Status);    
        }
        
        /* this should equal the dt value in the BatchCaseMarkedForDelete Class - used in SOQL query */
        Date DateUsedInClass = system.today()-1;
        System.debug('DateUsedInClass:  '+ DateUsedInClass);
        
        User user = TestUtils.createTestUser('RunAsUser1', 'System Administrator');
        
        System.runAs(user){
            Test.startTest();
            Database.batchableContext bc ;
            BatchCaseMarkedForDelete b=new BatchCaseMarkedForDelete();
            Id batchId=Database.executeBatch(b,200);
            System.assertNOTEquals(batchId,null);
            system.abortJob(batchId);
            /* this line will cause an Error in Try/Catch Block because the null id value causes exception on Delete */
            testCases[0].id=null;
            b.Execute(bc,testCases);
            Test.stopTest();
            
            /* The Test Cases should persist as the error caused the Delete step to not be executed */
            System.assertEquals(2, [SELECT count() FROM Case WHERE Status = 'Closed (Marked for Delete)']);
            
            system.debug('!!END BatchCaseMarkedForDeleteTestMethodThrowAnError()');            
        }
    }
    
    static testMethod void BatchCaseMarkedForDeleteSchedulerTestMethod(){
        
        system.debug('!!BEGIN BatchCaseMarkedForDeleteSchedulerTestMethod()');            
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        
        // Schedule the test job     
        String jobId = System.schedule('BatchCaseMarkedforDeletedSchdule', CRON_EXP, new BatchCaseMarkedForDeleteSchedule());
        
        System.assertNOTEquals(jobId,null);
        
        system.debug('!!END BatchCaseMarkedForDeleteSchedulerTestMethod()');            
    }
}