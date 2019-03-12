@isTest
public class OppRenewalProdLoadInvocableTest {
    
    public static testmethod void Test0001(){
        
        /* create Account */
        Account anAccount = TestClassUtiltity.createAccountWithRecType('The Big Account',Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId());
        System.debug('anAccount: ' + anAccount.Id);
        
        /* create Renewal Opportunity */
        Opportunity anOpportunity = TestClassUtiltity.newOpportunity(anAccount.Id,'The Big Opportunity');
        anOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        insert anOpportunity;        
        System.debug('anOpportunity: ' + anOpportunity.Id);
        
        /* create Products */
        List<Product2> theProducts = TestClassUtiltity.createProducts();        
        insert theProducts;
        System.debug('theProducts: ' + theProducts);
        
        List<Account_Products__c> theAccountProducts = new List<Account_Products__c>();
        
        Integer Counter = 0;
        
        for(Product2 aProduct : theProducts){           
            
            Account_Products__c anAccountProduct = new Account_Products__c();
            
            System.debug('in Loop > anAccount: '+ anAccount.Id);            
            anAccountProduct.Account__c = anAccount.Id;
            
            System.debug('in Loop > aProduct: '+ anAccount.Id);
            anAccountProduct.Product2__c = aProduct.Id;
            
            anAccountProduct.Active_Contracts__c = 100;
            
            anAccountProduct.Active_Members__c = 1000;
            
            if(Counter == 0){
                Date todaysDate = System.today();
                anAccountProduct.Effective_End_Date__c = todaysDate;
            }
            
            theAccountProducts.add(anAccountProduct);
            
            Counter = Counter + 1;
        }
        insert theAccountProducts;
        System.debug('theAccountProducts: ' + theAccountProducts);
        
        
        Test.startTest();
        
        List<Opportunity> passToMethod = [SELECT Id, Name FROM Opportunity LIMIT 1]; 
        
        OppRenewalProdLoadInvocable.OppRenewalProductsLoad(passToMethod);        
        
        Test.stopTest();
        
        /* There were 3 Account Products created.  1 should not pass the SELECT in the Class.  Only 2 */
        /* should be loaded as part of processing.                                                    */
        List<Opportunity_Product__c> postTestOpportunityProducts = new List<Opportunity_Product__c>();
        postTestOpportunityProducts = [SELECT Id, Projected_Contracts__c, Projected_Members__c FROM Opportunity_Product__c WHERE Opportunity_Name__c = :anOpportunity.Id];        
        System.assertEquals(2, postTestOpportunityProducts.size(),'There should only be 2 Opportunity Products Loaded.');
        System.assert(postTestOpportunityProducts[0].Projected_Contracts__c == 100,'The Active Contracts did not load properly');
        System.assert(postTestOpportunityProducts[0].Projected_Members__c == 1000,'The Active Members did not load properly');
    }
    
}