/**************************************************************************************
* Apex Class Name     : LGNA_EIN_ConfirmControllerApx 
* Version             : 1.0
* Function            : This is server side controller for EIN confirmation component.
* Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Bharath            04/12/2018             Original Version
*************************************************************************************/
public class LGNA_EIN_ConfirmControllerApx {
    
    /******************************************************************** 
*    Method Name : returnEIN
*   @description : This method returns the list of EINs which are ready for transmission to BlueStar.
*   @parameters  : Account ID
*   @return type :   List<EIN__c> 
*   @Author      : Bharath
***************************************************************/       
    @AuraEnabled
    public static list<EIN__c> returnEIN(id Accid){
        if(Accid <> null){
            //Retrieve the list of EINs which are ready for transmission to BlueStar.
            ////Bharath0626
            /*List<EIN__c> sendReady = [select id, name, location_name__c, effective_date__c, end_date__c, gems_address__c, EIN_Sequence_Number__c, primary__c, change_reason__c,
                    Bluestar_Transfer_Status__c from EIN__c where Account__c =: Accid and change_reason__c != null and change_reason__c != 'ENDSENT' 
                    and Bluestar_Transfer_Status__c = 'Due for Transfer'];*/
            List<EIN__c> sendReady = [select id, name, location_name__c, effective_date__c, end_date__c, EIN_Sequence_Number__c, primary__c, change_reason__c,
                    Bluestar_Transfer_Status__c from EIN__c where Account__c =: Accid and change_reason__c != null and change_reason__c != 'ENDSENT' 
                    and Bluestar_Transfer_Status__c = 'Due for Transfer'];
            //Retrieve the records which are stuck in retrieving sequence number status for more than an hour and make them available for transmission.
            DateTime timeCheck = system.now().addHours(-2);
            ////Bharath0626
            /*List<EIN__c> stuckEINs = [select id, name, location_name__c, SystemModStamp, effective_date__c, end_date__c, gems_address__c, EIN_Sequence_Number__c, primary__c, change_reason__c,
                    Bluestar_Transfer_Status__c from EIN__c where Account__c =:Accid and (Bluestar_Transfer_Status__c = 'Seq# Requested' or Bluestar_Transfer_Status__c = 'Seq# updated'
                                                                                         or Bluestar_Transfer_Status__c = 'Wait BS Confirm') and SystemModStamp < :timeCheck];*/
            List<EIN__c> stuckEINs = [select id, name, location_name__c, SystemModStamp, effective_date__c, end_date__c, EIN_Sequence_Number__c, primary__c, change_reason__c,
                    Bluestar_Transfer_Status__c from EIN__c where Account__c =:Accid and (Bluestar_Transfer_Status__c = 'Seq# Requested' or Bluestar_Transfer_Status__c = 'Seq# updated'
                                                                                         or Bluestar_Transfer_Status__c = 'Wait BS Confirm') and SystemModStamp < :timeCheck];            
			List<EIN__c> updateStuckEIN = new List<EIN__c>();
            for(EIN__c stuckEIN : stuckEINs){
                stuckEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
                updateStuckEIN.add(stuckEIN);
                sendReady.add(stuckEIN);
            }
            if(!updateStuckEIN.isEmpty()){
                //Update the stuck EINs so that they are ready for transmission to BlueStar again.
                upsert updateStuckEIN;
            }
            if(!sendReady.isEmpty()){
                return sendReady;
            } else {
                List<EIN__c> dummyrecs = new List<EIN__c>();
                return dummyrecs;
            }
        }
        else {
            List<EIN__c> dummyrecs1 = new List<EIN__c>();
            return dummyrecs1;
        }
    }
    
    /******************************************************************** 
*    Method Name : sentEIN
*   @description : This method returns the list of EINs which have been already updated to BlueStar.
*   @parameters  : Account ID
*   @return type :   List<EIN__c> 
*   @Author      : Bharath
***************************************************************/           
    @AuraEnabled
    public static list<EIN__c> sentEIN(id Accid){
        if(Accid <> null){
            //Retrieve the list of EINs already transmitted to BlueStar successfully.
            //////Bharath0626
            /*return [select id, name, location_name__c,lastmodifieddate, effective_date__c, end_date__c, gems_address__c, EIN_Sequence_Number__c, primary__c, change_reason__c 
                    from EIN__c where Account__c =: Accid and (change_reason__c = '' or change_reason__c = 'ENDSENT') and Bluestar_Transfer_Status__c != 'Transfer In Transit' and 
                   Bluestar_Transfer_Status__c != 'Seq# Requested' and Bluestar_Transfer_Status__c != 'Seq# updated' and Bluestar_Transfer_Status__c != 'Due for Transfer'
                   and Bluestar_Transfer_Status__c != 'Wait BS Confirm'];            */
            return [select id, name, location_name__c,lastmodifieddate, effective_date__c, end_date__c, EIN_Sequence_Number__c, primary__c, change_reason__c 
                    from EIN__c where Account__c =: Accid and (change_reason__c = '' or change_reason__c = 'ENDSENT') and Bluestar_Transfer_Status__c != 'Transfer In Transit' and 
                   Bluestar_Transfer_Status__c != 'Seq# Requested' and Bluestar_Transfer_Status__c != 'Seq# updated' and Bluestar_Transfer_Status__c != 'Due for Transfer'
                   and Bluestar_Transfer_Status__c != 'Wait BS Confirm'];                        
        }
        else {
            List<EIN__c> dummyrecs = new List<EIN__c>();
            return dummyrecs;
        }
    }
    
