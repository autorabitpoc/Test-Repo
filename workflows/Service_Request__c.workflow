<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GFRA_Adjustment_Request_Ownership_Notification</fullName>
        <description>GFRA - Adjustment Request Ownership Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Email_Templates/GFRA_Adjustment_Request_Ownership_Notification</template>
    </alerts>
    <alerts>
        <fullName>SR_DateofMeetingChanged</fullName>
        <description>SR - Send Email when Date of Meeting changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Service_Request_Enrollment_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Request/SR_DateOfMeetingChanged</template>
    </alerts>
    <alerts>
        <fullName>SR_Send_Email_when_Enrollment_Specialist_Assigned</fullName>
        <description>SR - Send Email when Enrollment Specialist Assigned</description>
        <protected>false</protected>
        <recipients>
            <recipient>Service_Request_Enrollment_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Account_Executive__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Alternative_Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Request/SR_Enrollment_Specialist_Assigned</template>
    </alerts>
    <alerts>
        <fullName>SR_Send_Email_when_upcoming_event_is_Not_Staffed</fullName>
        <description>SR - Send Email when upcoming event is Not Staffed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Service_Request_Enrollment_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Service_Request/SR_Enrollment_Unstaffed_Events</template>
    </alerts>
    <alerts>
        <fullName>SR_Stage_Equals_Submitted</fullName>
        <description>SR - Send Email when Request Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Marketing_Service_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>Service_Request_Enrollment_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Request/SR_StageEqualsSubmitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>GFRA_Final_Approval_Stage</fullName>
        <field>Stage__c</field>
        <literalValue>Completed</literalValue>
        <name>GFRA Final Approval Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Final_Approver_Name</fullName>
        <description>Added as part of SFDC-7243</description>
        <field>Final_Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot; + $User.LastName</formula>
        <name>GFRA Final Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Pending_with_Accountant</fullName>
        <description>GFRA Approval process, Stage field on Service Request Object should change to Pending with Accountant once request request approved by Owner.</description>
        <field>Stage__c</field>
        <literalValue>Pending with Accountant/Manager</literalValue>
        <name>GFRA Pending with Accountant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Pending_with_Director</fullName>
        <description>GFRA Approval process, Stage field on Service Request Object should change to Pending with Director once request approved by Manager.</description>
        <field>Stage__c</field>
        <literalValue>Pending with Director</literalValue>
        <name>GFRA Pending with Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Pending_with_SLT</fullName>
        <field>Stage__c</field>
        <literalValue>Pending with SLT</literalValue>
        <name>GFRA Pending with SLT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Pending_with_SVP</fullName>
        <description>GFRA Approval process, Stage field on Service Request Object should change to Pending with SVP once request approved by Director.</description>
        <field>Stage__c</field>
        <literalValue>Pending with SVP</literalValue>
        <name>GFRA Pending with SVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Request_Approved</fullName>
        <description>Status field on Service Request record will be updated once record is approved.</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>GFRA Request Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GFRA_Request_Rejected</fullName>
        <description>Status field on Service Request record will be updated once record is Rejected.</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>GFRA Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GRFA_Request_in_Approval_Process</fullName>
        <description>Status field update on Service Request  object once record initiated for Approval Process.</description>
        <field>Status__c</field>
        <literalValue>In Process</literalValue>
        <name>GRFA Request in Approval Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>History_Tracking_Approved</fullName>
        <description>Added as part of SFDC-7243</description>
        <field>History_Tracking__c</field>
        <literalValue>Approved</literalValue>
        <name>History Tracking Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>History_Tracking_Pending</fullName>
        <description>Added as part of SFDC-7243</description>
        <field>History_Tracking__c</field>
        <literalValue>Pending</literalValue>
        <name>History Tracking Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>History_Tracking_Rejected</fullName>
        <description>Added as part of SFDC-7243</description>
        <field>History_Tracking__c</field>
        <literalValue>Rejected</literalValue>
        <name>History Tracking Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Open_Enrollment_update_Stage_to_New</fullName>
        <field>Stage__c</field>
        <literalValue>New</literalValue>
        <name>Open Enrollment update Stage to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Modified_Meeting_Date</fullName>
        <description>Updates the Last Modified Meeting Date field with the current date when the Date of Meeting field is changed.</description>
        <field>Last_Modified_Meeting_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Last Modified Meeting Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GFRA - Adjustment Request Ownership Notification</fullName>
        <actions>
            <name>GFRA_Adjustment_Request_Ownership_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(OwnerId),  ISNEW() ) &amp;&amp; RecordType.DeveloperName = &apos;GFRA_Adjustment&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Open Enrollment - Default Stage is New</fullName>
        <actions>
            <name>Open_Enrollment_update_Stage_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Open Enrollment</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SR - Date of Meeting Changed</fullName>
        <actions>
            <name>SR_DateofMeetingChanged</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Mktg Hub: Open Enrollment Automated Notification - &quot;Change of Date/Time&quot;</description>
        <formula>if((ISCHANGED( Date_of_Meeting__c ) || ISCHANGED( Start_Time__c )) &amp;&amp;  RecordType.Name==&apos;Open Enrollment&apos;,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SR - Request Submitted</fullName>
        <actions>
            <name>SR_Stage_Equals_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Open Enrollment</value>
        </criteriaItems>
        <description>Mktg Hub: Open Enrollment Automated Notification - &quot;Request Submitted&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Modified Meeting Date</fullName>
        <actions>
            <name>Update_Last_Modified_Meeting_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Last Modified Meeting Date field when the value of the Date of Meeting filed is changed.</description>
        <formula>OR(ISNEW(),ISCHANGED(Date_of_Meeting__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
