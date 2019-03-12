public class Prototype_SGR_ValidationHelper {
    
    private List<Prototype_OpportunityModel> opptyModelList { get; set; }
    private List<Opportunity> oppList {get; set;}
    
    public Prototype_SGR_ValidationHelper(List<Opportunity> opps, String BatchId)
    { 
        //callingMethods(opps,BatchId);
        
    }
    //Code added to Test BR Frame work
    public Prototype_SGR_ValidationHelper(List<Opportunity> opps, String BatchId, Boolean isBatch) 
    { 
        if(isBatch && String.isBlank(BatchId)) {
            // throw an error. 
        }
        
        oppList = opps;
        
        
    }
    
    public void StartValidation() {
        opptyModelList.addAll(GetOpportunityModels(oppList));
        Prototype_ValidationRuleValidator validator = new Prototype_ValidationRuleValidator(opptyModelList);
    }
    
    private void SetUpValidationHelper(List<Opportunity> opptyList) {
        opptyModelList = GetOpportunityModels(opptyList);
    }
    
    
    private List<Prototype_OpportunityModel> GetOpportunityModels(List<Opportunity> opportunities) {
        
        List<String> OpptyIdList = new List<String>(); 
        List<Prototype_OpportunityModel> OpptyModelList = new List<Prototype_OpportunityModel>();
        
        //for(String Id: )
        
        /* Child queries */
        /* Benefits aggrements */
        List<SGR_Opportunity_Benefit_Agreement__c> BAList = [SELECT Id
                                                             FROM SGR_Opportunity_Benefit_Agreement__c 
                                                             WHERE Opportunity__c IN :OpptyIdList  LIMIT 2000];
        /* Group Sections */
         List<SGR_Opportunity_Group_Section__c> GSList = [SELECT Id 
                                                          FROM SGR_Opportunity_Group_Section__c 
                                                          WHERE Opportunity__c IN :OpptyIdList LIMIT 2000];
        /* Census */
         List<SGR_Opportunity_Census__c> CensusList = [SELECT Id 
                                                       FROM SGR_Opportunity_Census__c 
                                                       WHERE Opportunity__c IN :OpptyIdList LIMIT 2000];
        /* Member Benefits */
         /*List<SGR_Opportunity_Member_Benefits__c> MBList = [SELECT Id 
                                                            FROM SGR_Opportunity_Member_Benefits__c 
                                                            WHERE Opportunity__c IN :OpptyIdList LIMIT 2000];*/
        
        
        /* Create a map Opportunity/ child ojects*/
        
        /* Create a list of opportunity models */
        
        
        return OpptyModelList;
        
    }
    

    
    public static String callingMethods1(List<Opportunity> opps, String BatchId) {
        String msg;
        system.debug('******** inside Method*****');
        map<String,SGR_Business_Rule__c> sbrmap = new  map<String,SGR_Business_Rule__c>();
        List<SGR_Business_Rule__c> br=[select id,Rule_Code__c,Proposed_wording_fail__c,Proposed_wording_pass__c from SGR_Business_Rule__c ];
        for (SGR_Business_Rule__c sa:br){
            sbrmap.put(sa.Rule_Code__c,sa);
        }
        
        map<id,List<SGR_Renewal_Batch_Oppty__c>>oppsrbop = new map<id,List<SGR_Renewal_Batch_Oppty__c>>();
        map<id,List<SGR_Opportunity_Group_Section__c>>oppsgrogs1 = new map<id,List<SGR_Opportunity_Group_Section__c>>();  
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppsgrobamap = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();  
        map<id,List<SGR_Opportunity_Census__c>> oppsgrogs = new map<id,List<SGR_Opportunity_Census__c>>();
        map<Id, List<SGR_Opportunity_Member_Benefits__c>> benefits = new map<Id, List<SGR_Opportunity_Member_Benefits__c>>();
        List<SGR_Opportunity_Census__c> optyCens = new List<SGR_Opportunity_Census__c>();
        List<opportunity> lstopp = [SELECT Id, name, Batch_Id__c,Funding_Type__c, (SELECT Id, Name ,Batch_Id__c from SGR_Renewal_Batch_Opptys__r),(SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),(SELECT id,Name,Account__c,Opportunity__c,Relationship_Code__c,Member_Cancel_Date__c,Membership_Number__c,Member_Effective_Date__c,Relationship__c, Subscriber_number__c, Date_of_Birth__c FROM Opportunity_Census__r),(SELECT Id, Name,Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r) FROM opportunity where (id IN:opps AND Batch_Id__c=:BatchId)];
        
        //Keeping all the child objects related opportunity in a Map
        for(Opportunity os :lstopp) {
            
             oppsrbop.put(os.id,os.SGR_Renewal_Batch_Opptys__r);
             //SGR_Opportunity_Census__c opCen = os.Opportunity_Census__r;
             oppsgrobamap.put(os.id, os.Opportunity_Benefit_Agreements__r);
             oppsgrogs.put(os.id,os.Opportunity_Census__r);
             oppsgrogs1.put(os.id,os.Opportunity_Group_Section__r);
             optyCens = os.Opportunity_Census__r;
        }
        List<SGR_Opportunity_Census__c> memBenefits = new List<SGR_Opportunity_Census__c>();
        
        if (optyCens.size() > 0) {
            memBenefits = [Select Id, (Select Id, Name, Member_Policy_Tier__c, Subscriber_Number__c
                                                                   From Opportunity_Member_Benefits__r)
                                                       from SGR_Opportunity_Census__c where Id IN :optyCens];
            for (SGR_Opportunity_Census__c oc : memBenefits) {
                benefits.put(oc.Id, oc.Opportunity_Member_Benefits__r);
            }
        }
        
        system.debug('==========='+oppsgrobamap);
        system.debug('==========='+oppsgrogs);
        system.debug('============'+oppsgrogs1);
        
        System.debug('Opportunities: ' + opps);
        
        List<SGRRenewalBatch__c> RenewBatchId = new List<SGRRenewalBatch__c>();
        RenewBatchId=[select Id,BatchID__c from SGRRenewalBatch__c where BatchID__c =:BatchId];
        return msg;
    }   

}