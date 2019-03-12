@isTest
public class SGR_URE_OpportunityRatingHelperTest {

    @isTest 
    public static void testOppRating(){
    
        Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
       // Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
        Test.loadData(OAuth_Jwt_Token2__c.sObjectType,'JwtOauth2TestData');
        String mockResBody='{"rffResult": {"marketingDentalRatesSpecificTaskResult": {"ratingPackageResults": [{"productResults": [{"planResults": [{"areaResults": [{"areaNumber": "100","isTefra": "false","isTobacco": "false","rates": [{"censusDetailId": "860534","grossPremium": "43.66","retentionBreakdown": {"ACAFees": "0.00","Net_of_ACA": "43.66","nonACAFees": "14.04"},"subscriberId": "860534"},{"censusDetailId": "860535","grossPremium": "43.66","retentionBreakdown": {"ACAFees": "0.00","Net_of_ACA": "43.66","nonACAFees": "14.04"},"subscriberId": "860535"}]}],"compositeRateResults": [{"tierResult": [{"tierRate": [{"ACAFees": "0.00","grossPremium": "43.66","tier": "EO"},{"ACAFees": "0.00","grossPremium": "106.97","tier": "EC"},{"ACAFees": "0.00","grossPremium": "87.32","tier": "ES"},{"ACAFees": "0.00","grossPremium": "172.46","tier": "EF"}],"type": "4"}]}],"coverageCode": "D","demographicFactorClass": "D7","optionResults": [{"optionDetails": [{"areaFactorClass": "1","benefitName": "DILLR07","benefitType": "Dental"}]}],"planId": "DILLR07"}],"value": "PPO"}]}]},"marketingRatesSpecificTaskResult": {"ratingPackageResults": [{"productResults": [{"planResults": [{"areaResults": [{"areaNumber": "2","isTefra": "false","isTobacco": "false","rates": [{"censusDetailId": "860534","grossPremium": "318.05","retentionBreakdown": {"ACAFees": "0.48","Net_of_ACA": "317.57","nonACAFees": "41.97"},"subscriberId": "860534"},{"censusDetailId": "860535","grossPremium": "306.64","retentionBreakdown": {"ACAFees": "0.46","Net_of_ACA": "306.18","nonACAFees": "40.46"},"subscriberId": "860535"}]}],"compositeRateResults": [{"tierResult": [{"tierRate": [{"ACAFees": "0.47","grossPremium": "312.35","tier": "EO"},{"ACAFees": "0.87","grossPremium": "577.85","tier": "EC"},{"ACAFees": "0.94","grossPremium": "624.70","tier": "ES"},{"ACAFees": "1.34","grossPremium": "890.20","tier": "EF"}],"type": "4"}]}],"coverageCode": "M","demographicFactorClass": "1 ","optionResults": [{"optionDetails": [{"areaFactorClass": "62","benefitName": "36096IL0900038","benefitType": "MEDICAL"}]}],"planId": "SPSG10BCOSILO"}],"value": "BOPT MED"},{"planResults": [{"areaResults": [{"areaNumber": "2","isTefra": "false","isTobacco": "false","rates": [{"censusDetailId": "860534","grossPremium": "403.08","retentionBreakdown": {"ACAFees": "0.60","Net_of_ACA": "402.48","nonACAFees": "53.19"},"subscriberId": "860534"},{"censusDetailId": "860535","grossPremium": "388.62","retentionBreakdown": {"ACAFees": "0.58","Net_of_ACA": "388.04","nonACAFees": "51.28"},"subscriberId": "860535"}]}],"compositeRateResults": [{"tierResult": [{"tierRate": [{"ACAFees": "0.59","grossPremium": "395.85","tier": "EO"},{"ACAFees": "1.10","grossPremium": "732.32","tier": "EC"},{"ACAFees": "1.19","grossPremium": "791.70","tier": "ES"},{"ACAFees": "1.69","grossPremium": "1128.17","tier": "EF"}],"type": "4"}]}],"coverageCode": "M","demographicFactorClass": "1 ","optionResults": [{"optionDetails": [{"areaFactorClass": "1","benefitName": "36096IL0770045","benefitType": "MEDICAL"}]}],"planId": "SPSG10PPOSILO"}],"value": "PPO MED"}]}]},"rateSize": "A","referenceId": "13127874","retentionTaskResult": [{"coverageCode": "M","multplvFactors": {"ACAFees": "0.001500000000000","commission": "0.000000000000000","expense": "0.131960000000000","m5": "0.000000000000000","margin": "0.000000000000000","premtax": "0.000000000000000"}},{"coverageCode": "D","multplvFactors": {"ACAFees": "0.000000000000000","commission": "0.000000000000000","expense": "0.321600000000000","m5": "0.000000000000000","margin": "0.000000000000000","premtax": "0.000000000000000"}}]}}';
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseProductGroup(200, '{"username": "test","access_token": "test","token_type": "Bearer","expires_in": 3650, "refresh_token": "test", "scope": "oob", "jwt_token": "test"}'));
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseProductGroup(200,mockResBody));
       
        List<String> task = new List<String> ();
        task.add('RetentionTask');
        task.add('MarketingRatesGenericTask'); 
        Integer age= 4;
        String  rateEffectiveDate='01/01/2019';
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
        pl.Marketing_Plan_Number__c='111';
        insert pl;
        
        Plan__c pl2=new Plan__c();
        pl2.name='SPSG10BCOSIjfgh';
        insert pl2;
        
        list<id> opId=new list<id>();
        List<Opportunity> opList=new List<Opportunity>();
        Opportunity op=new Opportunity();
        op.name='TestOp';
        op.StageName='Withdrawn';
        op.CloseDate=Date.newInstance(2022, 12, 9);
        op.Date_Closed__c = System.today();
        op.Primary_Closed_Reason__c ='Other';
        op.Closed_Comments__c = 'xyz';
        op.FIPS_Code__c = '17111';
        //op.Gate__r.Status__c='Down';
        opList.add(op);
        
        
        Opportunity op2=new Opportunity();
        op2.name='TestOp2';
        op2.StageName='Lost';
        op2.CloseDate=Date.newInstance(2022, 12, 9);
        op2.Date_Closed__c = System.today();
        op2.Primary_Closed_Reason__c ='Other';
        op2.Closed_Comments__c = 'xyz';
        //op2.Gate__r.Status__c='sdfds';
        opList.add(op2);
        insert opList;
        opId.add(opList[0].id);
        opId.add(opList[1].id);
        
        List<SGR_Opportunity_Plan_Rate__c> opPlanList=new List<SGR_Opportunity_Plan_Rate__c>();
        SGR_Opportunity_Plan_Rate__c opPlan=new SGR_Opportunity_Plan_Rate__c();
        opPlan.Name='PR - 0000000434';
        opPlan.Opportunity__c=opList[0].id;
        opPlan.Plan__c=pl.id;
        opPlanList.add(opPlan);
        
        SGR_Opportunity_Plan_Rate__c opPlan2=new SGR_Opportunity_Plan_Rate__c();
        opPlan2.Name='PR - 0000000434';
        opPlan2.Opportunity__c=opList[1].id;
        opPlan2.Plan__c=pl2.id;
        opPlanList.add(opPlan2);
        insert  opPlanList;
        
        SGR_Opportunity_Group_Section__c grp=new SGR_Opportunity_Group_Section__c();
        grp.Name='GS-976908';
        grp.Opportunity__c=opList[0].id;
        insert grp;
        
        list<SGR_Opportunity_Census__c> cenLst=new list<SGR_Opportunity_Census__c>();
        SGR_Opportunity_Census__c cen=new SGR_Opportunity_Census__c();
        cen.Name='860535';
        cen.Opportunity__c=opList[0].id;
        cen.Subscriber_Number__c=860535;
        cen.Gender__c='M';
        cen.Relationship__c='Subscriber';
        //cen.Relationship_Code__c='PR';
        cen.Date_of_Birth__c=Date.newInstance(1992, 12, 9);
        cen.Age_New__c=26;
        cen.Zip_Code__c='12';
        cenLst.add(cen);
        
        SGR_Opportunity_Census__c cen2=new SGR_Opportunity_Census__c();
        cen2.Name='860535';
        cen2.Opportunity__c=opList[1].id;
        cen2.Gender__c='M';
        cen2.Relationship__c='Subscriber';
        cen2.Date_of_Birth__c=Date.newInstance(1992, 12, 9);
        cen2.Age_New__c=26;
        cen2.Zip_Code__c='12';       
        cenLst.add(cen2);
        insert cenLst;
        
        
        List<SGR_Opportunity_Member_Benefits__c> soc = new List<SGR_Opportunity_Member_Benefits__c>();
        SGR_Opportunity_Member_Benefits__c mbs = new SGR_Opportunity_Member_Benefits__c();
        mbs.Name='demo34Cloned';
        mbs.Opportunity_Group_Section__c=grp.id;
        mbs.Opportunity_Census__c=cenLst[0].id;
        mbs.Opportunity_Plan_Rate__c=opPlanList[0].id;
        
        soc.add(mbs);
        
        SGR_Opportunity_Member_Benefits__c mbs2 = new SGR_Opportunity_Member_Benefits__c();
        mbs2.Name='demo34Cloneddfg';
        mbs2.Opportunity_Group_Section__c=grp.id;
        mbs2.Opportunity_Census__c=cenLst[1].id;
        mbs2.Opportunity_Plan_Rate__c=opPlanList[1].id;
        
        soc.add(mbs2);
        insert soc;
        List<SGR_Opportunity_Member_Benefits__c> membenList = [Select Name,Opportunity_Group_Section__c,Opportunity_Census__c,Opportunity_Plan_Rate__c,Plan_ID__c,Opportunity_Plan_Rate__r.Plan__r.Name FROM SGR_Opportunity_Member_Benefits__c];
        system.debug('member benefits'+membenList);
        
        SGR_Plan_FIPS_Map__c fips = new SGR_Plan_FIPS_Map__c();
        fips.Effective_Date__c = Date.newInstance(2022, 12, 9);
        fips.FIPS_Code__c = '17111';
        fips.SGR_Plan_Id__c = 'SPSG10BCOSILO';
        insert fips;
        //APICallOutRestWSUtility objUtility = new APICallOutRestWSUtility('URE_Rate_Callout');
        //UserDAO.IUserDAO userDAOInstance=new UserDAO();
       // User iUser = userDAOInstance.getUserByName(objUtility.integrationUserName); 
       // APIJwtOAuthUtility oAuthUtil = new APIJwtOAuthUtility(objUtility.integrationUserName);
       SGR_URE_OpportunityRatingHelper obj=new SGR_URE_OpportunityRatingHelper();
        SGR_URE_GetRatingsResponse response= obj.callUREService(cenLst,membenList,rateEffectiveDate,'','13127874',1,'RenewalsSalesForce','IL1','SG',false,'17111',planId,task,type);
            obj.populateOppPlanRate(opId);
            obj.populateOppCensus(opId);
            Map<Id, List<SGR_Opportunity_Census__c>> oppCensusMap = new Map<Id, List<SGR_Opportunity_Census__c>>();
            oppCensusMap.put(op.id, cenLst);
            obj.populateOppMemberBenefits(opId,oppCensusMap);
            Map<Id,String> fipsCodeMap = new Map<Id, String>();
            fipsCodeMap.put(op.id,'17111');
            Map<Id,Date> effDateMap  = new map<Id,Date>();
            effDateMap.put(op.id,Date.newInstance(2022, 12, 9));
            obj.populatePlanIds(fipsCodeMap,effDateMap);
            list<Id> succOpId=new list<Id>();
            succOpId.add(op.Id);
            list<Id> failOpId=new list<Id>();
            failOpId.add(op2.Id);
            obj.updateOpportunities(succOpId,failOpId);
            SGR_Relationship_Mapping__c rel = new SGR_Relationship_Mapping__c();
            rel.Name='sfRelCode';
            rel.Relationship__c='sub';
            rel.URE_Code__c='1001';
            insert rel;
            obj.getMappedRelationCode('sfRelCode');
            obj.GetURERatingCalloutInfo();
   
    }
   
}