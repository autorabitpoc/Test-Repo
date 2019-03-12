public class SGR_TestDataUtility1 {
   
    // A C C O U N T  M E T H O D S //
    
    public static Account createAcc(String accName){
        Account acc = new Account(name = accName);        
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
        
        Return returnAccount;      
        
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
        return sac;
    }
    
    // O P P O R T U N I T Y  M E T H O D S //
    
    public static Opportunity createOpty(string accId, string ratingStatus){
        Opportunity opp = new opportunity(Name = 'Opty1', 
                                          Accountid = accId, 
                                          Rating_status__c=ratingStatus, 
                                          StageName = 'Quote', 
                                          CloseDate = date.today().adddays(20)); 
        
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
        
        return returnOpportunity;
    }
    
    
    // O P P O R T U N I T Y  C E N S U S  M E T H O D S //
    
    public static Sgr_Opportunity_Census__c createOptyCensus(decimal subNum, string subOrDep, string optyId, string accId){       
        List<Sgr_Opportunity_Census__c> sgrOptyCensus = new List<Sgr_Opportunity_Census__c>();
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( Name ='OppCen', 
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
    
    public static Sgr_Opportunity_Census__c createOptyCensus2(decimal subNum, string subOrDep, string optyId, string accId,String RelationshipCode){       
        List<Sgr_Opportunity_Census__c> sgrOptyCensus = new List<Sgr_Opportunity_Census__c>();
        Sgr_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c( Name ='OppCen', 
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
                                                                         Relationship_Code__c=RelationshipCode,
                                                                         Member_Effective_Date__c=date.today().adddays(-1), 
                                                                         Member_Cancel_Date__c=date.today().adddays(20), 
                                                                         Zip_Code__c='1234',
                                                                         Subscriber_Number__c=subNum);
        return oppCen;  
    }
    
    // B E N E F I T  A G R E E M E N T  M E T H O D S //
    
    public static Benefit_Agreement__c createBenefitAgreement(string accId){
        Benefit_Agreement__c bac=new Benefit_Agreement__c(Group_Account__c = accId, 
                                                          Status__c = 'Active');
        return bac;
    }
    
    
    // B U S I N E S S  R U L E  M E T H O D S //
    
    public static SGR_Business_Rule__c createBusinessRule(){
        SGR_Business_Rule__c busRule = new SGR_Business_Rule__c(Name='test', Rule_Code__c ='GR.DV.10', proposed_wording_pass__c ='Pass', proposed_wording_fail__c ='Fail');
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
       
        Return returnValue;
    }
    
    // R E N E W A L B A T C H  M E T H O D S //
    
    public static SGRRenewalBatch__c createRenewalBatch(){
        SGRRenewalBatch__c renBatch= new SGRRenewalBatch__c(name = 'BatchId', batchid__c = '567');
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
        
        Return returnValue;
    }
    
    // O P P O R T U N I T Y   B E N E F I T   A G R E E M E N T  M E T H O D S //
    
    public static SGR_Opportunity_Benefit_Agreement__c createOptyBenAgr(String optyId){
        SGR_Opportunity_Benefit_Agreement__c optyBA = new SGR_Opportunity_Benefit_Agreement__c();
        optyBA.Opportunity__c = optyId;
        return optyBA;
    }
    
    // O P P O R T U N I T Y  G R O U P  S E C T I O N  M E T H O D S //
    
    public static SGR_Opportunity_Group_Section__c OptyGrpSection(String optyId){
        SGR_Opportunity_Group_Section__c optyGrpSec = new SGR_Opportunity_Group_Section__c();
        optyGrpSec.Opportunity__c = optyId;
        return optyGrpSec;
    } 
    
    // O P P O R T U N I T Y  M E M B E R  B E N E F I T S  M E T H O D S //
        
    public static SGR_Opportunity_Member_Benefits__c OptyMemBen(String optyCenId){
        SGR_Opportunity_Member_Benefits__c OptyMemBen = new SGR_Opportunity_Member_Benefits__c();
        OptyMemBen.Opportunity_Census__c = optyCenId;
        return OptyMemBen;
    }
}