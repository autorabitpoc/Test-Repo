public class SGR_EventAuditCreation {
   public static void EventAuditCreation(List<opportunity>  opplist,Map<id,Opportunity> oppMap,Map<id,Opportunity> nwMap){
        try{
            Boolean isInsert = (oppMap == null);
            String UID;       
            List<EventAuditTrail__c> evntList = new List<EventAuditTrail__c>();
            if(isInsert){
                if(NULL !=opplist &&  opplist.size()>0){
                    for(opportunity op:opplist){
                        if(op.Assigned_UW__c != NULL){
                            EventAuditTrail__c evntRec = new EventAuditTrail__c();
                            evntRec.Opportunity__c = op.id;
                            evntRec.Event_Message__c = 'UW User is assigned';
                            evntRec.Event_Type__c = 'Internal Workflow';
                            UID =   op.Assigned_UW__r.name;
                            evntList.add(evntRec);
                        }
                    }
                }
            }
            else{
                for(Opportunity op : opplist){
                    if(oppMap.containsKey(op.Id) && oppMap.get(op.Id) != null && oppMap.get(op.Id).Assigned_UW__c  != nwMap.get(op.id).Assigned_UW__c){
                        EventAuditTrail__c evntRec = new EventAuditTrail__c();
                        evntRec.Opportunity__c = op.id;
                        evntRec.Event_Message__c = 'UW User is Changed/Removed';
                        evntRec.Event_Type__c = 'Internal Workflow';
                        UID =   op.Assigned_UW__c;
                        evntList.Add(evntRec);
                    }
                }
            }
            system.debug('**************'+evntList.size());
            system.debug('**************'+UID);
            if(evntList != null && !evntList.isEmpty()){
                insert evntList;
            }
        }
        catch(Exception Ex){
           system.debug('Exception Occured'+Ex.getStackTraceString());
        }
    }
}