//Created by Vijaya Channamsetti 10/30
//********************************************************************//
// Please group methods by the Objects they interact with to keep     //
// things orderly and easy to find.                                   //
// *******************************************************************//
@isTest
public class Sgr_TestDataUtility {
    
    // A C C O U N T  M E T H O D S //
    
    public static Account createAcc(String accName){
        Account acc = new Account(name = accName);
        insert acc;
        return acc;
    } 
    
    public static Account createAcc(string inputName,decimal inputCountyCode,string inputExternalID, string inputHCSCDivision,date inputRenewalDate,string inputStatus,string inputMarketSegment, string inputFundingType){
        
        Account returnAccount = new Account();
        returnAccount.Name = inputName;
        returnAccount.County_Code__c = string.valueof(inputCountyCode);        
        returnAccount.External_ID__c = inputExternalID; 
        returnAccount.HCSC_Division__c = inputHCSCDivision;
        returnAccount.Renewal_Date__c = inputRenewalDate;
        returnAccount.Status__c =  inputStatus;
        returnAccount.Market_Segment__c = inputMarketSegment;
        returnAccount.Funding_Type__c = inputFundingType;
        returnAccount.hold_end_date__c=Date.today()-1;
        returnAccount.SGR_Hold_Reason__c='1st Year Renewal';
        insert returnAccount;
        
        Return returnAccount;      
        
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
    //P L A N  C R E A T I O N //
    
    public static Plan__c createPlan(String name, String mktPlanId, String lineOfBussiness){
    	Plan__c pl = new Plan__c();
    	pl.name = name;
    	pl.Marketing_Plan_Number__c = mktPlanId;
        pl.Line_Of_Business__c = lineOfBussiness;
    	return pl;
    }
    
    // A C C O U N T  P L A N  R A T E  M E T H O D S //
    
    public Static SGR_Account_Plan_Rate__c accPlanRate(String planId, string mktPlanId, String accId){
    	SGR_Account_Plan_Rate__c planRate = new SGR_Account_Plan_Rate__c();
	    planRate.Plan__c = planId;
	    planRate.Marketing_Plan_ID__c = mktPlanId;
        planRate.Group_Account__c = accId;
	    return planRate;
    }
    
    // A C C O U N T  C E N S U S  M E T H O D S //
    
    public static SGR_Account_Census__c createAccCensus(decimal subNum, string subOrDep, string accId){  
        SGR_Account_Census__c sac = new SGR_Account_Census__c();
        sac.Account__c=accId;
        sac.Relationship__c=subOrDep;
        sac.Gender__c='M';
        sac.Zip_Code__c=string.valueof(12345);
        sac.Member_Cancel_Date__c=system.today().adddays(+2);
        sac.Membership_Number__c='1';
        sac.Member_Effective_Date__c=date.today().addDays(-2);
        sac.Subscriber_Number__c=string.valueof(subNum);
        insert sac;
        return sac;
    }
    
    // Account  G R O U P  S E C T I O N  M E T H O D S //
     public static Group_Section__c GrpSection(String accId){
        Group_Section__c grpSection = new Group_Section__c();
            grpSection.Group_Account__c=accId;
            grpSection.Benefit_Agreement_Cancel_Date__c=system.today();
        insert grpSection;
        return grpSection;
     }
    
    // O P P O R T U N I T Y  M E T H O D S //
    
    public static Opportunity createOpportunity(string accId, string ratingStatus, String stageName){
        Opportunity opp = new opportunity(Name = 'Opty1', 
                                          Accountid = accId, 
                                          Rating_status__c=ratingStatus, 
                                          StageName = stageName,
                                          CloseDate = date.today().adddays(20));  
        return opp;
    }
    
    public static Opportunity createOpty(string accId, string ratingStatus){
        Opportunity opp = new opportunity(Name = 'Opty1', 
                                          Accountid = accId, 
                                          Rating_status__c=ratingStatus, 
                                          StageName = 'Quote',
                                          SGR_Workflow_Activity__c='Underwriting Hold',
                                          recordTypeId=Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity'),
                                          Assigned_UW__c=userInfo.getUserId(),
                                          CloseDate = date.today().adddays(20)); 
        
        insert opp;   
        return opp;
    }
    public static Opportunity createOpty2(string accId, string ratingStatus){
        Opportunity opp = new opportunity(Name = 'Opty1', 
                                          Accountid = accId, 
                                          Rating_status__c=ratingStatus, 
                                          StageName = 'Quote',
                                          HCSC_Division__c='TX',
                                          SGR_Workflow_Activity__c='Underwriting Hold',
                                          recordTypeId=Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity'),
                                           Assigned_UW__c=userInfo.getUserId(),
                                          CloseDate = date.today().adddays(20)); 
        
        insert opp;   
        return opp;
    }
    
    public static Opportunity createOptyRec(string accId, string ratingStatus){
        Opportunity opp = new opportunity(Name = 'Opty1', 
                                          Accountid = accId, 
                                          Rating_status__c=ratingStatus, 
                                          StageName = 'Quote',
                                          SGR_Workflow_Activity__c='Underwriting Hold',
                                          County_Code__c = '12',
                                          Zip_Code__c = '12345',
                                          recordTypeId=Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity'),
                                          Assigned_UW__c=userInfo.getUserId(),
                                          Renewal_Date__c = system.today().adddays(30),
                                          CloseDate = date.today().adddays(20)); 
        
        //insert opp;   
        return opp;
    }
    
    public static Opportunity createOpty(string inputName, Id inputAccountID,string inputRatingStatus,string inputStageName,string inputFundingType,date inputRenewalEffDate,date inputCloseDate ){
        Opportunity returnOpportunity = new Opportunity();       
        
        returnOpportunity.Name = inputName;
        returnOpportunity.Rating_Status__c = inputRatingStatus;
        returnOpportunity.StageName = inputStageName;        
        returnOpportunity.AccountId =   inputAccountID;
        returnOpportunity.Funding_Type__c = inputFundingType;
        returnOpportunity.Renewal_Date__c = inputRenewalEffDate;
        returnOpportunity.CloseDate = inputCloseDate;
        returnOpportunity.HCSC_Division__c = 'TX';
        returnOpportunity.Assigned_UW__c=userInfo.getUserId();
        returnOpportunity.recordTypeId=Sgr_TestDataUtility.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        insert returnOpportunity;   
        
        return returnOpportunity;
    }
    
    //O P P O R T U N I T Y   P L A N  R A T E   M E T H O D S//
    
    public static SGR_Opportunity_Plan_Rate__c optyPlanRate(string name, string optyId, string status, string planId){
        
        SGR_Opportunity_Plan_Rate__c planRate = new SGR_Opportunity_Plan_Rate__c();
        planRate.name = name;
        planRate.Plan__c = planId;
        planRate.Opportunity__c = optyId;
        planRate.Plan_Status__c = status;
        return planRate;
    }
    
    // O P P O R T U N I T Y  C E N S U S  M E T H O D S //
    
    public static Sgr_Opportunity_Census__c OptyCensus(decimal subNum, string subOrDep, string optyId, string accId){       
        List<Sgr_Opportunity_Census__c> sgrOptyCensus = new List<Sgr_Opportunity_Census__c>();
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( //Name ='OppCen', 
                                                                         Opportunity__c = optyId,//optys[0].Id, 
                                                                         Account__c = accId,//accs[0].Id, 
                                                                         Relationship__c = subOrDep,
                                                                         Gender__c = 'M',                         
                                                                         Health_Tier__c='EF', 
                                                                         Dental_Tier__c='EF', 
                                                                         Vision_Tier__c='EF',
                                                                         Health_Plan_ID__c='1212',
                                                                         Dental_Plan_ID__c='1234',
                                                                         Vision_Plan_ID__c='2343', 
                                                                         Member_Effective_Date__c=date.today().adddays(-2), 
                                                                         Member_Cancel_Date__c=date.today().adddays(20), 
                                                                         Zip_Code__c='1234',
                                                                         Subscriber_Number__c=subNum);
        return oppCen;  
    }   
    
    public static Sgr_Opportunity_Census__c createOptyCensus(decimal subNum, string subOrDep, string optyId, string accId){       
        List<Sgr_Opportunity_Census__c> sgrOptyCensus = new List<Sgr_Opportunity_Census__c>();
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( //Name ='OppCen', 
                                                                         Opportunity__c = optyId,//optys[0].Id, 
                                                                         Account__c = accId,//accs[0].Id, 
                                                                         Relationship__c = subOrDep,
                                                                         Gender__c = 'M',                         
                                                                         Health_Tier__c='EF', 
                                                                         Dental_Tier__c='EF', 
                                                                         Vision_Tier__c='EF',
                                                                         Health_Plan_ID__c='1212',
                                                                         Dental_Plan_ID__c='1234',
                                                                         Vision_Plan_ID__c='2343', 
                                                                         Member_Effective_Date__c=date.today().adddays(-2), 
                                                                         Member_Cancel_Date__c=date.today().adddays(20), 
                                                                         Zip_Code__c='1234',
                                                                         Subscriber_Number__c=subNum);
        insert  oppCen;
        return oppCen;  
    }   
    
    public static Sgr_Opportunity_Census__c createOptyCensus2(decimal subNum, string subOrDep, string optyId, string accId,String RelationshipCode){       
        List<Sgr_Opportunity_Census__c> sgrOptyCensus = new List<Sgr_Opportunity_Census__c>();
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( //Name ='OppCen', 
                                                                         Opportunity__c = optyId,//optys[0].Id, 
                                                                         Account__c = accId,//accs[0].Id, 
                                                                         Relationship__c = subOrDep,
                                                                         Gender__c = 'M',                         
                                                                         Health_Tier__c='ES', 
                                                                         Dental_Tier__c='EF', 
                                                                         Vision_Tier__c='ES',
                                                                         Health_Plan_ID__c='1212',
                                                                         Dental_Plan_ID__c='234',
                                                                         Membership_Number__c=1,
                                                                         Vision_Plan_ID__c='2343',
                                                                         Relationship_Code__c=RelationshipCode,
                                                                         Member_Effective_Date__c=date.today().adddays(-1), 
                                                                         Member_Cancel_Date__c=date.today()+20, 
                                                                         Zip_Code__c='1234',
                                                                         Subscriber_Number__c=subNum);
        insert  oppCen;
        return oppCen;  
    }
    
    public static Sgr_Opportunity_Census__c createOptyCensus3(decimal subNum, string subOrDep, string optyId, string accId,String RelationshipCode,string DentalTier,String VisionTier,String HealthTier,Integer MembershipNumber){       
        List<Sgr_Opportunity_Census__c> sgrOptyCensus = new List<Sgr_Opportunity_Census__c>();
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( //Name ='OppCen', 
                                                                         Opportunity__c = optyId,//optys[0].Id, 
                                                                         Account__c = accId,//accs[0].Id, 
                                                                         Relationship__c = subOrDep,
                                                                         Gender__c = 'M',                         
                                                                         Health_Tier__c=HealthTier, 
                                                                         Dental_Tier__c=DentalTier, 
                                                                         Vision_Tier__c=VisionTier,
                                                                         Health_Plan_ID__c='1212',
                                                                         Dental_Plan_ID__c='234',
                                                                         Membership_Number__c=MembershipNumber,
                                                                         Vision_Plan_ID__c='2343',
                                                                         Relationship_Code__c=RelationshipCode,
                                                                         Member_Effective_Date__c=date.today().adddays(-1), 
                                                                         Member_Cancel_Date__c=date.today()+20, 
                                                                         Zip_Code__c='1234',
                                                                         Subscriber_Number__c=subNum);
        insert  oppCen;
        return oppCen;  
    }
    
    // B E N E F I T  A G R E E M E N T  M E T H O D S //
    
    public static Benefit_Agreement__c createBenefitAgreement(string accId){
        Benefit_Agreement__c bac=new Benefit_Agreement__c(Group_Account__c = accId, 
                                                          Status__c = 'Active');
        insert bac; 
        return bac;
    }
    
    
    // B U S I N E S S  R U L E  M E T H O D S //
    
    public static SGR_Business_Rule__c createBusinessRule(){
        SGR_Business_Rule__c busRule = new SGR_Business_Rule__c(Name='test', Rule_Code__c ='GR.DV.10', proposed_wording_pass__c ='Pass', proposed_wording_fail__c ='Fail');
        insert busRule;
        return busRule;
    }
    
    public static SGR_Business_Rule__c createBusinessRule(string inputName,string inputRuleCode,string inputLevel,string inputWordingPass,string inputRuleType,string inputWordingFail){
        SGR_Business_Rule__c returnValue = new SGR_Business_Rule__c();
        
        returnValue.Active__c = true;
        returnValue.Name = inputName;
        returnValue.Level__c = inputLevel;
        returnValue.Rule_Type__c = inputRuleType;                                                    
        returnValue.Proposed_wording_fail__c = inputWordingPass;
        returnValue.Proposed_wording_pass__c = inputWordingFail;
        returnValue.Rule_Code__c = inputRuleCode;
        
        insert returnValue;
        
        Return returnValue;
    }
    
    // R E N E W A L B A T C H  M E T H O D S //
    
    public static SGRRenewalBatch__c createRenewalBatch(){
       // Date DT=Date.today();
       // Date DAT=Date.today()+70;Renewal_Effective_date__c=DT,Date_to_Account__c=DAT
        SGRRenewalBatch__c renBatch= new SGRRenewalBatch__c(name = 'BatchId', batchid__c = '567');
        insert renBatch;
        return renBatch;
    }
    public static SGRRenewalBatch__c createRenewalBatch1(String renName, String batchid, String renType, String division, String mktSmt, String fundType, Decimal noofAccs){
        SGRRenewalBatch__c renBatch= new SGRRenewalBatch__c(name = renName, 
                                                            BatchId__c = batchid, 
                                                            RenewalType__c = renType,
                                                            Division__c = division, 
                                                            MarketSegment__c = mktSmt, 
                                                            FundingType__c = fundType, 
                                                            Number_of_Accounts__c = noofAccs);         
        return renBatch;
    }
    
    // R E N E W A L  B A T C H   O P P O R T U N I T Y  M E T H O D S //
     
    public static SGR_Renewal_Batch_Oppty__c createOptyRenBatch(String optyId){
        SGR_Renewal_Batch_Oppty__c renBatch = new SGR_Renewal_Batch_Oppty__c();
        renBatch.Opportunity__c = optyId;
        return renBatch;
    }  
    
    public static SGR_Renewal_Batch_Oppty__c createRenewalBatchOpportunity(Id inputAccountID, Id inputOpportunityID,Id inputRenewalBatch){
        SGR_Renewal_Batch_Oppty__c returnValue = new SGR_Renewal_Batch_Oppty__c();
        
        returnValue.Account_Number__c = inputAccountID;
        returnValue.Opportunity__c = inputOpportunityID;
        returnValue.BatchId__c = inputRenewalBatch;
        
        insert returnValue;
        
        Return returnValue;
    }
    
    // O P P O R T U N I T Y   B E N E F I T   A G R E E M E N T  M E T H O D S //
    
    public static SGR_Opportunity_Benefit_Agreement__c createOptyBenAgr(String optyId){
    
        SGR_Opportunity_Benefit_Agreement__c optyBA = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA.Status__c='Active';
        optyBA.Renewal_Date__c=system.today();
        optyBA.Opportunity__c = optyId;
        return optyBA;
    }
    public static SGR_Opportunity_Benefit_Agreement__c createOptyBenAgr2(String optyId,String Insurence){
    
        SGR_Opportunity_Benefit_Agreement__c optyBA = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA.Status__c='Active';
        optyBA.Renewal_Date__c=system.today();
        optyBA.Opportunity__c = optyId;
        optyBA.Insurance_Type_Code__c=Insurence;
        return optyBA;
    }
    public static List<SGR_Opportunity_Benefit_Agreement__c> createOptyBenAgrINACTIVE(String optyId){
    List<SGR_Opportunity_Benefit_Agreement__c> sgrLST = new List<SGR_Opportunity_Benefit_Agreement__c>();
        SGR_Opportunity_Benefit_Agreement__c optyBA = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA.Status__c='active';
        optyBA.Renewal_Date__c=system.today();
        optyBA.Opportunity__c = optyId;
        sgrLST.add(optyBA);
        SGR_Opportunity_Benefit_Agreement__c optyBA1 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA1.Status__c='Inactive';
        optyBA1.Renewal_Date__c=system.today();
        optyBA1.Opportunity__c = optyId;
        sgrLST.add(optyBA1);
        SGR_Opportunity_Benefit_Agreement__c optyBA2 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA2.Status__c='Inactive';
        optyBA2.Renewal_Date__c=system.today();
        optyBA2.Opportunity__c = optyId;
        sgrLST.add(optyBA2);
        SGR_Opportunity_Benefit_Agreement__c optyBA3 = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA3.Status__c='Inactive';
        optyBA3.Renewal_Date__c=system.today();
        optyBA3.Opportunity__c = optyId;
        sgrLST.add(optyBA3);
        insert sgrLST;
        return sgrLST;
    }
    
    // O P P O R T U N I T Y  G R O U P  S E C T I O N  M E T H O D S //
    
    public static SGR_Opportunity_Group_Section__c OptyGrpSection(String optyId){
        SGR_Opportunity_Group_Section__c optyGrpSec = new SGR_Opportunity_Group_Section__c();
        optyGrpSec.Opportunity__c = optyId;
        return optyGrpSec;
    } 
    
    public static SGR_Opportunity_Group_Section__c OptyGrpSection2(String optyId,Boolean Invitro){
        SGR_Opportunity_Group_Section__c optyGrpSec = new SGR_Opportunity_Group_Section__c();
        optyGrpSec.Opportunity__c = optyId;
        optyGrpSec.Invitro__c=Invitro;
        return optyGrpSec;
    }
    
    // O P P O R T U N I T Y  M E M B E R  B E N E F I T S  M E T H O D S //
        
    public static SGR_Opportunity_Member_Benefits__c OptyMemBen(String optyCenId){
        SGR_Opportunity_Member_Benefits__c OptyMemBen = new SGR_Opportunity_Member_Benefits__c();
        OptyMemBen.Opportunity_Census__c = optyCenId;
        return OptyMemBen;
    } 
    
     public static SGR_Opportunity_Member_Benefits__c SGROptyMemberBenefits(String MebPolicyTier, string subNumber, string OptyCensusId, string OptyGroupSection){
        SGR_Opportunity_Member_Benefits__c OppMemberBenefits=new SGR_Opportunity_Member_Benefits__c();
            OppMemberBenefits.Member_Policy_Tier__c=MebPolicyTier;
            OppMemberBenefits.Subscriber_Number__c=subNumber;
            OppMemberBenefits.Opportunity_Census__c=OptyCensusId;
            OppMemberBenefits.Opportunity_Group_Section__c=OptyGroupSection;
            insert OppMemberBenefits;
            
            return OppMemberBenefits;
    }
    public static List<Business_Rule_Validation_Log__c> createBRVPassLogs(Id oppId, String status){
        List<Business_Rule_Validation_Log__c> brvList = new List<Business_Rule_Validation_Log__c>();
        Business_Rule_Validation_Log__c brv1 = new Business_Rule_Validation_Log__c(OpportunityId__c=oppId,Status__c=status);
        brvList.add(brv1);
        Business_Rule_Validation_Log__c brv2 = new Business_Rule_Validation_Log__c(OpportunityId__c=oppId,Status__c=status);
        brvList.add(brv2);
        insert brvList;
        return brvList;
    }
    
    public static List<Business_Rule_Validation_Log__c> createBRVPassFailLogs(Id oppId){
        List<Business_Rule_Validation_Log__c> brvList = new List<Business_Rule_Validation_Log__c>();
        Business_Rule_Validation_Log__c brv1 = new Business_Rule_Validation_Log__c(OpportunityId__c=oppId,Status__c='Passed');
        brvList.add(brv1);
        Business_Rule_Validation_Log__c brv2 = new Business_Rule_Validation_Log__c(OpportunityId__c=oppId,Status__c='Failed');
        brvList.add(brv2);
        insert brvList;
        return brvList;
    }
    
    public static SGR_Plan_FIPS_Map__c createFipsMap(String name, string fipscode, string division){
        SGR_Plan_FIPS_Map__c fipCode = new SGR_Plan_FIPS_Map__c();
        fipCode.name = name;
        fipCode.FIPS_Code__c = fipscode;
        fipCode.Division__c = division;
        return fipCode;
    }
    
}