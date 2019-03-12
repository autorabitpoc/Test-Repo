public class SGR_LiftGateStatus {
/*
@AuraEnabled
//This method uses a simple SOQL query to return a List of Opprtunity
public Static List<OpptyWrapper> getOpportunity(string GateId) {
    List<OpptyWrapper> optyList =new List<OpptyWrapper>();
    if(optyList != null) {
        optyList = new List<OpptyWrapper>();
        for(Opportunity opty:[SELECT Name,Id,Gate__r.Status__c,Account_Market_Segment__c,Funding_Type__c,HCSC_Division__c,Renewal_Date__c,SGR_Workflow_Status__c,RecordType.Name FROM Opportunity where Gate__c= :GateId]){
            //Creating new wrapper 
            OpptyWrapper op = new OpptyWrapper();
            op.GateStatus = opty.Gate__r.Status__c;
            op.MarketSegment = opty.Account_Market_Segment__c; 
            op.FundingType = opty.Funding_Type__c;
            op.SGRWorkflowStatus = opty.SGR_Workflow_Status__c;
            op.Division=opty.HCSC_Division__c;
            op.RecordTypeName=opty.RecordType.Name;
            op.RenewalDate=opty.Renewal_Date__c; 
            //op.Selected=false;
            op.OptyId=opty.Id;
            op.Name=opty.Name;
            optyList.add(op);
            //optyList.add(new OpptyWrapper(opty));
        }
        
    }
    return optyList;
}
 */
@AuraEnabled
public static Boolean liftGate(List<Opportunity> SelOptyRecords) {
    //List<Actuary_Gate__c> gate =new List<Actuary_Gate__c>();
               
    List<Opportunity> OptyListToUpdate= new List<Opportunity>();
    set<id> sid = new set<id>();
    //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
      if(!SelOptyRecords.isEmpty()){
            for(Opportunity  opp : SelOptyRecords){
                
                if(opp.RecordType.Name=='SGR Production Opportunity')
                {
                    opp.SGR_Workflow_Status__c='Actuarial-Released';
                    sid.add(opp.Gate__c); 
            	}
                
             if(opp.RecordType.Name=='SGR Analytical Opportunity' && opp.Account_Market_Segment__c == opp.Gate__r.Market_Segment__c && opp.Funding_Type__c==opp.Gate__r.Funding_Type__c && opp.HCSC_Division__c==opp.Gate__r.Division__c && opp.Renewal_Date__c==opp.Gate__r.Effective_Date__c)
             {
                opp.SGR_Workflow_Status__c='Rated';
             }
            
                OptyListToUpdate.add(opp);  
             }
      
            List<Actuary_Gate__c> gate=[select Id,status__c,Division__c,Effective_Date__c,Funding_Type__c,Market_Segment__c from Actuary_Gate__c where Id IN :sid];
       
             for(Actuary_Gate__c gate1:gate){
            //Manipulating SGR workflow status based on conditions.
            if(gate1.Status__c =='Down'){
                gate1.Status__c ='Up';
            } 
            update gate1;
             }
      }
        try{
            update OptyListToUpdate;
            return true;
        }
        catch(Exception e){
            return false;
        }
}
/*
public class OpptyWrapper {
        
        @AuraEnabled public String GateStatus {get;set;}
        @AuraEnabled public String MarketSegment {get;set;}
        @AuraEnabled public String FundingType {get;set;}
        @AuraEnabled public String SGRWorkflowStatus {get;set;}
        @AuraEnabled public String Division {get;set;}
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled public String RecordTypeName {get;set;}
        @AuraEnabled public date RenewalDate {get;set;}
    	@AuraEnabled public String OptyId {get;set;}
        @AuraEnabled public Boolean Selected {get;set;}
   
    }
*/
}