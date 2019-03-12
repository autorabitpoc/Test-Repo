//*************************************************************************************
// Name             : SGR_GSPS_GetProductGroups.cls
// Description      : Callout To get Product Groups
// Created By       : Raviteja 
// Created Date     : 10/29/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 30/10/2018       Raviteja             SFDC 14273,14274 
// 11/20/2018       Mei Chen			Updated to call within loop of Fipscode
// ************************************************************************************
public class SGR_GSPS_GetProductGroups {
    @TestVisible private final String SGR_INTEGRATION_NAME = 'GSPS_ProductGroupCallOut';
    @TestVisible private static UserDAO.IUserDAO userDAOInstance;
    @TestVisible private static String EXCEPTION_MESSAGE = 'EndPoint not configured';

    public static String errorMessage;
    private List<FW_Service_Status_Log__c> logsList = new List<FW_Service_Status_Log__c>();
    private APICallOutRestWSUtility objUtility;
    public SGR_GSPS_GetProductGroups() {
        this.objUtility = new APICallOutRestWSUtility(SGR_INTEGRATION_NAME);

    }

    public void callGSPSProductGroupService(String clientId, Integer Version, Date effectiveDate, String state,
            String marketSegment, String fundingType) {
        List<SGR_Product_Group__c> productGroupList = new List<SGR_Product_Group__c>();
        List<FW_Service_Status_Log__c> logList = new List<FW_Service_Status_Log__c>();
        AggregateResult[] fips = [SELECT FIPS_Code__c, State__c FROM SearchFIPS__c WHERE State__c = :state GROUP BY FIPS_Code__c, State__c];
        List<String> fipsCodeList = new List<String>();
        for (AggregateResult ar : fips) {
            fipsCodeList.add(String.valueOf(ar.get('FIPS_Code__c')));
        }
        system.debug('fipscode List;:::' + fipsCodeList);
        String fipsCodeStr = String.join(fipsCodeList, ';');
        try {
            List<SGR_Product_Group__c> pgData = getGSPSProductGroup(clientId, Version, effectiveDate, state, marketSegment,
                    fundingType, fipsCodeStr);
            system.debug('size of pgData:' + pgData);

            if (pgData != null && !pgData.isEmpty()) {
                system.debug(' add new pg Data....');
                productGroupList.addAll(pgData);
            }
            List<String> errMsgsList = new List<String>();
            if (productGroupList != null && productGroupList.size() > 0) {

                system.debug('@@@@@@productGroupList:::::' + productGroupList);

                Database.UpsertResult [] results = Database.upsert(productGroupList, SGR_Product_Group__c.SGR_Product_Group_External_ID__c, false);

                system.debug('upSert result:::::' + results);

                if (results != null) {
                    for (Database.UpsertResult sv : results) {
                        if (sv != null && sv.isSuccess()) {
                            System.debug('*****Success::**' + sv.getId());
                        } else {
                            system.debug('something wrong when insert/update the product group data.' + sv.getErrors());
                            for (Database.Error err : sv.getErrors()) {
                                if (err != null) {
                                    errMsgsList.add(err.getMessage());
                                }
                            }
                            if (errMsgsList != null && !errMsgsList.isEmpty()) {
                                createErroLog(errMsgsList);
                            }
                        }

                    }
                }

            }

            if (logsList != null && !logsList.isEmpty()) {
                insert logsList;
            }

            if (objUtility != null && objUtility.newAccessToken != null) {
                objUtility.oAuthUtil.updateToken(objUtility.newAccessToken);
            }
        } catch (system.DmlException dml) {
            system.debug('insert product group exception::' + dml);
        } catch (Exception e) {
            system.debug('product group general exception:::' + e);
        }

    }
    public List<SGR_Product_Group__c> getGSPSProductGroup(String clientId, Integer Version, Date effectiveDate, String division,
            String marketSegment, String fundingType, String fipsCodes) {

        system.debug('calling callSGPS Product group Service.....fips code:.' + fipsCodes + 'state: ' + division);
        List<SGR_Product_Group__c> pgList = new List<SGR_Product_Group__c>();
        Set<Id> succPGIDS = new Set<Id>();
        try {
            SGR_GSPS_ProductGroupRequestWrapper objRequestWrapper = new SGR_GSPS_ProductGroupRequestWrapper();
            objRequestWrapper.clientId = clientId;
            objRequestWrapper.version = Version;
            objRequestWrapper.effectiveDate = effectiveDate;
            objRequestWrapper.division = division;
            objRequestWrapper.marketSegment = marketSegment;
            objRequestWrapper.fundingType = fundingType;
            objRequestWrapper.fipsCode = null ;//fipsCode;no need to pass the fipscode

            if (objRequestWrapper != null) {
                SGR_GSPS_ProductGroupResponseWrapper objResponseWrappertoProcess = objUtility.invokeProductGroupService(objRequestWrapper);

                if (objUtility.integrationStatuLog != null) {
                    logsList.add(objUtility.integrationStatuLog);
                }

                pgList = handleGSPSServiceResponse(objResponseWrappertoProcess, clientId, fipsCodes);

            }

        } catch (Exception e) {
            System.debug('OAUTH Exception:' + e.getMessage() + ' ' + e.getStackTraceString());
        }

        return pgList;
    }
    @TestVisible
    private List<SGR_Product_Group__c> handleGSPSServiceResponse(SGR_GSPS_ProductGroupResponseWrapper
            objResponseWrappertoProcess,
            String clientId, String fipsCodeStr) {
        List<SGR_Product_Group__c> pgList = new List<SGR_Product_Group__c>();
        Set<Id> succPGIDS = new Set<Id>();

        if (objResponseWrappertoProcess.responseItemsList != null) {
            system.debug('@@@@@@' + objResponseWrappertoProcess.responseItemsList + ' client Id:::' + clientId +
                    ' fipsCode....' + fipsCodeStr);
            for (SGR_GSPS_ProductGroupResponseWrapper.SGR_GSPS_ProductGroupResponseItems
            obj : objResponseWrappertoProcess.responseItemsList) {

                SGR_Product_Group__c sPG = new SGR_Product_Group__c();
                sPG.Name = obj.name;
                sPG.SGR_Product_Group_Code__c = obj.productGroupCode;
                sPG.SGR_Market_Segment__c = obj.marketSegment;
                sPG.SGR_Division__c = obj.division;
                sPG.FIPS_Code__c = fipsCodeStr;

                if (obj.effectiveDate != null) {
                    sPG.SGR_Effective_Date__c = Utility.parseDate(obj.effectiveDate);

                }
                if (obj.endDate != null) {
                    sPG.SGR_Expiry_Date__c = Utility.parseDate(obj.endDate);

                }
                sPG.SGR_Funding_Type__c = obj.fundingType;
                sPG.SGR_Line_of_Business__c = obj.lineOfBusiness;
                sPG.SGR_Product_Group_Type__c = format(obj.productGroupType);
                sPG.SGR_Product_Group_External_ID__c = convertPgExtId(obj.productGroupCode, obj.marketSegment, obj.division,
                        sPG.SGR_Effective_Date__c, sPG.SGR_Expiry_Date__c,
                        obj.lineOfBusiness);
                sPG.SGR_Client_ID__c = clientId;
                system.debug('@@@@@@' + sPG.SGR_Product_Group_External_ID__c);
                pgList.add(sPG);

            }
            system.debug('********size****' + pglist.size());
        }
        return pgList;
    }
    public static String format(List<String> values) {
        if (values == null) return null;
        return String.join(values, ';');
    }
    public static void createErroLog(List<String> errMsgsLst) {
        List<Error_Log__c> errLst = new List<Error_Log__c>();
        for (String er : errMsgsLst) {
            Error_Log__c errLog = new Error_Log__c();
            errLog.Application__c = System.Label.ErrorLog_Application_TriggerOff;
            errLog.Error_Message__c = er;
            errLst.add(errLog);
        }
        if (errLst.size() > 0) {
            insert errLst;
        }
    }

    public static String convertPgExtId(String productGroupCode, String marketSegment, String division, Date effctDate,
            Date expDate, String lineOfBusiness) {
        return productGroupCode + marketSegment + division + (effctDate == null ? '0/0/0'
                : effctDate.format()) + lineOfBusiness;
    }
}