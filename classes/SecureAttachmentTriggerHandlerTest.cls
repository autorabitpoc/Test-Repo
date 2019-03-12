@isTest
public with sharing class SecureAttachmentTriggerHandlerTest {
	
    static testmethod void testUpdateSecondaryProducerCongaFields(){
        
        Account testAcc = new Account(name='test');
        Secure_Information__c testSi = new Secure_Information__c();
        
        
        testSi.Secondary_a_general_agent__c = true;
        testSi.Seconday_producer_agency_for_commissions__c = true;
        testSi.X2nd_producer_agency_appointed_w_BCBS__c = true;
        testSi.Secondary_affiliated_w_general_agent__c = true;
        
        insert testAcc;
        
        testSi.Account__c = testAcc.Id;
        insert testSi;
        
        Secure_Information__c siAfterInsert = [SELECT Id, Is_Secondary_Producer_General_Agent__c, Is_Secondary_Producer_Affiliated__c, Is_Secondary_Producer_BCBS__c from Secure_Information__c Limit 1];
        
        System.assertEquals('Yes', siAfterInsert.Is_Secondary_Producer_Affiliated__c);
        System.assertEquals('Yes', siAfterInsert.Is_Secondary_Producer_BCBS__c);
        System.assertEquals('Yes', siAfterInsert.Is_Secondary_Producer_General_Agent__c);
        
        siAfterInsert.Seconday_producer_agency_for_commissions__c = false;
        
        update siAfterInsert;
        
        Secure_Information__c siAfterInsert2 = [SELECT Id, Is_Secondary_Producer_General_Agent__c, Is_Secondary_Producer_Affiliated__c, Is_Secondary_Producer_BCBS__c from Secure_Information__c Limit 1];
        System.assertEquals(null, siAfterInsert2.Is_Secondary_Producer_Affiliated__c);
        System.assertEquals(null, siAfterInsert2.Is_Secondary_Producer_BCBS__c);
        System.assertEquals(null, siAfterInsert2.Is_Secondary_Producer_General_Agent__c);
        
        siAfterInsert2.Seconday_producer_agency_for_commissions__c = true;
        siAfterInsert2.Secondary_a_general_agent__c = false;
        
        update siAfterInsert2;
        
        Secure_Information__c siAfterInsert3 = [SELECT Id, Is_Secondary_Producer_General_Agent__c, Is_Secondary_Producer_Affiliated__c, Is_Secondary_Producer_BCBS__c from Secure_Information__c Limit 1];
    	
        System.assertEquals('Yes', siAfterInsert3.Is_Secondary_Producer_Affiliated__c);
        System.assertEquals('Yes', siAfterInsert3.Is_Secondary_Producer_BCBS__c);
        System.assertEquals('No', siAfterInsert3.Is_Secondary_Producer_General_Agent__c);
    }
}