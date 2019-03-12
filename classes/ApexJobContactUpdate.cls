public class ApexJobContactUpdate implements IQueueable, Database.AllowsCallouts {

    @TestVisible private List<Contact> contacts {get; set;}
    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance {get; set;}
    @TestVisible private ContactDAO.IContactDAO contactDAOInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private FieldSetDAO.IFieldSetDAO fieldSetDAOInstance {get; set;}
    @TestVisible private EncryptionUtility.IEncryptionUtility encryptionUtilityInstance {get; set;}
    @TestVisible private CalloutUtility.ICalloutUtility calloutUtilityInstance {get; set;}
    @TestVisible private CronTriggerDAO.ICronTriggerDAO cronTriggerDAOInstance {get; set;}
    @TestVisible private UserDAO.IUserDAO userDAOInstance {get; set;}
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}

    public static final String SCHEDULABLE_CALLOUT = SchedulableCallout.class.getName();
    public static final String BLUESTAR     = 'BlueSTAR';
    public static final String STR_LN_1     = 'strLn1__c';
    public static final String STR_LN_2     = 'strLn2__c';
    public static final String CNTY_CD      = 'cntyCd__c';
    public static final String ZIP_CD       = 'zipCd__c';
    public static final String CNTC_PHN_NBR = 'contcPhnNbr__c';
    public static final String CONTC_PHN_NBR_EXT_BSTAR = 'contcPhnNbrExt__c';
    public static final String CONTC_PHN_FIELD_SFDC    = 'Phone';
    public static final String CONTC_FAX_FIELD_SFDC    = 'Fax';
    public static final String CONTC_EID_FIELD_SFDC    = 'Account.External_ID__c';
    public static final String EMPTY_STRING = '';
    public String body = EMPTY_STRING;
    public static final String CARRIAGE_RETURN = '\r\n';
    public static final String YES = 'Y';
    public static final String NO = 'N';

    public static final String PRIM_IND = 'wprimind__c';
    public static final String MAIL_IND = 'wmailind__c';
    public static final String BILL_IND = 'wbillind__c';
    public static final String BAE_IND  = 'wbaeind__c';

    public static final String PRIMARY = 'Primary';
    public static final String MAILING = 'Mailing';
    public static final String BILLING = 'Billing';
    public static final String BAE     = 'BAE';

    public ApexJobContactUpdate() {
        this(new List<Contact>());
    }

    public ApexJobContactUpdate(List<Contact> contacts) {
        this(contacts, new CustomSettingDAO(), new ContactDAO(), 
                        new OrganizationDAO(), new FieldSetDAO(), 
                                    new EncryptionUtility(), new CalloutUtility(),
                                                    new CronTriggerDAO(), new UserDAO(),
                                                                    new CustomMetadataTypeDAO());
    }

    @TestVisible 
    private ApexJobContactUpdate(List<Contact> contacts,
                                    CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
                                        ContactDAO.IContactDAO contactDAOInstance,
                                            OrganizationDAO.IOrganizationDAO organizationDAOInstance,
                                                FieldSetDAO.IFieldSetDAO fieldSetDAOInstance,
                                                    EncryptionUtility.IEncryptionUtility encryptionUtilityInstance,
                                                        CalloutUtility.ICalloutUtility calloutUtilityInstance,
                                                            CronTriggerDAO.ICronTriggerDAO cronTriggerDAOInstance,
                                                                UserDAO.IUserDAO userDAOInstance,
                                                                    CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance) {
        this.contacts                     = contacts;
        this.customSettingDAOInstance     = customSettingDAOInstance;
        this.contactDAOInstance           = contactDAOInstance;
        this.organizationDAOInstance      = organizationDAOInstance;
        this.fieldSetDAOInstance          = fieldSetDAOInstance;
        this.encryptionUtilityInstance    = encryptionUtilityInstance;
        this.calloutUtilityInstance       = calloutUtilityInstance;
        this.cronTriggerDAOInstance       = cronTriggerDAOInstance;
        this.userDAOInstance              = userDAOInstance;
        this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
    }
    
    public void setSObject(List<SObject> sobjects){
        this.contacts = (List<Contact>) sobjects;
    }
    
    public void execute(QueueableContext context) {

        try {
            Id profileId = userDAOInstance.getUserIdByProfileName(System.Label.ProfileIntegrationProfile);
            Encryption_Key__c encryptionKey = customSettingDAOInstance.getEncryptionKeyCSByProfileId(profileId);

            String organizationId = organizationDAOInstance.getCurrentOrganizationId();
            Blob cryptoKey = EncodingUtil.base64Decode(encryptionKey.Encryption_Key__c);
            Callout_Configuration__mdt calloutConfig;

            if (!organizationDAOInstance.isRunningInSandbox()) {
                calloutConfig = customMetadatTypeDAOInstance.getCustomMetadaTypeByName('BlueSTAR_Meab139_PROD');
            } else {
                calloutConfig = customMetadatTypeDAOInstance.getCustomMetadaTypeByName('BlueSTAR_Meab139_TEST');
            }
          
            BlueSTAR_MEAB139_ControlBlock__mdt meab139CtrlBlckMDT;
            Map<String, Schema.SobjectField> ctrlBlckfields = 
                            BlueSTAR_MEAB139_ControlBlock__mdt.getSObjectType().getDescribe().fields.getMap();
           
            Set<String> customCtrlBlckfields = new Set<String>();
            if(!ctrlBlckfields.isEmpty()){
                String ctrlBlckQuery = 'SELECT ';

                for (String field : ctrlBlckfields.keySet()) {
                    if(field.contains('__c')){
                        ctrlBlckQuery += field + ',';
                        customCtrlBlckfields.add(field);
                    }
                }
                ctrlBlckQuery += ' Label FROM BlueSTAR_MEAB139_ControlBlock__mdt WHERE DeveloperName = \'ControlBlock_Fields\' LIMIT 1';
                meab139CtrlBlckMDT = (BlueSTAR_MEAB139_ControlBlock__mdt) customMetadatTypeDAOInstance.getCustomMetadaTypeDynamically(ctrlBlckQuery);
            }

            BlueSTAR_MEAB139_WSDL_meReqCtl__mdt meab139meReqCtlMDT;
            Map<String, Schema.SobjectField> meReqCtlFields = BlueSTAR_MEAB139_WSDL_meReqCtl__mdt.getSObjectType().getDescribe().fields.getMap();
            Set<String> customMeReqCtlFields = new Set<String>();
            if(!meReqCtlFields.isEmpty()){
                String meReqCtlQuery = 'SELECT ';

                for (String field : meReqCtlFields.keySet()) {
                    if(field.contains('__c')){
                        meReqCtlQuery += field + ',';
                        customMeReqCtlFields.add(field);
                    }
                }
                meReqCtlQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_meReqCtl__mdt WHERE DeveloperName = \'meReqCtl_Fields\' LIMIT 1';
                meab139meReqCtlMDT = (BlueSTAR_MEAB139_WSDL_meReqCtl__mdt) customMetadatTypeDAOInstance.getCustomMetadaTypeDynamically(meReqCtlQuery);
            }

            BlueSTAR_MEAB139_WSDL_wsAddress__mdt meab139wsAddressMDT;
            Map<String, Schema.SobjectField> wsAddressFields = BlueSTAR_MEAB139_WSDL_wsAddress__mdt.getSObjectType().getDescribe().fields.getMap();
            Set<String> customWsAddressFields = new Set<String>();
            if(!wsAddressFields.isEmpty()){
                
                String wsAddressQuery = 'SELECT ';

                for (String field : wsAddressFields.keySet()) {
                    if(field.contains('__c')){
                        wsAddressQuery += field + ',';
                        customWsAddressFields.add(field);
                    }
                }
                wsAddressQuery += ' Label FROM BlueSTAR_MEAB139_WSDL_wsAddress__mdt WHERE DeveloperName = \'wsAddress_Fields\' LIMIT 1';
                meab139wsAddressMDT = (BlueSTAR_MEAB139_WSDL_wsAddress__mdt) customMetadatTypeDAOInstance.getCustomMetadaTypeDynamically(wsAddressQuery);
            }

            List<Id> contactIds = new List<Id>();
            SObjectType sobjType = Contact.sObjectType;
            List<Id> contactList = new List<Id>();
            contactList.addAll(Pluck.Ids(contacts));

            Map<Id, Contact> contactMap = new Map<Id, Contact>(contactDAOInstance.getContactsById(contactList));
            HttpResponse response;

            List<String> primaryBillingStr;
            primaryBillingStr = new List<String>{PRIMARY, BILLING, BAE, MAILING};
            Map<String, List<Contact>> contractIdToCases = contactDAOInstance.getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(contactMap.values(), primaryBillingStr);          
           
            body = EMPTY_STRING;
            for (Contact contact : contactMap.values()) {

                String selectedFieldSet;
                if (contact.Type__c == ConstantsController.contactTypePrimary) {
                    selectedFieldSet = ConstantsController.blueSTARContactPrimaryFieldSet;
                } else if (contact.Type__c == ConstantsController.contactTypeBAE) {
                    selectedFieldSet = ConstantsController.blueSTARContactBAEFieldSet;
                } else if (contact.Type__c == ConstantsController.contactTypeMailing) {
                    selectedFieldSet = ConstantsController.blueSTARContactMailingFieldSet;
                } else if (contact.Type__c == ConstantsController.contactTypeBilling) {
                    selectedFieldSet = ConstantsController.blueSTARContactBillingFieldSet;
                }

                Schema.FieldSet currentFieldSet = fieldSetDAOInstance.getFieldSetByNameAndSObject(selectedFieldSet, 'Contact');
                List<String> fieldList = fieldSetDAOInstance.getFieldSetMemberFieldPaths(currentFieldSet);
                Set<String> allowedFieldsToUpdate = new Set<String>(fieldList);
                
                body = '<' + meab139CtrlBlckMDT.Label + '>';
                for (String field : customCtrlBlckfields) {
                    String fieldLabel = ctrlBlckfields.get(field).getDescribe().getLabel();
                    if((meab139CtrlBlckMDT.get(field) != null &&
                             !((String)meab139CtrlBlckMDT.get(field)).trim().equals(EMPTY_STRING))) {
                        String meab139Field = (String)meab139CtrlBlckMDT.get(field);
                        if(sobjType.getDescribe().fields.getMap().containsKey(meab139Field) ||
                                                                        (meab139Field).contains('.')) {
                            List<String> splitFields = new List<String>();
                            if(meab139Field.contains('.')){
                                splitFields = meab139Field.split('\\.');
                            }
            
                            if(allowedFieldsToUpdate.contains(meab139Field.replace('.','__r.'))){
                                body += '<' + fieldLabel + '>';
                                if(splitFields.size()>1){ 
                                    body += (((String) contact.getSObject(splitFields[0]).get(splitFields[1])) != null ? 
                                            ((String) contact.getSObject(splitFields[0]).get(splitFields[1])).escapeXml() : EMPTY_STRING);
                                } else {
                                    body += (contact.get(meab139Field) != null ? 
                                        ((String) contact.get(meab139Field)).escapeXml() : EMPTY_STRING);
                                    
                                }
                                body += '</' + fieldLabel + '>';
                            } else {
                                body += '<' + fieldLabel + '/>';
                            }
                        } else {
                            body += '<' + fieldLabel + '>' + meab139Field + '</' + fieldLabel + '>';
                        }
                    } else {
                        body += '<' + fieldLabel + '/>';
                    }
                }
                body += '</' + meab139CtrlBlckMDT.Label + '>';

                body += '<' + meab139meReqCtlMDT.Label + '>';
                for (String field : customMeReqCtlFields) {
                    String fieldLabel = meReqCtlFields.get(field).getDescribe().getLabel();
                    if((meab139meReqCtlMDT.get(field) != null &&
                             !((String)meab139meReqCtlMDT.get(field)).trim().equals(EMPTY_STRING))) {
                        String meab139Field = (String)meab139meReqCtlMDT.get(field);
                        if(sobjType.getDescribe().fields.getMap().containsKey(meab139Field) ||
                                                                        (meab139Field).contains('.')) {
                            List<String> splitFields = new List<String>();
                            if(meab139Field.contains('.')){
                                splitFields = meab139Field.split('\\.');
                            }
            
                            if(allowedFieldsToUpdate.contains(meab139Field.replace('.','__r.'))){
                                body += '<' + fieldLabel + '>';
                                if(splitFields.size()>1){   
                                    body += (((String) contact.getSObject(splitFields[0]).get(splitFields[1])) != null ? 
                                            ((String) contact.getSObject(splitFields[0]).get(splitFields[1])).escapeXml() : EMPTY_STRING);
                                } else {
                                    body += (contact.get(meab139Field) != null ? 
                                            ((String) contact.get(meab139Field)).escapeXml() : EMPTY_STRING);
                                }
                                body += '</' + fieldLabel + '>';
                            } else {
                                body += '<' + fieldLabel + '/>';
                            }
                        } else {
                            body += '<' + fieldLabel + '>' + meab139Field + '</' + fieldLabel + '>';
                        }
                    } else {
                        body += '<' + fieldLabel + '/>';
                    }
                }
                body += '</' + meab139meReqCtlMDT.Label + '>';

                String phoneExt = EMPTY_STRING;
                String phone = EMPTY_STRING;

                Map<String, String> contactWSDLTypes; 
                contactWSDLTypes = new Map<String, String>{PRIM_IND=>NO, BAE_IND=>NO, BILL_IND=>NO, MAIL_IND=>NO};

                Map<String, String> contactTypes;
                contactTypes = new Map<String, String>{PRIMARY=>PRIM_IND, BAE=>BAE_IND, BILLING=>BILL_IND, MAILING=>MAIL_IND};

                body += '<' + meab139wsAddressMDT.Label + '>';
                for (String field : customWsAddressFields) {

                    if(contactWSDLTypes.containsKey(field)){
                        if(!contact.Type__c.equalsIgnoreCase(PRIMARY))
                        for(List<Contact> contacts:contractIdToCases.values()){
                            for(Contact c: contacts){
                                contactWSDLTypes.put(contactTypes.get(c.Type__c), YES);
                            }
                        } else {
                            contactWSDLTypes.put(contactTypes.get(PRIMARY), YES);
                        }
                    }

                    String fieldLabel = wsAddressFields.get(field).getDescribe().getLabel();
                    if((meab139wsAddressMDT.get(field) != null &&
                             !((String)meab139wsAddressMDT.get(field)).trim().equals(EMPTY_STRING))) {
                        String meab139Field = (String)meab139wsAddressMDT.get(field);
                        if(sobjType.getDescribe().fields.getMap().containsKey(meab139Field) ||
                                                                        (meab139Field).contains('.')) {
                            List<String> splitFields = new List<String>();
                            if(meab139Field.contains('.')){
                                splitFields = meab139Field.split('\\.');
                            }
                            
                            if(allowedFieldsToUpdate.contains(meab139Field.replace('.','__r.'))){
                                
                                body += '<' + fieldLabel + '>';
                                if(splitFields.size()>1){      
                                    String value = (((String) contact.getSObject(splitFields[0]).get(splitFields[1])) != null ? 
                                            ((String) contact.getSObject(splitFields[0]).get(splitFields[1])).escapeXml() : EMPTY_STRING);
                                     
                                    if(meab139Field.equalsIgnoreCase(CONTC_EID_FIELD_SFDC)){
                                        value = value.right(6);
                                    }
                                    body += value;
                                } else {
                                    String value =  EMPTY_STRING;
                                    if(contactWSDLTypes.containsKey(field)){
                                        value += contactWSDLTypes.get(field);
                                    }
                                    if(meab139Field.equals(CONTC_PHN_FIELD_SFDC) &&
                                            contact.get(meab139Field) != null){

                                        Pattern phonePattern; 
                                        phonePattern = Pattern.compile('(\\D?[0-9]{3}\\D?)[\\s]([0-9]{3})-([0-9]{4})-([0-9]*)');

                                        Matcher phoneMatcher; 
                                        phoneMatcher = phonePattern.matcher(String.valueOf(contact.get(meab139Field)));

                                        if(phoneMatcher.matches()){
                                            if(phoneMatcher.groupCount() == 4){
                                                phoneExt = phoneMatcher.group(4);
                                                phone = phoneMatcher.group(0).remove(phoneMatcher.group(4)).remove('-');
                                                phone = phone.remove('(');
                                                phone = phone.remove(')');
                                                phone = phone.remove(' ');
                                            }
                                        } else {
                                            phone = ((String)contact.get(meab139Field)).escapeXml();
                                            phone = phone.remove('(');
                                            phone = phone.remove(')');
                                            phone = phone.remove(' ');
                                            phone = phone.remove('-');
                                        }
                                    } 
                                    if(field.equalsIgnoreCase(CONTC_PHN_NBR_EXT_BSTAR) && phoneExt != null){
                                        value += phoneExt;
                                    } else if(field.equalsIgnoreCase(CNTC_PHN_NBR) && phone != null){
                                        value += phone;
                                    } else if((contact.get(meab139Field) != null) && 
                                                (field.equalsIgnoreCase(STR_LN_1) || field.equalsIgnoreCase(STR_LN_2))) {
                                            
                                            List<String> addressSplit = ((String)contact.get(meab139Field)).escapeXml().split(CARRIAGE_RETURN);
                                            if(!addressSplit.isEmpty() && addressSplit.size() > 1){
                                                value += (field.equalsIgnoreCase(STR_LN_1) ? 
                                                                addressSplit[0] : addressSplit[1]);
                                            } else if(!addressSplit.isEmpty() && 
                                                        addressSplit.size() == 1 &&
                                                            (field.equalsIgnoreCase(STR_LN_1))) {
                                                value += addressSplit[0].trim();
                                            }
                                    } else if(field.equalsIgnoreCase(CNTY_CD)){
                                        SearchFIPS__c searchFIPS = customSettingDAOInstance.getFIPSByStateAndZip(contact.MailingStateCode, contact.MailingPostalCode.left(5));
                                        value += searchFIPS.FIPS_Code__C.right(3);
                                    }  else if(field.equalsIgnoreCase(ZIP_CD)){
                                        String zipCode = contact.MailingPostalCode.replaceAll('[^0-9]', '');  
                                        value += zipCode;
                                    } else if(meab139Field.equals(CONTC_FAX_FIELD_SFDC)){
                                        value += (contact.get(meab139Field) != null ? 
                                            ((String) contact.get(meab139Field)).escapeXml() : EMPTY_STRING);
                                        value = value.remove('-');
                                        value = value.remove('(');
                                        value = value.remove(')');
                                        value = value.remove(' ');
                                    }

                                    if(value!=null  && !value.equals(EMPTY_STRING)){
                                        body += value;
                                    } else if(!field.equalsIgnoreCase(STR_LN_2) &&
                                                !field.equalsIgnoreCase(CONTC_PHN_NBR_EXT_BSTAR)) {
                                        body += (contact.get(meab139Field) != null ? 
                                            ((String) contact.get(meab139Field)).escapeXml() : EMPTY_STRING);
                                    }   
                                    
                                }
                                body += '</' + fieldLabel + '>';
                            } else {
                                body += '<' + fieldLabel + '/>';
                            }
                        } else {
                            body += '<' + fieldLabel + '>' + meab139Field + '</' + fieldLabel + '>';
                        }
                    } else {
                        body += '<' + fieldLabel + '/>';
                    }
                }
                body += '</' + meab139wsAddressMDT.Label + '>';

                body += '<acctStaCd></acctStaCd>';
                body += '<rowCd>U</rowCd>';
                contactMap.get(contact.Id).Integration_Action__c = 'Update';
                contactMap.get(contact.Id).Time_Sent__c = System.now();
                try {
                    if(!Test.isRunningTest()){
                        response = (HttpResponse) calloutUtilityInstance.sendCallout(calloutConfig.UserName__c, 
                                                                            encryptionUtilityInstance.getDecryptedMessage(calloutConfig.Password__c), 
                                                                                    body, calloutConfig.Endpoint_URL__c, calloutConfig.SSL_Certificate__c, organizationId, BLUESTAR);
                    }
                         
                } catch(System.CalloutException e) {
                    if(!contacts.isEmpty() && 
                                cronTriggerDAOInstance.getCronDetailCountByName
                                            (SCHEDULABLE_CALLOUT + contacts[0].Id) == 0){

                        String hour = String.valueOf(Datetime.now().hour());
                        String minute = String.valueOf(Datetime.now().minute() + 1); 
                        String second = String.valueOf(Datetime.now().second());
                        String nextFireTime = second + ' ' + minute + ' ' + hour + ' * * ?';

                        System.schedule(SCHEDULABLE_CALLOUT  + contacts[0].Id, nextFireTime, 
                                            new SchedulableCallout(contacts, calloutConfig.UserName__c, 
                                                    encryptionUtilityInstance.getDecryptedMessage(calloutConfig.Password__c), 
                                                            body, calloutConfig.Endpoint_URL__c, calloutConfig.SSL_Certificate__c, organizationId, calloutConfig.Scheduled_Apex_Class__c));
                    } else {
                        System.abortJob(cronTriggerDAOInstance.getCronTriggerByDetailName(SCHEDULABLE_CALLOUT + contacts[0].Id).Id);    
                    }
                    return;
                }
       
                if(response != null){
                    if (response.getStatusCode() == 200) {
                        contactMap.get(contact.Id).Integration_Status__c = 'Success';

                        if(cronTriggerDAOInstance.getCronDetailCountByName
                                                (SCHEDULABLE_CALLOUT + contacts[0].Id) != 0){
                            System.abortJob(cronTriggerDAOInstance.getCronTriggerByDetailName(SCHEDULABLE_CALLOUT + contacts[0].Id).Id);
                        } 

                    } else {

                        contactMap.get(contact.Id).Integration_Status__c = 'Failure';
                        contactMap.get(contact.Id).Time_Sent__c = System.now();

                        CreateExceptionLog.insertErrorLog(new CalloutException(response.getBody()), null, null, null, 'Apex Class', 'Contact', null, 'ApexJobContactUpdate.execute()', 'High');

                        if(!contacts.isEmpty() && 
                                    cronTriggerDAOInstance.getCronDetailCountByName
                                                (SCHEDULABLE_CALLOUT + contacts[0].Id) == 0){

                            String hour = String.valueOf(Datetime.now().hour());
                            String minute = String.valueOf(Datetime.now().minute() + 1); 
                            String second = String.valueOf(Datetime.now().second());
                            String nextFireTime = second + ' ' + minute + ' ' + hour + ' * * ?';

                            System.schedule(SCHEDULABLE_CALLOUT  + contacts[0].Id, nextFireTime, 
                                                new SchedulableCallout(contacts, calloutConfig.UserName__c, 
                                                        encryptionUtilityInstance.getDecryptedMessage(calloutConfig.Password__c), 
                                                                body, calloutConfig.Endpoint_URL__c, calloutConfig.SSL_Certificate__c, organizationId, calloutConfig.Scheduled_Apex_Class__c));
                        } else {
                            System.abortJob(cronTriggerDAOInstance.getCronTriggerByDetailName(SCHEDULABLE_CALLOUT + contacts[0].Id).Id);
                        }
                    }
                } else {
                    CreateExceptionLog.insertErrorLog(new CalloutException('Callout response object is null.'), null, null, null, 'Apex Class', 'Contact', null, 'ApexJobContactUpdate.execute()', 'High');
                }
            }

            contactDAOInstance.updateContacts(contactMap.values());

        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Contact', 
                                                                null, 'ApexJobContactUpdate.execute()', 'High');
        }
    }

    public class CalloutException extends Exception {}

}