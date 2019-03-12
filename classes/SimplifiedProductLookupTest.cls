/**************************************************************************************
Apex Class Name     : SimplifiedProductLookupTest
Version             : 1.0
Function            : This is a test class for the SimplifiedProductLookup class
* Developer                   Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin             3/30/2016
*************************************************************************************/
@isTest
private class SimplifiedProductLookupTest {
        
    @isTest static void test_method_one() {
        try {
            test.StartTest();
            Product2 prod = new Product2();
            prod.Name = 'Blue Directions';
            prod.Simplified_Product__c = 'Blue Directions';
            prod.HCSC_State__c = 'IL';
            prod.IsActive = true;
            insert prod;
            Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
            
            Opportunity opp2 = new Opportunity(AccountId = TestAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = system.Today(), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
            insert opp2;
            PageReference pageRef = Page.SimplifiedProductLookup; 
            pageRef.getParameters().put('Id', opp2.Id);
            pageRef.getParameters().put('lksrch', 'Blue Directions');
            Test.setCurrentPage(pageRef);
            
            SimplifiedProductLookup prods = new SimplifiedProductLookup();
            prods.getFormTag();
            prods.getTextBox();
            
            System.assertEquals(1, prods.results.size());
            test.StopTest();
            
        } catch(Exception e){
            throw e;
        }
    }
    
    @isTest static void test_method_two() {
        try {
            test.StartTest();
            Product2 prod = new Product2();
            prod.Name = 'Blue Directions';
            prod.HCSC_State__c = 'IL';
            prod.IsActive = True;
            insert prod;
            Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
            
            Opportunity opp2 = new Opportunity(AccountId = TestAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = system.Today(), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
            insert opp2;
            PageReference pageRef = Page.SimplifiedProductLookup; 
            pageRef.getParameters().put('Id', opp2.Id);
            pageRef.getParameters().put('lksrch', '');
            Test.setCurrentPage(pageRef);
            
            SimplifiedProductLookup prods = new SimplifiedProductLookup();
            
            System.assertEquals(1, prods.results.size());
            test.StopTest();
            
        } catch(Exception e){
            throw e;
        }
        
    }
    
    @isTest static void test_Dearborn_Profile() { 
        
        try{
            
            /** Create a User with Dearborn Profile **/
            Profile p = [SELECT Id FROM Profile WHERE Name='LGNA - Dearborn'];
            User userDearborn = new User(Alias = 'simpprod',Email='test@test.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='simpprodlookup@test.com');
            insert userDearborn;
            
            /** create an Account **/
            Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
            
            /** create an Opportunity **/
            Opportunity opp2 = new Opportunity(AccountId = TestAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = system.Today(), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
            insert opp2;            
            
            /* create a non-Dearborn Product **/
            Product2 NotDearborn = new Product2();
            NotDearborn.Name = 'Not A Dearborn Product Blue Directions';
            NotDearborn.HCSC_State__c = 'IL';
            NotDearborn.IsActive = True;
            NotDearborn.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC BlueStar Product').getRecordTypeId();
            insert NotDearborn;
            
            /** create a Dearborn Product **/            
            Product2 IsDearborn = new Product2();
            IsDearborn.Name = 'A Dearborn Product';
            IsDearborn.HCSC_State__c = 'IL';
            IsDearborn.IsActive = True;
            IsDearborn.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Dearborn Products').getRecordTypeId();
            insert IsDearborn;
            
            System.runAs(userDearborn){                
                /** passing in a Search criteria of Blue Directions should not return **/
                //* anything for a Dearborn user **/                
                PageReference pageRef = Page.SimplifiedProductLookup; 
                pageRef.getParameters().put('Id', opp2.Id);
                pageRef.getParameters().put('lksrch', 'Blue Directions');
                Test.setCurrentPage(pageRef);                
                SimplifiedProductLookup prods1 = new SimplifiedProductLookup();                
                System.assertEquals(0, prods1.results.size());
                
                /** passing in empty Search criteria should return a record for  **/
                //* a Dearborn user **/                
                pageRef.getParameters().put('Id', opp2.Id);
                pageRef.getParameters().put('lksrch', '');                
                Test.setCurrentPage(pageRef);                
                SimplifiedProductLookup prods2 = new SimplifiedProductLookup();
                System.assertEquals(1, prods2.results.size());                                             
            }            
        }catch(Exception e){
            throw e;
        }
    }
}