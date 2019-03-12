/**************************************************************************************
Apex Class Name     : SGR_BlueStarTransferCallout   
Version             			: 1.0
Function            		: This class is used callout to perform BlueSTAR transfer
Modification Log    	:
* Developer: Padma  Date: 12/20/2018                   Initial version
* ----------------------------------------------------------------------------               
* Padma                  12/20/2018                Original Version
*************************************************************************************/
public class SGR_BlueStarTransferCallout { 
    public static list<FW_Service_Status_Log__c> fwLogList = new list<FW_Service_Status_Log__c>();
    public static List<Opportunity> oppListToUpdate = new List<Opportunity>();
    public static List<Case> caseListToInsert = new List<Case>();
    public static List<Error_Log__c> errorLogs = new List<Error_Log__c>();
    public static List<Error_Log__c> errorLogstoinsert = new List<Error_Log__c>();
    public String createXMLDoc(Opportunity opp)
    {   
        /* Opportunity opp1 = [Select AccountId,SGR_Opportunity_Name__c,SGR_Account_Number__c, Renewal_Date__c, Name, 
Assigned_UW__c, Account_Market_Segment__c,HCSC_Division__c,SGR_Renewal_Account_Name__c,
(Select Plan__c, Opportunity__c,Marketing_Plan_ID__c, Mapping_From_Plan_Id__c, Invitro_TX_only__c,Is_HSA__c, 
Coverage_Type__c,Health_Rating_Area_Number__c From Opportunity_Plan_Rates__r)
From Opportunity
where id='0064D000004HjEJQA0'
];*/
        String request;       
        request = '<?xml version="1.0" encoding="UTF-8"?>';
        request += '\n<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/">';
        request += '\n\t<soapenv:Body>';
        request += '\n\t\t<acc:execute>';
        SGR_BlueStarTransferHelper bstarreq = new SGR_BlueStarTransferHelper(opp);
        String convreq = bstarreq.convertInputToRequest();
        if (null == convreq) {return null;}
        request += convreq;
        request += '\n\t\t</acc:execute>';
        request += '\n\t</soapenv:Body>';
        request += '\n</soapenv:Envelope>';
        return request;
    }
    
