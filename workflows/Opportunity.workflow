<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Opportunity_Owner</fullName>
        <description>Email Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Notification_for_Autocreated_Renewals</template>
    </alerts>
    <alerts>
        <fullName>Email_Won_New_Opp</fullName>
        <description>Email contract administrators when new opportunities are won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Contract_Administration</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Custom_Contract/Email_Contract_Administrator_for_Won_New_Opportunities</template>
    </alerts>
    <alerts>
        <fullName>Email_Won_Renewed_Opp</fullName>
        <description>Email contract administrators when renewed opportunities are won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Contract_Administration</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Custom_Contract/Email_Contract_Administrator_for_Won_Renewal_Opportunities</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Underwriter_when_Opportunity_moves_to_Renewal_Initiated</fullName>
        <description>Send Email to Underwriter when Opportunity moves to Renewal Initiated</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Template/Notify_Underwriter_of_Renewal_Initiated_Opportunity</template>
    </alerts>
    <fieldUpdates>
        <fullName>Add_Renewal_Date</fullName>
        <field>Renewal_Date__c</field>
        <formula>IF(ISBLANK(Account.Renewal_Date__c) , CloseDate , Account.Renewal_Date__c)</formula>
        <name>Add Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Audit_Assigned_Operations</fullName>
        <field>Audit_Assigned_Operations__c</field>
        <formula>PRIORVALUE ( Assigned_Operations__c )</formula>
        <name>Audit Assigned Operations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Closed</fullName>
        <description>Automatically closed the date closed field</description>
        <field>Date_Closed__c</field>
        <formula>TODAY()</formula>
        <name>Date Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Rating_Status</fullName>
        <field>Rating_Status__c</field>
        <literalValue>Initiated</literalValue>
        <name>Initial Rating Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Work_flow_Status</fullName>
        <field>SGR_Workflow_Status__c</field>
        <name>Initial Work flow Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Rating_Status</fullName>
        <field>SGR_Workflow_Activity__c</field>
        <literalValue>Pend in Progress</literalValue>
        <name>Opportunity Rating Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Rating_Status_Underwriting</fullName>
        <field>Rating_Status__c</field>
        <literalValue>Underwriting-Released</literalValue>
        <name>Opportunity_Rating_Status_Underwriting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Rating_status_Update</fullName>
        <field>Rating_Status__c</field>
        <literalValue>Actuarial-Released</literalValue>
        <name>Opportunity Rating status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Days_to_Release</fullName>
        <description>Populates the Days to Release field on Opportunity</description>
        <field>Days_to_Release__c</field>
        <formula>Account_Setup_Screening_Creation__c - Client_Approval_Received_Date__c</formula>
        <name>Populate Days to Release</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Days_to_Structure_Approval</fullName>
        <description>Populates the Days to Structure Approval field on Opportunity.</description>
        <field>Days_to_Structure_Approval__c</field>
        <formula>Client_Approval_Received_Date__c - Account_Structure_Case_Creation__c</formula>
        <name>Populate Days to Structure Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Days_to_Structure_Case</fullName>
        <description>Populates the Days to Structure Case field on Opportunity</description>
        <field>Days_to_Structure_Case__c</field>
        <formula>Account_Structure_Case_Creation__c - Date_Closed__c</formula>
        <name>Populate Days to Structure Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Weekly_Activity_Added</fullName>
        <field>Weekly_Activity_Added_Date__c</field>
        <formula>TODAY()</formula>
        <name>Populate Weekly Activity Added</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Weekly_Activity_Modified_Date</fullName>
        <field>Weekly_Activity_Modified_Date__c</field>
        <formula>TODAY()</formula>
        <name>Populate Weekly Activity Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Notification_time</fullName>
        <field>RFP_Notification_Time__c</field>
        <formula>&apos;90-Days-Before&apos;</formula>
        <name>RFP Notification time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Notification_time_after_30_days</fullName>
        <field>RFP_Notification_Time__c</field>
        <formula>&apos;30-Days-after&apos;</formula>
        <name>RFP Notification time after 30 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Notification_time_after_7_days</fullName>
        <field>RFP_Notification_Time__c</field>
        <formula>&apos;7-Days-after&apos;</formula>
        <name>RFP Notification time after 7 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Notification_time_before_30_days</fullName>
        <field>RFP_Notification_Time__c</field>
        <formula>&apos;30-Days-Before&apos;</formula>
        <name>RFP Notification time before 30 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Notification_time_before_7_days</fullName>
        <field>RFP_Notification_Time__c</field>
        <formula>&apos;7-Days-Before&apos;</formula>
        <name>RFP Notification time before 7 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGRWorkflowStatus</fullName>
        <field>SGR_Workflow_Status__c</field>
        <literalValue>Rated</literalValue>
        <name>SGRWorkflowStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Set_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>SGR_Renewal_Account_Name__c &amp; &quot;-&quot; &amp; TEXT(Renewal_Date__c) &amp; &quot;-&quot; &amp; 
