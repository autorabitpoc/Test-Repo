<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GEMS_CustomIDCardReSubmitEmailAlert</fullName>
        <description>GEMS_CustomIDCardReSubmitEmailAlert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Specialist_Email_ID__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_CustomIDCardResubmitEmailTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>GEMS_Reset_Re_submitted_field</fullName>
        <field>Re_Submitted__c</field>
        <name>GEMS Reset Re-submitted field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GEMS_CustomIDCardReSubmitEmailAlertFlow</fullName>
        <actions>
            <name>GEMS_CustomIDCardReSubmitEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Triggers an email when Custom ID form is re-submitted.</description>
        <formula>AND   (Re_Submitted__c = &apos;Re-Submitted&apos;,    ISCHANGED( LastModifiedDate )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GEMS_Reset_Re_Submitted_Field</fullName>
        <active>false</active>
        <criteriaItems>
            <field>GEMS_Custom_ID_Request_Form__c.Re_Submitted__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GEMS_Reset_Re_submitted_field</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>GEMS_Custom_ID_Request_Form__c.Reset_Re_Submitted_Field__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
