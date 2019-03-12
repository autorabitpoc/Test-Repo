/**************************************************************************************
Apex Class Name     : SGR_AccRenewalCopyMemberBenefitsHelper     
Version             : 1.0
Function            : This class is used to Copy Account member benefits into Opportunity Member benefits.
Modification Log    :
* 
* ----------------------------------------------------------------------------               
* INFOSYS                  09/05/2018                Original Version
*************************************************************************************/
public class SGR_AccRenewalCopyMemberBenefitsHelper {
    
    public static void insertOpportunitiesMemberBenefit(Set<id> accId, List<Opportunity> opptyList, String bidErr){
        
        Set<Id> oppIdSet = new Set<Id>();
        
        for(Opportunity oppty: opptyList){
            oppIdSet.add(oppty.Id);
        }
        
        List<SGR_Opportunity_Group_Section__c> oppGsec =new List<SGR_Opportunity_Group_Section__c>();
        List<SGR_Opportunity_Census__c> oppCensLst=new List<SGR_Opportunity_Census__c>(); 
        List<SGR_Opportunity_Member_Benefits__c> oppMemBefs = new List<SGR_Opportunity_Member_Benefits__c>();
        List<String> planIDS = new List<String>();
        Map<String,SGR_Opportunity_Plan_Rate__c> memPlanMap =  new Map<String,SGR_Opportunity_Plan_Rate__c>();
        List<SGR_Account_Member_Benefit__c> accMemBefs = new List<SGR_Account_Member_Benefit__c>();
        
        for(SGR_Account_Member_Benefit__c accMB : [SELECT    Name, Member_Benefit_Effective_Date__c,
                                                   Member_Policy_Tier__c,Member_Rates_or_Composite_Rates__c,
                                                   TAX__c,Subscriber_Number__c,Row__c,Group_Number__c, Rate_Type_Code__c, Premium_Amount__c, /* Cesar: Added Premium Ammount Column */
                                                   Benefit_Agreement_Number__c,ACA_Fee__c, Marketing_Plan_Number__c, Account_Census__r.Account__r.Renewal_Date__c,
                                                   Account_Census__r.Name, Account_Census__r.Member_Cancel_Date__c, Account_Census__r.Member_Effective_Date__c,
                                                   Group_Section__r.Name,Group_Section__r.Group_Name__c
                                                   FROM SGR_Account_Member_Benefit__c 
                                                   WHERE account__r.id IN:accId and Benefit_Agreement__r.Status__c ='Active']){
                                                       accMemBefs.add(accMB);
                                                       /*Akhil: getting Marketing Plan Ids from ACcount Member Benefit*/
                                                       planIDS.add(accMB.Marketing_Plan_Number__c); 
                                                   }
       
       // map<id,List<SGR_Opportunity_Group_Section__c>> oppGrpSc = new map<id,List<SGR_Opportunity_Group_Section__c>>();   
      //  map<id,List<SGR_Opportunity_Census__c>> oppCens = new map<id,List<SGR_Opportunity_Census__c>>();
        
      /*  List<opportunity> lstopp = [SELECT  Id, Name ,Batch_Id__c , 
                                    (   SELECT  Id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,
                                     Membership_Number__c, Member_Effective_Date__c 
                                     FROM Opportunity_Census__r ),
                                    (SELECT Id, Name,Group_Name__c,Benefit_Agreement_Cancel_Date__c 
                                     FROM Opportunity_Group_Section__r ) 
                                    FROM opportunity
                                    WHERE id IN:oppIdSet];*/
        
        
        /*Akhil: querying opportunity plan rate and putting it in memPlanMap*/
        for(SGR_Opportunity_Plan_Rate__c oppPR : [SELECT Id,Type__c, Marketing_Plan_ID__c,Opportunity__c
                                                  FROM SGR_Opportunity_Plan_Rate__c 
                                                  WHERE   Opportunity__c IN:oppIdSet AND
                                                  Marketing_Plan_ID__c IN:planIDS AND 
                                                  Type__c IN ('Current', 'Renewal') ]) {
                                                      
                                                      memPlanMap.put(oppPR.Marketing_Plan_ID__c+oppPR.Type__c,oppPR);
                                                  }
        
       /* for(Opportunity os : lstopp){
            oppCens.put(os.id,os.Opportunity_Census__r);
            oppGrpSc.put(os.id,os.Opportunity_Group_Section__r);
        }
        
        for(Opportunity os :lstopp){
            oppGsec.addAll(oppGrpSc.get(os.id));
            oppCensLst.addAll(oppCens.get(os.id));
        }*/
        
        for(Opportunity os :[SELECT  Id, Name ,Batch_Id__c , 
                                    (   SELECT  Id,Name,Account__c,Opportunity__c,Member_Cancel_Date__c,
                                     Membership_Number__c, Member_Effective_Date__c 
                                     FROM Opportunity_Census__r ),
                                    (SELECT Id, Name,Group_Name__c,Benefit_Agreement_Cancel_Date__c 
                                     FROM Opportunity_Group_Section__r ) 
                                    FROM opportunity
                                    WHERE id IN:oppIdSet]){
            oppGsec.addAll(os.Opportunity_Group_Section__r);
            oppCensLst.addAll(os.Opportunity_Census__r);
        }
               
        for(SGR_Account_Member_Benefit__c amb:accMemBefs)
        {
            SGR_Opportunity_Member_Benefits__c omb = new SGR_Opportunity_Member_Benefits__c();
            omb.name=amb.name;
            omb.ACA_Fee__c=amb.ACA_Fee__c;
            omb.Member_Rate__c = amb.Premium_Amount__c; /* Cesar: Setting member rate */
            omb.Rate_Type__c = amb.Rate_Type_Code__c == 'STN' ? 'Composite' : 'Age'; /* Cesar: Setting Rate Type */
            omb.Benefit_Agreement_Number__c=amb.Benefit_Agreement_Number__c;
            omb.Group_Number__c=amb.Group_Number__c;
            omb.Row__c=amb.Row__c;
            omb.Subscriber_Number__c=amb.Subscriber_Number__c;
            
            /* Akhil: populate Plan Rate of type current on Opportunity Member Benefit */
           
                if(memPlanMap != null && amb.Marketing_Plan_Number__c!=null && memPlanMap.containsKey(amb.Marketing_Plan_Number__c+'Current') && memPlanMap.get(amb.Marketing_Plan_Number__c+'Current').Type__c=='Current'){
                    omb.Opportunity_Plan_Rate__c = memPlanMap.get(amb.Marketing_Plan_Number__c+'Current').Id;
                    omb.Opportunity__c = memPlanMap.get(amb.Marketing_Plan_Number__c+'Current').Opportunity__c;
                }
            
            for(SGR_Opportunity_Group_Section__c ogs:oppGsec){
                
                if(amb.Group_Section__r.name==ogs.name){
                    omb.Opportunity_Group_Section__c=ogs.id;
                   break;
                }
            }
            
            for(SGR_Opportunity_Census__c ocs:oppCensLst)
            {
                
                 // Check if the Census is active or not (ignore if Expired or Cancelled before the Renewal Date)
                    if(amb.Account_Census__r.name==ocs.name && (amb.Account_Census__r.Member_Cancel_Date__c > amb.Account_Census__r.Account__r.Renewal_Date__c || amb.Account_Census__r.Member_Cancel_Date__c == null) && amb.Account_Census__r.Member_Effective_Date__c < amb.Account_Census__r.Account__r.Renewal_Date__c)
                    {
                        omb.Opportunity_Census__c=ocs.id;
                        omb.TAX__c=amb.TAX__c;
                        omb.Member_Rates__c=amb.Member_Rates_or_Composite_Rates__c;
                        
                        /*SFDC-14082 Added member policy tier reference*/
                        omb.Member_Policy_Tier__c = amb.Member_Policy_Tier__c;
                        omb.Member_Benefit_Effective_Date__c=amb.Member_Benefit_Effective_Date__c;
                        oppMemBefs.add(omb);
                        
                        /*Akhil : Clone the created Member Benefits and attach plan rate of type current*/
                        SGR_Opportunity_Member_Benefits__c newomb = omb.clone(false,true);
                        
                            if(memPlanMap != null && amb.Marketing_Plan_Number__c!=null && memPlanMap.containsKey(amb.Marketing_Plan_Number__c+'Renewal') && memPlanMap.get(amb.Marketing_Plan_Number__c+'Renewal').Type__c=='Renewal')
                                {
                                    newomb.Opportunity_Plan_Rate__c = memPlanMap.get(amb.Marketing_Plan_Number__c+'Renewal').Id;
                                    oppMemBefs.add(newomb);            
                                }
                    }
            }
        }         
        
        if(!oppMemBefs.isEmpty()){
            try{
                /*Insert opBenList;*/
                Database.SaveResult[] result=database.insert(oppMemBefs,false);
                List<String> errMsgsList=new List<String>();
                for(Database.SaveResult sr : result){
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            errMsgsList.add(err.getMessage());
                        }
                        SGR_AccountRenewalsHelper.createErroLog(errMsgsList,bidErr);
                    }
                }
            }
            catch(exception e){
                system.debug('Exception Occured'+e);
            }
        } 
        
    }
    
    
}