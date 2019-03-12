<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Setup_QR_Approval_Rejection</fullName>
        <description>Account Setup QR Approval Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case/Account_Setup_QR_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Account_Setup_WT_Approval_Rejectio</fullName>
        <description>Account Setup WT Approval Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case/Account_Setup_WT_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Client_Approval_Received</fullName>
        <description>Account Strcuture Client Approval - Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Client_Approval_Received</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Client_Approval_Received_CDHP</fullName>
        <description>Account Strcuture Client Approval - Received - CDHP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Client_Approval_Received</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Client_Approval_Received_Dental</fullName>
        <description>Account Strcuture Client Approval - Received - Dental</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Client_Approval_Received</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Client_Approval_Received_EEE</fullName>
        <description>Account Strcuture Client Approval - Received - EEE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Client_Approval_Received</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Internal_Approval_Pending</fullName>
        <description>Account Strcuture Internal Approval - Pending</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Pending</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Internal_Approval_Pending_CDHP</fullName>
        <description>Account Strcuture Internal Approval - Pending - CDHP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Pending</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Internal_Approval_Pending_Dental</fullName>
        <description>Account Strcuture Internal Approval - Pending - Dental</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Pending</template>
    </alerts>
    <alerts>
        <fullName>Account_Strcuture_Internal_Approval_Pending_EEE</fullName>
        <description>Account Strcuture Internal Approval - Pending - EEE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Pending</template>
    </alerts>
    <alerts>
        <fullName>Account_Structure_Cancellation_Notification_when_case_status_is_Submitted</fullName>
        <description>Account Structure Cancellation Notification when case status is Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Acc_Cancellation_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>BA_Level_Account_Setup_email_alert</fullName>
        <description>BA Level Account Setup email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BALevelAccountSetupEmailAlert</template>
    </alerts>
    <alerts>
        <fullName>BA_Level_BA_Level_Dental_Benefit_Coding_email_alert</fullName>
        <description>BA Level BA Level Dental Benefit Coding email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_GEMS_BALevelDentalBenefitCodingEmailAlert</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Fail</fullName>
        <description>BlueSTAR Notification - Fail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Fail</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Fail_CDHP</fullName>
        <description>BlueSTAR Notification - Fail - CDHP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Fail</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Fail_Dental</fullName>
        <description>BlueSTAR Notification - Fail - Dental</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Fail</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Fail_EEE</fullName>
        <description>BlueSTAR Notification - Fail - EEE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Fail</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Partial</fullName>
        <description>BlueSTAR Notification - Partial</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Partial</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Partial_CDHP</fullName>
        <description>BlueSTAR Notification - Partial - CDHP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Partial</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Partial_Dental</fullName>
        <description>BlueSTAR Notification - Partial - Dental</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Partial</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Partial_EEE</fullName>
        <description>BlueSTAR Notification - Partial - EEE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Partial</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Send</fullName>
        <description>BlueSTAR Notification - Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Send</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Send_CDHP</fullName>
        <description>BlueSTAR Notification - Send - CDHP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Send</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Send_Dental</fullName>
        <description>BlueSTAR Notification - Send - Dental</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Send</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Send_EEE</fullName>
        <description>BlueSTAR Notification - Send - EEE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Send</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Success</fullName>
        <description>BlueSTAR Notification - Success</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Success</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Success_CDHP</fullName>
        <description>BlueSTAR Notification - Success - CDHP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Success</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Success_Dental</fullName>
        <description>BlueSTAR Notification - Success - Dental</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Success</template>
    </alerts>
    <alerts>
        <fullName>BlueSTAR_Notification_Success_EEE</fullName>
        <description>BlueSTAR Notification - Success - EEE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BlueSTAR_Status_Success</template>
    </alerts>
    <alerts>
        <fullName>Case_Assigned</fullName>
        <description>Case Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Case_Received_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Case_closed</fullName>
        <description>Case closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Sales_Executive__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Case_Complete_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Client_Approval_Received_Bluestar_Transfer_Notification_Alert</fullName>
        <description>Client Approval Received Bluestar Transfer Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/Client_Approval_Received_Bluestar_Transfer</template>
    </alerts>
    <alerts>
        <fullName>Email</fullName>
        <description>Email Dearborn IL - Blue Directions Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Dearborn_IL_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_Fully_Executed</fullName>
        <description>Notify Custom Contract Owner Case is updated to be Fully Executed</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case/PG_Case_Closed_Email_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Email_Blue_Directions_Private_Exchange_When_Case_Modified</fullName>
        <description>Email Blue Directions Private Exchange When Case Modified</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Private_Exchange_Case_Folder/Case_Modified_Queue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Dearborn_Other_Blue_Directions_Group</fullName>
        <description>Email Dearborn Other - Blue Directions Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Dearborn_Other_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Dental_UW_Blue_Directions_Group</fullName>
        <description>Email Dental UW - Blue Directions Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Dental_UW_Private_Exchange</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_External_Private_Exchange_When_Case_Modified</fullName>
        <description>Email External Private Exchange When Case Modified</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_External</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Private_Exchange_Case_Folder/Case_Modified_Queue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Medical_MT_151_Blue_Directions_Group</fullName>
        <description>Email Medical MT &lt;151 - Blue Directions Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Medical_MT_151_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Medical_OK_151_Blue_Directions_Group</fullName>
        <description>Email Medical OK &lt;151 - Blue Directions Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Medical_OK_151_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Medical_UW_Blue_Directions</fullName>
        <description>Email Medical UW - Blue Directions</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Medical_UW_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Medical_UW_External_Exchange</fullName>
        <description>Email Medical UW - External Exchange</description>
        <protected>false</protected>
        <recipients>
            <recipient>LGNA_Medical_UW_External_Exchange</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_EEE_CDHP</fullName>
        <description>Email Notification to EEE + CDHP</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_EEE_CDHP_Dental</fullName>
        <description>Email Notification to EEE + CDHP + Dental</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_Dental_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_EEE_Dental</fullName>
        <description>Email Notification to EEE + Dental</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Dental_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_PG_Case_Creator_When_Case_Closed</fullName>
        <description>Email PG Case Creator When Case Closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/PG_Case_Closed_Email_Creator</template>
    </alerts>
    <alerts>
        <fullName>Email_PG_Case_Creator_when_Status_is_Send_Back_for_More_Info</fullName>
        <description>Email PG Case Creator when Status is Send Back for More Info</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/PG_Email_Creator_for_More_Info</template>
    </alerts>
    <alerts>
        <fullName>Email_PG_Case_Requestor_When_Case_Closed</fullName>
        <description>Email PG Case Requestor When Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>Requested_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/PG_Case_Closed_Email_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Email_PG_Case_Requestor_when_Status_is_Send_Back_for_More_Info</fullName>
        <description>Email PG Case Requestor when Status is Send Back for More Info</description>
        <protected>false</protected>
        <recipients>
            <field>Requested_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/PG_Email_Requestor_for_More_Info</template>
    </alerts>
    <alerts>
        <fullName>Email_PG_Group_when_case_with_PG_Yes_is_created_or_modified</fullName>
        <ccEmails>PG_Group@bcbsil.com</ccEmails>
        <description>Email PG Group when case with PG=Yes is created or modified</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_PG_Notification_Template_for_Account_Submission</template>
    </alerts>
    <alerts>
        <fullName>Email_Private_Exchange_Blue_Directions_Group</fullName>
        <description>Email Private Exchange - Blue Directions Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Email_Private_Exchange_External_Group</fullName>
        <description>Email Private Exchange - External Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_External</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>GEMSAccountStructureApprovalReminder</fullName>
        <description>Send reminder of the approval process after 2 days</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Approval1</template>
    </alerts>
    <alerts>
        <fullName>GEMS_AEP_EEE_Checked_Account_Submission_alert</fullName>
        <description>GEMS AEP (EEE) Checked Account Submission alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Electronic Eligibility Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_AEP_EEE_Checked_Account_Submission_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Accnt_Str_Client_Approval_Pending</fullName>
        <description>GEMS Accnt Str. Client Approval Pending</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Accnt_Str_Client_appr_Pending</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Accnt_Str_Client_Approval_Received_with_Changes</fullName>
        <description>GEMS Accnt Str. Client Approval Received with Changes</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Accnt_Str_Client_appr_received_with_changes</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Accnt_Structure_Client_Approval_Received_Alert</fullName>
        <description>GEMS Accnt Structure Client Approval Received Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Client_Approval_Received</template>
    </alerts>
    <alerts>
        <fullName>GEMS_AccountSpecialistAssignmentEmailAlert</fullName>
        <description>GEMS_AccountSpecialistAssignmentEmailAlert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_AccountSpecialistTemplate</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Maintenance_Completion_email_alert</fullName>
        <description>GEMS Account Maintenance Completion email alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Maintenance_Completion_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Setup_Maintenance_Case_1st_Notice</fullName>
        <description>GEMS Account Setup Maintenance Case 1st Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMSCaseEscalationNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Setup_Maintenance_Case_2nd_Notice</fullName>
        <description>GEMS Account Setup Maintenance Case 2nd Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMSCaseEscalation2ndNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Strcuture_Internal_Approval_Pending_EEE</fullName>
        <ccEmails>venugopal.manchukonda@capgemini.com,</ccEmails>
        <ccEmails>Guangjun_Han@bcbsil.com,</ccEmails>
        <ccEmails>Jingyong_Gui@bcbsil.com</ccEmails>
        <description>GEMS Account Strcuture Internal Approval Pending - EEE</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Pending</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Structure_Case_Created</fullName>
        <description>GEMS Account Structure Case Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Case_Created</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Structure_Internal_Approval_Pending_CDHP</fullName>
        <ccEmails>venugopal.manchukonda@capgemini.com,</ccEmails>
        <ccEmails>siva.thimmannagari@capgemini.com</ccEmails>
        <description>GEMS Account Structure Internal Approval Pending - CDHP</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Pending</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Structure_Internal_Approval_Received</fullName>
        <description>GEMS Account Structure Internal Approval Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_Approval_Received</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Structure_Internal_Approval_received_Alert</fullName>
        <description>GEMS Account Structure Internal Approval received Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Internal_approval_pending_for_2_Days</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Structure_Internal_Approval_received_Notification</fullName>
        <description>GEMS Account Structure Internal Approval received Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Accnt_Structure_Apprv_received_notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Submission_Blue_Direction_Creation_Rule</fullName>
        <description>GEMS Account Submission(Blue Direction) Creation Rule</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Blue_Direction_Product_Account_submNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_Terminated</fullName>
        <description>GEMS Account Terminated</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew_halkyn@bcbsil.com.lgna</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john_tao@bcbsil.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Termination</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_setup_WT_Approval_Request_Email_Alert</fullName>
        <description>GEMS Account setup WT Approval Request Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_BlueSTAR_Walkthrough_Resource_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Setup_WT_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_setup_case_with_maintenance_Submission_types_creation_Notification</fullName>
        <description>GEMS Account setup case with maintenance Submission types creation Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Setup_Case_Creation_Email_For_Maintenance_Submission_Types</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Account_setup_process_email_alert</fullName>
        <description>GEMS Account setup process email alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Setup_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Additional_UW_Screening_Email_Alert</fullName>
        <description>GEMS Additional UW Screening Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_All_Screening_Completed_Notification_Alert</fullName>
        <description>GEMS All Screening Completed Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_All_Screening_Cases_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Attachment_Email_Notification</fullName>
        <ccEmails>Health_Care_Economics@bcbstx.com</ccEmails>
        <description>GEMS Attachment Email Notification</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Attachment_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_BA_Level_AssignBack_Case_Email_Alert</fullName>
        <description>GEMS BA Level AssignBack Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_BA_Level_AssignBack_Case_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_BA_Level_Screening_Case_Return_Alert</fullName>
        <description>GEMS BA Level Screening Case Return Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_BA_Level_Screening_Return_Case_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_BCC_Product_Sold</fullName>
        <description>GEMS BCC Product Sold</description>
        <protected>false</protected>
        <recipients>
            <recipient>Medical Management Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_BCC_Product_Sold_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Benefit_Booklet_Notification_Alert</fullName>
        <ccEmails>EnterpriseBookletIntake@bcbstx.com</ccEmails>
        <description>GEMS Benefit Booklet Notification Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Benefit_Booklet_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Case_Escalation_2ndNotification</fullName>
        <description>GEMS Case Escalation 2nd Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMSCaseEscalation2ndNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Case_Escalation_2nd_Notification_Screening</fullName>
        <description>GEMS Case Escalation 2nd Notification - Screening</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Case_escalation_2nd_notification_Screening</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Case_Escalation_Notification</fullName>
        <description>GEMS Case Escalation Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMSCaseEscalationNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Case_Escalation_Notification_Screening</fullName>
        <description>GEMS Case Escalation Notification - Screening</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Case_escalation_notification_Screening</template>
    </alerts>
    <alerts>
        <fullName>GEMS_CommissionsPaidEmailAlert</fullName>
        <ccEmails>PSCGroupSupport@hcsc.net;</ccEmails>
        <ccEmails>callidus_operational_support@hcsc.net</ccEmails>
        <description>GEMS_CommissionsPaidEmailAlert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_CommissionsPaidEmailTemplate</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DBC_Underwriting_Approved_IL</fullName>
        <ccEmails>LGISILNationalDental@bcbsil.com</ccEmails>
        <description>GEMS DBC Underwriting Approved IL</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DBC_Underwriting_approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DBC_Underwriting_Approved_MT</fullName>
        <ccEmails>MTLGISDentalBenefits@bcbstx.com</ccEmails>
        <description>GEMS DBC Underwriting Approved MT</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DBC_Underwriting_approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DBC_Underwriting_Approved_NM</fullName>
        <ccEmails>NMLGISDental@bcbsil.com</ccEmails>
        <description>GEMS DBC Underwriting Approved NM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DBC_Underwriting_approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DBC_Underwriting_Approved_OK</fullName>
        <ccEmails>OKLGISASOAccounts@hcsc.net</ccEmails>
        <description>GEMS DBC Underwriting Approved OK</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DBC_Underwriting_approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DBC_Underwriting_Approved_OK_NOT_ASO</fullName>
        <ccEmails>LAdams@dnoa.com, GIGLIOD@BCBSIL.COM, BYRDB@BCBSIL.COM, ralmanza@dnoa.com, sfagiano@dnoa.com</ccEmails>
        <description>GEMS DBC Underwriting Approved OK NOT ASO</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DBC_Underwriting_approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DBC_Underwriting_Approved_TX</fullName>
        <ccEmails>TXLGISDentalBenefits@bcbstx.com</ccEmails>
        <description>GEMS DBC Underwriting Approved TX</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DBC_Underwriting_approved_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_DTU_Approve_Or_Reject_Email_Alert</fullName>
        <description>GEMS DTU Approve Or Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_DTU_Approve_Or_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_BC_Screening_IL_Email_Alert</fullName>
        <ccEmails>LGISILNationalDental@bcbsil.com</ccEmails>
        <description>GEMS Dental BC Screening IL Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_BC_Screening_MT_Email_Alert</fullName>
        <ccEmails>MTLGISDentalBenefits@bcbstx.com</ccEmails>
        <description>GEMS Dental BC Screening MT Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_BC_Screening_NM_Email_Alert</fullName>
        <ccEmails>NMLGISDental@bcbsil.com</ccEmails>
        <description>GEMS Dental BC Screening NM Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_BC_Screening_OK_ASO_Email_Alert</fullName>
        <ccEmails>OKLGISASOAccounts@hcsc.net</ccEmails>
        <description>GEMS Dental BC Screening OK ASO Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_BC_Screening_OK_NonASO_Email_Alert</fullName>
        <ccEmails>LAdams@dnoa.com,</ccEmails>
        <ccEmails>GIGLIOD@BCBSIL.COM,</ccEmails>
        <ccEmails>BYRDB@BCBSIL.COM,</ccEmails>
        <ccEmails>ralmanza@dnoa.com,</ccEmails>
        <ccEmails>sfagiano@dnoa.com</ccEmails>
        <description>GEMS Dental BC Screening OK NonASO Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_BC_Screening_TX_Email_Alert</fullName>
        <ccEmails>TXLGISDentalBenefits@bcbstx.com</ccEmails>
        <description>GEMS Dental BC Screening TX Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_Membership_Account_Submission_Notification</fullName>
        <description>GEMS Dental Membership Account Submission Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Dental Benefit Coder</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_Dental_Membership_Account_sub_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_UW_Screening_Email_Alert</fullName>
        <description>GEMS Dental UW Screening Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Dental_Underwriting_Approved_Notification_Alert</fullName>
        <description>GEMS Dental Underwriting Approved Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Dental_Underwriting_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Eligibility_Email_Alert</fullName>
        <description>GEMS_Eligibility_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_EligibilityEmailAlert</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Eligibility_Process_Completion_Notification</fullName>
        <description>GEMS Eligibility Process Completion Notification</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Eligibility_Completion_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Eligibility_Process_Notification</fullName>
        <description>GEMS Eligibility Process Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Eligibility_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Email_Alert_Approval_Notification</fullName>
        <description>Email Alert - Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Approval1</template>
    </alerts>
    <alerts>
        <fullName>GEMS_FEAK_Approve_Or_Reject_Email_Alert</fullName>
        <description>GEMS FEAK Approve Or Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Benefit_Coder_Email_Id__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_FEAK_Approve_Or_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_FSU_Membership_Account_Submission_Notification</fullName>
        <ccEmails>LGTTScreeningFSUMembAbilene@bcbstx.com</ccEmails>
        <description>GEMS Membership Account Submission Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_FSU_Membership_Account_sub_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_FSU_Membership_Email_Alert</fullName>
        <ccEmails>Divisional_Memb_DS@domino.hcsc.net</ccEmails>
        <description>GEMS Membership Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Membership_Creation_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_FSU_Membership_Maintenance_Email_Alert</fullName>
        <ccEmails>Divisional_Memb_DS@domino.hcsc.net</ccEmails>
        <description>GEMS Membership Maintenance Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Maintenance_Underwriting_Approved_Account</template>
    </alerts>
    <alerts>
        <fullName>GEMS_FSU_Membership_Notification</fullName>
        <description>GEMS Membership Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Membership Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_EEE_Process_Completion_for_FSU</template>
    </alerts>
    <alerts>
        <fullName>GEMS_FSU_Membership_UW_Medical_Production_ready_Notification</fullName>
        <ccEmails>Divisional_Memb_DS@domino.hcsc.net</ccEmails>
        <description>GEMS Membership UW(Medical) Production ready Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_FSU_Membership_Production_ready_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Health_Advocacy_and_BCC_Email_alert</fullName>
        <ccEmails>HAS_Operations@bcbsil.com,</ccEmails>
        <description>GEMS Health Advocacy and BCC Email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>christina_wheeler@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>patricia_girzadas@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Health_Advocacy_and_BCC</template>
    </alerts>
    <alerts>
        <fullName>GEMS_ID_card_Completed_Notification</fullName>
        <description>GEMS ID card Completed Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_ID_card_Completed_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_ID_card_Notification</fullName>
        <description>GEMS ID card Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Custom_ID_Request_Form_Completion</template>
    </alerts>
    <alerts>
        <fullName>GEMS_IL_division_Notification</fullName>
        <ccEmails>LGISILNationalDental@bcbsil.com</ccEmails>
        <description>GEMS IL division Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Email_notification_IL</template>
    </alerts>
    <alerts>
        <fullName>GEMS_LargeAccountSubmissionEmailAlert</fullName>
        <ccEmails>IL_OON_Notification@bcbsil.com</ccEmails>
        <description>GEMS_LargeAccountSubmissionEmailAlert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_LargeAccountSubmissionEmailTemplate</template>
    </alerts>
    <alerts>
        <fullName>GEMS_MT_division_Notification</fullName>
        <ccEmails>MTLGISDentalBenefits@bcbstx.com</ccEmails>
        <description>GEMS MT division Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Email_notification_MT</template>
    </alerts>
    <alerts>
        <fullName>GEMS_MUnderwriting_Approved_Non_Standard_BCC_Email_alert</fullName>
        <ccEmails>COTPI_Large_and_Custom_Accts@bcbsil.com,</ccEmails>
        <description>GEMS MUnderwriting Approved &amp; Non Standard BCC Email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>christina_wheeler@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>patricia_girzadas@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_MUnderwriting_Approved_Non_Standard_BCC</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Maintenance_Account_setup_process_email_alert</fullName>
        <description>GEMS Maintenance Account setup process email alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Maintenance_Account_Setup_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Chicago_Email_Alert</fullName>
        <ccEmails>Production_Ready_Chicago_FSU@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Chicago Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Danville_Email_Alert</fullName>
        <ccEmails>Production_Ready_Danville@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Danville Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Email_Alert</fullName>
        <description>GEMS Medical Benefit Coder Service Center Location Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Jacksonville_Email_Alert</fullName>
        <ccEmails>Production_Ready_Jacksonville@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Jacksonville Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Marshall_Email_Alert</fullName>
        <ccEmails>Production_Ready_Marshall@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Marshall Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_NM_Email_Alert</fullName>
        <ccEmails>Production_Ready_NM@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_NM Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Quincy_Email_Alert</fullName>
        <ccEmails>Production_ready_Quincy@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Quincy Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Rockford_Email_Alert</fullName>
        <ccEmails>ProductionReadyRockford@bcbsil.com</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Rockford Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_San_Angelo_Email_Alert</fullName>
        <ccEmails>Production_Ready_San_Angelo@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_San_Angelo Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Springfield_Email_Alert</fullName>
        <ccEmails>Production_Ready_Springfield_FSU@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Springfield Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Tulsa_Email_Alert</fullName>
        <ccEmails>ProductionReadyTulsa@bcbsok.com</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Tulsa Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coder_FSU_Location_Wichita_Falls_Email_Alert</fullName>
        <ccEmails>Production_Ready_Wichita_Falls@domino.hcsc.net</ccEmails>
        <description>GEMS Medical Benefit Coder Service Center Location_Wichita_Falls Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_FSU_Location_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coding_AssignBack_Case_Email_Alert</fullName>
        <description>GEMS Medical Benefit Coding AssignBack Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_AssignBack_Case_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coding_Notification</fullName>
        <description>GEMS Medical Benefit Coding Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/Gems_Medical_Benefit_Coding_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Benefit_Coding_Return_Case_Email_Alert</fullName>
        <description>GEMS Medical Benefit Coding Return Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Medical_Benefit_Coding_Return_Case_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Membership_Account_Submission_Notification</fullName>
        <description>GEMS Medical Membership Account Submission Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Medical Management Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_Medical_Membership_Account_sub_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Mgmt_Screening_Email_Alert</fullName>
        <ccEmails>william_m_crowley@bcbsil.com,</ccEmails>
        <ccEmails>jill_bradley@bcbsil.com</ccEmails>
        <description>GEMS Medical Mgmt Screening Email Alert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_UW_Screening_Email_Alert</fullName>
        <description>GEMS Medical UW Screening Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Account_Submission_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Underwriter</fullName>
        <description>GEMS Medical Underwriter</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Medical_Underwriter_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Medical_Underwriting_Approved_Notification_Alert</fullName>
        <description>GEMS Medical Underwriting Approved Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Medical_Underwriting_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Membership_Case_Completion_Alert</fullName>
        <description>GEMS Membership Case Completion Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Membership_Case_Completion_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_NM_division_Notification</fullName>
        <ccEmails>NMLGISDental@bcbsil.com</ccEmails>
        <description>GEMS NM division Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Email_notification_NM</template>
    </alerts>
    <alerts>
        <fullName>GEMS_OK_division_Notification</fullName>
        <ccEmails>LAdams@dnoa.com</ccEmails>
        <ccEmails>GIGLIOD@BCBSIL.COM</ccEmails>
        <ccEmails>BYRDB@BCBSIL.COM</ccEmails>
        <ccEmails>ralmanza@dnoa.com</ccEmails>
        <ccEmails>sfagiano@dnoa.com</ccEmails>
        <description>GEMS OK division Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Email_notification_OK</template>
    </alerts>
    <alerts>
        <fullName>GEMS_PORBOBEmailAlert</fullName>
        <ccEmails>Producer_Service_Center@bcbsok.com;</ccEmails>
        <ccEmails>PSCGroupSupport@hcsc.net</ccEmails>
        <description>GEMS_PORBOBEmailAlert</description>
        <protected>false</protected>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_PORBOBEmailAlertEmailTemplate</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Parent_Case_Owner_Assignment_Email_Alert</fullName>
        <description>GEMS Parent Case Owner Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Case_Owner_Assigned_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Pharmacy_Coding_Return_Case_Email_Alert</fullName>
        <description>GEMS Pharmacy Coding Return Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Pharmacy_Coding_Return_Case_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Re_Approval_Alert</fullName>
        <description>GEMS Re-Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_EEE_Review_approval_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Reject_Notification</fullName>
        <description>GEMS Reject Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_EEE_reject_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Rx_assign_back_to_business_area</fullName>
        <description>GEMS Rx assign back to business area</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Rx_Assign_Back_to_Bussiness_Area_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Account_Submission_Rule</fullName>
        <ccEmails>Breanne_McBride@bcbsil.com</ccEmails>
        <description>GEMS SBC Account Submission Rule</description>
        <protected>false</protected>
        <recipients>
            <recipient>SBC Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Account_Submission_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Approve_Or_Reject_Email_Alert</fullName>
        <description>GEMS SBC Approve Or Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_SBC_Approve_Or_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Approved_Alert</fullName>
        <description>GEMS SBC Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Complete_Email_Alert</fullName>
        <description>GEMS SBC Complete Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Creaion_Notification</fullName>
        <description>GEMS SBC Creaion Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Email_Notification_Alert</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Creation_Email_Alert</fullName>
        <description>GEMS SBC Creation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_SBC_Creation_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Email_Notifications</fullName>
        <ccEmails>Test@hcsc.com</ccEmails>
        <ccEmails>Binod.shaw@capgemini.com</ccEmails>
        <description>Send Email Notification when Account Submission Process is complete and Screening is in progress</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Email_Notification_Alert</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_PeerReviewer_Approval</fullName>
        <description>GEMS SBC PeerReviewer Approval</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_PeerReviewer_Approval</template>
    </alerts>
    <alerts>
        <fullName>GEMS_SBC_Reject_Alert</fullName>
        <description>GEMS SBC Reject Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Reject_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Screening_Created_Benefit_Booklet_Checked_Notification</fullName>
        <description>GEMS Screening Created (Benefit Booklet Checked) Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_Screening_creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Screening_Created_CDHP_product_Notification</fullName>
        <description>GEMS Screening Created (CDHP product) Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_CDHP_Product_Account_Submission_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Screening_Created_Dental_Benefit_Coding_Notification</fullName>
        <description>GEMS Screening Created (Dental Benefit Coding) Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_Screening_creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Send_reminder_EEE</fullName>
        <description>Send reminder of the approval process after 2 days</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Approval1</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Send_reminder_EEE_CDHP</fullName>
        <description>Send reminder of the approval process after 2 days</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Approval1</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Send_reminder_EEE_CDHP_Dental</fullName>
        <description>Send reminder of the approval process after 2 days</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_CDHP_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_Dental_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Approval1</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Send_reminder_EEE_Dental</fullName>
        <description>Send reminder of the approval process after 2 days</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Dental_Benefit_Coder__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>GEMS_EEE__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Account_Structure_Approval1</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Setup_Case_1st_Notice</fullName>
        <description>GEMS Setup Case 1st Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMSCaseEscalationNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Setup_Case_2nd_Notice</fullName>
        <description>GEMS Setup Case 2nd Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMSCaseEscalation2ndNotification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Shared_Accum_Approve_Or_Reject_Email_Alert</fullName>
        <description>GEMS Shared Accum Approve Or Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Shared_Accum_Approve_Or_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_TX_division_Notification</fullName>
        <ccEmails>TXLGISDentalBenefits@bcbstx.com</ccEmails>
        <description>GEMS TX division Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Email_notification_TX</template>
    </alerts>
    <alerts>
        <fullName>GEMS_UW_Case_Creation_Email_Alert</fullName>
        <description>GEMS UW Case Creation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Underwriting_Case_Creation_Template</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Underwriting_Approved_FSU_Claims_Fsu_membership_benefit_Enquiries</fullName>
        <ccEmails>Divisional_Memb_DS@domino.hcsc.net</ccEmails>
        <ccEmails>EnterpriseBookletIntake@bcbstx.com</ccEmails>
        <description>GEMS Underwriting Approved FSU Claims,Fsu membership,benefit Enquiries</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Underwriting_Approved_Account_FSU_Claim_membership_Benefit_Inquiry</template>
    </alerts>
    <alerts>
        <fullName>GEMS_structure_waiting_for_Client_approval_recevd_more_than_2_days</fullName>
        <description>GEMS structure waiting for Client approval recevd more than 2 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Accnt_St_client_approval_Pending_for_2_Days</template>
    </alerts>
    <alerts>
        <fullName>GEMS_structure_waiting_for_Client_approval_recevd_more_than_4_days</fullName>
        <description>GEMS structure waiting for Client approval recevd more than 4 days</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_Accnt_St_client_approval_Pending_for_4_Days</template>
    </alerts>
    <alerts>
        <fullName>Gems_Accnt_submission_Benefit_Booklet_required_checked</fullName>
        <description>Gems Accnt submission Benefit Booklet required checked</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/Gems_benefit_Booklet_checked</template>
    </alerts>
    <alerts>
        <fullName>Gems_SBC_creation_notification</fullName>
        <description>Gems SBC creation notification Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_SBC_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Inquiry_Case_Completed_email</fullName>
        <description>Inquiry Case Completed email</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Inquiry_Case_Completed</template>
    </alerts>
    <alerts>
        <fullName>Inquiry_Case_open_72_hours_email</fullName>
        <description>Inquiry Case open 72 hours email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Inquiry_Case_open_72_hours</template>
    </alerts>
    <alerts>
        <fullName>Medical_Underwriter_Notification_return_Status</fullName>
        <description>Medical Underwriter Notification return(Status)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_UW_Request_Paperwork_Review</template>
    </alerts>
    <alerts>
        <fullName>Network_Information_Case_Closed_Notification_Email</fullName>
        <description>Network Information Case Closed Notification Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>AEP Processor</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Executive</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Management Support</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Accountant</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Accounts Receivable</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Additional Medical Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Additional Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Advanced Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Analytics</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Assistant Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Behavioral Health CAC</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Benefit Coder</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Billing</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>CDHP Tax Screener</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Claims Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Client Consulting Contact</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Client Implementation Consultant</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Client Service Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Clinical Account Consultant</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Cobra</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Administration Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>DVP Account Management</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>DVP Sales</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Dearborn Sales Executive</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Dental Benefit Coder</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Dental Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Director Account Management</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Director Sales</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>EHCM Presenter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>EHCM RFP SME</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Electronic Eligibility Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>GPD Director</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>GPD Group Benefit Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>GPD Marketing Service Representative</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>GPD Sales Executive/AE</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Group Benefit Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Implementation Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Implementer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager Account Management</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager Sales</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Marketing Communications</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Marketing Operations</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Marketing Service Rep</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Medical Director</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Medical Management Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Membership Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Membership Specialist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>New Business Coordinator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Pharmacy Coder</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Writer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>SBC Analyst</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Executive</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Strategist</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Senior Director Subscriber Services</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Senior Manager Subscriber Services</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Strategic Account Executive</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>VP Account Management</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>VP Sales</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Wellness Consultant</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/NI_Case_Closed_Email_Creator</template>
    </alerts>
    <alerts>
        <fullName>New_Cede_Case_Notification</fullName>
        <description>New Cede Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Executive</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case/New_Cede_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Creator_of_Assignment</fullName>
        <description>Notify Case Creator of Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case/SUPPORTCaseAssignment</template>
    </alerts>
    <alerts>
        <fullName>Notify_Contract_Admin_of_Signer_Change</fullName>
        <ccEmails>mei_chen@bcbsil.com</ccEmails>
        <description>Notify Contract Admin of Signer Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Custom_Contract/Email_Contract_Administrator_for_Changed_Contract_Signer</template>
    </alerts>
    <alerts>
        <fullName>Notify_Requester_For_Case_Completion</fullName>
        <description>Notify Requester For Case Completion</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Executive__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Underwriting_Case_Templates/Underwriting_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Notify_owners_when_Underwriting_Due_Date_is_approaching</fullName>
        <description>Notify Owners When Underwriting Due Date is approaching</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Underwriting_Case_Templates/Underwriting_Case_Due_Date_Approaching</template>
    </alerts>
    <alerts>
        <fullName>Notify_sales_when_underwriting_declines_to_quote</fullName>
        <description>Notify sales when underwriting declines to quote</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Underwriting_Case_Templates/UW_Declined_to_Quote</template>
    </alerts>
    <alerts>
        <fullName>Notify_user_when_they_are_assigned_a_case</fullName>
        <description>Notify user when they are assigned a case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Case_Assigned_Owner</template>
    </alerts>
    <alerts>
        <fullName>PG_Team_Notification_of_PG_Case_Ownership</fullName>
        <description>PG Team Notification of PG Case Ownership</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case/PG_Case_Owner_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Private_Exchange_Blue_Directions_email_notification</fullName>
        <description>Private Exchange - Blue Directions email notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Private_Exchange_Email_Notification_Submit</fullName>
        <description>Private Exchange Email Notification Submit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case/PE_Case_Owner_Email_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Private_Exchange_External_email_notification</fullName>
        <description>Private Exchange - External email notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_External</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Legal_Councel</fullName>
        <description>Send Email To Legal Councel</description>
        <protected>false</protected>
        <recipients>
            <recipient>Legal_Counsel</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Case_For_Legel_Councel</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Private_Exchange_Blue_Directions_Queue_When_Status_has_Changed</fullName>
        <description>Send Email to Private Exchange Blue Directions Queue When Status has Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_Blue_Directions</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Private_Exchange_Case_Folder/Case_Status_Queue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Private_Exchange_External_Queue_When_Status_has_Changed</fullName>
        <description>Send Email to Private Exchange External Queue When Status has Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Private_Exchange_External</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Private_Exchange_Case_Folder/Case_Status_Queue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Setup_Process_Case_Release_Underwriting_Complete_Alert</fullName>
        <description>Setup Process Case Release Underwriting Complete Alert</description>
        <protected>false</protected>
        <recipients>
            <field>GEMS_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/Setup_Process_Case_Release_Underwriting_Complete</template>
    </alerts>
    <alerts>
        <fullName>Underwriting_Due_Date_has_passed</fullName>
        <description>Underwriting Due Date has passed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Underwriting_Case_Templates/Underwriting_Case_Due_Date_Passed</template>
    </alerts>
    <alerts>
        <fullName>reminder_to_submit_PG_case</fullName>
        <description>reminder to submit PG case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case/PG_Case_Owner_Email_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>AR_Cancellation_Flag_to_Blank_on_Case</fullName>
        <description>When Case is rejected for Group Section,Billing,Category cancellation then AR Cancellation Flag will be set to blank.</description>
        <field>AR_Cancellation_Flag__c</field>
        <name>AR Cancellation Flag to Blank on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_BD_DO_UW_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Dearborn_Other_Blue_Directions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to BD-DO-UW Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_BD_D_IL_UW_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Dearborn_IL_Blue_Directions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to BD-D-IL-UW Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_BD_D_UW_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Dental_UW_Private_Exchange</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to BD-D-UW Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_BD_M_MM_MT_UW_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Medical_MT_151_Blue_Directions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to BD-M-MM-MT-UW Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_BD_M_MM_OK_UW_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Medical_OK_151_Blue_Directions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to BD-M-MM-OK-UW Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_BD_M_UW_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Medical_UW_Blue_Directions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to BD-M-UW Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_PE_BD_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Private_Exchange_Blue_Directions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to PE-BD Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_PE_EU_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Medical_UW_External_Exchange</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to PE-EU Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Case_to_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LGNA_Private_Exchange_External</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Case to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_owner</fullName>
        <field>OwnerId</field>
        <lookupValue>SG_MM_Sales_Solution_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Waiting_for_Information_End_Date</fullName>
        <field>Waiting_For_Information_End_Date__c</field>
        <name>Clear Waiting for Information End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Reject_Update_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Final Reject Update Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Acc_Str_Client_Appr_Pending_2_days</fullName>
        <field>GEMS_Client_approval_pending__c</field>
        <formula>NOW()</formula>
        <name>GEMS Acc Str Client Appr Pending 2 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Acc_Str_Intern_Appr_Pending_2_days</fullName>
        <field>GEMS_Internal_Approval_Pending__c</field>
        <formula>NOW()</formula>
        <name>GEMS Acc Str Intern Appr Pending 2 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Setup_QR_Approval</fullName>
        <description>Quality Review Completed</description>
        <field>Status</field>
        <literalValue>Quality Review Completed</literalValue>
        <name>GEMS Account Setup QR Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Setup_QR_Rejection</fullName>
        <field>Status</field>
        <literalValue>QR Approval Rejected</literalValue>
        <name>GEMS Account Setup QR Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Setup_WT_Approval</fullName>
        <field>Status</field>
        <literalValue>BW Approval Received</literalValue>
        <name>GEMS Account Setup WT Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Setup_WT_Rejection</fullName>
        <field>Status</field>
        <literalValue>BW Approval Rejected</literalValue>
        <name>GEMS Account Setup WT Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Str_Submitter_Approval_1</fullName>
        <field>Status</field>
        <literalValue>Client Approval Pending</literalValue>
        <name>GEMS Account Str Submitter Approval - 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Str_Submitter_Approval_2</fullName>
        <field>Status</field>
        <literalValue>Client Approval Received</literalValue>
        <name>GEMS Account Str Submitter Approval - 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Str_Submitter_Approval_3</fullName>
        <field>Status</field>
        <literalValue>Design In Progress</literalValue>
        <name>GEMS Account Str Submitter Approval - 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Structure_Approval_EEE</fullName>
        <field>Status</field>
        <literalValue>Internal Approval Received</literalValue>
        <name>GEMS Account Structure Approval EEE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Account_Structure_Internal_Approval</fullName>
        <field>Status</field>
        <literalValue>Internal Approval Pending</literalValue>
        <name>GEMS Account Structure Internal Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Approval_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Client Approval Pending</literalValue>
        <name>Approval Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Benefit_Coder_Email_ID_Update</fullName>
        <field>GEMS_Benefit_Coder_Email_Id__c</field>
        <formula>Parent.GEMS_Owner_Email__c</formula>
        <name>GEMS Benefit Coder Email ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_CDHP_Verification_Approved</fullName>
        <field>GEMS_CDHP_Verification_Approved__c</field>
        <literalValue>1</literalValue>
        <name>CDHP Verification Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Completed_Date_Update_WithoutSigned</fullName>
        <field>GEMS_Completed_Date__c</field>
        <formula>NOW()</formula>
        <name>GEMS Completed Date Update WithoutSigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_DTU_Testing_Approved_Update</fullName>
        <field>GEMS_DTU_Testing_Approved__c</field>
        <literalValue>1</literalValue>
        <name>DTU Testing Approved Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Dental_BC_Peer_Reviewer_Approval</fullName>
        <field>Status</field>
        <literalValue>Peer Reviewer Approved</literalValue>
        <name>GEMS Dental BC Peer Reviewer Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Dental_BC_Peer_Reviewer_Rejected</fullName>
        <field>Status</field>
        <literalValue>Peer Review Rejected</literalValue>
        <name>GEMS Dental BC Peer Reviewer Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_EEE_Reject_action</fullName>
        <field>GEMS_EEE_rejected_action__c</field>
        <literalValue>1</literalValue>
        <name>GEMS EEE Reject action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_FEAK_Testing_Approved_Update</fullName>
        <field>GEMS_FEAK_Testing_Approved__c</field>
        <literalValue>1</literalValue>
        <name>FEAK Testing Approved Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_CDHP_Ops_Approval</fullName>
        <field>Status</field>
        <literalValue>CDHP Team Approval Received</literalValue>
        <name>GEMS Medical BC CDHP Ops Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_CDHP_Ops_Rejection</fullName>
        <field>Status</field>
        <literalValue>CDHP Team Approval Rejected</literalValue>
        <name>GEMS Medical BC CDHP Ops Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_FEAK_Approval</fullName>
        <field>Status</field>
        <literalValue>FEAK Approval Received</literalValue>
        <name>GEMS Medical BC FEAK Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_FEAK_Approval_Test</fullName>
        <field>Status</field>
        <literalValue>FEAK Approval Received</literalValue>
        <name>GEMS Medical BC FEAK Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_FEAK_Rejection</fullName>
        <field>Status</field>
        <literalValue>FEAK Approval Rejected</literalValue>
        <name>GEMS Medical BC FEAK Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_FEAK_Rejection_Test</fullName>
        <field>Status</field>
        <literalValue>FEAK Approval Rejected</literalValue>
        <name>GEMS Medical BC FEAK Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_Shared_Accum_Approval</fullName>
        <field>Status</field>
        <literalValue>Shared Accum Approval Received</literalValue>
        <name>GEMS Medical BC Shared Accum Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_BC_Shared_Accum_Rejection</fullName>
        <field>Status</field>
        <literalValue>Shared Accum Approval Rejected</literalValue>
        <name>GEMS Medical BC Shared Accum Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_Benefit_Coding_DTU_Approval</fullName>
        <field>Status</field>
        <literalValue>DTU Approval Received</literalValue>
        <name>GEMS Medical Benefit Coding DTU Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Medical_Benefit_Coding_DTU_Reject</fullName>
        <field>Status</field>
        <literalValue>DTU Approval Rejected</literalValue>
        <name>GEMS Medical Benefit Coding DTU Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_QR_Approved_checkbox_Update</fullName>
        <description>This field update will update the field GEMS_Account_Setup_QR_Approval_Received__c once the account setup has received QR Approval.</description>
        <field>GEMS_Account_Setup_QR_Approval_Received__c</field>
        <literalValue>1</literalValue>
        <name>GEMS QR Approved checkbox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Reject_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Design In Progress</literalValue>
        <name>Reject Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_SBC_Peer_Reviewer_Approved</fullName>
        <field>Status</field>
        <literalValue>Internal Approval Received</literalValue>
        <name>GEMS SBC Peer Reviewer Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_SBC_Peer_Reviewer_Rejected</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>GEMS SBC Peer Reviewer Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Shared_Accum_Testing_Approved</fullName>
        <field>GEMS_Shared_Accum_Testing_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Shared Accum Testing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Update_Internal_Appd_Received_Date</fullName>
        <field>GEMS_AcctStr_Internal_Appr_Received_Date__c</field>
        <formula>Now()</formula>
        <name>Update Internal Appd Recieved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_WT_Approved_checkbox_Update</fullName>
        <description>This field update will update the field GEMS_Account_Setup_WT_Approval_Received__c once the account setup has received QR Approval.</description>
        <field>GEMS_Account_Setup_WT_Approval_Received__c</field>
        <literalValue>1</literalValue>
        <name>GEMS WT Approved checkbox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LGNA_Send_to_BlueStar</fullName>
        <field>Status</field>
        <literalValue>LGNA Waiting for Submission to BlueStar</literalValue>
        <name>LGNA Send to BlueStar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_From_queue_to_user</fullName>
        <description>The date/time the owner changed from Texas, Illinois, Oklahoma to an agent</description>
        <field>Pulled_from_Queue2__c</field>
        <formula>NOW()</formula>
        <name>Owner From queue to user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Manager_Email</fullName>
        <field>Owner_Manager_Email__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>Owner Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Date_Time_Case_Declined</fullName>
        <description>Rule to populate date/time declined on a case</description>
        <field>Date_Time_Declined__c</field>
        <formula>NOW()</formula>
        <name>Populate Date/ Time Case Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Effective_Date</fullName>
        <field>Requested_Effective_Date__c</field>
        <formula>Opportunity_Name__r.Requested_Effective_Date__c</formula>
        <name>Populate Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Proposed_Dependent_Contribution</fullName>
        <field>Dependent1__c</field>
        <formula>Dependent__c</formula>
        <name>Populate Proposed Dependent Contribution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Proposed_Employee_Contribution</fullName>
        <field>Proposed_Employee__c</field>
        <formula>Current_Employee__c</formula>
        <name>Populate Proposed Employee Contribution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Time_Waiting_For_Information</fullName>
        <description>Populate Time Waiting For Information</description>
        <field>Time_in_Waiting_for_Information__c</field>
        <formula>IF(dateValue(CreatedDate)&lt;DATEVALUE($Label.Date_for_Underwritind_days_calculation), 
IF(ISBLANK(Time_in_Waiting_for_Information__c),0,Time_in_Waiting_for_Information__c) + 
CASE(MOD( DateValue(Waiting_For_Information_Start_Date__c) - DATE(1985,6,24),7), 
0 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( DateValue(Waiting_For_Information_End_Date__c) - DateValue(Waiting_For_Information_Start_Date__c) )/7)*5),0)</formula>
        <name>Populate Time Waiting For Information</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Due_Date</fullName>
        <field>Underwriting_Due_Date__c</field>
        <formula>IF(ISNULL(Underwriting_Due_Date__c) ,
IF(OR(ISPICKVAL(HCSC_Division__c ,&apos;TX&apos;), ISPICKVAL(HCSC_Division__c ,&apos;MT&apos;), ISPICKVAL(HCSC_Division__c ,&apos;OK&apos;), ISPICKVAL(HCSC_Division__c ,&apos;NM&apos;)),
IF(
AND(INCLUDES(Premium_Type__c,&apos;PP&apos;),Is_this_a_Formal_Bid__c)
,CASE(
MOD(
(Proposal_Due_Date__c + 8)-
DATE(1900, 1,7), 7),
0, (Proposal_Due_Date__c+ 8)+3,
1, (Proposal_Due_Date__c+ 8)+2,
2, (Proposal_Due_Date__c+ 8)+2,
3, (Proposal_Due_Date__c+ 8)+2,
4, (Proposal_Due_Date__c+ 8)+4,
5,(Proposal_Due_Date__c+ 8)+4,
6,(Proposal_Due_Date__c+ 8)+4,
(Proposal_Due_Date__c+ 8)
),
IF(
AND(INCLUDES(Premium_Type__c,&apos;PP&apos;),NOT(Is_this_a_Formal_Bid__c)),
CASE(
MOD(
(Proposal_Due_Date__c+ 5)-
DATE(1900, 1,7), 7),
0, (Proposal_Due_Date__c+ 5)+2,
1, (Proposal_Due_Date__c+ 5)+2,
2, (Proposal_Due_Date__c+ 5)+2,
3, (Proposal_Due_Date__c+ 5)+2,
4, (Proposal_Due_Date__c+ 5)+2,
5,(Proposal_Due_Date__c+ 5)+4,
6,(Proposal_Due_Date__c+ 5)+3,
(Proposal_Due_Date__c+ 5)
),
null
)
),
Proposal_Due_Date__c
),
Underwriting_Due_Date__c
)</formula>
        <name>Populate Underwriting Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Due_Date_IL</fullName>
        <description>Populate UW due date for IL cases</description>
        <field>Underwriting_Due_Date__c</field>
        <formula>Proposal_Due_Date__c</formula>
        <name>Populate Underwriting Due Date IL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Due_Date_v1</fullName>
        <field>Underwriting_Due_Date__c</field>
        <formula>IF(Underwriting_Due_Date__c = null,
   IF(
       AND(Is_this_a_Formal_Bid__c),       
       TODAY()+2,
       TODAY()+3
     ),
     TODAY()+4
)</formula>
        <name>Populate Underwriting Due Date v1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Due_Date_v2</fullName>
        <field>Underwriting_Due_Date__c</field>
        <formula>IF(ISNULL(Underwriting_Due_Date__c) ,
IF(OR(ISPICKVAL(HCSC_Division__c ,&apos;TX&apos;), ISPICKVAL(HCSC_Division__c ,&apos;MT&apos;), ISPICKVAL(HCSC_Division__c ,&apos;OK&apos;), ISPICKVAL(HCSC_Division__c ,&apos;NM&apos;)),
IF(
AND(NOT(INCLUDES(Premium_Type__c,&apos;PP&apos;)))
,CASE(
MOD(
(Proposal_Due_Date__c + 8)-
DATE(1900, 1,7), 7),
0, (Proposal_Due_Date__c+ 8)+3,
1, (Proposal_Due_Date__c+ 8)+2,
2, (Proposal_Due_Date__c+ 8)+2,
3, (Proposal_Due_Date__c+ 8)+2,
4, (Proposal_Due_Date__c+ 8)+4,
5,(Proposal_Due_Date__c+ 8)+4,
6,(Proposal_Due_Date__c+ 8)+4,
(Proposal_Due_Date__c+ 8)
),
Underwriting_Due_Date__c
),
Proposal_Due_Date__c
),
Underwriting_Due_Date__c
)</formula>
        <name>Populate Underwriting Due Date v2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Due_Date_v3</fullName>
        <field>Underwriting_Due_Date__c</field>
        <formula>IF(ISNULL(Underwriting_Due_Date__c) , 
IF(DATEVALUE(IF(OR(ISPICKVAL(HCSC_Division__c ,&apos;TX&apos;), ISPICKVAL(HCSC_Division__c ,&apos;MT&apos;), ISPICKVAL(HCSC_Division__c ,&apos;OK&apos;), ISPICKVAL(HCSC_Division__c ,&apos;NM&apos;)), 
IF( 
AND(INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;),NOT(OR(INCLUDES(Funding_Type_Multiselect__c,&apos;ASO&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;ACAP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;COST&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;MPP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;PAR&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;SERV&apos;))),Is_this_a_Formal_Bid__c) 
,CASE( 
MOD( 
DATEVALUE(Date_Assigned_to_Underwriting__c) + 8- 
DATE(1900, 1,7), 7), 
0, (Date_Assigned_to_Underwriting__c+ 8)+3, 
1, (Date_Assigned_to_Underwriting__c+ 8)+2, 
2, (Date_Assigned_to_Underwriting__c+ 8)+2, 
3, (Date_Assigned_to_Underwriting__c+ 8)+2, 
4, (Date_Assigned_to_Underwriting__c+ 8)+4, 
5,(Date_Assigned_to_Underwriting__c+ 8)+4, 
6,(Date_Assigned_to_Underwriting__c+ 8)+4, 
(Date_Assigned_to_Underwriting__c+ 8) 
), 
IF( 
AND(INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;),NOT(OR(INCLUDES(Funding_Type_Multiselect__c,&apos;ASO&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;ACAP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;COST&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;MPP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;PAR&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;SERV&apos;))),NOT(Is_this_a_Formal_Bid__c)), 
CASE( 
MOD( 
DATEVALUE(Date_Assigned_to_Underwriting__c) - 
DATE(1900, 1,7), 7), 
0, (Date_Assigned_to_Underwriting__c+ 5)+0, 
1, (Date_Assigned_to_Underwriting__c+ 5)+2, 
2, (Date_Assigned_to_Underwriting__c+ 5)+2, 
3, (Date_Assigned_to_Underwriting__c+ 5)+2, 
4, (Date_Assigned_to_Underwriting__c+ 5)+2, 
5,(Date_Assigned_to_Underwriting__c+ 5)+2, 
6,(Date_Assigned_to_Underwriting__c+ 5)+1, 
(Date_Assigned_to_Underwriting__c+ 5) 
), 
null 
) 
), 
Date_Assigned_to_Underwriting__c 
))&lt;=Proposal_Due_Date__c,Proposal_Due_Date__c,DATEVALUE(IF(OR(ISPICKVAL(HCSC_Division__c ,&apos;TX&apos;), ISPICKVAL(HCSC_Division__c ,&apos;MT&apos;), ISPICKVAL(HCSC_Division__c ,&apos;OK&apos;), ISPICKVAL(HCSC_Division__c ,&apos;NM&apos;)), 
IF( 
AND(INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;),NOT(OR(INCLUDES(Funding_Type_Multiselect__c,&apos;ASO&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;ACAP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;COST&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;MPP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;PAR&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;SERV&apos;))),Is_this_a_Formal_Bid__c) 
,CASE( 
MOD( 
DATEVALUE(Date_Assigned_to_Underwriting__c) + 8- 
DATE(1900, 1,7), 7), 
0, (Date_Assigned_to_Underwriting__c+ 8)+3, 
1, (Date_Assigned_to_Underwriting__c+ 8)+2, 
2, (Date_Assigned_to_Underwriting__c+ 8)+2, 
3, (Date_Assigned_to_Underwriting__c+ 8)+2, 
4, (Date_Assigned_to_Underwriting__c+ 8)+4, 
5,(Date_Assigned_to_Underwriting__c+ 8)+4, 
6,(Date_Assigned_to_Underwriting__c+ 8)+4, 
(Date_Assigned_to_Underwriting__c+ 8) 
), 
IF( 
AND(INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;),NOT(OR(INCLUDES(Funding_Type_Multiselect__c,&apos;ASO&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;ACAP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;COST&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;MPP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;PAR&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;SERV&apos;))),NOT(Is_this_a_Formal_Bid__c)), 
CASE( 
MOD( 
DATEVALUE(Date_Assigned_to_Underwriting__c) - 
DATE(1900, 1,7), 7), 
0, (Date_Assigned_to_Underwriting__c+ 5)+0, 
1, (Date_Assigned_to_Underwriting__c+ 5)+2, 
2, (Date_Assigned_to_Underwriting__c+ 5)+2, 
3, (Date_Assigned_to_Underwriting__c+ 5)+2, 
4, (Date_Assigned_to_Underwriting__c+ 5)+2, 
5,(Date_Assigned_to_Underwriting__c+ 5)+2, 
6,(Date_Assigned_to_Underwriting__c+ 5)+1, 
(Date_Assigned_to_Underwriting__c+ 5) 
), 
null 
) 
), 
Date_Assigned_to_Underwriting__c 
))), 
Underwriting_Due_Date__c 
)</formula>
        <name>Populate Underwriting Due Date v3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Due_Date_v4</fullName>
        <field>Underwriting_Due_Date__c</field>
        <formula>IF(ISNULL(Underwriting_Due_Date__c) , 
IF(IF(OR(ISPICKVAL(HCSC_Division__c ,&apos;TX&apos;), ISPICKVAL(HCSC_Division__c ,&apos;MT&apos;), ISPICKVAL(HCSC_Division__c ,&apos;OK&apos;), ISPICKVAL(HCSC_Division__c ,&apos;NM&apos;)), 
IF( 
OR(NOT(INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;)),AND(OR(INCLUDES(Funding_Type_Multiselect__c,&apos;ASO&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;ACAP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;COST&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;MPP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;PAR&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;SERV&apos;)),INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;)))
,DATEVALUE(CASE( 
MOD( 
DATEVALUE(Date_Assigned_to_Underwriting__c) + 8- 
DATE(1900, 1,7), 7), 
0, (Date_Assigned_to_Underwriting__c+ 8)+3, 
1, (Date_Assigned_to_Underwriting__c+ 8)+2, 
2, (Date_Assigned_to_Underwriting__c+ 8)+2, 
3, (Date_Assigned_to_Underwriting__c+ 8)+2, 
4, (Date_Assigned_to_Underwriting__c+ 8)+4, 
5,(Date_Assigned_to_Underwriting__c+ 8)+4, 
6,(Date_Assigned_to_Underwriting__c+ 8)+4, 
(Date_Assigned_to_Underwriting__c+ 8) 
)), 
Underwriting_Due_Date__c 
), 
DATEVALUE(Date_Assigned_to_Underwriting__c) 
)&lt;=Proposal_Due_Date__c,Proposal_Due_Date__c,IF(OR(ISPICKVAL(HCSC_Division__c ,&apos;TX&apos;), ISPICKVAL(HCSC_Division__c ,&apos;MT&apos;), ISPICKVAL(HCSC_Division__c ,&apos;OK&apos;), ISPICKVAL(HCSC_Division__c ,&apos;NM&apos;)), 
IF( 
OR(NOT(INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;)),AND(OR(INCLUDES(Funding_Type_Multiselect__c,&apos;ASO&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;ACAP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;COST&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;MPP&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;PAR&apos;),INCLUDES(Funding_Type_Multiselect__c,&apos;SERV&apos;)),INCLUDES(Funding_Type_Multiselect__c,&apos;Prem&apos;))) 
,DATEVALUE(CASE( 
MOD( 
DATEVALUE(Date_Assigned_to_Underwriting__c) + 8- 
DATE(1900, 1,7), 7), 
0, (Date_Assigned_to_Underwriting__c+ 8)+3, 
1, (Date_Assigned_to_Underwriting__c+ 8)+2, 
2, (Date_Assigned_to_Underwriting__c+ 8)+2, 
3, (Date_Assigned_to_Underwriting__c+ 8)+2, 
4, (Date_Assigned_to_Underwriting__c+ 8)+4, 
5,(Date_Assigned_to_Underwriting__c+ 8)+4, 
6,(Date_Assigned_to_Underwriting__c+ 8)+4, 
(Date_Assigned_to_Underwriting__c+ 8) 
)), 
Underwriting_Due_Date__c 
), 
DATEVALUE(Date_Assigned_to_Underwriting__c) 
)), 
Underwriting_Due_Date__c 
)</formula>
        <name>Populate Underwriting Due Date v4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Waiting_for_Information_End_D</fullName>
        <field>Waiting_For_Information_End_Date__c</field>
        <formula>NOW()</formula>
        <name>Populate Waiting for Information End D</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Waiting_for_Information_Start_D</fullName>
        <field>Waiting_For_Information_Start_Date__c</field>
        <formula>NOW()</formula>
        <name>Populate Waiting for Information Start D</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Remove_Submit_to_Verifier_Button</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SGR_Renewals_No_Submit_to_Group_Verifier_Button</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SGR_Remove Submit to Verifier Button</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bypass_Validation</fullName>
        <field>Bypass_Validation__c</field>
        <literalValue>0</literalValue>
        <name>Update Bypass Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner_to_NI_Queue</fullName>
        <description>Updates the Case Owner to the NI Queue</description>
        <field>OwnerId</field>
        <lookupValue>Network_Information</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner to NI Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner_to_PG_Queue</fullName>
        <description>Updates the Case Owner to the PG Team Queue</description>
        <field>OwnerId</field>
        <lookupValue>PG_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner to PG Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_owner</fullName>
        <field>OwnerId</field>
        <lookupValue>SGR_Operations_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Submitted_For_Legal_Review</fullName>
        <description>Changes Date Submitted For Legal Review to &apos;Now&apos;</description>
        <field>Date_Submitted_For_Legal_Review__c</field>
        <formula>NOW()</formula>
        <name>Update Date Submitted For Legal Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Execute_Rule_Field</fullName>
        <description>To update the Execute Rule checkbox to false once the Case Status is changed</description>
        <field>Execute_Rule__c</field>
        <literalValue>0</literalValue>
        <name>Update Execute Rule Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Internal_Field</fullName>
        <description>To update internal field on Case object</description>
        <field>Internal__c</field>
        <literalValue>1</literalValue>
        <name>Update Internal Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PE_External_Guideline</fullName>
        <field>HCSC_Division__c</field>
        <name>Update PE External Guideline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PE_Status_Field</fullName>
        <description>updates the status field to submitted</description>
        <field>Status</field>
        <literalValue>Submitted</literalValue>
        <name>Update PE Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Plan_President_Approval_Date</fullName>
        <description>Change the Plan President Approval Date field to today</description>
        <field>Plan_President_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Plan President Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proposal_Task_Created_Checkbox</fullName>
        <description>Updates the Proposal Task Created checkbox to prevent further task creations</description>
        <field>Proposal_Task_Created__c</field>
        <literalValue>1</literalValue>
        <name>Update Proposal Task Created Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status</field>
        <literalValue>Additional Input required</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Approve</fullName>
        <description>Update Status to &quot;LGNA Waiting for Submission to BlueStar&quot;</description>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Update Status Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Field</fullName>
        <description>updates the status field to submitted</description>
        <field>Status</field>
        <literalValue>Submitted</literalValue>
        <name>Update Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Rejected2</fullName>
        <description>Update Status Rejected</description>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_owner</fullName>
        <field>Case_Owner_Copy__c</field>
        <formula>Owner:Queue.QueueName + Owner:User.FirstName + &quot; &quot; + Owner:User.LastName</formula>
        <name>Update_owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated</fullName>
        <field>Account_Type__c</field>
        <literalValue>Prospect</literalValue>
        <name>Update Account Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>assign_Case_to_Enterprise_Proposal_Team</fullName>
        <description>assign Case to Enterprise Proposal Team queue when status = assigned</description>
        <field>OwnerId</field>
        <lookupValue>Proposal_Delivery_Unit</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>assign Case to Enterprise Proposal Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>assign_to_Sales_Solutions_Support</fullName>
        <description>assign to &apos;Sales Solutions Support&apos; queue</description>
        <field>OwnerId</field>
        <lookupValue>Sales_Solutions_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>assign to Sales Solutions Support</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Cancellation Case Submitted</fullName>
        <actions>
            <name>Account_Structure_Cancellation_Notification_when_case_status_is_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Notification sent Case Owner when Account cancellation case status submitted.</description>
        <formula>RecordType.Name = &apos;Account Cancellation&apos; &amp;&amp;  ISPICKVAL(Status, &quot;Submitted&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Case to Enterprise Proposal Team</fullName>
        <actions>
            <name>assign_Case_to_Enterprise_Proposal_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <description>Automatically assign Case to Enterprise Proposal Team when Status changes to Assigned</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Dearborn IL Routing</fullName>
        <actions>
            <name>Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_D_IL_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, TEXT(Account.HCSC_Division__c) = &apos;IL&apos;,  IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Dearborn&apos;), True, False),  OR(Account.Total_Projected_Health_Members__c &gt; 50, Account.Active_Health_Members__c &gt; 50))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Dearborn Other UW Routing</fullName>
        <actions>
            <name>Email_Dearborn_Other_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_DO_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, OR(TEXT(Account.HCSC_Division__c) = &apos;TX&apos;, TEXT(Account.HCSC_Division__c) = &apos;NM&apos;, TEXT(Account.HCSC_Division__c) = &apos;OK&apos;, TEXT(Account.HCSC_Division__c) = &apos;MT&apos;),  IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Dearborn&apos;), True, False),  OR(Account.Total_Projected_Health_Members__c &gt; 50, Account.Active_Health_Members__c &gt; 50))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Default Routing</fullName>
        <actions>
            <name>Email_Private_Exchange_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_PE_BD_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, OR(TEXT(Account.HCSC_Division__c) = &apos;IL&apos;, TEXT(Account.HCSC_Division__c) = &apos;TX&apos;, TEXT(Account.HCSC_Division__c) = &apos;MT&apos;, TEXT(Account.HCSC_Division__c) = &apos;NM&apos;, TEXT(Account.HCSC_Division__c) = &apos;OK&apos;), AND(Account.Total_Projected_Health_Members__c &lt; 51, Account.Active_Health_Members__c &lt; 51), NOT(ISNULL(Exchange_Lines_of_Business__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Dental UW Routing</fullName>
        <actions>
            <name>Email_Dental_UW_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_D_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, OR(TEXT(Account.HCSC_Division__c) = &apos;IL&apos;, TEXT(Account.HCSC_Division__c) = &apos;TX&apos;, TEXT(Account.HCSC_Division__c) = &apos;NM&apos;, TEXT(Account.HCSC_Division__c) = &apos;OK&apos;, TEXT(Account.HCSC_Division__c) = &apos;MT&apos;), IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Dental&apos;), True, False),  OR(Account.Total_Projected_Health_Members__c &gt; 50, Account.Active_Health_Members__c &gt; 50))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Medical MM MT Routing</fullName>
        <actions>
            <name>Email_Medical_MT_151_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_M_MM_MT_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, TEXT(Account.HCSC_Division__c) = &apos;MT&apos;,  IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Medical&apos;), True, False),  OR(AND(Account.Total_Projected_Health_Members__c &gt; 50, Account.Total_Projected_Health_Members__c &lt; 151), AND(Account.Active_Health_Members__c &gt; 50, Account.Active_Health_Members__c &lt; 151)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Medical MM OK Routing</fullName>
        <actions>
            <name>Email_Medical_OK_151_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_M_MM_OK_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, TEXT(Account.HCSC_Division__c) = &apos;OK&apos;,  IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Medical&apos;), True, False),  OR(AND(Account.Total_Projected_Health_Members__c &gt; 50, Account.Total_Projected_Health_Members__c &lt; 151), AND(Account.Active_Health_Members__c &gt; 50, Account.Active_Health_Members__c &lt; 151)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Medical NM Routing</fullName>
        <actions>
            <name>Email_Medical_UW_Blue_Directions</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_M_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, TEXT(Account.HCSC_Division__c) = &apos;NM&apos;,  IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Medical&apos;), True, False),  OR(AND(Account.Total_Projected_Health_Members__c &gt; 50, Account.Total_Projected_Health_Members__c &lt; 151), AND(Account.Active_Health_Members__c &gt; 50, Account.Active_Health_Members__c &lt; 151)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Child Medical Other UW Routing</fullName>
        <actions>
            <name>Email_Medical_UW_Blue_Directions</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_BD_M_UW_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, OR(TEXT(Account.HCSC_Division__c) = &apos;TX&apos;, TEXT(Account.HCSC_Division__c) = &apos;NM&apos;, TEXT(Account.HCSC_Division__c) = &apos;OK&apos;, TEXT(Account.HCSC_Division__c) = &apos;MT&apos;, TEXT(Account.HCSC_Division__c) = &apos;IL&apos;),  IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Medical&apos;), True, False),  OR(Account.Total_Projected_Health_Members__c &gt; 150, Account.Active_Health_Members__c &gt; 150))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blue Directions Parent Routing</fullName>
        <actions>
            <name>Email_Private_Exchange_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_PE_BD_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Exchange_Sub_Case__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Private Exchange - Blue Directions</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calculate Time in Waiting for Information</fullName>
        <actions>
            <name>Populate_Time_Waiting_For_Information</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Rule to populate the field &quot;Time in Waiting for Information&quot;</description>
        <formula>ISBLANK(PRIORVALUE(Waiting_For_Information_End_Date__c)) &amp;&amp; NOT(ISBLANK(Waiting_For_Information_End_Date__c)) &amp;&amp; (Waiting_For_Information_End_Date__c &gt; Waiting_For_Information_Start_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Assigned</fullName>
        <actions>
            <name>Case_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISCHANGED(Status) &amp;&amp;  ISPICKVAL(Status,&apos;Assigned&apos; )   &amp;&amp;  (RecordType.Name==&apos;Proposal&apos; || RecordType.Name==&apos;Network Information&apos; ),true,false  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Changed</fullName>
        <actions>
            <name>Update_Execute_Rule_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to Reset the Execute Rule checkbox to false every time the Status on Case is changed.</description>
        <formula>Execute_Rule__c &amp;&amp; ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Closed</fullName>
        <actions>
            <name>Case_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISCHANGED(Status) &amp;&amp; ISPICKVAL(Status,&apos;Closed&apos; ) &amp;&amp; (RecordType.Name==&apos;Proposal&apos; || RecordType.Name==&apos;Network Information&apos; || RecordType.Name == &apos;Underwriting&apos; ),true,false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cede Case Renewal</fullName>
        <actions>
            <name>New_Cede_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cede</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Account_Type__c</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Check if Priv Ex Blue Directions Case Status Changed</fullName>
        <actions>
            <name>Send_Email_to_Private_Exchange_Blue_Directions_Queue_When_Status_has_Changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Check if a Private Exchange Blue Directions Case Status has been changed.</description>
        <formula>ISCHANGED(Status)&amp;&amp; RecordType.DeveloperName = &apos;Private_Exchange_Blue_Directions&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check if Priv Ex External Case Status Changed</fullName>
        <actions>
            <name>Send_Email_to_Private_Exchange_External_Queue_When_Status_has_Changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Check if Private Exchange External Case Status has been changed</description>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName = &apos;Private_Exchange_External&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check if Private Exchange Blue Directions have been modified</fullName>
        <actions>
            <name>Email_Blue_Directions_Private_Exchange_When_Case_Modified</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(LastModifiedDate) &amp;&amp;  RecordType.DeveloperName  = &apos;Private_Exchange_Blue_Directions&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check if Private Exchange External have been modified</fullName>
        <actions>
            <name>Email_External_Private_Exchange_When_Case_Modified</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(LastModifiedDate) &amp;&amp;  RecordType.DeveloperName = &apos;Private_Exchange_External&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contract Signer Change Notification</fullName>
        <actions>
            <name>Notify_Contract_Admin_of_Signer_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email notification to the contract signer queue when the contract signer changes on an active contract.</description>
        <formula>AND( RecordType.Name = &apos;Custom Contracts&apos;,  AND( ISCHANGED( Full_Name__c), NOT(ISNULL(PRIORVALUE(Full_Name__c))) ), OR(ISPICKVAL(Status, &apos;Final Sent to Sales &amp; Marketing&apos;), ISPICKVAL(Status, &apos;Out for DOI Approval&apos;), ISPICKVAL(Status, &apos;Out for Signature by AE&apos;), ISPICKVAL(Status, &apos;Plan President Approval Received&apos;), ISPICKVAL(Status, &apos;Request from Sales &amp; Marketing, Draft&apos;), ISPICKVAL(Status, &apos;Sales &amp; Marketing Returns Draft&apos;), ISPICKVAL(Status,&apos;Out for Signature by Contract Specialist&apos;),ISPICKVAL(Status, &apos;Internal HCSC SME Review&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Create a task for Performance Guarantee</fullName>
        <actions>
            <name>Email_case_details_to_PG_team_and_Underwriting</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Performance Guarantee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fully Executed Status Update Notification</fullName>
        <actions>
            <name>Email_Alert_Fully_Executed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This wf is used to send email alert to user owner when case status is updated to fully executed.</description>
        <formula>ISCHANGED(Status) &amp;&amp; Text(Status)=&apos;Fully Executed&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS AEP Checked  Account Sub Rule</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_AEP_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>ccount has AEP then email to go out to EEE business area after intake process is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS AEP Checked  Account Submission Rule</fullName>
        <actions>
            <name>GEMS_AEP_EEE_Checked_Account_Submission_alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_AEP_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>ccount has AEP then email to go out to EEE business area after intake process is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Acc Submission Complete Date Update WithoutSignedBPA</fullName>
        <actions>
            <name>GEMS_Completed_Date_Update_WithoutSigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Completed Date when Account Submission Case status is updated to &apos;Completed – Without SIGNED BPA&apos;</description>
        <formula>AND(    RecordType.Name== &apos;GEMS Account Submission&apos;,    TEXT( Status ) = &apos;Completed – Without SIGNED BPA&apos;  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Accnt Str%2E Clent Approval Received with Changes</fullName>
        <actions>
            <name>GEMS_Accnt_Str_Client_Approval_Received_with_Changes</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Structure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Structure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Client Approval Received with Changes</value>
        </criteriaItems>
        <description>Notification to the Account Structure Creator when  status in GEMS continue as  &apos;Client Approval Received with Changes&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Accnt Str%2E Client Approval Received</fullName>
        <actions>
            <name>GEMS_Accnt_Structure_Client_Approval_Received_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Structure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Structure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Client Approval Received</value>
        </criteriaItems>
        <description>Notify when GEMS Account Structure Client Approval Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Account Terminated</fullName>
        <actions>
            <name>GEMS_Account_Terminated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.GEMS_Submission_Type__c</field>
            <operation>equals</operation>
            <value>Cancellation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Account str Client Approval Recvd 2 Days</fullName>
        <actions>
            <name>GEMS_Acc_Str_Client_Appr_Pending_2_days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Client Approval Pending</value>
        </criteriaItems>
        <description>Send reinder Emial when client approval received is waiting for than 2 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_structure_waiting_for_Client_approval_recevd_more_than_2_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.GEMS_Client_approval_pending__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS Account str Client Approval Recvd 4 Days</fullName>
        <actions>
            <name>GEMS_Acc_Str_Client_Appr_Pending_2_days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Client Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Structure</value>
        </criteriaItems>
        <description>Send reinder Emial when client approval received is waiting for than 4 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_structure_waiting_for_Client_approval_recevd_more_than_4_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.GEMS_Client_approval_pending__c</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS Account str Internal Approval Pending 2 Days</fullName>
        <actions>
            <name>GEMS_Acc_Str_Intern_Appr_Pending_2_days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Internal Approval Pending</value>
        </criteriaItems>
        <description>Send reinder Emial when client approval received is waiting for than 2 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Account_Structure_Internal_Approval_received_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.GEMS_Internal_Approval_Pending__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS BCC Product Sold Rule</fullName>
        <actions>
            <name>GEMS_BCC_Product_Sold</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>BCC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Benefit Booklet Checked</fullName>
        <actions>
            <name>Gems_Accnt_submission_Benefit_Booklet_required_checked</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Benefit_Booklet_Required__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Blue Direction%28Product%29 Account subm Rule</fullName>
        <actions>
            <name>GEMS_Account_Submission_Blue_Direction_Creation_Rule</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>Blue Directions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>an email notification sent once the submission process is complete in GEMS for accounts with BlueDirections product</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS CDHP %28Product%29 Account Submission Rule</fullName>
        <actions>
            <name>GEMS_Screening_Created_CDHP_product_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>8 AND (1 OR 2 OR 3 OR 4) AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>HCA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>HSA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>FSA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>HRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_StdCust_Product__c</field>
            <operation>notEqual</operation>
            <value>Standard Products only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <description>Gems notification when CDHP product selected and account submission completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Dental Membership Account submission Rule</fullName>
        <actions>
            <name>GEMS_Dental_Membership_Account_Submission_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>contains</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>Dental</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Dental benefit Coding Screening Rule</fullName>
        <actions>
            <name>GEMS_Screening_Created_Dental_Benefit_Coding_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>contains</operation>
            <value>GEMS BA Level Screening</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Category__c</field>
            <operation>contains</operation>
            <value>Dental Benefit Coding Screening</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>Rule will fire when CDHP Tax Screening created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS EEE Approval Pending</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Internal Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_EEE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_CDHP_Operations__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Dental_Benefit_Coder__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Send_reminder_EEE</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS EEE Re-approval Rule</fullName>
        <actions>
            <name>GEMS_Re_Approval_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Structure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Internal Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_EEE_rejected_action__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS EEE%2BCDHP Approval Pending</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Internal Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_EEE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_CDHP_Operations__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Dental_Benefit_Coder__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Send_reminder_EEE_CDHP</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS EEE%2BCDHP%2BDental Approval Pending</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_CDHP_Operations__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_EEE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Dental_Benefit_Coder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Send_reminder_EEE_CDHP_Dental</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS EEE%2BDental Approval Pending</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Internal Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_EEE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_CDHP_Operations__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Dental_Benefit_Coder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Send_reminder_EEE_Dental</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GEMS FSU Membership Account submission Rule</fullName>
        <actions>
            <name>GEMS_FSU_Membership_Account_Submission_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>contains</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS FSU Membership UW production ready Rule</fullName>
        <actions>
            <name>GEMS_FSU_Membership_UW_Medical_Production_ready_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Membership</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Membership</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>When all  underwriting Completed than trigger this mail</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Medical Benefit Coding AssignBack Case</fullName>
        <actions>
            <name>GEMS_Medical_Benefit_Coding_AssignBack_Case_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.Name == &quot;GEMS BA Level Medical Benefit Coding&quot;, ISPICKVAL(Status, &quot;In Progress&quot;), ISPICKVAL(PRIORVALUE(Status),&quot;Return&quot;),  ISCHANGED(OwnerId )   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Medical Benefit Coding Return Case</fullName>
        <actions>
            <name>GEMS_Medical_Benefit_Coding_Return_Case_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.Name == &quot;GEMS BA Level Medical Benefit Coding&quot;,ISPICKVAL(Status, &quot;Return&quot;),ISCHANGED(OwnerId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Medical Membership Account submission Rule</fullName>
        <actions>
            <name>GEMS_Medical_Membership_Account_Submission_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>contains</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>BCC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Products__c</field>
            <operation>includes</operation>
            <value>Blue Care Connection</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS PG notification for Acc Submission Creation and Updates</fullName>
        <actions>
            <name>Email_PG_Group_when_case_with_PG_Yes_is_created_or_modified</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR (4 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Performance_Guarantees__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Submission_Type__c</field>
            <operation>equals</operation>
            <value>New Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Submission_Type__c</field>
            <operation>contains</operation>
            <value>Renewal,Off Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Submission_Sub_Type__c</field>
            <operation>includes</operation>
            <value>Account Structure Change</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Parent Case Owner Assignment</fullName>
        <actions>
            <name>GEMS_Parent_Case_Owner_Assignment_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify user when GEMS Parent case owner change</description>
        <formula>ISCHANGED(OwnerId) &amp;&amp; GEMS_Flag__c ==TRUE &amp;&amp;  GEMS_Benefit_Agreement__c ==  &apos;&apos; &amp;&amp; (PRIORVALUE(Status)!= &apos;Return&apos; &amp;&amp; TEXT(Status)!=&apos;Return&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS Pharmacy Coding Return Case</fullName>
        <actions>
            <name>GEMS_Pharmacy_Coding_Return_Case_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.Name == &quot;GEMS BA Level Pharmacy Coding&quot;,ISPICKVAL(Status, &quot;Return&quot;),ISCHANGED(OwnerId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS SBC Account Submission Rule</fullName>
        <actions>
            <name>GEMS_SBC_Account_Submission_Rule</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_Type__c</field>
            <operation>contains</operation>
            <value>Account Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GEMS_SBC_Required__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>Send notification when SBC is checked and account submission is In Progress</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GEMS_CaseOwners_manager_EmailID_AccSubmitterEmailId_Update</fullName>
        <actions>
            <name>Owner_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates email ID of manager of Case owner and Account Submitter Email ID (Account Submission case owner email id).

1. 9/30/16 Added &apos;GEMS Eligibility&apos; for EEE Notification to Account Submitter
2. 10/3/16 Added &quot;GEMS BA Level SBC&quot; for SBC</description>
        <formula>AND (      OR( 		RecordType.Name==&apos;GEMS Screening&apos;, 		RecordType.Name==&apos;GEMS Medical Benefit Coding&apos;, 		RecordType.Name==&apos;GEMS Account Setup&apos;, 		RecordType.Name==&apos;GEMS Pharmacy Coding&apos;, 		RecordType.Name==&apos;GEMS Dental Benefit Coding&apos;, 		RecordType.Name==&apos;GEMS SBC&apos;,                 RecordType.Name==&apos;GEMS BA Level SBC&apos;, 		RecordType.Name==&apos;GEMS Medical Underwriting&apos;, 		RecordType.Name==&apos;GEMS Dental Underwriting&apos;, 		RecordType.Name==&apos;GEMS Additional Underwriting&apos;, 		RecordType.Name==&apos;GEMS Eligibility&apos; 	),     NOT( ISNULL(OwnerId) ),     NOT( ISNULL(GEMS_Account_Submission_Info__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS_Case_Submitter_Email_Id_Update</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS Account Submission</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Gems SBC creation Notification workflow</fullName>
        <actions>
            <name>Gems_SBC_creation_notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS SBC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>SBC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inquiry Case open 72 hours</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Inquiry Case has been open for more than 72 hours</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Inquiry_Case_open_72_hours_email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Inquiry Status Completed</fullName>
        <actions>
            <name>Inquiry_Case_Completed_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>the status of the Inquiry case has been updated to completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Network Information Case  Closed Notification</fullName>
        <actions>
            <name>Network_Information_Case_Closed_Notification_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Network Information</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Inquiry Case</fullName>
        <actions>
            <name>assign_to_Sales_Solutions_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Segment__c</field>
            <operation>notEqual</operation>
            <value>SG,ALI,COMA,HMSG,IMTS,OKCA,OKSA,SGAR,SGN,SGTR,SMRP,TCF,TULA,MLAS,MARS</value>
        </criteriaItems>
        <description>a new Inquiry case has been created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Owner about Due Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Underwriting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Notify owners when Underwriting Due Date is approaching</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_owners_when_Underwriting_Due_Date_is_approaching</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Underwriting_Due_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Underwriting_Due_Date_has_passed</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Underwriting_Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notify user when they are assigned a case</fullName>
        <actions>
            <name>Notify_user_when_they_are_assigned_a_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId) &amp;&amp; RecordType.DeveloperName != &apos;SG_General_Case&apos; &amp;&amp;    GEMS_Flag__c !=TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify_Private_Exchange_Case_Owner_On_Close</fullName>
        <actions>
            <name>Case_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Private Exchange - Blue Directions,Private Exchange - External</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Exchange_Sub_Case__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When a Private Exchange - Blue Directions or Private Exchange - External case is moved to &apos;Closed,&apos; an email is sent to the case&apos;s creator to let them know that it is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner change from Queue</fullName>
        <actions>
            <name>Owner_From_queue_to_user</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case owner change from IL, TX, OK queue to a user</description>
        <formula>AND(     ISCHANGED( OwnerId ),      BEGINS(PRIORVALUE(OwnerId),&apos;00G&apos;),     NOT(ISBLANK(Owner:User.Id)),      NOT( AND(  ISNEW()   ,          BEGINS(RecordType.Name, &apos;GEMS&apos;)          )     )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PG Team Notification of Case Ownership</fullName>
        <actions>
            <name>PG_Team_Notification_of_PG_Case_Ownership</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification will go to PG Team when they become Owner of a PG case.</description>
        <formula>AND(ISCHANGED(Owner_Name__c), Owner_Name__c = &apos;PG Team&apos;, RecordType.Name = &apos;Performance Guarantee&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PGCaseClosedNotification</fullName>
        <actions>
            <name>Email_PG_Case_Creator_When_Case_Closed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_PG_Case_Requestor_When_Case_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Performance Guarantee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Withdrawn,Approved,Denied</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PGCaseSendBackAction</fullName>
        <actions>
            <name>Email_PG_Case_Creator_when_Status_is_Send_Back_for_More_Info</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_PG_Case_Requestor_when_Status_is_Send_Back_for_More_Info</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &apos;Performance_Guarantee&apos; &amp;&amp;  TEXT(Status) = &apos;Sent Back for More Info&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Performace Guarantee Email Reminder Submit</fullName>
        <active>true</active>
        <booleanFilter>1 AND( 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Performance Guarantee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>A reminder to the case owner to submit the case after 2 days of it not being submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>reminder_to_submit_PG_case</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Case in WFI Start Date</fullName>
        <actions>
            <name>Clear_Waiting_for_Information_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Waiting_for_Information_Start_D</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting for Information</value>
        </criteriaItems>
        <description>This rule is to populate the field Waiting for Information Start Date with the day a case enters the status of Waiting for Information</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Date%2F Time Case Declined</fullName>
        <actions>
            <name>Populate_Date_Time_Case_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <description>Rule to populate the case field &quot;Date/Time Declined&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Proposed Employee Contribution</fullName>
        <actions>
            <name>Populate_Proposed_Dependent_Contribution</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Proposed_Employee_Contribution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Employer_Contribution_Same_as_Current__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Waiting for Information End D</fullName>
        <actions>
            <name>Populate_Waiting_for_Information_End_D</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Waiting_For_Information_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Waiting for Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Waiting_For_Information_End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This rule is to populate the field Waiting for Information End Date with the day a case enters the status of Waiting for Information</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pre Populate UW Due Date for IL</fullName>
        <actions>
            <name>Populate_Underwriting_Due_Date_IL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Prepopulate the UW due date for IL cases</description>
        <formula>Owner:User.Profile.Name =&apos;Underwriting&apos; &amp;&amp;  ISPICKVAL(HCSC_Division__c,&apos;IL&apos;) &amp;&amp; RecordType.Name = &apos;Underwriting&apos; &amp;&amp;  ISBLANK(Underwriting_Due_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prepopulate Underwriting Due Date</fullName>
        <actions>
            <name>Populate_Underwriting_Due_Date_v3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Underwriting_Due_Date_v4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.Name = &apos;Underwriting&apos;, ISNULL(PRIORVALUE(Date_Assigned_to_Underwriting__c)),NOT(ISNULL(Date_Assigned_to_Underwriting__c)),NOT( ISPICKVAL(HCSC_Division__c,&apos;IL&apos;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Private Exchange - Blue Directions notification</fullName>
        <actions>
            <name>Private_Exchange_Blue_Directions_email_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Record_update_counter__c)  &amp;&amp;  RecordType.Name ==&apos;Private Exchange - Blue Directions&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Private Exchange - External notification</fullName>
        <actions>
            <name>Private_Exchange_External_email_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_PE_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Record_update_counter__c)  &amp;&amp;  RecordType.Name ==&apos;Private Exchange - External&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Private Exchange Blue Directions Child Routing</fullName>
        <actions>
            <name>Email_Private_Exchange_Blue_Directions_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_PE_BD_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Status) = &apos;Assigned&apos;,  RecordType.Name = &apos;Private Exchange - Blue Directions&apos;, Exchange_Sub_Case__c = True, OR(TEXT(Account.HCSC_Division__c) = &apos;IL&apos;, TEXT(Account.HCSC_Division__c) = &apos;TX&apos;), IF(INCLUDES(Exchange_Lines_of_Business__c, &apos;Medical&apos;), True, False),  OR(AND(Account.Total_Projected_Health_Members__c &gt; 50, Account.Total_Projected_Health_Members__c &lt; 151), AND(Account.Active_Health_Members__c &gt; 50, Account.Active_Health_Members__c &lt; 151)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Private Exchange Email Reminder Submit</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Private Exchange - Blue Directions,Private Exchange - External</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New,In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Private_Exchange_Email_Notification_Submit</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Private Exchange External Child Routing</fullName>
        <actions>
            <name>Email_Medical_UW_External_Exchange</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_PE_EU_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Exchange_Sub_Case__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Private Exchange - External</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Private Exchange External Parent Routing</fullName>
        <actions>
            <name>Email_Private_Exchange_External_Group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Case_to_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Exchange_Sub_Case__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Private Exchange - External</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Proposal Case Task Creation</fullName>
        <actions>
            <name>Update_Proposal_Task_Created_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Confirm_requests_are_sent_to_UW_PG_and_CBSR_teams</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Finalize_RFP_RFI_response</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Route_proposal_draft_to_sales_account_management_and_SMEs</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_SME_solicitation_emails</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Upload_and_package_completed_proposal</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Proposal_Task_Created__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Tasks will be created for proposal cases when the status is changed to Assigned</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove PE External Guideline</fullName>
        <actions>
            <name>Update_PE_External_Guideline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Group_Exchange_Platform__c</field>
            <operation>equals</operation>
            <value>Aon Hewitt Active Exchange,Buck / Right Opt,Aon Hewitt Mid Market Exchange,Mercer Marketplace</value>
        </criteriaItems>
        <description>Remove the value of Private exchange guideline External when Group Exchange Platform is updated to include any of these values: Aon Hewitt Active Exchange,Buck / Right Opt,Aon Hewitt Mid Market Exchange,Mercer Marketplace</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route NI Cases to NI Queue</fullName>
        <actions>
            <name>Update_Case_Owner_to_NI_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a Sales or Account Manager changes a NI case&apos;s status to Assigned the owner of the case is then changed to the NI Queue</description>
        <formula>AND( RecordType.Name = &apos;Network Information&apos;, OR( $Profile.Name = &apos;LGNA - Sales&apos;, $Profile.Name = &apos;LGNA - Account Management&apos; ), ISPICKVAL(Status, &apos;Assigned&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route PG Cases to PG Queue</fullName>
        <actions>
            <name>Update_Case_Owner_to_PG_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a Sales or Account Manager changes a PG case&apos;s status to submitted the owner of the case is then changed to the PG Queue</description>
        <formula>AND( RecordType.Name = &apos;Performance Guarantee&apos;, OR( $Profile.Name = &apos;LGNA - Sales&apos;, $Profile.Name = &apos;LGNA - Account Management&apos; ), ISPICKVAL(Status, &apos;Submitted&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR Enquiry</fullName>
        <actions>
            <name>Case_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR (2 AND 3))</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SGR Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market_Segment__c</field>
            <operation>equals</operation>
            <value>SG,ALI,COMA,HMSG,IMTS,OKCA,OKSA,SGAR,SGN,SGTR,SMRP,TCF,TULA,MLAS,MARS</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SGR_Remove Submit to Verifier</fullName>
        <actions>
            <name>SGR_Remove_Submit_to_Verifier_Button</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>PRIORVALUE( Reason )!=&apos;Business Rule Validation Fallout&apos; &amp;&amp; ISPICKVAL(Reason,&apos;Business Rule Validation Fallout&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR_Updare_caseowner</fullName>
        <actions>
            <name>Update_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SGR-Renewals</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR_Update Case Fields</fullName>
        <actions>
            <name>Update_Case_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Additional_Input_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Turn off Proposal Case Validation Bypass</fullName>
        <actions>
            <name>Update_Bypass_Validation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Bypass_Validation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Producer House</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Underwriting Case Closed Mail</fullName>
        <actions>
            <name>Notify_Requester_For_Case_Completion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Underwriting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Underwriting Case Declined</fullName>
        <actions>
            <name>Notify_sales_when_underwriting_declines_to_quote</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Underwriting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Type on Cede Case</fullName>
        <actions>
            <name>Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>As a Account executive entering a CEDE Case into salesforce. The following field should be be pulled over from the account.
Account Type - Prospect or Renewal
If no Account number = Prospect, If account number = Renewal</description>
        <formula>AND( RecordTypeId  = &apos;01233000000IgPk&apos;, ISBLANK(Account.External_ID__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Date Submitted For Legal Review</fullName>
        <actions>
            <name>Update_Date_Submitted_For_Legal_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Submitted for Legal Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Date_Submitted_For_Legal_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When status is changed to be legal review, change Date Submitted For Legal Review to be &apos;Now&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Internal Field</fullName>
        <actions>
            <name>Update_Internal_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update internal field on Case object based on web email domain address</description>
        <formula>CONTAINS(SuppliedEmail,&quot;@bcbsok.com&quot;) ||  CONTAINS(SuppliedEmail,&quot;@bcbsil.com&quot;) ||  CONTAINS(SuppliedEmail,&quot;@bcbstx.com&quot;) ||  CONTAINS(SuppliedEmail,&quot;@bcbsmt.com&quot;) ||  CONTAINS(SuppliedEmail,&quot;@bcbsnm.com&quot;) ||  CONTAINS(SuppliedEmail,&quot;@hcsc.net&quot;) || CONTAINS(SuppliedEmail,&quot;@dnoa.com&quot;) || CONTAINS(SuppliedEmail,&quot;@dearbornnational.com&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Plan President Approval Date</fullName>
        <actions>
            <name>Update_Plan_President_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Plan President Approval Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Plan_President_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When status equals Plan President Approval Received, change Plan President Approval Date to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>A_POR_or_Partial_BOB_change_has_been_requested</fullName>
        <assignedToType>owner</assignedToType>
        <description>A POR or Partial BOB change has been requested</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Closed</status>
        <subject>A POR or Partial BOB change has been requested for account {!Case.Account}_{!Case.Account_Number__c}</subject>
    </tasks>
    <tasks>
        <fullName>Confirm_requests_are_sent_to_UW_PG_and_CBSR_teams</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Mail_Date_Due_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Confirm requests are sent to UW, PG and CBSR teams</subject>
    </tasks>
    <tasks>
        <fullName>Email_case_details_to_PG_team_and_Underwriting</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please save printable view of case details and email to Underwriting and PGRequestHCSC@bcbstx.com.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Email case details to PG team and Underwriting</subject>
    </tasks>
    <tasks>
        <fullName>Finalize_RFP_RFI_response</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Mail_Date_Due_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Finalize RFP/RFI response</subject>
    </tasks>
    <tasks>
        <fullName>Route_proposal_draft_to_sales_account_management_and_SMEs</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Mail_Date_Due_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Route proposal draft to sales, account management and SMEs</subject>
    </tasks>
    <tasks>
        <fullName>Send_SME_solicitation_emails</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Mail_Date_Due_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send SME solicitation emails</subject>
    </tasks>
    <tasks>
        <fullName>Upload_and_package_completed_proposal</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Mail_Date_Due_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Upload and package completed proposal</subject>
    </tasks>
</Workflow>
