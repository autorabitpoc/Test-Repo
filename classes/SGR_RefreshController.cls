public class SGR_RefreshController {
    
    Public  list<String> initiaterefresh(List<SGR_Opportunity_Benefit_Agreement__c> obfaList)
        
    {
        List<String> Successmsg = new List<String>();
        /*set<ID> tempid= new set<ID>();
        tempid=obfid;
       List<String > s = new list<String>();
       String oppId;
       String AccId;
       //List<SGR_Opportunity_Benefit_Agreement__c> oppid= new List<SGR_Opportunity_Benefit_Agreement__c>();
       //List<SGR_Opportunity_Benefit_Agreement__c>  Accid= new List<SGR_Opportunity_Benefit_Agreement__c>();
       oppId = [select Opportunity__c from SGR_Opportunity_Benefit_Agreement__c where ID IN :tempid Limit 1].Opportunity__c;
        //oppid= [select Opportunity__r.id from SGR_Opportunity_Benefit_Agreement__c where ID IN :tempid];
        //Accid=[select Opportunity__r.AccountID  from SGR_Opportunity_Benefit_Agreement__c where ID IN :tempid]; 
         AccId= [select Opportunity__r.AccountID  from SGR_Opportunity_Benefit_Agreement__c where ID IN :tempid Limit 1].Opportunity__r.AccountID;
    List<SGR_Opportunity_Benefit_Agreement__c> oppbfa = [Select id,name from SGR_Opportunity_Benefit_Agreement__c  where ID =:oppId];
     List<Benefit_Agreement__c> accbfa = [select id,name from Benefit_Agreement__c where ID =:AccId];
       for(Benefit_Agreement__c bps: accbfa)
       {
            if(bps.Benefit_Agreement_Number__c==bps.Group_Account__c)
               {
                   
                   
               }
               else{
                   
                   
               }
           
           }
           
           
      */
       
     return Successmsg;   

    }

    
}