/**************************************************************************************
  Apex Class Name     : SGR_GenerateAgeRateTablesBatch     
  Version             : 1.0
  Function            : This class is used to generate Age rate tables on monthly basis based on Dental or Health/Vision Plans.
  Modification Log    :
* Developer:Akbar Hussain Salisabgari    Date: 4/9/2018                   Description
* ----------------------------------------------------------------------------               
* INFOSYS                  09/05/2018                Original Version
*************************************************************************************/
global class SGR_GenerateAgeRateTablesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	
    public Date renewEffDate=system.today().addDays(Integer.valueOf(System.label.SGR_URE_FIPS_AddDays));
	public String planType;
	public Integer requestType;
	public String applicationId;
	public String marketSegment;
	public boolean isExchange;
	public String stateCode=null;
	public String fipsCode=null;
	public List<String> taskList;
	//List<SGR_Plan_Age_Rate_Detail__c> listOfARDToInsert =  new List<SGR_Plan_Age_Rate_Detail__c>();
	global SGR_GenerateAgeRateTablesBatch(Date effectiveDate, String typeOfPlan, Integer requestType,
			String applicationId, String marketSegment, boolean isExchange) {
				
                
       if(effectiveDate!=null){
			this.renewEffDate = effectiveDate;//.addDays(Integer.valueOf(System.label.SGR_URE_FIPS_AddDays));
        }
		this.planType = typeOfPlan;
		this.requestType = requestType;
		this.applicationId = applicationId;
		this.marketSegment = marketSegment;
		this.isExchange = isExchange;
        
	}
	global SGR_GenerateAgeRateTablesBatch(Date effectiveDate,String state, String fipsCode, String typeOfPlan, Integer requestType,
			String applicationId, String marketSegment, boolean isExchange) {
				
                
       if(effectiveDate!=null){
			this.renewEffDate = effectiveDate;//.addDays(Integer.valueOf(System.label.SGR_URE_FIPS_AddDays));
        }
		this.planType = typeOfPlan;
		this.requestType = requestType;
		this.applicationId = applicationId;
		this.marketSegment = marketSegment;
		this.isExchange = isExchange;
		this.stateCode=state;
		this.fipsCode=fipsCode;
        
	}
	

	global Database.QueryLocator start(Database.BatchableContext BC) {       
       System.debug('rate eff date'+renewEffDate);
        String query;
        String closingQueryStm=' ORDER BY FIPS_Code__c';
        if(String.isNotBlank(planType)&& planType.equalsIgnoreCase('Dental')){
            query = 'SELECT SGR_Plan_Id__c,FIPS_Code__c,Division__c,Corporate_Entity_Code__c,Rate_Effective_Date__c FROM SGR_URE_Age_Rate_Driver__c WHERE Rate_Effective_Date__c=:renewEffDate AND Market_Segment__c=:marketSegment AND Line_Of_Business__c=\'D\' ';
        }else{
           query = 'SELECT SGR_Plan_Id__c,FIPS_Code__c,Division__c,Corporate_Entity_Code__c,Rate_Effective_Date__c FROM SGR_URE_Age_Rate_Driver__c WHERE Rate_Effective_Date__c=:renewEffDate AND Market_Segment__c=:marketSegment AND (Line_Of_Business__c!=\'D\' OR Line_Of_Business__c=null)';
        }
        
        if(stateCode!=null){
        	query=query + 'AND Division__c=\''+stateCode+'\'';
        }
        if(fipsCode!=null){
        	query=query+ ' AND FIPS_Code__c=\''+fipsCode+'\'';
        }
        query=query+closingQueryStm;
        
       	System.debug('query:' + query);
        return Database.getQueryLocator(query);
        
    }

	global void execute(Database.BatchableContext BC, List<SGR_URE_Age_Rate_Driver__c> scope) {
		
		try {
            
            //listOfARDToInsert.addAll(SGR_URE_GetAgeRateshelper.generateAgeRateTables(scope,renewEffDate,planType,requestType,applicationId,marketSegment,isExchange));
            SGR_URE_GetAgeRateshelper.generateAgeRateTables(scope,renewEffDate,planType,requestType,applicationId,marketSegment,isExchange);               		
         	//System.debug('listOfARDToInsert::'+listOfARDToInsert.size());
           // System.debug('listOfARDToInsert::'+listOfARDToInsert);
		} catch (Exception ex) {
            
            //system.debug('Exception'+ ex);
            //system.debug('********** Inside Exception******'+resObjList);
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_Age_Rate_Driver__c', null, 'SGR_GenerateAgeRateTablesBatch.execute', 'High');
        }
    }

	global void finish(Database.BatchableContext BC){
   		//System.debug('Inside finish, listOfARDToInsert::'+ listOfARDToInsert.size());
   		//Database.executeBatch(new SGR_URE_InsertAgeRateDetailsBatch(listOfARDToInsert),2000); //@Akbar - added batch size to 2000
    }
}