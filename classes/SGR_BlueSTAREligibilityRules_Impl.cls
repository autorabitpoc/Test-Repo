/**************************************************************************************
  Apex Class Name     : SGR_BlueSTAREligibilityRules_Impl  
  Version             : 1.0
  Function            : This class is to validate(Transfer eligibilty rules) List of Opportunity
  Modification Log    	:
* Developer: Vijaya Channamsetti  Date: 12/20/2018                   Initial version
* ---------------------------------------------------------------------------- 
*************************************************************************************/

public class SGR_BlueSTAREligibilityRules_Impl implements SGR_BRValidationService{
    private static final string passed = 'Passed';
    private static final string failed = 'Failed';
    public Group opsQueue;
	public Set<Id> validate(Set<Id> oppIds){
        Set<Id> passList;
        try{
            opsQueue =[select Id from Group where  Type = 'Queue' AND NAME = 'SGR - Operations Queue'];
            List<Opportunity> opps = [Select Id, HCSC_Division__c, SGR_Account_Number__c, Account.Name, Assigned_UW__c,
                                     (SELECT Id, Name FROM BusinessRuleValidationLogs__r where Status__c = 'Failed' AND (Rule_ID__c = 'PR.DP.09.c' OR Rule_ID__c = 'PR.DP.09.h' OR Rule_ID__c = 'PR.DP.09.j')),
                                     (select Id, Processing_Status__c from SGR_Renewal_Batch_Opptys__r),
                                     (Select Plan__c, Plan_Status__c, Plan_Type__c, Opportunity__r.HCSC_Division__c, Opportunity__c, Marketing_Plan_ID__c, 
                                     Mapping_From_Plan_Id__c, Invitro_TX_only__c, Is_HSA__c, Coverage_Type__c, Health_Rating_Area_Number__c, Plan__r.MappedPlan__c 
                                     From Opportunity_Plan_Rates__r where Type__c='Renewal' AND Plan_Status__c='Sold') FROM Opportunity WHERE Id IN :oppIds];
            Set<Id> optyIds = new Set<Id>();
            List<SGR_Renewal_Batch_Oppty__c> optyRenBatch = new List<SGR_Renewal_Batch_Oppty__c>();
            Map<String, List<SGR_Renewal_Batch_Oppty__c>> optyRenBatchMap = new Map<String, List<SGR_Renewal_Batch_Oppty__c>>();
            Boolean isPassed = false;
            
            Boolean isPassedTX = false;
            Boolean isPassedNMMT = false;
            Boolean isPassedALLStates = false;
            
            Map<String, List<SGR_Opportunity_Plan_Rate__c>> optyPlanRates = new Map<String, List<SGR_Opportunity_Plan_Rate__c>>();
            passList = new Set<Id>();
            List<Opportunity> failList = new List<Opportunity>();
            Map<string, SGR_Business_Rule__c> ruleMap = new Map<string, SGR_Business_Rule__c>();
            Map<String, String> optyDivs = new Map<String, String>();
            Map<String, Opportunity> optyMap = new  Map<String, Opportunity>();
            for(SGR_Business_Rule__c rule : [select Id, Proposed_wording_fail__c, Proposed_wording_pass__c, Rule_Code__c from SGR_Business_Rule__c]){
                ruleMap.put(rule.Rule_Code__c, rule);
            }
            for(Opportunity opty : opps){
                optyIds.add(opty.Id);
                optyDivs.put(opty.Id, opty.HCSC_Division__c);
                optyMap.put(opty.Id, opty);
                optyPlanRates.put(opty.Id, opty.Opportunity_Plan_Rates__r);
                //optyRenBatchMap.put(opty.Id, opty.SGR_Renewal_Batch_Opptys__r);
            }
            system.debug('++++OptyIds.size()---'+optyIds.size());
            system.debug('++++Opty Division---'+opps[0].HCSC_Division__c);
            if(optyIds.size() > 0){
                List<Business_Rule_Validation_Log__c> validationLogs = new List<Business_Rule_Validation_Log__c>();
                for(String key : optyPlanRates.keyset()){
                    List<SGR_Opportunity_Plan_Rate__c> planRates = optyPlanRates.get(key);
                    String division = optyDivs.get(key);
                    //isPassed = false;
                    if(division == 'TX'){
                        if(isHMORulePassed(planRates)){
                            validationLogs.add(createValidation(key, passed, '', ruleMap.get('PR.DP.09.c').Proposed_wording_pass__c, ruleMap.get('PR.DP.09.c').Id));
                            //passList.add(optyMap.get(key));
                            //isPassed = true;
                            isPassedTX = true;
                        }
                        else{
                            //isPassed = false;
                            isPassedTX = false;
                            validationLogs.add(createValidation(key, failed, '', ruleMap.get('PR.DP.09.c').Proposed_wording_fail__c, ruleMap.get('PR.DP.09.c').Id));
                            }
                    }
                    if(division == 'NM' || division == 'MT' ){
                        if(isPlanStatusRulePassed(planRates)){
                            //if(isPassed)
                            //isPassed = true;
                            isPassedNMMT = true;
                            validationLogs.add(createValidation(key, passed, '', ruleMap.get('PR.DP.09.h').Proposed_wording_pass__c, ruleMap.get('PR.DP.09.h').Id));
                           }
                        else{
                            //isPassed = false;
                            isPassedNMMT = false;
                            validationLogs.add(createValidation(key, failed, '', ruleMap.get('PR.DP.09.h').Proposed_wording_fail__c, ruleMap.get('PR.DP.09.h').Id));
                            }
                    }
                    if(isConsolidatedRulePassed(planRates)){
                        //if(isPassed)
                        //isPassed = true; 
                        isPassedALLStates = true;  
                        validationLogs.add(createValidation(key, passed, '', ruleMap.get('PR.DP.09.j').Proposed_wording_pass__c, ruleMap.get('PR.DP.09.j').Id));
                        }
                    else{
                        //isPassed = false;
                        isPassedALLStates = false;
                        validationLogs.add(createValidation(key, failed, '', ruleMap.get('PR.DP.09.j').Proposed_wording_fail__c, ruleMap.get('PR.DP.09.j').Id));
                        }
                    
                   /* if(isPassed)
                       passList.add(optyMap.get(key));
                    else
                       failList.add(optyMap.get(key)); */
                    if(division =='TX'){                    
                        if(isPassedTX == true && isPassedALLStates == true && null != optyMap.get(key))
                            passList.add(optyMap.get(key).Id);
                        else
                            failList.add(optyMap.get(key));
                    }else if(division =='NM' || division == 'MT'){
                        if(isPassedNMMT == true && isPassedALLStates == true && null != optyMap.get(key))
                            passList.add(optyMap.get(key).Id);
                        else
                            failList.add(optyMap.get(key));
                    }else{
                        if(isPassedALLStates == true && null != optyMap.get(key))
                             passList.add(optyMap.get(key).Id);
                        else
                            failList.add(optyMap.get(key));
                    }
                }
                system.debug('****passList size--'+ passlist.size());
                
                system.debug('++++opps[0].Assigned_UW__c--'+opps[0].Assigned_UW__c);
                /*if(failList.size() > 0){
                    updateOptyStatus(failList);
                }*/
                system.debug('++++validationLogs.size()---'+validationLogs.size());
                if(validationLogs.size() > 0){                    
                    insert validationLogs;
                    system.debug('++++Opty validationLogs insert completed---');
                }        
            }
            system.debug('****failList size--'+ failList.size());
            if(failList.size() > 0){
                    for(Opportunity op : failList){
                        //if(optyRenBatchMap.size() > 0){
                        optyRenBatch.addAll(op.SGR_Renewal_Batch_Opptys__r); 
                        //}
                    }
                //optyRenBatch.add(optyRenBatchMap.SGR_Renewal_Batch_Opptys__r); 
                //createCases(failList);
                Map<String, Case> opportunityCaseMap = createOpportunityCase(failList);
                updateOptyStatus(failList);
                UpdateErrorLogsCaseLookup(failList, opportunityCaseMap);
                updateOptyRenBatch(optyRenBatch, 'Validation Failed');
            }
        }
        catch(exception e){
             CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_BlueSTAREligibilityRules_Impl', null, 'SGR_BlueSTAREligibilityRules_Impl.validate','Low'); 
        }
        return passList;
    }
    //HMO Rule
    private Boolean isHMORulePassed(List<SGR_Opportunity_Plan_Rate__c> planRates){
        Boolean isPassed = false;
        system.debug('+++planRates.size()--'+planRates.size());
        for(SGR_Opportunity_Plan_Rate__c planRate : planRates){
            if(planRate.Opportunity__r.HCSC_Division__c == 'TX'){
                if(planRate.Plan_Type__c == 'HMO'){
                    isPassed = false;
                    break;
                }
                else{
                    isPassed = true;
                }
            }
        }
        return isPassed;
    }
    //Plan status rule
    private Boolean isPlanStatusRulePassed(List<SGR_Opportunity_Plan_Rate__c> planRates){
         Boolean isPassed = false;
         for(SGR_Opportunity_Plan_Rate__c planRate : planRates){
             if(planRate.Opportunity__r.HCSC_Division__c == 'NM' || planRate.Opportunity__r.HCSC_Division__c == 'MT'){
                 if(planRate.Plan_Status__c == 'Mapped'){
                     isPassed = false;
                     break;
                 } 
                 else{
                     isPassed = true;
                 }
             }
         }
         return isPassed;
    }
    //Consolidated plan rule
    private Boolean isConsolidatedRulePassed(List<SGR_Opportunity_Plan_Rate__c> planRates){
         Boolean isPassed = false;
         String mappedId;
         for(SGR_Opportunity_Plan_Rate__c planRate : planRates){
             system.debug('+++planRate.Plan__r.MappedPlan__c---'+planRate.Plan__r.MappedPlan__c);
             mappedId = planRate.Plan__r.MappedPlan__c;
             //if(planRate.Plan__r.MappedPlan__c != null && planRate.Plan__r.MappedPlan__c != ''){
             if(mappedId != null && mappedId != ''){
                 isPassed = false;
                 break;
             }else{
                 isPassed = true;
             }
         }
         return isPassed;
    }
    private Business_Rule_Validation_Log__c createValidation(ID optyId, string status, string passMsg, string failMsg, string ruleId){
        Business_Rule_Validation_Log__c log = new Business_Rule_Validation_Log__c();
        log.OpportunityId__c = optyId;
        log.Status__c = status;
        log.Fail_Pass_Reason__c = failMsg;
        log.BusinessRuleId__c = ruleId;
        return log;
    }
    /*private void createCases(List<Opportunity> failedOptys){
        //List<Opportunity> failedOptys = [select id from Opportunity where id IN : failedOptyIds];
        //SGR_BRValidationCaseManager caseMgr = new SGR_BRValidationCaseManager('SGR_BRValidationFalloutCaseForUW');
        
        //if(caseMgr != null){
        if(failedOptys.size() > 0){
            //caseMgr.createCases(failedOptys);
           createCasesforFailList(failedOptys); 
        }
    }*/
    public void updateOptyRenBatch(List<SGR_Renewal_Batch_Oppty__c> failedOptys, String status){
        system.debug('++++Opty Renewal Batch Update---');
        List<SGR_Renewal_Batch_Oppty__c> optyRenBatch = new List<SGR_Renewal_Batch_Oppty__c>();
        if(failedOptys.size() > 0){
            for(SGR_Renewal_Batch_Oppty__c op : failedOptys){
                op.Processing_Status__c = status;
                optyRenBatch.add(op);
            }
            update optyRenBatch;
            system.debug('++++Opty Renewal Batch Update Complete---');
        }
        
    }
    private void updateOptyStatus(List<Opportunity> failedOptys){
        
        for(Opportunity op : failedOptys){
            //SFDC-16647 Updated workflow system status opportunity failed eligibility rules - Padma
            op.SGR_Workflow_Activity__c = system.label.BlueStarFailedEligibility_WorkFlow_Activity_Updated_Status;//'Not Eligible to be Transferred'; 
        	op.Workflow_System_Status__c = system.label.BlueStarFailed_WorkFlow_System_Status_Updated_Value;//Not Eligible to Send to BlueSTAR
        }
        system.debug('updateOptyStatus list'+failedOptys);
        if(failedOptys.size() > 0){
            update failedOptys;
        }
    }
    //Since Global workflow changed commenting below method - Padma -Start
   /* private void updatePassOptyStatus(List<Opportunity> passOptys){
        
        for(Opportunity op : passOptys){
            //SFDC-16647 Updated workflow system status opportunity failed eligibility rules - Padma
            op.SGR_Workflow_Activity__c = system.label.BlueStarPassEligibility_WorkFlow_Activity_Updated_Status;//'Eligible to be Transferred'; 
        }
        system.debug('updateOptyStatus list passOptys'+passOptys);
        if(passOptys.size() > 0){
            update passOptys;
        }
    }*/
   //Since Global workflow changed commenting below method - Padma -End
    /*private void updateOptyStatus(List<Opportunity> failedOptys){
        List<SGR_Opportunity_Plan_Rate__c> pRsToUpdate = new List<SGR_Opportunity_Plan_Rate__c>();
        Set<ID> prIds = new Set<ID>();
        for(Opportunity op : failedOptys){
            for(SGR_Opportunity_Plan_Rate__c pR : op.Opportunity_Plan_Rates__r){
                prIds.add(pR.Id);
            } 
        }    
        Map<String, Object> prOldValues = new Map<String, Object>();
        for(SGR_Opportunity_Plan_Rate__History pr : [Select parentId, OldValue From SGR_Opportunity_Plan_Rate__History where field = 'Plan_Status__c' and ParentId IN : prIds]){
            system.debug('++++pr.OldValue--'+pr.OldValue);
            prOldValues.put(pr.parentId, pr.oldValue);
        }
        system.debug('++++prOldValues--'+prOldValues);
        
        
        for(Opportunity op : failedOptys){
            op.SGR_Workflow_Activity__c = 'Not Eligible to be Transferred';
            op.Rating_Status__c = 'Marketing Release';
            for(SGR_Opportunity_Plan_Rate__c pR : op.Opportunity_Plan_Rates__r){
                if(prOldValues.get(pR.Id) != null && prOldValues.get(pR.Id) != ''){
                	pR.Plan_Status__c = string.valueof(prOldValues.get(pR.Id));
                	pRsToUpdate.add(pR);
                }
                else{
                    pR.Plan_Status__c = '';
                	pRsToUpdate.add(pR);
                }
                    
            }
        }
        if(failedOptys.size() > 0){
        	update failedOptys;
        }
        if(pRsToUpdate.size() > 0){
            Update pRsToUpdate;
        }
    }*/
    
