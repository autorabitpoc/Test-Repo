/**************************************************************************************
* Apex Class Name     : ChildScreeningBatch 
* Version             : 1.0
* Function            : This Batch Class is to create screening cases.
* Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore           09/09/2016             Original Version
* Luke Chen          06/13/2017             SFDC-3875 GEMS: Only generate BA cases for Dental that have dental products (Non-Standard Products)
* Phani Kommareddy   06/15/2017             SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests 
* Shankar            09/08/2017             SFDC-5815 Create Dental screening cases for BA's without Product but with Dental product category in Plan
* Malathi.K          09/08/2017             SFDC-5089 Don't create Dental screening if BA's Category is Dental for Medical/Pharmacy/Medical UW/Additional UW
* Phani K            10/29/2017             SFDC-6747 GEMS - trigger Membership case upon "release"
* Phani K            10/29/2017             SFDC-7233 GEMS: Prod Issue - non-standard products, ID Cards are not always creating > ba limit(8)
* Gokul              11/21/2017             SFDC-5205 GEMS SBC Case - code cleanup/tech debt
* Jenny Dalsania     06/27/2018             SFDC-10234 GEMS - ID Cards - If ID Card Format question is not answered on Submission, route ID Card case to Account Submission case owner  
*************************************************************************************/

