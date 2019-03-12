/*************************************************************************************************
	Class Name: SGR_URE_OpptyCompAndAgeRatingUtility.cls
	Created By: Cesar Murcia
	Description: Utility class that encamsulate the business logic to perform rating 
				 for Plan Rates (Renewal, Alternate, Option2 and Option3)  and Member Benefits.
**************************************************************************************************/
global class SGR_URE_OpptyCompAndAgeRatingUtility {


/* Public Methods */
	public static OpportunityCompositeRateModel ComputeCompositeAndAgeRates(List<SGR_URE_GetRatingsResponse> ureResponse, 
														List<SGR_Opportunity_Plan_Rate__c> opptyPlanRates, String planType){
		Set<Id> OpptyPlanRateIdList = new Set<Id>();
		List<SGR_Opportunity_Plan_Composite_Rate__c> compositeRates;
		Map<String, List<SGR_Opportunity_Plan_Composite_Rate__c>> compositeRatesMap = new Map<String, List<SGR_Opportunity_Plan_Composite_Rate__c>>();
		List<SGR_Opportunity_Plan_Composite_Rate__c> compositeRatesToInsert = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
		OpportunityCompositeRateModel opptyCompositeRateModel = new OpportunityCompositeRateModel();
		opptyCompositeRateModel.opptyPlanCompositeRates = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
		opptyCompositeRateModel.memberRates = new List<SGR_Opportunity_Member_Benefits__c>();
		List<Id> opportunityIds = new List<Id>();
		List<Id> planIds = new List<Id>();
		Map<Id, OpptyRenewPlanRateSummaryTotals> OpptyRenewPlanRateSumTotalsMap = new Map<Id, OpptyRenewPlanRateSummaryTotals>();
		OpptyRenewPlanRateSummaryTotals OpptyRenewPlanRateSumTotals = new OpptyRenewPlanRateSummaryTotals();
		SGR_Opportunity_Plan_Composite_Rate__c compositeRate;
		Boolean IsRenewingPlan = planType == SGR_URE_RatingOption.RENEWING_PLAN_TYPE;
		Boolean IsAlternatePlanRate = planType ==  SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE;

		try
		{
			URERateModel planRateMap =  SGR_URE_OpptyCompAndAgeRatingUtility.GetPlanCompAndAgeRateResultMapByPlanId(ureResponse);  

			for(SGR_Opportunity_Plan_Rate__c opr: opptyPlanRates){
				OpptyPlanRateIdList.add(opr.Id);
				if(!opportunityIds.contains(opr.Opportunity__c)){
				    opportunityIds.add(opr.Opportunity__c);
				}
				planIds.add(opr.Plan__c);
			}

			Map<String, MemberModelByPlan> membersByPlanRateMap = GetMembersByPlanRate(OpptyPlanRateIdList, planIds, opportunityIds, planType);

			for(SGR_Opportunity_Plan_Rate__c opr: opptyPlanRates){
				System.debug(String.format('SGR_URE_OpptyCompAndAgeRatingUtility:: Processing Plan/Type {0}/{1}', 
									new String[] {opr.Plan__r.Marketing_Plan_Number__c, planType}));
				/* compute totals for member benefits */
				List<SGR_URE_GetRatingsResponse.URE_TierRate> tierRates = getTierRate(planRateMap.compositeRateMap.get(opr.Plan__r.Marketing_Plan_Number__c));
				compositeRates = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
				for(SGR_URE_GetRatingsResponse.URE_TierRate tr : tierRates) {
					compositeRate = new SGR_Opportunity_Plan_Composite_Rate__c();
					for(SGR_Opportunity_Plan_Composite_Rate__c cr : opr.Opportunity_Plan_Composite_Rate__r) {
							if(cr.Tier_Code__c == tr.tier) {
								compositeRate = cr;
								break;
							}
					}
						
					compositeRate.Gross_Premium__c = tr.grossPremium;
					compositeRate.ACA_Fees__c = tr.ACAFees;
					compositeRate.Tier_Code__c = tr.tier;
					compositeRate.Volume__c = membersByPlanRateMap.containsKey(opr.Id) ? membersByPlanRateMap.get(opr.Id).getCountByTier(tr.tier) : 0;
					compositeRate.Opportunity_Plan_Rate__c = opr.Id;
					compositeRates.add(compositeRate);

				}

				if(compositeRates.size() > 0) {
					compositeRatesMap.put(opr.Id, compositeRates);
					opptyCompositeRateModel.opptyPlanCompositeRates.addAll(compositeRates);
				}

				String memberMapKey = IsAlternatePlanRate ? opr.Plan__r.Line_Of_Business__c : opr.Id;

				MemberModelByPlan members = membersByPlanRateMap.containsKey(memberMapKey) ? membersByPlanRateMap.get(memberMapKey) : new MemberModelByPlan();
				List<SGR_Opportunity_Member_Benefits__c> subscribers = members.getSubscriberMembers();
				if(IsAlternatePlanRate && subscribers.size() == 0) {
					System.debug('No members for memberMapKey = ' + memberMapKey );
					memberMapKey = (opr.Plan__r.Line_Of_Business__c == SGR_URE_RatingOption.DENTALCOVERAGECODE || 
									opr.Plan__r.Line_Of_Business__c == SGR_URE_RatingOption.VISIONCOVERAGECODE) 
									? SGR_URE_RatingOption.HEALTHCOVERAGECODE : SGR_URE_RatingOption.DENTALCOVERAGECODE;

					members = membersByPlanRateMap.containsKey(memberMapKey) ? membersByPlanRateMap.get(memberMapKey) : new MemberModelByPlan();
					subscribers = members.getSubscriberMembers();
				}

				/* compute totals for subscribers */
				List<SGR_Opportunity_Plan_Composite_Rate__c> compositeRateList = compositeRatesMap.containsKey(opr.Id) ? compositeRatesMap.get(opr.Id) : new List<SGR_Opportunity_Plan_Composite_Rate__c>();
				Decimal totalRenewCompGrosPremium = 0;
				Decimal totalRenewCompTaxAndFee = 0;
				Decimal totalRenewAgeGrosPremium = 0;
				Decimal totalRenewAgeTaxAndFee = 0;

	
				/* compute Members age & composite rates */
				List<SGR_Opportunity_Member_Benefits__c> allMembers = members.getAllMembers();	
				List<SGR_Opportunity_Member_Benefits__c> subsciberList = new List<SGR_Opportunity_Member_Benefits__c>();	
				Map<String, TotalsBySubscriber> totalAgeRatesBySubsMap = new Map<String, TotalsBySubscriber>();	
				TotalsBySubscriber totalAgeBySubs;
				for(SGR_Opportunity_Member_Benefits__c subs: allMembers) {

						for(SGR_Opportunity_Plan_Composite_Rate__c cr : compositeRateList) {
							if(cr.Tier_Code__c ==  subs.Member_Policy_Tier__c && subs.Relationship_Code__c == SGR_URE_RatingOption.SUBSCRIBER ) {
								subs.put('Renw_Comp_Gross_Premium__c' , cr.Gross_Premium__c);
								subs.put('Renw_Comp_ACA_Fees__c',cr.ACA_Fees__c);
								/* for subscribers, the composite totals should be equal to the Renw_Comp_Gross_Premium__c, and Renw_Comp_ACA_Fees__c */
								subs.put('Renw_Comp_Total_Monthly_Premium__c',cr.Gross_Premium__c);
								subs.put('Renw_Comp_Total_Est_Tax_and_Fees__c', cr.ACA_Fees__c);

								totalRenewCompTaxAndFee = totalRenewCompTaxAndFee  + cr.ACA_Fees__c;
								totalRenewCompGrosPremium = totalRenewCompGrosPremium + cr.Gross_Premium__c;

								/* Missing computation totals by family and stored in Member Benefits subscriber record */
								/*subs.put('Renw_Comp_Total_Monthly_Premium__c',total by family);
								subs.put('Renw_Comp_Total_Est_Tax_and_Fees__c', total by family);*/ 

							}
						}

						if(IsRenewingPlan){
							/* assign current premiumns to renewing current fields */
							if(subs.Rate_Type__c == SGR_URE_RatingOption.COMPOSITE) {
								subs.put('Current_Comp_Gross_Premium__c', subs.Member_Rate__c);
								subs.put('Current_Comp_ACA_Fees__c', subs.ACA_Fee__c);
							}
							else {
								subs.put('Current_Age_Gross_Premium__c', subs.Member_Rate__c);
								subs.put('Current_Age_ACA_Fees__c', subs.ACA_Fee__c);
							}
							opptyCompositeRateModel.memberRates.add(subs);
						}

						/* get census/emeber rates by Marketing Plan Id */
						String memberKey = opr.Plan__r.Marketing_Plan_Number__c + '_' + subs.Opportunity_Census__c;
						SGR_URE_GetRatingsResponse.URE_Rate ureAgeRate = planRateMap.ureRateMap.get(memberKey);
						/*System.debug('Plan Rate Map - ' + planRateMap);*/
						System.debug('Member Key = ' + memberKey );
						System.debug('ureAgeRate ' + ureAgeRate);
						if(ureAgeRate!=null){
							subs.put('Renw_Age_Gross_Premium__c',ureAgeRate.grossPremium);
							subs.put('Renw_Age_ACA_Fees__c',ureAgeRate.retentionBreakdown.ACAFees);
							subs.put('Renw_Age_Net_Of_ACA_Fees__c',ureAgeRate.retentionBreakdown.Net_of_ACA);
							subs.put('Renw_Age_Non_ACA_Fees__c',ureAgeRate.retentionBreakdown.nonACAFees);
						}
						else {
							System.debug('Census Rating:: Census Key not found - ' + memberKey);
							subs.put('Renw_Age_Gross_Premium__c',0);
							subs.put('Renw_Age_ACA_Fees__c',0);
							subs.put('Renw_Age_Net_Of_ACA_Fees__c',0);
							subs.put('Renw_Age_Non_ACA_Fees__c',0);
						}

						

						/* Compute age rate totals per subscribers */
						if(subs.Relationship_Code__c == SGR_URE_RatingOption.SUBSCRIBER){
							 totalRenewAgeGrosPremium +=  CheckForNull(subs.Renw_Age_Gross_Premium__c);
							 totalRenewAgeTaxAndFee += CheckForNull(subs.Renw_Age_ACA_Fees__c);
							 subsciberList.add(subs);
						}


						if(totalAgeRatesBySubsMap.containsKey(subs.Opportunity_Census__c)) {
							totalAgeBySubs = totalAgeRatesBySubsMap.get(subs.Opportunity_Census__c);
							totalAgeBySubs.Renw_Age_Total_Monthly_Premium +=  CheckForNull(subs.Renw_Age_Gross_Premium__c);
							totalAgeBySubs.Renw_Age_Total_Est_Tax_and_Fees += CheckForNull(subs.Renw_Age_ACA_Fees__c);
							if(IsRenewingPlan) {
								totalAgeBySubs.Current_Age_Total_Monthly_Premium += CheckForNull(subs.Current_Age_Gross_Premium__c);
								totalAgeBySubs.Current_Age_Total_Est_Tax_and_Fees += CheckForNull(subs.Current_Age_ACA_Fees__c);	
							}						
						}
						else {
							totalAgeBySubs = new TotalsBySubscriber();
                            
							totalAgeBySubs.Renw_Age_Total_Monthly_Premium += CheckForNull(subs.Renw_Age_Gross_Premium__c);
							totalAgeBySubs.Renw_Age_Total_Est_Tax_and_Fees += CheckForNull(subs.Renw_Age_ACA_Fees__c);
                            
							if(IsRenewingPlan) {
								totalAgeBySubs.Current_Age_Total_Monthly_Premium += CheckForNull(subs.Current_Age_Gross_Premium__c);
								totalAgeBySubs.Current_Age_Total_Est_Tax_and_Fees += CheckForNull(subs.Current_Age_ACA_Fees__c);	
							}						
							totalAgeRatesBySubsMap.put(subs.Opportunity_Census__c, totalAgeBySubs);
						}

						/*System.debug(String.format('SGR_URE_OpptyCompAndAgeRatingUtility:: Processing Plan/Type {0}/{1} - Subscriber Number {2}', 
											new String[] {opr.Plan__r.Marketing_Plan_Number__c, planType, subs.Opportunity_Census__c}));
						System.debug(subs);*/

				}


				/* compute subscriber member age total */
				for(SGR_Opportunity_Member_Benefits__c subs : subsciberList) {
					 totalAgeBySubs = totalAgeRatesBySubsMap.get(subs.Opportunity_Census__c);
					 if(totalAgeBySubs != null){
						 subs.put('Renw_Age_Total_Monthly_Premium__c',totalAgeBysubs.Renw_Age_Total_Monthly_Premium);
						 subs.put('Renw_Age_Total_Est_Tax_and_Fees__c',totalAgeBysubs.Renw_Age_Total_Est_Tax_and_Fees);
						 if(IsRenewingPlan) {
							subs.put('Current_Age_Total_Monthly_Premium__c',totalAgeBysubs.Current_Age_Total_Monthly_Premium);
							subs.put('Current_Age_Total_Est_Tax_and_Fees__c',totalAgeBySubs.Current_Age_Total_Est_Tax_and_Fees);
						 }
					 }
				}

				/* compute total for plan rates */
				opr.put('EC_Enrolled_Subscriber_Count__c', members.getCountByTier(SGR_URE_RatingOption.TIER_EC));
				opr.put('EO_Enrolled_Subscriber_Count__c',members.getCountByTier(SGR_URE_RatingOption.TIER_EO)); 
				opr.put('EF_Enrolled_Subscriber_Count__c',members.getCountByTier(SGR_URE_RatingOption.TIER_EF));
				opr.put('ES_Enrolled_Subscriber_Count__c',members.getCountByTier(SGR_URE_RatingOption.TIER_ES));
				opr.put('Enrolled_Subscriber_Count__c',members.getSubscriberMembers().size()); 
				opr.put('Enrolled_Member_Count__c',members.getAllMembers().size());
				/* compute Renewing composite total for plan rates */
				opr.put('Renw_Comp_Total_Est_Tax_and_Fees__c',totalRenewCompTaxAndFee);
				opr.put('Renw_Comp_Total_Monthly_Premium__c',totalRenewCompGrosPremium);

				/* compute Renewing aged total for plan rates */
				opr.put('Renw_Age_Total_Est_Tax_and_Fees__c',totalRenewAgeTaxAndFee);
				opr.put('Renw_Age_Total_Monthly_Premium__c',totalRenewAgeGrosPremium);

				if(IsRenewingPlan) {
					
					System.debug('Update current plan fields in Renewal Plan: Plan__c =' + opr.Plan__c );

					if(opr.Rate_Type_Code__c == SGR_URE_RatingOption.STN){
						opr.put('Current_Comp_Total_Monthly_Premium__c', opr.Member_Premium__c);
						opr.put('Current_Comp_Total_Est_Tax_and_Fees__c', opr.ACA_Fee__c);
					}
					else {
						opr.put('Current_Age_Total_Monthly_Premium__c', opr.Member_Premium__c);
						opr.put('Current_Age_Total_Est_Tax_and_Fees__c', opr.ACA_Fee__c);
					}

					/* compute opportunity summary records */
					String coverageType = opr.Plan__r.Line_Of_Business__c;
					if(OpptyRenewPlanRateSumTotalsMap.containsKey(opr.Opportunity__c))
					{
						OpptyRenewPlanRateSumTotals = OpptyRenewPlanRateSumTotalsMap.get(opr.Opportunity__c);
						
						if(coverageType == 'V') {
							OpptyRenewPlanRateSumTotals.Total_Vision_Monthly_Premium += CheckForNull(opr.Renw_Comp_Total_Monthly_Premium__c);
							OpptyRenewPlanRateSumTotals.Total_Est_Vision_Insurer_Fees += CheckForNull(opr.Renw_Comp_Total_Est_Tax_and_Fees__c);
						}
						else if(coverageType == 'D'){
							OpptyRenewPlanRateSumTotals.Total_Dental_Monthly_Premium += CheckForNull(opr.Renw_Comp_Total_Monthly_Premium__c);
							OpptyRenewPlanRateSumTotals.Total_Est_Dental_Insurer_Fees += CheckForNull(opr.Renw_Comp_Total_Est_Tax_and_Fees__c);
							
						}
						else if(coverageType == 'H')
						{
							OpptyRenewPlanRateSumTotals.Total_Medical_Monthly_Premium += CheckForNull(opr.Renw_Comp_Total_Monthly_Premium__c);
							OpptyRenewPlanRateSumTotals.Total_Est_Medical_Insurer_Fees += CheckForNull(opr.Renw_Comp_Total_Est_Tax_and_Fees__c);
						}
					}
					else {
						OpptyRenewPlanRateSumTotals = new OpptyRenewPlanRateSummaryTotals(); 
						
						if(coverageType == 'V') {
							OpptyRenewPlanRateSumTotals.Total_Vision_Monthly_Premium += CheckForNull(opr.Renw_Comp_Total_Monthly_Premium__c);
							OpptyRenewPlanRateSumTotals.Total_Est_Vision_Insurer_Fees += CheckForNull(opr.Renw_Comp_Total_Est_Tax_and_Fees__c);
						}
						else if(coverageType == 'D'){
							OpptyRenewPlanRateSumTotals.Total_Dental_Monthly_Premium += CheckForNull(opr.Renw_Comp_Total_Monthly_Premium__c);
							OpptyRenewPlanRateSumTotals.Total_Est_Dental_Insurer_Fees += CheckForNull(opr.Renw_Comp_Total_Est_Tax_and_Fees__c);
							
						}
						else if(coverageType == 'H')
						{
							OpptyRenewPlanRateSumTotals.Total_Medical_Monthly_Premium += CheckForNull(opr.Renw_Comp_Total_Monthly_Premium__c);
							OpptyRenewPlanRateSumTotals.Total_Est_Medical_Insurer_Fees += CheckForNull(opr.Renw_Comp_Total_Est_Tax_and_Fees__c);
						}
						
						OpptyRenewPlanRateSumTotalsMap.put(opr.Opportunity__c, OpptyRenewPlanRateSumTotals);
					}
				}
				
			}
			

			List<Opportunity> opptyToUpdateList = new List<Opportunity>();
			/* update opportunity level summary total */
			for(Id opptyId: OpptyRenewPlanRateSumTotalsMap.keySet()){
			    OpptyRenewPlanRateSummaryTotals OpptyRenewPRateSumTotals = OpptyRenewPlanRateSumTotalsMap.get(opptyId);
			    Opportunity oppty = new Opportunity(Id=opptyId);
			    //oppty.put('Total_Monthly_Premium__c',OpptyRenewPRateSumTotals.Total_Monthly_Premium);
			    oppty.put('Total_Medical_Monthly_Premium__c',OpptyRenewPRateSumTotals.Total_Medical_Monthly_Premium);
			    oppty.put('Total_Dental_Monthly_Premium__c',OpptyRenewPRateSumTotals.Total_Dental_Monthly_Premium);
			    oppty.put('Total_Vision_Monthly_Premium__c',OpptyRenewPRateSumTotals.Total_Vision_Monthly_Premium);
			    
			    oppty.put('Total_Est_Medical_Insurer_Fees__c',OpptyRenewPRateSumTotals.Total_Est_Medical_Insurer_Fees);
			    oppty.put('Total_Est_Dental_Insurer_Fees__c',OpptyRenewPRateSumTotals.Total_Est_Dental_Insurer_Fees);
			    oppty.put('Total_Est_Vision_Insurer_Fees__c',OpptyRenewPRateSumTotals.Total_Est_Vision_Insurer_Fees);
			    
				opptyToUpdateList.add(oppty);
			}

			opptyCompositeRateModel.opptyPlanRates = opptyPlanRates;
			opptyCompositeRateModel.opptyToUpdateList = opptyToUpdateList;
			

		}
		catch (Exception ex) {
             CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_OpptyCompAndAgeRatingUtility', null, 'SGR_URE_OpptyCompAndAgeRatingUtility.ComputeCompositeRates', 'High');
			 throw ex;

        }    

		return opptyCompositeRateModel;

	}

	public static OpportunityCompositeRateModel ComputeOptionPlansForRenewingPlans(Map<Id, Id> Plan_Option2, Map<Id, Id> Plan_Option3, List<SGR_Opportunity_Plan_Rate__c> RenewalPlansToUpdate) {
		OpportunityCompositeRateModel opptyCompositeRateModel = new OpportunityCompositeRateModel();
		List<Id> opportunityIds = new List<Id>();
		Set<Id> OpptyPlanRateIdList = new Set<Id>();
		List<Id> planIds = new List<Id>();
		

		for(SGR_Opportunity_Plan_Rate__c pr: RenewalPlansToUpdate) {
			opportunityIds.add(pr.Opportunity__c);
			OpptyPlanRateIdList.add(pr.Id);
			planIds.add(pr.Plan__c);
		}
		try{

			Map<Id, SGR_Opportunity_Plan_Rate__c> planRates2 = GetOptionPlans(Plan_Option2.values(), opportunityIds);
			Map<Id, SGR_Opportunity_Plan_Rate__c> planRates3 = GetOptionPlans(Plan_Option3.values(), opportunityIds);
			Map<Id, List<SGR_Opportunity_Member_Benefits__c>> member2 = GetOptionPlanMembers(Plan_Option2.values(), opportunityIds );
			Map<Id, List<SGR_Opportunity_Member_Benefits__c>> member3 = GetOptionPlanMembers(Plan_Option3.values(), opportunityIds );
			Map<String, MemberModelByPlan> membersMap = GetMembersByPlanRate(OpptyPlanRateIdList, planIds, opportunityIds, SGR_URE_RatingOption.RENEWING_PLAN_TYPE);
			SGR_Opportunity_Plan_Rate__c po2; 
			SGR_Opportunity_Plan_Rate__c po3;
			List<SGR_Opportunity_Member_Benefits__c> mbList; 
			List<SGR_Opportunity_Member_Benefits__c> mbToUpdate = new List<SGR_Opportunity_Member_Benefits__c>();
			for(SGR_Opportunity_Plan_Rate__c pr : RenewalPlansToUpdate){

				/* update plan rates */
				if(Plan_Option2.containsKey(pr.Id)) {
					if(planRates2.containsKey(Plan_Option2.get(pr.Id))) {
						po2 = planRates2.get(Plan_Option2.get(pr.Id));
						pr.put('Opt2_Plan_Id__c',po2.Plan__c);
						pr.put('Opt2_Renw_Age_Total_Est_Tax_and_Fees__c',po2.Renw_Age_Total_Est_Tax_and_Fees__c);
						pr.put('Opt2_Renw_Age_Total_Monthly_Premium__c',po2.Renw_Age_Total_Monthly_Premium__c);
						pr.put('Opt2_Renw_Comp_Total_Est_Tax_and_Fees__c',po2.Renw_Comp_Total_Est_Tax_and_Fees__c);
						pr.put('Opt2_Renw_Comp_Total_Monthly_Premium__c',po2.Renw_Comp_Total_Monthly_Premium__c);

					}
					if(member2.containsKey(Plan_Option2.get(pr.Id))) {
						mbList = member2.get(Plan_Option2.get(pr.Id));
						MemberModelByPlan members = membersMap.containsKey(pr.Id) ? membersMap.get(pr.Id) : new MemberModelByPlan();
						for(SGR_Opportunity_Member_Benefits__c m2: mbList){
							
							for(SGR_Opportunity_Member_Benefits__c m : members.getAllMembers()){
								if(m.Relationship_Code__c == m2.Relationship_Code__c && 
									m.Member_Policy_Tier__c == m2.Member_Policy_Tier__c && 
									m.Opportunity_Census__r.Member_Name__c == m2.Opportunity_Census__r.Member_Name__c &&
									m.Opportunity_Census__r.Subscriber_Number__c == m2.Opportunity_Census__r.Subscriber_Number__c ) {
										m.put('Opt2_Renw_Age_ACA_Fees__c', m2.Renw_Age_ACA_Fees__c);
										m.put('Opt2_Renw_Age_Gross_Premium__c', m2.Renw_Age_Gross_Premium__c);
 										m.put('Opt2_Renw_Age_Net_Of_ACA_Fees__c', m2.Renw_Age_Net_Of_ACA_Fees__c);
										m.put('Opt2_Renw_Age_Non_ACA_Fees__c', m2.Renw_Age_Non_ACA_Fees__c);
										m.put('Opt2_Renw_Age_Total_Est_Tax_and_Fees__c', m2.Renw_Age_Total_Est_Tax_and_Fees__c);
										m.put('Opt2_Renw_Age_Total_Monthly_Premium__c', m2.Renw_Age_Total_Monthly_Premium__c);

										m.put('Opt2_Renw_Comp_ACA_Fees__c', m2.Renw_Comp_ACA_Fees__c);
										m.put('Opt2_Renw_Comp_Gross_Premium__c', m2.Renw_Comp_Gross_Premium__c);
										m.put('Opt2_Renw_Comp_Total_Est_Tax_and_Fees__c', m2.Renw_Comp_Total_Est_Tax_and_Fees__c);
										m.put('Opt2_Renw_Comp_Total_Monthly_Premium__c', m2.Renw_Comp_Total_Monthly_Premium__c);
										m.put('Opt2_Age_Total_Child_Rate__c', m2.Age_Total_Child_Rate__c);
										m.put('Opt2_Age_Total_Employee_Rate__c', m2.Age_Total_Employee_Rate__c);

										m.put('Opt2_Age_Total_Spouse_Rate__c', m2.Age_Total_Spouse_Rate__c);
										m.put('Opt2_Comp_Total_Child_Rate__c', m2.Comp_Total_Child_Rate__c);
										m.put('Opt2_Comp_Total_Employee_Rate__c', m2.Comp_Total_Employee_Rate__c);
										m.put('Opt2_Comp_Total_Spouse_Rate__c', m2.Comp_Total_Spouse_Rate__c);

										mbToUpdate.add(m);

									}
							}
						}
					}
				}

				if(Plan_Option3.containsKey(pr.Id)) {
					if(planRates3.containsKey(Plan_Option3.get(pr.Id))) {
						po3 = planRates3.get(Plan_Option3.get(pr.Id));
						pr.put('Opt3_Plan_Id__c',po3.Plan__c);
						pr.put('Opt3_Renw_Age_Total_Est_Tax_and_Fees__c',po3.Renw_Age_Total_Est_Tax_and_Fees__c);
						pr.put('Opt3_Renw_Age_Total_Monthly_Premium__c',po3.Renw_Age_Total_Monthly_Premium__c);
						pr.put('Opt3_Renw_Comp_Total_Est_Tax_and_Fees__c',po3.Renw_Comp_Total_Est_Tax_and_Fees__c);
						pr.put('Opt3_Renw_Comp_Total_Monthly_Premium__c',po3.Renw_Comp_Total_Monthly_Premium__c);

					}

					if(member3.containsKey(Plan_Option3.get(pr.Id))) {
						mbList = member3.get(Plan_Option3.get(pr.Id));
						MemberModelByPlan members = membersMap.containsKey(pr.Id) ? membersMap.get(pr.Id) : new MemberModelByPlan();
						for(SGR_Opportunity_Member_Benefits__c m3: mbList){
							
							for(SGR_Opportunity_Member_Benefits__c m : members.getAllMembers()){
								if(m.Relationship_Code__c == m3.Relationship_Code__c && 
									m.Member_Policy_Tier__c == m3.Member_Policy_Tier__c && 
									m.Opportunity_Census__r.Subscriber_Number__c == m3.Opportunity_Census__r.Subscriber_Number__c ) {
										m.put('Opt3_Renw_Age_ACA_Fees__c', m3.Renw_Age_ACA_Fees__c);
										m.put('Opt3_Renw_Age_Gross_Premium__c', m3.Renw_Age_Gross_Premium__c);
										m.put('Opt3_Renw_Age_Net_Of_ACA_Fees__c', m3.Renw_Age_Net_Of_ACA_Fees__c);
										m.put('Opt3_Renw_Age_Non_ACA_Fees__c', m3.Renw_Age_Non_ACA_Fees__c);
										m.put('Opt3_Renw_Age_Total_Est_Tax_and_Fees__c', m3.Renw_Age_Total_Est_Tax_and_Fees__c);
 										m.put('Opt3_Renw_Age_Total_Monthly_Premium__c', m3.Renw_Age_Total_Monthly_Premium__c);

										m.put('Opt3_Renw_Comp_ACA_Fees__c', m3.Renw_Comp_ACA_Fees__c);
										m.put('Opt3_Renw_Comp_Gross_Premium__c', m3.Renw_Comp_Gross_Premium__c);
										m.put('Opt3_Renw_Comp_Total_Est_Tax_and_Fees__c', m3.Renw_Comp_Total_Est_Tax_and_Fees__c);
										m.put('Opt3_Renw_Comp_Total_Monthly_Premium__c', m3.Renw_Comp_Total_Monthly_Premium__c);
										m.put('Opt3_Age_Total_Child_Rate__c', m3.Age_Total_Child_Rate__c);
										m.put('Opt3_Age_Total_Employee_Rate__c', m3.Age_Total_Employee_Rate__c);

										m.put('Opt3_Age_Total_Spouse_Rate__c', m3.Age_Total_Spouse_Rate__c);
										m.put('Opt3_Comp_Total_Child_Rate__c', m3.Comp_Total_Child_Rate__c);
										m.put('Opt3_Comp_Total_Employee_Rate__c', m3.Comp_Total_Employee_Rate__c);
										m.put('Opt3_Comp_Total_Spouse_Rate__c', m3.Comp_Total_Spouse_Rate__c);

										mbToUpdate.add(m);

									}
							}
						}
					}
				}

				
				

				/* update Member benefits */
			}

			opptyCompositeRateModel.opptyPlanRates = RenewalPlansToUpdate;
			opptyCompositeRateModel.memberRates = mbToUpdate;
		}
		catch (Exception ex) {
             CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_URE_OpptyCompAndAgeRatingUtility', null, 'SGR_URE_OpptyCompAndAgeRatingUtility.ComputeOptionPlansForRenewingPlans', 'High');
			 throw ex;
        }    

		return opptyCompositeRateModel;

	}

	public static void InsertURECalloutAudit(List<Opportunity> opptyList, Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opptyCalloutInfoMap) {
		/*EventAuditTrail__c audit; 
		List<EventAuditTrail__c> auditList = new List<EventAuditTrail__c>();

		for(Opportunity oppty :  opptyList) {
			if(opptyCalloutInfoMap.containsKey(oppty.Id)){
				SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo ureInfo = opptyCalloutInfoMap.get(oppty.Id);
				if(ureInfo != null) {
					audit = new EventAuditTrail__c (
						Name = 'URE Rating: ' + oppty.Id,
						Event_Type__c = 'Integration',
						Event_Message__c =  (ureInfo.Success ? 'Success' : 'Fail')  + ': URE Rating for Opportunity Id = ' + oppty.Id,
						Opportunity__c = oppty.Id,
						Integration_Request__c = System.JSON.serialize(ureInfo.ureRequest),
						Integration_Response__c = System.JSON.serialize(ureInfo.ureResponse)
						
					);

					auditList.add(audit);
				}
			}
		}

		insert auditList;*/
	}

	public Static Decimal CheckForNull(Decimal n ) {
		return n == null ? 0 : n;
	}

/* End of public Methods */



/* Private Methods */

	@TestVisible 
	private static Map<Id, SGR_Opportunity_Plan_Rate__c> GetPlanRatesByType(List<Id> PlanIds, List<Id> OpportunityIds, String planType ) {
		Map<Id, SGR_Opportunity_Plan_Rate__c> planMap = new Map<Id, SGR_Opportunity_Plan_Rate__c>();

		List<SGR_Opportunity_Plan_Rate__c> planRates = [
			SELECT Id, Plan__c, Plan__r.Marketing_Plan_Number__c, Renw_Age_Total_Est_Tax_and_Fees__c, Renw_Age_Total_Monthly_Premium__c, 
			Renw_Comp_Total_Est_Tax_and_Fees__c, Renw_Comp_Total_Monthly_Premium__c, Rate_Type_Code__c, ACA_Fee__c, Member_Premium__c, 
				(SELECT Id, Tier_Code__c, Gross_Premium__c, ACA_Fees__c
			  		FROM Opportunity_Plan_Composite_Rate__r
			  	LIMIT 4 )
			FROM SGR_Opportunity_Plan_Rate__c 
			WHERE Plan__c IN :PlanIds AND Opportunity__c IN :OpportunityIds AND Type__c = :planType
			LIMIT 2000
			];

		for(SGR_Opportunity_Plan_Rate__c pr: planRates) {
			if(!planMap.containsKey(pr.Plan__c)) {
				planMap.put(pr.Plan__c, pr);
			}
		}

		return planMap;
	}

	@TestVisible
	private static Map<Id, SGR_Opportunity_Plan_Rate__c> GetOptionPlans(List<Id> Plan_Options, List<Id> OpportunityIds ) {	
		return GetPlanRatesByType(Plan_Options, opportunityIds, SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE );
	}
    
	@TestVisible
	private static Map<Id, List<SGR_Opportunity_Member_Benefits__c>> GetOptionPlanMembers(List<Id> Plan_Option, List<Id> OpportunityIds ) {
		Map<Id, List<SGR_Opportunity_Member_Benefits__c>> membersMap = new Map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
		List<SGR_Opportunity_Member_Benefits__c> members = [
			SELECT 	Id,Opportunity__c, Opportunity_Plan_Rate__c, Opportunity_Plan_Rate__r.Plan__c, Relationship_Code__c, Member_Policy_Tier__c, 
					Opportunity_Census__c, Opportunity_Census__r.Subscriber_Number__c,Renw_Age_ACA_Fees__c,Renw_Age_Gross_Premium__c,
					Renw_Age_Net_Of_ACA_Fees__c,Renw_Age_Non_ACA_Fees__c, Renw_Age_Total_Est_Tax_and_Fees__c,
					Renw_Age_Total_Monthly_Premium__c, Renw_Comp_ACA_Fees__c,Renw_Comp_Gross_Premium__c,Renw_Comp_Total_Est_Tax_and_Fees__c,Renw_Comp_Total_Monthly_Premium__c,
					Opportunity_Census__r.Date_of_Birth__c, Opportunity_Census__r.Age__c, Opportunity_Census__r.Age_New__c, Opportunity_Census__r.Member_Name__c,
					Age_Total_Child_Rate__c,Age_Total_Employee_Rate__c,Age_Total_Spouse_Rate__c, Comp_Total_Child_Rate__c,Comp_Total_Employee_Rate__c, Comp_Total_Spouse_Rate__c

			FROM SGR_Opportunity_Member_Benefits__c 
			WHERE Opportunity_Plan_Rate__r.Plan__c IN :Plan_Option AND Opportunity__c IN :OpportunityIds AND Opportunity_Plan_Rate__r.Type__c = :SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE
			LIMIT 2000
			];
       

		List<SGR_Opportunity_Member_Benefits__c> mbList;
		for(SGR_Opportunity_Member_Benefits__c mb: members) {
			if(!membersMap.containsKey(mb.Opportunity_Plan_Rate__r.Plan__c)) {
				mbList = new List<SGR_Opportunity_Member_Benefits__c>();
				mbList.add(mb);
				membersMap.put(mb.Opportunity_Plan_Rate__r.Plan__c, mbList);
			}
			else {
				membersMap.get(mb.Opportunity_Plan_Rate__r.Plan__c).add(mb);
			}
		}

		return membersMap;
	}

	 
	@TestVisible
	private static URERateModel GetPlanCompAndAgeRateResultMapByPlanId(List<SGR_URE_GetRatingsResponse> ureResponse) {
		Map<String, SGR_URE_GetRatingsResponse.URE_Rate> resultRateMap = new Map<String, SGR_URE_GetRatingsResponse.URE_Rate>();
		Map<String, List<SGR_URE_GetRatingsResponse.URE_CompositeRate>> resultCompMap = new Map<String, List<SGR_URE_GetRatingsResponse.URE_CompositeRate>>();
		URERateModel rateModel = new URERateModel();
		List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult> ratingPackageResultList = new List<SGR_URE_GetRatingsResponse.URE_RatingPackageResult>();

		for(SGR_URE_GetRatingsResponse response : ureResponse){
			if(response.rffResult != null) {
				if(response.rffResult.marketingDentalRatesSpecificTaskResult != null && 
					response.rffResult.marketingDentalRatesSpecificTaskResult.ratingPackageResults != null){
					ratingPackageResultList.addAll(response.rffResult.marketingDentalRatesSpecificTaskResult.ratingPackageResults);
				}
				if(response.rffResult.marketingRatesSpecificTaskResult != null && 
					response.rffResult.marketingRatesSpecificTaskResult.ratingPackageResults != null){
					ratingPackageResultList.addAll(response.rffResult.marketingRatesSpecificTaskResult.ratingPackageResults);
				}

				if(response.rffResult.marketingRatesSpecificTaskResult != null){
					for(SGR_URE_GetRatingsResponse.URE_RatingPackageResult packageResult : ratingPackageResultList)
					{
						for(SGR_URE_GetRatingsResponse.URE_ProductResult productResult : packageResult.productResults) {
							for(SGR_URE_GetRatingsResponse.URE_PlanRateResult planResult : productResult.planResults) {
								if(!resultCompMap.containsKey(planResult.planId)){
									resultCompMap.put(planResult.planId, planResult.compositeRateResults);
								}
								for(SGR_URE_GetRatingsResponse.URE_AreaRateResult areaRateResult : planResult.areaResults) {
									for(SGR_URE_GetRatingsResponse.URE_Rate rate : areaRateResult.rates) {
										if(!resultRateMap.containsKey(planResult.planId + '_' + rate.censusDetailId)){
												resultRateMap.put(planResult.planId + '_' + rate.censusDetailId, rate);
										}
									}
								}
							}
						}
					}
				}
			}
		}


		rateModel.compositeRateMap  = resultCompMap;
		rateModel.ureRateMap  = resultRateMap;

		return rateModel;
	}

	@TestVisible
	private static Map<String, MemberModelByPlan> GetMembersByPlanRate(Set<Id> OpptyPlanRateIdList, List<Id> planIds, list<Id> opportunityIds, string planType) {
		String type = SGR_URE_RatingOption.RENEWING_PLAN_TYPE;
		Boolean isCensusForAlternate = planType ==  SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE;
		String defaultWhere = planType ==  SGR_URE_RatingOption.ALTERNATE_PLAN_TYPE ? 
					/*' Opportunity_Plan_Rate__r.Plan__c IN :planIds AND Opportunity__c IN :opportunityIds AND Opportunity_Plan_Rate__r.Type__c = :type ' : */
					' AND Opportunity_Plan_Rate__c != null AND Opportunity__c IN :opportunityIds AND Opportunity_Plan_Rate__r.Type__c = :type ' :
					' AND Opportunity_Plan_Rate__c IN :OpptyPlanRateIdList AND  Opportunity_Plan_Rate__r.Type__c = :type ';

		String query =	'SELECT 	Id, Opportunity_Plan_Rate__r.Plan__r.Line_Of_Business__c, Opportunity_Plan_Rate__c, ACA_Fee__c, Member_Rate__c, ' + 
						'		    Relationship_Code__c, Member_Policy_Tier__c, Opportunity_Census__c, Subscriber_Number__c, Rate_Type__c, ' + 
						'			Opportunity_Census__r.Subscriber_Number__c, Opportunity_Census__r.Membership_Number__c, Opportunity_Census__r.Member_name__c, ' + 
						'			Opportunity_Census__r.Date_of_Birth__c, Opportunity_Census__r.Age__c, Opportunity_Census__r.Age_New__c ' +
						'FROM SGR_Opportunity_Member_Benefits__c  ' +
						'WHERE Opportunity_Plan_Rate__c != null AND Relationship_Code__c != null  {0} '   +
						'LIMIT 2000 ';   


		query = String.format(query, new String[] {defaultWhere});

		System.debug('GetMembersByPlanRate:: - query /' + planType + ' - ' + query);

		List<SGR_Opportunity_Member_Benefits__c> members = Database.query(query);

		Map<String, MemberModelByPlan> membersByPlanMap = new Map<String, MemberModelByPlan>();
		MemberModelByPlan memberList; 
		if(isCensusForAlternate) 
		{
			String mapKey = '';
			for(SGR_Opportunity_Member_Benefits__c m: members){
				mapKey = m.Opportunity_Plan_Rate__r.Plan__r.Line_Of_Business__c;
				if(!membersByPlanMap.containsKey(mapKey)) {
					memberList = new MemberModelByPlan();
					memberList.AddMember(m);
					membersByPlanMap.put(mapKey, memberList); 
				}
				else {
					membersByPlanMap.get(mapKey).AddMember(m);
				}
			}

		}
		else {
			for(SGR_Opportunity_Member_Benefits__c m: members){
				if(!membersByPlanMap.containsKey(m.Opportunity_Plan_Rate__c)) {
					memberList = new MemberModelByPlan();
					memberList.AddMember(m);
					membersByPlanMap.put(m.Opportunity_Plan_Rate__c, memberList); 
				}
				else {
					membersByPlanMap.get(m.Opportunity_Plan_Rate__c).AddMember(m);
				}
			}
		}

		return membersByPlanMap;
	}

	private static List<SGR_URE_GetRatingsResponse.URE_TierRate> getTierRate(List<SGR_URE_GetRatingsResponse.URE_CompositeRate> compositeRates) {
		List<SGR_URE_GetRatingsResponse.URE_TierRate> result = new List<SGR_URE_GetRatingsResponse.URE_TierRate>();

		for(SGR_URE_GetRatingsResponse.URE_CompositeRate cr : compositeRates){
			for(SGR_URE_GetRatingsResponse.URE_TierResult tr : cr.tierResult) {
				result = tr.tierRate;
			}
		}
		return result;
	}


	global class OpportunityCompositeRateModel {
		public List<SGR_Opportunity_Plan_Composite_Rate__c> opptyPlanCompositeRates { get; set;}
		public List<SGR_Opportunity_Plan_Rate__c>  opptyPlanRates {get; set;}
		public List<SGR_Opportunity_Member_Benefits__c> memberRates { get; set;}
		public List<Opportunity> opptyToUpdateList {get; set;}
	}

	global class MemberModelByPlan {
		private List<SGR_Opportunity_Member_Benefits__c> members = new List<SGR_Opportunity_Member_Benefits__c>(); 
		private List<SGR_Opportunity_Member_Benefits__c> subscriberMembers = new List<SGR_Opportunity_Member_Benefits__c>(); 
		private Integer ES_Count {get; set;}
		private Integer EO_Count {get; set;}
		private Integer EC_Count {get; set;}
		private Integer EF_Count {get; set;}

		public MemberModelByPlan() {
			ES_Count = 0;
			EO_Count = 0;
			EC_Count = 0;
			EF_Count = 0;
		}

		public void AddMember(SGR_Opportunity_Member_Benefits__c member){

			if(String.isEmpty(member.Opportunity_Census__c)) return; 

			members.add(member);
			String tier = member.Member_Policy_Tier__c;
			if(tier == SGR_URE_RatingOption.TIER_ES)
				ES_Count++;
			else if(tier == SGR_URE_RatingOption.TIER_EO){
				EO_Count++;
			}
			else if(tier == SGR_URE_RatingOption.TIER_EC){
				EC_Count++;
			}
			else if(tier == SGR_URE_RatingOption.TIER_EF){
				EF_Count++;
			}

			if(member.Relationship_Code__c == SGR_URE_RatingOption.SUBSCRIBER) {
				subscriberMembers.add(member);
			}
			
		}

		public List<SGR_Opportunity_Member_Benefits__c> getAllMembers() {
			return members;
		}

		public List<SGR_Opportunity_Member_Benefits__c> getSubscriberMembers() {
			return subscriberMembers;
		}

		public Integer getCountByTier(String tier){
			if(tier == SGR_URE_RatingOption.TIER_ES)
				return ES_Count;
			else if(tier == SGR_URE_RatingOption.TIER_EO){
				return EO_Count;
			}
			else if(tier == SGR_URE_RatingOption.TIER_EC){
				return EC_Count;
			}
			else if(tier == SGR_URE_RatingOption.TIER_EF){
				return EF_Count;
			}

			return 0; 
		}

	}

	global class URERateModel {
		public Map<String, List<SGR_URE_GetRatingsResponse.URE_CompositeRate>>  compositeRateMap {get; set;}
		public Map<String, SGR_URE_GetRatingsResponse.URE_Rate>  ureRateMap {get; set;}
	}

	global class TotalsBySubscriber {
		public Decimal 	Renw_Age_Total_Monthly_Premium  = 0;	
		public Decimal 	Renw_Age_Total_Est_Tax_and_Fees = 0;
		public Decimal 	Current_Age_Total_Monthly_Premium = 0;	
		public Decimal 	Current_Age_Total_Est_Tax_and_Fees = 0;
	}
	
	global class OpptyRenewPlanRateSummaryTotals {
		public Decimal 	Total_Medical_Monthly_Premium = 0;	
		public Decimal 	Total_Dental_Monthly_Premium = 0;
		public Decimal 	Total_Vision_Monthly_Premium = 0;	
		public Decimal 	Total_Est_Medical_Insurer_Fees = 0;
		public Decimal 	Total_Est_Dental_Insurer_Fees = 0;
		public Decimal 	Total_Est_Vision_Insurer_Fees = 0;
		public Decimal  Total_Monthly_Premium {get { return Total_Medical_Monthly_Premium + 
		                                                    Total_Vision_Monthly_Premium + 
		                                                    Total_Dental_Monthly_Premium; }}
		                                                  
		public Decimal  Total_Est_Tax_and_Fees {get { return Total_Est_Medical_Insurer_Fees + 
		                                                    Total_Est_Dental_Insurer_Fees + 
		                                                    Total_Est_Vision_Insurer_Fees; }}
	}

	global class URECalloutInfo {
		public SGR_URE_GetRatingsResponse ureResponse {get; set;}
		public SGR_URE_GetAgeRatesRequestWrapper ureRequest {get; set;}
		public Boolean Success {get; set;}

		public URECalloutInfo() {
			this.ureResponse = new SGR_URE_GetRatingsResponse();
			this.ureRequest = new SGR_URE_GetAgeRatesRequestWrapper();
			this.Success = false;
		}
	}



}