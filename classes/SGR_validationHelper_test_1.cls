@istest
public class SGR_validationHelper_test_1 
{
    
    /*static testmethod  void CheckCountyCodetest()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount1 = new Account(Name = 'Test Account', external_ID__c ='AC12345', HCSC_Division__c = 'IL',Product_Type__c='HD', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',ShippingPostalCode__c='123456789');
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c=1234, Product_Type__c='HD',external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',ShippingPostalCode__c='123456');
            List<Account> accList = new List<Account>();
            accList.add(newAccount1);
            accList.add(newAccount2); 
            insert accList;
            
            Benefit_Agreement__c bac=new Benefit_Agreement__c();
            bac.Group_Account__c = newAccount1.id;
            bac.Status__c = 'Active';
            insert bac; 
            
            
            Group_Section__c gs = new Group_Section__c();
            gs.Group_Account__c=newAccount1.id;
            gs.Benefit_Agreement_Cancel_Date__c=system.today();
            insert gs;
            
            List<SGR_Account_Census__c> sa = new List<SGR_Account_Census__c>();
            SGR_Account_Census__c sac = new SGR_Account_Census__c();
            sac.Account__c=newAccount1.id;
            sac.Relationship__c='Subscriber';
            sac.Gender__c='M';
            sac.Zip_Code__c=string.valueof(12345);
            sac.Member_Cancel_Date__c=system.today().adddays(+2);
            sac.Membership_Number__c=1;
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
            
            List<SGR_Business_Rule__c> brActvSubCount = new List<SGR_Business_Rule__c>();
            bragree.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.EL.02'));
            insert brActvSubCount;
            
            SGR_Account_Member_Benefit__c sam = new SGR_Account_Member_Benefit__c();
            sam.Account__c=newAccount1.id;
            sam.Group_Section__c=gs.id;
            sam.Account_Census__c=sac.id;
            insert  sam;
            
            
            Account acc = new Account(name='Test Account',Country_Code__c='12');
            insert acc;
            
            //String BatchId ='7074D00000RD90BQAT';
            List<Opportunity> opps = new List<Opportunity>();
            List<Opportunity> oppsneg = new List<Opportunity>();
            for(Integer j=0;j<5;j++)
            {
                opps.add(new Opportunity(Name='Test Opportunity'+ j,
                                         StageName='Prospecting',CloseDate= system.today(),Zip_Code__c=string.valueof(123.45),
                                         AccountId=acc.Id));
                
            }
            
            //   opps.add(new Opportunity(Name='Test Opportunity',StageName='Prospecting',CloseDate= system.today(),County_Code__c = 'Code',AccountId=acc.Id));
            insert opps;
            list<opportunity> listopp = new list<opportunity>();
            listopp = [select id,accountid,County_Code__c from opportunity where accountid = :acc.id];
            
            Test.starttest();
            
            //SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            //ID batchId = Database.executeBatch(sbr,50);
            
           // SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
           // Database.executeBatch(svc,50);
            //SGR_validationHelper Countycode = new SGR_validationHelper(listopp,BatchId);
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    
    static testmethod  void testmethod2(){
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            
            
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c=1234, external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
            List<Account> accList = new List<Account>();
            
            accList.add(newAccount2); 
            insert accList;
            Benefit_Agreement__c bac=new Benefit_Agreement__c();
            bac.Group_Account__c = newAccount2.id;
            bac.Status__c = 'Cancelled';
            insert bac; 
            
            List<SGR_Account_Census__c> sa = new List<SGR_Account_Census__c>();
            SGR_Account_Census__c sac = new SGR_Account_Census__c();
            sac.Account__c=newAccount2.id;
            sac.Relationship__c='Subscriber';
            sac.Gender__c='M';
            sac.Zip_Code__c=string.valueof(12345);
            sac.Member_Cancel_Date__c=system.today().adddays(+2);
            sac.Membership_Number__c=2;
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
                                         StageName='Prospecting',CloseDate= system.today(),
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
            
            SGR_validationHelper Countycode = new SGR_validationHelper(listopp,BatchId);    
            
            Test.stoptest();
        }
        catch(Exception e)
        {
            
            
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
            
            
            
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c=1234, external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
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
            sac.Membership_Number__c=1;
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
                                         StageName='Prospecting',CloseDate= system.today(),
                                         AccountId=newAccount3.Id));
                
            }
            
            Test.starttest();       
            SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            ID batchId = Database.executeBatch(sbr,50);
            System.debug('Batch Id: ' + batchId);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            System.debug('Account Id: ' + newAccount3.Id);
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount3.Id];
            System.debug('Test method 3 Opportunities: ' + listopp);
            SGR_validationHelper Countycode = new SGR_validationHelper(listopp,batchId);    
            
            
            
            Test.stoptest();
        }
        catch(Exception e)
        {
            System.debug('Exception: ' + e);  
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
            
            
            
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c=1234, external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
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
            sac.Membership_Number__c=3;
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
                                         StageName='Prospecting',CloseDate= system.today(),
                                         AccountId=newAccount3.Id));
                
            }
            
            Test.starttest();       
            SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
            ID batchId = Database.executeBatch(sbr,50);
            System.debug('Batch Id: ' + batchId);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            System.debug('Account Id: ' + newAccount3.Id);
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount3.Id];
            System.debug('Test method 3 Opportunities: ' + listopp);
            SGR_validationHelper Countycode = new SGR_validationHelper(listopp,batchId);    
            
            
            
            Test.stoptest();
        }
        catch(Exception e)
        {
            System.debug('Exception: ' + e);  
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
            
            
            
            
            Account newAccount2 = new Account(Name = 'Test Account',County_Code__c=1234, external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
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
            sac.Membership_Number__c=1;
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
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            br.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.09'));
            insert br;
            //String BatchId ='7074D00000RD90BQAT';
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
            System.debug('Batch Id: ' + batchId);
            SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
            Database.executeBatch(svc,50);
            list<opportunity> listopp = new list<opportunity>();
            System.debug('Account Id: ' + newAccount3.Id);
            listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                       (SELECT id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
                        FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
                       FROM opportunity WHERE AccountId = :newAccount3.Id];
            System.debug('Test method 3 Opportunities: ' + listopp);
            SGR_validationHelper Countycode = new SGR_validationHelper(listopp,batchId);    
            
            
            
            Test.stoptest();
        }
        catch(Exception e)
        {
            System.debug('Exception: ' + e);  
        }
    }*/
    //Anudeep //SFDC-14084 start
    /* static testmethod void DeptwithNoRelCodeValidation_Test() {
//Method to test the checkForDependentsForEmployeeOnlyTier function
try{
String indDiv = 'IL';
String marketSegment ='SG';
String fundingType ='PREM';
DATE renewEffDate =date.today();
String renType='Analytical';




Account newAccount2 = new Account(Name = 'Test Account',County_Code__c=1234, external_ID__c ='AC123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
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
sac.Membership_Number__c=1;
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
sam.Membership_Number__c=5;
sam.Group_Section__c=gs2.id;
sam.Account_Census__c=sac2.id;
sam.Member_Policy_Tier__c = 'EO';
benefits.add(sam);

SGR_Account_Member_Benefit__c sam2 = new SGR_Account_Member_Benefit__c();
sam2.Account__c=newAccount3.id;
sam2.Group_Section__c=gs2.id;
sam.Membership_Number__c=5;
sam2.Account_Census__c=sac2.id;
sam2.Member_Policy_Tier__c = 'ES';
benefits.add(sam2);
insert benefits;
List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
br.add(new SGR_Business_Rule__c(Name='test',Rule_Code__c ='GR.DV.11'));
br.add(new SGR_Business_Rule__c(Name='test1',Rule_Code__c ='GR.DV.12'));
br.add(new SGR_Business_Rule__c(Name='test2',Rule_Code__c ='GR.DV.13'));
insert br;
//String BatchId ='7074D00000RD90BQAT';
List<Opportunity> opps = new List<Opportunity>();
List<Opportunity> oppsneg = new List<Opportunity>();
for(Integer j=0;j<5;j++)
{
opps.add(new Opportunity(Name='Test Opportunity'+ j,
StageName='Prospecting',CloseDate= system.today(),
AccountId=newAccount3.Id));

}
// insert opps[0];
SGR_Opportunity_Census__c OppCensus=new SGR_Opportunity_Census__c();
OppCensus.Opportunity__c=opps[0].Id;
OppCensus.Account__c=newAccount3.Id;
OppCensus.Relationship_Code__c='';
//Insert OppCensus;
Test.starttest();       
SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
ID batchId = Database.executeBatch(sbr,50);
System.debug('Batch Id: ' + batchId);
SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
Database.executeBatch(svc,50);
list<opportunity> listopp = new list<opportunity>();
System.debug('Account Id: ' + newAccount3.Id);
listopp = [SELECT Id, name,Batch_Id__c ,(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
(SELECT id,Name,Account__c,Opportunity__c,Relationship_Code__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c 
FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) 
FROM opportunity WHERE AccountId = :newAccount3.Id];
System.debug('Test method 3 Opportunities: ' + listopp);
SGR_validationHelper Countycode = new SGR_validationHelper(listopp,batchId);    



Test.stoptest();
}
catch(Exception e)
{
System.debug('Exception: ' + e);  
}
}*///Anudeep SFDC-14084 END
    
