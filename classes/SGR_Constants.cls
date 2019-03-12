/*******************************************************************************
* This class is to capture all the static string values used in SGR code components
* DO NOT prefix SGR to the variables as the class name already has it. This will save lots of apex code characters
* 
* Date              Name                            Description
* ============================================================================================
* 11/02/2018        Phani Kommareddy                Original Version
* 11/03/2018		 Landry Harris					 Added constants
*******************************************************************************/

public class SGR_Constants {
    public static String statusFailed = 'Failed';
    public static String statusPassed = 'Passed';
    public static String statusNA = 'N/A';
    public static String comma =',';
    
    public static Set<String> setSubscriberValues = new Set<String>();
    static {
        setSubscriberValues.add('Subscriber');
        setSubscriberValues.add('SUB');
    }
      
    public static Set<String> setSpouseValues = new Set<String>(); 
    static {
        setSpouseValues.add('Spouse');
        setSpouseValues.add('Domestic Partner');
        setSpouseValues.add('SPS');
        setSpouseValues.add('DP');
    }
    
    public static Id idOppProductionRecTypeID  = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        
}