    public static Opportunity sendRequest(Opportunity opp){ 
        //fwLogList = new list<FW_Service_Status_Log__c>();
        Boolean finalResponseFromBlueStar;
        try{
            system.debug('sendRequest Entered:::::');
            
            String requestBody;
            SGR_BlueStarTransferCallout requestXML = new SGR_BlueStarTransferCallout();
            
            if (!isValidOpp(opp)) {
                // Case caseins = getBlueStarCaseDefaultsByOpportunity(opp);
                // insert caseins;
                opp.SGR_Workflow_Activity__c = system.label.BlueStarFailed_WorkFlow_Activity_Updated_Status;//'BlueStar Transfer Failed';
                opp.Workflow_System_Status__c = system.label.BlueStarSuccess_WorkFlow_System_Status_Updated_Value;//Workflow Completed
                SGR_Exception ex = new SGR_Exception('Invalid Opportunity. Missing reuired fields Data on XML request.');
                errorLogs = CreateExceptionLog.createErrorLogRecs(ex, null, null, null, 'Apex Class', 'SGR_BlueStarTransferCallout', null, 'SGR_BlueStarTransferCallout.sendRequest', 'High'); 
                errorLogstoinsert.addAll(errorLogs);
                system.debug('errorLogstoinsert:::::'+errorLogstoinsert);
                return opp;
            }
            system.debug('Before createXMLDoc:::::');
            requestBody = requestXML.createXMLDoc(opp);
            system.debug('requestBody :::::'+requestBody);
            if (null == requestBody) {
                opp.SGR_Workflow_Activity__c = system.label.BlueStarFailed_WorkFlow_Activity_Updated_Status;//'BlueStar Transfer Failed';
                opp.Workflow_System_Status__c = system.label.BlueStarSuccess_WorkFlow_System_Status_Updated_Value;//Workflow Completed
                SGR_Exception ex = new SGR_Exception('Request Body is empty because no valid opportunity found. Not sending request to BlueSTAR');
                errorLogs = CreateExceptionLog.createErrorLogRecs(ex, null, null, null, 'Apex Class', 'SGR_BlueStarTransferCallout', null, 'SGR_BlueStarTransferCallout.sendRequest', 'High'); 
                errorLogstoinsert.addAll(errorLogs);
                system.debug('errorLogstoinsert:::::'+errorLogstoinsert);
                return opp;
                //SGR_Exception ex = new SGR_Exception('Request Body is empty because no valid opportunity found. Not sending request to BlueSTAR');
                //CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_BlueStarTransferCallout', null, 'SGR_BlueStarTransferCallout.sendRequest','Low');
                //return null;
            }
            APICallOutRestWSUtility apiCallout = new APICallOutRestWSUtility('BlueStarUpdateCallOut');
            SGR_BlueStarTransferResponse response = apiCallout.BlueStartAutomationUpdateCallOut(opp.Id,requestBody);
            system.debug('Response:::::'+response); 
            if(response!=null){
                fwLogList.add(apiCallout.integrationStatuLog);
            }
            
            if(response.status == '200')
            {
                system.debug('response.message::::::'+response.message);
                finalResponseFromBlueStar = parseResponseXML(response.message);
                system.debug('finalResponseFromBlueStar::::::'+finalResponseFromBlueStar);
                if(finalResponseFromBlueStar == true){
                    system.debug('finalResponseFromBlueStar :'+finalResponseFromBlueStar);
                    opp.Rating_Status__c = system.label.BlueStar_Rating_Status_Update_Finalized;//'Finalized';
                    opp.SGR_Workflow_Activity__c = '';
                    opp.Workflow_System_Status__c = system.label.BlueStarSuccess_WorkFlow_System_Status_Updated_Value;//Workflow Completed
                }
                else{
                    system.debug('finalResponseFromBlueStar :'+finalResponseFromBlueStar);
                    opp.SGR_Workflow_Activity__c = system.label.BlueStarFailed_WorkFlow_Activity_Updated_Status;//'BlueStar Transfer Failed';
                    opp.Workflow_System_Status__c = system.label.BlueStarSuccess_WorkFlow_System_Status_Updated_Value;//Workflow Completed
                }
            }
            else{
                system.debug('finalResponseFromBlueStar :'+finalResponseFromBlueStar);
                opp.SGR_Workflow_Activity__c = system.label.BlueStarFailed_WorkFlow_Activity_Updated_Status;//'BlueStar Transfer Failed';
                opp.Workflow_System_Status__c = system.label.BlueStarSuccess_WorkFlow_System_Status_Updated_Value;//Workflow Completed
            }            
        }catch(exception e){
            system.debug('Exception::::'+e);
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_BlueStarTransferCallout', opp.id, 'SGR_BlueStarTransferCallout.sendRequest','Low');
        }
        system.debug('sendRequest Exited:::::');
        return opp;
    }
    public static void sendPlanOrRateChangeReqListToBStar(Set<Id> oppIds){
        system.debug('sendPlanOrRateChangeReqListToBStar Entered:::::');
        system.debug('sendPlanOrRateChangeReqListToBStar oppIds:::::'+oppIds);
        List<SGR_Renewal_Batch_Oppty__c> optyRenBatchList = new List<SGR_Renewal_Batch_Oppty__c>();      
        
        List<Opportunity> opps =  [Select AccountId,Account.Name,SGR_Account_Number__c, Renewal_Date__c, Opportunity_Number__c,SGR_Opportunity_Auto_Number__c, 
                                   Rating_Status__c,SGR_Workflow_Activity__c,Assigned_UW__c,Assigned_UW__r.EmployeeNumber, 
                                   Account_Market_Segment__c,HCSC_Division__c,SGR_Renewal_Account_Name__c,Account.Market_Segment__c,
                                   (Select Plan__c, Opportunity__c,Marketing_Plan_ID__c, Mapping_From_Plan_Id__c, Invitro_TX_only__c,Is_HSA__c,Type__c, 
                                    Plan_Status__c,Coverage_Type__c,Health_Rating_Area_Number__c,Rate_Size_Code__c From Opportunity_Plan_Rates__r 
                                    where Plan_Status__c='Sold' AND Type__c='Renewal'
                                   ),(select Id, Processing_Status__c from SGR_Renewal_Batch_Opptys__r)
                                   From Opportunity
                                   where id IN :oppIds 
                                   AND
                                   Rating_Status__c = 'Sold' AND (Plan_Change_Needed__c = '' OR Plan_Change_Needed__c = 'Complete')                       
                                   AND Workflow_System_Status__c = 'Ready to Send to BlueSTAR'
                                  ];
        system.debug('sendPlanOrRateChangeReqListToBStar opps:::::'+opps);
        
        if(opps != NULL && !opps.isEmpty()){
            for(Opportunity opp: opps) {
                system.debug('sendPlanOrRateChangeReqListToBStar opp:::::'+opp);
                Opportunity o = sendRequest(opp);
                system.debug('sendPlanOrRateChangeReqListToBStar o:::::'+o);
                if (o != Null) {
                    system.debug('Entered if condition o:::::'+o);
                    system.debug('o.SGR_Renewal_Batch_Opptys__r :::::'+o.SGR_Renewal_Batch_Opptys__r);
                    oppListToUpdate.add(o);
                    system.debug('fwLogList:::::'+fwLogList);
                    if(o.SGR_Renewal_Batch_Opptys__r != Null){
                        optyRenBatchList.addAll(o.SGR_Renewal_Batch_Opptys__r);
                        system.debug('o.SGR_Renewal_Batch_Opptys__r :::::'+o.SGR_Renewal_Batch_Opptys__r);  
                    }
                    if(o.SGR_Workflow_Activity__c == 'BlueStar Transfer Failed'){
                        Case caseins = getBlueStarCaseDefaultsByOpportunity(o);
                        system.debug('Opportunity Transfer Failed'+o);
                        caseListToInsert.add(caseins);
                        system.debug('caseListToInsert:::::'+caseListToInsert);
                    }                    
                }
            }
            if(oppListToUpdate !=null && !oppListToUpdate.isEmpty()){
                try{
                    update oppListToUpdate;
                }Catch(system.DMLException e){
                    system.debug('DML exception ::::'+e +' '+e.getLineNumber());
                }
            }
            if(caseListToInsert != null && !caseListToInsert.isEmpty()){
                try{
                    system.debug('caseListToInsert:::::'+caseListToInsert);
                    insert caseListToInsert;
                }Catch(system.DMLException e){
                    system.debug('DML exception ::::'+e +' '+e.getLineNumber());
                }
            }
            if(optyRenBatchList != null && !optyRenBatchList.isEmpty()){
                SGR_BlueSTAREligibilityRules_Impl implClass = new SGR_BlueSTAREligibilityRules_Impl();
                implClass.updateOptyRenBatch(optyRenBatchList, 'Transferred to Bluestar');  
            }
            if(errorLogstoinsert != null && errorLogstoinsert.isEmpty()){
                try{
                    system.debug('errorLogstoinsert try block::::'+errorLogstoinsert);
                    insert errorLogstoinsert;
                }Catch(system.DMLException e){
                    system.debug('DML exception ::::'+e +' '+e.getLineNumber());
                }
            }
            if(fwLogList != null && !fwLogList.isEmpty()){
                try{
                    insert fwLogList;
                }Catch(system.DMLException e){
                    system.debug('DML exception ::::'+e +' '+e.getLineNumber());
                }
            }
        }
        system.debug('sendPlanOrRateChangeReqListToBStar Exited:::::');
    }
    
