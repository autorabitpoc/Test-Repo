/**************************************************************************************
  Apex Class Name     : LGNA_AccountProducts
  Version             : 1.0
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  Ranjit Gandhi 		5/4/2018				Initial Version
*************************************************************************************/
public class LGNA_AccountProducts {
    
    // Query the custom Metadata to get the map of product type and order.
    
	public static Map<String,Integer> getCustomMetadataAccountProductsOrder() {
        //Map of categ and list of products for account
        List<Account_Products_Order__mdt> ProductOrderList = [SELECT Order__c, MasterLabel FROM Account_Products_Order__mdt  Order By Order__c asc];
        Map<String,Integer> ProductTypeOrderMap = new Map<String,Integer>();
        for(Account_Products_Order__mdt poList: ProductOrderList){ 
            ProductTypeOrderMap.put(poList.MasterLabel,poList.Order__c.intValue()); 
        } 
        return ProductTypeOrderMap;
    }
     @AuraEnabled    
   public static string getAccRecordId(String recordId) {
       String Recordtypename = [Select RecordType.Name FROM Account WHERE id=:recordId].RecordType.Name;
         string groupRec; string prospectRec;
        
         if(Recordtypename=='Group Account')  {
             groupRec='Group Account'; 
         	return groupRec;
         }
       
       	else if(Recordtypename=='Prospect'){
            prospectRec='Prospect';
           return prospectRec;
       		}
       return null;
         } 
    
     /************************************** Active Opportunity Products************************************************************************/
     @AuraEnabled
     public static Map<String, list<Object>> loadInitialAccountProducts(String recordId){
         
         Map<String, list<Object>> AccountActiveProductsMap = new Map<String, list<Object>>();
         AccountActiveProductsMap = getMappedActiveProducts(recordId,getActiveTypeProducts(recordId));
         AccountActiveProductsMap.putAll(getRemainingProductsSorted(recordId,
                                                              getRemainingProducts(recordId,
                                                                                   AccountActiveProductsMap,
                                                                                  getActiveTypeProducts(recordId))
                                                              ));       
         return AccountActiveProductsMap;
         
     }  
    
    
    // get the list of active products- returns a map of Product type and list of products.
	public static Map<String, list<Account_Products__c>> getActiveTypeProducts(String accId) {
        
        Id recTypeId = 
            Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        
        //Map of Product type and list of products for account
        Map<String, list<Account_Products__c>> ProductTypeToAccountProducts = new Map<String, list<Account_Products__c>>();
        
        for(Account_Products__c objCS : [SELECT Id, name,Product2__r.name, Product2__r.Product_Type__c,Effective_Start_Date__c, 
                                         Product2__r.Product_Category__c,Original_Effective_Date__c,
                                         Active_Members__c,Active_Contracts__c FROM Account_Products__c
                						 where Account__c=:accId and 
                                         Effective_End_Date__c=null and Parent_Account_Product__c=null  Order By Effective_Start_Date__c desc])
						{
						if(ProductTypeToAccountProducts.containsKey(objCS.Product2__r.Product_Type__c))
						{
							List<Account_Products__c> newlist =ProductTypeToAccountProducts.get(objCS.Product2__r.Product_Type__c);
							newlist.add(ObjCS);
							ProductTypeToAccountProducts.put(objCS.Product2__r.Product_Type__c, newlist);
						}
						else
						ProductTypeToAccountProducts.put(objCS.Product2__r.Product_Type__c, new List<Account_Products__c> {objCS});
						
						}
        
        System.debug('ProductTypeToAccountProducts'+ProductTypeToAccountProducts);
        
        return ProductTypeToAccountProducts;
    }    
   /************************************** Historical Account Products************************************************************************/
    @AuraEnabled
	 public static Map<String, list<Object>> loadHistoricalAccountProducts(String recordId){
         Map<String, list<Object>> AccountHistoricalProductsMap = new Map<String, list<Object>>();
         //System.debug('loadHistoricalAccountProducts-getHistoricalAccountTypeProducts'+getHistoricalAccountTypeProducts(recordId));
                                   // System.debug('loadHistoricalAccountProducts-getHistoricalOppTypeProducts'+getHistoricalOppTypeProducts(recordId));

         System.debug('loadHistoricalAccountProducts-getMappedHistoricalProducts'+getMappedHistoricalProducts(recordId,getHistoricalAccountTypeProducts(recordId),getHistoricalOppTypeProducts(recordId)));
      		
         AccountHistoricalProductsMap = getMappedHistoricalProducts(recordId,getHistoricalAccountTypeProducts(recordId),getHistoricalOppTypeProducts(recordId));
        // AccountHistoricalProductsMap.putAll(getMappedOpportunityProducts(recordId,getHistoricalOppTypeProducts(recordId)));
         System.debug('getMappedProductsAccountHistoricalProductsMap'+AccountHistoricalProductsMap);
         AccountHistoricalProductsMap.putAll(getRemainingProductsSorted(recordId,
                                                              getRemainingProducts(recordId,
                                                                                  AccountHistoricalProductsMap,
                                                                                  getHistoricalAccountTypeProducts(recordId)))); 
        AccountHistoricalProductsMap.putAll(getRemainingOpportunityProductsSorted(recordId,
                                                             getRemainingOpportunityProducts(recordId,
                                                                                 AccountHistoricalProductsMap,
                                                                                  getHistoricalOppTypeProducts(recordId)))); 
         System.debug('AccountHistoricalProductsMap'+AccountHistoricalProductsMap);
         return AccountHistoricalProductsMap;
         
     }  
    
