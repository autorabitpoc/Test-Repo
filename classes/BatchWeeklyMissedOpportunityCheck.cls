/**************************************************************************************
  Apex Class Name     : BatchWeeklyMissedOpportunityCheck
  Version             : 1.0
  Function            : This is a class for checking if opportunities were modified in the past week.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				6/7/2016
*************************************************************************************/
global class BatchWeeklyMissedOpportunityCheck implements Database.Batchable<SObject>, Schedulable{
    
	private String query = 'SELECT Id, IsClosed, LastModifiedDate, Number_Of_Misses__c, Missed_Last_Week__c, Non_Admin_Last_Modified_Date__c FROM Opportunity WHERE IsClosed = False';
	@testVisible private OpportunityDAO.IOpportunityDAO opportunityDAOInstance;
	private final Integer NUM_DAYS_IN_WEEK = 7;
	
	public BatchWeeklyMissedOpportunityCheck(){
		this(new OpportunityDAO());
	}
	
	@testVisible private BatchWeeklyMissedOpportunityCheck(OpportunityDAO.IOpportunityDAO opportunityDAOInstance){
		this.opportunityDAOInstance = opportunityDAOInstance;
	}

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<Opportunity> scope) {
		ConstantsController.canMakeFutureCalls = False;        
		List<Opportunity> updateOpps = new List<Opportunity>();
		for(Opportunity o: scope){
            o.Bypass_Validation__c = True;
            if(o.Number_Of_Misses__c == null){
                o.Number_Of_Misses__c = 0;
            }
            
            if(o.Non_Admin_Last_Modified_Date__c == null){
                o.Number_Of_Misses__c++;
                o.Missed_Last_Week__c = True;
                updateOpps.add(o);
            }
            else if(Math.abs(System.now().date().daysBetween(o.Non_Admin_Last_Modified_Date__c)) > NUM_DAYS_IN_WEEK){
                o.Number_Of_Misses__c++;
				o.Missed_Last_Week__c = True;
				updateOpps.add(o);
            }
			else{
				if(o.Missed_Last_Week__c == True){
					o.Missed_Last_Week__c = False;
					updateOpps.add(o);
				}
			}
        }
		try{
			Database.update(updateOpps, false);
		} catch(Exception e){
			CreateExceptionLog.insertErrorLog(e, null, null, null, 'Batchable Apex Class', 'Opportunity', null, 'BatchWeeklyMissedOpportunityCheck.execute()','High');
		}
    }
    
    global void finish(Database.BatchableContext context) {
		
    }

	global void execute(SchedulableContext sct){
		BatchWeeklyMissedOpportunityCheck newBatch = new BatchWeeklyMissedOpportunityCheck();
		Database.executeBatch(newBatch, 200);
	}
}