     public   Map<String, Case> createOpportunityCase(List<Opportunity> opptyList){
        system.debug('entered createOpportunityCase');
        List<Case> caseList = new List<Case>();
        Map<String, Case> opptyCaseMap = new Map<String, Case>();

        for(Opportunity oppty: opptyList ) {
            //if(oppty.BusinessRuleValidationLogs__r.size() > 0)
                caseList.add(createCasesforFailList(oppty));
        }
        system.debug('+++++++'+caseList);
        insert caseList;
           
        for(Case c: caseList){
            opptyCaseMap.put(c.Opportunity_Name__c, c);
        }
		system.debug('ended createOpportunityCase');
        return opptyCaseMap;
    }

    //This is for updating the Case Id on Business Rule validation Log
    public  void  UpdateErrorLogsCaseLookup(List<Opportunity> opps1, Map<String, Case> opportunityCaseMap) {
        Set<Id> optyIds = new Set<Id>();
        for(Opportunity opptys: opps1){
			optyIds.add(opptys.Id);       
        }
        //Need this query to get the BusinessRuleValidationLogs__r.
        List<Opportunity> opps = [Select Id, HCSC_Division__c, SGR_Account_Number__c, Account.Name, Assigned_UW__c,
                                   (SELECT Id, Name FROM BusinessRuleValidationLogs__r where Status__c = 'Failed' AND 
                                   (Rule_ID__c = 'PR.DP.09.c' OR Rule_ID__c = 'PR.DP.09.h' OR Rule_ID__c = 'PR.DP.09.j')) 
                                   from Opportunity where Id IN :optyIds];
		system.debug('+++Entered Case update with Bussiness rule Validation logs--');
        List<Business_Rule_Validation_Log__c> errorLogsToUpdate = new List<Business_Rule_Validation_Log__c>();
        system.debug('+++opportunityCaseMap---'+opportunityCaseMap);
        for(Opportunity oppty: opps){
            Case opptyCase = opportunityCaseMap.get(String.valueOF(oppty.Id));
			system.debug('+++optycase.Id---'+opptyCase.id);
            system.debug('+++oppty.BusinessRuleValidationLogs__r.size()---'+oppty.BusinessRuleValidationLogs__r.size());
            for(Business_Rule_Validation_Log__c errorLog : oppty.BusinessRuleValidationLogs__r ){
            	errorLog.SGR_caseId__c = opptyCase.Id;
                errorLogsToUpdate.add(errorLog);
            }
        }
		system.debug('+++update Case with Bussiness rule Validation logs--');
        update errorLogsToUpdate;
    }    
     private  case createCasesforFailList(Opportunity oppty) {
     //public  Case GetCaseDefaultsByOpportunity(Opportunity oppty, string caseOwner, string reason) {
     System.debug('Entered createCasesforFailList');
     
     Id sgrCaseRecId = Schema.SObjectType.case.getRecordTypeInfosByName().get('SGR-Renewals').getRecordTypeId();
       
            Case opptyCase = new Case();
            String accName = oppty.Account.name;
         	system.debug('++++acc Name--'+accName);
         	opptyCase.AccountId = oppty.AccountId;
            opptyCase.RecordTypeId = sgrCaseRecId;
            opptyCase.Subject = 'BlueSTAR Eligibility Fallout';
            opptyCase.Origin = 'BlueSTAR Eligibility Fallout';
            opptyCase.Status = 'New';
            opptyCase.Priority = 'Medium';
            opptyCase.Description = 'Case Created due to Failure of  BlueSTAR Eligibility validations';
            opptyCase.OwnerId =  opsQueue.Id;
            opptyCase.Reason = 'BlueSTAR Eligibility Fallout';
            opptyCase.Opportunity_Name__c = oppty.Id;            
            opptyCase.SGR_AccountNumber__c = oppty.SGR_Account_Number__c;
            opptyCase.SGRAccountName__c = accName;//oppty.Accountname;
            System.debug('++++oppty.HCSC_Division__c---'+oppty.HCSC_Division__c); 
            opptyCase.HCSC_Division__c = oppty.HCSC_Division__c;            
            opptyCase.SGR_MarketSegment__c = 'SG';//oppty.Account_Market_Segment__c;
            System.debug('++++oppty.Assigned_UW__c---'+oppty.Assigned_UW__c);           
            //if(oppty.Assigned_UW__c != '' || oppty.Assigned_UW__c != null)
            opptyCase.AssignedUnderWriter__c = oppty.Assigned_UW__c;
        
        return opptyCase;
    }
}