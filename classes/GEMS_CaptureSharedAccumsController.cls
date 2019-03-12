/**************************************************************************************
* Apex Class Name       : GEMS_CaptureSharedAccumsController
* Version               : 1.0
* Function              : This Class is for GEMS shared accums
* Modification Log      :
* Developer           Date                   Description
* ------------------------------------------------------------------------------------
* CAP             06/10/2016             Original Version
* Ranjit Gandhi   07/26/2017             SFDC-2074 Change how BAs are associated to Shared accums
* Phani K         01/22/2018             SFDC-7906 GEMS: Shared Accums - One field removed and additional fields needed on the Shared Accums Form and Grid output
* Malathi.K       02/05/2018             SFDC-8118 Add Group Number.
* Phani K         02/26/2018             SFDC-4244 GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
* Gokul Bharati   03/02/2018             SFDC-8322 GEMS: Shared Accums - Ability to Clone Existing Shared Accums Form
*************************************************************************************/

public with sharing class GEMS_CaptureSharedAccumsController {
    
    public ID caseId{get;set;}
    public Id accumRecId{get;set;}
    public case caseRec {set;get;}   
    public GEMS_Shared_Accums__c sharedAccumRecord {get;set;}
    public GEMS_SA_BA_Association__c sharedAccumBARec ;
    public Set<String> setbacasenum=new Set<string>();
    public List<String> baCaseNums1=new List<string>();    
    //Ranjit   SFDC-2074 Change how BAs are associated to Shared accums
    public List<GEMS_BAIdWrapper> listOfBARecords{get; set;}
    public List<Case> structureBAs{get;set;}
    //SFDC-8118 
    public List<Case> structbaGSs{get;set;} 
    public String baCaseNums{set;get;}    
    public boolean Addsuccess{get;set;} 
    //SFDC-8322
    public Id cloneId{get;set;}
    //SFDC-8322
    public GEMS_CaptureSharedAccumsController(ApexPages.StandardController controller) {
        caseID = apexpages.currentpage().getparameters().get('caseid');
        if(apexpages.currentpage().getparameters().get('baCaseNums')!=null)
            baCaseNums1 = (apexpages.currentpage().getparameters().get('baCaseNums')).split('\\,');
        setbacasenum.addAll(baCaseNums1);        
        accumRecId = apexpages.currentpage().getparameters().get('Id');
        system.debug('******** baCaseNums1'+baCaseNums1);
        sharedAccumRecord = new GEMS_Shared_Accums__c();
        system.debug('******** 1'+sharedAccumRecord);
        if(accumRecId != null) {
            //SFDC-7906 GEMS: Shared Accums - One field removed and additional fields needed on the Shared Accums Form and Grid output
            //Added new fields to extract
            sharedAccumRecord = [SELECT id, Name,GEMS_Case__c, Benefit_Agreement__c, Accum_Period__c, Shared_Accums_Effective_Date__c, HCSC_responsible_for_Vendor_Eligibility__c,
                                 Deductible__c,Aggregate_or_Embedded_Deductible__c,Individual_Deductible_Amount__c,Deductible_Middle_Tier_s_if_Applicable__c,
                                 Family_Deductible_Amount__c,Does_Deductible_apply_to_Out_of_Pocket__c,Does_Copay_apply_to_Out_of_Pocket__c,
                                 Out_of_Pocket__c,Aggregate_or_Embedded_Out_of_Pocket__c,Individual_Out_of_Pocket_Amount__c,
                                 Out_of_Pocket_Middle_Tier_if_Applicable__c,Family_Out_of_Pocket_Amount__c,Lifetime_Maximum__c,Amount__c,
                                 Accums_Shared_With__c,Accums_Feeding_feaking__c,Shared_Accum_ID__c,Applicable_BAs__c,
                                 Shared_Accum_with_Vendor_Using__c,Number_of_Accum_Tiers__c,In_Ntk_Ded_Feeds_Out_Of_Ntk__c,Out_of_Network_Deductible_Feeds_In_Ntk__c,
                                 In_Network_OOP_Feeds_Out_of_Network__c,Out_of_Network_OOP_Feeds_In_Network__c 
                                 FROM GEMS_Shared_Accums__c WHERE Id=:accumRecId];
            
        }
        if(caseID != null) {
            caseRec = [SELECT id, Account.Name, Account.External_ID__c, GEMS_Case_Effective_Date__c, HCSC_Division__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                       FSU_Location__c, Market_Segment__c, GEMS_Medical_Underwriter__c, Account_Executive__c, Sales_Executive__c,
                       CaseNumber, GEMS_View_Product__c, Owner.Name, Subject, Status, GEMS_Account_Submission_Info__c, GEMS_Type__c FROM case WHERE id =:caseID];
            //sharedAccumRecord.GEMS_Case__c=caseID;
        }
        else
        {
            caseRec = [SELECT id, Account.Name, Account.External_ID__c, GEMS_Case_Effective_Date__c, HCSC_Division__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                       FSU_Location__c, Market_Segment__c, GEMS_Medical_Underwriter__c, Account_Executive__c, Sales_Executive__c,
                       CaseNumber, GEMS_View_Product__c, Owner.Name, Subject, Status, GEMS_Account_Submission_Info__c, GEMS_Type__c FROM case WHERE id =:sharedAccumRecord.GEMS_Case__c];
            caseID=sharedAccumRecord.GEMS_Case__c;    
        } 
        
        //Ranjit    SFDC-2074 Query to retreive BA's
        Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        
        //  SFDC-8118 Get group numbers for the BA's.
        
        //SFDC-4244 - Added GEMS_BAs_SpHandling__c condition        
        structbaGSs = [SELECT id, (SELECT ID, Name, BA_Description__c, BA_Fund_Type__c, product__r.Name from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true and IsCancelled__c = false order by Name),(SELECT ID, benefit_agreement__r.ID,benefit_agreement__r.name, benefit_agreement__r.BA_Description__c, benefit_agreement__r.BA_Fund_Type__c, benefit_agreement__r.product__r.Name, group_section__r.Group_No__c from BA_Assignments__r where benefit_agreement__r.GEMS_BAs_SpHandling__c = true and benefit_agreement__r.IsCancelled__c = false order by benefit_agreement__r.name) 
                       FROM Case WHERE RecordTypeId= :caseAccountStructureRecordTypeId AND GEMS_Account_Submission_Info__c =:caseid  LIMIT 1];                                             
        
        listOfBARecords = new List<GEMS_BAIdWrapper>();
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        List<GEMS_BA_Assignment__c> gsList ;
        
        if(!structbaGSs.isEmpty()) {  
            Case baCase = structbaGSs.get(0);
            baList = baCase.GEMS_Benefit_Agreements__r;
            gsList = baCase.BA_Assignments__r;             
        }
        
        if(!baList.isEmpty()){                                                                
            Map<Id,Map<GEMS_Benefit_Agreement__c,String>> baGnoMap = new Map<Id,Map<GEMS_Benefit_Agreement__c,String>>();
            Map<GEMS_Benefit_Agreement__c,String> baMap;             
            GEMS_Benefit_Agreement__c ba;                
            String grpNo;
            
            if(!gsList.isEmpty()) 
            {                     
                for(GEMS_BA_Assignment__c gs: gsList) {
                    if (!baGnoMap.containsKey(gs.Benefit_Agreement__r.Id))
                    {
                        ba = new GEMS_Benefit_Agreement__c();
                        ba.Name = gs.Benefit_Agreement__r.Name;
                        ba.Id = gs.Benefit_Agreement__r.Id;
                        ba.BA_Description__c = gs.benefit_agreement__r.BA_Description__c;
                        ba.BA_Fund_Type__c = gs.benefit_agreement__r.BA_Fund_Type__c;                         
                        ba.product__r = new Product2();
                        ba.product__r.Name = gs.benefit_agreement__r.product__r.Name;                        
                        baMap = new Map<GEMS_Benefit_Agreement__c,String>();
                        baMap.put(ba, gs.Group_Section__r.Group_No__c);
                        baGnoMap.put(gs.Benefit_Agreement__r.Id,baMap);
                        
                    }
                    else
                    {
                        
                        baMap  = baGnoMap.get(gs.Benefit_Agreement__r.Id);
                        for(GEMS_Benefit_Agreement__c key :baMap.keySet()){
                            grpNo  = baMap.get(key);
                            if (!grpNo.Contains(gs.Group_Section__r.Group_No__c)) 
                            {
                                grpNo = grpNo + ',' + gs.Group_Section__r.Group_No__c;
                                baMap.put(key, grpNo);
                                baGnoMap.put(gs.Benefit_Agreement__r.Id,baMap);
                            }
                            break;
                        }
                    }
                }            
            }
            
            for(GEMS_Benefit_Agreement__c baAddl: baList) {
                if (!baGnoMap.containsKey(baAddl.Id))
                {
                    ba = new GEMS_Benefit_Agreement__c();
                    ba.Name = baAddl.Name;
                    ba.Id = baAddl.Id;
                    ba.BA_Description__c = baAddl.BA_Description__c;
                    ba.BA_Fund_Type__c = baAddl.BA_Fund_Type__c;                         
                    ba.product__r = new Product2();
                    ba.product__r.Name = baAddl.product__r.Name;                        
                    baMap = new Map<GEMS_Benefit_Agreement__c,String>();
                    baMap.put(ba, '');                        
                    baGnoMap.put(baAddl.Id,baMap);
                    
                }                     
            }
            
            for(Id key :baGnoMap.keySet())
            {
                baMap = baGnoMap.get(key);
                for(GEMS_Benefit_Agreement__c baKey :baMap.keySet())
                {
                    grpNo  = baMap.get(baKey);
                    listOfBARecords.add(new GEMS_BAIdWrapper(false, baKey, grpNo));
                    break;
                }
            }   
        }
        //SFDC-8118 End changes
    }
    
    Public PageReference back() {
        return new PageReference ('/'+caseID);      
    }
    
    public pagereference Save1() {
        boolean isError = false;
        integer count =0;
        string Datevalue;        
        System.debug('**************************baCaseNums'+baCaseNums);        
        try {
            //Ranjit  SFDC-2074 lookup field will be removed from Page layout- to enable multi-select of BA's
            if (sharedAccumRecord.Accum_Period__c != null ) 
            {count++; }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Accum Period can not be blank.');
                ApexPages.addMessage(myMsg);
                isError = true;     
            }
            if (sharedAccumRecord.Shared_Accums_Effective_Date__c != null ) 
            {count++; }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Shared Accum Effective Date can not be blank.');
                ApexPages.addMessage(myMsg);
                isError = true;       
            }   
            if (sharedAccumRecord.HCSC_responsible_for_Vendor_Eligibility__c != null ) 
            {count++; }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'HCSC responsible for Vendor Eligibility can not be blank.');
                ApexPages.addMessage(myMsg);
                isError = true;       
            }
            
            If (sharedAccumRecord.Deductible__c == true)
            {
                if (sharedAccumRecord.Aggregate_or_Embedded_Deductible__c != null )           
                { count++;}
                else
                { 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Aggregate or Embedded Deductible.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Deductible__c == true)
            {
                if (sharedAccumRecord.Individual_Deductible_Amount__c != null )           
                { count++;}
                else
                { 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter a numeric value, or 0 for Individual Deductible Amount.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Deductible__c == true)
            {
                if (sharedAccumRecord.Deductible_Middle_Tier_s_if_Applicable__c != null )           
                { count++;}
                else
                { 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter a numeric value, ‘0’, or ‘N/A’ for Deductible Middle Tier (s) if Applicable.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Deductible__c == true)
            {
                if (sharedAccumRecord.Family_Deductible_Amount__c != null )           
                { count++;}
                else
                { 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter a numeric value, or 0 for Family Deductible Amount.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Out_of_Pocket__c == true)
            {
                if (sharedAccumRecord.Aggregate_or_Embedded_Out_of_Pocket__c != null ) 
                {count++;}
                else
                {  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Aggregate or Embedded Out of Pocket.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Out_of_Pocket__c == true)
            {
                if (sharedAccumRecord.Individual_Out_of_Pocket_Amount__c != null ) 
                {count++;}
                else
                {  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter a numeric value, or 0 for Individual Out of Pocket Amount.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Out_of_Pocket__c == true)
            {
                if (sharedAccumRecord.Out_of_Pocket_Middle_Tier_if_Applicable__c != null ) 
                {count++;}
                else
                {  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter a numeric value, ‘0’, or ‘N/A’ for Out of Pocket Middle Tier if Applicable.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            If (sharedAccumRecord.Out_of_Pocket__c == true)
            {
                if (sharedAccumRecord.Family_Out_of_Pocket_Amount__c != null ) 
                {count++;}
                else
                {  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter a numeric value, or 0 for Family Out of Pocket Amount.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }        
            
            If (sharedAccumRecord.Out_of_Pocket__c == true)
            {
                if (sharedAccumRecord.Does_Deductible_apply_to_Out_of_Pocket__c != null ) 
                {count++;}
                else
                {  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Does Deductible apply to Out of Pocket.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }         
            If (sharedAccumRecord.Out_of_Pocket__c == true)
            {
                if (sharedAccumRecord.Does_Copay_apply_to_Out_of_Pocket__c != null ) 
                {count++;}
                else
                {  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Does Copay apply to Out of Pocket.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }       
            
            If (sharedAccumRecord.Lifetime_Maximum__c == true)
            {
                if (sharedAccumRecord.Amount__c != null)
                {count++;}
                else
                {   
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Lifetime Maximum is selected, please enter a numeric value, or 0.');
                    ApexPages.addMessage(myMsg);
                    isError = true;               
                }
            }
            
            if (sharedAccumRecord.Accums_Shared_With__c != null ) 
            {count++; }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Accums shared With can not be blank.');
                ApexPages.addMessage(myMsg);
                isError = true;       
            }
            
            //SFDC-7906 GEMS: Shared Accums - One field removed and additional fields needed on the Shared Accums Form and Grid output
            if (sharedAccumRecord.Shared_Accum_ID__c != null ) 
            {count++; }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Shared Accum ID can not be blank.');
                ApexPages.addMessage(myMsg);
                isError = true;       
            }
            
            if (sharedAccumRecord.Shared_Accum_with_Vendor_Using__c != null) 
            {count++; }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Shared Accum with Vendor Using can not be blank.');
                ApexPages.addMessage(myMsg);
                isError = true;       
            }
            
            if(!isError ) {  
                if(sharedAccumRecord.GEMS_Case__c == null)
                {                    
                    System.debug('******** sharedAccumRecord.GEMS_Case__c == null---baCaseNums'+baCaseNums);                                                                                                                                                                                       
                    sharedAccumRecord.GEMS_Case__c = caseID;  
                    
                    insert sharedAccumRecord;
                }
                Addsuccess=true;
                //Ranjit- 2704 - Update and upsert- dupes- adding else condition      
                String bacasenumsstring='';
                for(String s:setbacasenum)
                    bacasenumsstring+=(bacasenumsstring==''?'':',')+s;
                
                sharedAccumRecord.Applicable_BAs__c=baCaseNums;                          
                update sharedAccumRecord;
                
                //SFDC-8118 Save Group Numbers in the SA BA Association junction object
                accumRecId = apexpages.currentpage().getparameters().get('Id');
                
                Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
                List<String> baListSel = baCaseNums.split(',');                                            
                
                structbaGSs = [SELECT id, (SELECT ID, Name from GEMS_Benefit_Agreements__r where Name in :baListSel order by Name),(SELECT ID, benefit_agreement__r.name, group_section__r.Group_No__c from BA_Assignments__r where benefit_agreement__r.Name in :baListSel and benefit_agreement__r.IsCancelled__c = false order by benefit_agreement__r.name) 
                               FROM Case WHERE RecordTypeId= :caseAccountStructureRecordTypeId AND GEMS_Account_Submission_Info__c =:caseid LIMIT 1];                                     
                
                List<GEMS_Benefit_Agreement__c> baList;
                List<GEMS_BA_Assignment__c> gsList ;                
                String grpNo ='';
                Boolean inLoop = False;                                
                
                Map<Id,String> baGnoMap = new Map<Id,String>(); 
                List<GEMS_SA_BA_Association__c > saBAExisList ;
                List<GEMS_SA_BA_Association__c > saBARecNewList = new List<GEMS_SA_BA_Association__c>();                        
                
                saBAExisList = [SELECT Id from GEMS_SA_BA_Association__c where Shared_Accums__c = :sharedAccumRecord.Id ];
                if(!saBAExisList.isEmpty()){
                    delete saBAExisList;
                } 
                
                if(!structbaGSs.isEmpty()) {
                    Case baGSCase = structbaGSs.get(0);
                    baList = baGSCase.GEMS_Benefit_Agreements__r; 
                    gsList = baGSCase.BA_Assignments__r;                            
                } 
                system.debug('baListSel---' +baListSel);                                         
                system.debug('gsList ---' +gsList );
                
                Id baID;
                GEMS_SA_BA_Association__c sharedAccumBARec;
                
                if(!baList.isEmpty()){                                                                             
                    if(!gsList.isEmpty()){                                                                             
                        
                        for(GEMS_BA_Assignment__c gs: gsList) {
                            if (!baGnoMap.containsKey(gs.Benefit_Agreement__r.Id))
                            {
                                grpNo = gs.Group_Section__r.Group_No__c;
                                baGnoMap.put(gs.Benefit_Agreement__r.Id,grpNo);   
                            }
                            else
                            {
                                if (!grpNo.Contains(gs.Group_Section__r.Group_No__c)) 
                                {
                                    grpNo = baGnoMap.get(gs.Benefit_Agreement__r.Id);
                                    grpNo = grpNo + ';' + gs.Group_Section__r.Group_No__c;
                                    baGnoMap.put(gs.Benefit_Agreement__r.Id,grpNo);
                                }
                            }
                        }
                    }
                    for(GEMS_Benefit_Agreement__c ba: baList) {
                        if (!baGnoMap.containsKey(ba.Id))
                        {
                            baGnoMap.put(ba.Id,'');
                            
                        }                     
                    }
                    
                    for(Id key :baGnoMap.keySet())
                    {
                        String mapValue = baGnoMap.get(key);
                        sharedAccumBARec = new GEMS_SA_BA_Association__c();
                        sharedAccumBARec.BAGroupNum__c = mapValue ;
                        sharedAccumBARec.Shared_Accums__c = sharedAccumRecord.Id;
                        sharedAccumBARec.Benefit_Agreement__c = key;
                        saBARecNewList.Add(sharedAccumBARec);
                    }                                      
                    insert saBARecNewList;                                                                                                                                                                        
                }                                        
                // SFDC-8118 End changes        
                return null;
            }
            else
            {
                System.debug('******** error');
                isError = false;           
                Addsuccess=false;
                return null;
            }
            
        }
        Catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Shared_Accums__c', null, 'GEMS_CaptureSharedAccumsController','High');     
            return null;
        }     
    }
    public void checked()
    {
        if(sharedAccumRecord.Deductible__c == true)
        {
            sharedAccumRecord.Out_of_Pocket__c = true;
        }
        else
        {
            sharedAccumRecord.Out_of_Pocket__c = false;
        }        
    }
    //SFDC-8322
    public PageReference cloneRecord(){    
        if(sharedAccumRecord != null){
            try{
                GEMS_Shared_Accums__c clonerec = sharedAccumRecord.clone();
                clonerec.Applicable_BAs__c = '';
                insert clonerec;
                cloneId = clonerec.Id;      
            }
            catch(Exception ex){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Failed.Please contact the GEMS Support Team!.');
                ApexPages.addMessage(myMsg); 
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Shared Accums', null, 'GEMS_CaptureSharedAccumsController','High');              
            }            
        }
        return null;
    }
   //SFDC-8322  
}