@isTest(SeeAllData=false)
public class SGR_RenewalProcessor_Test {
    string returnMsg='text';
    Integer count=0;
    static testmethod void testmethod1(){
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String accNum; 
        String acctNo;
        String bid;
        String renewEffDateStr;
        
        
        divisions=new List<String>{'IL','TX'};
        marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr = string.valueof(system.today().adddays(2));
        renewEffDate ='2018-11-28';
        renType='Analytical';
       
        bid='jq123';
        accNum='AC12345';
        acctNo='AC12345';
        String returnMsg;
        string str = '2018-10-21';
        date actual = system.today().adddays(2);//date.valueOf(str);
        
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'Test Record1',recordTypeId=sgrGroupAccount,Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Forecast_Segment__c='Small Group', Renewal_Date__c = actual,status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        Account newAccount2 = new Account(Name = 'Test Record2',recordTypeId=sgrGroupAccount,Product_Type__c='H', external_ID__c ='AC12346', HCSC_Division__c = 'TX', Forecast_Segment__c='Small Group', Renewal_Date__c = actual,status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        accList.add(newAccount2);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'lost';
        opps.Product_Type__c='H';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.RecordTypeId =SGR_RenewalProcessor_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        opps.HCSC_Division__c ='IL';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        opps.Rating_Status__c = 'Marketing Release';
        oplist.add(opps);
        
        
        insert oplist;
         map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap= new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        List<Benefit_Agreement__c> bAList= new list<Benefit_Agreement__c>();
        Benefit_Agreement__c bAL= new Benefit_Agreement__c();
        
        bAL.Status__c='Active';
        bAL.ACA_Indicator__c= True;
        bAL.Group_Account__c=accList[0].id;
        bAList.add(bAL);
        Insert bAList;
        
        //system.assertEquals(accList[0].ACA_Metallic_Count__c, 1);
        
        
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        
        
        test.startTest();
        
        
        SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, renewEffDateStr, renType);
        SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(newAccount1.HCSC_Division__c,newAccount1.Market_Segment__c,newAccount1.Funding_Type__c,newAccount1.Renewal_Date__c,renType);
        ID batchId = Database.executeBatch(sbr,50);
        
        opBenMap = SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(ide,oplist,bid,opBenMap);
        SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide,oplist,bid);
        test.stopTest();
        system.assertequals(bAL.Status__c,'Active');
    }
    
    
    static testmethod void testmethod2(){
        
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String bid;
        String accNum; 
        String acctNo;
        String renewEffDateStr;
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        divisions=new List<String>{'IL'};
        marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2018-11-25';
        renewEffDate ='2018-11-20';
        renType='Production';
        division= 'IL';
        bid='jq123';
        accNum='AC12345';
        acctNo='AC12345';
        String returnMsg;
        string str = '2018-10-21';
        date actual = date.valueOf(str);
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'RTest Record',Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = actual,status__c = 'Active',recordTypeId=sgrGroupAccount, Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'lost';
        opps.Product_Type__c='H';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.RecordTypeId = SGR_RenewalProcessor_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        opps.HCSC_Division__c ='IL';
        opps.Rating_Status__c ='Closed';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        opps.Rating_Status__c = 'Marketing Release';
        oplist.add(opps);
        
        
        insert oplist;
        
        List<Benefit_Agreement__c> bAList= new list<Benefit_Agreement__c>();
        Benefit_Agreement__c bAL= new Benefit_Agreement__c();
        bAL.Status__c='Active';
        bAL.ACA_Indicator__c= True;
        bAL.Group_Account__c=accList[0].id;
        bAList.add(bAL);
        Insert bAList;
        
        
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        test.startTest();
        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap= new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, renewEffDateStr, renType);
        SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(newAccount1.HCSC_Division__c,newAccount1.Market_Segment__c,newAccount1.Funding_Type__c,newAccount1.Renewal_Date__c,renType);
        ID batchId = Database.executeBatch(sbr,50);
        Account act1 = SGR_RenewalProcessor.searchAccounts(division,acctNo); 
        
        opBenMap = SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(ide,oplist,bid,opBenMap);
        SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide,oplist,bid);
        test.stopTest();
        system.assertEquals(bAL.Status__c,'Active');
        
        
    }
    
    static testmethod void testmethod3(){
        
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String accNum; 
        String bid;
        String acctNo;
        String renewEffDateStr;
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        
        divisions=new List<String>{'IL'};
            marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2018-11-20';
        renewEffDate ='2018-11-23';
        bid='jq123';
        renType='Production';
        division= 'IL';
        accNum='AC12345';
        acctNo='AC12345';
        String returnMsg;
        string str = '2018-10-21';
        date actual = date.valueOf(str);
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'RTest Record',Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = actual,status__c = 'Active',recordTypeId=sgrGroupAccount, Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'lost';
        opps.Product_Type__c='H';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.RecordTypeId =SGR_RenewalProcessor_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        opps.HCSC_Division__c ='IL';
        opps.Rating_Status__c ='Finalized';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        opps.Rating_Status__c = 'Marketing Release';
        oplist.add(opps);
        insert oplist;
        
        List<Benefit_Agreement__c> bAList= new list<Benefit_Agreement__c>();
        Benefit_Agreement__c bAL= new Benefit_Agreement__c();
        
        bAL.Status__c='Active';
        
        bAL.ACA_Indicator__c= True;
        bAL.Group_Account__c=accList[0].id;
        bAList.add(bAL);
        Insert bAList;
        
        test.startTest();
        
        SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, renewEffDateStr, renType);
        SGR_RenewalProcessor.initiateRenewalForOnDemand(division, accNum, renType,fundingType, marketSegment, renewEffDate);
        Account act1 = SGR_RenewalProcessor.searchAccounts(division,acctNo); 
        
        test.stopTest();
        System.assertEquals(bAL.Status__c,'Active');
        
        
    }
    
    static testmethod void testmethod4(){
        
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String bid;
        String accNum; 
        String acctNo;
        String renewEffDateStr;
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        
        divisions=new List<String>{'IL'};
        marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2018-10-21';
        renewEffDate ='2018-11-28';
        renType='Analytical';
        division= 'IL';
        bid='jq123';
        accNum='AC12345';
        acctNo='AC12345';
        String returnMsg;
        string str ='2018-11-28';
        date actual = date.valueOf(str);
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'RTest Record',Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c =actual ,status__c = 'Active',recordTypeId=sgrGroupAccount, Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'Withdrawn';
        opps.Product_Type__c='H';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.RecordTypeId = SGR_RenewalProcessor_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        opps.HCSC_Division__c ='IL';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        opps.Rating_Status__c = 'Marketing Release';
        oplist.add(opps);
        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap= new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        
        insert oplist;
        
        List<Benefit_Agreement__c> bAList= new list<Benefit_Agreement__c>();
        Benefit_Agreement__c bAL= new Benefit_Agreement__c();
        bAL.Status__c='Active';
        bAL.ACA_Indicator__c= True;
        bAL.Group_Account__c=accList[0].id;
        bAList.add(bAL);
        Insert bAList;
        
        
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        test.startTest();
        
        SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, renewEffDateStr, renType);
        SGR_RenewalProcessor.initiateRenewalForOnDemand(division, accNum, renType,fundingType, marketSegment, renewEffDate);
        Account act1 = SGR_RenewalProcessor.searchAccounts(division,acctNo); 
        
        opBenMap = SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(ide,oplist,bid,opBenMap);
        SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,bid);
        SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide,oplist,bid);
        test.stopTest();
        system.assertEquals(bAL.Status__c,'Active');
        
    }
    
    static testmethod void testmethod5(){
        Actuary_Gate__c g= new Actuary_Gate__c();
        g.Division__c='IL';
        g.Market_Segment__c='SG';
        g.Funding_Type__c='PREM';
        g.Effective_Date__c =date.today();
        g.Status__c = 'Down';
        insert g;
        
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String bid;
        String accNum; 
        String acctNo;
        String renewEffDateStr;
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        
        divisions=new List<String>{'IL','ok'};
        marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2020-09-29';
        renewEffDate ='2020-09-09';
        renType='Analytical';
        division= 'IL';
        accNum='123456';
        String returnMsg;
        String str='2020-09-09';
        date actualdate=date.valueOf(str);
        
      //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'RTest Record',County_Code__c='1234',Domestic_Partner__c='Y',Product_Type__c='H', external_ID__c ='123456', HCSC_Division__c = 'IL', Renewal_Date__c = actualdate,status__c = 'Active',recordTypeId=sgrGroupAccount, Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'Withdrawn';
        opps.Product_Type__c='H';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.RecordTypeId =SGR_RenewalProcessor_Test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        opps.HCSC_Division__c ='IL';
        opps.Rating_Status__c ='Rated';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        oplist.add(opps);
        
        
        List<Benefit_Agreement__c> bAList= new list<Benefit_Agreement__c>();
        Benefit_Agreement__c bAL= new Benefit_Agreement__c();
        bAL.Status__c='Active';
        bAL.ACA_Indicator__c= True;
        bAL.Group_Account__c=accList[0].id;
        bAList.add(bAL);
        Insert bAList; 
        update accList;
        
        
        list<Account> testdata=[select id,ACA_Indicator__c,Status__c,(select id,Status__c from Benefit_Agreements__r) from Account where id=:accList[0].id];
        
        test.startTest();
        
        SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, str, renType);
        SGR_RenewalProcessor.initiateRenewalForOnDemand(division, accNum, renType,fundingType, marketSegment, renewEffDate);   
        test.stopTest();
        system.assertEquals(bAL.Status__c,'Active');
     }
    
     static testmethod void testmethod6(){
        Actuary_Gate__c g= new Actuary_Gate__c();
        g.Division__c='IL';
        g.Market_Segment__c='SG';
        g.Funding_Type__c='PREM';
        g.Effective_Date__c =date.today();
        g.Status__c = 'Down';
        insert g;
        
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String bid;
        String accNum; 
        String acctNo;
        String renewEffDateStr;
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        
        
        divisions=new List<String>{'IL','ok'};
        marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2020-09-29';
        renewEffDate ='2017-09-09';
        renType='Production';
        division= 'IL';
        String division123='MT';
        accNum='123456';
        String returnMsg;
        String str='2020-09-09';
        date actualdate=date.valueOf(str);
        
      //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'RTest Record',County_Code__c='1234',Domestic_Partner__c='Y',Product_Type__c='H', external_ID__c ='123456', HCSC_Division__c = 'IL', Renewal_Date__c = actualdate,status__c = 'Active',recordTypeId=sgrGroupAccount, Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal',ACA_Indicator__c='Y');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
       
        List<Benefit_Agreement__c> bAList= new list<Benefit_Agreement__c>();
        Benefit_Agreement__c bAL= new Benefit_Agreement__c();
        bAL.Status__c='Active';
       	bAL.ACA_Indicator__c= True;
        bAL.Group_Account__c=accList[0].id;
        bAList.add(bAL);
        Insert bAList; 
        update accList;
        
        
        list<Account> testdata=[select id,ACA_Indicator__c,Status__c,(select id,Status__c from Benefit_Agreements__r) from Account where id=:accList[0].id];
        
        test.startTest();
        
       //SGR_RenewalProcessor.initiateRenewalForBatch(divisions, marketSegment, fundingType, str, renType);
       SGR_RenewalProcessor.initiateRenewalForOnDemand(division123, accNum, renType,fundingType, marketSegment, renewEffDate);
        
        test.stopTest();
       system.assertEquals(bAL.Status__c,'Active');
     }
     
      public Static String getOpptyRecordTypeIds(String objectName,String recTypeName){
         Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobALDescribe() ;
        Schema.SObjectType schemaObject = mapSchemaobject.get(objectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = schemaObject.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        
        return recordTypeId;
       
    }
    
}