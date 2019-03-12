<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_AE</fullName>
        <description>Alert AE</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Executive</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Email_Templates/Account_Health_Member_Alert</template>
    </alerts>
    <alerts>
        <fullName>Email_Account_Owner_and_Executives_reminders_to_create_Strategic_Plans</fullName>
        <description>Email Account Owner and Executives reminders to create Strategic Plans</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Executive</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Templates/Create_Strategic_Plan_Reminder_Template</template>
    </alerts>
    <alerts>
        <fullName>Enter_claim_stopcode_Account_Receivables</fullName>
        <ccEmails>acctsreceiv@bcbsil.com</ccEmails>
        <description>Enter claim stopcode for Account Receivables</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Account_Templates/Claim_Stop_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Enter_claim_stopcode_in_Bluestar</fullName>
        <description>Enter claim stopcode in Bluestar for Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Account_Templates/Claim_Stop_Reminder_for_account_owner</template>
    </alerts>
    <alerts>
        <fullName>Enter_claim_stopcode_in_Bluestar_for_Account_Owner</fullName>
        <description>Enter claim stopcode in Bluestar for Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Account_Templates/Claim_Stop_Reminder_for_account_owner</template>
    </alerts>
    <alerts>
        <fullName>Enter_claim_stopcode_in_Bluestar_for_Account_Receivables</fullName>
        <ccEmails>acctsreceiv=bcbsil.com@example.com</ccEmails>
        <description>Enter claim stopcode in Bluestar for Account Receivables</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Account_Templates/Claim_Stop_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Prospect_Created_for_Cancelled_Account</fullName>
        <description>Prospect Created for Cancelled Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Solution_Prep_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Account_Templates/Prospect_Created_for_Cancelled_Group_Account</template>
    </alerts>
    <alerts>
        <fullName>Update_Producer_Account_Owner_on_Parent_Change</fullName>
        <description>Update Producer Account Owner on Parent Change</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Templates/ProducerHouseUpdateTemplate</template>
    </alerts>
    <alerts>
        <fullName>X90_Day_Risk_Level_Notification_2</fullName>
        <description>90 Day Risk Level Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Account_Templates/Risk_Level</template>
    </alerts>
    <fieldUpdates>
        <fullName>AR_Cancellation_Flag_to_Blank</fullName>
        <description>When Account cancellation request rejected then AR Cancellation Flag field should be blank.</description>
        <field>AR_Cancellation_Flag__c</field>
        <name>AR Cancellation Flag to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Cancellation_Status_Rejected</fullName>
        <description>Updates the Account Cancellation Status to Cancellation Rejected.</description>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancellation Rejected</literalValue>
        <name>Account Cancellation Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Cancellation_Status_to_Cancelled</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Account Cancellation Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Cancellation_Submitted_Date</fullName>
        <field>Cancellation_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>Account Cancellation Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Cancelled</fullName>
        <description>Updates the Account&apos;s Cancellation status to Cancelled</description>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Account Cancellation Status Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancellation_Status_to_Requested_Cancel</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Requested Cancellation</literalValue>
        <name>Cancellation Status to Requested Cancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancelled_Health_Contracts</fullName>
        <description>Populates the Cancelled Health Contracts field with the Active Health Contracts field value.</description>
        <field>Cancelled_Health_Contracts__c</field>
        <formula>Active_Health_Subscribers__c</formula>
        <name>Cancelled Health Contracts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancelled_Health_Members</fullName>
        <description>Populates the Cancelled Health Members field with the Active Health Members field value.</description>
        <field>Cancelled_Health_Members__c</field>
        <formula>Active_Health_Members__c</formula>
        <name>Cancelled Health Members</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Carry_Dental_Members_to_New</fullName>
        <description>Sets the Dental Members to New</description>
        <field>New_Active_Dental_Members__c</field>
        <formula>Active_Dental_Members__c</formula>
        <name>Carry Dental Members to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Carry_Health_Member_to_New</fullName>
        <description>Sets the Health Member to New</description>
        <field>New_Active_Health_Members__c</field>
        <formula>Active_Health_Members__c</formula>
        <name>Carry Health Member to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Cancelled_Health_Contracts</fullName>
        <description>Clear the field value for Cancelled Health Contracts</description>
        <field>Cancelled_Health_Contracts__c</field>
        <name>Clear Cancelled Health Contracts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Cancelled_Health_Members</fullName>
        <description>Clear the field value for Cancelled Health Members</description>
        <field>Cancelled_Health_Members__c</field>
        <name>Clear Cancelled Health Members</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Tax_ID_for_Producers_Field_Update</fullName>
        <description>Clears the Tax ID for all producers where the type is HCSC Employee</description>
        <field>Tax_ID__c</field>
        <name>Clear Tax ID for Producers Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Depopulate_claim_stop_date</fullName>
        <field>Claim_Stop_Date__c</field>
        <name>Depopulate claim stop date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Health_Dental_Date_to_Prior_Date</fullName>
        <field>Health_Dental_Members_Carry_Over_Date__c</field>
        <formula>DATE(1992,01,01)</formula>
        <name>Health Dental Date to Prior Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_BlueStar_Account_Record_Type_Update</fullName>
        <description>This field update will be used to convert Prospect Non BlueStar Accounts to Group Non BlueStar Accounts</description>
        <field>RecordTypeId</field>
        <lookupValue>Group_Account_Non_BlueSTAR</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Non BlueStar Account Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_BlueStar_Account_Status_to_Active</fullName>
        <description>This field update will be used to update the Non BlueStar Group Account Status to &quot;Active&quot; when the Prospect Non BlueStar Account is updated to &quot;Sold&quot; Status</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Non BlueStar Account Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Claim_Stop_Date</fullName>
        <field>Claim_Stop_Date__c</field>
        <formula>TODAY() + 365</formula>
        <name>Populate Claim Stop Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Chatter_30_Days_Before</fullName>
        <field>Account_Renewal_Notification_Indicator__c</field>
        <formula>&quot;30_Days_Before&quot;</formula>
        <name>Renewal Chatter 30 Days Before</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Chatter_7_Days_Before</fullName>
        <field>Account_Renewal_Notification_Indicator__c</field>
        <formula>&quot;7_Days_Before&quot;</formula>
        <name>Renewal Chatter 7 Days Before</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Chatter_90_Days_Before</fullName>
        <field>Account_Renewal_Notification_Indicator__c</field>
        <formula>&quot;90_Days_Before&quot;</formula>
        <name>Renewal Chatter 90 Days Before</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Forcast_Segment</fullName>
        <field>Forecast_Segment__c</field>
        <literalValue>Small Group</literalValue>
        <name>SGR Forcast Segment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Actively_Purchasing</fullName>
        <description>Sets the Account status to actively purchasing</description>
        <field>Status__c</field>
        <literalValue>Actively Purchasing</literalValue>
        <name>Set Status to Actively Purchasing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_In_Negotiation</fullName>
        <description>Status is set to in negotiation on the account</description>
        <field>Status__c</field>
        <literalValue>In Negotiations</literalValue>
        <name>Set Status to In Negotiation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Hold_enddate</fullName>
        <description>set Account Hold End Date and Hold Reason to Blank.</description>
        <field>Hold_End_Date__c</field>
        <name>Update Account Hold end date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_of_Prospect</fullName>
        <field>Date_of_Prospect__c</field>
        <formula>TODAY()</formula>
        <name>Update Date of Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Duration_of_Prospect</fullName>
        <field>Duration_of_client_in_Prospect_State__c</field>
        <formula>TODAY() - Date_of_Prospect__c</formula>
        <name>Update Duration of Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Manager_Approval_checkBox</fullName>
        <description>For Retro AR Cancellation need Manager and Underwriter Approval, This field updated based on Manager Approval</description>
        <field>Manager_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Update Manager Approval checkBox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_Members</fullName>
        <field>Previous_Active_Health_Members__c</field>
        <formula>PRIORVALUE(Active_Health_Members__c)</formula>
        <name>Update Previous Members</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prospect_Account_to_Uppercase</fullName>
        <field>Name</field>
        <formula>UPPER( Name )</formula>
        <name>Update Prospect Account to Uppercase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prospect_End_Date</fullName>
        <field>Prospect_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Prospect End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test1</fullName>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>test1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck</fullName>
        <description>un-check the checkbox.</description>
        <field>AutoCreateOpportunity__c</field>
        <literalValue>0</literalValue>
        <name>uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_checkbox</fullName>
        <field>AutoCreateOpportunity__c</field>
        <literalValue>1</literalValue>
        <name>update checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Immediate Cancellation Counts</fullName>
        <actions>
            <name>Cancelled_Health_Contracts</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Cancelled_Health_Members</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Cancellation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Populate the Cancelled Health Members and Cancelled Health Contracts fields with the number values from the Active Health Members and Active Health Contracts fields when an account has been cancelled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Immediate Cancellation Process</fullName>
        <actions>
            <name>Account_Cancellation_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Status_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF(OR(AND(ISPICKVAL(Cancellation_Status__c , &quot;Requested Cancellation&quot;),(Automated_Eligibility_Process__c = false), NOT(INCLUDES(Funding_Type__c , &quot;ASO&quot;))), AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &lt; 5), OR( Automated_Eligibility_Process__c = true, INCLUDES(Funding_Type__c , &quot;ASO&quot;)))), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Immediate Clear Cancellation Counts</fullName>
        <actions>
            <name>Clear_Cancelled_Health_Contracts</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Cancelled_Health_Members</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Cancelled_Health_Contracts__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Cancelled_Health_Members__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Clear the Cancelled Health Members and Cancelled Health Contracts fields when an account goes from a cancelled to a non-cancelled status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Renewal Chatter Notification</fullName>
        <active>true</active>
        <formula>Renewal_Date__c &gt;= TODAY() &amp;&amp;  $Profile.Name != &quot;Integration Profile&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Chatter_90_Days_Before</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Renewal_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Chatter_30_Days_Before</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Renewal_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Chatter_7_Days_Before</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Renewal_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account Time Based Cancellation Process</fullName>
        <active>false</active>
        <formula>IF( AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &gt;= 5) ,OR( Automated_Eligibility_Process__c = true,  INCLUDES(Funding_Type__c , &quot;ASO&quot;))) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_Cancellation_Status_to_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Account_Cancellation_Submitted_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Requested_Cancellation_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Auto Create Renewal Opp</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Renewal_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Auto Create a Renewal Opportunity when a Group Accounts Renewal date remaining days is 120 days left. (fires accountTriggerHandler.CreateRenewalOpportunity.)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>uncheck</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>update_checkbox</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Renewal_Date__c</offsetFromField>
            <timeLength>-120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Capture Prospect of account</fullName>
        <actions>
            <name>Update_Date_of_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>if(ISCHANGED( RecordTypeId) &amp;&amp;  RecordType.Name==&apos;Prospect&apos;,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Capture prospect period of accunt</fullName>
        <actions>
            <name>Update_Duration_of_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Prospect_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>if(ISCHANGED( RecordTypeId ) &amp;&amp; RecordType.Name!=&apos;Prospect&apos; &amp;&amp;  PRIORVALUE(RecordTypeId)==  $Label.Prospect_Record_Type_Id  ,true ,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Carry Value to New Active Health%2FDental Members</fullName>
        <active>false</active>
        <formula>ISCHANGED(Effective_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Claim Stop Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Funding_Type__c</field>
            <operation>equals</operation>
            <value>ASO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Claim_Stop_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Enter_claim_stopcode_Account_Receivables</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Enter_claim_stopcode_in_Bluestar_for_Account_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Claim_Stop_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Clear Tax ID for Producers</fullName>
        <actions>
            <name>Clear_Tax_ID_for_Producers_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>HCSC Employee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Tax_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Clears the Tax ID for Producers where type is HCSC Employee</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Convert Non BlueStar Account From Prospect To Group</fullName>
        <actions>
            <name>Non_BlueStar_Account_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Non_BlueStar_Account_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect (Non BlueSTAR)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Sold</value>
        </criteriaItems>
        <description>This workflow rule will be used to convert record type on Prospect Non BlueStar Accounts to Group Non BlueStar Accounts</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Create Strategic Plan Reminder</fullName>
        <active>true</active>
        <description>Send an email to Account Owners/Executives when an account does not have any associated Strategic Plans and the Active Heath Contracts are at least 500 and the Renewal Date is 4 months away</description>
        <formula>NOT(ISNULL(Renewal_Date__c)) &amp;&amp;  (Active_Health_Subscribers__c  &gt;= 500) &amp;&amp; (Number_of_Active_Strategic_Plans__c = 0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Account_Owner_and_Executives_reminders_to_create_Strategic_Plans</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Renewal_Date__c</offsetFromField>
            <timeLength>-120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Depopulate Claim Stop Date And Reminder</fullName>
        <actions>
            <name>Depopulate_claim_stop_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>When account is re-activated then Claim stop date is null</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Account Members Alert</fullName>
        <actions>
            <name>Alert_AE</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Previous_Members</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT( ISNEW()), ABS( PRIORVALUE( Active_Health_Members__c ) - Active_Health_Members__c ) &gt;= 400)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification for New Prospects</fullName>
        <actions>
            <name>Prospect_Created_for_Cancelled_Account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>BCBS User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <description>Sends Email Notification to Sales Solution Prep Team Public Group when new Prospects are automatically created for Cancelled Accounts</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Health Dental Members Carry Over Workflow</fullName>
        <active>true</active>
        <formula>Health_Dental_Members_Carry_Over_Date__c &gt;= Today()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.Health_Dental_Members_Carry_Over_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Claim Stop Date</fullName>
        <actions>
            <name>Populate_Claim_Stop_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Cancellation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When an account is cancelled , populate Claim stop field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.Claim_Stop_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Prospect Account Name to uppercase</fullName>
        <actions>
            <name>Update_Prospect_Account_to_Uppercase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update prospect account name to uppercase so that Salesforce can send in the account in correct format to Bluestar</description>
        <formula>RecordType.DeveloperName = &apos;Group_Prospect_Account&apos; &amp;&amp; Name &lt;&gt; UPPER(Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prospect Status Update Negotiating opportunity</fullName>
        <actions>
            <name>Set_Status_to_In_Negotiation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Account.No_Of_Non_Negotiating_Open_Opps__c</field>
            <operation>lessThan</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Number_of_Negotiating_Opps__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect (Non BlueSTAR)</value>
        </criteriaItems>
        <description>update the Status field to In Negotiation when the roll up fields for opportunities on account changes.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prospect Status Update Open opportunity</fullName>
        <actions>
            <name>Set_Status_to_Actively_Purchasing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Account.No_Of_Non_Negotiating_Open_Opps__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect (Non BlueSTAR)</value>
        </criteriaItems>
        <description>update the Status field to Activel purchasing when the roll up fields for opportunities on account changes.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Risk Level - 90 Day Queue Risk Change Date Create Task %26 Send Email</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Active_Health_Subscribers__c</field>
            <operation>greaterOrEqual</operation>
            <value>150</value>
        </criteriaItems>
        <description>Risk Level - 90 Day Queue Update Risk Change Date on Account &amp; Send Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X90_Day_Risk_Level_Notification_2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.Risk_Change_Date__c</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SGR Populating Forecast Segment</fullName>
        <actions>
            <name>SGR_Forcast_Segment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populating forecast segment value.</description>
        <formula>OR(
	AND(ISPICKVAL(HCSC_Division__c, &apos;IL&apos;), 
		OR(ISPICKVAL(Market_Segment__c, &apos;HMSG&apos;), ISPICKVAL(Market_Segment__c,&apos;SG&apos;)
		)
	),
	AND(ISPICKVAL(HCSC_Division__c, &apos;MT&apos;), 
		OR(ISPICKVAL(Market_Segment__c, &apos;IMTS&apos;), ISPICKVAL(Market_Segment__c,&apos;MARS&apos;), ISPICKVAL(Market_Segment__c, &apos;MLAS&apos;),
		ISPICKVAL(Market_Segment__c, &apos;SG&apos;),ISPICKVAL(Market_Segment__c, &apos;SMRP&apos;)
		)
	),
	AND(ISPICKVAL( HCSC_Division__c, &apos;NM&apos;), 
		OR(ISPICKVAL(Market_Segment__c, &apos;ALI&apos;), ISPICKVAL(Market_Segment__c,&apos;SGN&apos;)
		)
	),
	AND(ISPICKVAL( HCSC_Division__c, &apos;OK&apos;), 
		OR(ISPICKVAL(Market_Segment__c, &apos;COMA&apos;), ISPICKVAL(Market_Segment__c,&apos;OKCA&apos;), ISPICKVAL(Market_Segment__c, &apos;OKSA&apos;), 
		ISPICKVAL(Market_Segment__c,&apos;SGAR&apos;), ISPICKVAL(Market_Segment__c,&apos;SGTR&apos;), ISPICKVAL(Market_Segment__c,&apos;TULA&apos;)
		)
	),
	AND(ISPICKVAL( HCSC_Division__c, &apos;TX&apos;), 
		OR(ISPICKVAL(Market_Segment__c, &apos;SG&apos;), ISPICKVAL(Market_Segment__c,&apos;TCF&apos;)
		)
	)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>test Update ccount</fullName>
        <active>false</active>
        <formula>Hold_End_Date__c  =  TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Update_Risk_Info_2</fullName>
        <assignedToType>owner</assignedToType>
        <description>All of these three fields &quot;Risk Level, Risk Type, and Risk Reason&quot; should be updated within 90 days so they have the up-to-date information.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Update Risk Info</subject>
    </tasks>
</Workflow>
