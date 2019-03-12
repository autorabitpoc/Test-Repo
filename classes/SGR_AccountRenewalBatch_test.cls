@isTest(SeeAllData=false)
public class SGR_AccountRenewalBatch_test {
	static testmethod  void testmethod1()
    {
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Funding_Type__c='PREM';
        a.Renewal_Date__c=date.today();
        a.Product_Type__c='H';
        a.hold_end_date__c=Date.today()-1;
        a.SGR_Hold_Reason__c='1st Year Renewal';
        insert a;
        
        
        Actuary_Gate__c g= new Actuary_Gate__c();
        g.Division__c='IL';
        g.Market_Segment__c='SG';
        g.Funding_Type__c='PREM';
        g.Effective_Date__c =date.today();
        g.Status__c = 'Down';
        insert g;
        
        
        
        String divisions;
        String marketSegment;
        String fundingType;
        DATE renewEffDate;
        String renType='Production';
        Integer goodOps=2; 
        
        
        divisions = 'IL';
        marketSegment ='SG';
        fundingType ='PREM';
        renewEffDate =date.today();
        renType='Production';
        
        String divisions1 = 'IL';
        String   marketSegment1 ='SG';
        String  fundingType1 ='PREM';
        String bid='jq123';
        Date renewEffDate1 =date.today();
        String renType1='Analytical';  
        Test.startTest();
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'Test Account',county_code__c='1234', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        
        insert accList;
        system.debug(accList);
        
        list<Benefit_Agreement__c> BenList=new list<Benefit_Agreement__c>();
        Benefit_Agreement__c Ben= new Benefit_Agreement__c();
        Ben.Group_Account__c=newAccount1.id;
        Ben.Status__c='Active';
        ben.ACA_Indicator__c=TRUE;
        BenList.add(ben);
        
        insert BenList;
        system.debug(BenList);
        
        SGR_AccountRenewalBatch sbr1= new SGR_AccountRenewalBatch(divisions,marketSegment,fundingType,renewEffDate,renType);
        ID batchId = Database.executeBatch(sbr1,50);
        
        List<Account> accLists1 = [SELECT Id, Domestic_Partner__c,Status__c, HCSC_Division__c,Renewal_Date__c,county_code__c,Product_Type__c,name,Funding_Type__c,ShippingPostalCode,External_Id__c from Account];
        SGR_AccountRenewalBatch sbr2= new SGR_AccountRenewalBatch('IL','SG','PREM',date.today(),'Production');
        //ID batchId = Database.executeBatch(sbr1,50);
        sbr2.execute(null, accLIsts1);
        
        SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(divisions1,marketSegment1,fundingType1,renewEffDate1,renType1);
        ID batchId1 = Database.executeBatch(sbr,50);
        
        /*List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.recordTypeId=SGR_AccountRenewalBatch_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opp);
        
        insert oplist;*/
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        
        //SGR_AccountRenewalsHelper.createOpportunities(accList, renType,'Batch',newAccount1.id,renewEffDate, g); 
        
        
        SGR_AccountRenewalBatch sgbr= new SGR_AccountRenewalBatch(divisions,marketSegment,fundingType,renewEffDate, renType);
        /*  SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(ide,oplist,bid);
SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,bid);
SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide,oplist,bid);
SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(ide,oplist,bid);
SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide,oplist,bid);
//SGR_AccountRenewalsHelper.insertOppBAGSAssignment(ide,oplist,bid);

//SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide);*/
        
        database.executeBatch(sgbr);
        Test.stopTest();
        
    }
    static testmethod  void testmethod2()
    {
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Funding_Type__c='PREM';
        a.Product_Type__c='H';
        a.Renewal_Date__c=date.today();
        a.hold_end_date__c=Date.today()-1;
        a.SGR_Hold_Reason__c='1st Year Renewal';
        insert a;
        
        
        
        String divisions;
        String marketSegment;
        String fundingType;
        DATE renewEffDate;
        String renType='Production';
        String bid='jq123';
        Integer goodOps=2; 
        
        
        divisions='IL';
        marketSegment='LG';
        fundingType='ACAP';
        renewEffDate =date.today();
        Test.startTest();
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'Test Account',county_code__c='1234',Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        
        insert accList;
        
        SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(divisions,marketSegment,fundingType,renewEffDate,renType);
        ID batchId = Database.executeBatch(sbr,50);
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'Lost';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Probability = 0;
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = Userinfo.getUserId();
        opp.recordTypeId=SGR_AccountRenewalBatch_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opp);
        
        insert oplist;
        
