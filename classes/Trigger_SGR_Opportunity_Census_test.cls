@isTest 
private class Trigger_SGR_Opportunity_Census_test {
    
    @testSetup static void setup() {                      
                
        List<SGR_Trigger_Settings__c> triggerCustomSettings = new List<SGR_Trigger_Settings__c>();
        
        SGR_Trigger_Settings__c entry001 = new SGR_Trigger_Settings__c();
        entry001.Name = 'entry001';
        entry001.Trigger_Is_Active__c = true;
        entry001.Trigger_Name__c = 'Trigger_SGR_Opportunity_Census';
        entry001.Trigger_SubMethod__c = 'createSGROpportunityMemberBenefits';
        triggerCustomSettings.add(entry001);
        
        SGR_Trigger_Settings__c entry002 = new SGR_Trigger_Settings__c();
        entry002.Name = 'entry002';
        entry002.Trigger_Is_Active__c = true;
        entry002.Trigger_Name__c = 'Trigger_SGR_Opportunity_Census';
        entry002.Trigger_SubMethod__c = 'updateSGROpportunityMemberBenefits';
        triggerCustomSettings.add(entry002);
        
        SGR_Trigger_Settings__c entry003 = new SGR_Trigger_Settings__c();
        entry003.Name = 'entry003';
        entry003.Trigger_Is_Active__c = true;
        entry003.Trigger_Name__c = 'Trigger_SGR_Opportunity_Census';
        entry003.Trigger_SubMethod__c = 'deleteSGROpportunityMemberBenefits';        
        triggerCustomSettings.add(entry003);
        
        insert triggerCustomSettings;

        List<Plan__c> listPlans = new List<Plan__c>();
        
        for (Integer i = 0 ; i < 5; i++) {
            Plan__c aPlan = new Plan__c();
            aPlan.Name = 'Test Health Plan' + String.valueOf(i);
            aPlan.Line_Of_Business__c = 'H';        
            listPlans.add(aPlan);        
        }        
        
        for (Integer i = 0 ; i < 5; i++) {
            Plan__c aPlan = new Plan__c();
            aPlan.Name = 'Test Vision Plan' + String.valueOf(i);
            aPlan.Line_Of_Business__c = 'V';        
            listPlans.add(aPlan);        
        }        
        
        for (Integer i = 0 ; i < 5; i++) {
            Plan__c aPlan = new Plan__c();
            aPlan.Name = 'Test Dental Plan' + String.valueOf(i);
            aPlan.Line_Of_Business__c = 'D';        
            listPlans.add(aPlan);        
        }       
        
        insert listPlans;   
        
        List<Plan__c> listHealthPlans = new List<Plan__c>();
        List<Plan__c> listVisionPlans = new List<Plan__c>();
        List<Plan__c> listDentalPlans = new List<Plan__c>();
        
        listHealthPlans = [SELECT Id, Name, Line_Of_Business__c FROM Plan__c WHERE Line_Of_Business__c = 'H']; 
        System.debug('listHealthPlans: ' + listHealthPlans.size());
        listVisionPlans = [SELECT Id, Name, Line_Of_Business__c FROM Plan__c WHERE Line_Of_Business__c = 'V']; 
        System.debug('listVisionPlans: ' + listVisionPlans.size());
        listDentalPlans = [SELECT Id, Name, Line_Of_Business__c FROM Plan__c WHERE Line_Of_Business__c = 'D']; 
        System.debug('listDentalPlans: ' + listDentalPlans.size());
                
        List<SGR_Opportunity_Plan_Rate__c> listOpportunityPlanRates = new List<SGR_Opportunity_Plan_Rate__c>();
        
        for (Integer i = 0 ; i < 5; i++) {
            SGR_Opportunity_Plan_Rate__c aRate = new SGR_Opportunity_Plan_Rate__c();
            aRate.Name = 'TestHealthRate' + String.valueOf(i);
            aRate.Plan_Name__c = 'Health' + String.valueOf(i);  //Health1, Health2, etc.
            aRate.Type__c = 'Renewal';
            if(listHealthPlans.size() == 5){
                aRate.Plan__c = listHealthPlans[i].Id;                
            }            
            listOpportunityPlanRates.add(aRate);            
        }       
        
        for (Integer i = 0 ; i < 5; i++) {
            SGR_Opportunity_Plan_Rate__c aRate = new SGR_Opportunity_Plan_Rate__c();
            aRate.Name = 'TestDentalRate' + String.valueOf(i);
            aRate.Plan_Name__c = 'Dental' + String.valueOf(i); //Dental1, Dental2, etc.
            aRate.Type__c = 'Renewal';
            if(listDentalPlans.size() == 5){
                aRate.Plan__c = listDentalPlans[i].Id;                
            }            
            listOpportunityPlanRates.add(aRate);            
        }       
        
        for (Integer i = 0 ; i < 5; i++) {
            SGR_Opportunity_Plan_Rate__c aRate = new SGR_Opportunity_Plan_Rate__c();
            aRate.Name = 'TestVisionRate' + String.valueOf(i);
            aRate.Plan_Name__c = 'Vision' + String.valueOf(i); //Vision1, Vision2, etc.
            aRate.Type__c = 'Renewal';
            if(listVisionPlans.size() == 5){
                aRate.Plan__c = listVisionPlans[i].Id;                
            }
            listOpportunityPlanRates.add(aRate);            
        }       
        
        insert listOpportunityPlanRates;

        Account testAccount = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', System.today(), 'Active', 'SG', 'PREM');
        
        List<Group_Section__c> listGroupSections = new List<Group_Section__c>();
        
        Group_Section__c aGroupSection = new Group_Section__c();
        aGroupSection.Group_Account__c = testAccount.Id;
        listGroupSections.add(aGroupSection);
        
        insert listGroupSections;
        
        List<SGR_Opportunity_Group_Section__c> listOpportunityGroupSections = new List<SGR_Opportunity_Group_Section__c>();
        
        SGR_Opportunity_Group_Section__c anOpportunityGroupSection = new SGR_Opportunity_Group_Section__c(); 
        anOpportunityGroupSection.Name = 'Test Opp Grp Section';
        listOpportunityGroupSections.add(anOpportunityGroupSection);
        
        insert listOpportunityGroupSections;
        
    }
    