global class ChildScreeningBatch implements Database.Batchable<Case>,Database.Stateful{

   global final List<Case> screeningCases;
   global final Case structureCase;
   global final List<GEMS_Benefit_Agreement__c> businessAggrements;
   public List<Case> screeningCasesInsertList;
   global final List<Case> structureCaseList;
   global final Map<Id,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap;
   global ChildScreeningBatch(List<Case> screeningCases, Case structureCase, List<GEMS_Benefit_Agreement__c> benefitAgreementList,List<Case> structureCaseList,Map<Id,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap){
      this.screeningCases = screeningCases;
      this.structureCase = structureCase;
      this.businessAggrements = benefitAgreementList;
      this.structureCaseList = structureCaseList;
      this.subCaseIdBenfAggListMap = subCaseIdBenfAggListMap;
   }

   global Iterable<Case> start(Database.BatchableContext BC){
      return screeningCases;
   }

   global void execute(Database.BatchableContext BC, List<Case> businessAreacases){
     List<Case> screeningCasesInsertListee = new List<Case>();
     Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
     Case caseRecord = structureCase;
     Boolean renewalNochange = false;
     List<GEMS_Process_Metadata__mdt> processMetaData = null;
     String[] submissionSubtype = null;
     if(caseRecord.GEMS_Submission_Sub_Type__c != null ) {
        submissionSubtype = caseRecord.GEMS_Submission_Sub_Type__c.split(';');
     }
    
     if(submissionSubtype != null) {
         processMetaData = GEMS_Utility.retriveCustomMetaDataByProductTypeIndividual(caseRecord.GEMS_Submission_Type__c,Label.GEMS_Custom_Products,submissionSubtype);                   
     }
     List<Case> idCardCasesChildList = null;
     if( processMetaData == null ||(processMetaData != null && processMetaData.size() > 0 && GEMS_Utility.findBusinessAreaInMetaData(caseRecord,processMetaData,'ID Card'))) {
         //SFDC-7233
         idCardCasesChildList = createIdCardParentChildCase(structureCaseList, subCaseIdBenfAggListMap);
     }
     //SFDC-6747 GEMS - trigger Membership case upon "release"
     List<Case> membershipCasesChildList = null;
     if (processMetaData == null || (processMetaData != null && processMetaData.size() > 0 && GEMS_Utility.findBusinessAreaInMetaData(caseRecord, processMetaData, 'Membership'))) {
        membershipCasesChildList = createMembershipCase(structureCaseList, subCaseIdBenfAggListMap.keySet());
     }
     
     /*US-5205
     List<Case> sbcCasesChildList = createSBCParentChildCase(structureCaseList, subCaseIdBenfAggListMap);
     */
     for(Case businessAreacase : businessAreacases){
         if(businessAggrements != null && !businessAggrements.isEmpty()) {
             
             for(GEMS_Benefit_Agreement__c befAgrRec: businessAggrements) {
                 
                 // SFDC-SFDC-3875 don't create dental screening if BA's product category is not dental
                 // SFDC-5815. Modified condition check to look for dental product category in plan as well
                 if((businessAreacase.Sub_Category__c == 'Dental Benefit Coding Screening' || businessAreacase.Sub_Category__c == 'Dental Underwriting Screening' ) && 
                         befAgrRec.Product__r.Product_Category__c != 'Dental' && befAgrRec.Plan__r.Product__r.Product_Category__c != 'Dental') continue;                 
                 
                 // SFDC-5089 Don't create dental screening for Medical/Pharmacy/Medical UW/Additional UW if BA's product category is dental                                     
                  if((businessAreacase.Sub_Category__c == 'Benefit Coding Screening' || businessAreacase.Sub_Category__c == 'Pharmacy Coding Screening' 
                         || businessAreacase.Sub_Category__c == 'Medical Underwriting Screening' || businessAreacase.Sub_Category__c == 'Additional Underwriting' || businessAreacase.Sub_Category__c == 'Additional Medical Underwriter Screening') && 
                        (befAgrRec.Product__r.Product_Category__c == 'Dental' || befAgrRec.Plan__r.Product__r.Product_Category__c == 'Dental')) continue;  
                                                          
                 
                 Case screeningCase = new Case();
                 DateTime effectiveDate = caseRecord.GEMS_Effective_Date__c;
                 System.debug('businessAreacase.id=====>'+businessAreacase.id);
                 screeningCase.GEMS_Account_Submission_Info__c = caseRecord.GEMS_Account_Submission_Info__c;
                 screeningCase.parentId = businessAreacase.id;
                 screeningCase.GEMS_Benefit_Agreement__c = befAgrRec.Id;
                 screeningCase.Accountid=caseRecord.Accountid;
                 screeningCase.GEMS_Case_Effective_Date__c=caseRecord.GEMS_Case_Effective_Date__c;
                 screeningCase.GEMS_Effective_Date__c=caseRecord.GEMS_Effective_Date__c;
                 screeningCase.GEMS_Submission_Type__c=caseRecord.GEMS_Submission_Type__c;
                 screeningCase.GEMS_Submission_Sub_Type__c=caseRecord.GEMS_Submission_Sub_Type__c;
                 //screeningCase.Subject= accountname + ' ' +befAgrRec.Name+' '+ befAgrRec.Product__r.name+ ' BA Level '+ businessAreacase.Type;
                 //screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' - '+befAgrRec.Name+ ' '+ businessAreacase.Sub_Category__c+' - '+effectiveDate.format('M/d/yyyy'); // Active
                 //screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' - '+befAgrRec.Name+' - '+effectiveDate.format('M/d/yyyy'); // Praveen Added
                 //screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+befAgrRec.Name;
                 screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+businessAreacase.Sub_Category__c;
                 screeningCase.status='In Progress';
                 screeningCase.HCSC_Division__c=businessAreacase.HCSC_Division__c;
                 screeningCase.Opportunity_Name__c = businessAreacase.Opportunity_Name__c;
                 //screeningCase.type=caseRecord.type; <BA#>-BA Level Screening
                 //screeningCase.type=befAgrRec.Name +' BA'+ businessAreacase.Type;
                 screeningCase.type='Screening';
                 screeningCase.Sub_Category__c = businessAreacase.Sub_Category__c;
                 screeningCase.recordTypeId=caseBAScreeningCaseRecordTypeId;
                 screeningCase.GEMS_Medical_Underwriter__c=businessAreacase.GEMS_Medical_Underwriter__c;
                 screeningCase.Sales_Executive__c=businessAreacase.Sales_Executive__c;
                 screeningCase.Productid=businessAreacase.Productid;
                 screeningCase.FSU_Location__c=businessAreacase.FSU_Location__c;
                 screeningCase.GEMS_Products__c=businessAreacase.GEMS_Products__c;                 
                 
                 // This population is for October Hotfix 2016
                 screeningCase.Funding_Type_Multiselect__c = businessAreacase.Funding_Type_Multiselect__c;                
                 screeningCase.GEMS_StdCust_Product__c = businessAreacase.GEMS_StdCust_Product__c;
                 screeningCase.GEMS_Rx_Vendor__c = businessAreacase.GEMS_Rx_Vendor__c;
                 screeningCase.GEMS_Line_of_Business__c=businessAreacase.GEMS_Line_of_Business__c;
                 screeningCase.GEMS_Submitter__c = businessAreacase.GEMS_Submitter__c;
                 screeningCase.GEMS_Benefit_Booklet_Required__c = businessAreacase.GEMS_Benefit_Booklet_Required__c;
                 
                 screeningCase.Account_Executive__c=businessAreacase.Account_Executive__c;
                 System.debug(' businessAreacase.ownerId===>'+ businessAreacase.ownerId);
                 if( businessAreacase.ownerId != null) 
                     screeningCase.ownerId = businessAreacase.ownerId;
                 screeningCasesInsertListee.add(screeningCase);
             }
            
         }
     }
     if(idCardCasesChildList != null && !idCardCasesChildList.isEmpty()) {     
         screeningCasesInsertListee.addAll(idCardCasesChildList);
     }
     if(membershipCasesChildList != null && !membershipCasesChildList.isEmpty()) {     
        screeningCasesInsertListee.addAll(membershipCasesChildList);
     }
     /* US-5205
     if(sbcCasesChildList != null && !sbcCasesChildList.isEmpty()) {
         screeningCasesInsertListee.addAll(sbcCasesChildList);     
     }
     */
     
     this.screeningCasesInsertList =  screeningCasesInsertListee;
    }

   global void finish(Database.BatchableContext BC){
       if(!screeningCasesInsertList.isEmpty()) {
           ProcessScreeningBatch screeningBatch = new ProcessScreeningBatch(screeningCasesInsertList);
           Database.executeBatch(screeningBatch, 200);
       }
   }
   
   global List<Case> createIdCardParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap) {
        List<Case> custIdParentCasesInsertList = new List<Case>();
        List<Case> custIdChildCasesInsertList = new List<Case>();
        try {
            Id customIdCardParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
            //Id customIdCardChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId();
            
            Set<ID> subCaseIdsSet = new Set<ID>();
            subCaseIdsSet=subIdListBenfMap.keySet();
            
            //List<Case> subCaseChildCasesList = [SELECT ID, GEMS_Account_Submission_Info__c,RecordTypeId from Case WHERE GEMS_Account_Submission_Info__c IN: subCaseIdsSet];
            /* --------------- */
            List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
            List<case> subCaseRecChildIDCardCasesList = [select id, Status, recordtypeid, GEMS_Accum_Type__c,GEMS_BCC_Products__c, 
                                                         GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                         FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                         GEMS_Line_Of_Business__c,HCSC_Division__c,Account_Name__c,GEMS_ID_Cards_Format__c,
                                                         GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                         (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                          from Cases1__r where recordtypeid  =:customIdCardParentRecordTypeId),
                                                         (select parentId,memberid,TeamRole.name from TeamMembers
                                                          where TeamRole.name =: caseOwnerMetadata[0].Case_Team_Member__c)
                                                         from case where id = :subCaseIdsSet];
            
            Map<Id,Boolean> subCaseIdIDCardRecFoundMap = new Map<Id,Boolean>();
            
            Map<Id, caseTeamMember> subIdAccSpecialistMemberMap = new Map<Id, caseTeamMember>();
            Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
            
            Boolean IDCardRecFound = false;
            
            if(!subCaseRecChildIDCardCasesList.isEmpty() && subCaseRecChildIDCardCasesList != null) 
            {
                for(case subCaseRec : subCaseRecChildIDCardCasesList) 
                {
                    List<Case> tempCaseList = new List<Case>();
                    tempCaseList=subCaseRec.Cases1__r;
                    if(!subCaseRec.TeamMembers.isEmpty())
                    {
                        subIdAccSpecialistMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                    }
                    if(tempCaseList.Size()>0)
                    {
                        IDCardRecFound=true;
                        subCaseIdIDCardRecFoundMap.put(subCaseRec.Id,IDCardRecFound);
                        break;
                    }
                    else
                    {
                        IDCardRecFound=false;
                        subCaseIdIDCardRecFoundMap.put(subCaseRec.Id,IDCardRecFound);
                    }
                }
                
            }
            
            for(Case strCaseRec: clientApprovalReceivedCasesList) {
                Boolean IDCardCaseRecFound = subCaseIdIDCardRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                if(!IDCardCaseRecFound) {
                    List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                    DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                    Case parentIdCase = new Case();
                    parentIdCase.recordTypeId =customIdCardParentRecordTypeId;
                    
                    if( benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c !=null && benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c=='Standard' && subIdAccSpecialistMemberMap.containsKey(strCaseRec.GEMS_Account_Submission_Info__c) && subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid != null )
                    {
                        parentIdCase.ownerId=subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                    }
                    else if( benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c !=null && benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c=='Custom' && benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId != null)
                    {
                        parentIdCase.ownerId=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                    }
                    else
                    {
                        //SFDC-10234 Do not assign ID Card case to unmanaged queue when ID card format is blank
                        parentIdCase.ownerId=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                        //parentIdCase.ownerId=accSpecGroup.Id;
                    }
                    parentIdCase.Subject=benfAggList[0].AccountStructureCase__r.Account.Name+' '+ benfAggList[0].AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' ID Card';
                    parentIdCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                    parentIdCase.Accountid = strCaseRec.Accountid;
                    parentIdCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                    parentIdCase.GEMS_Case_Effective_Date__c=strCaseRec.GEMS_Case_Effective_Date__c;
                    parentIdCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                    parentIdCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                    parentIdCase.FSU_Location__c=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                    parentIdCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;                
                    parentIdCase.Opportunity_Name__c=strCaseRec.Opportunity_Name__c;
                    parentIdCase.Type='ID Card';  //strCaseRec.Type;
                    parentIdCase.parentid=strCaseRec.GEMS_Account_Submission_Info__c;                
                    parentIdCase.status='In Progress';  
                    //parentIdCase.Eligibility_Process_Case_Status__c='In Progress';   //added by Harsha              
                    parentIdCase.GEMS_OE_Eligibility_Method__c =strCaseRec.GEMS_Account_Submission_Info__r.GEMS_OE_Eligibility_Method__c; //added by Harsha
                    // This population is for October Hotfix 2016
                     parentIdCase.Funding_Type_Multiselect__c = strCaseRec.Funding_Type_Multiselect__c;                
                     parentIdCase.GEMS_StdCust_Product__c = strCaseRec.GEMS_StdCust_Product__c;
                     parentIdCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                     parentIdCase.GEMS_Line_of_Business__c=strCaseRec.GEMS_Line_of_Business__c;
                     parentIdCase.GEMS_Submitter__c = strCaseRec.GEMS_Submitter__c;
                    
                    custIdParentCasesInsertList.add(parentIdCase);
                }
            }
            if(!custIdParentCasesInsertList.isEmpty())
            {
                insert custIdParentCasesInsertList;
            }
            System.Debug('parent insert =====>' +custIdParentCasesInsertList);
            
            //SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests 
            /*
            for(Case custCaseRec: custIdParentCasesInsertList)
            {
                List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(custCaseRec.GEMS_Account_Submission_Info__c);
                for(GEMS_Benefit_Agreement__c benfRec: benfAggList)
                {
                    DateTime effectiveDate = custCaseRec.GEMS_Effective_Date__c;
                    Case childIdCase = new Case();
                    childIdCase.recordTypeId=customIdCardChildRecordTypeId;
                    childIdCase.parentId=custCaseRec.Id;
                    childIdCase.OwnerId=custCaseRec.OwnerId;
                    childIdCase.GEMS_Benefit_Agreement__c=benfRec.Id;
                    childIdCase.Subject=benfRec.AccountStructureCase__r.account.name+' '+ benfRec.AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' BA ID Card';
                    childIdCase.GEMS_Account_Submission_Info__c=custCaseRec.GEMS_Account_Submission_Info__c;
                    childIdCase.Accountid = custCaseRec.Accountid;
                    //childIdCase.GEMS_Account_Name__c = custCaseRec.Accountid;
                    childIdCase.GEMS_Effective_Date__c=custCaseRec.GEMS_Effective_Date__c;
                    childIdCase.GEMS_Case_Effective_Date__c=custCaseRec.GEMS_Case_Effective_Date__c;
                    childIdCase.GEMS_Submission_Type__c=custCaseRec.GEMS_Submission_Type__c;
                    childIdCase.GEMS_Submission_Sub_Type__c=custCaseRec.GEMS_Submission_Sub_Type__c;
                    childIdCase.FSU_Location__c=benfRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                    childIdCase.HCSC_Division__c=custCaseRec.HCSC_Division__c;
                    childIdCase.GEMS_Line_of_Business__c=custCaseRec.GEMS_Line_of_Business__c;
                    childIdCase.Opportunity_Name__c=custCaseRec.Opportunity_Name__c;
                    childIdCase.Type= 'ID Card'; //custCaseRec.Type;
                    // This population is for October Hotfix 2016
                     childIdCase.Funding_Type_Multiselect__c = custCaseRec.Funding_Type_Multiselect__c;                
                     childIdCase.GEMS_StdCust_Product__c = custCaseRec.GEMS_StdCust_Product__c;
                     childIdCase.GEMS_Rx_Vendor__c = custCaseRec.GEMS_Rx_Vendor__c;
                     childIdCase.GEMS_Line_of_Business__c=custCaseRec.GEMS_Line_of_Business__c;
                     childIdCase.GEMS_Submitter__c = custCaseRec.GEMS_Submitter__c;
                     
                    childIdCase.status='In Progress';
                    custIdChildCasesInsertList.add(childIdCase);
                }
            } */
            /*if(!custIdChildCasesInsertList.isEmpty())
            {
                insert custIdChildCasesInsertList;
            }*/
            System.Debug('Child insert list =====>' +custIdChildCasesInsertList);
        }
        catch(Exception ex) {
            System.debug('==exception='+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'ChildScreeningBatch.createIdCardParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');
        }
        return custIdChildCasesInsertList;
    }
    
    /*US-5205
    global List<Case> createSBCParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap) {
        List<Case> custSbcParentCasesInsertList = new List<Case>();
        List<Case> custSbcChildCasesInsertList = new List<Case>();
        try {
        Id customsbcParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Id customsbcChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        
        Set<ID> subCaseIdsSet = new Set<ID>();
        subCaseIdsSet=subIdListBenfMap.keySet();
        
        //List<Case> subCaseChildCasesList = [SELECT ID, GEMS_Account_Submission_Info__c,RecordTypeId from Case WHERE GEMS_Account_Submission_Info__c IN: subCaseIdsSet];
        //List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
        List<case> subCaseRecChildsbcCasesList = [select id, GEMS_SBC_Required__c,Status, recordtypeid, GEMS_Accum_Type__c, 
                                                     GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                     FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                     GEMS_Line_Of_Business__c,HCSC_Division__c,Account_Name__c,GEMS_BCC_Products__c,
                                                     GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                     (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                      from Cases1__r where recordtypeid  =:customsbcParentRecordTypeId)

                                                     from case where id = :subCaseIdsSet];
        
        Map<Id,Boolean> subCaseIdsbcRecFoundMap = new Map<Id,Boolean>();
        
        Map<Id, caseTeamMember> subIdAccSpecialistMemberMap = new Map<Id, caseTeamMember>();
        //Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
        
        Boolean sbcRecFound = false;
        
        if(!subCaseRecChildsbcCasesList.isEmpty() && subCaseRecChildsbcCasesList != null) 
        {
            for(case subCaseRec : subCaseRecChildsbcCasesList) 
            {
                List<Case> tempCaseList = new List<Case>();
                tempCaseList=subCaseRec.Cases1__r;
                //if(!subCaseRec.TeamMembers.isEmpty())
                //{
                //    subIdAccSpecialistMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                //}
                if(tempCaseList.Size()>0 || subCaseRec.GEMS_SBC_Required__c == 'No')
                {
                    sbcRecFound = true;
                    subCaseIdsbcRecFoundMap.put(subCaseRec.Id,sbcRecFound);
                    break;
                }
                else
                {
                    sbcRecFound = false;
                    subCaseIdsbcRecFoundMap.put(subCaseRec.Id,sbcRecFound);
                }
            }
            
        }
        
        List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
        
        for(Case strCaseRec: clientApprovalReceivedCasesList) {
            Boolean sbcCaseRecFound = subCaseIdsbcRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
            if(!sbcCaseRecFound) {
                List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                Case parentSbcCase = new Case();
                parentSbcCase.recordTypeId =customsbcParentRecordTypeId;
                parentSbcCase.Subject=benfAggList[0].AccountStructureCase__r.Account.Name+' '+ benfAggList[0].AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' SBC';
                parentSbcCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                parentSbcCase.parentId=strCaseRec.GEMS_Account_Submission_Info__c;
                parentSbcCase.Accountid = strCaseRec.Accountid;
                parentSbcCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                parentSbcCase.GEMS_Case_Effective_Date__c=strCaseRec.GEMS_Case_Effective_Date__c;
                parentSbcCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                parentSbcCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                parentSbcCase.FSU_Location__c=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                parentSbcCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;
                parentSbcCase.GEMS_Line_of_Business__c=strCaseRec.GEMS_Line_of_Business__c;
                parentSbcCase.Opportunity_Name__c=strCaseRec.Opportunity_Name__c;
                parentSbcCase.Type='SBC';  //strCaseRec.Type;
                parentSbcCase.Funding_Type_Multiselect__c=strCaseRec.Funding_Type_Multiselect__c;
                parentSbcCase.status='In Progress';
                parentSbcCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                parentSbcCase.ownerId=userInfo.getUserId();
                parentSbcCase.GEMS_Submitter__c = benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId; //Added for October Release Hot Fix
                // This population is for October Hotfix 2016                
                parentSbcCase.GEMS_StdCust_Product__c = strCaseRec.GEMS_StdCust_Product__c;
                
                if(!activeEntitlement.isEmpty())
                {
                    parentSbcCase.EntitlementId = activeEntitlement[0].id;
                }
                
                custSbcParentCasesInsertList.add(parentSbcCase);
            }
        }
        if(!custSbcParentCasesInsertList.isEmpty())
        {
            insert custSbcParentCasesInsertList;
        }
        System.Debug('parent insert =====>' +custSbcParentCasesInsertList);
        for(Case custCaseRec: custSbcParentCasesInsertList)
        {
            List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(custCaseRec.GEMS_Account_Submission_Info__c);
            System.debug('==benfAggList =='+benfAggList);
            for(GEMS_Benefit_Agreement__c benfRec: benfAggList)
            {
                DateTime effectiveDate = custCaseRec.GEMS_Effective_Date__c;
                Case childSbcCase = new Case();
                childSbcCase.recordTypeId=customsbcChildRecordTypeId;
                childSbcCase.parentId=custCaseRec.Id;
                childSbcCase.OwnerId=custCaseRec.OwnerId;
                childSbcCase.GEMS_Benefit_Agreement__c=benfRec.Id;
                childSbcCase.Subject=benfRec.AccountStructureCase__r.account.name+' '+ benfRec.AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+'BA Level SBC';
                childSbcCase.GEMS_Account_Submission_Info__c=custCaseRec.GEMS_Account_Submission_Info__c;
                childSbcCase.Accountid = custCaseRec.Accountid;
                childSbcCase.GEMS_Effective_Date__c=custCaseRec.GEMS_Effective_Date__c;
                childSbcCase.GEMS_Case_Effective_Date__c=custCaseRec.GEMS_Case_Effective_Date__c;
                childSbcCase.GEMS_Submission_Type__c=custCaseRec.GEMS_Submission_Type__c;
                childSbcCase.GEMS_Submission_Sub_Type__c=custCaseRec.GEMS_Submission_Sub_Type__c;
                childSbcCase.FSU_Location__c=benfRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                childSbcCase.HCSC_Division__c=custCaseRec.HCSC_Division__c;
                childSbcCase.GEMS_Line_of_Business__c=custCaseRec.GEMS_Line_of_Business__c;
                childSbcCase.Opportunity_Name__c=custCaseRec.Opportunity_Name__c;
                childSbcCase.Type= 'SBC'; //custCaseRec.Type;
                childSbcCase.Funding_Type_Multiselect__c=custCaseRec.Funding_Type_Multiselect__c;
                childSbcCase.status='In Progress';
                childSbcCase.GEMS_Submitter__c = benfRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.ownerId; //Added for October Release Hot Fix
                // This population is for October Hotfix 2016                
                childSbcCase.GEMS_StdCust_Product__c = custCaseRec.GEMS_StdCust_Product__c;
                
                custSbcChildCasesInsertList.add(childSbcCase);
            }
        }
        //if(!custSbcChildCasesInsertList.isEmpty())
        //{
            insert custSbcChildCasesInsertList;
        //}
        System.Debug('Child insert list =====>' +custSbcChildCasesInsertList);
        }
        Catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'ChildScreeningBatch.createSBCParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');  
            System.debug('==Exception='+ex.getMessage());
        }
        return custSbcChildCasesInsertList;
    }
    */
    
    /******************************************************************** 
    *    Method Name : createMembershipCase
    Action
    *   @description :   This method to create membership case. Created as part of SFDC-6747 GEMS - trigger Membership case upon "release"
    *   @parameters  :   List<Case> clientApprovalReceivedCasesList, Map<ID,Set<ID> subCaseIdsSet
    *   @return type :   void
    ***************************************************************/
    global List < Case > createMembershipCase(List<Case> clientApprovalReceivedCasesList, Set<ID> subCaseIdsSet) {
        List<Case> custIdChildCasesInsertList = new List<Case>();
        List<Case> membershipParentCasesInsertList = new List<Case>();
        try {
            Id membershipParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Membership').getRecordTypeId();
            Map<Id,Case> submissionIdMap = new Map<Id,Case>();
            List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='FSU Membership' ];
            List<case> subCaseRecChildMembershipCasesList = [select id, Status, OwnerId, recordtypeid, GEMS_Accum_Type__c,GEMS_BCC_Products__c, 
                                                         GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                     FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                     GEMS_Line_of_Business__c,HCSC_Division__c,Account_Name__c,GEMS_StdCust_Product__c,
                                                     GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                     (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                      from Cases1__r where recordtypeid  =:membershipParentRecordTypeId),
                                                     (select parentId,memberid,TeamRole.name from TeamMembers
                                                      where TeamRole.name =: caseOwnerMetadata[0].Case_Team_Member__c)
                                                     from case where id = :subCaseIdsSet];
        
            Map<Id,Boolean> subCaseIdMembershipRecFoundMap = new Map<Id,Boolean>();
            Map<Id, caseTeamMember> subIdFSUAnalystMemberMap = new Map<Id, caseTeamMember>();
            Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
            Boolean MembershipRecFound = false;
            if(!subCaseRecChildMembershipCasesList.isEmpty() && subCaseRecChildMembershipCasesList != null) {
                for(case subCaseRec : subCaseRecChildMembershipCasesList) {
                    submissionIdMap.put(subCaseRec.Id, subCaseRec );
                    List<Case> tempCaseList = new List<Case>();
                    tempCaseList=subCaseRec.Cases1__r;
                    if(!subCaseRec.TeamMembers.isEmpty()){
                        subIdFSUAnalystMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                    }
                    if(tempCaseList.Size()>0){
                        MembershipRecFound=true;
                        subCaseIdMembershipRecFoundMap.put(subCaseRec.Id,MembershipRecFound);
                        break;
                    } else {
                        MembershipRecFound=false;
                        subCaseIdMembershipRecFoundMap.put(subCaseRec.Id,MembershipRecFound);
                    }
                }
            }
            if (!subCaseIdMembershipRecFoundMap.isEmpty()) {
                    for (Case strCaseRec: clientApprovalReceivedCasesList) {
                        Boolean MembershipCaseRecFound = subCaseIdMembershipRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                        if(!MembershipCaseRecFound) {
                            case newCase = new case ();
                            newCase.GEMS_Account_Submission_Info__c = strCaseRec.GEMS_Account_Submission_Info__c;
                            newCase.parentid = strCaseRec.GEMS_Account_Submission_Info__c;
                            newCase.Accountid = strCaseRec.Accountid;
                            newCase.GEMS_Case_Effective_Date__c = strCaseRec.GEMS_Case_Effective_Date__c;
                            newcase.GEMS_Submission_Type__c = strCaseRec.GEMS_Submission_Type__c;
                            newCase.GEMS_Submission_Sub_Type__c = strCaseRec.GEMS_Submission_Sub_Type__c;
                            if(subIdFSUAnalystMemberMap.containsKey(strCaseRec.GEMS_Account_Submission_Info__c) && subIdFSUAnalystMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid != null ) {
                                newCase.ownerId=subIdFSUAnalystMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                            } else {
                                newCase.ownerId=accSpecGroup.Id;
                            }
                            DateTime effectiveDate = strCaseRec.GEMS_Case_Effective_Date__c;
                            newCase.Subject = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).Account_Name__c + ' ' + submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).Account_Number__c + ' ' + effectiveDate.format('M/d/yyyy') + ' GEMS Membership';
                            newCase.status = 'In Progress';
                            newCase.type = 'Membership';
                            newCase.GEMS_Products__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_Products__c;
                            newCase.HCSC_Division__c = strCaseRec.HCSC_Division__c;
                            newCase.GEMS_Line_of_Business__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_Line_of_Business__c;
                            newCase.FSU_Location__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).FSU_Location__c;
                            newCase.Opportunity_Name__c = strCaseRec.Opportunity_Name__c;
                            newCase.GEMS_AEP_Account__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_AEP_Account__c;
                            newCase.recordTypeId = membershipParentRecordTypeId;
                            newCase.GEMS_Effective_Date__c = strCaseRec.GEMS_Effective_Date__c;
                            newCase.Funding_Type_Multiselect__c = strCaseRec.Funding_Type_Multiselect__c;
                            newCase.GEMS_StdCust_Product__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_StdCust_Product__c;
                            newCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                            newCase.GEMS_Submitter__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).ownerId;
                            newCase.GEMS_Is_Eligibility_Required__c = strCaseRec.GEMS_Is_Eligibility_Required__c;
                            membershipParentCasesInsertList.add(newCase);
                        }
                    }

                    System.Debug('membership insert =====>' +membershipParentCasesInsertList);
                    List < Task > taskInsertList = new List < Task > ();
                    Database.UpsertResult[]childSaveResult;
                    if (!membershipParentCasesInsertList.isEmpty()) {
                        childSaveResult = Database.upsert(membershipParentCasesInsertList);
                    }
                    integer i = 0;
                    if (childSaveResult != null) {
                        System.debug('======creating task for membership======');
                        for (Database.UpsertResult sr: childSaveResult) {
                            if (sr.isSuccess()) {
                                Case memCase = membershipParentCasesInsertList.get(i);
                                Task memTask = new Task();
                                memTask.WhatId = memCase.Id;
                                memTask.Subject = 'Membership Entry Complete';
                                memTask.Status = 'In Progress';
                                memTask.Priority = 'Normal';
                                memTask.GEMS_Start_Date__c = System.now();
                                System.debug('memCase.GEMS_Account_Submission_Info__c===>' + memCase.GEMS_Account_Submission_Info__c);
                                if (memCase.ownerId == null && subIdFSUAnalystMemberMap.get(memCase.GEMS_Account_Submission_Info__c) != null) {
                                    memTask.ownerId = subIdFSUAnalystMemberMap.get(memCase.GEMS_Account_Submission_Info__c).memberid;
                                } else if (memCase.ownerId != null && !(string.valueOf(memCase.OwnerID).startsWith('00G'))) {
                                    memTask.ownerId = memCase.ownerId;
                                }
                                taskInsertList.add(memTask);
                            }
                            i++;
                        }
                    }
                    if (!taskInsertList.isEmpty())
                        Database.insert(taskInsertList);
                }
            } catch(Exception ex) {
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createMembershipCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');
            }
            return custIdChildCasesInsertList;
    }
}