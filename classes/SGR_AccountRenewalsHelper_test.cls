@isTest
public class SGR_AccountRenewalsHelper_test {
    
    
    static testmethod  void triggerRenewalTest()
    {
        
        List<Account> lstAcc = new List<Account>();
        Account a= new Account();
        a.name='Test';
        a.HCSC_Division__c='IL';
        a.Market_Segment__c='SG';
        a.Funding_Type__c='ACAP';
        a.Renewal_Date__c=date.today();
        a.hold_end_date__c=Date.today()-1;
        a.SGR_Hold_Reason__c='1st Year Renewal';
        insert a;
        
        
        //List<user> li= [select id,profile.name from user where ];
        String divisions;
        String marketSegment;
        String fundingType;
        DATE renewEffDate;
        String renType='Analytical';
        Integer goodOps=2; 
        
        
        divisions='IL';
        marketSegment='LG';
        fundingType='ACAP';
        renewEffDate =date.today();
        
        String division;
        String accNum;
        String batchType;
        String renewalType;
        Integer count;
        String batchId='jq1234';
        
        division='IL';
        accNum='1992';
        renewalType='Production';
        batchType='Batch';
        count=1;
        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> op_Ben_Map= new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        
        //Test.startTest();
        
        
        //Account newAccount1 = new Account(Name = 'Test Account', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM');
        //List<Account> accList = new List<Account>();
        //accList.add(newAccount1);
        //insert accList;
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        
        
         SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(division,marketSegment,fundingType,renewEffDate,renType);
            batchId = Database.executeBatch(sbr,50);
        
        
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
         opp.Renewal_Date__c=date.today();
        opp.Assigned_UW__c = Userinfo.getUserId();
        opp.recordTypeId=SGR_AccountRenewalsHelper_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        //opp.Assigned_UW__c='0054D000001FFfi';
        oplist.add(opp);
        insert oplist;
        
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount11 = new Account(Name='ABC',external_ID__c ='123456', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList1 = new List<Account>();
        accList1.add(newAccount11);
        insert accList1;
        
        Set<id> ide1 = new Set<id>();
        ide1.add(newAccount11.id);
        
        List<opportunity> oplist1 = new List<opportunity>();
        opportunity opp1 = new opportunity();
        opp1.Accountid = newAccount11.id;
        opp1.Name = 'Sample';
        opp1.StageName = 'Triggered';
        opp1.Product_Type__c='H';
        opp1.Primary_Closed_Reason__c ='Political';
        opp1.Closed_Comments__c = 'XYZ';
        opp1.Date_Closed__c = date.today().adddays(-1);
        opp1.CloseDate = date.today().adddays(2);
        opp1.Renewal_Date__c=date.today();
        opp1.Assigned_UW__c = Userinfo.getUserId();
        opp1.recordTypeId=SGR_AccountRenewalsHelper_test.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');
        //opp.Assigned_UW__c='0054D000001FFfi';
        oplist1.add(opp1);
        insert oplist1;
        
        Error_Log__c errLog=new Error_Log__c();
        list<Error_Log__c> errLst=new list<Error_Log__c>();
        errLog.Batch_Id__c=newAccount1.id;
        errLog.Account_Id__c=accList[0].id;
        errLog.Opportunity_Id__c=oplist[0].id;
        errLog.Error_Message__c='Multiple production Opportunities Exists';
        errLst.add(errLog);
        
        insert errLst;
        
        Benefit_Agreement__c opp2 = new Benefit_Agreement__c();
        list<Benefit_Agreement__c> blist1 = new list<Benefit_Agreement__c>();
        opp2.Group_Account__c= newAccount1.id;
        opp2.Funding_Type__c = fundingType;
        blist1.add(opp2);
        insert blist1;
        
        
        SGR_Opportunity_Benefit_Agreement__c opp11 = new SGR_Opportunity_Benefit_Agreement__c();
        list<SGR_Opportunity_Benefit_Agreement__c> blist = new list<SGR_Opportunity_Benefit_Agreement__c>();
        opp11.Name='Test';
        opp11.Opportunity__c = oplist[0].Id;
        opp11.Funding_Type__c = fundingType;
        blist.add(opp11);
        insert blist;
        
        SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c();
        list<SGR_Opportunity_Census__c> opBenList = new list<SGR_Opportunity_Census__c>();
        //oppcen.Name =oplist[0].Id;
        oppcen.Opportunity__c = oplist[0].Id;
        oppcen.Account__c = newAccount1.id;
        oppcen.Date_of_Birth__c = System.today().addYears(-30);
        oppcen.Gender__c = 'F';
        oppcen.Relationship__c = 'Subscriber';
        oppcen.Zip_Code__c = '1234H';
        oppcen.Member_Cancel_Date__c=date.today()+1;
        oppcen.Member_Effective_Date__c=date.today()-1;
        system.debug('oppcen.Member_Cancel_Date__c'+oppcen.Member_Cancel_Date__c);
        opBenList.add(oppcen);
      Insert opBenList;
        
        
        
       
        SGR_Opportunity_Group_Section__c oppg = new SGR_Opportunity_Group_Section__c();
        list<SGR_Opportunity_Group_Section__c> opGList = new list<SGR_Opportunity_Group_Section__c>();
        oppg.Name = oplist[0].id;
        
        opGList.add(oppg);
        Insert opGList;
        
        Group_Section__c ga = new Group_Section__c();
        list<Group_Section__c> gaList = new list<Group_Section__c>();
        ga.Group_Account__c = newAccount1.id;
        
             
        gaList.add(ga);
        Insert gaList;
        
         SGR_Opportunity_Plan_Rate__c opplanrate = new SGR_Opportunity_Plan_Rate__c(); 
        list<SGR_Opportunity_Plan_Rate__c> opplanlist = new list<SGR_Opportunity_Plan_Rate__c>();
        
        opplanrate.Name = oplist[0].id;
        opplanrate.Account__c = newAccount1.id;
        opplanrate.Member_Premium__c=299;
        
        
        opplanlist.add(opplanrate);
        Insert opplanlist;
        
       // List<SGR_Opportunity_Plan_Rate__c> planRates = [Select Id, Member_Premium__c from SGR_Opportunity_Plan_Rate__c Limit 1];
        set<id> planRateIDs1 = new set<id>();
        SGR_Opportunity_Plan_Composite_Rate__c opplanratecom = new SGR_Opportunity_Plan_Composite_Rate__c(); 
        list<SGR_Opportunity_Plan_Composite_Rate__c> opplanlistcom = new list<SGR_Opportunity_Plan_Composite_Rate__c>();
        
        opplanratecom.Name = oplist[0].id;
        opplanratecom.Gross_Premium__c = opplanlist[0].Member_Premium__c;
        opplanratecom.Opportunity_Plan_Rate__c = opplanlist[0].id;
        
        planRateIDs1.add(opplanlist[0].Id);
        opplanlistcom.add(opplanratecom);
        Insert opplanlistcom;
       
        
        SGR_Account_Census__c oppcen1 = new SGR_Account_Census__c();
        list<SGR_Account_Census__c> opBenList1 = new list<SGR_Account_Census__c>();
        oppcen1.Name =oplist[0].Id;
        oppcen1.Account__c = newAccount1.id;
        oppcen1.Group_Section_Number__c=gaList[0].id;
        oppcen1.Member_Cancel_Date__c=date.today()+1;
        oppcen1.Member_Effective_Date__c=date.today()-1;
        oppcen1.Membership_Number__c='12';
        
        opBenList1.add(oppcen1);
        Insert opBenList1;
        
        
        
        
        
        SGR_Opportunity_Member_Benefits__c opp5 = new SGR_Opportunity_Member_Benefits__c();
        list<SGR_Opportunity_Member_Benefits__c> opMBenList = new list<SGR_Opportunity_Member_Benefits__c>();
        opp5.Name=newAccount1.id;
        opp5.Opportunity_Group_Section__c = opGList[0].id;
        opp5.Opportunity_Census__c= opBenList[0].id;
        
        opMBenList.add(opp5);
        
        Insert opMBenList;
        
        SGR_Account_Member_Benefit__c opp4 = new SGR_Account_Member_Benefit__c();
        list<SGR_Account_Member_Benefit__c> aMBenList = new list<SGR_Account_Member_Benefit__c>();
        //opp4.Name=newAccount1.id;
        opp4.Account_Census__c= opBenList1[0].id;
        opp4.Group_Section__c= gaList[0].id;
        aMBenList.add(opp4);
        
        Insert aMBenList;
        
        BA_GS_Assignment__c bags =new BA_GS_Assignment__c();
        bags.External_ID__c='654654';
        bags.Benefit_Agreement__c=blist1[0].Id;
        bags.Group_Section__c=gaList[0].Id;
        insert bags;
        
        //List<SGR_Opportunity_Benefit_Agreement__c> baa =[select id from SGR_Opportunity_Benefit_Agreement__c limit 1];
        //List<SGR_Opportunity_Group_Section__c> gaa =[select id from SGR_Opportunity_Group_Section__c limit 1];
        //list<BA_GS_Assignment__c> accBAGSLst =[select name,id,External_ID__c,Benefit_Agreement__r.name,Group_Section__r.name from BA_GS_Assignment__c limit 1];
        
        
        Opportunity_BA_GS_Assignment__c oppBAGS=new Opportunity_BA_GS_Assignment__c();
        oppBAGS.name=bags.name;
        oppBAGS.External_ID__c='654654';
        oppBAGS.Opportunity_Group_Section__c=opGList[0].id;
        oppBAGS.Opportunity_Benefit_Agreement__c=blist[0].id;
        insert oppBAGS;
        
        set<id> planRateIDs = new set<id>();
        Test.startTest();
        SGR_AccountRenewalsHelper.createOpportunities(accList, renType,'Batch',newAccount1.id,renewEffDate, null); 
        
        
        //SGR_AccountRenewalBatch sgbr= new SGR_AccountRenewalBatch(divisions,marketSegment,fundingType,renewEffDate, renType);
        SGR_AccountRenewalsHelper.createRenewalBatchRec(divisions,accNum,marketSegment,fundingType,renewEffDate,renewalType,batchType,count,newAccount1.id);
        //SGR_AccountRenewalsHelper.createOpportunities(accList,renewalType,batchType,batchId,renewEffDate);
        SGR_AccountRenewalsHelper.createRenewalBatchOpps(oplist,newAccount1.id);
        SGR_AccountRenewalsHelper.createErrorLog(accList1,newAccount1.id);
        SGR_AccountRenewalsHelper.validateRenewalEffectiveDate(marketSegment,fundingType,batchType,renewalType,divisions,renewEffDate);
        op_Ben_Map=SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(ide,oplist,batchId);
        SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(ide,oplist,batchId);
        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide,oplist,batchId);
        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(ide1,oplist1,batchId);
        SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(ide,oplist,batchId,op_Ben_Map);
        SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(ide,oplist,batchId);
        SGR_AccountRenewalsHelper.insertOppBAGSAssignment(ide,oplist,batchId);
        SGR_AccountRenewalsHelper.renewalBatchInsert(divisions, accNum, marketSegment, fundingType, renewEffDate, renewalType);
        //SGR_AccountRenewalsHelper.insertOptyPlanCompRate(planRateIDs);
        //SGR_AccountRenewalsHelper.createRenewalBatchRec('IL','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        //SGR_AccountRenewalsHelper.createRenewalBatchRec('OK','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        //SGR_AccountRenewalsHelper.createRenewalBatchRec('NM','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        //SGR_AccountRenewalsHelper.createRenewalBatchRec('TX','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        //SGR_AccountRenewalsHelper.createRenewalBatchRec('MT','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        SGR_AccountRenewalsHelper.createEventAuditLog(oplist,'Internal Workflow','Refresh Census event is fired by the user');
        //SGR_AccountRenewalsHelper.insertOptyPlanCompRate(planRateIDs1);
        //database.executeBatch(sgbr);
        string str=String.valueof(oplist[0].id);
         string str1=String.valueof(opplanlist[0].id);
        
        
        SGR_AccountRenewalsHelper.createAlternateOptyPlanRate(str,'type',str1);
        
        
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
    static testmethod  void testmethod2(){
        
        //SGR_AccountRenewalsHelper.createRenewalBatchRec('IL','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        SGR_AccountRenewalsHelper.createRenewalBatchRec('OK','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        SGR_AccountRenewalsHelper.createRenewalBatchRec('NM','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        SGR_AccountRenewalsHelper.createRenewalBatchRec('TX','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
        SGR_AccountRenewalsHelper.createRenewalBatchRec('MT','accNum','marketSegment','fundingType',system.today(),'renType','batchType',2, 'batchId');
   
    }
    private static testmethod void insertOpportunities(){
        Date renDate = system.today().adddays(20);
        Account acc = Sgr_TestDataUtility.createAcc('NewAcc',12345,'45321','TX',renDate,'Active','SG', 'PREM');
        List<Account> accList = new List<Account>();
        accList.add(acc);
        SGRRenewalBatch__c renBatch = Sgr_TestDataUtility.createRenewalBatch1('Ren Batch', 'BId123', 'Analytical', 'TX', 'SG', 'PREM', 1);
        Insert renBatch;
        SGR_AccountRenewalsHelper.createOpportunities(accList, 'Analytical','Batch',renBatch.id,renDate, null); 
        //( list<Account> acc,String renewalType,String batchType,String batchId,DAte renEffDate, Actuary_Gate__c gateRec){
        //Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        //Id sgrAnalytOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
        
    }
   
    private static testmethod void insertOpportunitiesPlanRateTest(){
        Date renDate = system.today().adddays(20);
        Date closeDate = system.today().adddays(30);
            Account acc = Sgr_TestDataUtility.createAcc('NewAcc',12345,'45321','TX',renDate,'Active','SG', 'PREM');
        
        set<Id> accIds = new Set<Id>();
        accIds.add(acc.Id);
        Plan__c plH = Sgr_TestDataUtility.createPlan('Plan1', 'MktPlanIdH', 'H');
        plH.Expiry_Date__c=System.today();
        plH.Marketing_Plan_Number__c='123456';
        insert plH;
        Plan__c plD = Sgr_TestDataUtility.createPlan('Plan1', 'MktPlanIdD', 'D');
        plD.Expiry_Date__c=System.today();
        plD.Marketing_Plan_Number__c='789';
        insert plD;
        SGR_Account_Plan_Rate__c plRateH = Sgr_TestDataUtility.accPlanRate(plH.id, 'MktPlanIdH', acc.Id);
        plRateH.Marketing_Plan_ID__c='123456';
        insert plRateH;
        SGR_Account_Plan_Rate__c plRateD = Sgr_TestDataUtility.accPlanRate(plD.id, 'MktPlanIdD', acc.Id);
        plRateD.Marketing_Plan_ID__c='789';
        insert plRateD;
        System.debug('Ravi Test'+plRateD);
        Opportunity opty1 = Sgr_TestDataUtility.createOpty('Opty1', acc.Id,'Initiated','Qualify','PREM',renDate,closeDate);
        opty1.FIPS_Code__c = '17111';
        update opty1;
        list<SGR_Opportunity_Benefit_Agreement__c> opBenListMapping =new list<SGR_Opportunity_Benefit_Agreement__c>();
        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> op_Ben_Map= new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        Map<String, Plan__c> marketingPlanIdPlanMap = new Map<String, Plan__c>();
        marketingPlanIdPlanMap.put('101',plD);
        List<Opportunity> optys = new List<Opportunity>();
        optys.add(opty1);
        //SGR_Plan_FIPS_Map__c fipsCode = Sgr_TestDataUtility.createFipsMap('Fip1', '17111', 'TX');
        //Insert fipsCode;
       SGR_Opportunity_Benefit_Agreement__c oBA = new SGR_Opportunity_Benefit_Agreement__c(Benefit_Agreement_Number__c='Test4', Opportunity__c=opty1.id, Plan1__c= plD.Id, Renewal_Date__c=System.today().addMonths(1));
        insert oBA;
        opBenListMapping.add(oBA);
        op_Ben_Map.put(opty1.id,opBenListMapping);
        Test.startTest();
        SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(accIDs,optys,'BidErr',op_Ben_Map);
        //SGR_AccountRenewalsHelper.createOptyPlanRate(plRateD,'Renewal', String.valueof(optys[0].id),optys[0].Renewal_Date__c,marketingPlanIdPlanMap,opBenListMapping);
        
        Test.StopTest();
    }
    

    
}