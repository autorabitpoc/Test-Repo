public class GEMS_ScopeCodeDetailController {
    
    public GEMS_Pharmacy_Scope_Code__c ScopeCodeRecord{get;set;}
    public List<GEMS_Pharmacy_Scope_Code__c> RelatedScopeCodeRecord{
        get{
            if (ScopeCodeRecord.Type__c == 'Permanent'){
                return [SELECT Id, Name, Case__c, Temp__c, Type__c, Related_Scope_Code__c, Mail__c, Retail__c,
                                     		Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Peer_Reviewer__c 
                                      			FROM GEMS_Pharmacy_Scope_Code__c WHERE Related_Scope_Code__c =: ScopeCodeRecord.Name];     
            }
            else {
                return [SELECT Id, Name, Case__c, Temp__c, Type__c, Related_Scope_Code__c, Mail__c, Retail__c,
                                     		Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Peer_Reviewer__c
                                      			FROM GEMS_Pharmacy_Scope_Code__c WHERE Name =: ScopeCodeRecord.Related_Scope_Code__c];
            }
        }
        set;
    }
        public GEMS_ScopeCodeDetailController(ApexPages.standardController con) {
        try {
            GEMS_Pharmacy_Scope_Code__c ScopeCodeRec = (GEMS_Pharmacy_Scope_Code__c)con.getRecord();
            ScopeCodeRecord = [SELECT Id, Name, Case__c, Temp__c, Type__c, Related_Scope_Code__c, Mail__c, Retail__c,
                               		Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Peer_Reviewer__c, Owner.Name
                               			FROM GEMS_Pharmacy_Scope_Code__c WHERE ID =: ScopeCodeRec.ID];
            
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_TaskEligibilityController(ApexPages.standardController con)','High');  
        }  
    }

}