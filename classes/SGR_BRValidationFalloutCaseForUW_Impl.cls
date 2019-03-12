public  class SGR_BRValidationFalloutCaseForUW_Impl implements SGR_BRValidationCaseService  {
    public   void  createCases(List<Opportunity> opportunityIdList) {
        
        List<opportunity> opportunityList = [SELECT Id, 

AccountId,SGR_Account_Number__c,Account.name,Assigned_UW__c,HCSC_Division__c,Account_Market_Segment__c,
                                                (   SELECT Id, Name
                                                    FROM BusinessRuleValidationLogs__r 
                                                     WHERE  SGR_caseId__c = null AND Status__c = 'Failed'
                                                    LIMIT 200
                                                )
                                            FROM Opportunity
                                            WHERE Id IN :opportunityIdList
                                            ];
        
        Map<String, Case> opportunityCaseMap = createOpportunityCase(opportunityList);
        updateErrorLogsCaseLookup(opportunityList, opportunityCaseMap);

    }

    //This is for Inserting the cases into data base
    public   Map<String, Case> createOpportunityCase(List<Opportunity> opptyList){
        List<Case> caseList = new List<Case>();
        Map<String, Case> opptyCaseMap = new Map<String, Case>();

        for(Opportunity oppty: opptyList ) {
            if(oppty.BusinessRuleValidationLogs__r.size() > 0){
                caseList.add(getCaseDefaultsByOpportunity(oppty));
            }
        }
        insert caseList;
           
        for(Case c: caseList){
            opptyCaseMap.put(c.Opportunity_Name__c, c);
        }

        return opptyCaseMap;
    }

    //This is for updating the Case Id on Business Rule validation Log
    public  void  updateErrorLogsCaseLookup(List<Opportunity> opportunityList, Map<String, Case> 

opportunityCaseMap) {

        List<Business_Rule_Validation_Log__c> errorLogsToUpdate = new 

List<Business_Rule_Validation_Log__c>();
        for(Opportunity oppty: opportunityList){
            Case opptyCase = opportunityCaseMap.get(String.valueOF(oppty.Id));

            for(Business_Rule_Validation_Log__c errorLog : oppty.BusinessRuleValidationLogs__r ){
            errorLog.SGR_caseId__c = opptyCase.Id;
                errorLogsToUpdate.add(errorLog);
            }
        }

        update errorLogsToUpdate;
    }

    //This is for setting up the data for the cases to Insert
    public  Case getCaseDefaultsByOpportunity(Opportunity oppty) {
        Case opptyCase = new Case();
        opptyCase.Opportunity_Name__c = oppty.Id;
        Id sgrCaseRecId = Schema.SObjectType.case.getRecordTypeInfosByName().get('SGR-Renewals').getRecordTypeId();
        opptyCase.RecordTypeId=sgrCaseRecId;       
        opptyCase.Subject='Business Rule Validation Fallout';
        opptyCase.Origin='Business Rule Validation Fallout';
        opptyCase.Reason='Business Rule Validation Fallout';
        opptyCase.SGRAccountName__c=oppty.Account.name;
        opptyCase.AccountId = oppty.AccountId;
        opptyCase.SGR_AccountNumber__c=oppty.SGR_Account_Number__c;
        opptyCase.HCSC_Division__c=oppty.HCSC_Division__c;
        opptyCase.Status='New';
        opptyCase.SGR_MarketSegment__c=oppty.Account_Market_Segment__c;
        opptyCase.Description='Case Created due to Failure of  Business validations';
       
         return opptyCase;
    }
}