    public static boolean isValidOpp(Opportunity opp) {
        boolean isValid = true;
        // opp.SGR_Account_Number__c
        //     opp.SGR_Renewal_Account_Name__c
        system.debug('opp.Account.Market_Segment__c'+opp.Account.Market_Segment__c);
        system.debug('opp.Renewal_Date__c'+opp.Renewal_Date__c);
        system.debug('opp.SGR_Renewal_Account_Name__c'+opp.SGR_Renewal_Account_Name__c);
        system.debug(' opp.HCSC_Division__c'+ opp.HCSC_Division__c);
        system.debug('opp.Assigned_UW__c'+opp.Assigned_UW__c);
        if(opp.Account_Market_Segment__c == Null || opp.SGR_Renewal_Account_Name__c == Null ||
           opp.Renewal_Date__c == Null || opp.HCSC_Division__c == Null || opp.Assigned_UW__c == Null){
               isValid = false;
           }
        return isValid;
    }
    //This is for setting up the data for the cases to Insert
    public static Case getBlueStarCaseDefaultsByOpportunity(Opportunity oppty) {
        Case opptyCase = new Case();
        Group grp = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name ='SGR - Operations Queue'];
        opptyCase.Opportunity_Name__c = oppty.Id;
        Id sgrCaseRecId = Schema.SObjectType.case.getRecordTypeInfosByName().get('SGR-Renewals').getRecordTypeId();
        opptyCase.RecordTypeId=sgrCaseRecId;        
        opptyCase.Subject='BlueSTAR Transfer Fallout';
        opptyCase.Origin='BlueSTAR Transfer Fallout';
        opptyCase.OwnerId=grp.Id;
        opptyCase.Reason='BlueSTAR Transfer Fallout';        
        opptyCase.SGRAccountName__c=oppty.Account.name;
        opptyCase.AccountId = oppty.AccountId;
        opptyCase.SGR_AccountNumber__c=oppty.SGR_Account_Number__c;
        opptyCase.HCSC_Division__c=oppty.HCSC_Division__c;
        opptyCase.Status='New';
        opptyCase.SGR_MarketSegment__c='SG';//oppty.Account_Market_Segment__c;
        opptyCase.Priority='Medium';        
        opptyCase.AssignedUnderWriter__c=oppty.Assigned_UW__c;       
        return opptyCase;
    } 
    public static Boolean parseResponseXML(String res){
        Dom.Document doc = new Dom.Document();
        Dom.XMLNode envelope;
        Dom.XmlNode body;
        Dom.XmlNode executeResponse;
        Dom.XmlNode AutomatedPlanChangeServiceResponse;
        Dom.XmlNode planResponses;
        Dom.XmlNode planResponse;
        String planExecutedSuccessFully;
        Set<String> finalResStringSet = new Set<String>();
        Boolean finalResponse = false;
        if(res != Null){
            /*
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<ns2:executeResponse xmlns:ns2="http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/">
<AutomatedPlanChangeServiceResponse>
<corpEntCd>TX1</corpEntCd>
<acctNbr>219371</acctNbr>
<opportunityId>317889</opportunityId>
<modNbr>0</modNbr>
<rtSzUpdateTxt>account rtSzCd update successful - updated from none to </rtSzUpdateTxt>
<planResponses>
<planResponse>
<mktgPlnNbr>SPSG15BCASTXO</mktgPlnNbr>
<planExecutedSuccessFully>Y</planExecutedSuccessFully>
<grpSectTab/>
<messagesList>
<message>
<msgTxt>Benefit Agreement Number 0002 has been successfully Approved.</msgTxt>
</message>
</messagesList>
</planResponse>
</planResponses>
</AutomatedPlanChangeServiceResponse>
</ns2:executeResponse>
</soap:Body>
</soap:Envelope>*/
            
            doc.load(res);
            
            //Retrieve the root element for this document.
            if(doc != null)
                envelope  = doc.getRootElement();
            system.debug('Envelope :' + envelope );
            if(envelope != null)
                body = envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            system.debug('Body' + body);
            if(body != null)
                executeResponse = body.getChildElement('executeResponse', 'http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/');
            system.debug('executeResponse :' + executeResponse);
            if(executeResponse != null)
                AutomatedPlanChangeServiceResponse = executeResponse.getChildElement('AutomatedPlanChangeServiceResponse', null);
            system.debug('AutomatedPlanChangeServiceResponse :' + AutomatedPlanChangeServiceResponse);
            if(AutomatedPlanChangeServiceResponse != null)
                planResponses = AutomatedPlanChangeServiceResponse.getChildElement('planResponses', null);
            system.debug('planResponses :' + planResponses);
            if(planResponses != null){
                for(Dom.XmlNode pResponse:planResponses.getChildElements()){                
                    // planResponse = pResponse.getChildElement('planResponse', null);
                    //system.debug('planResponse :' + planResponse);
                    planExecutedSuccessFully = pResponse.getChildElement('planExecutedSuccessFully', null).getText();
                    system.debug('planExecutedSuccessFully :'+planExecutedSuccessFully);
                    if(planExecutedSuccessFully != null){                    
                        finalResStringSet.add(planExecutedSuccessFully); 
                        system.debug('finalResStringSet :'+finalResStringSet);
                    }
                } 
            }
            if(finalResStringSet.contains('Y')){
                system.debug('finalResponse :'+finalResponse);
                finalResponse = True;
            } 
            else{
                finalResponse = False;
                system.debug('finalResponse :'+finalResponse);
            }
        }
        return finalResponse; 
    }
}