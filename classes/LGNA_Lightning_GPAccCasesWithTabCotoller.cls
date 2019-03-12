/* 
 * Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 03/20/2018
 * Modified date: 04/06/2018
 * Discription : Class to fetch the records from Cases associated with the Accounts & Opportunities for the Record Types(Insatallation(GEMS), SAM REquests)
*/
 public with sharing class LGNA_Lightning_GPAccCasesWithTabCotoller {
     
     @AuraEnabled
     public static List<Case> loadInitialCasesGems(String objectType,String recordId){
         List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = getcaseswithgemsAcc(recordId);
        }
        else if(objectType == 'Opportunity'){
            caseList = getcaseswithgemsOpp(recordId);
			            
        }
        return caseList;
         
     }
     
     
	public static List<case> getcaseswithgemsAcc(String accId) {
        
        System.debug('==AccId=='+accId);
        //List<RecordType> gemRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and Name LIKE:'GEMS%'];
        List<CaseRecordTypes__c > gemCaseRT = CaseRecordTypes__c.getall().values();
        List<String> gemRtNames = new List<String>();
        for(CaseRecordTypes__c cr:gemCaseRT){
            if(cr.Gems__c == true){
                gemRtNames.add(cr.Name);
            
            }
            
        }
        System.debug('=gemRtNames='+gemRtNames);
        return [SELECT Id, RecordTypeId,CaseNumber,subject, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:accId AND RecordType.Name IN:gemRtNames Order By CreatedDate Desc LIMIT 10];
    }    
    public static List<case> getcaseswithgemsOpp(String oppId) {
        System.debug('==OppId=='+oppId);
        List<CaseRecordTypes__c > gemCaseRT = CaseRecordTypes__c.getall().values();
        List<String> gemRtNames = new List<String>();
        for(CaseRecordTypes__c cr:gemCaseRT){
            if(cr.Gems__c == true){
                gemRtNames.add(cr.Name);
            
            }
            
        }
        System.debug('=gemRtNames='+gemRtNames);
        //List<RecordType> gemRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and Name LIKE:'GEMS%'];
        return [SELECT Id,OwnerId, RecordTypeId,CaseNumber,subject, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where Opportunity_Name__c=:oppId AND RecordType.Name IN:gemRtNames Order By CreatedDate Desc LIMIT 10];
    }
     
     @AuraEnabled
     public static List<Case> loadViewAllCasesGems(String objectType,String recordId){
         List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = getcaseswithgemsAllAcc(recordId);
        }
        else if(objectType == 'Opportunity'){
            caseList = getcaseswithgemsAllOpp(recordId);
			            
        }
        return caseList;
         
     }
     public static List<Case> getcaseswithgemsAllAcc(String acId) {
        
        //List<RecordType> gemRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and Name LIKE:'GEMS%'];
        List<CaseRecordTypes__c > gemCaseRT = CaseRecordTypes__c.getall().values();
        List<String> gemRtNames = new List<String>();
        for(CaseRecordTypes__c cr:gemCaseRT){
            if(cr.Gems__c == true){
                gemRtNames.add(cr.Name);
            
            }
            
        }
                System.debug('=gemRtNames='+gemRtNames);
         
         return [SELECT Id, CaseNumber,subject,Account.Name,status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:acId AND RecordType.Name IN:gemRtNames Order By CreatedDate Desc];
    }

    public static List<Case> getcaseswithgemsAllOpp(String opId) {
        List<CaseRecordTypes__c > gemCaseRT = CaseRecordTypes__c.getall().values();
        List<String> gemRtNames = new List<String>();
        for(CaseRecordTypes__c cr:gemCaseRT){
            if(cr.Gems__c == true){
                gemRtNames.add(cr.Name);
            
            }
            
        }
                System.debug('=gemRtNames='+gemRtNames);

        //List<RecordType> gemRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and Name LIKE:'GEMS%'];
        return [SELECT Id,OwnerId, CaseNumber,subject,Opportunity_Name__r.Name,status, Owner.Name,RecordType.Name,CreatedDate FROM Case where Opportunity_Name__c=:opId AND RecordType.Name IN:gemRtNames Order By CreatedDate Desc];
    }
     @AuraEnabled
     public static List<Case> loadInitialCasesSamRequest(String objectType,String recordId){
        List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = getCaseSamRequestAcc(recordId);
        }
        else if(objectType == 'Opportunity'){
            caseList = getCaseSamRequestOpp(recordId);
			            
        }
        return caseList;
         
     }
     public static List<Case> getCaseSamRequestAcc(String accountId){
        
        //List<RecordType> samRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and (NOT Name LIKE:'GEMS%') AND DeveloperName!='SG_General_Case'];
        List<CaseRecordTypes__c > samCaseRT = CaseRecordTypes__c.getall().values();
        List<String> samRtNames = new List<String>();
        for(CaseRecordTypes__c cr:samCaseRT){
            if(cr.Sam_Requests__c == true){
                samRtNames.add(cr.Name);
            
            }
            
        }
         return [SELECT Id, RecordTypeId,CaseNumber,subject, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:accountId AND RecordType.Name IN:samRtNames Order By CreatedDate Desc LIMIT 10];
    }
    public static List<Case> getCaseSamRequestOpp(String opportunityId){
        
        List<CaseRecordTypes__c > samCaseRT = CaseRecordTypes__c.getall().values();
        List<String> samRtNames = new List<String>();
        for(CaseRecordTypes__c cr:samCaseRT){
            if(cr.Sam_Requests__c == true){
                samRtNames.add(cr.Name);
            
            }
            
        }
        
        //List<RecordType> samRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and (NOT Name LIKE:'GEMS%') AND DeveloperName!='SG_General_Case'];
        return [SELECT Id,OwnerId, RecordTypeId,CaseNumber,subject, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where Opportunity_Name__c=:OpportunityId AND RecordType.Name IN:samRtNames Order By CreatedDate Desc LIMIT 10];
    }
     
     @AuraEnabled
     public static List<Case> loadViewAllCasesSamRequest(String objectType,String recordId){
         List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = getCaseSamRequestAllAcc(recordId);
        }
        else if(objectType == 'Opportunity'){
            caseList = getCaseSamRequestAllOpp(recordId);
			            
        }
        return caseList;
         
     }

     public static List<Case> getCaseSamRequestAllAcc(String acId){
        //List<RecordType> samRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and (NOT Name LIKE:'GEMS%') AND DeveloperName!='SG_General_Case'];
        List<CaseRecordTypes__c > samCaseRT = CaseRecordTypes__c.getall().values();
        List<String> samRtNames = new List<String>();
        for(CaseRecordTypes__c cr:samCaseRT){
            if(cr.Sam_Requests__c == true){
                samRtNames.add(cr.Name);
            
            }
            
        }
         
         return [SELECT Id, RecordTypeId,CaseNumber,subject, Account.Name, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:acId AND RecordType.Name IN:samRtNames Order By CreatedDate Desc];
    } 
     public static List<Case> getCaseSamRequestAllOpp(String opId){
        
        List<CaseRecordTypes__c> samCaseRT = CaseRecordTypes__c.getall().values();
        List<String> samRtNames = new List<String>();
        for(CaseRecordTypes__c cr:samCaseRT){
            if(cr.Sam_Requests__c == true){
                samRtNames.add(cr.Name);
            
            }
            
        }
        //List<RecordType> samRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and (NOT Name LIKE:'GEMS%') AND DeveloperName!='SG_General_Case'];
        return [SELECT Id,OwnerId, RecordTypeId,CaseNumber,subject,Opportunity_Name__r.Name, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where Opportunity_Name__c=:opId AND RecordType.Name IN:samRtNames Order By CreatedDate Desc];
    }
    
     @AuraEnabled
     public static List<Case> searchGems(String objectType,String recordId,String key){
   		List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = gemSearchAcc(recordId,key);
        }
        else if(objectType == 'Opportunity'){
            caseList = gemSearchOpp(recordId,key);
			            
        }
        return caseList;      
         
         
     }
    public static List<Case> gemSearchOpp(String opId,String key){
        
        List<Case> caseList = new List<Case>();
        System.debug('==key=='+key);
        List<CaseRecordTypes__c > gemCaseRT = CaseRecordTypes__c.getall().values();
        List<String> gemRtNames = new List<String>();
        for(CaseRecordTypes__c cr:gemCaseRT){
            if(cr.Gems__c == true){
                gemRtNames.add(cr.Name);
            
            }
            
        }
        if(key!=null){
            String searchText= '%'+key+'%';
  		 	caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Opportunity_Name__r.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where (((CaseNumber like :searchText) OR (Subject like :searchText) OR (RecordType.Name like :searchText)) AND (RecordType.Name IN:gemRtNames) AND (Opportunity_Name__c=:opId))];
        }
        else{
            caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Opportunity_Name__r.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where RecordType.Name IN:gemRtNames AND Opportunity_Name__c=:opId];

        }
        System.debug('==caseList=='+caseList); 
        return caseList;
        
        
    }
     public static List<Case> gemSearchAcc(String acId,String key){
        
        List<Case> caseList = new List<Case>();
        System.debug('==key=='+key);
        List<CaseRecordTypes__c > gemCaseRT = CaseRecordTypes__c.getall().values();
        List<String> gemRtNames = new List<String>();
        for(CaseRecordTypes__c cr:gemCaseRT){
            if(cr.Gems__c == true){
                gemRtNames.add(cr.Name);
            
            }
            
        }
        if(key!=null){
            String searchText= '%'+key+'%';
  		 	caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Account.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where (((CaseNumber like :searchText) OR (Subject like :searchText) OR (RecordType.Name like :searchText)) AND (RecordType.Name IN:gemRtNames) AND (AccountId=:acId))];
        }
        else{
            caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Account.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where RecordType.Name IN:gemRtNames AND AccountId=:acId];

        }
        System.debug('==caseList=='+caseList); 
        return caseList;
        
        
    }
     @AuraEnabled
     public static List<Case> searchSamRequest(String objectType,String recordId,String key){
   		List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = samRequestSearchAcc(recordId,key);
        }
        else if(objectType == 'Opportunity'){
            caseList = samRequestSearchOpp(recordId,key);
			            
        }
        return caseList;      
         
         
     }
    public static List<Case> samRequestSearchOpp(String opId,String key){ 
    	
        List<Case> caseList = new List<Case>();
        List<CaseRecordTypes__c> samCaseRT = CaseRecordTypes__c.getall().values();
        List<String> samRtNames = new List<String>();
        for(CaseRecordTypes__c cr:samCaseRT){
            if(cr.Sam_Requests__c == true){
                samRtNames.add(cr.Name);
            
            }
            
        }
        if(key!=null){
            String searchText= '%'+key+'%';
  		 	caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Opportunity_Name__r.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where (((CaseNumber like :searchText) OR (Subject like :searchText) OR (RecordType.Name like :searchText)) AND (RecordType.Name IN:samRtNames) AND (Opportunity_Name__c=:opId))];
        }
        else{
            caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Opportunity_Name__r.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where RecordType.Name IN:samRtNames AND Opportunity_Name__c=:opId];

        }
        System.debug('==caseList=='+caseList); 
        return caseList;
    
    }
     public static List<Case> samRequestSearchAcc(String acId,String key){ 
    	
        List<Case> caseList = new List<Case>();
        List<CaseRecordTypes__c> samCaseRT = CaseRecordTypes__c.getall().values();
        List<String> samRtNames = new List<String>();
        for(CaseRecordTypes__c cr:samCaseRT){
            if(cr.Sam_Requests__c == true){
                samRtNames.add(cr.Name);
            
            }
            
        }
        if(key!=null){
            String searchText= '%'+key+'%';
  		 	caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Account.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where (((CaseNumber like :searchText) OR (Subject like :searchText) OR (RecordType.Name like :searchText)) AND (RecordType.Name IN:samRtNames) AND (AccountId=:acId))];
        }
        else{
            caseList = [select Id,OwnerId, RecordTypeId,CaseNumber,subject,Opportunity_Name__r.Name, status, Owner.Name,RecordType.Name,CreatedDate  from Case where RecordType.Name IN:samRtNames AND AccountId=:acId];

        }
        System.debug('==caseList=='+caseList); 
        return caseList;
    
    }
    @AuraEnabled
     public static List<Case> totalcaseList(String objectType,String recordId) {
        List<Case> caseList = new List<Case>();
        if(objectType == 'Account'){
            caseList = totalcaseListAcc(recordId);
        }
        else if(objectType == 'Opportunity'){
            caseList = totalcaseListOpp(recordId);
			            
        }
        return caseList;
         
     }   
    public static List<Case> totalcaseListOpp(String opId) {   
        return [SELECT Id,OwnerId, RecordTypeId,CaseNumber,subject, Account.Name, status, Owner.Name,RecordType.Name,CreatedDate FROM Case WHERE Opportunity_Name__c=:opId];
        
    }
    public static List<Case> totalcaseListAcc(String acId) {   
        return [SELECT Id,OwnerId, RecordTypeId,CaseNumber,subject, Account.Name, status, Owner.Name,RecordType.Name,CreatedDate FROM Case WHERE AccountId=:acId];
        
    } 
    @AuraEnabled
    public static void deleteCaseRecord(String caseId){
        
        Case c = [select Id from Case where Id=:caseId];
        delete c;
    }
    
}


