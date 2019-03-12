/*****************************************************************************************************
	Class Name: SGR_URE_OpptyRatingCalculationManager.cls
	Created By: Cesar Murcia
	Description: Strategy Pattern implementation. Invokes the Interface Implementation of 
	SGR_URE_OpptyRatingCalculationService. It starts the URE opportunity rating post process.
*****************************************************************/
public  class SGR_URE_OpptyRatingCalculationManager {
	/* Strategy Pattern */
	public class NameException extends Exception{}
	public static final Map<String,SGR_URE_OpptyRatingCalculationService> strategies;

	static{

        // Populate a List Collection of strategy names e.g., SGR_BRValidationFalloutCaseForUW, etc
        List<String> strategyNames = new List<String>();
		strategyNames.add('OpptyCompAndAgeRatingCalc');

        strategies = new Map<String,SGR_URE_OpptyRatingCalculationService>();
        for(String name : strategyNames){
            try{strategies.put(name, (SGR_URE_OpptyRatingCalculationService)Type.forName('SGR_URE_' + name + '_Impl').newInstance());}
            catch(Exception e){continue;} //skip bad name silently
        }
    }

	private SGR_URE_OpptyRatingCalculationService strategy; 

	public SGR_URE_OpptyRatingCalculationManager(string Name) {
		if(!strategies.containsKey(name)) throw new NameException(name);
        strategy = strategies.get(name);
	}

	/* calcualte opportunity composite & age rates */
	public void calculateRates(List<Id> opptyIdList, Set<String> PlanIdList, Map<Id, SGR_URE_OpptyCompAndAgeRatingUtility.URECalloutInfo> opptyCalloutInfoMap) {
		strategy.calculateRates(opptyIdList,  planIdList, opptyCalloutInfoMap);
	}

	 
}