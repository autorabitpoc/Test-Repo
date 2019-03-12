/**************************************************************************************
  Apex Class Name     : SGR_URE_GenerateAgeRateDriverBatch     
  Version             : 1.0
  Function            : Batch class to populate plan details in Age Rate Driver table
  
* Modification Log    :
* Shankar		11/26/2018		SFDC-14007 - Initial version
* ----------------------------------------------------------------------------               
* INFOSYS                  11/26/2018                Original Version
*************************************************************************************/

public without sharing class SGR_URE_GenerateAgeRateDriverBatch implements Database.Batchable<sObject>, Database.Stateful {
    public List<String> recipientEmailAddr=new List<String>();
    public Date effectiveDate=null;
   
    String className = 'SGR_URE_GenerateAgeRateDriverBatch';
    
    public SGR_URE_GenerateAgeRateDriverBatch(Date effDate) {
    	final String ADMIN_USER_EMAIL_ID= 'salesforceITG@bcbsil.com';
    	
    	List<SGR_EmailDL__c> dlSettingVals = SGR_EmailDL__c.getAll().values();
        
		recipientEmailAddr = new List<String>(); 
		
	    if(effDate!=null){
	    	effectiveDate=effDate;
	    }
				   
		if (null != dlSettingVals) {
			for (SGR_EmailDL__c dl: dlSettingVals) {
				if (dl.TaskName__c == className) {
					recipientEmailAddr.add(dl.To__c);
				}
			}
		}    	
		
		if (recipientEmailAddr !=null && recipientEmailAddr.isEmpty()){
			recipientEmailAddr.add(ADMIN_USER_EMAIL_ID);
       }
    }
    
    public Database.QueryLocator start(Database.BatchableContext context) {
    	

    	String body;
    	String subject;
        String query = null;
		
		String divisions = buildDivClause();
		if (divisions.length() == 1) {
    		body = 'No Divisions found in Division__c custom settings.<br/>Please contact System administrator.<br/>Regards,<br/>AgeRateDriverBatch';
			subject = 'Age Rate Driver batch job failed';
			EmailUtility.circulateEmail(recipientEmailAddr, subject, body);
			return Database.getQueryLocator('SELECT id FROM SGR_Plan_FIPS_Map__c limit 0');
    	}
    	
    	Date firstDate=null;
    	Date lastDate=null;
    	
    	if (effectiveDate == null) {
    		body = 'Invalid effective Date supplied.<br/>Please contact System administrator.<br/>Regards,<br/>AgeRateDriverBatch';
			subject = 'Age Rate Driver batch job failed';
			EmailUtility.circulateEmail(recipientEmailAddr, subject, body);
			return Database.getQueryLocator('SELECT id FROM SGR_Plan_FIPS_Map__c limit 0');
    	}
    	
   		try {
    		firstDate= Date.valueOf(effectiveDate).toStartOfMonth();	    		
			system.debug('first date::'+firstDate);	    		
            lastDate= firstDate.addDays(Date.daysInMonth(firstDate.year(), firstDate.month()) - 1);         

    		query = 'SELECT SGR_Plan_Id__c, FIPS_Code__c, ' +
 								 'Corporate_Entity_Code__c, Division__c, '+ 
 								 'Market_Segment__c, Funding_Type__c, ' +
 								 'Effective_Date__c, Name, Id, 	Plan__r.Line_Of_Business__c ' + 
 								 'FROM SGR_Plan_FIPS_Map__c WHERE ' +
 								 'Division__c IN ' + divisions;
 								 
        	if(firstDate!=null && lastDate!=null){
        		query = query+' AND Effective_Date__c>='+String.ValueOf(firstDate)+ ' AND Effective_Date__c<='+String.ValueOf(lastDate);
        	}
        
     		System.debug('query:' + query);
            return Database.getQueryLocator(query);
     	} catch (exception e){
			system.debug('wrong format of the effective date');    			
			firstDate=Date.valueOf(system.today()).toStartOfMonth();
            return Database.getQueryLocator('SELECT id FROM SGR_Plan_FIPS_Map__c limit 0');
            
        }		   								       
    }
    
    public void execute(Database.BatchableContext context, List<SGR_Plan_FIPS_Map__c> scope) {
    
    	String body;
    	String subject;
		List<SGR_URE_Age_Rate_Driver__c> recsToInsert = new List<SGR_URE_Age_Rate_Driver__c>();
		
		EmailUtility util = new EmailUtility();

		
		for (SGR_Plan_FIPS_Map__c rec: scope) {
			recsToInsert.add(new SGR_URE_Age_Rate_Driver__c(
										Name = rec.Name,
										SGR_Plan_Id__c = rec.SGR_Plan_Id__c,
										FIPS_Code__c = rec.FIPS_Code__c,
										Division__c = rec.Division__c,
										Corporate_Entity_Code__c = rec.Corporate_Entity_Code__c,
										Rate_Effective_Date__c = rec.Effective_Date__c,
										Market_Segment__c = rec.Market_Segment__c,
                						Line_Of_Business__c = rec.Plan__r.Line_Of_Business__c,
										Processing_Status__c = 'Ready'
			));
		}
		System.debug('recsToInsert::' + recsToInsert);
		try {
			if (!recsToInsert.isEmpty()) {			             
    	        	Schema.SObjectField ardKey = SGR_URE_Age_Rate_Driver__c.Fields.Name;
   		         	Database.UpsertResult [] results = Database.upsert(recsToInsert, ardKey, false);                                            
   	             	System.debug('ARD SaveResults::'+results);
			}
		} catch (Exception e) {
			body = 'An error has occured in Apex Job Id:'+context.getJobId() + '.<br/>Please contact System administrator.<br/>Regards,<br/>AgeRateDriverBatch';
			subject = 'Age Rate Driver batch job failed';	
			EmailUtility.circulateEmail(recipientEmailAddr, subject, body);		
		} 
    }

	public void finish(Database.BatchableContext bc) {
		
		AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
		String body ='Hi,<br/>Records processed ' + a.TotalJobItems +   ' with '+ a.NumberOfErrors + ' failures.<br/><br/>Regards,<br/>Age Rate Driver batch job';
		String subject = 'Age Rate Driver batch job ' + a.Status;
		EmailUtility.circulateEmail(recipientEmailAddr, subject, body);	
	}
	
	private String buildDivClause() {
		
    	String divisions = '(';
    	
		List<Division__c> divisionCSVals = Division__c.getAll().values();
    	System.debug('divisionCSVals:'+divisionCSVals);
     	if (null != divisionCSVals && !divisionCSVals.isEmpty()) {
     		for (Division__c d: divisionCSVals) {
     			if (null != d.Name && d.Name != '') {
     				divisions = divisions + '\'' + d.Name + '\',';
     			}
     		}
     		divisions = divisions.removeEnd(',') + ')';
     	}
     	return divisions;
	}
}