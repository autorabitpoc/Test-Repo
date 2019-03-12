public without sharing class GEMS_AccountStructureSetupServiceCallout extends FW_ServiceIO_REST {
    
    map<string, string> requestHeader;
    //string referenceId;
    
    private virtual void setCustomHeaderValues(map<string, string> requestHeader){
        this.requestHeader = requestHeader;
        System.Debug('requestHeader - '+ requestHeader);
    }
    
    public object convertInputToRequest(){    
        
        GEMS_AccountStructureSetupServiceInput input = (GEMS_AccountStructureSetupServiceInput) serviceInput;
		
		 //referenceId = input.accountDetails.accountStructureCaseID;
		 		
        string request;
        request = '<?xml version="1.0" encoding="UTF-8"?>';
        request += '\n<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:blu="http://www.hcsc.com/account/BluestarAccountService">';
        
        request += '\n\t<soapenv:Header>';
        request += '\n\t\t<wsse:Security soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns:wsse="http://schemas.xmlsoap.org/ws/2003/06/secext">';
        request += '\n\t\t\t<wsse:UsernameToken>';
        request += '\n\t\t\t\t<wsse:Username>' + requestHeader.get('Username') + '</wsse:Username>';
        request += '\n\t\t\t\t<wsse:Password>' + requestHeader.get('Password') + '</wsse:Password>';
        //request += '\n\t\t\t\t<wsse:Username>' + 'SFDCLGNA' + '</wsse:Username>';
        //request += '\n\t\t\t\t<wsse:Password>' + 'bs2VwBSe' + '</wsse:Password>';
        request += '\n\t\t\t</wsse:UsernameToken>';
        request += '\n\t\t</wsse:Security>';
        request += '\n\t</soapenv:Header>';
        
        request += '\n\t<soapenv:Body>';
        request += '\n\t\t<blu:invokeAccountSetup>';
        request += '\n\t\t\t<accountAutomationRequestData>';
                
        request += '\n\t\t\t\t<acctNm>' + input.accountDetails.accountName + '</acctNm>';
        request += '\n\t\t\t\t<acctNbr>' + input.accountDetails.accountNumber + '</acctNbr>';
        request += '\n\t\t\t\t<acctEffDt>' + input.accountDetails.effectiveDate + '</acctEffDt>';        
        request += '\n\t\t\t\t<mktSegCd>' + input.accountDetails.marketSegment + '</mktSegCd>';     
        request += '\n\t\t\t\t<accountStructureCaseID>' + input.accountDetails.accountStructureCaseID + '</accountStructureCaseID>';
        request += '\n\t\t\t\t<corpEntCd>' + input.accountDetails.corpCode + '</corpEntCd>';
        request += '\n\t\t\t\t<cobraAutoCanInd>' + input.accountDetails.cobraAutoCancel + '</cobraAutoCanInd>';
        request += '\n\t\t\t\t<cobraCd>' + input.accountDetails.cobraCode + '</cobraCd>';       
        
        //1 or more repetitions:        
        for(GEMS_AccountStructureSetupServiceInput.Address address : input.addresses) {
            request += '\n\t\t\t\t<acctAddrInfo>';
            request += '\n\t\t\t\t\t<acctAddrSeqNbr>' + address.addressSequence + '</acctAddrSeqNbr>';            
            request += '\n\t\t\t\t\t<acctAddrNm>' + address.addressName + '</acctAddrNm>';            
            request += '\n\t\t\t\t\t<street>' + address.street + '</street>';
            request += '\n\t\t\t\t\t<stateCd>' + address.state + '</stateCd>';
            request += '\n\t\t\t\t\t<ctyNm>' + address.cityName + '</ctyNm>';
            request += '\n\t\t\t\t\t<zipCd>' + address.zipCode + '</zipCd>';
            request += '\n\t\t\t\t\t<cntyCd>' + address.countyCode + '</cntyCd>';
            request += '\n\t\t\t\t\t<cntryCd>' + address.countryCode + '</cntryCd>';
            
            request += '\n\t\t\t\t\t<contcNm>' + address.contactName + '</contcNm>';
            request += '\n\t\t\t\t\t<contcPhnNbr>' + address.contactPhoneNumber + '</contcPhnNbr>';
            request += '\n\t\t\t\t\t<eMailAddr>' + address.contactEmailAddress + '</eMailAddr>';
            
            request += '\n\t\t\t\t\t<acctAddrUsgInfo>';
            request += '\n\t\t\t\t\t\t<primInd>' + address.isPrimaryAddress + '</primInd>';
            request += '\n\t\t\t\t\t\t<mailInd>' + address.isMailingAddress + '</mailInd>';
            request += '\n\t\t\t\t\t\t<subsidInd>' + address.isSubsidaryAddress + '</subsidInd>';
            request += '\n\t\t\t\t\t\t<billInd>' + address.isBillingAddress + '</billInd>';
            request += '\n\t\t\t\t\t\t<invcInd>' + address.isInvoiceAddress + '</invcInd>';
            request += '\n\t\t\t\t\t\t<baeInd>' + address.isBaeAddress + '</baeInd>';
            request += '\n\t\t\t\t\t\t<stlmInd>' + address.isStlmAddress + '</stlmInd>';
            request += '\n\t\t\t\t\t\t<thrdPrtyInd>' + address.isThirdPartyAddress + '</thrdPrtyInd>';
            request += '\n\t\t\t\t\t</acctAddrUsgInfo>';
            request += '\n\t\t\t\t</acctAddrInfo>';
        }
                
        for(GEMS_AccountStructureSetupServiceInput.BenefitAggrement benefitAggrement : input.benefitAggrements) { 
            
            request += '\n\t\t\t\t<benAgmtInfo>';
            request += '\n\t\t\t\t\t<baUsrDisplNbr>' + benefitAggrement.baNumber + '</baUsrDisplNbr>';
            request += '\n\t\t\t\t\t<prodTypCd>' + benefitAggrement.prodTypeCode + '</prodTypCd>';
            request += '\n\t\t\t\t\t<benAgmtDesc>' + benefitAggrement.baDescription + '</benAgmtDesc>';
            request += '\n\t\t\t\t\t<fundTypCd>' + benefitAggrement.baFundType + '</fundTypCd>';
            request += '\n\t\t\t\t\t<corpProdNbr>' + benefitAggrement.corporateProdNumber + '</corpProdNbr>';
            request += '\n\t\t\t\t\t<corpProdNm>' + benefitAggrement.corporateProdName + '</corpProdNm>';
            if(benefitAggrement.scheduleCode != null)
            	request += '\n\t\t\t\t\t<schdleCd>' + benefitAggrement.scheduleCode + '</schdleCd>';            	
            request += '\n\t\t\t\t</benAgmtInfo>';
            
        }
        
        for(GEMS_AccountStructureSetupServiceInput.Category category : input.categories) { 
            
            request += '\n\t\t\t\t<catInfo>';
            request += '\n\t\t\t\t\t<catUserDisplNbr>' + category.categoryNumber + '</catUserDisplNbr>';
            request += '\n\t\t\t\t\t<descTxt>' + category.categoryDescription + '</descTxt>';
            request += '\n\t\t\t\t\t<catCobraCd>' + category.categoryCobraCode + '</catCobraCd>';
            request += '\n\t\t\t\t\t<catUsgInfo>';
            request += '\n\t\t\t\t\t\t<prodInd>' + category.productIndicator + '</prodInd>';
            request += '\n\t\t\t\t\t\t<billInd>' + category.billingIndicator + '</billInd>';
            request += '\n\t\t\t\t\t\t<rptInd>' + category.reportingIndicator + '</rptInd>';
            request += '\n\t\t\t\t\t\t<mailInd>' + category.mailIndicator + '</mailInd>';
            request += '\n\t\t\t\t\t</catUsgInfo>';
            request += '\n\t\t\t\t</catInfo>';
            
        }
        
        for(GEMS_AccountStructureSetupServiceInput.GroupSection groupSection : input.groupSections) { 
            
            request += '\n\t\t\t\t<grpSectInfo>';
            request += '\n\t\t\t\t\t<grpUsrDisplNbr>' + groupSection.groupNumber + '</grpUsrDisplNbr>';
            request += '\n\t\t\t\t\t<sectUsrDisplNbr>' + groupSection.sectionNumber + '</sectUsrDisplNbr>';
            request += '\n\t\t\t\t\t<grpNm>' + groupSection.sectionDescription + '</grpNm>';
            
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
            
            request += '\n\t\t\t\t</grpSectInfo>';          
        }
        
        request += '\n\t\t\t</accountAutomationRequestData>';       
        request += '\n\t\t</blu:invokeAccountSetup>';
        request += '\n\t</soapenv:Body>';
        
        request += '\n</soapenv:Envelope>';
        
        //system.debug('Request XML : \n' + request);        
        return request;
    
    }
    
    public override object convertResponseToOutput(object response, map<string, string> responseHeader, FW_Service_Status serviceStatus){
    	
    	HttpResponse res = (HttpResponse) response;    	
    	string responseBody = res.getBody();   
    	
    	//serviceStatus.referenceId =  this.referenceId;
    	
    	GEMS_AccountStructureSetupServiceOutput output = new GEMS_AccountStructureSetupServiceOutput();	

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
    
     /*if(responseBody != null){
                XmlStreamReader reader = new XmlStreamReader(responseBody);
            
            while (reader.hasNext()) {
			  	if (reader.getEventType() == XmlTag.CHARACTERS) {			
			    				
			  	}			
			  	reader.next();
			}*/
			
			/*string responseBody = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:invokeAccountSetupResponse xmlns:ns2="http://www.hcsc.com/account/BluestarAccountService"><return><status>S</status><acctNbr>107002</acctNbr><accountStructureCaseID>50056000002LSbiAAG</accountStructureCaseID><corpEntCd>IL1</corpEntCd><message>ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY</message></return></ns2:invokeAccountSetupResponse></soap:Body></soap:Envelope>';
			XmlStreamReader reader = new XmlStreamReader(responseBody);
			boolean isSafeToGetNextXmlElement = true;
			while(isSafeToGetNextXmlElement) {
            // Start at the beginning of the book and make sure that it is a book
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('return' == reader.getLocalName()) {
                   
				boolean isSafeToGetNextXmlElement1 = true;
	        	while(isSafeToGetNextXmlElement) {
		            if (reader.getEventType() == XmlTag.END_ELEMENT) {
		                break;
		            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
		                string print = reader.getText();
		                system.debug('Status : ' + print);
		            }
		            // Always use hasNext() before calling next() to confirm 
		            // that we have not reached the end of the stream
		            if (reader.hasNext()) {
		                reader.next();
		            } else {
		                isSafeToGetNextXmlElement1 = false;
		                break;
		            }
		        }
		        
		        break;
	
	                }
	            }
	            // Always use hasNext() before calling next() to confirm 
	            // that we have not reached the end of the stream
	            if (reader.hasNext()) {
	                reader.next();
					//system.debug('sdfssf' + reader);
	            } else {
	                isSafeToGetNextXmlElement = false;
	                break;
	            }
        	}*/	
    
}