    @AuraEnabled
	 public static Map<String, list<Object>> loadHistoricalOpportunityProducts(String recordId){
         Map<String, list<Object>> OpportunityHistoricalProductsMap = new Map<String, list<Object>>();
         OpportunityHistoricalProductsMap = getMappedOpportunityProducts(recordId,getHistoricalOppTypeProducts(recordId));
        System.debug('OpportunityHistoricalProductsMap'+OpportunityHistoricalProductsMap);
         OpportunityHistoricalProductsMap.putAll(getRemainingOpportunityProductsSorted(recordId,
                                                             getRemainingOpportunityProducts(recordId,
                                                                                 OpportunityHistoricalProductsMap,
                                                                                  getHistoricalOppTypeProducts(recordId)))); 
        // System.debug('AccountHistoricalProductsMap'+AccountHistoricalProductsMap);
         return OpportunityHistoricalProductsMap;
         
     } 
   
    // get the list of Historical products- returns a map of Product type and list of products.
	public static Map<String, list<Object>> getHistoricalAccountTypeProducts(String accId) {
        
        //Map of Product type and list of products for account
        Map<String, list<Object>> ProductTypeToAccountProducts = new Map<String, list<Object>>();
         Integer year = Date.today().year() - 5;      
        
        for(Account_Products__c objCS : [SELECT Id, name,Status__c,Product2__c,Product2__r.name, Product2__r.Product_Type__c,
                                         Product2__r.Product_Category__c,Effective_Start_Date__c,Effective_End_Date__c,
                                         Active_Members__c,Active_Contracts__c FROM Account_Products__c
                		where Account__c=:accId and 
                                         CALENDAR_YEAR(Effective_End_Date__c) >: year and Parent_Account_Product__c=null 
                                         
                                         Order By Effective_End_Date__c Desc])
						{
						if(ProductTypeToAccountProducts.containsKey(objCS.Product2__r.Product_Type__c))
						{
							List<Object> newlist =ProductTypeToAccountProducts.get(objCS.Product2__r.Product_Type__c);
							newlist.add(ObjCS);
							ProductTypeToAccountProducts.put(objCS.Product2__r.Product_Type__c, newlist);
						}
						else
						ProductTypeToAccountProducts.put(objCS.Product2__r.Product_Type__c, new List<Account_Products__c> {objCS});						
						}
        
        System.debug('ProductTypeToAccountProducts'+ProductTypeToAccountProducts);
        
        return ProductTypeToAccountProducts;
    } 
    
    
     /************************************** Common code for Account Products	************************************************************************/    
	      public static Map<String, list<Object>> getMappedActiveProducts(String accId, Map<String, list<Object>> ProductTypeProductsMap) {        
        //Map of  order, Product type
         Map<String,Integer> ProductTypeOrderMap = getCustomMetadataAccountProductsOrder();       
    	 Map<String, list<Object>> MappedListProductTypeToAccountProducts = new Map<String, list<Object>>();
        
		for(String KeyID: ProductTypeOrderMap.keyset())   
        {
           	if(ProductTypeProductsMap.keyset().contains(keyId) )
            {
                MappedListProductTypeToAccountProducts.put(keyId, ProductTypeProductsMap.get(keyId));
            }              
            
        }
        System.debug('getMappedProducts'+MappedListProductTypeToAccountProducts); 
        return MappedListProductTypeToAccountProducts;        
    }
                                                                  