/*public with sharing class LGNA_Lightning_GPAccCasesWithTabCotoller {
 
    @AuraEnabled
    public static List<case> getcaseswithgems(String accId) {
        
        System.debug('==AccId=='+accId);
        List<RecordType> gemRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and Name LIKE:'GEMS%'];
        return [SELECT Id, RecordTypeId,CaseNumber,subject, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:accId AND RecordTypeId IN:gemRecTypeList Order By CreatedDate Desc LIMIT 10];
    }
    @AuraEnabled
    public static List<Case> getcaseswithgemsAll(String acId) {
        
        List<RecordType> gemRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and Name LIKE:'GEMS%'];
        return [SELECT Id, CaseNumber,subject,Account.Name,status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:acId AND RecordTypeId IN:gemRecTypeList Order By CreatedDate Desc];
    }
    @AuraEnabled
    public static List<Case> getCaseSamRequest(String accountId){
        
        List<RecordType> samRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and (NOT Name LIKE:'GEMS%') AND DeveloperName!='SG_General_Case'];
        return [SELECT Id, RecordTypeId,CaseNumber,subject, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:accountId AND RecordTypeId IN:samRecTypeList Order By CreatedDate Desc LIMIT 10];
    }
    @AuraEnabled
    public static List<Case> getCaseSamRequestAll(String acId){
        List<RecordType> samRecTypeList = [Select Id,name From RecordType where sobjecttype = 'Case' and (NOT Name LIKE:'GEMS%') AND DeveloperName!='SG_General_Case'];
        return [SELECT Id, RecordTypeId,CaseNumber,subject, Account.Name, status, Owner.Name,RecordType.Name,CreatedDate FROM Case where AccountId=:acId AND RecordTypeId IN:samRecTypeList Order By CreatedDate Desc];
    } 
    @AuraEnabled
    public static List<Case> totalcaseList(Id acId) {   
        return [SELECT Id, RecordTypeId,CaseNumber,subject, Account.Name, status, Owner.Name,RecordType.Name,CreatedDate FROM Case WHERE AccountId=:acId];
        
    }
}*/