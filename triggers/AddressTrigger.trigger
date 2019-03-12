trigger AddressTrigger on GEMS_Address__c (before insert, before update) {

    if(trigger.isBefore && trigger.isInsert && !System.isFuture()){
    //checkPrimaryAddress method validates and stops the insert of a new primary address if the account already has another 
    //primary address assigned to it.
       GEMS_AddressTriggerHandler.checkPrimaryAddress(trigger.new);
        set<string> addrSequences = new set<string>();
        string corpCode;
        string accountNumber;
        list<GEMS_Address__c> newAddresses = trigger.New;
        if(newAddresses != null && newAddresses.size() > 0){
            
            list<Account> accounts = [SELECT External_Id__c 
                                                    FROM Account
                                                        WHERE Id = : newAddresses[0].Account__c];
            for(Account account : accounts){
                string corpAccountNumber = account.External_Id__c;
                if(corpAccountNumber != null){
                    corpCode = corpAccountNumber.substring(0, 2) + '1';
                    accountNumber = corpAccountNumber.substring(2, corpAccountNumber.length());  
                }
            }
            
            list<GEMS_Address__c> existingAddresses = [SELECT Address_Sequence__c
                                                    FROM GEMS_Address__c
                                                        WHERE Account__c = : newAddresses[0].Account__c
                                                            AND Address_Sequence__c != null];
            
            for(GEMS_Address__c existingAddress : existingAddresses){
                if(existingAddress.Address_Sequence__c != null){
                    addrSequences.add(existingAddress.Address_Sequence__c.substringAfterLast('-'));
                }
            }
            system.debug('addrSequences :' + addrSequences);
            
            for(GEMS_Address__c newAddress : newAddresses){
                if(newAddress.Address_Sequence__c == null){
                    Integer addrSequence;
                    do{
                        addrSequence = Integer.valueOf(FW_GUID_Generator.generateNumber(4));
                        system.debug('addrSequence :' + addrSequence);
                    }
                    while(addrSequences.contains(string.valueOf(addrSequence)));
                    newAddress.Address_Sequence__c = corpCode + '-' + accountNumber + '-' + string.valueOf(addrSequence);
                    addrSequences.add(string.valueOf(addrSequence));
                }
            }
            //update newAddresses;
        }
    }
    
    if(trigger.isBefore && trigger.isUpdate && !System.isFuture()){
      //checkPrimaryAddress method validates and stops the update of any address being marked as primary
      //if the account already has another primary address assigned to it.
        GEMS_AddressTriggerHandler.checkPrimaryAddress(trigger.new);
        list<GEMS_Address__c> newAddresses = trigger.New;
        if(newAddresses != null && newAddresses.size() > 0){
            for(GEMS_Address__c newAddress : newAddresses){
                newAddress.IsUpdated__c = true;
            }
        }
    }

}