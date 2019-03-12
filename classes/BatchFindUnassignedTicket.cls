global class BatchFindUnassignedTicket implements Database.Batchable<Sobject>, Database.Stateful, Database.AllowsCallouts {
    
    String query='select id from Ticket__c where Days_to_Event_Starts__c<=5 and client__c =null AND contact__c=null and producer_for_Event__c=null and prospect__c=null and vendor__c=null limit 1';
    list<String>emailsAddress=new List<String>();
    String[] toAddresses = new String[]{};
    Map <String, String> emailToTicketNumMap=new Map<String, String>();
    Map<String, String> emailToName=new Map<String, String>();
    Map<Id,String> reqEmail=new Map<Id,String>();
    Map<string,list<EmailGrouping>> reqToEmailGroup=new Map<String, list<EmailGrouping>>();
    
    public BatchFindUnassignedTicket(){
        
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC ){
        return Database.getQueryLocator(query);
    }
    /*
    global Iterable<AggregateResult> start(Database.batchableContext info){
        // just instantiate the new iterable here and return
        return new AggregateResultIterable();
    }*/
   global void execute(Database.BatchableContext BC, List<Ticket__c> scope){//AggregateResult[] groupedResults List<Ticket__c> 
    
       list<Id> reqId =new list<Id> ();
       list<Id> eventIds=new list<Id>();
       
       Map <Id, Integer> reqToNumMap=new Map<Id, Integer>(); 
      
       Map<Id, String> reqToEmail=new Map<Id, String>();
       Map<Id, String>reqToName=new Map<Id, String>();
        
       AggregateResult[] result=[select count(id) num,Ticket_Event__c eventId, Ticket_Event__r.name event,Ticket_Event__r.Event_Date__c date,Ticket_Event__r.Event_Time__c time,Ticket_Grouping__c grpId,Ticket_Grouping__r.name grpName,Requestor_contact__r.name reqName, Requestor_contact__c req from Ticket__c where Days_to_Event_Starts__c<=5 and client__c =null AND contact__c=null and producer_for_Event__c=null and prospect__c=null and vendor__c=null group by Ticket_Event__c,Ticket_Event__r.name,Ticket_Event__r.Event_Date__c, Ticket_Event__r.Event_Time__c, Ticket_Grouping__c,Ticket_Grouping__r.name,Requestor_contact__c,Requestor_contact__r.name limit 200];
       
       
       list<TicketWrapper> ticketWrapperlist=new list<TicketWrapper>();
       
       TicketWrapper wrapper;
    
       try{
        
        Integer i=0;
        Id requester=null;
        Integer num=0;
        String event=null;
        String eventId=null;
        Date eventDate=null;
        String eventTime=null;
        String reqName=null;
        String groupName=null;
        String eventDesc=null;
        Id groupId=null;
      //  Id backUpId=[select id from Contact where id='0031900000Fwmw3' limit 1].id;
        
        for(AggregateResult ar: result){
            
        // AggregateResult ar = (AggregateResult) s;
       //    if(ar.get ('req')!=null){
             
             requester=(Id)ar.get ('req');
      
            num=(Integer)ar.get('num');
            eventId=(Id)ar.get('eventId');
            event=(String)ar.get('event');
            eventDate=(Date)ar.get('date');
            eventTime=(String)ar.get('time');
            system.debug('event time:'+eventTime);
            if(eventTime==null ||eventTime=='00.00.00'){
                eventTime='';
            }
            reqName=(String)ar.get('reqName'); 
            groupName=(String)ar.get('grpName');
            groupId=(Id)ar.get('grpId');
            
            reqId.add(requester);
            eventIds.add(eventId);
            
            wrapper=new TicketWrapper();
            wrapper.requesterId=requester;
            wrapper.eventName=event;
            wrapper.eventId=eventId;
            wrapper.eventDate=eventDate;
            wrapper.eventTime=eventTime;
            wrapper.unAssignedNum=num;
            wrapper.requesterName=reqName;
            wrapper.groupName=groupName;
            wrapper.groupId=groupId;
            ticketWrapperlist.add(wrapper);
        // }
      }
       
      list<Contact> requesters=null;
       //find email address
       ContactDAO.IContactDAO contactDAOInstance;
    
       if(reqId.size()>0){
        //  requesters=new ContactDAO().getContactsById(reqId);
        requesters=[select id, name, email from Contact where id in:reqId];
         
          for(Contact c:requesters){   
            if(c.email!=null && c.email!=''){
                system.debug('email address: '+c.email);
                reqToEmail.put(c.id,c.email);
           
            }      
         }
       }
      
       list<Ticket_Event__c> eventList=new list<Ticket_Event__c>();
       Map<Id,Ticket_Event__c> eventMap=new Map<Id,Ticket_Event__c>();
       
       if(!eventIds.isEmpty()){
         eventList=[select Id, Event_Description__c from Ticket_Event__c where Id in:eventIds];
         for(Ticket_Event__c te: eventList){
             eventMap.put(te.id, te);
         }
          system.debug('eventList;;;;'+eventList+' eventMap: '+eventMap.keySet());
       }
       
       
      
       list <EmailGrouping> groupList;//new list<EmailGrouping>();
       String keystr=null;
       for(Ticketwrapper w: ticketWrapperlist){
               system.debug(' requester ID +eventId:'+ w.RequesterId+''+w.eventId);
          
          if(w.requesterId!=null){     
           if(reqToEmailGroup.containsKey(String.valueOf(w.requesterId)+String.valueOf(w.eventId))){
              groupList=reqToEmailGroup.get(String.valueOf(w.requesterId)+String.valueOf(w.eventId));
             
           }else{
              groupList=new list<EmailGrouping> ();
           }
            system.debug('groupList:::'+groupList);
            EmailGrouping grouping=new EmailGrouping();
            grouping=new EmailGrouping();
            grouping.requesterId=w.requesterId;
            grouping.eventName=w.eventName;
            grouping.eventDesc=eventMap.get(w.eventId).Event_Description__c;
            if(grouping.eventDesc==null){
                grouping.eventDesc='';//w.eventName;
            }
          
            grouping.eventLink=URL.getSalesforceBaseUrl().toExternalForm()+ '/'+w.eventId;//eventMap.get(w.eventId).Ticket_event__c.link;
            
            grouping.eventDate=w.eventDate;
            grouping.eventTime=w.eventTime;
            grouping.groupName=w.groupName;
            grouping.unassignedTicket=w.unAssignedNum;
             system.debug('email requester: ');
            grouping.email=reqToEmail.get(w.requesterId);
            system.debug('email requester: '+grouping.email);
            groupList.add(grouping);
            
          //  keyStr=String.valueOf(w.requesterId)+w.eventId;
           reqToEmailGroup.put(String.valueOf(w.requesterId)+String.valueOf(w.eventId), groupList);
           system.debug(' reqto Email Group: '+String.valueOf(w.requesterId)+String.valueOf(w.eventId));
           reqToName.put(w.requesterId, w.requesterName);
          }
      }
       
       
      
     }catch(Exception e){
        system.debug('Exception from atchFindUnassignedTicket.execute: '+e);
        CreateExceptionLog.insertErrorLog(e, null, null, null, 'Batchable Apex Class', 'Ticket', null, 'BatchFindUnassignedTicket.execute()','High');
        
     }
       
   }
   
   global void finish(Database.BatchableContext ctx) {
       String emailbody='';
       
       String subject='';
       String body='';
       try{
      List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
      
       for(String key: reqToEmailGroup.keySet()){
        //  String firstLine='Hi '+emailToName.get(email)+'\r\n You have following unassigned Ticket(s): \r\n\r\n';
        system.debug('email: '+key);
          integer ct=0;
          body='';
          subject='';
          String email=null;
          String link=null;
          
         
          
          for(EmailGrouping eg:reqToEmailGroup.get(key)){
            email=eg.email;
            link=eg.eventLink;
            system.debug('email address:::::: '+email);
            if(ct==0){
             
             Date myDate=null;
             String dateStr='';
             if(eg.eventDate!=null){
              //  myDate=Date.newInstance(eg.eventDate.Year(),eg.eventDate.Month(), eg.eventDate.day());
                   dateStr=String.valueofGmt(eg.eventDate);
                   dateStr=dateStr.subString(0,10);//cut off the time part
               }
             
             Subject=eg.eventName+': '+eg.eventDesc+' '+dateStr;//eg.eventDate;
             
             body='There are unassigned tickets  for the following event:\r\n\n Event Name:'+ eg.eventName+'\r\n'+' Event Date:'+dateStr+'\r\n\n'
                    +'It is within 5 days of the event, please assign the following tickets to avoid any unused tickets.\r\n\n';
            }
             body=body+'Ticket Grouping for Ticket: '+eg.groupName+'\r\n'+' # of unassigned Ticket: '+eg.unAssignedTicket+'\r\n\n';
             ct++;
          }
          body=body+'\r\n Link to Event: \r\n'+link;
          
         // body=firstLine+emailToTicketNumMap.get(email);
         if(email!=null ||email!=''){
         // Utility.sendEmails(email, subject,body);
          listMail.add(getEmail(email,subject,body));
         }
       }
       
       if(!listMail.isEmpty()){
          Messaging.sendEmail(listMail);
       }
       }catch(exception e){
         system.debug('send email exception: '+e);
           CreateExceptionLog.insertErrorLog(e, null, null, null, 'Batchable Apex Class', 'Ticket', null, 'finish send email','High');
       }
   }
   
   public class EmailGrouping{
    
    String email{get;set;}
    String eventName{get;set;}
    String eventDesc{get;set;}
    String eventTime{get;set;}
    Date  eventDate{get;set;}
    String groupName{get;set;}
    String eventLink{get;set;}
    Id requesterId{get;set;}
    integer unAssignedTicket {get;set;}
    
   }
   public class TicketWrapper{
    
       String groupName {get;set;}
       Id groupId{get;set;}
       Id requesterId{get;set;}
       String eventDesc{get;set;}
       String requesterName{get;set;}
       Integer unAssignedNum{get;set;}
       String emailAddress {get;set;}
       String eventName{get;set;}
       Id eventId{get;set;}
       String eventTime{get;set;}
       Date eventDate{get;set;}
       
      public TicketWrapper(String grouping, Id requester, Integer num){
        this.groupName=grouping;
        this.requesterId=requester;
        this.unAssignedNum=num;
      }
      
      public TicketWrapper(){
        
      }
      
   }
   
  
   private Messaging.SingleEmailMessage getEmail(String toAddress, String subject, String body){
    
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        toAddresses.add(toAddress);
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
       return mail;      
   }
}