@isTest
private class SGR_Beng_RequestHelperTest{

@testSetup static void setup() {
    // setup data
    Id ProducerTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
    Id ContactTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agency Contact').getRecordTypeId();
    Id censusTypeId = Schema.SObjectType.SGR_Opportunity_Census__c.getRecordTypeInfosByName().get('SGR Opportunity Census').getRecordTypeId();
    Id oppTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
    Account pd=new Account();
    pd.name = 'Luke Producer';
    pd.Type='Producer';
    pd.National_Producer_Number__c='12345';
    pd.External_ID__c='67890';
    pd.recordTypeId=ProducerTypeId;
    pd.ShippingStreet='1001 Producer Dr.';
    pd.ShippingCity='Richardson';
    pd.ShippingState='TX';
    pd.ShippingPostalCode='75083';
    insert pd;  system.debug(pd);
    Account pd1=new Account();
    pd1.name = 'Luke Sub Producer';
    pd1.Type='Sub Producer';
    pd1.National_Producer_Number__c='12345pd1';
    pd1.External_ID__c='67890pd1';
    pd1.recordTypeId=ProducerTypeId;
    pd1.ShippingStreet='1001 Sub Producer Dr.';
    pd1.ShippingCity='Richardson';
    pd1.ShippingState='TX';
    pd1.ShippingPostalCode='75083';
    insert pd1; system.debug(pd1);
    Account pd2=new Account();
    pd2.name = 'Luke General Agent';
    pd2.Type='General Agent';
    pd2.National_Producer_Number__c='12345pd2';
    pd2.External_ID__c='67890pd2';
    pd2.recordTypeId=ProducerTypeId;
    pd2.ShippingStreet='1001 GA Dr.';
    pd2.ShippingCity='Richardson';
    pd2.ShippingState='TX';
    pd2.ShippingPostalCode='75083';
    insert pd2; system.debug(pd2);
    Account a = new Account();
    a.name='Luke Bengage';
    a.AccountNumber='TX090909';
    a.Line_of_business__c='Major National';
    a.HCSC_Division__c='TX';
    a.Primary_Producer_Account__c=pd.id;
    a.primary_contact_name__c='John Smith';
    a.ShippingStreet='1001 Lookout Dr.';
    a.ShippingCity='Richardson';
    a.ShippingState='TX';
    a.ShippingPostalCode='75083';
    insert a; system.debug(a);
    Opportunity opp = new Opportunity();
    opp.name='Luke Bengage';
    opp.stagename='Renewal Planning';
    opp.recordtypeid=oppTypeId;
    opp.Closed_Comments__c = 'XYZ';
    opp.Date_Closed__c = date.today();
    opp.CloseDate = system.today();
    opp.Requested_Effective_Date__c=Date.newInstance(2019, 2, 1);
    opp.Renewal_Date__c=Date.newInstance(2019, 2, 1);
    opp.Expected_Dental_Members__c=20;
    opp.HCSC_Division__c='TX';
    opp.County_Name__c='Collin';
    opp.Zip_Code__c='75075';
    opp.FIPS_Code__c='75075';
    opp.Account_Market_Segment__c='SG';
    opp.Submit_Date__c=Date.newInstance(2019, 1, 1);
    opp.Total_Medical_Monthly_Premium__c=opp.Total_Dental_Monthly_Premium__c=opp.Total_Vision_Monthly_Premium__c=opp.Total_Est_Medical_Insurer_Fees__c=opp.Total_Est_Dental_Insurer_Fees__c=opp.Total_Est_Vision_Insurer_Fees__c=99.99;
    opp.accountId=a.id;
    insert opp; system.debug('>>>> opp.id = ' + opp.id);
    // system.debug('>>>> opp.id=' + opp.id);   
    List<Contact> cList = new List<Contact>();
    Contact c1 = new Contact(); cList.add(c1);
    c1.firstname = 'c1FNAME';
    c1.lastname = 'c1LNAME';
    c1.phone='(123)456-7890';
    c1.email='abc@def.com';
    c1.Primary__c=true;
    c1.Type__c='Renewal';
    c1.accountId=a.id;
    c1.recordTypeId=ContactTypeId;
    c1.MailingStreet='1001 Lookout Dr.';
    c1.MailingCity='Richardson';
    c1.MailingState='TX';
    c1.MailingPostalCode='75083';
    Contact c2 = new Contact(); cList.add(c2);
    c2.firstname = 'c2FNAME';
    c2.lastname = 'c2LNAME';
    c2.phone='(123)456-7800';
    c2.email='abc0@def.com';
    c2.Primary__c=true;
    c2.Type__c='Renewal';
    c2.accountId=pd.id;
    c2.recordTypeId=ContactTypeId;
    c2.MailingStreet='1001 Producer Dr.';
    c2.MailingCity='Richardson';
    c2.MailingState='TX';
    c2.MailingPostalCode='75083';
    Contact c3 = new Contact(); cList.add(c3);
    c3.firstname = 'c3FNAME';
    c3.lastname = 'c3LNAME';
    c3.phone='(123)456-7801';
    c3.email='abc1@def.com';
    c3.Primary__c=true;
    c3.Type__c='Renewal';
    c3.accountId=pd2.id;
    c3.recordTypeId=ContactTypeId;
    c3.MailingStreet='1001 GA Dr.';
    c3.MailingCity='Richardson';
    c3.MailingState='TX';
    c3.MailingPostalCode='75083';
    insert cList; system.debug(cList);
/*    Producer_Group_Association__c pga = new Producer_Group_Association__c();
    pga.Group_Account__c=a.id;
    pga.Producer_Account__c=pd.id;
    Producer_Group_Association__c pga1 = new Producer_Group_Association__c();
    pga1.Group_Account__c=a.id;
    pga1.Producer_Account__c=pd1.id;
    Producer_Group_Association__c pga2 = new Producer_Group_Association__c();
    pga2.Group_Account__c=a.id;
    pga2.Producer_Account__c=pd2.id; */
    Producer_Association_For_Opportunity__c pga = new Producer_Association_For_Opportunity__c();
    pga.Opportunity__c=opp.id;
    pga.Producer_Consultant__c=pd.id;
    Producer_Association_For_Opportunity__c pga1 = new Producer_Association_For_Opportunity__c();
    pga1.Opportunity__c=opp.id;
    pga1.Producer_Consultant__c=pd1.id;
    Producer_Association_For_Opportunity__c pga2 = new Producer_Association_For_Opportunity__c();
    pga2.Opportunity__c=opp.id;
    pga2.Producer_Consultant__c=pd2.id; 
    insert pga; insert pga1; insert pga2; system.debug(pga);system.debug(pga1);system.debug(pga2);
    // Product2
    Product2 prod1 = new Product2();
    prod1.name = 'Preferred Provider Organization (PPO) Network';prod1.IsActive=true;
    insert prod1; system.debug(prod1);
    Product2 prod21 = new Product2();
    prod21.name = 'PPO Plans';prod21.IsActive=true;
    insert prod21; system.debug(prod21);
    Product2 prod22 = new Product2();
    prod22.name = 'HSA Plans';prod22.IsActive=true;
    insert prod22; system.debug(prod22);
    Product2 prod31 = new Product2();
    prod31.name = 'Blue Platinum Plans';prod31.IsActive=true;
    insert prod31; system.debug(prod31);
    Product2 prod32 = new Product2();
    prod32.name = 'Blue Gold Plans';prod32.IsActive=true;
    insert prod32; system.debug(prod32);
    Product2 prod33 = new Product2();
    prod33.name = 'Blue Silver Plans';prod33.IsActive=true;
    insert prod33; system.debug(prod33);
    Product2 prod34 = new Product2();
    prod34.name = 'Blue Bronze Plans';prod34.IsActive=true;
    insert prod34; system.debug(prod34);
    Product2 prodden1 = new Product2();
    prodden1.name = 'Dental Plans';prodden1.IsActive=true;
    insert prodden1; system.debug(prodden1); 
    Product2 prodden2 = new Product2();
    prodden2.name = 'Contributory Group';prodden2.IsActive=true;
    insert prodden2; system.debug(prodden2);    
    Product2 prodden3 = new Product2();
    prodden3.name = 'High Coverage Allocation';prodden3.IsActive=true;
    insert prodden3; system.debug(prodden3);    
    Product2 prodvis1 = new Product2();
    prodvis1.name = 'Vision Plans';prodvis1.IsActive=true;
    insert prodvis1; system.debug(prodvis1); 
    Product2 prodvis2 = new Product2();
    prodvis2.name = 'PREFERRED';prodvis2.IsActive=true;
    insert prodvis2; system.debug(prodvis2); 
    // Plan__c
    Plan__c p1_21_31 = new Plan__c();
    p1_21_31.Name='PPSG11PPOSNMO';
    p1_21_31.Marketing_Plan_Number__c='P811PPO';    
    p1_21_31.Network__c='PPO';  
    p1_21_31.Plan_Level__c='Platinum';  
    p1_21_31.Product_Name__c='Blue Platinum Plans'; 
    p1_21_31.Level_1_Product_Name__c='Preferred Provider Organization (PPO) Network';   
    p1_21_31.Level_2_Product_Name__c='PPO Plans';   
    p1_21_31.Level_1_Product__c=prod1.id;   
    p1_21_31.Level_2_Product__c=prod21.id;  
    p1_21_31.Product__c=prod31.id;  
    insert p1_21_31; system.debug(p1_21_31);
    Plan__c p1_21_32 = new Plan__c();
    p1_21_32.Name='GPSG13PPOSNMO';
    p1_21_32.Marketing_Plan_Number__c='G822PPO';    
    p1_21_32.Network__c='PPO';  
    p1_21_32.Plan_Level__c='Gold';  
    p1_21_32.Product_Name__c='Blue Gold Plans'; 
    p1_21_32.Level_1_Product_Name__c='Preferred Provider Organization (PPO) Network';   
    p1_21_32.Level_2_Product_Name__c='PPO Plans';   
    p1_21_32.Level_1_Product__c=prod1.id;   
    p1_21_32.Level_2_Product__c=prod21.id;  
    p1_21_32.Product__c=prod32.id;  
    insert p1_21_32; system.debug(p1_21_32);
    Plan__c p1_22_33 = new Plan__c();
    p1_22_33.Name='SPSG10PPOSNMO';
    p1_22_33.Marketing_Plan_Number__c='S830PPO';    
    p1_22_33.Network__c='PPO';  
    p1_22_33.Plan_Level__c='Silver';    
    p1_22_33.Product_Name__c='Blue Silver Plans';   
    p1_22_33.Level_1_Product_Name__c='Preferred Provider Organization (PPO) Network';   
    p1_22_33.Level_2_Product_Name__c='HSA Plans';   
    p1_22_33.Level_1_Product__c=prod1.id;   
    p1_22_33.Level_2_Product__c=prod22.id;  
    p1_22_33.Product__c=prod33.id;  
    insert p1_22_33; system.debug(p1_22_33);
    Plan__c p1_22_34 = new Plan__c();
    p1_22_34.Name='BHSG10PPOSNMO';
    p1_22_34.Marketing_Plan_Number__c='B830PPO';    
    p1_22_34.Network__c='PPO';  
    p1_22_34.Plan_Level__c='Bronze';    
    p1_22_34.Product_Name__c='Blue Bronze Plans';   
    p1_22_34.Level_1_Product_Name__c='Preferred Provider Organization (PPO) Network';   
    p1_22_34.Level_2_Product_Name__c='HSA Plans';   
    p1_22_34.Level_1_Product__c=prod1.id;   
    p1_22_34.Level_2_Product__c=prod22.id;  
    p1_22_34.Product__c=prod34.id;
    insert p1_22_34; system.debug(p1_22_34);
    Plan__c pden = new Plan__c();
    pden.Name='DNMHR01';
    pden.Marketing_Plan_Number__c='DNMHR01';    
    pden.Network__c='PPO';  
    pden.Plan_Level__c=null;    
    pden.Product_Name__c='High Coverage Allocation';    
    pden.Level_1_Product_Name__c='Dental Plans';    
    pden.Level_2_Product_Name__c='Contributory Group';  
    pden.Level_1_Product__c=prodden1.id;    
    pden.Level_2_Product__c=prodden2.id;    
    pden.Product__c=prodden3.id;
    insert pden; system.debug(pden);
    Plan__c pvis = new Plan__c();
    pvis.Name='VPRFSNM';
    pvis.Marketing_Plan_Number__c='VPRFSNM';    
    pvis.Network__c='PPO';  
    pvis.Plan_Level__c=null;    
    pvis.Product_Name__c=null;  
    pvis.Level_1_Product_Name__c='Vision Plans';    
    pvis.Level_2_Product_Name__c='PREFERRED';   
    pvis.Level_1_Product__c=prodvis1.id;    
    pvis.Level_2_Product__c=prodvis2.id;    
    pvis.Product__c=null;
    insert pvis; system.debug(pvis);
    List<Plan__c> plns = new List<Plan__c>();
    plns.add(p1_21_31);plns.add(p1_21_32);plns.add(p1_22_33);plns.add(p1_22_34);plns.add(pden);plns.add(pvis);
    // SGR_Lowest_Cost_Plan_Option__c
    SGR_Lowest_Cost_Plan_Option__c opt23 = new SGR_Lowest_Cost_Plan_Option__c();
    opt23.Type__c='Medical';
    opt23.Division__c=opp.HCSC_Division__c;
    opt23.RenewalEffectiveDate__c = opp.Renewal_Date__c;
    opt23.LowestCostOption2__c=p1_21_32.id;
    opt23.LowestCostOption3__c=p1_21_32.id;
    insert opt23; system.debug(opt23);
    // SGR_Opportunity_Plan_Rate__c 
    List<SGR_Opportunity_Plan_Rate__c> prs = new List<SGR_Opportunity_Plan_Rate__c>();
    for(Plan__c p : plns){
        SGR_Opportunity_Plan_Rate__c prc = new SGR_Opportunity_Plan_Rate__c();
        SGR_Opportunity_Plan_Rate__c prr = new SGR_Opportunity_Plan_Rate__c();
        SGR_Opportunity_Plan_Rate__c pra = new SGR_Opportunity_Plan_Rate__c();
        prs.add(prc);prs.add(prr);prs.add(pra);
        prc.Name=prr.Name=pra.Name='plan Rate - ' + p.name;
        prc.Type__c='Current';prr.Type__c='Renewal';pra.Type__c='Alternate';
        prc.Sales_Plan_ID__c=prr.Sales_Plan_ID__c=pra.Sales_Plan_ID__c=p.Marketing_Plan_Number__c;
        prc.Plan_Name__c=prr.Plan_Name__c=pra.Plan_Name__c=p.name;
        prc.Current_Age_Total_Monthly_Premium__c=prc.Current_Comp_Total_Monthly_Premium__c=prc.Renw_Age_Total_Monthly_Premium__c=prc.Renw_Comp_Total_Monthly_Premium__c=prc.Renw_Comp_Total_Est_Tax_and_Fees__c=prc.Renw_Age_Total_Est_Tax_and_Fees__c=prc.Current_Comp_Total_Est_Tax_and_Fees__c=prc.Current_Age_Total_Est_Tax_and_Fees__c=prc.Member_Premium__c=99.99;
        prr.Current_Age_Total_Monthly_Premium__c=prr.Current_Comp_Total_Monthly_Premium__c=prr.Renw_Age_Total_Monthly_Premium__c=prr.Renw_Comp_Total_Monthly_Premium__c=prr.Renw_Comp_Total_Est_Tax_and_Fees__c=prr.Renw_Age_Total_Est_Tax_and_Fees__c=prr.Current_Comp_Total_Est_Tax_and_Fees__c=prr.Current_Age_Total_Est_Tax_and_Fees__c=prr.Member_Premium__c=99.99;
        pra.Current_Age_Total_Monthly_Premium__c=pra.Current_Comp_Total_Monthly_Premium__c=pra.Renw_Age_Total_Monthly_Premium__c=pra.Renw_Comp_Total_Monthly_Premium__c=pra.Renw_Comp_Total_Est_Tax_and_Fees__c=pra.Renw_Age_Total_Est_Tax_and_Fees__c=pra.Current_Comp_Total_Est_Tax_and_Fees__c=pra.Current_Age_Total_Est_Tax_and_Fees__c=pra.Member_Premium__c=99.99;
        prc.Enrolled_Subscriber_Count__c=prr.Enrolled_Subscriber_Count__c=pra.Enrolled_Subscriber_Count__c=1;
        prr.Opt2_Renw_Comp_Total_Monthly_Premium__c=prr.Opt2_Renw_Age_Total_Monthly_Premium__c=prr.Opt3_Renw_Comp_Total_Monthly_Premium__c=prr.Opt3_Renw_Age_Total_Monthly_Premium__c=199.99;
        String typ='H';
        if(p.Level_1_Product_Name__c =='Dental Plans') typ = 'D';
        else if(p.Level_1_Product_Name__c =='Vision Plans') typ = 'V';
        prc.Coverage_Type__c=prr.Coverage_Type__c=pra.Coverage_Type__c=typ;
        prc.Plan__c=prr.Plan__c=pra.Plan__c=p.id;
        prc.Opportunity__c=prr.Opportunity__c=pra.Opportunity__c=opp.id ;
    }
    insert prs; system.debug(prs);
    // SGR_Opportunity_Plan_Composite_Rate__c
    List<SGR_Opportunity_Plan_Composite_Rate__c> pcs = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
    for(SGR_Opportunity_Plan_Rate__c pr : prs){
        SGR_Opportunity_Plan_Composite_Rate__c pcEO = new SGR_Opportunity_Plan_Composite_Rate__c();
        SGR_Opportunity_Plan_Composite_Rate__c pcEC = new SGR_Opportunity_Plan_Composite_Rate__c();
        SGR_Opportunity_Plan_Composite_Rate__c pcES = new SGR_Opportunity_Plan_Composite_Rate__c();
        SGR_Opportunity_Plan_Composite_Rate__c pcEF = new SGR_Opportunity_Plan_Composite_Rate__c();
        pcs.add(pcEO);pcs.add(pcEC);pcs.add(pcES);pcs.add(pcEF);
        pcEO.Opportunity_Plan_Rate__c=pcEC.Opportunity_Plan_Rate__c=pcES.Opportunity_Plan_Rate__c=pcEF.Opportunity_Plan_Rate__c=pr.id;
        pcEO.Tier_Code__c='EO';pcEC.Tier_Code__c='EC';pcES.Tier_Code__c='ES';pcEF.Tier_Code__c='EF';
        pcEO.Gross_Premium__c=pcEC.Gross_Premium__c=pcES.Gross_Premium__c=pcEF.Gross_Premium__c=299;
        pcEO.Total_Monthly_Premium__c=pcEC.Total_Monthly_Premium__c=pcES.Total_Monthly_Premium__c=pcEF.Total_Monthly_Premium__c=399;
        pcEO.Total_Estimated_Taxes_and_Fees__c=pcEC.Total_Estimated_Taxes_and_Fees__c=pcES.Total_Estimated_Taxes_and_Fees__c=pcEF.Total_Estimated_Taxes_and_Fees__c=99;
    }
    insert pcs; system.debug(pcs);
    // SGR_Plan_Age_Rate_Header__c
    List<SGR_Plan_Age_Rate_Header__c> prhs = new List<SGR_Plan_Age_Rate_Header__c>();
    Integer fips = 75000;
    for(Plan__c p : plns){
        SGR_Plan_Age_Rate_Header__c prh = new SGR_Plan_Age_Rate_Header__c();
        prhs.add(prh);
        prh.Plan__c = p.id;
        prh.FIPS_Code__c = '75075';
        prh.Rate_Effective_Date__c = opp.Renewal_Date__c;
    }
    insert prhs; system.debug(prhs);
    // SGR_Plan_Age_Rate_Detail__c
    List<SGR_Plan_Age_Rate_Detail__c> pads = new List<SGR_Plan_Age_Rate_Detail__c>();
    for(SGR_Plan_Age_Rate_Header__c prh : prhs){
        for(Integer age=14; age <=64; age++){
            SGR_Plan_Age_Rate_Detail__c pad = new SGR_Plan_Age_Rate_Detail__c();
            pads.add(pad);
            // pad.name = 'Age ' + age;
            pad.Gross_Premium__c = 199;
            pad.Age_Rate_Header__c = prh.id;
            pad.From_Age__c=pad.To_Age__c=age;
            pad.Relationship_Code__c = 'PR';
            pad.Is_TEFRA__c = false;
            pad.Is_Tobacco__c = false;
        }
    }
    insert pads; system.debug(pads);
    // SGR_Opportunity_Census__c
    SGR_Opportunity_Census__c cen1 = new SGR_Opportunity_Census__c();
    SGR_Opportunity_Census__c cen1_1 = new SGR_Opportunity_Census__c();
    SGR_Opportunity_Census__c cen1_2 = new SGR_Opportunity_Census__c();
    SGR_Opportunity_Census__c cen1_3 = new SGR_Opportunity_Census__c();
    cen1.First_Name__c='John';cen1_1.First_Name__c='Mary';cen1_2.First_Name__c='Nacy';cen1_3.First_Name__c='Peter';
    cen1.Last_Name__c=cen1_1.Last_Name__c=cen1_2.Last_Name__c=cen1_3.Last_Name__c='Smith';
    cen1.Relationship_Code__c='STD';
    cen1_1.Relationship_Code__c='STD';
    cen1_2.Relationship_Code__c='STD';cen1_3.Relationship_Code__c='STD';
    cen1.recordTypeId=cen1_1.recordTypeId=cen1_2.recordTypeId=cen1_3.recordTypeId=censusTypeId; 
    cen1.Date_of_Birth__c=Date.newInstance(1970, 2, 1);cen1_1.Date_of_Birth__c=Date.newInstance(1975, 2, 1);cen1_2.Date_of_Birth__c=Date.newInstance(1999, 2, 1);cen1_3.Date_of_Birth__c=Date.newInstance(1997, 2, 1);
    cen1.State__c=cen1_1.State__c=cen1_2.State__c=cen1_3.State__c='Texas';
    cen1.Relationship__c='Subscriber';cen1_1.Relationship__c='Spouse';cen1_2.Relationship__c='Child';cen1_3.Relationship__c='Child';
    cen1.Row__c='1';cen1_1.Row__c='1.1';cen1_2.Row__c='1.2';cen1_3.Row__c='1.3';
    cen1.Health_Tier__c=cen1_1.Health_Tier__c=cen1_2.Health_Tier__c=cen1_3.Health_Tier__c='EF';
    cen1.Dental_Tier__c=cen1_1.Dental_Tier__c=cen1_2.Dental_Tier__c=cen1_3.Dental_Tier__c='EF';
    cen1.Vision_Tier__c=cen1_1.Vision_Tier__c=cen1_2.Vision_Tier__c=cen1_3.Vision_Tier__c='EF';
    cen1.Health_Plan_ID__c=cen1_1.Health_Plan_ID__c=cen1_2.Health_Plan_ID__c=cen1_3.Health_Plan_ID__c='123456789';
    cen1.Dental_Plan_ID__c=cen1_1.Dental_Plan_ID__c=cen1_2.Dental_Plan_ID__c=cen1_3.Dental_Plan_ID__c='123456789';
    cen1.Vision_Plan_ID__c=cen1_1.Vision_Plan_ID__c=cen1_2.Vision_Plan_ID__c=cen1_3.Vision_Plan_ID__c='123456789';
    cen1.Zip_Code__c=cen1_1.Zip_Code__c=cen1_2.Zip_Code__c=cen1_3.Zip_Code__c='75001';
    cen1.Gender__c='M';cen1_1.Gender__c='F';cen1_2.Gender__c='F';cen1_3.Gender__c='M';
    cen1.Opportunity__c=cen1_1.Opportunity__c=cen1_2.Opportunity__c=cen1_3.Opportunity__c=opp.id;
    List<SGR_Opportunity_Census__c> cens = new List<SGR_Opportunity_Census__c>();
    cens.add(cen1);cens.add(cen1_1);cens.add(cen1_2);cens.add(cen1_3);
    insert cens; system.debug(cens);
    // SGR_Opportunity_Group_Section__c
    SGR_Opportunity_Group_Section__c grp = new SGR_Opportunity_Group_Section__c();
    grp.name = 'Test Grp01';
    insert grp; system.debug('>>>> id = ' + grp.id);
    // SGR_Opportunity_Member_Benefits__c
    List<SGR_Opportunity_Member_Benefits__c> mems = new List<SGR_Opportunity_Member_Benefits__c>();
    List<String> comList = new List<String>{'EO', 'ES', 'EC', 'EF'};
    for(SGR_Opportunity_Plan_Rate__c pr : prs){
        integer i = 0;
        for(SGR_Opportunity_Census__c cen : cens){
            SGR_Opportunity_Member_Benefits__c mem = new SGR_Opportunity_Member_Benefits__c();
            mem.Opportunity_Group_Section__c = grp.id;
            mem.Tier_Code__c = comList[i]; i++;
            mem.Opportunity_Census__c = cen.id;
            mem.Opportunity_Plan_Rate__c = pr.id;
            mem.Renw_Age_Gross_Premium__c=mem.Renw_Comp_Gross_Premium__c=99.99;
            mem.Age_Total_Employee_Rate__c=mem.Age_Total_Spouse_Rate__c=mem.Age_Total_Child_Rate__c=mem.Renw_Age_Total_Monthly_Premium__c=99.99;
            mem.Opt2_Renw_Comp_Total_Monthly_Premium__c=mem.Opt2_Age_Total_Employee_Rate__c=mem.Opt2_Age_Total_Spouse_Rate__c=mem.Opt2_Age_Total_Child_Rate__c=mem.Opt2_Age_Total_All_Rate__c=99.99;
            mem.Opt3_Renw_Comp_Total_Monthly_Premium__c=mem.Opt3_Age_Total_Employee_Rate__c=mem.Opt3_Age_Total_Spouse_Rate__c=mem.Opt3_Age_Total_Child_Rate__c=mem.Opt3_Age_Total_All_Rate__c=99.99;
            mems.add(mem);
        }
    }
    insert mems; system.debug(mems);
    // Benefit_Header_Detail__c, Benefit_Header_Detail_Association__c
    List<Benefit_Header_Detail__c> bhds = new List<Benefit_Header_Detail__c>();
    bhds.add(createBHD('0','Ded In/Out','$500/$1,000'));
    bhds.add(createBHD('1','Office Visit','$40/$60'));
    bhds.add(createBHD('2','Coins In/Out','80%/60%'));     
    bhds.add(createBHD('3','OPX In/Out','$6,500/$8,000'));  
    bhds.add(createBHD('4','Preferred Rx','$10/$20/$30/$100/$100/$100'));   
    bhds.add(createBHD('5','Deductible In/Out','$100/$200'));   
    bhds.add(createBHD('6','In Network','80%/60%'));    
    bhds.add(createBHD('7','Out Of Network','50%/NA'));     
    bhds.add(createBHD('8','Orthodontia Lifetime Max','$5,000/NA'));    
    bhds.add(createBHD('9','Annual Benefit Max','$8,000/NA'));  
    bhds.add(createBHD('10','Out-of-Network Reimb','90th R&C/MAC'));    
    bhds.add(createBHD('11','Exam','$60'));     
    bhds.add(createBHD('12','Frames','$120'));  
    bhds.add(createBHD('13','Conventional Lenses','Single Vision - $100 Bifocal Single - $100 Bifocal Double - $100 Trifocal - $100 Lenticular Including Aspheric - $100'));    
    bhds.add(createBHD('14','Contact Lenses','In Lieu of Glasses - $100 Sole Treatment Option - $100'));    
    bhds.add(createBHD('15','Ped Dental','80%/60%'));   
    bhds.add(createBHD('16','ER Copay','$100/80%'));    
    bhds.add(createBHD('17','IP In/Out','$150/$250')); 
    bhds.add(createBHD('18','OP Surg In/Out','$500/$1,000')); 
    bhds.add(createBHD('19','Plan Type','Passive')); 
    insert bhds; system.debug(bhds);
    List<Benefit_Header_Detail_Association__c> bhdas = new List<Benefit_Header_Detail_Association__c>();
    for(Plan__c p : plns){
        for(Benefit_Header_Detail__c bhd : bhds){
            Benefit_Header_Detail_Association__c bhda = new Benefit_Header_Detail_Association__c();
            bhdas.add(bhda);
            bhda.Plan__c = p.id;
            bhda.Benefit_Header_Detail__c = bhd.id;
            bhda.Effective_Date__c = opp.Renewal_Date__c;
        }
    }
    insert bhdas; system.debug(bhdas);
    // SGR_Note__c, Plan_Note_Association__c
    List<SGR_Note__c> notes = new List<SGR_Note__c>();
    List<Plan_Note_Association__c> nas = new List<Plan_Note_Association__c>();
    Integer i = 1;
    for(Plan__c p : plns){
        SGR_Note__c n = new SGR_Note__c(); notes.add(n);
        Plan_Note_Association__c na = new Plan_Note_Association__c(); nas.add(na);
        n.name='' + i;
        n.Symbol__c='*' + i; i++;
        insert n;
        na.Plan__c = p.id;
        na.Mapped_Note_Id__c = n.name;
        na.Plan_Note__c = n.id;
        na.Effective_Date__c = opp.Renewal_Date__c;
    }
    insert nas; system.debug(notes);system.debug(nas);
    // SGR_Note_Detail__c, Product_Note_Detail_Association__c
    List<SGR_Note_Detail__c> nds = new List<SGR_Note_Detail__c>();
    List<Product_Note_Detail_Association__c> ndas = new List<Product_Note_Detail_Association__c>();
    for(SGR_Note__c n : notes){
        SGR_Note_Detail__c nd = new SGR_Note_Detail__c();
        Product_Note_Detail_Association__c nda = new Product_Note_Detail_Association__c();
        nd.Symbol__c=n.Symbol__c;
        nd.Text__c='This is the explanation for symbol ' + n.Symbol__c + '.';
        nd.name=n.name;
        insert nd; nds.add(nd); ndas.add(nda);
        nda.Plan_Note_Detail__c=nd.id;
        nda.Product__c=prod1.id;
        nda.Mapped_Note_Detail_Id__c=nd.name;
        nda.Mapped_Product_Key__c='12345';
        nda.Effective_Date__c = opp.Renewal_Date__c;
    }
    insert ndas; system.debug(nds);system.debug(ndas);
}

@isTest static void testCreateXmlDocSTNRateAcc(){
    // run the test to generate encoded64 XML doc
    List<SGR_Opportunity_Plan_Rate__c> prs = [select id,Rate_Type_Code__c from SGR_Opportunity_Plan_Rate__c];
    for(SGR_Opportunity_Plan_Rate__c pr : prs) pr.Rate_Type_Code__c = 'STN';
    update prs;
    Opportunity opp = [select id from Opportunity limit 1];
    SGR_Beng_XML_TemplateDAO dao = new SGR_Beng_XML_TemplateDAO();
    dao.oppId=opp.id;
    dao.docVer='PRINT';   
    dao.docType='Renewal';   
    dao.source='Salesforce';
    dao.correspondenceId='1234';
    dao.printType='Account'; // Producer, Account, GA
    String s = dao.createXmlDoc();
 }
 
@isTest static void testCreateXmlDocAGERatePro(){
    // run the test to generate encoded64 XML doc
    List<SGR_Opportunity_Plan_Rate__c> prs = [select id,Rate_Type_Code__c from SGR_Opportunity_Plan_Rate__c];
    for(SGR_Opportunity_Plan_Rate__c pr : prs) pr.Rate_Type_Code__c = 'AGE';
    update prs;
    Opportunity opp = [select id from Opportunity limit 1];
    SGR_Beng_XML_TemplateDAO dao = new SGR_Beng_XML_TemplateDAO();
    dao.oppId=opp.id;
    dao.docVer='PRINT';   
    dao.docType='Renewal';   
    dao.source='Salesforce';
    dao.correspondenceId='1234';
    dao.printType='Producer'; // Producer, Account, GA
    String s = dao.createXmlDoc();
 }

@isTest static void testCreateXmlDocSTNRateGA(){
    // run the test to generate encoded64 XML doc
    List<SGR_Opportunity_Plan_Rate__c> prs = [select id,Rate_Type_Code__c from SGR_Opportunity_Plan_Rate__c];
    for(SGR_Opportunity_Plan_Rate__c pr : prs) pr.Rate_Type_Code__c = 'STN';
    update prs;
    Opportunity opp = [select id from Opportunity limit 1];
    SGR_Beng_XML_TemplateDAO dao = new SGR_Beng_XML_TemplateDAO();
    dao.oppId=opp.id;
    dao.docVer='PRINT';   
    dao.docType='Renewal';   
    dao.source='Salesforce';
    dao.correspondenceId='1234';
    dao.printType='GA'; // Producer, Account, GA
    String s = dao.createXmlDoc();
 }


private static Benefit_Header_Detail__c createBHD(String name, String header, String value){
    Benefit_Header_Detail__c bhd1 = new Benefit_Header_Detail__c();
    bhd1.Benefit_Header_Detail_Name__c=header;
    bhd1.name=name; bhd1.Value__c=value;
    return bhd1;
}

}