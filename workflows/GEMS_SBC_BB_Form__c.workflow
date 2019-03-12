<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Benefit_Booklet_Approval_Notification</fullName>
        <description>Benefit Booklet Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_Benefit_Booklet_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Benefit_Booklet_Rejection_Notification</fullName>
        <description>Benefit Booklet Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_Benefit_Booklet_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Form_Owner_Assigned_Notification</fullName>
        <description>Form Owner Assigned Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_Form_Owner_Assigned_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Request_Form_Reminder_Email_To_SAM_After_30_Days</fullName>
        <description>GEMS Request Form Reminder Email To SAM After 30 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Request_Form/GEMS_Reminder_Email_To_SAM_After_30_Days</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Request_Form_Reminder_Email_To_SAM_After_45_Days</fullName>
        <description>GEMS Request Form Reminder Email To SAM After 45 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Request_Form/GEMS_Reminder_Email_To_SAM_After_45_Days</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Request_Form_Reminder_Email_To_SAM_After_60_Days</fullName>
        <description>GEMS Request Form Reminder Email To SAM After 60 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Request_Form/GEMS_Reminder_Email_To_SAM_After_60_Days</template>
    </alerts>
    <alerts>
        <fullName>Notify_Submitter_on_Benefit_Booklet_Return</fullName>
        <description>Notify Submitter on Benefit Booklet Return</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_Benefit_Booklet_Return_Form</template>
    </alerts>
    <alerts>
        <fullName>Notify_Submitter_on_SBC_Return</fullName>
        <description>Notify Submitter on SBC Return</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_SBC_Return_Form</template>
    </alerts>
    <alerts>
        <fullName>SBC_Approval_Notification</fullName>
        <description>SBC Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_SBC_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>SBC_Rejection_Notification</fullName>
        <description>SBC Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Request_Form/GEMS_SBC_Rejection_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Send_30_Days_Reminder_Mail</fullName>
        <field>Send_Reminder_Mail__c</field>
        <literalValue>Send 30 Days Reminder Mail</literalValue>
        <name>Send 30 Days Reminder Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_45_Days_Reminder_Mail</fullName>
        <field>Send_Reminder_Mail__c</field>
        <literalValue>Send 45 Days Reminder Mail</literalValue>
        <name>Send 45 Days Reminder Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_60_Days_Reminder_Mail</fullName>
        <field>Send_Reminder_Mail__c</field>
        <literalValue>Send 60 Days Reminder Mail</literalValue>
        <name>Send 60 Days Reminder Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Approval_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Set Approval Status to Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Recall</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Recall</literalValue>
        <name>Set Approval Status to Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_Approved</fullName>
        <field>Form_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_In_Progress</fullName>
        <field>Form_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Set status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_Internal_Approval_Pending</fullName>
        <field>Form_Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Set status to Internal Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_Internal_Approval_Rejected</fullName>
        <field>Form_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Set status to Internal Approval Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_Revision_Requested</fullName>
        <field>Form_Status__c</field>
        <literalValue>Revision Requested</literalValue>
        <name>Set status to Revision Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Do_Not_Send_Reminder_Email</fullName>
        <field>Send_Do_Not_Send_Reminder_Mail__c</field>
        <literalValue>No</literalValue>
        <name>Update Do Not Send Reminder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Reminder_Email</fullName>
        <field>Send_Do_Not_Send_Reminder_Mail__c</field>
        <literalValue>Yes</literalValue>
        <name>Update Send Reminder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>GEMS Request Form Send Reminder Mail To SAM User</fullName>
        <active>true</active>
        <criteriaItems>
            <field>GEMS_SBC_BB_Form__c.Send_Do_Not_Send_Reminder_Mail__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>GEMS_SBC_BB_Form__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>GEMS BB Form</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Request_Form_Reminder_Email_To_SAM_After_45_Days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Send_45_Days_Reminder_Mail</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Request_Form_Reminder_Email_To_SAM_After_60_Days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Send_60_Days_Reminder_Mail</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Request_Form_Reminder_Email_To_SAM_After_30_Days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Send_30_Days_Reminder_Mail</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
