//************************************************************************************
// Name             : GEMS_AccountSetupServiceHelper.cls
// Description      : Helper Class for sending Salesforce data to BlueStar
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 07/10/2017        Ketki J             SFDC 3641 and 4900. Set IsDescUpdate flags for BA, Category, GS and BP
// 07/10/2017        Lakshmi             SFDC 5025 and 4894. Set changeReasonCode values for BA,Category and BillProfile
// 07/21/2017        Shankar             SFDC 4890, 4893. Changes to set changeReasonCode values for BA, Category and group section
// 08/04/2017        Shankar             SFDC 4890, 4893. Changes in logic to set changeReasonCode for BA, Cat & GS as per new requirements
// 08/07/2017        Shankar             SFDC 5025, 4894. Changes in logic to set changeReasonCode for BA, Cat & BP as per new requirements
// 08/17/2017        Shankar             SFDC 4890, 4893, 5025, 4894. Changes in logic to set REN changeReasonCode for existing BA, Cat & BP as per new requirements for renewal scenario
// 08/23/2017        Shankar             SFDC 4890, 4893, 5025, 4894. Changes to include ADD changeReasoncode for new BP & GS for New Account scenario. Moved 'ADD' logic for categories outside BA-Cat assignment iteration
// 08/24/2017        Shankar             SFDC 4890, 4893, 5025, 4894. Changes to remove changeReasoncode for existing Cat for offcycle & renewal
// 08/28/2017        Shankar             SFDC 4890, 4893, 5025, 4894. Reverted the changes to include 'REN' changeReasonCode for existing Cat for offcycle & Renewal
// 09/10/2017        Harsha              Changes made for UAT Defect/Additional Scenarios for BlueStar change reason codes
// 10/10/2017        Shankar             Changes for code clean up across environments 
// 10/20/2017        Shankar             SFDC-6718. Description update production bug fix
// 10/26/2017        Shankar             SFDC-7140. Add ADD changeReasonCd at account level
// 10/26/2017        Shankar             SFDC 7146. Added additional scenarios for Existing BAs
// 05/10/2018        Gokul               SFDC-4912 GEMS: BlueSTAR - Transfer Updated Characteristic Value Descriptions from GEMS to B*.
// ************************************************************************************


