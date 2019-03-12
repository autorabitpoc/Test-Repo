@isTest(SeeAllData=false)
private class ApexJobContactUpdateTest {
    
    public static Map<String, List<Contact>> contactMap;

    @testSetup static void setup() {

        SearchFIPS__c searchFIPS = new SearchFIPS__c();
        searchFIPS.Name = '6061200031';
        searchFIPS.FIPS_Code__c = '00031';
        searchFIPS.ZipCode__c = '60612';
        searchFIPS.State__c = 'IL';
        insert searchFIPS;

        Global__c globalCS = new Global__c();
        globalCS.CRLF__c = 'a\r\nb';
        globalCS.SetupOwnerId = UserInfo.getProfileId();
        insert globalCS;

        Id groupContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get( Label.Group_Contact ).getRecordTypeId();

        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.External_ID__c = 'IL000000';
        testAccount.BillingStateCode = 'IL';
        insert testAccount; 

        Contact testContact = new Contact();

        List<Contact> testContacts = new List<Contact>();
        List<String> contactTypes = new List<String>{'Primary', 'Mailing', 'Billing', 'BAE'};

        for(String type: contactTypes){
            testContact = new Contact(RecordTypeId = groupContactRecordType, FirstName = 'FIRST',LastName = 'LAST',Type__c = type, Title = 'Account Executive',Phone = '(000) 000-0000-1234',Fax = '(000) 000-0000',MailingCountry = 'US',MailingStreet = '123 Main Street\r\nAttn: John Doe',MailingStateCode = 'IL',MailingPostalCode = '60612',Account_Address_Sequence_Number__c = '123',AccountId = testAccount.Id,Account = testAccount,Account__r = testAccount);
            testContacts.add(testContact);
        }
        insert testContacts;
    }

     @isTest static void testConstructor(){
        Test.startTest();
            ApexJobContactUpdate apexJob = new ApexJobContactUpdate(); 
        Test.stopTest();
     }

    @isTest static void testPrimaryContact(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'Primary\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
            apexJobService.execute(null);
            String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>N</WBaeInd><WBillInd>N</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>N</WMailInd><WPrimChgInd/><WPrimInd>Y</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        Test.stopTest();

        System.assertEquals(soapBody,apexJobService.body);

    }

    @isTest static void testBillingContact(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'Billing\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
        apexJobService.execute(null);
        String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>N</WBaeInd><WBillInd>Y</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>N</WMailInd><WPrimChgInd/><WPrimInd>N</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        System.assertEquals(soapBody,apexJobService.body);
        Test.stopTest();

    }

    @isTest static void testMailingContact(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'Mailing\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
        apexJobService.execute(null);
        String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>N</WBaeInd><WBillInd>N</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>Y</WMailInd><WPrimChgInd/><WPrimInd>N</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        System.assertEquals(soapBody,apexJobService.body);
        Test.stopTest();

    }

    @isTest static void testBAEContact(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'BAE\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
        apexJobService.execute(null);
        String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>Y</WBaeInd><WBillInd>N</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>N</WMailInd><WPrimChgInd/><WPrimInd>N</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        System.assertEquals(soapBody,apexJobService.body);
        Test.stopTest();

    }

