public class GEMS_ShowCaseSubmissionRequiredDocuments {

    public Case caseRecord{get;set;}
    public Set<String> requiredDocuments{get;set;}
    
    public GEMS_ShowCaseSubmissionRequiredDocuments(ApexPages.StandardController controller) {
        requiredDocuments = new Set<String>();
        try {
        Case caseRec = (case)controller.getRecord();
        caseRecord = [Select ID, GEMS_Return_Check__c,GEMS_Submission_Type__c,Funding_Type_Multiselect__c,GEMS_Is_CBSR_required__c,GEMS_AEP_Account__c,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c, GEMS_ReviewDocuments__c,GEMS_Performance_Guarantees__c,HCSC_Division__c,GEMS_Products__c,Funding_Type__c, GEMS_Approve__c,GEMS_Return__c,GEMS_Routed_In_Error__c, Status, GEMS_Account_Submission_Info__c,RecordType.name from Case where ID =: caseRec.ID];
        List<Case> caseList = new List<Case>{caseRecord};
        Map<String,Set<String>> documentListMap = retrieveDocsRequiredForCases(caseList );
        if(documentListMap != null && documentListMap.get(caseRecord.Id) != null) {        
             requiredDocuments.addAll(documentListMap.get(caseRecord.Id));
         }
        /*List<GEMS_Account_Submission_required_doc__mdt> accountSubmissionRequiredDocsList = [SELECT DeveloperName,Division__c, Document_Type__c, Fields__c, Funding_Type__c, Products__c, Required_Documents__c, Submission_Sub_type__c, Submission_Type__c FROM GEMS_Account_Submission_required_doc__mdt where Is_Active__c = true];
        Map<String, Schema.SObjectField> caseFieldsMap = Schema.SObjectType.Case.fields.getMap();
        if(!accountSubmissionRequiredDocsList.isEmpty()) {
        for(GEMS_Account_Submission_required_doc__mdt submissionReqDoc : accountSubmissionRequiredDocsList) { 
            System.debug('DeveloperName====>'+submissionReqDoc.DeveloperName);           
            if(!(caseRecord.GEMS_Submission_Type__c != null && caseRecord.GEMS_Submission_Type__c.contains(submissionReqDoc.Submission_Type__c)) ) {
                continue;
            }
            if((submissionReqDoc.Division__c == 'All' && caseRecord.HCSC_Division__c == null ) || (submissionReqDoc.Division__c != 'All' && submissionReqDoc.Division__c != 'N/A' && caseRecord.HCSC_Division__c != submissionReqDoc.Division__c) ) {
                continue;
            }
            
            System.debug('caseRecord.GEMS_Products__c===>'+caseRecord.GEMS_Products__c+' submissionReqDoc.Products__c==>'+submissionReqDoc.Products__c);

            if( (submissionReqDoc.Products__c != 'N/A' && caseRecord.GEMS_Products__c == null) || (submissionReqDoc.Products__c != 'N/A' && caseRecord.GEMS_Products__c != null && !(caseRecord.GEMS_Products__c.contains(submissionReqDoc.Products__c) || submissionReqDoc.Products__c.contains(caseRecord.GEMS_Products__c)) )) {
                System.debug('Entered----Rec--Docs--');
                continue;
            }
            
            String SearchstringcaseFundingType = '';
            String SearchstringMetadataFundingType = '';
            
            SearchstringMetadataFundingType = submissionReqDoc.Funding_Type__c;
            SearchstringcaseFundingType = caseRecord.Funding_Type_Multiselect__c;
            
            System.debug('caseRecord.Funding_Type__c ===>'+caseRecord.Funding_Type_Multiselect__c +' submissionReqDoc.Funding_Type__c ==>'+submissionReqDoc.Funding_Type__c );
            
            if( (submissionReqDoc.Funding_Type__c == 'All' && caseRecord.Funding_Type_Multiselect__c == null) || (submissionReqDoc.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && !SearchstringcaseFundingType .contains(SearchstringMetadataFundingType) ) ) {
                continue;
            }  
                       
            if( submissionReqDoc.Fields__c != 'N/A') {
                try{
                String[] fieldMetaDataArray = (submissionReqDoc.Fields__c).split(';');
                Boolean caseFailed = false;
                String Searchstring = '';
                for(String fieldMetaData : fieldMetaDataArray ) {
                    String[] fieldData = fieldMetaData.split('=');
                    //Searchstring = (String)caseRecord.get(caseFieldsMap.get(fieldData[0]));
                    system.debug('field Type: '+fieldData[0]);
                    system.debug('field Data: '+fieldData[1]);
                     
                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist) {
                    Searchstring = (String)caseRecord.get(caseFieldsMap.get(fieldData[0]));
                    system.debug('Picklist :'+(String)caseRecord.get(caseFieldsMap.get(fieldData[0])));
                    }
                    
                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.BOOLEAN && ( (fieldData[1] == 'TRUE' && !(Boolean)caseRecord.get(caseFieldsMap.get(fieldData[0]))) || (fieldData[1] == 'FALSE' && (Boolean)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                        caseFailed = true;
                        break;
                    }
                    
                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.PICKLIST && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                        caseFailed = true;
                        break;
                    }
                    
                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.STRING && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                        caseFailed = true;
                        break;
                    }
                    
                    
                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist && ( !Searchstring.contains(fieldData[1]) ) ){
                        caseFailed = true;
                        break;
                    }
                }
                if(caseFailed) {
                    continue;
                }
              }catch(Exception ex) {
                  System.debug('======Try===Exception==Fields__c ==='+ex.getMessage());
              }
            }
            if(submissionReqDoc.Document_Type__c != '?') {
                requiredDocuments.add(submissionReqDoc.Document_Type__c);
            }
            
        }
        }*/
    } catch(Exception ex) {
        System.debug('=========Exception===='+ex.getMessage());
    }
    }
    
    
    public static Map<String,Set<String>> retrieveDocsRequiredForCases(List<Case> casesList) {
        List<GEMS_Account_Submission_required_doc__mdt> accountSubmissionRequiredDocsList = [SELECT Division__c, Document_Type__c, Fields__c, Funding_Type__c, Products__c, Required_Documents__c, Submission_Sub_type__c, Submission_Type__c FROM GEMS_Account_Submission_required_doc__mdt where Is_Active__c = true];
        Set<String> recDocs= null;
        Map<String,Set<String>> caseIdRecDocsMap = new Map<String,Set<String>>();
        Map<String, Schema.SObjectField> caseFieldsMap = Schema.SObjectType.Case.fields.getMap();
        for(Case caseRecord : casesList) {
            if(!accountSubmissionRequiredDocsList.isEmpty()) {
                recDocs = new Set<String>();
                
                for(GEMS_Account_Submission_required_doc__mdt submissionReqDoc : accountSubmissionRequiredDocsList) {            
                    if(!(caseRecord.GEMS_Submission_Type__c != null && caseRecord.GEMS_Submission_Type__c.contains(submissionReqDoc.Submission_Type__c)) ) {
                        continue;
                    }
                    if((submissionReqDoc.Division__c == 'All' && caseRecord.HCSC_Division__c == null ) || (submissionReqDoc.Division__c != 'All' && submissionReqDoc.Division__c != 'N/A' && caseRecord.HCSC_Division__c != submissionReqDoc.Division__c) ) {
                        continue;
                    }
                    
                    System.debug('caseRecord.GEMS_Products__c===>'+caseRecord.GEMS_Products__c+' submissionReqDoc.Products__c==>'+submissionReqDoc.Products__c);
        
                    if( (submissionReqDoc.Products__c != 'N/A' && caseRecord.GEMS_Products__c == null) || (submissionReqDoc.Products__c != 'N/A' && caseRecord.GEMS_Products__c != null && !(caseRecord.GEMS_Products__c.contains(submissionReqDoc.Products__c) || submissionReqDoc.Products__c.contains(caseRecord.GEMS_Products__c)) )) {
                        System.debug('Entered----Rec--Docs--');
                        continue;
                    }
                    
                    String SearchstringcaseFundingType = '';
                    String SearchstringMetadataFundingType = '';
                    
                    SearchstringMetadataFundingType = submissionReqDoc.Funding_Type__c;
                    SearchstringcaseFundingType = caseRecord.Funding_Type_Multiselect__c;
                    
                    System.debug('caseRecord.Funding_Type__c ===>'+caseRecord.Funding_Type_Multiselect__c +' submissionReqDoc.Funding_Type__c ==>'+submissionReqDoc.Funding_Type__c );
                    //if( (submissionReqDoc.Funding_Type__c == 'All' && caseRecord.Funding_Type_Multiselect__c == null) || (submissionReqDoc.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && caseRecord.Funding_Type_Multiselect__c != submissionReqDoc.Funding_Type__c) ) {
                    if( (submissionReqDoc.Funding_Type__c == 'All' && caseRecord.Funding_Type_Multiselect__c == null) || (submissionReqDoc.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && !SearchstringcaseFundingType .contains(SearchstringMetadataFundingType) ) ) {
                        continue;
                    }   
                               
                    if( submissionReqDoc.Fields__c != 'N/A') {
                        try{
                        String[] fieldMetaDataArray = (submissionReqDoc.Fields__c).split(';');
                        Boolean caseFailed = false;
                        String Searchstring = '';
                        for(String fieldMetaData : fieldMetaDataArray ) {
                            String[] fieldData = fieldMetaData.split('=');
                            //Searchstring = (String)caseRecord.get(caseFieldsMap.get(fieldData[0]));
                            system.debug('field Type: '+fieldData[0]);
                            system.debug('field Data: '+fieldData[1]);
                             
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist) {
                               if(caseRecord.get(caseFieldsMap.get(fieldData[0])) != null) {
                                Searchstring = (String)caseRecord.get(caseFieldsMap.get(fieldData[0]));
                                system.debug('Picklist :'+(String)caseRecord.get(caseFieldsMap.get(fieldData[0])));
                               }
                            }
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.BOOLEAN && ( (fieldData[1] == 'TRUE' && !(Boolean)caseRecord.get(caseFieldsMap.get(fieldData[0]))) || (fieldData[1] == 'FALSE' && (Boolean)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                caseFailed = true;
                                break;
                            }
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.PICKLIST && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                caseFailed = true;
                                break;
                            }
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.STRING && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                caseFailed = true;
                                break;
                            }
                            
                            //if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist && ( !Searchstring.contains(fieldData[1]) ) ){
                                caseFailed = true;
                                break;
                            }
                        }
                        if(caseFailed) {
                            continue;
                        }
                      }catch(Exception ex) {
                          System.debug('======Try===Exception==Fields__c ==='+ex.getMessage());
                      }
                    }
                    if(submissionReqDoc.Document_Type__c != '?') {
                        recDocs.add(submissionReqDoc.Document_Type__c);
                    }
                    
                }
                
