//*************************************************************************************
// Name             : SGR_URE_GetAgeRateshelper.cls
// Description      : Callout To get URE Rates
// Created By       : Raviteja 
// Created Date     : 10/29/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 30/10/2018       Santosh             SFDC-14568->Callout with request formation and getting response 
// 23/11/2018       Raviteja			SFDC-14018->Response Processing
// ************************************************************************************
public class SGR_URE_GetAgeRateshelper {
    
    private final static string SGR_INTEGRATION_NAME = 'URE_Rate_Callout';
  
    public static String errorMessage;

    public static SGR_URE_GetRatingsResponse objResponseWrappertoProcess = new SGR_URE_GetRatingsResponse();
    public static list<SGR_Plan_Age_Rate_Detail__c> areaDtLst = new list<SGR_Plan_Age_Rate_Detail__c>();  
    public static list<String> errMsgsList=new list<String>();
    public static set<id> succPGIDS = new set<id>();
    public static list<Error_Log__c> errLst=new list<Error_Log__c>();
    private static APIJwtOAuthUtility oAuthUtil;
    private static String newAccessToken=null;
   
    public SGR_URE_GetAgeRateshelper(){
        
    }
    public static /*List<SGR_Plan_Age_Rate_Detail__c>*/ void generateAgeRateTables(List<SGR_URE_Age_Rate_Driver__c> scope,Date renewEffDate,String planType,Integer requestType,String applicationId,String marketSegment,boolean isExchange){
		List<String> rateEffDate;
		String dateString;
		String corpEntityCode,cCode;
		String newAccessToken=null;
		DateTime lastTokenUpdateDateTime=null;
        List<SGR_Plan_Age_Rate_Header__c> finalAreaHdrLst = new List<SGR_Plan_Age_Rate_Header__c>();
		Map<String,List<SGR_URE_GetRatingsResponse>> resMap = new Map<String,List<SGR_URE_GetRatingsResponse>>();
        SGR_URE_GetRatingsResponse resObj = new SGR_URE_GetRatingsResponse();
		Integration_Log_Switcher__c allPlanLog=Integration_Log_Switcher__c.getInstance('URE Generic Service');
		List<SGR_Plan_Age_Rate_Detail__c> listOfARDToInsert =  new List<SGR_Plan_Age_Rate_Detail__c>();
		List<SGR_URE_GetRatingsResponse> resFailList = new List<SGR_URE_GetRatingsResponse>();
		
		try{
			Map<String,List<SGR_URE_Age_Rate_Driver__c>> ageRateMap = new Map<String,List<SGR_URE_Age_Rate_Driver__c>>();
			Set<String> planSet = new Set<String>();
			Set<String> planIdSet = new Set<String>();
			List<String> tasksList = new List<String>();
			List<Plan__c> planList = new List<Plan__c>();
			tasksList = (System.Label.SGR_Tasks).split(SGR_Constants.COMMA);
			Integer noOfPlanIds;
            rateEffDate = String.valueOf(renewEffDate).split('-');
			dateString = rateEffDate[1]+'/'+rateEffDate[2]+'/'+rateEffDate[0];
			// The below for contains logic to collect set of plan id from scope of records.		
			for(SGR_URE_Age_Rate_Driver__c obj : scope){
				planIdSet.add(obj.SGR_Plan_Id__c);
			}
			System.debug('planIdSet::'+planIdSet);
			// The below if else condition gets either dental or non dental plan ids from plan object and sets different value into variable noOfPlanIds based on dental plans or non dental plans.
			if(String.isNotBlank(planType)&& planType.equalsIgnoreCase('Dental')){
				planList = [SELECT Marketing_Plan_Number__c,Line_Of_Business__c FROM Plan__c WHERE Marketing_Plan_Number__c IN :planIdSet AND Line_Of_Business__c='D'];
				noOfPlanIds = Integer.valueOf(System.Label.SGR_No_Of_Dental_Plan_ID);
			}else{
				planList = [SELECT Marketing_Plan_Number__c,Line_Of_Business__c FROM Plan__c WHERE Marketing_Plan_Number__c IN :planIdSet AND Line_Of_Business__c!='D'];
				noOfPlanIds = Integer.valueOf(System.Label.SGR_No_Of_Plan_ID);
			}
			for(Plan__c pln: planList){
				planSet.add(pln.Marketing_Plan_Number__c);
			}
			for(SGR_URE_Age_Rate_Driver__c obj : scope){
				if(planSet.contains(obj.SGR_Plan_Id__c)){
					
					if(!ageRateMap.containskey(obj.FIPS_Code__c)){
						ageRateMap.put(obj.FIPS_Code__c,new List<SGR_URE_Age_Rate_Driver__c>{obj});
					}else{
						ageRateMap.get(obj.FIPS_Code__c).add(obj);
					}
					
				}
			}
			System.debug('ageRateMap::'+ageRateMap);
			SGR_URE_AgeRateshelperData helperData = new SGR_URE_AgeRateshelperData();
			for(String countyCode: ageRateMap.keySet()){
					List<SGR_URE_GetRatingsResponse> resObjList = new List<SGR_URE_GetRatingsResponse>();
                    List<SGR_URE_Age_Rate_Driver__c> tempList = new List<SGR_URE_Age_Rate_Driver__c>();
                    tempList = ageRateMap.get(countyCode);
                    for(integer i = 0; i < tempList.size(); i += noOfPlanIds) {
                        String referenceId = Utility.generateGUID();
                        List<String> planIdList = new List<String>();
                        for(integer j = i;j<i + Math.min(noOfPlanIds, tempList.size() - i);j++){
                            corpEntityCode = tempList[j].Corporate_Entity_Code__c;
                            cCode = tempList[j].FIPS_Code__c;
                            planIdList.add(tempList[j].SGR_Plan_Id__c);
                        }						
                        System.debug('Calling URE service');
                        helperData = getUREGenericResponse(null, dateString, null, referenceId, requestType, applicationId, corpEntityCode,marketSegment,isExchange,cCode, planIdList,tasksList,null,newAccessToken, 
    			                                 lastTokenUpdateDateTime);
                        System.debug('each respone'+resObj);
                         if(helperData.resObj.statusMessage =='Success'){
                            resObjList.add(helperData.resObj);
                         }else{
                             resFailList.add(helperData.resObj);
                         }
						 
						if(helperData!=null){
							newAccessToken = helperData.newAccessToken;
							lastTokenUpdateDateTime = helperData.lastTokenUpdateDateTime;
                            system.debug('resMap newAccessToken'+'*********'+newAccessToken);
                            system.debug('resMap lastTokenUpdateDateTime'+'*********'+lastTokenUpdateDateTime);
						}
                    }
					resMap.put(countyCode,resObjList);
					system.debug('resMap'+'*********'+resMap);
                }
				for(String countyCode : resMap.keySet()){
					List<SGR_Plan_Age_Rate_Header__c> areaHdrLst = new List<SGR_Plan_Age_Rate_Header__c>();
					areaHdrLst = processRatingResponse(resMap.get(countyCode),countyCode,renewEffDate,marketSegment,corpEntityCode);
					finalAreaHdrLst.addAll(areaHdrLst);
				}
				
				//upsert Age Rate Header records.
				system.debug('**********finalAreaHdrLst Size******'+finalAreaHdrLst.size());
				if(finalAreaHdrLst.size()!=null && finalAreaHdrLst.size()>0){
					Schema.SObjectField extID = SGR_Plan_Age_Rate_Header__c.Fields.Plan_Header_External_ID__c;
					Database.UpsertResult [] results = Database.upsert(finalAreaHdrLst, extID, false);
					Utility.createErroLog(results);
				}
				Map<String, List<SGR_Plan_Age_Rate_Header__c>> planIdHeaderMap = new Map<String, List<SGR_Plan_Age_Rate_Header__c>>();
				for (SGR_Plan_Age_Rate_Header__c hdr: finalAreaHdrLst) {
					List<SGR_Plan_Age_Rate_Header__c> smallerHdrList = (null == planIdHeaderMap.get(hdr.Fips_Code__c)) ? new List<SGR_Plan_Age_Rate_Header__c>():planIdHeaderMap.get(hdr.Fips_Code__c);
					smallerHdrList.add(hdr);
					planIdHeaderMap.put(hdr.Fips_Code__c, smallerHdrList);
				}
				for(String countyCode : resMap.keySet()){
					if(planIdHeaderMap.containsKey(countyCode)){
						List<SGR_URE_GetRatingsResponse> resList = new List<SGR_URE_GetRatingsResponse>();
						resList = resMap.get(countyCode);
						for(SGR_URE_GetRatingsResponse res:  resList){
							List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult> rprList = new List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult>();
							if (planType == 'Dental') {
								rprList = res.rffResult.marketingDentalRatesGenericTaskResult.ratingPackageResults;    					
							} else {
								rprList = res.rffResult.marketingRatesGenericTaskResult.ratingPackageResults;
							}
							System.debug('rprList::'+rprList);
							for(SGR_URE_GetRatingsResponse.URE_RatingPackageResult ratingPackageRslt: rprList) {
								for(SGR_URE_GetRatingsResponse.URE_ProductResult prodResult: ratingPackageRslt.productResults) {
									listOfARDToInsert.addAll(createAgeRateDetailRecords(planIdHeaderMap, prodResult.planResults,planType,countyCode));                                                                     
								}
							}
						}
						
					}
				}
				System.debug('listOfARDToInsert::'+listOfARDToInsert.size());
				System.debug('listOfARDToInsert::'+listOfARDToInsert);
				if(listOfARDToInsert.size()!=null && listOfARDToInsert.size()>0){
					Schema.SObjectField extID = SGR_Plan_Age_Rate_Detail__c.Fields.Plan_Detail_External_ID__c;
					Database.UpsertResult [] results = Database.upsert(listOfARDToInsert, extID, false);
					Utility.createErroLog(results);
				}
		}Catch(Exception ex){
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_Age_Rate_Driver__c', null, 'SGR_URE_GetAgeRateshelper.generateAgeRateTables', 'High');
		}finally{
			System.debug('finally newAccessToken::'+newAccessToken);
            System.debug('finally oAuthUtil::'+oAuthUtil);
			 //update the jwtTokenCustomSetting with new token 
			   if(newAccessToken!=null && oAuthUtil!=null){
                   
					oAuthUtil.UpdateToken(newAccessToken);
			   }
			List<FW_Service_Status_Log__c> intLogsList=new List<FW_Service_Status_Log__c>();
			if(allPlanLog.Integration_Log__c){
				for(SGR_URE_GetRatingsResponse failRes:resFailList){
					FW_Service_Status_Log__c intLog=new FW_Service_Status_Log__c();
					intLog=Utility.getIntegrationLog('URE_GenericService',null, 
																			failRes.statusMessage,
																			failRes.errorMessage, 
																			failRes.executeStartDate, 
																			system.now(), 
																			failRes.req, 
																			failRes.res);
					intLogsList.add(intLog);
				}
 
			}
      
		   if(intLogsList!=null && !intLogsList.isEmpty()){
				try{
					Database.SaveResult [] resultsLog = Database.insert(intLogsList, false);
				}catch (Exception e){
					system.debug('exception threw during integration log insertion :::'+e);
				}
			
			}
		}
        //return listOfARDToInsert;
    }
    public static SGR_URE_AgeRateshelperData getUREGenericResponse(List<SGR_Opportunity_Census__c> censusDetail,string rateEffectiveDate,string rateSize,string referenceId,Integer requestType,string applicationId,string corporateEntityCode,string marketSegment,boolean isExchange,String countyCode,List<string> planId,List<String> task,List<String> type,String newAccessToken, 
    			                                 DateTime lastTokenUpdateDateTime){
		SGR_URE_AgeRateshelperData helperData = new SGR_URE_AgeRateshelperData();
        SGR_URE_GetAgeRatesRequestWrapper objRequest = new SGR_URE_GetAgeRatesRequestWrapper();
        SGR_URE_GetAgeRatesRequestWrapper.RffRequestWrapper rffRequestWrapper = new SGR_URE_GetAgeRatesRequestWrapper.RffRequestWrapper();
        SGR_URE_GetRatingsResponse genericResponse = new SGR_URE_GetRatingsResponse();
        
        SGR_URE_GetAgeRatesRequestWrapper.URE_Plans pl = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plans();
        SGR_URE_GetAgeRatesRequestWrapper.URE_Tasks  t = new SGR_URE_GetAgeRatesRequestWrapper.URE_Tasks();
        SGR_URE_GetAgeRatesRequestWrapper.URE_Census cen= new SGR_URE_GetAgeRatesRequestWrapper.URE_Census();
        SGR_URE_GetAgeRatesRequestWrapper.URE_CompositeRates cr= new SGR_URE_GetAgeRatesRequestWrapper.URE_CompositeRates();
        List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>  pList = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>();
        
        SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail cd = new SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail();
        List<SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail> cList = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_CensusDetail>(); 
        
        rffRequestWrapper.rateEffectiveDate=rateEffectiveDate;
        rffRequestWrapper.referenceId=referenceId;
        
        rffRequestWrapper.requestType=requestType;
        rffRequestWrapper.applicationId=applicationId;
        rffRequestWrapper.corporateEntityCode=corporateEntityCode;
        rffRequestWrapper.marketSegment=marketSegment;
        rffRequestWrapper.isExchange=isExchange;
        rffRequestWrapper.countyCode=countyCode;
        try{
        	for(String s :planId){
                SGR_URE_GetAgeRatesRequestWrapper.URE_Plan p = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
                p.planId = s;
                pList.add(p);
            }
            pl.plan = pList;
            rffRequestWrapper.plans = pl;
        
        
        
            t.task=task;
            rffRequestWrapper.tasks = t;
            
            if(type!=NULL && type.size()>0 ){   
                cr.type=type;
                rffRequestWrapper.compositeRates=cr;
            }
        
        
        
            if(censusDetail!=NULL && censusDetail.size()>0  )
            {
                
                
                for(SGR_Opportunity_Census__c fr:censusDetail){
                    
                    List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>  cdPlans = new List<SGR_URE_GetAgeRatesRequestWrapper.URE_Plan>();    
                    cd.censusDetailId=fr.name;
                    cd.subscriberId=string.valueof(fr.Subscriber_Number__c);
                    Date d = fr.Date_of_Birth__c;
                    String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
                    system.debug('++++++++++'+dt);
                    cd.dateOfBirth=dt;
                    //cd.dateOfBirth='01/01/2018';
                    cd.age=integer.valueOf(fr.Age_New__c);
                    cd.relationshipCode=fr.Relationship_Code__c;
                    cd.isTobacco= fr.Tobacco_Use__c;
                    cd.isTefra=fr.IsTefra__c;// tefra value not present in object(hard coded) 
                    cd.countyCode=countyCode; // county code not available 
                    if(fr.Health_Plan_ID__c !=NULL && fr.Health_Plan_ID__c!='')
                    {
                        SGR_URE_GetAgeRatesRequestWrapper.URE_Plan p = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
                        p.planId = fr.Health_Plan_ID__c;
                        cdPlans.add(p);
                    }
                    if(fr.Dental_Plan_ID__c !=NULL && fr.Dental_Plan_ID__c !='')
                    {
                        SGR_URE_GetAgeRatesRequestWrapper.URE_Plan p = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
                        p.planId = fr.Dental_Plan_ID__c;
                        cdPlans.add(p);
                    }
                    if(fr.Vision_Plan_ID__c !=NULL && fr.Vision_Plan_ID__c !='')
                    {
                        SGR_URE_GetAgeRatesRequestWrapper.URE_Plan p = new SGR_URE_GetAgeRatesRequestWrapper.URE_Plan();
                        p.planId = fr.Vision_Plan_ID__c;
                        cdPlans.add(p);
                    }  
                    
                    pl.plan = cdPlans;
                    cd.plans = pl;
                    cList.add(cd);
                    
                    cen.censusDetail=cList;
                    
                    rffRequestWrapper.census=cen;
                    
                }
                
                if( rateSize!=Null && rateSize!='')   
                {
                    
                    rffRequestWrapper.rateSize=rateSize;
                    
                }
            }
        	objRequest.rffRequest = rffRequestWrapper;
			APICallOutRestWSUtility callOutUtil = new APICallOutRestWSUtility(SGR_INTEGRATION_NAME);
			if(newAccessToken!=null && lastTokenUpdateDateTime!=null){
          		system.debug('get new access token from previous call-->'+newAccessToken);
          		callOutUtil.newAccessToken=newAccessToken;// will get updated from callout if this token is expired
          		callOutUtil.lastTokenUpdateDateTime=lastTokenUpdateDateTime;//will get updated from callout is this token is expired
                system.debug('callOutUtil.newAccessToken-->'+callOutUtil.newAccessToken);
                system.debug('callOutUtil.lastTokenUpdateDateTime-->'+callOutUtil.lastTokenUpdateDateTime);
                
          	}
            
        	genericResponse = callOutUtil.invokeUREAgeRates(objRequest);
			if(genericResponse!=null){
                oAuthUtil=callOutUtil.oAuthUtil;
				helperData.resObj = genericResponse;
				helperData.newAccessToken = callOutUtil.newAccessToken;
				helperData.lastTokenUpdateDateTime = callOutUtil.lastTokenUpdateDateTime;
                system.debug('helperData.newAccessToken-->'+helperData.newAccessToken);
                system.debug('helperData.lastTokenUpdateDateTime-->'+helperData.lastTokenUpdateDateTime);
                system.debug('callOutUtil.oAuthUtil-->'+callOutUtil.oAuthUtil);
			}
        }catch (Exception e){
   	
   			system.debug('UREGenericResponse service error:'+e.getLineNumber()+' :'+e);
      		
   		}
        return helperData;
    }
  
    
    /************************************************************* Response Processing ***************************************************/
    
    
    public static List<SGR_Plan_Age_Rate_Header__c> processRatingResponse(List<SGR_URE_GetRatingsResponse> resList, String countyCode, Date rateEffDate,String marketSegment,String corpEntityCode){
     
            List<SGR_Plan_Age_Rate_Header__c> areaHdrLst = new List<SGR_Plan_Age_Rate_Header__c>();
            List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult> ratingPackageResults;
            SGR_URE_GetRatingsResponse.URE_RateResponse rffRsltProcess;
            system.debug('**********140********');
            if(resList != NULL) {
                
                for(SGR_URE_GetRatingsResponse objResponseWrappertoProcess : resList) {
                    rffRsltProcess = objResponseWrappertoProcess.rffResult;
                    
                    if(rffRsltProcess!= NULL){
                       
                        system.debug('**********rffRsltProcess*********'+rffRsltProcess);
                        if(rffRsltProcess.marketingRatesGenericTaskResult != null)
                            areaHdrLst.addAll(processAgeRateHeaderData(rffRsltProcess.marketingRatesGenericTaskResult,null,rateEffDate,marketSegment,corpEntityCode,countyCode));
                        if(rffRsltProcess.marketingDentalRatesGenericTaskResult != null)
                        	areaHdrLst.addAll(processAgeRateHeaderData(rffRsltProcess.marketingDentalRatesGenericTaskResult,'Dental',rateEffDate,marketSegment,corpEntityCode,countyCode));
                        
                    }
                }
            }
            return areaHdrLst;       
    }
    