    @isTest static void testBillingWithPrimaryAddressUsage(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        Id groupContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get( Label.Group_Contact ).getRecordTypeId();

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'Billing\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        Contact testContact2 = new Contact();
        testContact2.RecordTypeId = groupContactRecordType;
        testContact2.FirstName = 'JANE';
        testContact2.LastName = 'DOE';
        testContact2.Type__c = 'Primary';
        testContact2.Title = 'Account Executive';
        testContact2.Phone = '(111) 111-1111-1234';
        testContact2.Fax = '(111) 111-1111';
        testContact2.MailingCountry = 'United States';
        testContact2.MailingCountry = 'US';
        testContact2.MailingStreet = '456 Main Street\r\nAttn: Jane Doe';
        testContact2.MailingStateCode = 'IL';
        testContact2.MailingPostalCode = '60661';
        testContact2.Account_Address_Sequence_Number__c = '123';
        insert testContact2;

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact,testContact2}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
        apexJobService.execute(null);
        String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>N</WBaeInd><WBillInd>Y</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>N</WMailInd><WPrimChgInd/><WPrimInd>Y</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        System.assertEquals(soapBody,apexJobService.body);
        Test.stopTest();

    }

    @isTest static void testMailingWithPrimaryAddressUsage(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        Id groupContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get( Label.Group_Contact ).getRecordTypeId();

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'Mailing\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        Contact testContact2 = new Contact();
        testContact2.RecordTypeId = groupContactRecordType;
        testContact2.FirstName = 'JANE';
        testContact2.LastName = 'DOE';
        testContact2.Type__c = 'Primary';
        testContact2.Title = 'Account Executive';
        testContact2.Phone = '(111) 111-1111-1234';
        testContact2.Fax = '(111) 111-1111';
        testContact2.MailingCountry = 'United States';
        testContact2.MailingCountry = 'US';
        testContact2.MailingStreet = '456 Main Street\r\nAttn: Jane Doe';
        testContact2.MailingStateCode = 'IL';
        testContact2.MailingPostalCode = '60661';
        testContact2.Account_Address_Sequence_Number__c = '123';
        insert testContact2;

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact,testContact2}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
        apexJobService.execute(null);
        String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>N</WBaeInd><WBillInd>N</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>Y</WMailInd><WPrimChgInd/><WPrimInd>Y</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        System.assertEquals(soapBody,apexJobService.body);
        Test.stopTest();

    }

    @isTest static void testBAEWithPrimaryAddressUsage(){

        SearchFIPS__c searchFIPS = [SELECT FIPS_Code__c FROM SearchFIPS__c LIMIT 1];

        Id groupContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get( Label.Group_Contact ).getRecordTypeId();

        String soql = 'SELECT ';
        for(String field : Contact.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += field + ',';
        }
        for(String field : Account.SObjectType.getDescribe().fields.getMap().keySet()){
            soql += 'Account.' + field + ',';
        }
        soql = soql.removeEnd(',');

        soql +=  ' FROM Contact WHERE Type__c = \'BAE\'';
        Contact testContact = (Contact)Database.query(soql)[0];

        Contact testContact2 = new Contact();
        testContact2.RecordTypeId = groupContactRecordType;
        testContact2.FirstName = 'JANE';
        testContact2.LastName = 'DOE';
        testContact2.Type__c = 'Primary';
        testContact2.Title = 'Account Executive';
        testContact2.Phone = '(111) 111-1111-1234';
        testContact2.Fax = '(111) 111-1111';
        testContact2.MailingCountry = 'United States';
        testContact2.MailingCountry = 'US';
        testContact2.MailingStreet = '456 Main Street\r\nAttn: Jane Doe';
        testContact2.MailingStateCode = 'IL';
        testContact2.MailingPostalCode = '60661';
        testContact2.Account_Address_Sequence_Number__c = '123';
        insert testContact2;

        List<Contact> contacts = new List<Contact>();
        contacts.add(testContact);
        
        Id organizationId = UserInfo.getOrganizationId();
        Id profileId = fflib_IDGenerator.generate( Profile.SObjectType );
        Encryption_Key__c encryptionKeyCS = new Encryption_Key__c();
        Blob cryptoKey = Crypto.generateAesKey(128);
        encryptionKeyCS.Encryption_Key__c = EncodingUtil.base64Encode(cryptoKey);
        encryptionKeyCS.SetupOwnerId = profileId;

        fflib_ApexMocks userMocks = new fflib_ApexMocks();
        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        fflib_ApexMocks organizationMocks = new fflib_ApexMocks();
        fflib_ApexMocks contactMocks = new fflib_ApexMocks();

        UserDAO.IUserDAO userMockDAO; 
        userMockDAO = new MockDAOs.UserDAOMock(userMocks);

        userMocks.startStubbing();
        userMocks.when(userMockDAO.getUserIdByProfileName('Integration Profile'))
                        .thenReturn(profileId);
        userMocks.stopStubbing();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(profileId))
                        .thenReturn(encryptionKeyCS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getFIPSByStateAndZip('IL','60612'))
                        .thenReturn(searchFIPS);
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getUsernamePasswordCSByName(''))
                        .thenReturn('http://www.bluestar.com/service');
        customSettingMocks.stopStubbing();

        OrganizationDAO.IOrganizationDAO organizationMockDAO; 
        organizationMockDAO = new MockDAOs.OrganizationDAOMock(organizationMocks);

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.getCurrentOrganizationId())
                        .thenReturn(organizationId);
        organizationMocks.stopStubbing();

        organizationMocks.startStubbing();
        organizationMocks.when(organizationMockDAO.isRunningInSandbox())
                        .thenReturn(true);
        organizationMocks.stopStubbing();

        ContactDAO.IContactDAO contactMockDAO; 
        contactMockDAO = new MockDAOs.ContactDAOMock(contactMocks);

        contactMocks.startStubbing();
        contactMocks.when(contactMockDAO.getContactsById(new List<Id>{testContact.Id}))
                        .thenReturn(new List<Contact>{testContact});
                        

        contactMocks.when(contactMockDAO.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(new List<Contact>{testContact}, new List<String>{'Primary', 'Billing', 'BAE', 'Mailing'}))
                        .thenReturn(new Map<String, List<Contact>>{'123'=>new List<Contact>{testContact,testContact2}});
        contactMocks.stopStubbing();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = globalDescribeMap.get('Contact');
        Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
        System.debug('fieldset: ' + fieldSet);

        fflib_ApexMocks fieldSetMocks = new fflib_ApexMocks();
        FieldSetDAO.IFieldSetDAO fieldSetMockDAO; 
        fieldSetMockDAO = new MockDAOs.FieldSetDAOMock(fieldSetMocks);

        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetByNameAndSObject('BlueSTAR_Contact_Primary_Required_Fields', 'Contact'))
                        .thenReturn(fieldSet);
        fieldSetMocks.stopStubbing();

        List<String> fieldPaths = new List<String>();
        for(FieldSetMember fieldSetMember: fieldSet.getFields()){
            fieldPaths.add(fieldSetMember.getFieldPath());
        }
        System.debug('fieldPaths: ' + fieldPaths);
        fieldSetMocks.startStubbing();
        fieldSetMocks.when(fieldSetMockDAO.getFieldSetMemberFieldPaths(fieldSet))
                        .thenReturn(fieldPaths);
        fieldSetMocks.stopStubbing();

        fflib_ApexMocks encryptionMocks = new fflib_ApexMocks();
        EncryptionUtility.IEncryptionUtility encryptionMockUtility; 
        encryptionMockUtility = new MockDAOs.EncryptionUtilityMock(encryptionMocks);

        encryptionMocks.startStubbing();
        encryptionMocks.when(encryptionMockUtility.getDecryptedMessage('message'))
                        .thenReturn('testKey');
        encryptionMocks.stopStubbing();

        fflib_ApexMocks calloutMocks = new fflib_ApexMocks();
        CalloutUtility.ICalloutUtility calloutMockUtility; 
        calloutMockUtility = new MockDAOs.CalloutUtilityMock(calloutMocks);

        calloutMocks.startStubbing();
        calloutMocks.when(calloutMockUtility.sendCallout('username', 'password', 'body', 'endpoint', 'certificate', 'organizationId', 'type'))
                        .thenReturn(new HttpResponse());
        calloutMocks.stopStubbing();

        fflib_ApexMocks cronTriggerMocks = new fflib_ApexMocks();
        CronTriggerDAO.ICronTriggerDAO cronTriggerMockDAO; 
        cronTriggerMockDAO = new MockDAOs.CronTriggerDAOMock(cronTriggerMocks);

        cronTriggerMocks.startStubbing();
        cronTriggerMocks.when(cronTriggerMockDAO.getCronDetailCountByName(''))
                        .thenReturn(1);
        cronTriggerMocks.stopStubbing();

        fflib_ApexMocks customMetadataMocks = new fflib_ApexMocks();
        CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeMockDAO; 
        customMetadataTypeMockDAO = new MockDAOs.CustomMetadataTypeDAOMock(customMetadataMocks);

        Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
        Set<String> customWsAddressFields = new Set<String>();
        String wsAddressQuery = 'SELECT ';

        for (String field : wsAddressFields.keySet()) {
            if(field.contains('__c')){
                wsAddressQuery += field + ',';
                customWsAddressFields.add(field);
            }
        }
        wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
        BlueSTAR_MEAB139_WSDL_wsAddress__mdt wsAddress = Database.query(wsAddressQuery);

        System.debug('wsAddress ' + wsAddress);

        customMetadataMocks.startStubbing();
        customMetadataMocks.when(customMetadataTypeMockDAO.getCustomMetadaTypeDynamically(wsAddressQuery))
                        .thenReturn(wsAddress);
        customMetadataMocks.stopStubbing();

        ApexJobContactUpdate apexJobService = new ApexJobContactUpdate(contacts,
                                                                        customSettingMockDAO,
                                                                            contactMockDAO,
                                                                                organizationMockDAO,
                                                                                    fieldSetMockDAO,
                                                                                        encryptionMockUtility,
                                                                                            calloutMockUtility,
                                                                                                cronTriggerMockDAO,
                                                                                                    userMockDAO,
                                                                                                        new CustomMetadataTypeDAO());
        apexJobService.setSObject(contacts);
        apexJobService.userDAOInstance.getUserIdByProfileName('Integration Profile');

        Test.startTest();
        apexJobService.execute(null);
        String soapBody = '<controlBlock><applReturnCode/><dataLength/><originatorId/><reserved/><serviceAlias/><serviceStatus/><startOfData/><tag/><transactionControl/><version/></controlBlock><meReqCtl><fwAcctStaCd/><fwActCd/><fwAddrFixInd/><fwApplid/><fwAutoFlow/><fwBusinessFunc/><fwBypassEdit/><fwBypassMsgInd/><fwCallingProcess/><fwDocSrc/><fwExecMode/><fwInitngTrnSeqNbr/><fwInvReqCd/><fwLogMsgFlg/><fwMemshpTrackngNbr/><fwNicAddr/><fwPendSeqNbr/><fwPmEventId/><fwPmLevel/><fwPrgSecToken/><fwPrgTrcFlg/><fwReqFill2/><fwReqWormWrote/><fwTableFlag/><fwTranSrcCd/><fwUserid/><reqRowCount/></meReqCtl><wsAddress><EMailAddr></EMailAddr><WBaeInd>Y</WBaeInd><WBillInd>N</WBillInd><WIdcardInd/><WInvcInd/><WMailInd>N</WMailInd><WPrimChgInd/><WPrimInd>Y</WPrimInd><WStlmInd/><WSubsidInd/><WThrdPrtyInd/><acctAddrNm>Test Account</acctAddrNm><acctAddrSeqNbr>123</acctAddrSeqNbr><acctNbr>000000</acctNbr><cntryCd>US</cntryCd><cntryNm>United States</cntryNm><cntyCd>031</cntyCd><contcFaxNbr>0000000000</contcFaxNbr><contcNm>FIRST LAST</contcNm><contcPhnNbrExt>1234</contcPhnNbrExt><contcPhnNbr>0000000000</contcPhnNbr><contcTtl>Account Executive</contcTtl><corpEntCd>IL1</corpEntCd><ctyNm></ctyNm><frgnPostlCd/><lastChgUsrid/><prevCntyCd/><prevStateCd/><provinceCd/><stateCd>IL</stateCd><strLn1>123 Main Street</strLn1><strLn2>Attn: John Doe</strLn2><wsChgBaeInd/><wsChgBillInd/><wsChgIdcardInd/><wsChgInvcInd/><wsChgMailInd/><wsChgStlmInd/><wsChgSubsidInd/><wsChgThrdPrtyInd/><zipCd>60612</zipCd></wsAddress><acctStaCd></acctStaCd><rowCd>U</rowCd>';
        System.assertEquals(soapBody,apexJobService.body);
        Test.stopTest();

    }
}