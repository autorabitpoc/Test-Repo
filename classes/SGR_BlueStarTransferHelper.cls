/**************************************************************************************
  Apex Class Name     : SGR_BlueStarTransferHelper     
  Version             			: 1.0
  Function            		: This class is used for calloutHelper to perform BlueSTAR transfer
  Modification Log    	:
* Developer: Padma  Date: 12/20/2018                   Initial version
* ----------------------------------------------------------------------------               
* Padma                  12/20/2018                Original Version
*************************************************************************************/
public class SGR_BlueStarTransferHelper {
    Private SGR_BlueStarTransferRequest input;
    //Private Opportunity opp1;
    //Private Opportunity opp2 {get; set;}
    Private Id oppId;
    Private string Id; 
    list<SGR_BlueStarTransferRequest.plan> oppPlans;
    public SGR_BlueStarTransferHelper(){
        
    }
    Public SGR_BlueStarTransferHelper(Opportunity opp2){
       
        system.debug('entered constructor'+opp2);
        string result;   
        this.oppId = opp2.Id;
        // Urgent fixes - Offshore - 19-Jan - Start
		/*List<Division__c> divisionData = Division__c.getAll().values();
		Map<String, Division__c> stateCodeCSMap = new Map<String, Division__c>();
		for (Division__c d: divisionData) {
			stateCodeCSMap.put(d.Name,d);
		}*/
		// Urgent fixes - Offshore - 19-Jan - End
        try{
        	// Fix for Uncommitted error - Shankar - Start
        	List<Opportunity> opps = new List<Opportunity>();
        	Opportunity opp = null;
        	String regionCode = null;
            if(oppId != null)
            {
            	// Urgent fixes - Offshore - 19-Jan - Start
                //Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Wholesale_Partner').getRecordTypeId();
                opps = [Select AccountId,Account.Name,SGR_Account_Number__c, Renewal_Date__c, Opportunity_Number__c, Rating_Status__c,SGR_Opportunity_Auto_Number__c, Region__c,
                       SGR_Workflow_Activity__c,Assigned_UW__c,Assigned_UW__r.EmployeeNumber, 
                        Account_Market_Segment__c,HCSC_Division__c,SGR_Renewal_Account_Name__c,Account.Market_Segment__c,
                       (Select Plan__c, Opportunity__c,Marketing_Plan_ID__c, Mapping_From_Plan_Id__c, Invitro_TX_only__c,Is_HSA__c, Type__c,
                        Plan_Status__c,Coverage_Type__c,Health_Rating_Area_Number__c,Rate_Size_Code__c From Opportunity_Plan_Rates__r 
                        where Plan_Status__c='Sold' AND Type__c='Renewal'
                       )
                       From Opportunity
                       where id=:oppId
                       AND
                       Rating_Status__c = :system.label.BlueStar_Rating_Status_Update_Sold//'Sold'
                       AND (Plan_Change_Needed__c = '' OR Plan_Change_Needed__c = 'Complete')
                       AND Workflow_System_Status__c = :system.label.BlueSTAR_System_Status_Ready_to_Send_to_BlueSTAR
                        //'Ready to Send to BlueSTAR'
                      ];
                if (null != opps && !opps.isEmpty()) {
                	opp = opps[0];
					//regionCode = ( !String.isBlank(opp.Region__c) && null !=stateCodeCSMap.get(opp.HCSC_Division__c) && !String.isBlank(stateCodeCSMap.get(opp.HCSC_Division__c).Region_Code__c) ) ? stateCodeCSMap.get(opp.HCSC_Division__c).Region_Code__c:null;					
                }
                // Fix for Uncommitted error - Shankar - End
                system.debug('Opp:::::'+opp);
                system.debug('Assigned_UW__r.EmployeeNumber::::'+opp.Assigned_UW__r.EmployeeNumber);
                system.debug('regionCode::::'+regionCode);
                if(opp!=null)
                {
                   Map<String,String> mrkplanAndRegioncdMap = new Map<String,String>();
				   List<SGR_Opportunity_Benefit_Agreement__c>  balist = [Select Status__c, Region_Code__c, Marketing_Plan_ID_13__c, 
                                                                         Id,Opportunity__c,Plan1__r.Marketing_Plan_Number__c 
                                                                         From SGR_Opportunity_Benefit_Agreement__c 
                                                                         where Opportunity__c=:opp.id
																		 AND Status__c = 'Active'];
				for(SGR_Opportunity_Benefit_Agreement__c ba:balist ){
                    mrkplanAndRegioncdMap.put(ba.Plan1__r.Marketing_Plan_Number__c,ba.Region_Code__c);
                                              //new set<string>{ba.Plan1__r.Marketing_Plan_Number__c});
					}

					
                    input = new SGR_BlueStarTransferRequest();
                    SGR_BlueStarTransferRequest.opportunityDetails oppTransferDetails = new SGR_BlueStarTransferRequest.opportunityDetails();//initialized
                    system.debug('opp transfer detail::'+oppTransferDetails);
                    if(opp!=null && opp.HCSC_Division__c != Null){
                        oppTransferDetails.corpEntCd = opp.HCSC_Division__c + '1'; 
                        system.debug('oppTransferDetails.corpEntCd::::::'+oppTransferDetails.corpEntCd);
                    }                   
                    
                    string accountNumber = opp.SGR_Account_Number__c;
                    if(accountNumber != NULL  && accountNumber.length() > 6 ) {
                        accountNumber = accountNumber.substring(2, accountNumber.length());   
                    }
                    oppTransferDetails.acctNbr = accountNumber;               
                    system.debug('oppTransferDetails.acctNbr::::::'+oppTransferDetails.acctNbr);
                    oppTransferDetails.acctNm = opp.SGR_Renewal_Account_Name__c;
                    system.debug('oppTransferDetails.acctNm::::::'+oppTransferDetails.acctNm);
                    system.debug('opp.Renewal_Date__c'+opp.Renewal_Date__c);
                    
                    if(opp.Renewal_Date__c!=null){
                        oppTransferDetails.acctRnewlDt = string.valueof(date.newinstance(opp.Renewal_Date__c.year(), opp.Renewal_Date__c.month(), opp.Renewal_Date__c.day()));
                        system.debug('input.opportunityDetails'+oppTransferDetails.acctRnewlDt);
                    }
                    oppTransferDetails.mktSegCd =opp.Account.Market_Segment__c;
                    String oppNumber = opp.SGR_Opportunity_Auto_Number__c;
                    system.debug('opp.SGR_Opportunity_Auto_Number__c;'+oppNumber);
                    System.debug('opp.Opportunity_Plan_Rates__r::'+opp.Opportunity_Plan_Rates__r);
                    if(oppNumber!=null){
                        oppNumber = oppNumber.substring(2, oppNumber.length());
                    }
                    oppTransferDetails.opportunityId = oppNumber;
                    oppTransferDetails.underwriterID = opp.Assigned_UW__r.EmployeeNumber;
                    //oppTransferDetails.rtSzCd = opp.Opportunity_Plan_Rates__r.Rate_Size_Code__c;
                    list<SGR_Opportunity_Plan_Rate__c> oppPlansOrRates = new list<SGR_Opportunity_Plan_Rate__c>();
                    for(SGR_Opportunity_Plan_Rate__c opr: opp.Opportunity_Plan_Rates__r){
                        if(opr.Coverage_Type__c == 'D'){
                            if(opr.Type__c == 'Renewal') oppPlansOrRates.add(opr);
                        }
                    }
                    if(!oppPlansOrRates.isEmpty()){
                        system.debug('oppPlansOrRates::::'+oppPlansOrRates);
                        oppTransferDetails.rtSzCd = oppPlansOrRates[0].Rate_Size_Code__c==null?'':oppPlansOrRates[0].Rate_Size_Code__c;
                        system.debug('oppTransferDetails.rtSzCd::::'+oppTransferDetails.rtSzCd);
                    }
                    system.debug('input.opportunityDetails--->>>'+oppTransferDetails);
                    input.opportunityDetails =  oppTransferDetails;
                    
                    
                    //oppPlanRate = [];
                    oppPlans = new list<SGR_BlueStarTransferRequest.plan>();
                    for(SGR_Opportunity_Plan_Rate__c oppPlanRate: opp.Opportunity_Plan_Rates__r)
                    {
                        SGR_BlueStarTransferRequest.plan planOrRateChange = new SGR_BlueStarTransferRequest.plan();
                        planOrRateChange.mktgPlnNbr = oppPlanRate.Marketing_Plan_ID__c;
                        planOrRateChange.effectiveDate = string.valueof(date.newinstance(opp.Renewal_Date__c.year(), opp.Renewal_Date__c.month(), opp.Renewal_Date__c.day()));
                        planOrRateChange.oldMktgPlnNbr = 
                            oppPlanRate.Mapping_From_Plan_Id__c != NULL?oppPlanRate.Mapping_From_Plan_Id__c:oppPlanRate.Marketing_Plan_ID__c;
                        //regionCd hard codeded value until we get resolution from Datalake and Bluestar
                        if(opp.HCSC_Division__c == 'TX') planOrRateChange.regionCd = mrkplanAndRegioncdMap.get(oppPlanRate.Marketing_Plan_ID__c);
                        system.debug('planOrRateChange.regionCd ::::'+planOrRateChange.regionCd);
                        planOrRateChange.invitroInd = (oppPlanRate.Invitro_TX_only__c)==false?'N':'Y';
                        //planOrRateChange.visInd = oppPlanRate.Coverage_Type__c;
                        planOrRateChange.visInd = oppPlanRate.Coverage_Type__c=='V'?'Y':'N';
                        planOrRateChange.hsaInd = (oppPlanRate.Is_HSA__c)==false?'N':'Y';
                        planOrRateChange.totRtChgPct = '0.00';
                        planOrRateChange.totAdminChrgPct = '0.00';
                        planOrRateChange.ureAreaNbr = oppPlanRate.Health_Rating_Area_Number__c;

                        oppPlans.add(planOrRateChange);
                    }
                    input.plans = oppPlans;
                }
            }
        }catch(exception e){
            system.debug('Exception::::'+e);
            SGR_Exception ex = new SGR_Exception('Creating Bluestar Request has been failed.');
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_BlueStarTransferHelper', null, 'SGR_BlueStarTransferHelper(Opportunity opp)','Low');
        }
        // return result;
    }
    public String convertInputToRequest(){
        string request = null;
        XmlStreamWriter req = new XmlStreamWriter();
        try{
            if(input !=null && input.opportunityDetails != NULL){
                system.debug('input.opportunityDetails'+input.opportunityDetails);
                req.writeStartElement(null, 'AutomatedPlanChangeServiceRequest', null);
                req.writeCharacters('\r\n');
                system.debug(' req::'+req);
                system.debug('input:::'+input);
                
                addXmlElement(req, 'corpEntCd', input.opportunityDetails.corpEntCd);
                addXmlElement(req, 'acctNbr', input.opportunityDetails.acctNbr);
                addXmlElement(req, 'acctNm', input.opportunityDetails.acctNm);
                addXmlElement(req, 'acctRnewlDt', input.opportunityDetails.acctRnewlDt);
                addXmlElement(req, 'mktSegCd', input.opportunityDetails.mktSegCd);
                addXmlElement(req, 'opportunityId', input.opportunityDetails.opportunityId);
                addXmlElement(req, 'modNbr', null);
                addXmlElement(req, 'underwriterID', input.opportunityDetails.underwriterID);
                addXmlElement(req, 'acaAtstnCd', '');
                addXmlElement(req, 'rtSzCd', input.opportunityDetails.rtSzCd);
                req.writeStartElement(null, 'renewingPlans', null);
                req.writeCharacters('\r\n');
                for(SGR_BlueStarTransferRequest.plan plan:input.plans){
                    req.writeStartElement(null, 'plan', null);
                    addXmlPlan(req, plan);
                    req.writeEndElement();
                }
                req.writeCharacters('\r\n');
                req.writeEndElement();
                req.writeCharacters('\r\n');
                req.writeEndElement();
                request = req.getXmlString();
                system.debug('request:::::::::::'+request);
                req.close();  
            }
        }catch(exception e){
            system.debug('Exception::::'+e);
            SGR_Exception ex = new SGR_Exception('Creating Bluestar Request has been failed.');
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_BlueStarTransferHelper', null, 'SGR_BlueStarTransferHelper(Opportunity opp)','Low');
        }
        return request;
    }
    private void addXmlElement(XmlStreamWriter w, String elemName, String value){
        w.writeStartElement(null, elemName, null);
        w.writeCharacters(value==null?'':value);
        w.writeEndElement();
        w.writeCharacters('\r\n');
    }
    private void addXmlPlan(XmlStreamWriter req, SGR_BlueStarTransferRequest.plan oppPlanRate){
        addXmlElement(req, 'mktgPlnNbr', oppPlanRate.mktgPlnNbr);
        addXmlElement(req, 'effectiveDate', oppPlanRate.effectiveDate);
        addXmlElement(req, 'oldMktgPlnNbr', oppPlanRate.oldMktgPlnNbr);
        //addXmlElement(req, 'effectiveDate', oppPlanRate.effectiveDate);
        // addXmlElement(req, 'schdleCd', '');
        // Urgent fixes - Offshore - 19-Jan - Start
        if (!String.isBlank(oppPlanRate.regionCd)) addXmlElement(req, 'regionCd', oppPlanRate.regionCd);
        // Urgent fixes - Offshore - 19-Jan - End
        // addXmlElement(req, 'matrntyInd', ''); 
        addXmlElement(req, 'invitroInd', oppPlanRate.invitroInd);
        //addXmlElement(req, 'speechInd', '');
        //addXmlElement(req, 'mmhInd', '');
        addXmlElement(req, 'visInd', oppPlanRate.visInd);
        addXmlElement(req, 'hsaInd', oppPlanRate.hsaInd); 
        addXmlElement(req, 'totRtChgPct', oppPlanRate.totRtChgPct);
        addXmlElement(req, 'totAdminChrgPct', oppPlanRate.totAdminChrgPct);
        addXmlElement(req, 'ureAreaNbr', oppPlanRate.ureAreaNbr);
    }    

}