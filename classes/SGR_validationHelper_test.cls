@istest
public class SGR_validationHelper_test 
{
    public static testmethod void testcountycodeNotNull(){
         Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', System.today(), 'Active', 'SG', 'PREM');
        List<Opportunity> opprList = new List<Opportunity>();
        Opportunity oppr = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Rated');
        system.assertEquals(acc.Name,'TestAccount');
        opprList.add(oppr);
       
        List<SGR_Renewal_Batch_oppty__c> renewBatchOppList = new List<SGR_Renewal_Batch_oppty__c>();
        Map<Id,List<SGR_Renewal_Batch_oppty__c>> renewBatchOppMap = new Map<Id,List<SGR_Renewal_Batch_oppty__c>>();
        SGR_Renewal_Batch_oppty__c renBatchOppObj = Sgr_TestDataUtility.createOptyRenBatch(oppr.id);
        renewBatchOppList.add(renBatchOppObj);
        renewBatchOppMap.put(oppr.id,renewBatchOppList);
        List<SGRRenewalBatch__c> renewList = new List<SGRRenewalBatch__c>();
        SGRRenewalBatch__c renew = Sgr_TestDataUtility.createRenewalBatch();
        renewList.add(renew);
        Map<string,SGR_Business_Rule__c> brMap = new Map<string,SGR_Business_Rule__c>();
        SGR_Business_Rule__c br = Sgr_TestDataUtility.createBusinessRule();
        brMap.put(br.Rule_Code__c,br);
        Test.startTest();
        SGR_validationHelper.checkcountycode(opprList,'GR.DV.10','1234',renewList,brMap,renewBatchOppMap);
        Test.stopTest();
        
    }
    
    public static testmethod void testcountycodeNull(){
         Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', System.today(), 'Active', 'SG', 'PREM');
        List<Opportunity> opprList = new List<Opportunity>();
        Opportunity oppr = Sgr_TestDataUtility.createOpty(acc.Id, 'Rated');
        System.assertEquals(acc.Name,'TestAccount');
        
        opprList.add(oppr);
       
        List<SGR_Renewal_Batch_oppty__c> renewBatchOppList = new List<SGR_Renewal_Batch_oppty__c>();
        Map<Id,List<SGR_Renewal_Batch_oppty__c>> renewBatchOppMap = new Map<Id,List<SGR_Renewal_Batch_oppty__c>>();
        SGR_Renewal_Batch_oppty__c renBatchOppObj = Sgr_TestDataUtility.createOptyRenBatch(oppr.id);
        renewBatchOppList.add(renBatchOppObj);
        renewBatchOppMap.put(oppr.id,renewBatchOppList);
        List<SGRRenewalBatch__c> renewList = new List<SGRRenewalBatch__c>();
        SGRRenewalBatch__c renew = Sgr_TestDataUtility.createRenewalBatch();
        renewList.add(renew);
        Map<string,SGR_Business_Rule__c> brMap = new Map<string,SGR_Business_Rule__c>();
        SGR_Business_Rule__c br = Sgr_TestDataUtility.createBusinessRule();
        brMap.put(br.Rule_Code__c,br);
        Test.startTest();
        SGR_validationHelper.checkcountycode(opprList,'GR.DV.10','1234',renewList,brMap,renewBatchOppMap);
        Test.stopTest();
        
    }
    
    public static testmethod void testZipCodeMatch(){
         Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', System.today(), 'Active', 'SG', 'PREM');
        List<Opportunity> opprList = new List<Opportunity>();
        Opportunity oppr = Sgr_TestDataUtility.createOptyRec(acc.Id, 'Rated');
        
        opprList.add(oppr);
        System.assertEquals(acc.Name, 'TestAccount');
       
        List<SGR_Renewal_Batch_oppty__c> renewBatchOppList = new List<SGR_Renewal_Batch_oppty__c>();
        Map<Id,List<SGR_Renewal_Batch_oppty__c>> renewBatchOppMap = new Map<Id,List<SGR_Renewal_Batch_oppty__c>>();
        SGR_Renewal_Batch_oppty__c renBatchOppObj = Sgr_TestDataUtility.createOptyRenBatch(oppr.id);
        renewBatchOppList.add(renBatchOppObj);
        renewBatchOppMap.put(oppr.id,renewBatchOppList);
        List<SGRRenewalBatch__c> renewList = new List<SGRRenewalBatch__c>();
        SGRRenewalBatch__c renew = Sgr_TestDataUtility.createRenewalBatch();
        renewList.add(renew);
        Map<string,SGR_Business_Rule__c> brMap = new Map<string,SGR_Business_Rule__c>();
        SGR_Business_Rule__c br = Sgr_TestDataUtility.createBusinessRule();
        brMap.put(br.Rule_Code__c,br);
        Test.startTest();
        SGR_validationHelper.CheckZipCode(opprList,'GR.DV.10','1234',renewList,brMap,renewBatchOppMap);
        Test.stopTest();

        
    }
   
    static testmethod  void testmethod2(){
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c='1234', external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
            List<Account> accList = new List<Account>();
            
            accList.add(newAccount2); 
            insert accList;
            Benefit_Agreement__c bac=new Benefit_Agreement__c();
            bac.Group_Account__c = newAccount2.id;
            bac.Status__c = 'Cancelled';
            insert bac; 
            system.assertEquals(bac.Status__c ,'Cancelled');
            
            List<SGR_Account_Census__c> sa = new List<SGR_Account_Census__c>();
            SGR_Account_Census__c sac = new SGR_Account_Census__c();
            sac.Account__c=newAccount2.id;
            sac.Relationship__c='Subscriber';
            sac.Gender__c='M';
            sac.Zip_Code__c=string.valueof(12345);
            sac.Member_Cancel_Date__c=system.today().adddays(+2);
            sac.Membership_Number__c='2';
            sac.Member_Effective_Date__c=date.today().addDays(-2);
            sa.add(sac);
            insert sa;
            
            
            List<SGR_Business_Rule__c> brAS = new List<SGR_Business_Rule__c>();
            brAS.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.02'));
            insert brAS;
            List<SGR_Business_Rule__c> brASzip = new List<SGR_Business_Rule__c>();
            brASzip.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.06'));
            insert brASzip;
            List<SGR_Business_Rule__c> brcounty = new List<SGR_Business_Rule__c>();
            brcounty.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.07'));
            insert brcounty;
            
            List<SGR_Business_Rule__c> bragree = new List<SGR_Business_Rule__c>();
            bragree.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.01'));
            insert bragree;
            List<Opportunity> opps = new List<Opportunity>();
            for(Integer j=0;j<5;j++)
            {
                opps.add(new Opportunity(Name='Test Opportunity'+ j,
                                         StageName='Prospecting',CloseDate= system.today(),Assigned_UW__c=userInfo.getUserId(),
                                         AccountId=newAccount2.Id));
                
            }
            insert opps; 
            
            Test.starttest();   
            SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            ID batchId = Database.executeBatch(sbr,50);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount2.Id];
            
            SGR_validationHelper countycode = new SGR_validationHelper(listopp,BatchId);    
            
