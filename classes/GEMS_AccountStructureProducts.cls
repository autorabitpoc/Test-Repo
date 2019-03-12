public without sharing class GEMS_AccountStructureProducts{

    public Case StructureCase {get;set;}
    public list<Opportunity_Product__c> OppPro {get; set;}
    public Id OpID;
    
    
    public GEMS_AccountStructureProducts(ApexPages.StandardController controller){
    
        this.StructureCase = (Case)Controller.getRecord();
        
        try{
            OppPro = getOpportunityProduct();
        //OpID=  ApexPages.currentPage().getParameters().get('opId');
        }Catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_AccountStructureProducts.getOpportunityProduct()','High'); 
        }
    
    }

    public list<Opportunity_Product__c> getOpportunityProduct(){
        OppPro = [SELECT Id, Product__c, Product_Category__c, Funding_Type__c, Product_Family__c FROM Opportunity_Product__c WHERE Opportunity_Name__c = '00656000001fQUp']; 
        System.debug('Opportunity Product list is' + oppPro);  
        return oppPro;
    }
}