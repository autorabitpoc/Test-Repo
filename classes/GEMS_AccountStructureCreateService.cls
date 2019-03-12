//************************************************************************************
// Name             : GEMS_AccountStructureCreateService .cls
// Description      : Integration class for invoking the Create Account Structure Service
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 11/08/2017       Shankar             SFDC-7238. Changes to mark existing primary address as subsidary if B* sends a different primary addr
// 11/21/2017       Shankar             SFDC-7238. Made changes to just remove Primary usage from existing address if B* sends a different primary addr (instaed of marking it subsidiary)
// 11/28/2017       Shankar             SFDC-7238. Bug fix to consider other usages while making primary as non-primary
// 12/2017          Naumann             SFDC-7450 - LGNA Account Cancellation changes. 
// 05/25/2018		Bharath				SFDC-8691 Included EIN information so that BlueStar can respond with EIN details of Account when EIN retrieval is requested.
// -----------------------------------------------------------------------------------
// ************************************************************************************

global without sharing
class GEMS_AccountStructureCreateService {

    static CASE accountStructureCase;
    static ID accountId;
    static ID caseId;

    static list<GEMS_Address__c> gemsAddresses = new list<GEMS_Address__c>();
    static map<string, GEMS_Address__c> mapOfAddresses = new map<string, GEMS_Address__c>();

    static list<GEMS_Group_Section__c> gemsGroupSections = new list<GEMS_Group_Section__c>();
    static Set<String> basWithGroupSections = new Set<String>();
    static Set<String> catsWithGroupSections = new Set<String>();
    // static map<string, GEMS_Group_Section__c> mapOfGroupSections = new
    // map<string, GEMS_Group_Section__c>();

    static list<GEMS_Category__c> gemsCategories = new list<GEMS_Category__c>();
    // static map<string, GEMS_Category__c> mapOfCategories = new map<string,
    // GEMS_Category__c>();

    static list<GEMS_Corp_Characteristic_Code__c> corpCharCode = new list<GEMS_Corp_Characteristic_Code__c>();
    static map<String, id> mapOfCorpCharCode = new Map<String, id>();
    static list<GEMS_Characteristic__c> gemsChars = new list<GEMS_Characteristic__c>();

    webService

