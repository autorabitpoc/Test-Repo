public with sharing class HPS_MyRenewalsController {
    
    public List<MyRenewalsWrapper> myRenewalsList {get; set;}
    public Map<Id, Opportunity> mapOfOpportunityIdAndOpportunity = new Map<Id, Opportunity>();
    public Map<String, Integer> mapOfOpportunityIdAndProjectedMembers = new Map<String, Integer>();
    @TestVisible OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAOInstance;
    public Exception exceptionObj {get; set;}

    public HPS_MyRenewalsController(){
        this(new OpportunityProductDAO());
    }

    private HPS_MyRenewalsController(OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAOInstance){
        this.opportunityProductDAOInstance = opportunityProductDAOInstance;
        populateMyRenewals();
    }

    private void populateMyRenewals(){

        try{
            MyRenewalsWrapper myRenewalsObj;
            myRenewalsList = new List<MyRenewalsWrapper>();
            List<Id> opportunityIds = new List<Id>();
            
            Id renewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            
            for(OpportunityTeamMember opportunityTeamMemberObj : [  SELECT  OpportunityId 
                                                                    FROM    OpportunityTeamMember 
                                                                    WHERE   Opportunity.RecordTypeId =: renewalRecordTypeId 
                                                                        AND UserId =: UserInfo.getUserId() and Opportunity.IsClosed = false
                                                                    limit   :Limits.getLimitQueryRows() - Limits.getQueryRows()]){
                opportunityIds.add(opportunityTeamMemberObj.OpportunityId);
            }
  
            for(Opportunity opportunityObj : [  SELECT  Id, Name, AccountId, Account.Name, CloseDate, StageName, Account.Current_Risk_Level__c,  Expected_Health_Members__c  
                                                FROM    Opportunity 
                                                WHERE   RecordTypeId =: renewalRecordTypeId 
                                                    AND OwnerId =: UserInfo.getUserId() and IsClosed = false
                                                limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ]){
                opportunityIds.add(opportunityObj.Id);
            }
          
            for(Opportunity opportunityObj : [  SELECT  Id, Name, AccountId, Account.Name, CloseDate, StageName, Account.Current_Risk_Level__c,  Expected_Health_Members__c  
                                                FROM    Opportunity 
                                                WHERE   Id IN: opportunityIds and IsClosed = false
                                                limit   :Limits.getLimitQueryRows() - Limits.getQueryRows()]){
                mapOfOpportunityIdAndOpportunity.put(opportunityObj.Id, opportunityObj);
            }
            
            for(AggregateResult aggregateResultObj : opportunityProductDAOInstance.getAggregateOpportunityProductByIds(opportunityIds)){
                mapOfOpportunityIdAndProjectedMembers.put(String.valueOf(aggregateResultObj.get('opportunityName')), Integer.valueOf(aggregateResultObj.get('noOfProjectedMembers')));
            }
       
            for(Id opportunityId : opportunityIds){
                myRenewalsObj = new MyRenewalsWrapper();
                if(mapOfOpportunityIdAndOpportunity.containsKey(opportunityId)){
                    myRenewalsObj.opportunityObj = mapOfOpportunityIdAndOpportunity.get(opportunityId);
                }
                if(mapOfOpportunityIdAndProjectedMembers.containsKey(opportunityId)){
                    myRenewalsObj.projectedMembers = mapOfOpportunityIdAndProjectedMembers.get(opportunityId);
                }
                if(myRenewalsList.size()<10000){
                    myRenewalsList.add(myRenewalsObj);
                }
            }
        }catch(Exception exceptionObj){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,exceptionObj.getMessage());
            ApexPages.addMessage(myMsg);
            this.exceptionObj = exceptionObj;
        }
    }

    public class MyRenewalsWrapper {
        public Opportunity opportunityObj {get; set;}
        public Integer projectedMembers {get; set;}
        
        public MyRenewalsWrapper() {}
    }

    public void logConstructorException(){
        if(exceptionObj != null){
            CreateExceptionLog.insertErrorLog(exceptionObj, null, null, null, 'Apex Controller', 'Opportunity', 
                                                                null, 'HPS_MyRenewalsController constructor', 'High');
        }
    }
}