global class BatchAddressCache implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{

    Boolean hasError = false; 
    Integer attempt = 0;
    String stateCode;
    String userQuery = 'SELECT id From User where Id = \''+UserInfo.getUserId()+'\'';
    String errorMessage = null; 
    public static final String ADDRESS_SERVICE = 'Address_Service';
    wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList response;
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}
    @TestVisible private CalloutUtility.ICalloutUtility calloutUtilityInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private EmailUtility.IEmailUtility emailUtilityInstance {get; set;}
    
    public BatchAddressCache(String stateCode, Integer attempt) {
        this(stateCode, attempt, new CustomMetadataTypeDAO(), 
                        new CalloutUtility(), new OrganizationDAO(), new EmailUtility());
    }

    @TestVisible private BatchAddressCache(String stateCode, Integer attempt, 
                                                CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance, 
                                                    CalloutUtility.ICalloutUtility calloutUtilityInstance, 
                                                        OrganizationDAO.IOrganizationDAO organizationDAOInstance,
                                                            EmailUtility.IEmailUtility emailUtilityInstance) {
        hasError = false;
        this.attempt = attempt;
        this.stateCode = stateCode;
        this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
        this.calloutUtilityInstance = calloutUtilityInstance;
        this.organizationDAOInstance = organizationDAOInstance;
        this.emailUtilityInstance = emailUtilityInstance;
    }
    
    global Database.queryLocator start(Database.BatchableContext ctx) {
        Callout_Configuration__mdt calloutConfig;
        try {
            if (!organizationDAOInstance.isRunningInSandbox()) {
                calloutConfig = customMetadatTypeDAOInstance.getCustomMetadaTypeByName('Address_Service_PROD');
            } else {
                calloutConfig = customMetadatTypeDAOInstance.getCustomMetadaTypeByName('Address_Service_TEST');
            }           
            
            /* SFDC-5798 - Added as part of Test Class Remediation - Begin */
            /* if (!Test.isRunningTest()) { */
            CalloutUtility.STATE_CODE = stateCode;
            response = (wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationshipList) calloutUtilityInstance.sendCallout(null, null,null, calloutConfig.Endpoint_URL__c, calloutConfig.SSL_Certificate__c, null, ADDRESS_SERVICE);     
            /* } */
            /* SFDC-5798 - Added as part of Test Class Remediation - End */
            
        }catch (Exception e) {
            hasError = true;
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Batch Apex', 'SearchFIPS__C', 
                                                                null, 'BatchAddressCache.start()', 'High');            
        }
        return Database.getQueryLocator(userQuery);
    }        
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {

        Integer indx = -1;
        Integer lstindx = -1;
        List<SearchFIPS__c> result = new List<SearchFIPS__c>();
        SearchFIPS__c searchObj = null;
        
        try {
            if (response!= null && response.zipCodeToCountiesRelationships!=null) {
                System.debug('Response: ' + response.zipCodeToCountiesRelationships.zipCodeToCountiesRelationship);
                for (wwwHcscComCorpItMnssAddressSvcV4.zipCodeToCountiesRelationship resObj : response.zipCodeToCountiesRelationships.zipCodeToCountiesRelationship) {
                    for (wwwHcscComCorpItMnssAddressSvcV4.county cntObj : resObj.counties.county) {
                        searchObj = new SearchFIPS__c(Name = resObj.zipCode+cntObj.fipsStateCode2+cntObj.fipsCountyCode3, 
                        FIPS_Code__c = cntObj.fipsStateCode2+cntObj.fipsCountyCode3, ZipCode__c = resObj.zipCode,
                        State__c = cntObj.stateCode != null ? cntObj.stateCode.toUpperCase() : cntObj.stateCode);                   
                        result.add(searchObj);                                              
                    }
                }
                  
                if (result.size() > 0) {
                    System.debug('result: ' + result.size());
                    Database.upsert(result, SearchFIPS__c.Name);
                }
            } else {
                   System.debug('is null');
                    hasError = true;           
            }
        } catch(Exception e) {
            hasError = true;    
            System.debug('Exception: ' + e);        
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Batch Apex', 'SearchFIPS__C', 
                                                                null, 'BatchAddressCache.execute()', 'High');
        }
    }
    
    global void finish(Database.BatchableContext ctx) {

        String emailMessage = '';

        if (!hasError) {
            attempt = 0;
           
            if (stateCode == 'IL') {
                stateCode = 'NM'; 
            } else if (stateCode == 'NM') {
                stateCode = 'OK';
            } else if (stateCode == 'OK') {
                stateCode = 'TX';
            } else if (stateCode == 'TX') {
                stateCode = 'MT';
            } else if (stateCode == 'MT') {
                stateCode = null;
            }
                
            if (stateCode != null) {                          
                BatchAddressCache batch = new BatchAddressCache(stateCode, attempt);
                Database.executeBatch(batch);
            }
            else {
                emailMessage =  System.Label.Internal_Address_Service_Success;
                emailUtilityInstance.circulateEmail(UserInfo.getUserEmail(), 'BatchAddressCache Success', emailMessage); 
            }           
        }
        else if (hasError) {
            attempt++;
            if (attempt <= 4) {
                BatchAddressCache batch = new BatchAddressCache(stateCode, attempt);
                Database.executeBatch(batch);
            }
            else {
                emailMessage =  System.Label.Internal_Address_Service_Error.replace('{!statecode}', stateCode);
                emailUtilityInstance.circulateEmail(Utility.constantMap.get(103), 'BatchAddressCache Error', emailMessage);              
            }           
        }
    }
    
    /* SFDC-5798 - Added as part of Test Class Remediation - Begin */
    // Inner Class
    public class CountyDetails {
        String name;
        String stateCode;
        String fipsStateCode;
        String city;
        String zipCode;
        
        public CountyDetails(String name, String stateCode, String fipsStateCode, String city, String zipCode) {
            this.name = name;
            this.stateCode = stateCode;
            this.fipsStateCode = fipsStateCode;
            this.city = city;
            this.zipCode = zipCode;
        }
        
    }
    /* SFDC-5798 - Added as part of Test Class Remediation - End */
    
}