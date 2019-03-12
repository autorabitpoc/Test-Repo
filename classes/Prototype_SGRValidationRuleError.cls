public class Prototype_SGRValidationRuleError  {

    private static final String RULE_GRDV01_FAIL_MESSAGE = 'Account has no active Benefit Aggrement';
    private static final String RULE_GRDV01_PASS_MESSAGE = 'Account has  active Benefit Aggrement';
    private static final String RULE_GRDV02_FAIL_MESSAGE = 'Account has no active Subscribers';
    private static final String RULE_GRDV02_PASS_MESSAGE = 'Account has active Subscribers';
    private static final String RULE_GRDV07_FAIL_MESSAGE = 'County Code is missing';
    private static final String RULE_GRDV07_PASS_MESSAGE = 'County Code is available';
    private static final String RULE_GRDV09_FAIL_MESSAGE_1 = 'Dependents exist for an Employee Only Tier. Subscriber Number(s) : ';
    private static final String RULE_GRDV09_FAIL_MESSAGE_2 = 'No Active Subscribers Found';
    private static final String RULE_GRDV09_PASS_MESSAGE = 'No Invalid Employee Only Tier Exist';
/*  
RUle Description: 
    GR.DV.01:   Active Account with no active Benefit Agreements
    GR.DV.02:   No active subscribers exist for this account.
    GR.DV.06:   Account level Zip Code is not valid.
    GR.DV.07:   County Code is missing
    GR.DV.09:   Dependents exist for an 'Employee Only' (EO) tier
    GR.DV.10:   More than one dependent with relationship type of Spouse or Domestic Partner  or Civil Union Spouse exists per subscriber
    GR.DV.11:   Dependents exist with no relationship code
    GR.DV.12:   One or more Employee Spouse (ES) tiers exist which do not contain a Spouse or Domestic Partner.  ES tier can also not contain Child(ren). 
    GR.DV.13:   One or more Employee Child(ren) (EC) tiers exist which does not contain one or more children.  EC tier can also not contain a Spouse or Domestic Partner
    GR.DV.14:   One or more Employee Family (EF) tiers exists which does not consist of a Spouse or Domestic Partner AND 1 or more Children.
*/


    /* GR.DV.01:    Active Account with no active Benefit Agreements */
    public Static Business_Rule_Validation_Log__c RuleGRDV01(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        Business_Rule_Validation_Log__c errorLog = GetErrorLogDefaults(opportunity, rule);
        String messageValue = RULE_GRDV01_FAIL_MESSAGE;
        if(opportunity.HasActiveBenefitAgreement) {
            messageValue = RULE_GRDV01_PASS_MESSAGE;
        }

        errorLog.Fail_Pass_Reason__c = messageValue;

        return errorLog;
    }

        /* GR.DV.01:    Active Account with no active Benefit Agreements */
    public Static List<Business_Rule_Validation_Log__c> RuleGRDV01_Bulk(List<Prototype_OpportunityModel> opportunityList, SGR_Business_Rule__c rule) {
        Business_Rule_Validation_Log__c errorLog;
        List<Business_Rule_Validation_Log__c> errorLogList = new List<Business_Rule_Validation_Log__c>();
        
        String messageValue = RULE_GRDV01_FAIL_MESSAGE;
        
        for(Prototype_OpportunityModel oppty : opportunityList) {
            errorLog = GetErrorLogDefaults(oppty, rule);
            if(oppty.HasActiveBenefitAgreement) {
                messageValue = RULE_GRDV01_PASS_MESSAGE;
            }

            errorLog.Fail_Pass_Reason__c = messageValue;
            errorLogList.add(errorLog);
        }

        return errorLogList;
    }
    
    /*GR.DV.02: No active subscribers exist for this account. */
    public Static Business_Rule_Validation_Log__c RuleGRDV02(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        Boolean hasActiveSubscriber = ComputeHasActiveSubscribers(opportunity);
        Business_Rule_Validation_Log__c errorLog = GetErrorLogDefaults(opportunity, rule);
        String messageValue = RULE_GRDV02_FAIL_MESSAGE;

        if(hasActiveSubscriber) {
            messageValue = RULE_GRDV02_PASS_MESSAGE;
        }

        return errorLog;
    }
    
    /*GR.DV.06: Account level Zip Code is not valid. */
    public Static Business_Rule_Validation_Log__c RuleGRDV06(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        System.debug('GR.DV.06: Account level Zip Code is not valid.');

         return new Business_Rule_Validation_Log__c();
    }
    
    /*GR.DV.07: County Code is missing */
    public Static Business_Rule_Validation_Log__c RuleGRDV07(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        Business_Rule_Validation_Log__c errorLog = GetErrorLogDefaults(opportunity, rule);
        String messageValue = RULE_GRDV07_FAIL_MESSAGE;

        if(opportunity.ISCountyCodeMissing) {
            messageValue = RULE_GRDV07_PASS_MESSAGE;
        }

        errorLog.Fail_Pass_Reason__c = messageValue;

        return errorLog;
    }
    
    /*GR.DV.09: Dependents exist for an 'Employee Only' (EO) tier */
    public Static Business_Rule_Validation_Log__c RuleGRDV09(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        Business_Rule_Validation_Log__c errorLog = GetErrorLogDefaults(opportunity, rule);

        Map<String, List<SGR_Opportunity_Member_Benefits__c>> EmployeeOnlyBySubscriber = GetMemberBenefitTierEmployeeOnly(opportunity);
        //bool hasSucess = false;
        boolean hasErrors = false;

        for(string SubscriberId: EmployeeOnlyBySubscriber.KeySet())
        {
            List<SGR_Opportunity_Member_Benefits__c> memberList = EmployeeOnlyBySubscriber.get(SubscriberId);

            /*f()
            for(SGR_Opportunity_Member_Benefits__c memberBenefit: memberList) {
                
                if(memberBenefit.Opportunity_Census__r.Membership_Number__c == 1 && )
            }*/
        }

        if(hasErrors) {

        }

         return errorLog;
    }
    
    /*GR.DV.10:   More than one dependent with relationship type of Spouse or Domestic Partner  or Civil Union Spouse exists per subscriber*/
    public Static Business_Rule_Validation_Log__c RuleGRDV10(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        System.debug(' GR.DV.10:   More than one dependent with relationship type of Spouse or Domestic Partner  or Civil Union Spouse exists per subscriber');
    
        return new Business_Rule_Validation_Log__c();
    }
    
    /*GR.DV.11:   Dependents exist with no relationship code */
    public Static Business_Rule_Validation_Log__c RuleGRDV11(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        System.debug('GR.DV.11:   Dependents exist with no relationship code');
    
         return new Business_Rule_Validation_Log__c();
    }
    
    /*GR.DV.12:   One or more Employee Spouse (ES) tiers exist which do not contain a Spouse or Domestic Partner.  ES tier can also not contain Child(ren).  */
    public Static Business_Rule_Validation_Log__c RuleGRDV12(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        System.debug('GR.DV.12:   One or more Employee Spouse (ES) tiers exist which do not contain a Spouse or Domestic Partner.  ES tier can also not contain Child(ren). ');
    
        return new Business_Rule_Validation_Log__c();
    }
    
    /*GR.DV.13:   One or more Employee Child(ren) (EC) tiers exist which does not contain one or more children.  EC tier can also not contain a Spouse or Domestic Partner */
    public Static Business_Rule_Validation_Log__c RuleGRDV13(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        System.debug('GR.DV.13:   One or more Employee Child(ren) (EC) tiers exist which does not contain one or more children.  EC tier can also not contain a Spouse or Domestic Partner ');
    
         return new Business_Rule_Validation_Log__c();
    }
    
    /*GR.DV.14:   One or more Employee Family (EF) tiers exists which does not consist of a Spouse or Domestic Partner AND 1 or more Children. */
    public Static Business_Rule_Validation_Log__c RuleGRDV14(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule) {
        System.debug('GR.DV.14:   One or more Employee Family (EF) tiers exists which does not consist of a Spouse or Domestic Partner AND 1 or more Children.');
    
         return new Business_Rule_Validation_Log__c();
    }


    /* Private Methods */

    private Static Business_Rule_Validation_Log__c GetErrorLogDefaults(Prototype_OpportunityModel opportunity, SGR_Business_Rule__c rule){
        Business_Rule_Validation_Log__c errorLog = new Business_Rule_Validation_Log__c();
        //errorLog.Name =  String.format('{0} - {1}', new String[] { rule.Name, String.valueOf(System.Now()) });
        errorLog.AccountId__c = opportunity.currentOpportunity.AccountId;
        errorLog.OpportunityId__c = opportunity.currentOpportunity.Id;
        
        //errorLog.Batch_Id__c = opportunity.currentOpportunity.Batch_Id__c;
        return errorLog;
    }

    private Static Boolean ComputeHasActiveSubscribers(Prototype_OpportunityModel opportunity) {
        Boolean hasActiveSubscriber = false;
        Date currentDate = System.Now().Date();

        for(SGR_Opportunity_Census__c member: opportunity.censusList) {
            if(member.Membership_Number__c == 1 && 
                member.Member_Effective_Date__c <= currentDate && 
                (member.Member_Cancel_Date__c == null || member.Member_Cancel_Date__c > currentDate))
                {
                    hasActiveSubscriber = true;
                    break;
                }
        }

        return HasActiveSubscriber && opportunity.hasActiveBenefitAgreement;
    }

    private static Map<String, List<SGR_Opportunity_Member_Benefits__c>> GetMemberBenefitTierEmployeeOnly(Prototype_OpportunityModel opportunity) {
        return new Map<String, List<SGR_Opportunity_Member_Benefits__c>>();
    }

}