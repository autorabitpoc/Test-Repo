/**************************************************************************************
* Apex Class Name     : LGNA_EIN_SendStart 
* Version             : 1.0
* Function            : This class retrieves 
* Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Bharath            04/12/2018             Original Version
*************************************************************************************/
public class LGNA_EIN_SendStart {
    
    /******************************************************************** 
*    Method Name : sendEINInvocable
*   @description : This method submits the EIN transmission as future method.
*   @parameters  : List of Account IDs.
*   @return type :   void 
*   @Author      : Bharath
***************************************************************/           
    @InvocableMethod
    public static void sendEINInvocable(List<Id> accIds){
        system.debug('Invocable method called sendEINInvocable');
        sendEINInFuture(accIds);
    }
    
    /******************************************************************** 
*    Method Name : sendEINInFuture
*   @description : This is a future method which calls the transmission method in loop.
*   @parameters  : List of Account IDs.
*   @return type :   void 
*   @Author      : Bharath
***************************************************************/               
    @future (callout=true)
    public static void sendEINInFuture(List<Id> accIds){
        system.debug('Invocable method called sendEINInFuture');
        for(Id accId : accIds){
            String result = LGNA_EIN_TransmitServiceHelper.sendEIN(accId);
        }
    }
    
    
    
    /******************************************************************** 
*    Method Name : fetchSeqNoInFuture
*   @description : This is a future method which calls the fetchSeqNo method
*   @parameters  : List of EIN records, account id
*   @return type :   void 
*   @Author      : Bharath
***************************************************************/               
    //@future (callout=true)
    public static String fetchEIN(List<Id> einIdList, Id accId){
        system.debug('Invocable method called fetchSeqNoInFuture');
        List<EIN__c> einList = [select id,name,Bluestar_Transfer_Status__c from EIN__c where Id in :einIdList];
        
        Account acc = [select id,Name,HCSC_Division__c,External_Id__c,Market_Segment__c, 
                       Effective_Date__c, Cancellation_Status__c,COBRA_Administration_Type__c, Multiple_EINs__c
                       from Account where Id =: accId ];
        
        return LGNA_EIN_TransmitServiceHelper.retrieveEIN(einList, acc);
        
    }
    
    
}