SGR_Opportunity_Type__c</formula>
        <name>SGR Set_Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Workflow_System_Status_for_Rated</fullName>
        <description>Update value for Workflow System Status when rating status is rated</description>
        <field>Workflow_System_Status__c</field>
        <literalValue>Ready For Gate Processing</literalValue>
        <name>SGR Workflow System Status for Rated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Workflow_System_Status_for_UW_Hold</fullName>
        <description>update Workflow System Status to &quot;Awating hold task confirmation&quot;when opportunity workflow activity became Underwriter Hold</description>
        <field>Workflow_System_Status__c</field>
        <literalValue>Awaiting Hold Task Completion</literalValue>
        <name>SGR Workflow System Status for UW Hold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Workflow_System_Status_ready_B_eng</fullName>
        <description>update Workflow System Status to &quot;Ready to send B-engage&quot; when rating status of production opportunity set to underwriter release.</description>
        <field>Workflow_System_Status__c</field>
        <literalValue>Ready to Send to B-Engaged</literalValue>
        <name>SGR Workflow System Status ready B eng</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_ratingstatus_update</fullName>
        <field>Rating_Status__c</field>
        <literalValue>Marketing Release</literalValue>
        <name>SGR_ratingstatus_update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_BD_Counter_to_0</fullName>
        <field>Private_Exchange_Blue_Directions_Count__c</field>
        <formula>0</formula>
        <name>Set BD Counter to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exchange_Offering_Type_to_BD</fullName>
        <field>Exchange_Offering_Type__c</field>
        <literalValue>Private Exchange - Blue Directions</literalValue>
        <name>Set Exchange Offering Type to BD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exchange_Offering_Type_to_External</fullName>
        <field>Exchange_Offering_Type__c</field>
        <literalValue>Private Exchange - External</literalValue>
        <name>Set Exchange Offering Type to External</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exchange_Offering_Type_to_both</fullName>
        <field>Exchange_Offering_Type__c</field>
        <literalValue>Private Exchange - Blue Directions and External</literalValue>
        <name>Set Exchange Offering Type to both</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Ext_Counter_to_0</fullName>
        <field>Private_Exchange_External_Count__c</field>
        <formula>0</formula>
        <name>Set Ext Counter to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEST2</fullName>
        <field>RecordTypeId</field>
        <lookupValue>sgr_test_analy_opp</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>TEST2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Bypass_Validation</fullName>
        <field>Bypass_Validation__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Bypass Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AdjustAndNgotiate</fullName>
        <field>Status__c</field>
        <literalValue>Negotiate</literalValue>
        <name>Update_AdjustAndNgotiate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_UW</fullName>
        <field>Status__c</field>
        <literalValue>In Underwriting</literalValue>
        <name>Update_In UW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SGR_Renewal_Account_Name_c_NFU</fullName>
        <field>SGR_Renewal_Account_Name__c</field>
        <formula>Account.Name</formula>
        <name>Update SGR_Renewal_Account_Name__c NFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Workflow_activity</fullName>
        <description>set value of workflow activity to &quot;Acturail gate&quot;</description>
        <field>SGR_Workflow_Activity__c</field>
        <literalValue>Actuarial Gate</literalValue>
        <name>Update Workflow activity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_type</fullName>
        <field>Opportunity_Type_Copy__c</field>
        <formula>SGR_Opportunity_Type__c</formula>
        <name>Update_type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updt_AccountHoldStatusCopy</fullName>
        <field>Account_Hold_Status_Copy__c</field>
        <formula>sgrAccountHoldReason__c</formula>
        <name>Updt_AccountHoldStatusCopy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workflow_Activity_Update_To_UW_Hold</fullName>
        <field>SGR_Workflow_Activity__c</field>
        <literalValue>Underwriting Hold</literalValue>
        <name>Workflow_Activity_Update_To_UW Hold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workflow_Activity_to_Blank</fullName>
        <field>SGR_Workflow_Activity__c</field>
        <name>Workflow Activity_to_Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workflow_System_Status_to_ready_for_b_en</fullName>
        <description>update production opportunity Workflow System Status to Ready to Send to B-Engaged</description>
        <field>Workflow_System_Status__c</field>
        <literalValue>Ready to Send to B-Engaged</literalValue>
        <name>Workflow System Status to ready for b en</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_workflow_activity_prod_opty</fullName>
        <description>update production opportunity workflow activity field to Ready for Distribution</description>
        <field>SGR_Workflow_Activity__c</field>
        <name>update workflow activity prod opty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Audit Assigned Operations</fullName>
        <actions>
            <name>Audit_Assigned_Operations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Assigned_Operations__C is edited; update Audit_Assigned_Operations__c with new value; this field will be used for history tracking the assigned operations user</description>
        <formula>ISCHANGED( Assigned_Operations__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check Opportunity Moves To Renewal Initiated</fullName>
        <actions>
            <name>Send_Email_to_Underwriter_when_Opportunity_moves_to_Renewal_Initiated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Renewal Initiated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check if Opp has Priv Ex Blue Directions Case and No External Case</fullName>
        <actions>
            <name>Set_Exchange_Offering_Type_to_BD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Private_Exchange_Blue_Directions_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Private_Exchange_External_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check if Opp has Priv Ex External Case and No Blue Directions Case</fullName>
        <actions>
            <name>Set_Exchange_Offering_Type_to_External</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Private_Exchange_Blue_Directions_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Private_Exchange_External_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check if Opp has both Priv Ex Blue Directions and External Cases</fullName>
        <actions>
            <name>Set_Exchange_Offering_Type_to_both</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Private_Exchange_Blue_Directions_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Private_Exchange_External_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Contract Admin for Won New Opportunity</fullName>
        <actions>
            <name>Email_Won_New_Opp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to Contract Admins when Opportunity is New, Won, and RFP</description>
        <formula>(RecordType.DeveloperName = &apos;New_Sale&apos;) &amp;&amp; (TEXT(StageName) = &apos;Won&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Contract Admin for Won Renewed Opportunity</fullName>
        <actions>
            <name>Email_Won_Renewed_Opp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to Contract Admins when Opportunity is Renewal, Won, and RFP</description>
        <formula>(RecordType.DeveloperName = &apos;Renewal&apos;) &amp;&amp; (TEXT(Type) = &apos;RFP&apos;) &amp;&amp; (TEXT(StageName) = &apos;Won&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification for Autocreated Renewals</fullName>
        <actions>
            <name>Email_Opportunity_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsAutoCreated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>A renewal is auto-created and the renewal opportunity owner receives a notification that the renewal was created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LGNA_Automatic Date Closed</fullName>
        <actions>
            <name>Date_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Won,Lost,Declined</value>
        </criteriaItems>
        <description>when Opportunity stage is closed, date closed field also closed automatically</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification On Chatter</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Expected_RFP_Release_Date__c</field>
            <operation>greaterThan</operation>
            <value>6/7/1990</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration Profile</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RFP_Notification_time_before_30_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Expected_RFP_Release_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RFP_Notification_time</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Expected_RFP_Release_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RFP_Notification_time_before_7_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Expected_RFP_Release_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RFP_Notification_time_after_30_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Expected_RFP_Release_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RFP_Notification_time_after_7_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Expected_RFP_Release_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opp Days to Release</fullName>
        <actions>
            <name>Populate_Days_to_Release</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule triggers the calculation of the Days to Release field on Opportunity.</description>
        <formula>ISCHANGED(Client_Approval_Received_Date__c) || ISCHANGED(Account_Setup_Screening_Creation__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Days to Structure Approval</fullName>
        <actions>
            <name>Populate_Days_to_Structure_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule triggers the calculation of the Days to Structure Approval field on Opportunity.</description>
        <formula>ISCHANGED(Account_Structure_Case_Creation__c) || ISCHANGED(Client_Approval_Received_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Days to Structure Case</fullName>
        <actions>
            <name>Populate_Days_to_Structure_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule triggers the calculation of the Days to Structure Case field on Opportunity.</description>
        <formula>ISCHANGED(Account_Structure_Case_Creation__c) ||  ISCHANGED(Date_Closed__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity workflow activity Acturial gate</fullName>
        <actions>
            <name>SGR_Workflow_System_Status_for_Rated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Workflow_activity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Rating_Status__c</field>
            <operation>equals</operation>
            <value>Rated</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Renewal Date</fullName>
        <actions>
            <name>Add_Renewal_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Renewal_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <description>Populate Renewal_Date__c from Account Renewal_Date__c</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Status field based on Stage</fullName>
        <actions>
            <name>Update_In_UW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Status field based on Stage_ AdjustNegotiate</fullName>
        <actions>
            <name>Update_AdjustAndNgotiate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Adjust and Negotiate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Production_Opportunity_UW_Hold</fullName>
        <actions>
            <name>SGR_Workflow_System_Status_for_UW_Hold</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Workflow_Activity_Update_To_UW_Hold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.DeveloperName = &apos;SGR_Production_Opportunity&apos; , ISPICKVAL( Rating_Status__c , &apos;Actuarial-Released&apos;) ,OR(Account.Renewal_Date__c  &lt;=  Account.Hold_End_Date__c ,Account.renewal_duration_is_infinite__c = true ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Production_Opportunity_Underwriting_Released</fullName>
        <actions>
            <name>Opportunity_Rating_Status_Underwriting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SGR_Workflow_System_Status_ready_B_eng</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Workflow_Activity_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( RecordType.DeveloperName = &apos;SGR_Production_Opportunity&apos; , ISPICKVAL( Rating_Status__c , &apos;Actuarial-Released&apos;),Account.Renewal_Date__c &gt; Account.Hold_End_Date__c,Account.renewal_duration_is_infinite__c = false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR Set Rating Status to Initiated Upon Creation</fullName>
        <actions>
            <name>Initial_Rating_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SGR Production Opportunity,SGR Analytical Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SGR Set Work flow Status to Blank Upon Creation</fullName>
        <actions>
            <name>Initial_Work_flow_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SGR Production Opportunity,SGR Analytical Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Rating_Status__c</field>
            <operation>equals</operation>
            <value>Initiated</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SGRWorkflowStatus</fullName>
        <actions>
            <name>SGRWorkflowStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL( Gate__r.Status__c , &quot; Down&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR_Set_Opportunity_Name</fullName>
        <actions>
            <name>SGR_Set_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set name for SGR Opportunity records based on Account Name, Effective Date &amp; Renewal Type</description>
        <formula>AND(
  CONTAINS(RecordType.DeveloperName ,&apos;SGR&apos;),
  OR(
     ISNEW(),
     ISCHANGED( SGR_Opportunity_Type__c ),
     ISCHANGED( SGR_Renewal_Account_Name__c ),
     ISCHANGED( Renewal_Date__c )
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR_Update_SGR_Renewal_Account_Name</fullName>
        <actions>
            <name>Update_SGR_Renewal_Account_Name_c_NFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SGR Production Opportunity,SGR Analytical Opportunity</value>
        </criteriaItems>
        <description>WR to update SGR_Renewal_Account_Name__c	field on Opportunity taken from Account during opportunity creation (SFDC-12)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SGR_accholdreason_copy_opdt</fullName>
        <actions>
            <name>Updt_AccountHoldStatusCopy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(sgrAccountHoldReason__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR_opp_update</fullName>
        <actions>
            <name>SGR_ratingstatus_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Workflow_System_Status_to_ready_for_b_en</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_workflow_activity_prod_opty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Account_Market_Segment__c</field>
            <operation>equals</operation>
            <value>SG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SGR_Opportunity_Type__c</field>
            <operation>equals</operation>
            <value>Production</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Rating_Status__c</field>
            <operation>equals</operation>
            <value>Underwriting-Released</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SGR_update_type</fullName>
        <actions>
            <name>Update_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Forecast_Segment__c</field>
            <operation>equals</operation>
            <value>Small Group</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SGR_Opportunity_Type__c</field>
            <operation>equals</operation>
            <value>Production</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SGR_Opportunity_Type__c</field>
            <operation>equals</operation>
            <value>Analytical</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opp PE Counters to 0 on Creation</fullName>
        <actions>
            <name>Set_BD_Counter_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Ext_Counter_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISNULL(CreatedById))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Special Eligibility For Rating Status Change</fullName>
        <actions>
            <name>Opportunity_Rating_status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Special_Eligibility__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Turn off Bypass Validation Opp</fullName>
        <actions>
            <name>Uncheck_Bypass_Validation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Bypass_Validation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Weekly Activity Added Date</fullName>
        <actions>
            <name>Populate_Weekly_Activity_Added</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Weekly_Activity_Added_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Weekly_Activity_Report__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Lan_ID__c</field>
            <operation>notEqual</operation>
            <value>456</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Weekly Activity Modified</fullName>
        <actions>
            <name>Populate_Weekly_Activity_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED( Initial_Comments__c ),  ISCHANGED( Description ), AND(ISCHANGED( StageName ),  OR(ISPICKVAL(StageName, &apos;Closed Won&apos;),ISPICKVAL(StageName, &apos;Closed Lost&apos;),ISPICKVAL(StageName, &apos;Won&apos;),ISPICKVAL(StageName, &apos;Lost&apos;), ISPICKVAL(StageName, &apos;Declined&apos;), ISPICKVAL(StageName, &apos;No Further Action&apos;))) , ISCHANGED( Primary_Closed_Reason__c ), ISCHANGED( Closed_Comments__c ), ISCHANGED( Requested_Effective_Date__c ), ISCHANGED( Expected_Dental_Members__c ), ISCHANGED( Expected_Health_Members__c ), ISCHANGED( Projected_Membership_Gain_Loss__c )),  $User.Lan_ID__c != &apos;456&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
