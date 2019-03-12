public class SGR_BAGS{
    Public static List<String> initiaterefresh(List<SGR_Opportunity_Benefit_Agreement__c> obfaList,Id oppId){
        set<id> ide = new set<id>();
        set<id> accids = new set<id>();
        set<id> baID = new set<id>();
        List<SGR_Opportunity_Benefit_Agreement__c> OlBA = new List<SGR_Opportunity_Benefit_Agreement__c>();
        list<SGR_Opportunity_Group_Section__c> oGS = new list<SGR_Opportunity_Group_Section__c>(); 
        Map<id,list<SGR_Opportunity_Group_Section__c>> aChild = new Map<id,list<SGR_Opportunity_Group_Section__c>>();
        if(!obfaList.isempty()){
            OlBA = obfaList;
            for(SGR_Opportunity_Benefit_Agreement__c sg:obfaList){	
                ide.add(sg.Opportunity__c);
                baID.add(sg.id);
            }
        } 
        
        List<opportunity> sgrList = [select Account.id,Account.Name from Opportunity where id IN: ide];
        
        if(!sgrList.isempty())
            for(opportunity opp :sgrList ){
                accids.add(opp.accountID);
                
            }
        //       List<SGR_Opportunity_Benefit_Agreement__c> baList = [select id ,(select id from Opportunity_Group_Section__r) from SGR_Opportunity_Benefit_Agreement__c where ID IN:baID];
        List<SGR_Opportunity_Group_Section__c> gaList = [select id,Benefit_Agreement__c from SGR_Opportunity_Group_Section__c where Benefit_Agreement__c IN:baID]; 
        
        try{
            delete OlBA;
            if(!gaList.isEmpty())
                delete gaList;
        }
        catch(Exception E){
            
            system.debug('Exception Occured'+ E);
             throw new AuraHandledException('Error while erasing Child Records. Contact System Administrator');
        }
        if(OlBA.size()==0){
            //SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(accids);
        }
        if(gaList.size()==0){
            //SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(accids);
        }
     List<String> Successmsg = new List<String>();   
      return Successmsg;   
    }
    
}