    static testMethod void testInsertUpdateVersion1(){
        
        List<SGR_Opportunity_Group_Section__c> listOpportunityGroupSections = new List<SGR_Opportunity_Group_Section__c>();
        listOpportunityGroupSections = [SELECT Id, Name, Opportunity_Group_Section_Number__c FROM SGR_Opportunity_Group_Section__c LIMIT 1];        
        
        SGR_Opportunity_Census__c aRecord = new SGR_Opportunity_Census__c();
        aRecord.Name = 'Test Opportunity Census 001';
        aRecord.Gender__c = 'M';
        aRecord.Zip_Code__c = '60601';
        aRecord.Relationship__c = 'Subscriber';
        aRecord.Health_Plan_ID__c = 'Health1'; 
        aRecord.Health_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        aRecord.Dental_Plan_ID__c = 'Dental2';
        aRecord.Dental_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        aRecord.Vision_Plan_ID__c = 'Vision3';
        aRecord.Vision_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        
        //test the Insert
        insert aRecord;
        
        String QueryString = 'SELECT count() FROM SGR_Opportunity_Member_Benefits__c'; 
        Integer countOpportunityMemberBenefits = Database.countQuery(QueryString);        
        System.debug('countOpportunityMemberBenefits after Insert: ' + countOpportunityMemberBenefits);
        
        //test the Update
        aRecord = [SELECT 
                   Id, 
                   Name, 
                   Gender__c, 
                   Zip_Code__c,
                   Relationship__c,
                   Health_Plan_ID__c,
                   Dental_Plan_ID__c,
                   Vision_Plan_ID__c
                   FROM SGR_Opportunity_Census__c];
        
        aRecord.Name = 'Test Opportunity Census 002';
        aRecord.Gender__c = 'F';
        aRecord.Relationship__c = 'Spouse';
        aRecord.Health_Plan_ID__c = 'Health2';
        aRecord.Dental_Plan_ID__c = 'Dental3';
        aRecord.Vision_Plan_ID__c = 'Vision4';
        
        update aRecord;    
        
        List<Error_Log__c> listErrorLogs = new List<Error_Log__c>();
        listErrorLogs = [SELECT Id, Class__c, Error_Message__c FROM Error_Log__c LIMIT 100];
        
        for(Error_Log__c aLog : listErrorLogs){
            System.debug('testInsertUpdate Error Log: ' + aLog.Class__c + ' ' +  aLog.Error_Message__c);
        }
    }
    
