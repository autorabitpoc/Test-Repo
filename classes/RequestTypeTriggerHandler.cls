public class RequestTypeTriggerHandler {
	public static void setCaseNITypeSelections(List<Request_Type__c> requestTypeList){
		List<Case> updatedCases = new List<Case>();
		
		List<Id> caseIds = new List<Id>();
		for(Request_Type__c rt: requestTypeList){
			caseIds.add(rt.Case__c);
		}
		Id networkInformationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.CaseRecordTypeNetworkInformation).getRecordTypeId();
		Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, NI_Type__c FROM Case WHERE Id IN :caseIds AND RecordTypeId =: networkInformationRecordTypeId]);

		List<Request_Type__c> childrenRequestTypes = [SELECT Id, Case__c, Proposal_NI_Type__c, Number_Of_Requests__c FROM Request_Type__c WHERE Case__c IN :caseMap.keySet()];
		
		Map<Case, List<Request_Type__c> > requestTypeMap = new Map<Case, List<Request_Type__c> >();
		for(Case c: caseMap.values()){
			requestTypeMap.put(c, new List<Request_Type__c>());
		}

		for(Request_Type__c rt: childrenRequestTypes){
			if(requestTypeMap.containsKey(caseMap.get(rt.Case__c))){
				requestTypeMap.get(caseMap.get(rt.Case__c)).add(rt);
			}
			else{
				List<Request_Type__c> rtList = new List<Request_Type__c>{rt};
				requestTypeMap.put(caseMap.get(rt.Case__c), rtList);				
			}
		}

		for(Case c: requestTypeMap.keySet()){
			String selectedNITypes = ';';
			for(Request_Type__c rt: requestTypeMap.get(c)){
				selectedNITypes += rt.Proposal_NI_Type__c+';';
			}
			c.NI_Type__c = selectedNITypes;
		}
		update new List<Case>(requestTypeMap.keySet());
	}
}