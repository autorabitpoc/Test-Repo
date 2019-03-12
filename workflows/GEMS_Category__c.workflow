<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Category_Cancel_Date_field_update</fullName>
        <field>Cancellation_Date__c</field>
        <formula>Requested_Cancellation_Date__c</formula>
        <name>Category Cancel Date  field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMSCatFieldUpdate</fullName>
        <field>UniqueCatCombo__c</field>
        <formula>casesafeid(Case__c) + Name</formula>
        <name>GEMSCatFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GEMSCatDupCheckRule</fullName>
        <actions>
            <name>GEMSCatFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL(CreatedDate))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Category Cancel date</fullName>
        <actions>
            <name>Category_Cancel_Date_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GEMS_Category__c.Cancellation_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>GEMS_Category__c.Requested_Cancellation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
