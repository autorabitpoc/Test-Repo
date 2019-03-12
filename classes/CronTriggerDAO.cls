public class CronTriggerDAO implements ICronTriggerDAO{
    
    public interface ICronTriggerDAO{
        Integer getCronDetailCountByName(String name);
        CronTrigger getCronTriggerByDetailName(String name);
    }
    
    public Integer getCronDetailCountByName(String name){
       return [SELECT COUNT() FROM CronJobDetail WHERE Name =:name];
    }

    public CronTrigger getCronTriggerByDetailName(String name){
       return [SELECT Id FROM CronTrigger WHERE CronJobDetail.name =:name];
    }    
}