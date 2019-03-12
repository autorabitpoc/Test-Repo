<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>GS_Update_Cancel_Date_with_Req_Can_Date</fullName>
        <field>Cancellation_Date__c</field>
        <formula>Requested_Cancellation_Date__c</formula>
        <name>GS Update Cancel Date with Req Can Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Cancel Date for GrpSec</fullName>
        <actions>
            <name>GS_Update_Cancel_Date_with_Req_Can_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GEMS_Group_Section__c.Cancellation_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>GEMS_Group_Section__c.Requested_Cancellation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