    static testMethod void testInsertUpdateVersion2(){
        
        List<SGR_Opportunity_Group_Section__c> listOpportunityGroupSections = new List<SGR_Opportunity_Group_Section__c>();
        listOpportunityGroupSections = [SELECT Id, Name, Opportunity_Group_Section_Number__c FROM SGR_Opportunity_Group_Section__c LIMIT 1];        
        
        SGR_Opportunity_Census__c aRecord = new SGR_Opportunity_Census__c();
        aRecord.Name = 'Test Opportunity Census 001';
        aRecord.Gender__c = 'M';
        aRecord.Zip_Code__c = '60601';
        aRecord.Relationship__c = 'Subscriber';
        aRecord.Health_Plan_ID__c = 'Health1'; 
        aRecord.Health_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        aRecord.Dental_Plan_ID__c = 'Dental2';
        aRecord.Dental_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        aRecord.Vision_Plan_ID__c = 'Vision3';
        aRecord.Vision_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        
        //test the Insert
        insert aRecord;
        
        String QueryString = 'SELECT count() FROM SGR_Opportunity_Member_Benefits__c'; 
        Integer countOpportunityMemberBenefits = Database.countQuery(QueryString);        
        System.debug('countOpportunityMemberBenefits after Insert: ' + countOpportunityMemberBenefits);
        
        //test the Update
        aRecord = [SELECT 
                   Id, 
                   Name, 
                   Gender__c, 
                   Zip_Code__c,
                   Relationship__c,
                   Health_Plan_ID__c,
                   Dental_Plan_ID__c,
                   Vision_Plan_ID__c
                   FROM SGR_Opportunity_Census__c];
        
        aRecord.Name = 'Test Opportunity Census 001';
        aRecord.Gender__c = 'F';
        aRecord.Relationship__c = 'Spouse';
        aRecord.Health_Plan_ID__c = null;
        aRecord.Dental_Plan_ID__c = 'Dental3';
        aRecord.Vision_Plan_ID__c = 'Vision4';
        
        update aRecord;    
        
        List<Error_Log__c> listErrorLogs = new List<Error_Log__c>();
        listErrorLogs = [SELECT Id, Class__c, Error_Message__c FROM Error_Log__c LIMIT 100];
        
        for(Error_Log__c aLog : listErrorLogs){
            System.debug('testInsertUpdate Error Log: ' + aLog.Class__c + ' ' +  aLog.Error_Message__c);
        }
    }
       
