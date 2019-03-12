@isTest
public class SGR_DentalAgeRateTablesBatchScheduleTest{
    static testmethod void  testschedule(){
        String cronExp = '0 0 0 15 3 ? *';
        Test.StartTest();
        String jobId = System.schedule('ScheduleApexClassTest',  cronExp, new SGR_DentalAgeRateTablesBatchSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}