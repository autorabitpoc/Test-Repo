<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Email_Address_of_Contact</fullName>
        <description>To update the Contacts email address based on the associated Accounts email address</description>
        <field>Email</field>
        <formula>Account.Email__c</formula>
        <name>Update Email Address of Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Email Address of Contact %28If associated Account is Sub Producer%29</fullName>
        <actions>
            <name>Update_Email_Address_of_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Sub Producer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Email Address of Contact (If associated Account is Sub Producer and Email address is BLANK)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