                /*for(GEMS_Account_Submission_required_doc__mdt submissionReqDoc : accountSubmissionRequiredDocsList) {
                    if(!(caseRecord.GEMS_Submission_Type__c != null && caseRecord.GEMS_Submission_Type__c.contains(submissionReqDoc.Submission_Type__c)) ) {
                        continue;
                    }
                    if(caseRecord.HCSC_Division__c != submissionReqDoc.Division__c) {
                        continue;
                    }
                    System.debug('caseRecord.GEMS_Products__c===>'+caseRecord.GEMS_Products__c+' submissionReqDoc.Products__c==>'+submissionReqDoc.Products__c);
                    if(caseRecord.GEMS_Products__c != null && !(caseRecord.GEMS_Products__c.contains(submissionReqDoc.Products__c) || submissionReqDoc.Products__c.contains(caseRecord.GEMS_Products__c) )) {
                        System.debug('Entered----Rec--Docs--');
                        continue;
                    }
                    if(caseRecord.Funding_Type__c != null && caseRecord.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && caseRecord.Funding_Type__c != submissionReqDoc.Funding_Type__c) {
                        continue;
                    }
                    recDocs.add(submissionReqDoc.Document_Type__c.toUpperCase());
                }*/
                System.debug('recDocs====>'+recDocs);
               caseIdRecDocsMap.put(caseRecord.Id,recDocs);  
            }
            
        }
        return caseIdRecDocsMap;
    }
   
}