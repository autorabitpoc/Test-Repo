global class ProcessScreeningBatch implements Database.Batchable<Case>{
    global List<Case> screeningCasesInsertList = new List<Case>();
    
    global ProcessScreeningBatch(List<Case> screeningCasesInsertList){
      this.screeningCasesInsertList = screeningCasesInsertList;      
    }
    
    global Iterable<Case> start(Database.BatchableContext BC){
      return screeningCasesInsertList;
   }
   
   global void execute(Database.BatchableContext BC, List<Case> screeningCases){
       insert screeningCases;
   }
   global void finish(Database.BatchableContext BC){
       System.debug('Job finished--');
   }
}