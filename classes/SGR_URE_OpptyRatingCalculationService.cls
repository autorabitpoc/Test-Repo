/*****************************************************************
	Class Name: SGR_URE_OpptyRatingCalculationService.cls
	Created By: Cesar Murcia
	Description: Interface to implemment the Strategy Pattern. 
*****************************************************************/
public interface SGR_URE_OpptyRatingCalculationService {
	void calculateRates(List<Id> opptyIdList, Set<String> planIdList, Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opptyCalloutInfoMap);
}