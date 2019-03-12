/*****************************************************************************************************
* Apex Class Name     : LGNA_AccountCancellationCallout
* Version             : 1.0
* Function            : This is callout class for Account, Group Section, Billing Profile, Category Cancellation.
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Padma Bedampeta     10/20/2017       Added code for Account Cancellation SFDC-5043
*                                      related apex classes ARCancelllationHelper, LGNA_ARCancellationInput, LGNA_ARCancellationOutput, GEMS_AccountStructureStatusService
*                                      AccountCancellationClass, Laveraged existing GEMS framework by using apex classes- FW_Service, FW_Service_Helper, 
*                                      FW_Service_Interface, FW_Service_BASE, FW_ServiceIO_REST, FW_ServiceIO_Base, FW_ServiceIO_Interface . 
*                                      Custom Metadata Types - FW_Service_Headers__mdt, FW_Service_Settings__mdt
*------------------------------------------------------------------------------------------------------------------------------*/

public class LGNA_AccountCancellationCallout extends FW_ServiceIO_REST{
    
    map<string, string> requestHeader;
    //string referenceId;
    
    private virtual void setCustomHeaderValues(map<string, string> requestHeader){
        this.requestHeader = requestHeader;
        System.Debug('requestHeader - '+ requestHeader);
    }
    
    public object convertInputToRequest(){    
        
        LGNA_ARCancellationInput input = (LGNA_ARCancellationInput)serviceInput;
        System.debug('serviceInput:::::::::::::'+serviceInput);
        
        //referenceId = input.accountDetails.accountStructureCaseID;
        // Forming XML Request based on data captured in ARCancellationHelper.apxc
        string request;
        request = '<?xml version="1.0" encoding="UTF-8"?>';
        request += '\n<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:blu="http://www.hcsc.com/account/BluestarAccountService">';
        
        request += '\n\t<soapenv:Header>';
        request += '\n\t\t<wsse:Security soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns:wsse="http://schemas.xmlsoap.org/ws/2003/06/secext">';
        request += '\n\t\t\t<wsse:UsernameToken>';
        request += '\n\t\t\t\t<wsse:Username>' + requestHeader.get('Username') + '</wsse:Username>';
        request += '\n\t\t\t\t<wsse:Password>' + requestHeader.get('Password') + '</wsse:Password>';
        request += '\n\t\t\t</wsse:UsernameToken>';
        request += '\n\t\t</wsse:Security>';
        request += '\n\t</soapenv:Header>';
        
        request += '\n\t<soapenv:Body>';
        request += '\n\t\t<blu:invokeAccountSetup>';
        request += '\n\t\t\t<accountAutomationRequestData>';
        
        if(input.accountCanDetails.accountName != null)        
            request += '\n\t\t\t\t<acctNm>' + input.accountCanDetails.accountName + '</acctNm>';
        else
            request += '\n\t\t\t\t<acctNm/>';
        request += '\n\t\t\t\t<acctNbr>' + input.accountCanDetails.accountNumber + '</acctNbr>';
        request += '\n\t\t\t\t<acctEffDt>' + input.accountCanDetails.effectiveDate + '</acctEffDt>';  
        if(input.accountCanDetails.marketSegment != null)
            request += '\n\t\t\t\t<mktSegCd>' + input.accountCanDetails.marketSegment + '</mktSegCd>';     
        else
            request += '\n\t\t\t\t<mktSegCd/>';
        request += '\n\t\t\t\t<accountStructureCaseID>' + input.accountCanDetails.accountStructureCaseID + '</accountStructureCaseID>';
 		if(input.accountCanDetails.sourceSystemCd != null)      
        	request += '\n\t\t\t\t<sourceSystemCd>'+ input.accountCanDetails.sourceSystemCd +'</sourceSystemCd>';
        else
             request += '\n\t\t\t\t<sourceSystemCd/>';
        request += '\n\t\t\t\t<corpEntCd>' + input.accountCanDetails.corpCode + '</corpEntCd>';
        if(input.accountCanDetails.cobraAutoCancel != null)
            request += '\n\t\t\t\t<cobraAutoCanInd>' + input.accountCanDetails.cobraAutoCancel + '</cobraAutoCanInd>';
        else
            request += '\n\t\t\t\t<cobraAutoCanInd/>';
        if(input.accountCanDetails.cobraCode != null)
            request += '\n\t\t\t\t<cobraCd>' + input.accountCanDetails.cobraCode + '</cobraCd>';  
        else
            request += '\n\t\t\t\t<cobraCd/>';
        if(input.accountCanDetails.autoCatInd != null)
            request += '\n\t\t\t\t<autoCatInd>' + input.accountCanDetails.autoCatInd + '</autoCatInd>';
        else
            request += '\n\t\t\t\t<autoCatInd/>';
        