    //Vijaya SFDC-14083 start
  /*  static testmethod void checkForSpouseOrDPTest(){ 
        
        Account acc = Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        update opty;
        opps.add(opty);
        opps.add(opty1);
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        //Sgr_TestDataUtility.OptyMemBen(oppCen.Id);
        
        //List<Opportunity> opps, map<id,List<SGR_Opportunity_Census__c>> optyCenGrp, 
        //string BatchId, String ruleId, List<SGRRenewalBatch__c> renBatchId,  Map<String,SGR_Business_Rule__c> bRules  
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
        
        SGR_Renewal_Batch_Oppty__c OptyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_Oppty__c>();
        listSGRRenewalBatchOpp.add(OptyBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        //Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) 
        //SGR_validationHelper checkForSpOrDP = new SGR_validationHelper(opps,batId);
        
        SGR_validationHelper.checkForSpouseOrDP(opps, optyCenGrp, batId, ruleId, renBatchId, bRules, mapOppRenwalBatchOpp);//
        Test.stoptest();
        
    }*/
    //Vijaya SFDC-14083 end
    
    /* static testmethod void checkFundingType() {
Test.startTest();
String fundingTypeRule = 'GR.DV.15';

Account acc = Sgr_TestDataUtility.createAcc('Test Account 1');
List<Opportunity> opps = new List<Opportunity>();
Opportunity opp1 = Sgr_TestDataUtility.createOpty('Test Opp 1', acc.Id, 'Rated', 'Triggered', 'SG', 'PREM', Date.today() + 20);
Opportunity opp2 = Sgr_TestDataUtility.createOpty('Test Opp 2', acc.Id, 'Rated', 'Triggered', 'SG', 'ASO', Date.today() + 20);

opps.add(opp1);
opps.add(opp2);

List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
batches.add(Sgr_TestDataUtility.createRenewalBatch());

List<SGR_Renewal_Batch_Oppty__c> rbopps = new List<SGR_Renewal_Batch_Oppty__c>();
SGR_Renewal_Batch_Oppty__c rbo1 = new SGR_Renewal_Batch_Oppty__c(Opportunity__c=opp1.Id);
SGR_Renewal_Batch_Oppty__c rbo2 = new SGR_Renewal_Batch_Oppty__c(Opportunity__c=opp1.Id);
rbopps.add(rbo1);
rbopps.add(rbo2);
Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop = new Map<id,List<SGR_Renewal_Batch_Oppty__c>>();
oppsrbop.put(rbo1.Opportunity__c, rbopps);

List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.15','GR.DV.15','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
Map<String,SGR_Business_Rule__c> sbrmap = new Map<String,SGR_Business_Rule__c>();
sbrmap.put(fundingTypeRule, rules[0]);
String RenewBatchId = '';
SGR_validationHelper.checkForPremiumFundingType(opps,fundingTypeRule,sbrmap,'567',batches,oppsrbop); 
Test.stopTest();
} */
    /* static testmethod void checkMemberAge() {
Test.startTest();
String memberOver99 = 'GR.DV.08';

Account acc = Sgr_TestDataUtility.createAcc('Test Account 1');
List<Opportunity> opps = new List<Opportunity>();
Opportunity opp1 = Sgr_TestDataUtility.createOpty('Test Opp 1', acc.Id, 'Rated', 'Triggered', 'SG', 'PREM', Date.today() + 20);
Opportunity opp2 = Sgr_TestDataUtility.createOpty('Test Opp 2', acc.Id, 'Rated', 'Triggered', 'SG', 'ASO', Date.today() + 20);
opp1.Renewal_Date__c = Date.newInstance(2048, 1, 1);
opp2.Renewal_Date__c = Date.newInstance(2048, 1, 1); 

opps.add(opp1);
opps.add(opp2);

List<SGR_Opportunity_Census__c> censuses = new List<SGR_Opportunity_Census__c>();
censuses.add(Sgr_TestDataUtility.createOptyCensus(8675309, 'Subscriber', String.valueOf(opp1.Id), String.valueOf(acc.Id)));
censuses.add(Sgr_TestDataUtility.createOptyCensus(9035768, 'Subscriber', String.valueOf(opp2.Id), String.valueOf(acc.Id)));
censuses[0].Date_of_Birth__c = Date.newInstance(1948, 1, 1);
censuses[1].Date_of_Birth__c = Date.newInstance(1949, 1, 1);

Map<Id, List<SGR_Opportunity_Census__c>> oppsgrogs = new Map<Id, List<SGR_Opportunity_Census__c>>();
oppsgrogs.put(opp1.Id, censuses);
List<SGRRenewalBatch__c> batches = new List<SGRRenewalBatch__c>();
batches.add(Sgr_TestDataUtility.createRenewalBatch());

List<SGR_Renewal_Batch_Oppty__c> rbopps = new List<SGR_Renewal_Batch_Oppty__c>();
SGR_Renewal_Batch_Oppty__c rbo1 = new SGR_Renewal_Batch_Oppty__c(Opportunity__c=opp1.Id);
SGR_Renewal_Batch_Oppty__c rbo2 = new SGR_Renewal_Batch_Oppty__c(Opportunity__c=opp1.Id);
rbopps.add(rbo1);
rbopps.add(rbo2);
Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop = new Map<id,List<SGR_Renewal_Batch_Oppty__c>>();
oppsrbop.put(rbo1.Opportunity__c, rbopps);

List<SGR_Business_Rule__c> rules = new List<SGR_Business_Rule__c>();
rules.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.08','GR.DV.08','Subscriber','','Warning',''));
Map<String,SGR_Business_Rule__c> sbrmap = new Map<String,SGR_Business_Rule__c>();
sbrmap.put(memberOver99, rules[0]);
String RenewBatchId = '';
SGR_validationHelper.checkMembershipAge(opps,memberOver99,'567',oppsgrogs,batches,sbrmap,oppsrbop);
Test.stopTest();
} */
    //Anudeep //SFDC-14085 start  
   //Anudeep //SFDC-14085 start 11/14 commented for deployment still work in progress  
/*static testmethod  void Testmethod_test_1()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
           Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            
           //Create Oppty
            Opportunity Oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(Oppty);
            
            Map<String,SGR_Business_Rule__c> BusinessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           
            BusinessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
      
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> OPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListES1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListES2=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListES3=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListES5=new list<Sgr_Opportunity_Census__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList2=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList3=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList4=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListBlank=new List<SGR_Opportunity_Member_Benefits__c>();
             
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMap=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapES1=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapES2=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapES3=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapESBlank=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapESBlank2=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            
            Sgr_Opportunity_Census__c OPC=Sgr_TestDataUtility.createOptyCensus2(2.0,'Spouse',opps[0].Id,newAccount1.Id,'Spouse');
            Sgr_Opportunity_Census__c OPC4=Sgr_TestDataUtility.createOptyCensus2(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'Domestic Partner');
            Sgr_Opportunity_Census__c OPC2=Sgr_TestDataUtility.createOptyCensus2(3.0,'Child',opps[0].Id,newAccount1.Id,'Child');
            Sgr_Opportunity_Census__c OPC3=Sgr_TestDataUtility.createOptyCensus2(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'Subscriber');
            Sgr_Opportunity_Census__c OPC5=Sgr_TestDataUtility.createOptyCensus2(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'');
            OPCSList.add(OPC);
            OPCSList.add(OPC2);
            OPCSListES1.add(OPC);
            OPCSListES2.add(OPC3);
            OPCSListES3.add(OPC4);
            OPCSListES5.add(OPC5);
            
            SGR_Opportunity_Group_Section__c OptyGroupSection=Sgr_TestDataUtility.OptyGrpSection(opps[0].Id);
            Insert OptyGroupSection;
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits=Sgr_TestDataUtility.SGROptyMemberBenefits('ES','2',OPC.id,OptyGroupSection.Id);
            
            OMBList.add(OppMemberBenefits);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefitsES=Sgr_TestDataUtility.SGROptyMemberBenefits('ES','2',OPC3.id,OptyGroupSection.Id);
            OMBList3.add(OppMemberBenefitsES);
            
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits2=Sgr_TestDataUtility.SGROptyMemberBenefits('EC','2',OPC.id,OptyGroupSection.Id);
            
            OMBList2.add(OppMemberBenefits2);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefitsES1=Sgr_TestDataUtility.SGROptyMemberBenefits('EF','2',OPC3.id,OptyGroupSection.Id);
           
            OMBList4.add(OppMemberBenefitsES1);
            
            PMBMap.put(OPC.Id,OMBList);
            PMBMap.put(OPC3.Id,OMBList2);
            PMBMapES1.put(OPC.Id,OMBList2);
            PMBMapES2.put(OPC3.Id,OMBList3);
            PMBMapES3.put(OPC3.Id,OMBList4);
            PMBMapESBlank.put(OPC.Id,OMBListBlank);
            PMBMapESBlank2.put(OPC5.Id,OMBListBlank);
            
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
        SGR_Renewal_Batch_Oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> SGRRenwalBatchotyList = new List<SGR_Renewal_Batch_Oppty__c>();
        SGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        oppsrbop.put(opps[0].Id, SGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
       
            SGR_validationHelper.ESTiresValidation(opps,OPCSList,PMBMap,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ESTiresValidation(opps,OPCSListES1,PMBMapES1,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ESTiresValidation(opps,OPCSListES2,PMBMapES2,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ESTiresValidation(opps,OPCSListES2,PMBMapES3,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ESTiresValidation(opps,OPCSList,PMBMapESBlank,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ESTiresValidation(opps,OPCSListES5,PMBMapESBlank2,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            
            //SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSList,PMBMap,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            //SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSList,PMBMap,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
           
            
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    //Anudeep //SFDC-14085 End
    //Anudeep SFDC-14086 start
    static testmethod  void Testmethod_test_2()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
           
       Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            
           //Create Oppty
            Opportunity Oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(Oppty);
            
            Map<String,SGR_Business_Rule__c> BusinessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
           
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> OPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListEC=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListEC1=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSListEC2=new list<Sgr_Opportunity_Census__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList2=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListEC=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListEC1=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListEC2=new List<SGR_Opportunity_Member_Benefits__c>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMap=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEC=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEC1=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEC2=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
      
            
            Sgr_Opportunity_Census__c OPC=Sgr_TestDataUtility.createOptyCensus2(2.0,'Child',opps[0].Id,newAccount1.Id,'Child');
            Sgr_Opportunity_Census__c OPC2=Sgr_TestDataUtility.createOptyCensus2(3.0,'Child',opps[0].Id,newAccount1.Id,'Child');
            Sgr_Opportunity_Census__c OPC3=Sgr_TestDataUtility.createOptyCensus2(3.0,'Domestic Partner',opps[0].Id,newAccount1.Id,'Domestic Partner');
      
            OPCSList.add(OPC3);
            OPCSList.add(OPC2);
            OPCSList.add(OPC);
            OPCSListEC.add(OPC2);
            OPCSListEC1.add(OPC2);
            OPCSListEC2.add(OPC3);
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits=new SGR_Opportunity_Member_Benefits__c();
            OppMemberBenefits.Member_Policy_Tier__c='ES';
            OppMemberBenefits.Subscriber_Number__c='2';
            OppMemberBenefits.Opportunity_Census__c=OPC2.id;
            OppMemberBenefits.Opportunity_Group_Section__c='a3w4D0000009d4GQAQ';
            
            Insert OppMemberBenefits;
            OMBList2.add(OppMemberBenefits);
            OMBListEC1.add(OppMemberBenefits);
            
            SGR_Opportunity_Group_Section__c OptyGroupSection=Sgr_TestDataUtility.OptyGrpSection(opps[0].Id);
            Insert OptyGroupSection;
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits2=Sgr_TestDataUtility.SGROptyMemberBenefits('EC','2',OPC2.id,OptyGroupSection.Id);
            
            OMBListEC.add(OppMemberBenefits2);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefitsEC=Sgr_TestDataUtility.SGROptyMemberBenefits('EC','2',OPC3.id,OptyGroupSection.Id);            
            OMBListEC2.add(OppMemberBenefitsEC);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits3=Sgr_TestDataUtility.SGROptyMemberBenefits('EF','2',OPC2.id,OptyGroupSection.Id); 
            OMBList.add(OppMemberBenefits3);
            
            PMBMap.put(OPC2.Id,OMBList);
            PMBMap.put(OPC3.Id,OMBList);
            PMBMap.put(OPC.Id,OMBList2);
            PMBMapEC.put(OPC2.Id,OMBListEC);
            PMBMapEC1.put(OPC2.Id,OMBListEC1);
            PMBMapEC2.put(OPC3.Id,OMBListEC2);
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
        SGR_Renewal_Batch_Oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> SGRRenwalBatchotyList = new List<SGR_Renewal_Batch_Oppty__c>();
        SGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        oppsrbop.put(opps[0].Id, SGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
            SGR_validationHelper.ESTiresValidation(opps,OPCSList,PMBMap,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSList,PMBMap,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSListEC,PMBMapEC,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSListEC1,PMBMapEC1,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSListEC2,PMBMapEC2,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSList,PMBMap,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
              
            
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    
    //Anudeep SFDC-14086 End
    //Anudeep SFDC-14087 Start
   static testmethod  void Testmethod_test_3()
    {
        try{
            String indDiv = 'IL';
            String marketSegment ='SG';
            String fundingType ='PREM';
            DATE renewEffDate =date.today();
            String renType='Analytical';
            
            Account newAccount1 = Sgr_TestDataUtility.createAcc('TestAccount', 773, 'ExID56', 'IL', renewEffDate, 'Active', 'SG', 'PREM');
            
           //Create Oppty
            Opportunity Oppty = Sgr_TestDataUtility.createOpty('TestOpp', newAccount1.Id, 'Rated', 'Triggered', 'PREM', renewEffDate, renewEffDate);
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(Oppty);
            
            Map<String,SGR_Business_Rule__c> BusinessRulesMap=new Map<String,SGR_Business_Rule__c>();
            List<SGR_Business_Rule__c> brDPT = new List<SGR_Business_Rule__c>();
            brDPT.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.11','GR.DV.11','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
           
            List<SGR_Business_Rule__c> brES = new List<SGR_Business_Rule__c>();
            brES.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.12','GR.DV.12','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(brES[0].Rule_Code__c,brES[0]);
            List<SGR_Business_Rule__c> brEC = new List<SGR_Business_Rule__c>();
            brEC.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.13','GR.DV.13','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(brEC[0].Rule_Code__c,brEC[0]);
            List<SGR_Business_Rule__c> bEF = new List<SGR_Business_Rule__c>();
            bEF.add(Sgr_TestDataUtility.createBusinessRule('GR.DV.14','GR.DV.14','Account','Funding Type is Premium.','Warning','Funding Type is not Premium.'));
            
            BusinessRulesMap.put(bEF[0].Rule_Code__c,bEF[0]);
            
          
            
            
            //String BatchId ='7074D00000RD90BQAT';
            
            
            list<opportunity> listopp = new list<opportunity>();
            list<Sgr_Opportunity_Census__c> OPCSList=new list<Sgr_Opportunity_Census__c>();
            list<Sgr_Opportunity_Census__c> OPCSEFList=new list<Sgr_Opportunity_Census__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList2=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBList3=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListEC=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListEF=new List<SGR_Opportunity_Member_Benefits__c>();
            List<SGR_Opportunity_Member_Benefits__c> OMBListEFBlank=new List<SGR_Opportunity_Member_Benefits__c>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMap=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEC=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEF=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
             map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEFN=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            map<Id, List<SGR_Opportunity_Member_Benefits__c>> PMBMapEFBlank=new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
           
             Sgr_Opportunity_Census__c OPC=Sgr_TestDataUtility.createOptyCensus2(2.0,'Subscriber',opps[0].Id,newAccount1.Id,'Subscriber');
            Sgr_Opportunity_Census__c OPC2=Sgr_TestDataUtility.createOptyCensus2(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'Subscriber');
            Sgr_Opportunity_Census__c OPC3=Sgr_TestDataUtility.createOptyCensus2(3.0,'Subscriber',opps[0].Id,newAccount1.Id,'Child');
            Sgr_Opportunity_Census__c OPC4=Sgr_TestDataUtility.createOptyCensus2(3.0,'Spouse',opps[0].Id,newAccount1.Id,'Spouse'); 
            Sgr_Opportunity_Census__c OPC5=Sgr_TestDataUtility.createOptyCensus2(3.0,'Spouse',opps[0].Id,newAccount1.Id,'Domestic Partner'); 
            
            
            OPCSList.add(OPC3);
            OPCSList.add(OPC2);
            OPCSList.add(OPC);
            OPCSList.add(OPC4);
            OPCSEFList.add(OPC5);
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits=new SGR_Opportunity_Member_Benefits__c();
            OppMemberBenefits.Member_Policy_Tier__c='ES';
            OppMemberBenefits.Subscriber_Number__c='2';
            OppMemberBenefits.Opportunity_Census__c=OPC2.id;
            OppMemberBenefits.Opportunity_Group_Section__c='a3w4D0000009d4GQAQ';
            
            Insert OppMemberBenefits;
            OMBList2.add(OppMemberBenefits);
            
            SGR_Opportunity_Group_Section__c OptyGroupSection=Sgr_TestDataUtility.OptyGrpSection(opps[0].Id);
            Insert OptyGroupSection;
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits2=Sgr_TestDataUtility.SGROptyMemberBenefits('EC','2',OPC4.id,OptyGroupSection.Id);
            OMBList3.add(OppMemberBenefits2);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefitsEFN=Sgr_TestDataUtility.SGROptyMemberBenefits('EC','2',OPC5.id,OptyGroupSection.Id);
            OMBList3.add(OppMemberBenefitsEFN);
            SGR_Opportunity_Member_Benefits__c OppMemberBenefitsEC1=Sgr_TestDataUtility.SGROptyMemberBenefits('EC','2',OPC3.id,OptyGroupSection.Id);
            OMBListEC.add(OppMemberBenefitsEC1);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefits3=Sgr_TestDataUtility.SGROptyMemberBenefits('EF','2',OPC2.id,OptyGroupSection.Id);
            OMBList.add(OppMemberBenefits3);
            
            SGR_Opportunity_Member_Benefits__c OppMemberBenefitsEF=Sgr_TestDataUtility.SGROptyMemberBenefits('EF','2',OPC5.id,OptyGroupSection.Id);
            OMBListEF.add(OppMemberBenefitsEF);
            
            
            PMBMap.put(OPC2.Id,OMBList);
            PMBMap.put(OPC3.Id,OMBListEC);
            PMBMap.put(OPC.Id,OMBList2);
            PMBMap.put(OPC4.Id,OMBList3);
            PMBMapEC.put(OPC3.Id,OMBList);
            PMBMapEF.put(OPC5.Id,OMBListEF);
            PMBMapEFN.put(OPC5.Id,OMBList3);
            PMBMapEFBlank.put(OPC5.Id,OMBListEFBlank);
           
            
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
        SGR_Renewal_Batch_Oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(newAccount1.Id, opps[0].Id, aBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> SGRRenwalBatchotyList = new List<SGR_Renewal_Batch_Oppty__c>();
        SGRRenwalBatchotyList.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        oppsrbop.put(opps[0].Id, SGRRenwalBatchotyList);
           Id batchId=anOppBatch.Id;
            SGR_validationHelper.ESTiresValidation(opps,OPCSList,PMBMap,'GR.DV.12',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSList,PMBMap,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.ECTireWithoutChildValidation(opps,OPCSList,PMBMapEC,'GR.DV.13',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSList,PMBMap,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSList,PMBMapEC,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSEFList,PMBMapEF,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSEFList,PMBMapEFN,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
            SGR_validationHelper.EFTireWithoutFamilyValidation(opps,OPCSEFList,PMBMapEFBlank,'GR.DV.14',BusinessRulesMap,batchId,batches,oppsrbop);
            Test.stoptest();
        }
        catch (SGR_Exception e)
        {
            
            throw new AuraHandledException( e.getMessage());
        }
    }
    // commented for Deployment END
    //Anudeep SFDC-14087 End
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
        
        //Create Opp Census
        Id oppID = anOpp.Id;
        Id accountID = anAccount.Id;
        SGR_Opportunity_Census__c aCensus = Sgr_TestDataUtility.createOptyCensus2(1234567, 'Subscriber', anOpp.Id, anAccount.Id, 'Subscriber');
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
        SGR_Renewal_Batch_Oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(anAccount.Id, anOpp.Id, aBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_Oppty__c>();
        listSGRRenewalBatchOpp.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        mapOppRenwalBatchOpp.put(oppID, listSGRRenewalBatchOpp);
                
        //SGR_validationHelper.Sub50Enrollees(listOpportunities, 'GR.EL.02', aBatch.Id, mapOpportunityCensus, listRenewalBatch, ruleMap, mapOppRenwalBatchOpp);
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
        
        //Dental Only Opp
        Opportunity anOpp3 = Sgr_TestDataUtility.createOpty('TestOpp3', anAccount.Id, 'Rated', 'Triggered', 'PREM', dateToday, dateToday);
        anOpp3.Product_Type__c = 'D';
        upsert anOpp3;
        listOpportunities.add(anOpp3);
        
        //Create Opp Census
        Id oppID = anOpp.Id;
        Id accountID = anAccount.Id;
        SGR_Opportunity_Census__c aCensus = Sgr_TestDataUtility.createOptyCensus2(1234567, 'Subscriber', anOpp.Id, anAccount.Id, 'Subscriber');
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
        SGR_Renewal_Batch_Oppty__c anOppBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(anAccount.Id, anOpp.Id, aBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_Oppty__c>();
        listSGRRenewalBatchOpp.add(anOppBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        mapOppRenwalBatchOpp.put(oppID, listSGRRenewalBatchOpp);
                
        SGR_validationHelper.HealthvsContributoryDental(listOpportunities, 'GR.EL.04', aBatch.Id, mapOpportunityCensus, listRenewalBatch, ruleMap, mapOppRenwalBatchOpp);
    }*/
//SFDC-14543 - Nathan - End
    