    public static List<SGR_Plan_Age_Rate_Header__c> processAgeRateHeaderData(SGR_URE_GetRatingsResponse.URE_TaskResult resTaskRslt,String resType,Date rateEffDate,String marketSegment,String corpEntityCode,String countyCode){
		List<SGR_Plan_Age_Rate_Header__c> areaHdrLst = new List<SGR_Plan_Age_Rate_Header__c>();
        List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult> ratingPackageResults = new List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult>();
        if(resTaskRslt!= NULL) { 
            System.debug('Inside resTaskRslt!= NULL check');
            ratingPackageResults =  resTaskRslt.ratingPackageResults;
            System.debug('Inside ratingPackageResults'+ratingPackageResults);
            Set<String> planIdsSet = new Set<String>();
			Map<String,String> rateSizeMap = new Map<String,String>();
			
            System.debug('Inside1 ratingPackageResults'+ratingPackageResults);
            for(SGR_URE_GetRatingsResponse.URE_RatingPackageResult ratingPackageRslt: ratingPackageResults){
                for(SGR_URE_GetRatingsResponse.URE_ProductResult planRsltObj: ratingPackageRslt.productResults){
                    for(SGR_URE_GetRatingsResponse.URE_PlanRateResult plsRsltObj: planRsltObj.planResults){
                        planIdsSet.add(plsRsltObj.planId);
                        if(String.isNotBlank(resType) && resType.equalsIgnoreCase('Dental'))
                        	rateSizeMap.put(plsRsltObj.planId+plsRsltObj.rateSize,plsRsltObj.rateSize);
                    }
                }
            }
            System.debug('Inside3 ratingPackageResults'+ratingPackageResults);
            Map<String, Plan__c> planMap = new Map<String, Plan__c>();
            for(Plan__c plnObj: [SELECT Id,Plan_Sales_ID__c,Marketing_Plan_Number__c from Plan__c WHERE Marketing_Plan_Number__c IN: planIdsSet]){
                planMap.put(plnObj.Marketing_Plan_Number__c, plnObj);
            }
            
            for(SGR_URE_GetRatingsResponse.URE_RatingPackageResult ratingPackageRslt: ratingPackageResults){
                System.debug('Inside URE_RatingPackageResult loop');
                for(SGR_URE_GetRatingsResponse.URE_ProductResult planRsltObj: ratingPackageRslt.productResults){
                    System.debug('Inside URE_ProductResult loop');
                    for(SGR_URE_GetRatingsResponse.URE_PlanRateResult plsRsltObj: planRsltObj.planResults){
                        System.debug('Inside URE_PlanRateResult loop');
                        for(SGR_URE_GetRatingsResponse.URE_AreaRateResult areaRsltObj: plsRsltObj.areaResults){
                            System.debug('Inside URE_AreaRateResult loop');
                           
                            areaHdrLst.add(createAgeRateHeaderData(areaRsltObj,planRsltObj,plsRsltObj, planMap.get(plsRsltObj.planId),rateEffDate,marketSegment,corpEntityCode,resType, rateSizeMap.get(plsRsltObj.planId+plsRsltObj.rateSize),countyCode)); //@Akbar - added plsRsltObj.planId+plsRsltObj.rateSize in rateSizeMap instead of plsRsltObj.planId
                            
                        }
                    }                    
                }
            }
        }
        
        return areaHdrLst;
    }
    
    
    public static SGR_Plan_Age_Rate_Header__c createAgeRateHeaderData(SGR_URE_GetRatingsResponse.URE_AreaRateResult areaRsltObj,SGR_URE_GetRatingsResponse.URE_ProductResult planRsltObj,SGR_URE_GetRatingsResponse.URE_PlanRateResult plsRsltObj, Plan__c planObj,Date rateEffDate,String marketSegment,String corpEntityCode,String resType, String rateSize,String countyCode){
        SGR_Plan_Age_Rate_Header__c areahdrObj = new SGR_Plan_Age_Rate_Header__c();
        
        areahdrObj.Plan__c = planObj.Id;
        areahdrObj.Rate_Size__c = rateSize; 
        areahdrObj.Rating_Area_Number__c = areaRsltObj.areaNumber;
        areahdrObj.Is_Tobacco__c = boolean.valueof(areaRsltObj.isTobacco); // @Akbar - added to indentify age rate details records belongs to which header like isTobacoo Y or N during Age rate details response processing.
        areahdrObj.SGR_Product_Code_Value__c = planRsltObj.value;
        areahdrObj.SGR_Plan_Id__c = plsRsltObj.planId;
        areahdrObj.Rate_Effective_Date__c = rateEffDate;
        areahdrObj.Market_Segment__c = marketSegment;
        areahdrObj.Corporate_Entity_Code__c = corpEntityCode;
		areahdrObj.FIPS_Code__c = countyCode; //@Akbar -  added to indentify header belongs to which county code in case multiple county codes have same plan Id.
        areahdrObj.Plan_Header_External_ID__c = converthdrExtId(plsRsltObj.planId,areaRsltObj.areaNumber,areaRsltObj.isTefra,areaRsltObj.isTobacco,resType,plsRsltObj.rateSize,countyCode);
        system.debug('**********areahdrObj*********'+areahdrObj);
        
        return areahdrObj;
    }