    static GEMS_AccountStructureCreateServiceOutput createAccountStructure(GEMS_AccountStructureCreateServiceInput input) {

        GEMS_AccountStructureCreateServiceOutput output = new GEMS_AccountStructureCreateServiceOutput();        
        System.debug('input parameters:'+input.requestCode);

        // SFDC-8691 - If the request code in the input from BlueStar contains 'mein', branch out with EIN processing. 
        // In this case, the program returns after EIN and does not go through regular account structure retrieval process.
        if (input.requestCode !=null && input.requestCode.contains('mein')) {
            // EIN flow
            try{           
            system.debug('Request From B*'+input);  
            output = LGNA_EIN_TransmitServiceHelper.updateEIN(input,  input.accountStructureCaseID);
            }
            catch(Exception ex){
              System.debug('EIN Exception Message'+ex.getmessage()+'Line Number'+ex.getLineNumber());
            }
            return output;
        }
        // SFDC-8691 end


        String transactionId = (null != input.requestCode && input.requestCode.split('-').size()==2)?input.requestCode.split('-')[0]:'';
        String reqCode = (null != input.requestCode && input.requestCode.split('-').size()==2)?input.requestCode.split('-')[1]:'';
        
        
        System.debug('transactionId::'+transactionId);
        GEMS_Account_Structure_Response__c responseRec;
        boolean errFlag = false;
        try{
            List<GEMS_Account_Structure_Response__c> responseLst =[Select Id, Transaction_Id__c, AccStructCaseId__c, Call_1_status__c, Call_2_status__c, 
                                                                   Call_3_status__c from GEMS_Account_Structure_Response__c 
                                                                   where Transaction_Id__c = :transactionId];

            /* SFDC-7540 - Added RecordyTypeId to SOQL for Cases*/
            list<CASE> cases = [SELECT Id, Account.Id, RecordTypeId, GEMS_Submission_Type__c, GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Response_Time__c, 
                                GEMS_Failed_Account_Message__c, GEMS_Failed_Addresses__c, GEMS_Failed_Benefit_Agreements__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                GEMS_Reserved_Group_Numbers__c, GEMS_Cobra_Auto_Can_Ind__c, GEMS_Is_Account_Derivated__c, OwnerId,
                                GEMS_Account_Submission_Info__c, GEMS_Account_Submission_Info__r.GEMS_Ready_to_release_to_screening__c,GEMS_Account_Submission_Info__r.GEMS_Submission_Type__c
                                FROM CASE
                                WHERE id = : input.accountStructureCaseID];

            if (responseLst.size()>0) { 
                responseRec = responseLst.get(0);
            } else {
                errFlag = true;
            }

            System.debug('AccStructResponse element:'+responseRec);
            if(cases != null && cases.size() > 0)
                accountStructureCase = cases[0];            
            
            /* SFDC-7450 - Custom Setting with List of the Service Request Record Types to Process */
            List<LGNACaseAccountCancellRecType__c> CustomSettingAppropriateRecordTypes = LGNACaseAccountCancellRecType__c.getAll().values();
            
            /* SFDC-7450 - Map to hold the RecordType ID for each Custom Setting entry */
            Map<Id,String> AppropriateRecTypeMap = new Map<Id,String>();
            
            /* SFDC-7450 - If running a Test add a value to eliminate Null References */
            if(Test.isRunningTest()){
                ID LGNAAccountCancellationCaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
                AppropriateRecTypeMap.put(LGNAAccountCancellationCaseRecType, 'Account Cancellation'); 
            }
            
            /* SFDC - 7450  Run thru the List of Custom Setting entries */
            for (LGNACaseAccountCancellRecType__c AnEntry: CustomSettingAppropriateRecordTypes){
                /* Get the RecordType ID */
                Id TemporaryId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(AnEntry.Record_Type_Name__c).getRecordTypeId();
                /* Put the ID and the Name in the Map */
                AppropriateRecTypeMap.put(TemporaryId, AnEntry.Record_Type_Name__c); 
                System.debug('Added a Record Type to Process: ' + AppropriateRecTypeMap);
            }           
            
            if(/* SFDC-7450 - LGNA Validation Isolation Added */
                (!errFlag && accountStructureCase != null && AppropriateRecTypeMap.containsKey(accountStructureCase.RecordTypeId))
                ||
                /* SFDC-7450 - GEMS Validation Isolation Added */
                (!errFlag && accountStructureCase != null && accountStructureCase.GEMS_Account_Submission_Info__c != null
                 && (accountStructureCase.GEMS_Account_Submission_Info__r.GEMS_Ready_to_release_to_screening__c != 'Released' || 
                     // US-5246 Added for Account Structure Maintenance flow
                     (accountStructureCase.GEMS_Account_Submission_Info__r.GEMS_Submission_Type__c == 'Account Structure Maintenance' && 
                      accountStructureCase.GEMS_Account_Submission_Info__r.GEMS_Ready_to_release_to_screening__c == 'Released')))) {
                caseId = accountStructureCase.Id;
                accountId = accountStructureCase.Account.Id;

                if(input.status == 'S') {
                    string validSession = UserInfo.getSessionId();
                    input.validSession = validSession;
                    string jsonstring = JSON.serializePretty(input);                    
                    addAttachmentToResponseRec(jsonString, responseRec.Id, reqCode);
                    //createAccountStructureInFuture(jsonstring);
                    output.status = 'S';
                    output.requestCode = input.requestCode;
                    output.accountStructureCaseID = input.accountStructureCaseID;
                    if(input.accountDetails != null)
                        output.accountNumber = input.accountDetails.accountNumber;

                    if (reqCode == 'Call1') {
                        responseRec.Call_1_status__c = 'R';
                        responseRec.Call_1_response_txt__c = 'Account Structure Part 1 received';
                    } else if (reqCode == 'Call2') {
                        responseRec.Call_2_status__c = 'R';
                        responseRec.Call_2_response_txt__c = 'Account Structure Part 2 received';
                    } else if (reqCode == 'Call3') {                           
                        GEMS_AccountStructureCreateServiceInput consInput = GEMS_AccountStructureCreateServiceHelper.fetchDeserializedData(
                                transactionId, input.accountStructureCaseID);

                        if (GEMS_AccountStructureCreateService.deleteAccountStructure()) {
                            GEMS_AccountStructureCreateService.processAddresses(consInput.accountDetails, consInput.addresses);
                            GEMS_AccountStructureCreateService.processGroupSections(consInput.groupSections);
                            GEMS_AccountStructureCreateService.processCategories(consInput.categories);
                            GEMS_AccountStructureCreateService.processCharacteristics(consInput.characteristics);
                            String fullJsonString = JSON.serialize(consInput);
                            GEMS_AccountStructureCreateService.createAccountStructureInFuture(fullJsonString);                    
                        }

                        responseRec.Response_Time__c = System.now();
                        responseRec.Call_3_status__c = 'R';                           
                        responseRec.Call_3_response_txt__c = 'Account Structure Part 3 received';
                    }
                    //accountStructureCase.GEMS_Integration_Message__c = output.message;                                     
                } else {
                    String status = 'E';
                    String responseTxt = input.message;
                    responseRec.Should_delete__c = true;

                    if (reqCode == 'Call1') {
                        responseRec.Call_1_status__c = status;
                        responseRec.Call_1_response_txt__c = responseTxt;
                        responseRec.Response_Time__c = System.now();  
                    } else if (reqCode == 'Call2') {
                        responseRec.Call_2_status__c = status;
                        responseRec.Call_2_response_txt__c = responseTxt;
                        responseRec.Response_Time__c = System.now();  
                    } else if (reqCode == 'Call3') {                           
                        responseRec.Call_3_status__c = status;
                        responseRec.Call_3_response_txt__c = responseTxt;
                        responseRec.Response_Time__c = System.now();                       
                    }
                }    
            }
            else{
                output.status = 'E';
                output.accountStructureCaseID = input.accountStructureCaseID;
                output.requestCode = input.requestCode;
                if(input.accountDetails != null)
                    output.accountNumber = input.accountDetails.accountNumber;
                output.message = 'Account Structure was already created in GEMS or incorrect accountStructureCaseID or invalid transactionId. Please contact GEMS Application Support.';
                // Since this is an error, update response time in response record
                if (null != responseRec) {
                    responseRec.Response_Time__c = System.now();
                    if (reqCode == 'Call1') {
                        responseRec.Call_1_status__c = 'E';
                        responseRec.Call_1_response_txt__c = output.message;
                    } else if (reqCode == 'Call2') {
                        responseRec.Call_2_status__c = 'E';
                        responseRec.Call_2_response_txt__c = output.message;
                    } else if (reqCode == 'Call3') {
                        responseRec.Call_3_status__c = 'E';
                        responseRec.Call_3_response_txt__c = output.message;
                    }
                    responseRec.Should_delete__c = true;
                }
            }            
        }
        catch(Exception ex){
            output.status = 'E';
            output.accountStructureCaseID = input.accountStructureCaseID;
            output.requestCode = input.requestCode;
            if(input.accountDetails != null)
                output.accountNumber = input.accountDetails.accountNumber;
            output.message = ex.getLineNumber() + ' : ' + ex.getMessage();
            if (responseRec != null) {
                responseRec.Response_Time__c = System.now();
                if (reqCode == 'Call1') {
                    responseRec.Call_1_status__c = 'E';
                    responseRec.Call_1_response_txt__c = output.message;
                } else if (reqCode == 'Call2') {
                    responseRec.Call_2_status__c = 'E';
                    responseRec.Call_2_response_txt__c = output.message;
                } else if (reqCode == 'Call3') {
                    responseRec.Call_3_status__c = 'E';
                    responseRec.Call_3_response_txt__c = output.message;
                }
                responseRec.Should_delete__c = true;
            }
        } finally {
            if (null != responseRec)
                upsert responseRec;
        }
        system.debug('BlueSTAR Response : ' + output);
        return output;    
    }

