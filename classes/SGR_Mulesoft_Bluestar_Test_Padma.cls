/* Sample Class used to test Mulesoft through Bluestar Connectivity---Padma Bedampeta
Can be delted once development is completed*/
public class SGR_Mulesoft_Bluestar_Test_Padma {    
public String convertInputToRequest(){
        string request;

        XmlStreamWriter req = new XmlStreamWriter();
      
        system.debug('input.opportunityDetails');
        req.writeStartElement(null, 'AutomatedPlanChangeServiceRequest', null);
        req.writeCharacters('\r\n');
        system.debug(' req::'+req);
        system.debug('input:::');
        
        addXmlElement(req, 'corpEntCd', 'TX1');
        addXmlElement(req, 'acctNbr', '219371');
        addXmlElement(req, 'acctNm', 'STORYLINE RENOVATIONS, LLC');
        addXmlElement(req, 'acctRnewlDt', '2019-02-01');
        addXmlElement(req, 'mktSegCd', 'SG');
        addXmlElement(req, 'opportunityId', '317698');
        addXmlElement(req, 'modNbr', null);
        addXmlElement(req, 'underwriterID', 'U339883');
        addXmlElement(req, 'acaAtstnCd', '');
        addXmlElement(req, 'rtSzCd', 'A');
        req.writeStartElement(null, 'renewingPlans', null);
    	req.writeStartElement(null, 'plan', null);
        addXmlElement(req, 'mktgPlnNbr', 'SPSG15BCASTXO');
        addXmlElement(req, 'effectiveDate', '2019-02-01');
        addXmlElement(req, 'oldMktgPlnNbr', 'GPSE46BCASTXO');      
        // addXmlElement(req, 'schdleCd', '');
        //  addXmlElement(req, 'regionCd', '');
        // addXmlElement(req, 'matrntyInd', ''); 
        addXmlElement(req, 'invitroInd', 'N');
        //addXmlElement(req, 'speechInd', '');
        //addXmlElement(req, 'mmhInd', '');
        addXmlElement(req, 'visInd', 'N');
        addXmlElement(req, 'hsaInd','N'); 
        addXmlElement(req, 'totRtChgPct', '0.00');
        addXmlElement(req, 'totAdminChrgPct', '0.00');
        req.writeEndElement();
        req.writeCharacters('\r\n');
        req.writeEndElement();
        req.writeCharacters('\r\n');
        req.writeEndElement();
        request = req.getXmlString();
        system.debug('request:::::::::::'+request);
        req.close();
        return request;
    }
    private void addXmlElement(XmlStreamWriter w, String elemName, String value){
        w.writeStartElement(null, elemName, null);
        w.writeCharacters(value==null?'':value);
        w.writeEndElement();
        w.writeCharacters('\r\n');
    }
    
    public void callOut(){
        String Request;
        request = '<?xml version="1.0" encoding="UTF-8"?>';
        request += '\n<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/">';
        request += '\n\t<soapenv:Body>';
        request += '\n\t\t<acc:execute>';
        request += convertInputToRequest();        
        request += '\n\t\t</acc:execute>';
        request += '\n\t</soapenv:Body>';
        request += '\n</soapenv:Envelope>';
        String buserName = 'WTS01U2';//oAuthUtil.userName;//'userName';
        system.debug('buserName:::'+buserName);
        String bpassword = 'G9XQYJ3G';//oAuthUtil.password;//'Password';//
        system.debug('bpassword:::'+bpassword);
        String clientId = '5c22ab6f60d8474abd0bae13cbdb1c38';
        String clientSecret = '7681dBc2867e4b9aBf3621a72F9967E2';
        String endPoint = 'https://api-sit.hcsctest.net/bluestarcommonservices/Mead739AutomatedPlanChangeService/v1';
        system.debug('endPoint:::'+endPoint);
        String reqMethod = 'POST';
       
        system.debug('requestBody:::::'+request);
        system.debug('clientId:::'+clientId);
        system.debug('clientSecret:::'+clientSecret);
        String certDevName = 'eamsg_salesforce_hcscexttest_net';
        
        HttpRequest req = new HttpRequest();
        Blob headerValue = Blob.valueOf(buserName + ':' + bpassword);        
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug(LoggingLevel.DEBUG, '64Encoded Basic from service: ' + authorizationHeader);
        req.setEndpoint(endPoint);
        req.setMethod(reqMethod);
        req.setHeader('Authorization', authorizationHeader); 
        req.setHeader('clientId',clientId);
        req.setHeader('clientSecret',clientSecret);
        req.setheader('content-type','application/xml');
        req.setClientCertificateName(certDevName);
        req.setBody(request);
        //req.setTimeout(60000);//Need confirmation from Bluestar for exact timeout period
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        
        System.debug(res.getBody());
        try {
            //Execute web service call here     
            res = http.send(req);  
            
            //Helpful debug messages
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode());  
            if(res.getStatusCode() == 500){
                system.debug('Validation error from Bluestar');
            }
            if(res.getStatusCode() == 200){
                system.debug('Success');
            }
            if(res.getStatusCode() == 400){
                system.debug('Validation error from Bluestar');
            }
        } catch(System.CalloutException e) {
            system.debug('exception::::'+e);
            //Exception handling goes here.... retry the call, whatever
        }

    }
   
}