    /******************************************************************** 
*    Method Name : returnEIN
*   @description : This method will returns the list of EINs for which transmission has been initiated as future method and response is awaited.
*   @parameters  : Account ID
*   @return type :   List<EIN__c> 
*   @Author      : Bharath
***************************************************************/           
    @AuraEnabled
    public static list<EIN__c> sendProgress(id Accid){
        if(Accid <> null){
            ////Bharath0626
            /*return [select id, name, location_name__c, lastmodifieddate, effective_date__c, end_date__c, gems_address__c, EIN_Sequence_Number__c, primary__c, change_reason__c 
                    from EIN__c where Account__c =: Accid and change_reason__c != null and (Bluestar_Transfer_Status__c = 'Transfer In Transit' or Bluestar_Transfer_Status__c = 'Seq# Requested' 
                                                                                            or Bluestar_Transfer_Status__c = 'Seq# updated' or Bluestar_Transfer_Status__c = 'Wait BS Confirm')];*/
            return [select id, name, location_name__c, lastmodifieddate, effective_date__c, end_date__c,  EIN_Sequence_Number__c, primary__c, change_reason__c 
                    from EIN__c where Account__c =: Accid and change_reason__c != null and (Bluestar_Transfer_Status__c = 'Transfer In Transit' or Bluestar_Transfer_Status__c = 'Seq# Requested' 
                                                                                            or Bluestar_Transfer_Status__c = 'Seq# updated' or Bluestar_Transfer_Status__c = 'Wait BS Confirm')];            
        }
        else {
            List<EIN__c> dummyrecs = new List<EIN__c>();
            return dummyrecs;
        }
    }    
    
    /******************************************************************** 
*    Method Name : transmitEIN
*   @description : This method calls the process to transmit EIN to BlueStar. 
*   @parameters  : Account ID
*   @return type :   List<EIN__c> 
*   @Author      : Bharath
***************************************************************/           
    @AuraEnabled
    public static void transmitEIN(id Accid){
        list<id> idParam = new list<id>();
        idParam.add(Accid);
        //EINCHGSEND - Use the 1st query to send ADD, CHG and END EINs.
        List<EIN__c> readEINs = [select id,name,Bluestar_Transfer_Status__c,change_reason__c from EIN__c where Account__c =: Accid and change_reason__c != null and change_reason__c != 'ENDSENT'
                                 and Bluestar_Transfer_Status__c = 'Due for Transfer'];
        if (readEINs.isEmpty()) { return; }
        List<EIN__c> updateEINs = new List<EIN__c>();
        List<Id> EINReqList = new List<Id>();
        Boolean needEINRetrieveCall = false; 
        for(EIN__c einRecord : readEINs){
            // This field update is to track the EINs which are being transmitted. This update is done to avoid duplicate transmissions by user.
            einRecord.Bluestar_Transfer_Status__c = 'Transfer In Transit';
            
            EINReqList.add(einRecord.id); // moved out of changeReasonCd check because EIN list should have all the EINs for later status update
            
            // If there is at least 1 EIN with ERR/CHG change reason code, retrieve EIN list from B*
            if (einRecord.change_reason__c != 'ADD') {
                needEINRetrieveCall = true;
            } else {
                // Table EINs with 'ADD' for transmission
                updateEINs.add(einRecord);    
            }            
        }
        
        // Request Seq# for the EINs if any CHG or END or ERR records exists for transmission.
        if (needEINRetrieveCall){
            String response = LGNA_EIN_SendStart.fetchEIN(EINReqList, Accid);
            if (response == 'Success') {
                
                
            } else {
                if(!Test.isRunningTest()){
                    throw new AuraHandledException('Communication error occured while trying to transmit EIN to BlueStar. Please try after some time. If the issue persists, please contact System Administrator.');
                }
            }
        }
        // If there are only ADDs present in EIN list, bypass Seq# request and initiate transmission of EINs to BlueStar.
        else if(!updateEINs.isEmpty() && !needEINRetrieveCall){
            upsert updateEINs;
            //Following call initiates the transmission to BlueStar.
            LGNA_EIN_SendStart.sendEINInvocable(idParam);                    
        }
        
        
    }
    
}