<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GEMS_Underwriting_Task_Re_review_Notification</fullName>
        <description>GEMS Underwriting Task Re review Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>GEMS_Account_Submission_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Underwriting_Task_Re_review_Notification</template>
    </alerts>
    <alerts>
        <fullName>GEMS_Underwriting_Task_Return_Notification</fullName>
        <description>GEMS Underwriting Task Return Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>GEMS_Account_Submission_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Underwriting_Task_Return_Notification</template>
    </alerts>
    <alerts>
        <fullName>Important_Reminder_Strategic_Plans_for_Your_Renewing_Accounts_are_Due_Soon</fullName>
        <ccEmails>liraa@bcbsil.com</ccEmails>
        <description>Important Reminder -- Strategic Plans for Your Renewing Accounts are Due Soon!</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_Closed_Date_as_today</fullName>
        <field>Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>Populate Closed Date as today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Task_Closed_Date</fullName>
        <description>Update the Task Closed Date with the current date.</description>
        <field>Task_Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Task Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Task_Type</fullName>
        <description>Update on task type custom field. This is needed for reporting purposes.</description>
        <field>Activity_Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Update Task Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Important Reminder -- Strategic Plans for Your Renewing Accounts are Due Soon%21</fullName>
        <actions>
            <name>Create_Strategic_Plan</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>lessOrEqual</operation>
            <value>NEXT 30 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.IsReminderSet</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Important_Reminder_Strategic_Plans_for_Your_Renewing_Accounts_are_Due_Soon</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Closed Date</fullName>
        <actions>
            <name>Populate_Closed_Date_as_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>CSS Task Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>CSS Task Record Type</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Task Type</fullName>
        <actions>
            <name>Update_Task_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow rule to update the task type custom field on the Task record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Closed Date Population</fullName>
        <actions>
            <name>Update_Task_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Auto-population of the Task Closed Date field.</description>
        <formula>AND(RecordType.Name = &quot;CSS Task Record Type&quot;, ISPICKVAL(Status, &quot;Completed&quot;), ISBLANK(Task_Closed_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Create_Strategic_Plan</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.ActivityDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Create Strategic Plan</subject>
    </tasks>
    <tasks>
        <fullName>Important_Reminder</fullName>
        <assignedToType>owner</assignedToType>
        <description>It&apos;s now time to create your strategic plan! The 2016 Know Our Customer - Ease of Doing Business goal requires creation / approval of a strategic plan for all renewing ASO / Fully Insured 500+ accounts three months prior to the effective date.</description>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.ActivityDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Important Reminder</subject>
    </tasks>
</Workflow>