    public static void addAttachmentToResponseRec(String jsonString, Id respId, String filename) {
        Attachment a = new Attachment();
        a.Name = filename;
        a.Body = Blob.valueOf(jsonString);
        a.ContentType = 'application/json';
        a.ParentId = respId;
        insert a;
    }

    @future(callout = true)
    public static void createAccountStructureInFuture(string jsonString) {
        GEMS_AccountStructureCreateServiceInput input;
        GEMS_AccountStructureCreateServiceOutput output;
        try{
            input = (GEMS_AccountStructureCreateServiceInput) JSON.deserialize(jsonString, GEMS_AccountStructureCreateServiceInput.Class);            
            system.debug('Consolidated JsonString : ' + jsonString);
            output = GEMS_AccountStructureCreateServiceHelper.consolidateAccountStructureDetails(input);
            system.debug('Service Response : ' + output);
        }

        Catch(Exception ex){
            throw ex;
            system.debug('Service Exception : ' + ex);
        }

    }

    // deleting Account Structure
    public static boolean deleteAccountStructure(){

        try{

            list<GEMS_Cat_Char_Value_Association__c> delCatCharValues = [SELECT id FROM GEMS_Cat_Char_Value_Association__c
                                                                         WHERE Case__c =: caseId];
            list<GEMS_BA_Assignment__c> delBAGSAssignments = [SELECT id FROM GEMS_BA_Assignment__c
                                                              WHERE Case__c =: caseId];
            list<GEMS_Category_Assignment__c> delCategoryGSAssignments = [SELECT id FROM GEMS_Category_Assignment__c
                                                                          WHERE Case__c =: caseId];
            list<GEMS_BA_Category_Assignment__c> delBACategoryAssignments = [SELECT id FROM GEMS_BA_Category_Assignment__c
                                                                             WHERE Case__c =: caseId];        
            list<GEMS_BP_BA_Association__c> delBABPAssignments = [SELECT id FROM GEMS_BP_BA_Association__c
                                                                  WHERE Billing_Profile__r.Case__c =: caseId];
            list<GEMS_BP_Category_Association__c> delCategoryBPAssignments = [SELECT id FROM GEMS_BP_Category_Association__c
                                                                              WHERE Billing_Profile__r.Case__c =: caseId];

            list<GEMS_Benefit_Agreement__c> delBAs = [SELECT id FROM GEMS_Benefit_Agreement__c
                                                      WHERE AccountStructureCase__c =: caseId];

            list<GEMS_Characteristic_Value__c> delCharValues = [SELECT id FROM GEMS_Characteristic_Value__c
                                                                WHERE Case__c =: caseId];
            list<GEMS_Characteristic__c> delChars = [SELECT id FROM GEMS_Characteristic__c
                                                     WHERE Case__c =: caseId];        
            list<GEMS_Category__c> delCategories = [SELECT id FROM GEMS_Category__c
                                                    WHERE Case__c =: caseId];

            list<GEMS_Group_Section__c> delGroupSections = [SELECT id FROM GEMS_Group_Section__c
                                                            WHERE Case__c =: caseId];
            list<GEMS_Billing_Profile__c> delBillingProfiles = [SELECT id FROM GEMS_Billing_Profile__c
                                                                WHERE Case__c =: caseId];
            if(delCatCharValues != null)
                delete delCatCharValues;
            if(delBAGSAssignments != null)
                delete delBAGSAssignments;
            if(delCategoryGSAssignments != null)
                delete delCategoryGSAssignments;
            if(delBACategoryAssignments != null)
                delete delBACategoryAssignments;
            if(delBABPAssignments != null)
                delete delBABPAssignments;
            if(delCategoryBPAssignments != null)
                delete delCategoryBPAssignments;

            if(delBillingProfiles != null)
                delete delBillingProfiles;
            if(delGroupSections != null)
                delete delGroupSections;
            if(delCharValues != null)
                delete delCharValues;
            if(delChars != null)
                delete delChars;
            if(delCategories != null)
                delete delCategories;
            if(delBAs != null)
                delete delBAs;

            return true;
        }

        Catch(Exception ex){
            throw ex;
        }

    }

