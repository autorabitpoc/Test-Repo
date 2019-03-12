<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Move_the_Initial_To_address_of_Email</fullName>
        <description>To move the initial email address of the email-to-case email</description>
        <field>Initial_Email_To_Address__c</field>
        <formula>IF(ISBLANK(Parent.Initial_Email_To_Address__c),ToAddress +  CcAddress +  BccAddress ,Parent.Initial_Email_To_Address__c)</formula>
        <name>Move the Initial To address of Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Move the Initial To address of Email</fullName>
        <actions>
            <name>Move_the_Initial_To_address_of_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Move the Initial To address of Email</description>
        <formula>ISBLANK(Parent.Initial_Email_To_Address__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
