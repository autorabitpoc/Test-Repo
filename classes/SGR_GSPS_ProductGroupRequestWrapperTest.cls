@isTest
public class SGR_GSPS_ProductGroupRequestWrapperTest {

    @isTest static void myUnitTest() {
        Date effectiveDate = Date.newInstance(2019, 01, 01);
        new SGR_GSPS_GetProductGroups().callGSPSProductGroupService('RENEWALS', 1, effectiveDate, 'NM', 'SG', 'PREM');
        SGR_GSPS_ProductGroupRequestWrapper wrP = new SGR_GSPS_ProductGroupRequestWrapper();
        wrP.clientId = 'RENEWALS' ;
        wrP.version = 1 ;
        wrP.marketSegment = 'SG';
        wrP.effectiveDate = effectiveDate;
        wrP.division = 'NM';
        wrP.fundingType = 'PREM';

    }

}