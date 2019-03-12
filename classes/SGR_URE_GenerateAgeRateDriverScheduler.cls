/**************************************************************************************
  Apex Class Name     : SGR_URE_GenerateAgeRateDriverScheduler     
  Version             : 1.0
  Function            : Scheduler class to populate plan details in Age Rate Driver table
  
* Modification Log    :
* Shankar		11/26/2018		SFDC-14007 - Initial version
* ----------------------------------------------------------------------------               
* INFOSYS                  11/26/2018                Original Version
*************************************************************************************/
global class SGR_URE_GenerateAgeRateDriverScheduler implements Schedulable {
	global void execute(SchedulableContext con) {
	  SGR_URE_GenerateAgeRateDriverBatch b=	new SGR_URE_GenerateAgeRateDriverBatch(null);
        database.executeBatch(b);

    }
}