trigger BatchlookUpCreation on Error_Log__c (after insert) {
    
    if(trigger.isInsert && trigger.isAfter){
        if(trigger.new[0].Application__c=='SGR'){
            
            
            list<Error_Log__c> errRecsUpdate = new list<Error_Log__c>();
            list<Error_Log__c> errRecs = new list<Error_Log__c>();
            list<SGR_Renewal_Batch_Oppty__c> optyRecs = new list<SGR_Renewal_Batch_Oppty__c>();
            list<SGR_Renewal_Batch_Oppty__c> optyRecsUpdate = new list<SGR_Renewal_Batch_Oppty__c>();
            list<SGRRenewalBatch__c> batRecs=new list<SGRRenewalBatch__c>();
            //optyRecs=trigger.new;
            
            
            set<String> batchLst=new set<String>();
            for(Error_Log__c idHolder:trigger.new){
                batchLst.add(idHolder.Batch_ID__c);
            }
            
            
            batRecs=[select id,BatchID__c from SGRRenewalBatch__c where BatchID__c IN:batchLst];
            optyRecsUpdate=[select id,BatchId__c,Batch_ID__c,Opportunity__c from SGR_Renewal_Batch_Oppty__c where Batch_ID__c IN:batchLst];
            errRecsUpdate=[select id,name,Batch_Id__c,Batch_IDL__c,Opportunity_Idl__c from Error_Log__c where Batch_Id__c IN:batchLst FOR UPDATE];
            //errRecsUpdate=trigger.new;
            
            
            
            for(SGRRenewalBatch__c bat:batRecs){
                for(Error_Log__c err:errRecsUpdate){
                    if(bat.BatchID__c==err.Batch_Id__c){
                        System.debug('@@@@@@@@@'+err);
                        err.Batch_IDL__c=bat.id;
                        errRecs.add(err);
                    }
                } 
            }
            try{
                if(errRecs.size()>0){
                    update errRecs;
                }}
            catch(Exception e){
                system.debug('******************'+e);
            }
            
            errRecs.clear();
            for(SGR_Renewal_Batch_Oppty__c batOpty:optyRecsUpdate){
                for(Error_Log__c err:errRecsUpdate){
                    if(batOpty.Batch_ID__c==err.Batch_Id__c){
                        if(batOpty.Opportunity__c==err.Opportunity_Idl__c){
                            err.Renewal_Batch_Opty_IDL__c=batOpty.id;
                            errRecs.add(err);
                        }
                    } 
                }
            }
            try{
                if(errRecs.size()>0){
                    update errRecs;
                } }
            catch(Exception e){
                system.debug('******************'+e);
            }            
        }
        
        
        
    } 
}