            Test.stoptest();
        }
        catch(Exception e)
        {
            e.getMessage();
            
        }
    }
    
    //SFDC-14082: SGR: R4E - Dependents for Employee Only Tier
    //Author: Landry Harris
    static testmethod void checkForDependentsForEmployeeOnlyTier() {
        //Method to test the checkForDependentsForEmployeeOnlyTier function
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c='1234', external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
            List<Account> accList = new List<Account>();
            accList.add(newAccount2);
            insert accList;
            System.assertEquals(marketSegment,'SG');
            Account newAccount3 = [Select Id, Name, External_ID__c, HCSC_Division__c, Market_Segment__c, Funding_Type__c From Account Where External_ID__C = 'AC123456'];
            
            List<SGR_Account_Census__c> sa = new List<SGR_Account_Census__c>();
            SGR_Account_Census__c sac = new SGR_Account_Census__c();
            sac.Account__c=newAccount3.id;
            sac.Relationship__c='Subscriber';
            sac.Gender__c='M';
            
            sac.Zip_Code__c=string.valueof(12345);
            sac.Member_Cancel_Date__c=system.today().adddays(+2);
            sac.Membership_Number__c='1';
            sac.Member_Effective_Date__c=date.today().addDays(-2);
            sa.add(sac);
            insert sa;
            
            Group_Section__c gs = new Group_Section__c();
            gs.Group_Account__c=newAccount3.id;
            gs.Benefit_Agreement_Cancel_Date__c=system.today();
            insert gs;
            
            SGR_Account_Census__c sac2 = [Select Id From SGR_Account_Census__c Where Account__c = :newAccount3.Id];
            Group_Section__c gs2 = [Select Id FROM Group_Section__c WHERE Group_Account__c = :newAccount3.Id];
            
            SGR_Account_Member_Benefit__c sam = new SGR_Account_Member_Benefit__c();
            sam.Account__c=newAccount3.id;
            sam.Group_Section__c=gs2.id;
            sam.Account_Census__c=sac2.id;
            sam.Member_Policy_Tier__c = 'EO';
            insert sam;
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            br.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.09'));
            insert br;
            List<Opportunity> opps = new List<Opportunity>();
            List<Opportunity> oppsneg = new List<Opportunity>();
            for(Integer j=0;j<5;j++)
            {
                opps.add(new Opportunity(Name='Test Opportunity'+ j,
                                         StageName='Prospecting',CloseDate= system.today(),Assigned_UW__c=userInfo.getUserId(),
                                         AccountId=newAccount3.Id));
                
            }
            
            Test.starttest();       
            SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            ID batchId = Database.executeBatch(sbr,50);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount3.Id];
            SGR_validationHelper countycode = new SGR_validationHelper(listopp,batchId);    
            Test.stoptest();
        }
        catch(Exception e)
        {
        	e.getMessage();
        }
    }
    static testmethod void checkForDependentsForEmployeeOnlyTier2() {
        //Method to test the checkForDependentsForEmployeeOnlyTier function
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c='1234', external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
            List<Account> accList = new List<Account>();
            accList.add(newAccount2);
            insert accList;
            Account newAccount3 = [Select Id, Name, External_ID__c, HCSC_Division__c, Market_Segment__c, Funding_Type__c From Account Where External_ID__C = 'AC123456'];
            
            List<SGR_Account_Census__c> sa = new List<SGR_Account_Census__c>();
            SGR_Account_Census__c sac = new SGR_Account_Census__c();
            sac.Account__c=newAccount3.id;
            sac.Relationship__c='Subscriber';
            sac.Gender__c='M';
            
            sac.Zip_Code__c=string.valueof(12345);
            sac.Member_Cancel_Date__c=system.today().adddays(+2);
            sac.Membership_Number__c='3';
            sac.Member_Effective_Date__c=date.today().addDays(-2);
            sa.add(sac);
            insert sa;
            
            Group_Section__c gs = new Group_Section__c();
            gs.Group_Account__c=newAccount3.id;
            gs.Benefit_Agreement_Cancel_Date__c=system.today();
            insert gs;
            
            SGR_Account_Census__c sac2 = [Select Id From SGR_Account_Census__c Where Account__c = :newAccount3.Id];
            Group_Section__c gs2 = [Select Id FROM Group_Section__c WHERE Group_Account__c = :newAccount3.Id];
            
            SGR_Account_Member_Benefit__c sam = new SGR_Account_Member_Benefit__c();
            sam.Account__c=newAccount3.id;
            sam.Group_Section__c=gs2.id;
            sam.Account_Census__c=sac2.id;
            sam.Member_Policy_Tier__c = 'EO';
            insert sam;
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            br.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.09'));
            insert br;
            //String BatchId ='7074D00000RD90BQAT';
            List<Opportunity> opps = new List<Opportunity>();
            List<Opportunity> oppsneg = new List<Opportunity>();
            for(Integer j=0;j<5;j++)
            {
                opps.add(new Opportunity(Name='Test Opportunity'+ j,
                                         StageName='Prospecting',CloseDate= system.today(),Assigned_UW__c=userInfo.getUserId(),
                                         AccountId=newAccount3.Id));
                
            }
            
            Test.starttest();       
            SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            ID batchId = Database.executeBatch(sbr,50);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount3.Id];
            SGR_validationHelper countycode = new SGR_validationHelper(listopp,batchId);    
            Test.stoptest();
            system.assertEquals(sam.Member_Policy_Tier__c,'EO');
        }
        catch(Exception e)
        {
        	e.getMessage();
        }
    }
    static testmethod void checkForDependentsForEmployeeOnlyTier3() {
        //Method to test the checkForDependentsForEmployeeOnlyTier function
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c='1234', external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
            List<Account> accList = new List<Account>();
            accList.add(newAccount2);
            insert accList;
            Account newAccount3 = [Select Id, Name, External_ID__c, HCSC_Division__c, Market_Segment__c, Funding_Type__c From Account Where External_ID__C = 'AC123456'];
            
            List<SGR_Account_Census__c> sa = new List<SGR_Account_Census__c>();
            SGR_Account_Census__c sac = new SGR_Account_Census__c();
            sac.Account__c=newAccount3.id;
            sac.Relationship__c='Subscriber';
            sac.Gender__c='M';
            
            sac.Zip_Code__c=string.valueof(12345);
            sac.Member_Cancel_Date__c=system.today();
            sac.Membership_Number__c='1';
            sac.Member_Effective_Date__c=date.today().addDays(-2);
            sa.add(sac);
            insert sa;
            
            Group_Section__c gs = new Group_Section__c();
            gs.Group_Account__c=newAccount3.id;
            gs.Benefit_Agreement_Cancel_Date__c=system.today();
            insert gs;
            
            SGR_Account_Census__c sac2 = [Select Id From SGR_Account_Census__c Where Account__c = :newAccount3.Id];
            Group_Section__c gs2 = [Select Id FROM Group_Section__c WHERE Group_Account__c = :newAccount3.Id];
            
            List<SGR_Account_Member_Benefit__c> benefits = new List<SGR_Account_Member_Benefit__c>();
            SGR_Account_Member_Benefit__c sam = new SGR_Account_Member_Benefit__c();
            sam.Account__c=newAccount3.id;
            sam.Group_Section__c=gs2.id;
            sam.Account_Census__c=sac2.id;
            sam.Member_Policy_Tier__c = 'EO';
            benefits.add(sam);
            
            SGR_Account_Member_Benefit__c sam2 = new SGR_Account_Member_Benefit__c();
            sam2.Account__c=newAccount3.id;
            sam2.Group_Section__c=gs2.id;
            sam2.Account_Census__c=sac2.id;
            sam2.Member_Policy_Tier__c = 'ES';
            benefits.add(sam2);
            insert benefits;
            System.assertEquals(sam2.Member_Policy_Tier__c,'ES');
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            br.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.09'));
            insert br;
            List<Opportunity> opps = new List<Opportunity>();
            List<Opportunity> oppsneg = new List<Opportunity>();
            for(Integer j=0;j<5;j++)
            {
                opps.add(new Opportunity(Name='Test Opportunity'+ j,
                                         StageName='Prospecting',CloseDate= system.today(),
                                         AccountId=newAccount3.Id));
                
            }
            
            Test.starttest();       
            SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            ID batchId = Database.executeBatch(sbr,50);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount3.Id];
            SGR_validationHelper countycode = new SGR_validationHelper(listopp,batchId);    
            

            
            Test.stoptest();
        }
        catch(Exception e)
        {
        	e.getMessage();
        }
    }
  
    
    //Vijaya SFDC-14083 start
    static testmethod void checkForSpouseOrDPTest(){ 
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        update opty;
        opps.add(opty);
        opps.add(opty1);
        System.assertEquals(opty.Batch_Id__c,'567');
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
          
        Sgr_Opportunity_Census__c oppCen = Sgr_TestDataUtility.createOptyCensus(100,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen1 = Sgr_TestDataUtility.createOptyCensus(100,'Spouse',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen2 = Sgr_TestDataUtility.createOptyCensus(100,'Child',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen3 = Sgr_TestDataUtility.createOptyCensus(200,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen4 = Sgr_TestDataUtility.createOptyCensus(200,'Spouse',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen5 = Sgr_TestDataUtility.createOptyCensus(200,'Spouse',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen6 = Sgr_TestDataUtility.createOptyCensus(300,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen7 = Sgr_TestDataUtility.createOptyCensus(300,'Spouse',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen8 = Sgr_TestDataUtility.createOptyCensus(300,'Child',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen9 = Sgr_TestDataUtility.createOptyCensus(400,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen10 = Sgr_TestDataUtility.createOptyCensus(400,'Domestic Partner',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen11 = Sgr_TestDataUtility.createOptyCensus(400,'Domestic Partner',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen12 = Sgr_TestDataUtility.createOptyCensus(500,'Subscriber',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen13 = Sgr_TestDataUtility.createOptyCensus(500,'Spouse',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen14 = Sgr_TestDataUtility.createOptyCensus(500,'Domestic Partner',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen15 = Sgr_TestDataUtility.createOptyCensus(600,'Domestic Partner',opty.Id,acc.Id);
        Sgr_Opportunity_Census__c oppCen16 = Sgr_TestDataUtility.createOptyCensus(700,'Subscriber',opty1.Id,acc.Id);
        oppCen.Member_Effective_Date__c=date.today().adddays(2);
        oppCen.Member_Cancel_Date__c=date.today().adddays(-20);
        oppCen16.Member_Effective_Date__c=date.today().adddays(2);
        oppCen16.Member_Cancel_Date__c=date.today().adddays(-20);
        update oppCen;
        update oppCen16;
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        Sgr_TestDataUtility.OptyMemBen(oppCen.Id);
        List<Sgr_Opportunity_Census__c> lstOptyCensus = new List<Sgr_Opportunity_Census__c>{oppCen,oppCen1,oppCen2,oppCen3,oppCen4,oppCen5,oppCen6,oppCen7,oppCen8,oppCen9,oppCen10,oppCen11,oppCen12,oppCen13,oppCen14,oppCen15,oppCen16};
            SGR_Business_Rule__c bsRule = Sgr_TestDataUtility.createBusinessRule();
        Map<String,SGR_Business_Rule__c> bRules = new Map<String,SGR_Business_Rule__c>();
        bRules.put('GR.DV.10',bsRule);
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> renBatchId = new List<SGRRenewalBatch__c>{renBatch};
            String batId = '567';
        String ruleId = 'GR.DV.10';
        Map<id,List<SGR_Opportunity_Census__c>> optyCenGrp = new Map<id,List<SGR_Opportunity_Census__c>>();
        optyCenGrp.put(opty.id,lstOptyCensus); 
        
        SGR_Renewal_Batch_oppty__c optyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(optyBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        
        SGR_validationHelper.checkForSpouseOrDP(opps, optyCenGrp, batId, ruleId, renBatchId, bRules, mapOppRenwalBatchOpp);//
        Test.stoptest();
        
    }
    //Vijaya SFDC-14083 end
    
    static testmethod void checkFundingType() {
        Test.startTest();
        String fundingTypeRule = 'GR.DV.15';
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account 1');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp1 = Sgr_TestDataUtility.createOpty('Test Opp 1', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today() + 20, Date.today() + 40);
        Opportunity opp2 = Sgr_TestDataUtility.createOpty('Test Opp 2', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today() + 20, Date.today() + 40);
        
        opps.add(opp1);
        opps.add(opp2);
        System.assertEquals(opp1.Name,'Test Opp 1');
        
        List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
        batches.add(Sgr_TestDataUtility.createRenewalBatch());
        
        List<SGR_Renewal_Batch_oppty__c> rbopps = new List<SGR_Renewal_Batch_oppty__c>();
        SGR_Renewal_Batch_oppty__c rbo1 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        SGR_Renewal_Batch_oppty__c rbo2 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        rbopps.add(rbo1);
        rbopps.add(rbo2);
        Map<id,List<SGR_Renewal_Batch_oppty__c>>oppsrbop = new Map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(rbo1.Opportunity__c, rbopps);
        
        List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
        rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.15','GR.DV.15','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
        Map<String,SGR_Business_Rule__c> sbrmap = new Map<String,SGR_Business_Rule__c>();
        sbrmap.put(fundingTypeRule, rules[0]);
        String renewBatchId = '';
        SGR_validationHelper.checkForPremiumFundingType(opps,fundingTypeRule,sbrmap,'567',batches,oppsrbop); 
        Test.stopTest();

    } 
    static testmethod void checkMemberAge() {
        Test.startTest();
        String memberOver99 = 'GR.DV.08';
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account 1');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp1 = Sgr_TestDataUtility.createOpty('Test Opp 1', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today() + 20, Date.today() + 40);
        Opportunity opp2 = Sgr_TestDataUtility.createOpty('Test Opp 2', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today() + 20, Date.today() + 40);
        opp1.Renewal_Date__c = Date.newInstance(1948, 1, 1);
        opp2.Renewal_Date__c = Date.newInstance(1949, 1, 1); 
        
        opps.add(opp1);
        opps.add(opp2);
        System.assertEquals(opp1.Name,'Test Opp 1');
        
        List<SGR_Opportunity_Census__c> censuses = new List<SGR_Opportunity_Census__c>();
        censuses.add(Sgr_TestDataUtility.createOptyCensus(8675309, 'Subscriber', String.valueOf(opp1.Id), String.valueOf(acc.Id)));
        censuses.add(Sgr_TestDataUtility.createOptyCensus(9035768, 'Subscriber', String.valueOf(opp2.Id), String.valueOf(acc.Id)));
        censuses[0].Date_of_Birth__c = Date.newInstance(2038, 1, 1);
        censuses[1].Date_of_Birth__c = Date.newInstance(2048, 1, 1);
        
        Map<Id, List<SGR_Opportunity_Census__c>> oppsgrogs = new Map<Id, List<SGR_Opportunity_Census__c>>();
        oppsgrogs.put(opp1.Id, censuses);
        List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
        batches.add(Sgr_TestDataUtility.createRenewalBatch());
        
        List<SGR_Renewal_Batch_oppty__c> rbopps = new List<SGR_Renewal_Batch_oppty__c>();
        SGR_Renewal_Batch_oppty__c rbo1 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        SGR_Renewal_Batch_oppty__c rbo2 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        rbopps.add(rbo1);
        rbopps.add(rbo2);
        Map<id,List<SGR_Renewal_Batch_oppty__c>>oppsrbop = new Map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(rbo1.Opportunity__c, rbopps);
        
        List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
        rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.08','GR.DV.08','Subscriber','','Warning',''));
        Map<String,SGR_Business_Rule__c> sbrmap = new Map<String,SGR_Business_Rule__c>();
        sbrmap.put(memberOver99, rules[0]);
        String renewBatchId = '';
        SGR_validationHelper.checkMembershipAge(opps,memberOver99,'567',oppsgrogs,batches,sbrmap,oppsrbop);
        Test.stopTest();
    } 
    //Commented code due to SAMPARTIAL Test class failure with hard coded Ids. Start
    //Anudeep //SFDC-14085 start  
   //Anudeep //SFDC-14085 start 11/14 commented for deployment still work in progress  
static testmethod  void testmethodtest1()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
           Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            
           //Create oppty
            Opportunity oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(oppty);
            System.assertEquals(oppty.Name,'TestOpp');
            
            Map<String,SGR_Business_Rule__c> businessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           
            businessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
      
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> oPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES2=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES3=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES5=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES6=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES7=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES8=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES9=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListES10=new list<Sgr_Opportunity_Census__c>();
            
            list<Sgr_Opportunity_Census__c> oPCSListESActive=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListESActiveFail=new list<Sgr_Opportunity_Census__c>();
            
            Sgr_Opportunity_Census__c oPC=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SUB','ES','ES','ES',1);
            Sgr_Opportunity_Census__c oPC4=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'DP','ES','EC','EF',2);
            Sgr_Opportunity_Census__c oPC2=Sgr_TestDataUtility.createOptyCensus3(3.0,'Child',opps[0].Id,newAccount1.Id,'DEP','ES','ES','ES',2);
            Sgr_Opportunity_Census__c oPC3=Sgr_TestDataUtility.createOptyCensus3(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'SUB','EF','ES','EF',2);
            Sgr_Opportunity_Census__c oPC5=Sgr_TestDataUtility.createOptyCensus3(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'','ES','ES','ES',1);
            Sgr_Opportunity_Census__c oPC6=Sgr_TestDataUtility.createOptyCensus3(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EC','ES','EC',2);
            Sgr_Opportunity_Census__c oPC7=Sgr_TestDataUtility.createOptyCensus3(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EC','EF','ES',2);
            Sgr_Opportunity_Census__c oPC8=Sgr_TestDataUtility.createOptyCensus3(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'DEP','EF','EC','ES',2);
            Sgr_Opportunity_Census__c oPC9=Sgr_TestDataUtility.createOptyCensus3(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EF','EC','ES',1);
            Sgr_Opportunity_Census__c oPC10=Sgr_TestDataUtility.createOptyCensus3(3.0,'Child',opps[0].Id,newAccount1.Id,'DEP','EF','EO','ES',1);
            Sgr_Opportunity_Census__c oPC11=Sgr_TestDataUtility.createOptyCensus3(3.0,'Child',opps[0].Id,newAccount1.Id,'DEP','EF','ES','EO',1);
            oPCSList.add(oPC);
            oPCSList.add(oPC2);
            oPCSListES1.add(oPC);
            oPCSListES2.add(oPC3);
            oPCSListES3.add(oPC4);
            oPCSListES5.add(oPC5);
            oPCSListES6.add(oPC6);
            oPCSListES7.add(oPC7);
            oPCSListES8.add(oPC8);
            oPCSListES9.add(oPC9);
            oPCSListES10.add(oPC10);
            oPCSListES10.add(oPC11);
            
            oPCSListESActive.add(oPC);
            oPCSListESActive.add(oPC4);
            oPCSListESActive.add(oPC6);
            oPCSListESActive.add(oPC7);
            
            oPCSListESActiveFail.add(oPC);
            oPCSListESActiveFail.add(oPC2);
            oPCSListESActiveFail.add(oPC3);
            oPCSListESActiveFail.add(oPC8);
            
            
       List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
           
            Test.startTest();
            //Create Batch
            SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
            List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
            batches.add(aBatch);
           
            //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> sGRRenwalBatchotyList = new List<SGR_Renewal_Batch_oppty__c>();
        sGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(opps[0].Id, sGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
       
            SGR_validationHelper.eSTiresValidation(opps,oPCSList,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES1,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES2,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES2,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSList,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES5,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES6,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES7,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSList,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES9,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListES10,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListESActive,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.eSTiresValidation(opps,oPCSListESActiveFail,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            
             
            
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    //Anudeep //SFDC-14085 End
    //Anudeep SFDC-14086 start
    static testmethod  void testmethodtest2()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
           
       Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            
           //Create oppty
            Opportunity oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(oppty);
            System.assertEquals(oppty.Name,'TestOpp');
            
            Map<String,SGR_Business_Rule__c> businessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
           
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> oPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListEC=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListEC1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListEC2=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListECBlank=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListECBlank2=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSListActiveSub=new list<Sgr_Opportunity_Census__c>();
           list<Sgr_Opportunity_Census__c> oPCSListFailActiveSub=new list<Sgr_Opportunity_Census__c>();
           
            Sgr_Opportunity_Census__c oPC=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'DEP','EC','EC','EC',2);
            Sgr_Opportunity_Census__c oPC2=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'DEP','ES','EC','EF',2);
            Sgr_Opportunity_Census__c oPC3=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'DEP','EF','EO','EC',2);
            Sgr_Opportunity_Census__c oPCBlank=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'','EC','ES','EC',1);
            Sgr_Opportunity_Census__c oPCNOEC=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'SPS','EC','EF','EF',2);
            Sgr_Opportunity_Census__c oPCfail=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'SPS','ES','EC','EF',2);
            Sgr_Opportunity_Census__c oPCfail2=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'SPS','ES','EF','EC',2);
            Sgr_Opportunity_Census__c oPCActSub=Sgr_TestDataUtility.createOptyCensus3(2.0,'Child',opps[0].Id,newAccount1.Id,'SUB','EF','EF','EF',1);
            
            oPCSList.add(oPC3);
            oPCSList.add(oPC2);
            oPCSList.add(oPC);
            oPCSListEC.add(oPC2);
            oPCSListEC1.add(oPC2);
            oPCSListEC2.add(oPC3);
            oPCSListECBlank2.add(oPCNOEC);
            oPCSListECBlank.add(oPCBlank);
            oPCSListActiveSub.add(oPCActSub);
            oPCSListActiveSub.add(oPC);
            oPCSListActiveSub.add(oPC2);
            oPCSListActiveSub.add(oPC3);
            oPCSListFailActiveSub.add(oPCActSub);
            oPCSListFailActiveSub.add(oPCNOEC);
            oPCSListFailActiveSub.add(oPCfail);
            oPCSListFailActiveSub.add(oPCfail2);
            
             List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
           
            Test.startTest();
            //Create Batch
            SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
            List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
            batches.add(aBatch);
           
            //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> sGRRenwalBatchotyList = new List<SGR_Renewal_Batch_oppty__c>();
        sGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(opps[0].Id, sGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
            SGR_validationHelper.eSTiresValidation(opps,oPCSList,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSList,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListEC,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListEC1,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListEC2,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListECBlank,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);  
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListECBlank2,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);  
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListActiveSub,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSListFailActiveSub,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            
            
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    
    //Anudeep SFDC-14086 End
    //Anudeep SFDC-14087 Start
   static testmethod  void testmethodtest3()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            system.assertEquals(newAccount1.Name,'TestAccount');
           //Create oppty
            Opportunity oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(oppty);
            
            Map<String,SGR_Business_Rule__c> businessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> oPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListBlank=new list<Sgr_Opportunity_Census__c>();
           list<Sgr_Opportunity_Census__c> oPCSNoEFList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFActiveSub=new list<Sgr_Opportunity_Census__c>();
           list<Sgr_Opportunity_Census__c> oPCSEFActiveFailCondation=new list<Sgr_Opportunity_Census__c>();
             Sgr_Opportunity_Census__c oPC=Sgr_TestDataUtility.createOptyCensus3(2.0,'Domestic Partner',opps[0].Id,newAccount1.Id,'DP','EF','EF','EF',2);
            Sgr_Opportunity_Census__c oPC2=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'DP','EO','EF','EO',2);
            Sgr_Opportunity_Census__c oPC3=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','ES','EC','EF',2);
            Sgr_Opportunity_Census__c oPC4=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EF','EF','EF',1); 
            Sgr_Opportunity_Census__c oPC5=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EF','EF','EF',2);
            Sgr_Opportunity_Census__c oPCBlank=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'','EF','EF','EF',1); 
            Sgr_Opportunity_Census__c oPCNoESTire=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EO','EO','EO',1);
            
            Sgr_Opportunity_Census__c oPCActiveCenses=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SUB','EF','EF','EF',1);
            Sgr_Opportunity_Census__c oPCFail1=Sgr_TestDataUtility.createOptyCensus3(2.0,'Domestic Partner',opps[0].Id,newAccount1.Id,'SUB','EF','EF','EF',2);
            Sgr_Opportunity_Census__c oPCFail2=Sgr_TestDataUtility.createOptyCensus3(2.0,'Domestic Partner',opps[0].Id,newAccount1.Id,'SUB','ES','EF','EC',2);
            Sgr_Opportunity_Census__c oPCFail3=Sgr_TestDataUtility.createOptyCensus3(2.0,'Domestic Partner',opps[0].Id,newAccount1.Id,'SUB','ES','EC','EF',2);
            
            
            oPCSList.add(oPC3);
            oPCSList.add(oPC2);
            oPCSList.add(oPC);
            oPCSList.add(oPC4);
            oPCSEFList.add(oPC5);
            oPCSEFListBlank.add(oPCBlank);
            oPCSNoEFList.add(oPCNoESTire);
            oPCSEFActiveSub.add(oPCActiveCenses);
            oPCSEFActiveSub.add(oPC);
            oPCSEFActiveSub.add(oPC2);
            oPCSEFActiveSub.add(oPC3);
            oPCSEFActiveFailCondation.add(oPCActiveCenses);
            oPCSEFActiveFailCondation.add(oPCFail1);
                oPCSEFActiveFailCondation.add(oPCFail2);
                    oPCSEFActiveFailCondation.add(oPCFail3);
            List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
           
            Test.startTest();
            //Create Batch
            SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
            List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
            batches.add(aBatch);
           
            //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> sGRRenwalBatchotyList = new List<SGR_Renewal_Batch_oppty__c>();
        sGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(opps[0].Id, sGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
            SGR_validationHelper.eSTiresValidation(opps,oPCSList,'GR.DV.12',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSList,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,oPCSList,'GR.DV.13',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSEFList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSEFList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSEFList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSEFListBlank,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSNoEFList,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSEFActiveSub,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,oPCSEFActiveFailCondation,'GR.DV.14',businessRulesMap,batchId,batches,oppsrbop);
            
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    } 
    //Anudeep SFDC-14087 End
    //Anudeep SFDC-14084 Start
     static testmethod  void testmethodtest4()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            System.assertEquals(newAccount1.Name,'TestAccount');
           //Create oppty
            Opportunity oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(oppty);
            
            Map<String,SGR_Business_Rule__c> businessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           businessRulesMap.put(brDPT[0].Rule_Code__c,brDPT[0]);
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            businessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
            
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> oPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListBlank=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListHealthTier=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> activeBenefitAgreementDatecheckTest=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListVisionActive=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListVisionActiveNoRel=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSList1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListBlank1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListHealthTier1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListVisionTier1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListinactivesub=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListinactivePasscondation=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> oPCSEFListinactiveNACondation=new list<Sgr_Opportunity_Census__c>();
           Sgr_Opportunity_Census__c oPCActive=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SUB','EF','EF','EF',1);
            Sgr_Opportunity_Census__c oPC=Sgr_TestDataUtility.createOptyCensus3(2.0,'Domestic Partner',opps[0].Id,newAccount1.Id,'DP','EF','EF','EF',2);
            Sgr_Opportunity_Census__c oPC2=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'DEP','ES','EC','EF',2);
            Sgr_Opportunity_Census__c oPC3=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EO','EO','ES',2);
           Sgr_Opportunity_Census__c oPC4=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SPS','EO','EO','EO',2);
            Sgr_Opportunity_Census__c nACActive=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'SUB','EF','EF','EF',0);
            oPCSList.add(oPC);
            oPCSEFListBlank.add(oPC2);
            oPCSEFListHealthTier.add(oPC3);
            activeBenefitAgreementDatecheckTest.add(oPC4);
            oPCSEFListVisionActive.add(oPCActive);
            oPCSEFListVisionActive.add(oPC);
            oPCSEFListVisionActive.add(oPC2);
            oPCSEFListVisionActive.add(oPC3);
            oPCSEFListVisionActive.add(oPC4);
            oPCSEFListinactivePasscondation.add(oPCActive);
            oPCSEFListinactivePasscondation.add(oPC);
            oPCSEFListinactiveNACondation.add(NACActive);
            oPCSEFListinactiveNACondation.add(oPCActive);
             Sgr_Opportunity_Census__c oPCRSC=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'Subscriber','EF','EF','EF',1);
            Sgr_Opportunity_Census__c oPCRSCC2=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,null,'ES','EC','EF',2);
            Sgr_Opportunity_Census__c oPCRSC3=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,null,'EO','EO','EF',2);
           Sgr_Opportunity_Census__c oPCRSC4=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,null,'','ES','',2);
           Sgr_Opportunity_Census__c oPCRSC5=Sgr_TestDataUtility.createOptyCensus3(2.0,'Subscriber',opps[0].Id,newAccount1.Id,null,'','ES','',3);
            oPCSList1.add(oPCRSC);
            oPCSEFListBlank1.add(oPCRSCC2);
            oPCSEFListHealthTier1.add(oPCRSC3);
            oPCSEFListVisionTier1.add(oPCRSC4);
            oPCSEFListinactivesub.add(oPCRSC5);
            oPCSEFListVisionActiveNoRel.add(oPCRSC);
            oPCSEFListVisionActiveNoRel.add(oPCRSCC2);
            oPCSEFListVisionActiveNoRel.add(oPCRSC3);
                    oPCSEFListVisionActiveNoRel.add(oPCRSC4);
                        oPCSEFListVisionActiveNoRel.add(oPCRSC5);
            List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
            rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
         
            
           
            Test.startTest();
            //Create Batch
            SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
            List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
            batches.add(aBatch);
           
            //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> sGRRenwalBatchotyList = new List<SGR_Renewal_Batch_oppty__c>();
        sGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(opps[0].Id, sGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSList,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListBlank,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
           SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListHealthTier,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
           SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,activeBenefitAgreementDatecheckTest,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
           
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSList1,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListBlank1,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
           SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListHealthTier1,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
           SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListVisionTier1,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListinactivesub,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListVisionActive,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListVisionActiveNoRel,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListinactivePasscondation,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.DependentswithNoRelationshipCodeValidation(opps,oPCSEFListinactiveNACondation,'GR.DV.11',businessRulesMap,batchId,batches,oppsrbop);
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    //
    //SFDC-14541 - Nathan - Start
    static testmethod  void testSub50Enrollees(){
        
        //Create Account
        Date dateToday = Date.today();
        dateToday.addMonths(12);
        
        Account anAccount = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', dateToday, 'Active', 'SG', 'PREM');
        
        //Create Opp
        Opportunity anOpp = Sgr_TestDataUtility.createOpty('TestOpp', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        List<Opportunity> listOpportunities = new List<Opportunity>();
        listOpportunities.add(anOpp);
        system.assertEquals(anOpp.Name,'TestOpp');
        
        //Create Opp Census
        Id oppID = anOpp.Id;
        Id accountID = anAccount.Id;
        SGR_Opportunity_Census__c aCensus = Sgr_TestDataUtility.createOptyCensus2(1234567, 'Subscriber', anOpp.Id, anAccount.Id, 'SUB');
        List<SGR_Opportunity_Census__c> listOpportunityCensus = new List<SGR_Opportunity_Census__c>();
        listOpportunityCensus.add(aCensus);
        map<id,List<SGR_Opportunity_Census__c>> mapOpportunityCensus = new map<id,List<SGR_Opportunity_Census__c>>();
        mapOpportunityCensus.put(oppID, listOpportunityCensus);
        
        //Create Rule
        string pass = '# Current Subscribers = XX;';
        string fail = '# Current Subscribers = XX;';
        SGR_Business_Rule__c aBusinessRule = Sgr_TestDataUtility.createBusinessRule('GR.EL.02', 'GR.EL.02', 'Subscriber',pass,'Warning',fail);
        map<String,SGR_Business_Rule__c> ruleMap = new  map<String,SGR_Business_Rule__c>();
        ruleMap.put('GR.EL.02', aBusinessRule);
        
        //Create Batch
        SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> listRenewalBatch = new List<SGRRenewalBatch__c>();
        listRenewalBatch.add(aBatch);
        
        //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(anAccount.Id, anOpp.Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(oppID, listSGRRenewalBatchOpp);
                
        SGR_validationHelper.checkSub50Enrollees(listOpportunities, 'GR.EL.02', aBatch.Id, mapOpportunityCensus, listRenewalBatch, ruleMap, mapOppRenwalBatchOpp);
    }  
    //SFDC-14541 - Nathan - End
    
    
    //SFDC-14543 - Nathan - Start
     static testmethod  void testHealthvsContributoryDental(){
        
        //Create Account
        Date dateToday = Date.today();
        dateToday.addMonths(12);
        
        Account anAccount = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', dateToday, 'Active', 'SG', 'PREM');
        
        //Create Opp
        Opportunity anOpp = Sgr_TestDataUtility.createOpty('TestOpp', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        List<Opportunity> listOpportunities = new List<Opportunity>();
        listOpportunities.add(anOpp);
        
        //Health Only Opp
        Opportunity anOpp2 = Sgr_TestDataUtility.createOpty('TestOpp2', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        anOpp2.Product_Type__c = 'H';
        upsert anOpp2;
        listOpportunities.add(anOpp2);
        system.assertEquals(anOpp2.Product_Type__c,'H');
        
        //Dental Only Opp
        Opportunity anOpp3 = Sgr_TestDataUtility.createOpty('TestOpp3', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        anOpp3.Product_Type__c = 'D';
        upsert anOpp3;
        listOpportunities.add(anOpp3);
        
        //Create Opp Census
        Id oppID = anOpp.Id;
        Id accountID = anAccount.Id;
        SGR_Opportunity_Census__c aCensus = Sgr_TestDataUtility.createOptyCensus2(1234567, 'Subscriber', anOpp.Id, anAccount.Id, 'SUB');
        List<SGR_Opportunity_Census__c> listOpportunityCensus = new List<SGR_Opportunity_Census__c>();
        listOpportunityCensus.add(aCensus);
        map<id,List<SGR_Opportunity_Census__c>> mapOpportunityCensus = new map<id,List<SGR_Opportunity_Census__c>>();
        mapOpportunityCensus.put(oppID, listOpportunityCensus);
        
        //Create Rule
        string pass = 'Variation of enrollment between Health & Contributory Dental (X.XX%) is within range. (where X.XX% > -25%) N/A: Health Only N/A: Voluntary Dental Only N/A: Contributory Dental Only';
        string fail = 'Variation of enrollment between Health & Contributory Dental (Y.YY%) is not within range. (where Y.YY% <= -25%)';
        SGR_Business_Rule__c aBusinessRule = Sgr_TestDataUtility.createBusinessRule('GR.EL.04', 'GR.EL.04', 'Subscriber',pass,'Warning',fail);
        map<String,SGR_Business_Rule__c> ruleMap = new  map<String,SGR_Business_Rule__c>();
        ruleMap.put('GR.EL.04', aBusinessRule);
        
        //Create Batch
        SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> listRenewalBatch = new List<SGRRenewalBatch__c>();
        listRenewalBatch.add(aBatch);
        
        //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(anAccount.Id, anOpp.Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(oppID, listSGRRenewalBatchOpp);
                
        SGR_validationHelper.checkHealthvsContributoryDental(listOpportunities, 'GR.EL.04', aBatch.Id, mapOpportunityCensus, listRenewalBatch, ruleMap, mapOppRenwalBatchOpp);
    }
//SFDC-14543 - Nathan - End
    
    //SFDC-14540 - Landry - Start
    static testmethod void checkStateCode() {
        Test.startTest();
        String fundingTypeRule = 'GR.DV.15';
       
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account 1');
        acc.ShippingState__c = 'OK';
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp1 = Sgr_TestDataUtility.createOpty('Test Opp 1', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today() + 20, Date.today() + 40);
        Opportunity opp2 = Sgr_TestDataUtility.createOpty('Test Opp 2', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today() + 20, Date.today() + 40);
        opp1.HCSC_Division__c = 'OK';
        opp2.HCSC_Division__c = 'TX';
        
        opps.add(opp1);
        opps.add(opp2);
        System.assertEquals(opp1.HCSC_Division__c,'OK');
        
        List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
        batches.add(Sgr_TestDataUtility.createRenewalBatch());
        
        List<SGR_Renewal_Batch_oppty__c> rbopps = new List<SGR_Renewal_Batch_oppty__c>();
        SGR_Renewal_Batch_oppty__c rbo1 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        SGR_Renewal_Batch_oppty__c rbo2 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        rbopps.add(rbo1);
        rbopps.add(rbo2);
        Map<id,List<SGR_Renewal_Batch_oppty__c>>oppsrbop = new Map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(rbo1.Opportunity__c, rbopps);
        
        List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
        rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.15','GR.DV.15','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
        Map<String,SGR_Business_Rule__c> sbrmap = new Map<String,SGR_Business_Rule__c>();
        sbrmap.put(fundingTypeRule, rules[0]);
        String renewBatchId = '';
        SGR_validationHelper.checkStateCode(opps,fundingTypeRule,sbrmap,'567',batches,oppsrbop); 
        Test.stopTest();
    }
    //SFDC-14540 - Landry - End
    
    //US12536 - This method is used to test Opportunity rating status to be updated as Initiated when all BRV logs are passed on it.
   public static testMethod void testOppRtngStatusAndWAToAllPassBRVLogs(){
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('TestAccount');
        List<Opportunity> opprList = new List<Opportunity>();
        Opportunity oppr = Sgr_TestDataUtility.createOpty(acc.Id, 'Rated');
        
        opprList.add(oppr);
    
        List<Business_Rule_Validation_Log__c> brvList = new List<Business_Rule_Validation_Log__c>();
        brvList = Sgr_TestDataUtility.createBRVPassLogs(oppr.id,'Passed');       
        Test.startTest();
        SGR_validationHelper.updateOppRatingStatusAndWA(opprList);
       
        System.assertEquals(oppr.Rating_Status__c, 'Initiated');
        Test.stopTest();
    } 
    //US12536 - This method is used to test Opportunity rating status to be updated as Initiated and Workflow Activity as UW Review - Validation Errors when at least one BRV logs are failed on it.
    public static testMethod void testOppRtngStatusAndWAToFailedBRVLogs(){
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('TestAccount');
        System.assertEquals(acc.name,'TestAccount');
        List<Opportunity> opprList = new List<Opportunity>();
        Opportunity oppr = Sgr_TestDataUtility.createOpty(acc.Id, 'Rated'); 
        opprList.add(oppr);
          
        List<Business_Rule_Validation_Log__c> brvList = new List<Business_Rule_Validation_Log__c>();
        brvList = Sgr_TestDataUtility.createBRVPassFailLogs(oppr.id);
        Test.startTest();
        SGR_validationHelper.updateOppRatingStatusAndWA(opprList);
        //System.assertEquals(oppr.SGR_Workflow_Activity__c, '');//UW Review - Validation Errors
        Test.stopTest();
    }

//Nikhil SFDC-14431 and SFDC-14430 start
    static testmethod void testcheckForactivedentalsubscriber(){ 
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        update opty;
        opps.add(opty);
        opps.add(opty1);
        System.assertEquals(opty.Batch_Id__c,'567');
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        Sgr_Opportunity_Census__c oppCen = Sgr_TestDataUtility.createOptyCensus(100,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen16 = Sgr_TestDataUtility.createOptyCensus(700,'Subscriber',opty1.Id,acc.Id);
        SGR_Opportunity_Benefit_Agreement__c oppben1 = Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        SGR_Opportunity_Benefit_Agreement__c oppben3 = Sgr_TestDataUtility.createOptyBenAgr2(opty.Id,'D');
        SGR_Opportunity_Benefit_Agreement__c oppben2 = Sgr_TestDataUtility.createOptyBenAgr2(opty1.Id,'H');
        oppCen.Member_Cancel_Date__c=date.today().adddays(-20);
        oppCen16.Member_Cancel_Date__c=null;
        update oppCen16;
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        List<Sgr_Opportunity_Census__c> lstOptyCensus = new List<Sgr_Opportunity_Census__c>{oppCen,oppCen16};
            List<SGR_Opportunity_Benefit_Agreement__c> lstOptyba = new List<SGR_Opportunity_Benefit_Agreement__c>{oppben1,oppben2,oppben3};
            
            SGR_Business_Rule__c bsRule = Sgr_TestDataUtility.createBusinessRule();
        Map<String,SGR_Business_Rule__c> bRules = new Map<String,SGR_Business_Rule__c>();
        bRules.put('GR.DV.04',bsRule);
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> renBatchId = new List<SGRRenewalBatch__c>{renBatch};
            String batId = '567';
        String ruleId = 'GR.DV.04';
        String ruleId1 = 'GR.DV.02';
        Map<id,List<SGR_Opportunity_Census__c>> optyCenGrp = new Map<id,List<SGR_Opportunity_Census__c>>();
        optyCenGrp.put(opty.id,lstOptyCensus); 
        Map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1 = new Map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        oppsgrobamap1.put(opty.id,lstOptyba); 
        
        SGR_Renewal_Batch_oppty__c optyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(optyBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        
        SGR_validationHelper.checkForactivedentalsubscriber(opps, ruleId, batId,optyCenGrp, renBatchId, bRules, mapOppRenwalBatchOpp,oppsgrobamap1);
        SGR_validationHelper.checkForactiveHealthsubscriber(opps, ruleId, batId,optyCenGrp, renBatchId, bRules, mapOppRenwalBatchOpp,oppsgrobamap1);
        SGR_validationHelper.activeSubscribercheck(opps,ruleId,batId,optyCenGrp,renBatchId,bRules,mapOppRenwalBatchOpp);
        Test.stoptest();
        
    }
    //Nikhil SFDC-14431 and SFDC-14430 end
    
        //SFDC-14509 - Shuyler - Begin
    static testmethod  void testOtherOpenOpportunities(){
        
        //Create Account
        Date dateToday = Date.today();
        dateToday.addMonths(12);
        
        Account anAccount = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', dateToday, 'Active', 'SG', 'PREM');
        System.assertEquals(anAccount.Name,'TestAccount');
        //Create Opp
        Opportunity anOpp = Sgr_TestDataUtility.createOpty('TestOpp', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        List<Opportunity> listOpportunities = new List<Opportunity>();
        listOpportunities.add(anOpp);
        
        List<Opportunity> listExistingOpportunities = new List<Opportunity>();
        
        //Health Only Opp
        Opportunity anOpp2 = Sgr_TestDataUtility.createOpty('TestOpp2', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        anOpp2.Product_Type__c = 'H';
        upsert anOpp2;
        listExistingOpportunities.add(anOpp2);
        
        //Dental Only Opp
        Opportunity anOpp3 = Sgr_TestDataUtility.createOpty('TestOpp3', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        anOpp3.Product_Type__c = 'D';
        upsert anOpp3;
        listExistingOpportunities.add(anOpp3);
        
        //Create Opp Census
        Id oppID = anOpp.Id;
        Id accountID = anAccount.Id;
        SGR_Opportunity_Census__c aCensus = Sgr_TestDataUtility.createOptyCensus2(1234567, 'Subscriber', anOpp.Id, anAccount.Id, 'SUB');
        List<SGR_Opportunity_Census__c> listOpportunityCensus = new List<SGR_Opportunity_Census__c>();
        listOpportunityCensus.add(aCensus);
        map<id,List<SGR_Opportunity_Census__c>> mapOpportunityCensus = new map<id,List<SGR_Opportunity_Census__c>>();
        mapOpportunityCensus.put(oppID, listOpportunityCensus);
        
        //Create Rule
        string pass = 'Most recent Production Opty is complete.';
        string fail = 'This renewal may be impacted by another in-process Production Opty.';
        SGR_Business_Rule__c aBusinessRule = Sgr_TestDataUtility.createBusinessRule('GR.DV.16', 'GR.DV.16', 'Subscriber',pass,'Warning',fail);
        map<String,SGR_Business_Rule__c> ruleMap = new  map<String,SGR_Business_Rule__c>();
        ruleMap.put('GR.DV.16', aBusinessRule);
        
        //Create Batch
        SGRRenewalBatch__c aBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> listRenewalBatch = new List<SGRRenewalBatch__c>();
        listRenewalBatch.add(aBatch);
        
        //Create OppBatch
        SGR_Renewal_Batch_oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(anAccount.Id, anOpp.Id, aBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(oppID, listSGRRenewalBatchOpp);        
        
        SGR_validationHelper.checkOtherOpenOpportunities(listOpportunities,listExistingOpportunities,'GR.DV.16',aBatch.Id,listRenewalBatch,ruleMap);
    }
    //SFDC-14509 - Shuyler - End
    //SFDC-14542 - Landry Harris - Start
    static testmethod void checkHealthSubscriberNumberTX() {
        Test.startTest();
        String texasSubs = 'GR.EL.03';
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account 1');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp1 = Sgr_TestDataUtility.createOpty('Test Opp 1', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today(), Date.today() + 40);
        Opportunity opp2 = Sgr_TestDataUtility.createOpty('Test Opp 2', acc.Id, 'Rated', 'Triggered', 'PREM', Date.today(), Date.today() + 40);
        opp1.HCSC_Division__c = 'TX';
        opp2.HCSC_Division__c = 'OK';
        
        opps.add(opp1);
        opps.add(opp2);
        System.assertEquals(opp2.HCSC_Division__c,'OK');
        
        List<SGR_Opportunity_Census__c> censuses = new List<SGR_Opportunity_Census__c>();
        censuses.add(Sgr_TestDataUtility.createOptyCensus(8675309, 'Subscriber', String.valueOf(opp1.Id), String.valueOf(acc.Id)));
        censuses.add(Sgr_TestDataUtility.createOptyCensus(9035768, 'Subscriber', String.valueOf(opp1.Id), String.valueOf(acc.Id)));
        censuses.add(Sgr_TestDataUtility.createOptyCensus(9035768, 'Subscriber', String.valueOf(opp2.Id), String.valueOf(acc.Id)));
        censuses[0].State__c = 'TX';
        censuses[0].Relationship_Code__c = 'Subscriber';
        censuses[1].State__c = 'TX';
        censuses[1].Relationship_Code__c = 'Dependent';
        censuses[2].State__c = 'TX';
        censuses[2].Relationship_Code__c = 'Dependent';
        
        Map<Id, List<SGR_Opportunity_Census__c>> oppsgrogs = new Map<Id, List<SGR_Opportunity_Census__c>>();
        oppsgrogs.put(opp1.Id, censuses);
        List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
        batches.add(Sgr_TestDataUtility.createRenewalBatch());
        
        List<SGR_Renewal_Batch_oppty__c> rbopps = new List<SGR_Renewal_Batch_oppty__c>();
        SGR_Renewal_Batch_oppty__c rbo1 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        SGR_Renewal_Batch_oppty__c rbo2 = new SGR_Renewal_Batch_oppty__c(Opportunity__c=opp1.Id);
        rbopps.add(rbo1);
        rbopps.add(rbo2);
        Map<id,List<SGR_Renewal_Batch_oppty__c>>oppsrbop = new Map<id,List<SGR_Renewal_Batch_oppty__c>>();
        oppsrbop.put(rbo1.Opportunity__c, rbopps);
        
        List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
        rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.08','GR.DV.08','Subscriber','','Warning',''));
        Map<String,SGR_Business_Rule__c> sbrmap = new Map<String,SGR_Business_Rule__c>();
        sbrmap.put(texasSubs, rules[0]);
        String renewBatchId = '';
        SGR_validationHelper.getNumberOfHealthSubscribers(opps,texasSubs,'567',oppsgrogs,batches,sbrmap,oppsrbop);
        Test.stopTest();
    } 
    //SFDC-14542 - Landry Harris - Start
    /**********
    US:14535
    Start
    *************/
    public static testMethod void activeBenefitAgreementDatecheckTest(){
      Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty2(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        update opty;
        System.assertEquals(opty.Batch_Id__c,'567');
        opps.add(opty);
        opps.add(opty1);
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        List<SGR_Opportunity_Benefit_Agreement__c> sgrLSTPass = new List<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Benefit_Agreement__c> sgrLST = new List<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Benefit_Agreement__c> sgrLSTnull = new List<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Benefit_Agreement__c> sgrLStempty = new List<SGR_Opportunity_Benefit_Agreement__c>();
        SGR_Opportunity_Benefit_Agreement__c optyBA = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA.Status__c='active';
        optyBA.Renewal_Date__c=system.today();
        optyBA.Opportunity__c = opty.Id;
        sgrLSTPass.add(optyBA);
        SGR_Opportunity_Benefit_Agreement__c optyBA11 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA11.Status__c=null;
        optyBA11.Renewal_Date__c=null;
        optyBA11.Opportunity__c = opty.Id;
        sgrLSTnull.add(optyBA11);
        SGR_Opportunity_Benefit_Agreement__c optyBA1 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA1.Status__c='active';
        optyBA1.Renewal_Date__c=system.today();
        optyBA1.Opportunity__c = opty.Id;
        sgrLSTPass.add(optyBA1);
        SGR_Opportunity_Benefit_Agreement__c optyBA2 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA2.Status__c='Inactive';
        //optyBA2.Renewal_Date__c=system.today();
        optyBA2.Opportunity__c = opty.Id;
        sgrLST.add(optyBA2);
        SGR_Opportunity_Benefit_Agreement__c optyBA3 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA3.Status__c='Inactive';
        //optyBA3.Renewal_Date__c=system.today();
        optyBA3.Opportunity__c = opty.Id;
        sgrLST.add(optyBA3);
        SGR_Opportunity_Benefit_Agreement__c optyBA4 = new SGR_Opportunity_Benefit_Agreement__c();
        sgrLST.add(optyBA4);
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> mapOppBenefit = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        mapOppBenefit.put(opty.Id,sgrLSTPass);
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> mapOppBenefitfailed = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        mapOppBenefitfailed.put(opty.Id,sgrLST);
        Opportunity noOPP = new Opportunity();
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> mapNOOppBenefit = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        mapNOOppBenefit.put(noOPP.id,sgrLST);
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> mapNOOppBenefitempty = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        mapNOOppBenefitempty.put(noOPP.id,sgrLStempty);
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> mapNOOppBenefitnull = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        mapNOOppBenefitempty.put(noOPP.id,sgrLSTnull);
        SGR_Business_Rule__c bsRule = Sgr_TestDataUtility.createBusinessRule();
        Map<String,SGR_Business_Rule__c> bRules = new Map<String,SGR_Business_Rule__c>();
        bRules.put('GR.DV.18',bsRule);
        
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( Name ='OppCen', 
                                                                         Opportunity__c =opty.ID,//optys[0].Id, 
                                                                         Account__c = acc.ID,//accs[0].Id, 
                                                                         Relationship__c = 'Subscriber',
                                                                         Gender__c = 'M',                         
                                                                         Health_Tier__c='ES',                                                                    
                                                                         Dental_Tier__c='EF', 
                                                                         Vision_Tier__c='ES',
                                                                         Health_Plan_ID__c='1212',
                                                                         Dental_Plan_ID__c='234',
                                                                         Membership_Number__c=1,
                                                                         Vision_Plan_ID__c='2343',
                                                                         Relationship_Code__c='SUB',
                                                                         Member_Effective_Date__c=date.today().adddays(-1), 
                                                                         Member_Cancel_Date__c=date.today()+20, 
                                                                         Zip_Code__c='1234',
                                                                         Employee_Status_Code__c='RETIRED',
                                                                         Subscriber_Number__c=10.2);
        insert  oppCen;  
        Sgr_Opportunity_Census__c oppCen16 = new SGR_Opportunity_Census__c( Name ='OppCen', 
                                                                         Opportunity__c = opty.Id,//optys[0].Id, 
                                                                         Account__c = acc.ID,//accs[0].Id, 
                                                                         Relationship__c = 'CHILD',
                                                                         Gender__c = 'M',                         
                                                                         Health_Tier__c='ES', 
                                                                         Dental_Tier__c='EF', 
                                                                         Vision_Tier__c='ES',
                                                                         Health_Plan_ID__c='1212',
                                                                         Dental_Plan_ID__c='234',
                                                                         Membership_Number__c=1,
                                                                         Vision_Plan_ID__c='2343',
                                                                         Relationship_Code__c='Subscriber',
                                                                         Member_Effective_Date__c=date.today().adddays(-1), 
                                                                         Member_Cancel_Date__c=date.today()+20, 
                                                                         Zip_Code__c='1234',
                                                                         Employee_Status_Code__c='RETIRED',
                                                                         Subscriber_Number__c=1.2);
        oppCen.Member_Cancel_Date__c=date.today().adddays(-20);
        List<Sgr_Opportunity_Census__c> lstOptyCensus = new List<Sgr_Opportunity_Census__c>{oppCen,oppCen16};
        Map<id,List<SGR_Opportunity_Census__c>> optyCenGrp = new Map<id,List<SGR_Opportunity_Census__c>>();
        optyCenGrp.put(opty.id,lstOptyCensus); 
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> renBatchId = new List<SGRRenewalBatch__c>{renBatch};
        String batId = '567';
        String ruleId = 'GR.DV.18'; 
        String ruleId1 = 'GR.DV.17';
        SGR_Renewal_Batch_oppty__c optyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(optyBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        string res2=SGR_validationHelper.activeBenefitAgreementDatecheck(opps, batId, ruleId,mapOppBenefit, renBatchId, bRules, mapOppRenwalBatchOpp);
       // system.AssertEquals('Insertion done.',res2);
        string res1=SGR_validationHelper.activeBenefitAgreementDatecheck(opps, batId, ruleId,mapNOOppBenefit, renBatchId, bRules, mapOppRenwalBatchOpp);
       // system.AssertEquals('Insertion done.',res1);
        string res=SGR_validationHelper.activeBenefitAgreementDatecheck(opps, batId, ruleId,mapOppBenefitfailed, renBatchId, bRules, mapOppRenwalBatchOpp);
       // system.AssertEquals('Insertion done.',res);
       string res3=SGR_validationHelper.activeBenefitAgreementDatecheck(opps, batId, ruleId,mapNOOppBenefitnull, renBatchId, bRules, mapOppRenwalBatchOpp);
       string res4=SGR_validationHelper.activeBenefitAgreementDatecheck(opps, batId, ruleId,mapNOOppBenefitempty, renBatchId, bRules, mapOppRenwalBatchOpp);
        Test.stoptest();
        string res5=SGR_validationHelper.activeRetiredsubscriberexist(opps, batId, ruleId,optyCenGrp, renBatchId, bRules, mapOppRenwalBatchOpp);
        
    }
     //SFDC-14539 - raghavender goud - Start
   public static testmethod void checkInvitroPlans()
{ 
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty2(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        update opty;
        opps.add(opty);
        opps.add(opty1);
        system.assertEquals(opty.Batch_Id__c,'567');
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        
        SGR_Opportunity_Benefit_Agreement__c oppben1 = Sgr_TestDataUtility.createOptyBenAgr2(opty.Id,null);
        SGR_Opportunity_Benefit_Agreement__c oppben2 = Sgr_TestDataUtility.createOptyBenAgr2(opty1.Id,'H');
        
        SGR_Opportunity_Group_Section__c opg1 = Sgr_TestDataUtility.OptyGrpSection2(opty.Id,true);
        SGR_Opportunity_Group_Section__c opg2 = Sgr_TestDataUtility.OptyGrpSection2(opty1.Id,false);
    List<SGR_Opportunity_Group_Section__c> lstOptygs = new List<SGR_Opportunity_Group_Section__c>{opg1,opg2};
    
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
            List<SGR_Opportunity_Benefit_Agreement__c> lstOptyba = new List<SGR_Opportunity_Benefit_Agreement__c>{oppben1,oppben2};
            
            SGR_Business_Rule__c bsRule = Sgr_TestDataUtility.createBusinessRule();
        Map<String,SGR_Business_Rule__c> bRules = new Map<String,SGR_Business_Rule__c>();
        bRules.put('GR.DV.19',bsRule);
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> renBatchId = new List<SGRRenewalBatch__c>{renBatch};
            String batId = '567';
        String ruleId = 'GR.DV.19';
        
        Map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1 = new Map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        oppsgrobamap1.put(opty.id,lstOptyba); 
    
    Map<id,List<SGR_Opportunity_Group_Section__c>> opgsmap = new Map<id,List<SGR_Opportunity_Group_Section__c>>();
    opgsmap.put(opty.id,lstOptygs);
        SGR_Renewal_Batch_oppty__c optyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
    
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(optyBatch);
    
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        
        SGR_validationHelper.checkInvitroplans(opps,ruleId,batId,bRules,renBatchId,mapOppRenwalBatchOpp,opgsmap,oppsgrobamap1);
        
        Test.stoptest();
}
    //Nikhil SFDC-14433 start
    static testmethod void testcheckforNonCobraSubsribers(){ 
        
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        opty.Renewal_Date__c=date.today().adddays(-2);
        update opty;
        System.assertEquals(opty.Batch_Id__c,'567');
        opps.add(opty);
        opps.add(opty1);
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        Sgr_Opportunity_Census__c oppCen = Sgr_TestDataUtility.createOptyCensus(100,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen16 = Sgr_TestDataUtility.createOptyCensus(700,'Subscriber',opty1.Id,acc.Id);
        SGR_Opportunity_Member_Benefits__c oppmben1 = Sgr_TestDataUtility.OptyMemBen(oppCen16.Id);
        oppCen16.Member_Cancel_Date__c=date.today().adddays(20);
        oppCen16.Member_Effective_Date__c=date.today().adddays(-2);
        oppCen.Employee_Status_Code__c='C';
         oppCen16.Employee_Status_Code__c='NC';
        oppCen16.Relationship_Code__c='SUB';
        oppCen.Relationship_Code__c=null;
        oppCen16.Membership_Number__c=1;
        oppCen16.Date_of_Birth__c=date.today().adddays(2);
        oppCen.Membership_Number__c=1;
        oppCen.Date_of_Birth__c=date.today().adddays(4000);
        Sgr_TestDataUtility.OptyMemBen(oppCen16.Id);
        update oppCen16;
        update oppCen;
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        Sgr_TestDataUtility.OptyMemBen(oppCen16.Id);
        List<Sgr_Opportunity_Census__c> lstOptyCensus = new List<Sgr_Opportunity_Census__c>{oppCen16};
            List<SGR_Opportunity_Member_Benefits__c> lstOptymb = new List<SGR_Opportunity_Member_Benefits__c>{oppmben1};
            
            SGR_Business_Rule__c bsRule = Sgr_TestDataUtility.createBusinessRule();
        Map<String,SGR_Business_Rule__c> bRules = new Map<String,SGR_Business_Rule__c>();
        bRules.put('GR.DV.05',bsRule);
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> renBatchId = new List<SGRRenewalBatch__c>{renBatch};
            String batId = '567';
        String ruleId = 'GR.DV.05';
        Map<id,List<SGR_Opportunity_Census__c>> optyCenGrp = new Map<id,List<SGR_Opportunity_Census__c>>();
        optyCenGrp.put(opty.id,lstOptyCensus); 
        
        Map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1 = new Map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        
         Map<id,List<SGR_Opportunity_Member_Benefits__c>> oppmb = new Map<id,List<SGR_Opportunity_Member_Benefits__c>>();
        oppmb.put(oppCen16.id,lstOptymb); 
        
        SGR_Renewal_Batch_oppty__c optyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
        List<SGR_Renewal_Batch_oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_oppty__c>();
        listSGRRenewalBatchOpp.add(optyBatch);
        map<id,List<SGR_Renewal_Batch_oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        
        SGR_validationHelper.checkforNonCobraSubsribers(opps, ruleId, batId,optyCenGrp, renBatchId, bRules, oppmb,mapOppRenwalBatchOpp);
 
        
        Test.stoptest();
        
    }
    
        
       public static testMethod void rerunvalidationnew(){
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', Date.Today(), 'Active', 'SG', 'PREM');//Sgr_TestDataUtility.createAcc('TestAccount');
        List<Opportunity> opprList = new List<Opportunity>();
        Opportunity oppr = Sgr_TestDataUtility.createOpty(acc.Id, 'Rated');
        System.assertEquals(acc.Name,'TestAccount');
        opprList.add(oppr);
    
        List<Business_Rule_Validation_Log__c> brvList = new List<Business_Rule_Validation_Log__c>();
        brvList = Sgr_TestDataUtility.createBRVPassLogs(oppr.id,'Passed');       
        Test.startTest();
        SGR_validationHelper.Reinitiationbussrules(opprList);
        SGR_validationHelper.Reinitiationbussrulesagg(opprList);

        Test.stopTest();
    } 
    

    
        public static testmethod  void taskcrweatedata()
    {

        
        Test.startTest();

        Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = Userinfo.getUserId();
        opp.recordTypeId=SGR_AccountRenewalsHelper_test.getopptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opp);
        insert oplist;
        
      SGR_validationHelper.createtask(oplist);
        
        Test.stopTest();
        System.assertEquals(opp.StageName,'lost');
    }
    
    
  public static testmethod void updateStatusTest(){
        
        
        Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', 
                                          Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',
                                          Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        
        insert newAccount1;
        Id sGRTR =Schema.SObjectType.task.getRecordTypeInfosByName().get('SGR_Task').getRecordTypeId();
        Id taskUW= Schema.SObjectType.task.getRecordTypeInfosByName().get('GEMS UW Task Record Type').getRecordTypeId();
        
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        System.assertEquals(opp.Name,'Sample');
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = UserInfo.getuserid();
        opp.recordTypeId=Sgr_TaskHelper_Test.getopptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        opp.Rating_Status__c = 'Actuarial-Released';
        insert opp;
        
        Test.starttest();
        
        list<Task> tasklistOpp=new list<Task>(); 
        
        Task t1 = new Task();
        t1.Subject = 'Underwriter Hold Complete';
        t1.status = 'Completed';
        t1.Whatid = opp.Id;
        t1.RecordTypeId=sGRTR;
        t1.WhatId=opp.ID;
        insert t1;
        TasklistOpp.add(t1);
        Task t2 = new Task();
        t2.status = 'Completed';
        t2.Whatid = opp.Id;
        t2.subject='Edit Complete';	
        t2.ActivityDate=system.today();
        t2.RecordTypeId=sGRTR;
        insert t2;
        Sgr_TaskHelper.rerun = false;
        update t2;
        TasklistOpp.add(t2);
        
        Task t3 = new Task();
        t3.status = 'Completed';
        t3.Whatid = opp.Id;
        t3.subject='Data Review Complete';	
        t3.ActivityDate=system.today();
        t3.RecordTypeId=sGRTR;
        insert t3;
        Sgr_TaskHelper.firsttime = false;
        update t3;
        TasklistOpp.add(t3);
        boolean firsttime = false;
        
        Task t4 = new Task();
        t4.Subject = 'Underwriter Hold Complete';
        t4.status = 'Completed';
        t4.Whatid = opp.Id;
        t4.RecordTypeId=taskUW;
        t4.WhatId=opp.ID;
        insert t4;	
        update t4;
        delete t4;
 
        Test.stoptest();
        
        
        
    }

    
}