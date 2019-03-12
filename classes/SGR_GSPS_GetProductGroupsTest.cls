@isTest
public class SGR_GSPS_GetProductGroupsTest {

    @isTest
    public static void testProductGroups_Success() {
        Test.loadData(Username_Password__c.SObjectType, 'UserNamePasswordTestData');
        Test.loadData(OAuth_Jwt_Token2__c.SObjectType, 'JwtOauth2TestData');
        String mockResBody = '[{"name": "Health/Dental/Life","productGroupCode": "QHP_IL_HDL","productGroupType": ["Health", "Dental","Life"],"division": "IL", "effectiveDate": "2014-01-01","endDate": "9999-12-31","marketSegment": "SG","fundingType": "PREM", "lineOfBusiness": "HDL"},{"name": "Health/Dental","productGroupCode": "QHP_IL_HD", "productGroupType": ["Health","Dental"],"division": "IL","effectiveDate": "2014-01-01", "endDate": "9999-12-31","marketSegment": "SG","fundingType": "PREM","lineOfBusiness": "HD"}]';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseProductGroup(200, '{"username": "test","access_token": "test","token_type": "Bearer","expires_in": 3650, "refresh_token": "test", "scope": "oob", "jwt_token": "test"}'));
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseProductGroup(200, mockResBody));
        SGR_Product_Group__c sPG = new SGR_Product_Group__c();
        sPG.Name = 'Health';
        sPG.SGR_Product_Group_Code__c = 'QHP_IL_HDL';
        sPG.SGR_Market_Segment__c = 'SG';
        sPG.SGR_Division__c = 'IL';
        String str = '2014-01-01';
        String str1 = '2014-01-05';
        sPG.SGR_Effective_Date__c = Utility.parseDate(str);
        sPG.SGR_Expiry_Date__c = Utility.parseDate(str1);
        sPG.SGR_Product_Group_Type__c = 'dxf';
        Date effectiveDate = Date.newInstance(2019, 01, 01);
        List<String> values = new List<String>();
        List<Error_Log__c> errLst = new List<Error_Log__c>();
        Error_Log__c errLog = new Error_Log__c();
        List<String> errMsgsLst = new List<String>();
        errMsgsLst.add('error');
        errMsgsLst.add('error12');
        errLog.Application__c = System.Label.ErrorLog_Application_TriggerOff;
        errLog.Error_Message__c = 'error';
        errLst.add(errLog);
        Test.startTest();
        SGR_GSPS_ProductGroupRequestWrapper requestWrapper = new SGR_GSPS_ProductGroupRequestWrapper();
        SGR_GSPS_GetProductGroups productGroup = new SGR_GSPS_GetProductGroups();
        SGR_GSPS_ProductGroupResponseWrapper responseWrapper = new SGR_GSPS_ProductGroupResponseWrapper();
        responseWrapper.responseItemsList = new List<SGR_GSPS_ProductGroupResponseWrapper.SGR_GSPS_ProductGroupResponseItems>();
        responseWrapper.responseItemsList = SGR_GSPS_ProductGroupResponseWrapper.parse(mockResBody);
        productGroup.callGSPSProductGroupService('RENEWALS', null, effectiveDate, 'IL', 'SG', 'PREM');
        productGroup.handleGSPSServiceResponse(responseWrapper, '', '14008');
        SGR_GSPS_GetProductGroups.format(values);
        SGR_GSPS_GetProductGroups.createErroLog(values);
        SGR_GSPS_GetProductGroups.createErroLog(errMsgsLst);
        Test.stopTest();
    }
}