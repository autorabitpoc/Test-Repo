//************************************************************************************
// Name             : LGNA_EIN_TransmitServiceHelper.cls
// Description      : Helper class to retrieve Sequence No from the Service.
// Created By       : Bharath
// Created Date     : 5/28/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 5/28/2018        Bharath             Initial version
// -----------------------------------------------------------------------------------
// ************************************************************************************

global class LGNA_EIN_TransmitServiceHelper {
    
    public static string transactionId=null;    
    
    /******************************************************************** 
*    Method Name : sendEIN
*   @description : This method retreives Account and EIN information and uses FW_Service framework for transmission of EINs to BlueStar.
*   @parameters  : Account record.
*   @return type :   void 
*   @Author      : Bharath
***************************************************************/                   
    public static String sendEIN(Id accId){
        system.debug('Invocable method called sendEIN');
        string result;
        try{
            if(accId != null){
                Account acc = [select id,Name,HCSC_Division__c,External_Id__c,Market_Segment__c, 
                               Effective_Date__c, Cancellation_Status__c,COBRA_Administration_Type__c, Multiple_EINs__c
                               from Account where Id =: accId ];
                
                
                LGNA_EIN_SendInput input = new LGNA_EIN_SendInput();
                LGNA_EIN_SendInput.AccountDetails accountDetails = new LGNA_EIN_SendInput.AccountDetails();
                list<LGNA_EIN_SendInput.EINInfo> einDetailsList = new list<LGNA_EIN_SendInput.EINInfo>();
                accountDetails.accountName = acc.Name.escapeXML();
                string accountNumber = acc.External_Id__c;   
                if(accountNumber!= null){                    
                    if(accountNumber.length() > 6) {
                        accountNumber = accountNumber.substring(2, accountNumber.length());   
                    }
                    accountDetails.accountNumber = accountNumber;                    
                }                
                accountDetails.effectiveDate = string.valueof(date.newinstance(acc.Effective_Date__c.year(), acc.Effective_Date__c.month(), acc.Effective_Date__c.day()));  
                accountDetails.marketSegment = acc.Market_Segment__c;
                String azId = String.valueOf(acc.Id).substring(0, 15);
                accountDetails.accountStructureCaseID = azId;
                accountDetails.corpCode = acc.HCSC_Division__c + '1';
                accountDetails.sourceSystemCd = 'MEIN';
                if(!Test.isRunningTest()){
                    accountDetails.cobraCode = acc.COBRA_Administration_Type__c;
                    String cobraAutoCancelValue = ARCancellationConstants__c.getValues('cobraAutoCancel').ARCancelRequiredField__c;
                    accountDetails.cobraAutoCancel = cobraAutoCancelValue;
                    String autoCatIndValue = ARCancellationConstants__c.getValues('autoCatInd').ARCancelRequiredField__c;
                    accountDetails.autoCatInd = autoCatIndValue;                
                }
                if(acc.Multiple_EINs__c == true){
                    accountDetails.multipleEIN = 'Y';
                } else {
                    accountDetails.multipleEIN = 'N';
                }
                
                EIN__c primaryEIN = [select Name from EIN__c where Account__c = :accId and primary__c = true limit 1];
                accountDetails.primaryEIN = primaryEIN.Name.escapeXML();
                //Bharath0626
                list<EIN__c> einList = [select id,Name, Account__r.name, City1__c, Country1__c, County_Code1__c, Effective_Date__c, EIN_Sequence_Number__c, End_Date__c,                                        
                                        Location_Name__c, Primary__c, State1__c, Street11__c, Street21__c, Zip_Code1__c, Change_Reason__c from EIN__c 
                                        where Account__c = :accId and Change_Reason__c != null
                                        and (Bluestar_Transfer_Status__c = 'Transfer In Transit' or Bluestar_Transfer_Status__c = 'Seq# updated')
                                        order by primary__c desc];
                /*list<EIN__c> einList = [select id,Name, Account__r.name, Effective_Date__c, EIN_Sequence_Number__c, End_Date__c,                                        
Location_Name__c, Primary__c, Change_Reason__c from EIN__c 
where Account__c = :accId and Change_Reason__c != null
and (Bluestar_Transfer_Status__c = 'Transfer In Transit' or Bluestar_Transfer_Status__c = 'Seq# updated')
order by primary__c desc];*/
                
                for(EIN__c ein : einList){
                    system.debug('EIN records are available');
                    LGNA_EIN_SendInput.EINInfo sendEIN = new LGNA_EIN_SendInput.EINInfo();
                    sendEIN.ein = ein.Name.escapeXML();
                    sendEIN.effectiveDate = string.valueof(date.newinstance(ein.Effective_Date__c.year(), ein.Effective_Date__c.month(), ein.Effective_Date__c.day()));
                    if(ein.End_Date__c <> null){
                        sendEIN.endDate = string.valueof(date.newinstance(ein.End_Date__c.year(), ein.End_Date__c.month(), ein.End_Date__c.day()));    
                    }
                    sendEIN.locName = ein.Location_Name__c;
                    //Bharath0626
                    sendEIN.street1 = ein.Street11__c;
                    ////Bharath0626
                    sendEIN.street2 = ein.Street21__c;
                    ////Bharath0626
                    sendEIN.city = ein.City1__c;
                    ////Bharath0626
                    sendEIN.state = ein.State1__c;
                    ////Bharath0626
                    sendEIN.zipCode = ein.Zip_Code1__c;
                    ////Bharath0626
                    sendEIN.countyCode = string.valueOf(ein.County_Code1__c);
                    ////Bharath0626
                    sendEIN.countryCode = ein.Country1__c;
                    if((ein.EIN_Sequence_Number__c == 0 || ein.EIN_Sequence_Number__c == null) && (ein.Change_Reason__c == 'CHG' || ein.Change_Reason__c == 'ERR')){
                        sendEIN.chgReasonCode = 'ADD';
                    } else {
                        sendEIN.chgReasonCode = ein.Change_Reason__c;
                    }
                    
                    sendEIN.einSeqNbr = string.valueof(ein.EIN_Sequence_Number__c);
                    ////Bharath0626
                    if(ein.Country1__c == 'US'){
                        sendEIN.countryName = 'United States';
                    }
                    einDetailsList.add(sendEIN);
                }
                input.accountDetails = accountDetails;
                input.einInfo = einDetailsList;
                if(einDetailsList!= null && !einDetailsList.isempty()){
                    system.debug('Before the call of FW_Service');
                    FW_Service s = new FW_Service('LGNA_EIN_Send');
                    LGNA_EIN_SendOutput output = (LGNA_EIN_SendOutput) s.callout(input);
                    system.debug('After the call of FW_Service');
                    List<EIN__c> updateEINs = new List<EIN__c>();
                    if(output.status == 'S'){
                        for(Ein__c updEIN : einList){
                            //Bharath - Do not clear change reason until we get confirmation from BlueStar.
                            //updEIN.Change_Reason__c = null;    
                            updEIN.Bluestar_Transfer_Status__c = 'Wait BS Confirm';
                            updateEINs.add(updEIN);
                        }
                        upsert updateEINs;
                        system.debug('Output status is S');
                        result = 'EIN has been sent to BlueSTAR.';
                    } else if(output.status == 'I'){
                        for(Ein__c updEIN : einList){
                            updEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
                            //Following 2 lines can be uncommented for testing in dev environment. 
                            //updEIN.Change_Reason__c = null;    
                            //updEIN.Bluestar_Transfer_Status__c = 'Transfer Complete';
                            updateEINs.add(updEIN);
                        }
                        upsert updateEINs;                    
                        system.debug('Bharath Output status is I');
                        result = 'EIN send has failed';
                    } else {
                        for(Ein__c updEIN : einList){
                            updEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
                            //Following 2 lines can be uncommented for testing in dev environment. 
                            //  updEIN.Change_Reason__c = null;    
                            //  updEIN.Bluestar_Transfer_Status__c = 'Transfer Complete';
                            updateEINs.add(updEIN);
                        }
                        upsert updateEINs;                             
                        system.debug('Bharath Output status is final else');
                        result = 'EIN send has failed';
                    }
                } else {
                    result = 'No EINs qualified for transmission.';
                    List<EIN__c> update1EINs = new List<EIN__c>();
                    for(Ein__c updEIN : einList){
                        updEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
                        update1EINs.add(updEIN);
                    }
                    upsert update1EINs;                                        
                }
            }
        }
        catch(exception e){
            system.debug('exception in LGNA_EIN_SendStart ' + e);
        }
        return result;
    }
    
    /******************************************************************** 
*    Method Name : retrieveEIN
*   @description : This method builds request to fetch Seq# from BlueSTAR, parses the response & updates corresponding EIN records
*   @parameters  : List of EIN records
*   @return type : void 
*   @Author      : Bharath
***************************************************************/ 
    webService static string retrieveEIN(List<EIN__c> einList, Account acc) {   
        
        string result = null;
        
        try {
            GEMS_AccountRetrieveServiceInput input = new GEMS_AccountRetrieveServiceInput();
            
            input.corpEntCd = acc.HCSC_Division__c + '1';            
            String azId = String.valueOf(acc.Id).substring(0, 15);
            input.accountStructureCaseID = azId; 
            
            String accountNbr = acc.External_ID__c;
            if(accountNbr!= null) {                    
                if(accountNbr.length() > 6)
                    accountNbr = accountNbr.substring(2, accountNbr.length());                
                input.acctNbr = accountNbr;                    
            }
            
            input.requestCode = azId+'-mein'; // 
            
            FW_Service s = new FW_Service('GEMS_Account_Retrieve');      
            
            GEMS_AccountRetrieveServiceOutput output = (GEMS_AccountRetrieveServiceOutput) s.callout(input);
            String blueStarStatus = 'Due for Transfer';            
            if(output.status == 'S' ) {
                result = 'Success';
                blueStarStatus = 'Seq# Requested'; // new status to indicate that Seq# is requested from B* for non-ADD EINs
                
            } else if(output.status == 'I') {
                result = 'System failed to send the request for Account Structure details.';                 
            } else {
                result = output.message; 
                blueStarStatus = 'Due for Transfer';
            }
            
            if(result == null) {
                result = 'Failed to send the the request.';   
            }
            
            // Update appropriate B* status in EINs
            for (EIN__c ein: einList) {
                ein.Bluestar_Transfer_Status__c = blueStarStatus;
            }
            
            update einList;
            
        } catch (Exception ex) {
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
        return result;
    }
    
    public static GEMS_AccountStructureCreateServiceOutput updateEIN(GEMS_AccountStructureCreateServiceInput input, String accId) {
        GEMS_AccountStructureCreateServiceOutput output = new GEMS_AccountStructureCreateServiceOutput();        
        Boolean errFlag = false;
        try {
            if (input.status == 'S') {
                /*List<EIN__c> einsToUpsert =  processEINsFuture(input.acctEin, accId);
if (null != einsToUpsert && !einsToUpsert.isEmpty()) {
System.debug('einsToUpsert to upsert:::'+einsToUpsert);
upsert einsToUpsert Name;
output.status = 'S';
output.message ='Seq# successfully updated';
} else {
output.status = 'E';
output.message = 'Empty or invalid EIN list received from BlueSTAR';
}*/
                processEINsFuture(input, accId);
                if(!input.acctEin.isEmpty()){
                    output.status = 'S';
                    output.message ='Seq# successfully updated';
                } else {
                    output.status = 'E';
                    output.message = 'Empty or invalid EIN list received from BlueSTAR';                    
                }
            } else {
                output.status = 'E';
                output.message = 'EIN retrieval failed in BlueSTAR';
            }
        } catch (Exception ex) {
            output.status = 'E';
            output.message = 'Error ocuured while updating EIN. Reason: '+ ex.getMessage();
        } 
        return output;
    }
    
    /******************************************************************** 
*    Method Name : processEINs
*   @description : This method parses the input from BlueSTAR & uodates corresponding EIN info
*   @parameters  : List of EIN records
*   @return type : void 
*   @Author      : Bharath
***************************************************************/ 
    /*Bharath - earlier version.    
public static List<EIN__c> processEINs(List<GEMS_AccountStructureCreateServiceInput.AccountEin> einInfoList, String accId) {
List<EIN__c> einsToUpsert = new List<EIN__c>();
for (GEMS_AccountStructureCreateServiceInput.AccountEin e: einInfoList) {
EIN__c ein = new EIN__c();
ein.EIN_Sequence_Number__c = e.einSeqNbr;
ein.Name = e.einNbr;
if(ein.Bluestar_Transfer_Status__c == 'Seq# Requested'){
ein.Bluestar_Transfer_Status__c = 'Seq# updated'; // Update status to indicate that seq no retrieval from B* is complete; and EIN transmit can start
}
einsToUpsert.add(ein);
}
return einsToUpsert;        
}    */
    //@future (callout=true)
    public static void processEINsFuture(GEMS_AccountStructureCreateServiceInput accountDetailsReceived, String accId) {
        // Get the list of EINs waiting for sequence number from BlueStar for the specified account.
        List<EIN__c> einWaitingTransmit = [select id,name,EIN_Sequence_Number__c,Bluestar_Transfer_Status__c from EIN__c where Account__c = :accId and
                                           Bluestar_Transfer_Status__c = 'Seq# Requested'];
        //Set<EIN__c> einWaitingTransmit = new Set<EIN__c>([select id,name,EIN_Sequence_Number__c,Bluestar_Transfer_Status__c from EIN__c where Account__c = :accId and Bluestar_Transfer_Status__c = 'Seq# Requested']);
        Set<String> einNumToUpdate = new Set<String>();
        //Create a set of EIN numbers waiting for sequence number from Bluestar.
        for(EIN__c ei : einWaitingTransmit){
            einNumToUpdate.add(ei.name);
        }
        Set<GEMS_AccountStructureCreateServiceInput.AccountEin> einToUpdate = new Set<GEMS_AccountStructureCreateServiceInput.AccountEin>();
        Map<String,GEMS_AccountStructureCreateServiceInput.AccountEin> processedEin = new Map<String,GEMS_AccountStructureCreateServiceInput.AccountEin>();
        for(GEMS_AccountStructureCreateServiceInput.AccountEin ae : accountDetailsReceived.acctEin){
            //Check whether the EIN recieved from BlueStar is waiting for sequence number in SFDC.
            if(einNumToUpdate.contains(ae.einNbr)){
                //Bluestar can return multiple record for same EIN number. Process them as uniqueue with EIN# on SFDC using a map. Add data to map if the EIN# is already not present as key.
                if(processedEin.containsKey(ae.einNbr) == false){
                    processedEin.put(ae.einNbr,ae);
                } else {
                    //If the map already has the EIN#, check whether the repeating EIN# from BlueStar has higher effective date. If yes, use the new EIN with the old one. Otherwise, ignore the record.
                    if(ae.einEffDt > processedEin.get(ae.einNbr).einEffDt){
                        processedEin.put(ae.einNbr,ae);
                    }
                }
            }
        }
        //We now have a Map with uniqueue EIN key set which needs to be updated on SFDC with highest effective date from BlueStar. Use the map data to populate sequence number into EIN__c object.
        List<EIN__c> einsToUpsert = new List<EIN__c>();
        for (EIN__c e: einWaitingTransmit) {
            if(processedEin.containsKey(e.Name)){
                e.EIN_Sequence_Number__c = processedEin.get(e.Name).einSeqNbr;                
            }
            e.Bluestar_Transfer_Status__c = 'Seq# updated';
            einsToUpsert.add(e);
        }
        if(!einsToUpsert.isEmpty()){
            upsert einsToUpsert;
        }
        
    }    
    
    /******************************************************************** 
*    Method Name : sendNewAcctEIN
*   @description : This method willl kick off EINs 
*   @parameters  : List of EIN records
*   @return type : void 
*   @Author      : Bharath
***************************************************************/ 
    public static void sendNewAcctEIN(Id AccId){
        list<id> idParam = new list<id>();
        idParam.add(Accid);
        List<EIN__c> readEINs = [select id,name,Bluestar_Transfer_Status__c,change_reason__c, Account__r.Name, Account__r.External_ID__c, 
                                 Account__r.Effective_Date__c,Account__r.Market_Segment__c, Account__r.HCSC_Division__c
                                 from EIN__c where Account__c =: Accid and change_reason__c = 'ADD'
                                 and Bluestar_Transfer_Status__c = 'Due for Transfer'];        
        if (readEINs.isEmpty()) { return; }
        List<EIN__c> updateEINs = new List<EIN__c>();
        for(EIN__c einRecord : readEINs){
            einRecord.Bluestar_Transfer_Status__c = 'Transfer In Transit';
            if(einRecord.Account__r.External_ID__c <> null && einRecord.Account__r.Effective_Date__c <> null && einRecord.Account__r.Market_Segment__c <> null){
                updateEINs.add(einRecord);
            }
        } 
        if(!updateEINs.isEmpty()){
            upsert updateEINs;
            LGNA_EIN_SendStart.sendEINInvocable(idParam);
        }
    }    
    
    /******************************************************************** 
*    Method Name : processResponse
*   @description : This method willl kick off EINs 
*   @parameters  : List of EIN records
*   @return type : void 
*   @Author      : Bharath
***************************************************************/ 
    public static void processResponse(Id AccId, List<String> bsFailEINs){
        List<EIN__c> failEINs = [select id,name,Bluestar_Transfer_Status__c,change_reason__c, Account__c, Sent_Effective_Date__c, Effective_Date__c
                                 from EIN__c where Account__c =: Accid and name in :bsFailEINs];
        List<EIN__c> successEINs = [select id,name,Bluestar_Transfer_Status__c,change_reason__c, Account__c, Sent_Effective_Date__c, Effective_Date__c
                                    from EIN__c where Account__c =: Accid and Bluestar_Transfer_Status__c = 'Wait BS Confirm' and name not in :bsFailEINs];
        List<EIN__c> updateEINs = new List<EIN__c>();
        for(EIN__c fe : failEINs){
            fe.Bluestar_Transfer_Status__c = 'Due for Transfer';
            updateEINs.add(fe);
        }
        for(EIN__c se : successEINs){
            se.Bluestar_Transfer_Status__c = '';
            se.change_reason__c = '';
            se.Sent_Effective_Date__c = se.Effective_Date__c;
            updateEINs.add(se);
        }
        if(!updateEINs.isEmpty()){
            upsert updateEINs;
        }
    }        
    /******************************************************************** 
*    Method Name : resetEINs
*   @description : This method willl kick off EINs 
*   @parameters  : List of EIN records
*   @return type : void 
*   @Author      : Bharath
***************************************************************/ 
    public static void resetEINs(Id AccId){
        List<EIN__c> failEINs = [select id,name,Bluestar_Transfer_Status__c,change_reason__c, Account__c 
                                 from EIN__c where Account__c =: Accid and Bluestar_Transfer_Status__c = 'Wait BS Confirm'];
        List<EIN__c> updateEINs = new List<EIN__c>();
        for(EIN__c fe : failEINs){
            fe.Bluestar_Transfer_Status__c = 'Due for Transfer';
            updateEINs.add(fe);
        }
        if(!updateEINs.isEmpty()){
            upsert updateEINs;
        }
    }            
}