    static testMethod void testInsertUpdateVersion3(){
        
        List<SGR_Opportunity_Group_Section__c> listOpportunityGroupSections = new List<SGR_Opportunity_Group_Section__c>();
        listOpportunityGroupSections = [SELECT Id, Name, Opportunity_Group_Section_Number__c FROM SGR_Opportunity_Group_Section__c LIMIT 1];        
        
        SGR_Opportunity_Census__c aRecord = new SGR_Opportunity_Census__c();
        aRecord.Name = 'Test Opportunity Census 003';
        aRecord.Gender__c = 'M';
        aRecord.Zip_Code__c = '60601';
        aRecord.Relationship__c = 'Subscriber';
        aRecord.Health_Plan_ID__c = null;
        aRecord.Health_Group_Section__c = null;
        aRecord.Dental_Plan_ID__c = 'Dental2';
        aRecord.Dental_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        aRecord.Vision_Plan_ID__c = 'Vision3';
        aRecord.Vision_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        
        //test the Insert
        insert aRecord;
        
        String QueryString = 'SELECT count() FROM SGR_Opportunity_Member_Benefits__c'; 
        Integer countOpportunityMemberBenefits = Database.countQuery(QueryString);        
        System.debug('countOpportunityMemberBenefits after Insert: ' + countOpportunityMemberBenefits);
        
        //test the Update
        aRecord = [SELECT 
                   Id, 
                   Name, 
                   Gender__c, 
                   Zip_Code__c,
                   Relationship__c,
                   Health_Plan_ID__c,
                   Health_Group_Section__c,
                   Dental_Plan_ID__c,
                   Dental_Group_Section__c,
                   Vision_Plan_ID__c,
                   Vision_Group_Section__c
                   FROM SGR_Opportunity_Census__c];
        
        aRecord.Name = 'Test Opportunity Census 003';
        aRecord.Gender__c = 'F';
        aRecord.Relationship__c = 'Spouse';
        aRecord.Health_Plan_ID__c = 'Health1';
        aRecord.Health_Group_Section__c = String.valueOf(listOpportunityGroupSections[0].Opportunity_Group_Section_Number__c);
        aRecord.Dental_Plan_ID__c = 'Dental2';
        aRecord.Vision_Plan_ID__c = 'Vision3';
        
        countOpportunityMemberBenefits = Database.countQuery(QueryString);        
        System.debug('countOpportunityMemberBenefits before Update: ' + countOpportunityMemberBenefits);
       
        update aRecord;    
        
        countOpportunityMemberBenefits = Database.countQuery(QueryString);        
        System.debug('countOpportunityMemberBenefits after Update: ' + countOpportunityMemberBenefits);

        
        List<Error_Log__c> listErrorLogs = new List<Error_Log__c>();
        listErrorLogs = [SELECT Id, Class__c, Error_Message__c FROM Error_Log__c LIMIT 100];
        
        for(Error_Log__c aLog : listErrorLogs){
            System.debug('testInsertUpdate Error Log: ' + aLog.Class__c + ' ' +  aLog.Error_Message__c);
        }
    }
    
    static testMethod void testDelete(){
        
        SGR_Opportunity_Census__c aRecord = new SGR_Opportunity_Census__c();
        aRecord.Name = 'Test Opportunity Census 001';
        aRecord.Gender__c = 'M';
        aRecord.Zip_Code__c = '60601';
        aRecord.Relationship__c = 'Subscriber';
        aRecord.Health_Plan_ID__c = 'Health1';
        aRecord.Dental_Plan_ID__c = 'Dental2';
        aRecord.Vision_Plan_ID__c = 'Vision3';
        
        //test the Insert
        insert aRecord;
        
        List<SGR_Opportunity_Member_Benefits__c> listOppMbrBene = new List<SGR_Opportunity_Member_Benefits__c>();
        listOppMbrBene = [SELECT 
                          ID,
                          Name,
                          Opportunity_Census__c,
                          Opportunity_Group_Section__c,
                          Opportunity_Plan_Rate__c
                          FROM SGR_Opportunity_Member_Benefits__c];
        
        system.debug('BEFORE listOppMbrBene: ' + listOppMbrBene);
        
        //test the Delete
        aRecord = [SELECT 
                   Id, 
                   Name, 
                   Gender__c, 
                   Zip_Code__c,
                   Relationship__c,
                   Health_Plan_ID__c,
                   Dental_Plan_ID__c,
                   Vision_Plan_ID__c
                   FROM SGR_Opportunity_Census__c];
        
        delete aRecord;        
        
        listOppMbrBene = [SELECT 
                          ID,
                          Name,
                          Opportunity_Census__c,
                          Opportunity_Group_Section__c,
                          Opportunity_Plan_Rate__c
                          FROM SGR_Opportunity_Member_Benefits__c];
        
        system.debug('AFTER listOppMbrBene: ' + listOppMbrBene);
        
        List<Error_Log__c> listErrorLogs = new List<Error_Log__c>();
        listErrorLogs = [SELECT Id, Class__c, Error_Message__c FROM Error_Log__c LIMIT 100];
        
        for(Error_Log__c aLog : listErrorLogs){
            System.debug('testDelete Error Log: ' + aLog.Class__c + ' ' +  aLog.Error_Message__c);
        }
        
    }
    
}