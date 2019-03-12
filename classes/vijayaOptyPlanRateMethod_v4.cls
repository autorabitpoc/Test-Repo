public with sharing class vijayaOptyPlanRateMethod_v4 {
	Public static void insertOpportunitiesPlanRate(set<id> accIDs, List<Opportunity> optyList){
        
        set<Id> oppIdSet=new set<Id>();
        Set<String> fipsCodes = new Set<String>();
        Set<String>marketingPlanIdsSet=new Set<String>();
        if(optyList.size()> 0){
            for(Opportunity opty : optyList){
                oppIdSet.add(opty.id);
                fipsCodes.add(opty.FIPS_Code__c);
            }
            //--Vijaya-- Getting FIPS code to create Alternative plan rates - Start
            List<SGR_Plan_FIPS_Map__c> fipsPlans = [Select Id, Effective_Date__c, FIPS_Code__c, Plan__c, Plan__r.Marketing_Sales_Plan_ID__c,plan__r.Marketing_Plan_Number__c,  Plan__r.Plan_Sales_ID__c from SGR_Plan_FIPS_Map__c where FIPS_Code__c IN : fipsCodes AND Division__c = :optyList[0].HCSC_division__c];
            
            Map<ID, List<SGR_Plan_FIPS_Map__c>> fipPlansMap = new Map<ID, List<SGR_Plan_FIPS_Map__c>>();
            for(Opportunity opty : optyList){
                List<SGR_Plan_FIPS_Map__c> effectiveFipsPlans = new List<SGR_Plan_FIPS_Map__c>();
                for(SGR_Plan_FIPS_Map__c fipsPlan : fipsPlans){
                    if(fipsPlan.Effective_Date__c == opty.Renewal_Date__c && fipsPlan.FIPS_Code__c == opty.FIPS_Code__c){
                        effectiveFipsPlans.add(fipsPlan);
                    }
                }
                fipPlansMap.put(opty.Id, effectiveFipsPlans);
                
            }
            system.debug('+++fipPlansMap--' + fipPlansMap);     
            //--Vijaya-- Getting FIPS code to create Alternative plan rates - End
            List<SGR_Opportunity_Plan_Rate__c> opBenList = new List<SGR_Opportunity_Plan_Rate__c>();
            
            Map<id, List<SGR_Account_Plan_Rate__c>> accIdAllPlanRatesMap = new Map<id, List<SGR_Account_Plan_Rate__c>>();
            Map<String,Id> OppGSmap= new Map<String,Id>();
            //SFDC-14982:Added Group_SectionLK_Key__r.Name to the Query
            //Change on SOQL as a part of Integration e2e Testing : Mei Chen - Start
            List<Account> accs2 = [select Id, ShippingPostalCode, (select id,name,AccountLK_Key__c,Benefit_Agreement__r.Status__c,Acc_Plan_Rate_External_Id__c,Funding_Type__c,Group_Number__c,Benefit_Agreement_Cancel_Date__c,
                                                                   Benefit_Agreement_Effective_Date__c,Benefit_Agreement_End_Date__c,Benefit_Agreement_Number__c,Benefit_Agreement_Renewal_Date__c,
                                                                   Cancel_Code__c,Corporate_Product_Name__c,Corporate_Product_Number__c,Group_Name__c,Group_SectionLK_Key__c,Tier_Aggregate_Seq__c,
                                                                   Group_SectionLK_Key__r.Name,Group_Section_Cancel_Date__c,Group_Section_Number__c,Group_Section_Original_Effective_Date__c, ACA_Fee__c,
                                                                   Group_Section_Renewal_Date__c,isInvitro__c,Marketing_Plan_ID__c,isMaternity__c,Member_Rate__c,Rate_Effective_Date__c,Group_Account__c,
                                                                   Sales_Plan_ID__c,Tier_Agreement_Sequence_Number__c,Benefit_Agreement__r.name,Tier_Number__c,Member_Premium__c,Health_Rating_Area_Number__c,Plan__r.Name, Rate_Type_Code__c, Plan__c,plan__r.id,plan__r.Marketing_Plan_Number__c, Benefit_Agreement_Rate_Effective_Date__c
                                                                   From SGR_Plan_Rates_Account__r) from Account where Id In : accIDs];        
            //Change on SOQL as a part of Integration e2e Testing : Mei Chen - End
            
            //TO DO:::: Merge 4 composite rates and put into opportunity plan composite rate. need to be done here
            //SFDC-14982:For Getting Group_Section__c value to opportunity GS--Start
            List<SGR_Opportunity_Group_Section__c> OPPGSList = [SELECT Id, Name,Group_Name__c, Opportunity__r.accountID FROM SGR_Opportunity_Group_Section__c where Opportunity__c IN:oppIdSet] ;
            
            for(SGR_Opportunity_Group_Section__c OppGS :OPPGSList )
            {
                OppGSmap.put(OppGS.Name.toUpperCase()+OppGS.Opportunity__r.accountID, OppGS.id);
            }
            Map<id, Map<String, List<SGR_Account_Plan_Rate__c>>> accPlanRateMap = new Map<id,Map<String, List<SGR_Account_Plan_Rate__c>>>();
            Map<Id, List<SGR_Account_Plan_Rate__c>> accPRLst = new Map<Id, List<SGR_Account_Plan_Rate__c>>();
            //Member Premium logic for composite Plan Rates
            Map<String, Map<decimal, decimal>> memberPremiumMap = new Map<String, Map<decimal, decimal>>();
            //For generating the Map per Plan Id          
            for(Account a:accs2){
                Map<String, List<SGR_Account_Plan_Rate__c>> planRatesMap = new Map<String, List<SGR_Account_Plan_Rate__c>>(); 
                for(SGR_Account_Plan_Rate__c planRate : a.SGR_Plan_Rates_Account__r){                    
                    if(planRate != null){
                        if(memberPremiumMap.containsKey(planRate.Marketing_Plan_ID__c)){
                    		memberPremiumMap.get(planRate.Marketing_Plan_ID__c).put(planRate.Tier_Aggregate_Seq__c, planRate.Member_Premium__c);
                            
                    	}
                        else{
                        	Map<decimal, decimal> premiums = new Map<decimal, decimal>();
                        	premiums.put(planRate.Tier_Aggregate_Seq__c, planRate.Member_Premium__c);
                        	memberPremiumMap.put(planRate.Marketing_Plan_ID__c, premiums);
                        }
                        if(planRatesMap.get(planRate.Marketing_Plan_ID__c) == null){//c
                            List<SGR_Account_Plan_Rate__c> planRateEmptyLst = new List<SGR_Account_Plan_Rate__c>();
                            planRateEmptyLst.add(planRate);
                            String planId = planRate.Marketing_Plan_ID__c;//c
                            if(planId != null && planId != '')//c
                                planRatesMap.put(planRate.Marketing_Plan_ID__c, planRateEmptyLst);//c
                        }    
                        else{
                            
                            if(planRatesMap.get(planRate.Marketing_Plan_ID__c).size() > 0){//c
                                continue;
                            }
                            else{                    
                                List<SGR_Account_Plan_Rate__c> planRateLst = planRatesMap.get(planRate.Marketing_Plan_ID__c);//c
                                planRateLst.add(planRate);
                                planRatesMap.put(planRate.Marketing_Plan_ID__c, planRateLst);//c
                            }    
                        }                                         
                        system.debug('+++planRatesMap--' + planRatesMap);
                        accPlanRateMap.put(a.Id, planRatesMap);
                        marketingPlanIdsSet=planRatesMap.keySet();                        
                    }
                }
            }
            for(string key : memberPremiumMap.keyset()){
                system.debug('+++planId--' + key);
                system.debug('+++member premium--' + memberPremiumMap.get(key));
            }
            system.debug('+++accPlanRateMap--' + accPlanRateMap);
            
            system.debug('marketingPlanIdsSet::'+marketingPlanIdsSet);
            
            //SFDC-14982:For Getting Group_Section__c value to opportunity GS--End      
            List<SGR_Account_Plan_Rate__c> aprList = new List<SGR_Account_Plan_Rate__c>();        
            for(Account a:accs2 )
            {
                if(accIdAllPlanRatesMap.get(a.id)==Null){
                    accIdAllPlanRatesMap.put(a.ID,new List<SGR_Account_Plan_Rate__c>{});
                }
                
                if(accIdAllPlanRatesMap.get(a.id)!=Null){
                    accIdAllPlanRatesMap.get(a.id).addall(a.Plan_Rates_Account__r);
                    // SFDC-16508 Changes - Start
                    aprList.addAll(a.Plan_Rates_Account__r);
                }
            }
            
            
            // Iterate through SGR Account Plan rate records and collect associated plan information
            Map<String, Plan__c> marketingPlanIdPlanMap = new Map<String, Plan__c>();
            
            // Query the corresponding plan information
            //List<Plan__c> plans = [Select Id, Name, Marketing_Sales_Plan_ID__c,Expiry_Date__c from Plan__c where Name in :marketingPlanIds];
            List<Plan__c> plans = [Select Id, Name, Marketing_Sales_Plan_ID__c,Line_Of_Business__c, Marketing_Plan_Number__c,Expiry_Date__c from Plan__c where Marketing_Plan_Number__c in :marketingPlanIdsSet];//marketingPlanIds];
            System.debug('Matching Plans:: ' + plans);
            if (null != plans || !plans.isEmpty()) {
                for (Plan__c p: plans) {
                    //marketingPlanIdPlanMap.put(p.Name, p);
                    marketingPlanIdPlanMap.put(p.Marketing_Plan_Number__c, p);
                }
            }
            // SFDC-16508 Changes - End
            
            for(Opportunity op : optyList ){
                
                if(!accIdAllPlanRatesMap.isEmpty())
                    system.debug('***Map****'+accIdAllPlanRatesMap);
                //Vijaya - Alternate Plan Rate creation logic - START
                if(fipPlansMap.containsKey(op.Id)){
                    for(SGR_Plan_FIPS_Map__c fip : fipPlansMap.get(op.Id)){
                        SGR_Opportunity_Plan_Rate__c altPlanRate = createAlternateOptyPlanRate(op.Id, 'Alternate', fip.Plan__c);
                        altPlanRate.Marketing_Plan_ID__c = fip.plan__r.Marketing_Plan_Number__c;
                        altPlanRate.Sales_Plan_ID__c = fip.Plan__r.Plan_Sales_ID__c;
                        opBenList.add(altPlanRate);
                    }
                }
                //Vijaya - Alternate Plan Rate creation logic - END
                //list<SGR_Account_Plan_Rate__c> blist = accIdAllPlanRatesMap.get(op.accountID);
                
                //Tarun 01/02/2019 : Added below line as a part of E2E Fixes
                /*list<SGR_Opportunity_Benefit_Agreement__c> opBenListFrmMap=opBenMap.get(op.id);
                Map<string,SGR_Opportunity_Benefit_Agreement__c> benMap = new Map<string,SGR_Opportunity_Benefit_Agreement__c>();
                if(opBenListFrmMap != NULL)
                for(SGR_Opportunity_Benefit_Agreement__c opB:opBenListFrmMap){
                    benMap.put(opB.name,opB);
                }*/
                Map<String, List<SGR_Account_Plan_Rate__c>> planRatesMap = accPlanRateMap.get(op.accountID);        
                if(planRatesMap != null){
                    
                    for(String planId : planRatesMap.keySet()){
                        
                        list<SGR_Account_Plan_Rate__c> blist = planRatesMap.get(planId);
                        
                        if(blist!=null && blist.size()>0){
                            for(SGR_Account_Plan_Rate__c accPlanRate:blist){
                                
                                //Added Field - 15079
                                //opplanrate.Health_Rating_Area_Number__c = c.Health_Rating_Area_Number__c;
                                //SFDC-14982:Modified the Group_Section__c value to opportunity GS
                                //for creating 'current' Opportunity Plan Rate
                                SGR_Opportunity_Plan_Rate__c opplanrateCurrent;
                                
                                if(planRatesMap.containsKey(accPlanRate.Marketing_Plan_ID__c) && planRatesMap.get(accPlanRate.Marketing_Plan_ID__c).size() > 0)//c
                                     //Tarun 01/02/2019 : Added parameter to method calling as a part of E2E Fixes
                                     if(accPlanRate.Benefit_Agreement__r.Status__c == 'Active') // Only for Active Benefit Agreements
                                    //opplanrateCurrent =  createOptyPlanRate(accPlanRate, 'Current', op.Id,op.Renewal_Date__c, marketingPlanIdPlanMap,benMap);
                                
                                if(OppGSmap!=null && !OppGSmap.isEmpty()){
                                    if(accPlanRate.Group_SectionLK_Key__r.Name!=null){
                                        if(OppGSmap.containsKey(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID))
                                        {
                                            opplanrateCurrent.Group_Section__c = OppGSmap.get(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID);
                                        }
                                    } 
                                }
                                // SFDC-16508 Changes - Start
                                // Set plan look up field 
                                
                                //String key = accPlanRate.Plan__r.Name;
                                String key = accPlanRate.Marketing_Plan_ID__c;//c
                                Plan__c p = (Plan__c) marketingPlanIdPlanMap.get(key);
                                //opplanrateCurrent.Plan__c = (marketingPlanIdPlanMap!=null && null != p) ? p.Id : null;
                                
                                //for creating 'Renewal' Opportunity Plan Rate
                                SGR_Opportunity_Plan_Rate__c opplanrateRenewal;
                                if(planRatesMap.containsKey(accPlanRate.Marketing_Plan_ID__c) && planRatesMap.get(accPlanRate.Marketing_Plan_ID__c).size() > 0)//c
                                   //Tarun 01/02/2019 : Added parameter to method calling as a part of E2E Fixes
                                    if(accPlanRate.Benefit_Agreement__r.Status__c == 'Active') // Only for Active Benefit Agreements
                                    //opplanrateRenewal =  createOptyPlanRate(accPlanRate, 'Renewal', op.Id,op.Renewal_Date__c, marketingPlanIdPlanMap,benMap);
                                if(OppGSmap!=null && !OppGSmap.isEmpty()){
                                    if(accPlanRate.Group_SectionLK_Key__r.Name!=null){
                                        if(OppGSmap.containsKey(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID))
                                        {
                                            opplanrateRenewal.Group_Section__c = OppGSmap.get(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID);
                                        }
                                    } 
                                }
                                // SFDC-16508 Changes - Start
                                // Set plan look up field 
                                
                                key = accPlanRate.Marketing_Plan_ID__c;//c
                                p = (Plan__c) marketingPlanIdPlanMap.get(key);
                                //opplanrateRenewal.Plan__c = (marketingPlanIdPlanMap!=null && null != p) ? p.Id : null;
                                
                                
                                // SFDC-16508 Changes - End
                                opBenList.add(opplanrateCurrent);
                                opBenList.add(opplanrateRenewal);
                            }
                        }
                    }
                }
            }
            
            if(!opBenList.isEmpty()){
                try{
                    
                    Database.SaveResult[] result= database.insert(opBenList,false);
                    list<String> errMsgsList=new list<String>();
                    Set<ID> optyPlanRateIDs = new Set<ID>();
                    for(Database.SaveResult sr : result){
                        if (!sr.isSuccess()) {
                            for(Database.Error err : sr.getErrors()) {
                                errMsgsList.add(err.getMessage());
                            }
                            //createErroLog(errMsgsList,bidErr);
                        }
                        else{
                            optyPlanRateIDs.add(sr.getId());
                        }
                    }
                    system.debug('+++optyPlanRateIDs.size()--'+optyPlanRateIDs.size()+errMsgsList);
                    
                }
                catch(exception e){
                    system.debug('Exception Occured'+e);
                }
            }
        }
	}
    @TestVisible  private Static SGR_Opportunity_Plan_Rate__c createAlternateOptyPlanRate(String optyId, String type, String planId){
        SGR_Opportunity_Plan_Rate__c oppPlanRate = new SGR_Opportunity_Plan_Rate__c();
        oppPlanRate.Name = 'Alternate Plan';
        oppPlanRate.Opportunity__c = optyId;
        oppPlanRate.Plan__c = planId;
        oppPlanRate.Type__c = type;
        return oppPlanRate;
    }
    @TestVisible private Static SGR_Opportunity_Plan_Rate__c createOptyPlanRate(SGR_Account_Plan_Rate__c accPlanRate, String type, String optyId,date opRenDate, Map<String, Plan__c> marketingPlanIdPlanMap,Map<String,SGR_Opportunity_Benefit_Agreement__c> opBenAgrNameBenAgrMap){
        SGR_Opportunity_Plan_Rate__c oppPlanrate;
        if(accPlanRate != null){
            oppPlanrate = new SGR_Opportunity_Plan_Rate__c();
            oppPlanrate.name=accPlanRate.name;
            oppPlanrate.Plan_Name__c=accPlanRate.Plan__r.Name;
            
            // Urgent fixes - Offshore - 20-Jan - Start
            //   if (null != marketingPlanIdPlanMap && null != accPlanRate.Plan__r.Marketing_Plan_Number__c && null != marketingPlanIdPlanMap.get(accPlanRate.Plan__r.Marketing_Plan_Number__c)) {
            //oppPlanrate.Plan__c=marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c)!=null? marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c).id : null;//Plan__r.Marketing_Plan_Number__c).Id;
            // }
            
            //system.debug('+++plan Id ---'+accPlanRate.Plan__r.Id);
            //oppPlanrate.Plan__c=accPlanRate.Plan__r.Id;
            //oppPlanrate.Plan__c=accPlanRate.Marketing_Plan_ID__c;
            // Urgent fixes - Offshore - 20-Jan - End
            System.debug('marketingPlanIdPlanMap;;;'+marketingPlanIdPlanMap);
            oppPlanRate.Opportunity__c = optyId;
            oppPlanRate.Account__c = accPlanRate.Group_Account__c;//AccountLK_Key__c;
            oppPlanRate.Acc_Plan_External_Id__c= accPlanRate.Acc_Plan_Rate_External_Id__c;
            oppPlanRate.Funding_Type__c = accPlanRate.Funding_Type__c;
            oppPlanRate.Group_Number__c= accPlanRate.Group_Number__c;
            oppPlanRate.Benefit_Agreement_Cancel_Date__c = accPlanRate.Benefit_Agreement_Cancel_Date__c;
            // Urgent fixes - 20-Jan
            oppPlanRate.Benefit_Agreement_Effective_Date__c= accPlanRate.Benefit_Agreement_Rate_Effective_Date__c;
            //oppPlanRate.Benefit_Agreement_Effective_Date__c= accPlanRate.Benefit_Agreement_Rate_Effective_Date__c; TODO: Change to BA lookup once Maha confirms
            // Urgent fixes - 20-Jan
            oppPlanRate.Benefit_Agreement_End_Date__c = accPlanRate.Benefit_Agreement_End_Date__c;
            oppPlanRate.Benefit_Agreement_Number__c= accPlanRate.Benefit_Agreement_Number__c;
            oppPlanRate.Benefit_Agreement_Renewal_Date__c= accPlanRate.Benefit_Agreement_Renewal_Date__c;
            oppPlanRate.Cancel_Code__c= accPlanRate.Cancel_Code__c;
            oppPlanRate.Corporate_Product_Name__c = accPlanRate.Corporate_Product_Name__c;
            oppPlanRate.Corporate_Product_Number__c= accPlanRate.Corporate_Product_Number__c;
            //oppPlanRate.Coverage_Type__c= accPlanRate.Coverage_Type__c;
            oppPlanRate.Group_Name__c= accPlanRate.Group_Name__c;
            oppPlanRate.Type__c = type;
            oppPlanRate.Health_Rating_Area_Number__c = accPlanRate.Health_Rating_Area_Number__c;
            oppPlanRate.Group_Section_Cancel_Date__c=accPlanRate.Group_Section_Cancel_Date__c;
            oppPlanRate.Group_Section_Number__c= accPlanRate.Group_Section_Number__c;
            oppPlanRate.Group_Section_Original_Effective_Date__c = accPlanRate.Group_Section_Original_Effective_Date__c;
            oppPlanRate.Group_Section_Renewal_Date__c = accPlanRate.Group_Section_Renewal_Date__c;
            oppPlanRate.Invitro_TX_only__c= accPlanRate.isInvitro__c;
            oppPlanRate.Marketing_Plan_ID__c= accPlanRate.Marketing_Plan_ID__c;
            
            //SFDC-16508
            oppPlanrate.Plan__c=marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c)!=null? marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c).Id : null;//Plan__r.Marketing_Plan_Number__c).Id;
            system.debug('plan__c::;;'+oppPlanrate.Plan__c);
            oppPlanRate.Maternity__c= accPlanRate.isMaternity__c;
            // oppPlanRate.Member_Rates_or_Composite_Rates__c = accPlanRate.Member_Rate__c;
            oppPlanRate.Rate_Effective_Date__c= accPlanRate.Rate_Effective_Date__c;
            oppPlanRate.Sales_Plan_ID__c= accPlanRate.Sales_Plan_ID__c;
            oppPlanRate.Tier_Agreement_Sequence_Number__c= accPlanRate.Tier_Agreement_Sequence_Number__c;
            oppPlanRate.Tier_Number__c = accPlanRate.Tier_Number__c;
            oppPlanRate.Rate_Type_Code__c = accPlanRate.Rate_Type_Code__c;
            oppPlanRate.ACA_Fee__c = accPlanRate.ACA_Fee__c;
            oppPlanRate.Member_Premium__c = accPlanRate.Member_Premium__c;//added by Cesar/Mei @2/13
            oppPlanRate.Plan_Status__c='Renewing';
            
            //MC - get plan object by the marketing plan id
            Plan__c gspsPlan=marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c);
            system.debug('+++gspsPlan--'+gspsPlan);
             if(gspsPlan!=null){
                oppPlanRate.Coverage_Type__c=gspsPlan.Line_Of_Business__c;
                 system.debug('+++plan Id ---'+gspsPlan.Id);
            }
            if((gspsPlan!=null && gspsPlan.Expiry_Date__c < opRenDate)
               || (!accPlanRate.Benefit_Agreement__r.Status__c.equalsignorecase('Active'))){
                oppPlanRate.Plan_Status__c='Cancelled';
               
            }
             oppPlanRate.Member_Premium__c = accPlanRate.Member_Premium__c;
             //Tarun 01/02/2019 : Added logic as a part of E2E Fixes start here
            if(opBenAgrNameBenAgrMap!=NULL && accPlanRate.Benefit_Agreement__r != NULL && opBenAgrNameBenAgrMap.get(accPlanRate.Benefit_Agreement__r.name)!= NULL){
                   oppPlanRate.Opportunity_Benefit_Agreement__c = opBenAgrNameBenAgrMap.get(accPlanRate.Benefit_Agreement__r.name).id;
            }
             //Tarun 01/02/2019 : Added logic as a part of E2E Fixes end here
            

           // system.debug('+++plan Id ---'+accPlanRate.Plan__r.Id);
        }
        
        return oppPlanrate;
    }
    /*public static void insertOptyPlanCompRate(Set<ID> planRateIDs){
        List<SGR_Opportunity_Plan_Rate__c> planRates = [Select Id, Member_Premium__c, ACA_Fee__c from SGR_Opportunity_Plan_Rate__c where ID IN : planRateIDs];
        List<SGR_Opportunity_Plan_Composite_Rate__c> optyCompPlanRates = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
        for(SGR_Opportunity_Plan_Rate__c planRate : planRates){
            
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEO = createCompPlanRate(planRate, 'EO');
            optyCompPlanRates.add(compPlanRateEO);
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateES = createCompPlanRate(planRate, 'ES');
            optyCompPlanRates.add(compPlanRateES);
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEC = createCompPlanRate(planRate, 'EC');
            optyCompPlanRates.add(compPlanRateEC);
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEF = createCompPlanRate(planRate, 'EF');
            optyCompPlanRates.add(compPlanRateEF);
            
        }
        system.debug('+++optyCompPlanRates.size()--'+optyCompPlanRates.size());
        if(optyCompPlanRates.size() > 0)
            insert optyCompPlanRates;
        
    }*/
    public static void insertOptyPlanCompRate(Set<ID> planRateIDs,  List<SGR_Account_Plan_Rate__c> allAccPlRtList){
    	Set<string> mktPlIds = new Set<string>();
    	List<SGR_Opportunity_Plan_Composite_Rate__c> optyCompPlanRates = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
    	Map<string, List<SGR_Opportunity_Plan_Rate__c>> plIdMOpPlRtMap = new Map<string, List<SGR_Opportunity_Plan_Rate__c>>();
    	List<SGR_Opportunity_Plan_Rate__c> opPlanRates = [Select Id, Marketing_Plan_ID__c from SGR_Opportunity_Plan_Rate__c where ID IN : planRateIDs];
        for(SGR_Opportunity_Plan_Rate__c opPlRt : opPlanRates){
        	mktPlIds.add(opPlRt.Marketing_Plan_ID__c);
        	for(SGR_Account_Plan_Rate__c accPlRt : allAccPlRtList){
        		if(opPlRt.Type__c == 'Current'){
        			if(accPlRt.Marketing_Plan_ID__c == opPlRt.Marketing_Plan_ID__c){
		        		if(accPlRt.Tier_Aggregate_Seq__c == 1){          
				            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEO = createCompPlanRate(accPlRt, 'EO', opPlRt.Id);
				            optyCompPlanRates.add(compPlanRateEO);
		        		}
		        		else if(accPlRt.Tier_Aggregate_Seq__c == 2){
				            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateES = createCompPlanRate(accPlRt, 'ES', opPlRt.Id);
				            optyCompPlanRates.add(compPlanRateES);
		        		}
		        		else if(accPlRt.Tier_Aggregate_Seq__c == 3){
				            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEC = createCompPlanRate(accPlRt, 'EC', opPlRt.Id);
				            optyCompPlanRates.add(compPlanRateEC);
		        		}else if(accPlRt.Tier_Aggregate_Seq__c == 4){
				            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEF = createCompPlanRate(accPlRt, 'EF', opPlRt.Id);
				            optyCompPlanRates.add(compPlanRateEF); 
		        		} 
		        	}    
	        	}
	        	else{
	        		SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEO = createCompPlanRate(accPlRt, 'EO', opPlRt.Id);
		            optyCompPlanRates.add(compPlanRateEO);
		            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateES = createCompPlanRate(accPlRt, 'ES', opPlRt.Id);
		            optyCompPlanRates.add(compPlanRateES);
		            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEC = createCompPlanRate(accPlRt, 'EC', opPlRt.Id);
		            optyCompPlanRates.add(compPlanRateEC);
		            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEF = createCompPlanRate(accPlRt, 'EF', opPlRt.Id);
		            optyCompPlanRates.add(compPlanRateEF);
	        	}
        	}
        }
        system.debug('+++optyCompPlanRates.size()--'+optyCompPlanRates.size());
        if(optyCompPlanRates.size() > 0)
            insert optyCompPlanRates;        
    }
    /*private static SGR_Opportunity_Plan_Composite_Rate__c createCompPlanRate(SGR_Opportunity_Plan_Rate__c planRate, String tier){
        SGR_Opportunity_Plan_Composite_Rate__c optyCompPlanRate = new SGR_Opportunity_Plan_Composite_Rate__c();
        optyCompPlanRate.Gross_Premium__c = planRate.Member_Premium__c;
        optyCompPlanRate.Name = 'Comp';
        optyCompPlanRate.Opportunity_Plan_Rate__c = planRate.Id;
        optyCompPlanRate.ACA_Fees__c = planRate.ACA_Fee__c;
        optyCompPlanRate.Tier_Code__c = tier;
        return optyCompPlanRate;
    }*/
    private static SGR_Opportunity_Plan_Composite_Rate__c createCompPlanRate(SGR_Account_Plan_Rate__c accPlanRate, String tier, String opPlRtId){
        SGR_Opportunity_Plan_Composite_Rate__c optyCompPlanRate = new SGR_Opportunity_Plan_Composite_Rate__c();
        optyCompPlanRate.Gross_Premium__c = accPlanRate.Member_Premium__c;
        optyCompPlanRate.Name = 'Comp';
        optyCompPlanRate.Opportunity_Plan_Rate__c = opPlRtId;
        optyCompPlanRate.ACA_Fees__c = accPlanRate.ACA_Fee__c;
        optyCompPlanRate.Tier_Code__c = tier;
        return optyCompPlanRate;
    }
}