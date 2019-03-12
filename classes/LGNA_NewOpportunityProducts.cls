public class LGNA_NewOpportunityProducts {
    
    //Queries Initial load of active products
     
    /**
     * @author: Mei Chen
     * @date: 5/28/2018
     * @description  This method is to retrieve the mapping data from custom metadata setting OpportunityProductPicklistMap__mdt 
     *  from LGNA_OpportunityProductController.js.  As Controlling/Dependent from standard configuration is not implemented from lighning page, 
     *  OpportunityProductPicklistMap__mdt is used as mapping for Opportunity Product Type and Status base on the Record type.
     *  
     **/
    @auraEnabled
    public static Map<String,OpportunityProductPicklistMap__mdt > getOppProductPickListMappingData(){
        
        Map<String,OpportunityProductPicklistMap__mdt> picklistMap=new Map<String,OpportunityProductPicklistMap__mdt>();
        list<OpportunityProductPicklistMap__mdt> picklistMappingList=[select Id, MasterLabel,DeveloperName,Status__c,ForStatus__c,ForType__c,Funding_Type__c,Premium_Type__c, Type__c from OpportunityProductPicklistMap__mdt];
        if(picklistMappingList!=null && !picklistMappingList.isEmpty()){
            for(OpportunityProductPicklistMap__mdt mapping:picklistMappingList){
                pickListMap.put(mapping.DeveloperName, mapping);
            }
        }
        
        return picklistMap;
    }
    
    // Query the custom Metadata to get the map of product type and order.
    @AuraEnabled
	public static Map<String,Integer> getCustomMetadataAccountProductsOrder() {
        //Map of categ and list of products for account
        List<Account_Products_Order__mdt> ProductOrderList = [SELECT Order__c, MasterLabel FROM Account_Products_Order__mdt  Order By Order__c asc];
        Map<String,Integer> ProductTypeOrderMap = new Map<String,Integer>();
        for(Account_Products_Order__mdt poList: ProductOrderList){ 
            ProductTypeOrderMap.put(poList.MasterLabel,poList.Order__c.intValue()); 
        } 
        return ProductTypeOrderMap;
    }
   // SFDC - 9418   Sujatha  Add Products Button Functionality Starts Here
   /* @AuraEnabled
    public static Opportunity getopportunitydetails(Id opprecId) {
        system.debug('ID of teh'+opprecId);
        Opportunity opplist = new Opportunity();
        if(opprecId!=null){
            opplist= [SELECT Id,Name,HCSC_Division__c FROM Opportunity where Id=:opprecId];
            system.debug('test'+opplist);
        }
        return opplist;
    }*/
    
    //SFDC - 9298 Rakesh Nunna: Method to get the Current Selected Records
    @AuraEnabled
    public static Map<String,List<Opportunity_Product__c>> getCurrentlySelectedOpportunityProducts(string recordId){
        Map<String,Integer> ProductTypeOrderMap = getCustomMetadataAccountProductsOrder();
        Map<String,List<Opportunity_Product__c>> CurrentMappedListProductTypeToOpportunityProducts = new Map<String,List<Opportunity_Product__c>>();
        Map<String,List<Opportunity_Product__c>> CurrentRemainingListProductTypeToOpportunityProducts = new Map<String,List<Opportunity_Product__c>>();
        List<Opportunity_Product__c> currentOpportunityProductsList = new List<Opportunity_Product__c>();
        Map<String,List<Opportunity_Product__c>> currentproductTypeOpportunityProductMap = new Map<String,List<Opportunity_Product__c>>();
        
        List<Opportunity_Product__c> currentOpportunityProd = [select Id,Name,RecordTypeId,RecordType.Name,RecordType.DeveloperName,Product__r.Name,Product__r.Product_Type__c,Product_Type__c,Status__c,Funding_Type__c,Premium_Type__c,Projected_Contracts__c,Projected_Members__c,Incumbent__c,Incumbent__r.Name,Win_Probability__c from Opportunity_Product__c where Opportunity_Name__c=:recordId Order By Product__r.Product_Type__c asc];
        List<String> pickListValuesList= new List<String>();

        for(Opportunity_Product__c opProducts:currentOpportunityProd){
            system.debug('Opp Product Type:'+opProducts.Product_Type__c+' Status: '+opProducts.Status__c+' recordTypeId:'+opProducts.recordTypeId+'  recordTypeName:'+opProducts.recordType.Name);
            if(currentproductTypeOpportunityProductMap.containsKey(opProducts.Product__r.Product_Type__c))//Opp Prod's Category
             {
                 List<Opportunity_Product__c> newlist =currentproductTypeOpportunityProductMap.get(opProducts.Product__r.Product_Type__c);
                 newlist.add(opProducts);
                 currentproductTypeOpportunityProductMap.put(opProducts.Product__r.Product_Type__c, newlist);
            }else{
                currentproductTypeOpportunityProductMap.put(opProducts.Product__r.Product_Type__c, new List<Opportunity_Product__c> {opProducts});
            }
            
          }
        
        for(String key:currentproductTypeOpportunityProductMap.keyset()){
            system.debug('key::'+key);
            for(String KeyID: ProductTypeOrderMap.keyset()){
                system.debug('keyId::'+keyID);
               if((currentproductTypeOpportunityProductMap.keyset().contains(keyID)) && (key == keyID)){
                    CurrentMappedListProductTypeToOpportunityProducts.put(keyID, currentproductTypeOpportunityProductMap.get(keyID));
                        
              } else{
                   CurrentRemainingListProductTypeToOpportunityProducts.put(key,currentproductTypeOpportunityProductMap.get(key));
                }
             }
                
            }
        	
        
        	CurrentMappedListProductTypeToOpportunityProducts.putAll(CurrentRemainingListProductTypeToOpportunityProducts);
    
        
        return CurrentMappedListProductTypeToOpportunityProducts;
    }
    

 //SFDC - 9298 Rakesh Nunna - To get the Previuosly Quoted Records
    @AuraEnabled
    public static Map<String,List<Opportunity_Product__c>> getPreviouslyQuotedOpportunityProducts(string recordId){
        Map<String,Integer> ProductTypeOrderMap = getCustomMetadataAccountProductsOrder();
        Map<String,List<Opportunity_Product__c>> CurrentMappedListProductTypeToOpportunityProducts = new Map<String,List<Opportunity_Product__c>>();
        Map<String,List<Opportunity_Product__c>> CurrentRemainingListProductTypeToOpportunityProducts = new Map<String,List<Opportunity_Product__c>>();
        List<Opportunity_Product__c> currentOpportunityProductsList = new List<Opportunity_Product__c>();
        Map<String,List<Opportunity_Product__c>> currentproductTypeOpportunityProductMap = new Map<String,List<Opportunity_Product__c>>();
        Integer year = Date.today().year() - 5;
        system.debug('current opp id:'+recordId);
        
       	list<Opportunity> Opp=[Select Id, AccountId from Opportunity where id =:recordId limit 1];
        Set<Id> oppIds=new Set<Id>();
        
        if(Opp!=null && !Opp.isEmpty()){
            system.debug('accountId::'+opp[0].AccountId);
            
           //find all the related Opp product from the current opp's account but exclude the Opp Product from the current Opp
  
          list<Opportunity> allOpp=[select id, AccountId from Opportunity where AccountId=:opp[0].AccountId and id !=:opp[0].Id];
            if(allOpp!=null && !allOpp.isEmpty()){
                for(Opportunity op:allOpp){
                    oppIds.add(op.Id);
                }
                system.debug('size of oppIds:::'+oppIds.size());
            }
            
        }

        List<Opportunity_Product__c> currentOpportunityProd = [select Id,Name,Account__c, Account__r.Name, Product__r.Name,Product__r.Product_Type__c,Product_Type__c,Status__c,Funding_Type__c,Premium_Type__c,Projected_Contracts__c,Projected_Members__c,Win_Probability__c,Effective_Date__c from Opportunity_Product__c where Opportunity_Name__c In:oppIds and Status__c = 'Lost' and CALENDAR_YEAR(Effective_Date__c) >: year  Order By Effective_Date__c desc];
       
        List<String> pickListValuesList= new List<String>();

        for(Opportunity_Product__c opProducts:currentOpportunityProd){
            if(currentproductTypeOpportunityProductMap.containsKey(opProducts.Product__r.Product_Type__c))
                            {
                                List<Opportunity_Product__c> newlist =currentproductTypeOpportunityProductMap.get(opProducts.Product__r.Product_Type__c);
                                newlist.add(opProducts);
                                currentproductTypeOpportunityProductMap.put(opProducts.Product__r.Product_Type__c, newlist);
                            }
                            else
                            currentproductTypeOpportunityProductMap.put(opProducts.Product__r.Product_Type__c, new List<Opportunity_Product__c> {opProducts});
                            
           }
        	

            for(String key:currentproductTypeOpportunityProductMap.keyset()){
                
                for(String KeyID: ProductTypeOrderMap.keyset()){
                    
                    if((currentproductTypeOpportunityProductMap.keyset().contains(keyID)) && (key == keyID)){
                    	CurrentMappedListProductTypeToOpportunityProducts.put(keyID, currentproductTypeOpportunityProductMap.get(keyID));
                        
                    } 
                    else{
                        CurrentRemainingListProductTypeToOpportunityProducts.put(key,currentproductTypeOpportunityProductMap.get(key));
                        
                    }
                }
                
            }
        	
        
        	CurrentMappedListProductTypeToOpportunityProducts.putAll(CurrentRemainingListProductTypeToOpportunityProducts);
    
        
        return CurrentMappedListProductTypeToOpportunityProducts;
    }
    
    //Rakesh:Code for lookup
    
    @AuraEnabled
    public static List<Account> fetchLookUpValues(String searchfilter,String searchKeyWord,String ObjectName){
        String competitorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        
          String searchKey = searchKeyWord + '%';
          List < Account > returnList = new List < Account > ();
          List < Account > lstOfAccount = [select id, Name from account where RecordTypeId=:competitorRecordTypeId AND Name LIKE: searchKey];
         
          for (Account acc: lstOfAccount) {
             returnList.add(acc);
             }
          return returnList;
       
    }
     @auraEnabled
     public static List<Account> fetchLookUpWiningCarrierValues(String searchfilter,String searchKeyWord,String ObjectName){
        String competitorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        String vendorRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        system.debug(' comepitorRecordTypeId;;;'+competitorRecordTypeId+' verdorRecordTypeId;:;;; '+vendorRecordTypeId);
        
          String searchKey = searchKeyWord + '%';
          List < Account > returnList = new List < Account > ();
          List < Account > lstOfAccount = [select id,RecordTypeId,Type, Name from account where ((RecordTypeId =:competitorRecordTypeId AND Type ='Competitor Account') Or RecordTypeId =:vendorRecordTypeId) AND Name LIKE: searchKey];
         
          for (Account acc: lstOfAccount) {
             returnList.add(acc);
          }
         system.debug(' return searched accountList size:'+returnList.size());
          return returnList;
       
    }
    
 
    @AuraEnabled
    public static Opportunity_Product__c getproductDetails(Id recordId){
        try{
                  system.debug('**** oppproductId--> ' + recordId);
            Opportunity_Product__c acc=[select Id,Name,Product__r.Name,Product__r.Product_Type__c,Product_Type__c,Status__c,Funding_Type__c,Premium_Type__c,Projected_Contracts__c,Projected_Members__c,Win_Probability__c,Effective_Date__c from Opportunity_Product__c where Opportunity_Name__c=:recordId and Status__c = 'Won' Order By Effective_Date__c desc];
            
            return acc;
        }catch(Exception e){
            system.debug('*** Exception ex --> ' + e);
        }
        return null;
    }
    
  
    
  
   /****
    * author: Rakesh/Mei
    * date: 5/28/2018
    * This method is called in LGNA_OpportunityProductController.js to save the Opportunity Product record update or add from UI
    * */
    @auraEnabled
    public static Boolean saveOpportunityProducts(List<Opportunity_Product__c> updateList, List<Opportunity_Product__c> newList) {
        
		System.debug('======opProducts======='+updateList);
        Boolean result=false;
        try{
            if(updateList!=null && !updateList.isEmpty()){
                system.debug('updating....'+updateList);
			   update updateList; 
               result=true;
               system.debug('update completed....');
            }
            if(newList!=null && !newList.isEmpty()){
                system.debug('inserting....');
                List<Opportunity_Product__c> updateNewList= new List<Opportunity_Product__c>();
                for(Opportunity_Product__c op:newList){
                    system.debug('product__c:::'+op.Product__c);
                    Id recTypeId=Schema.SObjectType.Opportunity_Product__c.getRecordTypeInfosByName().get(op.Record_Type_Name__c).getRecordTypeId();
                    op.RecordTypeId=recTypeId;
                    op.Account_Product_Name__c=null; //clear the account Product name field as it was borrowed in UI to store the opp prod name temprary
                    updateNewList.add(op);
                }
                insert updateNewList;
                result=true;
                
             }
        } catch(Exception ex)
        {   result=false;
            system.debug(' upsert op product exception:'+ex);
            throw new AuraHandledException(ex.getMessage());
            
        }
        
        return result;
    }
    
    //Lookup Filter
     @AuraEnabled
 public static List < Opportunity_Product__c > fetchAccount(String searchKeyWord) {
 
  //String competitorRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
     
  String searchKey = searchKeyWord + '%';
  List < Opportunity_Product__c > returnList = new List < Opportunity_Product__c > ();
  List < Opportunity_Product__c > lstOfProducts = [select id, Name from Opportunity_Product__c where Name LIKE: searchKey];
 
  for (Opportunity_Product__c acc: lstOfProducts) {
     returnList.add(acc);
     }
  return returnList;
 }
   @AuraEnabled
    public static boolean deleteOptyProduct(id OptyProdId){
        //OptyProdId='1234';
        List<Opportunity_Product__c> optyProdList = [select id from Opportunity_Product__c where id=:OptyProdId];
        if(optyProdList.size()>0){
            delete optyProdList;
            return true;
        }
        else
        {
            return false;
        }
    }
    @AuraEnabled
    public static boolean SetOpptyProd(Id optyId, string sStatus, Id sAccount,string sNotes, string sSplit, string sCarve){
        List<Opportunity_Product__c> OptyPord = [select Id,Status__c from Opportunity_Product__c where Id=:optyId];
        if(OptyPord.size()>0){
            Opportunity_Product__c sOptyprod = new Opportunity_Product__c();
            sOptyprod.Id = optyId;
            sOptyprod.Status__c = sStatus;
			sOptyprod.Account__c = sAccount;
            if(sNotes!=null){
            	sOptyprod.Notes__c = sNotes;    
            }
            if(sSplit!=null){
                sOptyprod.Split__c = sSplit; 
            }
            if(sCarve!=null){
                sOptyprod.Carve_Out__c = sCarve; 
            }
             update sOptyprod;
            return true;
        }else{
            return false;
        }
        
    }
    
     // SFDC - 9418   Sujatha  Add Products Button Functionality Starts Here
     // 
         
    @AuraEnabled
    public static List<Product2> getOppProducts(String hcscSate) {        
        system.debug('==opp division state=='+hcscSate);
       
        Id serviceRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
       /* list<Opportunity_Product__c> relatedOP=[select Id, Product__c, Opportunity_Name__c from Opportunity_Product__c];
        
        set<Id> opId=new set<Id>();
        if(relatedOP!=null && !relatedOP.isEmpty()){
            for(Opportunity_Product__c op:relatedOP){
             opId.add(op.Product__c);
            }
        }*/
        //SFDC-10629 BEGIN        
        // ORIGINAL List<Product2> ProductsList = [SELECT Id,Description,Product_Category__c,HCSC_State__c, Product_Type__c, Name FROM Product2 where HCSC_State__c=:hcscSate and (RecordTypeId!= :serviceRecordTypeId and IsActive=true)];
        List<Product2> ProductsList = [SELECT Id, Name, Product_Type__c,Description,Product_Category__c,HCSC_State__c FROM Product2 where HCSC_State__c=:hcscSate and (RecordTypeId!= :serviceRecordTypeId and IsActive=true)];
        //SFDC-10629 END        
        return ProductsList;
    }
     //KK Added for Opportunity Product ReadwriteAcess 6/25/2018
    @auraEnabled
    public static boolean checkOptyAccess(id OptyId){
        if(OptyId!=null)
        {
            List<UserRecordAccess> userAccess=[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =:OptyId limit 1];
            if(userAccess!=null && userAccess[0].HasEditAccess){
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }
  
    //SFDC-9297 KK
    @auraEnabled
    public static string getOptyId(id OptyProdId){
        List<Opportunity_Product__c> OptyProd = [Select Id,Opportunity_Name__c from Opportunity_Product__c where Id=:OptyProdId limit 1];
        string optyId = OptyProd[0].Opportunity_Name__c;
        return optyId;
    }

}