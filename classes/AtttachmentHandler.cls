/**************************************************************************************
  Apex Class Name     : AtttachmentHandler
  Version             : 1.0
  Function            : This is a handler class for AtttachmentHandler. The methods in this class are used as utility methods for AtttachmentHandler
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Mayuri Bhadane           05/15/2015                Original Version
* Phani Kommareddy		   05/16/2018				 SFDC-6974 GEMS: ID Cards - Allow Prospective IDs to be attached to Prospective ID Card Form
*************************************************************************************/
public with sharing class AtttachmentHandler{ 

       /******************************************************************** 
    * Method Name    : UpdateIntegrationActionObject
    *   @description : Insert record in integration status if cbsr case is updated
    *   @parameters  : List<Attachment> AttachmentList
    *   @return type : void                    
    ***************************************************************/
        public static void UpdateIntegrationActionObject(List<Attachment> AttachmentList ){
               
       Map<id,Attachment>          caseCommentMap        = new Map<id,Attachment>();
       List<Integration_Status__c>  IntegrationStatusList = new List<Integration_Status__c>();
       Set<id>                      caseIds               = new Set<id>();
       Map<id,case>                 caseMap               = new Map<id,case>(); 
       Integration_Status__c       newIntegrationStatus ;  
       try{
           for(Attachment newatt : AttachmentList ){             
              if(newatt.parentid.getSobjectType().getDescribe().getName()=='Case')
                caseIds.add(newatt.parentid);
           }
         if(caseIds.size()>0){  
           caseMap =  GetCBSRCaseRecord(caseIds);   
           
               if(caseMap.size()>0){
                   for(Attachment att: AttachmentList ){
                       if(caseMap.containskey(att.parentid)){
                         newIntegrationStatus = new Integration_Status__c();
                         newIntegrationStatus.ObjectID__c             =   att.id;
                         newIntegrationStatus.ObjectType__c           =   'Attachment';
                         if(caseMap.containsKey(att.parentid)) {
                             newIntegrationStatus.Parent_External_ID__c   =   caseMap.get(att.parentid).External_Id__c;
                         }
                         newIntegrationStatus.Parent_Object_ID__c     =   att.parentid;
                         newIntegrationStatus.Integration_Action__c   =   'Insert'; 
                         newIntegrationStatus.Integration_Status__c   =   'Sent';
                         newIntegrationStatus.Time_Sent__c   =   system.Now();
                         //newIntegrationStatus.Created_By_Lan_ID__c    =    caseMap.get(att.parentid).createdby.Lan_Id__c;
                         //newIntegrationStatus.Last_Modifed_Lan_ID__c    =    caseMap.get(att.parentid).lastmodifiedby.Lan_Id__c;  
                         IntegrationStatusList.add(newIntegrationStatus);
                       }  
                   }  
               } 
          }  
           if(IntegrationStatusList.size()>0){
               List<Database.SaveResult> sr = Database.Insert(IntegrationStatusList,false);   
           }    
       }catch(Exception ex){
           system.debug(ex);
           CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Attachment', 'AtttachmentTrigger', 'AtttachmentHandler.UpdateIntegrationActionObject()','High'); 
       }
    }  
 
  /******************************************************************** 
    * Method Name    : DeleteIntegrationActionObject
    *   @description : Insert record in integration status if attachment is deleted
    *   @parameters  : List<Attachment> AttachmentList
    *   @return type : void                    
    ***************************************************************/
    public static void DeleteIntegrationActionObject(List<Attachment> AttachmentList ){
        Set<id> attachIds = new Set<id>();
        try{
            List<Integration_Status__c> intUpdateList = new List<Integration_Status__c>();
            //Integration_Status__c intStatus;
            //Integration_Status__c intStatus;
            
               for(Attachment oldatt : AttachmentList ){             
                    attachIds.add(oldatt.id);
               }
            
            for(Integration_Status__c intStatus : [Select ID, ObjectID__c, Integration_Action__c from Integration_Status__c where ObjectID__c in :attachIds])
            {
                intStatus.Integration_Action__c='Delete';
                intStatus.Integration_Status__c   =   'Sent';
                intStatus.Time_Sent__c   =   system.Now();
                intUpdateList.add(intStatus);
            }
         if(intUpdateList.size()>0)   
            Update intUpdateList;   
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Attachment', 'AtttachmentTrigger', 'AtttachmentHandler.DeleteIntegrationActionObject()','High'); 
        }     
    }    
    
  /******************************************************************** 
    * Method Name    : GetCBSRcaseRecord
    *   @description : This method colects CBSR case records in map.
    *   @parameters  : set<ids> caseIds
    *   @return type : Map<id,Case>                     
    ***************************************************************/
    public static Map<id,Case> GetCBSRCaseRecord(set<id> caseIds ){ 
         Map<id,case> caseIdRecMap = new Map<id,case>();
         try{  
            for(Case caserec: [select id,External_Id__c,recordtypeid,recordtype.name,status , createdby.Lan_Id__c, lastmodifiedby.Lan_Id__c from case where id in : caseIds and recordtype.name = :system.label.CBSR_Issue  Limit :Limits.getLimitQueryRows() - Limits.getQueryRows()]){
                if(caserec.recordtype.name==system.label.CBSR_Issue){
                   caseIdRecMap.put(caserec.id,caserec);
                }
            
            }
         }catch(Exception ex){
             CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Attachment', 'AtttachmentTrigger', 'AtttachmentHandler.GetCBSRCaseRecord()','High'); 
         } 
       return caseIdRecMap;       
    }  
    
     /******************************************************************** 
    * Method Name    : validateCBSRStatusforAttachment
    *   @description : This method validates CBSR case status.only non draft cbsr cases can have attachment
    *   @parameters  : List<Attachment> AttachmentList
    *   @return type : void                    
    ***************************************************************/
    public static void validateCBSRStatusforAttachment(List<Attachment> AttachmentList){
       Set<id>                      caseIds               = new Set<id>();
       Map<id,case>                 caseMap; 
        try{
           for(Attachment newatt : AttachmentList ){   
              if(newatt.parentid.getSobjectType().getDescribe().getName()=='Case')          
                 caseIds.add(newatt.parentid);
           }
           caseMap =  GetCBSRCaseRecord(caseIds);   
           
           if(caseMap!=null && caseMap.size()>0){
               for(Attachment att: AttachmentList ){  
                    if(caseMap.containskey(att.parentid) && caseMap.get(att.parentid).status=='Draft' ){
                        att.addError('Can not insert Attachments on CBSR Issue when the Case is in Draft Status.');
                    }
               }
           }
        }catch(exception e){
        
        }
    }
    
    public static void validationForMIMETypes(list<Attachment> newList){
        Map<String,Allowed_MIME_Types__c> mapUSerPass  = Allowed_MIME_Types__c.getAll();
        //set<String> allowedMIMETypes = new set<String>();
        Set<String> allowedExtensions = new Set<String>();
        try{
            for(String cs : mapUSerPass.keyset()){
                //allowedMIMETypes.add(mapUSerPass.get(cs).MIME_Type__c);
                allowedExtensions.add(mapUSerPass.get(cs).Name.toUpperCase());
            }
            
            set<String> CBSRRenewalIds = new Set<String>();
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(system.label.CBSR_Issue).getRecordTypeId();
            for(Attachment att : [select Id,Parent.RecordTypeId,BodyLength from Attachment where Id In :newList]){
                if(att.Parent.RecordTypeId == recordTypeId)
                    CBSRRenewalIds.add(att.Id);
            }
            String FileExtension;
            Integer attSizeLimit = Integer.valueof(system.label.Allowed_Attachment_Size_in_MB) * 1048576;
            for(Attachment att : newList){
                if(CBSRRenewalIds.contains(att.Id) ){
                    FileExtension = att.Name.substring(att.Name.lastIndexOf('.') + 1, att.Name.length());
                    if(!allowedExtensions.contains(FileExtension.toUpperCase())   ){ //att.ContentType == null || !allowedMIMETypes.contains(att.ContentType.toLowerCase())
                        att.addError(system.label.MIME_type_not_allowed);
                    }
                    if(att.BodyLength > attSizeLimit){
                        att.addError('Maximum Allowed attachment size is '+system.label.Allowed_Attachment_Size_in_MB +' MB');
                    }
                }
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Attachment', 'AtttachmentTrigger', 'AtttachmentHandler.validationForMIMETypes()','High'); 
        }
    }
    
    
/**
** This method is utility to update the Quote_Request_Summary__c note_count field by 1 when attachment or note is added to the Quote Request record.
** Call by AttachmentTrigger
**/
/*
  public static void updateQuoteRequestAttachmentCounter(list<Attachment> newList){
    
    set<Id> quoteReqIds=new set<id>();
    Map<id,Quote_Request_Summary__c> reqNoteMap=new Map<id,Quote_Request_Summary__c>();
    
 
    try{
         
      for(Attachment newAtt:newList){
        
          if(newAtt.ParentId.getSobjectType() == Quote_Request_Summary__c.SobjectType){
                 quoteReqIds.add(newatt.parentid);
                
               Quote_Request_Summary__c  noteData=new Quote_Request_Summary__c();
                  noteData.Note_Attachment_Created_By__c=newAtt.ownerId;
                  noteData.Last_Note_Attachment_Modify_By__c=UserInfo.getUserId();
                  noteData.Late_Note_Attachment_Title__c=newAtt.name;
                 
                   quoteReqIds.add(newAtt.parentid);
                  
                  reqNoteMap.put(newAtt.parentId, noteData);   
            }
      }
      
       updateQuoteRequestCounter(reqNoteMap);
    
        
    }catch(Exception e){
        system.debug('updateQuoteRequestNoteAttachmentCounter exception: '+e);
    }
  }
  */
/**
** This method is utility to update the Quote_Request_Summary__c note_count field by 1 when note is added to the Quote Request record.
** Call by NoteTrigger
**/
/*
 public static void updateQuoteRequestNoteCounter(list<Note> newList){
    
    set<Id> quoteReqIds=new set<id>();
    list<Quote_Request_Summary__c>  noteDataList=new list<Quote_Request_Summary__c>();
    Map<id,Quote_Request_Summary__c> reqNoteMap=new Map<id,Quote_Request_Summary__c>();
    
    try{
        
      for(Note nt:newList){
        
          if(nt.ParentId.getSobjectType() == Quote_Request_Summary__c.SobjectType){
            
                  Quote_Request_Summary__c  noteData=new Quote_Request_Summary__c();
                  noteData.Note_Attachment_Created_By__c=nt.ownerId;
                  noteData.Last_Note_Attachment_Modify_By__c=UserInfo.getUserId();
                  noteData.Late_Note_Attachment_Title__c=nt.title;
                  quoteReqIds.add(nt.parentid);
                  reqNoteMap.put(nt.parentId, noteData);     
            }
      }
      
      updateQuoteRequestCounter(reqNoteMap);
        
        
    }catch(DMLException e){
        system.debug('update quote request note counter exception: '+e);
    }
  }
  
 private static void  updateQuoteRequestCounter(Map<id, Quote_Request_Summary__c> quoteReqMap){
    
    try{
        
        list<Quote_Request_Summary__c> reqList=[select id, Note_Count__c from Quote_Request_Summary__c where id in : quoteReqMap.keySet()];
           
       if(reqList!=null && !reqList.isEmpty()){
             for(Quote_Request_Summary__c req: reqList){
                req.Note_Count__c=req.Note_Count__c+1;
                Quote_Request_Summary__c temp=quoteReqMap.get(req.id);
                req.Note_Attachment_Created_By__c=temp.Note_Attachment_Created_By__c;
                req.Last_Note_Attachment_Modify_By__c=temp.Last_Note_Attachment_Modify_By__c;
                req.Late_Note_Attachment_Title__c=temp.Late_Note_Attachment_Title__c;
                
             }
             update reqlist;
       }
    
    }catch(DMLException e){
        system.debug('update qutoe request note counter exception:'+e);
    }
 }*/
 
   /*******************************************************************************************************************************
    * Method Name  : updateProspectiveIDAttachmentCounts
	* @description : SFDC-6974 This Method processes attachments for the prospective id card and update attachment field on its releated list
	* @parameters  : list<id> triggeredparentIdList
	* @return type : void                    
    *******************************************************************************************************************************/
    public static void updateProspectiveIDAttachmentFlag(list<id> triggeredparentIdList) {
        Set<GEMS_Prospective_ID_Card__C> updatePIDSet = new Set<GEMS_Prospective_ID_Card__C>();
        
        List<GEMS_Prospective_ID_Card__C> pIdCardList = [SELECT id,(select id from attachments) from GEMS_Prospective_ID_Card__C where id in : triggeredparentIdList];
        
        for(GEMS_Prospective_ID_Card__C pidCard : pIdCardList) {
            List<Attachment> pidCardAttList = pidCard.Attachments;
            if(pidCardAttList != null && !pidCardAttList.isEmpty()) {
                pidCard.Attachment__c = 'Yes';
            } else {
                pidCard.Attachment__c = 'No';
            }
            updatePIDSet.add(pidCard);
        }
        
        List<GEMS_Prospective_ID_Card__C> finalList = new List<GEMS_Prospective_ID_Card__C>();
        finalList.addAll(updatePIDSet);
        update finalList;
    }
    
    
    
}