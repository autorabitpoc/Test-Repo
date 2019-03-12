/**************************************************************************************
  Apex Class Name     : SGR_GenerateAgeRateTablesBatch     
  Version             : 1.0
  Function            : This class is used to shcedule Age rate tables on monthly basis for Health/Vision Plans.
  Modification Log    :
* Developer:Akbar Hussain Salisabgari    Date: 11/29/2018                   Description
* ----------------------------------------------------------------------------               
* INFOSYS                  09/05/2018                Original Version
*************************************************************************************/
global class SGR_NonDentalAgeRateTablesBatchSchedule implements Schedulable{

  global void execute(SchedulableContext sc) {
		
        SGR_GenerateAgeRateTablesBatch b1 = new SGR_GenerateAgeRateTablesBatch(System.today(),'NonDental',1,'RenewalsSalesForce','SG',false);
        ID batchprocessid = Database.executeBatch(b1,Integer.valueOf(System.label.SGR_No_Of_Plan_ID));           
    }
}