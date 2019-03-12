global class GEMS_AccountStructureServiceHelper {
    
    webService static string sendAccountStructure(Id accountStructureCaseID){
        
        string result;
        
        try{
                
            if(accountStructureCaseID != null){
            
                CASE accountStructureCase = [SELECT 
                                                Account.Id, Account.Name, Account.External_Id__c, Account.COBRA_Administration_Type__c, 
                                                Opportunity_Name__r.HCSC_Division__c, Market_Segment__c,
                                                Id, GEMS_Case_Effective_Date__c,
                                                Account.BillingStreet, Account.BillingState, Account.BillingCity, Account.BillingPostalCode, Account.Billing_County__c, Account.BillingCountry,
                                                    GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Request_Time__c, GEMS_Integration_Response_Time__c,
                                                    GEMS_Failed_Account_Message__c, GEMS_Failed_Addresses__c, 
                                                    GEMS_Failed_Benefit_Agreements__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                                    Status                                       
                                                    FROM CASE WHERE Id = : accountStructureCaseID];
                
                if(accountStructureCase.Status != null && accountStructureCase.Status != 'Client Approval Received'){
                    result = 'Client Approval has to be received before sending to BlueStar.';
                }
                /*else if(accountStructureCase.GEMS_Integration_Status__c != null && accountStructureCase.GEMS_Integration_Status__c == 'Initiated'){
                    result = 'The process to send the Account Structure details to BlueSTAR has already been initiated.';
                }*/
                else if(accountStructureCase.GEMS_Integration_Status__c != null && accountStructureCase.GEMS_Integration_Status__c == 'Sent'){
                    result = 'Account Structure has already been sent to BlueSTAR.';
                }
                else if(accountStructureCase.GEMS_Integration_Status__c != null && accountStructureCase.GEMS_Integration_Status__c == 'Success'){
                    result = 'Account Structure has already been created in BlueSTAR.';
                }
                else if(accountStructureCase.GEMS_Integration_Status__c != null && accountStructureCase.GEMS_Integration_Status__c == 'Partial'){
                    result = 'Account Structure has already been created partially in BlueSTAR';
                }
                else{
                    accountStructureCase.GEMS_Integration_Request_Time__c = system.now();            
                    
                    GEMS_AccountStructureSetupServiceInput input = new GEMS_AccountStructureSetupServiceInput();    
                    
                    GEMS_AccountStructureSetupServiceInput.AccountDetails accountDetails = new GEMS_AccountStructureSetupServiceInput.AccountDetails();
                    accountDetails.accountName = accountStructureCase.Account.Name;
                    
                    string accountNumber = accountStructureCase.Account.External_Id__c;
                    
                    if(accountNumber!= null){                    
                        if(accountNumber.length() > 6)
                            accountNumber = accountNumber.substring(2, accountNumber.length());                
                        accountDetails.accountNumber = accountNumber;                    
                    }
                    else{
                        result = 'Please reserve an Account Number';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                              
                    accountDetails.effectiveDate = string.valueof(date.newinstance(accountStructureCase.GEMS_Case_Effective_Date__c.year(), accountStructureCase.GEMS_Case_Effective_Date__c.month(), accountStructureCase.GEMS_Case_Effective_Date__c.day()));                
                    accountDetails.marketSegment = accountStructureCase.Market_Segment__c;
                    accountDetails.accountStructureCaseID = accountStructureCaseID;
                    accountDetails.corpCode = accountStructureCase.Opportunity_Name__r.HCSC_Division__c + '1';
                    accountDetails.cobraAutoCancel = 'N';
                    if(accountStructureCase.Account.COBRA_Administration_Type__c != null)
                        accountDetails.cobraCode = accountStructureCase.Account.COBRA_Administration_Type__c;
                    else
                        accountDetails.cobraCode = 'NA';
                                        
                    input.accountDetails = accountDetails;
                    
                    list<GEMS_AccountStructureSetupServiceInput.Address> addresses = new list<GEMS_AccountStructureSetupServiceInput.Address>();
                    GEMS_AccountStructureSetupServiceInput.Address address = new GEMS_AccountStructureSetupServiceInput.Address();    
                    address.addressSequence = 1;      
                    address.addressName = accountStructureCase.Account.Name;//accountStructureCase.Account.BillingStreet;
                    address.street = accountStructureCase.Account.BillingStreet;
                    if(address.street != null){
                        address.state = accountStructureCase.Account.BillingState;
                        address.cityName = accountStructureCase.Account.BillingCity;
                        address.zipCode = accountStructureCase.Account.BillingPostalCode;
                        address.countyCode = accountStructureCase.Account.Billing_County__c;
                        address.countryCode = accountStructureCase.Account.BillingCountry;
                    }
                    else{
                        result = 'Please capture the Account Billing Address details.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;                        
                    }
                                    
                    address.isPrimaryAddress = 'Y';
                    address.isMailingAddress = 'Y';
                    address.isSubsidaryAddress = 'N';
                    address.isBillingAddress = 'Y';
                    address.isInvoiceAddress = 'N';
                    address.isBaeAddress = 'N';
                    address.isStlmAddress = 'N';
                    address.isThirdPartyAddress = 'N';
                    
                    list<Contact> primaryContact = [SELECT Name, Phone, Email, MobilePhone
                                                        FROM CONTACT
                                                            WHERE Account.Id = : accountStructureCase.Account.Id 
                                                            and (Type__c = 'Billing' OR Type__c = 'Mailing' OR Type__c = 'Primary')];                                                        
                    
                    if(primaryContact != null && primaryContact.size() > 0){
                        if(primaryContact[0].Name != null)
                            address.contactName = primaryContact[0].Name;
                        else{
                            result = 'Please capture Contact Name details.';
                            accountStructureCase.GEMS_Integration_Message__c = result;
                            accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                            accountStructureCase.Status = 'BlueSTAR Failed';
                            update accountStructureCase;
                            return result;
                        }
                            
                        if(primaryContact[0].Phone != null && primaryContact[0].Phone.length() > 0){                            
                            string ph = primaryContact[0].Phone.Trim();
                            ph = ph.Replace('+', '');
                            ph = ph.Replace('(', '');
                            ph = ph.Replace(')', '');
                            ph = ph.Replace('.', '');
                            ph = ph.Replace('-', '');
                            ph = ph.Replace(' ', '');
                            if(ph != null && ph.length() > 10)
                                ph = ph.substring(1, ph.length());
                            address.contactPhoneNumber = ph;
                        }
                        else if(primaryContact[0].MobilePhone != null && primaryContact[0].MobilePhone.length() > 0){               
                string ph = primaryContact[0].MobilePhone.Trim();
                ph = ph.Replace('+', '');
                ph = ph.Replace('(', '');
                ph = ph.Replace(')', '');
                ph = ph.Replace('.', '');
                ph = ph.Replace('-', '');
                ph = ph.Replace(' ', '');
                if(ph != null && ph.length() > 10)
                ph = ph.substring(1, ph.length());
                address.contactPhoneNumber = ph;
                        }
                        else{
                            result = 'Please capture Contact Phone Number details.';
                            accountStructureCase.GEMS_Integration_Message__c = result;
                            accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                            accountStructureCase.Status = 'BlueSTAR Failed';
                            update accountStructureCase;
                            return result;                            
                        }
                            
                        if(primaryContact[0].Email != null)                  
                            address.contactEmailAddress = primaryContact[0].Email;
                        else{
                            result = 'Please capture Contact Email Address details.';
                            accountStructureCase.GEMS_Integration_Message__c = result;
                            accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                            accountStructureCase.Status = 'BlueSTAR Failed';
                            update accountStructureCase;
                            return result;
                        }
                    }
                    else{
                        result = 'Please capture Account Billing/Mailing/Primary Contact details.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    
                    addresses.add(address);
                    
                    input.addresses = addresses;
                    
                    list<GEMS_Benefit_Agreement__c> bas = [SELECT Name, BA_Description__c, BA_Fund_Type__c, Product_Name__c, Product_Number__c, Product_Type__c, Schedule__c
                                                                FROM GEMS_Benefit_Agreement__c
                                                                    WHERE AccountStructureCase__r.Id = : accountStructureCaseID];
                                                                    
                    list<GEMS_AccountStructureSetupServiceInput.BenefitAggrement> benefitAggrements = new list<GEMS_AccountStructureSetupServiceInput.BenefitAggrement>();
                    for(GEMS_Benefit_Agreement__c ba : bas){
                        GEMS_AccountStructureSetupServiceInput.BenefitAggrement benefitAggrement = new GEMS_AccountStructureSetupServiceInput.BenefitAggrement();   
                        benefitAggrement.baNumber = ba.Name;                    
                        
                        benefitAggrement.prodTypeCode = ba.Product_Type__c;                 
                        benefitAggrement.corporateProdNumber = String.ValueOf(ba.Product_Number__c);
                        benefitAggrement.corporateProdName = ba.Product_Name__c;    
                        
                        benefitAggrement.baDescription = ba.BA_Description__c;                  
                           
                        benefitAggrement.baFundType = ba.BA_Fund_Type__c;   
                        benefitAggrement.scheduleCode = ba.Schedule__c;
                        
                        if(benefitAggrement.scheduleCode == null && accountDetails.corpCode == 'TX1'){
                            result = 'Please capture the Schedule Code details for each BA.';
                            accountStructureCase.GEMS_Integration_Message__c = result;
                            accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                            accountStructureCase.Status = 'BlueSTAR Failed';
                            update accountStructureCase;
                            return result;
                        }
                        
                        benefitAggrements.add(benefitAggrement);
                    }
                    input.benefitAggrements = benefitAggrements;  
                    
                    if(input.benefitAggrements != null && !(input.benefitAggrements.size() >= 1)){    
                        result = 'Please capture the Benefit Aggrement details';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    
                    list<GEMS_Category__c> cats = [SELECT Name, Category_Description__c, Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c,
                                                            Category_Cobra_Code__c
                                                                FROM GEMS_Category__c
                                                                    WHERE Case__r.Id = : accountStructureCaseID
                                                                        AND (Usage_Billing__c = true OR Usage_Reporting__c = true)];
                    
                    list<GEMS_AccountStructureSetupServiceInput.Category> categories = new list<GEMS_AccountStructureSetupServiceInput.Category>();
                    for(GEMS_Category__c cat : cats){
                        GEMS_AccountStructureSetupServiceInput.Category category = new GEMS_AccountStructureSetupServiceInput.Category();
                        category.categoryNumber = cat.Name;
                        category.categoryDescription = cat.Category_Description__c; 
                        if(cat.Category_Cobra_Code__c != null)
                            category.categoryCobraCode = cat.Category_Cobra_Code__c; 
                        else
                            category.categoryCobraCode = 'NC';
                        category.productIndicator = 'N';//cat.Usage_Product__c == true ? 'Y': 'N';
                        category.billingIndicator = cat.Usage_Billing__c == true ? 'Y': 'N';
                        category.reportingIndicator = cat.Usage_Reporting__c == true ? 'Y': 'N';
                        category.mailIndicator = 'N';//cat.Usage_Mailing__c == true ? 'Y': 'N';                    
                        categories.add(category);
                    }
                    input.categories = categories;
                    
                    if(input.categories != null && !(input.categories.size() >= 1)){   
                        result = 'Please capture the category details';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    
                    list<GEMS_Group_Section__c> gss = [SELECT Group_No__c, Section_No__c, Section_Description__c,
                                                                    (SELECT Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c
                                                                        FROM GS_Assignments__r),
                                                                    (SELECT Category__r.Name, Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c
                                                                        FROM Category_Assignments__r WHERE Category__r.Usage_Billing__c = true OR Category__r.Usage_Reporting__c = true) catAssignments
                                                            FROM GEMS_Group_Section__c
                                                                WHERE Case__r.Id = : accountStructureCaseID];                                                       
                    
                    list<GEMS_AccountStructureSetupServiceInput.GroupSection> groupSections = new list<GEMS_AccountStructureSetupServiceInput.GroupSection>();
                    for(GEMS_Group_Section__c gs : gss){
                        GEMS_AccountStructureSetupServiceInput.GroupSection groupSection = new GEMS_AccountStructureSetupServiceInput.GroupSection();
                        groupSection.groupNumber = gs.Group_No__c;      
                        groupSection.sectionNumber = gs.Section_No__c;
                        groupSection.sectionDescription = gs.Section_Description__c;
                                        
                        groupSection.assignedBANumbers = new list<string>();
                        for(GEMS_BA_Assignment__c b : gs.GS_Assignments__r){
                            groupSection.assignedBANumbers.add(b.Benefit_Agreement__r.Name);
                        }
                        
                        groupSection.assignedCategoryNumbers = new list<string>();
                        groupSection.assignedCategoryNumbers.add('0000');
                        for(GEMS_Category_Assignment__c c : gs.Category_Assignments__r){
                            groupSection.assignedCategoryNumbers.add(c.Category__r.Name);
                        }               
                        groupSections.add(groupSection);
                    }
                    input.groupSections = groupSections;
                    
                    if(input.groupSections != null && !(input.groupSections.size() >= 1)){  
                        result = 'Please capture the account structure details with group sections.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                                
                    FW_Service s = new FW_Service('GEMS_Account_Structure_Setup');      
                    GEMS_AccountStructureSetupServiceOutput output = (GEMS_AccountStructureSetupServiceOutput) s.callout(input);
                    
                    if(output.status == 'S'){            
                        accountStructureCase.GEMS_Integration_Status__c = 'Sent';    
                        accountStructureCase.GEMS_Integration_Response_Time__c = null;               
                        result = 'Account Structure details has been sent to BlueSTAR successfully.';
                        accountStructureCase.Status = 'BlueSTAR Sent';
                    }
                    else{
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.GEMS_Integration_Response_Time__c = system.now();
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        if(output.status == 'I')
                            result = 'System failed to send the Account Structure details to BlueSTAR.';                        
                        else{
                            result = output.message;
                            if(result == null)
                                result = 'BlueSTAR failed to create Account Structure. Please contact System Admin.';
                            //accountStructureCase.GEMS_Integration_Message__c = output.message;                                              
                        }                   
                    }
                    accountStructureCase.GEMS_Integration_Message__c = result;
                    accountStructureCase.GEMS_Failed_Addresses__c = null;
                    accountStructureCase.GEMS_Failed_Benefit_Agreements__c = null;
                    accountStructureCase.GEMS_Failed_Categories__c = null;
                    accountStructureCase.GEMS_Failed_Group_Sections__c = null;
                    accountStructureCase.GEMS_Failed_Account_Message__c = null;
                    
                    update accountStructureCase;
                }
            }
        
        }
        catch(Exception ex){
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
        
        return result;
        
    }
    
    @InvocableMethod
    public static void sendAccountStructure(List<Id> caseIds)
    {
        sendAccountStructureInFuture(caseIds);
    }
    
    @future (callout=true)
    public static void sendAccountStructureInFuture(List<Id> caseIds){
        for(id caseId : caseIds){
            string result = sendAccountStructure(caseId);
        }
    }
    
}