/**************************************************************************************
  Apex Class Name     : LGNA_OpportunityRequestHubController 
  Version             : 1.0
  Function            : This class is used as Opportunity RequestHub. 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Dileep      09/26/2017                Original Version
*************************************************************************************/
public class LGNA_OpportunityRequestHubController {
    
    @AuraEnabled
    public static String getAccountId (String OpptyId){
        return LGNA_LightningGlobal.getAccountIdFromOpptyId(OpptyId);
    }
}