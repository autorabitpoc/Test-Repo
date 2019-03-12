@isTest
global class MockHttpResponseGeneratorSGR_blueStar implements HttpCalloutMock{
	Integer StatusCd = 200;
    string requestBody = 
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/">'+
        '<soapenv:Header>'+
        '</soapenv:Header>'+
        '<soapenv:Body>'+
        '<acc:execute>'+
        '<AutomatedPlanChangeServiceRequest>'+ 
        '<corpEntCd>TX1</corpEntCd>'+
        '<acctNbr>219371</acctNbr>'+
        '<acctNm>STORYLINE RENOVATIONS, LLC</acctNm>'+
        '<acctRnewlDt>2019-02-01</acctRnewlDt>'+
        '<mktSegCd>SG</mktSegCd>'+
        '<opportunityId>S317699</opportunityId>'+
        '<modNbr/>'+
        '<underwriterID>U339883</underwriterID>'+
        '<acaAtstnCd></acaAtstnCd>'+
        '<rtSzCd>A</rtSzCd>'+
        '<renewingPlans>'+
        '<plan>'+
        '<mktgPlnNbr>SPSG15BCASTXO</mktgPlnNbr>'+
        '<effectiveDate>2018-06-01</effectiveDate>'+
        '<oldMktgPlnNbr>GPSE46BCASTXO</oldMktgPlnNbr>'+
        '<schdleCd />'+
        '<regionCd/>'+
        '<matrntyInd/>'+
        '<invitroInd>N</invitroInd>'+
        '<speechInd />'+
        '<mmhInd />'+
        '<visInd>N</visInd>'+
        '<hsaInd>N</hsaInd>'+
        '<totRtChgPct>0.00</totRtChgPct>'+
        '<totAdminChrgPct>0.00</totAdminChrgPct>'+
        '<rates/>'+
        '<ureAreaNbr>3</ureAreaNbr>'+
        '</plan>'+
        '</renewingPlans>'+
        '</AutomatedPlanChangeServiceRequest>'+
        '</acc:execute>'+
        '</soapenv:Body>'+
        '</soapenv:Envelope>';
	string responseBody=
        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
        '<soap:Body>'+
        '<ns2:executeResponse xmlns:ns2="http://accountapplication1.xplservice.commonservices.bluestar.hcsc.com/">'+
        '<AutomatedPlanChangeServiceResponse>'+  
        '<corpEntCd>TX1</corpEntCd>'+     
        '<acctNbr>219371</acctNbr>'+     
        '<opportunityId>317789</opportunityId>'+     
        '<modNbr>0</modNbr>'+    
        '<rtSzUpdateTxt>account rtSzCd not updated</rtSzUpdateTxt>'+    
        '<planResponses>'+   
        '<planResponse>' +     
        '<mktgPlnNbr>SPSG15BCASTXO</mktgPlnNbr>'+         
        '<planExecutedSuccessFully>Y</planExecutedSuccessFully>'+        
        '<grpSectTab/>'+        
        '<messagesList>' +      
        '<message>'+           
        '<msgTxt>Benefit Agreement Number 0002 has been successfully Approved.</msgTxt>'+             
        '</message>'+          
        '</messagesList>'+      
        '</planResponse>'+  
        '</planResponses>'+  
        '</AutomatedPlanChangeServiceResponse>'+ 
        '</ns2:executeResponse>'+  
        '</soap:Body>'+ 
        '</soap:Envelope>';
	
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
    	String reqBody = req.getBody();
    	HttpResponse res = new HttpResponse();
    	res.setHeader('Content-Type', 'application/json');
    	if(reqBody != null){
    		
			res.setBody(responseBody);
	       
    	}else{
    		// jwtToken response
			res.setBody(requestBody);
	        res.setStatusCode(StatusCd);
    	}
        return res;
    }
}