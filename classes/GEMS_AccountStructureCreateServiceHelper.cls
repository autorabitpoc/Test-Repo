//************************************************************************************
// Name             : GEMS_AccountStructureCreateServiceHelper .cls
// Description      : Helper Class for Account Structure Create Service
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 07/31/2017       Shankar             SFDC 5090. Java Heap error issue fix changes
// 10/10/2017       Shankar             Fix for a production bug: SFDC 6820 
// 05/17/2018       Malathi.K           SFDC-4287 GEMS: BlueSTAR - Member Counts at BA Level (GEMS Integration)
// -----------------------------------------------------------------------------------
// ************************************************************************************


public without sharing class GEMS_AccountStructureCreateServiceHelper {
    
    static GEMS_AccountStructureCreateServiceOutput output = new GEMS_AccountStructureCreateServiceOutput();
    
    static DateTime executionStartTime = system.now();
    static DateTime executionEndTime;
    
    static CASE accountStructureCase;
    static ID accountId;
    static ID caseId;
    
    static set<string> allGroupNumbers = new Set<string>();
    static list<GEMS_Address__c> gemsAddresses = new list<GEMS_Address__c>();
    static map<string, GEMS_Address__c> mapOfAddresses = new map<string, GEMS_Address__c>();
    
    static list<GEMS_Group_Section__c> gemsGroupSections = new list<GEMS_Group_Section__c>();
    static Set<String> basWithGroupSections = new Set<String>();
    static Set<String> catsWithGroupSections = new Set<String>();
    static map<string, GEMS_Group_Section__c> mapOfGroupSections = new map<string, GEMS_Group_Section__c>();    
    
    static list<GEMS_Billing_Profile__c> gemsBillingProfiles = new list<GEMS_Billing_Profile__c>();
    static map<string, GEMS_Billing_Profile__c> mapOfBillingProfiles = new map<string, GEMS_Billing_Profile__c>();
    
    static list<GEMS_Benefit_Agreement__c> gemsBAs = new list<GEMS_Benefit_Agreement__c>();
    static map<string, GEMS_Benefit_Agreement__c> mapOfBAs = new map<string, GEMS_Benefit_Agreement__c>();
    static map<string, GEMS_Benefit_Agreement__c> mapOfPremBAs = new map<string, GEMS_Benefit_Agreement__c>();
    static map<string, GEMS_Benefit_Agreement__c> mapOfBAProducts = new map<string, GEMS_Benefit_Agreement__c>();
    
    static list<GEMS_Characteristic__c> gemsChars = new list<GEMS_Characteristic__c>(); 
    static map<string, GEMS_Characteristic__c> mapOfChars = new map<string, GEMS_Characteristic__c>();
    static map<string, List<GEMS_AccountStructureCreateServiceInput.CharacteristicValue>> mapOfCharAndCharValues 
        = new map<string, List<GEMS_AccountStructureCreateServiceInput.CharacteristicValue>>();    
    
    static list<GEMS_Characteristic_Value__c> gemsCharValues = new list<GEMS_Characteristic_Value__c>();
    static map<string, GEMS_Characteristic_Value__c> mapOfCharValues = new map<string, GEMS_Characteristic_Value__c>();
    
    static list<GEMS_Category__c> gemsCategories = new list<GEMS_Category__c>();    
    static map<string, GEMS_Category__c> mapOfCategories = new map<string, GEMS_Category__c>();
    static map<string, List<GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic>> mapOfListCategoryCharValues 
        = new map<string, List<GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic>>();
    
    static list<GEMS_Cat_Char_Value_Association__c> gemsCatCharValues = new list<GEMS_Cat_Char_Value_Association__c>();
        
    static list<GEMS_BA_Assignment__c> gemsBAGSAssignments = new list<GEMS_BA_Assignment__c>();    
    static list<GEMS_Category_Assignment__c> gemsCategoryGSAssignments = new list<GEMS_Category_Assignment__c>();
    
    static list<GEMS_BA_Category_Assignment__c> gemsBACategoryAssignments = new list<GEMS_BA_Category_Assignment__c>();
    static map<string, GEMS_BA_Category_Assignment__c> mapOfBACategoryAssignments = new map<string, GEMS_BA_Category_Assignment__c>();//--
    static list<GEMS_BA_Category_Assignment__c> gemsBACategoryAssignmentsWithBPs = new list<GEMS_BA_Category_Assignment__c>();//--
    
    static list<GEMS_BP_BA_Association__c> gemsBABPAssignments = new list<GEMS_BP_BA_Association__c>();
    static list<GEMS_BP_Category_Association__c> gemsCategoryBPAssignments = new list<GEMS_BP_Category_Association__c>();
        
    static list<GEMS_Corp_Characteristic_Code__c> corpCharCode = new list<GEMS_Corp_Characteristic_Code__c>();
    static map<String, id> mapOfCorpCharCode = new Map<String, id>();
    static string validSession;
     
    public static GEMS_AccountStructureCreateServiceOutput consolidateAccountStructureDetails(GEMS_AccountStructureCreateServiceInput input) {
      
        output.accountStructureCaseID = input.accountStructureCaseID;
        output.status = 'S';
    
        try{
          
            list<CASE> cases = [SELECT Id, Account.Id, GEMS_Submission_Type__c, GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Response_Time__c, 
                                GEMS_Failed_Account_Message__c, GEMS_Failed_Addresses__c, GEMS_Failed_Benefit_Agreements__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                GEMS_Reserved_Group_Numbers__c, GEMS_Cobra_Auto_Can_Ind__c, GEMS_Is_Account_Derivated__c, OwnerId
                        FROM CASE
                          WHERE id = : input.accountStructureCaseID];
        
            if(cases != null && cases.size() > 0)
                accountStructureCase = cases[0];
              
            if(accountStructureCase != null){// && accountStructureCase.GEMS_Submission_Type__c == 'Renewal'){
                caseId = accountStructureCase.Id;
                accountId = accountStructureCase.Account.Id;
                //System.debug('input.status for consolidation:'+input.status);
                System.debug('input contents:'+input);
                try{
                    if(input.status == 'S'){// && deleteAccountStructure()
                        
                        processAddresses(input.accountDetails, input.addresses);                
                        
                        processGroupSections(input.groupSections);
                        processAccountDetails(input.accountDetails, input.groupNumbers);    
                        
                        validSession = input.validSession;
                        processCharacteristics(input.characteristics);
                        processCategories(input.categories);
                        
                        processBenefitAggrements(input.benefitAggrements, input.billingProfiles, input.accountDetails);
                        processBillingProfiles(input.billingProfiles);
                        //processCharacteristics(input.characteristics);
                        //processCategories(input.categories);
                        
                        //Process Assignments
                        processBA_GS_CAT_Assignments(input.groupSections);  
                        processBA_BP_CAT_Assignments(input.billingProfiles);    
                    }
                    else{
                        output.status = 'E';
                        output.accountStructureCaseID = input.accountStructureCaseID;
                        output.requestCode = input.requestCode;
                        if(input.accountDetails != null)
                            output.accountNumber = input.accountDetails.accountNumber;
                        output.message = 'BlueSTAR Failed to send the Account Structure details. ' + input.message;
                    }
                }
                catch(Exception ex){
                    output.status = 'E';
                    output.requestCode = input.requestCode;
                    output.accountStructureCaseID = input.accountStructureCaseID;
                    if(input.accountDetails != null)
                      output.accountNumber = input.accountDetails.accountNumber;
                    output.message = ex.getLineNumber() + ' : ' + ex.getMessage();
                }
                                
                updateAccountStructureStatus();
            }
            else{          
                output.status = 'E';
                output.requestCode = input.requestCode;
                output.message = 'No Renewal case found!!!' + ' Env : ' + URL.getSalesforceBaseUrl().getHost();            
            }            
            executionEndTime = system.now();
        }
        catch(Exception ex){
            output.status = 'E';
            output.requestCode = input.requestCode;
            output.message = ex.getLineNumber() + ' : ' + ex.getMessage();
            executionEndTime = system.now();
        }
      
        updateServiceStatus(input);
      
        return output;
    }
    
    // Adding new Addresses from Service
    public static void processAddresses(GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails,
                                           list<GEMS_AccountStructureCreateServiceInput.Address> addresses){
                                               
        gemsAddresses = [SELECT Id, Address_Sequence__c FROM GEMS_Address__c WHERE Account__c = : accountId];
                                               
        for(GEMS_Address__c gemsAddress : gemsAddresses){            
            mapOfAddresses.put(gemsAddress.Address_Sequence__c.substring(gemsAddress.Address_Sequence__c.lastIndexOf('-') + 1), gemsAddress);
        }
        
    }
    
    // Creating new group sections 
    public static void processGroupSections(list<GEMS_AccountStructureCreateServiceInput.GroupSection> groupSections){
        
        for(GEMS_AccountStructureCreateServiceInput.GroupSection groupSection : groupSections){
 
            allGroupNumbers.add(groupSection.groupNumber);
 
            for(String assignedBANumber : groupSection.assignedBANumbers)
              basWithGroupSections.add(assignedBANumber);
            
            for(String assignedCategoryNumber : groupSection.assignedCategoryNumbers){
                if(assignedCategoryNumber != '0')
                    catsWithGroupSections.add(assignedCategoryNumber);
            }            
        }
        
        //insert gemsGroupSections;
        
        gemsGroupSections = [SELECT Id, Group_No__c, Section_No__c FROM GEMS_Group_Section__c WHERE Case__c = : caseId];
        
        for(GEMS_Group_Section__c gemsGroupSection : gemsGroupSections){
          mapOfGroupSections.put(gemsGroupSection.Group_No__c + '-' + gemsGroupSection.Section_No__c, gemsGroupSection);
        }
    }
    
    public static void processAccountDetails(GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails,
                                               list<string> groupNumbers){
        accountStructureCase.GEMS_Cobra_Auto_Can_Ind__c = accountDetails.cobraAutoCancel;
        //accountStructureCase. cobraCode?????
        accountStructureCase.GEMS_Is_Account_Derivated__c = accountDetails.autoCategorizationIndicator;
        //accountStructureCase.HCSC_Division__c = accountDetails.corpCode.left(2);
        
        string grpNumbers;   
        if(groupNumbers != null)                                                       
            allGroupNumbers.addAll(groupNumbers);
        if(allGroupNumbers != null){            
            for(string groupNumber : allGroupNumbers){
                if(grpNumbers != null)
                    grpNumbers = grpNumbers + ';' + groupNumber;
                else
                    grpNumbers = groupNumber;
            }
            accountStructureCase.GEMS_Reserved_Group_Numbers__c = grpNumbers;
        }       
                                                   
        //update accountStructureCase;
    }
    
    // Creating new Benefit Agreement based on service Response
    public static void processBenefitAggrements(list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement> benefitAggrements,
                                               list<GEMS_AccountStructureCreateServiceInput.BillingProfile> billingProfiles,
                                               GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails){
        
        list<string> baProducts = new list<string>();
        string corpCode = accountDetails.corpCode.left(2);
                                                   
        for(GEMS_AccountStructureCreateServiceInput.BenefitAggrement benefitAggrement : benefitAggrements){
            //if(basWithGroupSections.contains(benefitAggrement.baNumber)){
                GEMS_Benefit_Agreement__c gemsBA = new GEMS_Benefit_Agreement__c();
                
                gemsBA.Account__c = accountId;
                gemsBA.AccountStructureCase__c = caseId;
                            
                gemsBA.IsNew__c = false;
                if(basWithGroupSections.contains(benefitAggrement.baNumber))
                    gemsBA.Has_Group_Sections__c = true;
                else
                    gemsBA.Has_Group_Sections__c = false;
                
                gemsBA.Name = updateNumber(benefitAggrement.baNumber);
                //gemsBA.Name = benefitAggrement.baNumber;
                gemsBA.Effective_Date__c = benefitAggrement.effectiveDate;            
                
                gemsBA.ProductNumber__c = benefitAggrement.corporateProdNumber;
                gemsBA.ProductType__c = benefitAggrement.prodTypeCode;
                                
                gemsBA.BA_Description__c = benefitAggrement.baDescription;
                
                gemsBA.BA_Fund_Type__c = benefitAggrement.baFundType;
                gemsBA.Schedule__c = benefitAggrement.scheduleCode;
                gemsBA.ID_Card_Type__c = benefitAggrement.idCardType;
                gemsBA.Active_Member_Count__c = integer.valueof(benefitAggrement.activeMemberCount);
                //SFDC-4287 Added new field BA Member count
                
                gemsBAs.add(gemsBA);
                
                if(gemsBA.ProductNumber__c != null){
                    mapOfBAProducts.put(gemsBA.ProductNumber__c, gemsBA);
                    baProducts.add(gemsBA.ProductNumber__c);
                    if(gemsBA.ProductNumber__c.length() == 4)
                        baProducts.add(corpCode + gemsBA.ProductNumber__c);
                    else if(gemsBA.ProductNumber__c.length() == 3)
                        baProducts.add(corpCode + '0' + gemsBA.ProductNumber__c);
                    else if(gemsBA.ProductNumber__c.length() == 2)
                        baProducts.add(corpCode + '00' + gemsBA.ProductNumber__c);
                    else if(gemsBA.ProductNumber__c.length() == 1)
                        baProducts.add(corpCode + '000' + gemsBA.ProductNumber__c);
                }
            //}
        }
                                                   
        map<string, Plan__c> mapOfPlans = new map<string, Plan__c>();
        list<Plan__c> gemsPlans = [Select Id, Name, External_Id__c, Product__r.Id, Product__r.ProductCode From Plan__c
                                        WHERE External_Id__c in : baProducts AND Product__c != null AND Product__r.HCSC_State__c = : corpCode];
        
        for(Plan__c gemsPlan : gemsPlans){
            mapOfPlans.put(gemsPlan.External_Id__c, gemsPlan);
        }
                                                   
        for(GEMS_Benefit_Agreement__c gemsBA : gemsBAs){
            if(mapOfPlans.containsKey(gemsBA.ProductNumber__c)){
                gemsBA.Plan__c = mapOfPlans.get(gemsBA.ProductNumber__c).Id;
                gemsBA.Product__c = mapOfPlans.get(gemsBA.ProductNumber__c).Product__c;
            }
            else if(gemsBA.ProductNumber__c.length() == 4 && mapOfPlans.containsKey(corpCode + gemsBA.ProductNumber__c)){
                gemsBA.Plan__c = mapOfPlans.get(corpCode + gemsBA.ProductNumber__c).Id;
                gemsBA.Product__c = mapOfPlans.get(corpCode + gemsBA.ProductNumber__c).Product__c;
            }
            else if(gemsBA.ProductNumber__c.length() == 3 && mapOfPlans.containsKey(corpCode + '0' + gemsBA.ProductNumber__c)){
                gemsBA.Plan__c = mapOfPlans.get(corpCode + '0' + gemsBA.ProductNumber__c).Id;
                gemsBA.Product__c = mapOfPlans.get(corpCode + '0' + gemsBA.ProductNumber__c).Product__c;
            }
            else if(gemsBA.ProductNumber__c.length() == 2 && mapOfPlans.containsKey(corpCode + '00' + gemsBA.ProductNumber__c)){
                gemsBA.Plan__c = mapOfPlans.get(corpCode + '00' + gemsBA.ProductNumber__c).Id;
                gemsBA.Product__c = mapOfPlans.get(corpCode + '00' + gemsBA.ProductNumber__c).Product__c;
            }
            else if(gemsBA.ProductNumber__c.length() == 1 && mapOfPlans.containsKey(corpCode + '000' + gemsBA.ProductNumber__c)){
                gemsBA.Plan__c = mapOfPlans.get(corpCode + '000' + gemsBA.ProductNumber__c).Id;
                gemsBA.Product__c = mapOfPlans.get(corpCode + '000' + gemsBA.ProductNumber__c).Product__c;
            }                
        }
        System.debug('BAs to be inserted:'+ gemsBAs);                                          
        insert gemsBAs;
        
        for(GEMS_Benefit_Agreement__c gemsBA : gemsBAs){
            mapOfBAs.put(gemsBA.Name, gemsBA);
            if(gemsBA.BA_Fund_Type__c != null && gemsBA.BA_Fund_Type__c == 'PREM')
                mapOfPremBAs.put(gemsBA.Name, gemsBA);
        }
    }
    
    
    // Creating Billing Profiles based on service response
    public static void processBillingProfiles(list<GEMS_AccountStructureCreateServiceInput.BillingProfile> billingProfiles){
        System.debug('mapOfPremBAs::'+mapOfPremBAs);

        for(GEMS_AccountStructureCreateServiceInput.BillingProfile billingProfile : billingProfiles){

            if(billingProfile.baNumbers == null || (billingProfile.baNumbers != null && mapOfPremBAs != null && !mapOfPremBAs.containsKey(updateNumber(billingProfile.baNumbers[0]))))
                continue;
            
            GEMS_Billing_Profile__c gemsBillingProfile = new GEMS_Billing_Profile__c();
            
            gemsBillingProfile.Account__c = accountId;
            gemsBillingProfile.Case__c = caseId;
            gemsBillingProfile.OwnerId = accountStructureCase.OwnerId;
            gemsBillingProfile.IsNew__c = false;
            
            for(String categoryNumber : billingProfile.categoryNumbers){
                if(categoryNumber == '0'){
                    gemsBillingProfile.IsUpdated__c = true;
                    break;
                }               
            }
            
            gemsBillingProfile.Billing_Profile_Number__c = billingProfile.billingProfileNumber;
            gemsBillingProfile.Name = billingProfile.description;
            gemsBillingProfile.Effective_Date__c = billingProfile.effectiveDate;
            
            if(billingProfile.billingAddressSequence != null && mapOfAddresses.get(billingProfile.billingAddressSequence) != null){
                gemsBillingProfile.Billing_Address__c = mapOfAddresses.get(billingProfile.billingAddressSequence).Id;
            }
            
            gemsBillingProfiles.add(gemsBillingProfile);
        }     
        
        insert gemsBillingProfiles;
        
        for(GEMS_Billing_Profile__c gemsBillingProfile : gemsBillingProfiles){
          mapOfBillingProfiles.put(gemsBillingProfile.Billing_Profile_Number__c, gemsBillingProfile);
        }
    }
    
    // Creating Characteristics and Characterisitic Values based on Service Response
    public static void processCharacteristics(list<GEMS_AccountStructureCreateServiceInput.Characteristic> characteristics){
        
        gemsChars = [SELECT Id, Comments__c FROM GEMS_Characteristic__c WHERE Case__c = : caseId];
        
        for(GEMS_Characteristic__c gemsChar : gemsChars){
           mapOfChars.put(gemsChar.Comments__c, gemsChar);
        }
        
        system.debug('mapOfChars : ' + mapOfChars);
        system.debug('gemsChars : ' + gemsChars);
        
        for(GEMS_AccountStructureCreateServiceInput.Characteristic characteristic : characteristics){
            Id charID = mapOfChars.get(characteristic.characteristicCode).Id;
            string charCode = mapOfChars.get(characteristic.characteristicCode).Comments__c;
            mapOfCharAndCharValues.put(charID + '-' + charCode,characteristic.characteristicValues); 
        }       
        system.debug('gemsCharValues : ' + gemsCharValues);
        if(mapOfCharAndCharValues != null && mapOfCharAndCharValues.size() > 0){
            for(string idAndCode : mapOfCharAndCharValues.keySet()  ){
                if(idAndCode != null && mapOfCharAndCharValues.get(idAndCode) != null){
                    for(GEMS_AccountStructureCreateServiceInput.CharacteristicValue CharValue : mapOfCharAndCharValues.get(idAndCode)){
                        
                        GEMS_Characteristic_Value__c gemsCharValue =  new GEMS_Characteristic_Value__c();
                        gemsCharValue.Case__c = caseId ;
                        gemsCharValue.Code__c =  CharValue.valueCode ; 
                        gemsCharValue.Name =  CharValue.value ; 
                        gemsCharValue.Effective_Date__c = CharValue.effectiveDate;
                        gemsCharValue.IsNew__c =  false;                
                        gemsCharValue.Characteristic__c = idAndCode.substringBefore('-');
                        gemsCharValue.Characteristic_Code__c = idAndCode.substringAfter('-');
                        gemsCharValues.add(gemsCharValue);
                    }
                }
            }
        }
        
        GEMS_Global_Settings__mdt globalSettings = [Select Value__c, QualifiedApiName, MasterLabel, Label, Id, DeveloperName 
                                                                    From GEMS_Global_Settings__mdt 
                                                                        where QualifiedApiName = 'CreateCharValuesWithService' 
                                                                            limit 1];
        
        if(!Test.isRunningTest() 
            && globalSettings != null && globalSettings.Value__c != null && globalSettings.Value__c == 'Y' 
                && gemsCharValues != null && gemsCharValues.size() > 0){
            System.debug('About to insert charValues');
                    
            insertRecords(JSON.serialize(gemsCharValues), 'gemsCharValues');
            gemsCharValues = [SELECT Id, Characteristic_Code__c, Code__c, Name, Characteristic__c FROM GEMS_Characteristic_Value__c WHERE Case__c = : caseId];
        }
        else
            insert gemsCharValues;
        
        for(GEMS_Characteristic_Value__c gemsCharValue : gemsCharValues){
            mapOfCharValues.put(gemsCharValue.Characteristic_Code__c + '-' + gemsCharValue.Code__c, gemsCharValue);
        }
    }
    
    
    // Creating new Categories and Category Characteristics based on Service Response
    public static void processCategories(list<GEMS_AccountStructureCreateServiceInput.Category> categories){
       
                                            
        gemsCategories = [SELECT Id, Name, Has_Group_Sections__c FROM GEMS_Category__c WHERE Case__c = : caseId];
        
        for(GEMS_Category__c gemsCategory : gemsCategories){
          mapOfCategories.put(gemsCategory.Name, gemsCategory);
        }
                                            
        system.debug('mapOfCategories :' + mapOfCategories);
        
        //Category Characteristic Values                
        for(GEMS_AccountStructureCreateServiceInput.Category category : categories){
            if(category.categoryNumber != '0' && mapOfCategories.get(updateNumber(category.categoryNumber)) != null
                && mapOfCategories.get(updateNumber(category.categoryNumber)).Has_Group_Sections__c){
                Id catID = mapOfCategories.get(updateNumber(category.categoryNumber)).Id;
                mapOfListCategoryCharValues.put(catID,category.categoryCharacteristics);       
            }
        }
                                            
        system.debug('mapOfListCategoryCharValues :' + mapOfListCategoryCharValues);
        
         GEMS_Global_Settings__mdt globalSettings = [Select Value__c, QualifiedApiName, MasterLabel, Label, Id, DeveloperName 
                                                                    From GEMS_Global_Settings__mdt 
                                                                        where QualifiedApiName = 'CreateCatCharValuesWithService' 
                                                                            limit 1];
        System.debug('mapOfCharValues:'+mapOfCharValues);
        for(ID catID : mapOfListCategoryCharValues.keySet()  ){
            if(catID != null && mapOfListCategoryCharValues.get(catID) != null){
                for(GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic charCode : mapOfListCategoryCharValues.get(catID)){ 
                    if(charCode != null && charCode.valueCodes != null){
                        for(string valueCode : charCode.valueCodes){                  
                            GEMS_Cat_Char_Value_Association__c gemsCatCharValue =  new GEMS_Cat_Char_Value_Association__c();
                            gemsCatCharValue.Case__c = caseId ;
                            gemsCatCharValue.Account__c =  accountId ; 
                            gemsCatCharValue.IsNew__c = false;
                            System.debug('keyVal::'+charCode.characteristicCode + '-' + valueCode);
                            gemsCatCharValue.Category__c = catID;
                            if(mapOfCharValues.get(charCode.characteristicCode + '-' + valueCode) != null)
                                gemsCatCharValue.Characteristic_Value__c = mapOfCharValues.get(charCode.characteristicCode + '-' + valueCode).Id;
                            else
                                continue;
                            
                            gemsCatCharValues.add(gemsCatCharValue);
                            
                            if(!Test.isRunningTest() 
                                && globalSettings != null && globalSettings.Value__c != null && globalSettings.Value__c == 'Y' 
                                && gemsCatCharValues != null && gemsCatCharValues.size() > 9999){
                                
                                system.debug('gemsCatCharValues size : ' + gemsCatCharValues.size());
                                    
                                insertRecords(JSON.serialize(gemsCatCharValues), 'gemsCatCharValues');
                                    
                                gemsCatCharValues = new list<GEMS_Cat_Char_Value_Association__c>();
                            }
                            
                        }
                    }
                }
            }
        }
        
        //Last Run
        if(!Test.isRunningTest() 
           && globalSettings != null && globalSettings.Value__c != null && globalSettings.Value__c == 'Y' 
           && gemsCatCharValues != null && gemsCatCharValues.size() > 0){
               
               system.debug('gemsCatCharValues size : ' + gemsCatCharValues.size());
               
               insertRecords(JSON.serialize(gemsCatCharValues), 'gemsCatCharValues');
               
               gemsCatCharValues = new list<GEMS_Cat_Char_Value_Association__c>();
        }
        else
            insert gemsCatCharValues;
        
        gemsCatCharValues = null;
    }
    
    // Creating Benefit Agreement, Group Sections, Category Assignments 
    public static void processBA_GS_CAT_Assignments(list<GEMS_AccountStructureCreateServiceInput.GroupSection> groupSections){

        for(GEMS_AccountStructureCreateServiceInput.GroupSection groupSection : groupSections){
            for(String assignedBANumber : groupSection.assignedBANumbers){
              GEMS_BA_Assignment__c gemsBAGSAssignment = new GEMS_BA_Assignment__c();
                gemsBAGSAssignment.Account__c = accountId;
                gemsBAGSAssignment.Case__c = caseId;
                gemsBAGSAssignment.IsNew__c = false;
                
                gemsBAGSAssignment.Group_Section__c = mapOfGroupSections.get(groupSection.groupNumber + '-' + groupSection.sectionNumber).Id;
                
                if(mapOfBAs.get(updateNumber(assignedBANumber)) != null)
                    gemsBAGSAssignment.Benefit_Agreement__c = mapOfBAs.get(updateNumber(assignedBANumber)).Id;
                else
                    continue;
            
                gemsBAGSAssignments.add(gemsBAGSAssignment);   
                
                for(String assignedCategoryNumber : groupSection.assignedCategoryNumbers){
                    if(assignedCategoryNumber != '0'){
                        GEMS_BA_Category_Assignment__c gemsBACategoryAssignment = new GEMS_BA_Category_Assignment__c();
                        gemsBACategoryAssignment.Account__c = accountId;
                        gemsBACategoryAssignment.Case__c = caseId;
                        gemsBACategoryAssignment.IsNew__c = false;
                        
                        if(mapOfBAs.get(updateNumber(assignedBANumber)) != null)
                            gemsBACategoryAssignment.Benefit_Agreement__c = mapOfBAs.get(updateNumber(assignedBANumber)).Id;
                        else
                            continue;
                        
                        if(mapOfCategories.get(updateNumber(assignedCategoryNumber)) != null)
                            gemsBACategoryAssignment.Category__c = mapOfCategories.get(updateNumber(assignedCategoryNumber)).Id;
                        else
                            continue;
                        gemsBACategoryAssignment.Name = assignedBANumber + '-' + assignedCategoryNumber;
                        
                        if(mapOfBACategoryAssignments.get(gemsBACategoryAssignment.Name) == null){
                            gemsBACategoryAssignments.add(gemsBACategoryAssignment);
                            mapOfBACategoryAssignments.put(gemsBACategoryAssignment.Name, gemsBACategoryAssignment);
                        }
                    }
                }
            }
            
            for(String assignedCategoryNumber : groupSection.assignedCategoryNumbers){
                if(assignedCategoryNumber != '0'){
                  GEMS_Category_Assignment__c gemsCategoryGSAssignment = new GEMS_Category_Assignment__c();
                    gemsCategoryGSAssignment.Account__c = accountId;
                    gemsCategoryGSAssignment.Case__c = caseId;
                    gemsCategoryGSAssignment.IsNew__c = false;
                    
                    gemsCategoryGSAssignment.Group_Section__c = mapOfGroupSections.get(groupSection.groupNumber + '-' + groupSection.sectionNumber).Id;
                    if(mapOfCategories.get(updateNumber(assignedCategoryNumber)) != null)
                        gemsCategoryGSAssignment.Category__c = mapOfCategories.get(updateNumber(assignedCategoryNumber)).Id;
                    else
                        continue;
                    
                  gemsCategoryGSAssignments.add(gemsCategoryGSAssignment);  
                }
            }
        }
        
        insert gemsBAGSAssignments;
        insert gemsCategoryGSAssignments;
        
        insert gemsBACategoryAssignments;
    }
    
    // Creating Benefit Agreement, Billing Profile, Category Assignments based on the service
    public static void processBA_BP_CAT_Assignments(list<GEMS_AccountStructureCreateServiceInput.BillingProfile> billingProfiles){
                
        for(GEMS_AccountStructureCreateServiceInput.BillingProfile billingProfile : billingProfiles){
            
            if(billingProfile.baNumbers == null || (billingProfile.baNumbers != null && mapOfPremBAs != null && !mapOfPremBAs.containsKey(updateNumber(billingProfile.baNumbers[0]))))
                continue;
            
            for(String baNumber : billingProfile.baNumbers){
              GEMS_BP_BA_Association__c gemsBABPAssignment = new GEMS_BP_BA_Association__c();
              gemsBABPAssignment.Case__c = caseId;
              gemsBABPAssignment.IsNew__c = false;
                
              gemsBABPAssignment.Billing_Profile__c = mapOfBillingProfiles.get(billingProfile.billingProfileNumber).Id;
              if(mapOfBAs.get(updateNumber(baNumber)) != null)
                gemsBABPAssignment.Benefit_Agreement__c = mapOfBAs.get(updateNumber(baNumber)).Id;
              else
                continue;
            
              gemsBABPAssignments.add(gemsBABPAssignment);                
            }
            
            for(String categoryNumber : billingProfile.categoryNumbers){
              GEMS_BP_Category_Association__c gemsCategoryBPAssignment = new GEMS_BP_Category_Association__c();
                gemsCategoryBPAssignment.Case__c = caseId;
                gemsCategoryBPAssignment.IsNew__c = false;
                
                gemsCategoryBPAssignment.Billing_Profile__c = mapOfBillingProfiles.get(billingProfile.billingProfileNumber).Id;
                if(mapOfCategories.get(updateNumber(categoryNumber)) != null)
                    gemsCategoryBPAssignment.Category__c = mapOfCategories.get(updateNumber(categoryNumber)).Id;
                else
                    continue;
                
              gemsCategoryBPAssignments.add(gemsCategoryBPAssignment);   
            }
        }
        
        insert gemsBABPAssignments;
        insert gemsCategoryBPAssignments;
    }
    
    public static string insertRecords(string records, string recordType){
        
        system.debug('validSession : ' + validSession);
        string status = 'S';
        string message;
        string sOutput;
        
        Try{
            Http h = new Http();
            HttpRequest hr = new HttpRequest();
            hr.setHeader('Content-Type','application/json');
            hr.setHeader('Authorization','OAuth ' + validSession);
            hr.setEndpoint(System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/GEMS_CreateCharValuesService/' + recordType);
            hr.setBody(records);
            hr.setMethod('POST');
            hr.setTimeout(120000);
            HttpResponse hrs = h.send(hr);
            system.debug(hrs);            
            if(hrs.getStatusCode() != 200){
                status = 'E';
                message = hrs.getStatus();
            }
            else{
                system.debug(hrs.getBody());
                sOutput = hrs.getBody();
            }
                
        }
        catch(Exception ex){
            status = 'E';
            message = ex.getMessage();
        }
        
        //updateServiceStatus('GEMS_' + recordType, records, sOutput, status, message);
        
        return status;
    }
    
    // Updating the length of the BA and Category Number to 4
    public static string updateNumber(string formatNumber){
        if(formatNumber.length() == 3)
            formatNumber = '0' + formatNumber;
        if(formatNumber.length() == 2)
            formatNumber = '00' + formatNumber;
        if(formatNumber.length() == 1)
            formatNumber = '000' + formatNumber;  
        
        return formatNumber;
    }
    
    public static void updateServiceStatus(GEMS_AccountStructureCreateServiceInput input){
        try{
          System.Debug('Log Service Status START');
          FW_Service_Status_Log__c statusLog = new FW_Service_Status_Log__c();
              statusLog.Name = 'GEMS_AccountStructureCreateService';
              statusLog.UID__c = input.accountStructureCaseID;
               statusLog.Case__c = input.accountStructureCaseID;
              statusLog.Status__c = output.status;          
              statusLog.ErrorDescription__c = output.message;
              statusLog.StartTime__c = executionStartTime;              
              statusLog.EndTime__c = executionEndTime;              
              string request1 = JSON.serializePretty(input);
              if(request1.length() > 131000)
                   request1 = request1.substring(0,131000);
              statusLog.RequestBody__c = request1;
              string response1 = JSON.serializePretty(output);
              if(response1.length() > 131000)
                   response1 = response1.substring(0,131000);
              statusLog.ResponseBody__c = response1;
              statusLog.OwnerId = accountStructureCase.OwnerId;
              System.Debug('Log Service Status BEFORE INSERT' + statusLog);
              
              insert statusLog;
              
              System.Debug('Log Service Status END');
      }
      catch(Exception ex){
        //DO NOTHING
      }
    }
    
    
    public static void updateAccountStructureStatus(){
        accountStructureCase.GEMS_Integration_Response_Time__c = system.now();
          
        if(output.status == 'E'){
            System.Debug('output.message : ' + output.message);
            string message = output.message;
            if(message.length() > 254)
                message = message.substring(0,254);
            accountStructureCase.GEMS_Integration_Message__c = message;               
        }
        else
            accountStructureCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';                      
        
        update accountStructureCase;
    }
    
    public static GEMS_AccountStructureCreateServiceInput fetchDeserializedData(String transactionId, String accStructureCaseId) {
        GEMS_AccountStructureCreateServiceInput input = new GEMS_AccountStructureCreateServiceInput();
        List<Attachment> attachments = [Select Name, Body from Attachment where ParentId in (Select Id from GEMS_Account_Structure_Response__c where Transaction_Id__c = :transactionId)];
        for (Attachment a: attachments) {
            String inputStr = a.Body.toString();
            GEMS_AccountStructureCreateServiceInput partialReq = (GEMS_AccountStructureCreateServiceInput) JSON.deserialize(inputStr, GEMS_AccountStructureCreateServiceInput.class);
                       
            if (a.Name == 'Call1') {
                input.accountDetails = partialReq.accountDetails;
                
                // Task - 6820 Production bug fix. Have to set valid session in the consolidate structure
                // to process characteristics and category-characteristicVal associations successfully. This 
                // is because these 2 information are inserted by calling another service and valid session 
                // has to be passed in the request. Failing to do so leads to 401 (unauthorized) error
                input.validSession = partialReq.validSession;

                input.addresses = partialReq.addresses;
                input.characteristics = partialReq.characteristics;
                input.groupNumbers = partialReq.groupNumbers;
                input.accountStructureCaseID = accStructureCaseId;
            } else if (a.Name == 'Call2') {
                input.benefitAggrements = partialReq.benefitAggrements;
                input.categories = partialReq.categories;
            } else if (a.Name == 'Call3') {
                input.billingProfiles = partialReq.billingProfiles;
                input.groupSections = partialReq.groupSections;
                input.status = 'S';
            }
        }
        System.debug('Consolidated Input:'+input);
        return input;
    }
}