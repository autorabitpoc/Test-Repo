public with Sharing class LightningShowPopoverController {
    
    @auraEnabled
    public static Account_Products__c getAccountProductData(String recordId){
        Account_Products__c ap=new Account_Products__c();
        system.debug('acc product recordId:'+recordId);
        if(recordId!=null){
            ap=[select id, Name, Product__c, Product2__c,  product2__r.name, product2__r.Family, product2__r.Description, product2__r.ProductCode from Account_Products__c where id=:recordId];
            
        }
        return ap;
    }
    
     @auraEnabled
    public static Opportunity_Product__c getOpportunityProductData(String recordId){
       Opportunity_Product__c op=new Opportunity_Product__c();
        system.debug('acc product recordId:'+recordId);
        
        if(recordId!=null){
            op=[SELECT Id, name,Status__c,Product__c,Effective_Date__c,Projected_Members__c,Projected_Contracts__c FROM Opportunity_Product__c where id=:recordId];
            
        }
        return op;
    }
    
   @auraEnabled 
    public static Product2 getProductData(String recordId){
        system.debug('product 2 recordId:'+recordId);
        Product2  p2=new Product2();
        
        if(recordId!=null){
            p2=[select id, Name, Family,Description, ProductCode from Product2 where id=:recordId];
        }
        system.debug('product data: '+p2);
        return p2;
        
    }
    
    
    
}