@isTest
public class SGR_GSPS_GetAvailablePlansSc_Test {
    static testMethod void testMethod1() {
        Fips_Mapping_for_Plan_Batch__c fip = new Fips_Mapping_for_Plan_Batch__c();
        fip.Fips_Code__c = '17003';
        fip.HCSC_State__c = 'IL';
        fip.Name = '17003';
        insert fip;

        test.startTest();
        SGR_GSPS_GetAvailablePlansSchedule sb = new SGR_GSPS_GetAvailablePlansSchedule();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('GSPS_Test_Schedule', CRON_EXP, sb);
        //System.schedule('Test', CRON_EXP, sb);
        test.stopTest();
    }

}