public class SGR_GSPS_GetProductGroupBatchScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        SGR_GSPS_GetProductGroupBatch batch = new SGR_GSPS_GetProductGroupBatch('IL', 0, false);
        Database.executeBatch(batch, 1);
    }
}