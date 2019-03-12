@isTest
private class LGNA_NewRHItemTotalsController_test {
    
    @testSetup static void setup() {
        //create test Account Record
        Id  grpActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account testAccount=TestClassUtiltity.createAccountWithRecType('testAccount', grpActRecId);      
        
        //create test Opportunity Record
        Id nsOppOppRecId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity nsOpp=new Opportunity(AccountId = testAccount.id, RecordTypeId = nsOppOppRecId, Name = 'oppName 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));        
        insert nsOpp;
    }
    
    static testMethod void Test_000_fetchItemTotals() {             
        
        //test blank/empty objectId
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Account_Maintenance', '','Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('fieldName: '+fieldName);
        System.debug('fieldValue: '+ fieldValue);
        
        System.assertEquals('Account_Maintenance', fieldValue, 'The value was not as expected.');
        
    }
    
    static testMethod void Test_001_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Account_Maintenance', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('fieldName: '+fieldName);
        System.debug('fieldValue: '+ fieldValue);
        
        System.assertEquals('Account_Maintenance', fieldValue, 'The value was not as expected.');
        
    }
    
    static testMethod void Test_002_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Cede', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Cede', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Cede', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('Cede', fieldValue, 'The value was not as expected.');        
    }
    
    static testMethod void Test_003_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Contract_Admin', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Contract_Admin', fieldValue, 'The value was not as expected.');
    }
    
    static testMethod void Test_004_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('CSS_Tasks', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('CSS_Tasks', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('CSS_Tasks', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('CSS_Tasks', fieldValue, 'The value was not as expected.');        
    }
    
    static testMethod void Test_005_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Network_Information', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Network_Information', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Network_Information', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('Network_Information', fieldValue, 'The value was not as expected.');        
    }
    
    
    static testMethod void Test_006_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Open_Enrollment', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Open_Enrollment', fieldValue, 'The value was not as expected.');
    }
    
    static testMethod void Test_007_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Performance_Guarantee', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Performance_Guarantee', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Performance_Guarantee', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('Performance_Guarantee', fieldValue, 'The value was not as expected.');        
    }
    
    static testMethod void Test_008_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Private_Exchange _ External', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Private_Exchange _ External', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Private_Exchange _ External', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('Private_Exchange _ External', fieldValue, 'The value was not as expected.');        
    }
    
    static testMethod void Test_009_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Proposal', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Proposal', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Proposal', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('Proposal', fieldValue, 'The value was not as expected.');        
    }
    
    static testMethod void Test_010_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('CBSR', String.valueOf(theAccount.Id),'Account');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('CBSR', fieldValue, 'The value was not as expected.');
        
        theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('CBSR', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        fieldValue = parser.getText();
        
        System.debug('Opportunity fieldName: '+fieldName);
        System.debug('Opportunity fieldValue: '+ fieldValue);
        
        System.assertEquals('CBSR', fieldValue, 'The value was not as expected.');        
    }
    
    static testMethod void Test_011_fetchItemTotals() {       
        
        Account theAccount = [SELECT Id FROM Account WHERE Name='testAccount' LIMIT 1];
        Opportunity theOpportunity = [SELECT Id FROM Opportunity WHERE Name='oppName 1' LIMIT 1];
        
        String theReturnedString = LGNA_NewRHItemTotalsController.fetchItemTotals('Contract_Admin_Request', String.valueOf(theOpportunity.Id),'Opportunity');        
        
        JSONParser parser = JSON.createParser(theReturnedString);
        // Advance to the start object marker.
        parser.nextToken();
        // Advance to the next value.
        parser.nextValue();
        // Get the field name for the current value.
        String fieldName = parser.getCurrentName();
        // Get the textual representation 
        // of the value.
        String fieldValue = parser.getText();
        
        System.debug('Account fieldName: '+fieldName);
        System.debug('Account fieldValue: '+ fieldValue);
        
        System.assertEquals('Contract_Admin_Request', fieldValue, 'The value was not as expected.');       
       
    }
    
    
}