    // Adding new Addresses from Service
    public static void processAddresses(GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails,
            list<GEMS_AccountStructureCreateServiceInput.Address> addresses){

        // SFDC-7238. Get the existing primary address
        List<GEMS_Address__c> primAddrList = [Select id ,Usage__c, Address_Sequence__c from GEMS_Address__c where Account__c = :accountId and Usage__c includes('Primary') LIMIT 1];
        GEMS_Address__c primAddr = null;
        if (!primAddrList.isEmpty()) {
            primAddr = primAddrList[0];
        }
        // SFDC-7238. End
        
        // SFDC-7238. Build a map of addresses to be updated. Need this to track primary usage changes back and forth in the B* list 
        Map<String, GEMS_Address__c> upsertAddrMap = new Map<String, GEMS_Address__c>();
        
        for(GEMS_AccountStructureCreateServiceInput.Address address : addresses){
            GEMS_Address__c gemsAddress = new GEMS_Address__c();
            String addrSeq = accountDetails.corpCode + '-' + accountDetails.accountNumber + '-' + address.addressSequence;
            // If address has been processed already, it should be in the map. Retrieve it.
            // Otherwise create a new GEMS_Address object
            if (null != upsertAddrMap.get(addrSeq) && address.street != null) {
                gemsAddress = upsertAddrMap.get(addrSeq);
            }
            // SFDC-7238 End.
            if(address.street != null){
                gemsAddress.Name = address.street;
                gemsAddress.Account__c = accountId;
                gemsAddress.City__c = address.cityName;
                gemsAddress.State__c = address.state;
                if(address.countyCode != null && address.countyCode.isNumeric())
                    gemsAddress.County_Code__c = Integer.ValueOf(address.countyCode);
                gemsAddress.Zip_Code__c = address.zipCode;
                gemsAddress.Address_Sequence__c = addrSeq;
                gemsAddress.Country__c = address.countryCode;
                gemsAddress.IsNew__c = false;
                gemsAddress.IsUpdated__c = false;

                string usage;

                // SFDC-7238. Check if primary address already exists. If so, remove Primary usaqe and add to upsert map
                if(address.isPrimaryAddress && null != primAddr && primAddr.Address_Sequence__c != addrSeq) {
                    usage = 'Primary';
                    primAddr.Usage__c = primAddr.Usage__c.replace('Primary','');
                    upsert primAddr Address_Sequence__c;
                    // SFDC-7238. Bug fix. Don't overwrite the non-primary to map if already exists (it exists in map because it's processed)
                    if (null == upsertAddrMap.get(primAddr.Address_Sequence__c)) {
                        upsertAddrMap.put(primAddr.Address_Sequence__c, primAddr);
                    }
                    System.debug('After making non-primary::upsertAddrMap::'+ upsertAddrMap);
                } else if (address.isPrimaryAddress) {
                    usage = 'Primary';
                }
                // SFDC-7238 End                    

                if(address.isBillingAddress && usage != null)
                    usage = usage + ';' + 'Billing';
                if(address.isBillingAddress && usage == null)
                    usage = 'Billing';

                if(address.isMailingAddress && usage != null)
                    usage = usage + ';' + 'Mailing';
                if(address.isMailingAddress && usage == null)
                    usage = 'Mailing';

                if(address.isBaeAddress && usage != null)
                    usage = usage + ';' + 'BAE';
                if(address.isBaeAddress && usage == null)
                    usage = 'BAE';

                if(address.isSubsidaryAddress && usage != null)
                    usage = usage + ';' + 'Subsidary';
                if(address.isSubsidaryAddress && usage == null)
                    usage = 'Subsidary';

                if(address.isInvoiceAddress && usage != null)
                    usage = usage + ';' + 'Invoice';
                if(address.isInvoiceAddress && usage == null)
                    usage = 'Invoice';

                if(address.isThirdPartyAddress && usage != null)
                    usage = usage + ';' + 'ThirdParty';
                if(address.isThirdPartyAddress && usage == null)
                    usage = 'ThirdParty';

                if(address.isStlmAddress && usage != null)
                    usage = usage + ';' + 'Stlm';
                if(address.isStlmAddress && usage == null)
                    usage = 'Stlm';

                gemsAddress.Usage__c = usage;

                gemsAddress.Contact_Name__c = address.contactName;
                gemsAddress.Contact_Phone__c = address.contactPhoneNumber;

                try{
                    if(address.contactEmailAddress != null){  
                        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';                  
                        Pattern MyPattern = Pattern.compile(emailRegex);
                        Matcher MyMatcher = MyPattern.matcher(address.contactEmailAddress);

                        if (MyMatcher.matches()) 
                            gemsAddress.Contact_Email__c = address.contactEmailAddress;
                    }
                }
                catch(Exception ex){
                    //DO NOTHING Primary address already exists for this account
                }

                gemsAddress.OwnerId = accountStructureCase.OwnerId;

                // SFDC-7238 Add it to upsert map 
                //gemsAddresses.add(gemsAddress);
                upsertAddrMap.put(addrSeq, gemsAddress);
                // SFDC-7238 End
            }
        }

        // SFDC-7238 Add from the new list 
        List<GEMS_Address__c> upsertList = new List<GEMS_Address__c>();
        upsertList = upsertAddrMap.values();
        System.debug('Before upserting::upsertAddrMap::'+ upsertAddrMap);
        upsert upsertList Address_Sequence__c;


        for(GEMS_Address__c gemsAddress : upsertList){
            mapOfAddresses.put(gemsAddress.Address_Sequence__c.substring(gemsAddress.Address_Sequence__c.lastIndexOf('-') + 1), gemsAddress);
        }
        // SFDC-7238 End

    }

