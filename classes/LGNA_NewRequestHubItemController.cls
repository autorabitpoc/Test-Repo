/**
** Apex Class Name: LGNA_NewRequestHubItemController
** Version: 4/20/2018
** Created by: Mei Chen
** Description: This Controller is to process the Requests from New Request Hub UI. 
** 
***  Modification Log
**   Developer                        Date                 Description
**-----------------------------------------------------------------------------
**  Mei Chen                        4/20/2018            SFDC-9053 & SFDC-8550   Retrieve Request Hub Items data and Request Hub User Favorite data and dispaly on Request Hub UI
**  Padma B.                        4/23/2018            Added SaverUserFavorite SFDC-9052
**  sujatha gondi					5/02/2018			 Added Account Maintanance SFDC - 9020,8918
**  Rakesh Nunna                    5/01/2018            Added Account Maintenance Access Check SFDC -9020,8918
**  Padma Bedampeta                 5/06/2018            Proposal, Network Information, Cede access check, Insert Cases from Account Request Hub.
**  Padma Bedampeta                 5/16/2018            Proposal, Network Information, Cede access check, Insert Cases from Account Request Hub.
**  Ranjit Gandhi                   5/16/2018            SFDC- 9626
***********************************************************************************************************************/

public with sharing class LGNA_NewRequestHubItemController {
    
    /*
@auraEnabled
public static Map<Integer,list<Request_Hub_Items__c>> getRequestItemsMap(String recordId, String objectName){

Map<Integer, list<Request_Hub_Items__c>> requestItemsMap=new Map<Integer,list<Request_Hub_Items__c>>();


list<Request_Hub_Items__c> requestList=new list<Request_Hub_Items__c>();
list<Request_Hub_Items__c> userFavoriteList=new list<Request_Hub_Items__c>();
Id userId=UserInfo.getUserId();//

list<Request_Hub_Favorite__c> currentUserFavoristList=new list<Request_Hub_Favorite__c>();

currentUserFavoristList=[ select id, User__c, Request_Hub_Items__c from Request_Hub_Favorite__c where user__c=:userId AND Favorite_On__c=true];

//put the item Ids in a set
Set<Id> favoritedItemIds=new Set<Id>();

for(Request_Hub_Favorite__c cf: currentUserFavoristList){
favoritedItemIds.add(cf.Request_Hub_Items__c);
}
system.debug('current favorited Item Ids: '+favoritedItemIds);

if( !favoritedItemIds.isEmpty()){
userFavoriteList=[Select Id, Name, Closed_YTD__c,Description__c,Label__c,Active__c,Open_Request__c,New_Sale_Opp__c,Off_Cycle_Opp__c,Prospect_Account__c,Renewal_Opp__c,LG_Group_Account__c,SG_Group_Account__c from Request_Hub_Items__c where Active__c=true and Id In : favoritedItemIds];        
}
requestItemsMap.put(1, userFavoriteList); //put empty list

String recordKey=null;
String conditionStr='';
Map<String, String> fieldNameMap=new Map<String, String>();//record type developer name mapping with field name from request item hub
fieldNameMap.put('Group_Prospect_Account','Prospect_Account__c');
fieldNameMap.put('Group_Account','LG_Group_Account__c');
fieldNameMap.put('New_Sale','New_Sale_Opp__c');
fieldNameMap.put('Off_Cycle_Upsell','Off_Cycle_Opp__c');
fieldNameMap.put('Renewal','Renewal_Opp__c');
fieldNameMap.put('SG','SG_Group_Account__c'); //this one is exception, SG is not record type 

try{
if(objectName!=null && objectName=='Opportunity'){
Opportunity opp=[select id, RecordTypeId, recordType.Name, recordType.developerName from Opportunity where id =:recordId];
if(opp!=null){
recordKey =opp.recordType.developerName;//Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.RecordTypeId).getname();
}
}else if(objectName!=null && objectName=='Account'){
Account acc=[select id,Market_Segment__c, RecordTypeId, recordType.developerName, recordType.Name from Account where id =:recordId];
if(acc!=null){
recordKey =acc.recordType.developerName; //Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(acc.RecordTypeId).getname();
if(recordKey!=null && recordKey=='Group_Account' && acc.Market_Segment__c!=null && acc.Market_Segment__c.contains('SG')){
recordKey='SG';
}
}
}
system.debug(' record type name:'+recordKey);

if(recordKey!=null){
conditionStr=fieldNameMap.get(recordKey)+'=true';
}
String queryStr='Select Id, Name, Closed_YTD__c,Description__c,Label__c,Active__c,Open_Request__c,New_Sale_Opp__c,Off_Cycle_Opp__c,Prospect_Account__c,Renewal_Opp__c,LG_Group_Account__c,SG_Group_Account__c from Request_Hub_Items__c where Active__c=true and id NOT In:favoritedItemIds'+' AND '+conditionStr+' order by Label__c ASC';
system.debug('queryStr:::::'+queryStr);
requestList=Database.query(queryStr);
system.debug('requestList::'+requestList);

if(requestList!=null){
requestItemsMap.put(2, requestList);
}else{
requestList=new list<Request_Hub_Items__c>();
requestItemsMap.put(2,requestList);//put empty and send back to UI instead of null
}

}catch(Exception e){
system.debug('exception: '+e);
}
return  requestItemsMap;
}
*/
    /**
** @author: Mei Chen
** @Date: 4/20/2018
** @Description: SFDC-9053 & SFDC 8550 retrieve request hub User Favorite item data base on the record Id and object name( account or opportunity). This request is initiated from Request Hub UI.
**/
    
    @auraEnabled
    public static list<Request_Hub_Items__c> getFavoriteItemsList(String recordId, String objectName){
        list<Request_Hub_Items__c> requestList=new list<Request_Hub_Items__c>();
        list<Request_Hub_Items__c> userFavoriteList=new list<Request_Hub_Items__c>();
        list<Request_Hub_Items__c> favoriteList=new list<Request_Hub_Items__c>();
        Id userId=UserInfo.getUserId();//
        
        try{
            Map<String, String> fieldNameMap =getRecordFieldNameMapping();
            String recordKey=getRecordMappingKey(recordId, objectName);
            
            list<Request_Hub_Favorite__c> currentUserFavoristList=new list<Request_Hub_Favorite__c>();
            
            String conditionStr='';
            
            if(recordkey!=null){
                conditionStr='Request_Hub_Items__r.'+fieldNameMap.get(recordKey)+'=true';
            }
            
            String queryStr='Select id, User__c, Request_Hub_Items__c, Request_Hub_Items__r.Label__c from Request_Hub_Favorite__c where user__c=:userId AND Favorite_On__c=true And '+conditionStr;
            system.debug('get favorite list query:'+queryStr);
            currentUserFavoristList=Database.query(queryStr);
            
            //[ Select id, User__c, Request_Hub_Items__c from Request_Hub_Favorite__c where user__c=:userId AND Favorite_On__c=true];
            
            //put the item Ids in a set
            
            Set<Id> favoritedItemIds=new Set<Id>();
            
            for(Request_Hub_Favorite__c cf: currentUserFavoristList){
                favoritedItemIds.add(cf.Request_Hub_Items__c);
            }
            system.debug('current favorited Item Ids: '+favoritedItemIds);
            //  list<Request_Hub_Items__c> favoriteList=new list<Request_Hub_Items__c>();
            if( !favoritedItemIds.isEmpty()){
                userFavoriteList=[Select Id, Name,FavoriteColor__c, Closed_YTD__c,Description__c,Label__c,Active__c,Open_Request__c,New_Sale_Opp__c,Off_Cycle_Opp__c,Prospect_Account__c,Renewal_Opp__c,LG_Group_Account__c,SG_Group_Account__c from Request_Hub_Items__c where Active__c=true and Id In : favoritedItemIds Order by Label__c ASC];        
                if(userFavoriteList!=null && !userFavoriteList.isEmpty()){//update the favorite to orange
                    for(Request_Hub_Items__c req:userFavoriteList){
                        req.FavoriteColor__c='OrangeColor';
                        req.isFavorited__c=true;
                        favoriteList.add(req);
                    }
                    update favoriteList;
                }
            }
        }catch (Exception e){
            system.debug('exception: '+e);
        }
        return favoriteList;
    }
    
    /**
** @author: Mei Chen
** @Date: 4/20/2018
** @Description: SFDC-9053 & SFDC 8550 retrieve request hub item data base on the record Id and object name( account or opportunity). This request is initiated from Request Hub UI.
**/
    
    @auraEnabled
    public static list<Request_Hub_Items__c> getRequestHubItems(String recordId, String objectName){
        
        list<Request_Hub_Items__c> requestList=new list<Request_Hub_Items__c>();
        String conditionStr='';       
        try{
            Map<String, String> fieldNameMap =getRecordFieldNameMapping();
            String recordKey=getRecordMappingKey(recordId, objectName);
            
            if(recordKey!=null){
                conditionStr=fieldNameMap.get(recordKey)+'=true';
            }
            
            list<Request_Hub_Items__c> userFavoriteList=getFavoriteItemsList(recordId, objectName);
            String queryStr='Select Id, Name, FavoriteColor__c,Closed_YTD__c,Description__c,Label__c,Active__c,Open_Request__c,New_Sale_Opp__c,Off_Cycle_Opp__c,Prospect_Account__c,Renewal_Opp__c,LG_Group_Account__c,SG_Group_Account__c from Request_Hub_Items__c where Active__c=true AND Id NOT In:userFavoriteList AND '+conditionStr+' order by Label__c ASC';
            system.debug('queryStr:::::'+queryStr);
            requestList=Database.query(queryStr);
            
            system.debug('requestList::'+requestList);
            
            list<Request_Hub_Items__c> updateItemList=new list<Request_Hub_Items__c>();
            
            if(requestList!=null && !requestList.isEmpty()){
                for(Request_Hub_Items__c item : requestList) {
                    item.FavoriteColor__c='GreyColor';
                    item.isFavorited__c=false;
                    updateItemList.add(item);
                }
                if(!updateItemList.isEmpty()){
                    update updateItemList;
                }
            }
            
        }catch(Exception e){
            system.debug('exception: '+e);
        }
        return requestList;
    }
    
    private static String getRecordMappingKey(String recordId, String objectName){
        String recordTypeName=null;
        
        if(objectName!=null && objectName=='Opportunity'){
            Opportunity opp=[select id, RecordTypeId, recordType.Name, recordType.developerName from Opportunity where id =:recordId];
            if(opp!=null){
                recordTypeName =opp.recordType.developerName;//Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.RecordTypeId).getname();
            }
        }else if(objectName=='Account'){
            Account acc=[select id,Market_Segment__c, RecordTypeId, recordType.developerName, recordType.Name from Account where id =:recordId];
            if(acc!=null){
                recordTypeName =acc.recordType.developerName; //Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(acc.RecordTypeId).getname();
                if(recordTypeName!=null && recordTypeName=='Group_Account' && acc.Market_Segment__c!=null && acc.Market_Segment__c.contains('SG')){
                    recordTypeName='SG';//this is not record type name, but is mapped to the key from the map
                }
            }
        }
        system.debug(' record type name:'+recordTypeName);
        
        return recordTypeName;
    }
    
    private static Map<String, String> getRecordFieldNameMapping(){
        
        Map<String, String> recordFieldNameMap=new Map<String, String>();//record type developer name mapping with field name from request item hub
        recordFieldNameMap.put('Group_Prospect_Account','Prospect_Account__c');
        recordFieldNameMap.put('Group_Account','LG_Group_Account__c');
        recordFieldNameMap.put('New_Sale','New_Sale_Opp__c');
        recordFieldNameMap.put('Off_Cycle_Upsell','Off_Cycle_Opp__c');
        recordFieldNameMap.put('Renewal','Renewal_Opp__c');
        recordFieldNameMap.put('SG','SG_Group_Account__c'); //this one is exception, SG is not record type 
        
        return recordFieldNameMap;
        
    }
    //***************SFDC-9052 Save Favorites functionality: Insert New record for Request_Hub_Favorite__c***************//
    //***************Unfavorites : Delete unfavorited records from Request_Hub_Favorite__c***************//
    
    @auraEnabled
    public static void saveFavoriteItemsList(list<Request_Hub_Items__c> favoriteItems, list<Request_Hub_Items__c> requestItems){
        system.debug('favoriteItems'+favoriteItems);
        system.debug('requestItems'+requestItems);
        Map<Id,Request_Hub_Items__c> favReqItemsMap =new Map<Id,Request_Hub_Items__c>();
        Map<Id,Request_Hub_Items__c> unFavReqItemsMap =new Map<Id,Request_Hub_Items__c>();
        list<Request_Hub_Favorite__c> newFavoriteList=new list<Request_Hub_Favorite__c>();
        list<Request_Hub_Favorite__c> deleteUnFavoriteList=new list<Request_Hub_Favorite__c>();
        list<Request_Hub_Favorite__c> unFavItemsList=new list<Request_Hub_Favorite__c>();
        
        Id userId=UserInfo.getUserId();
        if(favoriteItems!=Null)
        {
            for(Request_Hub_Items__c rhi: favoriteItems){
                if(rhi.FavoriteColor__c== 'GreyColor')
                {
                    unFavReqItemsMap.put(rhi.Id,rhi);                    
                }
                
            }
        }
        if(requestItems!=Null)
        {
            for(Request_Hub_Items__c rhi: requestItems){
                if(rhi.FavoriteColor__c== 'OrangeColor')
                {
                    favReqItemsMap.put(rhi.Id,rhi);                    
                }
                
            }
            
        }
        
        system.debug('unFavReqItemsMap'+unFavReqItemsMap.keySet());
        system.debug('favReqItemsMap'+favReqItemsMap.keySet()); 
        
        unFavItemsList=[select id, User__c, Request_Hub_Items__c, Favorite_On__c from Request_Hub_Favorite__c where user__c=:userId AND Request_Hub_Items__c IN:unFavReqItemsMap.keySet()];
        
        if(!favReqItemsMap.isEmpty()){
            for(Id id :favReqItemsMap.keySet()){
                Request_Hub_Favorite__c newFavorite=new Request_Hub_Favorite__c();
                newFavorite.Request_Hub_Items__c=id;
                system.debug('newFavorite.Request_Hub_Items__c'+newFavorite.Request_Hub_Items__c);
                newFavorite.Favorite_On__c = true;
                newFavorite.User__c=userId;
                newFavoriteList.add(newFavorite);                
            } 
        }
        if(!unFavItemsList.isEmpty()){
            for(Request_Hub_Favorite__c unFavReqItem :unFavItemsList)
            {         
                deleteUnFavoriteList.add(unFavReqItem);
            }
        }
        
        If(newFavoriteList!=null)
        {
            try{
                
                Insert newFavoriteList;
            }Catch(System.DmlException e){
                system.debug('Error Message'+e.getMessage());
            }   
        }
        If(deleteUnFavoriteList!=null){
            try{
                delete deleteUnFavoriteList;
            }Catch(System.DmlException e){
                system.debug('Error Message'+e.getMessage());
            }  
        }
        
    }
    //***************SFDC-9052 END ***************//
    
    //***************SFDC-9356 BEGIN ***************//
    @AuraEnabled 
    public static string fetchProfileName(){
        
        String theProfileName;
        
        Id profileId=userinfo.getProfileId();
        
        theProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        system.debug('fetchProfileName Returned: '+ theProfileName);
        
        return theProfileName;        
    }
    
    @AuraEnabled
    public static boolean checkCSSTaskTypeAccess(){
        
        Boolean theResult = false;
        
        List<SelectOption> recordTypes = new List<SelectOption>();
        
        for(RecordTypeInfo info: Task.SObjectType.getDescribe().getRecordTypeInfos()) {
            // see if the User has access to create this Record Type
            if(info.isAvailable()) {   
                if(info.getName() == 'CSS Task Record Type'){
                    theResult = true;                    
                    break;
                }
            }
        }        
        return theResult;
    }
    
    
    
    //***************SFDC-8918 BEGIN ***************//
    @AuraEnabled
    public static boolean contractAdminAccess(){
        
        Boolean contractAdminAccess = false;
        
        List<SelectOption> recordTypes = new List<SelectOption>();
        
        for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            // see if the User has access to create this Record Type
            if(info.isAvailable()) {   
                if(info.getName() == 'Custom Contracts' || info.getName() == 'Standard Contracts'){
                    
                    contractAdminAccess = true;                    
                    break;
                }
            }
        }        
        return contractAdminAccess;
    }
    @AuraEnabled
    public static string fetchCaseRecordTypeId(String selectedRecordType){
        String recId;
        if(selectedRecordType == 'custom'){
            recId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Custom Contracts').getRecordTypeId();
        }
        else if(selectedRecordType == 'standard'){
            
            recId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Standard Contracts').getRecordTypeId();
        }
        return recId;
        
        
    }
    
    @AuraEnabled
    public static Account fetchCurrentAccountInfo(String recordId){
        
        Account acc=[select Id,Name,HCSC_Division__c,OwnerId,Underwriter_Name__c from Account where Id=:recordId];
        return acc;
        
    }
    //***************SFDC-8918 END ***************//
    
    @AuraEnabled 
    public static string fetchTaskRecordId(String toFind){
        
        Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(toFind).getRecordTypeId();
        
        String theId = String.valueOf(devRecordTypeId);
        
        system.debug('fetchTaskRecordId Returned: '+ theId);
        
        return theId;
    }
    
    
    //***************SFDC-9020 BEGIN ***************//
    
    @AuraEnabled
    public static boolean checkAccountMaintenanceTypeAccess(){
        
        Boolean access = false;
        
        List<SelectOption> recordTypes = new List<SelectOption>();
        
        for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            // see if the User has access to create this Record Type
            if(info.isAvailable()) {   
                if(info.getName() == 'Account Maintenance'){
                    
                    access = true;                    
                    break;
                }
            }
        }        
        return access;
    }
    //Mapping and Fetching the Submission Sub type picklist values.
    @AuraEnabled
    public static List <String> getSSubTypePiklistValues() {
        List<String> plValues = new List<String>();
        
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Case');
        
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('GEMS_Submission_Sub_Type__c').getDescribe();
        
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
        
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        return plValues;
    }
    //Fetching the Submission type picklist values.
    @AuraEnabled
    public static List<String> getSubmissionTypePiklistValues()
    {
        try
        {
            List<String> SubmissionTypeList= new List<String>();
            Schema.DescribeFieldResult fieldResult;
            fieldResult = Case.GEMS_Submission_Type__c.getDescribe();
            
            List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
            //SubmissionTypeList.add('--None--');
            for(Schema.PicklistEntry p:pickList)
            {  
                //Add the picklist values to list.
                SubmissionTypeList.add(p.getValue());
            }
            return SubmissionTypeList;
        }
        catch(Exception e)
        {
            //System.debug(exceptionStr + e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static String getselectOptionsCAM() {
        Case__c casecam = Case__c.getValues('Cosmetic Account Maintenance');
        return casecam.Maintenance_Type__c;
    }
    @AuraEnabled
    public static String getselectOptionsASM() {
        Case__c caseasm = Case__c.getValues('Account Structure Maintenance');
        return caseasm.Maintenance_Type__c;
    }
    @AuraEnabled
    public static String getselectOptionsAEM() {
        Case__c caseaem = Case__c.getValues('Account Eligibility Maintenance');
        return caseaem.Maintenance_Type__c;
    }
    @AuraEnabled
    public static String getselectOptionsRCM() {
        Case__c casercm = Case__c.getValues('Rate Change/Stop Loss Maintenance');
        return casercm.Maintenance_Type__c;
    }
    @AuraEnabled
    public static String getselectOptionsAEPFM() {
        Case__c caseafm = Case__c.getValues('AEP File Maintenance');
        return caseafm.Maintenance_Type__c;
    }
    
    @AuraEnabled
    public static String getselectOptionsICM() {
        Case__c caseicm = Case__c.getValues('ID Card Maintenance');
        return caseicm.Maintenance_Type__c;
    }
    //Creates Account Maintanance Case Record 
    @AuraEnabled
    public static Case insertAMCaseRec(Account accountdetail, Opportunity opportunitydetail, Case newRec, string submissiontype, list<string> submissionsubtype, string Commentsvalue)
    {  
        system.debug('insert '+submissionsubtype);
        string subtypestr = '';
        if(!submissionsubtype.IsEmpty()){
            for(string str:submissionsubtype){
                subtypestr = subtypestr+';'+str;
            }
        }
        try{
            Request_Hub__c reqhubAM = Request_Hub__c.getValues('Account Maintenance');
            //system.debug('insert try'+reqhubAM.Request_Type__c);
            if(accountdetail!=null){
                system.debug('account loop test'+accountdetail);
                newRec.AccountId = accountdetail.Id;
                newRec.GEMS_Submission_Type__c=submissiontype;
                newRec.GEMS_Submission_Sub_Type__c= subtypestr;
                newRec.HCSC_Division__c = accountdetail.HCSC_Division__c;
                newRec.Subject = accountdetail.Name+' '+accountdetail.External_ID__c+' '+ newRec.GEMS_Submission_Type__c;
                newRec.Priority ='Medium';
                newRec.Type = reqhubAM.Request_Type__c;
                newRec.GEMS_Line_of_Business__c = accountdetail.Line_of_business__c;
                newRec.GEMS_Ready_to_release_to_screening__c='Not Released';
                RecordType rec=[select id, Name, DeveloperName From RecordType where Name=:reqhubAM.Request_Type__c];
                
                if(rec!=null){
                    newRec.RecordTypeId=rec.Id;
                }
                // insert newRec;
                // system.debug('rec acc'+newRec);
            }
            else if(opportunitydetail!=null){ 
                system.debug('oppo loop test'+opportunitydetail);
                // newRec.Account = opportunitydetail.Account;
                newRec.Opportunity_Name__c = opportunitydetail.Id;
                newRec.GEMS_Submission_Type__c=submissiontype;
                newRec.GEMS_Submission_Sub_Type__c= subtypestr;
                newRec.HCSC_Division__c = opportunitydetail.HCSC_Division__c;
                newRec.Subject = opportunitydetail.Name+' '+opportunitydetail.External_ID__c+' '+ newRec.GEMS_Submission_Type__c;
                newRec.Priority ='Medium';
                newRec.Type = reqhubAM.Request_Type__c;
                //newRec.GEMS_Line_of_Business__c = accountdetail.Line_of_business__c;
                newRec.GEMS_Ready_to_release_to_screening__c='Not Released';
                RecordType rec=[select id, Name, DeveloperName From RecordType where Name=:reqhubAM.Request_Type__c];
                
                if(rec!=null){
                    newRec.RecordTypeId=rec.Id;
                }
                // insert newRec;
                // system.debug('return rec opp'+newRec);
            }
            insert newRec;
            //system.debug('test insert rec case'+newRec);
            if(Commentsvalue!=null && Commentsvalue!=''){
                //system.debug('test inside if comments');
                CaseComment cc = new CaseComment (ParentID = newRec.id, isPublished=false);
                cc.CommentBody = Commentsvalue;
                insert cc;
            }
            
            system.debug('return suajtha rec acc'+newRec);
            return newRec;
        }    
        catch(Exception e){
            system.debug('insert exception'+e.getMessage());
            return null;
        }
    }
    //Fetching Account Details based on recordId
    @AuraEnabled
    public static Account getaccDetails(Id accountId){
        try{
            // system.debug('**** accountId--> ' + accountId);
            Account acc=[SELECT Accidental_Death_Dismemberment__c,AccountNumber,
                         AccountSource,Account_Case_Count__c,Account_Cluster_Effective_Date__c,
                         Account_Cluster_End_Date__c,Account_Cluster_Name__c,Account_Cluster_Number__c,
                         Account_Cluster_Product_Type__c,Account_Cluster_Region__c,Account_Cluster_User_Identification__c,Account_Executive_2__c,
                         Account_Persistency__c,Account_Reinstate__c,Account_Renewal_Notification_Indicator__c,Account_Type__c,
                         accumms_file_format__c,accums_eff_date__c,accums__c,Active_Dental_Members__c,
                         Active_Dental_Subscribers__c,Active_Health_Members__c,Active_Health_Member_Change_del__c,Active_Health_Subscribers__c,
                         Additional_Information__c,Administrative_Checkbox__c,Alpha_Prefix__c,AnnualRevenue,ASA_Contract_Type__c,ASA_Signed__c,
                         At_Risk__c,AutoCreateOpportunity__c,Automated_Eligibility_Process__c,BCBS_Enrolled_Members__c,BCC_Program_s__c,
                         Beneficiary_Admin_Tool__c,benefits__c,BillingAddress,BillingCountry,Billing_County__c, BillingCity, BillingPostalCode, BillingState, BillingStreet,BillingGeocodeAccuracy,
                         BillingLatitude,BillingLongitude,
                         Bluecard_Mailbox__c,Blue_Clients_in_Similar_Industry__c,Blue_Leader__c,Cancellation_Code__c,Cancellation_Date__c,Cancellation_Explanation__c,
                         Cancellation_Reason__c,Cancellation_Status__c,Cancellation_Submitted_Date__c,Cancelled_Health_Contracts__c,
                         Cancelled_Health_Members__c,Cancels__c,Carve_Out__c,Case_Factor_Score__c,Ceded_From_ICL__c,Ceded_From__c,
                         Ceded_To_ACL__c,Ceded__c,Cede_End_Date__c,CIRC_Name__c,CIRC_URL__c,Claim_Stop_Date__c,CleanStatus,
                         Client_Communication_Resources__c,Client_Competitors__c,Cluster__c,Coalition__c,COBRA_Administration_Type__c,
                         Company_Financial_Health__c,Competitor_Strength_and_Opportunity__c,Competitor_Weaknesses_and_Threats__c,
                         Complexity_Score__c,Connectivity__c,Contract_End__c,Contract_Signer__c,Cooperative__c,CPFieldCompletionRate__c,
                         CreatedById,CreatedDate,Credit_Rating__c,Critical_Account__c,Critical_Illness__c,Current_Risk_Level__c,
                         Custom_Blue_Access_Link__c,DandbCompanyId,Date_of_Prospect__c,DBA_Name__c,DBA_Tax_ID__c,Dental__c,Description,
                         Direct_Indirect_Manager_of_Owner__c,Direct_Market__c,Distribution_Method__c,District__c,DRP__c,DunsNumber,
                         Duration_of_client_in_Prospect_State__c,Effective_Date__c,EIN__c,Electronic_Attachments__c,
                         Eligibility_Vendor_EDI_Analyst_Email__c,Eligibility_Vendor_EDI_Analyst_Name__c,Eligibility_Vendor_EDI_Analyst_Phone__c,
                         Eligibility_Vendor_Name__c,Eligibility__c,Eligible_Members_O65__c,Email__c,Employee_Assistance_Program__c,
                         Employee_Demographics__c,Enrollment_Credits__c,Enrollment_Credit_Allowance__c,Enterprise_National_Account__c,
                         Error_Code__c,Error_Message__c,Exchange_Account__c,Exchange_Name__c,External_ID__c,Facebook__c,Face_to_Community__c,
                         Fax,First_Group_Focus__c,Forecast_Segment__c,Form_Received_Date__c,Fourth_Group_Focus__c,FSU_Location__c,Funding_Type__c,
                         Google__c,Grandfathered_Account__c,Grandfathered_Date__c,Group_Anniversary_Date__c,Group_Exchange_Effective_Date__c,
                         Group_Medicare_Plan__c,Group_Medicare_Type__c,Group_Medicare__c,Group_Number__c,Group_Total_Eligible_Members__c,
                         Growth_Potential__c,HCM_Client_Intensity__c,HCM_Program_Model__c,HCSC_as_Fiduciary__c,HCSC_Client_Since__c,HCSC_Division_Full_State__c,HCSC_Division__c,HCSC_Revenue__c,Health_Dental_Members_Carry_Over_Date__c,Hold_Harmless_Agreement__c,HQ_County__c,Id,Implementation_Credits__c,Implementation_Credit_Allowance__c,Incentive_Exception_Explanation__c,Incentive_Exception_Reason__c,Incentive_Exception__c,Industry,Instagram__c,Integration_Action__c,Integration_Status__c,IsDeleted,Jigsaw,JigsawCompanyId,Key_Locations__c,Labor_fund_ID__c,Labor__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Life__c,Line_of_business__c,LinkedIn__c,Local_Mailbox__c,Long_Term_Disability__c,Market_Capitalization__c,Market_Segment__c,MasterRecordId,Medical__c,membership_File_Frequency__c,membership_file_layout__c,Membership_Gain_Loss__c,Membership_Mailbox__c,membership_mode__c,Mental_Health_Parity__c,MHP_Indicator_Date__c,Migration_additional_information__c,Migration_Source__c,Most_Recent_Financial_Position__c,NaicsCode,NaicsDesc,Name,National_Producer_Number__c,Net_Income__c,New_Active_Dental_Members__c,New_Active_Health_Members__c,New_Carrier_For_Dental_C__c,New_Carrier_For_Dental_G__c,New_Carrier_For_Medical_C__c,New_Carrier_For_Medical_G__c,New_Complexity_Score__c,No_Of_Non_Negotiating_Open_Opps__c,NPN__c,NumberOfEmployees,Number_of_Active_Strategic_Plans__c,Number_of_Negotiating_Opps__c,Number_Of_Open_Opportunities__c,of_BCBS_Enrolled_Subscribers__c,of_Grandfathered_Members__c,of_retiree_members__c,Open_Enrollment_Date__c,Open_Enrollment_End_Date__c,Organizational_Mission__c,Other_HCM_Information__c,Our_Strategy_Response1__c,Our_Strategy_Response2__c,Out_of_Business__c,OwnerId,Ownership,Owner_of_Record__c,Owner_s_Manager_Name__c,ParentId,Parent_Account_Record_Type__c,Phone,PhotoUrl,Pinterest__c,Post_65_Exchange_Effective_Date__c,Post_65_Individual_Private_Exchange__c,Preferred_Producer__c,Preferred_Vendor__c,Premium_Type__c,Previous_Active_Health_Members__c,Pre_65_Exchange_Effective_Date__c,Pre_65_Individual_Private_Exchange__c,Primary_Producer_Account__c,Processing_Method__c,Producer_Number__c,Producer_Organization__c,Projected_Dental_Contracts__c,Projected_Dental_Members__c,Projected_Health_Contracts__c,Projected_Health_Members__c,Prospect_End_Date__c,Prospect_Identifier__c,Rating,Recent_Mergers_Acquisitions_Divestures__c,RecordTypeId,Record_Type_Name__c,Region__c,Regulatory_Requirements__c,Remaining_Days_from_Renewal_Date__c,Renewal_Date__c,renewal_medical_product_count2__c,Renewal_Notification_Date__c,Renewal_Notification_in_days__c,Requested_Cancellation_Date__c,Reserved_Group_Number__c,RFP_Cycle__c,risk_comparison__c,Risk_Reason__c,Risk_Type__c,Rx__c,Sales_Cluster_Effective_Date__c,Sales_Cluster_End_Date__c,Sales_Cluster_Number__c,Sales_Cluster_Product_Type__c,Sales_Cluster_Region__c,Sales_District_Number__c,Sales_Rep_Employee_Number__c,Sales_Team__c,Second_Group_Focus__c,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,shippingCity,Short_Term_Disability__c,Sic,SicDesc,Site,Sliced__c,Small_Group_Cancellation__c,SOD_Row_Id__c,Status__c,SystemModstamp,Tax_ID__c,Third_Group_Focus__c,TickerSymbol,Time_Processed__c,Time_Sent__c,Total_EES__c,Total_Num_of_Potential_Subscribers__c,Total_Projected_Dental_Contracts__c,Total_Projected_Dental_Members__c,Total_Projected_Health_Contracts__c,Total_Projected_Health_Members__c,Total_Value_Of_Open_Opportunity__c,Tradestyle,Travel_Resource__c,TRMN__c,Twitter__c,Type,Underwriter_Effective_Date__c,Underwriter_End_Date__c,Underwriter_Name__c,Underwriter_Team_Code__c,Underwriter_User_ID__c,Underwriter__c,Vision__c,Website,Weighted_Complexity_Score__c,Wellness_Consulting_Coordinator__c,Wellness_Consulting__c,Wellness_Credits__c,Wellness_Credit_Allowance__c,Wellness_Program__c,Willing_to_be_used_as_a_reference__c,X1_31_Account_Status__c,X1_31_Membership__c,X18_Characters_RecordType_ID__c,YearStarted,Youtube__c FROM Account
                         WHERE Id=:accountId];
            
            return acc;
        }catch(Exception e){
            system.debug('*** Exception ex --> ' + e);
        }
        return null;
    }
    //***************SFDC-9020 END ***************//
    
    /**
* @Author: Mei Chen
* @Date: 5/06/2018
*  @Description: this method is to get the record type Id by RecordDevName.
*   SFDC-9234
* *****************************************************************************/
    @auraEnabled
    public static String getRecordTypeId(String recordDevName,String objectName){
        String recdTypeId=null;
        
        try{
            system.debug('recordDevName:'+recordDevName+' object: '+ObjectName);
            RecordType rec=[select id, Name, DeveloperName From RecordType where SObjectType =:objectName and DeveloperName=:recordDevName];
            
            if(rec!=null){
                recdTypeId=rec.Id;
            }
            system.debug('record type id: '+recdTypeId);
        }catch(Exception e){
            system.debug('getrecord type Id exception: '+e);
        }
        
        return recdTypeId;
    }
    
    @auraEnabled
    public Static Boolean getProspectAccountAccess(String recordTypeId){
        
        List<RecordTypeInfo> recordInfos=Account.SObjectType.getDescribe().getRecordTypeInfos();
        
        for(RecordTypeInfo ri:recordInfos){
            if(ri.isAvailable()){
                if(ri.getRecordTypeId()==recordTypeId){
                    system.debug('has access!!!');
                    return true;
                }
            }
        }
        return false;
    }
    
    //Padma Bedampeta - 9055,9056,9235,9470,9471,9473,9476 - Start
    @AuraEnabled
    public static boolean checkCaseRecordTypeAccess(String selectedItem){
        system.debug('selectedItem' + selectedItem);
        Boolean haveAccess = false; 
        
        for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            // see if the User has access to create this Record Type
            if(info.isAvailable()) {   
                if(info.getName() == selectedItem){
                    haveAccess = true;                 
                }
            }
            
        }
        system.debug('haveAccess:::::::::::::'+haveAccess);        
        return haveAccess;
    }    
    
    @AuraEnabled 
    public static Case createCase(String caseRecTypeLabel,String recordId){
        system.debug('recordId::::'+recordId);
        String sObjName;
        Id accountId = Id.valueOf(recordId);  //Any Object ID
        // sObjName = accountId.getSObjectType();
        
        Schema.SObjectType st = accountId.getSobjectType();
        Schema.DescribeSObjectResult dsr = st.getDescribe();
        system.debug('dsr:::'+dsr);
        Case createdCase;
        Case createCase = New Case();
        Account acc;
        Opportunity oppty;
        String prospectAccDevName = 'Group_Prospect_Account';
        String groupAccDevName = 'Group_Account';
        String FundingType;
        
        try{
            
            Id prospectRTId =  getRecordTypeId(prospectAccDevName,'Account'); 
            Id groupRTId =  getRecordTypeId(groupAccDevName,'Account');
            system.debug('prospectRTId Returned: '+ prospectRTId);
            system.debug('groupRTId Returned: '+ groupRTId);
            
            if(dsr.getName() == 'Account'){
                system.debug('fetchCaseRecordtype Returned: '+ caseRecTypeLabel);
                Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRecTypeLabel).getRecordTypeId();
                if(devRecordTypeId != Null){
                    system.debug('fetchCaseRecordId Returned: '+ devRecordTypeId);
                    acc = [Select id,RecordtypeId,Record_Type_Name__c, Projected_Health_Contracts__c,Projected_Health_Members__c,
                           Underwriter__c,Line_of_business__c,Name,External_ID__c,ShippingAddress,HCSC_Division__c,
                           Active_Health_Subscribers__c,Active_Health_Members__c, OwnerId,
                           FSU_Location__c,Funding_Type__c,Premium_Type__c  from Account where Id=:recordId ];  
                    
                    createCase.RecordTypeId = devRecordTypeId;
                    createCase.AccountId = acc.Id;
                    createCase.HCSC_Division__c = acc.HCSC_Division__c;
                    createCase.Subject = acc.Name+' '+caseRecTypeLabel;
                    
                    if(caseRecTypeLabel == 'Proposal'){        
                        createCase.Bypass_Validation__c = true;       
                        if(acc.Funding_Type__c != Null){
                            FundingType = String.valueOf(acc.Funding_Type__c);
                            system.debug('FundingType:::'+FundingType);
                            if(FundingType.toUpperCase().CONTAINS('PREM') && acc.Premium_Type__c != NULL){
                                createCase.Funding_Type_Multiselect__c = acc.Funding_Type__c;
                                createCase.Premium_Type__c = acc.Premium_Type__c;
                            }else{
                                createCase.Funding_Type_Multiselect__c = acc.Funding_Type__c;
                            } 
                        }
                        if(acc.FSU_Location__c == 'Other (specify)'){
                            createCase.FSU_Location__c = acc.FSU_Location__c;
                            createCase.Other_FSU_Location__c = 'Not Specified';
                        }else{
                            createCase.FSU_Location__c = acc.FSU_Location__c;                        
                        }                  
                        system.debug('createCase.Funding_Type__c: '+ createCase.Funding_Type__c);    
                    } 
                    
                    if(caseRecTypeLabel == 'Cede'){ 
                        createCase.Account_Owner__c = acc.OwnerId;
                        if(acc.RecordTypeId == prospectRTId)
                        {
                            createCase.Account_Type__c = 'Prospect';
                            createCase.Expected_Health_Contracts__c = acc.Projected_Health_Contracts__c;
                            createCase.Expected_Health_Members__c =  acc.Projected_Health_Members__c;
                            
                        }else If(acc.RecordTypeId == groupRTId){
                            createCase.Account_Type__c = 'Renewal';
                            createCase.Expected_Health_Contracts__c = acc.Active_Health_Subscribers__c;
                            createCase.Expected_Health_Members__c =  acc.Active_Health_Members__c;
                        }
                        createCase.Funding_Type_Multiselect__c = acc.Funding_Type__c;
                    }
                    if(caseRecTypeLabel == 'Performance Guarantee'){
                        createCase.FSU_Location__c = acc.FSU_Location__c;
                        createCase.Funding_Type_Multiselect__c = acc.Funding_Type__c;
                        createCase.Group_Number_s__c = acc.External_ID__c;                    
                    }
                    
                    if(caseRecTypeLabel == 'Account Cancellation'){
                        createCase.type='Account Cancellation';            
                        createCase.GEMS_Line_of_Business__c = acc.Line_of_business__c;
                        createCase.GEMS_Effective_Date__c = system.today();         
                        createCase.GEMS_Case_Effective_Date__c = system.today();         
                        createCase.subject = acc.Name+' '+acc.External_ID__c+' '+ createCase.type;
                        createCase.Underwriter_Lookup__c = acc.Underwriter__c;
                    }
                }
            }
            else if(dsr.getName() == 'Opportunity'){
                system.debug('fetchCaseRecordtype Returned: '+ caseRecTypeLabel);
                Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRecTypeLabel).getRecordTypeId();
                if(devRecordTypeId != Null){
                    oppty = [Select id,RecordtypeId,Name,Requested_Effective_Date__c,AccountId,
                             Account.Name,Account.Funding_Type__c,Account.External_ID__c,Account.Premium_Type__c,
                             Account.FSU_Location__c, Expected_Health_Contracts_Lex__c, Expected_Health_Members_Lex__c,
                             Account.HCSC_Division__c,Account.RecordTypeId,Account.OwnerId from Opportunity 
                             where Id=:recordId ];
                    createCase.RecordTypeId = devRecordTypeId;
                    createCase.Opportunity_Name__c = oppty.Id;
                    createCase.Subject = oppty.Name+' '+caseRecTypeLabel;
                    createCase.AccountId = oppty.AccountId;
                    createCase.HCSC_Division__c = oppty.account.HCSC_Division__c;
                    
                    if(caseRecTypeLabel == 'Proposal'){        
                        createCase.Bypass_Validation__c = true;
                        createCase.Requested_Effective_Date__c = oppty.Requested_Effective_Date__c;
                        if(oppty.account.Funding_Type__c != Null){
                            FundingType = String.valueOf(oppty.account.Funding_Type__c);
                            if(FundingType.toUpperCase().CONTAINS('PREM') && oppty.account.Premium_Type__c != NULL){
                                createCase.Funding_Type_Multiselect__c = oppty.account.Funding_Type__c;
                                createCase.Premium_Type__c = oppty.account.Premium_Type__c;
                            }else{
                                createCase.Funding_Type_Multiselect__c = oppty.account.Funding_Type__c;
                            } 
                            system.debug('createCase.Funding_Type__c: ');
                        }                        
                        if(oppty.account.FSU_Location__c == 'Other (specify)'){
                            createCase.FSU_Location__c = oppty.account.FSU_Location__c;
                            createCase.Other_FSU_Location__c = 'Not Specified';
                        }else{
                            createCase.FSU_Location__c = oppty.account.FSU_Location__c;                        
                        }                  
                        // system.debug('createCase.Funding_Type__c: '+ createCase.Funding_Type__c);    
                    } 
                    
                    if(caseRecTypeLabel == 'Cede'){ 
                        createCase.Expected_Health_Contracts__c = oppty.Expected_Health_Contracts_Lex__c;
                        createCase.Expected_Health_Members__c =  oppty.Expected_Health_Members_Lex__c  ;
                        createCase.Account_Owner__c = oppty.Account.OwnerId;
                        system.debug('prospectRTId'+prospectRTId);
                        system.debug('groupRTId'+groupRTId);
                        if(oppty.account.RecordTypeId == prospectRTId)
                        {
                            createCase.Account_Type__c = 'Prospect';
                        }else If(oppty.account.RecordTypeId == groupRTId){
                            createCase.Account_Type__c = 'Renewal';
                        }
                    }
                    
                    if(caseRecTypeLabel == 'Performance Guarantee'){
                        createCase.FSU_Location__c = oppty.account.FSU_Location__c;
                        createCase.Funding_Type_Multiselect__c = oppty.account.Funding_Type__c;
                        createCase.Group_Number_s__c = oppty.account.External_ID__c;                    
                    }
                    if(caseRecTypeLabel == 'Private Exchange - External'){
                        if(oppty.Requested_Effective_Date__c != Null){
                            createCase.Effective_Date__c = oppty.Requested_Effective_Date__c; 
                        }
                    }
                }
            }
            try{
                system.debug('Entered:::try block');
                insert createCase;
            }
            catch(Exception e){
                system.debug('Error Message'+e.getMessage());
                throw new AuraHandledException('Unexpected system error has occured: ' + e.getMessage());
            }
            if(createCase.id != NULL){
                createdCase = [select id, caseNumber from Case where id=:createCase.id];             
            }
        }      
        catch(Exception e){
            system.debug('Error Message'+e.getMessage());
            throw new AuraHandledException('Unexpected system error has occured: ' + e.getMessage()); 
        }
        
        return createdCase; 
    }
    //Padma Bedampeta - 9055,9056,9235 - End
    //Padma Bedampeta - SGFDC-9269 -Start
    @AuraEnabled 
    public static List<SI_Record_Types__c> getSIRecordTypesList(String selectedItem,String recordId, String objectName){
        system.debug('selectedItem:::::::::'+selectedItem);
        system.debug('recordId:::::::::'+recordId);
        system.debug('objectName:::::::::'+objectName);
        Opportunity oppty;
        List<SI_Record_Types__c> selectedStateSIRTList = new List<SI_Record_Types__c>();
        List<SI_Record_Types__c> availableSIRecordTypes =  new List<SI_Record_Types__c>();
        
        if(recordId != NULL){
            oppty = getOpportunityDetails(recordId);//[Select id, HCSC_Division__c from Opportunity where id =: recordId]; 
            system.debug('oppty.HCSC_Division__c :::::'+oppty.HCSC_Division__c);
        }
        
        if(oppty.HCSC_Division__c != NULL) {
            
            availableSIRecordTypes = [Select id,HCSC_Division__c,SI_Request_Hub_UI_Label__c 
                                      from SI_Record_Types__c 
                                      where HCSC_Division__c =: oppty.HCSC_Division__c OR
                                      HCSC_Division__c =: 'ALL' ORDER BY SI_Request_Hub_UI_Label__c ASC];
            system.debug('availableSIRecordTypes::'+availableSIRecordTypes);
            
        }
        
        if(availableSIRecordTypes.size() > 0){
            for (SI_Record_Types__c SIRecLabel :  availableSIRecordTypes){
                //  SIRecLabel.SI_Record_Type_Label__c;
                selectedStateSIRTList.add(SIRecLabel);
            }
        }
        return selectedStateSIRTList;
    }
    @AuraEnabled 
    public static String fetchSIRecordTypeId(String recordTypeLabel){
        //ID devRecordTypeId = '';
        String returnValue;
        system.debug('recordTypeLabel::::::::::'+recordTypeLabel);
        //String SIRecordTypeLabel = SI_Record_Types__c.getValues('recordTypeLabel').SI_Record_Type_Label__c;
        SI_Record_Types__c SIRecordTyperec = [Select Id,Name,SI_Request_Hub_UI_Label__c,SI_Record_Type_API_Name__c from SI_Record_Types__c 
                                              where SI_Request_Hub_UI_Label__c =:recordTypeLabel];
        System.debug('SIRecordTyperec:::::'+SIRecordTyperec);
        String recordDevName = SIRecordTyperec.SI_Record_Type_API_Name__c;     
        RecordType rec=[select Id, Name, DeveloperName From RecordType where SObjectType = 'Secure_Information__c' and DeveloperName=:recordDevName];
        
        List<RecordTypeInfo> recordInfos=Secure_Information__c.SObjectType.getDescribe().getRecordTypeInfos();
        for(RecordTypeInfo ri:recordInfos){
            if(ri.isAvailable()){
                if(ri.getRecordTypeId()==rec.Id){
                    system.debug('has access!!!');
                    returnValue = String.valueOf(rec.Id);
                    break;
                }
                else {
                    returnValue = 'No Access';
                }
            }
        }
        system.debug('Returned: '+returnValue);
        return returnValue;
    }
    @AuraEnabled
    public static Opportunity getOpportunityDetails(Id recordId){
        Opportunity oppty;
        system.debug('recordId'+recordId);
        if(recordId != NULL){
            try{
                oppty = [Select id, Name, AccountId,HCSC_Division__c from Opportunity where id =: recordId];
                
            }catch(Exception e){
                system.debug('Error Message'+e.getMessage());
                // throw new AuraHandledException('Unexpected system error has occured: '+ e.getMessage()); 
            }  
        }
        return oppty;
    } 
    //Padma Bedampeta - SGFDC-9269 -END
    @AuraEnabled
    public static boolean isSGAccount(String recordId) {
        
        list<Market_Segment__c> sgsmList = [select id, name, value__c, type__c from market_segment__c where type__c = 'SG'];
        Account acc = [Select id,Market_Segment__c from Account where Id=:recordId ];  
        String marketSegment=acc.Market_Segment__c;
        Boolean isSGAcc = false;
        if(marketSegment == 'SG'){
            system.debug('marketSegment SG'+marketSegment);
            isSGAcc = True;
        }
        else if (sgsmList != null && sgsmList.size() > 0 && marketSegment != null && marketSegment != '') {
            for (Market_Segment__c sm : sgsmList) {
                if (sm != null && sm.value__c.containsIgnoreCase(marketSegment)) {
                    isSGAcc = True;                 
                    break;
                }
            }
        }
        return isSGAcc;
    }
    //SFDC9041
    @AuraEnabled
    public static boolean checkSRAccess(string selectedItem){
        Boolean haveAccess = false;       
        for(RecordTypeInfo info: Service_Request__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            // see if the User has access to create this Record Type
            if(info.isAvailable()) {   
                if(info.getName() == selectedItem){
                    haveAccess = true;                 
                }
            }
        }
        return haveAccess;
    }
    
    /* @AuraEnabled
public static Opportunity getfullOpportunityDetails(Id recordId){
Opportunity oppdetail;
Account AccDet;
system.debug('recordId'+recordId);
if(recordId != NULL){
try{
oppdetail = [Select id, Name, AccountId,HCSC_Division__c from Opportunity where id =: recordId];
AccDet = [select id, name, Market_Segment__c, Line_of_business__c, District__c, Cluster__c, Open_Enrollment_Date__c, HCSC_Division__c, Region__c from Account where id = :oppdetail.AccountId limit 1];
}catch(Exception e){
system.debug('Error Message'+e.getMessage());
//throw new AuraHandledException('Unexpected system error has occured: '+ e.getMessage()); 
}  
}
return oppdetail;
} */
    
    /***************************************************************************************
* Method : createRequest (SFDC-9626)
* Parameters : None
* Return : URL for the newly created Contract Admin Request. 
* Description : This method creates new Contract Admin Request if there are no existing requests assigned to the Opportunity. 
*              This method is called from the screen on hitting Continue button after filling details in the Request Hub. 
***************************************************************************************/
    @AuraEnabled
    public static GEMS_Contract_Admin_Request__c createContractAdminRequest(String caseRecTypeLabel,String recordId)
    {
        system.debug('>>>> Continue Button -> createRequest()');
        Id SelectRequestID; Boolean exists;
        GEMS_Contract_Admin_Request__c newContractRequest = new GEMS_Contract_Admin_Request__c();
        
        //Check whether a SBC/BB request already exists for this opportunity. 
        
        // SelectRequestID=checkRequestExists(recordId);
        //Proceed only if the Contract Admin request does not exist.
        //if(SelectRequestID==null)
        // {
        
        try{
            Opportunity OppDet = [select id, name, AccountId, Requested_Effective_Date__c from Opportunity where id = :recordId limit 1];
            Account AccDet = [select id, name, Market_Segment__c, Line_of_business__c, District__c, Cluster__c, Open_Enrollment_Date__c, HCSC_Division__c, Region__c from Account where id = :OppDet.AccountId limit 1];
            
            newContractRequest.RecordTypeId = Schema.SObjectType.GEMS_Contract_Admin_Request__c.getRecordTypeInfosByName().get('GEMS SBC & Benefit Booklet Request').getRecordTypeId();
            newContractRequest.OwnerId = userInfo.getUserId();
            newContractRequest.Opportunity_Link__c = recordId;
            newContractRequest.Created_Date_Time__c = system.now();
            newContractRequest.Market_Segment__c = AccDet.Market_Segment__c;
            newContractRequest.District__c = AccDet.District__c;
            newContractRequest.Cluster__c = AccDet.Cluster__c;
            newContractRequest.Open_Enrollment_Start_Date__c = AccDet.Open_Enrollment_Date__c;
            newContractRequest.Effective_Date__c = OppDet.Requested_Effective_Date__c;
            newContractRequest.Hidden_HCSC_Division__c = AccDet.HCSC_Division__c;
            newContractRequest.Region__c = AccDet.Region__c;
            newContractRequest.Line_of_Business__c = AccDet.Line_of_business__c;
            insert newContractRequest;
            // returnURL = new pageReference('/'+newContractRequest.Id);
        }
        catch(Exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Account/Opportunity', null, 'ServiceRequestController.createRequest()','High');  
            system.debug(e);
        }
        //}
        //else
        // newContractRequest.id=SelectRequestID;
        
        if(newContractRequest.id != NULL){
            newContractRequest = [select id, name from GEMS_Contract_Admin_Request__c where id=:newContractRequest.id limit 1];   
            //System.debug('newContractRequest'+newContractRequest);
            
            
        }
        
        return newContractRequest;
    } 
    /***************************************************************************************
* Method : checkRequestExists (SFDC-9626)
* Parameters : None
* Return : None
* Description : Checks whether a Contract Admin Request already exists for Opportunity and sets the flag requestExists accordingly. 
***************************************************************************************/
    
    public static String checkRequestExists(Id recordId){
        String SelectRequestID;
        system.debug('recordId'+recordId); 
        List<GEMS_Contract_Admin_Request__c> SelectRequestIDList=[select id from GEMS_Contract_Admin_Request__c where Opportunity_Link__c = :recordId limit 1];
        if(SelectRequestIDList.size()>0)
            SelectRequestID=SelectRequestIDList[0].id;
        
        system.debug('SelectRequestID'+SelectRequestID);
        return SelectRequestID;
    } 
    @AuraEnabled
    public static String contractAdminRequestRecordTypeAccess(Id recordId){        
        String access = 'false';   
        List<SelectOption> recordTypes = new List<SelectOption>();        
        for(RecordTypeInfo info: GEMS_Contract_Admin_Request__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            System.debug(info.getName());
            // see if the User has access to create this Record Type
            if(info.isAvailable()) {   
                if(info.getName() == 'GEMS SBC & Benefit Booklet Request'){                    
                    access = 'true';                    
                    break;
                }
                
            }
        } 
        if(access == 'true')
        {
            System.debug('access'+access);
            access=checkRequestExists(recordId);System.debug('access'+access);
        }
        return access;
    }
}