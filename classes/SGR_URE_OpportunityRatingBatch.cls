global class SGR_URE_OpportunityRatingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public List<Id> oppRecIds;    
  	public List<String> recipientEmailAddr;
    public List<SGR_URE_GetRatingsResponse> resObjList = new List<SGR_URE_GetRatingsResponse>();
    public List<SGR_URE_GetRatingsResponse> resFailList = new List<SGR_URE_GetRatingsResponse>();
    public list<Id> succOpId=new list<Id>();
    public list<Id> failOpId=new list<Id>();
    Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opptyCalloutInfoMap = new Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo>();
    Set<String> allPlanISet = new Set<String>(); 
    Set<String> planIdsForRating = new Set<String>(); 
   //List<Error_Log__c> errorLogList = new List<Error_Log__c>();
    
    global SGR_URE_OpportunityRatingBatch(List<Id> oppRecIds) {
    	String className = 'SGR_URE_GenerateAgeRateDriverBatch';  
      	List<SGR_EmailDL__c> dlSettingVals = SGR_EmailDL__c.getAll().values();
        this.oppRecIds = oppRecIds;
        
         recipientEmailAddr = new List<String>();      
           
    	 if (null != dlSettingVals) {
      		for (SGR_EmailDL__c dl: dlSettingVals) {
        		if (dl.TaskName__c == className) {
          			recipientEmailAddr.add(dl.To__c);
        		}
      		}    
    	}
    }
    
    global Database.QueryLocator start( Database.BatchableContext bc) {        
    	String query = 'select id,HCSC_Division__c,Account_Market_Segment__c,Renewal_Date__c,County_Code__c,FIPS_Code__c,Zip_Code__c from Opportunity where Id in :oppRecIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        String body, subject;
        //Akbar - E2E testing fixes - Insert URE Opp rating logs
        List<FW_Service_Status_Log__c> intLogsList=new List<FW_Service_Status_Log__c>();
        List<Error_Log__c> errorLogList = new List<Error_Log__c>();
        //Start - Akbar - E2E - testing fixes - Jan 30
        List<Attachment> atchmntList=new List<Attachment>();
        Map<String, String> attchMap = new Map<String, String>();
        Map<String, String> refIdMap = new Map<String, String>();
       //End - Akbar - E2E - testing fixes - Jan 30
        try {
        	SGR_URE_OpportunityRatingHelper helperObj = new SGR_URE_OpportunityRatingHelper();
			List<Id>oppIds = new List<Id>();
            
			List<Opportunity>opps = new List<Opportunity>();
			Map<Id,String> fipsCodeMap = new Map<Id, String>();

			Map<Id,Date> effDateMap  = new map<Id,Date>();
			
            Map<Id, List<SGR_Opportunity_Plan_Rate__c>> oppPlanRatesMap = new Map<Id, List<SGR_Opportunity_Plan_Rate__c>>();
            Map<Id, List<SGR_Opportunity_Census__c>> oppCensusMap = new Map<Id, List<SGR_Opportunity_Census__c>>();
            Map<Id, List<SGR_Opportunity_Member_Benefits__c>> oppMemBenMap = new Map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
            Map<String, Set<String>> planIdMap = new Map<String, Set<String>>();
            
            List<String> tasks = new List<String>{'RetentionTask','MarketingRatesSpecificTask'};
            List<String> compositeRates = new List<String>{'TIER4'};
            
            List<String> renEffDate = new List<String>();
            String fips;
            Date rendt;
            String dateString;
            String corporateEntityCode;
            String marketSegment;
            String countyCode;
            String referenceId;
            
            Integer requestType = 1;
            
            if(scope==null || scope.isEmpty()){
            	return;
            }
            // URE fixes - 10-Jan - Start
			Map<String,String> stateCodeMap = new  Map<String,String>();
			Map<String,String> searchFipsMap = new  Map<String,String>();
			for(Division__c state: Division__c.getAll().values()){
				stateCodeMap.put(state.Name,state.State_Code__c);
			}
			for(SearchFIPS__c sfip: SearchFIPS__c.getAll().values()){
				searchFipsMap.put(sfip.ZipCode__c,sfip.FIPS_Code__c);
			}
			for(SObject temp : scope) {
				Opportunity opp = (Opportunity) temp;
				if (String.isNotBlank(opp.FIPS_Code__c)) {
					fipsCodeMap.put(opp.Id, opp.FIPS_Code__c);
				}else if(String.isNotBlank(opp.County_Code__c)){ //populate fipsmap from searchfips using opp.zipcode and opp.HCSC_Division__c
					fipsCodeMap.put(opp.Id, opp.County_Code__c.length()==5?opp.County_Code__c:stateCodeMap.get(opp.HCSC_Division__c)+ opp.County_Code__c);
				}else if(String.isNotBlank(opp.Zip_Code__c)){  // populate fipsmap from searchfips using opp.zipcode
					fipsCodeMap.put(opp.Id, searchFipsMap.get(opp.Zip_Code__c));
				}
				
				effDateMap.put(opp.Id, opp.Renewal_Date__c);			
				oppIds.add(opp.Id);
				opps.add(opp);
                //System.debug('fipscodeMap****'+fipsCodeMap);
        		//System.debug('effDateMap****'+effDateMap);
            }
            // URE fixes - 10-Jan - End
            List<Plan__c> planList = new List<Plan__c>();
            Integer noOfPlanIds;
            
			// Populate Opp Plan Rate
			oppPlanRatesMap = helperObj.populateOppPlanRate(oppIds);
			//system.debug('oppPlanRatesMap--->'+oppPlanRatesMap);
			// Populate Opp Census
			oppCensusMap = helperObj.populateOppCensus(oppIds);
			system.debug('oppCensusMap--->'+oppCensusMap);
			// Populate Opp Member benefits
			oppMemBenMap = helperObj.populateOppMemberBenefits(oppIds, oppCensusMap);
		   // system.debug('oppMemBenMap--->'+oppMemBenMap);
			
			// URE fixes - 10-Jan - Start
			// Populate Plan Ids
			planIdMap = helperObj.populatePlanIds(fipsCodeMap, effDateMap);
			
			//System.debug('planIdMap---->'+planIdMap);        
			// URE fixes - 10-Jan - End			                        
            for(Opportunity opp: opps){
                
                referenceId = String.valueOf((math.random()*100000000).intValue());
                refIdMap.put(opp.id,referenceId);
                //referenceId='13127874';
                rendt = opp.Renewal_Date__c;
                if(rendt==null){
                	continue;
                }
                //system.debug('opp renewal date-->'+rendt);
                
                renEffDate = String.valueOf(rendt).split('-');
                dateString = renEffDate[1]+'/'+renEffDate[2]+'/'+renEffDate[0];
                corporateEntityCode = opp.HCSC_Division__c+'1';
                
               // system.debug('date in String::'+dateString);
               // marketSegment = opp.Account_Market_Segment__c;
                marketSegment='SG';
                               
                countyCode = opp.County_Code__c!=null && opp.County_Code__c.length()==5?opp.County_Code__c:fipsCodeMap.get(opp.Id);
                
                //system.debug('county code for URE :::'+countycode);
                
                List<String> tasksList = new List<String>(); 
                List<SGR_Opportunity_Plan_Rate__c> oppPlanRates =oppPlanRatesMap!=null? oppPlanRatesMap.get(opp.Id):null;
                List<SGR_Opportunity_Census__c>oppCensus =oppCensusMap!=null? oppCensusMap.get(opp.Id):null;
                List<SGR_Opportunity_Member_Benefits__c> oppMemBen = oppMemBenMap!=null? oppMemBenMap.get(opp.Id):null;
                
               /* System.debug('planRates::'+oppPlanRates);
                System.debug('census::'+oppCensus);
                System.debug('oppMemBen::'+oppMemBen); */
				
				if (null == oppPlanRates || null == oppCensus || null == oppMemBen) {
      				 continue;
				}
				/*
                if (null !=oppPlanRatesMap) {
                	 oppPlanRates = oppPlanRatesMap.get(opp.Id);  
                }
                if (null != oppCensusMap) {
                	oppCensus  = oppCensusMap.get(opp.Id);
                }
                if (null !=oppMemBenMap) {
                	oppMemBen = oppMemBenMap.get(opp.Id);
                }
                */
                //system.debug('opp.FIPS_Code__c::'+opp.FIPS_Code__c+'    opp.Renewal_Date__c:::'+opp.Renewal_Date__c);
				Set<String> allPlans = planIdMap.get(opp.FIPS_Code__c+opp.Renewal_Date__c.year()+'-'+opp.Renewal_Date__c.month()+'-'+'01');                               
                if(allPlans!=null && allPlans.size()>0){
                	allPlanISet.addAll(allPlans);
                }
                
                //added by MC replace allPlas from above
                Set<String>allPlansForURE=new Set<String>();
                
                for(String key:planIdMap.keySet()){
                	allPlansForURE.addAll(planIdMap.get(key));
                    planIdsForRating.addAll(planIdMap.get(key));
                }
                
               // system.debug('allplans for '+opp.FIPS_Code__c+opp.Renewal_Date__c+ ' is '+allPlans+' allPlansForURE==>'+allPlansForURE);
                 system.debug('Cesar:: Calling helperObj.callUREService');
                 SGR_URE_GetRatingsResponse obj = helperObj.callUREService(oppCensus, oppMemBen, dateString,
                                                                          null, referenceId, requestType, 'RenewalsSalesForce', 
                                                                          corporateEntityCode, marketSegment, false, countyCode, allPlansForURE, tasks, compositeRates); //allPlans
                 // system.debug('response Object::'+obj);
                 
                // URE fixes - 10-Jan-Start
                //Start - Akbar - E2E testing fixes - Insert URE Opp rating logs
                FW_Service_Status_Log__c intLog=new FW_Service_Status_Log__c();
                intLog = helperObj.intLog;
                attchMap.put(opp.id,JSON.serialize(obj,true));
                intLog.UID__c = opp.id;
                intLog.ResponseBody__c = 'Refer Attachments Section For Response Body';
                intLogsList.add(intLog);
                //End - Akbar - E2E testing fixes - Insert URE Opp rating logs
                if(helperObj!=null && helperObj.errorLogList!=null && helperObj.errorLogList.size()>0)
                    errorLogList.addAll(helperObj.errorLogList);
                // URE fixes - 10-Jan -End
                if(obj!=null && obj.statusCode =='Success'){
                    system.debug(' response success for Opp Id: -->>'+opp.id);
                    resObjList.add(obj);
                    succOpId.add(opp.id);
                }else{
                    system.debug(' response failed for Opp Id---> '+opp.id);
                    resFailList.add(obj);
                    failOpId.add(opp.id);
                }
              //  system.debug(obj); 

                /* store request/response */
                SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo ureCalloutinfo = helperObj.GetURERatingCalloutInfo();
                ureCalloutinfo.Success = obj.statusCode =='Success';
                opptyCalloutInfoMap.put(opp.Id, ureCalloutinfo);
                
                system.debug( ureCalloutinfo.Success+'  Post Process oppty calloutInfo Map:::'+opptyCalloutInfoMap);
				
            }
            //Start - Akbar - E2E testing fixes - Insert URE Opp rating logs
            if(intLogsList!=null && intLogsList.size()>0)
                insert intLogsList;
            
            for(FW_Service_Status_Log__c temp:intLogsList){
                for(string opid:attchMap.keySet()){
                	if(temp.UID__c==opid){
                       Attachment ach=new Attachment();
                       ach.Body = Blob.valueOf(attchMap.get(temp.UID__c));
                       ach.Name = String.valueOf(opid+'-'+refIdMap.get(opid)+'.txt');
                       ach.ParentId = temp.id;
                       atchmntList.add(ach);
                	}
                }
                
            }
            
            if(atchmntList!=null && atchmntList.size()>0)
                insert atchmntList;
            if(errorLogList!=null && errorLogList.size()>0)
                    insert errorLogList;
			//End - Akbar - E2E testing fixes - Insert URE Opp rating logs
        } 
        catch (Exception ex) {
        	system.debug('SGR_URE_Opportunity Rating Batch exception:::'+ex.getLineNumber()+' error::'+ex);
        	
             CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_OpportunityRatingBatch', null, 'SGR_URE_OpportunityRatingBatch.execute', 'High');
             body = 'An error has occured in Apex Job Id:'+bc.getJobId() + '.<br/>Please contact System administrator.<br/>Regards,<br/>OpportunityRatingBatch <br/>';
      		 subject = 'Opportunity rating batch job failed';  
      		 EmailUtility.circulateEmail(recipientEmailAddr, subject, body);   
        }        
    }
    
    
    global void finish(Database.BatchableContext BC) {
        	
        	// URE fixes - 10-Jan-Start
               // if(errorLogList!=null && errorLogList.size()>0)
                 //   insert errorLogList;
            // URE fixes - 10-Jan -End
            AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
    		String body ='Hi,<br/>' +  a.TotalJobItems + ' Records processed ' +   ' with '+ a.NumberOfErrors + ' failures.';
    		if (!resFailList.isEmpty()) {
    			body = body + 'Failed records:<br/>' + resFailList;
    		}
    		body  =body + '<br/><br/>Regards,<br/>OpportunityRatingBatch';
    		String subject = 'Opportunity Rating batch job ' + a.Status;
    		EmailUtility.circulateEmail(recipientEmailAddr, subject, body);  
            /* Post processing - Computes rates: Composite and Age Rates */
            if(oppRecIds.size() > 0 && planIdsForRating.size() > 0 && resObjList.size() > 0) {
                SGR_URE_OpptyRatingCalculationManager manager = new SGR_URE_OpptyRatingCalculationManager('OpptyCompAndAgeRatingCalc');
                manager.calculateRates(oppRecIds, planIdsForRating, opptyCalloutInfoMap);
            }
        SGR_URE_OpportunityRatingHelper lastObj=new SGR_URE_OpportunityRatingHelper();
        lastObj.updateOpportunities(succOpId,failOpId);
    }        
}