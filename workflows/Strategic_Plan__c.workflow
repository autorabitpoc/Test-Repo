<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Strategic_Plan_Update_Needed</fullName>
        <description>Strategic Plan Update Needed</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Strategic_Plan/ACCOUNTStrategicPlanNeedsUpdating</template>
    </alerts>
    <alerts>
        <fullName>Strategic_Plan_Update_Needed180</fullName>
        <description>Strategic Plan Update Needed</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Strategic_Plan/ACCOUNTStrategicPlanNeedsUpdating</template>
    </alerts>
    <alerts>
        <fullName>Test_Alert_on_1_day</fullName>
        <description>Test Alert on 1 day</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Strategic_Plan/ACCOUNTStrategicPlanNeedsUpdating</template>
    </alerts>
    <fieldUpdates>
        <fullName>Activate_Strategic_Plan</fullName>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Activate Strategic Plan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deactivate_Strategic_Plan</fullName>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Deactivate Strategic Plan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Approved_Date</fullName>
        <description>Populate the approved date field.</description>
        <field>Date_Approved__c</field>
        <formula>Today()</formula>
        <name>Populate Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Plan %27Active%27 if future Renewal Date</fullName>
        <actions>
            <name>Activate_Strategic_Plan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Strategic_Plan__c.Effective_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>A Strategic Plan should be marked as &apos;Active&apos; is the plan&apos;s Renewal Date is in the future</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_Strategic_Plan</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Strategic_Plan__c.Effective_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Date Approved</fullName>
        <actions>
            <name>Populate_Approved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Strategic_Plan__c.Manager_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule populates the date a strategic plan was approved by the manager.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Six month Strategic Plan Update Notification</fullName>
        <active>true</active>
        <description>Notifies the account owner if the strategic plan has not been updated in 6 months.</description>
        <formula>AND((Datevalue(LastModifiedDate) + 180) &lt; Effective_Date__c, Effective_Date__c &gt;= TODAY(), Active__c = True,  OR ( Account_Name__r.Active_Health_Subscribers__c &gt;= 10000,  Account_Name__r.Projected_Health_Contracts__c &gt;= 10000 ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Strategic_Plan_Update_Needed180</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Strategic_Plan__c.LastModifiedDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Strategic_Plan__c.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Strategic_Plan_Client_Meeting</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please create Strategic Plan Client meeting</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Strategic_Plan__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Strategic Plan Client Meeting</subject>
    </tasks>
</Workflow>
