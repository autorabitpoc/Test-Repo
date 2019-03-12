/****************************************************************************************************
  Apex Class Name     : BatchCreateCededRenewalCase
  Version             : 1.0
  Function            : This class creates and inserts new ceded renewal cases for qualifed accounts. 
  Modification Log    :
  Developer                  Date                  Description
  ----------------------------------------------------------------------------
  Zachary Campbell    :      November 4 2016       Original Version
*****************************************************************************************************/
global class BatchCreateCededRenewalCase implements Database.Batchable<sObject> {

    public String query;

    global BatchCreateCededRenewalCase() {
    }

	/******************************************************************************************
	* @description First method run of the batch to grab all records in query
	* @param BC Internal Apex object for running batch jobs
	* @return Database.querylocator Object that contains the query results
	******************************************************************************************/
    global Database.querylocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

	/******************************************************************************************
	* @description This method runs for each batch of records in the job. 
	* @param BC	   Internal Apex object for running batch jobs
	* @param scope List<Account> containg the records to be processed in this batch
	******************************************************************************************/
    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        Datetime maxCaseDate;
        Id maxCaseId;
		List<Case> newCases = new List<Case>();
        Map<Id, List<Case>> allCaseMap = new Map<Id, List<Case>>();
		Map<Id, Case> acctCaseMap = new Map<Id, Case>();
        
        try{
            List<Case> allCases = [SELECT Id, CaseNumber, CreatedDate, Case_Owner__c, Subject, Description, AccountID,  
                        		   Account_Name__c, Account_Number__c, Account_Owner__c, Account_Type__c, Alpha_Prefix__c, Origin, 
                        		   Cede_Conditions__c, Ceded_From_ICL__c, Ceded_To_ACL__c, Cede_Effective_Date__c, Cede_Fee__c,
                        		   Cede_Receipt_Date__c, Cede_End_Date__c, Decision_Maker__c, Expected_Health_Contracts__c, 
                        		   Expected_Health_Members__c, Funding_Type__c, HQ_Address__c, IPPER_Contracts__c, 
                        		   IPPER_Date__c, Labor__c, Labor_Type__c, Multi_State_Case__c, Priority,  
                        		   Producer_Account__c, Purpose_of_Cede__c, Subsidiaries__c, Type, OwnerID
                 				   FROM  	Case 
                 				   WHERE 	AccountID IN :scope
                 				   AND		RecordType.Name = 'Cede'
                    			   AND		Status = 'Approved'];
			
            //add selected cases to map list
            for(Case cases : allCases){
                List<Case> caseList = new List<Case>();
                if(allCaseMap.containsKey(cases.AccountId)){
                    caseList = allCaseMap.get(cases.AccountId);
                }
                caseList.add(cases);
                allCaseMap.put(cases.AccountId, caseList);
            }

            for(sObject aa : scope){
				//clear and initialize variables/list for case loop
                Account newAccount = (Account)aa;
            	if(allCaseMap.containsKey(newAccount.Id)){
                    maxCaseDate = Date.newInstance(1,1,1);
       				maxCaseID = null;
                    acctCaseMap.clear();
					for (Case curCase : allCaseMap.get(newAccount.Id)){
            			//find most current case id
                		if (curCase.createdDate > maxCaseDate){
	                   		maxCaseDate = curCase.createdDate;
                    		maxCaseID = curCase.Id;
                        	//create map of most current case
                            acctCaseMap.put(curCase.Id, curCase);
                		}
        			}
					Case cc = acctCaseMap.get(maxCaseId);
                    if (cc.Cede_End_Date__c.addDays(-180) == date.today()){
                    	//update cede case with specified values for cloning
                    	cc.status = 'New';
                		cc.Cede_Effective_Date__c = cc.Cede_End_Date__c.addDays(1);
                        cc.Opportunity_Name__c = null;
                        cc.Cede_End_Date__c = null;
                        Case cloneCase = cc.clone(false,false);
                        cloneCase.OwnerId = cc.OwnerId;
                   		newCases.add(cloneCase);
                    }
        		}
			}
			insert(newCases);
            
 		} catch(Exception e){
        	System.debug( 'Exception in Create Cede Renewal Case Batch: ' + e.getMessage() );
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}