global class GEMS_AccountSetupServiceHelper {
    
    webService static string validateAccountStructure(Id accountStructureCaseID){
        return GEMS_AccountSetupHelper.validateAccountStructure(accountStructureCaseID);
    }
    
    webService static string sendAccountStructure(Id accountStructureCaseID){
        
        string result;
        
        try{
            
            if(accountStructureCaseID != null){
                
                CASE accountStructureCase = [SELECT 
                                             Account.Id, Account.Name, Account.External_Id__c, Account.COBRA_Administration_Type__c, 
                                             Opportunity_Name__r.HCSC_Division__c, Market_Segment__c,
                                             Id, GEMS_Case_Effective_Date__c, HCSC_Division__c,                                                
                                             GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Request_Time__c, GEMS_Integration_Response_Time__c,
                                             GEMS_Failed_Account_Message__c, GEMS_Failed_Addresses__c, 
                                             GEMS_Failed_Benefit_Agreements__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                             Status, GEMS_Submission_Type__c, GEMS_Is_Account_Derivated__c, GEMS_Cobra_Auto_Can_Ind__c                          
                                             FROM CASE WHERE Id = : accountStructureCaseID];
                
                if(accountStructureCase.Status != null && accountStructureCase.Status != 'Client Approval Received'){
                    result = 'Client Approval has to be received before sending to BlueStar.';
                }                
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
                     
                    Set<string> catUsages = new Set<string>();
                    Set<string> addrSequences = new Set<string>();
                    
                    GEMS_AccountSetupServiceInput input = new GEMS_AccountSetupServiceInput();  

                    
                    GEMS_AccountSetupServiceInput.AccountDetails accountDetails = new GEMS_AccountSetupServiceInput.AccountDetails();
                    
                    string accountNumber = accountStructureCase.Account.External_Id__c;                    
                    if(accountNumber!= null){                    
                        if(accountNumber.length() > 6)
                            accountNumber = accountNumber.substring(2, accountNumber.length());                
                        accountDetails.accountNumber = accountNumber;                    
                    }
                    
                    // SFDC-7140. Add "ADD" changeReasonCd at account level for New Account scenario
                    if (accountStructureCase.GEMS_Submission_Type__c=='New Account') {
                        accountDetails.changeReasonCode = 'ADD';
                    }
                    // SFDC-7140 end
                    
                    accountDetails.effectiveDate = string.valueof(date.newinstance(accountStructureCase.GEMS_Case_Effective_Date__c.year(), accountStructureCase.GEMS_Case_Effective_Date__c.month(), accountStructureCase.GEMS_Case_Effective_Date__c.day()));                
                    //accountDetails.corpCode = accountStructureCase.Opportunity_Name__r.HCSC_Division__c + '1';
                    accountDetails.corpCode = accountStructureCase.HCSC_Division__c + '1';
                    accountDetails.accountStructureCaseID = accountStructureCaseID;                    
                    accountDetails.accountName = accountStructureCase.Account.Name.escapeXML();
                    accountDetails.marketSegment = accountStructureCase.Market_Segment__c; 
                    accountDetails.cobraAutoCancel = accountStructureCase.GEMS_Cobra_Auto_Can_Ind__c == true ? 'Y': 'N';
                    if(accountStructureCase.Account.COBRA_Administration_Type__c != null)
                        accountDetails.cobraCode = accountStructureCase.Account.COBRA_Administration_Type__c;
                    else
                        accountDetails.cobraCode = 'NA';
                    accountDetails.autoCatInd = accountStructureCase.GEMS_Is_Account_Derivated__c == true ? 'Y': 'N';
                    
                    input.accountDetails = accountDetails;
                    
                    list<GEMS_Address__c> gemsPrimaryAddresses = [SELECT Address_Sequence__c                                                            
                                                                  FROM GEMS_Address__c
                                                                  WHERE Account__c = : accountStructureCase.Account.Id 
                                                                  AND Usage__c INCLUDES ('Primary')];
                    
                    if(gemsPrimaryAddresses != null && gemsPrimaryAddresses.size() > 0 && gemsPrimaryAddresses[0].Address_Sequence__c != null){
                        addrSequences.add(gemsPrimaryAddresses[0].Address_Sequence__c);
                    }
                    else{
                        result = 'Please capture the Account Primary Address details.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    
                    list<Id> baIds = new list<id>();
                    list<GEMS_Benefit_Agreement__c> bas = [SELECT IsNew__c, Name, Product__r.ProductCode, BA_Description__c, BA_Fund_Type__c, Product_Name__c, Product_Number__c, Product_Type__c, Schedule__c,IsDescUpdate__c
                                                           FROM GEMS_Benefit_Agreement__c
                                                           WHERE AccountStructureCase__r.Id = : accountStructureCaseID
                                                           // SFDC-7146. Removed AND (IsNew__c = true or IsDescUpdate__c = true) criteria below to include existing BAs as well in B* request

                                                           // Added to avoid sending cancelled BA's with
                                                           // updated description field
                                                           AND IsCancelled__c != true];
                    
                    list<GEMS_AccountSetupServiceInput.BenefitAggrement> benefitAggrements = new list<GEMS_AccountSetupServiceInput.BenefitAggrement>();
                    set<string> premBAs = new set<string>();
                    for(GEMS_Benefit_Agreement__c ba : bas){
                        // SFDC-7146. Existing BA scenarios. Avoid sending baInfo for existing BAs
                        if (!ba.IsNew__c && !ba.IsDescUpdate__c) {
                            continue;
                        }
                        // SFDC-7146 End.
                        GEMS_AccountSetupServiceInput.BenefitAggrement benefitAggrement = new GEMS_AccountSetupServiceInput.BenefitAggrement();   
                        benefitAggrement.baNumber = ba.Name;
                        benefitAggrement.prodTypeCode = ba.Product_Type__c;                 
                        benefitAggrement.corporateProdNumber = String.ValueOf(ba.Product_Number__c);
                        benefitAggrement.corporateProdName = ba.Product_Name__c;    
                        
                        benefitAggrement.baDescription = ba.BA_Description__c;   
                        benefitAggrement.IsDescUpdate = ba.IsDescUpdate__c == true ? 'Y': 'N';
                        if(benefitAggrement.baDescription != null)
                            benefitAggrement.baDescription = benefitAggrement.baDescription.escapeXML();
                        
                        benefitAggrement.baFundType = ba.BA_Fund_Type__c;   
                        // SFDC-7146. Add only new BA's to premBAs list used for BP validation later
                        if(benefitAggrement.baFundType != null && benefitAggrement.baFundType == 'PREM' && ba.IsNew__c)
                            premBAs.add(benefitAggrement.baNumber);
                        
                        benefitAggrement.scheduleCode = ba.Schedule__c;
                        
                        if(benefitAggrement.scheduleCode == null && accountDetails.corpCode == 'TX1'){
                            result = 'Please capture the Schedule Code details for each new BA. BA#' + benefitAggrement.baNumber;
                            accountStructureCase.GEMS_Integration_Message__c = result;
                            accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                            accountStructureCase.Status = 'BlueSTAR Failed';
                            update accountStructureCase;
                            return result;
                        }
                        benefitAggrement.isNew = ba.isNew__c;
                        // SFDC 4890, 4893, 4894, 5025. Set 'ADD' as BA's changeReasonCode if it's a new BA
                        if (benefitAggrement.isNew) {
                            benefitAggrement.changeReasonCode = 'ADD';
                        }
                        
                        benefitAggrements.add(benefitAggrement);
                        // SFDC-7146. Collect Ids of new BA's (since the criteria was removed in the SOQL query above
                        if (ba.IsNew__c)
                            baIds.add(ba.Id);
                        // SFDC-7146 End
                    }
                    input.benefitAggrements = benefitAggrements;  
                    
                    if(accountStructureCase.GEMS_Submission_Type__c == 'New Account' && input.benefitAggrements != null && !(input.benefitAggrements.size() >= 1)){    
                        result = 'Please capture the Benefit Aggrement details.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    //SFDC-4912                    
                    list<GEMS_Characteristic__c> chars = [SELECT Characteristic_Code__c, Corp_Characteristic_Code__r.Name, 
                                                          Name, Mandatory__c,
                                                          Billing__c, Reporting__c, Mailing__c, Product__c, Other__c,
                                                          (SELECT Name,Code__c,IsUpdated__c,isNew__c,Effective_Date__c,Case__r.GEMS_Submission_Type__c 
                                                           FROM GEMS_Characteristic_Values__r
                                                           WHERE IsNew__c = true OR IsUpdated__c = true)                                                                    
                                                           FROM GEMS_Characteristic__c
                                                           WHERE Case__r.Id = : accountStructureCaseID
                                                           AND (IsNew__c = true OR IsUpdated__c = true)];
                    //SFDC-4912                    
                    list<GEMS_AccountSetupServiceInput.Characteristic> characteristics = new list<GEMS_AccountSetupServiceInput.Characteristic>();
                    for(GEMS_Characteristic__c charr : chars){
                        GEMS_AccountSetupServiceInput.Characteristic characteristic = new GEMS_AccountSetupServiceInput.Characteristic();
                        characteristic.characteristicCode = charr.Characteristic_Code__c;      
                        characteristic.characteristicDescription = charr.Corp_Characteristic_Code__r.Name;
                        
                        characteristic.mandatoryGroupIndicator = charr.Mandatory__c == true ? 'Y': null;
                        
                        characteristic.billingIndicator = charr.Billing__c == true ? 'Y': 'N';
                        characteristic.reportingIndicator = charr.Reporting__c == true ? 'Y': 'N';
                        characteristic.productIndicator = charr.Product__c == true ? 'Y': 'N';
                        characteristic.mailIndicator = charr.Mailing__c == true ? 'Y': 'N';
                        characteristic.otherIndicator = charr.Other__c == true ? 'Y': 'N';
                        
                        characteristic.characteristicValues = new list<GEMS_AccountSetupServiceInput.CharacteristicValue>();
                        for(GEMS_Characteristic_Value__c c : charr.GEMS_Characteristic_Values__r){
                            GEMS_AccountSetupServiceInput.CharacteristicValue characteristicValue = new GEMS_AccountSetupServiceInput.CharacteristicValue();
                            characteristicValue.valueCode = c.Code__c;
                            if(c.Name != null){
                                characteristicValue.value = c.Name.escapeXML();
                                //SFDC-4912 
                                if(c.isNew__c)
                                characteristicValue.changeReasonCode = 'ADD';
                                else if(!c.isNew__c && c.IsUpdated__c && (c.Case__r.GEMS_Submission_Type__c == 'Off Cycle' || c.Case__r.GEMS_Submission_Type__c == 'Renewal'))
                                characteristicValue.changeReasonCode = 'ERR'; 
                                //SFDC-4912    
                            }                         
                            characteristic.characteristicValues.add(characteristicValue);
                        }
                        characteristics.add(characteristic);
                    }
                    input.characteristics = characteristics;
                    
                    set<id> prodCatIds = new set<Id>();
                    if(!baIds.isEmpty()){
                        list<GEMS_BA_Category_Assignment__c> prodCats = [SELECT Id, Benefit_Agreement__c, Category__c 
                                                                         FROM GEMS_BA_Category_Assignment__c
                                                                         WHERE Benefit_Agreement__c IN : baIds
                                                                         AND Category__r.Usage_Product__c = true];
                        if(!prodCats.isEmpty()){
                            for(GEMS_BA_Category_Assignment__c baCat : prodCats){
                                prodCatIds.add(baCat.Category__c);
                            }
                        }
                    }
                    System.debug('prodCatIds::'+prodCatIds);
                    list<GEMS_Category__c> cats = [SELECT Id, Name, Category_Description__c, Category_Cobra_Code__c,
                                                   Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c,                                                            
                                                   Mailing_Address__c, Mailing_Address__r.Address_Sequence__c, IsNew__c, IsUpdated__c, IsCancelled__c,
                                                   
                                                   Members_Derivation_Type__c,IsDescUpdate__c,
                                                   (SELECT Characteristic_Value__r.Code__c, Characteristic_Value__r.Name,
                                                    Characteristic_Value__r.Characteristic__r.Characteristic_Code__c, Characteristic_Value__r.IsNew__c
                                                    FROM GEMS_Category_Characteristic_Association__r),
                                                   
                                                   (SELECT Benefit_Agreement__r.Name
                                                    FROM Category_BA_Assignments__r)
                                                   
                                                   FROM GEMS_Category__c
                                                   WHERE Case__r.Id = : accountStructureCaseID
                                                   AND IsCancelled__c = false];
                    Map<String, GEMS_AccountSetupServiceInput.Category>  idInputCatMap = new Map<String, GEMS_AccountSetupServiceInput.Category>();
                    list<GEMS_AccountSetupServiceInput.Category> categories = new list<GEMS_AccountSetupServiceInput.Category>();
                    for(GEMS_Category__c cat : cats){
                        
                        if(cat.Usage_Product__c == true && !catUsages.contains('Product'))
                            catUsages.add('Product');
                        if(cat.Usage_Billing__c == true && !catUsages.contains('Billing'))
                            catUsages.add('Billing');
                        if(cat.Usage_Reporting__c == true && !catUsages.contains('Reporting'))
                            catUsages.add('Reporting');
                        if(cat.Usage_Mailing__c == true && !catUsages.contains('Mailing'))
                            catUsages.add('Mailing');
                        
                        if(cat.IsNew__c == true || cat.IsUpdated__c == true||cat.IsDescUpdate__c == true || prodCatIds.contains(cat.Id)){
                            GEMS_AccountSetupServiceInput.Category category = new GEMS_AccountSetupServiceInput.Category();
                            category.categoryNumber = cat.Name;
                            category.categoryDescription = cat.Category_Description__c; 
                            category.IsDescUpdate = cat.IsDescUpdate__c == true ? 'Y': 'N';
                            if(category.categoryDescription != null)
                                category.categoryDescription = category.categoryDescription.escapeXML();
                            if(cat.Category_Cobra_Code__c != null)
                                category.categoryCobraCode = cat.Category_Cobra_Code__c; 
                            else
                                category.categoryCobraCode = 'NC';
                            category.productIndicator = cat.Usage_Product__c == true ? 'Y': 'N';
                            category.billingIndicator = cat.Usage_Billing__c == true ? 'Y': 'N';
                            category.reportingIndicator = cat.Usage_Reporting__c == true ? 'Y': 'N';
                            category.mailIndicator = cat.Usage_Mailing__c == true ? 'Y': 'N';
                            
                            
                            if(cat.Usage_Mailing__c && cat.Mailing_Address__c != null && 
                               cat.Mailing_Address__r.Address_Sequence__c != null && cat.Mailing_Address__r.Address_Sequence__c.contains('-')){
                                   category.mailAddrSeqNbr = cat.Mailing_Address__r.Address_Sequence__c.substringAfterLast('-');
                                   addrSequences.add(cat.Mailing_Address__r.Address_Sequence__c);
                               }
                            
                            if(cat.Usage_Product__c){
                                for(GEMS_BA_Category_Assignment__c baCat : cat.Category_BA_Assignments__r){
                                    if(category.associatedBANumbers == null)
                                        category.associatedBANumbers = new list<string>();
                                    category.associatedBANumbers.add(baCat.Benefit_Agreement__r.Name);
                                }
                            }
                            
                            map<string, list<string>> c_vs = new map<string, list<string>>();
                            for(GEMS_Cat_Char_Value_Association__c catCharValueAssoc : cat.GEMS_Category_Characteristic_Association__r){                            
                                string code = catCharValueAssoc.Characteristic_Value__r.Characteristic__r.Characteristic_Code__c;
                                string value = catCharValueAssoc.Characteristic_Value__r.Code__c; 
                                if(c_vs.containsKey(code)){
                                    list<string> values = c_vs.get(code);
                                    values.add(value);
                                    c_vs.put(code, values);
                                }
                                else{
                                    list<string> values = new list<string>();
                                    values.add(value);
                                    c_vs.put(code, values);
                                }
                            }
                            
                            if(c_vs.keySet() != null && c_vs.keySet().size() > 0){
                                category.categoryCharacteristics = new list<GEMS_AccountSetupServiceInput.CategoryCharacteristic>();                            
                                for(string code : c_vs.keySet()){
                                    GEMS_AccountSetupServiceInput.CategoryCharacteristic catCharValues = new GEMS_AccountSetupServiceInput.CategoryCharacteristic();                            
                                    catCharValues.characteristicCode = code;
                                    catCharValues.valueCodes = c_vs.get(code);
                                    category.categoryCharacteristics.add(catCharValues);                                
                                }
                            }
                            
                            if(category.categoryCharacteristics != null && !category.categoryCharacteristics.IsEmpty())
                                category.memDrvdTypCd = cat.Members_Derivation_Type__c;
                            
                            category.isNew = cat.isNew__c;
                            if (cat.isNew__c) {
                                category.changeReasonCode = 'ADD';                                    
                            }
                            idInputCatMap.put(category.categoryNumber, category);
                            categories.add(category);
                        }
                    }
                    
                    
                    // SFDC-4890, SFDC-4893
                    // Commented out input.categories = categories; below to defer adding categories to input until Group section details are added
                    
                    
                    if(accountStructureCase.GEMS_Submission_Type__c == 'New Account' && categories != null && !(categories.size() >= 1)){   
                        result = 'Please capture the category details.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    
                    list<GEMS_Group_Section__c> gss = [SELECT IsNew__c, IsUpdated__c, Section_Eff_Date__c, Group_No__c, Section_No__c, Section_Description__c,IsDescUpdate__c,
                                                       (SELECT Benefit_Agreement__r.IsNew__c, Benefit_Agreement__r.Effective_Date__c, Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c
                                                        FROM GS_Assignments__r
                                                        WHERE Benefit_Agreement__r.IsCancelled__c = false),
                                                       (SELECT Category__r.IsNew__c, Category__r.Effective_Date__c, Category__r.Name, Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c
                                                        FROM Category_Assignments__r
                                                        WHERE Category__r.IsCancelled__c = false)
                                                       FROM GEMS_Group_Section__c
                                                       WHERE Case__r.Id = : accountStructureCaseID
                                                       // Commented out AND (IsNew__c = true OR IsUpdated__c = true) below to include all GSs for B* changeReason code changes 
                                                       AND IsCancelled__c = false
                                                      ];
                    
                    list<GEMS_AccountSetupServiceInput.GroupSection> groupSections = new list<GEMS_AccountSetupServiceInput.GroupSection>();
                    for(GEMS_Group_Section__c gs : gss){
                        GEMS_AccountSetupServiceInput.GroupSection groupSection = new GEMS_AccountSetupServiceInput.GroupSection();
                        groupSection.groupNumber = gs.Group_No__c;      
                        groupSection.sectionNumber = gs.Section_No__c;
                        groupSection.sectionDescription = gs.Section_Description__c;
                        groupSection.IsDescUpdate = gs.IsDescUpdate__c == true ? 'Y': 'N';
                        system.debug('@@IsDescUpdate '+gs.IsDescUpdate__c);
                        if(groupSection.sectionDescription != null)
                            groupSection.sectionDescription = groupSection.sectionDescription.escapeXML();
                        
                        groupSection.assignedBANumbers = new list<string>();
                        set<string> assignedBANumbers = new set<string>();
                        if(!gs.GS_Assignments__r.IsEmpty()){
                            for(GEMS_BA_Assignment__c b : gs.GS_Assignments__r){
                                if(!assignedBANumbers.contains(b.Benefit_Agreement__r.Name)){
                                    assignedBANumbers.add(b.Benefit_Agreement__r.Name);                                   
                                }
                                // SFDC - 4890 4893. Set ERR changeReasonCode to group section if BA is new
                                // and if Group section is an existing one
                                //Additional Scenarios for Effective Dates - made changes for UAT Defect
                                //Krishna - made changes consolidated code for gs.IsNew for Off Cycle, Renewal and New Acct - Chg reason code is ADD
                               system.debug('case effective date: '+accountStructureCase.GEMS_Case_Effective_Date__c);
                               system.debug('gs effective date: '+gs.Section_Eff_Date__c);
                               // SFDC 7146 Removed b.Benefit_Agreement__r.IsNew__c && check for additional scenarios for existing BAs
                               if (accountStructureCase.GEMS_Submission_Type__c=='Off Cycle') {
                                      if(gs.IsNew__c){
                                        groupSection.changeReasonCode = 'ADD';  
                                        // SFDC-7416. Added to avoid sending changeReasonCd for unchanaged Cat and GS 
                                      } else if(gs.IsUpdated__c && accountStructureCase.GEMS_Case_Effective_Date__c > gs.Section_Eff_Date__c){ 
                                            groupSection.changeReasonCode = 'REN';  
                                      } else if(gs.IsUpdated__c && accountStructureCase.GEMS_Case_Effective_Date__c==gs.Section_Eff_Date__c){
                                            groupSection.changeReasonCode = 'ERR';
                                      }
                                }
                               // SFDC-7416. End
                               // SFDC 7146 Removed b.Benefit_Agreement__r.IsNew__c &&  check for additional scenarios for existing BAs
                               if (accountStructureCase.GEMS_Submission_Type__c=='Renewal') { 
                                   if(gs.IsNew__c){
                                        groupSection.changeReasonCode = 'ADD';
                                   } else if (gs.IsUpdated__c) {
                                        groupSection.changeReasonCode = 'REN';
                                   }
                                } else if (accountStructureCase.GEMS_Submission_Type__c=='New Account') {
                                    // SFDC 7146 Removed b.Benefit_Agreement__r.IsNew__c && check above for additional scenarios for existing BAs
                                    groupSection.changeReasonCode = 'ADD';
                                }                                 
                            }
                        }
                        else{
                            continue;
                        }
                        groupSection.assignedBANumbers.addAll(assignedBANumbers);
                        
                        groupSection.assignedCategoryNumbers = new list<string>();
                        set<string> assignedCategoryNumbers = new set<string>();
                        if(catUsages == null || (catUsages != null && catUsages.size() < 4))
                            groupSection.assignedCategoryNumbers.add('0000');
                        
                        if(!gs.Category_Assignments__r.IsEmpty()) {
                            for(GEMS_Category_Assignment__c c : gs.Category_Assignments__r) {
                                if(!assignedCategoryNumbers.contains(c.Category__r.Name)){
                                    assignedCategoryNumbers.add(c.Category__r.Name);
                                }    
                                
                                
                                // Set category's changeReasonCode to 'ADD' if it's a new category
                                // Set category's changeReasonCode to 'ERR' if it's an existing one
                                // and is tied to an existing group section
                                // SFDC-7146. Send REN changeReasonCode for existing cat's only if a changeReasonCd is sent in GS
                                GEMS_AccountSetupServiceInput.Category inpCat = idInputCatMap.get(c.Category__r.Name);
                                if (null != inpCat && !c.Category__r.IsNew__c && groupSection.changeReasonCode != null) {
                                    inpCat.changeReasonCode = 'REN';
                                    idInputCatMap.put(inpCat.categoryNumber, inpCat);
                                } 
                                // SFDC-7146 end
                            }  
                        }
                        else{
                            continue;
                        }
                        groupSection.assignedCategoryNumbers.addAll(assignedCategoryNumbers);             
                        // Add group section to the input if it's new or existing with ERR code
                        // SFDC-6718. Send group section if description is updated
                        if (gs.IsNew__c || gs.IsUpdated__c || gs.IsDescUpdate__c || (gs.IsUpdated__c && (groupSection.changeReasonCode == 'ERR' || groupSection.changeReasonCode == 'REN'))) {
                            groupSections.add(groupSection);
                        }
                        // SFDC-6718 end
                    }
                    // SFDC 5025, 4894. Commented out input.categories = idInputCatMap.values(); to defer adding input after GS and BP flow
                    input.groupSections = groupSections;
                    
                    if(accountStructureCase.GEMS_Submission_Type__c == 'New Account' && input.groupSections != null && !(input.groupSections.size() >= 1)){  
                        result = 'Please capture the account structure details with group sections.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                                        
                    //Fix for UAT Defect - Modified query to exclude cancelled BA's
                    list<GEMS_Billing_Profile__c> bps = [SELECT IsNew__c, IsUpdated__c,Effective_Date__c,Billing_Profile_Number__c, Name, IsDescUpdate__c,
                                                         Billing_Address__c, Billing_Address__r.Address_Sequence__c,
                                                         (SELECT Benefit_Agreement__r.Name,Benefit_Agreement__r.IsNew__c,Benefit_Agreement__r.Effective_Date__c, Benefit_Agreement__r.BA_Description__c, Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c
                                                          FROM BP_Associations__r
                                                          WHERE Benefit_Agreement__r.BA_Fund_Type__c = 'PREM' ),
                                                         (SELECT Category__r.Name,Category__r.IsNew__c,Category__r.Effective_Date__c, Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c
                                                          FROM BA_BP_Associations__r
                                                          WHERE Category__r.Usage_Billing__c = true)
                                                         FROM GEMS_Billing_Profile__c
                                                         WHERE Case__r.Id = : accountStructureCaseID
                                                         AND (IsNew__c = true OR IsUpdated__c = true OR IsDescUpdate__c = true )
                                                         ];

                    
                    list<GEMS_AccountSetupServiceInput.BillingProfile> billingProfiles = new list<GEMS_AccountSetupServiceInput.BillingProfile>();
                    for(GEMS_Billing_Profile__c bp : bps){
                        GEMS_AccountSetupServiceInput.BillingProfile billingProfile = new GEMS_AccountSetupServiceInput.BillingProfile();
                        billingProfile.billingProfileNumber = bp.Billing_Profile_Number__c;      
                        billingProfile.description = bp.Name;
                        billingProfile.IsDescUpdate = bp.IsDescUpdate__c == true ? 'Y': 'N';
                        if(billingProfile.description != null)
                            billingProfile.description = billingProfile.description.escapeXML();
                        
                        if(bp.Billing_Address__c != null && bp.Billing_Address__r.Address_Sequence__c != null &&  bp.Billing_Address__r.Address_Sequence__c.contains('-')){
                            billingProfile.billingAddressSequence = bp.Billing_Address__r.Address_Sequence__c.substringAfterLast('-');                            
                            addrSequences.add(bp.Billing_Address__r.Address_Sequence__c);
                        }
                        else
                            continue;
                        
                        billingProfile.baNumbers = new list<string>();
                        set<string> baNumbers = new set<string>();
                        if(!bp.BP_Associations__r.IsEmpty()){
                            for(GEMS_BP_BA_Association__c b : bp.BP_Associations__r){
                                if(!baNumbers.contains(b.Benefit_Agreement__r.Name)){
                                    baNumbers.add(b.Benefit_Agreement__r.Name);
                                }
                                //SFDC-5025, 4894. Set changeReasonCode when new BA has been assigned to an existing BP
                                
                                // SFDC 7146 Removed b.Benefit_Agreement__r.IsNew__c && check for additional scenarios for existing BAs
                                if(!bp.IsNew__c && accountStructureCase.GEMS_Submission_Type__c=='Off Cycle') {
                                   //UAT Defect Fix for new Scenario
                                    if(accountStructureCase.GEMS_Case_Effective_Date__c > bp.Effective_Date__c){
                                        billingProfile.changeReasonCode = 'REN';
                                    }
                                   //UAT Defect Fix for new Scenario
                                    if(accountStructureCase.GEMS_Case_Effective_Date__c==bp.Effective_Date__c){
                                        billingProfile.changeReasonCode = 'ERR'; 
                                    }
                                } else if(!bp.IsNew__c && accountStructureCase.GEMS_Submission_Type__c=='Renewal') {
                                    // SFDC 7146 Removed b.Benefit_Agreement__r.IsNew__c && check above for additional scenarios for existing BAs
                                    billingProfile.changeReasonCode = 'REN'; 
                                } else if (bp.IsNew__c &&
                                // SFDC 7146 Removed b.Benefit_Agreement__r.IsNew__c && check above for additional scenarios for existing BAs
                                (accountStructureCase.GEMS_Submission_Type__c=='New Account' 
                                || accountStructureCase.GEMS_Submission_Type__c=='Off Cycle' 
                                || accountStructureCase.GEMS_Submission_Type__c=='Renewal')) {
                                    billingProfile.changeReasonCode = 'ADD'; 
                                }                                                               
                            }
                        }
                        else{
                            continue;
                        }
                        if(!premBAs.isEmpty() && !catUsages.contains('Billing'))
                            baNumbers.addAll(premBAs);
                        if(baNumbers.isEmpty())
                            continue;
                        billingProfile.baNumbers.addAll(baNumbers);
                        
                        billingProfile.categoryNumbers = new list<string>();
                        set<string> categoryNumbers = new set<string>();
                        if(!bp.BA_BP_Associations__r.IsEmpty()){
                            for(GEMS_BP_Category_Association__c c : bp.BA_BP_Associations__r){
                                if(!categoryNumbers.contains(c.Category__r.Name)){
                                    categoryNumbers.add(c.Category__r.Name);
                                }
                                
                                // SFDC-5025 & 4894
                                // Set category's changeReasonCode to 'ADD' if it's a new category
                                // Set category's changeReasonCode to 'REN' if it's an existing one
                                // and is tied to an existing billing profile
                                // SFDC-6718. Send REN changeReasonCode for existing cat's only if a changeReasonCd is sent in BP
                               GEMS_AccountSetupServiceInput.Category inpCat = idInputCatMap.get(c.Category__r.Name);
                                if (null != inpCat && !c.Category__r.IsNew__c && billingProfile.changeReasonCode != null) {
                                    inpCat.changeReasonCode = 'REN';
                                    idInputCatMap.put(inpCat.categoryNumber, inpCat);
                                }       
                                // SFDC-6718 end
                            }
                        } else{
                            continue;
                        }
                        if(!premBAs.isEmpty() && !catUsages.contains('Billing'))
                            categoryNumbers.add('0000');
                        if(categoryNumbers.isEmpty())
                            continue;
                        billingProfile.categoryNumbers.addAll(categoryNumbers);
                        // SFDC-6718. Send billing profile section if description is updated
                        if (bp.IsNew__c || bp.IsUpdated__c || bp.IsDescUpdate__c || (bp.IsUpdated__c && (billingProfile.changeReasonCode == 'ERR' || billingProfile.changeReasonCode == 'REN'))){   
                            billingProfiles.add(billingProfile);
                        }
                        // SFDC-6718 end
                    }
                    input.billingProfiles = billingProfiles;
                    // SFDC-5025, 4894. Add categories to input
                    input.categories = idInputCatMap.values();
                    
                    if(!premBAs.isEmpty() && input.billingProfiles.isEmpty()){  
                        result = 'Please add a billing profile.';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                        accountStructureCase.Status = 'BlueSTAR Failed';
                        update accountStructureCase;
                        return result;
                    }
                    
                    list<GEMS_Address__c> gemsAddresses = [SELECT Address_Sequence__c, 
                                                           Name, City__c, State__c, Zip_Code__c, usage__c,Country__c, County_Code__c,
                                                           Contact_Name__c, Contact_Phone__c, Contact_Email__c
                                                           FROM GEMS_Address__c
                                                           WHERE Account__c = : accountStructureCase.Account.Id 
                                                           AND (IsNew__c = true OR IsUpdated__c = true)
                                                           AND Address_Sequence__c IN : addrSequences];
                    
                    list<GEMS_AccountSetupServiceInput.Address> addresses = new list<GEMS_AccountSetupServiceInput.Address>();
                    for(GEMS_Address__c gemsAddress : gemsAddresses){
                        GEMS_AccountSetupServiceInput.Address address = new GEMS_AccountSetupServiceInput.Address();        
                        
                        if(gemsAddress.Address_Sequence__c != null){
                            string sequence = gemsAddress.Address_Sequence__c;
                            sequence = sequence.substringAfter('-');
                            sequence = sequence.substringAfter('-');
                            system.debug('address sequence :' + sequence);
                            address.addressSequence = Integer.valueOf(sequence);
                            address.addressName = accountStructureCase.Account.Name;
                            if(address.addressName != null)
                                address.addressName = address.addressName.escapeXML();
                            address.street = gemsAddress.Name;
                            if(address.street != null)
                                address.street = address.street.escapeXML();
                            address.state = gemsAddress.State__c;
                            address.cityName = gemsAddress.City__c;
                            if(gemsAddress.Zip_Code__c != null)
                                address.zipCode = gemsAddress.Zip_Code__c.replace('-', '');                             
                            if(gemsAddress.County_Code__c != null) 
                                address.countyCode = String.valueOf(Integer.valueOf(gemsAddress.County_Code__c));
                            address.countryCode = gemsAddress.Country__c;
                            
                            if(gemsAddress.Usage__c != null){
                                address.isPrimaryAddress = gemsAddress.Usage__c.contains('Primary') ? 'Y': 'N';                            
                                address.isMailingAddress = gemsAddress.Usage__c.contains('Mailing') ? 'Y': 'N';
                                address.isBillingAddress = gemsAddress.Usage__c.contains('Billing') ? 'Y': 'N';
                                address.isSubsidaryAddress = gemsAddress.Usage__c.contains('Subsidary') ? 'Y': 'N';
                                address.isInvoiceAddress = gemsAddress.Usage__c.contains('Invoice') ? 'Y': 'N';
                                address.isBaeAddress = gemsAddress.Usage__c.contains('BAE') ? 'Y': 'N';
                                address.isStlmAddress = gemsAddress.Usage__c.contains('Stlm') ? 'Y': 'N';
                                address.isThirdPartyAddress = gemsAddress.Usage__c.contains('ThirdParty') ? 'Y': 'N';                            
                            }    
                            
                            address.contactName = gemsAddress.Contact_Name__c;
                            if(address.contactName != null)
                                address.contactName = address.contactName.escapeXML();
                            if(gemsAddress.Contact_Phone__c != null && gemsAddress.Contact_Phone__c.length() > 0){                            
                                string ph = gemsAddress.Contact_Phone__c.Trim();
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
                            address.contactEmailAddress = gemsAddress.Contact_Email__c;
                            
                            addresses.add(address);
                        }
                    }
                    input.addresses = addresses;
                    
                    FW_Service s = new FW_Service('GEMS_Account_Setup');      
                    GEMS_AccountSetupServiceOutput output = (GEMS_AccountSetupServiceOutput) s.callout(input);
                    
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
            System.debug('exception=='+result);
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