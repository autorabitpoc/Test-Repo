//Guidelines
//TODO: All - NO QUERIES INSIDE RULES
//TODO: Wrapper class to use as input to all rules
public class SGR_validationHelperdemo {
    
    public SGR_validationHelperdemo(List<Opportunity> opps, String BatchId )
    { 
        callingMethods(opps,BatchId);
        //US12536 & US11982 - This method is used to update Opportunity records with Rating Status and Workflow Activity based on failed Business rule valdations for respective Opportunites.
        updateOppRatingStatusAndWA(opps);
        
    }
    //Code added to Test BR Frame work
    /* public SGR_validationHelperdemo(List<Opportunity> opps, String BatchId, Integer index)
{ 
callingMethods1(opps,BatchId);

}
public static String callingMethods1(List<Opportunity> opps, String BatchId) {
String msg;
system.debug('******** inside Method*****');
map<String,SGR_Business_Rule__c> sbrmap = new  map<String,SGR_Business_Rule__c>();
List<SGR_Business_Rule__c> br=[select id,Rule_Code__c,Proposed_wording_fail__c,Proposed_wording_pass__c from SGR_Business_Rule__c ];
for (SGR_Business_Rule__c sa:br){
sbrmap.put(sa.Rule_Code__c,sa);
}

map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
map<id,List<SGR_Opportunity_Group_Section__c>>oppsgrogs1 = new map<id,List<SGR_Opportunity_Group_Section__c>>();  
map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();  
map<id,List<SGR_Opportunity_Census__c>> oppsgrogs = new map<id,List<SGR_Opportunity_Census__c>>();
map<Id, List<SGR_Opportunity_Member_Benefits__c>> benefits = new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
List<SGR_Opportunity_Census__c> optyCens = new List<SGR_Opportunity_Census__c>();
List<opportunity> lstopp = [SELECT Id, name, Batch_Id__c,Funding_Type__c, (SELECT Id, Name ,Batch_Id__c from SGR_Renewal_Batch_Opptys__r),(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),(SELECT id,Name,Account__c,Opportunity__c,Relationship_Code__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c,Relationship__c, Subscriber_number__c, Date_of_Birth__c, State__c, Health_Plan_Id__c FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) FROM opportunity where (id IN:opps AND Batch_Id__c=:BatchId)];

//Keeping all the child objects related opportunity in a Map
for(Opportunity os :lstopp) {

oppsrbop.put(os.id,os.SGR_Renewal_Batch_Opptys__r);
//SGR_Opportunity_Census__c opCen = os.Opportunity_Census__r;
oppsgrobamap.put(os.id, os.Opportunity_Benefit_Agreements__r);
oppsgrogs.put(os.id,os.Opportunity_Census__r);
oppsgrogs1.put(os.id,os.Opportunity_Group_Section__r);
optyCens = os.Opportunity_Census__r;
}
List<SGR_Opportunity_Census__c> memBenefits = new List<SGR_Opportunity_Census__c>();

if (optyCens.size() > 0) {
memBenefits = [Select Id, (Select Id, Name, Member_Policy_Tier__c, Subscriber_Number__c
From Opportunity_Member_Benefits__r)
from SGR_Opportunity_Census__c where Id IN :optyCens];
for (SGR_Opportunity_Census__c oc : memBenefits) {
benefits.put(oc.Id, oc.Opportunity_Member_Benefits__r);
}
}

system.debug('==========='+oppsgrobamap);
system.debug('==========='+oppsgrogs);
system.debug('============'+oppsgrogs1);

System.debug('Opportunities: ' + opps);

List<SGRRenewalBatch__c> RenewBatchId = new List<SGRRenewalBatch__c>();
RenewBatchId=[select Id,BatchID__c from SGRRenewalBatch__c where BatchID__c =:BatchId];
return msg;
} */  
    
