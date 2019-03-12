public  class SGR_BRValidationCaseManager {
	/* Strategy Pattern */
	public class NameException extends Exception{}
	public static final Map<String,SGR_BRValidationCaseService> strategies;

	static{

        // Populate a List Collection of strategy names e.g., SGR_BRValidationFalloutCaseForUW, etc
        List<String> strategyNames = new List<String>();
		strategyNames.add('SGR_BRValidationFalloutCaseForUW');

        strategies = new Map<String,SGR_BRValidationCaseService>();
        for(String name : strategyNames){
            try{strategies.put(name, (SGR_BRValidationCaseService)Type.forName(name + '_Impl').newInstance());}
            catch(Exception e){continue;} //skip bad name silently
        }
    }

	private SGR_BRValidationCaseService strategy; 

	public SGR_BRValidationCaseManager(string Name) {
		if(!strategies.containsKey(name)) throw new NameException(name);
        strategy = strategies.get(name);
	}

	public void createCases(List<Opportunity> opportunityIdList) {
		strategy.createCases(opportunityIdList);
	}
}