        if(input.accountCanDetails.changereasoncode != null){
            if(input.accountCanDetails.changereasoncode != null)
                request += '\n\t\t\t\t<changeReasonCd>'+ input.accountCanDetails.changereasoncode +'</changeReasonCd>';
            else
                request += '\n\t\t\t\t<changeReasonCd/>';
            if(input.accountCanDetails.cancellationEffDate != null)
                request += '\n\t\t\t\t <canEffDt>'+ input.accountCanDetails.cancellationEffDate +'</canEffDt>';
            else
                request += '\n\t\t\t\t<canEffDt/>';
            if(input.accountCanDetails.cancellationCode != null)
                request += '\n\t\t\t\t<cancellationCode>'+ input.accountCanDetails.cancellationCode +'</cancellationCode>';
            else
                request += '\n\t\t\t\t<cancellationCode/>';
        }
        
        if(input.groupSections != Null){
            for(LGNA_ARCancellationInput.GroupSection groupSection : input.groupSections) { 
                
                request += '\n\t\t\t\t<grpSectInfo>';
                request += '\n\t\t\t\t\t<grpUsrDisplNbr>' + groupSection.groupNumber + '</grpUsrDisplNbr>';
                request += '\n\t\t\t\t\t<sectUsrDisplNbr>' + groupSection.sectionNumber + '</sectUsrDisplNbr>';
                request += '\n\t\t\t\t\t<grpNm>' + groupSection.sectionDescription + '</grpNm>';
                if (groupSection.changeReasonCode != null) {
                    request += '\n\t\t\t\t\t<changeReasonCd>' + groupSection.changeReasonCode + '</changeReasonCd>';
                }
                if (groupSection.cancellationEffDate != null) {
                    request += '\n\t\t\t\t\t<canEffDt>' + groupSection.cancellationEffDate + '</canEffDt>';
                }
                if (groupSection.cancellationCode != null) {
                    request += '\n\t\t\t\t\t<cancellationCode>' + groupSection.cancellationCode + '</cancellationCode>';
                }
                
                if(groupSection.assignedCategoryNumbers != null){
                    for(string assignedCategoryNumber : groupSection.assignedCategoryNumbers) {
                        request += '\n\t\t\t\t\t<catAssignmentInfo>';
                        request += '\n\t\t\t\t\t\t<catUserDisplNbr>' + assignedCategoryNumber + '</catUserDisplNbr>';           
                        request += '\n\t\t\t\t\t</catAssignmentInfo>';
                    }
                }          
                
                for(string assignedBANumber : groupSection.assignedBANumbers) {
                    request += '\n\t\t\t\t\t<benAgmtAssignmentInfo>';
                    request += '\n\t\t\t\t\t\t<baUsrDisplNbr>' + assignedBANumber + '</baUsrDisplNbr>';                         
                    request += '\n\t\t\t\t\t</benAgmtAssignmentInfo>';
                }
                System.debug('groupSection.changeReasonCode::'+ groupSection.changeReasonCode);
                
                
                request += '\n\t\t\t\t</grpSectInfo>';          
            }
            
        }
        System.debug('Before Billing Profiles');
        if(input.billingProfiles != Null){
            for(LGNA_ARCancellationInput.BillingProfile billingProfile : input.billingProfiles) { 
                
                request += '\n\t\t\t\t<billProfInfo>';
                if(billingProfile.billingProfileNumber != null)
                    request += '\n\t\t\t\t\t<billProfNbr>' + billingProfile.billingProfileNumber + '</billProfNbr>';
                request += '\n\t\t\t\t\t<billProfDesc>' + billingProfile.description + '</billProfDesc>';
                if (billingProfile.changeReasonCode != null) {
                    request += '\n\t\t\t\t\t<changeReasonCd>' + billingProfile.changeReasonCode + '</changeReasonCd>';
                }
                if (billingProfile.cancellationEffDate != null) {
                    request += '\n\t\t\t\t\t<canEffDt>' + billingProfile.cancellationEffDate + '</canEffDt>';
                }
                if (billingProfile.cancellationCode != null) {
                    request += '\n\t\t\t\t\t<cancellationCode>' + billingProfile.cancellationCode + '</cancellationCode>';
                }
                
                request += '\n\t\t\t\t\t<arrangementInfo>';
                if(billingProfile.baNumbers != null){
                    for(string baNumber : billingProfile.baNumbers) {
                        request += '\n\t\t\t\t\t\t<benAgmtArrangement>';
                        request += '\n\t\t\t\t\t\t\t<baUsrDisplNbr>' + baNumber + '</baUsrDisplNbr>';           
                        request += '\n\t\t\t\t\t\t</benAgmtArrangement>';
                    }
                }
                
                for(string categoryNumber : billingProfile.categoryNumbers) {
                    request += '\n\t\t\t\t\t\t<billCatArrangement>';
                    request += '\n\t\t\t\t\t\t\t<catUserDisplNbr>' + categoryNumber + '</catUserDisplNbr>';                         
                    request += '\n\t\t\t\t\t\t</billCatArrangement>';
                }
                
                request += '\n\t\t\t\t\t\t<billAddrArrangement>';
                request += '\n\t\t\t\t\t\t\t<acctAddrSeqNbr>' + billingProfile.billingAddressSequence + '</acctAddrSeqNbr>';                         
                request += '\n\t\t\t\t\t\t</billAddrArrangement>';
                
                request += '\n\t\t\t\t\t</arrangementInfo>';
                request += '\n\t\t\t\t</billProfInfo>';          
            }
        }
        //**** Start Category Cancellation XML ****//
        if(input.categories != Null){
            for(LGNA_ARCancellationInput.Category category : input.categories) { 
                request += '\n\t\t\t\t<catInfo>';
                request += '\n\t\t\t\t\t<catUserDisplNbr>' + category.categoryNumber + '</catUserDisplNbr>';
                request += '\n\t\t\t\t\t<descTxt>' + category.categoryDescription + '</descTxt>';
                request += '\n\t\t\t\t\t<catCobraCd>' + category.categoryCobraCode + '</catCobraCd>';
                if(category.changeReasonCode != null) {
                request += '\n\t\t\t\t\t<changeReasonCd>' + category.changeReasonCode + '</changeReasonCd>';
            } 
                if (category.cancellationEffDate != null) {
                    request += '\n\t\t\t\t\t<canEffDt>' + category.cancellationEffDate + '</canEffDt>';
                }
                if (category.cancellationCode != null) {
                    request += '\n\t\t\t\t\t<cancellationCode>' + category.cancellationCode + '</cancellationCode>';
                }
                request += '\n\t\t\t\t\t<catUsgInfo>';
                request += '\n\t\t\t\t\t\t<prodInd>' + category.productIndicator + '</prodInd>';
                request += '\n\t\t\t\t\t\t<billInd>' + category.billingIndicator + '</billInd>';
                request += '\n\t\t\t\t\t\t<rptInd>' + category.reportingIndicator + '</rptInd>';
                request += '\n\t\t\t\t\t\t<mailInd>' + category.mailIndicator + '</mailInd>';
                request += '\n\t\t\t\t\t</catUsgInfo>'; 
                request += '\n\t\t\t\t</catInfo>';
            }
        }
        