    // Creating new group sections
    public static void processGroupSections(list<GEMS_AccountStructureCreateServiceInput.GroupSection> groupSections){

        for(GEMS_AccountStructureCreateServiceInput.GroupSection groupSection : groupSections){
            GEMS_Group_Section__c gemsGroupSection = new GEMS_Group_Section__c();

            gemsGroupSection.Account__c = accountId;
            gemsGroupSection.Case__c = caseId;            
            gemsGroupSection.IsNew__c = false;

            gemsGroupSection.Group_No__c = groupSection.groupNumber;
            //allGroupNumbers.add(groupSection.groupNumber);
            gemsGroupSection.Section_No__c = groupSection.sectionNumber;
            gemsGroupSection.Section_Description__c = groupSection.sectionDescription;
            gemsGroupSection.Section_Eff_Date__c = groupSection.effectiveDate;            

            gemsGroupSection.Alpha_Prefix__c = groupSection.alphaPrefix;

            gemsGroupSection.SPI_Codes__c = groupSection.spiCodes;

            gemsGroupSection.Name = gemsGroupSection.Section_No__c + ' - ' + gemsGroupSection.Group_No__c;

            string parPlanCodes;

            if(groupSection.blueCrossPlanCode != null)
                parPlanCodes = groupSection.blueCrossPlanCode ;

            if(groupSection.blueShieldPlanCode != null && parPlanCodes != null)
                parPlanCodes = parPlanCodes + '/' + groupSection.blueShieldPlanCode;
            if(groupSection.blueShieldPlanCode != null && parPlanCodes == null)
                parPlanCodes = groupSection.blueShieldPlanCode;

            if(groupSection.majorMedicalPlanCode != null && parPlanCodes != null)
                parPlanCodes = parPlanCodes + '/' + groupSection.majorMedicalPlanCode;
            if(groupSection.majorMedicalPlanCode != null && parPlanCodes == null)
                parPlanCodes = groupSection.majorMedicalPlanCode;

            if(groupSection.drugPlanCode != null && parPlanCodes != null)
                parPlanCodes = parPlanCodes + '/' + groupSection.drugPlanCode;
            if(groupSection.drugPlanCode != null && parPlanCodes == null)
                parPlanCodes = groupSection.drugPlanCode;

            if(groupSection.dentalPlanCode != null && parPlanCodes != null)
                parPlanCodes = parPlanCodes + '/' + groupSection.dentalPlanCode;
            if(groupSection.dentalPlanCode != null && parPlanCodes == null)
                parPlanCodes = groupSection.dentalPlanCode;

            gemsGroupSection.Par_Plan_Codes__c = parPlanCodes;

            for(String assignedBANumber : groupSection.assignedBANumbers)
                basWithGroupSections.add(assignedBANumber);

            for(String assignedCategoryNumber : groupSection.assignedCategoryNumbers){
                if(assignedCategoryNumber != '0')
                    catsWithGroupSections.add(assignedCategoryNumber);
            }

            gemsGroupSections.add(gemsGroupSection);
        }

        insert gemsGroupSections;
    }

