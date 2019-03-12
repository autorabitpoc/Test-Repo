public class LGNA_EIN_SendCallout  extends FW_ServiceIO_REST{
    map<string, string> requestHeader;
    
    private virtual void setCustomHeaderValues(map<string, string> requestHeader){
        this.requestHeader = requestHeader;
    }    
    public object convertInputToRequest(){
        LGNA_EIN_SendInput input = (LGNA_EIN_SendInput)serviceInput;
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
        if(input.accountDetails.accountName != null)        {
            request += '\n\t\t\t\t<acctNm>' + input.accountDetails.accountName + '</acctNm>';            
        }
        else{
            request += '\n\t\t\t\t<acctNm/>';                    
        }
        request += '\n\t\t\t\t<acctNbr>' + input.accountDetails.accountNumber + '</acctNbr>';
        request += '\n\t\t\t\t<acctEffDt>' + input.accountDetails.effectiveDate + '</acctEffDt>';  
        if(input.accountDetails.marketSegment != null)
            request += '\n\t\t\t\t<mktSegCd>' + input.accountDetails.marketSegment + '</mktSegCd>';     
        else
            request += '\n\t\t\t\t<mktSegCd/>';
        request += '\n\t\t\t\t<accountStructureCaseID>' + input.accountDetails.accountStructureCaseID + '</accountStructureCaseID>';
        request += '\n\t\t\t\t<corpEntCd>' + input.accountDetails.corpCode + '</corpEntCd>';
        if(input.accountDetails.cobraAutoCancel != null)
            request += '\n\t\t\t\t<cobraAutoCanInd>' + input.accountDetails.cobraAutoCancel + '</cobraAutoCanInd>';
        else
            request += '\n\t\t\t\t<cobraAutoCanInd/>';
        if(input.accountDetails.cobraCode != null)
            request += '\n\t\t\t\t<cobraCd>' + input.accountDetails.cobraCode + '</cobraCd>';  
        else
            request += '\n\t\t\t\t<cobraCd>NA</cobraCd>';
        if(input.accountDetails.autoCatInd != null)
            request += '\n\t\t\t\t<autoCatInd>' + input.accountDetails.autoCatInd + '</autoCatInd>';
        else
            request += '\n\t\t\t\t<autoCatInd/>';        
        request += '\n\t\t\t\t<sourceSystemCd>mein</sourceSystemCd>';  
        request += '\n\t\t\t\t<einNbrPrimary>' + input.accountDetails.primaryEIN + '</einNbrPrimary>';  
        request += '\n\t\t\t\t<mltpEinInd>' + input.accountDetails.multipleEIN + '</mltpEinInd>';  
        if(input.einInfo != Null){
            for(LGNA_EIN_SendInput.EINInfo einRec : input.EINInfo) {
                request += '\n\t\t\t\t<einInfo>';
                request += '\n\t\t\t\t\t<einNbr>' + einRec.ein + '</einNbr>';
                if(einRec.einSeqNbr != null)
                    request += '\n\t\t\t\t\t<acctEinSeqNbr>' + einRec.einSeqNbr + '</acctEinSeqNbr>';
                else
                    request += '\n\t\t\t\t\t<acctEinSeqNbr>0</acctEinSeqNbr>';
                if(einRec.chgReasonCode != null)
                    request += '\n\t\t\t\t\t<changeReasonCd>' + einRec.chgReasonCode + '</changeReasonCd>';
                else
                    request += '\n\t\t\t\t\t<changeReasonCd></changeReasonCd>';
                if(einRec.effectiveDate != null)        
                    request += '\n\t\t\t\t\t<einEffDt>' + einRec.effectiveDate + '</einEffDt>';
                else
                    request += '\n\t\t\t\t\t<einEffDt></einEffDt>';
                if(einRec.endDate != null)        
                    request += '\n\t\t\t\t\t<einEndDt>' + einRec.endDate + '</einEndDt>';
                request += '\n\t\t\t\t\t<locNm>' + einRec.locName + '</locNm>';
                if(einRec.street1 != null)        
                    request += '\n\t\t\t\t\t<strLn1>' + einRec.street1 + '</strLn1>';
                else
                    request += '\n\t\t\t\t\t<strLn1></strLn1>';
                if(einRec.street2 != null)        
                    request += '\n\t\t\t\t\t<strLn2>' + einRec.street2 + '</strLn2>';
                else
                    request += '\n\t\t\t\t\t<strLn2></strLn2>';
                if(einRec.city != null)        
                    request += '\n\t\t\t\t\t<ctyNm>' + einRec.city + '</ctyNm>';
                else
                    request += '\n\t\t\t\t\t<ctyNm></ctyNm>';
                if(einRec.state != null)        
                    request += '\n\t\t\t\t\t<stCd>' + einRec.state + '</stCd>';
                else
                    request += '\n\t\t\t\t\t<stCd></stCd>';
                if(einRec.zipCode != null)        
                    request += '\n\t\t\t\t\t<zipCd>' + einRec.zipCode + '</zipCd>';
                else
                    request += '\n\t\t\t\t\t<zipCd></zipCd>';
                if(einRec.countyCode != null)        
                    request += '\n\t\t\t\t\t<cntyCd>' + einRec.countyCode + '</cntyCd>';
                else
                    request += '\n\t\t\t\t\t<cntyCd></cntyCd>';
                if(einRec.countryName != null)        
                    request += '\n\t\t\t\t\t<cntryNm>' + einRec.countryName + '</cntryNm>';
                else
                    request += '\n\t\t\t\t\t<cntryNm></cntryNm>';
                if(einRec.countryCode != null)        
                    request += '\n\t\t\t\t\t<cntryCd>' + einRec.countryCode + '</cntryCd>';
                else
                    request += '\n\t\t\t\t\t<cntryCd></cntryCd>';
                request += '\n\t\t\t\t</einInfo>';          
            }
        }
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
        LGNA_EIN_SendOutput output = new LGNA_EIN_SendOutput(); 
        if(res.getStatusCode() != 200 && res.getStatusCode() != 201){
            serviceStatus.status = 'I';
            serviceStatus.errorCode = string.valueOf(res.getStatusCode());
            serviceStatus.errorDescription = res.getStatus();              
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
            //Following commented code can be used for debug purpose in dev environments.
            //system.debug('Return :' + return1);
            /*String acctNmbr;
            String asId;
            String corpEntCd;*/
            //if(return1 != null){
                output.status = return1.getChildElement('status', null).getText();
              /*  acctNmbr = return1.getChildElement('acctNbr', null).getText();
                asId = return1.getChildElement('accountStructureCaseID', null).getText();
                corpEntCd = return1.getChildElement('corpEntCd', null).getText();*/
                output.message = return1.getChildElement('message', null).getText();
            /*}
            
            //print out specific elements
            system.debug('Status: ' + status);
            system.debug('acctNbr: ' + acctNmbr);
            system.debug('asId: ' + asId); 
            system.debug('corpEntCd: ' + corpEntCd); 
            system.debug('message: ' + message);            
            
            output.status = status;
            output.message = message;*/
        }
                
        
        return output;
    }
    
}