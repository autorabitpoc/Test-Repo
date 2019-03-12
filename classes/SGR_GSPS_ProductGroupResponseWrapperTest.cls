@IsTest
public class SGR_GSPS_ProductGroupResponseWrapperTest {

    static testMethod void testParse() {
        String json = '[{\"name\":\"Health/Dental/Life\",\"productGroupCode\":\"QHP_NM_HDL\",\"productGroupType\":[\"Health\",\"Vision\",\"Dental\",\"Life\"],\"division\":\"NM\",\"effectiveDate\":\"2014-01-01\",\"endDate\":\"9999-12-31\",\"marketSegment\":\"SG\",\"fundingType\":\"PREM\",\"lineOfBusiness\":\"HDL\"},{\"name\":\"Health/Dental\",\"productGroupCode\":\"QHP_NM_HD\",\"productGroupType\":[\"Health\",\"Vision\",\"Dental\"],\"division\":\"NM\",\"effectiveDate\":\"2014-01-01\",\"endDate\":\"9999-12-31\",\"marketSegment\":\"SG\",\"fundingType\":\"PREM\",\"lineOfBusiness\":\"HD\"},{\"name\":\"Health\",\"productGroupCode\":\"QHP_NM_H\",\"productGroupType\":[\"Health\",\"Vision\"],\"division\":\"NM\",\"effectiveDate\":\"2014-01-01\",\"endDate\":\"9999-12-31\",\"marketSegment\":\"SG\",\"fundingType\":\"PREM\",\"lineOfBusiness\":\"H\"},{\"name\":\"Dental\",\"productGroupCode\":\"QHP_NM_D\",\"productGroupType\":[\"Dental\"],\"division\":\"NM\",\"effectiveDate\":\"2014-01-01\",\"endDate\":\"9999-12-31\",\"marketSegment\":\"SG\",\"fundingType\":\"PREM\",\"lineOfBusiness\":\"D\"}]';
        List<SGR_GSPS_ProductGroupResponseWrapper.SGR_GSPS_ProductGroupResponseItems> obj = SGR_GSPS_ProductGroupResponseWrapper.parse(json);
        System.assert(obj != null);
    }
}