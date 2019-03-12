public with sharing class GEMS_OpportunityProductInfoController {

    public List<Opportunity_Product__c> oliList{get;set;}
    
    public GEMS_OpportunityProductInfoController(ApexPages.StandardController controller) {
        try {
          ID caseID = apexpages.currentpage().getparameters().get('id');
          case caseRec =[select id,Opportunity_Name__c from case where id =:caseID];
          oliList=[select  Product__c,Funding_Type__c,Product_Category__c from  Opportunity_Product__c where Opportunity_Name__c =:caseRec.Opportunity_Name__c];
         }
         catch(Exception ex) {
         System.debug('============Exception==='+ex.getMessage());
         }
    }
    

}