//Guidelines
//TODO: All - NO QUERIES INSIDE RULES
//TODO: Wrapper class to use as input to all rules
//Anil -- Used ShippingState field instead of ShippingState__c in the State Validation Rule
public class SGR_validationHelper {
    public static boolean firsttime = false;
    
    public SGR_validationHelper(List<Opportunity> opps, String batchId )
    { 
        list<Business_Rule_Validation_Log__c> bRV =[select id from Business_Rule_Validation_Log__c where  OpportunityId__c IN:opps];
        
        try{
            if(bRV.size()>0 && bRV!=null) {
                delete bRV;
                
                callingMethods(opps,batchId);
                //US12536 & US11982 - This method is used to update Opportunity records with Rating Status and Workflow Activity based on failed Business rule valdations for respective Opportunites.
                updateOppRatingStatusAndWA(opps);
                Reinitiationbussrulesagg(opps);
            }
            else
            {
                callingMethods(opps,batchId);
                //US12536 & US11982 - This method is used to update Opportunity records with Rating Status and Workflow Activity based on failed Business rule valdations for respective Opportunites.
                updateOppRatingStatusAndWA(opps);
                reinitiationbussrules(opps);
            }
            // End
        }catch(Exception e){
            e.getMessage();
        }
    }
    //Code added to Test BR Frame work
    public static String callingMethods(List<Opportunity> opps, String batchId) {
        String msg;
        map<String,SGR_Business_Rule__c> sbrmap = new  map<String,SGR_Business_Rule__c>();
       // List<SGR_Business_Rule__c> br=[select id,Rule_Code__c,Proposed_wording_fail__c,Proposed_wording_pass__c from SGR_Business_Rule__c ];
        for (SGR_Business_Rule__c sa:[select id,Rule_Code__c,Proposed_wording_fail__c,Proposed_wording_pass__c from SGR_Business_Rule__c ]){
            sbrmap.put(sa.Rule_Code__c,sa);
        }
        
        map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        map<id,List<SGR_Opportunity_Group_Section__c>>oppsgrogs1 = new map<id,List<SGR_Opportunity_Group_Section__c>>();  
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();  
        map<id,List<SGR_Opportunity_Census__c>> oppsgrogs = new map<id,List<SGR_Opportunity_Census__c>>();
        map<Id, List<SGR_Opportunity_Member_Benefits__c>> benefits = new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
        List<SGR_Opportunity_Census__c> optyCens = new List<SGR_Opportunity_Census__c>();
        
        //Data Lake does not populate ShippingState__C, hence using ShippingState -- Anil Kamisetty 27 Jan 2019
        List<opportunity> lstopp = [SELECT Id, name, Account.ShippingState,Batch_Id__c,Funding_Type__c, AccountId,HCSC_Division__c, (SELECT Id, Name ,Batch_Id__c from SGR_Renewal_Batch_Opptys__r),(SELECT Id, Name,Insurance_Type_Code__c,Status__c,Renewal_Date__c FROM Opportunity_Benefit_Agreements__r),(SELECT id,Name,Account__c,Opportunity__c,Employee_Status_Code__c,Relationship_Code__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c,Relationship__c, Subscriber_number__c, Date_of_Birth__c,Total_Number_of_Health_Subscribers__c,Total_Number_of_Dental_Subscribers__c,Vision_Tier__c,Health_Tier__c,Dental_Tier__c, State__c,Dental_Plan_ID__c, Health_Plan_ID__c FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c,Invitro__c FROM Opportunity_Group_Section__r) FROM opportunity where (id IN:opps AND Batch_Id__c=:batchId)];
        
        //Create a List of Account Id include on the incoming Opportunity List
        List<Id> listAccountIds = new List<Id>();
        For(Opportunity anOpportunity : lstopp){
            listAccountIds.add(anOpportunity.AccountId);
        }
        //Get any Opportunities for the Accounts that are NOT in the List of Opportunities being processed
        List<opportunity> listExistingOpps = [SELECT Id, RecordTypeId, Name, AccountId, Renewal_Date__c, Rating_Status__c FROM Opportunity WHERE (Id NOT IN :opps AND AccountId in :listAccountIds )];//Issue is with this query , this will never be empty.
        
        //Keeping all the child objects related opportunity in a Map
        for(Opportunity os :lstopp) {            
            oppsrbop.put(os.id,os.SGR_Renewal_Batch_Opptys__r);
            oppsgrobamap.put(os.id, os.Opportunity_Benefit_Agreements__r);
            oppsgrogs.put(os.id,os.Opportunity_Census__r);
            oppsgrogs1.put(os.id,os.Opportunity_Group_Section__r);
            optyCens = os.Opportunity_Census__r;
        }
       // List<SGR_Opportunity_Census__c> memBenefits = new List<SGR_Opportunity_Census__c>();
        
        if (optyCens.size() > 0) {
           /* memBenefits = [Select Id, (Select Id, Name, Member_Policy_Tier__c, Subscriber_Number__c
                                       From Opportunity_Member_Benefits__r)
                           from SGR_Opportunity_Census__c where Id IN :optyCens];*/
            for (SGR_Opportunity_Census__c oc : [Select Id, (Select Id, Name, Member_Policy_Tier__c, Subscriber_Number__c
                                       From Opportunity_Member_Benefits__r)
                           from SGR_Opportunity_Census__c where Id IN :optyCens]) {
                benefits.put(oc.Id, oc.Opportunity_Member_Benefits__r);
            }
        }
        List<SGRRenewalBatch__c> renewbatchId = new List<SGRRenewalBatch__c>();
        renewbatchId=[select Id,batchId__c from SGRRenewalBatch__c where batchId__c =:batchId];
        
        String activeBAC ='GR.DV.01';
        String activeSubscriberRule ='GR.DV.02';
        String activehealthsubscriber1='GR.DV.03';
        String activedentalsubscriberlist = 'GR.DV.04';
        String ziprule = 'GR.DV.06';
        String countyrule ='GR.DV.07';
        String memberOver99 = 'GR.DV.08';
        String employeeOnlyDependentsRule ='GR.DV.09';
        String morePartners = 'GR.DV.10';
        String dependentsexistwithnorelationshipcode='GR.DV.11';
        string eSTireSpouseDomesticPartner='GR.DV.12';
        string eCTireChild='GR.DV.13';
        String eFTireFamily='GR.DV.14';
        String fundingTypeRule = 'GR.DV.15';
        String inProcessOpps='GR.DV.16';
        String dateCheck ='GR.DV.18';//SFDC-14535
        String invitro1='GR.DV.19';
        String stateCodeRule = 'GR.EL.01';
        String sGLessThan50 = 'GR.EL.02';
        String texasHealthSubs = 'GR.EL.03';
        String healthvsContributory = 'GR.EL.04';
        String nonCobraSubscriber = 'GR.DV.05';
        String retiredexist ='GR.DV.17';//SFDC-14510
        
        // Start of method calls:
        checkCountyCode(opps,countyrule,batchId,renewbatchId,sbrmap,oppsrbop);
        checkZipCode(opps,ziprule,batchId,renewbatchId,sbrmap,oppsrbop);
        checkForDependentsForEmployeeOnlyTier(opps, employeeOnlyDependentsRule, batchId,oppsgrogs,renewbatchId,sbrmap,benefits,oppsrbop);
        activeSubscribercheck(opps,activeSubscriberRule,batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop);
        activeBenefitAgreementcheck(opps,batchId,activeBAC,oppsgrobamap,renewbatchId,sbrmap,oppsrbop);
        checkForSpouseOrDP(opps, oppsgrogs, batchId, morePartners, renewbatchId, sbrMap, oppsrbop);
        checkSub50Enrollees(opps,sGLessThan50,batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop);
        checkhealthvsContributoryDental(opps,healthvsContributory,batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop);
        checkOtherOpenOpportunities(opps,listExistingOpps,inProcessOpps,batchId,renewbatchId,sbrmap);
        activeBenefitAgreementdateCheck(opps,batchId,dateCheck,oppsgrobamap,renewbatchId,sbrmap,oppsrbop);//SFDC-14535
        activeRetiredsubscriberexist(opps,batchId,retiredexist,oppsgrogs,renewbatchId,sbrmap,oppsrbop);//SFDC-14510
        checkMembershipAge(opps,memberOver99,batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop);
        checkForPremiumFundingType(opps,fundingTypeRule,sbrmap,batchId,renewbatchId,oppsrbop);
        dependentswithNoRelationshipCodeValidation(opps,optyCens,dependentsexistwithnorelationshipcode,sbrmap,batchId,renewbatchId,oppsrbop);
        eSTiresValidation(opps,optyCens,eSTireSpouseDomesticPartner,sbrmap,batchId,renewbatchId,oppsrbop);
        ECTireWithoutChildValidation(opps,optyCens,eCTireChild,sbrmap,batchId,renewbatchId,oppsrbop);
        eFTireWithoutFamilyValidation(opps,optyCens,eFTireFamily,sbrmap,batchId,renewbatchId,oppsrbop);
        checkStateCode(opps,stateCodeRule,sbrmap,batchId,renewbatchId,oppsrbop);
        getNumberOfHealthSubscribers(opps,texasHealthSubs,batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop);
        checkInvitroplans(opps,invitro1,batchId,sbrmap,renewbatchId,oppsrbop,oppsgrogs1,oppsgrobamap);
        checkForactivedentalsubscriber(opps, activedentalsubscriberlist, batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop,oppsgrobamap);
        checkForactiveHealthsubscriber(opps, activehealthsubscriber1, batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop,oppsgrobamap);
        checkforNonCobraSubsribers(opps, nonCobraSubscriber, batchId,oppsgrogs,renewbatchId,sbrmap,benefits,oppsrbop);
        return msg;
    }
    
    
    //check for zip code size
    //US14164
    //developer:santosh
    public static Boolean checkZipCode(List<Opportunity> accs,String ziprule,String batchId,List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) 
    {
        
        Matcher zipcodeMatcher;
        String msg;
        try{
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            for(Opportunity os:accs)
            {
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                String zipCode=String.valueOf(os.Zip_Code__c);
                Pattern zipcodePattern = Pattern.compile('^[0-9]{5,9}(-[0-9]{4})?$');
                zipcodeMatcher = zipcodePattern.matcher(zipCode);
                if(zipcodeMatcher.matches()==true && (os.Zip_Code__c.length()==5 || os.Zip_Code__c.length()==9) && os.Zip_Code__c.length()!=0)
                {
                    
                    bRV.AccountId__c=os.AccountId;
                    bRV.Status__c='Passed';
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    bRV.Fail_Pass_Reason__c=sbrmap.get(ziprule).Proposed_wording_pass__c;
                    bRV.BusinessRuleId__c=sbrmap.get(ziprule).id;
                    
                    if(renewbatchId.size()>0){
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    bRV.OpportunityId__c=os.Id;
                    
                    bsrlst.add(bRV);
                }
                
                else{
                    bRV.AccountId__c=os.AccountId;
                    bRV.Status__c=' Failed';
                    String propwordfail=sbrmap.get(ziprule).Proposed_wording_fail__c+'Zipcode value:'+os.Zip_Code__c;
                    
                    bRV.Fail_Pass_Reason__c=propwordfail;
                    bRV.BusinessRuleId__c=sbrmap.get(ziprule).id;
                    
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    if(renewbatchId.size()>0){
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    bRV.OpportunityId__c=os.Id;
                    
                    bsrlst.add(bRV); 
                }
            }
            
            database.insert(bsrlst);
            msg='Insertion done.';
        }
        catch(Exception e)
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.checkZipCode', 'High');                                                           
        }
        // return zipcodeMatcher.matches();
        return true;
    }
 
    //SFDC-14079: SGR: checkCountyCode
    //Author:Santosh
    public static String checkCountyCode(List<Opportunity> accs,String countyrule,String batchId,List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        try{
            List<SGR_Business_Rule__c> br = new List<SGR_Business_Rule__c>();
            
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            
            for(Opportunity os:accs)
            {
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                
                if(os.County_Code__c=='' ||os.County_Code__c==NULL)
                {
                    
                    bRV.AccountId__c=os.AccountId;
                    bRV.Status__c='Failed';
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    bRV.Fail_Pass_Reason__c=sbrmap.get(countyrule).Proposed_wording_fail__c;
                    bRV.BusinessRuleId__c=sbrmap.get(countyrule).id;
                    
                    if(renewbatchId.size()>0){
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    bRV.OpportunityId__c=os.Id;
                    
                    bsrlst.add(bRV);
                }
                
                else{
                    bRV.AccountId__c=os.AccountId;
                    bRV.Status__c=' Passed';
                    
                    bRV.Fail_Pass_Reason__c=sbrmap.get(countyrule).Proposed_wording_pass__c;
                    bRV.BusinessRuleId__c=sbrmap.get(countyrule).id;
                    
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(os.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    
                    
                    if(renewbatchId.size()>0){
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    bRV.OpportunityId__c=os.Id;
                    
                    bsrlst.add(bRV); 
                }
                
            }
            database.insert(bsrlst);
            msg='Insertion done.';
            
        }
        
        catch(Exception e)
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.checkCountyCode', 'High');                                                           
            
        }
        return msg; 
    }
    //SFDC-14081: SGR: activeBenefitAgreementcheck
    //Author: Sreedhar
    public static String activeBenefitAgreementcheck(List<Opportunity> accs,String batchId,String activeBAC1,map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1,List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        try{
            
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            List<SGR_Opportunity_Benefit_Agreement__c> sobfaactive = new List<SGR_Opportunity_Benefit_Agreement__c> ();
            
            for(opportunity oss: accs)
            { 
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
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
                    bRV.AccountId__c=oss.AccountId;
                    bRV.Status__c='Passed';
                    if(renewbatchId.size()>0)
                    {
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    bRV.OpportunityId__c=oss.Id;
                    bRV.Fail_Pass_Reason__c=sbrmap.get(activeBAC1).Proposed_wording_pass__c;
                    bRV.BusinessRuleId__c=sbrmap.get(activeBAC1).id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    bsrlst.add(bRV);
                }
                
                else{
                    bRV.AccountId__c=oss.AccountId;
                    bRV.Status__c='Failed';
                    if(renewbatchId.size()>0)
                    {
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    bRV.OpportunityId__c=oss.Id;
                    bRV.Fail_Pass_Reason__c=sbrmap.get(activeBAC1).Proposed_wording_fail__c;
                    bRV.BusinessRuleId__c=sbrmap.get(activeBAC1).id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    
                    bsrlst.add(bRV); 
                }
                
            }
            
            database.insert(bsrlst);
            msg='Insertion done.';
            sobfaactive.clear();
            
        }
        catch(System.NullPointerException e )
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.activeBenefitAgreementcheck', 'High');                                                           
            
        }
        return msg;    
    }
    //SFDC-14080: SGR: Active Subscribers Check
    //Author: Saurav Gupta
   public static String activeSubscribercheck(List<Opportunity> opps,String activeSubscriberRule,String batchId,map<id,List<SGR_Opportunity_Census__c>> oppsgrogs,List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        try{
            
            
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            
            
            for (Opportunity oss: opps) {
                Boolean activeSubFound = false;
                //id ide1 = opp.id;
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                if(oppsgrogs.get(oss.Id).size() > 0)
                {
                    for(SGR_Opportunity_Census__c oc:oppsgrogs.get(oss.Id))
                    {
                        if(oc.id != NULL){
                            
                            
                            if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c >= oss.Renewal_Date__c)) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c != null && oc.Member_Effective_Date__c <=oss.Renewal_Date__c)
                            {
                            	activeSubFound = true;
                            	
                            }
                          
                        }
                    }
                     bRV.AccountId__c=oss.AccountId;
                                
                     if(renewbatchId.size()>0)
                     {
                     	bRV.Batch_Id__c = renewbatchId[0].Id;
                     }
                     bRV.BusinessRuleId__c=sbrmap.get(activeSubscriberRule).id;
                    bRV.OpportunityId__c = oss.Id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    if (activeSubFound==true) {
                    	bRV.Status__c='Passed';	
                        bRV.Fail_Pass_Reason__c=sbrmap.get(activeSubscriberRule).Proposed_wording_pass__c;
                    } else {
                    	bRV.Status__c='Failed';
                        bRV.Fail_Pass_Reason__c=sbrmap.get(activeSubscriberRule).Proposed_wording_fail__c;
                    }
                    bsrlst.add(bRV);
                    
                } else {
                    bRV.AccountId__c=oss.AccountId;
                    if(renewbatchId.size()>0){
                        bRV.Batch_Id__c = renewbatchId[0].Id;
                    }
                    bRV.Fail_Pass_Reason__c=sbrmap.get(activeSubscriberRule).Proposed_wording_fail__c;
                    bRV.BusinessRuleId__c=sbrmap.get(activeSubscriberRule).id;
                    bRV.OpportunityId__c = oss.Id;
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    bRV.Status__c='Failed';
                    
                    bsrlst.add(bRV);
                }                
            }
            insert bsrlst;
            msg='Insertion done.';
            
        }
        catch(Exception e)
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.activeSubscribercheck', 'High');                                                           
            
        }
        return msg;
    } 
    //SFDC-14082: SGR: R4E - Dependents for Employee Only Tier
    //Author: Landry Harris
    //TODO:LANDRY - DMLException/Exception handling , move status and reason text to SGR_Constants
    public static String checkForDependentsForEmployeeOnlyTier(List<Opportunity> opps,
                                                               String employeeOnlyDependentsRule,
                                                               String batchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                               List<SGRRenewalBatch__c> renewbatchId,
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
                                                                           Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                                           bRV.AccountId__c = o.AccountId;
                                                                           if (renewbatchId.size() > 0) {
                                                                               bRV.Batch_Id__c = renewbatchId[0].Id;
                                                                           }
                                                                           bRV.BusinessRuleId__c = br.Id;    
                                                                           bRV.OpportunityId__c = o.Id;
                                                                           for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                                                                           {
                                                                               bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                                           }
                                                                           List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                                           for (SGR_Opportunity_Census__c oc: censuses) {
                                                                               List<SGR_Opportunity_Member_Benefits__c> oppMemberBenefits = benefits.get(oc.Id);
                                                                               for (SGR_Opportunity_Member_Benefits__c omb: oppMemberBenefits) {
                                                                                   if ((oc.Member_Effective_Date__c < =o.Renewal_Date__c) && (oc.Member_Cancel_Date__c >= o.Renewal_Date__c)) {
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
                                                                               bRV.Status__c = SGR_Constants.StatusPassed;
                                                                               bRV.Fail_Pass_Reason__c = br.Proposed_wording_pass__c;
                                                                           }
                                                                           else {
                                                                               if (ruleFailOne && !ruleFailTwo) {
                                                                                   //TODO:Landry example of using constants
                                                                                   bRV.Status__c = SGR_Constants.StatusFailed;
                                                                                   bRV.Fail_Pass_Reason__c = 'Dependents exist for an \'Employee Only\' tier.\nSubscriber Number = ' + joinedIds + '.';
                                                                               }
                                                                               else if (!ruleFailOne && ruleFailTwo) {
                                                                                   bRV.Status__c = SGR_Constants.StatusFailed;
                                                                                   bRV.Fail_Pass_Reason__c = 'No active subscribers found.';
                                                                               }
                                                                               else if (ruleFailOne && ruleFailTwo) {
                                                                                   bRV.Status__c = SGR_Constants.StatusFailed;
                                                                                   bRV.Fail_Pass_Reason__c = 'Fail #1: Dependents exist for an \'Employee Only\' tier.\nSubscriber Number = ' + joinedIds + '.\n\nFail #2: Scenario 2: No active subscribers found';
                                                                               }
                                                                           }
                                                                           bsrlst.add(bRV);
                                                                       }
                                                                       insert bsrlst;                                                          
                                                                       ruleProcessMsg = 'BR GR.DV.09 processed successfully.';                                                          
                                                                   } 
                                                                   
                                                                   catch (Exception ex) {
                                                                       CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                                                                                         'Opportunity', null, 
                                                                                                         'SGR_validationHelper.checkForDependentsForEmployeeOnlyTier AccountId: ' + acctId + ' Opportunity Id: ' + oppId, 'High');                                                          
                                                                   }
                                                                   
                                                                   
                                                                   return ruleProcessMsg;
                                                               } 
    
    /*private static void createbRVLog(string recId, string passMesg, string failMesg){
Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
}*/
    //vijaya SFDC-14083 start
    public static String checkForSpouseOrDP(List<Opportunity> opps, map<id,List<SGR_Opportunity_Census__c>> optyCenGrp, 
                                            string batchId, String ruleId, List<SGRRenewalBatch__c> renbatchId,  Map<String,SGR_Business_Rule__c> bRules, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
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
                                                    List<Id> censusIds = new List<Id>();
                                                    boolean ruleFailOne;                                                         
                                                    boolean rulePass2; 
                                                    boolean rulePass1;
                                                    boolean activeSubscriber;  
                                                    for(Opportunity optys : opps){
                                                        
                                                        fail = new List<string>();
                                                        pass = new List<string>();
                                                        pass2 = new List<string>();
                                                        ruleFailOne = false;                                                         
                                                        rulePass2 = false; 
                                                        rulePass1 = false;
                                                        activeSubscriber = false;  
                                                        List<Decimal> subscriberIds = new List<Decimal>();
                                                        Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                        bRV.AccountId__c = optys.AccountId;
                                                        if(renbatchId.size() >0){
                                                            bRV.Batch_Id__c = renbatchId[0].Id;
                                                        }
                                                        bRV.OpportunityId__c = optys.Id;
                                                        bRV.BusinessRuleId__c = bRules.get(ruleId).id;
                                                        for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(optys.id))
                                                        {
                                                            bRV.Renewal_Batch_Oppty_Id__c = srbo.name;
                                                        }
                                                        List<SGR_Opportunity_Census__c> censuses = optyCenGrp.get(optys.Id);
                                                        //Validate if the census exists or not
                                                        if(censuses.size() == 0){
                                                            bRV.Status__c = SGR_Constants.StatusFailed;
                                                            bRV.Fail_Pass_Reason__c = 'Fail #2: No active subscribers found';
                                                        }
                                                        Map<decimal, List<SGR_Opportunity_Census__c>> memMap = new Map<decimal, List<SGR_Opportunity_Census__c>>();
                                                        for (SGR_Opportunity_Census__c oc: censuses) { 
                                                           
                                                            if(oc.Relationship__c == 'Subscriber'){
                                                                
                                                                if((oc.Member_Effective_Date__c <= optys.Renewal_Date__c) && (oc.Member_Cancel_Date__c >=optys.Renewal_Date__c)) {
                                                                    activeSubscriber = true;
                                                                }
                                                                
                                                                if(memMap.containskey(oc.Subscriber_number__c)){
                                                                    continue;
                                                                }
                                                                else{
                                                                    List<SGR_Opportunity_Census__c> lstCens= new List<SGR_Opportunity_Census__c>();
                                                                    memMap.put(oc.Subscriber_number__c, lstCens);
                                                                }    
                                                            }
                                                            else{
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
                                                        
                                                        for(Decimal keyS : memMap.keySet()){
                                                            spouseCount = 0;
                                                            dpCount = 0;                                                            
                                                            rulePass1 = false;
                                                            rulePass2 = false;
                                                            ruleFailOne = false;
                                                            List<SGR_Opportunity_Census__c> lstCens = memMap.get(keyS);
                                                            Decimal cenSubNumber;
                                                            for(SGR_Opportunity_Census__c opCs : lstCens){
                                                                if(opCs.Relationship__c == 'Spouse'){
                                                                    spouseCount++;
                                                                    cenSubNumber = opCs.Subscriber_number__c;
                                                                }
                                                                else if(opCs.Relationship__c == 'Domestic Partner'){
                                                                    dpCount++;
                                                                    cenSubNumber = opCs.Subscriber_number__c;
                                                                }
                                                            }
                                                            
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
                                                                subscriberIds.add(cenSubNumber);
                                                                fail.add('fail');
                                                            }
                                                        }
                                                        String joinedIds = String.join(subscriberIds, ', ');
                                                        
                                                        if(fail.size()>0 && activeSubscriber == true){
                                                            bRV.Status__c = SGR_Constants.StatusFailed;
                                                            bRV.Fail_Pass_Reason__c = 'Fail #1: More than one Dependent with relationship type of "S" or "DP".   Subscriber Number = '+joinedIds;
                                                        }
                                                        else if(pass.size()>0 && activeSubscriber == true){
                                                            bRV.Status__c = SGR_Constants.StatusPassed;
                                                            bRV.Fail_Pass_Reason__c = 'Pass: Only one Dependent has a relationship code of "S" or "DP"';//bRule.Proposed_wording_pass__c; 
                                                        }
                                                        else if(pass2.size()>0 && activeSubscriber == true){
                                                            bRV.Status__c = SGR_Constants.StatusNA;
                                                            bRV.Fail_Pass_Reason__c = 'N/A: No "ES" tiers';
                                                        }
                                                        else if(activeSubscriber == false){
                                                            bRV.Status__c = SGR_Constants.StatusFailed;
                                                            bRV.Fail_Pass_Reason__c = 'Fail #2: No active subscribers found';
                                                        }                                                        
                                                        bRVs.add(bRV);
                                                    }
                                                    if(bRVs.size() > 0){
                                                        insert bRVs;
                                                        value = 'BR GR.DV.10 processed successfully.'; 
                                                    }
                                                    
                                                } catch(Exception e)
                                                { 
                                                    CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'Vijaja_sgr_validationM.checkForSpouseOrDP', 'High');                                                          
                                                }
                                                return value;
                                            } 
    //Vijaya SFDC-14083 End
    
    //SFDC-14508: SGR: R5W - Funding Type is NOT Premium
    //Author: Landry Harris
    public static String checkForPremiumFundingType(List<Opportunity> opps, String fundingTypeRule, Map<String,SGR_Business_Rule__c> sbrmap, String batchId, List<SGRRenewalBatch__c> renewbatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
        String ruleProcessMsg;
        try {
            SGR_Business_Rule__c br = sbrmap.get(fundingTypeRule);
            List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
            for (Opportunity o: opps) {
                
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                bRV.AccountId__c = o.AccountId;
                if (renewbatchId.size() > 0) {
                    bRV.Batch_Id__c = renewbatchId[0].Id;
                }
                bRV.BusinessRuleId__c = br.Id;    
                bRV.OpportunityId__c = o.Id;
                for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                {
                    bRV.Renewal_Batch_Oppty_Id__c = srbo.name;
                }
                
                if (o.Funding_Type__c == 'PREM') {
                    bRV.Status__c = SGR_Constants.StatusPassed;
                    bRV.Fail_Pass_Reason__c = br.Proposed_wording_pass__c;
                } 
                else {
                    bRV.Status__c = SGR_Constants.StatusFailed;
                    bRV.Fail_Pass_Reason__c = br.Proposed_wording_fail__c;
                }
                bsrlst.add(bRV);
            }
            insert bsrlst;
            ruleProcessMsg = 'BR GR.DV.15 processed successfully.';
        }
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.checkForPremiumFundingType', 'High');
            ruleProcessMsg = 'BR GR.DV.15 processed unsuccessfully.';
        }
        return ruleProcessMsg;
    }
    
    //Anudeep  
    
    //SFDC-14084: SGR: R6E - Dependents w/ No Relationship Code 
    //Author: Anudeep
    public Static String dependentswithNoRelationshipCodeValidation(List<Opportunity> oppList,List<SGR_Opportunity_Census__c> sGROpptyCensusList, String deptsexistwithnorelationshipcode, 
                                                                    Map<String,SGR_Business_Rule__c> sbrmap, String batchId, List<SGRRenewalBatch__c> renewbatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                                        String ruleProcessMsg;
                                                                        boolean failCondation=false;
                                                                        boolean passcondation=false;
                                                                        boolean nACondation=false;
                                                                        boolean activesubscribers=false;
                                                                        boolean eSTierCondation=false;
                                                                        boolean eCTierCondation=false;
                                                                        boolean eFTierCondation=false;
                                                                        set<boolean> aCCMemberBenefits=new set<boolean>();
                                                                        set<String> aCCIDSet=new set<String>();
                                                                        Set<string> subscriberIds=new Set<String>();
                                                                        set<Id> subcscriberSet=new set<Id>();
                                                                        try{
                                                                            
                                                                            List<Business_Rule_Validation_Log__c> busRuleValidationLogList = new List<Business_Rule_Validation_Log__c>();
                                                                            Map<String,SGR_Account_Member_Benefit__c> accMemberBenefitMap=new Map<String,SGR_Account_Member_Benefit__c>();
                                                                            
                                                                            
                                                                            //Dental Tier Set
                                                                            set<String> eSTierSet =new set<String>{'ES'};
                                                                                set<String> eCTierSet =new set<String>{'EC'};
                                                                                    set<String> eFTierSet =new set<String>{'EF'};
                                                                                        String eSTirer='';
                                                                            String eCTirer='';
                                                                            String eFTirer='';
                                                                            set<String> spouseDependentset =new set<String>{'Spouse','Domestic Partner','SPS','DP','Child'};
                                                                                Map<String,String> spouseDependentMap =new Map<String,String>();
                                                                            Map<String,String> spouseDependentFamilyMap =new Map<String,String>();
                                                                            SpouseDependentMap.put('Spouse','ES');
                                                                            SpouseDependentMap.put('Domestic Partner','ES');
                                                                            SpouseDependentMap.put('DP','ES');
                                                                            SpouseDependentMap.put('SPS','ES');
                                                                            SpouseDependentMap.put('Child','EC');
                                                                            SpouseDependentFamilyMap.put('Spouse','EF');
                                                                            SpouseDependentFamilyMap.put('Domestic Partner','EF');
                                                                            SpouseDependentFamilyMap.put('DP','EF');
                                                                            SpouseDependentFamilyMap.put('SPS','EF');
                                                                            SpouseDependentFamilyMap.put('Child','EF');
                                                                            SpouseDependentFamilyMap.put('DEP','EF');
                                                                            
                                                                            
                                                                            if(!oppList.isEmpty()){
                                                                                for(Opportunity oPPS : oppList){
                                                                                    Business_Rule_Validation_Log__c bRVL=new Business_Rule_Validation_Log__c();
                                                                                    bRVL.AccountId__c=OPPS.AccountId;
                                                                                    bRVL.OpportunityId__c=OPPS.Id;
                                                                                    if(!sGROpptyCensusList.isEmpty()){
                                                                                        
                                                                                        
                                                                                        for(SGR_Opportunity_Census__c opptyCensus : sGROpptyCensusList){
                                                                                            if(OPPS.Id==OpptyCensus.Opportunity__c){
                                                                                                subscriberIds.add(String.valueOf(OpptyCensus.Subscriber_Number__c));
                                                                                                if(((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<=OPPS.Renewal_Date__c) && (OpptyCensus.Member_Cancel_Date__c>=OPPS.Renewal_Date__c || OpptyCensus.Member_Cancel_Date__c==null))){
                                                                                                    Activesubscribers=true;
                                                                                                    if(OpptyCensus.Dental_Tier__c=='ES'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        ESTierCondation=true;
                                                                                                        ESTirer='ES';
                                                                                                    }else if(OpptyCensus.Health_Tier__c=='ES'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        ESTierCondation=true;
                                                                                                        ESTirer='ES';
                                                                                                    }
                                                                                                    else if(OpptyCensus.Vision_Tier__c=='ES'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        ESTierCondation=true;
                                                                                                        ESTirer='ES';
                                                                                                    }
                                                                                                    if(OpptyCensus.Dental_Tier__c=='EC'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        ECTierCondation=true;
                                                                                                        ECTirer='EC';
                                                                                                    }else if(OpptyCensus.Health_Tier__c=='EC'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        ECTierCondation=true;
                                                                                                        ECTirer='EC';
                                                                                                    }
                                                                                                    else if(OpptyCensus.Vision_Tier__c=='EC'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        ECTierCondation=true;
                                                                                                        ECTirer='EC';
                                                                                                    }
                                                                                                    if(OpptyCensus.Dental_Tier__c=='EF'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        EFTierCondation=true;
                                                                                                        EFTirer='EF';
                                                                                                    }else if(OpptyCensus.Health_Tier__c=='EF'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        EFTierCondation=true;
                                                                                                        EFTirer='EF';
                                                                                                    }
                                                                                                    else if(OpptyCensus.Vision_Tier__c=='EF'){
                                                                                                        SubcscriberSet.add(OpptyCensus.id);
                                                                                                        EFTierCondation=true;
                                                                                                        EFTirer='EF';
                                                                                                    }
                                                                                                    
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                        }
                                                                                        
                                                                                        if(Activesubscribers){
                                                                                            for(SGR_Opportunity_Census__c opptycens : sGROpptyCensusList){
                                                                                                if(sGROpptyCensusList.size()==1){NACondation=true;}
                                                                                                if(!SubcscriberSet.contains(opptycens.id)){
                                                                                                    if(opptycens.Membership_Number__c>1){
                                                                                                        if(opptycens.Relationship_Code__c!=null){
                                                                                                            if((SpouseDependentMap.get(opptycens.Relationship_Code__c)==ESTirer) || (SpouseDependentFamilyMap.get(opptycens.Relationship_Code__c)==EFTirer) || (SpouseDependentMap.get(opptycens.Relationship_Code__c)==ECTirer)){
                                                                                                                Passcondation=true;
                                                                                                                
                                                                                                            }else{
                                                                                                                FailCondation=true;
                                                                                                            }
                                                                                                        }else{
                                                                                                            FailCondation=true;
                                                                                                        }
                                                                                                    }else{
                                                                                                        
                                                                                                        if((ESTierCondation || ECTierCondation || EFTierCondation) && !Passcondation && !FailCondation && !SubcscriberSet.contains(opptycens.id)){
                                                                                                            NACondation=true;
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }else{
                                                                                        Activesubscribers=false;
                                                                                    }
                                                                                    List<String> uniqueIds = new List<String>(subscriberIds);
                                                                                    String joinedIds = String.join(uniqueIds, ', ');
                                                                                    if(FailCondation){
                                                                                        Passcondation=false;
                                                                                        NACondation=false;
                                                                                        bRVL.Status__c='Failed';
                                                                                        bRVL.Fail_Pass_Reason__c = 'Tier type of ES/EC/EF has a Dependent with no relationship type code Subscriber Number ='+joinedIds;
                                                                                    }
                                                                                    if(Passcondation){
                                                                                        bRVL.Status__c='Passed';
                                                                                        bRVL.Fail_Pass_Reason__c = 'All Dependents have relationship codes';
                                                                                    }
                                                                                    if(NACondation){
                                                                                        bRVL.Status__c='N/A';
                                                                                        bRVL.Fail_Pass_Reason__c = 'No dependents';
                                                                                    }
                                                                                    if(!Activesubscribers){
                                                                                        bRVL.Status__c='Failed';
                                                                                        bRVL.Fail_Pass_Reason__c = 'No active subscribers found';
                                                                                    }
                                                                                    
                                                                                    bRVL.BusinessRuleId__c=sbrmap.get(deptsexistwithnorelationshipcode).Id;
                                                                                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OPPS.Id))
                                                                                    {
                                                                                        bRVL.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                                    }
                                                                                    if (renewbatchId.size() > 0) {
                                                                                        bRVL.Batch_Id__c = renewbatchId[0].Id;
                                                                                    }
                                                                                    BusRuleValidationLogList.add(bRVL);
                                                                                    if(!BusRuleValidationLogList.isEmpty()){
                                                                                        Insert BusRuleValidationLogList;
                                                                                        ruleProcessMsg='BR GR.DV.11 processed successfully.';
                                                                                    }
                                                                                    
                                                                                    //}
                                                                                }
                                                                            }
                                                                            
                                                                            
                                                                        } catch (Exception ex) {
                                                                            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.dependentswithNoRelationshipCodeValidation', 'High');
                                                                            ruleProcessMsg = 'BR GR.DV.11 processed unsuccessfully.';
                                                                        }
                                                                        return ruleProcessMsg;
                                                                    }
    //Anudeep
    //14085 SGR: R7E - ES Tier with no Spouse or DP
    public Static String eSTiresValidation(list<Opportunity> inputListOpportunity,
                                           List<SGR_Opportunity_Census__c> inputListOpportunityCensus,                   
                                           String inputRuleName, 
                                           Map<String,SGR_Business_Rule__c> inputBusinessRules, 
                                           String inputbatchId, 
                                           List<SGRRenewalBatch__c> inputListRenewBatch, 
                                           Map<id,List<SGR_Renewal_Batch_Oppty__c>> inputListOppBatch){
                                               
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
                                                   returnString = 'BR GR.DV.12 NOT present in Map of Rules.';
                                                   
                                                   Return returnString;
                                               }
                                               
                                               for(Opportunity anOpportunity : inputListOpportunity){
                                                   
                                                   Business_Rule_Validation_Log__c abRVLogEntry = new Business_Rule_Validation_Log__c();
                                                   
                                                   abRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                   abRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                   abRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                   
                                                   if (inputListRenewBatch.size() > 0) {
                                                       abRVLogEntry.Batch_Id__c = inputListRenewBatch[0].Id;
                                                   } 
                                                   
                                                   List <SGR_Opportunity_Census__c> listActiveSubscribers = new List<SGR_Opportunity_Census__c>();
                                                   
                                                   for(SGR_Opportunity_Census__c anOpportunityCensus: inputListOpportunityCensus){
                                                       if(SGR_Constants.setSubscriberValues.contains(anOpportunityCensus.Relationship__c)){
                                                           if((anOpportunityCensus.Member_Effective_Date__c <= anOpportunity.Renewal_Date__c) && (anOpportunityCensus.Member_Cancel_Date__c >= anOpportunity.Renewal_Date__c || anOpportunityCensus.Member_Cancel_Date__c == null)){
                                                               listActiveSubscribers.add(anOpportunityCensus);
                                                           }
                                                       }
                                                   }       
                                                   
                                                   
                                                   List <SGR_Opportunity_Census__c> listActiveSubscribersWithESTiers = new List<SGR_Opportunity_Census__c>();
                                                   
                                                   for(SGR_Opportunity_Census__c anOpportunityCensus: inputListOpportunityCensus){
                                                       
                                                       if(!SGR_Constants.setSubscriberValues.contains(anOpportunityCensus.Relationship__c)){
                                                           //not Subscriber, skips to the next iteration of the loop
                                                           continue;
                                                       }
                                                       
                                                       if(anOpportunityCensus.Membership_Number__c != 1){
                                                           //not Subscriber, skips to the next iteration of the loop
                                                           continue;
                                                       }
                                                       
                                                       Boolean booleanFoundES = false;
                                                       
                                                       //Check all the Tiers for ES
                                                       if(anOpportunityCensus.Dental_Tier__c == 'ES'){
                                                           booleanFoundES = true;
                                                       }else{
                                                           if(anOpportunityCensus.Health_Tier__c == 'ES'){
                                                               booleanFoundES = true;
                                                           }else{
                                                               if(anOpportunityCensus.Vision_Tier__c == 'ES'){
                                                                   booleanFoundES = true;
                                                               }
                                                           }
                                                       }
                                                       
                                                       if(booleanFoundES == true){
                                                           listActiveSubscribersWithESTiers.add(anOpportunityCensus);
                                                       }
                                                   }
                                                   
                                                   
                                                   List <SGR_Opportunity_Census__c> listRelatedSpouses = new List<SGR_Opportunity_Census__c>();
                                                   
                                                   for(SGR_Opportunity_Census__c outerLoop : listActiveSubscribersWithESTiers){
                                                       for(SGR_Opportunity_Census__c innerLoop : inputListOpportunityCensus){
                                                           if(outerLoop.Subscriber_Number__c == innerLoop.Subscriber_Number__c){
                                                               if(SGR_Constants.setSpouseValues.contains(innerLoop.Relationship__c)){
                                                                   listRelatedSpouses.add(innerLoop);
                                                                   continue;
                                                               }
                                                           }
                                                       }
                                                   }
                                                   
                                                   
                                                   List <SGR_Opportunity_Census__c> listRelatedNonSpouses = new List<SGR_Opportunity_Census__c>();
                                                   
                                                   for(SGR_Opportunity_Census__c outerLoop : listActiveSubscribersWithESTiers){
                                                       for(SGR_Opportunity_Census__c innerLoop : inputListOpportunityCensus){
                                                           if(outerLoop.Subscriber_Number__c == innerLoop.Subscriber_Number__c){
                                                               if(!SGR_Constants.setSpouseValues.contains(innerLoop.Relationship__c) && !SGR_Constants.setSubscriberValues.contains(innerLoop.Relationship__c) ){
                                                                   listRelatedNonSpouses.add(innerLoop);
                                                                   continue;
                                                               }
                                                           }
                                                       }
                                                   }
                                                   
                                                   
                                                   if(listActiveSubscribers.size() > 0 ){
                                                       if(listActiveSubscribersWithESTiers.size() == 0){
                                                           //No ES Subscribers
                                                           abRVLogEntry.Status__c = SGR_Constants.StatusNA;
                                                           abRVLogEntry.Fail_Pass_Reason__c = 'No ES tiers';
                                                           businessRuleValidationLog.add(abRVLogEntry);
                                                       }else{
                                                           
                                                           for(SGR_Opportunity_Census__c outerLoop : listActiveSubscribersWithESTiers){                                                           
                                                               
                                                               Boolean booleanFoundSpouse = false;
                                                               Boolean booleanFoundNonSpouse = false;
                                                               
                                                               for(SGR_Opportunity_Census__c innerLoop1 : listRelatedSpouses){
                                                                   if(outerLoop.Subscriber_Number__c == innerLoop1.Subscriber_Number__c){
                                                                       booleanFoundSpouse = true;
                                                                   }
                                                               }
                                                               
                                                               for(SGR_Opportunity_Census__c innerLoop2 : listRelatedNonSpouses){
                                                                   if(outerLoop.Subscriber_Number__c == innerLoop2.Subscriber_Number__c){
                                                                       booleanFoundNonSpouse = true;
                                                                   }
                                                               }
                                                               
                                                               if(booleanFoundSpouse == false || booleanFoundNonSpouse == true){
                                                                   //Did not find the Spouse or Found something other than a Spouse
                                                                   abRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                                   abRVLogEntry.Fail_Pass_Reason__c = 'Invalid Employee Spouse tier exists. Subscriber Number = ' + outerLoop.Subscriber_Number__c ;
                                                                   businessRuleValidationLog.add(abRVLogEntry);
                                                                   //Break out of For Loop as no need to examine any further records
                                                                   break;
                                                               }
                                                           }
                                                           
                                                           //If made it out of the FOR Loop logic above without an entry in Business Rule Validation Log
                                                           //assuming that this is a PASS.
                                                           if(businessRuleValidationLog.size() == 0){
                                                               abRVLogEntry.Status__c = SGR_Constants.StatusPassed;
                                                               abRVLogEntry.Fail_Pass_Reason__c = 'No Invalid Employee Spouse tier exists.';
                                                               businessRuleValidationLog.add(abRVLogEntry);
                                                           }
                                                       }
                                                       
                                                   }else{
                                                       //No Active Subscribers
                                                       abRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                       abRVLogEntry.Fail_Pass_Reason__c = 'No Active Subscribers';
                                                       businessRuleValidationLog.add(abRVLogEntry);
                                                   }     
                                               }
                                               
                                               if (businessRuleValidationLog.size() > 0) {                                                        
                                                   try{
                                                       insert businessRuleValidationLog;
                                                       returnString = 'BR GR.DV.12 processed successfully.';
                                                   }catch(DmlException e){
                                                       CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelper.ESTiersValidation', 'High');                                                                
                                                       returnString = 'BR GR.DV.12 processed unsuccessfully.';
                                                   }
                                               }            
                                               
                                               return returnString;
                                           }
    
    
    //Anudeep
    // 14086 SGR: R8E - EC Tier Without Children 
    public Static String eCTireWithoutChildValidation(list<Opportunity> oppList,List<SGR_Opportunity_Census__c> sGROpptyCensusList,                   
                                                      String eCTireChild, 
                                                      Map<String,SGR_Business_Rule__c> sbrmap, 
                                                      String batchId, List<SGRRenewalBatch__c> renewbatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                          boolean activeSubscribers=false;
                                                          boolean passCondation=false;
                                                          boolean failCondation=false;
                                                          boolean nACondation=false;
                                                          boolean eCCondation=false;
                                                          set<Id> subcscriberSet=new set<Id>();
                                                          Double subscriberNumber;
                                                          String ruleProcessMsg;
                                                          set<String> subscriberSubSt =new set<String>{'Subscriber','SUB'};
                                                              Set<string> subscriberIds=new Set<String>();
                                                          Set<Double> subIdSet=new Set<Double>();
                                                          try{
                                                              List<Business_Rule_Validation_Log__c> busRuleValidationLogList = new List<Business_Rule_Validation_Log__c>();
                                                              if(!oppList.isEmpty()){
                                                                  for(Opportunity oPPS : oppList){
                                                                      Business_Rule_Validation_Log__c bRVLog=new Business_Rule_Validation_Log__c();
                                                                      bRVLog.AccountId__c=OPPS.AccountId;
                                                                      bRVLog.OpportunityId__c=OPPS.Id;
                                                                      if(!sGROpptyCensusList.isEmpty()){
                                                                          //For Active User Check for subscriber as a member ship number 1
                                                                          for(SGR_Opportunity_Census__c opptyCensus : sGROpptyCensusList){
                                                                              
                                                                              if(OpptyCensus.Opportunity__c==OPPS.Id){
                                                                                  if(SubscriberSubSt.contains(OpptyCensus.Relationship_Code__c)){
                                                                                      if((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<=OPPS.Renewal_Date__c) && 
                                                                                         (OpptyCensus.Member_Cancel_Date__c>=OPPS.Renewal_Date__c || OpptyCensus.Member_Cancel_Date__c==null)){
                                                                                             SubscriberNumber=OpptyCensus.Subscriber_Number__c;
                                                                                             subscriberIds.add(String.valueOf(OpptyCensus.Subscriber_Number__c));
                                                                                             
                                                                                             ActiveSubscribers=true;
                                                                                             if(OpptyCensus.Dental_Tier__c=='EC'){
                                                                                                 ECCondation=true;
                                                                                                 SubcscriberSet.add(OpptyCensus.Id);
                                                                                                 subIdSet.add(OpptyCensus.Subscriber_Number__c);
                                                                                             }else if(OpptyCensus.Health_Tier__c=='EC'){
                                                                                                 
                                                                                                 ECCondation=true;
                                                                                                 SubcscriberSet.add(OpptyCensus.Id);
                                                                                                 subIdSet.add(OpptyCensus.Subscriber_Number__c);
                                                                                             }
                                                                                             else if(OpptyCensus.Vision_Tier__c=='EC'){
                                                                                                 
                                                                                                 ECCondation=true;
                                                                                                 SubcscriberSet.add(OpptyCensus.Id);
                                                                                                 subIdSet.add(OpptyCensus.Subscriber_Number__c);
                                                                                             }
                                                                                             
                                                                                         }
                                                                                  }                                                                       
                                                                              } 
                                                                          }
                                                                          //if its active user as a subscriber exist
                                                                          if(ActiveSubscribers){
                                                                              for(SGR_Opportunity_Census__c opptycns : sGROpptyCensusList){
                                                                                  
                                                                                  if(sGROpptyCensusList.size()==1){
                                                                                      if(!ECCondation){
                                                                                          NACondation=true;
                                                                                      }
                                                                                      
                                                                                  }
                                                                                  if(!SubcscriberSet.contains(opptycns.id) ){
                                                                                      if(opptycns.Membership_Number__c>1){
                                                                                          if(ECCondation && subIdSet.contains(opptycns.Subscriber_Number__c)){
                                                                                              if(opptycns.Relationship_Code__c=='Child'){
                                                                                                  PassCondation=true;
                                                                                              }else{
                                                                                                  failCondation=true;
                                                                                              }
                                                                                          }
                                                                                          
                                                                                      }else{if(ECCondation && !PassCondation && !failCondation && !subIdset.contains(opptycns.Subscriber_Number__c)){failCondation=true;}}
                                                                                  }
                                                                              }
                                                                          }
                                                                      }else{
                                                                          ActiveSubscribers=false;
                                                                      }
                                                                      List<String> uniqueIds = new List<String>(subscriberIds);
                                                                      String joinedIds = String.join(uniqueIds, ', ');
                                                                      if(ActiveSubscribers==false){
                                                                          bRVLog.Status__c='Failed';
                                                                          bRVLog.Fail_Pass_Reason__c ='No active subscribers found'; 
                                                                      }else{
                                                                          if(PassCondation){
                                                                              failCondation=false;
                                                                              NACondation=false;
                                                                              bRVLog.Status__c='Passed';                                                                         
                                                                              bRVLog.Fail_Pass_Reason__c = 'No Invalid Employee Child(ren) tier exists.';
                                                                          }
                                                                          if(failCondation){
                                                                              //PassCondation=false;
                                                                              NACondation=false;
                                                                              bRVLog.Status__c='Failed';
                                                                              bRVLog.Fail_Pass_Reason__c = 'Invalid Employee Child(ren) tier exists.  Subscriber Number ='+joinedIds;
                                                                          }
                                                                          if(!ECCondation){//NACondation
                                                                              bRVLog.Status__c='N/A';
                                                                              bRVLog.Fail_Pass_Reason__c = 'No EC tiers';
                                                                          }
                                                                      }
                                                                      
                                                                      bRVLog.BusinessRuleId__c=sbrmap.get(eCTireChild).Id;
                                                                      for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OPPS.Id))
                                                                      {
                                                                          bRVLog.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                      }
                                                                      
                                                                      if (renewbatchId.size() > 0) {
                                                                          bRVLog.Batch_Id__c = renewbatchId[0].Id;
                                                                      }
                                                                      BusRuleValidationLogList.add(bRVLog);
                                                                      
                                                                      //}
                                                                  }
                                                              }
                                                              if(!BusRuleValidationLogList.isEmpty()){
                                                                  Insert BusRuleValidationLogList;
                                                                  ruleProcessMsg='BR GR.DV.13 processed successfully.';
                                                              }
                                                          }
                                                          catch (Exception ex) {
                                                              CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.dependentswithNoRelationshipCodeValidation', 'High');
                                                              ruleProcessMsg = 'BR GR.DV.13 processed unsuccessfully.';
                                                          }
                                                          return ruleProcessMsg;
                                                          
                                                      }
    //Anudeep
    //14087 SGR: R9E - EF Tier Without Family 
    
    public Static String eFTireWithoutFamilyValidation(list<Opportunity> oppList,List<SGR_Opportunity_Census__c> sGROpptyCensusList,                   
                                                       String eFTireFamily, 
                                                       Map<String,SGR_Business_Rule__c> sbrmap, 
                                                       String batchId, List<SGRRenewalBatch__c> renewbatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop){
                                                           boolean activeSubscribers=false;
                                                           boolean passCondation=false;
                                                           boolean failCondation=false;
                                                           boolean nACondation=false;
                                                           boolean eFCondation=false;
                                                           boolean sposeOrDPCondation=false;
                                                           boolean childPCondation=false;
                                                           set<Id> subcscriberSet=new set<Id>();
                                                           Double subscriberNumber;
                                                           String ruleProcessMsg;
                                                           set<String> spouseDependentset =new set<String>{'Spouse','Domestic Partner','SPS','DP'};
                                                               set<String> subscriberSubSt =new set<String>{'Subscriber','SUB'};
                                                                   Set<string> subscriberIds=new Set<String>();
                                                           Set<Double> subIdSet=new Set<Double>();
                                                           try{
                                                               List<Business_Rule_Validation_Log__c> busRuleValidationLogList = new List<Business_Rule_Validation_Log__c>();
                                                               if(!oppList.isEmpty()){
                                                                   for(Opportunity oPPS : oppList){
                                                                       
                                                                       Business_Rule_Validation_Log__c bRVLog=new Business_Rule_Validation_Log__c();
                                                                       bRVLog.AccountId__c=OPPS.AccountId;
                                                                       bRVLog.OpportunityId__c=OPPS.Id;
                                                                       if(!sGROpptyCensusList.isEmpty()){
                                                                           //For Active User Check for subscriber as a member ship number 1
                                                                           for(SGR_Opportunity_Census__c opptyCensus : sGROpptyCensusList){
                                                                               
                                                                               if(OpptyCensus.Opportunity__c==OPPS.Id){
                                                                                   if(SubscriberSubSt.contains(OpptyCensus.Relationship_Code__c)){
                                                                                       if((OpptyCensus.Membership_Number__c==1 && OpptyCensus.Member_Effective_Date__c<=OPPS.Renewal_Date__c) && 
                                                                                          (OpptyCensus.Member_Cancel_Date__c>=OPPS.Renewal_Date__c || OpptyCensus.Member_Cancel_Date__c==null)){
                                                                                              ActiveSubscribers=true;
                                                                                              SubscriberNumber=OpptyCensus.Subscriber_Number__c;
                                                                                              subscriberIds.add(String.valueOf(OpptyCensus.Subscriber_Number__c));
                                                                                              
                                                                                              
                                                                                              if(OpptyCensus.Dental_Tier__c=='EF'){
                                                                                                  SubcscriberSet.add(OpptyCensus.Id);
                                                                                                  subIdSet.add(OpptyCensus.Subscriber_Number__c);
                                                                                                  EFCondation=true;
                                                                                              }else if(OpptyCensus.Health_Tier__c=='EF'){
                                                                                                  SubcscriberSet.add(OpptyCensus.Id);
                                                                                                  subIdSet.add(OpptyCensus.Subscriber_Number__c);
                                                                                                  EFCondation=true;
                                                                                              }
                                                                                              else if(OpptyCensus.Vision_Tier__c=='EF'){
                                                                                                  SubcscriberSet.add(OpptyCensus.Id);
                                                                                                  subIdSet.add(OpptyCensus.Subscriber_Number__c);
                                                                                                  EFCondation=true;
                                                                                              }
                                                                                              
                                                                                              
                                                                                          }
                                                                                   }                                                                       
                                                                               }
                                                                           }
                                                                           //if its active user as a subscriber exist
                                                                           if(ActiveSubscribers){
                                                                               for(SGR_Opportunity_Census__c opptycns : sGROpptyCensusList){
                                                                                   if(sGROpptyCensusList.size()==1){
                                                                                       if(!EFCondation){
                                                                                           NACondation=true;
                                                                                       }
                                                                                   }
                                                                                   if(!SubcscriberSet.contains(opptycns.id)){
                                                                                       if(opptycns.Membership_Number__c>1){
                                                                                           if(EFCondation && subIdSet.contains(opptycns.Subscriber_Number__c)){
                                                                                               if(opptycns.Relationship__c=='Child'){
                                                                                                   ChildPCondation=true;
                                                                                                   if(failCondation){failCondation=false;}
                                                                                               }
                                                                                               if(SpouseDependentset.contains(opptycns.Relationship_Code__c)){
                                                                                                   SposeOrDPCondation=true;
                                                                                                   if(failCondation){failCondation=false;}
                                                                                               }
                                                                                               if(ChildPCondation && SposeOrDPCondation){
                                                                                                   PassCondation=true;
                                                                                               }else{
                                                                                                   failCondation=true;
                                                                                               }
                                                                                               
                                                                                               
                                                                                           }
                                                                                       }else{if(EFCondation && !PassCondation && !failCondation && !subIdset.contains(opptycns.Subscriber_Number__c)){failCondation=true;}}
                                                                                   }
                                                                               }
                                                                           }
                                                                       }else{ActiveSubscribers=false;}
                                                                       List<String> uniqueIds = new List<String>(subscriberIds);
                                                                       String joinedIds = String.join(uniqueIds, ', ');
                                                                       if(ActiveSubscribers==false){
                                                                           bRVLog.Status__c='Failed';
                                                                           bRVLog.Fail_Pass_Reason__c ='No active subscribers found'; 
                                                                       }else{
                                                                           if(PassCondation){
                                                                               NACondation=false;
                                                                               failCondation=false;
                                                                               bRVLog.Status__c='Passed';                                                                         
                                                                               bRVLog.Fail_Pass_Reason__c = 'No Invalid Employee Family tier exists.';
                                                                           }
                                                                           if(failCondation){
                                                                               NACondation=false;
                                                                               bRVLog.Status__c='Failed';
                                                                               bRVLog.Fail_Pass_Reason__c = 'Invalid Employee Family tier exists.  Subscriber Number ='+joinedIds;
                                                                           }
                                                                           if(!EFCondation){//NACondation
                                                                               bRVLog.Status__c='N/A';
                                                                               bRVLog.Fail_Pass_Reason__c = 'No EF tiers';
                                                                           }
                                                                       }
                                                                       
                                                                       bRVLog.BusinessRuleId__c=sbrmap.get(eFTireFamily).Id;
                                                                       for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(OPPS.Id))
                                                                       {
                                                                           bRVLog.Renewal_Batch_Oppty_Id__c=srbo.Name;
                                                                       }
                                                                       
                                                                       if (renewbatchId.size() > 0) {
                                                                           bRVLog.Batch_Id__c = renewbatchId[0].Id;
                                                                       }
                                                                       BusRuleValidationLogList.add(bRVLog);
                                                                       
                                                                   }
                                                               }
                                                               if(!BusRuleValidationLogList.isEmpty()){
                                                                   Insert BusRuleValidationLogList;
                                                                   ruleProcessMsg='BR GR.DV.14 processed successfully.';
                                                               }
                                                           }
                                                           catch (Exception ex) {
                                                               CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.dependentswithNoRelationshipCodeValidation', 'High');
                                                               ruleProcessMsg = 'BR GR.DV.14 processed unsuccessfully.';
                                                           }
                                                           return ruleProcessMsg;
                                                           
                                                       }
    
    //SFDC-14506: SGR: R4W - Member Over 99 Years Old
    //Author: Landry Harris
    public static String checkMembershipAge(List<Opportunity> opps, String memberOver99,
                                            String batchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                            List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,
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
                                                        Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                        bRV.AccountId__c = o.AccountId;
                                                        if (renewbatchId.size() > 0) {
                                                            bRV.Batch_Id__c = renewbatchId[0].Id;
                                                        }
                                                        bRV.BusinessRuleId__c = br.Id;    
                                                        bRV.OpportunityId__c = o.Id;
                                                        for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                                                        {
                                                            bRV.Renewal_Batch_Oppty_Id__c = srbo.name;
                                                        }
                                                        List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                        for (SGR_Opportunity_Census__c oc: censuses) {
                                                            activeSubscriber = false;
                                                            Integer days = oc.Date_of_Birth__c.daysBetween(o.Renewal_Date__c);
                                                            age = days/365;
                                                            if ((oc.Member_Effective_Date__c <= o.Renewal_Date__c) && (oc.Member_Cancel_Date__c >=o.Renewal_Date__c || oc.Member_Cancel_Date__c == null)) {
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
                                                            bRV.Status__c = SGR_Constants.StatusPassed;
                                                            bRV.Fail_Pass_Reason__c = br.Proposed_wording_pass__c;
                                                        }
                                                        else {
                                                            if (ruleFailOne) {
                                                                bRV.Status__c = SGR_Constants.StatusFailed;
                                                                bRV.Fail_Pass_Reason__c = 'One or more members exist which is above 99 years old.\nSubscriber Number = ' + joinedIds + '.';
                                                            }
                                                            else if (!ruleFailOne && ruleFailTwo) {
                                                                bRV.Status__c = SGR_Constants.StatusFailed;
                                                                bRV.Fail_Pass_Reason__c = 'No active members found.';
                                                            }
                                                        }
                                                        bsrlst.add(bRV);
                                                    }
                                                    if (bsrlst.size() > 0) {
                                                        insert bsrlst;
                                                        result = 'BR GR.DV.08 processed successfully.';
                                                    }
                                                    
                                                }
                                                catch (Exception ex) {
                                                    CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.checkMembershipAge', 'High');
                                                    result = 'BR GR.DV.08 processed unsuccessfully.';
                                                }
                                                return result;
                                            }
    //SFDC-14540: SGR: R10W - Headquarter & Division Mismatch
    //Author: Landry Harris
    public static String checkStateCode(List<Opportunity> opps, String stateCodeRule, Map<String,SGR_Business_Rule__c> sbrmap, String batchId, List<SGRRenewalBatch__c> renewbatchId, Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
        String ruleProcessMsg;
        SGR_Business_Rule__c br = sbrmap.get(stateCodeRule);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        try {
            for (Opportunity o: opps) {
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                bRV.AccountId__c = o.AccountId;
                if (renewbatchId.size() > 0) {
                    bRV.Batch_Id__c = renewbatchId[0].Id;
                }
                bRV.BusinessRuleId__c = br.Id;    
                bRV.OpportunityId__c = o.Id;
                for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                {
                    bRV.Renewal_Batch_Oppty_Id__c = srbo.name;
                }

                if (o.Account.ShippingState == o.HCSC_Division__c) {
                    bRV.Status__c = SGR_Constants.StatusPassed;
                    bRV.Fail_Pass_Reason__c = 'Account State Code = ' + o.Account.ShippingState + '.';
                } 
                else {
                    bRV.Status__c = SGR_Constants.StatusFailed;
                    bRV.Fail_Pass_Reason__c = 'Account State Code = ' + o.Account.ShippingState + '.';
                }
                
                bsrlst.add(bRV);
            }
            
            insert bsrlst;
            ruleProcessMsg = 'BR GR.DV.15 processed successfully.';
        }
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.checkStateCode', 'High');
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
        Set<Id> bRVfailOppSet = new Set<Id>();
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
                SGR_Global_Process_Skip__c processSkip= SGR_Global_Process_Skip__c.getInstance('Opportunity Validation');
                for(Opportunity failOppr : failOpprList){
                    
                    failOppr.Rating_Status__c = 'Initiated'; //Need to check with BA
                    failOppr.SGR_Workflow_Activity__c = 'UW Review - Validation Errors'; // Edited for SFDC: 16646
                    
                    failOppr.Workflow_System_Status__c = 'Failed Validation'; // Edited for SFDC: 16646
                    
                    if(processSkip.Skip__c){//if skip is true
                        failOppr.Workflow_System_Status__c = 'Ready to Rate';
                    }
                    
                    finalOpprToUpdate.add(failOppr);
                    
                    
                }
                
            }
            
            bRVfailOppSet = failedBROpp.keySet();
            
            for(Opportunity oppor :opprs){
                if(!bRVfailOppSet.contains(oppor.id)){
                    passBROpp.put(oppor.id,oppor);
                }
            }
            if(passBROpp!=null){
                passOpprList = passBROpp.values();
                for(Opportunity passOppr : passOpprList){
                    passOppr.Rating_Status__c = 'Initiated';
                    passOppr.SGR_Workflow_Activity__c = '';
                    passOppr.Workflow_System_Status__c = 'Ready to Rate';
                    
                    finalOpprToUpdate.add(passOppr);
                }
            }
            if(finalOpprToUpdate!=null && finalOpprToUpdate.size()>0){
                update finalOpprToUpdate;
            }
            
            //Logic that Calls Insertion of  case & update the case id on business validation Log that are created.
            SGR_bRValidationFalloutCaseForUW_Impl  svfc = new SGR_bRValidationFalloutCaseForUW_Impl();
            svfc.createCases(failOpprList);
            //End of Logic
            
            
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.updateOppRatingStatusAndWA', 'High');
        }
    }
    
    //SFDC-14541 - SGR: R11W - <= 50 Enrollees Check - Begin
    public static String checkSub50Enrollees(List<Opportunity> inputOpportunities, 
                                             String inputRuleName,
                                             String inputbatchId,
                                             map<id,List<SGR_Opportunity_Census__c>>inputOppCensus,
                                             List<SGRRenewalBatch__c> inputrenewbatchId,
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
                                                     
                                                     Business_Rule_Validation_Log__c abRVLogEntry = new Business_Rule_Validation_Log__c();
                                                     
                                                     abRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                     abRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                     abRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                     
                                                     if (inputrenewbatchId.size() > 0) {
                                                         abRVLogEntry.Batch_Id__c = inputrenewbatchId[0].Id;
                                                     } 
                                                     
                                                     activeHealthSubsribers = 0;
                                                     
                                                     List<SGR_Opportunity_Census__c> theCensusesForTheOpp = inputOppCensus.get(anOpportunity.Id);
                                                     
                                                     //Census Loop
                                                     if(theCensusesForTheOpp!=null){
                                                         for (SGR_Opportunity_Census__c anOppCensus: theCensusesForTheOpp) {
                                                             //Active 
                                                             if ((anOppCensus.Member_Cancel_Date__c > anOpportunity.Renewal_Date__c) || anOppCensus.Member_Cancel_Date__c == null){
                                                                 //Subscribers
                                                                 if(anOppCensus.Relationship_Code__c == 'Subscriber' || anOppCensus.Relationship_Code__c == 'SUB'){
                                                                     activeHealthSubsribers = activeHealthSubsribers + 1;                                                                        
                                                                 }                                                                    
                                                             }
                                                         }     
                                                     }
                                                     
                                                     //FAIL > 50
                                                     if (activeHealthSubsribers > 50){
                                                         abRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                         abRVLogEntry.Fail_Pass_Reason__c = '# Current Subscribers = ' + activeHealthSubsribers ;    
                                                         
                                                         //Add the Log Entry
                                                         businessRuleValidationLog.add(abRVLogEntry);
                                                         continue; //Breaks out of this Opportunity Loop iteration
                                                     }
                                                     
                                                     //FAIL = 0
                                                     if (activeHealthSubsribers == 0){  
                                                         
                                                         abRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                         abRVLogEntry.Fail_Pass_Reason__c = 'No active Subscribers found';
                                                         
                                                         //Add the Log Entry
                                                         businessRuleValidationLog.add(abRVLogEntry);
                                                         continue; //Breaks out of this Opportunity Loop iteration
                                                     }
                                                     
                                                     
                                                     //PASS <= 50 AND > 0
                                                     
                                                     if (activeHealthSubsribers <= 50){
                                                         abRVLogEntry.Status__c = SGR_Constants.StatusPassed;
                                                         abRVLogEntry.Fail_Pass_Reason__c = '# Current Subscribers = ' + activeHealthSubsribers;
                                                         
                                                         //Add the Log Entry
                                                         businessRuleValidationLog.add(abRVLogEntry);
                                                         continue; //Breaks out of this Opportunity Loop iteration
                                                     }
                                                 }                                                        
                                                 
                                                 if (businessRuleValidationLog.size() > 0) {                                                        
                                                     try{
                                                         insert businessRuleValidationLog;
                                                         returnString = 'BR GR.EL.02 processed successfully.';
                                                     }catch(DmlException e){
                                                         CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelper.Sub50Enrollees', 'High');                                                                
                                                         returnString = 'BR GR.EL.02 NOT processed successfully.';
                                                     }
                                                 }                                                        
                                                 Return returnString;                                                        
                                             } 
    //SFDC-14541 - SGR: R11W - <= 50 Enrollees Check - End 
    //SFDC-14542 - SGR: R12W - Regulated & Health Subscriber in TX
    //Author: Landry Harris
    public static String getNumberOfHealthSubscribers(List<Opportunity> opps, String texasHealthSubs,
                                                      String batchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                      List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,
                                                      Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop) {
                                                          String result;      
                                                          List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();                             
                                                          try {
                                                              SGR_Business_Rule__c br = sbrmap.get(texasHealthSubs);
                                                              Integer healthSubCount; 
                                                              for (Opportunity o: opps) {
                                                                  healthSubCount = 0;
                                                                  Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                                  bRV.AccountId__c = o.AccountId;
                                                                  if (renewbatchId.size() > 0) {
                                                                      bRV.Batch_Id__c = renewbatchId[0].Id;
                                                                  }
                                                                  bRV.BusinessRuleId__c = br.Id;    
                                                                  bRV.OpportunityId__c = o.Id;
                                                                  for(SGR_Renewal_Batch_Oppty__c srbo: oppsrbop.get(o.id))
                                                                  {
                                                                      bRV.Renewal_Batch_Oppty_Id__c = srbo.name;
                                                                  }
                                                                  
                                                                  if (o.HCSC_Division__c == 'TX') {
                                                                      List<SGR_Opportunity_Census__c> oppCensuses = oppsgrogs.get(o.Id);
                                                                      
                                                                      //Census Loop
                                                                      for (SGR_Opportunity_Census__c oc: oppCensuses) {
                                                                          //Active 
                                                                          if (oc.Member_Effective_Date__c < =o.Renewal_Date__c && (oc.Member_Cancel_Date__c >= o.Renewal_Date__c || oc.Member_Cancel_Date__c == null)){
                                                                              //Subscribers
                                                                              if(oc.Relationship_Code__c == 'SUB' && oc.State__c == 'TX' && oc.Health_Plan_ID__c != null){
                                                                                  healthSubCount = healthSubCount + 1;                                                                        
                                                                              }                                                                    
                                                                          }
                                                                      }
                                                                      if (healthSubCount > 0) {
                                                                          bRV.Status__c = 'Passed';
                                                                          bRV.Fail_Pass_Reason__c = '# of Health Subscribers in TX = ' + healthSubCount + '.';
                                                                      }
                                                                      else {
                                                                          bRV.Status__c = 'Failed';
                                                                          bRV.Fail_Pass_Reason__c = '# of Health Subscribers in TX = 0.';
                                                                      }
                                                                  }
                                                                  else {
                                                                      bRV.Status__c = 'N/A';
                                                                      bRV.Fail_Pass_Reason__c = 'N/A OK, NM, IL, MT';
                                                                  }
                                                                  bsrlst.add(bRV);
                                                              }
                                                              if (bsrlst.size() > 0) {
                                                                  insert bsrlst;
                                                                  result = 'BR GR.DV.08 processed successfully.';
                                                              }
                                                              
                                                          }
                                                          catch (Exception ex) {
                                                              CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.getNumberOfHealthSubscribers', 'High');
                                                              result = 'BR GR.DV.08 NOT processed successfully.';
                                                          }
                                                          return result;
                                                      }
    
    //SFDC-14543 - SGR: R13W - Health vs.Contributory Dental - Begin
    public static String checkhealthvsContributoryDental(List<Opportunity> inputOpportunities, 
                                                         String inputRuleName,
                                                         String inputbatchId,
                                                         map<id,List<SGR_Opportunity_Census__c>>inputOppCensus,
                                                         List<SGRRenewalBatch__c> inputrenewbatchId,
                                                         map<String,SGR_Business_Rule__c> inputBusinessRules,
                                                         Map<id,List<SGR_Renewal_Batch_Oppty__c>>inputOppBatch) {
                                                             
                                                             Double activeHealthSubsribers;
                                                             Double activeDentalSubscriber;
                                                             Double computedValue;
                                                             
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
                                                                 
                                                                 Business_Rule_Validation_Log__c abRVLogEntry = new Business_Rule_Validation_Log__c();
                                                                 
                                                                 abRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                                 abRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                                 abRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                                 
                                                                 if (inputrenewbatchId.size() > 0) {
                                                                     abRVLogEntry.Batch_Id__c = inputrenewbatchId[0].Id;
                                                                 } 
                                                                 
                                                                 activeHealthSubsribers = 0;
                                                                 activeDentalSubscriber = 0;
                                                                 
                                                                 List<SGR_Opportunity_Census__c> theCensusesForTheOpp = inputOppCensus.get(anOpportunity.Id);
                                                                 
                                                                 //Health Only & Dental Only Idenfitied using the Opportunity.Product_Type__c Field
                                                                 //No need to do anything further as this should be N/A
                                                                 if((anOpportunity.Product_Type__c == 'H') || (anOpportunity.Product_Type__c == 'D')){
                                                                     abRVLogEntry.Status__c = SGR_Constants.StatusNA;
                                                                     if(anOpportunity.Product_Type__c == 'H'){
                                                                         abRVLogEntry.Fail_Pass_Reason__c = 'N/A Health Only';
                                                                     }
                                                                     if(anOpportunity.Product_Type__c == 'D'){
                                                                         abRVLogEntry.Fail_Pass_Reason__c = 'N/A Dental Only';
                                                                     }
                                                                     businessRuleValidationLog.add(abRVLogEntry);
                                                                     continue; //Breaks out of this Opportunity Loop iteration
                                                                 }
                                                                 
                                                                 if(theCensusesForTheOpp!=null){
                                                                     //Census Loop
                                                                     for (SGR_Opportunity_Census__c anOppCensus: theCensusesForTheOpp) {
                                                                         
                                                                         //Only need SUBSCRIBER Opportunity Census Records
                                                                         if(anOppCensus.Relationship_Code__c == 'Subscriber' || anOppCensus.Relationship_Code__c == 'SUB'){
                                                                             
                                                                             //Only want ACTIVE SUBSCRIBER Opportunity Census Records
                                                                             if(anOppCensus.Member_Effective_Date__c <= anOpportunity.Renewal_Date__c){
                                                                                 if(anOppCensus.Member_Cancel_Date__c >= anOpportunity.Renewal_Date__c || anOppCensus.Member_Cancel_Date__c == null){
                                                                                     //should be ACTIVE
                                                                                     
                                                                                     //Has a Health Plan indicated = Add to Health Coung
                                                                                     if(String.isNotBlank(anOppCensus.Health_Plan_ID__c)){
                                                                                         activeHealthSubsribers = activeHealthSubsribers + 1;
                                                                                     }
                                                                                     
                                                                                     //Has a Dental Plan indicated = Add to Dental Count
                                                                                     if(String.isNotBlank(anOppCensus.Dental_Plan_ID__c)){
                                                                                         activeDentalSubscriber = activeDentalSubscriber + 1;
                                                                                     }
                                                                                     
                                                                                 }
                                                                             }
                                                                         } 
                                                                     }   
                                                                 }
                                                                 computedValue = 0;
                                                                 
                                                                 //Can not divide by Zero.
                                                                 if(activeHealthSubsribers != 0 && activeDentalSubscriber!=0 ){
                                                                     // Formula for getting the variance percentage
                                                                     computedValue = (((activeHealthSubsribers / activeDentalSubscriber) - 1) * 100);
                                                                 }
                                                                 
                                                                 //FAIL
                                                                 if (computedValue <= -25 ){                                                                
                                                                     abRVLogEntry.Status__c = SGR_Constants.StatusFailed;
                                                                     abRVLogEntry.Fail_Pass_Reason__c = 'Variation of enrollment between Health & Contributory Dental (' + computedValue + '%) is not within range.';
                                                                     businessRuleValidationLog.add(abRVLogEntry);                                                                     
                                                                 }else{
                                                                     //Fall-Thru Logic = Pass
                                                                     abRVLogEntry.Status__c = SGR_Constants.StatusPassed;
                                                                     abRVLogEntry.Fail_Pass_Reason__c = 'Variation of enrollment between Health & Contributory Dental (' + computedValue + '%) is within range.';
                                                                     businessRuleValidationLog.add(abRVLogEntry);                                                                                                                                       
                                                                 }
                                                             }                                                        
                                                             
                                                             if (businessRuleValidationLog.size() > 0) {                                                        
                                                                 try{
                                                                     insert businessRuleValidationLog;
                                                                     returnString = 'BR GR.EL.04 processed successfully.';
                                                                 }catch(DmlException e){
                                                                     CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelper.healthvsContributoryDental', 'High');                                                                
                                                                     returnString = 'BR GR.EL.04 NOT processed successfully.';
                                                                 }
                                                             }                                                        
                                                             Return returnString;                                                        
                                                         }
    //SFDC-14543 - SGR: R13W - Health vs.Contributory Dental - End
    
    // nikhil sfdc - 14431
    
    //Author: nihkil jain
    //TODO:nikhil - DMLException/Exception handling , move status and reason text to SGR_Constants
    //checkForactivedentalsubscriber(opps, activedentalsubscriberlist, batchId,oppsgrogs,renewbatchId,sbrmap,oppsrbop,oppsgrobamap);
    public static String checkForactivedentalsubscriber(List<Opportunity> opps,
                                                        String activedentalsubscriberlist,
                                                        String batchId,
                                                        map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                        List<SGRRenewalBatch__c> renewbatchId,
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
                                                            boolean count1 = false;
                                                            boolean count2 = false;
                                                            try {
                                                                for (Opportunity o: opps) {
                                                                    acctId = o.AccountId;
                                                                    oppId = o.Id; 
                                                                    Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                                    bRV.AccountId__c = o.AccountId;
                                                                    if (renewbatchId.size() > 0) {
                                                                        bRV.Batch_Id__c = renewbatchId[0].Id;
                                                                    }
                                                                    bRV.BusinessRuleId__c = br.Id;    
                                                                    bRV.OpportunityId__c = o.Id;
                                                                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                                                                    {
                                                                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                                    }
                                                                    List<SGR_Opportunity_Benefit_Agreement__c> benf = oppsgrobamap1.get(o.Id);
                                                                    if(benf.size()>0)
                                                                    {
                                                                        for(SGR_Opportunity_Benefit_Agreement__c oba1:benf)
                                                                        {
                                                                            if (count==true)
                                                                            {
                                                                                break;
                                                                            }
                                                                            if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'D')
                                                                            { 
                                                                                
                                                                                List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                                                if(censuses.size()>0)
                                                                                {
                                                                                    for (SGR_Opportunity_Census__c oc: censuses)
                                                                                    { 
                                                                                        if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c > =o.Renewal_Date__c)) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c <=o.Renewal_Date__c && oc.Dental_Plan_ID__c != Null)
                                                                                        {
                                                                                            
                                                                                            bRV.Status__c = 'Passed';
                                                                                            bRV.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement and active Dental Subscribers on Account.';
                                                                                            count=true;
                                                                                            break;
                                                                                        }
                                                                                        else 
                                                                                        {
                                                                                            bRV.Status__c = 'Failed';
                                                                                            bRV.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement but no active Dental Subcribers on Account.'; 
                                                                                            count1=true;
                                                                                        }
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    bRV.Status__c = 'Failed';
                                                                                    bRV.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement but no active Dental Subcribers on Account.';
                                                                                    count1=true;                                                                                    
                                                                                }
                                                                            }
                                                                            else if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'H')
                                                                            {
                                                                                bRV.Status__c = 'N/A';
                                                                                bRV.Fail_Pass_Reason__c = 'N/A Health Only';
                                                                                count2=true;
                                                                            }
                                                                            else
                                                                            { 
                                                                                bRV.Status__c = 'N/A';
                                                                                bRV.Fail_Pass_Reason__c = 'No Active Dental Benefit Agreement Found';
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    else
                                                                    { 
                                                                        bRV.Status__c = 'N/A';
                                                                        bRV.Fail_Pass_Reason__c = 'No BA Found'; 
                                                                    }
                                                                    
                                                                    if(count==false && count1==true)
                                                                    {
                                                                        bRV.Status__c = 'Failed';
                                                                        bRV.Fail_Pass_Reason__c = 'Active Family Dental Benefit Agreement but no active Dental Subcribers on Account.';    
                                                                    }
                                                                    
                                                                    else if(count==false && count1==false && count2==true)  
                                                                    { 
                                                                        bRV.Status__c = 'N/A';
                                                                        bRV.Fail_Pass_Reason__c = 'N/A Health Only';
                                                                    }
                                                                    
                                                                    
                                                                    bsrlst.add(bRV);
                                                                }
                                                                insert bsrlst;                                                          
                                                                ruleProcessMsg = 'BR GR.DV.04 processed successfully.';                                                          
                                                            } 
                                                            
                                                            catch (Exception ex) {
                                                                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                                                                                  'Opportunity', null, 
                                                                                                  'SGR_validationHelper.checkForactivedentalsubscriber AccountId: ' + acctId + ' Opportunity Id: ' + oppId, 'High');                                                          
                                                            }
                                                            
                                                            return ruleProcessMsg; 
                                                        }
    //end 14431
    
    // nikhil
    // sfdc- 14430 start //Code Commented for SAMPARTIAL Deployment 
    public static String checkForactiveHealthsubscriber(List<Opportunity> opps,
                                                        String activehealthsubscriber1,
                                                        String batchId,
                                                        map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                        List<SGRRenewalBatch__c> renewbatchId,
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
                                                            boolean count1 = false;
                                                            boolean count2 = false;
                                                            try {
                                                                for (Opportunity o: opps) {
                                                                    acctId = o.AccountId;
                                                                    oppId = o.Id; 
                                                                    Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                                                                    bRV.AccountId__c = o.AccountId;
                                                                    if (renewbatchId.size() > 0) {
                                                                        bRV.Batch_Id__c = renewbatchId[0].Id;
                                                                    }
                                                                    bRV.BusinessRuleId__c = br.Id;    
                                                                    bRV.OpportunityId__c = o.Id;
                                                                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                                                                    {
                                                                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                                                                    }
                                                                    List<SGR_Opportunity_Benefit_Agreement__c> benf = oppsgrobamap1.get(o.Id);
                                                                    if(benf.size()>0)
                                                                    {
                                                                        for(SGR_Opportunity_Benefit_Agreement__c oba1:benf)
                                                                        {
                                                                            if (count==true)
                                                                            {
                                                                                break;
                                                                            }
                                                                            
                                                                            if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'H')
                                                                            {
                                                                                
                                                                                List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                                                                                if(censuses.size()>0)
                                                                                {
                                                                                    for (SGR_Opportunity_Census__c oc: censuses)
                                                                                    { 
                                                                                        if(((oc.Member_Cancel_Date__c == null) || (oc.Member_Cancel_Date__c > =o.Renewal_Date__c)) && oc.Membership_Number__c == 1 && oc.Member_Effective_Date__c <=o.Renewal_Date__c && oc.Health_Plan_ID__c != Null)
                                                                                        {
                                                                                            
                                                                                            bRV.Status__c = 'Passed';
                                                                                            bRV.Fail_Pass_Reason__c = 'Active Family Health Benefit Agreement and active Health Subscribers on Account.';
                                                                                            count=true;
                                                                                            break;
                                                                                        }
                                                                                        else 
                                                                                        {
                                                                                            bRV.Status__c = 'Failed';
                                                                                            bRV.Fail_Pass_Reason__c = 'Active Family Health Benefit Agreement but no active Health Subcribers on Account.'; 
                                                                                            count1=true;
                                                                                        }     
                                                                                    }
                                                                                }
                                                                                else
                                                                                {
                                                                                    bRV.Status__c = 'Failed';
                                                                                    bRV.Fail_Pass_Reason__c = 'Active Family Health Benefit Agreement but no active Health Subcribers on Account.';
                                                                                    count1=true;
                                                                                    
                                                                                }
                                                                            }
                                                                            else if(oba1.Status__c == 'Active' && oba1.Insurance_Type_Code__c == 'D')
                                                                            {
                                                                                bRV.Status__c = 'N/A';
                                                                                bRV.Fail_Pass_Reason__c = 'N/A Dental Only';
                                                                                count2=true;
                                                                            }
                                                                            else
                                                                            {
                                                                                bRV.Status__c = 'N/A';
                                                                                bRV.Fail_Pass_Reason__c = 'No Active Health Benefit agreement found';
                                                                            }
                                                                        }
                                                                    }
                                                                    else
                                                                    {
                                                                        bRV.Status__c = 'N/A';
                                                                        bRV.Fail_Pass_Reason__c = 'No BA Found';   
                                                                        
                                                                    }
                                                                    
                                                                    if(count==false && count1==true)
                                                                    {
                                                                        bRV.Status__c = 'Failed';
                                                                        bRV.Fail_Pass_Reason__c = 'Active Family Health Benefit Agreement but no active Health Subcribers on Account.';    
                                                                    }
                                                                    
                                                                    else if(count==false && count1==false && count2==true)  
                                                                    { 
                                                                        bRV.Status__c = 'N/A';
                                                                        bRV.Fail_Pass_Reason__c = 'N/A Dental Only';
                                                                    }
                                                                    
                                                                    bsrlst.add(bRV);
                                                                }
                                                                insert bsrlst;                                                          
                                                                ruleProcessMsg = 'BR GR.DV.03 processed successfully.';                                                          
                                                            } 
                                                            
                                                            catch (Exception ex) {
                                                                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                                                                                  'Opportunity', null, 
                                                                                                  'SGR_validationHelper.checkForactiveHealthsubscriber AccountId: ' + acctId + ' Opportunity Id: ' + oppId, 'High');                                                          
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
                                                     String inputbatchId,                                                    
                                                     List<SGRRenewalBatch__c> inputrenewbatchId,
                                                     map<String,SGR_Business_Rule__c> inputBusinessRules){
                                                         
                                                         
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
                                                             Return returnString;
                                                         }
                                                         
                                                         //Opportunity Loop                                                        
                                                         for (Opportunity anOpportunity: inputOpportunities) {
                                                             
                                                             Business_Rule_Validation_Log__c abRVLogEntry = new Business_Rule_Validation_Log__c();
                                                             
                                                             if (inputrenewbatchId.size() > 0) {
                                                                 abRVLogEntry.Batch_Id__c = inputrenewbatchId[0].Id;
                                                             } 
                                                             
                                                             String possibleDupes = '';
                                                             
                                                             abRVLogEntry.AccountId__c = anOpportunity.AccountId;
                                                             abRVLogEntry.BusinessRuleId__c = aBusinessRule.Id;    
                                                             abRVLogEntry.OpportunityId__c = anOpportunity.Id;
                                                             
                                                             //If there are no existing Opps then this is a Pass
                                                             if(inputExistingOpps.isEmpty()){
                                                                 abRVLogEntry.Status__c = SGR_Constants.StatusPassed;  
                                                                 abRVLogEntry.Fail_Pass_Reason__c = 'Most recent Production Opty is complete.';
                                                                 businessRuleValidationLog.add(abRVLogEntry);
                                                                 //Break the loop and move to next Opportunity
                                                                 continue;
                                                             }else{
                                                                 Integer possibleDupeCount = 0;
                                                                 //Loop thru the existing Opportunties and examine for criteria
                                                                 for(Opportunity existingOpportunity : inputExistingOpps){
                                                                     if(anOpportunity.RecordTypeId == SGR_Constants.idOppProductionRecTypeID){                                                                                                                                  
                                                                         if(anOpportunity.AccountId == existingOpportunity.AccountId){
                                                                             if(anOpportunity.Renewal_Date__c == existingOpportunity.Renewal_Date__c){
                                                                                 if(existingOpportunity.RecordTypeId == SGR_Constants.idOppProductionRecTypeID){                                                                            
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
                                                                 }                                                                
                                                             }
                                                             
                                                             if(String.isNotBlank(possibleDupes)){
                                                                 //Found Possible Duplicates
                                                                 abRVLogEntry.Status__c = SGR_Constants.StatusFailed;  
                                                                 abRVLogEntry.Fail_Pass_Reason__c = 'This renewal may be impacted by another in-process Production Opty: ' + possibleDupes  ;
                                                                 businessRuleValidationLog.add(abRVLogEntry);                                          
                                                             }else{
                                                                 //No Possible Duplicates Found
                                                                 abRVLogEntry.Status__c = SGR_Constants.StatusPassed;  
                                                                 abRVLogEntry.Fail_Pass_Reason__c = 'Most recent Production Opty is complete.';
                                                                 businessRuleValidationLog.add(abRVLogEntry);
                                                             }                                                        
                                                         }
                                                         
                                                         if (businessRuleValidationLog.size() > 0) {                                                        
                                                             try{
                                                                 insert businessRuleValidationLog;
                                                                 returnString = 'BR GV.DV.16 processed successfully.';
                                                             }catch(DmlException e){
                                                                 CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Business_Rule_Validation_Log__c', null, 'SGR_validationHelper.otherOpenOpportunities', 'High');                                                                
                                                                 returnString = 'BR GV.DV.16 NOT processed successfully.';
                                                             }
                                                         }                                                                                          
                                                         
                                                         Return returnString;
                                                     }
    //SFDC-14543 - SGR: R6W - Existing Production Opportunity - End
    /************************************************
US Name: SFDC-14535
SGR: Active Benefit Agreement renewal date and opportunity date check.
Author: Roopa
Date:11/14/2018.
**************************************************/
    public static String activeBenefitAgreementdateCheck(List<Opportunity> accs,String batchId,String dateCheck,map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap1,List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)    
    {
        String msg;
       
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
                    Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                    List<SGR_Opportunity_Benefit_Agreement__c> sobfaactive = oppsgrobamap1.get(opp.Id);
                    
                    if(sobfaactive.size()>0) // Checking opp benefit aggreement is present or not.
                    {
                       
                        for(SGR_Opportunity_Benefit_Agreement__c sgrs1:oppsgrobamap1.get(opp.Id))
                        {
                            if(String.isNotEmpty(sgrs1.Status__c) && sgrs1.Status__c =='Active'&& sgrs1.Renewal_Date__c!=null)
                            {
                                String str2 = sgrs1.Status__c;
                                tempSet1.add(str2);
                                Date myDate=sgrs1.Renewal_Date__c;
                                String str1 = String.valueOf(myDate);// accepts date string in YYYY-MM-dd format. or use parse
                                tempList.add(str1);
                                
                                tempSet.addAll(tempList);
                            }
                            if(tempSet1==null || tempSet1.isEmpty()==True){
                               
                                bRV.Status__c='Failed';
                                bRV.Fail_Pass_Reason__c='No active benefit agreement found.';
                            }else{
                                if(tempSet1!=null&& tempSet1.size()==1&& tempSet!=null && tempSet.size()==1){
                                    bRV.Status__c='Passed';
                                    bRV.Fail_Pass_Reason__c=sbrmap.get(dateCheck).Proposed_wording_pass__c;
                                }
                                if(sgrs1.Status__c =='Active'&& (sgrs1.Renewal_Date__c==null || (tempSet!=null && tempSet.size()>1))){
                                    bRV.Status__c='Failed';
                                    bRV.Fail_Pass_Reason__c='All the active BA do not have the same renewal date.';
                                }
                            }
                        }     
                    }else{
                        bRV.Status__c='Failed';
                        bRV.Fail_Pass_Reason__c='No active benefit agreement found.';
                    }
                    
                    bRV.AccountId__c=opp.AccountId;
                    bRV.OpportunityId__c=opp.Id;
                    bRV.BusinessRuleId__c=sbrmap.get(dateCheck).id;
                    if(renewbatchId.size()>0)
                    {
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(opp.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                   
                    bsrlst.add(bRV);
                    
                }
            }
            
            insert bsrlst;
           
            msg='Insertion done.';        
        }  
        catch(System.NullPointerException e )
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.activeBenefitAgreementcheck', 'High');                                                           
            
        }
        return msg;    
    }//END-14535  
    
    
    //check for When the account has a divison of TX and invitro plans
    //US14539
    //developer:Raghavender Goud Nellikondi
    //checkInvitroplans(opps,invitro1,batchId,sbrmap,renewbatchId,oppsrbop,oppsgrogs1,oppsgrobamap);
    public Static String checkInvitroplans(List<Opportunity> opps,
                                           String invitro,
                                           String batchId,
                                           map<String,SGR_Business_Rule__c> sbrmap,
                                           List<SGRRenewalBatch__c> renewbatchId,
                                           Map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop,
                                           map<id,List<SGR_Opportunity_Group_Section__c>>oppsgrogs1,
                                           map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap)
    {
        String msg;
        SGR_Business_Rule__c br = sbrmap.get(Invitro);
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        boolean passFail = false;
        Integer count1=0;
        Integer count2=0;
        
        try{
            for(Opportunity oss :opps)
            {
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                bRV.AccountId__c = oss.AccountId;
                if (renewbatchId.size() > 0) {
                    bRV.Batch_Id__c = renewbatchId[0].Id;
                }
                bRV.BusinessRuleId__c = br.Id;    
                bRV.OpportunityId__c = oss.Id;
                
                
                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(oss.id))
                {
                    bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                }
                if(oss.HCSC_Division__c=='TX')
                {
                
                    List<SGR_Opportunity_Group_Section__c> sgrgs1 = oppsgrogs1.get(oss.Id);
                    if(sgrgs1.size()>0)
                    {
                        for(SGR_Opportunity_Group_Section__c sgrgs:sgrgs1)
                        {
                         
                            if(sgrgs.Invitro__c == true) 
                            {
                                PassFail=true;
                                count1=1;
                                
                            }
                            else
                            {
                                PassFail=false;
                                count2=2;
                                //   break;
                                
                            }
                        }
                        
                        
                        
                        List<SGR_Opportunity_Benefit_Agreement__c> oppsgrbagr1 = oppsgrobamap.get(oss.id);
                        if(oppsgrbagr1.size()>0)
                        {
                            for(SGR_Opportunity_Benefit_Agreement__c oppsgrbagr:oppsgrbagr1)
                            {
                                if(oppsgrbagr.Insurance_Type_Code__c=='H' && oppsgrbagr.Status__c == 'Active' )
                                {
                                    if(count1==1 && count2==2) 
                                    {
                                        bRV.Status__c='Failed';
                                        bRV.Fail_Pass_Reason__c='The account has at least one active Invitro and at least one active non-Invitro health plan(s)';
                                        break;
                                    }
                                    else if(count2==2 && count1==0) 
                                    {
                                        bRV.Status__c='passed';
                                        bRV.Fail_Pass_Reason__c='The account has all Inactive Invitro Health Plans';
                                        break;
                                    }
                                    else if(count2==0 && count1==1) 
                                    {
                                        bRV.Status__c='passed';
                                        bRV.Fail_Pass_Reason__c='The account has all active Invitro Health Plans';
                                        break;
                                    }
                                    
                                    else
                                    {
                                        bRV.Status__c='N/A';
                                        bRV.Fail_Pass_Reason__c='The account does not have any active or Inactive Invitro health plans';
                                    }
                                }
                                else if(oppsgrbagr.Insurance_Type_Code__c=='D' && oppsgrbagr.Status__c == 'Active')
                                {
                                    bRV.Status__c='N/A';
                                    bRV.Fail_Pass_Reason__c='Dental Only';
                                    break;
                                    
                                }
                                else
                                {
                                    bRV.Status__c='N/A';
                                    bRV.Fail_Pass_Reason__c='N/A';
                                }
                                
                                
                            }
                        }
                        else
                        {
                            bRV.Status__c='N/A';
                            bRV.Fail_Pass_Reason__c='No BA found';  
                            
                        }
                    }
                    else 
                    {
                        
                        
                        bRV.Status__c='N/A';
                        bRV.Fail_Pass_Reason__c='No Group Section found';
                        
                    }
                    
                    
                    //}
                }
                else
                {
                    
                    bRV.Status__c='N/A';
                    bRV.Fail_Pass_Reason__c='The Account has a division of IL or OK or NM or MT';
                }
                bsrlst.add(bRV);
            }
            insert bsrlst;                                                          
            msg = 'BR GR.DV.19 processed successfully.'; 
        }
        catch(Exception e)
        {
            
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.checkInvitroplans', 'High');
        }
        
        return msg;
    }
    //SFDC-14433: SGR:R3W - Non-COBRA Under 16 
    //Author: Shalini
    
    public static String checkforNonCobraSubsribers(List<Opportunity> opps,
                                                    String nonCobraSubscriber,
                                                    String batchId,map<id,List<SGR_Opportunity_Census__c>>oppsgrogs,
                                                    List<SGRRenewalBatch__c> renewbatchId,
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
        Integer noOfYears;
        boolean count = false;
        boolean count1 = false;
        boolean count2 = false;
        try {
            for (Opportunity o: opps) {
                acctId = o.AccountId;
                oppId = o.Id;
                Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                bRV.AccountId__c = o.AccountId;
                if (renewbatchId.size() > 0) {
                    bRV.Batch_Id__c = renewbatchId[0].Id;
                }
                bRV.BusinessRuleId__c = br.Id;    
                bRV.OpportunityId__c = o.Id;
                
                for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(o.id))
                {
                    bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                }
               
                List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(o.Id);
                
                if(censuses.size()>0){
                    for (SGR_Opportunity_Census__c oc: censuses) {
                       
                        
                        if(count == true)
                        {
                            Break;
                        }
                        if ((oc.Member_Effective_Date__c <=o.Renewal_Date__c) && (oc.Member_Cancel_Date__c > =o.Renewal_Date__c || oc.Member_Cancel_Date__c == null) && oc.Membership_Number__c == 1) 
                        {
                            
                            for(SGR_Opportunity_Census__c actoc:censuses){
                                if(oc.Subscriber_Number__c==actoc.Subscriber_Number__c)
                                { 
                                   
                                    
                                    if(actoc.Employee_Status_Code__c!='C')
                                    {
                                        noOfYears = (actoc.Date_of_Birth__c.daysBetween(o.Renewal_Date__c))/365;
                                        
                                        
                                        if( noOfYears < 16  && (actoc.Relationship_Code__c=='Domestic Partner' || actoc.Relationship_Code__c=='Subscriber' || actoc.Relationship_Code__c=='Spouse'))
                                        {
                                            bRV.Status__c = 'Failed';  
                                            
                                            bRV.Fail_Pass_Reason__c = ' A Non-Cobra Subscriber Or spouse Or Dependent is Under 16 Year Age. Subscriber Number =' + oc.Subscriber_Number__c;
                                            count = true;
                                            break;
                                            
                                        } 
                                        else {
                                           
                                            bRV.Status__c = 'Passed';
                                            bRV.Fail_Pass_Reason__c = ' There is No Non-Cobra Subscriber Or spouse Or Dependent Under 16 Year Age.'; 
                                            count1 = true;
                                        }
                                        
                                    }
                                    else {
                                        
                                        bRV.Status__c = 'N/A';
                                        bRV.Fail_Pass_Reason__c = 'N/A Cobra Subscriber Only'; 
                                        count2 = true;
                                    } 
                                } 
                            }
                        }
                        else {
                            
                            bRV.Status__c = 'Failed';
                            bRV.Fail_Pass_Reason__c = 'No active subscribers found.';
                            
                        }
                        
                    }
                    
                    
                }
                else
                {
                    bRV.Status__c = 'N/A';
                    bRV.Fail_Pass_Reason__c = ' No Census Found.';
                    
                }
                
                if(count==false && count1==true)
                { 
                    
                    bRV.Status__c = 'Passed';
                    bRV.Fail_Pass_Reason__c = ' There is No Non-Cobra Subscriber Or spouse Or Dependent is Under 16 Year Age.';
                }
                else if(count==false && count1==false && count2 ==true)
                {
                    bRV.Status__c = 'N/A';
                    bRV.Fail_Pass_Reason__c = 'N/A Cobra Subscriber Only';    
                }
                
                
                bsrlst.add(bRV);
            }
            insert bsrlst;                                                          
            ruleProcessMsg = 'BR GR.DV.05 processed successfully.';                                                          
        } 
        
        catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 
                                              'Opportunity', null, 
                                              'SGR_validationHelper.checkforNonCobraSubsribers' + oppId, 'High'); 
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
    public static String activeRetiredsubscriberexist(List<Opportunity> accs,String batchId,String retiredexist,map<id,List<SGR_Opportunity_Census__c>> oppsgrogs,List<SGRRenewalBatch__c> renewbatchId,map<String,SGR_Business_Rule__c> sbrmap,map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop)
    {
        String msg;
        
        List<Business_Rule_Validation_Log__c> bsrlst = new List<Business_Rule_Validation_Log__c>();
        set<string> withoutretired = new set<string>();
        set<string> withretired = new set<string>();
        Boolean count = false;
        Decimal num1;
        
        try{
            if(accs!=null && accs.size()>0){
                for(opportunity opp: accs)
                { 
                    Business_Rule_Validation_Log__c bRV = new Business_Rule_Validation_Log__c();
                    if(opp.HCSC_Division__c!=NULL && opp.HCSC_Division__c=='IL'){
                        bRV.Status__c='N/A';
                        bRV.Fail_Pass_Reason__c='N/A';  
                    }
                    else{
                       
                        //string empstatus;
                        List<SGR_Opportunity_Census__c> censuses = oppsgrogs.get(opp.Id);
                        
                        if(censuses!=null && censuses.size()>0) {
                            for(SGR_Opportunity_Census__c cen:censuses){
                                if(((cen.Member_Cancel_Date__c == null) || (cen.Member_Cancel_Date__c >= opp.Renewal_Date__c)) && cen.Membership_Number__c == 1 && cen.Member_Effective_Date__c <=opp.Renewal_Date__c )
                                {
                                    
                                    if(cen.Relationship_Code__c!=null && (cen.Relationship_Code__c=='Subscriber' || cen.Relationship_Code__c=='SUB') && cen.Employee_Status_Code__c!=null && cen.Employee_Status_Code__c!='R')
                                    {
                                        string str='subscribed and NotRetired';
                                        //empstatus=cen.Employee_Status_Code__c;
                                        
                                        withoutretired.add(str);                                
                                    }else if(cen.Relationship_Code__c!=null && (cen.Relationship_Code__c=='Subscriber' || cen.Relationship_Code__c=='SUB') && cen.Employee_Status_Code__c!=null && cen.Employee_Status_Code__c=='R'){
                                        string str1='subscribed and Retired';
                                        //empstatus=cen.Employee_Status_Code__c;
                                        withretired.add(str1);
                                       
                                        num1 = cen.Subscriber_Number__c;
                                        break;
                                    }else{
                                        
                                        Count = True;
                                    }
                                }
                                else{
                                    
                                    bRV.Status__c='Failed';
                                    bRV.Fail_Pass_Reason__c='No Active Subscriber Found';  
                                }
                            }       
                            if(withoutretired!=null && withoutretired.size()>0 && (withretired==null || withretired.isEmpty()==True)){   
                                
                                bRV.Status__c='Passed';
                                bRV.Fail_Pass_Reason__c=sbrmap.get(retiredexist).Proposed_wording_pass__c;
                            }else{
                                
                                if(((withoutretired==null || withoutretired.isEmpty()==True) && withretired!=null && withretired.size()>0)||(withoutretired!=null && withoutretired.size()>0 && withretired!=null && withretired.size()>0 )){
                                    if(opp.HCSC_Division__c!=NULL && (opp.HCSC_Division__c=='NM' || opp.HCSC_Division__c=='TX')){
                                        bRV.Status__c='Failed';
                                        bRV.Fail_Pass_Reason__c='A Retired subscriber cannot exist in an Opty within a Regulated Market Segment.  Subscriber =' + num1;
                                    }
                                    if(opp.HCSC_Division__c!=NULL && opp.HCSC_Division__c=='MT'){
                                        bRV.Status__c='Failed';
                                        bRV.Fail_Pass_Reason__c='A Retired subscriber cannot exist in an Opty located within a Non Municipality account. Subscriber =' + num1;
                                    }
                                    if(opp.HCSC_Division__c!=NULL && opp.HCSC_Division__c=='OK'){
                                        bRV.Status__c='Failed';
                                        bRV.Fail_Pass_Reason__c='A Retired subscriber cannot exist in an Opty located within a Non Public Entity account.  Subscriber =' + num1;
                                    }  
                                }
                            }
                            if((withretired==null || withretired.isEmpty()==True) && (withoutretired==null || withoutretired.isEmpty()==True) && count==true )
                            { 
                                bRV.Status__c='N/A';
                                bRV.Fail_Pass_Reason__c='No Retiree subscriber exists.';
                            }
                        }else{
                            
                            bRV.Status__c='N/A';
                            bRV.Fail_Pass_Reason__c='No Census Found';
                        }
                    }
                    
                    bRV.AccountId__c=opp.AccountId;
                    bRV.OpportunityId__c=opp.Id;
                    bRV.BusinessRuleId__c=sbrmap.get(retiredexist).id;
                    if(renewbatchId.size()>0)
                    {
                        bRV.Batch_Id__c=renewbatchId[0].id;
                    }
                    for(SGR_Renewal_Batch_Oppty__c  srbo: oppsrbop.get(opp.id))
                    {
                        bRV.Renewal_Batch_Oppty_Id__c=srbo.name;
                    }
                    bsrlst.add(bRV);
                    
                }
                insert bsrlst;
             
                msg='Insertion done.';         
            }
            
        }
        catch(System.NullPointerException e )
        {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.activeRetiredsubscriberexist', 'High');                                                           
            
        }
        return msg;    
    }//END-14510
    
    public static void reinitiationbussrules(List<Opportunity> opprs){
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> failedBROpp = new Map<Id,Opportunity>();
        List<Opportunity> failerrOpprList = new List<Opportunity>();
        List<Business_Rule_Validation_Log__c> brLogList = new List<Business_Rule_Validation_Log__c>();
        try{
            for(Opportunity opp :opprs){
                oppMap.put(opp.id,opp);
            }
            
            brLogList = [SELECT Id, OpportunityId__c,Status__c,Rule_Type__c FROM Business_Rule_Validation_Log__c WHERE OpportunityId__c IN :oppMap.keySet()];
            for(Business_Rule_Validation_Log__c brLog : brLogList){
                
                if(!failedBROpp.containskey(brLog.OpportunityId__c) && (String.isNotBlank(brLog.Status__c) && brLog.Status__c.equalsIgnoreCase('Failed'))){
                    
                    failedBROpp.put(brLog.OpportunityId__c,oppMap.get(brLog.OpportunityId__c));
                }
            }
            if(failedBROpp!=null){
                
                failerrOpprList = failedBROpp.values();
                
                for(Opportunity failOppr : failerrOpprList){
                    
                    createtask(opprs);  
                    
                }   
                
            }
            
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.creatingtask', 'High');
        }
    }
    
    public static void reinitiationbussrulesagg(List<Opportunity> opprs){
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> failedBROpp = new Map<Id,Opportunity>();
        List<Opportunity> failerrOpprList = new List<Opportunity>();
        List<Opportunity> finalopp = new List<Opportunity>();
        List<Business_Rule_Validation_Log__c> brLogList = new List<Business_Rule_Validation_Log__c>();
        try{
            for(Opportunity opp :opprs){
                oppMap.put(opp.id,opp);
            }
            
            brLogList = [SELECT Id, OpportunityId__c,Status__c,Rule_Type__c FROM Business_Rule_Validation_Log__c WHERE OpportunityId__c IN :oppMap.keySet()];
            for(Business_Rule_Validation_Log__c brLog : brLogList){
                
                if(!failedBROpp.containskey(brLog.OpportunityId__c) && (String.isNotBlank(brLog.Status__c) && brLog.Status__c.equalsIgnoreCase('Failed')) && brLog.Rule_Type__c.equalsIgnoreCase('E')){
                    
                    failedBROpp.put(brLog.OpportunityId__c,oppMap.get(brLog.OpportunityId__c));
                }
            }
            if(failedBROpp!=null && failedBROpp.size()>0 ){
                
                failerrOpprList = failedBROpp.values();
                
                for(Opportunity failOppr : failerrOpprList){
                    
                    createtask(opprs);  
                    
                }   
                
            }
            else
            {
                
                for(Opportunity opp : opprs){
                    opp.Rating_Status__c = 'Initiated';
                    opp.SGR_Workflow_Activity__c = '';
                    opp.Workflow_System_Status__c = 'Ready to Rate';
                    
                    finalopp.add(opp);
                }   
            }
            if(finalopp!=null && finalopp.size()>0){
                
                update finalopp;
            }
            
        }catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Opportunity', null, 'SGR_validationHelper.creatingtask', 'High');
        }
    }
    
    
    
    
    
    public static void createtask(List<Opportunity> opps1)
    {
        Id sgrTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SGR_Task').getRecordTypeId(); 
        list<Task> task = new list<Task>();
        
        List<Opportunity> opps=opps1;
        
        for(Opportunity op:opps ){
          
            Task opp = new Task();
            opp.OwnerId=op.Assigned_UW__c;
            opp.Priority='Normal';
            opp.Status='Not Started' ;   
            opp.Subject='Data Review Complete';
            opp.WhatId=op.Id;
            opp.RecordTypeId=sgrTask;
            
            task.add(opp);
            
        }
        
        if(!task.isEmpty()){
            try{
               
                Insert task;
                firsttime=true;
            }
            
            catch(exception e){
            	e.getmessage();
                
            }
        }
        
    }
    
 
}