    public static void processCategories(list<GEMS_AccountStructureCreateServiceInput.Category> categories) {

        for (GEMS_AccountStructureCreateServiceInput.Category category : categories) {

            if (category.categoryNumber != '0') {
                GEMS_Category__c gemsCategory = new GEMS_Category__c();

                gemsCategory.Account__c = accountId;
                gemsCategory.Case__c = caseId;
                gemsCategory.IsNew__c = false;

                if (catsWithGroupSections.contains(category.categoryNumber))
                    gemsCategory.Has_Group_Sections__c = true;
                else
                    gemsCategory.Has_Group_Sections__c = false;

                gemsCategory.Name = GEMS_AccountStructureCreateServiceHelper.updateNumber(category.categoryNumber);
                // gemsCategory.Name = category.categoryNumber;
                gemsCategory.Category_Description__c = category.categoryDescription;
                gemsCategory.Effective_Date__c = category.effectiveDate;

                gemsCategory.Category_Cobra_Code__c = category.categoryCobraCode;

                gemsCategory.Usage_Reporting__c = category.reportingIndicator;

                gemsCategory.Usage_Product__c = category.productIndicator;
                // gemsCategory.BA_Fund_Type__c = category.productBANumber;

                gemsCategory.Usage_Billing__c = category.billingIndicator;

                gemsCategory.Usage_Mailing__c = category.mailIndicator;

                if (category.mailIndicator && category.mailingAddressSequence != null
                        && mapOfAddresses.get(category.mailingAddressSequence) != null) {
                    gemsCategory.Mailing_Address__c = mapOfAddresses.get(category.mailingAddressSequence).Id;
                }

                gemsCategory.Members_Derivation_Type__c = category.membersDerivationTypeCode;

                gemsCategories.add(gemsCategory);
            }
        }

        insert gemsCategories;
    }

