public class BatchDetailWrapper{
        String batchId;
        Integer count;
        String succMsg;
         String errMsg;
        public BatchDetailWrapper(String batchId,Integer count,String succMsg){
            this.batchId=batchId;
            this.count=count;
            this.succMsg=succMsg;
            this.errMsg=errMsg;
        }
        
    }