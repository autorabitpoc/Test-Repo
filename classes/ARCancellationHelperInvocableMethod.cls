/****************************************************************************************/
/* Description:  This Class was created to be called from a Process Builder as part of  */
/*               the LGNA Accout Group Section Cancellation Process.  It takes in a Case*/
/*               and then calls an external Method.                                     */
/****************************************************************************************/
/* History - 12/2017 - SFDC-7452 - Initial Version                                      */
/****************************************************************************************/
global class ARCancellationHelperInvocableMethod {
    
    /* SFDC-7452 - 12/2017 - Retro Cancellations - Begin */
    @InvocableMethod(label='LGNAAfterApprovalAccountStructureCancellation' description='Sends the Cases out to BlueStar for Processing.')
    global static void LGNAAfterApprovalAccountStructureCancellation(List<Case> TheCases){
        
        List<Id> TheCaseIDs = new List<Id>();
        
        System.debug('Start - LGNAAfterApprovalAccountStructureCancellation: ' + TheCases);
        
        /* get the Ids for the Cases and put into Lists */
        for(Case ACase:TheCases){
            /* Add the Case IDs to the list for the Call */
            TheCaseIDs.add(ACase.Id);
        }        
        
        System.debug('TheCaseIDs: ' + TheCaseIDs);
 
        /* make the Call */
        ARCancelllationHelper.sendLGNAAccountStructureCancellation(TheCaseIDs);                                        
    }
    /* SFDC-7452 - 12/2017 - Retro Cancellations - End */
}