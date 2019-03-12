<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Stage_to_Started</fullName>
        <description>Update Stage to Started</description>
        <field>Started__c</field>
        <literalValue>1</literalValue>
        <name>Update Stage to Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Stage_Mapping__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Set Stage as started when Substage starts</fullName>
        <actions>
            <name>Update_Stage_to_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Substage_Mapping1__c.Started__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update the stage picklist to started.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
