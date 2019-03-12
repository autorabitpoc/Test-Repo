global class SGR_URE_InsertAgeRateDetailsBatch implements Database.batchable<SGR_Plan_Age_Rate_Detail__c>  {
	public List<SGR_Plan_Age_Rate_Detail__c> details;
	
	global SGR_URE_InsertAgeRateDetailsBatch(List<SGR_Plan_Age_Rate_Detail__c> details) {
		this.details = details;		
	}
	
   	global Iterable<SGR_Plan_Age_Rate_Detail__c> start(Database.batchableContext info){
         System.debug('inside batch2'+details.size());      
    	 SGR_URE_AgeRateDetailIterator iter = new SGR_URE_AgeRateDetailIterator(details);
         System.debug('inside batch2--iterator'+iter);
    	 return iter.source; //@Akbar - returning source instead of iter obj
   	}     
   	
   	global void execute(Database.batchableContext info, List<SGR_Plan_Age_Rate_Detail__c> scope){ 
		// do something with scope
       System.debug('inside batch2scope'+scope.size());
        //insert scope; //@Akbar - added upsert logic instead of insert
        Schema.SObjectField extID = SGR_Plan_Age_Rate_Detail__c.Fields.Plan_Detail_External_ID__c;
        Database.UpsertResult [] results = Database.upsert(scope, extID, false);
		Utility.createErroLog(results); 
   	}     
   
   	global void finish(Database.batchableContext info){     
   		// do something
   	}  
}