        list<Benefit_Agreement__c> BenList=new list<Benefit_Agreement__c>();
        Benefit_Agreement__c Ben= new Benefit_Agreement__c();
        Ben.Group_Account__c=newAccount1.id;
        Ben.Status__c='Active';
        ben.ACA_Indicator__c=TRUE;
        BenList.add(ben);
        insert BenList;
        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> op_Ben_Map= new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        SGR_AccountRenewalBatch sbr1= new SGR_AccountRenewalBatch(divisions,marketSegment,fundingType,renewEffDate,renType);
        ID batchId1 = Database.executeBatch(sbr1,50);
        
        if(accList.size()>0){
            
            SGR_AccountRenewalBatch sgbr= new SGR_AccountRenewalBatch(divisions,marketSegment,fundingType,renewEffDate, renType);
            
            op_Ben_Map=SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(ide,oplist,bid);
            SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,bid);
            SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide,oplist,bid);
            SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(ide,oplist,bid,op_Ben_Map);
            //SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,bid);
            SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide,oplist,bid);
            //SGR_AccountRenewalsHelper.insertOppBAGSAssignment(ide,oplist,bid);
            
            database.executeBatch(sgbr);
            
        }
        
        
        Test.stopTest();
        
    }
	static  testmethod void testmethod3()
    {
        Actuary_Gate__c g = new Actuary_Gate__c();
        g.Division__c='IL';
        g.Market_Segment__c='SG';
        g.Funding_Type__c='PREM';
        g.Effective_Date__c =date.today();
        g.Status__c = 'Down';
        insert g;
        /*
        String divisions;
        String marketSegment;
        String fundingType;
        DATE renewEffDate;
        String renType='Production';
        Integer goodOps=2; 
        
        divisions = 'IL';
        marketSegment ='SG';
        fundingType ='PREM';
        renewEffDate =date.today();
        renType='Production';
        
        String divisions1 = 'IL';
        String marketSegment1 ='SG';
        String fundingType1 ='PREM';
        String bid='jq123';
        Date renewEffDate1 =date.today();
        String renType1='Analytical';  
        */
        List<Account> accList = new List<Account>();
        
        Account a= new Account();
        a.name='TestAccren1';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Funding_Type__c='PREM';
        a.Renewal_Date__c=date.today();
        a.Product_Type__c='H';
        a.hold_end_date__c=Date.today()-1;
        a.SGR_Hold_Reason__c='1st Year Renewal';
        accList.add(a);
        
        Account newAccount = new Account(Name = 'TestAccren',Status__c='Active', HCSC_Division__c = 'IL', external_ID__c ='AC123456', Renewal_Date__c = date.today(), Market_Segment__c='SG',Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='Special Adjustments');
        accList.add(newAccount);
        
        insert accList;
        system.debug('Test newAccount1 :: '+accList);
        
        list<Benefit_Agreement__c> BenList=new list<Benefit_Agreement__c>();
        Benefit_Agreement__c Ben= new Benefit_Agreement__c();
        Ben.Group_Account__c=accList[0].id;
        Ben.Status__c='Active';
        ben.ACA_Indicator__c=TRUE;
        BenList.add(ben);
        
        Benefit_Agreement__c Ben1= new Benefit_Agreement__c();
        Ben1.Group_Account__c=accList[1].id;
        Ben1.Status__c='Active';
        ben1.ACA_Indicator__c=TRUE;
        BenList.add(ben1);
               
        insert BenList;
         List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = accList[0].id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = Userinfo.getUserId();
        opp.recordTypeId=SGR_AccountRenewalBatch_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        //opp.Owner='';
        oplist.add(opp);
        
        insert oplist;
        system.debug('Test BenList :: '+BenList);
        System.assertEquals(accList[0].id, Ben.Group_Account__c);
        Test.startTest();
        
        
        
        
       // SGR_AccountRenewalBatch sbr1= new SGR_AccountRenewalBatch('IL','SG','PREM',date.today(),'Production');
        
       List<Account> accLists = [SELECT Id, Domestic_Partner__c,Status__c, Forecast_Segment__c,HCSC_Division__c,Renewal_Date__c,county_code__c,Product_Type__c,name,Funding_Type__c,ShippingPostalCode,External_Id__c,EIN__c  from Account];
        system.debug('AListsixe'+accLists.size());
        SGR_AccountRenewalBatch sbr1= new SGR_AccountRenewalBatch('IL','SG','PREM',date.today(),'Production');
        ID batchId = Database.executeBatch(sbr1,50);
        //sbr1.execute(null, accLIsts);
        
        SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch('IL','SG','PREM',date.today(),'Analytical');
        //ID batchId1 = Database.executeBatch(sbr,50);
        sbr.execute(null, accLIsts);
        
        Test.stopTest();
    }
    
     public Static String getOpptyRecordTypeIds(String ObjectName,String recTypeName){
         Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobalDescribe() ;
        Schema.SObjectType SchemaObject = mapSchemaobject.get(ObjectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = SchemaObject.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        System.debug(':::RECTYPE:::'+recordTypeId);
        return recordTypeId;
       
    }
}