        public static Map<String, list<Object>> getMappedHistoricalProducts(String accId, Map<String, list<Object>> ProductTypeProductsMap, 
                                                              Map<String, list<Object>> ProductTypeOppProductsMap) {        
        //Map of  order, Product type
         Map<String,Integer> ProductTypeOrderMap = getCustomMetadataAccountProductsOrder();       
    	 Map<String, list<Object>> MappedListProductTypeToAccountProducts = new Map<String, list<Object>>();

		for(String KeyID: ProductTypeOrderMap.keyset())   
        {
           	if(ProductTypeOppProductsMap.keyset().contains(keyId))
            {
                List<Object> c=new List<SObject>();
                if(ProductTypeProductsMap.get(keyId)!=null)
                	c.addAll(ProductTypeProductsMap.get(keyId)); 
                if(ProductTypeOppProductsMap.get(keyId)!=null)
                	c.addAll(ProductTypeOppProductsMap.get(keyId));                
                MappedListProductTypeToAccountProducts.put(keyId, c);
               
            }            
            else if(ProductTypeProductsMap.keyset().contains(keyId))
            {
                MappedListProductTypeToAccountProducts.put(keyId, ProductTypeProductsMap.get(keyId));
            }
        }
                                                                  
                                                                  
        System.debug('getMappedHistoricalProducts'+MappedListProductTypeToAccountProducts); 
        return MappedListProductTypeToAccountProducts;        
    }
  
    
   
    public static Map<String, list<Object>> getRemainingProducts(String accId, Map<String, 
                                                                              list<Object>> MappedListProductTypeToAccountProducts,
                                                                             Map<String, list<Object>> ProductTypeProductsMap) 
    {
        //ProductTypeProductsMap-Map of  Product type, Products
   
		for(String KeyID: MappedListProductTypeToAccountProducts.keyset())   
        {
           	if(ProductTypeProductsMap.keyset().contains(keyId))
            {                
                ProductTypeProductsMap.remove(keyId); 
            }
        }
        return ProductTypeProductsMap;
        
    }
    
     public static Map<String, list<Object>> getRemainingProductsSorted(String accId,
                                                                                     Map<String, list<Object>> MappedRemainingproducts) 
     { 
      
        	Map<String, list<Object>> MappedRemainingproductsSorted = new Map<String, list<Object>>();
         	List<String> aProductsList = new List<String>();
            aProductsList.addAll(MappedRemainingproducts.keySet());            
            aProductsList.sort();     
            for(String a: aProductsList){            
             MappedRemainingproductsSorted.put(a,MappedRemainingproducts.get(a));            
            }
		System.debug('MappedRemainingproductsSorted'+MappedRemainingproductsSorted);
        return MappedRemainingproductsSorted;
        
    }
   /************************************** Common code for Opportunity Products	************************************************************************/  
    	public static Map<String, list<Object>> getMappedOpportunityProducts(String oppId, Map<String, list<Object>> ProductTypeProductsMap) {        
        //Map of  order, Product type
         Map<String,Integer> ProductTypeOrderMap = getCustomMetadataAccountProductsOrder();       
    	 Map<String, list<Object>> MappedListProductTypeToOpportunityProducts = new Map<String, list<Object>>();
        
		for(String KeyID: ProductTypeOrderMap.keyset())   
        {
           	if(ProductTypeProductsMap.keyset().contains(keyId))
            {
                MappedListProductTypeToOpportunityProducts.put(keyId, ProductTypeProductsMap.get(keyId));
            }            
        }
        System.debug('MappedListProductTypeToOpportunityProducts'+MappedListProductTypeToOpportunityProducts); 
        return MappedListProductTypeToOpportunityProducts;        
    }
    