    /* static testmethod void checkStateCode() {
    
    }  */
    
    //US12536 - This method is used to test Opportunity rating status to be updated as Initiated when all BRV logs are passed on it.
   /*public static testMethod void testOppRtngStatusAndWAToAllPassBRVLogs(){
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount');
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
        Account acc = Sgr_TestDataUtility.createAcc('TestAccount');
         
        List<Opportunity> opprList = new List<Opportunity>();
    Opportunity oppr = Sgr_TestDataUtility.createOpty(acc.Id, 'Rated'); 
        opprList.add(oppr);
          
        List<Business_Rule_Validation_Log__c> brvList = new List<Business_Rule_Validation_Log__c>();
    brvList = Sgr_TestDataUtility.createBRVPassFailLogs(oppr.id);
        Test.startTest();
        SGR_validationHelper.updateOppRatingStatusAndWA(opprList);
        System.assertEquals(oppr.SGR_Workflow_Activity__c, 'UW Review - Validation Errors');
        Test.stopTest();
    }*/
   /* // US14541 -padmini
public static testmethod void countActiveSub(){
   // Creating Account
    List<Account> acc = new List<Account>();    
    Account ac1 = Sgr_TestDataUtility.createAcc('TesAcc1',100,'EX120','IL',Date.Today()+10,'Active','SG','PREM');
    acc.add(ac1);
    insert acc;        
    //Creating Opportunity
    List<Opportunity> opps = new List<Opportunity>();
    Opportunity opp = Sgr_TestDataUtility.createOpty('TestOp1',ac1.Id,'Rated','Triggered','PREM',Date.Today(),Date.Today());
    opps.add(opp);
    insert opps;
    
    // Creating Opp census
    Id oppID = opp.Id;
    Id accountID = ac1.Id;
    SGR_Opportunity_Census__c opCen = Sgr_TestDataUtility.createOptyCensus2(8888888, 'Subscriber', opp.Id, ac1.Id, 'Subscriber');
    List<SGR_Opportunity_Census__c> opCensuList = new List<SGR_Opportunity_Census__c>();
    opCensuList.add(opCen);
    map<id,List<SGR_Opportunity_Census__c>> opCensuMap = new map<id,List<SGR_Opportunity_Census__c>>();
    opCensuMap.put(oppID, opCensuList);
    
    //creating business rule 
    SGR_Business_Rule__c bRule = Sgr_TestDataUtility.createBusinessRule('GR.EL.0200','GR.EL.02','Subscriber','**Active Subscribers=**','Warning','**Non-Active Subscribers**');
    Map<String,SGR_Business_Rule__c> bRulMap = new Map<String,SGR_Business_Rule__c>();
    bRulMap.put('Gr.EL.02',bRule);
    
    //creating batch id
    SGRRenewalBatch__c rBatch = Sgr_TestDataUtility.createRenewalBatch();
    List<SGRRenewalBatch__c> renBatList = new List<SGRRenewalBatch__c>();
    renBatList.add(rBatch);
    
    //creating Renewal Batch Opportunity 
    SGR_Renewal_Batch_Oppty__c rBatOpp = Sgr_TestDataUtility.createRenewalBatchOpportunity(ac1.Id, opp.Id, rBatch.Id);
    List<SGR_Renewal_Batch_Oppty__c> rBatOppList = new List<SGR_Renewal_Batch_Oppty__c>();
    rBatOppList.add(rBatOpp);
    map<id,List<SGR_Renewal_Batch_Oppty__c>> RenBatOpp = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
    RenBatOpp.put(oppID, rBatOppList);
    
    Test.starttest();
    SGR_ValidationHelper.countActiveSubscribers(opps,'GR.EL.02',rBatch.Id,opCensuMap,renBatList,bRulMap,RenBatOpp);
    Test.stopTest();
    
    
        
    }
*/
//Nikhil SFDC-14431 start
 /*   static testmethod void TestcheckForactivedentalsubscriber(){ 
        
        Account acc = Sgr_TestDataUtility.createAcc('Test Account');
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity opty = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        Opportunity opty1 = Sgr_TestDataUtility.createOpty(acc.Id, 'Qualify');
        opty.Batch_Id__c = '567';
        update opty;
        opps.add(opty);
        opps.add(opty1);
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        //Sgr_TestDataUtility.OptyMemBen(oppCen.Id);
        
        //List<Opportunity> opps, map<id,List<SGR_Opportunity_Census__c>> optyCenGrp, 
        //string BatchId, String ruleId, List<SGRRenewalBatch__c> renBatchId,  Map<String,SGR_Business_Rule__c> bRules  
        Sgr_Opportunity_Census__c oppCen = Sgr_TestDataUtility.createOptyCensus(100,'Subscriber',opty.Id,acc.Id);      
        Sgr_Opportunity_Census__c oppCen16 = Sgr_TestDataUtility.createOptyCensus(700,'Subscriber',opty1.Id,acc.Id);
        SGR_Opportunity_Benefit_Agreement__c oppben1 = Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        SGR_Opportunity_Benefit_Agreement__c oppben3 = Sgr_TestDataUtility.createOptyBenAgr2(opty.Id,'D');
        SGR_Opportunity_Benefit_Agreement__c oppben2 = Sgr_TestDataUtility.createOptyBenAgr2(opty1.Id,'H');
        //oppCen.Member_Cancel_Date__c=date.today().adddays(-20);
        //oppCen15.Member_Effective_Date__c=date.today().adddays(2);
        oppCen16.Member_Cancel_Date__c=null;
        //update oppben1;
        update oppCen16;
        Sgr_TestDataUtility.createOptyRenBatch(opty.Id);
        Sgr_TestDataUtility.createOptyBenAgr(opty.Id);
        Sgr_TestDataUtility.OptyGrpSection(opty.Id);
        //Sgr_TestDataUtility.OptyMemBen(oppCen.Id);
        List<Sgr_Opportunity_Census__c> lstOptyCensus = new List<Sgr_Opportunity_Census__c>{oppCen,oppCen16};
            List<SGR_Opportunity_Benefit_Agreement__c> lstOptyba = new List<SGR_Opportunity_Benefit_Agreement__c>{oppben1,oppben2};
            
            SGR_Business_Rule__c bsRule = Sgr_TestDataUtility.createBusinessRule();
        Map<String,SGR_Business_Rule__c> bRules = new Map<String,SGR_Business_Rule__c>();
        bRules.put('GR.DV.04',bsRule);
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch();
        List<SGRRenewalBatch__c> renBatchId = new List<SGRRenewalBatch__c>{renBatch};
            String batId = '567';
        String ruleId = 'GR.DV.04';
        Map<id,List<SGR_Opportunity_Census__c>> optyCenGrp = new Map<id,List<SGR_Opportunity_Census__c>>();
        optyCenGrp.put(opty.id,lstOptyCensus); 
        Map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1 = new Map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        oppsgrobamap1.put(opty.id,lstOptyba); 
        
        SGR_Renewal_Batch_Oppty__c OptyBatch = Sgr_TestDataUtility.createRenewalBatchOpportunity(acc.Id, opty.Id, renBatch.Id);
        List<SGR_Renewal_Batch_Oppty__c> listSGRRenewalBatchOpp = new List<SGR_Renewal_Batch_Oppty__c>();
        listSGRRenewalBatchOpp.add(OptyBatch);
        map<id,List<SGR_Renewal_Batch_Oppty__c>> mapOppRenwalBatchOpp = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        mapOppRenwalBatchOpp.put(opty.Id, listSGRRenewalBatchOpp);
        Test.starttest();
        //Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) 
        //SGR_validationHelper checkForSpOrDP = new SGR_validationHelper(opps,batId);
        
        SGR_validationHelper.checkForactivedentalsubscriber(opps, ruleId, batId,optyCenGrp, renBatchId, bRules, mapOppRenwalBatchOpp,oppsgrobamap1);
        SGR_validationHelper.checkForactiveHealthsubscriber(opps, ruleId, batId,optyCenGrp, renBatchId, bRules, mapOppRenwalBatchOpp,oppsgrobamap1);
        
        Test.stoptest();
        
    }*/
    //Nikhil SFDC-14431 end
}