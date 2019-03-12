<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Event_Type</fullName>
        <description>Update on task type custom field. This is needed for reporting purposes.</description>
        <field>Activity_Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Update Event Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Event Type</fullName>
        <actions>
            <name>Update_Event_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow rule to update the task type custom field on the Event record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
