/**************************************************************************************
  Apex Class Name     : SGR_GenerateAgeRateTablesBatch     
  Version             : 1.0
  Function            : This class is used to shcedule Age rate tables on monthly basis for Dental Plans.
  Modification Log    :
* Developer:Akbar Hussain Salisabgari    Date: 11/29/2018                   Description
* ----------------------------------------------------------------------------               
* INFOSYS                  09/05/2018                Original Version
*************************************************************************************/
public class SGR_DentalAgeRateTablesBatchSchedule implements Schedulable{

    public void execute(SchedulableContext sc) {
		
        SGR_GenerateAgeRateTablesBatch b1 = new SGR_GenerateAgeRateTablesBatch(System.today(),'Dental',1,'RenewalsSalesForce','SG',false);
        ID batchprocessid = Database.executeBatch(b1,Integer.valueOf(System.label.SGR_No_Of_Dental_Plan_ID));           
    }
}