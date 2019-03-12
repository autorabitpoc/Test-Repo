/****************************************************************************************/
/* Description:  This Class was created to be called from a Process Builder as part of  */
/*               the Renewal Opporutunity creation process.  It will automatically load */
/*               some specific Account Products.                                        */
/****************************************************************************************/
/* History - 04/2018 - SFDC-9349 - Initial Version                                      */
/****************************************************************************************/

global class OppRenewalProdLoadInvocable {
    
    /* SFDC-9349 - 04/2018 - Begin */
    @InvocableMethod(label='OppRenewalProductsLoad' description='For Renewal Opportunities this will pre-load some Account Products.')
    global static void OppRenewalProductsLoad(List<Opportunity> TheOpportunities){
        
        System.debug('Start - OppRenewalProductsLoad: ' + TheOpportunities);
        
        /* create a List to hold the records to be Inserted */
        List<Opportunity_Product__c> theOpportunityProductsToInsert = new List<Opportunity_Product__c>();
        
        /* process the Opportunities passed into the method */
        for(Opportunity AnOpportunity : TheOpportunities){
            
            System.debug('Processing Opportunity: ' + AnOpportunity);
            
            List<Opportunity> copyOfOpportunity = [SELECT 
                                                   Id, AccountId, RecordTypeId, HCSC_Division__c 
                                                   FROM Opportunity 
                                                   WHERE Id = :AnOpportunity.Id 
                                                   LIMIT 1];
            
            System.debug('copyOfOpportunity: '+ copyOfOpportunity);
            
            /* ensure that only RENEWAL Opportunities are processed */
            if(copyOfOpportunity[0].RecordTypeId != Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId()){
                System.debug('Opportunity Renewal Record Type Id: ' + Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId());
                System.debug('This Opportunity is **not** a Renewal, Bypass It: ' + AnOpportunity.RecordTypeId);
                break;
            }
            
            // Get the specified Account Products for the Account Associated to the Opportunity 
            List<Account_Products__c> TheAccountProducts = new List<Account_Products__c>();        
            TheAccountProducts = [SELECT 
                                  Id,
                                  Product2__c,
                                  Product2__r.Name,
                                  Active_Contracts__c,
                                  Active_Members__c
                                  FROM Account_Products__c
                                  WHERE 
                                  Effective_End_Date__c = null
                                  AND
                                  Parent_Account_Product__c = null
                                  AND
                                  Account__c = :copyOfOpportunity[0].AccountId];
            
            System.debug('Number of Account Products Retrieved: ' + TheAccountProducts.size() );   
            System.debug('TheAccountProducts' + TheAccountProducts);
            
            /* starting new Opportunity, clear the List */
            theOpportunityProductsToInsert.clear();
            
            for(Account_Products__c anAccountProduct : TheAccountProducts){
                
                System.debug('Processing Account Product: ' + anAccountProduct);
                
                Opportunity_Product__c aSingleOpportunityProduct = new Opportunity_Product__c();
                
                /* Populate the Opportunity Product  attributes as prescribed */
                aSingleOpportunityProduct.Opportunity_Name__c = AnOpportunity.Id;
                aSingleOpportunityProduct.Account_Product_Name__c = anAccountProduct.Product2__r.Name;
                aSingleOpportunityProduct.Product__c = anAccountProduct.Product2__c;
                aSingleOpportunityProduct.Product_Type__c = 'Renewal';
                aSingleOpportunityProduct.State__c = copyOfOpportunity[0].HCSC_Division__c;
                aSingleOpportunityProduct.Status__c = 'In Progress';
                aSingleOpportunityProduct.Projected_Members__c = anAccountProduct.Active_Members__c;
                aSingleOpportunityProduct.Projected_Contracts__c = anAccountProduct.Active_Contracts__c;
                
                /* add the record to the List */
                theOpportunityProductsToInsert.add(aSingleOpportunityProduct);
                
            }
            
            System.debug('theOpportunityProductsToInsert: ' + theOpportunityProductsToInsert);
            
            /* Insert the Opportunity Products for the Opportunity */
            try {
                insert theOpportunityProductsToInsert;        
            } catch(DmlException e) {
                System.debug('Insert Error : OppRenewalProdLoadInvocable: ' + e.getMessage());
            }
        }       
    }
    /* SFDC-9349 - 04/2018 - End */
}