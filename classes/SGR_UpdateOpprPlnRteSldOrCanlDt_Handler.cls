public class SGR_UpdateOpprPlnRteSldOrCanlDt_Handler{
	
    public static boolean isUpdateFromChildObject = true;
    
	public static void updateSoldOrCancelDate(List<SGR_Opportunity_Group_Section__c> oldRecs, List<SGR_Opportunity_Group_Section__c> newRecs){
        try{
            List<SGR_Opportunity_Plan_Rate__c> plnRateList;
            Map<id,SGR_Opportunity_Group_Section__c> grpSecRecsMap = new Map<id,SGR_Opportunity_Group_Section__c>();
            Map<id,List<SGR_Opportunity_Plan_Rate__c>> plnRateMap = new Map<id,List<SGR_Opportunity_Plan_Rate__c>>();
            for(SGR_Opportunity_Group_Section__c oldRec :oldRecs){
                for(SGR_Opportunity_Group_Section__c newRec :newRecs){
                    if(oldRec.id==newRec.id){
                        system.debug('OldRec'+oldRec.Benefit_Agreement_Cancel_Date__c);
                        system.debug('newRec'+newRec.Benefit_Agreement_Cancel_Date__c);
                        if(oldRec.Benefit_Agreement_Cancel_Date__c!=newRec.Benefit_Agreement_Cancel_Date__c || oldRec.BEN_AGMT_renewal_date__c!=newRec.BEN_AGMT_renewal_date__c){
                            grpSecRecsMap.put(newRec.id,newRec);
                        }
                        break;
                    }					
                    
                }
                
            }
            Set<id> grpSecIdSet = new Set<id>();
            grpSecIdSet = grpSecRecsMap.keySet();
            for(SGR_Opportunity_Plan_Rate__c plnRec :[SELECT id, Name, Canceled_Date_Copy__c, Sold_Date_Copy__c,Group_Section__c FROM SGR_Opportunity_Plan_Rate__c WHERE Group_Section__c IN :grpSecIdSet]){
                plnRec.Canceled_Date_Copy__c = grpSecRecsMap.get(plnRec.Group_Section__c).Benefit_Agreement_Cancel_Date__c;
                plnRec.Sold_Date_Copy__c = grpSecRecsMap.get(plnRec.Group_Section__c).BEN_AGMT_renewal_date__c;
                if(plnRateMap.get(plnRec.Group_Section__c)!=null){
                    plnRateMap.get(plnRec.Group_Section__c).add(plnRec);
                }else{
                    plnRateList = new List<SGR_Opportunity_Plan_Rate__c>();
                    plnRateList.add(plnRec);
                    plnRateMap.put(plnRec.Group_Section__c,plnRateList);
                }
            }
            if(plnRateMap!=null){
                List<SGR_Opportunity_Plan_Rate__c> finalList = new List<SGR_Opportunity_Plan_Rate__c>();
                for(List<SGR_Opportunity_Plan_Rate__c> prList : plnRateMap.values())
                finalList.addAll(prList);
                if(finalList!=null && finalList.size()>0)
                    update finalList;
            }	
    	
        }catch(Exception ex){
        	CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', null, null, 'SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.updateSoldOrCancelDate', 'High');
        }
	}
	
	public static void emptySoldAndCancelDate(List<SGR_Opportunity_Group_Section__c> oldRecs){
		try{
            List<String> recList = new List<String>();
            for(SGR_Opportunity_Group_Section__c rec: oldRecs){
                recList.add(rec.id);
            }
            if(recList!=null && recList.size()>0){
                List<SGR_Opportunity_Plan_Rate__c> planRateList = new List<SGR_Opportunity_Plan_Rate__c>();
                for(SGR_Opportunity_Plan_Rate__c plnRateRec: [SELECT id, Name,Canceled_Date_Copy__c,Sold_Date_Copy__c,Group_Section__c FROM SGR_Opportunity_Plan_Rate__c WHERE Group_Section__c IN :recList]){
                    plnRateRec.Canceled_Date_Copy__c = null;
                    plnRateRec.Sold_Date_Copy__c = null;
                    planRateList.add(plnRateRec);
                }
                if(planRateList!=null && planRateList.size()>0)
                    update planRateList;
            }
		}catch(Exception ex){
        	CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', null, null, 'SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.emptySoldAndCancelDate', 'High');
        }
    	
	}
    
    public static void InsertPlnRateCancelOrSoldDateCopy(List<SGR_Opportunity_Plan_Rate__c> plnRateRecs){
       	try{
        	Map<id,List<SGR_Opportunity_Plan_Rate__c>> plnRateMap = new Map<id,List<SGR_Opportunity_Plan_Rate__c>>();
        	List<id> idList = new List<id>();
            for(SGR_Opportunity_Plan_Rate__c plnRateRec : plnRateRecs){
                if(plnRateMap.get(plnRateRec.Group_Section__c)!=null){
                    plnRateMap.get(plnRateRec.Group_Section__c).add(plnRateRec);
                }else{
                    List<SGR_Opportunity_Plan_Rate__c> rateList = new List<SGR_Opportunity_Plan_Rate__c>();
                    rateList.add(plnRateRec);
                    plnRateMap.put(plnRateRec.Group_Section__c,rateList);
                }
            }
            for(SGR_Opportunity_Group_Section__c opprGrpSec : [SELECT id,Benefit_Agreement_Cancel_Date__c,BEN_AGMT_renewal_date__c FROM SGR_Opportunity_Group_Section__c Where id IN :plnRateMap.keySet()]){
                
                    for(SGR_Opportunity_Plan_Rate__c plnRateRec :plnRateMap.get(opprGrpSec.id)){
                        plnRateRec.Canceled_Date_Copy__c = opprGrpSec.Benefit_Agreement_Cancel_Date__c;
                        plnRateRec.Sold_Date_Copy__c = opprGrpSec.BEN_AGMT_renewal_date__c;
                    }
                
            }
       	}catch(Exception ex){
        	CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', null, null, 'SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.InsertPlnRateCancelOrSoldDateCopy', 'High');
        }          	
               
    }
    
    public static void UpdatePlnRateCancelOrSoldDateCopy(List<SGR_Opportunity_Plan_Rate__c> oldPlnRateRecs,List<SGR_Opportunity_Plan_Rate__c> newPlnRateRecs){
       try{
            for(SGR_Opportunity_Plan_Rate__c oldplnRate : oldPlnRateRecs){
                for(SGR_Opportunity_Plan_Rate__c newplnRate : newPlnRateRecs){
                    if(oldplnRate.Prototype_Canceled_Date__c!=newplnRate.Prototype_Canceled_Date__c)
						newplnRate.Canceled_Date_Copy__c = newplnRate.Prototype_Canceled_Date__c;
                    if(oldplnRate.Sold_Date__c!=newplnRate.Sold_Date__c)
						newplnRate.Sold_Date_Copy__c = newplnRate.Sold_Date__c;
                }
			} 
               
    	}catch(Exception ex){
        	CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', null, null, 'SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.UpdatePlnRateCancelOrSoldDateCopy', 'High');
        } 
    }
}