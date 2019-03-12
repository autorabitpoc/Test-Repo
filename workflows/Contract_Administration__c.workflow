<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateDateSubmittedForLegalReview</fullName>
        <description>Changes Date Submitted For Legal Review to &apos;Now&apos;</description>
        <field>Date_Submitted_For_Legal_Review__c</field>
        <formula>NOW()</formula>
        <name>UpdateDateSubmittedForLegalReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatePlanPresidentApprovalDate</fullName>
        <description>Changes Plan President Approval Date to &apos;Now&apos;</description>
        <field>Plan_President_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>UpdatePlanPresidentApprovalDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
