trigger LookUpCreation on SGR_Renewal_Batch_Oppty__c (after insert) {

    if(trigger.isInsert && trigger.isAfter){
    list<SGR_Renewal_Batch_Oppty__c> optyRecs = new list<SGR_Renewal_Batch_Oppty__c>();
    list<SGR_Renewal_Batch_Oppty__c> optyRecsUpdate = new list<SGR_Renewal_Batch_Oppty__c>();
    //optyRecs=trigger.new;
    List<String> batchLst=new list<String>();
    for(SGR_Renewal_Batch_Oppty__c idHolder:trigger.new){
        batchLst.add(idHolder.Batch_ID__c);
    }
    list<SGRRenewalBatch__c> batRecs=new list<SGRRenewalBatch__c>();
    batRecs=[select id,BatchID__c from SGRRenewalBatch__c where BatchID__c IN:batchLst];
    optyRecsUpdate=[select id,BatchId__c,Batch_ID__c from SGR_Renewal_Batch_Oppty__c where Batch_ID__c IN:batchLst FOR UPDATE];
  // optyRecsUpdate=trigger.new;
    for(SGRRenewalBatch__c bat:batRecs){
       for(SGR_Renewal_Batch_Oppty__c opty:optyRecsUpdate){
       	System.debug('bat.BatchID__c::'+bat.BatchID__c);
       	System.debug('opty.Batch_ID__c::'+opty.Batch_ID__c);
        if(!String.isBlank(bat.BatchID__c)  && bat.BatchID__c==opty.Batch_ID__c){
                            opty.BatchId__c=bat.id;
                           optyRecs.add(opty);
             }
       } 
      }
    if(optyRecs.size()>0){
        update optyRecs;
    }
    }
    }