    public static String callingMethods(List<Opportunity> opps, String BatchId) {
        String msg;
        system.debug('******** inside Method*****');
        map<String,SGR_Business_Rule__c> sbrmap = new  map<String,SGR_Business_Rule__c>();
        List<SGR_Business_Rule__c> br=[select id,Rule_Code__c,Proposed_wording_fail__c,Proposed_wording_pass__c from SGR_Business_Rule__c ];
        for (SGR_Business_Rule__c sa:br){
            sbrmap.put(sa.Rule_Code__c,sa);
        }
        
        map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        map<id,List<SGR_Opportunity_Group_Section__c>>oppsgrogs1 = new map<id,List<SGR_Opportunity_Group_Section__c>>();  
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();  
        map<id,List<SGR_Opportunity_Census__c>> oppsgrogs = new map<id,List<SGR_Opportunity_Census__c>>();
        map<Id, List<SGR_Opportunity_Member_Benefits__c>> benefits = new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
        List<SGR_Opportunity_Census__c> optyCens = new List<SGR_Opportunity_Census__c>();
        List<opportunity> lstopp = [SELECT Id, name, Batch_Id__c,Funding_Type__c, AccountId,HCSC_Division__c, (SELECT Id, Name ,Batch_Id__c from SGR_Renewal_Batch_Opptys__r),(SELECT Id, Name,Insurance_Type_Code__c,Status__c,Renewal_Date__c FROM Opportunity_Benefit_Agreements__r),(SELECT id,Name,Account__c,Opportunity__c,Employee_Status_Code__c,Relationship_Code__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c,Relationship__c, Subscriber_number__c, Date_of_Birth__c,Total_Number_of_Health_Subscribers__c,Total_Number_of_Dental_Subscribers__c,Vision_Tier__c,Health_Tier__c,Dental_Tier__c, State__c,Dental_Plan_ID__c, Health_Plan_ID__c FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c,Invitro__c FROM Opportunity_Group_Section__r) FROM opportunity where (id IN:opps AND Batch_Id__c=:BatchId)];
        
        //Create a List of Account Id include on the incoming Opportunity List
        List<Id> listAccountIds = new List<Id>();
        For(Opportunity anOpportunity : lstopp){
            listAccountIds.add(anOpportunity.AccountId);
        }
        //Get any Opportunities for the Accounts that are NOT in the List of Opportunities being processed
        List<opportunity> listExistingOpps = [SELECT Id, Name, AccountId, Renewal_Date__c, Rating_Status__c FROM Opportunity WHERE (Id NOT IN :opps AND AccountId in :listAccountIds)];
        
        //Keeping all the child objects related opportunity in a Map
        for(Opportunity os :lstopp) {
            
            oppsrbop.put(os.id,os.SGR_Renewal_Batch_Opptys__r);
            //SGR_Opportunity_Census__c opCen = os.Opportunity_Census__r;
            oppsgrobamap.put(os.id, os.Opportunity_Benefit_Agreements__r);
            oppsgrogs.put(os.id,os.Opportunity_Census__r);
            oppsgrogs1.put(os.id,os.Opportunity_Group_Section__r);
            optyCens = os.Opportunity_Census__r;
        }
        List<SGR_Opportunity_Census__c> memBenefits = new List<SGR_Opportunity_Census__c>();
        
        if (optyCens.size() > 0) {
            memBenefits = [Select Id, (Select Id, Name, Member_Policy_Tier__c, Subscriber_Number__c
                                       From Opportunity_Member_Benefits__r)
                           from SGR_Opportunity_Census__c where Id IN :optyCens];
            for (SGR_Opportunity_Census__c oc : memBenefits) {
                benefits.put(oc.Id, oc.Opportunity_Member_Benefits__r);
            }
        }
        
        system.debug('==========='+oppsgrobamap);
        system.debug('==========='+oppsgrogs);
        system.debug('============'+oppsgrogs1);
        system.debug('============>>'+optyCens);
        
        System.debug('Opportunities: ' + opps);
        
        List<SGRRenewalBatch__c> RenewBatchId = new List<SGRRenewalBatch__c>();
        RenewBatchId=[select Id,BatchID__c from SGRRenewalBatch__c where BatchID__c =:BatchId];
        
        String ActiveBAC ='GR.DV.01';
        String ActiveSubscriberRule ='GR.DV.02';
        String activehealthsubscriber1='GR.DV.03';
        String activedentalsubscriberlist = 'GR.DV.04';
        String Ziprule = 'GR.DV.06';
        String countyrule ='GR.DV.07';
        String memberOver99 = 'GR.DV.08';
        String employeeOnlyDependentsRule ='GR.DV.09';
        String morePartners = 'GR.DV.10';
        String Dependentsexistwithnorelationshipcode='GR.DV.11';
        string ESTireSpouseDomesticPartner='GR.DV.12';
        string ECTireChild='GR.DV.13';
        String EFTireFamily='GR.DV.14';
        String fundingTypeRule = 'GR.DV.15';
        String inProcessOpps='GR.DV.16';
        String DateCheck ='GR.DV.18';//SFDC-14535
        String Invitro1='GR.DV.19';
        String stateCodeRule = 'GR.EL.01';
        String SGLessThan50 = 'GR.EL.02';
        String texasHealthSubs = 'GR.EL.03';
        String HealthvsContributory = 'GR.EL.04';
        String nonCobraSubscriber = 'GR.DV.05';
        // String countActiveSubscriberRule = 'GR.EL.02';
        String Retiredexist ='GR.DV.17';//SFDC-14510
        
        // Start of method calls:
        CheckCountyCode(opps,countyrule,BatchId,RenewBatchId,sbrmap,oppsrbop);
        CheckZipCode(opps,Ziprule,BatchId,RenewBatchId,sbrmap,oppsrbop);
        checkForDependentsForEmployeeOnlyTier(opps, employeeOnlyDependentsRule, BatchId,oppsgrogs,RenewBatchId,sbrmap,benefits,oppsrbop);
        activeSubscribercheck(opps,ActiveSubscriberRule,BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);
        activeBenefitAgreementcheck(opps,BatchId,ActiveBAC,oppsgrobamap,RenewBatchId,sbrmap,oppsrbop);
        checkForSpouseOrDP(opps, oppsgrogs, batchId, morePartners, renewBatchId, sbrMap, oppsrbop);
        checkSub50Enrollees(opps,SGLessThan50,BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);
        //checkHealthvsContributoryDental(opps,HealthvsContributory,BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);
        checkOtherOpenOpportunities(opps,listExistingOpps,inProcessOpps,BatchId,RenewBatchId,sbrmap);
        activeBenefitAgreementDatecheck(opps,BatchId,DateCheck,oppsgrobamap,RenewBatchId,sbrmap,oppsrbop);//SFDC-14535
        activeRetiredsubscriberexist(opps,BatchId,Retiredexist,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);//SFDC-14510
        checkMembershipAge(opps,memberOver99,BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);
        checkForPremiumFundingType(opps,fundingTypeRule,sbrmap,BatchId,RenewBatchId,oppsrbop);
        DependentswithNoRelationshipCodeValidation(optyCens,Dependentsexistwithnorelationshipcode,sbrmap,BatchId,RenewBatchId,oppsrbop);
        ESTiresValidation(optyCens,ESTireSpouseDomesticPartner,sbrmap,BatchId,RenewBatchId,oppsrbop);
        ECTireWithoutChildValidation(optyCens,ECTireChild,sbrmap,BatchId,RenewBatchId,oppsrbop);
        EFTireWithoutFamilyValidation(optyCens,EFTireFamily,sbrmap,BatchId,RenewBatchId,oppsrbop);
        checkStateCode(opps,stateCodeRule,sbrmap,BatchId,RenewBatchId,oppsrbop);
        getNumberOfHealthSubscribers(opps,texasHealthSubs,BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);
        checkInvitroplans(opps,Invitro1,BatchId,sbrmap,RenewBatchId,oppsrbop,oppsgrogs1,oppsgrobamap);
        // countActiveSubscribers(opps,countActiveSubscriberRule,BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop);
        checkForactivedentalsubscriber(opps, activedentalsubscriberlist, BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop,oppsgrobamap);
        checkForactiveHealthsubscriber(opps, activehealthsubscriber1, BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop,oppsgrobamap);
        checkforNonCobraSubsribers(opps, nonCobraSubscriber, BatchId,oppsgrogs,RenewBatchId,sbrmap,benefits,oppsrbop);
        
        
        
        return msg;
    }
    
    
    //check for zip code size
    //US14164
    //developer:santosh
    public static Boolean CheckZipCode(List<Opportunity> accs,String Ziprule,String BatchId,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) 
    {
        
        Matcher zipcodeMatcher;
        String msg;
        system.debug('coming into zip');
        try{
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            
            system.debug('in check county code '+accs);
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            
            
            
            for(Opportunity os:accs)
            {
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                String zipCode=String.valueOf(os.Zip_Code__c);
                Pattern zipcodePattern = Pattern.compile('^[0-9]{5,9}(-[0-9]{4})?$');
                zipcodeMatcher = zipcodePattern.matcher(zipCode);
                system.debug('matcher---'+zipcodeMatcher.matches());
                if(zipcodeMatcher.matches()==true && (os.Zip_Code__c.length()==5 || os.Zip_Code__c.length()==9))
                {
                    
                    system.debug('Zip code '+os.Zip_Code__c);
                    brv.AccountId__c=os.AccountId;
                    brv.Status__c='Passed';
                    system.debug('----------------->'+brv.Status__c);
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    system.debug('sbrmap::::::::::'+sbrmap);
                    brv.Fail_Pass_Reason__c=sbrmap.get(Ziprule).Proposed_wording_pass__c;
                    brv.BusinessRuleId__c=sbrmap.get(Ziprule).id;
                    
                    if(RenewBatchId.size()>0){
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    brv.OpportunityId__c=os.Id;
                    system.debug('----------------->'+os.Id);
                    
                    bsrlst.add(brv);
                    system.debug('PassedLstZip'+bsrlst);
                }
                
                else{
                    brv.AccountId__c=os.AccountId;
                    brv.Status__c=' Failed';
                    system.debug('sbrmap::::::::::'+sbrmap);
                    String propwordfail=sbrmap.get(Ziprule).Proposed_wording_fail__c+'Zipcode value:'+os.Zip_Code__c;
                    
                    brv.Fail_Pass_Reason__c=propwordfail;
                    brv.BusinessRuleId__c=sbrmap.get(Ziprule).id;
                    
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    
                    
                    if(RenewBatchId.size()>0){
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    brv.OpportunityId__c=os.Id;
                    
                    bsrlst.add(brv); 
                    system.debug('FailedlistZip'+bsrlst);
                }
                
            }
            
            system.debug('-------------------->'+bsrlst);
            database.insert(bsrlst);
            msg='Insertion done.';
            
            
            
        }
        
        catch(Exception e)
        {
            system.debug('came into catch'+e) ;
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.CheckZipCode', 'High');                                                           
        }
        
        
        // return zipcodeMatcher.matches();
        return true;
    }
    //SFDC-14541:SGR:CountActiveSubscriber
    //Author:Padmini 
    /* public static String countActiveSubscribers(List<Opportunity> opps,String countActiveSubscriberRule,String batchId,map<id,List<SGR_Opportunity_Census__c>> oppsgrogs,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
{
String msg;
boolean activeSubscriber = false;
List<Business_Rule_Validation_Log__c> updtdbsrLst = new List<Business_Rule_Validation_Log__c>();
try{  
List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
Map<Id,Integer> countActiveOpps = new Map<Id,Integer>(); //added
for (Opportunity oss: opps) 
{       
system.debug('Looping through all opportunities');
Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
if(oppsgrogs.get(oss.Id).size() > 0)
{
system.debug('checking for opty id null ');
for(SGR_Opportunity_Census__c oc:oppsgrogs.get(oss.Id))
{
system.debug('inside retrriing cencus from map '+oc);
if(oc.id != NULL)
{            
system.debug('in second for loop '+oc);               
if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c > date.today()) || oc.Member_Cancel_Date__c > oss.Renewal_Date__c) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c < date.today())               
{
countActiveOpps.put(brv.OpportunityId__c,1); //added         
}             
} 
}
}
integer couActSubsSize = countActiveOpps.size();
if(couActSubsSize == 0)
{
brv.AccountId__c=oss.AccountId;
brv.OpportunityId__c=oss.Id;
brv.Status__c='Failed';
if(RenewBatchId.size()>0)
{
brv.Batch_Id__c=RenewBatchId[0].id;
}       
brv.Fail_Pass_Reason__c = 'Fail#2: No active subscribers found';    
brv.BusinessRuleId__c=sbrmap.get(countActiveSubscriberRule).id;
for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
{
brv.Renewal_Batch_Oppty_Id__c=srbo.name;
}
updtdbsrLst.add(brv);
}
else if(couActSubsSize > 50)
{ // do we need to check subscriber condition and renewal condition here                            
brv.AccountId__c=oss.AccountId;
brv.OpportunityId__c=oss.Id;
brv.Status__c='Failed';
if(RenewBatchId.size()>0)
{
brv.Batch_Id__c=RenewBatchId[0].id;
} 
brv.Fail_Pass_Reason__c = 'Fail#1; #Current Subscribers = '+couActSubsSize + 'MS = SG';
brv.BusinessRuleId__c = sbrmap.get(countActiveSubscriberRule).Id;
for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
{
brv.Renewal_Batch_Oppty_Id__c=srbo.name;
}                       
updtdbsrLst.add(brv);
}
else if(couActSubsSize <= 50)
{
brv.AccountId__c=oss.AccountId;
brv.OpportunityId__c=oss.Id;
brv.Status__c = 'Passed';
if(RenewBatchId.size()>0)
{
brv.Batch_Id__c=RenewBatchId[0].id;
}
brv.Fail_Pass_Reason__c = 'Pass#1: #Current Subscribers = '+couActSubsSize + 'MS = SG';
brv.BusinessRuleId__c = sbrmap.get(countActiveSubscriberRule).Id;
for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
{
brv.Renewal_Batch_Oppty_Id__c=srbo.name;
}
updtdbsrLst.add(brv);
}
System.debug('Inserting BR ' + updtdbsrLst);
insert updtdbsrLst;
msg='Insertion done.'; 
countActiveOpps.clear();
}  
}   
catch(Exception e)
{
CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.countActiveSubscribers', 'High');                                                           
//throw new AuraHandledException( e.getMessage());            
}
return msg;  
} 
*/
    //SFDC-14079: SGR: CheckCountyCode
    //Author:Santosh
    public static String CheckCountyCode(List<Opportunity> accs,String countyrule,String BatchId,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        try{
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            
            system.debug('in check county code '+accs);
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            
            for(Opportunity os:accs)
            {
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                
                if(os.County_Code__c=='' ||os.County_Code__c==NULL)
                {
                    
                    brv.AccountId__c=os.AccountId;
                    brv.Status__c='Failed';
                    system.debug('----------------->'+brv.Status__c);
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    brv.Fail_Pass_Reason__c=sbrmap.get(countyrule).Proposed_wording_fail__c;
                    brv.BusinessRuleId__c=sbrmap.get(countyrule).id;
                    
                    if(RenewBatchId.size()>0){
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    brv.OpportunityId__c=os.Id;
                    system.debug('----------------->'+os.Id);
                    
                    bsrlst.add(brv);
                    system.debug('failedList'+bsrlst);
                }
                
                else{
                    brv.AccountId__c=os.AccountId;
                    brv.Status__c=' Passed';
                    
                    brv.Fail_Pass_Reason__c=sbrmap.get(countyrule).Proposed_wording_pass__c;
                    brv.BusinessRuleId__c=sbrmap.get(countyrule).id;
                    
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    
                    
                    if(RenewBatchId.size()>0){
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    brv.OpportunityId__c=os.Id;
                    
                    bsrlst.add(brv); 
                    system.debug('passedlist'+bsrlst);
                }
                
            }
            database.insert(bsrlst);
            msg='Insertion done.';
            
        }
        
        catch(Exception e)
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.CheckCountyCode', 'High');                                                           
            //throw new AuraHandledException( e.getMessage());
            
        }
        return msg; 
    }
    //SFDC-14081: SGR: activeBenefitAgreementcheck
    //Author: Sreedhar
    public static String activeBenefitAgreementcheck(List<Opportunity> accs,String BatchId,String ActiveBAC1,map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        try{
            
            system.debug('in check activeBenefitAgreementcheck code '+accs);
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            List<SGR_Opportunity_Benefit_Agreement__c> sobfaactive = new List<SGR_Opportunity_Benefit_Agreement__c> ();
            
            for(opportunity oss: accs)
            { 
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                if(oss.id != NULL)
                {
                    for(SGR_Opportunity_Benefit_Agreement__c sgrs1:oppsgrobamap1.get(oss.Id))
                    {
                        if(sgrs1.Status__c == 'Active')
                        {
                            sobfaactive.add(sgrs1);
                            
                        } 
                    }
                }
                
                if(sobfaactive.size()>0){
                    brv.AccountId__c=oss.AccountId;
                    brv.Status__c='Passed';
                    if(RenewBatchId.size()>0)
                    {
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    brv.OpportunityId__c=oss.Id;
                    brv.Fail_Pass_Reason__c=sbrmap.get(ActiveBAC1).Proposed_wording_pass__c;
                    brv.BusinessRuleId__c=sbrmap.get(ActiveBAC1).id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    bsrlst.add(brv);
                }
                
                else{
                    brv.AccountId__c=oss.AccountId;
                    brv.Status__c='Failed';
                    if(RenewBatchId.size()>0)
                    {
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    brv.OpportunityId__c=oss.Id;
                    brv.Fail_Pass_Reason__c=sbrmap.get(ActiveBAC1).Proposed_wording_fail__c;
                    brv.BusinessRuleId__c=sbrmap.get(ActiveBAC1).id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    
                    bsrlst.add(brv); 
                }
                
            }
            system.debug('list of ba'+bsrlst);
            
            database.insert(bsrlst);
            msg='Insertion done.';
            sobfaactive.clear();
            
        }
        catch(System.NullPointerException e )
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.activeBenefitAgreementcheck', 'High');                                                           
            system.debug(e);
            
        }
        return msg;    
    }
    //SFDC-14080: SGR: Active Subscribers Check
    //Author: Saurav Gupta
    public static String activeSubscribercheck(List<Opportunity> opps,String ActiveSubscriberRule,String BatchId,map<id,List<SGR_Opportunity_Census__c>> oppsgrogs,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        try{
            
            //List<SGR_Business_Rule__c> br = [select id,Proposed_wording_fail__c,Proposed_wording_pass__c from SGR_Business_Rule__c where Rule_Code__c=:ActiveSubscriberRule];
            
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            
            system.debug('in check subscriber rule code '+ActiveSubscriberRule);
            system.debug('opty list '+opps);
            system.debug('map list '+oppsgrogs);
            for (Opportunity oss: opps) {
                
                //id ide1 = opp.id;
                system.debug('inside for ');
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                if(oppsgrogs.get(oss.Id).size() > 0)
                {
                    system.debug('checking for opty id null ');
                    for(SGR_Opportunity_Census__c oc:oppsgrogs.get(oss.Id))
                    {
                        system.debug('inside retrriing cencus from map '+oc);
                        if(oc.id != NULL){
                            
                            system.debug('in second for loop '+oc);
                            
                            if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c > date.today())) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c <date.today())
                            {
                                brv.AccountId__c=oc.Account__c;
                                
                                if(RenewBatchId.size()>0)
                                {
                                    brv.Batch_Id__c = RenewBatchId[0].Id;
                                }
                                brv.Fail_Pass_Reason__c=sbrmap.get(ActiveSubscriberRule).Proposed_wording_pass__c;
                                brv.BusinessRuleId__c=sbrmap.get(ActiveSubscriberRule).id;
                                brv.OpportunityId__c = oc.Opportunity__c;
                                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                                {
                                    brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                                }
                                brv.Status__c='Passed';
                                
                                bsrlst.add(brv);
                                System.debug('Business rule list subscriber condition pass: ' + bsrlst);
                            }
                            
                            else {
                                system.debug('inside retrriing cencus after if condition');
                                brv.AccountId__c=oc.Account__c;
                                if(RenewBatchId.size()>0)
                                {
                                    brv.Batch_Id__c = RenewBatchId[0].Id;
                                }
                                brv.Fail_Pass_Reason__c=sbrmap.get(ActiveSubscriberRule).Proposed_wording_fail__c;
                                brv.BusinessRuleId__c=sbrmap.get(ActiveSubscriberRule).id;
                                brv.OpportunityId__c = oc.Opportunity__c;
                                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                                {
                                    brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                                }
                                brv.Status__c='Failed';
                                
                                bsrlst.add(brv);
                                System.debug('Business rule list subscriber condition fails: ' + bsrlst);
                            }
                        }
                    }
                    
                }
                
                
                else {
                    system.debug('Testingaccountoppsubscribercheck');
                    brv.AccountId__c=oss.AccountId;
                    if(RenewBatchId.size()>0){
                        brv.Batch_Id__c = RenewBatchId[0].Id;
                    }
                    brv.Fail_Pass_Reason__c=sbrmap.get(ActiveSubscriberRule).Proposed_wording_fail__c;
                    brv.BusinessRuleId__c=sbrmap.get(ActiveSubscriberRule).id;
                    brv.OpportunityId__c = oss.Id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    brv.Status__c='Failed';
                    
                    bsrlst.add(brv);
                    System.debug('zero cencus: ' + bsrlst);
                }
                
            }
            System.debug('Inserting BR ' + bsrlst);
            insert bsrlst;
            msg='Insertion done.';
            
        }
        catch(Exception e)
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.activeSubscribercheck', 'High');                                                           
            //throw new AuraHandledException( e.getMessage());
            
        }
        return msg;
    } 
    //SFDC-14082: SGR: R4E - Dependents for Employee Only Tier
    //Author: Landry Harris
    //TODO:LANDRY - DMLException/Exception handling , move status and reason text to SGR_Constants
    public static String checkForDependentsForEmployeeOnlyTier(List<Opportunity> opps,
                                                               String employeeOnlyDependentsRule,
                                                               String BatchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                               List<SGRRenewalBatch__c> RenewBatchId,
                                                               map<String,SGR_Business_Rule__c> sbrmap,
                                                               map<Id, List<SGR_Opportunity_Member_Benefits__c>> benefits,
                                                               Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
                                                                   String ruleProcessMsg;
                                                                   SGR_Business_Rule__c br = sbrmap.get(employeeOnlyDependentsRule);
                                                                   List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
                                                                   Set<String> subscriberIds = new Set<String>(); 
                                                                   Id acctId;
                                                                   Id oppId;                                                          
                                                                   boolean activeSubscriber = false; 
                                                                   boolean rulePass = false;
                                                                   boolean ruleFailOne = false;                                                         
                                                                   boolean ruleFailTwo = false; 
                                                                   try {
                                                                       for (Opportunity o: opps) {
                                                                           acctId = o.AccountId;
                                                                           oppId = o.Id;
                                                                           rulePass = false;
                                                                           ruleFailOne = false;                                                         
                                                                           ruleFailTwo = false; 
                                                                           Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                                                                           brv.AccountId__c = o.AccountId;
                                                                           if (RenewBatchId.size() > 0) {
                                                                               brv.Batch_Id__c = RenewBatchId[0].Id;
                                                                           }
                                                                           brv.BusinessRuleId__c = br.Id;    
                                                                           brv.OpportunityId__c = o.Id;
                                                                           System.debug('Business rule list: ' + bsrlst);
                                                                           for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                                                                           {
                                                                               brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                                           }
                                                                           List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                                           for (SGR_Opportunity_Census__c oc: censuses) {
                                                                               List<SGR_Opportunity_Member_Benefits__c> oppMemberBenefits = benefits.get(oc.Id);
                                                                               for (SGR_Opportunity_Member_Benefits__c omb: oppMemberBenefits) {
                                                                                   if ((oc.Member_Effective_Date__c < Date.today()) && (oc.Member_Cancel_Date__c > Date.today())) {
                                                                                       activeSubscriber = true;
                                                                                   }
                                                                                   if (omb.Member_Policy_Tier__c == 'EO') {
                                                                                       if (activeSubscriber && oc.Membership_Number__c == 1) {
                                                                                           rulePass = true;
                                                                                       }
                                                                                       else {
                                                                                           if (activeSubscriber && oc.Membership_Number__c > 1) {
                                                                                               subscriberIds.add(String.valueOf(oc.Subscriber_Number__c));
                                                                                               rulePass = false;
                                                                                               ruleFailOne = true;
                                                                                           }
                                                                                           else {
                                                                                               rulePass = false;
                                                                                               ruleFailTwo = true;
                                                                                           }       
                                                                                       }
                                                                                   }
                                                                                   else {
                                                                                       rulePass = true;  
                                                                                   }
                                                                               }          
                                                                           }
                                                                           List<String> uniqueIds = new List<String>(subscriberIds);
                                                                           String joinedIds = String.join(uniqueIds, ', ');
                                                                           //check boolean values to see if rule should mark as pass or fail
                                                                           if (!ruleFailOne && !ruleFailTwo) {
                                                                               brv.Status__c = SGR_Constants.StatusPassed;
                                                                               brv.Fail_Pass_Reason__c = br.Proposed_wording_pass__c;
                                                                           }
                                                                           else {
                                                                               if (ruleFailOne && !ruleFailTwo) {
                                                                                   //TODO:Landry example of using constants
                                                                                   brv.Status__c = SGR_Constants.StatusFailed;
                                                                                   brv.Fail_Pass_Reason__c = 'Dependents exist for an \'Employee Only\' tier.\nSubscriber Number = ' + joinedIds + '.';
                                                                               }
                                                                               else if (!ruleFailOne && ruleFailTwo) {
                                                                                   brv.Status__c = SGR_Constants.StatusFailed;
                                                                                   brv.Fail_Pass_Reason__c = 'No active subscribers found.';
                                                                               }
                                                                               else if (ruleFailOne && ruleFailTwo) {
                                                                                   brv.Status__c = SGR_Constants.StatusFailed;
                                                                                   brv.Fail_Pass_Reason__c = 'Fail #1: Dependents exist for an \'Employee Only\' tier.\nSubscriber Number = ' + joinedIds + '.\n\nFail #2: Scenario 2: No active subscribers found';
                                                                               }
                                                                           }
                                                                           bsrlst.add(brv);
                                                                       }
                                                                       insert bsrlst;                                                          
                                                                       ruleProcessMsg = 'BR GR.DV.09 processed successfully.';                                                          
                                                                   } 
                                                                   
                                                                   catch (Exception ex) {
                                                                       CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                                                                                         'Opportunity', null, 
                                                                                                         'SGR_validationHelperdemo.checkForDependentsForEmployeeOnlyTier AccountId: ' + acctId + ' Opportunity Id: ' + oppId, 'High');                                                          
                                                                   }
                                                                   
                                                                   
                                                                   return ruleProcessMsg;
                                                               } 
    
    /*private static void createBRVLog(string recId, string passMesg, string failMesg){
Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
}*/
    //vijaya SFDC-14083 start
    public static String checkForSpouseOrDP(List<Opportunity> opps, map<id,List<SGR_Opportunity_Census__c>> optyCenGrp, 
                                            string BatchId, String ruleId, List<SGRRenewalBatch__c> renBatchId,  Map<String,SGR_Business_Rule__c> bRules, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                system.debug('checkForSpouseOrDP method called');                                        
                                                string value;        
                                                
                                                SGR_Business_Rule__c bRule = bRules.get(ruleId);
                                                
                                                try{
                                                    integer spouseCount;
                                                    integer dpCount;
                                                    List<String> fail;
                                                    List<String> pass;
                                                    List<String> pass2;
                                                    List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
                                                    List<Business_Rule_Validation_Log__c> bRVs = new List<Business_Rule_Validation_Log__c>();
                                                    //List<SGR_Opportunity_Census__c> optyDepCensRecs = new List<SGR_Opportunity_Census__c>();
                                                    List<Id> censusIds = new List<Id>();
                                                    boolean ruleFailOne;                                                         
                                                    boolean rulePass2; 
                                                    boolean rulePass1;
                                                    boolean activeSubscriber;  
                                                    for(Opportunity optys : opps){
                                                        system.debug('+++++optys.Id--'+optys.Id);
                                                        fail = new List<string>();
                                                        pass = new List<string>();
                                                        pass2 = new List<string>();
                                                        ruleFailOne = false;                                                         
                                                        rulePass2 = false; 
                                                        rulePass1 = false;
                                                        activeSubscriber = false;  
                                                        List<Decimal> subscriberIds = new List<Decimal>();
                                                        //brvs = new List<Business_Rule_Validation_Log__c>();
                                                        Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                        bRV.AccountId__c = optys.AccountId;
                                                        system.debug('+++++renBatchId.size()--'+renBatchId.size());
                                                        if(renBatchId.size() >0)
                                                            brv.Batch_Id__c = renBatchId[0].Id;
                                                        brv.OpportunityId__c = optys.Id;
                                                        brv.BusinessRuleId__c = bRules.get(ruleId).id;
                                                        for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(optys.id))
                                                        {
                                                            brv.Renewal_Batch_Oppty_Id__c = srbo.name;
                                                        }
                                                        List<SGR_Opportunity_Census__c> censuses = optyCenGrp.get(optys.Id);
                                                        //Validate if the census exists or not
                                                        system.debug('+++++censuses.size()--'+censuses.size());
                                                        if(censuses.size() == 0){
                                                            brv.Status__c = SGR_Constants.StatusFailed;
                                                            brv.Fail_Pass_Reason__c = 'Fail #2: No active subscribers found';
                                                        }
                                                        Map<decimal, List<SGR_Opportunity_Census__c>> memMap = new Map<decimal, List<SGR_Opportunity_Census__c>>();
                                                        for (SGR_Opportunity_Census__c oc: censuses) { 
                                                            system.debug('Opty cen rec--'+oc.id);
                                                            system.debug('+++++oc.Relationship__c--'+oc.Relationship__c);
                                                            if(oc.Relationship__c == 'Subscriber'){
                                                                system.debug('opty census relationship---'+oc.Relationship__c);
                                                                system.debug('opty census Member_Effective_Date__c---'+oc.Member_Effective_Date__c);
                                                                system.debug('opty census Member_Cancel_Date__c---'+oc.Member_Cancel_Date__c);
                                                                if((oc.Member_Effective_Date__c < Date.today()) && (oc.Member_Cancel_Date__c > Date.today())) {
                                                                    activeSubscriber = true;
                                                                }
                                                                system.debug('activeSubscriber-->'+activeSubscriber);
                                                                system.debug('+++++memMap.containskey(oc.Subscriber_number__c)--'+memMap.containskey(oc.Subscriber_number__c));
                                                                if(memMap.containskey(oc.Subscriber_number__c)){
                                                                    continue;
                                                                }
                                                                else{
                                                                    List<SGR_Opportunity_Census__c> lstCens= new List<SGR_Opportunity_Census__c>();
                                                                    memMap.put(oc.Subscriber_number__c, lstCens);
                                                                }    
                                                            }
                                                            else{
                                                                system.debug('+++++memMap.containskey(oc.Subscriber_number__c)--'+memMap.containskey(oc.Subscriber_number__c));
                                                                if(memMap.containskey(oc.Subscriber_number__c)){
                                                                    memMap.get(oc.Subscriber_Number__c).add(oc);
                                                                }
                                                                else{
                                                                    List<SGR_Opportunity_Census__c> lstCens= new List<SGR_Opportunity_Census__c>();
                                                                    lstCens.add(oc);
                                                                    memMap.put(oc.Subscriber_number__c, lstCens);
                                                                } 
                                                            }
                                                        }
                                                        
                                                        system.debug('memMap--'+memMap);
                                                        for(Decimal keyS : memMap.keySet()){
                                                            spouseCount = 0;
                                                            dpCount = 0;                                                            
                                                            rulePass1 = false;
                                                            rulePass2 = false;
                                                            ruleFailOne = false;
                                                            List<SGR_Opportunity_Census__c> lstCens = memMap.get(keyS);
                                                            Decimal cenSubNumber;
                                                            for(SGR_Opportunity_Census__c opCs : lstCens){
                                                                system.debug('+++++opCs.Relationship__c--'+opCs.Relationship__c);
                                                                if(opCs.Relationship__c == 'Spouse'){
                                                                    spouseCount++;
                                                                    cenSubNumber = opCs.Subscriber_number__c;
                                                                }
                                                                else if(opCs.Relationship__c == 'Domestic Partner'){
                                                                    dpCount++;
                                                                    cenSubNumber = opCs.Subscriber_number__c;
                                                                }
                                                            }
                                                            system.debug('+++++spouseCount--'+spouseCount);
                                                            system.debug('+++++dpCount--'+dpCount);
                                                            if(spouseCount == 0 && dpCount == 0){
                                                                rulePass2 = true;
                                                                pass2.add('pass2');
                                                            }
                                                            else if(spouseCount == 1 || dpCount == 1){
                                                                rulePass1 = true;
                                                                pass.add('pass');
                                                            }
                                                            else if((spouseCount > 1 || dpCount > 1) || (spouseCount == 1 && dpCount == 1)){
                                                                ruleFailOne = true;  
                                                                //cenSubNumber = opCs.Subscriber_number__c;
                                                                subscriberIds.add(cenSubNumber);
                                                                //string con = new string('fail');
                                                                fail.add('fail');
                                                            }
                                                        }
                                                        String joinedIds = String.join(subscriberIds, ', ');
                                                        system.debug('+++++fail.size()--'+fail.size());
                                                        system.debug('+++++pass.size()--'+pass.size());
                                                        system.debug('+++++pass2.size()--'+pass2.size());
                                                        system.debug('+++++activeSubscriber--'+activeSubscriber);
                                                        if(fail.size()>0 && activeSubscriber == true){
                                                            brv.Status__c = SGR_Constants.StatusFailed;
                                                            brv.Fail_Pass_Reason__c = 'Fail #1: More than one Dependent with relationship type of "S" or "DP".   Subscriber Number = '+joinedIds;
                                                        }
                                                        else if(pass.size()>0 && activeSubscriber == true){
                                                            brv.Status__c = SGR_Constants.StatusPassed;
                                                            brv.Fail_Pass_Reason__c = 'Pass: Only one Dependent has a relationship code of "S" or "DP"';//bRule.Proposed_wording_pass__c; 
                                                        }
                                                        else if(pass2.size()>0 && activeSubscriber == true){
                                                            brv.Status__c = SGR_Constants.StatusNA;
                                                            brv.Fail_Pass_Reason__c = 'N/A: No "ES" tiers';
                                                        }
                                                        else if(activeSubscriber == false){
                                                            brv.Status__c = SGR_Constants.StatusFailed;
                                                            brv.Fail_Pass_Reason__c = 'Fail #2: No active subscribers found';
                                                        }                                                        
                                                        bRVs.add(brv);
                                                    }
                                                    system.debug('+++++bRVs.size()--'+bRVs.size());
                                                    if(bRVs.size() > 0){
                                                        insert brvs;
                                                        value = 'BR GR.DV.10 processed successfully.'; 
                                                    }
                                                    
                                                } catch(Exception e)
                                                { 
                                                    //throw new AuraHandledException( e.getMessage());
                                                    CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'Vijaja_sgr_validationM.checkForSpouseOrDP', 'High');                                                          
                                                }
                                                return value;
                                            } 
    //Vijaya SFDC-14083 End
    
    //SFDC-14508: SGR: R5W - Funding Type is NOT Premium
    //Author: Landry Harris
    public static String checkForPremiumFundingType(List<Opportunity> opps, String fundingTypeRule, Map<String,SGR_Business_Rule__c> sbrmap, String BatchId, List<SGRRenewalBatch__c> RenewBatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
        String ruleProcessMsg;
        try {
            SGR_Business_Rule__c br = sbrmap.get(fundingTypeRule);
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            for (Opportunity o: opps) {
                System.debug('Opportunity (funding type): ' + o);
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                brv.AccountId__c = o.AccountId;
                if (RenewBatchId.size() > 0) {
                    brv.Batch_Id__c = RenewBatchId[0].Id;
                }
                brv.BusinessRuleId__c = br.Id;    
                brv.OpportunityId__c = o.Id;
                for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                {
                    brv.Renewal_Batch_Oppty_Id__c = srbo.name;
                }
                
                if (o.Funding_Type__c == 'PREM') {
                    brv.Status__c = SGR_Constants.StatusPassed;
                    brv.Fail_Pass_Reason__c = br.Proposed_wording_pass__c;
                } 
                else {
                    brv.Status__c = SGR_Constants.StatusFailed;
                    brv.Fail_Pass_Reason__c = br.Proposed_wording_fail__c;
                }
                bsrlst.add(brv);
            }
            insert bsrlst;
            ruleProcessMsg = 'BR GR.DV.15 processed successfully.';
        }
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.checkForPremiumFundingType', 'High');
            ruleProcessMsg = 'BR GR.DV.15 processed unsuccessfully.';
        }
        return ruleProcessMsg;
    }
    
    //Anudeep  
    
    //SFDC-14084: SGR: R6E - Dependents w/ No Relationship Code 
    //Author: Anudeep
    public Static String DependentswithNoRelationshipCodeValidation(List<SGR_Opportunity_Census__c> SGROpptyCensusList, String Deptsexistwithnorelationshipcode, 
                                                                    Map<String,SGR_Business_Rule__c> sbrmap, String BatchId, List<SGRRenewalBatch__c> RenewBatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                                        String ruleProcessMsg;
                                                                        
                                                                        try{
                                                                            List<Business_Rule_Validation_Log__c> BusRuleValidationLogList = new List<Business_Rule_Validation_Log__c>();
                                                                            //Dental Tier Set
                                                                            set<String> ESTierSet =new set<String>{'ES'};
                                                                                set<String> ECTierSet =new set<String>{'EC'};
                                                                                    set<String> EFTierSet =new set<String>{'EF'};
                                                                                        
                                                                                        
                                                                                        if(!SGROpptyCensusList.isEmpty()){
                                                                                            for(SGR_Opportunity_Census__c OpptyCensus : SGROpptyCensusList){
                                                                                                system.debug('***********'+OpptyCensus);
                                                                                                Business_Rule_Validation_Log__c BRVL=new Business_Rule_Validation_Log__c();
                                                                                                BRVL.AccountId__c=OpptyCensus.Account__c;
                                                                                                BRVL.OpportunityId__c=OpptyCensus.Opportunity__c;
                                                                                                if(OpptyCensus.Membership_Number__c!=null){
                                                                                                    if((OpptyCensus.Membership_Number__c>1 && OpptyCensus.Relationship_Code__c==null)){
                                                                                                        if(ESTierSet.contains(OpptyCensus.Dental_Tier__c) || ECTierSet.contains(OpptyCensus.Dental_Tier__c) || EFTierSet.contains(OpptyCensus.Dental_Tier__c)){
                                                                                                            BRVL.Status__c='Failed';
                                                                                                            BRVL.Fail_Pass_Reason__c = 'Tier type of ES/EC/EF has a Dependent with no relationship type code';
                                                                                                            BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                            for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                            {
                                                                                                                BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                            }
                                                                                                            if (RenewBatchId.size() > 0) {
                                                                                                                BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                            }
                                                                                                            BusRuleValidationLogList.add(BRVL);
                                                                                                        }else if(ESTierSet.contains(OpptyCensus.Health_Tier__c) || ECTierSet.contains(OpptyCensus.Health_Tier__c) || EFTierSet.contains(OpptyCensus.Health_Tier__c)){
                                                                                                            BRVL.Status__c='Failed';
                                                                                                            BRVL.Fail_Pass_Reason__c = 'Tier type of ES/EC/EF has a Dependent with no relationship type code';
                                                                                                            BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                            for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                            {
                                                                                                                BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                            }
                                                                                                            
                                                                                                            if (RenewBatchId.size() > 0) {
                                                                                                                BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                            }
                                                                                                            BusRuleValidationLogList.add(BRVL);
                                                                                                        }else{
                                                                                                            if(ESTierSet.contains(OpptyCensus.Vision_Tier__c) || ECTierSet.contains(OpptyCensus.Vision_Tier__c) || EFTierSet.contains(OpptyCensus.Vision_Tier__c)){
                                                                                                                BRVL.Status__c='Failed';
                                                                                                                BRVL.Fail_Pass_Reason__c = 'Tier type of ES/EC/EF has a Dependent with no relationship type code';
                                                                                                                BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                                {
                                                                                                                    BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                                }
                                                                                                                
                                                                                                                if (RenewBatchId.size() > 0) {
                                                                                                                    BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                                }
                                                                                                                BusRuleValidationLogList.add(BRVL);
                                                                                                            }
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                    else{
                                                                                                        if(ESTierSet.contains(OpptyCensus.Dental_Tier__c) || ECTierSet.contains(OpptyCensus.Dental_Tier__c) || EFTierSet.contains(OpptyCensus.Dental_Tier__c)){
                                                                                                            BRVL.Status__c='Passed';
                                                                                                            BRVL.Fail_Pass_Reason__c = 'All Dependents have relationship codes';
                                                                                                            BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                            for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                            {
                                                                                                                BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                            }
                                                                                                            if (RenewBatchId.size() > 0) {
                                                                                                                BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                            }
                                                                                                            BusRuleValidationLogList.add(BRVL);
                                                                                                        }else if(ESTierSet.contains(OpptyCensus.Health_Tier__c) || ECTierSet.contains(OpptyCensus.Health_Tier__c) || EFTierSet.contains(OpptyCensus.Health_Tier__c)){
                                                                                                            BRVL.Status__c='Passed';
                                                                                                            BRVL.Fail_Pass_Reason__c = 'All Dependents have relationship codes';
                                                                                                            BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                            for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                            {
                                                                                                                BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                            }
                                                                                                            
                                                                                                            if (RenewBatchId.size() > 0) {
                                                                                                                BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                            }
                                                                                                            BusRuleValidationLogList.add(BRVL);
                                                                                                        }else{
                                                                                                            if(ESTierSet.contains(OpptyCensus.Vision_Tier__c) || ECTierSet.contains(OpptyCensus.Vision_Tier__c) || EFTierSet.contains(OpptyCensus.Vision_Tier__c)){
                                                                                                                BRVL.Status__c='Passed';
                                                                                                                BRVL.Fail_Pass_Reason__c = 'All Dependents have relationship codes';
                                                                                                                BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                                {
                                                                                                                    BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                                }
                                                                                                                
                                                                                                                if (RenewBatchId.size() > 0) {
                                                                                                                    BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                                }
                                                                                                                BusRuleValidationLogList.add(BRVL);
                                                                                                            }
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                }else{
                                                                                                    BRVL.Status__c='N/A';
                                                                                                    BRVL.Fail_Pass_Reason__c = 'No dependents';
                                                                                                    BRVL.BusinessRuleId__c=sbrmap.get(Deptsexistwithnorelationshipcode).Id;
                                                                                                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                                                    {
                                                                                                        BRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                                    }
                                                                                                    
                                                                                                    if (RenewBatchId.size() > 0) {
                                                                                                        BRVL.Batch_Id__c = RenewBatchId[0].Id;
                                                                                                    }
                                                                                                    BusRuleValidationLogList.add(BRVL);
                                                                                                }
                                                                                                
                                                                                                
                                                                                            }
                                                                                            if(!BusRuleValidationLogList.isEmpty()){
                                                                                                system.debug('&&&&&&'+BusRuleValidationLogList);
                                                                                                Insert BusRuleValidationLogList;
                                                                                                ruleProcessMsg='BR GR.DV.11 processed successfully.';
                                                                                            }
                                                                                        }
                                                                        } catch (Exception ex) {
                                                                            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.DependentswithNoRelationshipCodeValidation', 'High');
                                                                            ruleProcessMsg = 'BR GR.DV.11 processed unsuccessfully.';
                                                                        }
                                                                        return ruleProcessMsg;
                                                                    }
    
    //Anudeep
    //14085 SGR: R7E - ES Tier with no Spouse or DP 
    
    public Static String ESTiresValidation(List<SGR_Opportunity_Census__c> SGROpptyCensusList,                   
                                           String ESTireSpouseDomesticPartner, 
                                           Map<String,SGR_Business_Rule__c> sbrmap, 
                                           String BatchId, List<SGRRenewalBatch__c> RenewBatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                               System.debug('::::::ENTET ES 1');
                                               String ruleProcessMsg;
                                               try{
                                                   Map<String,Business_Rule_Validation_Log__c> BusRuleValidationLogList = new Map<String,Business_Rule_Validation_Log__c>();
                                                   if(!SGROpptyCensusList.isEmpty()){
                                                       
                                                       for(SGR_Opportunity_Census__c OpptyCensus : SGROpptyCensusList){
                                                           system.debug(':::::VALUEENTER:::::>>'+OpptyCensus.Name);
                                                           Business_Rule_Validation_Log__c BRVLog=new Business_Rule_Validation_Log__c();
                                                           BRVLog.AccountId__c=OpptyCensus.Account__c;
                                                           BRVLog.OpportunityId__c=OpptyCensus.Opportunity__c;
                                                           
                                                           if((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<date.today()) && (OpptyCensus.Member_Cancel_Date__c>date.today() || OpptyCensus.Member_Cancel_Date__c==null) ){
                                                               
                                                               if(((OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c=='ES') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c=='ES') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c=='ES')) && (OpptyCensus.Relationship_Code__c=='Spouse' || OpptyCensus.Relationship_Code__c=='Domestic Partner') ){
                                                                   system.debug('!!!!**1*!!!!'+OpptyCensus.Name);
                                                                   BRVLog.Status__c='Passed';
                                                                   BRVLog.Fail_Pass_Reason__c = ' No Invalid Employee Spouse tier exists.';
                                                                   
                                                               }
                                                               if(((OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c!='ES') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c!='ES') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c!='ES') ) && (OpptyCensus.Relationship_Code__c=='Spouse' || OpptyCensus.Relationship_Code__c=='Domestic Partner')){
                                                                   system.debug('!!!!**2*!!!!'+OpptyCensus.Name);
                                                                   
                                                                   BRVLog.Status__c='Failed';
                                                                   BRVLog.Fail_Pass_Reason__c = 'One or more Employee Spouse (ES) tiers exist which do not contain a Spouse or Domestic Partner.  ES tier can also not contain Child(ren)';
                                                               }
                                                               if(((OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c=='ES') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c=='ES') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c=='ES')) && (OpptyCensus.Relationship_Code__c<>'Spouse' && OpptyCensus.Relationship_Code__c<>'Domestic Partner')){
                                                                   system.debug('!!!!**3*!!!!'+OpptyCensus.Name);
                                                                   
                                                                   BRVLog.Status__c='Failed';
                                                                   BRVLog.Fail_Pass_Reason__c = 'One or more Employee Spouse (ES) tiers exist which do not contain a Spouse or Domestic Partner.  ES tier can also not contain Child(ren)';
                                                               }
                                                               if((OpptyCensus.Dental_Tier__c!='ES' && OpptyCensus.Health_Tier__c!='ES' && OpptyCensus.Vision_Tier__c!='ES') && (OpptyCensus.Relationship_Code__c!='Spouse' || OpptyCensus.Relationship_Code__c!='Domestic Partner')){
                                                                   system.debug('!!!!**4*!!!!'+OpptyCensus.Name);
                                                                   
                                                                   BRVLog.Status__c='N/A';
                                                                   BRVLog.Fail_Pass_Reason__c = 'No ES tiers';
                                                                   
                                                               }
                                                               
                                                           }else{
                                                               system.debug('::::::::INACTIVE ACCOUNT::::::'+OpptyCensus);
                                                               
                                                               BRVLog.Status__c='Failed';
                                                               BRVLog.Fail_Pass_Reason__c ='No active subscribers found'; 
                                                           } 
                                                           
                                                           BRVLog.BusinessRuleId__c=sbrmap.get(ESTireSpouseDomesticPartner).Id;
                                                           for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                           {
                                                               BRVLog.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                           }
                                                           
                                                           if (RenewBatchId.size() > 0) {
                                                               BRVLog.Batch_Id__c = RenewBatchId[0].Id;
                                                           }
                                                           System.debug(':::::::VALUES-->:::::'+BRVLog);
                                                           if(BRVLog.Status__c==null){
                                                               System.debug(':::::::STATUSCHECK-->:::::'+OpptyCensus.Name);
                                                           }
                                                           BusRuleValidationLogList.put(OpptyCensus.Name,BRVLog);
                                                       }
                                                       
                                                       
                                                   }
                                                   System.debug(':::::::VALUES:::::'+BusRuleValidationLogList);
                                                   if(!BusRuleValidationLogList.isEmpty()){
                                                       Insert BusRuleValidationLogList.values();
                                                       ruleProcessMsg='BR GR.DV.12 processed successfully.';
                                                   }
                                               }
                                               catch (Exception ex) {
                                                   CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.DependentswithNoRelationshipCodeValidation', 'High');
                                                   ruleProcessMsg = 'BR GR.DV.12 processed unsuccessfully.';
                                               }
                                               return ruleProcessMsg;
                                               
                                           }
    
    //Anudeep
    // 14086 SGR: R8E - EC Tier Without Children 
    public static String ECTireWithoutChildValidation(List<SGR_Opportunity_Census__c> SGROpptyCensusList,                   
                                                      String ECTireChild, 
                                                      Map<String,SGR_Business_Rule__c> sbrmap, 
                                                      String BatchId, List<SGRRenewalBatch__c> RenewBatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                          System.debug('::::::ENTET EC 1');
                                                          String ruleProcessMsg;
                                                          try{
                                                              Map<String,Business_Rule_Validation_Log__c> BusRuleValidationLogList = new Map<String,Business_Rule_Validation_Log__c>();
                                                              if(!SGROpptyCensusList.isEmpty()){
                                                                  
                                                                  for(SGR_Opportunity_Census__c OpptyCensus : SGROpptyCensusList){
                                                                      system.debug(':::::VALUEENTER:::::>>'+OpptyCensus);
                                                                      Business_Rule_Validation_Log__c BRVLog=new Business_Rule_Validation_Log__c();
                                                                      BRVLog.AccountId__c=OpptyCensus.Account__c;
                                                                      BRVLog.OpportunityId__c=OpptyCensus.Opportunity__c;
                                                                      
                                                                      if((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<date.today()) && (OpptyCensus.Member_Cancel_Date__c>date.today() || OpptyCensus.Member_Cancel_Date__c==null) ){
                                                                          
                                                                          if( ((OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c=='EC') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c=='EC') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c=='EC')) && OpptyCensus.Relationship_Code__c=='Child'){
                                                                              system.debug('!!!!**1*!!!!'+OpptyCensus);
                                                                              BRVLog.Status__c='Passed';
                                                                              BRVLog.Fail_Pass_Reason__c = 'No Invalid Employee Child(ren) tier exists.';
                                                                              
                                                                          }
                                                                          if(( (OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c!='EC') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c!='EC') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c!='EC') ) && OpptyCensus.Relationship_Code__c=='Child'){
                                                                              system.debug('!!!!**2*!!!!'+OpptyCensus);
                                                                              
                                                                              BRVLog.Status__c='Failed';
                                                                              BRVLog.Fail_Pass_Reason__c = 'One or more Employee Child(ren) (EC) tiers exist which does not contain one or more children.  EC tier can also not contain a Spouse or Domestic Partner';
                                                                          }
                                                                          if(( (OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c=='EC') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c=='EC') ||  (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c=='EC')) && OpptyCensus.Relationship_Code__c<>'Child'){
                                                                              system.debug('!!!!**3*!!!!'+OpptyCensus);
                                                                              
                                                                              BRVLog.Status__c='Failed';
                                                                              BRVLog.Fail_Pass_Reason__c = 'One or more Employee Child(ren) (EC) tiers exist which does not contain one or more children.  EC tier can also not contain a Spouse or Domestic Partner';
                                                                          }
                                                                          if(OpptyCensus.Dental_Tier__c!='EC' && OpptyCensus.Health_Tier__c!='EC' && OpptyCensus.Vision_Tier__c!='EC' && OpptyCensus.Relationship_Code__c!='Child'){
                                                                              system.debug('!!!!**4*!!!!'+OpptyCensus);
                                                                              BRVLog.Status__c='N/A';
                                                                              BRVLog.Fail_Pass_Reason__c = 'No EC tiers';
                                                                          }
                                                                      }else{
                                                                          system.debug('::::::::INACTIVE ACCOUNT::::::'+OpptyCensus);
                                                                          
                                                                          BRVLog.Status__c='Failed';
                                                                          BRVLog.Fail_Pass_Reason__c ='No active subscribers found'; 
                                                                      } 
                                                                      
                                                                      BRVLog.BusinessRuleId__c=sbrmap.get(ECTireChild).Id;
                                                                      for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                      {
                                                                          BRVLog.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                      }
                                                                      
                                                                      if (RenewBatchId.size() > 0) {
                                                                          BRVLog.Batch_Id__c = RenewBatchId[0].Id;
                                                                      }
                                                                      System.debug(':::::::VALUES-->:::::'+BRVLog);
                                                                      BusRuleValidationLogList.put(OpptyCensus.Name,BRVLog);
                                                                  }
                                                                  
                                                                  
                                                              }
                                                              System.debug(':::::::VALUES:::::'+BusRuleValidationLogList);
                                                              if(!BusRuleValidationLogList.isEmpty()){
                                                                  Insert BusRuleValidationLogList.values();
                                                                  ruleProcessMsg='BR GR.DV.13 processed successfully.';
                                                              }
                                                          }
                                                          catch (Exception ex) {
                                                              CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.DependentswithNoRelationshipCodeValidation', 'High');
                                                              ruleProcessMsg = 'BR GR.DV.13 processed unsuccessfully.';
                                                          }
                                                          return ruleProcessMsg;
                                                          
                                                      }
    //Anudeep
    //14087 SGR: R9E - EF Tier Without Family 
    public Static String EFTireWithoutFamilyValidation(List<SGR_Opportunity_Census__c> SGROpptyCensusList,                   
                                                       String EFTireFamily, 
                                                       Map<String,SGR_Business_Rule__c> sbrmap, 
                                                       String BatchId, List<SGRRenewalBatch__c> RenewBatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                           System.debug('::::::ENTET EF 1');
                                                           String ruleProcessMsg;
                                                           try{
                                                               Map<String,Business_Rule_Validation_Log__c> BusRuleValidationLogList = new Map<String,Business_Rule_Validation_Log__c>();
                                                               if(!SGROpptyCensusList.isEmpty()){
                                                                   
                                                                   for(SGR_Opportunity_Census__c OpptyCensus : SGROpptyCensusList){
                                                                       system.debug(':::::VALUEENTER:::::>>'+OpptyCensus);
                                                                       Business_Rule_Validation_Log__c BRVLog=new Business_Rule_Validation_Log__c();
                                                                       BRVLog.AccountId__c=OpptyCensus.Account__c;
                                                                       BRVLog.OpportunityId__c=OpptyCensus.Opportunity__c;
                                                                       
                                                                       if((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<date.today()) && (OpptyCensus.Member_Cancel_Date__c>date.today() || OpptyCensus.Member_Cancel_Date__c==null) ){
                                                                           
                                                                           if(((OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c=='EF') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c=='EF') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c=='EF') ) && OpptyCensus.Relationship_Code__c=='Domestic Partner'){
                                                                               system.debug('!!!!**1*!!!!'+OpptyCensus);
                                                                               BRVLog.Status__c='Passed';
                                                                               BRVLog.Fail_Pass_Reason__c = ' No Invalid Employee Family tier exists.';
                                                                               
                                                                           }
                                                                           if( (( OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c!='EF') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c!='EF') ||  (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c!='EF') ) && OpptyCensus.Relationship_Code__c=='Domestic Partner'){
                                                                               system.debug('!!!!**2*!!!!'+OpptyCensus);
                                                                               
                                                                               BRVLog.Status__c='Failed';
                                                                               BRVLog.Fail_Pass_Reason__c = 'One or more Employee Family (EF) tiers exists which does not consist of a Spouse or Domestic Partner AND 1 or more Children';
                                                                           }
                                                                           if(((OpptyCensus.Dental_Tier__c!=null && OpptyCensus.Dental_Tier__c=='EF') || (OpptyCensus.Health_Tier__c!=null && OpptyCensus.Health_Tier__c=='EF') || (OpptyCensus.Vision_Tier__c!=null && OpptyCensus.Vision_Tier__c=='EF') ) && OpptyCensus.Relationship_Code__c<>'Domestic Partner'){
                                                                               system.debug('!!!!**3*!!!!'+OpptyCensus);
                                                                               
                                                                               BRVLog.Status__c='Failed';
                                                                               BRVLog.Fail_Pass_Reason__c = 'One or more Employee Family (EF) tiers exists which does not consist of a Spouse or Domestic Partner AND 1 or more Children';
                                                                           }
                                                                           if(OpptyCensus.Dental_Tier__c!='EF' && OpptyCensus.Health_Tier__c!='EF' && OpptyCensus.Vision_Tier__c!='EF' && OpptyCensus.Relationship_Code__c!='Domestic Partner'){
                                                                               system.debug('!!!!**4*!!!!'+OpptyCensus);
                                                                               BRVLog.Status__c='N/A';
                                                                               BRVLog.Fail_Pass_Reason__c = 'No EF tiers';
                                                                           }
                                                                       }else{
                                                                           system.debug('::::::::INACTIVE ACCOUNT::::::'+OpptyCensus);
                                                                           
                                                                           BRVLog.Status__c='Failed';
                                                                           BRVLog.Fail_Pass_Reason__c ='No active subscribers found'; 
                                                                       } 
                                                                       
                                                                       BRVLog.BusinessRuleId__c=sbrmap.get(EFTireFamily).Id;
                                                                       for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OpptyCensus.Opportunity__c))
                                                                       {
                                                                           BRVLog.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                       }
                                                                       
                                                                       if (RenewBatchId.size() > 0) {
                                                                           BRVLog.Batch_Id__c = RenewBatchId[0].Id;
                                                                       }
                                                                       System.debug(':::::::VALUES-->:::::'+BRVLog);
                                                                       BusRuleValidationLogList.put(OpptyCensus.Name,BRVLog);
                                                                   }
                                                                   
                                                                   
                                                               }
                                                               System.debug(':::::::VALUES:::::'+BusRuleValidationLogList);
                                                               if(!BusRuleValidationLogList.isEmpty()){
                                                                   Insert BusRuleValidationLogList.values();
                                                                   ruleProcessMsg='BR GR.DV.13 processed successfully.';
                                                               }
                                                           }
                                                           catch (Exception ex) {
                                                               CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.DependentswithNoRelationshipCodeValidation', 'High');
                                                               ruleProcessMsg = 'BR GR.DV.13 processed unsuccessfully.';
                                                           }
                                                           return ruleProcessMsg;
                                                           
                                                       }  
    
    //SFDC-14506: SGR: R4W - Member Over 99 Years Old
    //Author: Landry Harris
    public static String checkMembershipAge(List<Opportunity> opps, String memberOver99,
                                            String BatchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                            List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,
                                            Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
                                                String result;      
                                                List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();                             
                                                try {
                                                    SGR_Business_Rule__c br = sbrmap.get(memberOver99);
                                                    Set<String> subscriberIds = new Set<String>();                                                          
                                                    boolean activeSubscriber = false; 
                                                    boolean rulePass = false;
                                                    boolean ruleFailOne = false;                                                         
                                                    boolean ruleFailTwo = false; 
                                                    Decimal age;
                                                    for (Opportunity o: opps) {
                                                        rulePass = false;
                                                        ruleFailOne = false;                                                         
                                                        ruleFailTwo = false; 
                                                        Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                                                        brv.AccountId__c = o.AccountId;
                                                        if (RenewBatchId.size() > 0) {
                                                            brv.Batch_Id__c = RenewBatchId[0].Id;
                                                        }
                                                        brv.BusinessRuleId__c = br.Id;    
                                                        brv.OpportunityId__c = o.Id;
                                                        for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                                                        {
                                                            brv.Renewal_Batch_Oppty_Id__c = srbo.name;
                                                        }
                                                        List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                        for (SGR_Opportunity_Census__c oc: censuses) {
                                                            activeSubscriber = false;
                                                            Integer days = oc.Date_of_Birth__c.daysBetween(o.Renewal_Date__c);
                                                            System.debug('Days between: ' + days);
                                                            age = days/365;
                                                            System.debug('Age: ' + age);
                                                            if ((oc.Member_Effective_Date__c < Date.today()) && (oc.Member_Cancel_Date__c >= Date.today())) {
                                                                activeSubscriber = true;
                                                            }
                                                            if (activeSubscriber) {
                                                                if (age >= 99) {
                                                                    subscriberIds.add(String.valueOf(oc.Subscriber_number__c));
                                                                    rulePass = false;
                                                                    ruleFailOne = true; 
                                                                }
                                                                else {
                                                                    rulePass = true;
                                                                }
                                                            }
                                                            else {
                                                                rulePass = false;
                                                                ruleFailTwo = true; 
                                                            }
                                                        }
                                                        List<String> uniqueIds = new List<String>(subscriberIds);
                                                        String joinedIds = String.join(uniqueIds, ', ');
                                                        //check boolean values to see if rule should mark as pass or fail
                                                        if (!ruleFailOne && !ruleFailTwo) {
                                                            brv.Status__c = SGR_Constants.StatusPassed;
                                                            brv.Fail_Pass_Reason__c = br.Proposed_wording_pass__c;
                                                        }
                                                        else {
                                                            if (ruleFailOne) {
                                                                brv.Status__c = SGR_Constants.StatusFailed;
                                                                brv.Fail_Pass_Reason__c = 'One or more members exist which is above 99 years old.\nSubscriber Number = ' + joinedIds + '.';
                                                            }
                                                            else if (!ruleFailOne && ruleFailTwo) {
                                                                brv.Status__c = SGR_Constants.StatusFailed;
                                                                brv.Fail_Pass_Reason__c = 'No active members found.';
                                                            }
                                                        }
                                                        bsrlst.add(brv);
                                                    }
                                                    if (bsrlst.size() > 0) {
                                                        insert bsrlst;
                                                        result = 'BR GR.DV.08 processed successfully.';
                                                    }
                                                    
                                                }
                                                catch (Exception ex) {
                                                    CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.checkMembershipAge', 'High');
                                                    result = 'BR GR.DV.08 processed unsuccessfully.';
                                                }
                                                return result;
                                            }
    //SFDC-14540: SGR: R10W - Headquarter & Division Mismatch
    //Author: Landry Harris
    public static String checkStateCode(List<Opportunity> opps, String stateCodeRule, Map<String,SGR_Business_Rule__c> sbrmap, String BatchId, List<SGRRenewalBatch__c> RenewBatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
        String ruleProcessMsg;
        SGR_Business_Rule__c br = sbrmap.get(stateCodeRule);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        try {
            for (Opportunity o: opps) {
                System.debug('Opportunity (funding type): ' + o);
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                brv.AccountId__c = o.AccountId;
                if (RenewBatchId.size() > 0) {
                    brv.Batch_Id__c = RenewBatchId[0].Id;
                }
                brv.BusinessRuleId__c = br.Id;    
                brv.OpportunityId__c = o.Id;
                for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                {
                    brv.Renewal_Batch_Oppty_Id__c = srbo.name;
                }
                
                if (o.Account.ShippingState__c == o.HCSC_Division__c) {
                    brv.Status__c = SGR_Constants.StatusPassed;
                    brv.Fail_Pass_Reason__c = 'Account State Code = ' + o.Account.ShippingState__c + '.';
                } 
                else {
                    brv.Status__c = SGR_Constants.StatusFailed;
                    brv.Fail_Pass_Reason__c = 'Account State Code = ' + o.Account.ShippingState__c + '.';
                }
                bsrlst.add(brv);
            }
            
            insert bsrlst;
            ruleProcessMsg = 'BR GR.DV.15 processed successfully.';
        }
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.checkStateCode', 'High');
            ruleProcessMsg = 'BR GR.DV.15 processed unsuccessfully.';
        }
        return ruleProcessMsg;
    }
    
    /*
*   US12536& US11982 -  This method is used to update the Opportunity records with Rating status and WA based on Business Rule Validation Log status as either Failed or Passed
*   @Author : Akbar
*
*/
    public static void updateOppRatingStatusAndWA(List<Opportunity> opprs){
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> failedBROpp = new Map<Id,Opportunity>();
        List<Opportunity> failOpprList = new List<Opportunity>();
        Map<Id,Opportunity> passBROpp = new Map<Id,Opportunity>();
        List<Opportunity> passOpprList = new List<Opportunity>();
        List<Business_Rule_Validation_Log__c> brLogList = new List<Business_Rule_Validation_Log__c>();
        List<Opportunity> finalOpprToUpdate = new List<Opportunity>();
        Set<Id> brvfailOppSet = new Set<Id>();
        try{
            for(Opportunity opp :opprs){
                oppMap.put(opp.id,opp);
            }
            brLogList = [SELECT Id, OpportunityId__c,Status__c FROM Business_Rule_Validation_Log__c WHERE OpportunityId__c IN :oppMap.keySet()];
            for(Business_Rule_Validation_Log__c brLog : brLogList){
                
                if(!failedBROpp.containskey(brLog.OpportunityId__c) && (String.isNotBlank(brLog.Status__c) && brLog.Status__c.equalsIgnoreCase('Failed'))){
                    
                    failedBROpp.put(brLog.OpportunityId__c,oppMap.get(brLog.OpportunityId__c));
                }
            }
            if(failedBROpp!=null){
                failOpprList = failedBROpp.values();
                for(Opportunity failOppr : failOpprList){
                    failOppr.Rating_Status__c = 'Initiated'; //Need to check with BA
                    failOppr.SGR_Workflow_Activity__c = 'UW Review - Validation Errors';
                    finalOpprToUpdate.add(failOppr);
                }
            }
            brvfailOppSet = failedBROpp.keySet();
            for(Opportunity oppor :opprs){
                if(!brvfailOppSet.contains(oppor.id)){
                    passBROpp.put(oppor.id,oppor);
                }
            }
            if(passBROpp!=null){
                passOpprList = passBROpp.values();
                for(Opportunity passOppr : passOpprList){
                    passOppr.Rating_Status__c = 'Initiated';
                    finalOpprToUpdate.add(passOppr);
                }
            }
            if(finalOpprToUpdate!=null && finalOpprToUpdate.size()>0){
                update finalOpprToUpdate;
            }
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.updateOppRatingStatusAndWA', 'High');
        }
    }
    
    //SFDC-14541 - SGR: R11W - <= 50 Enrollees Check - Begin
    public static String checkSub50Enrollees(List<Opportunity> inputOpportunities, 
                                             String inputRuleName,
                                             String inputBatchId,
                                             map<id,List<SGR_Opportunity_Census__c>>inputOppCensus,
                                             List<SGRRenewalBatch__c> inputRenewBatchId,
                                             map<String,SGR_Business_Rule__c> inputBusinessRules,
                                             Map<id,List<SGR_Renewal_Batch_Oppty__c>>inputOppBatch) {
                                                 
                                                 Integer activeHealthSubsribers;                                                       
                                                 
                                                 String returnString;
                                                 List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
                                                 List<Business_Rule_Validation_Log__c> businessRuleValidationLog = new List<Business_Rule_Validation_Log__c>();
                                                 
                                                 SGR_Business_Rule__c aBusinessRule = new SGR_Business_Rule__c();
                                                 
                                                 //Ensure Rule for this Method is contained in the Rule Map
                                                 IF(inputBusinessRules.containsKey(inputRuleName)){
                                                     //Rule is present - Continue
                                                     aBusinessRule = inputBusinessRules.get(inputRuleName);
                                                 }ELSE{
                                                     //Rule is NOT present - no need to Continue
                                                     returnString = 'BR GR.EL.02 NOT present in Map of Rules.';
                                                     Return returnString;
                                                 }
                                                 
                                                 //Opportunity Loop
                                                 for (Opportunity anOpportunity: inputOpportunities) {
                                                     
                                                     Business_Rule_Validation_Log__c aBRVLogEntry = new Business_Rule_Validation_Log__c();
                                                     
                                                     aBRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                     aBRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                     aBRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                     
                                                     if (inputRenewBatchId.size() > 0) {
                                                         aBRVLogEntry.Batch_Id__c = inputRenewBatchId[0].Id;
                                                     } 
                                                     
                                                     activeHealthSubsribers = 0;
                                                     
                                                     List<SGR_Opportunity_Census__c> theCensusesForTheOpp = inputOppCensus.get(anOpportunity.Id);
                                                     
                                                     //Census Loop
                                                     for (SGR_Opportunity_Census__c anOppCensus: theCensusesForTheOpp) {
                                                         //Active 
                                                         if ((anOppCensus.Member_Cancel_Date__c > anOpportunity.Renewal_Date__c) || anOppCensus.Member_Cancel_Date__c == null){
                                                             //Subscribers
                                                             if(anOppCensus.Relationship_Code__c == 'Subscriber'){
                                                                 activeHealthSubsribers = activeHealthSubsribers + 1;                                                                        
                                                             }                                                                    
                                                         }
                                                     }                                                            
                                                     
                                                     //FAIL > 50
                                                     if (activeHealthSubsribers > 50){
                                                         aBRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                         aBRVLogEntry.Fail_Pass_Reason__c = '# Current Subscribers = ' + activeHealthSubsribers ;    
                                                         
                                                         //Add the Log Entry
                                                         businessRuleValidationLog.add(aBRVLogEntry);
                                                         continue; //Breaks out of this Opportunity Loop iteration
                                                     }
                                                     
                                                     //FAIL = 0
                                                     if (activeHealthSubsribers == 0){  
                                                         
                                                         aBRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                         aBRVLogEntry.Fail_Pass_Reason__c = 'No active Subscribers found';
                                                         
                                                         //Add the Log Entry
                                                         businessRuleValidationLog.add(aBRVLogEntry);
                                                         continue; //Breaks out of this Opportunity Loop iteration
                                                     }
                                                     
                                                     
                                                     //PASS <= 50 AND > 0
                                                     
                                                     if (activeHealthSubsribers <= 50){
                                                         aBRVLogEntry.Status__c = SGR_Constants.StatusPassed;
                                                         aBRVLogEntry.Fail_Pass_Reason__c = '# Current Subscribers = ' + activeHealthSubsribers;
                                                         
                                                         //Add the Log Entry
                                                         businessRuleValidationLog.add(aBRVLogEntry);
                                                         continue; //Breaks out of this Opportunity Loop iteration
                                                     }
                                                 }                                                        
                                                 
                                                 if (businessRuleValidationLog.size() > 0) {                                                        
                                                     try{
                                                         insert businessRuleValidationLog;
                                                         returnString = 'BR GR.EL.02 processed successfully.';
                                                     }catch(DmlException e){
                                                         CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelperdemo.Sub50Enrollees', 'High');                                                                
                                                         returnString = 'BR GR.EL.02 NOT processed successfully.';
                                                     }
                                                 }                                                        
                                                 Return returnString;                                                        
                                             }
    //SFDC-14541 - SGR: R11W - <= 50 Enrollees Check - End 
    //SFDC-14542 - SGR: R12W - Regulated & Health Subscriber in TX
    //Author: Landry Harris
    public static String getNumberOfHealthSubscribers(List<Opportunity> opps, String texasHealthSubs,
                                                      String BatchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                      List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,
                                                      Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
                                                          String result;      
                                                          List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();                             
                                                          try {
                                                              SGR_Business_Rule__c br = sbrmap.get(texasHealthSubs);
                                                              Integer healthSubCount; 
                                                              for (Opportunity o: opps) {
                                                                  healthSubCount = 0;
                                                                  Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                                                                  brv.AccountId__c = o.AccountId;
                                                                  if (RenewBatchId.size() > 0) {
                                                                      brv.Batch_Id__c = RenewBatchId[0].Id;
                                                                  }
                                                                  brv.BusinessRuleId__c = br.Id;    
                                                                  brv.OpportunityId__c = o.Id;
                                                                  for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                                                                  {
                                                                      brv.Renewal_Batch_Oppty_Id__c = srbo.name;
                                                                  }
                                                                  
                                                                  if (o.HCSC_Division__c == 'TX') {
                                                                      List<SGR_Opportunity_Census__c> oppCensuses = oppsgrogs.get(o.Id);
                                                                      
                                                                      //Census Loop
                                                                      for (SGR_Opportunity_Census__c oc: oppCensuses) {
                                                                          //Active 
                                                                          if (oc.Member_Effective_Date__c < Date.today() && (oc.Member_Cancel_Date__c > o.Renewal_Date__c || oc.Member_Cancel_Date__c == null)){
                                                                              //Subscribers
                                                                              if(oc.Relationship_Code__c == 'Subscriber' && oc.State__c == 'TX' && oc.Health_Plan_ID__c != null){
                                                                                  healthSubCount = healthSubCount + 1;                                                                        
                                                                              }                                                                    
                                                                          }
                                                                      }
                                                                      System.debug('Health sub count: ' + healthSubCount);
                                                                      if (healthSubCount > 0) {
                                                                          brv.Status__c = 'Passed';
                                                                          brv.Fail_Pass_Reason__c = '# of Health Subscribers in TX = ' + healthSubCount + '.';
                                                                      }
                                                                      else {
                                                                          brv.Status__c = 'Failed';
                                                                          brv.Fail_Pass_Reason__c = '# of Health Subscribers in TX = 0.';
                                                                      }
                                                                  }
                                                                  else {
                                                                      brv.Status__c = 'N/A';
                                                                      brv.Fail_Pass_Reason__c = 'N/A OK, NM, IL, MT';
                                                                  }
                                                                  bsrlst.add(brv);
                                                              }
                                                              if (bsrlst.size() > 0) {
                                                                  insert bsrlst;
                                                                  result = 'BR GR.DV.08 processed successfully.';
                                                              }
                                                              
                                                          }
                                                          catch (Exception ex) {
                                                              CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.getNumberOfHealthSubscribers', 'High');
                                                              result = 'BR GR.DV.08 NOT processed successfully.';
                                                          }
                                                          return result;
                                                      }
    
    //SFDC-14543 - SGR: R13W - Health vs.Contributory Dental - Begin
    public static String checkHealthvsContributoryDental(List<Opportunity> inputOpportunities, 
                                                         String inputRuleName,
                                                         String inputBatchId,
                                                         map<id,List<SGR_Opportunity_Census__c>>inputOppCensus,
                                                         List<SGRRenewalBatch__c> inputRenewBatchId,
                                                         map<String,SGR_Business_Rule__c> inputBusinessRules,
                                                         Map<id,List<SGR_Renewal_Batch_Oppty__c>>inputOppBatch) {
                                                             
                                                             Decimal activeHealthSubsribers;
                                                             Decimal activeDentalSubscriber;
                                                             Integer computedValue;
                                                             
                                                             String returnString;
                                                             
                                                             List<Business_Rule_Validation_Log__c> businessRuleValidationLog = new List<Business_Rule_Validation_Log__c>();
                                                             
                                                             SGR_Business_Rule__c aBusinessRule = new SGR_Business_Rule__c();
                                                             
                                                             //Ensure Rule for this Method is contained in the Rule Map
                                                             IF(inputBusinessRules.containsKey(inputRuleName)){
                                                                 //Rule is present - Continue
                                                                 aBusinessRule = inputBusinessRules.get(inputRuleName);
                                                             }ELSE{
                                                                 //Rule is NOT present - no need to Continue
                                                                 returnString = 'BR GR.EL.04 NOT present in Map of Rules.';
                                                                 Return returnString;
                                                             }                                                        
                                                             
                                                             //Opportunity Loop
                                                             for (Opportunity anOpportunity: inputOpportunities) {
                                                                 
                                                                 Business_Rule_Validation_Log__c aBRVLogEntry = new Business_Rule_Validation_Log__c();
                                                                 
                                                                 aBRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                                 aBRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                                 aBRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                                 
                                                                 if (inputRenewBatchId.size() > 0) {
                                                                     aBRVLogEntry.Batch_Id__c = inputRenewBatchId[0].Id;
                                                                 } 
                                                                 
                                                                 activeHealthSubsribers = 0;
                                                                 activeDentalSubscriber = 0;
                                                                 
                                                                 List<SGR_Opportunity_Census__c> theCensusesForTheOpp = inputOppCensus.get(anOpportunity.Id);
                                                                 
                                                                 //Health Only & Dental Only Idenfitied using the Opportunity.Product_Type__c Field
                                                                 //No need to do anything further as this should be N/A
                                                                 if((anOpportunity.Product_Type__c == 'H') || (anOpportunity.Product_Type__c == 'D')){
                                                                     aBRVLogEntry.Status__c = SGR_Constants.StatusNA;
                                                                     if(anOpportunity.Product_Type__c == 'H'){
                                                                         aBRVLogEntry.Fail_Pass_Reason__c = 'N/A Health Only';
                                                                     }
                                                                     if(anOpportunity.Product_Type__c == 'D'){
                                                                         aBRVLogEntry.Fail_Pass_Reason__c = 'N/A Dental Only';
                                                                     }
                                                                     businessRuleValidationLog.add(aBRVLogEntry);
                                                                     continue; //Breaks out of this Opportunity Loop iteration
                                                                 }
                                                                 
                                                                 //Census Loop
                                                                 for (SGR_Opportunity_Census__c anOppCensus: theCensusesForTheOpp) {
                                                                     if(anOppCensus.Total_Number_of_Health_Subscribers__c != null){
                                                                         activeHealthSubsribers = activeHealthSubsribers + anOppCensus.Total_Number_of_Health_Subscribers__c;                                                                    
                                                                     }
                                                                     if(anOppCensus.Total_Number_of_Dental_Subscribers__c != null){
                                                                         activeDentalSubscriber = activeDentalSubscriber + anOppCensus.Total_Number_of_Dental_Subscribers__c;
                                                                     }
                                                                 }
                                                                 
                                                                 //Can not divide by Zero.
                                                                 if(activeHealthSubsribers != 0 ){
                                                                     computedValue = (((activeHealthSubsribers.intValue() - activeDentalSubscriber.intValue()) /  activeHealthSubsribers.intValue()) * 100);
                                                                 }
                                                                 
                                                                 //FAIL
                                                                 if (computedValue <= -25 ){                                                                
                                                                     aBRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                                     aBRVLogEntry.Fail_Pass_Reason__c = 'Variation of enrollment between Health & Contributory Dental (' + computedValue + '%) is not within range.';
                                                                     businessRuleValidationLog.add(aBRVLogEntry);
                                                                     continue; //Breaks out of this Opportunity Loop iteration
                                                                 }                                                           
                                                                 
                                                                 //Fall-Thru Logic = Pass
                                                                 aBRVLogEntry.Status__c = SGR_Constants.StatusPassed;
                                                                 aBRVLogEntry.Fail_Pass_Reason__c = 'Variation of enrollment between Health & Contributory Dental (' + computedValue + '%) is within range.';
                                                                 businessRuleValidationLog.add(aBRVLogEntry);
                                                             }                                                        
                                                             
                                                             if (businessRuleValidationLog.size() > 0) {                                                        
                                                                 try{
                                                                     insert businessRuleValidationLog;
                                                                     returnString = 'BR GR.EL.04 processed successfully.';
                                                                 }catch(DmlException e){
                                                                     CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelperdemo.HealthvsContributoryDental', 'High');                                                                
                                                                     returnString = 'BR GR.EL.04 NOT processed successfully.';
                                                                 }
                                                             }                                                        
                                                             Return returnString;                                                        
                                                         }
    //SFDC-14543 - SGR: R13W - Health vs.Contributory Dental - End
    
    // nikhil sfdc - 14431
    
    //Author: nihkil jain
    //TODO:nikhil - DMLException/Exception handling , move status and reason text to SGR_Constants
    //checkForactivedentalsubscriber(opps, activedentalsubscriberlist, BatchId,oppsgrogs,RenewBatchId,sbrmap,oppsrbop,oppsgrobamap);
    public static String checkForactivedentalsubscriber(List<Opportunity> opps,
                                                        String activedentalsubscriberlist,
                                                        String BatchId,
                                                        map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                        List<SGRRenewalBatch__c> RenewBatchId,
                                                        map<String,SGR_Business_Rule__c> sbrmap,
                                                        Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop,
                                                        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1) {
                                                            
                                                            String ruleProcessMsg;
                                                            SGR_Business_Rule__c br = sbrmap.get(activedentalsubscriberlist);
                                                            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
                                                            Set<String> subscriberIds = new Set<String>(); 
                                                            Id acctId;
                                                            Id oppId;                                                          
                                                            //    boolean activeSubscriber = false; 
                                                            boolean count = false;
                                                            try {
                                                                for (Opportunity o: opps) {
                                                                    acctId = o.AccountId;
                                                                    oppId = o.Id; 
                                                                    Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                                                                    brv.AccountId__c = o.AccountId;
                                                                    if (RenewBatchId.size() > 0) {
                                                                        brv.Batch_Id__c = RenewBatchId[0].Id;
                                                                    }
                                                                    brv.BusinessRuleId__c = br.Id;    
                                                                    brv.OpportunityId__c = o.Id;
                                                                    System.debug('Business rule list: ' + bsrlst);
                                                                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                                                                    {
                                                                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                                    }
                                                                    List<SGR_Opportunity_Benefit_Agreement__c> benf = oppsgrobamap1.get(o.Id);
                                                                    if(benf.size()>0)
                                                                    {
                                                                        
                                                                        for(SGR_Opportunity_Benefit_Agreement__c oba1:benf)
                                                                        {
                                                                            if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'D')
                                                                            {
                                                                                if (count==true)
                                                                                {
                                                                                    break;
                                                                                }
                                                                                
                                                                                List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                                                if(censuses.size()>0)
                                                                                {
                                                                                    for (SGR_Opportunity_Census__c oc: censuses)
                                                                                    { 
                                                                                        //  system.debug('condition check start');
                                                                                        if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c > date.today())) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c <date.today() && oc.Dental_Plan_ID__c != Null)
                                                                                        {
                                                                                            //     system.debug('condition true');
                                                                                            
                                                                                            brv.Status__c = 'Passed';
                                                                                            brv.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement and active Dental Subscribers on Account.';
                                                                                            count=true;
                                                                                            break;
                                                                                        }
                                                                                        else 
                                                                                        {
                                                                                            //   system.debug('condition false');
                                                                                            brv.Status__c = 'Failed';
                                                                                            brv.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement but no active Dental Subcribers on Account.'; 
                                                                                        }
                                                                                        //      system.debug('condition End inside for');
                                                                                    }
                                                                                    //        system.debug('out side for');
                                                                                }
                                                                                else{
                                                                                    brv.Status__c = 'Failed';
                                                                                    brv.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement but no active Dental Subcribers on Account.';
                                                                                    
                                                                                }
                                                                            }
                                                                            else if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'H')
                                                                            {
                                                                                brv.Status__c = 'N/A';
                                                                                brv.Fail_Pass_Reason__c = 'N/A Health Only';
                                                                            }
                                                                            else
                                                                            { 
                                                                                brv.Status__c = 'N/A';
                                                                                brv.Fail_Pass_Reason__c = 'No Active Dental Benefit Agreement Found';
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    else
                                                                    { 
                                                                        //      System.debug('hello');
                                                                        brv.Status__c = 'N/A';
                                                                        brv.Fail_Pass_Reason__c = 'No BA Found'; 
                                                                    }
                                                                    bsrlst.add(brv);
                                                                }
                                                                insert bsrlst;                                                          
                                                                ruleProcessMsg = 'BR GR.DV.04 processed successfully.';                                                          
                                                            } 
                                                            
                                                            catch (Exception ex) {
                                                                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                                                                                  'Opportunity', null, 
                                                                                                  'SGR_validationHelperdemo.checkForactivedentalsubscriber AccountId: ' + acctId + ' Opportunity Id: ' + oppId, 'High');                                                          
                                                            }
                                                            
                                                            return ruleProcessMsg; 
                                                        }
    //end 14431
    
    // nikhil
    // sfdc- 14430 start //Code Commented for SAMPARTIAL Deployment 
    public static String checkForactiveHealthsubscriber(List<Opportunity> opps,
                                                        String activehealthsubscriber1,
                                                        String BatchId,
                                                        map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                        List<SGRRenewalBatch__c> RenewBatchId,
                                                        map<String,SGR_Business_Rule__c> sbrmap,
                                                        Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop,
                                                        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1) {
                                                            
                                                            String ruleProcessMsg;
                                                            SGR_Business_Rule__c br = sbrmap.get(activehealthsubscriber1);
                                                            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
                                                            Set<String> subscriberIds = new Set<String>(); 
                                                            Id acctId;
                                                            Id oppId;                                                          
                                                            boolean activeSubscriber = false; 
                                                            boolean count = false;
                                                            try {
                                                                for (Opportunity o: opps) {
                                                                    acctId = o.AccountId;
                                                                    oppId = o.Id; 
                                                                    Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                                                                    brv.AccountId__c = o.AccountId;
                                                                    if (RenewBatchId.size() > 0) {
                                                                        brv.Batch_Id__c = RenewBatchId[0].Id;
                                                                    }
                                                                    brv.BusinessRuleId__c = br.Id;    
                                                                    brv.OpportunityId__c = o.Id;
                                                                    System.debug('Business rule list: ' + bsrlst);
                                                                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                                                                    {
                                                                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                                    }
                                                                    List<SGR_Opportunity_Benefit_Agreement__c> benf = oppsgrobamap1.get(o.Id);
                                                                    if(benf.size()>0)
                                                                    {
                                                                        for(SGR_Opportunity_Benefit_Agreement__c oba1:benf)
                                                                        {
                                                                            if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'H')
                                                                            {
                                                                                if (count==true)
                                                                                {
                                                                                    break;
                                                                                }
                                                                                
                                                                                List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                                                if(censuses.size()>0)
                                                                                {
                                                                                    for (SGR_Opportunity_Census__c oc: censuses)
                                                                                    { 
                                                                                        if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c > date.today())) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c <date.today() && oc.Health_Plan_ID__c != Null)
                                                                                        {
                                                                                            
                                                                                            brv.Status__c = 'Passed';
                                                                                            brv.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement and active Dental Subscribers on Account.';
                                                                                            count=true;
                                                                                            break;
                                                                                        }
                                                                                        else 
                                                                                        {
                                                                                            brv.Status__c = 'Failed';
                                                                                            brv.Fail_Pass_Reason__c = 'Active Family Health Benefit Agreement but no active Health Subcribers on Account.'; 
                                                                                        }     
                                                                                    }
                                                                                }
                                                                                else
                                                                                {
                                                                                    brv.Status__c = 'Failed';
                                                                                    brv.Fail_Pass_Reason__c = 'Active Family Health Benefit Agreement but no active Health Subcribers on Account.';
                                                                                    
                                                                                }
                                                                            }
                                                                            else if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'D')
                                                                            {
                                                                                brv.Status__c = 'N/A';
                                                                                brv.Fail_Pass_Reason__c = 'N/A Dental Only';
                                                                            }
                                                                            else
                                                                            {
                                                                                brv.Status__c = 'N/A';
                                                                                brv.Fail_Pass_Reason__c = 'No Active Health Benefit agreement found';
                                                                            }
                                                                        }
                                                                    }
                                                                    else
                                                                    {
                                                                        brv.Status__c = 'N/A';
                                                                        brv.Fail_Pass_Reason__c = 'No BA Found';   
                                                                        
                                                                    }
                                                                    bsrlst.add(brv);
                                                                }
                                                                insert bsrlst;                                                          
                                                                ruleProcessMsg = 'BR GR.DV.03 processed successfully.';                                                          
                                                            } 
                                                            
                                                            catch (Exception ex) {
                                                                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                                                                                  'Opportunity', null, 
                                                                                                  'SGR_validationHelperdemo.checkForactiveHealthsubscriber AccountId: ' + acctId + ' Opportunity Id: ' + oppId, 'High');                                                          
                                                            }
                                                            
                                                            return ruleProcessMsg; 
                                                        }  
    //Code Commented for SAMPARTIAL Deployment
    //end 14430
    
    
    //Code Commented for SAMPARTIAL Deployment END
    //SFDC-14509 - SGR: R6W - Existing Production Opportunity - Begin
    public static String checkOtherOpenOpportunities(List<Opportunity> inputOpportunities,
                                                     List<Opportunity> inputExistingOpps, 
                                                     String inputRuleName,
                                                     String inputBatchId,                                                    
                                                     List<SGRRenewalBatch__c> inputRenewBatchId,
                                                     map<String,SGR_Business_Rule__c> inputBusinessRules){
                                                         
                                                         System.debug('SGR_validationHelperdemo.otherOpenOpportunities()');
                                                         
                                                         String returnString;
                                                         
                                                         List<Business_Rule_Validation_Log__c> businessRuleValidationLog = new List<Business_Rule_Validation_Log__c>();
                                                         
                                                         SGR_Business_Rule__c aBusinessRule = new SGR_Business_Rule__c();
                                                         
                                                         //Ensure Rule for this Method is contained in the Rule Map
                                                         IF(inputBusinessRules.containsKey(inputRuleName)){
                                                             //Rule is present - Continue
                                                             aBusinessRule = inputBusinessRules.get(inputRuleName);
                                                         }ELSE{
                                                             //Rule is NOT present - no need to Continue
                                                             returnString = 'BR GR.DV.16 NOT present in Map of Rules.';
                                                             System.debug('SGR_validationHelperdemo.otherOpenOpportunities returnString: '+ returnString);
                                                             Return returnString;
                                                         }
                                                         
                                                         //Opportunity Loop                                                        
                                                         for (Opportunity anOpportunity: inputOpportunities) {
                                                             
                                                             Business_Rule_Validation_Log__c aBRVLogEntry = new Business_Rule_Validation_Log__c();
                                                             
                                                             if (inputRenewBatchId.size() > 0) {
                                                                 aBRVLogEntry.Batch_Id__c = inputRenewBatchId[0].Id;
                                                             } 
                                                             
                                                             String possibleDupes = '';
                                                             
                                                             aBRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                             aBRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                             aBRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                             
                                                             //If there are no existing Opps then this is a Pass
                                                             if(inputExistingOpps.isEmpty()){
                                                                 aBRVLogEntry.Status__c = SGR_Constants.StatusPassed;  
                                                                 aBRVLogEntry.Fail_Pass_Reason__c = 'Most recent Production Opty is complete.';
                                                                 businessRuleValidationLog.add(aBRVLogEntry);
                                                                 //Break the loop and move to next Opportunity
                                                                 continue;
                                                             }else{
                                                                 Integer possibleDupeCount = 0;
                                                                 //Loop thru the existing Opportunties and examine for criteria
                                                                 for(Opportunity existingOpportunity : inputExistingOpps){                                                                
                                                                     if(anOpportunity.AccountId == existingOpportunity.AccountId){
                                                                         if(anOpportunity.Renewal_Date__c == existingOpportunity.Renewal_Date__c){
                                                                             if(existingOpportunity.Rating_Status__c != 'Closed'||existingOpportunity.Rating_Status__c != 'Finalized'){
                                                                                 //Only identify the first 5 Possible Duplicates 
                                                                                 if(possibleDupeCount <= 5){
                                                                                     possibleDupes = possibleDupes + ' ' + existingOpportunity.Id;
                                                                                     possibleDupes = possibleDupes.trim();                                                                               
                                                                                     possibleDupeCount = possibleDupeCount + 1;
                                                                                 }
                                                                             }  
                                                                         }
                                                                     }                                                                
                                                                 }                                                                
                                                             }
                                                             
                                                             if(String.isNotBlank(possibleDupes)){
                                                                 //Found Possible Duplicates
                                                                 aBRVLogEntry.Status__c = SGR_Constants.StatusFailed;  
                                                                 aBRVLogEntry.Fail_Pass_Reason__c = 'This renewal may be impacted by another in-process Production Opty: ' + possibleDupes  ;
                                                                 businessRuleValidationLog.add(aBRVLogEntry);                                          
                                                             }else{
                                                                 //No Possible Duplicates Found
                                                                 aBRVLogEntry.Status__c = SGR_Constants.StatusPassed;  
                                                                 aBRVLogEntry.Fail_Pass_Reason__c = 'Most recent Production Opty is complete.';
                                                                 businessRuleValidationLog.add(aBRVLogEntry);
                                                             }                                                        
                                                         }
                                                         
                                                         if (businessRuleValidationLog.size() > 0) {                                                        
                                                             try{
                                                                 insert businessRuleValidationLog;
                                                                 returnString = 'BR GV.DV.16 processed successfully.';
                                                             }catch(DmlException e){
                                                                 CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelperdemo.otherOpenOpportunities', 'High');                                                                
                                                                 returnString = 'BR GV.DV.16 NOT processed successfully.';
                                                             }
                                                         }                                                                                          
                                                         
                                                         System.debug('SGR_validationHelperdemo.otherOpenOpportunities returnString: '+ returnString);
                                                         Return returnString;
                                                     }
    //SFDC-14543 - SGR: R6W - Existing Production Opportunity - End
    /************************************************
US Name: SFDC-14535
SGR: Active Benefit Agreement renewal date and opportunity date check.
Author: Roopa
Date:11/14/2018.
**************************************************/
    public static String activeBenefitAgreementDatecheck(List<Opportunity> accs,String BatchId,String DateCheck,map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)  
    {
        String msg;
        system.debug('List of Opportunity'+accs);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        //List<SGR_Opportunity_Benefit_Agreement__c> sobfaactive = List<SGR_Opportunity_Benefit_Agreement__c>();
        List<String> tempList = new List<String>();
        Set<String> tempSet = new Set<String>();
        Set<String> tempSet1 = new Set<String>();
        Set<String> tempSet3 = new Set<String>();
        try{
            if(accs!=null && accs.size()>0){
                for(opportunity opp: accs)
                { 
                    Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                    List<SGR_Opportunity_Benefit_Agreement__c> sobfaactive = oppsgrobamap1.get(opp.Id);
                    system.debug('condition start');
                    if(sobfaactive.size()>0) // Checking opp benefit aggreement is present or not.
                    {
                        system.debug('condition true');
                        for(SGR_Opportunity_Benefit_Agreement__c sgrs1:oppsgrobamap1.get(opp.Id))
                        {
                            if(sgrs1.Status__c =='Active' && sgrs1.Renewal_Date__c!=null)
                            {
                                Date myDate=sgrs1.Renewal_Date__c;
                                String str1 = String.valueOf(myDate);// accepts date string in YYYY-MM-dd format. or use parse
                                String str2 = sgrs1.Status__c;
                                tempList.add(str1);
                                System.debug('@@@@@@@@@@@@tempList'+tempList);
                                tempSet.addAll(tempList);
                                tempSet1.add(str2);
                            }
                           /* else{
                                String str3 = sgrs1.Status__c;
                                //brv.Status__c='Failed';
                                //brv.Fail_Pass_Reason__c='No active benefit agreement found.';
                                if(str3!='Active'){
                                    tempSet3.add(str3);
                                }
                            }*/
                        }     
                        system.debug('condition Ends');
                        system.debug('list of ba'+tempSet);
                        if(tempSet!=null && tempSet.size()==1){
                            brv.Status__c='Passed';
                            brv.Fail_Pass_Reason__c=sbrmap.get(DateCheck).Proposed_wording_pass__c;
                        }else{
                            brv.Status__c='Failed';
                            brv.Fail_Pass_Reason__c='All the active BA do not have the same renewal date or status.';
                        }
                    }
                    else
                    {
                        system.debug('condition fails');
                        brv.Status__c='Failed';
                        brv.Fail_Pass_Reason__c='No active benefit agreement found.';
                    }
                    system.debug('condition fails display');
                    brv.AccountId__c=opp.AccountId;
                    brv.OpportunityId__c=opp.Id;
                    brv.BusinessRuleId__c=sbrmap.get(DateCheck).id;
                    if(RenewBatchId.size()>0)
                    {
                        brv.Batch_Id__c=RenewBatchId[0].id;
                    }
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(opp.id))
                    {
                        brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    system.debug('list of ba'+tempSet);
                    
                    bsrlst.add(brv);
                    system.debug('final business rule validation log list'+bsrlst);
                }
                system.debug('final business rule validation log list'+bsrlst);
                insert bsrlst;
                system.debug('list of ba'+bsrlst);
                msg='Insertion done.';        
            }  
        }
        catch(System.NullPointerException e )
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.activeBenefitAgreementcheck', 'High');                                                           
            system.debug(e);
        }
        return msg;    
    }//END-14535  
    
    
    //check for When the account has a divison of TX and invitro plans
    //US14539
    //developer:Raghavender Goud Nellikondi
    //checkInvitroplans(opps,Invitro1,BatchId,sbrmap,RenewBatchId,oppsrbop,oppsgrogs1,oppsgrobamap);
    public Static String checkInvitroplans(List<Opportunity> opps,
                                           String Invitro,
                                           String BatchId,
                                           map<String,SGR_Business_Rule__c> sbrmap,
                                           List<SGRRenewalBatch__c> RenewBatchId,
                                           Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop,
                                           map<id,List<SGR_Opportunity_Group_Section__c>>oppsgrogs1,
                                           map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap)
    {
        String msg;
        SGR_Business_Rule__c br = sbrmap.get(Invitro);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        boolean PassFail = false;
        Integer count1=0;
        Integer count2=0;
        
        try{
            for(Opportunity oss :opps)
            {
                
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                brv.AccountId__c = oss.AccountId;
                if (RenewBatchId.size() > 0) {
                    brv.Batch_Id__c = RenewBatchId[0].Id;
                }
                brv.BusinessRuleId__c = br.Id;    
                brv.OpportunityId__c = oss.Id;
                System.debug('Business rule list: ' + br);
                
                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                {
                    brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                }
                if(oss.HCSC_Division__c=='TX')
                {
                    System.debug('Inside TX devision ');
                    List<SGR_Opportunity_Group_Section__c> sgrgs1 = oppsgrogs1.get(oss.Id);
                    if(sgrgs1.size()>0)
                    {
                    for(SGR_Opportunity_Group_Section__c sgrgs:sgrgs1)
                    {
                            System.debug('Inside group section ');
                            if(sgrgs.Invitro__c == true) 
                            {
                                PassFail=true;
                                count1=1;
                            }
                            else
                            {
                                PassFail=false;
                                count2=2;
                                break;
                            }
                      }
                    }
                    else
                    {
                        brv.Status__c='N/A';
                        brv.Fail_Pass_Reason__c='No Group Section found';
                        break;
                    }
                    
                    System.debug('Passfail' +Passfail);
                  //  if (PassFail==true)
                  //  {
                   //     brv.Status__c='Passed';
                   //     brv.Fail_Pass_Reason__c='The account has all active Invitro health plan(s)'; 
                   // }
                    //else
                   // {
                        List<SGR_Opportunity_Benefit_Agreement__c> oppsgrbagr1 = oppsgrobamap.get(oss.id);
                        for(SGR_Opportunity_Benefit_Agreement__c oppsgrbagr:oppsgrbagr1)
                        {
                            if(oppsgrbagr!=null)
                            {  
                                if(oppsgrbagr.Insurance_Type_Code__c=='H')
                                {
                                                if(count1==1 && count2==2) 
                                                {
                                                    brv.Status__c='Failed';
                                                    brv.Fail_Pass_Reason__c='The account has at least one active Invitro and at least one active non-Invitro health plan(s)';
                                                    break;
                                                }
                                                else if(count2==2 && count1==0) 
                                                {
                                                    brv.Status__c='passed';
                                                    brv.Fail_Pass_Reason__c='The account has all Inactive Invitro Health Plans';
                                                    break;
                                                }
                                                else if(count2==0 && count1==1) 
                                                {
                                                    brv.Status__c='passed';
                                                    brv.Fail_Pass_Reason__c='The account has all active Invitro Health Plans';
                                                    break;
                                                }
                                            
                                                else
                                                     {
                                                brv.Status__c='N/A';
                                                brv.Fail_Pass_Reason__c='The account does not have any active or Inactive Invitro health plans';
                                                     }
                                }
                                      else if(oppsgrbagr.Insurance_Type_Code__c=='D')
                                    {
                                        brv.Status__c='N/A';
                                        brv.Fail_Pass_Reason__c='Dental Only';
                                        break;
                                        
                                    }
                                    else
                                    {
                                         brv.Status__c='N/A';
                                        brv.Fail_Pass_Reason__c='Not Applicable';
                                    }
                                    
                                
                            }
                        }
                        
                    //}
                }
                else
                {
                    System.debug('outside TX devision ');
                    brv.Status__c='N/A';
                    brv.Fail_Pass_Reason__c='The Account has a division of IL or OK or NM or MT';
                }
                bsrlst.add(brv);
            }
            insert bsrlst;                                                          
            msg = 'BR GR.DV.19 processed successfully.'; 
        }
        catch(Exception e)
        {
            system.debug('came into catch'+e) ;
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.checkInvitroplans', 'High');
        }
        
        return msg;
    }
    //SFDC-14433: SGR:R3W - Non-COBRA Under 16 
    //Author: Shalini
    
    public static String checkforNonCobraSubsribers(List<Opportunity> opps,
                                                    String nonCobraSubscriber,
                                                    String BatchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                    List<SGRRenewalBatch__c> RenewBatchId,
                                                    map<String,SGR_Business_Rule__c> sbrmap,
                                                    map<Id, List<SGR_Opportunity_Member_Benefits__c>> benefits,
                                                    Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) 
    {
        String ruleProcessMsg;
        SGR_Business_Rule__c br = sbrmap.get(nonCobraSubscriber);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        Set<String> subscriberIds = new Set<String>(); 
        Id acctId;
        Id oppId;                                                          
        boolean activeSubscriber = false; 
        boolean rulePass = false;
        boolean ruleFailOne = false;                                                         
        boolean ruleFailTwo = false; 
        try {
            for (Opportunity o: opps) {
                acctId = o.AccountId;
                oppId = o.Id;
                rulePass = false;
                ruleFailOne = false;                                                         
                ruleFailTwo = false; 
                Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                brv.AccountId__c = o.AccountId;
                if (RenewBatchId.size() > 0) {
                    brv.Batch_Id__c = RenewBatchId[0].Id;
                }
                brv.BusinessRuleId__c = br.Id;    
                brv.OpportunityId__c = o.Id;
                System.debug('Business rule list1: ' + bsrlst);
                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                {
                    brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                }
                System.debug('condition start ');  
                List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                for (SGR_Opportunity_Census__c oc: censuses) {
                    system.debug('in cencus');
                    List<SGR_Opportunity_Member_Benefits__c> oppMemberBenefits = benefits.get(oc.Id);
                    for (SGR_Opportunity_Member_Benefits__c omb: oppMemberBenefits) {
                        system.debug('in mbaand condition start');
                        if ((oc.Member_Effective_Date__c < Date.today()) && (oc.Member_Cancel_Date__c > Date.today())) {
                            activeSubscriber = true;
                            system.debug('adate check');
                        }
                        
                        if (activeSubscriber == true && oc.Membership_Number__c == 1) {
                            ruleFailTwo = true;
                            system.debug('active subscriber check');
                        }
                        if(((o.Renewal_Date__c.year() - oc.Date_of_Birth__c.year()) < 16 && oc.Relationship_Code__c!='Domestic Partner') || (oc.Employee_Status_Code__c!='Cobra' && 
                                                                                                                                             (oc.Relationship_Code__c!='Subcsriber')) || ((oc.Employee_Status_Code__c!='Cobra' && oc.Relationship_Code__c!='Spouse'))) 
                            //Searching if there is no  non cobra subscriber, spouse or dp under 16 year of age
                        {
                            subscriberIds.add(omb.Subscriber_Number__c);
                            ruleFailOne = true;
                            system.debug('cobra check');
                        } 
                        
                        system.debug('condition 1 end');
                    }  
                    system.debug('cencus end');
                }
                system.debug('all check check');
                List<String> uniqueIds = new List<String>(subscriberIds);
                String joinedIds = String.join(uniqueIds, ', ');
                //check boolean values to see if rule should mark as pass or fail
                
                if (ruleFailOne==true && ruleFailTwo==true) {
                    brv.Status__c = SGR_Constants.StatusPassed;
                    brv.Fail_Pass_Reason__c = 'Pass #1: There are no Non-COBRA Subscribers, Spouse, or DP under 16 years of age.';
                }
                else {
                    if (ruleFailOne==true && ruleFailTwo==false) {
                        brv.Status__c = SGR_Constants.StatusFailed;
                        brv.Fail_Pass_Reason__c = 'Fail #2: No active subscribers found.';
                        
                    }
                    else if (ruleFailOne==false && ruleFailTwo==true) {
                        brv.Status__c = SGR_Constants.StatusFailed;
                        brv.Fail_Pass_Reason__c = 'Fail #1: A Non-COBRA Subscriber, Spouse, or DP under 16 years of age.\nSubscriber Number = ' + joinedIds + '.';
                    }
                    else if (ruleFailOne==false && ruleFailTwo==false) {
                        brv.Status__c = SGR_Constants.StatusFailed;
                        brv.Fail_Pass_Reason__c = 'Fail #1: A Non-COBRA Subscriber, Spouse, or DP under 16 years of age.\nSubscriber Number = ' + joinedIds + '.\n\nFail #2: No active subscribers found';
                    }
                }
                bsrlst.add(brv);
            }
            insert bsrlst;                                                          
            ruleProcessMsg = 'BR GR.DV.05 processed successfully.';                                                          
        } 
        
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                              'Opportunity', null, 
                                              'SGR_validationHelperdemo.checkforNonCobraSubsribers' + oppId, 'High'); 
            ruleProcessMsg = 'BR GR.DV.05 processed unsuccessfully.';                                                         
        }
        
        return ruleProcessMsg;
    }
    /************************************************
US Name: SFDC-14510
SGR: A Retired subscriber exists
Author: Roopa
Date:11/20/2018.
**************************************************/
    public static String activeRetiredsubscriberexist(List<Opportunity> accs,String BatchId,String Retiredexist,map<id,List<SGR_Opportunity_Census__c>> oppcensus,List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        system.debug('List of Opportunity'+accs);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        try{
            if(accs!=null && accs.size()>0){
                for(opportunity opp: accs)
                { 
                    String Division=opp.HCSC_Division__c;
                    Business_Rule_Validation_Log__c brv = new Business_Rule_Validation_Log__c();
                    List<SGR_Opportunity_Census__c> oppcenLST = oppcensus.get(opp.Id);
                    system.debug('condition start');
                    if(oppcenLST!=null && oppcenLST.size()>0) 
                    {
                        for(SGR_Opportunity_Census__c cens:oppcenLST){
                            if(Division!=null && Division.equalsIgnoreCase('IL')){
                                if((cens.Relationship_Code__c!=null && cens.Relationship_Code__c!='Subscriber') && (cens.Employee_Status_Code__c!=null && !cens.Employee_Status_Code__c.equalsIgnoreCase('Retired'))){
                                    brv.Status__c='Passed';
                                    brv.Fail_Pass_Reason__c=sbrmap.get(Retiredexist).Proposed_wording_pass__c;
                                }else{
                                    brv.Status__c='N/A';
                                    brv.Fail_Pass_Reason__c='N/A';
                                }
                            }
                            else if(Division!=null && (Division.equalsIgnoreCase('NM') || Division.equalsIgnoreCase('TX'))){
                                if((cens.Relationship_Code__c!=null && cens.Relationship_Code__c!='Subscriber') && (cens.Employee_Status_Code__c!=null && !cens.Employee_Status_Code__c.equalsIgnoreCase('Retired'))){
                                    brv.Status__c='Passed';
                                    brv.Fail_Pass_Reason__c=sbrmap.get(Retiredexist).Proposed_wording_pass__c;
                                }else{
                                    brv.Status__c='Failed';
                                    brv.Fail_Pass_Reason__c='A Retired subscriber cannot exist in an Opty within a Regulated Market Segment.  Subscriber = '+cens.Relationship_Code__c;
                                }
                                
                            }else if(Division!=null && Division.equalsIgnoreCase('MT')){
                                if((cens.Relationship_Code__c!=null && cens.Relationship_Code__c!='Subscriber') && (cens.Employee_Status_Code__c!=null && !cens.Employee_Status_Code__c.equalsIgnoreCase('Retired'))){
                                    brv.Status__c='Passed';
                                    brv.Fail_Pass_Reason__c=sbrmap.get(Retiredexist).Proposed_wording_pass__c;
                                }else{
                                    brv.Status__c='Failed';
                                    brv.Fail_Pass_Reason__c='A Retired subscriber cannot exist in an Opty located within a Non Municipality account. Subscriber ='+cens.Relationship_Code__c;
                                }
                            }else{
                                if((cens.Relationship_Code__c!=null && cens.Relationship_Code__c!='Subscriber') && (cens.Employee_Status_Code__c!=null && !cens.Employee_Status_Code__c.equalsIgnoreCase('Retired'))){
                                    brv.Status__c='Passed';
                                    brv.Fail_Pass_Reason__c=sbrmap.get(Retiredexist).Proposed_wording_pass__c;
                                }else{
                                    brv.Status__c='Failed';
                                    brv.Fail_Pass_Reason__c='A Retired subscriber cannot exist in an Opty located within a Non Public Entity account.  Subscriber ='+cens.Relationship_Code__c;
                                }
                            }
                            system.debug('ADDING TO LIST');
                            brv.AccountId__c=opp.AccountId;
                            brv.OpportunityId__c=opp.Id;
                            brv.BusinessRuleId__c=sbrmap.get(Retiredexist).id;
                            if(RenewBatchId.size()>0)
                            {
                                brv.Batch_Id__c=RenewBatchId[0].id;
                            }
                            for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(opp.id))
                            {
                                brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                            }
                            bsrlst.add(brv);
                            system.debug('final business rule validation log list'+bsrlst);
                        }
                    }
                    else
                    {
                        system.debug('condition fails');
                        brv.Status__c='Failed';
                        brv.Fail_Pass_Reason__c='No active subscribers found';
                        system.debug('condition fails display');
                        brv.AccountId__c=opp.AccountId;
                        brv.OpportunityId__c=opp.Id;
                        brv.BusinessRuleId__c=sbrmap.get(Retiredexist).id;
                        if(RenewBatchId.size()>0)
                        {
                            brv.Batch_Id__c=RenewBatchId[0].id;
                        }
                        for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(opp.id))
                        {
                            brv.Renewal_Batch_Oppty_Id__c=srbo.name;
                        }  
                        bsrlst.add(brv);
                        system.debug('final business rule validation log list'+bsrlst);
                    }
                }
                system.debug('final business rule validation log list'+bsrlst);
                insert bsrlst;
                system.debug('list of ba'+bsrlst);
                msg='Insertion done.';         
            }
        }
        catch(System.NullPointerException e )
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.activeRetiredsubscriberexist', 'High');                                                           
            system.debug(e);
        }
        return msg;    
    }//END-14510
    /*
    public Static String ESTiresValidationAkbar(List<Opportunity> opps,                   
                                           String ESTireSpouseDomesticPartner,
                       String BatchId,map<id,List<SGR_Opportunity_Census__c>> oppsgrogs,
                                           List<SGRRenewalBatch__c> RenewBatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                            try{
                                                   String ruleProcessMsg;
                           boolean isNoActiveSubscribers = true;
                           boolean isNoEStiersExists = false;
                           boolean isAllESAndDPCensus = false;
                           SGR_Business_Rule__c br = sbrmap.get(ESTireSpouseDomesticPartner);
                           List<SGR_Opportunity_Census__c> activeSubList = new List<SGR_Opportunity_Census__c>();
                           Map<id,List<SGR_Opportunity_Census__c>> activeSubMap = new Map<id,List<SGR_Opportunity_Census__c>>();
                           List<SGR_Opportunity_Census__c> esTierList = new List<SGR_Opportunity_Census__c>();
                           Map<id,List<SGR_Opportunity_Census__c>> esTierMap = new Map<id,List<SGR_Opportunity_Census__c>>();
                           List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
                          for(Opportunity oss: opps){
                            Business_Rule_Validation_Log__c BRVLog = new Business_Rule_Validation_Log__c();
                            for(SGR_Opportunity_Census__c OpptyCensus:oppsgrogs.get(oss.Id)){
                              if((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<date.today()) && (OpptyCensus.Member_Cancel_Date__c>date.today() || OpptyCensus.Member_Cancel_Date__c==null) ){
                                isNoActiveSubscribers = false;
                                if(!activeSubMap.containsKey(oss.id)){
                                  activeSubList = new List<SGR_Opportunity_Census__c>();
                                  activeSubList.add(OpptyCensus);
                                  activeSubMap.put(oss.id,activeSubList);
                                }else{
                                  activeSubMap.get(oss.id).add(OpptyCensus);
                                }
                                
                              }
                              
                            }
                            if(isNoActiveSubscribers){
                              BRVLog.Status__c='Failed';
                                                            BRVLog.Fail_Pass_Reason__c ='No active subscribers found';
                            }else{
                              List<SGR_Opportunity_Census__c> actSubList = activeSubMap.get(oss.Id);
                              for(SGR_Opportunity_Census__c OpptyCens:actSubList){
                                if((String.isNotBlank(OpptyCens.Dental_Tier__c) && OpptyCens.Dental_Tier__c!='ES') && (String.isNotBlank(OpptyCens.Health_Tier__c) && OpptyCens.Health_Tier__c!='ES') && (String.isNotBlank(OpptyCens.Vision_Tier__c) && OpptyCens.Vision_Tier__c!='ES')){
                                  isNoEStiersExists = true;
                                }else{
                                  if(!esTierMap.containsKey(oss.id)){
                                    esTierList = new List<SGR_Opportunity_Census__c>();
                                    esTierList.add(OpptyCens);
                                    esTierMap.put(oss.id,esTierList);
                                  }else{
                                    esTierList.get(oss.id).add(OpptyCens);
                                  }
                                }
                              }
                              if(isNoEStiersExists){
                                BRVLog.Status__c='N/A';
                                                                BRVLog.Fail_Pass_Reason__c = 'No ES tiers';
                              }else{
                                for(SGR_Opportunity_Census__c esTierCens:esTierMap.get(oss.Id)){
                                  
                                  if(esTierCens.Relationship_Code__c=='Spouse' || esTierCens.Relationship_Code__c=='Domestic Partner'){
                                    BRVLog.Status__c='Passed';
                                    BRVLog.Fail_Pass_Reason__c = 'No Invalid Employee Spouse tier exists.';
                                    
                                  }else{
                                    BRVLog.Status__c='Failed';
                                    BRVLog.Fail_Pass_Reason__c = 'Invalid Employee Spouse tier exists.  Subscriber Number =' + esTierCens.Subscriber_Number__c;
                                    break;
                                  }
                                }
                              }
                            }
                            BRVLog.AccountId__c = oss.AccountId;
                                                        if (RenewBatchId.size() > 0) {
                                                            BRVLog.Batch_Id__c = RenewBatchId[0].Id;
                                                        }
                                                        BRVLog.BusinessRuleId__c = br.Id;    
                                                        BRVLog.OpportunityId__c = oss.Id;
                                                        for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                                                        {
                                                            BRVLog.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                        }
                            bsrlst.add(BRVLog);
                          }
                          if(bsrlst!=null && bsrlst.size()>0)
                            insert bsrlst;

                                                }
                                               catch (Exception ex) {
                                                   CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelperdemo.ESTiresValidation', 'High');
                                                   ruleProcessMsg = 'BR GR.DV.12 processed unsuccessfully.';
                                               }
                                               return ruleProcessMsg;
                                               
  } */
}