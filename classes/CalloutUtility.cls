public class CalloutUtility implements ICalloutUtility{ 

    public interface ICalloutUtility {
        Object sendCallout(String username, String password, String body, 
                                        String endpoint, String certificate, 
                                                    String organizationId, String type);
    }
    
    public static final String  SOAP_BODY  = '{!BODY}';
    public static final String  SOAP_UNAME = '{!USERNAME}';
    public static final String  SOAP_PWORD = '{!PASSWORD}';
    public static final String  SOAP_ORGID = '{!ORGID}';
    public static final Integer ADD_SRV_TIMEOUT = 120000;
    public static String  STATE_CODE = 'IL';

    wwwHcscComCorpItMnssAddressSvcV4.AddressServiceImplPort request;
    wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList response;
    
    public CalloutUtility(){
        this(new wwwHcscComCorpItMnssAddressSvcV4.AddressServiceImplPort(),
                new wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList());
    }

    @TestVisible private CalloutUtility(wwwHcscComCorpItMnssAddressSvcV4.AddressServiceImplPort request, 
                                            wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList response){
        this.request = request;
        this.response = response;
    }

    public Object sendCallout(String username, String password, String body, 
                                            String endpoint, String certificate, 
                                                        String organizationId, String type){
        if(Limits.getCallouts() < Limits.getLimitCallouts()){
            if(type.equalsIgnoreCase('BLUESTAR')){
                return sendCalloutToBlueSTAR(username, password, body, endpoint, certificate, organizationId);
            } else if(type.equalsIgnoreCase('ADDRESS_SERVICE')){
                return sendCalloutToAddressService(endpoint, certificate);
            }
        }
        return null;
    }
    
    public HttpResponse sendCalloutToBlueSTAR(String username, String password, 
                                                    String body, String endpoint, 
                                                        String certificate, String organizationId) {

        String soapXML = getSOAPEnvelope();
        soapXML=soapXML.replace(SOAP_UNAME, username);
        soapXML=soapXML.replace(SOAP_PWORD, password);
        soapXML=soapXML.replace(SOAP_ORGID, organizationId);
        soapXML=soapXML.replace(SOAP_BODY,  body);

        Http http = new Http();
        HttpResponse resp=new HttpResponse();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/xml');
        request.setHeader('Content-Length', '10240');
        request.setHeader('Username', username);
        request.setHeader('Password', password);
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setTimeout(60000);
        request.setClientCertificateName(certificate);
        request.setBody(soapXML);
        system.debug(' call out to '+endpoint+' with request xml:'+request.getBody());
        
        resp=http.send(request); 
        
        system.debug('blue * resp::::'+resp);
        return resp;// http.send(request);        
    } 

    public Object sendCalloutToAddressService(String endpoint, String certificate) { 

        request.endpoint_x = endpoint;
        request.clientCertName_x = certificate; 
        request.timeout_x = ADD_SRV_TIMEOUT;
        return request.getZipCodeToCountiesRelationshipByState(STATE_CODE);  
    }

    public static String getSOAPEnvelope(){

        String soapXML;
        soapXML= '<?xml version="1.0" encoding="UTF-8"?>';
        soapXML += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:add="http://addressapplication1.xplservice.commonservices.bluestar.hcsc.com/">';
        soapXML += '<soapenv:Header>';
        soapXML += '<wsse:Security soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns:wsse="http://schemas.xmlsoap.org/ws/2003/06/secext">';
        soapXML += '<wsse:UsernameToken>';
        soapXML += '<wsse:Username>{!USERNAME}</wsse:Username>'; 
        soapXML += '<wsse:Password>{!PASSWORD}</wsse:Password>';
        soapXML += '</wsse:UsernameToken></wsse:Security>';
        soapXML += '</soapenv:Header>';
        soapXML += '<soapenv:Body>';
        soapXML += '<add:execute>';
        soapXML += '<arg0>';
        soapXML += '{!BODY}';
        soapXML += '</arg0>';
        soapXML += '</add:execute>';
        soapXML += '</soapenv:Body>';
        soapXML += '</soapenv:Envelope>';

        return soapXML;
    }   
}