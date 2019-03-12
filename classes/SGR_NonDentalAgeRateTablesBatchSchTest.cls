@isTest
public class SGR_NonDentalAgeRateTablesBatchSchTest{
    static testmethod void  testschedule(){
        String CRON_EXP = '0 0 0 15 4 ? *';
        Test.StartTest();
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new SGR_NonDentalAgeRateTablesBatchSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}