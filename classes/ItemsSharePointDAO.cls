public class ItemsSharePointDAO implements IItemsSharePointDAO{
    public interface IItemsSharePointDAO{
        Integer getAccountsCountById(Id accountId);
        Integer getOpportunitiesCountById(Id oppId);
        Integer getCasesCountById(Id oppId);
        List<items_Sharepoint__x> getItemizedSharePointRecordsDynamically(String soql);
    }

    public Integer getAccountsCountById(Id accountId) {
        return [SELECT count() FROM items_Sharepoint__x WHERE AccountId__c = :accountId AND isFolder__c = false];
    }

    public Integer getOpportunitiesCountById(Id oppId){
        return [SELECT count() FROM items_Sharepoint__x WHERE OpportunityId__c = :oppId AND isFolder__c = false];
    }

    public Integer getCasesCountById(Id caseId){
        return [SELECT count() FROM items_Sharepoint__x WHERE CaseId__c = :caseId AND isFolder__c = false];
    }

    public List<items_Sharepoint__x> getItemizedSharePointRecordsDynamically(String soql){
        return Database.query(soql);
    }
}