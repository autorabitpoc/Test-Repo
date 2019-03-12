/* Developer                   Date                   Description
* ----------------------------------------------------------------------------

*  Ranjit Gandhi       03/27/2018               SFDC-8771 Group Account - Renewal Opportunity Button
*  Sujatha Gondi       09/18/2017                Original Version
*************************************************************************************/

public with sharing class LGNA_CreateOffCycleOpportunity {
   
   //public static Map<Id, String> recordtypemap {get;set;}
    
   // This method to get record type Id from a label. 
       
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){        
        return LGNA_LightningGlobal.getOpportunityRecTypeId(recordTypeLabel);
    }  
    
     /*************************************************************************************************************************************
    *  getaccDetails
    *   @description:  Method is used to Fetch Account Details
    *   @parameters : Account Id
    *   @return type : Account Object
    *******************************************************************************************************************************************/
    @AuraEnabled
    public static Account getAccDetails(Id accountId){
        try{
                  system.debug('**** accountId--> ' + accountId);
            Account acc=[SELECT Accidental_Death_Dismemberment__c,AccountNumber,
                         AccountSource,Account_Case_Count__c,Account_Cluster_Effective_Date__c,
                         Account_Cluster_End_Date__c,Account_Cluster_Name__c,Account_Cluster_Number__c,
                         Account_Cluster_Product_Type__c,Account_Cluster_Region__c,Account_Cluster_User_Identification__c,Account_Executive_2__c,
                         Account_Persistency__c,Account_Reinstate__c,Account_Renewal_Notification_Indicator__c,Account_Type__c,
                         accumms_file_format__c,accums_eff_date__c,accums__c,Active_Dental_Members__c,
                         Active_Dental_Subscribers__c,Active_Health_Members__c,Active_Health_Member_Change_del__c,Active_Health_Subscribers__c,
                         Additional_Information__c,Administrative_Checkbox__c,Alpha_Prefix__c,AnnualRevenue,ASA_Contract_Type__c,ASA_Signed__c,
                         At_Risk__c,AutoCreateOpportunity__c,Automated_Eligibility_Process__c,BCBS_Enrolled_Members__c,BCC_Program_s__c,
                         Beneficiary_Admin_Tool__c,benefits__c,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,
                         BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,Billing_County__c,
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
                         Duration_of_client_in_Prospect_State__c,Effective_Date__c,Electronic_Attachments__c,
                         Eligibility_Vendor_EDI_Analyst_Email__c,Eligibility_Vendor_EDI_Analyst_Name__c,Eligibility_Vendor_EDI_Analyst_Phone__c,
                         Eligibility_Vendor_Name__c,Eligibility__c,Eligible_Members_O65__c,Email__c,Employee_Assistance_Program__c,
                         Employee_Demographics__c,Enrollment_Credits__c,Enrollment_Credit_Allowance__c,Enterprise_National_Account__c,
                         Error_Code__c,Error_Message__c,Exchange_Account__c,Exchange_Name__c,External_ID__c,Facebook__c,Face_to_Community__c,
                         Fax,First_Group_Focus__c,Forecast_Segment__c,Form_Received_Date__c,Fourth_Group_Focus__c,FSU_Location__c,Funding_Type__c,
                         Google__c,Grandfathered_Account__c,Grandfathered_Date__c,Group_Anniversary_Date__c,Group_Exchange_Effective_Date__c,
                         Group_Medicare_Plan__c,Group_Medicare_Type__c,Group_Medicare__c,Group_Number__c,Group_Total_Eligible_Members__c,
                         Growth_Potential__c,HCM_Client_Intensity__c,HCM_Program_Model__c,HCSC_as_Fiduciary__c,HCSC_Client_Since__c,HCSC_Division_Full_State__c,HCSC_Division__c,HCSC_Revenue__c,Health_Dental_Members_Carry_Over_Date__c,Hold_Harmless_Agreement__c,HQ_County__c,Id,Implementation_Credits__c,Implementation_Credit_Allowance__c,Incentive_Exception_Explanation__c,Incentive_Exception_Reason__c,Incentive_Exception__c,Industry,Instagram__c,Integration_Action__c,Integration_Status__c,IsDeleted,Jigsaw,JigsawCompanyId,Key_Locations__c,Labor_fund_ID__c,Labor__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Life__c,Line_of_business__c,LinkedIn__c,Local_Mailbox__c,Long_Term_Disability__c,Market_Capitalization__c,Market_Segment__c,MasterRecordId,Medical__c,membership_File_Frequency__c,membership_file_layout__c,Membership_Gain_Loss__c,Membership_Mailbox__c,membership_mode__c,Mental_Health_Parity__c,MHP_Indicator_Date__c,Migration_additional_information__c,Migration_Source__c,Most_Recent_Financial_Position__c,NaicsCode,NaicsDesc,Name,National_Producer_Number__c,Net_Income__c,New_Active_Dental_Members__c,New_Active_Health_Members__c,New_Carrier_For_Dental_C__c,New_Carrier_For_Dental_G__c,New_Carrier_For_Medical_C__c,New_Carrier_For_Medical_G__c,New_Complexity_Score__c,No_Of_Non_Negotiating_Open_Opps__c,NPN__c,NumberOfEmployees,Number_of_Active_Strategic_Plans__c,Number_of_Negotiating_Opps__c,Number_Of_Open_Opportunities__c,of_BCBS_Enrolled_Subscribers__c,of_Grandfathered_Members__c,of_retiree_members__c,Open_Enrollment_Date__c,Open_Enrollment_End_Date__c,Organizational_Mission__c,Other_HCM_Information__c,Our_Strategy_Response1__c,Our_Strategy_Response2__c,Out_of_Business__c,OwnerId,Ownership,Owner_of_Record__c,Owner_s_Manager_Name__c,ParentId,Parent_Account_Record_Type__c,Phone,PhotoUrl,Pinterest__c,Post_65_Exchange_Effective_Date__c,Post_65_Individual_Private_Exchange__c,Preferred_Producer__c,Preferred_Vendor__c,Premium_Type__c,Previous_Active_Health_Members__c,Pre_65_Exchange_Effective_Date__c,Pre_65_Individual_Private_Exchange__c,Processing_Method__c,Producer_Number__c,Producer_Organization__c,Projected_Dental_Contracts__c,Projected_Dental_Members__c,Projected_Health_Contracts__c,Projected_Health_Members__c,Prospect_End_Date__c,Prospect_Identifier__c,Rating,Recent_Mergers_Acquisitions_Divestures__c,RecordTypeId,Record_Type_Name__c,Region__c,Regulatory_Requirements__c,Remaining_Days_from_Renewal_Date__c,Renewal_Date__c,renewal_medical_product_count2__c,Renewal_Notification_Date__c,Renewal_Notification_in_days__c,Requested_Cancellation_Date__c,Reserved_Group_Number__c,RFP_Cycle__c,risk_comparison__c,Risk_Reason__c,Risk_Type__c,Rx__c,Sales_Cluster_Effective_Date__c,Sales_Cluster_End_Date__c,Sales_Cluster_Number__c,Sales_Cluster_Product_Type__c,Sales_Cluster_Region__c,Sales_District_Number__c,Sales_Rep_Employee_Number__c,Sales_Team__c,Second_Group_Focus__c,ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,Short_Term_Disability__c,Sic,SicDesc,Site,Sliced__c,Small_Group_Cancellation__c,SOD_Row_Id__c,Status__c,SystemModstamp,Tax_ID__c,Third_Group_Focus__c,TickerSymbol,Time_Processed__c,Time_Sent__c,Total_EES__c,Total_Num_of_Potential_Subscribers__c,Total_Projected_Dental_Contracts__c,Total_Projected_Dental_Members__c,Total_Projected_Health_Contracts__c,Total_Projected_Health_Members__c,Total_Value_Of_Open_Opportunity__c,Tradestyle,Travel_Resource__c,TRMN__c,Twitter__c,Type,Underwriter_Effective_Date__c,Underwriter_End_Date__c,Underwriter_Name__c,Underwriter_Team_Code__c,Underwriter_User_ID__c,Underwriter__c,Vision__c,Website,Weighted_Complexity_Score__c,Wellness_Consulting_Coordinator__c,Wellness_Consulting__c,Wellness_Credits__c,Wellness_Credit_Allowance__c,Wellness_Program__c,Willing_to_be_used_as_a_reference__c,X1_31_Account_Status__c,X1_31_Membership__c,X18_Characters_RecordType_ID__c,YearStarted,Youtube__c FROM Account
                WHERE Id=:accountId];
            
            return acc;
        }catch(Exception e){
            system.debug('*** Exception ex --> ' + e);
        }
        return null;
    }

}