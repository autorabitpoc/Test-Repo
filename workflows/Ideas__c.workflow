<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Idea_Managers_Alert</fullName>
        <description>Email Idea Managers If a New Idea is Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>kathleen_cox@bcbstx.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>liraa@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Idea/Email_Idea_Managers_Template</template>
    </alerts>
    <alerts>
        <fullName>Status_Changed_Send_Email_To_Idea_Owner</fullName>
        <description>If the Status of the Idea changes send email to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Idea/Idea_Alert_User_of_Status_Change</template>
    </alerts>
    <rules>
        <fullName>Alert User of Idea Status Change</fullName>
        <actions>
            <name>Status_Changed_Send_Email_To_Idea_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Idea Managers</fullName>
        <actions>
            <name>Email_Idea_Managers_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Ideas__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