    // Creating Characteristics and Characterisitic Values based on Service
    // Response
    public static void processCharacteristics(list<GEMS_AccountStructureCreateServiceInput.Characteristic> characteristics){
        corpCharCode = [select Id,CORP_Characteristic_Code__c from GEMS_Corp_Characteristic_Code__c];
        for(GEMS_Corp_Characteristic_Code__c c : corpCharCode){
            mapOfCorpCharCode.put(c.CORP_Characteristic_Code__c, c.id);
        }

        for(GEMS_AccountStructureCreateServiceInput.Characteristic characteristic : characteristics){
            GEMS_Characteristic__c gemsChar = new GEMS_Characteristic__c();

            gemsChar.Account__c = accountId;
            gemsChar.Case__c = caseId;
            gemsChar.OwnerId = accountStructureCase.OwnerId;
            gemsChar.IsNew__c = false;
            gemsChar.Corp_Characteristic_Code__c = mapOfCorpCharCode.get(characteristic.characteristicCode);
            gemsChar.Comments__c = characteristic.characteristicCode;//Please do not delete the comment field
            //gemsChar.Comments__c = characteristic.characteristicDescription;????????????????
            gemsChar.Effective_Date__c = characteristic.effectiveDate;

            gemsChar.Product__c = characteristic.productIndicator;
            gemsChar.Billing__c = characteristic.billingIndicator;
            gemsChar.Reporting__c = characteristic.reportingIndicator;
            gemsChar.Mailing__c = characteristic.mailIndicator;
            gemsChar.Other__c = characteristic.otherIndicator;

            gemsChar.Mandatory__c = characteristic.mandatoryGroupIndicator;
            gemsChars.add(gemsChar);
        }

        insert gemsChars;
    }
}