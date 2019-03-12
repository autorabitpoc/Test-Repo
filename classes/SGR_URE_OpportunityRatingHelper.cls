public class SGR_URE_OpportunityRatingHelper {
    
    @TestVisible private Final string SGR_INTEGRATION_NAME = 'URE_Rate_Callout';
    public Static String errorMessage;
    public static Map<String,String> rateSizeMap = new Map<String,String>();
    
    public Static SGR_URE_GetRatingsResponse objResponseWrappertoProcess = new SGR_URE_GetRatingsResponse();
    public Static List<SGR_Plan_Age_Rate_Header__c> areaHdrLst = new List<SGR_Plan_Age_Rate_Header__c>();
    public static List<SGR_Plan_Age_Rate_Detail__c> areaDtLst = new List<SGR_Plan_Age_Rate_Detail__c>();
    public  List<Error_Log__c> errorLogList;
    public FW_Service_Status_Log__c intLog=new FW_Service_Status_Log__c(); //Akbar - E2E testing fixes - Insert URE Opp rating logs
    
    
    SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo ureCalloutInfo = new SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo(); 
    
    public SGR_URE_OpportunityRatingHelper(){
        errorLogList = new List<Error_Log__c>();
    }
    
    public SGR_URE_GetRatingsResponse callUREService(List<SGR_Opportunity_Census__c> censusDetail, list<SGR_Opportunity_Member_Benefits__c> oppMemBen, String rateEffectiveDate, String rateSize, String referenceId, Integer requestType, String applicationId, String corporateEntityCode, String marketSegment, Boolean isExchange, String countyCode, Set<String> planId, List<String> task, List<String> type)
    {
        SGR_URE_GetAgeRatesRequestWrapper objRequest = new SGR_URE_GetAgeRatesRequestWrapper();
        SGR_URE_GetAgeRatesRequestWrapper.RffRequestWrapper rffRequestWrapper = new SGR_URE_GetAgeRatesRequestWrapper.RffRequestWrapper();
        
        
        SGR_URE_GetAgeRatesRequestWrapper.URE_Plans pl = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plans();
        
        SGR_URE_GetAgeRatesRequestWrapper.URE_Tasks  t = new SGR_URE_GetAgeRatesRequestWrapper.URE_Tasks();
        SGR_URE_GetAgeRatesRequestWrapper.URE_Census cen= new SGR_URE_GetAgeRatesRequestWrapper.URE_Census();
        SGR_URE_GetAgeRatesRequestWrapper.URE_CompositeRates cr= new SGR_URE_GetAgeRatesRequestWrapper.URE_CompositeRates();
        List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>  pList = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>();
        Boolean isValidURERequest = false; // URE fixes - 10-Jan
        Set<String> cdPlanSet = new Set<String>(); // URE fixes - 10-Jan
        Boolean allCensusPlansExists = true; // URE fixes - 10-Jan
        //SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail cd = new SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail();
        List<SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail> cList = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail>(); 
        
        rffRequestWrapper.rateEffectiveDate=rateEffectiveDate;
        rffRequestWrapper.referenceId=referenceId;
        
        rffRequestWrapper.requestType=requestType;
        rffRequestWrapper.applicationId=applicationId;
        rffRequestWrapper.corporateEntityCode=corporateEntityCode;
        rffRequestWrapper.marketSegment=marketSegment;
        rffRequestWrapper.isExchange=isExchange;
        rffRequestWrapper.countyCode=countyCode;
        
        
        //system.debug('plan Id:::'+planId);
        if(planId!=null && !planId.isEmpty()){  
            for(String s :planId){
                SGR_URE_GetAgeRatesRequestWrapper.URE_Plan p = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
                p.planId = s;
                pList.add(p);
            }
        }
        pl.plan = pList;
        rffRequestWrapper.plans = pl;
        
        
        t.task=task;
        rffRequestWrapper.tasks = t;
        
        
        if(type!=NULL && type.size()>0 ){   
            cr.type=type;
            rffRequestWrapper.compositeRates=cr;
            
        }
        
        system.debug('George: censusDetail ' + censusDetail);
        system.debug('George: oppMemBen' + oppMemBen);
        if(censusDetail!=NULL && censusDetail.size()!=0  )
        {
            system.debug('George: censusDetail ' + censusDetail);
            

            for(SGR_Opportunity_Census__c fr:censusDetail){
            	
               SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail cd = new SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail();
                List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>  cdPlans = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>();
                SGR_URE_GetAgeRatesRequestWrapper.URE_Plans cdpl = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plans();
                system.debug('George: oppMemBen' + oppMemBen);
                for(SGR_Opportunity_Member_Benefits__c eachMben:oppMemBen) {
                    if(fr.id==eachMben.Opportunity_Census__c) {
                        SGR_URE_GetAgeRatesRequestWrapper.URE_Plan p = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
                        if(String.isNotBlank(eachMben.Plan_ID__c)){
                            //p.planId = eachMben.Plan_ID__c;
                  	 		p.planId = eachMben.Opportunity_Plan_Rate__r.Plan__r.Name;
                            cdPlans.add(p);
                            //cdPlanSet.add(eachMben.Plan_ID__c); // URE fixes - 10-Jan
                            cdPlanSet.add(p.planId); //Krishna 1/29
                        }
                    }
                }
                // URE fixes - 10-Jan - Start
                // If there are no plans in Opp Census, dont add it to CensusDetail request block
              
                if (cdPlans.isEmpty()) {
                    continue;
                }
                // URE fixes - 10-Jan - End
                
                cd.censusDetailId=fr.Id;
                cd.subscriberId=string.valueof(fr.Subscriber_Number__c);
                // URE fixes - 10-Jan - Start
                if (String.isBlank(cd.subscriberId) ||cd.subscriberId.equalsIgnoreCase('0')) {
                    SGR_Exception ex = new SGR_Exception('No Subscriber Id found. Not calling URE');
                    errorLogList.addAll(CreateExceptionLog.createErrorLogRecs(ex, null, null, null, 'Apex Class', 'SGR_URE_OpportunityRatingHelper', null, 'SGR_URE_OpportunityRatingHelper.callUREService', 'High'));
                    continue;
                }
                // URE fixes - 10-Jan - End
                Date d = fr.Date_of_Birth__c;
                String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
                system.debug('++++++++++'+dt);
                cd.dateOfBirth=dt;
                //cd.dateOfBirth='01/01/2018';
                cd.age=integer.valueOf(fr.Age_New__c);
                
                cd.relationshipCode=getMappedRelationCode(fr.Relationship_Code__c);
                system.debug('relationship code for URE: '+cd.relationshipCode);
                
                // URE fixes - 10-Jan - Start
                if (cd.relationshipCode == 'PR') {
                    isValidURERequest = true;
                }
                // URE fixes - 10-Jan - Start
                cd.isTobacco= fr.Tobacco_Use__c;
                cd.isTefra=fr.IsTefra__c;// tefra value not present in object(hard coded) 
                cd.countyCode=countyCode; // county code not available 
                
                system.debug('countycode:::'+cd.countyCode);
                
                cdpl.plan = cdPlans;
                cd.plans = cdpl;
                cList.add(cd);
                system.debug('cdPlans ' + cdPlans);
           }//for
           
            system.debug('census list::'+cList);
            
            cen.censusDetail=cList;
            
            rffRequestWrapper.census=cen; 
            
            if( rateSize!=Null && rateSize!='')   
            {
                
                rffRequestWrapper.rateSize=rateSize;
                
            }
        }
        
         system.debug('cdPlanSet ' + cdPlanSet);
        system.debug('global alt plan Ids list:::'+planId);
        
        // URE fixes - 10-Jan - Start -The below code checks All census plans conatins in altn plan list or not.
        for(String cdPlan: cdPlanSet){
            if(planId!=null && planId.size()>0 && !planId.contains(cdPlan)){
                allCensusPlansExists = false;
                break;
            }    
        }
        //system.debug('have at least one PRIMARY ?-->'+isValidURERequest);
       // system.debug('allCensusPlansExists in Alt Plan area?--->'+allCensusPlansExists);
        // URE fixes - 10-Jan - End
        objRequest.rffRequest = rffRequestWrapper; 
        
       // system.debug('prepare to callout URE service with request data:::'+objRequest.rffRequest);
        
        APICallOutRestWSUtility objUtility = new APICallOutRestWSUtility(SGR_INTEGRATION_NAME);
        if(objRequest != NULL && isValidURERequest && allCensusPlansExists && planId!=null && planId.size()>0){
            system.debug('Cesar:: objUtility.invokeUREOppRating - request');
            objResponseWrappertoProcess = objUtility.invokeUREOppRating(objRequest); 
            system.debug('Cesar:: objUtility.invokeUREOppRating - response');
            ureCalloutInfo.ureRequest = objRequest;
            ureCalloutInfo.ureResponse = objResponseWrappertoProcess;
        } else if (!isValidURERequest) {
            SGR_Exception ex = new SGR_Exception('No census detail found with Primary Relationship code. Not calling URE');
            errorLogList.addAll(CreateExceptionLog.createErrorLogRecs(ex, null, null, null, 'Apex Class', 'SGR_URE_OpportunityRatingHelper', null, 'SGR_URE_OpportunityRatingHelper.callUREService', 'High'));
            system.debug('validation failed, missing Primary!');
        }else if(!allCensusPlansExists){
            SGR_Exception ex = new SGR_Exception('Alternate Plans not contains all Census Plans. Not calling URE');
            errorLogList.addAll(CreateExceptionLog.createErrorLogRecs(ex, null, null, null, 'Apex Class', 'SGR_URE_OpportunityRatingHelper', null, 'SGR_URE_OpportunityRatingHelper.callUREService', 'High'));
            system.debug(' validation failed: not all census plan included in the global plan section!');
        }else if(planId==null || planId.size()<=0){
            SGR_Exception ex = new SGR_Exception('Alternate Plans are empty. Not calling URE');
            errorLogList.addAll(CreateExceptionLog.createErrorLogRecs(ex, null, null, null, 'Apex Class', 'SGR_URE_OpportunityRatingHelper', null, 'SGR_URE_OpportunityRatingHelper.callUREService', 'High'));
            system.debug('validation failed: no alternate global plans.');
        }
        System.debug(objResponseWrappertoProcess);
        System.debug('================================================================================');
        System.debug(objRequest.rffRequest);
        System.debug('errorLogList::'+errorLogList);
        intLog=Utility.getIntegrationLog('InvokeURERatingService',null, objResponseWrappertoProcess.statusMessage,objResponseWrappertoProcess.errorMessage,objResponseWrappertoProcess.executeStartDate, 
																			system.now(), 
																			JSON.serialize(objRequest,true), 
																			JSON.serialize(objResponseWrappertoProcess,true));
        return objResponseWrappertoProcess;
        
        
    }
    
    public SGR_URE_OpptyCompAndAgeRatingUtility.ureCalloutInfo GetURERatingCalloutInfo() {
        return ureCalloutInfo;
    }
    
    public  Map<Id, List<SGR_Opportunity_Plan_Rate__c>> populateOppPlanRate(List<Id> oppIds) {
        List<SGR_Opportunity_Plan_Rate__c> oppPlanRates = [SELECT Id, Rate_Effective_Date__c, Opportunity__c from SGR_Opportunity_Plan_Rate__c where Opportunity__c in :oppIds];
        System.debug('oppPlanRates::' + oppPlanRates);
        if (null == oppPlanRates || oppPlanRates.isEmpty()) {
            return null;
        }
        
        Map<Id, List<SGR_Opportunity_Plan_Rate__c>> opOPRMap = new Map<Id, List<SGR_Opportunity_Plan_Rate__c>>();
        for (SGR_Opportunity_Plan_Rate__c opr : oppPlanRates) {
            if (null == opr.Opportunity__c) continue;
            List<SGR_Opportunity_Plan_Rate__c> oprList =(null == opOPRMap.get(opr.Opportunity__c)) ? new List<SGR_Opportunity_Plan_Rate__c>() :  opOPRMap.get(opr.Opportunity__c);
            oprList.add(opr);
            opOPRMap.put(opr.Opportunity__c, oprList);
        }
        
        return opOPRMap;
    }
    
    public  Map<Id, List<SGR_Opportunity_Census__c>> populateOppCensus(List<Id> oppIds) {
        List<SGR_Opportunity_Census__c> oppCensus = [select Id, Name, Subscriber_Number__c, Date_of_Birth__c, Age__c, Relationship_Code__c, Tobacco_Use__c, IsTefra__c, Opportunity__c, Age_New__c  from SGR_Opportunity_Census__c where Opportunity__c in :oppIds];
        System.debug('oppCensus::' + oppCensus);
        if (null == oppCensus || oppCensus.isEmpty()) {
            return null;
        }
        
        Map<Id, List<SGR_Opportunity_Census__c>> opCensusMap = new Map<Id, List<SGR_Opportunity_Census__c>>();
        for (SGR_Opportunity_Census__c census : oppCensus) {
            if (null == census.Opportunity__c) continue;
            List<SGR_Opportunity_Census__c> censusList = (null == opCensusMap.get(census.Opportunity__c)) ? new List<SGR_Opportunity_Census__c>() :  opCensusMap.get(census.Opportunity__c);
            censusList.add(census);
            opCensusMap.put(census.Opportunity__c, censusList);
        }
        
        return opCensusMap;
    }  
    
    public  Map<Id, List<SGR_Opportunity_Member_Benefits__c>> populateOppMemberBenefits(List<Id> oppIds, Map<Id, List<SGR_Opportunity_Census__c>> oppCensusMap) {
        Set<Id> censusIds = new Set<Id>(); 
        for (Id oppId: oppIds) {
            if (oppCensusMap!=null &&  oppCensusMap.get(oppId)!=null) {
                for (SGR_Opportunity_Census__c census: (List<SGR_Opportunity_Census__c>) oppCensusMap.get(oppId)) {
                    censusIds.add(census.Id);
                }                   
            }
        }
        List<SGR_Opportunity_Member_Benefits__c> oppMemBens = [select Id, Plan_ID__c, Opportunity__c, Opportunity_Census__r.Opportunity__c, 
        														Opportunity_Plan_Rate__r.Plan__r.Name, Opportunity_Plan_Rate__r.Type__c 
                                                                from SGR_Opportunity_Member_Benefits__c 
                                                                where Opportunity_Census__c  in :censusIds 
                                                                and Opportunity_Plan_Rate__r.Type__c='Renewal' 
                                                                and Opportunity_Plan_Rate__r.Plan_Status__c in ('Renewing','Mapped')];
        System.debug('oppMemBens::' + oppMemBens);
        if (null == oppMemBens || oppMemBens.isEmpty()) {
            return null;
        }
        
        Map<Id, List<SGR_Opportunity_Member_Benefits__c>> opMemBenMap = new Map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
        for (SGR_Opportunity_Member_Benefits__c omb : oppMemBens) {
            if (omb==null || null == omb.Opportunity_Census__r.Opportunity__c) continue;
            List<SGR_Opportunity_Member_Benefits__c> ombList = (null == opMemBenMap.get(omb.Opportunity_Census__r.Opportunity__c)) ? new List<SGR_Opportunity_Member_Benefits__c>() :  opMemBenMap.get(omb.Opportunity_Census__r.Opportunity__c);
            ombList.add(omb);
            opMemBenMap.put(omb.Opportunity_Census__r.Opportunity__c, ombList);
        }
        
        return opMemBenMap;
    } 
    
    public Map<String, Set<String>> populatePlanIds(Map<Id, String> fipsCodeMap, Map<Id, Date> effDateMap) {
        System.debug('fipscodeMap****'+fipsCodeMap);
        System.debug('effDateMap****'+effDateMap);
        // URE fixes - 10-Jan - Start
        Set<String> filterCriteria = new Set<String>(); //List<String> filterCriteria = new List<String>();
        for (Id oppId : fipsCodeMap.keyset()) {
            System.debug('Inside fipcodes loop first line');
            Date effDate = effDateMap.get(oppId);
            if (null != effDate && null != fipsCodeMap.get(oppId)) {
                System.debug('Inside fipcodes loop');
                filterCriteria.add(fipsCodeMap.get(oppId)/*+'-'+String.valueOf(effDate)*/+'-'+effDate.year()+'-'+effDate.month()+'-01');
                System.debug('filterCriteria::'+ filterCriteria);
              /*  Date priorDate = effDate;
                // Add all the prior dates upto start of month
                while (priorDate.day()>=1 && priorDate.month() == effDate.month()) {
                    filterCriteria.add(fipsCodeMap.get(oppId)+'-'+String.valueOf(priorDate.addDays(-1))+'-'+effDate.month());
                    priorDate = priorDate.addDays(-1);
                } */
            }               
        }
        
        System.debug('filterCriteria::'+ filterCriteria);
        if (filterCriteria.isEmpty()) return null;
        
        List<SGR_Plan_FIPS_Map__c> recs = [select SGR_Plan_Id__c, FIPS_Code__c, Effective_Date__c,URE_AltPlanPicker__c  from SGR_Plan_FIPS_Map__c where URE_AltPlanPicker__c in :filterCriteria];
        // URE fixes - 10-Jan - End
        System.debug('SGR_Plan_FIPS_Map__c recs::' + recs);
        Map<String, Set<String>> planIdMap = new Map<String, Set<String>>();
        for (SGR_Plan_FIPS_Map__c rec: recs) {
            String key = rec.URE_AltPlanPicker__c; //rec.FIPS_Code__c+rec.Effective_Date__c;
            Set<String> planIds = (null == planIdMap.get(key)) ? new Set<String>():planIdMap.get(key);
            planIds.add(rec.SGR_Plan_Id__c);
            planIdMap.put(key, planIds);
        }
        return planIdMap;       
    } 
    
    /*
** Mei Chen
** return the relationship code that maped in URE system
*/
  @Testvisible  private String getMappedRelationCode(String sfRelCode){
    	
        
        if (sfRelCode==null || sfRelCode==''){
        	return null;
        }
         
        String ureRelCode='OD';//other
        
        try{
        	SGR_Relationship_Mapping__c relMap=SGR_Relationship_Mapping__c.getInstance(sfRelCode);
        	if(relMap!=null){
        		ureRelCode=relMap.URE_Code__c;
        	}
        
        }catch (Exception e){
        	system.debug('exception from getting relation ship code from custom setting'+e);
        }
      /*  if(sfRelCode!=null){
            
            if( sfRelCode.contains('Spouse') ||sfRelCode.equalsIgnoreCase('SP')||sfRelCode.equalsIgnoreCase('Domestic Partner') || sfRelCode.equalsIgnoreCase('SPS')){
                ureRelCode='SP';
            }else if( sfRelCode.equalsIgnoreCase('Primary')||sfRelCode.equalsIgnoreCase('Subscriber') || sfRelCode.equalsIgnoreCase('PR')||sfRelCode.equalsIgnoreCase('SUB')){
                ureRelCode='PR';
            }
        }*/
        return ureRelCode;
    }
    public void updateOpportunities(list<id> succ,list<id> fail){
        list<Opportunity> succOpps=new list<Opportunity>();
        list<Opportunity> failopps=new list<Opportunity>();
        
        if(succ.size()>0 && succ!=null)
        succOpps=[select id,RecordTypeId,Recordtype.Name,Account.renewal_duration_is_infinite__c, Account.hold_end_date__c, Assigned_UW__c, 
                  Renewal_Date__c, SGR_Workflow_Activity__c,Workflow_System_Status__c,Rating_Status__c,Gate__r.Status__c from Opportunity where id IN:succ];
        System.debug('succOpps'+succOpps);
        
        if(fail.size()>0 && fail!=null)
        failopps=[select id,RecordTypeId,Recordtype.Name,Account.renewal_duration_is_infinite__c, Account.hold_end_date__c, Assigned_UW__c, 
                  SGR_Workflow_Activity__c,Renewal_Date__c, Workflow_System_Status__c,Rating_Status__c from Opportunity where id IN:fail];
        System.debug('failopps:'+failopps);
        
        list<Opportunity> succOppToUpdate=new list<Opportunity>();
        list<Opportunity> succOppToUpdate1=new list<Opportunity>();
        list<Opportunity> failOppToUpdate=new list<Opportunity>();
        list<Opportunity> allOppToUpdate=new list<Opportunity>();
        
        
        if(succOpps.size()>0 && succOpps!=null){
            for(Opportunity opp:succOpps){
                  if(opp.Gate__r.Status__c=='Down'){
                        opp.SGR_Workflow_Activity__c='';
                        opp.Workflow_System_Status__c='Ready For Gate Processing';
                        opp.Rating_Status__c='Rated';
                        succOppToUpdate.add(opp);
                	}
                else
                   {  
                opp.SGR_Workflow_Activity__c='';
                opp.Workflow_System_Status__c='Gate Processing Completed';
                opp.Rating_Status__c='Actuarial-Released';
                succOppToUpdate1.add(opp);
                }
        }
        }
        
        System.debug('succOppToUpdate'+succOppToUpdate);
        
          if(failopps.size()>0 && failopps!=null){
          for(Opportunity opp:failopps){
            opp.SGR_Workflow_Activity__c='IT Review - Rating Failed';
            opp.Workflow_System_Status__c='Failed Rating';
            opp.Rating_Status__c='Initiated';
            failOppToUpdate.add(opp);
        }
        }
        System.debug('failOppToUpdate'+failOppToUpdate);
        
        allOppToUpdate.addAll(succOppToUpdate);
        allOppToUpdate.addAll(failOppToUpdate);
        allOppToUpdate.addAll(succOppToUpdate1);
        System.debug('allOppToUpdate'+allOppToUpdate);
        
        if(allOppToUpdate.size()>0 && allOppToUpdate!=null)
        update allOppToUpdate;
        SGR_ReleaseValidations.initiateValidation(succOppToUpdate1);
        
    }
}