//************************************************************************************
// Name             : GEMS_AccountRetrieveServiceCallout .cls
// Description      : Callout class for Retrieve Account Structure Service
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// ************************************************************************************


public without sharing class GEMS_AccountRetrieveServiceCallout extends FW_ServiceIO_REST{
    map<string, string> requestHeader;
    //string referenceId;
    
    private virtual void setCustomHeaderValues(map<string, string> requestHeader){
        this.requestHeader = requestHeader;
        System.Debug('requestHeader - '+ requestHeader);
    }
    // Formatting the Input to Request
    public object convertInputToRequest(){    
        
        GEMS_AccountRetrieveServiceInput input = (GEMS_AccountRetrieveServiceInput) serviceInput;
        
         //referenceId = input.accountDetails.accountStructureCaseID;
                
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
        request += '\n\t\t<blu:getAccountStructure>';
        request += '\n\t\t\t<accountStructureRequest>';
        
        request += '\n\t\t\t\t<corpEntCd>' + input.corpEntCd + '</corpEntCd>';
        request += '\n\t\t\t\t<acctNbr>' + input.acctNbr + '</acctNbr>';
        request += '\n\t\t\t\t<accountStructureCaseID>' + input.accountStructureCaseID + '</accountStructureCaseID>';
        request += '\n\t\t\t\t<requestCode>' + input.requestCode + '</requestCode>';        
        request += '\n\t\t\t</accountStructureRequest>';       
        request += '\n\t\t</blu:getAccountStructure>';
        request += '\n\t</soapenv:Body>';
        
        request += '\n</soapenv:Envelope>';
        
        system.debug('Request XML : \n' + request);        
        return request;
    
    }
    // Formatting the Request to Output
    public override object convertResponseToOutput(object response, map<string, string> responseHeader, FW_Service_Status serviceStatus){
        
        HttpResponse res = (HttpResponse) response;     
        string responseBody = res.getBody();   
        
        //serviceStatus.referenceId =  this.referenceId;
        
        GEMS_AccountRetrieveServiceOutput output = new GEMS_AccountRetrieveServiceOutput(); 

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
            //string responseBody = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
            
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
                invokeAccountSetupResponse = body.getChildElement('getAccountStructureResponse', 'http://www.hcsc.com/account/BluestarAccountService');
            system.debug('getAccountStructureResponse :' + invokeAccountSetupResponse);
            
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