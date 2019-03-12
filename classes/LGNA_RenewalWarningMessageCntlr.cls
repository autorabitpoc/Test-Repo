/**************************************************************************************
Apex Class Name     : LGNA_RenewalWarningMessageCntlr 
Version             : 1.0
Function            : This is Opportunity Data 
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------

*  Ranjit Gandhi       03/27/2018               SFDC-8771 Group Account - Renewal Opportunity Button
*  Sujatha Gondi       09/18/2017                Original Version
*************************************************************************************/
public class LGNA_RenewalWarningMessageCntlr {
   
    @auraEnabled
    public static string getOpportunityRenewalList(String accountId,String recordtypeId){
        string checkopp;
        system.debug('****** inside getOpportunitylist');
        
        list<Opportunity> oppRecordslist = new list<Opportunity>();
        Integer Year = Date.Today().Year();
        oppRecordslist = [SELECT Id,AccountId,Account_Industry__c,Account_Market_Segment__c,Administrative_Checkbox__c,
                      Amount,At_Risk__c,BCC_Program_s__c,Bull_s_Eye__c,Business_Days_Before_Due_Date__c,Bypass_Validation__c,
                      CampaignId,Census_Report_Received__c,Client_Received_Paperwork__c,CloseDate,Closed_Comments__c,
                      Clusters__c,Competitors__c,Concerns_Issues__c,ContractId,County_Report_Received__c,CreatedById,
                      CreatedDate,Date_Closed__c,Date_Nexus_Delivered_to_GPD_AE__c,Date_Nexus_Results_Received__c,
                      Date_Nexus_Results_Requested__c,Date_Quote_Delivered_to_GPD_AE__c,Date_Quote_Received_from_GPD_UW__c,Date_Sent_to_GPD_UW__c,DB_Competitor__c,Description,Direct_Indirect_Manager_of_Owner__c,District__c,Due_Date_Notification_in_Days__c,Effective_Month__c,Exchange_Offering_Type__c,ExpectedRevenue,Expected_Decision_Date__c,Expected_Dental_Contracts__c,Expected_Dental_Members__c,Expected_Health_Contracts__c,Expected_Health_Members__c,Expected_RFP_Release_Date__c,External_ID__c,Finalist_Meeting__c,Finalist_Named__c,Finalist__c,Final_Comments__c,Fiscal,FiscalQuarter,FiscalYear,ForecastCategory,ForecastCategoryName,Forecast_Segment__c,FSU_Location__c,full_prob_count__c,Full_Product_Count__c,Group_Medicare_Plan__c,Group_Medicare__c,HasOpenActivity,HasOpportunityLineItem,HasOverdueTask,HCM_Client_Intensity__c,HCM_Program_Model__c,HCM_Response_Submitted_Date__c,HCSC_Division__c,Incumbent__c,Initial_Comments__c,IsAutoCreated__c,IsClosed,IsDeleted,IsPrivate,IsWon,Kick_Off_Date__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,LeadSource,Membership_Gain_Loss_Probability__c,Migration_additional_information__c,Migration_Source__c,Missed_Last_Week__c,Name,NextStep,Nexus_Information__c,Non_Admin_Last_Modified_Date__c,Number_Of_Misses__c,Opportunity_Case_Count__c,Opportunity_Due_Date_Notification_Date__c,Opp_Prod_Prob__c,Other_FSU_Location__c,Other_HCM_Information__c,Other_Incumbent__c,Our_Strategy_Response__c,OwnerId,Owner_of_Record__c,Owner_s_Manager_Name__c,Parent_Opportunity__c,Perceived_Vulnerabilities_Threats__c,Playbook__c,Pricebook2Id,Primary_Closed_Reason__c,Private_Exchange_Blue_Directions_Count__c,Private_Exchange_External_Count__c,Probability,Product_Count__c,Product_Members__c,Product__c,Projected_Membership_Gain_Loss__c,Proposal_Case_Created__c,Push_Counter__c,Rate_End_Date__c,RecordTypeId,Region__c,Renewal_Date__c,renewal_medical_product_count__c,Requested_Effective_Date__c,Request_Received_Date__c,RFI_RFP_Received_Date__c,RFP_Notification_Time__c,risk_comparison__c,Risk_Data_Received__c,Special_Exceptions__c,StageName,Status__c,SyncedQuoteId,SystemModstamp,TotalOpportunityQuantity,Type,Underwriting_Case_Closed_Date_Time__c,Underwriting_Case_Closed__c,Underwriting_Case_Created__c,Underwriting_Case_Submitted__c,Weekly_Activity_Added_Date__c,Weekly_Activity_Modified_Date__c,Weekly_Activity_Report__c,weighted_projected_medical_health_member__c,Wellness_Consulting_Coordinator__c,Wellness_Consulting__c,Win_Prob_on_Won__c FROM Opportunity
                                                          WHERE AccountId=:accountId and RecordTypeId=:recordtypeId
                          and CALENDAR_YEAR(Renewal_Date__c) =: Year limit 1];
 
        
         system.debug('******oppRecordslist'+oppRecordslist.size());
        if(oppRecordslist.size()>0){
          
            checkopp ='hasopprenewalrec';
        }else {
            checkopp  ='hasnotopprenewalrec';
    }
      return checkopp ;
    }
    
}