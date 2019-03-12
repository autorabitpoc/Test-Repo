/**************************************************************************************
  Apex Class Name     : GEMS_BATriggerHandler 
  Version             : 1.0
  Function            : This is a handler class for GEMS_BA_Trigger.
  Test Class		  : GEMS_BATriggerHandlerTest
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Bharath            07/27/2017             Original Version
*************************************************************************************/
public class GEMS_BATriggerHandler {
    
    /******************************************************************** 
    *    Method Name : updateCaseBAProduct
    *   @description :   This method updates corresponding Case objects when IsNew field is updated.   
    *   @parameters  :   List<Case> statusChnage, List<Case> oldParentCaseStatus
    *   @return type :   void
    *   @Author      : Bharath
    ***************************************************************/
    public static void updateCaseBAProduct(List<GEMS_Benefit_Agreement__c> oldBAs, List<GEMS_Benefit_Agreement__c> newBAs){
        map<id, GEMS_Benefit_Agreement__c> mapBAs = new map<id, GEMS_Benefit_Agreement__c>();
        list<case> updatecase = new list<case>();
        //Check whether IsNew field has been changed in the Business Agreement.
        for(GEMS_Benefit_Agreement__c oldBAcheck : oldBAs){
            for(GEMS_Benefit_Agreement__c newBAcheck : newBAs){
                if(oldBAcheck.isnew__c != newBAcheck.isnew__c){
                	mapBAs.put(newBAcheck.id, newBAcheck);
                }
            }
        }
        //Proceed with processing only when the IsNew field has been updated.
        if(mapBAs.size()>0){
            try{
        		list<Case> BACase = [select ID, isnew__c, GEMS_Benefit_Agreement__c from case where GEMS_Benefit_Agreement__c in : newBAs];
            	if(BACase.size()>0){
            		for(Case processCase : BACase){
                		processCase.isnew__c = mapBAs.get(processCase.GEMS_Benefit_Agreement__c).isnew__c;
                		updatecase.add(processCase);
            		}
            		update updatecase;
            	}
            }
            catch(exception ex){
                System.debug('==exception='+ex.getMessage());
                CreateExceptionLog.insertErrorLog(ex,null,null,null,'Apex Class','Case',null,'updateCaseBAProduct(List<GEMS_Benefit_Agreement__c> oldBAs, List<GEMS_Benefit_Agreement__c> newBAs)','High');  
            }
        }
    }
}