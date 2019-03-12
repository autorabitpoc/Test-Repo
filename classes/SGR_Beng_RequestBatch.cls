global class SGR_Beng_RequestBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global final String Query;
    global SGR_Beng_RequestBatch(){
        Query = 'SELECT Id,Distribute_Via_Mail_to_Producer__c,Sent_Via_Mail_to_Producer__c,Distribute_Via_Mail_to_Account__c,Sent_Via_Mail_to_Account__c FROM Opportunity WHERE ((Sent_Via_Mail_to_Producer__c=FALSE AND Distribute_Via_Mail_to_Producer__c=TRUE) OR (Distribute_Via_Mail_to_Account__c=TRUE AND Sent_Via_Mail_to_Account__c=FALSE))';
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        List<Opportunity> opplSt= new  List<Opportunity>();
        for( Opportunity opty :scope){
            if(!opty.Sent_Via_Mail_to_Producer__c&&opty.Distribute_Via_Mail_to_Producer__c){
                //Here we need to send dco version 
                SGR_Beng_XML_Response Response = Sgr_Beng_Request.SendRequest(opty.Id, 'PRINT','Producer');
                system.debug('==Response=='+Response);
                if(Response!=Null){
                    opty.Sent_Via_Mail_to_Producer__c= true;
                    opty.Beng_LatestTransactionID__c=Response.transactionId;
                    opplSt.add(opty);
                }   
            }
            if(opty.Distribute_Via_Mail_to_Account__c  && !opty.Sent_Via_Mail_to_Account__c){
                SGR_Beng_XML_Response ResponseAcc = Sgr_Beng_Request.SendRequest(opty.Id, 'PRINT','Account');
                system.debug('==ResponseAcc=='+ResponseAcc);
                if(ResponseAcc!=Null){
                    opty.Sent_Via_Mail_to_Account__c= true;
                    opty.Beng_LatestTransactionID__c=ResponseAcc.transactionId;
                    if(!opplSt.contains(opty)){
                        opplSt.add(opty);
                    }
                }   
            }
        }  
        if(opplSt.size()>0){
            update opplSt;
        }
    }
    global void finish(Database.BatchableContext bc){

    }
}