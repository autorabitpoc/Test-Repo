public class GEMS_UploadAttachmentController {
    @TestVisible public transient String description {get;set;}
     @TestVisible public transient  String selectedType {get;set;}
    @TestVisible public transient String BAInfo {get; set;}
    @TestVisible public Case case1 {get;set;}
    public String filename {get;set;}
     @TestVisible public transient  String selectedLevel {get;set;}
    @TestVisible public transient Blob fileBody {get;set;}
    @TestVisible public transient List<GEMS_Attachment__c> gemsAttachmentList {set;get;}
    public Boolean filebool {get;set;}
    public string getInfo{get;set;}
    public Boolean typebool{get;set;}
    
    public List<WrapperClass> listWrapper {get;set;}
    public Boolean allBool {get;set;}
    
    public GEMS_UploadAttachmentController (ApexPages.StandardController Controller) {
        try{
            this.case1 = (Case)controller.getRecord();
            typebool = false;
            filebool = false;
            gemsAttachmentList =[select name,description__c,type__c,CreatedBy.name,View__c,Attachment__c, level__c, BA_Info__c  from GEMS_Attachment__c where case__c = :case1.id order by createddate desc];
            listWrapper = new List<WrapperClass>();
            if(gemsAttachmentList.size() > 0) {
                for(GEMS_Attachment__c gemAtt: gemsAttachmentList) {
                    listWrapper.add(new WrapperClass(gemAtt));
                }
            }
        }
        catch(Exception ex) {
            System.debug('====Exception==============='+ex.getMessage());
        }
    }
    
    //creates a new case_attachment__c record
    
    @testVisible private Database.SaveResult saveCustomAttachment(){
        GEMS_Attachment__c obj = new GEMS_Attachment__c();
        Database.SaveResult saveResult;
        try {
            obj.case__c = case1.id;
            obj.description__c = description;
            obj.type__c = selectedType;
            obj.level__c=selectedLevel;
            obj.ba_info__c=bainfo;
            saveResult = Database.insert(obj);
        }
        catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null,'Apex Class', 'Case', null, 'GEMS_UploadAttachmentController.saveCustomAttachment()','High'); 
            return null;
        }
        return saveResult;
    }
    
          public List<SelectOption> getLevelOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult LevelResult = GEMS_Attachment__c.Level__c.getDescribe();
        List<Schema.PicklistEntry> Ty = LevelResult.getPicklistValues();
        for( Schema.PicklistEntry f : Ty)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    public List<SelectOption> getTypeOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult TypeResult = GEMS_Attachment__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> Ty = TypeResult.getPicklistValues();
        for( Schema.PicklistEntry f : Ty)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    
    //create an actual Attachment record with the case_attachment__c as parent
    
    @testVisible Private Database.SaveResult saveStandardAttachment(Id parentId) {
        Database.SaveResult result;
        try {
        Attachment attachment = new Attachment();
        attachment.body = this.fileBody;
        attachment.name = this.fileName;
        attachment.parentid = parentid;
        result = Database.insert(attachment);
        }
        catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex,null, null, null,'Apex Class', 'Case', null, 'GEMS_UploadAttachmentController.saveStandardAttachment(Id parentId)','High'); 
            return null;
        }
        //set the file for the view state
        fileBody = Blob.valueof('');
        return result;
    }
    
    
    
    //Upload process is:
    // Insert new Contact_Attachment__c record
    // Insert new attachment with the new Contact_Attachment__c record as parent
    // Updates the Contact_attachment__c record with the ID of the new attahcment
    
    Public PageReference processUpload(){
        
        Boolean docTypeCheck =false; if(selectedType != null && selectedType =='--None--') docTypeCheck =true; System.debug('====selectedType  ==='+selectedType+docTypeCheck  );

       System.debug('fileBody======>'+fileBody);
        System.debug('fileName ======>'+fileName );
        if (docTypeCheck){
            //if(docTypeCheck)
            typebool=true;
            filebool=false;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No DocType Chosen'));
            fileName = fileName;                      
            //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            //pageRef.setRedirect(true);
            return null;
        }else if (fileName == Null && fileBody == Null){
            filebool=true;
            System.debug('Testing in else if');
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No file chosen to be uploaded'));
            return null;
          }

           
        
        else{
            try {
            System.debug('Testing in  if');
                Database.SaveResult customAttachmentResult = saveCustomAttachment();
                if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not save attachment'));
                    return null;
                }
                
                Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());
                if (attachmentResult == null || !attachmentResult.isSuccess()) {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not save attachment'));
                    return null;
                }
                else {
                    //update the custom attachment record with some attachment info
                    GEMS_Attachment__c customAttachment = [select id from GEMS_Attachment__c where id = :customAttachmentresult.getId()];
                    customAttachment.name = this.filename;
                    customAttachment.Attachment__c = attachmentResult.getId();
                    update customAttachment;
                }
                
                gemsAttachmentList =[select name,description__c,type__c,Level__c ,ba_info__c,CreatedBy.name,Attachment__c  from GEMS_Attachment__c where case__c = :case1.id order by createddate desc];
                listWrapper.Clear();
                if(gemsAttachmentList.size() > 0) {
                    for(GEMS_Attachment__c gemAtt: gemsAttachmentList) {
                        listWrapper.add(new WrapperClass(gemAtt));
                    }
                }
                description ='';
                selectedType ='--None--';
                selectedLevel = 'Account Submission';
                bainfo = '';
                 return null;
            }
            
            catch(Exception ex){
                ApexPages.AddMessages(ex);
                GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_UploadAttachmentController.saveStandardAttachment(Id parentId)','High'); 
                return null;
            } 
            
             
            return new PageReference('/apex/GEMSUploadAttachment1?id='+case1.id);
        }
    }
    
    
    Public PageReference back(){
        return new PageReference ('/'+case1.id);
    }
    public Integer getPageNumber()
    {
        return  1;
    }
    
    public Integer getTotalPages()
    {
        
        return 1;
        
    }
    public class WrapperClass {
        public Boolean checked {get;set;}
        public GEMS_Attachment__c gemAtt{get;set;}
        public WrapperClass(GEMS_Attachment__c gemAtt) {
            this.gemAtt= gemAtt;
        }
    }
    public void del() {
        List<GEMS_Attachment__c > listAttForDel = new List<GEMS_Attachment__c >();
        List<WrapperClass> listTempWrapper = new List<WrapperClass>();
        for(WrapperClass w : listWrapper) {
            if(w.checked) {
                listAttForDel.add(w.gemAtt);
            } else {
                listTempWrapper.add(w);
            }
        }
        if(listAttForDel.size() > 0) {
            delete listAttForDel;
            listWrapper = listTempWrapper;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one record to delete'));
        }
    }
    public void selectAll() {
        if(allBool) {
            for(WrapperClass w : listWrapper) {
                w.checked = true;
            }
        } else {
            for(WrapperClass w : listWrapper) {
                w.checked = false;
            }
        }
    }
    public void test()
    {
        
    }
}