    public static List<SGR_Plan_Age_Rate_Detail__c> createAgeRateDetailRecords(Map<String, List<SGR_Plan_Age_Rate_Header__c>> planIdHdrMap, List<SGR_URE_GetRatingsResponse.URE_PlanRateResult> planResults,String planType,String countyCode){                                                    
		List<SGR_Plan_Age_Rate_Detail__c> areaDtLst = new List<SGR_Plan_Age_Rate_Detail__c>();
		
        if(planResults == null || planResults.isEmpty()) {
        	return null;
        }

        for(SGR_URE_GetRatingsResponse.URE_PlanRateResult plsRsltObj: planResults) {
            String planId = plsRsltObj.planId;
        	List<SGR_Plan_Age_Rate_Header__c> hdrList = planIdHdrMap.get(countyCode);
        	if(null == hdrList || hdrList.isEmpty()) continue;
        	//SGR_Plan_Age_Rate_Header__c hdr = hdrList[0]; //@Akbar - commented this line due to we gets 8 records with each ratesize for single plan id and need to loop though all header records and creates details for each
            //@Akbar -  added for loop for headers to process
            for(SGR_Plan_Age_Rate_Header__c hdr:hdrList){
                if((hdr.SGR_Plan_Id__c == plsRsltObj.planId && hdr.Rate_Size__c==plsRsltObj.rateSize && (String.isNotBlank(planType) && planType.equalsIgnoreCase('Dental'))) ||
                  	((String.isNotBlank(planType) && !planType.equalsIgnoreCase('Dental')) && hdr.SGR_Plan_Id__c == plsRsltObj.planId )){
                    for(SGR_URE_GetRatingsResponse.URE_AreaRateResult areaRsltObj: plsRsltObj.areaResults) {
                        if(hdr.Is_Tobacco__c==boolean.valueof(areaRsltObj.isTobacco)){
                            for(SGR_URE_GetRatingsResponse.URE_Rate rateRslt : areaRsltObj.rates) {
                                    SGR_Plan_Age_Rate_Detail__c plAG = new SGR_Plan_Age_Rate_Detail__c();
                                    plAG.Rate_Size__c = hdr.Rate_Size__c; // Get rate size from header record
                                    plAG.Area_Number__c= areaRsltObj.areaNumber; 
                                    plAG.Is_TEFRA__c = boolean.valueof(areaRsltObj.isTefra);
                                    plAG.Is_Tobacco__c = boolean.valueof(areaRsltObj.isTobacco);
                                    plAG.From_Age__c = decimal.valueof(rateRslt.fromAge);
                                    plAG.To_Age__c = decimal.valueof(rateRslt.toAge);
                                    plAG.Relationship_Code__c = rateRslt.relationshipCode;
                                    plAG.Age_Rate_Header__c = hdr.Id;
                                    plAG.Gross_Premium__c = rateRslt.grossPremium;
                                    SGR_URE_GetRatingsResponse.URE_RetentionBreakDown rBD = new SGR_URE_GetRatingsResponse.URE_RetentionBreakDown();
                                    rBD = rateRslt.retentionBreakdown;
                                    plAG.ACA_Fees__c = rBD.ACAFees;
                                    plAG.Net_of_ACA__c = rBD.Net_of_ACA;
                                    plAG.Non_ACA_Fees__c = rBD.nonACAFees;
                                    plAG.Plan_Detail_External_ID__c = convertDtlExtId(hdr.Id,plAG.Rate_Size__c,areaRsltObj.areaNumber,areaRsltObj.isTefra,areaRsltObj.isTobacco,rateRslt.relationshipCode,rateRslt.fromAge,rateRslt.toAge);
                                    areaDtLst.add(plAG);
                                
                            }
                        }
                    }
                }
            }
                       	
		}
		
        return areaDtLst;
    }
    
    
    
    public static String converthdrExtId(String Planid, String areaNum,String isTefra,String isTobacco,String resType,String rateSize,String countyCode){
        if(String.isNotBlank(resType) && resType.equalsIgnoreCase('Dental')){
            return countyCode+Planid+areaNum+isTefra+isTobacco+rateSize;
        }else{
            return countyCode+Planid+areaNum+isTefra+isTobacco;
        }
        
    }
    
    
    public static String convertDtlExtId(String sID, String rtSize,String areaNum,String isTefra,String isTobbaco,String relationshipCode,String fromAge,String toAge){
        return sID+rtSize+areaNum+isTefra+isTobbaco+relationshipCode+fromAge+toAge;
    }
        
}