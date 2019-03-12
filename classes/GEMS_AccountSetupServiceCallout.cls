// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 07/10/2017       Ketki J             SFDC 3641 and 4900. Added <descUpdateFlag> Node at BA, Category, GS and BP
// 07/21/2017       Shankar             SFDC 4890, 4893. Added <changeReasonCd> node at BA, Category & GS
// 07/22/2017       Lakshmi             SFDC 5025,4894. Added <changeReasonCd> node at BA, Category & BP
// 08/04/2017       Shankar             SFDC 4890, 4893. Changed logic to add <changeReasonCd> for BA, Category & GS
// 10/26/2017       Shankar             SFDC-7140. Add ADD changeReasonCd at account level for New sale scenario
// 5/10/2018        Gokul               SFDC-4912 GEMS: BlueSTAR - Transfer Updated Characteristic Value Descriptions from GEMS to B*.
// ************************************************************************************

public without sharing class GEMS_AccountSetupServiceCallout extends FW_ServiceIO_REST {
    
    map<string, string> requestHeader;
    //string referenceId;
    
    private virtual void setCustomHeaderValues(map<string, string> requestHeader){
        this.requestHeader = requestHeader;
        System.Debug('requestHeader - '+ requestHeader);
    }
    
    public object convertInputToRequest(){    
        
        GEMS_AccountSetupServiceInput input = (GEMS_AccountSetupServiceInput) serviceInput;
        
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
        request += '\n\t\t<blu:invokeAccountSetup>';
        request += '\n\t\t\t<accountAutomationRequestData>';
        
        if(input.accountDetails.accountName != null)        
            request += '\n\t\t\t\t<acctNm>' + input.accountDetails.accountName + '</acctNm>';
        else
            request += '\n\t\t\t\t<acctNm/>';
        request += '\n\t\t\t\t<acctNbr>' + input.accountDetails.accountNumber + '</acctNbr>';
        request += '\n\t\t\t\t<acctEffDt>' + input.accountDetails.effectiveDate + '</acctEffDt>';  
        if(input.accountDetails.marketSegment != null)
            request += '\n\t\t\t\t<mktSegCd>' + input.accountDetails.marketSegment + '</mktSegCd>';     
        else
            request += '\n\t\t\t\t<mktSegCd/>';
        request += '\n\t\t\t\t<accountStructureCaseID>' + input.accountDetails.accountStructureCaseID + '</accountStructureCaseID>';
        request += '\n\t\t\t\t<corpEntCd>' + input.accountDetails.corpCode + '</corpEntCd>';
        //SFDC-8477 - Start transmitting GEMS as system source code to BlueStar.
        request += '\n\t\t\t\t<sourceSystemCd>GEMS</sourceSystemCd>';  
        request += '\n\t\t\t\t<einNbrPrimary></einNbrPrimary>';  
        request += '\n\t\t\t\t<mltpEinInd></mltpEinInd>';   
        if(input.accountDetails.cobraAutoCancel != null)
            request += '\n\t\t\t\t<cobraAutoCanInd>' + input.accountDetails.cobraAutoCancel + '</cobraAutoCanInd>';
        else
            request += '\n\t\t\t\t<cobraAutoCanInd/>';
        if(input.accountDetails.cobraCode != null)
            request += '\n\t\t\t\t<cobraCd>' + input.accountDetails.cobraCode + '</cobraCd>';  
        else
            request += '\n\t\t\t\t<cobraCd/>';
        if(input.accountDetails.autoCatInd != null)
            request += '\n\t\t\t\t<autoCatInd>' + input.accountDetails.autoCatInd + '</autoCatInd>';
        else
            request += '\n\t\t\t\t<autoCatInd/>';
        
        // SFDC-7140. Add "ADD" Change Reason Code for new accounts
        if(input.accountDetails.changeReasonCode != null)
            request += '\n\t\t\t\t<changeReasonCd>' + input.accountDetails.changeReasonCode + '</changeReasonCd>';        
        // SFDC-7140 end
        
        //1 or more repetitions:        
        for(GEMS_AccountSetupServiceInput.Address address : input.addresses) {
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
        
        if(input.characteristics != null && input.characteristics.size() > 0){
            for(GEMS_AccountSetupServiceInput.Characteristic characteristic : input.characteristics) {
                request += '\n\t\t\t\t<chrInfo>';
                request += '\n\t\t\t\t\t<chrCd>' + characteristic.characteristicCode + '</chrCd>';
                if(characteristic.mandatoryGroupIndicator != null)
                    request += '\n\t\t\t\t\t<mandGrpInd>' + characteristic.mandatoryGroupIndicator + '</mandGrpInd>';
                
                request += '\n\t\t\t\t\t<chrUsgInfo>';
                request += '\n\t\t\t\t\t\t<prodInd>' + characteristic.productIndicator + '</prodInd>';
                request += '\n\t\t\t\t\t\t<billInd>' + characteristic.billingIndicator + '</billInd>';
                request += '\n\t\t\t\t\t\t<rptInd>' + characteristic.reportingIndicator + '</rptInd>';
                request += '\n\t\t\t\t\t\t<mailInd>' + characteristic.mailIndicator + '</mailInd>';
                request += '\n\t\t\t\t\t\t<othrInd>' + characteristic.otherIndicator + '</othrInd>';
                request += '\n\t\t\t\t\t</chrUsgInfo>';
                
                for(GEMS_AccountSetupServiceInput.CharacteristicValue characteristicValue : characteristic.characteristicValues) {
                    request += '\n\t\t\t\t\t<chrValInfo>';
                    request += '\n\t\t\t\t\t\t<eqStringVal>' + characteristicValue.value + '</eqStringVal>';
                    request += '\n\t\t\t\t\t\t<chrValCd>' + characteristicValue.valueCode + '</chrValCd>';
                    //SFDC-4912
                    if(null != characteristicValue.changeReasonCode){
                       request += '\n\t\t\t\t\t\t<changeReasonCd>' + characteristicValue.changeReasonCode + '</changeReasonCd>'; 
                    } 
                    //SFDC-4912                      
                    request += '\n\t\t\t\t\t</chrValInfo>';
                }
                
                request += '\n\t\t\t\t</chrInfo>';
            }
        }
        
        for(GEMS_AccountSetupServiceInput.BenefitAggrement benefitAggrement : input.benefitAggrements) { 
            
            request += '\n\t\t\t\t<benAgmtInfo>';
            request += '\n\t\t\t\t\t<baUsrDisplNbr>' + benefitAggrement.baNumber + '</baUsrDisplNbr>';
            request += '\n\t\t\t\t\t<prodTypCd>' + benefitAggrement.prodTypeCode + '</prodTypCd>';
            request += '\n\t\t\t\t\t<benAgmtDesc>' + benefitAggrement.baDescription + '</benAgmtDesc>';
            request += '\n\t\t\t\t\t<fundTypCd>' + benefitAggrement.baFundType + '</fundTypCd>';
            request += '\n\t\t\t\t\t<corpProdNbr>' + benefitAggrement.corporateProdNumber + '</corpProdNbr>';
            request += '\n\t\t\t\t\t<corpProdNm>' + benefitAggrement.corporateProdName + '</corpProdNm>';
            if (benefitAggrement.IsDescUpdate == 'Y')
                request += '\n\t\t\t\t\t<descUpdateFlag>' + benefitAggrement.IsDescUpdate + '</descUpdateFlag>';
            if(benefitAggrement.scheduleCode != null)
                request += '\n\t\t\t\t\t<schdleCd>' + benefitAggrement.scheduleCode + '</schdleCd>';  
            
            if(null != benefitAggrement.changeReasonCode) {
                request += '\n\t\t\t\t\t<changeReasonCd>' + benefitAggrement.changeReasonCode + '</changeReasonCd>';
            }              
            request += '\n\t\t\t\t</benAgmtInfo>';
            
        }
        
        for(GEMS_AccountSetupServiceInput.Category category : input.categories) { 
            
            request += '\n\t\t\t\t<catInfo>';
            request += '\n\t\t\t\t\t<catUserDisplNbr>' + category.categoryNumber + '</catUserDisplNbr>';
            request += '\n\t\t\t\t\t<descTxt>' + category.categoryDescription + '</descTxt>';
            request += '\n\t\t\t\t\t<catCobraCd>' + category.categoryCobraCode + '</catCobraCd>';
            if (category.IsDescUpdate == 'Y') {
                request += '\n\t\t\t\t\t<descUpdateFlag>' + category.IsDescUpdate + '</descUpdateFlag>';
            }
            if(category.mailAddrSeqNbr != null)
                request += '\n\t\t\t\t\t<acctAddrSeqNbr>' + category.mailAddrSeqNbr + '</acctAddrSeqNbr>';
            if(category.changeReasonCode != null) {
                request += '\n\t\t\t\t\t<changeReasonCd>' + category.changeReasonCode + '</changeReasonCd>';
            } 
            if(category.memDrvdTypCd != null)
                request += '\n\t\t\t\t\t<memDrvdTypCd>' + category.memDrvdTypCd + '</memDrvdTypCd>';
            
            request += '\n\t\t\t\t\t<catUsgInfo>';
            request += '\n\t\t\t\t\t\t<prodInd>' + category.productIndicator + '</prodInd>';
            request += '\n\t\t\t\t\t\t<billInd>' + category.billingIndicator + '</billInd>';
            request += '\n\t\t\t\t\t\t<rptInd>' + category.reportingIndicator + '</rptInd>';
            request += '\n\t\t\t\t\t\t<mailInd>' + category.mailIndicator + '</mailInd>';
            request += '\n\t\t\t\t\t</catUsgInfo>';
            
            if(category.associatedBANumbers != null){
                for(string associatedBANumber : category.associatedBANumbers) {
                    request += '\n\t\t\t\t\t<benAgmtAssignmentInfo>';
                    request += '\n\t\t\t\t\t\t<baUsrDisplNbr>' + associatedBANumber + '</baUsrDisplNbr>';                         
                    request += '\n\t\t\t\t\t</benAgmtAssignmentInfo>';
                }
            }
            
            if(category.categoryCharacteristics != null && category.categoryCharacteristics.size() > 0){
                for(GEMS_AccountSetupServiceInput.CategoryCharacteristic categoryCharacteristic : category.categoryCharacteristics) {
                    request += '\n\t\t\t\t\t<chrAssignmentInfo>';
                    request += '\n\t\t\t\t\t\t<chrCd>' + categoryCharacteristic.characteristicCode + '</chrCd>'; 
                    for(string valueCode : categoryCharacteristic.valueCodes){
                        request += '\n\t\t\t\t\t\t<chrValAssignmentInfo>';  
                        request += '\n\t\t\t\t\t\t\t<chrValCd>' + valueCode + '</chrValCd>';
                        request += '\n\t\t\t\t\t\t</chrValAssignmentInfo>';  
                    }
                    request += '\n\t\t\t\t\t</chrAssignmentInfo>';
                }
            }

            request += '\n\t\t\t\t</catInfo>';            
        }
        
        for(GEMS_AccountSetupServiceInput.GroupSection groupSection : input.groupSections) { 
            
            request += '\n\t\t\t\t<grpSectInfo>';
            request += '\n\t\t\t\t\t<grpUsrDisplNbr>' + groupSection.groupNumber + '</grpUsrDisplNbr>';
            request += '\n\t\t\t\t\t<sectUsrDisplNbr>' + groupSection.sectionNumber + '</sectUsrDisplNbr>';
            request += '\n\t\t\t\t\t<grpNm>' + groupSection.sectionDescription + '</grpNm>';
            if (null != groupSection.changeReasonCode) {
                 request += '\n\t\t\t\t\t<changeReasonCd>' + groupSection.changeReasonCode + '</changeReasonCd>';
            }
            if (groupSection.IsDescUpdate == 'Y') {
                request += '\n\t\t\t\t\t<descUpdateFlag>' + groupSection.IsDescUpdate + '</descUpdateFlag>';
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
        
        //Billing Profile
        for(GEMS_AccountSetupServiceInput.BillingProfile billingProfile : input.billingProfiles) { 
            
            request += '\n\t\t\t\t<billProfInfo>';
            if(billingProfile.billingProfileNumber != null)
                request += '\n\t\t\t\t\t<billProfNbr>' + billingProfile.billingProfileNumber + '</billProfNbr>';
            request += '\n\t\t\t\t\t<billProfDesc>' + billingProfile.description + '</billProfDesc>';
            if (null != billingProfile.changeReasonCode) {
                 request += '\n\t\t\t\t\t<changeReasonCd>' + billingProfile.changeReasonCode + '</changeReasonCd>';
            }
            //added to update DescUpdateFlag  if Description is changed.      
            if (billingProfile.IsDescUpdate == 'Y') {
                request += '\n\t\t\t\t\t<descUpdateFlag>' + billingProfile.IsDescUpdate + '</descUpdateFlag>';   
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
        
        GEMS_AccountSetupServiceOutput output = new GEMS_AccountSetupServiceOutput(); 

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
    
}