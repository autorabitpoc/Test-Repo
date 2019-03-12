@isTest
public class SGR_URE_OpportunityRatingBatch_Test {
    
    @isTest 
    public static void testOppRating(){
        List<String> task = new List<String> ();
        task.add('RetentionTask');
        task.add('MarketingRatesGenericTask');
        Integer age= 4;
        String  rateEffectiveDate='2019-01-01';
        List<String> values = new List<String>();
         List<String> errMsgsLst = new List<String>();
        errMsgsLst.add('error');
        errMsgsLst.add('error12');
        
       
        
        
        set<string> planId = new set<string> ();
        List<string> type = new List<string>();
        type.add('TIER4');
        planId.add('SPSG10BCOSILO');
        planId.add('SPSG10PPOSILO');
        planId.add('DILLR07');
        
        
          CustomSettingDAO.ICustomSettingDAO customSettingInstance=new CustomSettingDAO();
        Username_Password__c pwd = new Username_Password__c();
        pwd.Name = 'URE_Rate_Callout';
        pwd.Integration_Name__c = 'Integration SGR';
        pwd.EndPoinUrl__c = 'https://test';
        pwd.Password__c = 'Password';
        insert pwd;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User u =new User();
        u.FirstName = 'Integration test';
        u.LastName = 'SGR';
        u.Alias = 'ISGR';
        u.Email = 'xyz@gmail.com';
        u.Username = 'Integrationxyz@gmail.com';
        u.IsActive = true;
        u.ProfileId = profileId.id;
        u.TimeZoneSidKey = 'GMT';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        OAuth_Jwt_Token2__c oAuth = new OAuth_Jwt_Token2__c();
        oAuth.Name = 'Integration SGR';
        //oAuth.SetupOwnerId=u.Id;
        oAuth.Password__c='xx';
     	oAuth.UserName__c = 'xs123';
     	oAuth.End_Point__c = 'https://test';
        oAuth.Last_Updated_Date_Time__c = System.now();
        oAuth.JWT_Token__c = 'xyz1234';
      
     	insert oAuth;
        
        Plan__c pl=new Plan__c();
        pl.name='SPSG10BCOSILO';
        insert pl;
        
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Lost';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.HCSC_Division__c ='IL';
        op.Renewal_Date__c = System.today();
        op.County_Code__c = '43243';
        op.FIPS_Code__c = '17111';
        op.Zip_Code__c = '32015';
        op.Date_Closed__c = System.today();
        op.Primary_Closed_Reason__c ='Other';
        op.Closed_Comments__c = 'xyz';
        oppList.add(op);
        
       
        Opportunity op2=new Opportunity();
        op2.name='TestOp';
        op2.StageName='Withdrawn';
        op2.CloseDate=Date.newInstance(2022, 12, 9);
        op2.HCSC_Division__c ='IL';
        op2.Renewal_Date__c = System.today();
        op2.County_Code__c = '43243';
        op2.Zip_Code__c = '32015';
        op2.Date_Closed__c = System.today();
        op2.Primary_Closed_Reason__c ='Other';
        op2.Closed_Comments__c = 'xyz';
        oppList.add(op2);
        
        Opportunity op3=new Opportunity();
        op3.name='TestOp';
        op3.StageName='Lost';
        op3.CloseDate=Date.newInstance(2022, 12, 9);
        op3.HCSC_Division__c ='IL';
        op3.Renewal_Date__c = System.today();
        op3.Zip_Code__c = '32015';
        op3.Date_Closed__c = System.today();
        op3.Primary_Closed_Reason__c ='Other';
        op3.Closed_Comments__c = 'xyz';
        oppList.add(op3);
        
        insert oppList;
        list<id> opId=new list<id>();
        for(Opportunity opp: oppList){
            opId.add(opp.id);
        }
        Division__c div = new Division__c();
        div.Name = 'IL';
        div.State_Code__c ='17';
        insert div;
        
        SearchFIPS__c fips = new SearchFIPS__c();
        fips.FIPS_Code__c = '17111';
        fips.ZipCode__c = '32015';
        fips.State__c = 'IL';
        fips.Name ='17111IL';
        insert fips;
        
        SGR_Opportunity_Plan_Rate__c opPlan=new SGR_Opportunity_Plan_Rate__c();
        opPlan.Name='PR - 0000000434';
        opPlan.Opportunity__c=op.id;
        opPlan.Plan__c=pl.id;
        opPlan.Type__c = 'Renewal';
        insert opPlan;
        
        SGR_Opportunity_Group_Section__c grp=new SGR_Opportunity_Group_Section__c();
        grp.Name='GS-976908';
        grp.Opportunity__c=op.id;
        insert grp;
        
        SGR_Opportunity_Census__c cen=new SGR_Opportunity_Census__c();
        cen.Name='860535';
        cen.Opportunity__c=op.id;
        cen.Subscriber_Number__c=860535;
        cen.Gender__c='M';
        cen.Relationship__c='Subscriber';
        cen.Relationship_Code__c='PR';
        cen.Date_of_Birth__c=Date.newInstance(1992, 12, 9);
        cen.Age_New__c=26;
        cen.Zip_Code__c='12';
        insert cen;
        list<SGR_Opportunity_Census__c> cenLst=new list<SGR_Opportunity_Census__c>();
        cenLst.add(cen);
        
        
        
        List<SGR_Opportunity_Member_Benefits__c> soc = new List<SGR_Opportunity_Member_Benefits__c>();
        SGR_Opportunity_Member_Benefits__c mbs = new SGR_Opportunity_Member_Benefits__c();
        mbs.Name='demo34Cloned';
        mbs.Opportunity_Group_Section__c=grp.id;
        mbs.Opportunity_Census__c=cen.id;
        mbs.Opportunity_Plan_Rate__c=opPlan.id;
        insert mbs;
        soc.add(mbs);
        
        SGR_URE_OpportunityRatingBatch obj=new SGR_URE_OpportunityRatingBatch(opId);
        Database.executeBatch(obj);
        
    }

}