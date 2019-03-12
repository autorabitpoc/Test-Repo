public class SGR_Email_Optout {
    public static String returnOppFieldsUpdate(String rating,String workflow,String accId){
        List<Contact> conList = new List<Contact>();
        String producerFlag = '';
        String groupFlag = '';
        String prodAndGroupFlag = '';
        Id producerContactRecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('Producer_Contact').getRecordTypeId();
        Id groupContactRecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('Group_Contact').getRecordTypeId();
        if(accId !=NULL)
            conList = [select id,HasOptedOutOfEmail,Type__c,AccountId,RecordTypeId from Contact 
                       where AccountId=:accId 
                       AND (Type__c='Renewal' OR Type__c='Producer')
                       AND (RecordTypeId=:producerContactRecType OR RecordTypeId=:groupContactRecType)];
        
        for(Contact c:conList){
            if(c.RecordTypeId == producerContactRecType){
                if(c.HasOptedOutOfEmail == True){
                    producerFlag = 'Distribute_Via_Mail_to_Producer__c';
                    break;
                }
            }
        }
        for(Contact c:conList){
            if(c.RecordTypeId == groupContactRecType){
                if(c.HasOptedOutOfEmail == True){
                    groupFlag = 'Distribute_Via_Mail_to_Account__c';
                    break;
                } 
            }
        }
        if(producerFlag != NULL && !String.isBlank(producerFlag) && groupFlag!= NULL && !String.isBlank(groupFlag)){
            prodAndGroupFlag = 'Distribute_Via_Mail_to_Account__c_Producer__c';
            return prodAndGroupFlag;          
        }
        else if(producerFlag != NULL && !String.isBlank(producerFlag)){
            return producerFlag;
        } 
        else if(groupFlag!= NULL && !String.isBlank(groupFlag)){
            return groupFlag;
        }
        return null;  
    }
    
}