     public static Map<String, list<Object>> getRemainingOpportunityProducts(String accId, Map<String, 
                                                                              list<Object>> MappedListProductTypeToOpportunityProducts,
                                                                             Map<String, list<Object>> ProductTypeProductsMap) 
    {
        //ProductTypeProductsMap-Map of  Product type, Products   
		for(String KeyID: MappedListProductTypeToOpportunityProducts.keyset())   
        {
           	if(ProductTypeProductsMap.keyset().contains(keyId))
            {                
                ProductTypeProductsMap.remove(keyId); 
            }
        }
        return ProductTypeProductsMap;
        
    }
    
    public static Map<String, list<Object>> getRemainingOpportunityProductsSorted(String accId,
                                                                                     Map<String, list<Object>> MappedRemainingproducts) 
     { 
      
        	Map<String, list<Object>> MappedRemainingproductsSorted = new Map<String, list<Object>>();
         	List<String> aProductsList = new List<String>();
            aProductsList.addAll(MappedRemainingproducts.keySet());            
            aProductsList.sort();     
            for(String a: aProductsList){            
             MappedRemainingproductsSorted.put(a,MappedRemainingproducts.get(a));            
            }
		System.debug('MappedRemainingproductsSorted'+MappedRemainingproductsSorted);
        return MappedRemainingproductsSorted;
        
    }
    
   /************************************** Opportunity Products************************************************************************/
    
        public static List<Opportunity> getOpportunitiesForLastFiveYears(String accId) {
        Integer year = Date.today().year() - 5;                    
        return [SELECT Id, name FROM Opportunity where AccountId=:accId and CALENDAR_YEAR(Requested_Effective_Date__c) >: year];
    }
    
    /*public static List<Object> getHistoricalOpportunityProducts(String accId) {
        List<Opportunity> OppListForAccount=getOpportunitiesForLastFiveYears(accId);
                
        return [SELECT Id, name,Status__c,Product__c,Product__r.name, Product__r.Product_Category__c,Effective_Date__c	,Projected_Members__c,Projected_Contracts__c 
                		FROM Opportunity_Product__c
                		where Opportunity_Name__c in :OppListForAccount and Status__c='lost' Order By Effective_Date__c Desc];
    }  */
    
     // get the list of Historical products- returns a map of Product type and list of products.
	public static Map<String, list<Object>> getHistoricalOppTypeProducts(String accId) {
        
        //Map of Product type and list of products for account
        Map<String, list<Object>> ProductTypeToOpportunityProducts = new Map<String, list<Object>>();
        
        for(Opportunity_Product__c objCS : [SELECT Id, name,Status__c,Product__c,Product__r.Product_Type__c,Product__r.name, Product__r.Product_Category__c,Effective_Date__c	,Projected_Members__c,Projected_Contracts__c 
                		FROM Opportunity_Product__c
                		where Opportunity_Name__c in :getOpportunitiesForLastFiveYears(accId)
                                            and (Status__c='lost' or Status__c='Migrated')
                                            Order By Effective_Date__c Desc 
                                         ])
						{
						if(ProductTypeToOpportunityProducts.containsKey(objCS.Product__r.Product_Type__c))
						{
							List<Object> newlist =ProductTypeToOpportunityProducts.get(objCS.Product__r.Product_Type__c);
							newlist.add(ObjCS);
							ProductTypeToOpportunityProducts.put(objCS.Product__r.Product_Type__c, newlist);
						}
						else
						ProductTypeToOpportunityProducts.put(objCS.Product__r.Product_Type__c, new List<Object> {objCS});						
						}
        
        System.debug('ProductTypeToOpportunityProducts'+ProductTypeToOpportunityProducts);
        
        return ProductTypeToOpportunityProducts;
    } 

}