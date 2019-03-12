public class SGR_AdditonalInputRequiredButton {
    
    @AuraEnabled
    public static String getAdditionalInputRequired(String caseId){
        List<Case> queryCases = new List<Case>();
        try{
            for(List<Case> caseList : [select Case_Owner__c,Status from case where Owner.Type='Queue']){
                for(Case c : caseList){
                  c.Status = 'Additional Input Required';
                  c.ownerId ='SGR- Operations Queue';  
                }
               update caseList; 
            }
           
        }catch(Exception e){  
            System.debug('Unexpected exception occurred: '+e.getMessage());
         }
   return 'Success';
    }
    
}