public class SGR_BRValidationManager{
    /* Strategy Pattern */
	public class NameException extends Exception{}
	public static final Map<String,SGR_BRValidationService> strategies;

	static{

        // Populate a List Collection of strategy names e.g., SGR_BRValidationFalloutCaseForUW, etc
        List<String> strategyNames = new List<String>();
		strategyNames.add('SGR_BlueSTAREligibilityRules');

        strategies = new Map<String,SGR_BRValidationService>();
        for(String name : strategyNames){
            try{strategies.put(name, (SGR_BRValidationService)Type.forName(name + '_Impl').newInstance());}
            catch(Exception e){continue;} //skip bad name silently
        }
    }

	private SGR_BRValidationService strategy; 

	public SGR_BRValidationManager(string Name) {
		if(!strategies.containsKey(name)) throw new NameException(name);
        strategy = strategies.get(name);
	}
	
    public Set<Id> validate(Set<Id> oppIds){
        Set<Id> optyIds = strategy.validate(oppIds);
        return optyIds;
    }
}