        //**** End Category Cancellation XML ****//
        
        request += '\n\t\t\t</accountAutomationRequestData>';       
        request += '\n\t\t</blu:invokeAccountSetup>';
        request += '\n\t</soapenv:Body>';
        request += '\n</soapenv:Envelope>';
        system.debug('Request XML : \n' + request);        
        return request;
        
    }
    
    public override object convertResponseToOutput(object response, map<string, string> responseHeader, FW_Service_Status serviceStatus){
        
        HttpResponse res = (HttpResponse) response;     
        string responseBody = res.getBody();   
        
        //serviceStatus.referenceId =  this.referenceId;
        
        LGNA_ARCancellationOutput output = new LGNA_ARCancellationOutput(); 
        
        if(res.getStatusCode() != 200 && res.getStatusCode() != 201){
            serviceStatus.status = 'I';
            serviceStatus.errorCode = string.valueOf(res.getStatusCode());
            serviceStatus.errorDescription = res.getStatus();    
            
            /*if(jsonResponse != null){
XmlStreamReader xsr = new XmlStreamReader(responseBody);
//TODO
//Parse the XML for the error code and description
}*/                   
            try{
                system.debug('Final XML to parse :' + responseBody);
                output.status = serviceStatus.status;
            }
            catch(Exception e){
                //DO NOT DO ANYTHING
            }
        }
        //else if(serviceSettings.OutputClass__c != null && responseBody != null && responseBody instanceof string && serviceStatus.status == 'S'){           
        else if(responseBody != null && serviceStatus.status == 'S'){
            
            system.debug('Final XML to parse :' + responseBody);
            
            /*<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
<soap:Body>
<ns2:invokeAccountSetupResponse xmlns:ns2=""http://www.hcsc.com/account/BluestarAccountService"">
<return>
<status>S</status>
<acctNbr>107002</acctNbr>
<accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID>
<corpEntCd>IL1</corpEntCd>
<message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message>
</return>
</ns2:invokeAccountSetupResponse>
</soap:Body>
</soap:Envelope>*/
            //string responseBody = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
            //<soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService">
            //<return><status>S</status>
            //<acctNbr>107002</acctNbr>
            //<accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID>
            //<corpEntCd>IL1</corpEntCd>
            //<message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message>
            //</return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
            
            Dom.Document doc;
            Dom.XMLNode envelope;
            Dom.XmlNode body;
            Dom.XmlNode invokeAccountSetupResponse;
            Dom.XmlNode return1;
            
            doc = res.getBodyDocument();
            system.debug('Doc' + doc);        
            
            //Retrieve the root element for this document.
            if(doc != null)
                envelope  = doc.getRootElement();
            system.debug('Envelope :' + envelope );
            
            if(envelope != null)
                body = envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            system.debug('Body' + body);
            
            if(body != null)
                invokeAccountSetupResponse = body.getChildElement('invokeAccountSetupResponse', 'http://www.hcsc.com/account/BluestarAccountService');
            system.debug('invokeAccountSetupResponse :' + invokeAccountSetupResponse);
            
            if(invokeAccountSetupResponse != null)
                return1 = invokeAccountSetupResponse.getChildElement('return', null);
            
            system.debug('Return :' + return1);
            String status;
            String acctNmbr;
            String asId;
            String corpEntCd;
            String message;
            if(return1 != null){
                status = return1.getChildElement('status', null).getText();
                acctNmbr = return1.getChildElement('acctNbr', null).getText();
                asId = return1.getChildElement('accountStructureCaseID', null).getText();
                corpEntCd = return1.getChildElement('corpEntCd', null).getText();
                message = return1.getChildElement('message', null).getText();
            }
            
            //print out specific elements
            system.debug('Status: ' + status);
            system.debug('acctNbr: ' + acctNmbr);
            system.debug('asId: ' + asId); 
            system.debug('corpEntCd: ' + corpEntCd); 
            system.debug('message: ' + message);            
            
            output.status = status;
            output.message = message;
        }
        
        return output; 
    }
    
}